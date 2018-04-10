@isTest
private class TestTriggerCandidateMapping
 {   
  static testMethod void myUnitTest()
   {         
        //  ContentVersion cv = new ContentVersion();  
         // cv.Id ='068f00000004vDOAAY'; //'068f00000004sHZAAY';    //'068400000001PPgAAM'; //  
         // cv.Candidate_ID__c = c.id; //'a0kf0000000Tt6tAAC'; //'a0kf0000000JnGGAA0';      //'a0k40000001ONveAAG'; // 
         // system.test.startTest();
        //  update cv; 
        // system.test.stopTest();
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
        //system.test.startTest();         
         insert c;
    
        Candidate__c can = [Select Id,LastModifiedById from Candidate__c where Id =: c.Id limit 1];      
        ContentWorkspace library = [SELECT id FROM ContentWorkspace LIMIT 1];
        ContentVersion contentVersionObj = new ContentVersion();
        contentVersionObj.ContentURL = 'http://www.google.com';
        contentVersionObj.title = 'Google';
        //contentVersionObj.Enablement_Area__c = 'Acct Mgmt';
        contentVersionObj.FirstPublishLocationId = library.id;
        contentVersionObj.Candidate_Id__c = can.Id;
        //system.test.startTest(); 
        insert contentVersionObj;
        //system.test.stopTest();

         if(c.id != null)
         {
           c.id = contentVersionObj.Candidate_Id__c;
           c.Resume_Attach__c =contentVersionObj.id;
         }
         update c;
        
           
   }  
   ///<OBJECTIVE>
   //Method to test update functionality of 'trigCandidateMapping' trigger
   ///<OBJECTIVE>
    static testMethod void getPopulateAssgnReqId()
    {  
       //Insert requirement record
        Requirement__c req = EZRE_DataFactory_Test_Utility.createReqWthCtgr('Salesforce','20',200,250,400,'Open','Contract','DC','In-Person',20,'Hyderabad',
                                               date.today(),'c','c','c','Active');
        //Insert Candidate record
        Candidate__c can = EZRE_DataFactory_Test_Utility.createActCan('TestCandidate','testing','chennai','Maine','Male','testEmployee',
                                                     'test@gmail.com','Mobile Phone','Corp to Corp','H1 B',100,'9176904882',
                                                     'test@gmail.com','TestContact','8143847962','jyothi','(326) 044-6881',date.today(),'c', 'Open', 'Active');
        //Insert Mailchimp Custom settings
        Mailchimp_Details__c objMCDtl = EZRE_DataFactory_Test_Utility.createMCCustomSettingLimit('MCAccount','TestAPIKey','us9', 'C48756', 'A23545',10); 
        
        //Fetch library data.
        List<ContentWorkspace> lstLibrary = EZRE_DataFactory_Test_Utility.fetchContent();
    
        if(lstLibrary != NULL && !lstLibrary.isEmpty())
        {
            //Insert ContentVersion record
            ContentVersion contentVersionObj = EZRE_DataFactory_Test_Utility.createContVer(lstLibrary[0].id,can.Id,Blob.valueOf('Data'),'http://www.google.com','Salesforce');

            System.assertEquals(req.Name,contentVersionObj.Title);

            Id [] fixedSearchResults= new Id[4];
            fixedSearchResults[0] = can.Id;
            fixedSearchResults[1] = req.Id;
            fixedSearchResults[2] = lstLibrary[0].Id;
            fixedSearchResults[3] = contentVersionObj.Id;
            Test.setFixedSearchResults(fixedSearchResults); 

            //Fetch Lead Recruiter profile
            Profile profile = EZRE_DataFactory_Test_Utility.fetchProfile(); 
         

            //Insert User record
            User objUser = EZRE_DataFactory_Test_Utility.createUser('standt','standarduser@testorg.com','UTF-8','Testing','en_US','en_US',profile.Id,'America/Los_Angeles','indhu_r@gmail.com','8143847962');

            //Insert Assign Requirement record     
            RequirementAssignment__c reqAssgn = EZRE_DataFactory_Test_Utility.createAssignmentReq(req.Id,objUser.Id); 
            System.runAs(objUser)
            {
                Candidate_Mapping__c coa =new Candidate_Mapping__c();            
                coa.status1__c = 'Applied';
                coa.Employer_s_Authorization__c = 'test';  
                coa.LR_Comments__c = 'test by lr';
                coa.MR_Comments__c = 'test by MR'; 
                coa.Requirement_Owner_Email__c = 'testOwner1@preludesys.com';
                coa.Manager_Email_ID__c = 'testOwner1@preludesys.com';          
                coa.R_Comments__c = '';                      
                coa.LR_Status__c = 'Rejected'; 
                coa.MR_Status__c = 'Rejected'; 
                coa.LR_Status_Date__c = DateTime.now().format('MM-dd-yyyy  hh:mm a z', 'America/Los_Angeles');
                coa.MR_Status_Date__c = DateTime.now().format('MM-dd-yyyy  hh:mm a z', 'America/Los_Angeles');      
                coa.Candidate__c=can.id;
                coa.Requirement__c=req.id;    
                insert coa; 
                String assgnReqId=EZRE_DataFactory_Test_Utl.getCandMapAssgnReqId(reqAssgn.id);
                Test.startTest();
                System.assertEquals(assgnReqId,reqAssgn.id);
                Test.stopTest();
           }    
       
        }
        
        
    }    
 }