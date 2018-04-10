/**
 * @author           Gnanaprakasam G
 * @version          1.0 
 * @date             13-Oct-2016
 * @Status           Developed
 * @description      This is the test class for Account trigger
 */
@isTest
private class ODS_AccountTrigger_Test
{
       
    static testMethod void AccountPortalAccess_PositiveTest()
    {
        Account acc = ODS_DataFactory_Test_Utility.insertAccount('Test Account', 'Test City', False,2000,'9433578865',
                                                 'Others', 'ODS Project');
        Contact con1 = ODS_DataFactory_Test_Utility.insertContact('Test First Name1', 'Test Last Name1', False, acc.Id, 
                                                 'Others', 'ODS Project');
        Contact con2 = ODS_DataFactory_Test_Utility.insertContact('Test First Name2', 'Test Last Name2', False, acc.Id,
                                                 'Others', 'ODS Project');
        Account accnt = ODS_DataFactory_Test_Utility.fetchAccount(acc.Id);
        accnt.Is_Portal_Access__c = True;
        update accnt;
    }
    
    static testMethod void AccountPortalAccess_NegativeTest()
    {
        Account acc = ODS_DataFactory_Test_Utility.insertAccount('Test Account', 'Test City', True,2000,'9433578865',
                                                    'Others', 'ODS Project');
        Contact con = ODS_DataFactory_Test_Utility.insertContact('Test First Name', 'Test Last Name', False, acc.Id,
                                                    'Others', 'ODS Project');
        Account accnt = ODS_DataFactory_Test_Utility.fetchAccount(acc.Id);
        accnt.Is_Portal_Access__c = False;
        update accnt;
    }
}