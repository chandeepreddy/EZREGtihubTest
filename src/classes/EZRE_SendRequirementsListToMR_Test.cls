/**
 * @author            Shahida K
 * @version           1.0 
 * @date              02/03/2016
 * @Status            Developed
 * @description       This is a test class for send email open/reopen requirements more than 30 days to requiement owner.
 *
 */
@istest
public class  EZRE_SendRequirementsListToMR_Test
{
 
    ///<OBJECTIVE>
    ///Method to get test requirements open/reopen more than 30 days
    ///</OBJECTIVE>    
    public static testMethod void EZRE_SendRequirementsListToMR_PositiveTest() 
    { 
         //Insert Profile     
          Profile objProfile =EZRE_DataFactory_Test_Utl.getParticularProfile('system administrator');
           
          //Insert User
          User objUser=EZRE_DataFactory_Test_Utl.createUser('acarm','gangadhar_y@preludesys.com',
                        'UTF-8','Alida', 'Carmona', 'en_US',  'en_US',objProfile.Id,'America/Los_Angeles',
                        'Test.carmona@abc.com.qa1prelude','9988776655',true);
                        
         System.runAs(objUser)
         {
        
          date dtStatusUpdatedate = system.today().addDays(-50);                    
         //Insert Requirement with status open and statusupdateDate should be the 30 days before to today's date
         Requirement__c objReqmt = EZRE_DataFactory_Test_Utl.CreateRequirement('.NET Developer','2 months' ,200.00,
                                                                               400.00, 600.00, 'Open', '',
                                                                              'Tamilnadu','tech',2 , 'chennai',
                                                                              'skillset', 'testUnique','testSkillSet', 
                                                                              'testFeebback',true,dtStatusUpdatedate ,'testJobCategory');                   
          System.debug('Current User: ' + UserInfo.getUserName());
          System.debug('Current Profile: ' + UserInfo.getProfileId());
          Test.startTest(); 
          EZRE_SendRequirementsListToMR objRequiement=new EZRE_SendRequirementsListToMR();     
          objRequiement.sendRequirementsListToMR();
          Test.stopTest();
          System.assertEquals(objRequiement.lstReqOpen.size(),1);
      }

    }
    
}