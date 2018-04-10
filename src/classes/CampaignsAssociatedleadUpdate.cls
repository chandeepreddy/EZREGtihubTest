/*
*
 * @author           Kanitha priya P
 * @version          1.0 
 * @date             03/01/2017
 * @description      Batch class to update "Campaigns associated" multipicklist field in Lead with Campaigns name
 */
 
global class CampaignsAssociatedleadUpdate implements Database.Batchable<sObject>
{

    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        
        String query = 'SELECT Id,Name,IsContactConvertedasLead__c,Campaigns_Associated__c FROM lead where IsContactConvertedasLead__c = TRUE';
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<lead> scope)
    {
        Set<Id> leadSet = new Set<Id>();
        List<CampaignMember> campaignMemList = new List<CampaignMember>();
        Map<Id,String> campaignsAssociated = new Map<Id,String>();
        List<Lead> LeadToUpdate = new List<Lead>();
                
        for(lead ld : scope)
        {
            leadSet.add(ld.Id);
        }
        
        //Fetching the list of campaign members with lead Id
        campaignMemList = [select Id,Campaign.Name,LeadId FROM CampaignMember WHERE LeadId in: leadSet ];
        
        //Building a map with leadId as key and the list of Campaign names as value seperated by semi colon
        for(CampaignMember cm : campaignMemList)
        {
            String CamStr = '';
            if(campaignsAssociated.containsKey(cm.leadId))
            {
               CamStr = campaignsAssociated.get(cm.leadId);
               CamStr = CamStr + cm.Campaign.Name+ ';';
               campaignsAssociated.put(cm.leadId, CamStr);
            }
            else
            {
                CamStr = CamStr + cm.Campaign.Name+ ';';
                campaignsAssociated.put(cm.leadId, CamStr);
            }
        }
        
        system.debug('campaignsAssociated '+campaignsAssociated);
        
        for(lead ldUpdate : scope)
        {
            if(campaignsAssociated.containskey(ldUpdate.Id))
            {
                String tocmpare ='';
                if(campaignsAssociated.get(ldUpdate.Id) != null)
                {
                   tocmpare = campaignsAssociated.get(ldUpdate.Id).removeEnd(';');
                }
                system.debug('values '+ldUpdate.Campaigns_Associated__c+' '+tocmpare);
               
                if(!(ldUpdate.Campaigns_Associated__c == null && campaignsAssociated.get(ldUpdate.Id) == null))
                {
                    if((ldUpdate.Campaigns_Associated__c == null || campaignsAssociated.get(ldUpdate.Id) == null) || (ldUpdate.Campaigns_Associated__c.trim() != tocmpare.trim() ))
                    {
                        
                        ldUpdate.Campaigns_Associated__c = campaignsAssociated.get(ldUpdate.Id);
                        LeadToUpdate.add(ldUpdate);
                    }
                }
            
               
            }
        }
        
        system.debug('LeadToUpdate '+LeadToUpdate);
        
        Database.update(LeadToUpdate);
        
    }  
    global void finish(Database.BatchableContext BC)
    {
    }
}