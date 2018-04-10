/**
 * @author           Gangadhar R
 * @version          1.0 
 * @date             8/07/2015
 * @Status           Developed
 * @description      This is a test class for AttachmentNameDuplicate Trigger.
 *
 */
@isTest
public class AttachmentNameDuplicateTrigger_Test 
{ 
        //Method Positive Test
        static testMethod void InsertAttachment() 
        {
            Test.StartTest();
            CDOC__c cd = CDOC_DataFactory_Test_Utility.InsertCDOC();
            
            Attachment attach = CDOC_DataFactory_Test_Utility.InsertAttachment(cd.Id);
                    
            List<Attachment> lstAttachments= CDOC_DataFactory_Test_Utility.fetchAttachments(cd.Id);
            System.assertEquals(1, lstAttachments.size());
            Test.StopTest();  
        }
      //Method Negative Test
      static testMethod void InsertAttachNegativeTest() 
      {
            Test.StartTest();
            CDOC__c cd = CDOC_DataFactory_Test_Utility.InsertCDOC();
            
            Attachment attach = CDOC_DataFactory_Test_Utility.InsertAttachment(cd.Id);
            try
            {
                Attachment attach1 = CDOC_DataFactory_Test_Utility.InsertAttachment(cd.Id);
            }
            catch(Exception e)
            {
                Boolean expectedExceptionThrown =  e.getMessage().contains('Cannot upload a file with same Name.Please retry with different Name') ? true : false;
                System.AssertEquals(expectedExceptionThrown,true);
            } 
            Test.StopTest();
           
        }
    }