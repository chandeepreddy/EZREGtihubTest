/**
 * @author           Shahida
 * @version          1.0 
 * @date             21/03/2016
 * @Status           Developed
 * @description      Batch class to send mail(Monthly)Requirement count and resumes submitted count based on requirement Type in Requirement 
 *
 */
 global class EZRE_RequirementMonthlyStatusReprt_Batch implements Database.Batchable<sObject>, Database.Stateful
 {
        
    public List<Requirement__c> RequirementList{get;set;}  
    public String  openStatus{get;set;}
    Public String  reopenStatus{get;set;}
    public DateTime dtFromDateTime{get;set;}      
    public DateTime dtToDateTime{get;set;}
    public integer  noOfResumesSubmitted{get;set;}
    public  set<Id> ReqIdSet{get;set;}
    public integer NoOfSubmittedResumesApp{get;set;}
    public integer NoOfSubmittedResumesRej{get;set;}
    public integer NoOfSubmittedResumesPending{get;set;}
    public integer NoOfRequirements{get;set;}  
    public Date todayDate{get;set;}
    public Date monthEndDate{get;set;}
    public Date urlEndDate{get;set;}
    public integer NoOfClientInterviews;
    public integer NoOfClientOffered;
    public integer NoOfCandStarted;
    public list<Candidate_Mapping__c> CndstrtdAssgnCand;
    public list<Candidate_Mapping__c> ClntOffrdAssgnCand;
    public list<Candidate_Mapping__c> ClntIntwedAssgnCand;
    public map<string,list<Candidate_Mapping__c>> ClntIntwedAssgnCndMap;
    public map<string,list<Candidate_Mapping__c>> ClntOffrdAssgnCandMap;
    public map<string,list<Candidate_Mapping__c>>   CndstrtdAssgnCandMap;
    
    public List<summary> SummaryReq
    {
        get
        {
            if(SummaryReq== null) 
            {
                SummaryReq= new List<summary>();
            }
            return SummaryReq;  
        }
        set;
    }
   
    //Batch start method
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        todayDate=Date.Today();
        Integer numberDays = date.daysInMonth(todayDate.year(),todayDate.month());       
        system.debug('--------------'+numberDays);
        
        Date monthStartDate= todayDate.toStartOfMonth();       
        system.debug('-------------------Month start Date'+monthStartDate);      
        dtFromDateTime=DateTime.newInstance(monthStartDate.year(),monthStartDate.month(),monthStartDate.day());          
        system.debug('------------------FromDateTime'+dtFromDateTime);   
        
        monthEndDate=monthStartDate.addDays(numberDays);
        system.debug('-------------------Month End Date'+monthStartDate.addDays(numberDays));
        urlEndDate=monthStartDate.addDays(numberDays-1);
        
        dtToDateTime=DateTime.newInstance(monthEndDate.year(),monthEndDate.month(),monthEndDate.day());                 
        system.debug('-------------------ToDateTime'+dtToDateTime);
        NoOfRequirements=0;
        NoOfSubmittedResumesApp =0;
        NoOfSubmittedResumesRej = 0;
        NoOfSubmittedResumesPending = 0;
        NoOfClientInterviews=0;
        NoOfClientOffered=0;
        NoOfCandStarted=0;
        openStatus='Open';
        reopenStatus='Re-Open';    
       //fetch all candidates modified between given date or status is'open' Or Re-open         
       return Database.getQueryLocator('Select Id,Status__c,Requirement_type__C,Name,LastModifiedDate,createddate,C_Name__c,Opportunity_Code__c,Req_Closed_Date__c,Submitted_Resumes__c,ResumesSubmitted__c,No_Of_Resumes__c FROM Requirement__c where (createdDate >: dtFromDateTime AND createdDate  <: dtToDateTime)  OR(StatusClosed_Date__c >: monthStartDate AND StatusClosed_Date__c<: monthEndDate)  OR (Status__c=:openStatus OR Status__c=:reopenStatus)');
    }

    //Batch execute method
    global void execute(Database.BatchableContext BC, List<Requirement__c> Requirementlst)
    {   
            
      system.debug('############Requirement list'+Requirementlst);
      system.debug('############Requirement list size'+Requirementlst.size());
      map<String,List<Requirement__c>> reqMap;    
      map<string,list<Candidate_Mapping__c>> ReqAssingedCandMapApp =new map<string,list<Candidate_Mapping__c>>();
      map<string,list<Candidate_Mapping__c>> ReqAssingedCandMapRej =new map<string,list<Candidate_Mapping__c>>();
      map<string,list<Candidate_Mapping__c>> ReqAssingedCandMapPending =new map<string,list<Candidate_Mapping__c>>();        
      if(Requirementlst.size()>0)
      { 
        //Create Map to have Requirements grouped by Requirement Type
          reqMap=new map<String,List<Requirement__c>>();
          ReqIdSet=new set<Id>();
          for(Requirement__c req:Requirementlst)
          {
             if(reqMap.containsKey(req.Requirement_type__c))
             {
                 reqMap.get(req.Requirement_type__c).add(req);
                 
             }
             else
             {
                 reqMap.put(req.Requirement_type__c,new list<Requirement__c>{req});
                 
             }
             ReqIdSet.add(req.Id);
          }
          system.debug('#########RequirementTypeBasedMap'+reqMap);//Building map of requirements based on requirementType(including null)
          system.debug('#########RequirementTypeBasedMap size'+reqMap.size());
          
      }
      //List of assign candidates(resumes attached to requirements) for the requirements 
      List<Candidate_Mapping__c> AssignedCandidateList=EZRE_Requirement_DataUtility.fetchAssignCandidates(dtFromDateTime,dtToDateTime,ReqIdSet);      
         //To from map that contaings assign candidates grouped by Requirement Type                         
        if(AssignedCandidateList.size()>0)
        {
        
            for(Candidate_Mapping__c AssignedCand:AssignedCandidateList)
            {  
                if(AssignedCand.Resumes_Status__c == 'Approved')
                {
                    if(ReqAssingedCandMapApp.containsKey(AssignedCand.requirement__r.Requirement_type__c))
                    {
                        ReqAssingedCandMapApp.get(AssignedCand.requirement__r.Requirement_type__c).add(AssignedCand);
                    }
                    else
                    {
                        ReqAssingedCandMapApp.put(AssignedCand.requirement__r.Requirement_type__c,new list<Candidate_Mapping__c>{AssignedCand});
                    }
                    
                }
                if(AssignedCand.Resumes_Status__c == 'Rejected')
                {
                    if(ReqAssingedCandMapRej.containsKey(AssignedCand.requirement__r.Requirement_type__c))
                    {
                        ReqAssingedCandMapRej.get(AssignedCand.requirement__r.Requirement_type__c).add(AssignedCand);
                    }
                    else
                    {
                        ReqAssingedCandMapRej.put(AssignedCand.requirement__r.Requirement_type__c,new list<Candidate_Mapping__c>{AssignedCand});
                    }
                    
                }
                if(AssignedCand.Resumes_Status__c == 'Pending Approval/Rejection')
                {
                    if(ReqAssingedCandMapPending.containsKey(AssignedCand.requirement__r.Requirement_type__c))
                    {
                        ReqAssingedCandMapPending.get(AssignedCand.requirement__r.Requirement_type__c).add(AssignedCand);
                    }
                    else
                    {
                        ReqAssingedCandMapPending.put(AssignedCand.requirement__r.Requirement_type__c,new list<Candidate_Mapping__c>{AssignedCand});
                    }
                    
                }        
            }
            system.debug('-----------ReqAssingedCandMapApp'+ReqAssingedCandMapApp);
            system.debug('-----------ReqAssingedCandMapAppsize'+ReqAssingedCandMapApp.size()); 
       } 
       //fetching assign candidates for calculating client Interviews,client offered candidates,candidate started count based on those fields get changed date to 'yes'       
        ClntIntwedAssgnCand=new list<Candidate_Mapping__c>();
        ClntOffrdAssgnCand=new list<Candidate_Mapping__c>();
        CndstrtdAssgnCand=new list<Candidate_Mapping__c>();
        ClntIntwedAssgnCndMap=new map<string,list<Candidate_Mapping__c>>();
        ClntOffrdAssgnCandMap=new map<string,list<Candidate_Mapping__c>>();
        CndstrtdAssgnCandMap=new map<string,list<Candidate_Mapping__c>>();
        ClntIntwedAssgnCand=EZRE_Requirement_DataUtility.fetchClientinvwedAssgnCand(dtFromDateTime,dtToDateTime,ReqIdSet);
        system.debug('====================assgnCndList for client interviewed Ass cand'+ClntIntwedAssgnCand);
        if(ClntIntwedAssgnCand.size()>0)
        {
           for(Candidate_Mapping__c  candMap:ClntIntwedAssgnCand)
           {
                if(candMap.Client_Interviewed__c=='yes')
                {
                    if(ClntIntwedAssgnCndMap.containsKey(candMap.requirement__r.Requirement_type__c))
                    {
                        ClntIntwedAssgnCndMap.get(candMap.requirement__r.Requirement_type__c).add(candMap);
                    }
                    else
                    {
                        ClntIntwedAssgnCndMap.put(candMap.requirement__r.Requirement_type__c,new list<Candidate_Mapping__c>{candMap});
                    }   
                }               
           }         
        }
        system.debug('ClntIntwedAssgnCndMap:====================assgnCndList for client intw Ass cand'+ClntIntwedAssgnCndMap);
        ClntOffrdAssgnCand=EZRE_Requirement_DataUtility.fetchClntOfferedAssgnCands(dtFromDateTime,dtToDateTime,ReqIdSet);
        system.debug('====================assgnCndList for client offerd Ass cand'+ClntOffrdAssgnCand);
        if(ClntOffrdAssgnCand.size()>0)
        {
            for(Candidate_Mapping__c  candMap:ClntOffrdAssgnCand)
            {
                if(candMap.Client_Offered__c=='yes')
                {
                    if(ClntOffrdAssgnCandMap.containsKey(candMap.requirement__r.Requirement_type__c))
                    {
                        ClntOffrdAssgnCandMap.get(candMap.requirement__r.Requirement_type__c).add(candMap);
                    }
                    else
                    {
                        ClntOffrdAssgnCandMap.put(candMap.requirement__r.Requirement_type__c,new list<Candidate_Mapping__c>{candMap});
                    }  
                }               
            }               
        }
        system.debug('ClntOffrdAssgnCandMap:====================assgnCndList for client off Ass cand'+ClntOffrdAssgnCandMap);         
        CndstrtdAssgnCand=EZRE_Requirement_DataUtility.fetchCandStartdAssgnCands(dtFromDateTime,dtToDateTime,ReqIdSet);
        system.debug('====================assgnCndList for cand started Ass cand'+CndstrtdAssgnCand);
        if(CndstrtdAssgnCand.size()>0)
        {
            for(Candidate_Mapping__c  candMap:CndstrtdAssgnCand)
            {
                if(candMap.Candidate_started__c=='yes')
                {
                    if(CndstrtdAssgnCandMap.containsKey(candMap.requirement__r.Requirement_type__c))
                    {
                        CndstrtdAssgnCandMap.get(candMap.requirement__r.Requirement_type__c).add(candMap);
                    }
                    else
                    {
                        CndstrtdAssgnCandMap.put(candMap.requirement__r.Requirement_type__c,new list<Candidate_Mapping__c>{candMap});
                    }
                }               
            }
           
        }  
       
       //To get Picklist values of the 'Type'(Requirement Type) field in Requirement Object
        Schema.DescribeFieldResult fieldResult=Requirement__c.Requirement_type__c.getDescribe();
        List<Schema.PicklistEntry>  PicklistEntry=fieldResult.getPicklistValues();
        system.debug('@@@@@@@@@@@@Requirement Type Values'+PicklistEntry);
        list<selectOption> reqTypeOptn=new list<selectOption>();
        set<String> reqTypeOptionValues=new set<String>();
        
        for(Schema.PicklistEntry f : PicklistEntry)
        {
          reqTypeOptn.add(new SelectOption(f.getLabel(),f.getValue()));
          reqTypeOptionValues.add(f.getValue());
        } 
        system.debug('---------------picklistlabel and values'+reqTypeOptn);  
        system.debug('---------------picklist values'+reqTypeOptionValues);  
        integer totalReq=0;
        integer totalResumesApp=0;
        integer totalResumesRej=0;
        integer totalResumesPending=0;
        integer totalClientInterviews=0;
        integer totalClientOffered=0;
        integer totalCandidateStarted=0;
        reqTypeOptionValues.add(null);
        
        //For loop to wrap up the No.Of requirements and No.Of submitted Resumes count for Requirement Type
        for(String strReqTypeOptValues:reqTypeOptionValues)
        {
            system.debug('--------------ReqType'+strReqTypeOptValues); 
            if(reqMap.containsKey(strReqTypeOptValues))
            {
                NoOfRequirements=reqMap.get(strReqTypeOptValues).size();
                system.debug('-------------NoOfRequirements'+reqMap.get(strReqTypeOptValues).size());
            }
           if(ReqAssingedCandMapApp.containsKey(strReqTypeOptValues))
            {
                NoOfSubmittedResumesApp = ReqAssingedCandMapApp.get(strReqTypeOptValues).size();
                system.debug('-------------NoOfSubmittedResumesApp'+ReqAssingedCandMapApp.get(strReqTypeOptValues).size());
            }
            if(ReqAssingedCandMapRej.containsKey(strReqTypeOptValues))
            {
                NoOfSubmittedResumesRej = ReqAssingedCandMapRej.get(strReqTypeOptValues).size();
                system.debug('-------------NoOfSubmittedResumesRej'+ReqAssingedCandMapRej.get(strReqTypeOptValues).size());
            }  if(ReqAssingedCandMapPending.containsKey(strReqTypeOptValues))
            {
                NoOfSubmittedResumesPending = ReqAssingedCandMapPending.get(strReqTypeOptValues).size();
                system.debug('-------------NoOfSubmittedResumesPending'+ReqAssingedCandMapPending.get(strReqTypeOptValues).size());
            }         
            totalReq=totalReq+NoOfRequirements;
            totalResumesApp =totalResumesApp+NoOfSubmittedResumesApp;
            totalResumesRej = totalResumesRej+NoOfSubmittedResumesRej; 
            totalResumesPending = totalResumesPending+NoOfSubmittedResumesPending;
            if(ClntIntwedAssgnCndMap.containsKey(strReqTypeOptValues))
            {
                NoOfClientInterviews=ClntIntwedAssgnCndMap.get(strReqTypeOptValues).size();
            }
            if(ClntOffrdAssgnCandMap.containsKey(strReqTypeOptValues))
            {
                NoOfClientOffered=ClntOffrdAssgnCandMap.get(strReqTypeOptValues).size();
            }
            if(CndstrtdAssgnCandMap.containsKey(strReqTypeOptValues))
            {
                NoOfCandStarted=CndstrtdAssgnCandMap.get(strReqTypeOptValues).size();
            } 
            
            totalClientInterviews=totalClientInterviews+NoOfClientInterviews;
            totalClientOffered=totalClientOffered+NoOfClientOffered;
            totalCandidateStarted=totalCandidateStarted+NoOfCandStarted;    
                     
            SummaryReq.add(New summary(strReqTypeOptValues,NoOfRequirements,NoOfSubmittedResumesApp,NoOfSubmittedResumesRej,NoOfSubmittedResumesPending,NoOfClientInterviews,NoOfClientOffered,NoOfCandStarted));
            
            NoOfRequirements=0;
            NoOfSubmittedResumesApp =0;
            NoOfSubmittedResumesRej = 0;
            NoOfSubmittedResumesPending = 0;
            NoOfClientInterviews=0;
            NoOfClientOffered=0;
            NoOfCandStarted=0;
        }
          SummaryReq.add(New summary('Grand Total',totalReq,totalResumesApp,totalResumesRej,totalResumesPending,totalClientInterviews,totalClientOffered,totalCandidateStarted));
         system.debug('-------------SummaryReq---------'+SummaryReq);

    }

    //Sending mail alert for Requirement Status Report based on Type 
    global void finish(Database.BatchableContext BC)
    {     
       String  htmlBody=''; 
        for(summary summryRec:SummaryReq)
        {
            
            String  requirementType;
            integer noOfRequiremnts;
             integer noOfResmSummtedApp;
            integer noOfResmSummtedRej;
            integer noOfResmSummtedPending;
            integer noOfClientInterview;
            integer noOfClientOffered;
            integer noOfCandidateStarted;
            if(summryRec.requiremntType!=null)
            {
               requirementType=summryRec.requiremntType;
            }
            else{
                requirementType='('+'Blank'+')';
            }
            noOfRequiremnts=summryRec.NoofReq;
             noOfResmSummtedApp =summryRec.NoofResumesApproved;
            noOfResmSummtedRej =summryRec.NoofResumesRejected;
            noOfResmSummtedPending  =summryRec.NoofResumesPending;
            noOfClientInterview=summryRec.intrwdCndCunt;
            noOfClientOffered=summryRec.offrdCndCunt;
            noOfCandidateStarted=summryRec.strtdCndCunt;
            //Adding record to Table and applying color to grand total row while adding row to html body 
            if(requirementType!='Grand Total')
            {
                htmlBody +='<tr>' +
                '<td>' + requirementType +'</td>' +
                '<td>' + noOfRequiremnts + '</td>' +                     
                '<td>' + noOfResmSummtedApp + '</td>' + 
                '<td>' + noOfResmSummtedRej + '</td>' +
                '<td>' + noOfResmSummtedPending + '</td>' +   
                '<td>' + noOfClientInterview + '</td>' + 
                '<td>' + noOfClientOffered + '</td>' +
                '<td>' + noOfCandidateStarted + '</td>' +  
                '</tr>';
            }
            else{
                htmlBody +='<b>'+'<tr bgcolor="#c4d9ed">' +
                '<td>' + requirementType +'</td>' +
                '<td>' + noOfRequiremnts + '</td>' +                     
                '<td>' + noOfResmSummtedApp + '</td>' +
                '<td>' + noOfResmSummtedRej + '</td>' +
                '<td>' + noOfResmSummtedPending + '</td>' + 
                '<td>' + noOfClientInterview + '</td>' + 
                '<td>' + noOfClientOffered + '</td>' +
                '<td>' + noOfCandidateStarted + '</td>' +                  
                '</tr>'+'</b>';
            }
        }
        string contentType='null';
        String FilterType='CreatedDate';
        String strLink='apex/EZRE_RequirementStatus_Report?FromDate='+dtFromDateTime+'&ToDate='+urlEndDate+'&Filter='+FilterType+'&ContentType='+contentType+'';
        Messaging.SingleEmailMessage email =  new Messaging.SingleEmailMessage(); 
        String ToAddress = System.Label.EZRE_ReqStatusReprtToAddress;    
        list<string> toAddressList=ToAddress.split(',');  
        email.setToAddresses(toAddressList);              
        system.debug('@@@@@@@@@@@@To Email For Requirement Status Report'+ToAddress);
        OrgWideEmailAddress owea = EZRE_OppActReport_DataUtility.getOrgWideEmailAddress();  
        email.setOrgWideEmailAddressId(owea.Id);                        

        email.setSubject( 'EZRE-Requirements Monthly Status Report');
        email.setHtmlBody('Dear Team, </br></br> Please find the below Requirements Monthly Status Report. '+'</br></br> <table border="1"> '+
        '<tr bgcolor="#c4d9ed">'+ 
        '<th>Requirement Type</th>' +
        '<th>No.Of Requirements</th>' +
        '<th>No.Of Resumes Approved</th>' + 
        '<th>No.Of Resumes Rejected</th>' +
        '<th>No.Of Resumes Pending</th>' +  
        '<th>No.Of Client Interviews</th>' + 
        '<th>No.Of Client Offered</th>' +
        '<th>No.Of Candidates Started</th>' +       
        '</tr>' +
        htmlBody + '</table>' + '</br> Please '+'<a href="'+URL.getSalesforceBaseUrl().toExternalForm() +'/'+strLink+'">'+ 'Click Here ' +'</a>'+' to get the details of the Requirements Status Report. </br></br> Regards, </br> EZRE Team');     
        //To Send mail                                 
        Messaging.SendEmailResult [] result = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email}); 
      
    }
    //Wrapper class 
    public class summary
        {
            public String requiremntType{get;set;}
             public integer  NoofResumesApproved{get;set;}
            public integer  NoofResumesRejected{get;set;}
            public integer  NoofResumesPending{get;set;}
            public integer  NoofReq{get;set;}
            public integer intrwdCndCunt{get;set;}
            public integer offrdCndCunt{get;set;}
            public integer strtdCndCunt{get;set;}
            public summary(String reqType,integer noOfReqrmt,integer noOfResumesApp,integer noOfResumesRej,integer noOfResumesPending,integer interviewdCandCount,integer offeredCandCount,integer startedCandCount)
            {
                this.requiremntType=reqType;
                this.NoofReq= noOfReqrmt;
                this.NoofResumesApproved = noOfResumesApp;
                this.NoofResumesRejected = noOfResumesRej;
                this.NoofResumesPending = noOfResumesPending;
                this.intrwdCndCunt=interviewdCandCount;
                this.offrdCndCunt=offeredCandCount;
                this.strtdCndCunt=startedCandCount;
               
            }
        }
}