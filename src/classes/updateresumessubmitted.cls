public class updateresumessubmitted
{

    /* public class testrequirement 
     {
         public String reqid;
         public integer count;
     }
     
     public String reqid;
     Public Id reqmtid;
     public List<testrequirement> lsttestrequirement ;

     public Integer rescount1;
     
     List<AggregateResult> aggresult;
     set<Id> RequirementIds = new Set<Id>();
     
     public List<Candidate_Mapping__c> coa {get; set;}   
     public List<requirement__c> req {get;set;}
     public List<requirement__c> req1 {get;set;}
     List<ID> refAccs = new List<ID> ();
     
     public PageReference updateresumessubmitted() 
     {                     
               
                    req1 = [select id ,name, cumulative_resumes_submitted__c,submitted_resumes__c from requirement__c where (Status__c!='re-open' and Status__c!='open') and (resumes_submitted__c = 0) and createddate <=2013-09-25T00:00:00.000+0000 limit 100];   
                    System.Debug('req1'+ req1); 
                              
                    for(requirement__c req : req1)
                    { 
                                    
                     req.cumulative_resumes_submitted__c = 0;
                     req.submitted_resumes__c = 0;
                     update req;

                     }
                   return null;    
        } */
     
   }