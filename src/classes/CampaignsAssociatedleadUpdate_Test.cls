@isTest

Public class CampaignsAssociatedleadUpdate_Test
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
            Lead inserttestlead1= EZRE_DataFactory_Test_Utility.createLeadwithcampaignmember('Test1','Lead1','Vijay','calling','Test Account','www.testwebsite.com');
            Lead inserttestlead2= EZRE_DataFactory_Test_Utility.createLeadwithcampaignmember('Test2','Lead2','Hari','calling','Test Account1','www.trailwebsite.com');
            
            //Fetch Campaigns
           // Campaign fetchcampaign =  [SELECT Id FROM Campaign];

            //Insert Campaign Member 
            CampaignMember campaignMember1 =EZRE_DataFactory_Test_Utility.createcampaignmember(inserttestlead1.id, 'Sent', inserttestcampaign1.id);
            CampaignMember campaignMember2 =EZRE_DataFactory_Test_Utility.createcampaignmember(inserttestlead1.id, 'Sent', inserttestcampaign2.id);
            
            CampaignMember campaignMember3 =EZRE_DataFactory_Test_Utility.createcampaignmember(inserttestlead2.id, 'Sent', inserttestcampaign3.id);
            
            test.startTest();
            CampaignsAssociatedleadUpdate  obj=new CampaignsAssociatedleadUpdate();
            Database.executeBatch(obj, 200);   
            test.stopTest();
            system.assertEquals('Test1',inserttestlead1.FirstName);
            //system.assertEquals(inserttestlead.id,campaignMember.LeadId);
            }
        }
    }
 }