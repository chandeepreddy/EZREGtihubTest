public with sharing class CandidateMapfromCandidates 
{ 
  public String showMessage { get; set; }
   
  public Candidate_Mapping__c coa {get;set;}
  public String cid;
  public string test{get; set;}
  public List<Candidate_Mapping__c> SelectedFields {get; set;}
  string canid;
  string coaid;
  string candidateRecordId;
  public List<User> UserList {get; set;}
  public String UserId {get; set;}
   public String UserRoleId {get; set;}
  public integer i;
  Public integer resumeUploadCount;
  public integer j;
  public decimal k;
  public decimal l;
  String canidateRecordURL= URL.getSalesforceBaseUrl().toExternalForm()+'/'; 
  public CandidateMapfromCandidates () 
  {
     cid = ApexPages.currentPage().getParameters().get('cid');
     system.debug('cid:'+cid);
     try
     {

        this.cid = ApexPages.currentPage().getParameters().get('cid');
        
        System.Debug('cid:nullchecking =' + this.cid);
        this.canid= System.CurrentPageReference().getParameters().get('Candidate__c.ID');
        system.debug('canid:'+this.canid);
        candidateRecordId=this.canid;
        SelectedFields = new List<Candidate_Mapping__c>();
        coa = new Candidate_Mapping__c();
        coa.Candidate__c =cid;   
        UserList = new List<User>();
        
        this.UserId = UserInfo.getUserId();
        System.Debug('UserId =' + UserId);
        

       }
         catch (system.QueryException e)
         {
      
         }
   }  
    public PageReference save() 
    {
      try
     {
       
        system.debug('LR STatus:' + coa.LR_Status__c);
        system.debug('save method');
        system.debug('cid'+coa.Candidate__c);
        system.debug('oid'+coa.Requirement__c);
        if(coa.Candidate__c == null)
        {   List<candidate__c> can = [select Candidate__c.ID from Candidate__c LIMIT 1];
            for(Candidate__c c : can)
             {
              system.debug('testc:'+ c);
             if(c!= null)
               {
                coa.Candidate__c = c.ID;
               }
             }
        }
        if(coa.Requirement__c == null)
        {
            List<requirement__c> req =[select Requirement__c.ID from Requirement__c LIMIT 1];
            for(Requirement__c op:req)
         {
          system.debug('opid:'+ op);
           if(op!= null)
           {
             coa.Requirement__c = op.ID;
             System.Debug('coa.Requirement__c :' +coa.Requirement__c);
           }
         }
        }
        
        Id id1 = UserInfo.getUserRoleId();
        Id id2 = UserInfo.getUserId();
        List<userrole> r1 = [Select Name from UserRole where id = :id1 limit 1];
       String  s='%' + UserId + '%'; 
       string manageremail = 'select Manager_Email__c from user where ID =:s';      
        for(UserRole ur : r1)
        { 
        system.debug('Role:' +ur);
        
         if(ur.Name == 'Recruiter' || ur.Name == 'R Chatter Only user')
         {
            coa.status1__c = 'Applied';
            string b = manageremail;             
            System.Debug('B =' + b);
            UserList = Database.Query(b);    
            System.Debug('SelectedFields2 =' + UserList);
            if(UserList.size() > 0)
             {
               coa.Manager_Email_ID__c = UserList[0].Manager_Email__c;         
               system.debug('coa.Manager_Email_ID__c='+coa.Manager_Email_ID__c);
             }
         }     

        if(ur.Name == 'Lead Recruiter' || ur.Name == 'LR Chatter Only user')
          {         
            user lru = [select Email from user where userroleid = :ur.Id and id = :id2];
            system.debug('lru:' + lru);
            coa.LR_Email__c = lru.email;
            system.debug('lr_email:' + coa.LR_Email__c );
          } 
         
        if(ur.Name == 'Vice President' || ur.Name == 'Business Development Manager' || ur.Name =='Management Representative' || ur.Name =='Business Development Executive')
          {    
            user mru = [select Email from user where userroleid = :ur.Id and id = :id2];
            system.debug('mru:' + mru);
            coa.MR_Email__c= mru.email;
            system.debug('mr_email:' + coa.MR_Email__c);
          }  
        }  
      List<AggregateResult> res =[SELECT Count(Id) cntid FROM Candidate_Mapping__c where Candidate__c =:coa.Candidate__c and Requirement__c=:coa.Requirement__c];  
      for(AggregateResult ar : res)
      {
         j = Integer.valueOf(ar.get('cntid'));         
      } 
      System.Debug('jcount:'+j);
      system.debug('jcount:'+res);
      system.debug('jcount:'+coa.Candidate__c); 
      system.debug('jcount:'+coa.Requirement__c);  
    
      if (j==null)
      {
         j=0;
      }
      if(j == 0) 
      {       
      List<AggregateResult> val = [SELECT count(Candidate_ID__c) cnt FROM ContentVersion Where Candidate_ID__c != null and Candidate_ID__c =:coa.Candidate__c];
      List<AggregateResult> candResumeFileUploadCount=EZRE_Requirement_DataUtility.getResumeAttachedThroughFiles(coa.Candidate__c);
      for(AggregateResult ar1 : val)
      {
           i = Integer.valueOf(ar1.get('cnt'));
      }
      for(AggregateResult ar: candResumeFileUploadCount)
      {
         resumeUploadCount=Integer.valueOf(ar.get('fileUploadResume'));
      }
      
      
      system.debug('icheck:'+i);
      if(i > 0 || resumeUploadCount>0)
      {
                     
             List<Requirement__c> req1 =  [Select Submitted_Resumes__c,No_Of_Resumes__c FROM Requirement__c where (Requirement__c.Status__c != 'Auto Closed' or Requirement__c.Status__c != 'Manually Closed') and Requirement__c.ID =:coa.Requirement__c];
             for(requirement__c ar4 : req1 )
              {
                  l = ar4.Submitted_Resumes__c;
                 system.debug('l1:'+ l);
                 k = ar4.No_Of_Resumes__c;
                  system.debug('k1:'+ k);
              }
              If(l != k) 
              {
                
                insert coa;   
                if(coa.MR_Status__c == 'Approved')
                {
                     sendemailwithattachment se = new sendemailwithattachment();
                  se.sendemail(coa.id);
                } 
              }
              else
              {
                ApexPages.Message errMsg1= new ApexPages.Message(ApexPages.severity.ERROR, 'This corresponding requirement is closed already');  
                ApexPages.addMessage(errMsg1);
                System.Debug('ApexPages.Addmessage3:');           
                return null;                                
              }
             System.Debug('ApexPages.Addmessage1:');       

       } 
       else
           {
                ApexPages.Message errMsg= new ApexPages.Message(ApexPages.severity.ERROR, 'Resume must be attached');  
                ApexPages.addMessage(errMsg);
                System.Debug('ApexPages.Addmessage2:');           
                return null;                                
            }
        
        }
        else
        {
            ApexPages.Message errMsg= new ApexPages.Message(ApexPages.severity.ERROR, 'Already this Candidate and requirement combination is available ');  
                ApexPages.addMessage(errMsg);
                System.Debug('ApexPages.AddmessageCOA Addition:');           
                return null;                                
           
        }      
         system.debug('canidateRecordURL' +canidateRecordURL);
 
         PageReference acctPage = new PageReference('/'+coa.id);     
         acctPage.setRedirect(true);
         return acctPage;         
       }
        catch(system.QueryException e)
         {
            return null;
         }
    }
    public PageReference saveNew() 
    {
        try
        {
            if(coa.Candidate__c == null)
            {
                for(Candidate__c c : [select Candidate__c.ID from Candidate__c  order by Candidate__c.ID desc limit 1])
                 {
                  system.debug('testc:'+ c);
                 if(c!= null)
                   {
                    coa.Candidate__c = c.ID;
                   }
                 }
            }
            if(coa.Requirement__c == null)
            {
                for(Requirement__c op: [select Requirement__c.ID from Requirement__c order by Requirement__c.id desc LIMIT 1])
             {
              system.debug('opid:'+ op);
               if(op!= null)
               {
                 coa.Requirement__c = op.ID;
               }
             }
            }
        
            system.debug('Testcc:'+ coa.Candidate__c+','+coa.Requirement__c);

            Id id1 = UserInfo.getUserRoleId();
            Id id2 = UserInfo.getUserId();
          for(UserRole ur :[Select id, Name from UserRole where id = :id1])
          {
            system.debug('Role:' +ur);
        
            if(ur.Name == 'Recruiter' || ur.Name == 'R Chatter Only user')
            {
                coa.status1__c = 'Applied';
                user ru = [select Email from user where userroleid = :ur.Id and id = :id2];
                system.debug('ru:' + ru);
                coa.R_Email__c = ru.email;
                system.debug('r_email:' + coa.R_Email__c );
                string k = '%' + UserId + '%';          
                string b = 'select Manager_Email__c from user where ID =: k' ;
                System.Debug('B =' + b);
                UserList = Database.Query(b);    
                System.Debug('SelectedFields2 =' + UserList);
                if(UserList.size() > 0)
                 {
                   coa.Manager_Email_ID__c = UserList[0].Manager_Email__c;
                   system.debug('coa.Manager_Email_ID__c='+coa.Manager_Email_ID__c);
                 }
            } 
           if(ur.Name == 'Lead Recruiter' || ur.Name == 'LR Chatter Only user')
            {    
                 user lru = [select Email from user where userroleid = :ur.Id and id = :id2];
                 system.debug('lru:' + lru);
                 coa.LR_Email__c = lru.email;
                 system.debug('lr_email:' + coa.LR_Email__c );
                 Id lrid = userinfo.getuserid();
               
                List<RequirementAssignment__c> assignreq = new List<RequirementAssignment__c>();
                assignreq = [select Lead_Recruiter__c,recruiter__c,Requirement_Owner__c,createdbyid from RequirementAssignment__c where Requirement__c =:coa.requirement__c and recruiter__c =:coa.createdbyid];

                for(integer k=0; k<assignreq.size(); k++)
                {
                    if(assignreq[k].Lead_Recruiter__c != lrid)
                    {
                        ApexPages.Message errMsg= new ApexPages.Message(ApexPages.severity.ERROR, 'Appropriate LR has to approve/reject the candidate');  
                        ApexPages.addMessage(errMsg);
                        System.Debug('ApexPages.Addmessage2:');           
                        return null; 
                        
                    }
                    
                    if(coa.lr_id__c ==null)
                    {
                       coa.lr_id__c = lrid;
                    }
                   
                }
            } 
            if(ur.Name == 'Vice President' || ur.Name == 'Business Development Manager' || ur.Name =='Management Representative' || ur.Name =='Business Development Executive')
           {    
                user mru = [select Email from user where userroleid = :ur.Id and id = :id2];
                system.debug('mru:' + mru);
                coa.MR_Email__c= mru.email;
                system.debug('mr_email:' + coa.MR_Email__c);
           } 
          }
          List<AggregateResult> res =[SELECT Count(Id) cntid FROM Candidate_Mapping__c where Candidate__c =:coa.Candidate__c and Requirement__c=:coa.Requirement__c];  
          system.debug('Testcc:'+res);
          for(AggregateResult ar : res)
          {
             j = Integer.valueOf(ar.get('cntid'));
          } 
          
          System.Debug('jcount1:'+j);
          system.debug('jcount11:'+res);
         system.debug('jcount:'+coa.Candidate__c);
      
          system.debug('jcount1:'+coa.Requirement__c);      

          system.debug('testj:'+j);       
          if (j==null)
          {
           j=0;
          }
          if(j == 0) 
          {  
              List<AggregateResult> val = [SELECT count(Candidate_ID__c) cnt FROM ContentVersion Where Candidate_ID__c != null and Candidate_ID__c =:coa.Candidate__c];
              List<AggregateResult> candResumeFileUploadCount=EZRE_Requirement_DataUtility.getResumeAttachedThroughFiles(coa.Candidate__c);
              
              for(AggregateResult ar1 : val)
              {
                   i = Integer.valueOf(ar1.get('cnt'));
              }
              for(AggregateResult ar: candResumeFileUploadCount)
             {
             resumeUploadCount=Integer.valueOf(ar.get('fileUploadResume'));
             }
             if(i > 0 || resumeUploadCount>0)
             {
               
                 List<Requirement__c> req1 =  [Select Submitted_Resumes__c,No_Of_Resumes__c FROM Requirement__c where (Requirement__c.Status__c != 'Auto Closed' or Requirement__c.Status__c != 'Manually Closed') and Requirement__c.ID =:coa.Requirement__c];
                 for(requirement__c ar4 : req1 )
                  {
                      l = ar4.Submitted_Resumes__c;
                     system.debug('l1:'+ l);
                     k = ar4.No_Of_Resumes__c;
                      system.debug('k1:'+ k);
                  }
                  If(l != k)             
                  {
                    insert coa;    
                  }
                  else
                  {
                    ApexPages.Message errMsg1= new ApexPages.Message(ApexPages.severity.ERROR, 'This corresponding opportunity is closed already');  
                    ApexPages.addMessage(errMsg1);
                    System.Debug('ApexPages.Addmessage3:');           
                    return null;                                
                  }
                 System.Debug('ApexPages.Addmessage1:');                         
            } 
            else
            {
                ApexPages.Message errMsg= new ApexPages.Message(ApexPages.severity.ERROR, 'Resume must be attached');  
                ApexPages.addMessage(errMsg);
                System.Debug('ApexPages.Addmessage2:');           
                return null;                                
            }
            
          }
            else
            {
                ApexPages.Message errMsg= new ApexPages.Message(ApexPages.severity.ERROR, 'Already this Candidate and Opportunity combination is available ');  
                ApexPages.addMessage(errMsg);
                System.Debug('ApexPages.AddmessageCOA Addition:');           
                return null;                                
               
            }      
            PageReference acctPage =ApexPages.currentPage();
            acctPage.setRedirect(true);
            return acctPage;        
        }
        catch(system.QueryException e)
        {    
           return null;  
        }        
    }
        public PageReference cancel() 
        {        
            PageReference pg=new PageReference('/a0k/o'); 
            pg.setRedirect(true);        
            return pg;
        } 
}