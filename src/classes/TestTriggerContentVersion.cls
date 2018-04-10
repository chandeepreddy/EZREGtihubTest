@isTest
private class TestTriggerContentVersion
 {   
  static testMethod void myUnitTest()
   {  
         /*
         Candidate__c c = new Candidate__c();
         
             c.Name = 'Testt';
             c.Last_Name__c = 'TestLast';   
             c.Current_City__c = 'Chennai';
             c.Gender__c = 'Female';    
             c.Followup_Date__c =date.today();
             c.Current_State__c = 'Oregan';   
             c.Email__c = 'mputta@gmail.com';             
             c.Interview_Contact_Phone__c = 'Mobile Phone';       
             c.Contract_Type__c = 'Corp to Corp';   
             c.Visa_Type__c = 'H1 B';                       
             //c.Resume_Attach__c ='068f00000004sHZAAY';                
             //ContentVersion co =[Select Id, Candidate_ID__c from ContentVersion where Id = '068f00000004sHZAAY' limit 1];
             //c.Resume_Attach__c = string.valueof(co.Id);
             //c.Id = 'a0kf0000000JnGGAA0';   
             c.Mobile_Phone_No__c ='9095535345';  
             c.Employer_Contact_Email__c = 'jose@gmail.com';
             c.Employer_Contact_Name_Name__c ='jose';     
             c.Employer_Name__c = 'jos'; 
             c.Employer_Work_Phone_No__c = '(425) 264-6771';  
             c.Cost__c = 60;              
         insert c;
            
    
        Candidate__c can = [Select Id,LastModifiedById from Candidate__c where Id =: c.Id limit 1];
           System.Debug('Can: ' + can);
            ContentWorkspace library = [SELECT id FROM ContentWorkspace LIMIT 1];
            System.Debug('Lib: ' + library);
            ContentVersion contentVersionObj = new ContentVersion();
            
            contentVersionObj.ContentURL = 'http://www.google.com';
            
            contentVersionObj.title = 'Google';
            
            //contentVersionObj.Enablement_Area__c = 'Acct Mgmt';
            
            contentVersionObj.FirstPublishLocationId = library.id;
            contentVersionObj.Candidate_Id__c = can.Id;
        
        
            insert contentVersionObj;

         
         List<ContentVersion> co = new List<ContentVersion>();
         co = [Select Id, Candidate_ID__c from ContentVersion limit 1];
         System.Debug('co:' + co);
         for(ContentVersion con : co)
         {
         System.Debug('con:' + con);
         ContentVersion cv = new ContentVersion();
         cv.Id = c.Id;
         //cv.Id ='068f00000004sHZAAY';
         cv.Candidate_ID__c =contentVersionObj.Candidate_ID__c; //'a0kf0000000JnGGAA0';                             
         update cv;         
         }  
         ContentVersion cv = new ContentVersion();
         cv.Id =  '068400000001PPgAAM';//'068f00000004sHZAAY';
         cv.Candidate_ID__c = 'a0k40000001ONveAAG';// 'a0kf0000000JnGGAA0';                            
         update cv; */  
   }
   static testMethod void myUnitTest1()
   {  
         Candidate__c c = new Candidate__c();
         c.Name = 'Testt';
         c.Last_Name__c = 'TestLast';   
         c.Current_City__c = 'Chennai';
         c.Gender__c = 'Female';    
         c.Followup_Date__c =date.today();
         c.Current_State__c = 'Oregan';   
         c.Email__c = 'mputta@gmail.com';             
         c.Interview_Contact_Phone__c = 'Mobile Phone';       
         c.Contract_Type__c = 'Corp to Corp';   
         c.Visa_Type__c = 'H1 B';                       
         //c.Resume_Attach__c ='068f00000004sHZAAY';                
         //ContentVersion co =[Select Id, Candidate_ID__c from ContentVersion where Id = '068f00000004sHZAAY' limit 1];
         //c.Resume_Attach__c = string.valueof(co.Id);
         //c.Id = 'a0kf0000000JnGGAA0';   
         c.Mobile_Phone_No__c ='9095535345';  
         c.Employer_Contact_Email__c = 'jose@gmail.com';
         c.Employer_Contact_Name_Name__c ='jose';     
         c.Employer_Name__c = 'jos'; 
         c.Employer_Work_Phone_No__c = '(425) 264-6771';  
         c.Cost__c = 60;              
         insert c;
         
         
         Candidate__c can = [Select Id,LastModifiedById from Candidate__c where Id =: c.Id limit 1];
         //ContentVersion cv = new ContentVersion();
         
        // cv.Candidate_Id__c = can.Id;
         //cv.ContentModifiedById = cv.LastModifiedById;  
        // insert cv;
         
         ContentWorkspace library = [SELECT id FROM ContentWorkspace LIMIT 1];

ContentVersion contentVersionObj = new ContentVersion();

contentVersionObj.ContentURL = 'http://www.google.com';

contentVersionObj.title = 'Google';

//contentVersionObj.Enablement_Area__c = 'Acct Mgmt';

contentVersionObj.FirstPublishLocationId = library.id;
contentVersionObj.Candidate_Id__c = can.Id;


insert contentVersionObj;


        
           
   }      
 }