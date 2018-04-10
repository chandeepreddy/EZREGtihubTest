/**
* @author           Aarthy
* @version          1.0 
* @date             27-DEC-2017
* @Status           Developed
* @ModifiedBy       Anil
* @description      This trigger fires before update on account,to send kick off mail and welcome aboard email. 
*
*/

trigger IntroductionAndKickoffEmailTrigger on Account (before update) 
{   
             Set<Id> PrimarycontactIds = new Set<Id>();     
             Set<Id> accountOwnerIdSet=new Set<Id>();
             Set<Id> CSMSet=new Set<Id>();
             List<Account> acctsToSendEmail = new List<Account>();
             Map<String,OrgWideEmailAddress> Org_wideaddress=new Map<String,OrgWideEmailAddress>();

             OrgWideEmailAddress[] list_Orgwideaddress= [select Id, address from OrgWideEmailAddress];
             for(OrgWideEmailAddress owa: list_Orgwideaddress){
                     if(!Org_wideaddress.containsKey(owa.address))
                     {
                             Org_wideaddress.put(owa.address,owa);
                     }       
             }
             system.debug('Org_wideaddress=========='+Org_wideaddress);
             /* Trigger will fires only if customer engagement type is "ODS" and SOW is "Fully-Executed" and Account_Status is "Customer" or "Active Customer" */
             if(trigger.isBefore && trigger.isUpdate)
             {
                if(isRecursiveAccountTrigger.runOnce()){
                    for(Account acc: trigger.new){
                             if(acc.Customer_Engagement_Type__c == 'ODS' && acc.SOW__c == 'Fully Executed' && (acc.Account_Status__c == 'Customer' || acc.Account_Status__c == 'Active Customer' ) ){
                                       acctsToSendEmail.add(acc);  
                                       accountOwnerIdSet.add(acc.ownerId);
                                       CSMSet.add(acc.user__c);
                                       if(acc.Primary_Customer_Contact__c != Null)
                                       {
                                             PrimarycontactIds.add(acc.Primary_Customer_Contact__c); 
                                       }               
                             }        
                    }
        
                    Map<Id,user> ownerEmailMap=new Map<id,user>([Select id,email from user where id IN:accountOwnerIdSet]);
                    Map<Id,user> CSMMap=new Map<id,user>([Select id,email from user where id IN:CSMSet]);
    
                    Map<Id,Contact> PrimarycontactsMap = new Map<Id,Contact>([Select Id,Name,Email from contact where Id = : PrimarycontactIds]);
                    system.debug('PrimarycontactsMap' +PrimarycontactsMap);
                    isRecursiveAccountTrigger.firedfromAccount();
                    AccountHandler.sendEmail(acctsToSendEmail, Org_wideaddress, ownerEmailMap, CSMMap, PrimarycontactsMap);
                }
            }    
}