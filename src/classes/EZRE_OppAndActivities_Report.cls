/**
 * @author           Indumathi
 * @version          1.0 
 * @date             25/11/2015
 * @Status           Developed
 * @description      Controller class for EZRE_Opportunity_Activities_Report to display the report on Opportunities which do not have any open activities
 *
 */
public class EZRE_OppAndActivities_Report
{

    public Set<string> setStgeName {get;set;}
    public List<Opportunity> lstAllOpp {get;set;}
    public List<Task> lstOpenTasks {get;set;}
    public List<Event> lstOpenEvnts {get;set;}
    public set<Id> setOpenOppIds {get;set;}
    public set<Id> setClosedOppIds {get;set;}
    public List<Opportunity> lstOppWthoutActvts {get;set;}  
    public string strStageNames{get;set;} 
    public List<AggregateResult> lstOppOwnerAggtRslt {get;set;}
    public Map<String, String> mapOppOwnerCount{get;set;}
    public list<WrapperAggregateResult>  lstWrapperAggregateResult{get;set;}
   

    ///<OBJECTIVE>
    ///Constructor
    ///<OBJECTIVE>
    public EZRE_OppAndActivities_Report()
    {
        setStgeName = new Set<String>{'Prospecting', 'Qualification','Needs Analysis','Value Proposition','Id. Decision Makers','Perception Analysis','Proposal/Price Quote','Negotiation/Review','Resume Submitted','Phone Screen','1st Interview','2nd Interview'};
        strStageNames = convertStageNameToString(setStgeName);       
        setOpenOppIds = new set<Id>();
        setClosedOppIds = new set<Id>(); 
        lstOppWthoutActvts  = new List<Opportunity>();  
        lstOppOwnerAggtRslt = new List<AggregateResult>();           
        fetchOpportunities();        
        getOpportunityOwnerCount();
    }
    
    private String convertStageNameToString(Set<String> setStageName)
    {
        String str = '(\'';
        for (String s : setStageName)
        {
            str += s + '\',\'';
        }

        str  = str.substring(0,str.length()-2);
        str += ')';      
        return  str;
    }
    
    ///<OBJECTIVE>
    ///Method to fetch the list of Opportunities
    ///</OBJECTIVE>
    public  void fetchOpportunities()
    {
        //List of all Opportunities with Stage and Account Owner Name filtered
        String strAccntOwner = System.Label.OppReport_AccountOwnerFilter;       
        lstAllOpp = new List<Opportunity>();        
        lstAllOpp = EZRE_OppActReport_DataUtility.getAllOppList(strStageNames,strAccntOwner);      
        for(Opportunity objOpp : lstAllOpp)
        {
            setClosedOppIds.add(objOpp.Id);
            
        }       
        
        //List of all open tasks
        lstOpenTasks = new List<Task>();
        lstOpenTasks = EZRE_OppActReport_DataUtility.getOpenTaskList();
       
        for(Task objTsk : lstOpenTasks)
        {
            setOpenOppIds.add(objTsk.WhatId);           
            
        }
      
        //List of all open events
        lstOpenEvnts = new List<Event>();  
        lstOpenEvnts = EZRE_OppActReport_DataUtility.getOpenEventsList();        
        for(Event objEvnt: lstOpenEvnts)
        {
            setOpenOppIds.add(objEvnt.WhatId);
            
        }
       
        setClosedOppIds.removeAll(setOpenOppIds);  
        
        lstOppWthoutActvts = EZRE_OppActReport_DataUtility.getAllOppWthoutActvs(setClosedOppIds);  
        
    }
    
    ///<OBJECTIVE>
    ///Method to fetch the count of Opportunity owner
    ///</OBJECTIVE>
    public list<WrapperAggregateResult> getOpportunityOwnerCount()
    {
         lstWrapperAggregateResult=new list<WrapperAggregateResult>();
         lstOppOwnerAggtRslt =EZRE_OppActReport_DataUtility.getOpportunityOwnerCountList(setClosedOppIds);  
                                      
         for (AggregateResult objAggrgtRslt : lstOppOwnerAggtRslt)  {
          lstWrapperAggregateResult.add(new WrapperAggregateResult(objAggrgtRslt));                    
        }     
        return lstWrapperAggregateResult;
        
    }
    
    public class WrapperAggregateResult
    {
       public string  strOwnerName{get;set;}
       public  integer intOwnerCount{get;set;}
       
       public WrapperAggregateResult(AggregateResult objAggrgtRslt)
       {
          
           strOwnerName=String.valueOf(objAggrgtRslt .get('Name'));
           intOwnerCount=Integer.valueOf(objAggrgtRslt .get('expr0'));
         
       }
    
    
    }
    
    

}