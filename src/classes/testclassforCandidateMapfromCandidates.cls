/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
/**
 * @Modified author  Shahida k
 * @version          1.0 
 * @date             25.Apr.2017
 * @Status           Updated
 * @description      Updated test class to cover all scenarios when included file upload for candidate resume attachement in lightning
 *
 */ 
 
@isTest
private class testclassforCandidateMapfromCandidates 
{
        
     
       ///OBJECTIVE
       ///Test method to create assign candidate record as a lead recruiter
      ///OBJECTIVE
      static testMethod void assignCandidateByLR() 
      {
        
         //Fetch Lead Recruiter profile
        Profile profileRecord=EZRE_DataFactory_Test_Utl.getParticularProfile('LR Chatter Only User'); 
        
        //Fetch lead recruiter role     
        userRole roleRecord=EZRE_DataFactory_Test_Utl.getParticularRole('Lead Recruiter');  
        
        //Insert User Record      
        USer standardUser=EZRE_DataFactory_Test_Utl.fetchRecruiters(profileRecord.Id,roleRecord.Id);
        System.RunAs(standardUser)
        {
            system.test.startTest();
            Candidate_Mapping__c candidateMapping =EZRE_DataFactory_Test_Utl.createCandidateMapping('test@preludesys.com',null,null,'Applied','test','test by lr','test by MR','testOwner@preludesys.com');         
            Candidate__c candidateRecord1=EZRE_DataFactory_Test_Utl.insertCandidateRecord('test','testfive','chennai','Maine','Male','ttt','test@gmail.com','Mobile Phone','w2','H1 B',100,'9890043500','test@gmail.com','tt','9988009876');  
            candidateMapping.Candidate__c=candidateRecord1.id;              
            system.debug('candid:'+candidateRecord1.id);
            requirement__c requirementRecord1=EZRE_DataFactory_Test_Utl.insertRequirement('SampathReq5','6',0,100,200,200,'Hourly','Open','Contract','CA','CA',date.today(),true,'java');
            candidateMapping.Requirement__c=requirementRecord1.id; 
            Candidate_Mapping__c candidateMapping1 =EZRE_DataFactory_Test_Utl.createCandidateMapping('test@preludesys.com',candidateRecord1.id,requirementRecord1.id,'Applied','test','test by lr','test by MR','testOwner@preludesys.com');   
            insert candidateMapping1;
            system.test.stopTest();
            
            RequirementAssignment__c  assgnRequirmnt=EZRE_DataFactory_Test_Utility2.createAssignmentReq(requirementRecord1.Id,standardUser.Id);
            ContentWorkspace testWorkspace = EZRE_DataFactory_Test_Utl.FetchContentWorkspace('Resumes');
            ContentVersion testContentInsert=EZRE_DataFactory_Test_Utl.createContentVersion(testWorkspace.Id,'http://www.google.com/','Google.com',candidateRecord1.id);         
            CandidateMapfromCandidates candidateMappingObj = new CandidateMapfromCandidates();  
            try{            
            candidateMappingObj.save();   
            candidateMappingObj.saveNew();    
            }
            catch(exception ex)  
            {
                 System.Assert(ex.getMessage().contains('Already this Candidate and Opportunity combination is available'));  
            }     

         }            
    }
       ///OBJECTIVE
       ///Test method to create assign candidate record as a recruiter
      ///OBJECTIVE
     static testMethod void assignCandidateByRecruiter() 
      {
         //Fetch Lead Recruiter profile
        Profile profileRecord=EZRE_DataFactory_Test_Utl.getParticularProfile('R Chatter Only User'); 
        //Fetch lead recruiter role     
        userRole roleRecord=EZRE_DataFactory_Test_Utl.getParticularRole('Recruiter');  
        
        //Insert User Record      
        USer standardUser=EZRE_DataFactory_Test_Utl.fetchRecruiters(profileRecord.Id,roleRecord.Id);
        System.RunAs(standardUser)
        {
            system.test.startTest();
            Candidate_Mapping__c candidateMapping =EZRE_DataFactory_Test_Utl.createCandidateMapping('test@preludesys.com',null,null,'Applied','test','test by lr','test by MR','testOwner@preludesys.com');
            Candidate__c candidateRecord1=EZRE_DataFactory_Test_Utl.insertCandidateRecord('test','testfive','chennai','Maine','Male','ttt','test@gmail.com','Mobile Phone','w2','H1 B',100,'9890043500','test@gmail.com','tt','9988009876');  
            candidateMapping.Candidate__c=candidateRecord1.id;              
            system.debug('candid:'+candidateRecord1.id);
            requirement__c requirementRecord1=EZRE_DataFactory_Test_Utl.insertRequirement('SampathReq5','6',1,100,200,200,'Hourly','Open','Contract','CA','CA',date.today(),true,'java');
            candidateMapping.Requirement__c=requirementRecord1.id;    
            system.test.stopTest();
              
            
            ContentWorkspace testWorkspace = EZRE_DataFactory_Test_Utl.FetchContentWorkspace('Resumes');
            ContentVersion testContentInsert=EZRE_DataFactory_Test_Utl.createContentVersion(testWorkspace.Id,'http://www.google.com/','Google.com',candidateRecord1.id);              
            system.debug('candidateMappingObj:'+testWorkspace );          
            CandidateMapfromCandidates candidateMappingObj = new CandidateMapfromCandidates();               
            system.assert(candidateMapping!= null);
            candidateMappingObj.save();          
            candidateMappingObj.saveNew();
         }            
    }
      
