/**
 * @author           Indhu
 * @version          1.0 
 * @date             07-Jan-2014
 * @Status           Developed
 * @description      This is the test class for EZRE_SendMailDailyProductivity that includes test scenarios.
 *                   
 */

@isTest 
public class EZRE_SendMailDailyProductivity_Test
{
    static testMethod void DailyProductivity_Constructor_Test()
    {        
        User objUserName = EZRE_DailyProd_DataFactoryTestUtility.getUserName();
        
        EZRE_DailyProductivityDetails__c objDailyProd = EZRE_DailyProd_DataFactoryTestUtility.createDailyProdCustmSetng(
                                     'DailyProductivityReport','from@testmail.com','to@testmail.com','Test from Name',
                                     'Test Subject','Test File Name',objUserName.Name,'cc@testmail.com','This is test mail');
        
        system.RunAs(objUserName)
        {
            Requirement__c objReqmt= EZRE_DailyProd_DataFactoryTestUtility.CreateRqmt('Test Reqmt Name','20',200,
                                    250,400,'Open','Contract','AZ','Technical',5,'Irvine','Test Easy1',
                                    'Test Unique1','Test Skill Set',objUserName.Name);
            
            
            Candidate__c objCand=EZRE_DailyProd_DataFactoryTestUtility.CreateCandidate('TestCandidateName','TestCandidateLastName',
                                        'Irvine','Arizona','Male','Test Employee','test@testmail.com','Mobile Phone',
                                        'Corp to Corp','H1 B',100,'9988776655','test@testmail.com','Test Contact Name',
                                        '9443322110','Test Emp Name','9011223344','Test Skill');
                                            
            Candidate_Mapping__c objCandMap = EZRE_DailyProd_DataFactoryTestUtility.createCandMapng('LR Rejected','test','test by lr',
                                          'test by MR','testOwner@preludesys.com','testOwner1@preludesys.com','TestComments',
                                          'Rejected','Applied','07/07/2015','07/07/2015','Yes','Yes','Yes',
                                          'Yes','Yes','Yes','TestComments',Date.Today()-1,objReqmt.Id,objCand.Id);
            
            EZRE_SendMailDailyProductivity objSendMailDailyProd = new EZRE_SendMailDailyProductivity();  
            objSendMailDailyProd.sendMail();
               
            //system.assertEquals(objSendMailDailyProd.LstCandMapping[0].Status1__c,objCandMap.Status1__c);
            system.assertEquals(objSendMailDailyProd.LstRequirement[0].Assigned_User__c,objReqmt.Assigned_User__c);
            //system.assertEquals(objSendMailDailyProd.LstRequirement[0].Job_Title__c,objReqmt.Job_Title__c);
            system.assertEquals(objSendMailDailyProd.LstRequirement[0].Status__c,objReqmt.Status__c);
        }
    }
    
    static testmethod void DailyProductivityScheduler_Test()
    {
        User objUserName = EZRE_DailyProd_DataFactoryTestUtility.getUserName();
        
        EZRE_DailyProductivityDetails__c objDailyProd = EZRE_DailyProd_DataFactoryTestUtility.createDailyProdCustmSetng(
                                     'DailyProductivityReport','from@testmail.com','to@testmail.com','Test from Name',
                                     'Test Subject','Test File Name',objUserName.Name,'cc@testmail.com','This is test mail');
        
        system.RunAs(objUserName)
        {
            Requirement__c objReqmt= EZRE_DailyProd_DataFactoryTestUtility.CreateRqmt('Test Reqmt Name','20',200,
                                    250,400,'Open','Contract','AZ','Technical',5,'Irvine','Test Easy1',
                                    'Test Unique1','Test Skill Set',objUserName.Name);
            
            
            Candidate__c objCand=EZRE_DailyProd_DataFactoryTestUtility.CreateCandidate('TestCandidateName','TestCandidateLastName',
                                        'Irvine','Arizona','Male','Test Employee','test@testmail.com','Mobile Phone',
                                        'Corp to Corp','H1 B',100,'9988776655','test@testmail.com','Test Contact Name',
                                        '9443322110','Test Emp Name','9011223344','Test Skill');
                                            
            Candidate_Mapping__c objCandMap = EZRE_DailyProd_DataFactoryTestUtility.createCandMapng('LR Rejected','test','test by lr',
                                          'test by MR','testOwner@preludesys.com','testOwner1@preludesys.com','TestComments',
                                          'Rejected','Applied','07/07/2015','07/07/2015','Yes','Yes','Yes',
                                          'Yes','Yes','Yes','TestComments',Date.Today()-1,objReqmt.Id,objCand.Id);
            
            EZRE_SendMailDailyProductivity objSendMailDailyProd = new EZRE_SendMailDailyProductivity();  
            objSendMailDailyProd.sendMail();
            
            EZRE_DailyProductionReportScheduler objschedule =new EZRE_DailyProductionReportScheduler();
            String strSchTime = '0 0 22 * * ?';
            system.schedule('Test schedule', strSchTime, objSchedule);
               
            //system.assertEquals(objSendMailDailyProd.LstCandMapping[0].Status1__c,objCandMap.Status1__c);
            system.assertEquals(objSendMailDailyProd.LstRequirement[0].Assigned_User__c,objReqmt.Assigned_User__c);
            //system.assertEquals(objSendMailDailyProd.LstRequirement[0].Job_Title__c,objReqmt.Job_Title__c);
            system.assertEquals(objSendMailDailyProd.LstRequirement[0].Status__c,objReqmt.Status__c);
        }           
    }
}