/**
 * @author           Nandhini A
 * @version          1.0
 * @date             16/06/2017
 * @description      Test class for ODS_DragAndDropRESTAPI
 */
 @isTest
 public class ODS_DragAndDropRESTAPI_Test
 {
    Public static testMethod void DragAndDrop_Test()
    {
         Profile SAProfile = ODS_DataFactory_Test_Utility.GetProfileName('System Administrator');
    User usrObj = ODS_DataFactory_Test_Utility.InsertUserWithPortalRole('Prels','testuser@testmail.com','UTF-8','TestLastName',
                    'en_US','en_US',SAProfile.Id,'America/Chicago',System.now().millisecond() + 
                    'sample123@testmail.com','Practice Head', true); 
    System.runAs (usrObj)
    {                    
        Account acc = ODS_DataFactory_Test_Utility.insertAccount('First Account', 'Test City', False,2000,'9433578865','Others', 'ODS Project');
        ODS_Services__c odsSrv = ODS_DataFactory_Test_Utility.insertODSServices('Python','test',true);
        User_Account__c usrAcc = ODS_DataFactory_Test_Utility.insertUsrAccnt(acc.id,'Technical Account Manager',usrObj.Id,odsSrv.Id);
        date strtDt =  Date.today();
        date endDt = strtDt.adddays(5);
        Account_Services__c accSrvc = ODS_DataFactory_Test_Utility.insertAccountServices(acc.id,strtDt, endDt,
                                 150.0, odsSrv.id, 1000, 'Monthly', usrObj.Id, 'DSSFDC');
        Folder__c folder=ODS_DataFactory_Test_Utility.InsertFolder('Test',accSrvc.Id);
        

           
            RestRequest request = new RestRequest();
           request.httpMethod = 'GET';
           
        // Set other properties, such as parameters
        request.params.put('FileName', 'Test');
        request.params.put('DocName', 'TestDoc');
        request.params.put('AccountService', accSrvc.Id);
        request.params.put('AccountId', acc.Id);
        request.params.put('ParentId', folder.Id);
        request.params.put('ContentType', 'csv');
         
         RestContext.request = request;
         ODS_DragAndDropRESTAPI.attachDoc();

        }
    }
}