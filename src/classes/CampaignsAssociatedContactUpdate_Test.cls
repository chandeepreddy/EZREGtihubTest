@isTest

Public class CampaignsAssociatedContactUpdate_Test
{
    public static testmethod void campaignmemunderLead()
    {
        // Insert Profile
         Profile inserttestprofile = EZRE_DataFactory_Test_Utility.ProfileByName('Administrator');
        
        // Insert User
        User inserttestuser = EZRE_DataFactory_Test_Utility.createUser('ISR1','testuser@testmail.com','UTF-8','ISR1', 'en_US',
                    'en_US',inserttestprofile.id,'America/Chicago','test123@testmail.com','1234567890');
        
        List<User> inserttestuserList = [select Id,Name,FirstName,LastName from user where LastName = 'ISR1'];
        if(inserttestuserList.size() > 0)
        {
            system.runAs(inserttestuserList[0])
            {
             //Insert Campaign
             Campaign inserttestcampaign1= EZRE_DataFactory_Test_Utility.createcampaignstoleads('VMS');
             Campaign inserttestcampaign2= EZRE_DataFactory_Test_Utility.createcampaignstoleads('ODS Force.com');
             Campaign inserttestcampaign3= EZRE_DataFactory_Test_Utility.createcampaignstoleads('ODS AWS');
            
            //Insert Lead
        
                Account inserttestaccount = EZRE_DataFactory_Test_Utility.createVMSaccounts('PreludeTestAccount',inserttestuser.id,'1: Calling','Jack');

           contact con = new contact(accountid = inserttestaccount.id, lastname = 'test', VMS__c = true, Lead_Gen_Name__c = 'Amit', status__c = '1: Calling', IsContactConvertedtoLead__c = false, isDoNotDelete__c = true);
        insert con;
            //Fetch Campaigns
           // Campaign fetchcampaign =  [SELECT Id FROM Campaign];
CampaignMember campaignMember1 = new campaignmember(contactid = con.id, status = 'sent', campaignid = inserttestcampaign1.id);
                insert campaignMember1;
            //Insert Campaign Member 
            //CampaignMember campaignMember1 =EZRE_DataFactory_Test_Utility.createcampaignmember(inserttestlead1.id, 'Sent', inserttestcampaign1.id);
           // CampaignMember campaignMember2 =EZRE_DataFactory_Test_Utility.createcampaignmember(inserttestlead1.id, 'Sent', inserttestcampaign2.id);
            
          //  CampaignMember campaignMember3 =EZRE_DataFactory_Test_Utility.createcampaignmember(inserttestlead2.id, 'Sent', inserttestcampaign3.id);
            
            test.startTest();
            CampaignsAssociatedContactUpdate  obj=new CampaignsAssociatedContactUpdate();
            Database.executeBatch(obj, 200);   
            test.stopTest();
            //system.assertEquals('Test1',inserttestlead1.FirstName);
            //system.assertEquals(inserttestlead.id,campaignMember.LeadId);
            }
        }
    }
 }