        ///OBJECTIVE
       ///Test method to create assign candidate 
      ///OBJECTIVE
      static testMethod void assignCandidateWithClosedReq() 
      {
         //Fetch Lead Recruiter profile
        Profile profileRecord=EZRE_DataFactory_Test_Utl.getParticularProfile('R Chatter Only User'); 
        //Fetch lead recruiter role     
        userRole roleRecord=EZRE_DataFactory_Test_Utl.getParticularRole('Recruiter');  
        
        //Insert User Record      
        USer standardUser=EZRE_DataFactory_Test_Utl.fetchRecruiters(profileRecord.Id,roleRecord.Id);
        System.RunAs(standardUser)
        {
             system.test.startTest();
            Candidate_Mapping__c candidateMapping =EZRE_DataFactory_Test_Utl.createCandidateMapping('test@preludesys.com',null,null,'Applied','test','test by lr','test by MR','testOwner@preludesys.com');
            Candidate__c candidateRecord1=EZRE_DataFactory_Test_Utl.insertCandidateRecord('test','testfive','chennai','Maine','Male','ttt','test@gmail.com','Mobile Phone','w2','H1 B',100,'9890043500','test@gmail.com','tt','9988009876');  
            candidateMapping.Candidate__c=candidateRecord1.id;              
            system.debug('candid:'+candidateRecord1.id);
            requirement__c requirementRecord1=EZRE_DataFactory_Test_Utl.insertRequirement('SampathReq5','6',0,100,200,200,'Hourly','Open','Contract','CA','CA',date.today(),true,'java');
            candidateMapping.Requirement__c=requirementRecord1.id;    
            system.test.stopTest();
              
            
            ContentWorkspace testWorkspace = EZRE_DataFactory_Test_Utl.FetchContentWorkspace('Resumes');
            ContentVersion testContentInsert=EZRE_DataFactory_Test_Utl.createContentVersion(testWorkspace.Id,'http://www.google.com/','Google.com',candidateRecord1.id);              
            system.debug('candidateMappingObj:'+testWorkspace );          
            CandidateMapfromCandidates candidateMappingObj = new CandidateMapfromCandidates();               
            system.assert(candidateMapping!= null);
           try{    
            candidateMappingObj.save();          
            candidateMappingObj.saveNew();
            }
            catch(Exception ex)
            {
                System.Assert(ex.getMessage().contains('This corresponding opportunity is closed already'));  
            }
            
            
         }            
    }
    
