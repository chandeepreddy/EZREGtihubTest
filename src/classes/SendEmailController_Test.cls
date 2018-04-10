/**
 * @author           Shahida
 * @version          1.0 
 * @date             27/02/2017
 * @Status           Developed
 * @description      Test class to SendEmailController class
 *
 */
@isTest
class SendEmailController_Test{
    static testMethod void unitTestforSendEmail() {
        //Create new Candiate and insert it into the database        
         //Insert Candidate
         Candidate__c objCand=EZRE_DataFactory_Test_Utility1.CreateCandidate('TestCandidateName','TestCandidateLastName',
                                'Irvine','Arizona','Male','Test Employee','test@testmail.com','Mobile Phone',
                                'Corp to Corp','H1 B',100,'9988776655','test@testmail.com','Test Contact Name',
                                '9443322110','Test Emp Name','9011223344','Test Skill');   
       
          SendEmailController.getCandidateId(objCand.Id);  
          System.assertEquals('test@testmail.com',SendEmailController.getCandidateId(objCand.Id).email__c);
                                              
    }
}