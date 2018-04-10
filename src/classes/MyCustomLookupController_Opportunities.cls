public with sharing class MyCustomLookupController_Opportunities 
{    
  public CandidateOpportunityAssociation__c coa {get;set;}
  public String oid;
  public string test{get; set;}
  public List<CandidateOpportunityAssociation__c> SelectedFields {get; set;}
  string oppid;
  string coaid;
  public MyCustomLookupController_Opportunities() 
  {
     try
     {
        String oid = System.CurrentPageReference().getParameters().get('CF00N400000022LFE');
        this.oppid = System.CurrentPageReference().getParameters().get('Opportunity.ID');
        system.debug('oppid:'+this.oppid);
        SelectedFields = new List<CandidateOpportunityAssociation__c>();
        coa = new CandidateOpportunityAssociation__c();
    
        coa.OpportunityId__c = oid;
        string a ='select Manager_Email_ID__c,OpportunityId__c from CandidateOpportunityAssociation__c where CandidateOpportunityAssociation__c.OpportunityId__c= \'' + oid+ '\'';
        //string a = 'SELECT Manager_Email__c from User where id = \'' + cid + '\'';
        System.Debug('a1 :' + a);
        SelectedFields = Database.Query(a);
        if(SelectedFields.size() > 0)
        {
             coa.Manager_Email_ID__c = SelectedFields[0].Manager_Email_ID__c;
             System.Debug('a1 =' + coa.Manager_Email_ID__c);
        }
        else  
        { 
            coa.Manager_Email_ID__c = '';
            System.Debug('a1 =' + coa.Manager_Email_ID__c);
        }
       }
         catch(system.QueryException e)
         {
      
         }
     
   }  

    public PageReference save() 
    {
        system.debug('cid'+coa.CandidateId__c);
        system.debug('oid'+coa.OpportunityId__c);
        if(coa.CandidateId__c==null)
        {
            for(Candidate__c c : [select Candidate__c.ID from Candidate__c LIMIT 1])
             {
              system.debug('cid:'+c);
               if(c!=null)
               {
                coa.CandidateId__c = c.ID;
               }
             }
        }
        if(coa.OpportunityId__c==null)
        {
            for(Opportunity op: [select Opportunity.ID from Opportunity LIMIT 1])
         {
          system.debug('opid:'+op);
           if(op!=null)
           {
             coa.OpportunityId__c = op.ID;
           }
         }
        }
        insert coa;
        system.debug('coa:'+coa);
        //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, aId));
        //return new PageReference('/a09/o/');
        //PageReference acctPage = new ApexPages.StandardController(coa).view();
        
        //PageReference acctPage = new PageReference('/a0k/o');
        //coaid = [select Id from CandidateOpportunityAssociation__c where  ];
        PageReference acctPage = new PageReference('/'+coa.id);
        System.Debug('test123');
        acctPage.setRedirect(true);
        return acctPage;
            }
    
    public PageReference saveNew() 
    {
        
        insert coa;
        PageReference acctPage = ApexPages.currentPage();
        acctPage.setRedirect(true);
        return acctPage;    
    }

    public PageReference cancel() {        
        //PageReference pageRef =  new PageReference('/a0k/o');
        ////PageReference pageRef = ApexPages.currentPage();
        //pageRef.setRedirect(true);
        //return null; //pageRef ;    
         PageReference pg=new PageReference('/a0k/o');
        
           pg.setRedirect(true);
       
          
        
        return pg;
        } 
}