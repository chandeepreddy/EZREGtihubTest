public with sharing class CandidateMapfromCandidatesEdit
{ 
  public static boolean calledOnce = false;
  public List<Candidate_Mapping__c> uEmail { get; set; }
  public User uEmailR {get; set;}
  public string MREmail {get; set;}
  public string LREMail {get; set;}
  public string REmail {get; set;}   
  public string subCandidate {get; set;} 
  public DateTime MRDate2 {get; set;}  
  public DateTime MRDate3 {get; set;}  
  public date candidatstarteddate {get;set;}
                       
  public string strConvertedDate {get; set;}  
  public string strConvertedMRDate {get; set;}              
  public string strSubmitToClient {get; set;}              
  public string strInterviewScheduled {get; set;}              
  public string strInterviewAccepted {get; set;}              
  public string strClientInterview {get; set;}              
  public string strClientOffer {get; set;}    
  public string strCandidateStarted {get; set;}   
  
  public Candidate__c can {get; set;}
   public Candidate__c candidate {get; set;}
  public String showMessage { get; set; }   
  public Candidate_Mapping__c coa {get; set;}     
  public Candidate_Mapping__c cm {get; set;}    
  public String cid;
  public List<Candidate_Mapping__c> SelectedFields {get; set;}
  string canid;
  string MRStatusValue; 
  public List<User> UserList {get; set;}
  public String UserId {get; set;}
  public String UserRoleId {get; set;}
  public UserRole ur1 {get;set;}
  public integer i;
  public integer j;
  public integer k;
  public List<Candidate_Mapping__c> cmc {get; set;}
  List<AggregateResult> res = new List<AggregateResult>();    

  
public CandidateMapfromCandidatesEdit () 
  {
       cid = ApexPages.currentPage().getParameters().get('cid');
        system.debug('cid:'+cid);
     try
     {

        this.cid = ApexPages.currentPage().getParameters().get('cid');

        System.Debug('cid:nullchecking =' + this.cid);
        this.canid= System.CurrentPageReference().getParameters().get('Candidate__c.ID');
        system.debug('canid:'+this.canid);
       
        SelectedFields = new List<Candidate_Mapping__c>();
        coa = new Candidate_Mapping__c();
        coa.Candidate__c =cid;
        UserList = new List<User>();
        
        this.UserId = UserInfo.getUserId();
        System.Debug('UserId =' + UserId);
        
        coa =[SELECT Id, LR_Status__c, Requirement__c, Status1__c,LR_Status_Date__c,MR_Status_Date__c, LR_Date__c,
                 Candidate__c, MR_Status__c,Requirement_Owner_Email__c, R_Comments__c, LR_Comments__c, MR_Comments__c, 
                 Employer_s_Authorization__c, Manager_Email_ID__c, Submitted_to_Client__c, Submitted_to_Client_Date__c,
                 Interview_Scheduled__c, Interview_Scheduled_Date__c, Interview_Accepted__c, Interview_Accepted_Date__c, 
                 Client_Offered__c, Client_Offer_Date__c, Comments__c, Client_Interviewed__c, Client_Interview_Date__c, 
                 Candidate_started__c, CreatedDate,started_date__c, LR_Email__c,lr_id__c, CreatedById, Name, Last_Name__c,Contract_End_Date__c,MR_Status_date1__c FROM 
                 Candidate_Mapping__c where id =:cid ]; 
                 
                 
              
               uEmailR = [Select Email,Manager_Email__c FROM User WHERE ID =:coa.CreatedById];       
         can = [Select Name,CreatedDate From Candidate__c WHERE ID =:coa.Candidate__c];  
          subCandidate =string.Valueof(can.Name) + ' ' + string.Valueof(coa.Last_Name__c);        
         REmail = uEmailR.Email;          
         LREmail = uEmailR.Manager_Email__c;         
         MREmail = string.Valueof(coa.Requirement_Owner_Email__c); 
         
         strCandidateStarted = coa.started_date__c;
              
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
        
        /* if(coa.started_date__c != null)
         {
         candidatstarteddate = Date.valueof(coa.started_date__c);
         system.debug('candidatstarteddate:'+ candidatstarteddate );
           }*/
           
        

        if(coa.Candidate__c == null)
        {
            List<candidate__c> can1 = [select Candidate__c.ID,Candidate__c.contract_end_date__c from Candidate__c LIMIT 1];
            for(Candidate__c c : can1)
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
            List<Requirement__c> req1= [select Requirement__c.ID from Requirement__c LIMIT 1];
            for(Requirement__c op: req1)
             {
                system.debug('opid:'+ op);
                if(op!= null)
                {
                  coa.Requirement__c = op.ID;
                  System.Debug('coa.Requirement__c :' +coa.Requirement__c);
                }
             }
        }
        
        
   
        
          candidate = [Select Name,CreatedDate From Candidate__c WHERE ID =:coa.Candidate__c];
          
          Date candidatestartdate = date.today();
          
          System.debug('candidatestartdate :' + candidatestartdate );
         
         if(coa.Candidate_started__c != 'Yes' && coa.Contract_End_Date__c != null)
        {
        ApexPages.Message errMsg= new ApexPages.Message(ApexPages.severity.info, 'Contract End Date should be entered only when a candidate is started');  
                ApexPages.addMessage(errMsg);
                System.Debug('ApexPages.Addmessage2:');           
                return null;               
        } 
          
          
        if(coa.Candidate_started__c == 'Yes' && coa.Contract_End_Date__c == null)
        {
        ApexPages.Message errMsg= new ApexPages.Message(ApexPages.severity.info, 'Contract End Date has to be selected');  
                ApexPages.addMessage(errMsg);
                System.Debug('ApexPages.Addmessage2:');           
                return null;               
        }
        
        else if(coa.Candidate_started__c == 'Yes' && coa.Contract_End_Date__c < candidatestartdate)
        {
           ApexPages.Message errMsg= new ApexPages.Message(ApexPages.severity.info, 'Contract End Date should be greater than candidate started date');  
                ApexPages.addMessage(errMsg);
                System.Debug('ApexPages.Addmessage2:');           
                return null;      
        }
        
        res = [SELECT Count(Id) cntid FROM Candidate_Mapping__c where Candidate__c =:coa.Candidate__c and Requirement__c=:coa.Requirement__c];  
        
        Id id1 = UserInfo.getUserRoleId();
        Id id2 = UserInfo.getUserId();
        List<userrole> r1 = [Select Name from UserRole where id = :id1 limit 1];
        string r= '%' + UserId + '%';
        string manageremail = 'select Manager_Email__c from user where ID =: r';

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
            //List<user> r2 = [Select Name from UserRole where id = :id1];  
            user lru = [select Email from user where userroleid = :ur.Id and id = :id2];
            system.debug('lru:' + lru);
            coa.LR_Email__c = lru.email;
            system.debug('lr_email:' + coa.LR_Email__c );
            
            Id lrid = userinfo.getuserid();
           
        List<RequirementAssignment__c> assignreq = new List<RequirementAssignment__c>();
        assignreq = [select Lead_Recruiter__c,recruiter__c,Requirement_Owner__c,createdbyid from RequirementAssignment__c where Requirement__c =:coa.requirement__c and recruiter__c =:coa.createdbyid];

        for(integer k=0; k<assignreq.size(); k++)
        {
            if(assignreq[k].createdbyid  != lrid)
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
 
        Candidate_Mapping__c cm = [SELECT ID, LR_Status__c,LR_Status_Date__c,MR_Status_Date__c, Requirement__c, 
                           Status1__c, Candidate__c,Requirement_Owner_Email__c, MR_Status__c, R_Comments__c, LR_Comments__c, MR_Comments__c,
                           Employer_s_Authorization__c, Manager_Email_ID__c, Submitted_to_Client__c, Submitted_to_Client_Date__c, 
                           Interview_Scheduled__c, Interview_Scheduled_Date__c, Interview_Accepted__c, Interview_Accepted_Date__c,
                           Client_Offered__c, Client_Offer_Date__c, Comments__c, Client_Interviewed__c, Client_Interview_Date__c, LR_Email__c, 
                           Candidate_started__c, started_date__c,lr_id__c, Contract_End_Date__c FROM Candidate_Mapping__c                               
                           WHERE Id = :ApexPages.currentPage().getParameters().get('cid') LIMIT 1];

        cm.R_Comments__c = coa.R_Comments__c;                     
        cm.LR_Status__c = coa.LR_Status__c;
        cm.LR_Comments__c = coa.LR_Comments__c;
        cm.MR_Status__c = coa.MR_Status__c; 
      
        cm.MR_Comments__c = coa.MR_Comments__c;
        cm.Employer_s_Authorization__c = coa.Employer_s_Authorization__c;
        cm.Manager_Email_ID__c = coa.Manager_Email_ID__c;
        cm.LR_Email__c = coa.LR_Email__c;

        cm.Submitted_to_Client__c = coa.Submitted_to_Client__c;
        cm.Interview_Scheduled__c = coa.Interview_Scheduled__c;
        cm.Interview_Accepted__c = coa.Interview_Accepted__c;
        cm.Client_Interviewed__c = coa.Client_Interviewed__c;
        cm.Client_Offered__c = coa.Client_Offered__c;
        cm.Candidate_started__c = coa.Candidate_started__c;
        cm.Comments__c = coa.Comments__c;
        cm.Contract_End_Date__c = coa.Contract_End_Date__c;
        cm.lr_id__c = coa.lr_id__c;

      /*  if(cm.MR_Status__c == 'Approved'&& cm.MR_Status_Date__c != string.ValueOf(DateTime.Now()))  //,true,false)
            {
                cm.MR_Status_Date__c = string.ValueOf(DateTime.Now());
                if(cm.MR_Status_Date__c != null)   
                    {                    
                        Datetime MRDate1 = Datetime.valueOf(cm.MR_Status_Date__c); //DateTime.Now(); 
                        System.Debug('MRDate1 :' + MRDate1);            
                    }
            } */

        update cm;      
        sendemailwithattachment se = new sendemailwithattachment();
        se.sendemail(cm.id);             
        system.debug('UpdateCheck:');       
        system.debug('coa:' + coa);
        system.debug('cm:' + cm);
        
        PageReference acctPage = new PageReference('/' + coa.candidate__c);
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