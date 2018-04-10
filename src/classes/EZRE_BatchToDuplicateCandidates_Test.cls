/**
 * @author           Shahida
 * @version          1.0 
 * @date             22/02/2016
 * @Status           Developed
 * @description      Test class to export duplicate Candidates batch class
 *
 */
 @isTest
 public class EZRE_BatchToDuplicateCandidates_Test
 {
    //<OBJECTIVE>
    //Test method to test export duplicate candidate funtionality
     static testmethod void exportDuplcateCandtTest()
     {
       //Insert Candidate
      Candidate__c objCandt=EZRE_DataFactory_Test_Utl.CreateCandidate('TestCandidateName','TestCandidateLastName','Irvine','Arizona','Male','Test Employee',
                                                    'testtest@testOrg.com','Mobile Phone','Corp to Corp','H1 B',
                                                     100,'9123456789','test@testmail.com','Test Contact Name',
                                                    '9443322110','9011223344', date.today(),'Test Skill');
     
     EZRE_BatchToDuplicateCandidates objDupeCandt=new EZRE_BatchToDuplicateCandidates();     
     database.executeBatch(objDupeCandt);
    
     }
 
 
 
 
 }