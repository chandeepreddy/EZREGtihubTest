@isTest
public class Test_updateCampaignMember {
    public static testmethod void updateCampaignMemberRun(){
    User u = new User(
     ProfileId = [SELECT Id FROM Profile WHERE Name = 'ISR'].Id,
         LastName = 'last',

          Email = 'puser000@amamama.com',
     Username = 'puser000@amamama.com' + System.currentTimeMillis(),
     CompanyName = 'TEST',
     Title = 'title',
     Alias = 'alias',
     TimeZoneSidKey = 'America/Los_Angeles',
     EmailEncodingKey = 'UTF-8',
     LanguageLocaleKey = 'en_US',
     LocaleSidKey = 'en_US'
);   
        insert u;
     
        
       // Campaign inserttestcampaign1= EZRE_DataFactory_Test_Utility.createcampaignstoleads('VMS');
       campaign inserttestcampaign1 = new campaign(name = 'ODS Force.com');
        insert inserttestcampaign1;
     // campaign inserttestcampaign1 = new campaign(name = 'ODS Force.com');
        
        Lead inserttestlead1= EZRE_DataFactory_Test_Utility.createLeadwithcampaignmember('Test1','Lead1','Vijay','calling','Test Account','www.testwebsite.com');
       //CampaignMember campaignMember1 =EZRE_DataFactory_Test_Utility.createcampaignmembers(inserttestlead1.id, 'Run 1','Completed', inserttestcampaign1.id);
 	   //system.debug('==Campaignmember1==' +campaignMember1);
       task t =  new task();
        t.Campaign__c = inserttestcampaign1.id; 
        t.Status = 'Completed';
        insert t;
        CampaignMember newMember = 
      new CampaignMember(Campaignid = inserttestcampaign1.Id, leadid = inserttestlead1.Id, run__c = 'run 0');
        insert newMember;
        system.debug('===inserttestcampaign1===' +inserttestcampaign1);
        system.debug('===inserttestlead1===' +inserttestlead1);
        system.debug('===newMember===' +newMember.campaign.name);
        
        
   system.runAs(u){
        //task task1 = EZRE_DataFactory_Test_Utility.createTasks('run 1',inserttestcampaign1.id, inserttestlead1.id, 'test1', 'high', 'test');
			List<task> tasks = new List<task>();
            task task2 = new task();
            task2.Campaign__c = inserttestcampaign1.id;
      		task2.Status = 'Completed';
           // task2.Run__c = 'Run 2';
            tasks.add(task2);
            task2.WhoId= inserttestlead1.Id;
            insert tasks;
        //newMember.Run__c = 'Run 5';
        
        update newMember;
        //test.stopTest();
       // system.assertnotEquals(task2.Run__c, campaignmember1.Run__c);
        }}

}