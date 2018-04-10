/*
*
 * @author           Aarthy S
 * @version          1.0 
 * @date             28/02/2018
 * @description      Batch class to update "Campaigns associated" multipicklist field in Contact with Campaigns name
 */
 
global class CampaignsAssociatedContactUpdate implements Database.Batchable<sObject>
{

    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        
        String query = 'SELECT Id,Name,IsContactConvertedtoLead__c,Campaigns_Associated__c FROM Contact where IsContactConvertedtoLead__c = false or  isdonotdelete__c = true ';
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<contact> scope)
    {
        Set<Id> contactSet = new Set<Id>();
        List<CampaignMember> campaignMemList = new List<CampaignMember>();
        Map<Id,String> campaignsAssociated = new Map<Id,String>();
        List<contact> contactsToUpdate = new List<contact>();
                
        for(contact c : scope)
        {
            contactSet.add(c.Id);
        }
        
        //Fetching the list of campaign members with lead Id
        campaignMemList = [select Id,Campaign.Name,contactId FROM CampaignMember WHERE contactid in: contactSet ];
        
        //Building a map with contactId as key and the list of Campaign names as value seperated by semi colon
        for(CampaignMember cm : campaignMemList)
        {
            String CamStr = '';
            if(campaignsAssociated.containsKey(cm.contactId))
            {
               CamStr = campaignsAssociated.get(cm.contactId);
               CamStr = CamStr + cm.Campaign.Name+ ';';
               campaignsAssociated.put(cm.contactId, CamStr);
            }
            else
            {
                CamStr = CamStr + cm.Campaign.Name+ ';';
                campaignsAssociated.put(cm.contactId, CamStr);
            }
        }
        
        system.debug('campaignsAssociated '+campaignsAssociated);
        
        for(contact contactUpdate : scope)
        {
            if(campaignsAssociated.containskey(contactUpdate.Id))
            {
                String tocmpare ='';
                if(campaignsAssociated.get(contactUpdate.Id) != null)
                {
                   tocmpare = campaignsAssociated.get(contactUpdate.Id).removeEnd(';');
                }
                system.debug('values '+contactUpdate.Campaigns_Associated__c+' '+tocmpare);
               
                if(!(contactUpdate.Campaigns_Associated__c == null && campaignsAssociated.get(contactUpdate.Id) == null))
                {
                    if((contactUpdate.Campaigns_Associated__c == null || campaignsAssociated.get(contactUpdate.Id) == null) || (contactUpdate.Campaigns_Associated__c.trim() != tocmpare.trim() ))
                    {
                        
                        contactUpdate.Campaigns_Associated__c = campaignsAssociated.get(contactUpdate.Id);
                        contactsToUpdate.add(contactUpdate);
                    }
                }
            
               
            }
        }
        
        system.debug('contactsToUpdate '+contactsToUpdate);
        
        Database.update(contactsToUpdate);
        
    }  
    global void finish(Database.BatchableContext BC)
    {
    }
}