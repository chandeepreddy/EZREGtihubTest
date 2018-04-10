public with sharing class CandidateMapfromRequirements 
{    
  public Candidate_Mapping__c coa {get;set;}
  public String oid;
  public string cid;
  public string test{get; set;}
  public List<Candidate_Mapping__c> SelectedFields {get; set;}
  public List<User> UserList {get; set;}
  public String UserId {get; set;}
  public String UserRoleId {get; set;}
  string oppid;
  string coaid;
  public integer i;
  public integer j;
  public decimal k;
  public decimal l;
  Public integer resumeUploadCount;
  public string UserEmail {get; set;}
  public List<Candidate_Mapping__c> uEmail {get; set;}

  public CandidateMapfromRequirements() 
  {
       oid = ApexPages.currentPage().getParameters().get('oid');
       system.debug('oid:' + oid);
     try
     {
        Id oid1 = System.CurrentPageReference().getParameters().get('Requirement__c.ID');
        system.debug('oid1:'+ oid1);
        
        this.oppid = System.CurrentPageReference().getParameters().get('oid');
        system.debug('oppid:'+this.oppid);
    
        SelectedFields = new List<Candidate_Mapping__c>();
        coa = new Candidate_Mapping__c();
        coa.Requirement__c = oid;
       
       
        system.debug('oid:'+ coa.Requirement__c);
        
        UserList = new List<User>();
        
        this.UserId = UserInfo.getUserId();
        System.Debug('UserId =' + UserId);
       
        string uid= UserInfo.getUserId(); 
         
          Candidate_Mapping__c uEmail = Database.query('SELECT LR_Email_ID__c,Req_Owner_Email__c,LR_Email__c FROM Candidate_Mapping__c where Requirement__c=:a');
          System.Debug(uEmail);
       
        
       
       }
         catch(system.QueryException e)
         {
      
         }
     
   }  

    public PageReference save() 
    {
        system.debug('save method');
        system.debug('oid'+coa.Requirement__c);
        
      if(coa.Requirement__c != null && coa.candidate__c != null)
                {   
                    Requirement__c Req = [select name,FTE__c from Requirement__c where id =:coa.Requirement__c];
                    Candidate__c   Can = [select name,FTE__c from Candidate__c where id =: coa.candidate__c];
                     if(Req.FTE__c == True && Can.FTE__c == False)
                    {
                           ApexPages.Message errMsg1= new ApexPages.Message(ApexPages.severity.ERROR, 'FTE Requirement Needs FTE Field in Candidate Profile to be checked');  
                           ApexPages.addMessage(errMsg1);           
                           return null;
                    }
                 
                }     
        
        if(coa.Requirement__c == null)
        {
            List<Requirement__c> req =[select Requirement__c.ID from Requirement__c LIMIT 1];
            for(Requirement__c op:req)
         {
          system.debug('opid:'+op);
           if(op!=null)
           {
             coa.Requirement__c = op.ID;
           }
         }
        }
        
        if(coa.Candidate__c == null)
        {
            List<candidate__c> can =[select Candidate__c.ID from Candidate__c LIMIT 1];
            for(Candidate__c c :can)
             {
              system.debug('cid:'+ c);
              
               if(c!=null)
               {
                coa.Candidate__c = c.ID;
                system.debug('cid:' + coa.Candidate__c);
               }
             }
        }
        
        
        Id id1 = UserInfo.getUserRoleId();
        Id id2 = UserInfo.getUserId();
        List<userrole> r1 = [Select Name from UserRole where id = :id1 limit 1];
        string p='%' + UserId + '%';
        string manageremail = 'select Manager_Email__c from user where ID =: p';
      
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
        
        List<AggregateResult> res =new List<AggregateResult>();
        
        res =[SELECT Count(Id) cntid FROM Candidate_Mapping__c where Candidate__c =: coa.Candidate__c and Requirement__c=: coa.Requirement__c];  
          for(AggregateResult ar : res)
          {
             j = Integer.valueOf(ar.get('cntid'));
          } 
          
          if (j==null)
          {
             j=0;
          }
          
          if(j == 0) 
          {  
          List<AggregateResult> val = [SELECT count(Candidate_ID__c) cnt FROM ContentVersion Where Candidate_ID__c != null and Candidate_ID__c =: coa.Candidate__c];
          
          for(AggregateResult ar1 : val)
          {
               i = Integer.valueOf(ar1.get('cnt'));
          }
            /*Below 5 lines of code added by Shahida Kalluri*/
            /*Line of code is to check the resumes uploaded through files for the candidate*/
          List<AggregateResult> candResumeFileUploadCount=EZRE_Requirement_DataUtility.getResumeAttachedThroughFiles(coa.Candidate__c);
           
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
                  If( l != k)

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
                   ApexPages.Message errMsg1= new ApexPages.Message(ApexPages.severity.ERROR, 'This corresponding requirement is either closed already or the necessary candidates are mapped');  
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
      
        system.debug('coa:'+coa);
       PageReference acctPage = new PageReference('/a0k/o');
       
        System.Debug('test123');
        acctPage.setRedirect(true);
        return acctPage;
            }
    
    public PageReference saveNew() 
    {
        if(coa.Requirement__c != null && coa.candidate__c != null)
        {   
                    Requirement__c Req = [select name,FTE__c from Requirement__c where id =:coa.Requirement__c];
                    Candidate__c   Can = [select name,FTE__c from Candidate__c where id =: coa.candidate__c];
                     if(Req.FTE__c == True && Can.FTE__c == False)
                    {
                           ApexPages.Message errMsg1= new ApexPages.Message(ApexPages.severity.ERROR, 'FTE Requirement Needs FTE Field in Candidate Profile to be checked');  
                           ApexPages.addMessage(errMsg1);           
                           return null;
                    }
                 
         }     
        if(coa.Candidate__c==null)
        {
            for(Candidate__c c : [select Candidate__c.ID from Candidate__c LIMIT 1])
             {
              system.debug('cid:'+ c);
               if(c!=null)
               {
                coa.Candidate__c = c.ID;
               }
             }
        }
        if(coa.Requirement__c==null)
        {
            for(Requirement__c op: [select Requirement__c.ID from Requirement__c LIMIT 1])
         {
          system.debug('opid:'+op);
           if(op!=null)
           {
             coa.Requirement__c = op.ID;
           }
         }
        }
        
 
  Id id1 = UserInfo.getUserRoleId();
        Id id2 = UserInfo.getUserId();
        for(UserRole ur :[Select Name from UserRole where id = :id1])
        {
        system.debug('Role:' +ur);
        
        if(ur.Name == 'Recruiter' || ur.Name == 'R Chatter Only user')
        {
            coa.status1__c = 'Applied';
             user ru = [select Email from user where userroleid = :ur.Id and id = :id2];
             system.debug('ru:' + ru);
        coa.R_Email__c = ru.email;
        system.debug('r_email:' + coa.R_Email__c );
        string u='%' + UserId + '%';
        string b = 'select Manager_Email__c from user where ID =: u';
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
    
      List<AggregateResult> res =[SELECT Count(Id) cntid FROM Candidate_Mapping__c where Candidate__c =: coa.Candidate__c and Requirement__c=: coa.Requirement__c];  
      for(AggregateResult ar : res)
      {
         j = Integer.valueOf(ar.get('cntid'));
      } 
      
      if(j == 0) 
      {  
      List<AggregateResult> val = [SELECT count(Candidate_ID__c) cnt FROM ContentVersion Where Candidate_ID__c != null and Candidate_ID__c =: coa.Candidate__c];
      for(AggregateResult ar1 : val)
      {
           i = Integer.valueOf(ar1.get('cnt'));
      }
      /*Below 5 lines of code added by Shahida Kalluri*/
      /*Line of code is to check the resumes uploaded through files for the candidate*/
     List<AggregateResult> candResumeFileUploadCount=EZRE_Requirement_DataUtility.getResumeAttachedThroughFiles(coa.Candidate__c);
     
      for(AggregateResult ar: candResumeFileUploadCount)
      {
        resumeUploadCount=Integer.valueOf(ar.get('fileUploadResume'));
     }
      if(i > 0  || resumeUploadCount>0)
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
      
        PageReference acctPage = ApexPages.currentPage();
        acctPage.setRedirect(true);
        return acctPage;    
    }

    public PageReference cancel() 
    {        
        PageReference pg=new PageReference('/a0k/o'); 
        
         pg.setRedirect(true);
        return pg;
        } 
}