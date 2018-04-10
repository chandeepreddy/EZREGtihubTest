/*
 * @author           Gangadhar R
 * @version          1.0 
 * @date             24/02/2016
 * @description      Controller for EZRE_RequirementTracking_Report
 */  
Public class EZRE_RequirementTracking_ReportAsCSV
{

  
public string strFromDate{get;set;}
public string strToDate{get;set;}
public string strFilterValue{get;set;}
public string strContentType{get;set;}
public date dtNextFromDate{get;set;}
public date dtNextToDate{get;set;}
public string PageRqstSource{get;set;}
public List<summary> SummaryReq{get;set;}
public boolean isShowTable{get;set;}
public List<Requirement__c> reqFinalList {get;set;}
public List<Candidate_Mapping__c> canMppngLst{get;set;}
public set<Id> reqIdSet {get;set;}
public Map<string,List<Candidate_Mapping__c>> assignCanCountMap {get;set;}

public list<Candidate_Mapping__c> CndstrtdAssgnCand;
public list<Candidate_Mapping__c> ClntOffrdAssgnCand;
public list<Candidate_Mapping__c> ClntIntwedAssgnCand;
public map<Id,list<Candidate_Mapping__c>> ClntIntwedAssgnCndMap;
public map<Id,list<Candidate_Mapping__c>> ClntOffrdAssgnCandMap;
public map<Id,list<Candidate_Mapping__c>>   CndstrtdAssgnCandMap;

public DateTime dttimefromDate;
public DateTime dttimeToDate;

 /// <OBJECTIVE>
/// Constructor
/// </OBJECTIVE>   
public EZRE_RequirementTracking_ReportAsCSV()
{
    //isShowTable = false;
    
    strFromDate = apexpages.CurrentPage().GetParameters().get('FromDate');
    strToDate = apexpages.CurrentPage().GetParameters().get('ToDate');
    strFilterValue = apexpages.CurrentPage().GetParameters().get('Filter');
    strContentType= apexpages.CurrentPage().GetParameters().get('ContentType');
    system.debug('--------------------strContentType'+strContentType);
    system.debug('--------------------PageRqstSource'+PageRqstSource);
    ClntIntwedAssgnCand=new list<Candidate_Mapping__c>();
    ClntOffrdAssgnCand=new list<Candidate_Mapping__c>();
    CndstrtdAssgnCand=new list<Candidate_Mapping__c>();
    
    if(strContentType=='null')
    {
        PageRqstSource='';
        system.debug('-------------------if-PageRqstSource'+PageRqstSource);
    }
    else
    {
       PageRqstSource='application/vnd.ms-excel#Requirement Status Report.xls';
        system.debug('------------------else--PageRqstSource'+PageRqstSource);
    }
    RunReport();
}

///<Objective>
///Method is the command button action in the controller
///</Objective>    
    public pageReference RunReport()
    {
    
        integer  interviewdCandCount;
        integer  offeredCandCount;
        integer  startedCandCount;
        ClntIntwedAssgnCndMap=new map<Id,list<Candidate_Mapping__c>>();
        ClntOffrdAssgnCandMap=new map<Id,list<Candidate_Mapping__c>>();
        CndstrtdAssgnCandMap=new map<Id,list<Candidate_Mapping__c>>();
        
        isShowTable = true;
        system.debug('@@@@Nextpagestring'+strFromDate);
        system.debug('@@@@Nextpage'+strToDate);
        List<requirement__c> reqList = new List<requirement__c>();
        List<requirement__c> reqNotModifiedList = new List<requirement__c>();
        List<RequirementAssignment__c> assignReqList = new List<RequirementAssignment__c>();
        SummaryReq = new List<summary>();
        reqIdSet = new Set<Id>();
        canMppngLst = new List<Candidate_Mapping__c>(); 
        assignCanCountMap =  new Map<string,List<Candidate_Mapping__c>>();
        dtNextFromDate = Date.valueof(strFromDate);
        dtNextToDate = Date.valueof(strToDate);
        system.debug('@@@@Nextpage'+dtNextFromDate);
        system.debug('@@@@Nextpage'+dtNextFromDate);      
        dttimefromDate = datetime.newInstance(dtNextFromDate.year(), dtNextFromDate.month(),dtNextFromDate.day());
        if(dtNextToDate ==date.Today())
        {    
           System.debug('to date-------if@@@----'+dtNextToDate);
            dttimeToDate = datetime.now();
            System.debug('to date-------inquery@@@----'+dttimeToDate);
            reqList=EZRE_Requirement_DataUtility.fetchRequirementForStatusReport(dttimefromDate,dttimeToDate,dtNextFromDate,dtNextToDate);            
        }
        else
        {
           dttimeToDate  = datetime.newInstance(dtNextToDate.year(), dtNextToDate.month(),dtNextToDate.day());
          
           System.debug('to date-------else@@@----'+dttimeToDate);
           System.debug('from date-------else@@@----'+dttimefromDate);
            dttimeToDate =dttimeToDate.addHours(23);
            System.debug('to date-------else@@@----'+dttimeToDate);
            dttimeToDate =dttimeToDate.addMinutes(59);
            System.debug('to date-------@@@----'+dttimeToDate);
            dttimeToDate =dttimeToDate.addSeconds(59);
            System.debug('to date-------else@@@----'+dttimeToDate);
            reqList=EZRE_Requirement_DataUtility.fetchRequirementForStatusReport(dttimefromDate,dttimeToDate,dtNextFromDate,dtNextToDate);   
        }

        for(Requirement__c reqObj : reqList)
        {
            reqIdSet.add(reqObj.Id);
            
        }
        for(Requirement__c reqNotObj : reqNotModifiedList)
        {
            reqIdSet.add(reqNotObj.Id);    
        }
        System.debug('Id set---------------'+reqIdSet);  
          if(dtNextToDate == date.Today())
        {
            dttimeToDate = datetime.now();
        
            getCndMpngForResumeStatus(dttimefromDate,dttimeToDate);
            getAssgnCandForInterviewsCount(dttimefromDate,dttimeToDate);
        }
        else
        {
            dttimeToDate  = datetime.newInstance(dtNextToDate.year(), dtNextToDate.month(),dtNextToDate.day());
            System.debug('to date-------else@@@----'+dttimeToDate);
            System.debug('from date-------else@@@----'+dttimefromDate);
            dttimeToDate =dttimeToDate.addHours(23);
            System.debug('to date-------else@@@----'+dttimeToDate);
            dttimeToDate =dttimeToDate.addMinutes(59);
            System.debug('to date-------@@@----'+dttimeToDate);
            dttimeToDate =dttimeToDate.addSeconds(59);
            System.debug('to date-------else@@@----'+dttimeToDate);
          
            getCndMpngForResumeStatus(dttimefromDate,dttimeToDate);
             getAssgnCandForInterviewsCount(dttimefromDate,dttimeToDate);
        }
        for(Candidate_Mapping__c CanMap:canMppngLst)
        {
            if(assignCanCountMap.ContainsKey(CanMap.requirement__c))
            {
                assignCanCountMap.get(CanMap.requirement__c).add(CanMap);
            }
            else
            {
                assignCanCountMap.put(CanMap.requirement__c,new List<Candidate_Mapping__c>{CanMap});
            }
            
        }
         string query = 'Select Id,Status__c,Requirement_type__C,owner.name,Name,LastModifiedDate,createddate,C_Name__r.Name,End_Client_Name__c,Opportunity_Code__c,Req_Closed_Date__c,Submitted_Resumes__c,ResumesSubmitted__c,No_Of_Resumes__c FROM Requirement__c where Id IN:reqIdSet Order By';
        if(strFilterValue == 'CreatedDate')
        {
            query += +' '+'CreatedDate';
        }
        else if(strFilterValue == 'owner.name')
        {
            query += +' '+'owner.name';
        }
        else if(strFilterValue == 'status__c')
        {
            query += +' '+'status__c';
        }
        else if(strFilterValue == 'C_Name__r.Name')
        {
            query += +' '+'C_Name__r.Name';
        }
        else if(strFilterValue == 'Name')
        {
            query += +' '+'Name';
        }
        else if(strFilterValue == 'Requirement_Type__c')
        {
            query += +' '+'Requirement_Type__c';
        }
        reqFinalList = Database.Query(query);
       
        Map<Id,set<string>> assignReqLRMap = new Map<Id,set<string>>();
        Map<Id,set<string>> assignReqRMap = new Map<Id,set<string>>();
       Map<Id,string> assignReqLatestRMap = new Map<Id,string>();
       assignReqList=EZRE_Requirement_DataUtility.fetchAssignRequirements(reqIdSet); 
       system.debug('assignReqList ============'+assignReqList );
      //Map of assign requirements of requirement
       Map<Id,set<RequirementAssignment__c>> assignRequirementMap = new  Map<Id,set<RequirementAssignment__c>>();
       for(RequirementAssignment__c assReq : assignReqList)
       {     
             
            if(assignReqLRMap.ContainsKey(assReq.requirement__c))
            {
                assignReqLRMap.get(assReq.requirement__c).add(assReq.lead_Recruiter__r.name);
                assignRequirementMap.get(assReq.requirement__c).add(assReq);
            }
            else
            {
                assignReqLRMap.put(assReq.requirement__c,new set<string>{assReq.lead_Recruiter__r.name});
                assignRequirementMap.put(assReq.requirement__c,new set<RequirementAssignment__c>{assReq});
            }
            if(dttimefromDate <= assReq.createdDate && dttimeToDate>=assReq.createdDate)
            {
                
                if(assignReqRMap.ContainsKey(assReq.requirement__c))
                {
                    assignReqRMap.get(assReq.requirement__c).add(assReq.Recruiter__r.name);
                }
                else
                {
                    assignReqRMap.put(assReq.requirement__c,new set<string>{assReq.Recruiter__r.name});
                }
            
            }
            else
            {
                if(!String.isBlank(assReq.Recruiter__r.name))
                {
                    assignReqLatestRMap.put(assReq.requirement__c,assReq.Recruiter__r.name);
                    
                }
            }
        }
           system.debug('@@@@@@@'+reqFinalList.size());
           for(requirement__c req:reqFinalList)
           {
                integer NoofResumes;
                string strLR = '';
                string strR = '';
                Set<string> lRNames = new Set<string>();
                set<string> RNames = new Set<string>();
                interviewdCandCount=0;
                offeredCandCount=0;
                startedCandCount=0;
                List<Candidate_Mapping__c>  apprvedAssgnCands=new  List<Candidate_Mapping__c>();
                integer assgnCandTtlApprvdCunt=0;
                integer assgnCandApprovedForPeriod=0;
                system.debug('Requirement Name========='+req.name); 
                if(assignRequirementMap.containsKey(Req.Id))
                {
                    system.debug('assign requirements========='+assignRequirementMap.get(Req.Id)); 
                }
                if(assignCanCountMap.ContainsKey(Req.Id))
                {
                    NoofResumes = assignCanCountMap.get(Req.Id).size();  
                    apprvedAssgnCands=assignCanCountMap.get(Req.Id);
                    system.debug('apprvedAssgnCands=================='+apprvedAssgnCands);
                    for(Candidate_Mapping__c assgncandidate:apprvedAssgnCands)
                    {
                        if(assgncandidate.MR_Status__c=='Approved')
                        {
                            assgnCandTtlApprvdCunt=assgnCandTtlApprvdCunt+1;
                            if(dtNextFromDate<=assgncandidate.MR_Approved_Date__c&&dtNextToDate>=assgncandidate.MR_Approved_Date__c)
                            {
                                 assgnCandApprovedForPeriod=assgnCandApprovedForPeriod+1;
                                 system.debug('assgncandidate.MR_Approved_Date__c========='+assgncandidate.MR_Approved_Date__c);
                            }
                        }   
                    }
                  system.debug('assgnCandTtlApprvdCunt==========='+assgnCandTtlApprvdCunt);  
                 
                  
                }
               
                if(assignReqLRMap.ContainsKey(Req.Id))
                {
                    lRNames = assignReqLRMap.get(Req.Id);
                    for(string lrName : lRNames)
                    {
                       if(lrName != null)
                        {
                            strLR += lrName+', ';
                            
                        }
                       
                    }
                     if(strLR != '')
                        {
                            strLR = strLR.substring(0,strLR.length()-2);
                        }                 
                }
                if(assignReqRMap.ContainsKey(Req.Id))
                {
                   //Recruiter names of assign requirements that are created between selected Dates.
                   for(string str :assignReqRMap.get(Req.Id))
                    {
                        if(str != null)
                        {
                            strR += str+', ';
                        }
                    }
                    if(strR != '')
                        {
                            strR = strR.substring(0,strR.length()-2);
                        }  
                 system.debug('1:all Recruiters=========='+strR);  
                }   
                else
                {
                    if(assignReqLatestRMap.containsKey(Req.Id))
                    { 
                        //Latest assign requirement recuiter Name
                        strR=assignReqLatestRMap.get(Req.Id);  
                        system.debug('2:Latest recruiter Name:======='+strR);                
                    }
                
                }                                  
                if(ClntIntwedAssgnCndMap.containsKey(Req.Id))
                {
                    interviewdCandCount=ClntIntwedAssgnCndMap.get(Req.Id).size();
                }
                if(ClntOffrdAssgnCandMap.containsKey(Req.Id))
                {
                    offeredCandCount=ClntOffrdAssgnCandMap.get(Req.Id).size();
                }
                if(CndstrtdAssgnCandMap.containsKey(Req.Id))
                {
                    startedCandCount=CndstrtdAssgnCandMap.get(Req.Id).size();
                } 
                   
                system.debug('loopnames@@@@@@'+strR);
                system.debug('loopnames@@@@@@'+strLR);
                SummaryReq.add(New summary(req,NoofResumes,strLR ,strR,interviewdCandCount,offeredCandCount,startedCandCount,assgnCandTtlApprvdCunt,assgnCandApprovedForPeriod));
           }
        
       return  null;
       
    }
    public void getCndMpngForResumeStatus(DateTime frmDtm,DateTime toDtm)
    {
         dttimefromDate=frmDtm;
         dttimeToDate=toDtm;
         canMppngLst=EZRE_Requirement_DataUtility.fetchMRApprovedCanidates(dttimefromDate,dttimeToDate);
         system.debug('canMppngLst:=====================CandidateMappingList'+canMppngLst); 
    }
    public void getAssgnCandForInterviewsCount(Datetime fromDtm,Datetime toDtm)
    {
        dttimefromDate=fromDtm;
        dttimeToDate=toDtm;
        system.debug('dttimefromDate:==================='+dttimefromDate);
        system.debug('dttimeToDate:================To query count'+dttimeToDate);
        ClntIntwedAssgnCand=EZRE_Requirement_DataUtility.fetchClientInterviewedCandidtes(reqIdSet,dttimefromDate,dttimeToDate);       
        system.debug('====================assgnCndList for client interviewed Ass cand'+ClntIntwedAssgnCand);
        if(ClntIntwedAssgnCand.size()>0)
        {
           for(Candidate_Mapping__c  candMap:ClntIntwedAssgnCand)
           {
                if(candMap.Client_Interviewed__c=='yes')
                {
                    if(ClntIntwedAssgnCndMap.containsKey(candMap.requirement__c))
                    {
                        ClntIntwedAssgnCndMap.get(candMap.requirement__c).add(candMap);
                    }
                    else
                    {
                        ClntIntwedAssgnCndMap.put(candMap.requirement__c,new list<Candidate_Mapping__c>{candMap});
                    }   
                }               
           }         
        }
        system.debug('ClntIntwedAssgnCndMap:====================assgnCndList for client intw Ass cand'+ClntIntwedAssgnCndMap);
        ClntOffrdAssgnCand=EZRE_Requirement_DataUtility.fetchClientOfferedCandidates(reqIdSet,dttimefromDate,dttimeToDate);           
        system.debug('====================assgnCndList for client offerd Ass cand'+ClntOffrdAssgnCand);
        if(ClntOffrdAssgnCand.size()>0)
        {
            for(Candidate_Mapping__c  candMap:ClntOffrdAssgnCand)
            {
                if(candMap.Client_Offered__c=='yes')
                {
                    if(ClntOffrdAssgnCandMap.containsKey(candMap.requirement__c))
                    {
                        ClntOffrdAssgnCandMap.get(candMap.requirement__c).add(candMap);
                    }
                    else
                    {
                        ClntOffrdAssgnCandMap.put(candMap.requirement__c,new list<Candidate_Mapping__c>{candMap});
                    }  
                }               
            }               
        }
        system.debug('ClntOffrdAssgnCandMap:====================assgnCndList for client off Ass cand'+ClntOffrdAssgnCandMap);
        CndstrtdAssgnCand=EZRE_Requirement_DataUtility.fetchCandidatesStarted(reqIdSet,dttimefromDate,dttimeToDate);       
        system.debug('====================assgnCndList for cand started Ass cand'+CndstrtdAssgnCand);
        if(CndstrtdAssgnCand.size()>0)
        {
            for(Candidate_Mapping__c  candMap:CndstrtdAssgnCand)
            {
                if(candMap.Candidate_started__c=='yes')
                {
                    if(CndstrtdAssgnCandMap.containsKey(candMap.requirement__c))
                    {
                        CndstrtdAssgnCandMap.get(candMap.requirement__c).add(candMap);
                    }
                    else
                    {
                        CndstrtdAssgnCandMap.put(candMap.requirement__c,new list<Candidate_Mapping__c>{candMap});
                    }
                }               
            }
           
        }  
        system.debug('CndstrtdAssgnCandMap:====================assgnCndList for cand started Ass cand'+CndstrtdAssgnCandMap);
    }   
    
       
///<Objective>
///This is a wrapper class.
///</Objective>
    public class summary
    {
        public requirement__c req{get;set;}
        public integer  NoofResumes{get;set;}
        public string LRNames{get;set;}
        public string RNames{get;set;}
        public integer intrwdCndCunt{get;set;}
        public integer offrdCndCunt{get;set;}
        public integer strtdCndCunt{get;set;}
        //Assign candidates total count approved by MR
        Public integer  mrApprvedCandTotalCount{get;set;}
        //Assign Candidates approved by MR between selected Dates
        public integer  mrApprvdCandsForGivenPeriod{get;set;}   
        public summary(requirement__c repName,integer noOfRes,string LRs,string Rs,integer interviewdCandCount,integer offeredCandCount,integer startedCandCount,integer totalMRApprovedCount,integer mrApprovedCountForGivenPeriod)
        {
            this.req =repName;
            this.NoofResumes = noOfRes;
            this.LRNames=LRs;
            this.RNames= Rs;
            this.intrwdCndCunt=interviewdCandCount;
            this.offrdCndCunt=offeredCandCount;
            this.strtdCndCunt=startedCandCount;
            this.mrApprvedCandTotalCount=totalMRApprovedCount;
            this.mrApprvdCandsForGivenPeriod=mrApprovedCountForGivenPeriod;
        }
    }
    
    
}