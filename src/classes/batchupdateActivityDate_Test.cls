@ISTest
public class batchupdateActivityDate_Test
{    
    public static testMethod void testBatch() 
    {
        //Insert account
            Account acc = EZRE_DataFactory_Test_Utl.createAccnt('test','www.yahoo.com');
            
            //Insert account 
            Account acc1 =EZRE_DataFactory_Test_Utl.createAccnt('testaccount','www.abc.com');
           
            //Insert contact 
            contact Con =EZRE_DataFactory_Test_Utl.createSfdcContact('TestContact',acc.Id,true,'3: Meeting Set');
            //task tsk = new task();
        //tsk.
        AccountActivityCreateddateUpdate obj = new AccountActivityCreateddateUpdate();
        database.executebatch(obj,10);
    }
}