        ///OBJECTIVE
       ///Test method to create assign candidate record as a business development manager
      ///OBJECTIVE
     static testMethod void assignCandidateByBDM() 
      {

         //Fetch Lead Recruiter profile
        Profile profileRecord=EZRE_DataFactory_Test_Utl.getParticularProfile('Custom Standard User'); 
        //Fetch lead recruiter role     
        userRole roleRecord=EZRE_DataFactory_Test_Utl.getParticularRole('Business Development Manager');  
        
        //Insert User Record      
        USer standardUser=EZRE_DataFactory_Test_Utl.fetchRecruiters(profileRecord.Id,roleRecord.Id);
        
        System.RunAs(standardUser)
        {
            system.test.startTest();
            Candidate_Mapping__c candidateMapping =EZRE_DataFactory_Test_Utl.createCandidateMapping('test@preludesys.com',null,null,'Applied','test','test by lr','test by MR','testOwner@preludesys.com');
            Candidate__c candidateRecord1=EZRE_DataFactory_Test_Utl.insertCandidateRecord('test','testfive','chennai','Maine','Male','ttt','test@gmail.com','Mobile Phone','w2','H1 B',100,'9890043500','test@gmail.com','tt','9988009876');  
            candidateMapping.Candidate__c=candidateRecord1.id;              
            system.debug('candid:'+candidateRecord1.id);
            requirement__c requirementRecord1=EZRE_DataFactory_Test_Utl.insertRequirement('SampathReq5','6',1,100,200,200,'Hourly','Open','Contract','CA','CA',date.today(),true,'java');
            candidateMapping.Requirement__c=requirementRecord1.id;    
            system.test.stopTest();
            
            ContentWorkspace testWorkspace = EZRE_DataFactory_Test_Utl.FetchContentWorkspace('Resumes');
            ContentVersion testContentInsert=EZRE_DataFactory_Test_Utl.createContentVersion(testWorkspace.Id,'http://www.google.com/','Google.com',candidateRecord1.id);
            system.debug('candidateMappingObj:'+testWorkspace );
            
            CandidateMapfromCandidates candidateMappingObj = new CandidateMapfromCandidates();              
             
            candidateMappingObj.save();    
            system.assert(candidateMapping!= null);
            candidateMappingObj.cancel();                           
            candidateMappingObj.saveNew();
         }            
    }
     
        ///OBJECTIVE
       ///Test method to create assign candidate without resume
      ///OBJECTIVE
        static testMethod void assignCandidateWithoutResume() 
      {

        //Fetch Lead Recruiter profile
        Profile profileRecord=EZRE_DataFactory_Test_Utl.getParticularProfile('Custom Standard User'); 
        
        //Fetch lead recruiter role     
        userRole roleRecord=EZRE_DataFactory_Test_Utl.getParticularRole('Business Development Manager');  
        
        //Insert User Record      
        USer standardUser=EZRE_DataFactory_Test_Utl.fetchRecruiters(profileRecord.Id,roleRecord.Id);
        
        System.RunAs(standardUser)
        {
            system.test.startTest();
            Candidate_Mapping__c candidateMapping =EZRE_DataFactory_Test_Utl.createCandidateMapping('test@preludesys.com',null,null,'Applied','test','test by lr','test by MR','testOwner@preludesys.com');
            
            Candidate__c candidateRecord1=EZRE_DataFactory_Test_Utl.insertCandidateRecord('test','testfive','chennai','Maine','Male','ttt','test@gmail.com','Mobile Phone','w2','H1 B',100,'9890043500','test@gmail.com','tt','9988009876');                          
            system.debug('candid:'+candidateRecord1.id);
            requirement__c requirementRecord1=EZRE_DataFactory_Test_Utl.insertRequirement('SampathReq5','6',0,100,200,200,'Hourly','Open','Contract','CA','CA',date.today(),true,'java');          
            
            system.test.stopTest();

            ContentWorkspace testWorkspace = EZRE_DataFactory_Test_Utl.FetchContentWorkspace('Resumes'); 
            system.debug('candidateMappingObj:'+testWorkspace );
            
                      
            try{
            
            CandidateMapfromCandidates candidateMappingObj = new CandidateMapfromCandidates();
            candidateMappingObj.showMessage='';  
            candidateMappingObj.test='';
            candidateMappingObj.UserRoleId='';
            candidateMappingObj.saveNew();   
            candidateMapping.Candidate__c=null; 
            candidateMapping.Requirement__c=null;  
            candidateMappingObj.savenew();
            candidateMappingObj.save();          
            candidateMappingObj.cancel();                          
           
            }
            catch(exception ex)
            {
                 System.Assert(ex.getMessage().contains('Resume must be attached'));  
            }
         }           
    }
    
}