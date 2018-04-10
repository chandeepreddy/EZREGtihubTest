public with sharing class MyCustomLookupController 
{    
  public CandidateOpportunityAssociation__c coa {get;set;}
  public String cid;
  public string test{get; set;}
  public List<CandidateOpportunityAssociation__c> SelectedFields {get; set;}
  string canid;
  string coaid;
  public List<User> UserList {get; set;}
  public String UserId {get; set;}

  public MyCustomLookupController () 
  {
     try
     {
        //this.cid= System.CurrentPageReference().getParameters().get('Candidate__c.ID');
        
        //if(cid==null)
        //{
          
        //cid = System.CurrentPageReference().getParameters().get('CF00N400000022LF9');
        this.cid = ApexPages.currentPage().getParameters().get('CF00N400000022LF9');

        System.Debug('cid:nullchecking =' + this.cid);
        this.canid= System.CurrentPageReference().getParameters().get('Candidate__c.ID');
        system.debug('canid:'+this.canid);
       
        SelectedFields = new List<CandidateOpportunityAssociation__c>();
        coa = new CandidateOpportunityAssociation__c();
        coa.CandidateId__c= cid;
       /* string a ='select Manager_Email_ID__c,CandidateId__c from CandidateOpportunityAssociation__c where CandidateOpportunityAssociation__c.CandidateId__c= \'' + cid+ '\'';
        //string a = 'SELECT Manager_Email__c from User where id = \'' + cid + '\'';
        System.Debug('a1 :' + a);
        SelectedFields = Database.Query(a);*/
        UserList = new List<User>();
        
        this.UserId = UserInfo.getUserId();
        System.Debug('UserId =' + UserId);
        string b = 'select Manager_Email__c from user where ID = \'' + UserId + '\'' ;
        System.Debug('B =' + b);
        UserList = Database.Query(b);    
        System.Debug('SelectedFields2 =' + UserList);
        if(UserList.size() > 0)
         {
           coa.Manager_Email_ID__c = UserList[0].Manager_Email__c;
           system.debug('coa.Manager_Email_ID__c='+coa.Manager_Email_ID__c);
         }
        /* else
         {
           //coa.Manager_Email_ID__c = null;
         }

       
      if(SelectedFields.size() >= 0)
        {
             coa.Manager_Email_ID__c = SelectedFields[0].Manager_Email_ID__c;
             System.Debug('a1 =' + coa.Manager_Email_ID__c);
        }
        else  
        { 
            coa.Manager_Email_ID__c = '';
            System.Debug('a1 =' + coa.Manager_Email_ID__c);
        }*/
       }
       
         catch(system.QueryException e)
         {
      
         }
     
   }  

    public PageReference save() 
    {
      
        system.debug('save method');
        system.debug('cid'+coa.CandidateId__c);
        system.debug('oid'+coa.OpportunityId__c);
        if(coa.CandidateId__c == null)
        {
            for(Candidate__c c : [select Candidate__c.ID from Candidate__c LIMIT 1])
             {
              system.debug('cid:'+ c);
             if(c!= null)
               {
                coa.CandidateId__c = c.ID;
               }
             }
        }
        if(coa.OpportunityId__c == null)
        {
            for(Opportunity op: [select Opportunity.ID from Opportunity LIMIT 1])
         {
          system.debug('opid:'+ op);
           if(op!= null)
           {
             coa.OpportunityId__c = op.ID;
           }
         }
        }
        insert coa;
        system.debug('coa:' + coa);
        //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, aId));
        //return new PageReference('/a09/o/');
        //PageReference acctPage = new ApexPages.StandardController(coa).view();
        
        //PageReference acctPage = new PageReference('/a0k/o');
        //coaid = [select Id from CandidateOpportunityAssociation__c where  ];
        PageReference acctPage = new PageReference('/'+ coa.id);
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
        
         PageReference pg=new PageReference('/a0k/o');
        
           pg.setRedirect(true);
       
          
        
        return pg;
        } 
}