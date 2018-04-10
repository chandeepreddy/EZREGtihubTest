global class BatchMovingCampaignsunderLeads implements Database.Batchable<sObject>
{   
 public List<CampaignMember> campaignmemberslist= new List<CampaignMember>();
     global Database.QueryLocator start(Database.BatchableContext bc) 
        {
            String contactslist = 'SELECT Id,isDoNotDelete__c,Lead_Id__c, Force_com__c,Status__c,Account.Inside_SalesRep__c, Account.Source__c, Account.Force_com_Data_Status__c,Account.Force_com_Account_Status__c,Account.Force_com_Data_Status_Comments__c,IsContactConvertedtoLead__c FROM Contact WHERE IsContactConvertedtoLead__c =true  and isDoNotDelete__c = true';
            return Database.getQueryLocator(contactslist);
        }
    global void execute(Database.BatchableContext bc, List<Contact> contactslist)
    {
        
         Map<String,Id> mapcampaigns = new Map<String,Id>();
         List<Campaign> cam=[SELECT Name,Id FROM Campaign];
            for(Campaign c: cam)
            {
              mapcampaigns.put(c.Name,c.Id); 
            }
        system.debug('@@@@mapcampaigns' +mapcampaigns );
         for(Contact eachcontact: contactslist)
         {
           if(eachcontact.Force_com__c==true)
           {
             id ForcecomId= mapcampaigns.get('ODS Force.com');
             PopulateForcecom(eachcontact,ForcecomId);                 
           }}
        database.insert (campaignmemberslist, false);
          Database.SaveResult[] srList = database.insert(campaignmemberslist,false);
     
        // Iterate through each returned result
        for (Database.SaveResult sr : srList) {
        system.debug('$$sr '+sr );
            if (sr.isSuccess()) {
                // Operation was successful, so get the ID of the record that was processed
                System.debug('Successfully inserted Lead. Lead ID: ' + sr.getId());
               
            }
            else {
                // Operation failed, so get all errors                
                for(Database.Error err : sr.getErrors()) {
                    System.debug('The following error has occurred.');                    
                    System.debug(err.getStatusCode() + ': ' + err.getMessage());
                    System.debug('Lead fields that affected this error: ' + err.getFields());
                }
       
         }
        }}
        global void finish(Database.BatchableContext bc) 
    {

    }
        public void PopulateForcecom(contact contactRecord,id ForcecomId)
         {
           CampaignMember varcampaignmember= new CampaignMember();
         
           varcampaignmember.CampaignId =ForcecomId;
           varcampaignmember.LeadId=contactRecord.Lead_Id__c;
          
           varcampaignmember.Contact_Status__c=contactRecord.Status__c;
           varcampaignmember.Status__c=contactRecord.Account.Force_com_Account_Status__c;
           varcampaignmember.Source__c=contactRecord.Account.Source__c;
           varcampaignmember.Inside_SalesRep__c=contactRecord.Account.Inside_SalesRep__c;
           varcampaignmember.Data_Status__c=contactRecord.Account.Force_com_Data_Status__c;
           varcampaignmember.Comments__c=contactRecord.Account.Force_com_Data_Status_Comments__c;
           campaignmemberslist.add(varcampaignmember);
         }
    }