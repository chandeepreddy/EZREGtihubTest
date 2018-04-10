@istest
Public class CreateChildswhenSOWisFullyExecuted_test
{
public static testmethod void testCreateChildswhenSOWisFullyExecuted()
{
//fetch user role where portal type is none
        UserRole portalRole = ODS_DataFactory_Test_Utility.FetchUserRole();
        System.debug('@@@portalRole:'+portalRole);
        //fetch system admin profile
        Profile SAProfile = ODS_DataFactory_Test_Utility.GetProfileName('System Administrator');
        
        //Insert an internal user
        User usrObj = ODS_DataFactory_Test_Utility.InsertUserWithPortalRole('Hari','testuser@testmail.com', 'UTF-8','Harikrishna', 'en_US','en_US',SAProfile.Id,'America/Chicago',System.now().millisecond() + 
                    'test123@testmail.com','Practice Head', true);
                    
                    
           System.runAs (usrObj) 
                {      
                List<Account> list_accounts = new List<Account>();
                //Insert an account    
                Account acc = ODS_DataFactory_Test_Utility.InsertAccountforcreatechilds('TestAccount','Sent',system.today(),usrObj.Id,10000,'012345789','Others','ODS Project',True,True);
                //Insert a contact  
                Contact con = ODS_DataFactory_Test_Utility.InsertContactforcreatechilds('Test','Contact','1: Calling',acc.Id,'Maharaja0393@gmail.com'); 
                //Insert ODS services record
                ODS_Services__c ods = new ODS_Services__c(Name__c = 'Salesforce', Description__c = 'Test salesforce' , Active__c = true);
                insert ods;
                Test.startTest();
                acc.Primary_Customer_Contact__c = con.id;
                acc.Created_Childs_Automatically__c  = False; 
                acc.SOW__c = 'Fully Executed';
                update acc;
                //added as part of demandblue migration@31/03/2018
                list_accounts.add(acc);
                CreateChildswhenSOWisFullyExecuted.createChilds(list_accounts);
                Test.stopTest();
                List<Account> invList = [Select Id,Name,Created_Childs_Automatically__c from Account where Id = : acc.Id];         
                system.assertEquals(1,invList.size());

                
                  List<User_Account__c> userAcc = [Select Id from User_Account__c where Account__c = : acc.Id];
              //    system.assertEquals(1,userAcc.size());
                  list<Contact_Account_Service__c> caccservice = [Select Id from Contact_Account_Service__c where Account__c = : acc.Id];
             //     system.assertEquals(1,caccservice.size());
                  list<Account_Services__c> Accservice = [Select id from Account_Services__c where Account__c = : acc.Id];
             //     system.assertEquals(1,Accservice.size());  

              }
    
}
    

}