@isTest 
private class TestSearchCandidates 
{ 
   static testmethod void testclassmethod()  
   {    
          
          
        
          Candidate__c cand= EZRE_DataFactory_Test_Utl.insertCandidateRecord('test','testone','Aplanta','georgia','Male',null,'tt@gmail.com','Mobile Phone','W2','H1 B',120,'2346678901',null,null,null);
          
       
           EZRE_Search_Candidate_Log_Activation__c objSerachCandLog = new  EZRE_Search_Candidate_Log_Activation__c();
           objSerachCandLog.name = 'SearchCandidateLog';
           objSerachCandLog.Activate_Search_Candidate_Log__c = true;
           
           insert objSerachCandLog;
           
          SearchCandidates s = new SearchCandidates();
          s.inputValue ='java';          
          
          s.search();
          s.showPrevious();
          s.showNext();
          s.showFirst();
          s.showLast();
          
        
   }
   
   static testmethod void testclassmethod_1()  
   {    
        
          Candidate__c cand= EZRE_DataFactory_Test_Utl.insertCandidateRecord('test','one','Aplanta','georgia','Male',null,'james.tttest@gmail.com','Mobile Phone','W2','H1 B',120,'2346678901',null,null,null);
          
           EZRE_Search_Candidate_Log_Activation__c objSerachCandLog = new  EZRE_Search_Candidate_Log_Activation__c();
           objSerachCandLog.name = 'SearchCandidateLog';
           objSerachCandLog.Activate_Search_Candidate_Log__c = true;
           
           insert objSerachCandLog;
        
          ContentWorkspace library = [SELECT id FROM ContentWorkspace LIMIT 1];
          
          ContentVersion cv = EZRE_DataFactory_Test_Utl.createContentVersion(library.id,'https://en.wikipedia.org/wiki/Test','test',cand.id);

          
          Id [] fixedSearchResults= new Id[1];
          fixedSearchResults[0] = cv.Candidate_ID__c;
          Test.setFixedSearchResults(fixedSearchResults);
           
          SearchCandidates s = new SearchCandidates();
          s.inputValue ='test';          
          
          s.search();
          s.showPrevious();
          s.showNext();
          s.showFirst();
          s.showLast();
         
   }
   
}