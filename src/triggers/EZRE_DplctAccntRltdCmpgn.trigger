/**
 * @author           Shahida K
 * @version          1.0 
 * @date             28-Jun-2015
 * @Status           Developed
 * @description     Trigger to restict duplicate Account Related Campaign for account
 *                   
 */
 
///<OBJECTIVE>
//Trigger to check the each Account Related Campaign record while inserting and updating.
//Functionlaity checks Account Related Campaigns 'Campaign__c' field value and if record exist with same Campaign value,shows error message that 'Duplcate Campaign'.  
///</OBJECTIVE> 
trigger EZRE_DplctAccntRltdCmpgn on Account_Related_Campaign__c(before Insert,before Update)
{
    Map<Id,List<Account_Related_Campaign__c>>  accIdAndAccntRltdCmpgnMap=new Map<Id,List<Account_Related_Campaign__c>>();
    Set<Id> AccIdSet=new Set<Id>();
    set<String> ARCCampaignSet;
    
    for(Account_Related_Campaign__c accRldCmpnObj:trigger.new)
    {
        if((accRldCmpnObj.Campaign__c!=null)&&(accRldCmpnObj.Account__c!=null))
        {
            AccIdSet.add(accRldCmpnObj.Account__c);
            system.debug('AccIdSet:=============='+AccIdSet);
        }
    }
    List<Account_Related_Campaign__c>  AccntRltdCmpgnList=[select Id,Account__c,Campaign__c from Account_Related_Campaign__c where Account__c IN: AccIdSet];
    system.debug('AccntRltdCmpgnList:=============='+AccntRltdCmpgnList);
    for(Account_Related_Campaign__c accRldCmpnObj:AccntRltdCmpgnList)
    {
        if(accIdAndAccntRltdCmpgnMap.containsKey(accRldCmpnObj.Account__c))
        {
            accIdAndAccntRltdCmpgnMap.get(accRldCmpnObj.Account__c).add(accRldCmpnObj);
        }
        else
        {
            accIdAndAccntRltdCmpgnMap.put(accRldCmpnObj.Account__c,new List<Account_Related_Campaign__c>{accRldCmpnObj});
        }
    }
    if(trigger.isBefore)
    {
        if(trigger.isInsert){           
            if(!accIdAndAccntRltdCmpgnMap.IsEmpty()){
                for(Account_Related_Campaign__c accRldCmpnObj:trigger.new)
                {
                  system.debug('accRldCmpnObjCampaign=============='+accRldCmpnObj.Campaign__c);
                    List<Account_Related_Campaign__c> AccntRltdCmpgnLst=new List<Account_Related_Campaign__c>();
                    if(accIdAndAccntRltdCmpgnMap.containsKey(accRldCmpnObj.Account__c))
                        AccntRltdCmpgnLst=accIdAndAccntRltdCmpgnMap.get(accRldCmpnObj.Account__c);
                    system.debug('accRldCmpnObjCampaign=============='+AccntRltdCmpgnLst);
                    if(AccntRltdCmpgnLst.size()>0)
                    {
                        for(Account_Related_Campaign__c accntRltdCmpnRec:AccntRltdCmpgnLst)
                        {
                            system.debug('new=============='+accRldCmpnObj.Campaign__c);
                            system.debug('list value=============='+accntRltdCmpnRec.Campaign__c);
                           if(accRldCmpnObj.Campaign__c==accntRltdCmpnRec.Campaign__c)
                           {
                             accRldCmpnObj.addError('Duplicate Campaign');  
                             system.debug('accRldCmpnObj.Id==============='+accRldCmpnObj.Id);
                           }
                        }
                    }
                }
            }
        }
    }
   if(trigger.isBefore)
    {
        if(trigger.isUpdate)
        {
            ARCCampaignSet=new set<String>();  
            if(!accIdAndAccntRltdCmpgnMap.IsEmpty())
            {
                for(Account_Related_Campaign__c accRldCmpnObj:trigger.new)
                {
                      system.debug('accRldCmpnObjCampaign=============='+accRldCmpnObj.Campaign__c);
                    List<Account_Related_Campaign__c> AccntRltdCmpgnLst=new List<Account_Related_Campaign__c>();
                    if(accIdAndAccntRltdCmpgnMap.containsKey(accRldCmpnObj.Account__c))
                        AccntRltdCmpgnLst=accIdAndAccntRltdCmpgnMap.get(accRldCmpnObj.Account__c);
                    if(AccntRltdCmpgnLst.size()>0)
                    {                   
                      system.debug('AccntRltdCmpgnLst=============='+AccntRltdCmpgnLst);
                        for(Account_Related_Campaign__c accntRltdCmpnRec:AccntRltdCmpgnLst)
                        {
                           system.debug('accntRltdCmpnRec=============='+accntRltdCmpnRec.Campaign__c); 
                           if((accRldCmpnObj.Campaign__c==accntRltdCmpnRec.Campaign__c)&&(Trigger.oldMap.get(accRldCmpnObj.id).Campaign__c!=Trigger.newMap.get(accRldCmpnObj.id).Campaign__c)){
                           ARCCampaignSet.add(accRldCmpnObj.Id);
                           system.debug('accRldCmpnObj.Id=================='+accRldCmpnObj.Id);
                           }
                        }
                    }
                }
                list<Account_Related_Campaign__c> ARCList=[select id,Campaign__c from Account_Related_Campaign__c where id IN:ARCCampaignSet];
        
                if(ARCList.size()>0) 
                {
                    for(Account_Related_Campaign__c accRldCmpnObj:Trigger.new)
                    {                   
                       accRldCmpnObj.addError('Duplicate Campaign');              
                        
                    }
                }     
            }
        }
    }
    

}