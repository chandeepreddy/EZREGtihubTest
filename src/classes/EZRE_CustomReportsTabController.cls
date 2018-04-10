/*
 * @author           Gangadhar R
 * @version          1.0 
 * @date             17/03/2016
 * @description      Controller for Custom_Reports
 */
public class EZRE_CustomReportsTabController
{
     public pageReference redirecttoReqStatusReport()
    {
        
        pagereference pg = new pagereference('/apex/EZRE_RequirementStatus_Report');
        //pg.SetRedirect(True);
        return pg;
    }
    
     public pageReference redirecttoISRSummaryReport()
    {
       
        pagereference pg = new pagereference('/apex/EZRE_InsideSalesRepReport');
        //pg.SetRedirect(True);

        return pg;
    } 
     public pageReference redirecttoDailyCallList()
    {
        
        pagereference pg = new pagereference('/apex/EZRE_SalesTeamDailyCallList');
        //pg.SetRedirect(True);
        return pg;
    }
    public pageReference redirecttoCandidateResumeReport()
    {
        
        pagereference pg = new pagereference('/apex/EZRE_CandidateResumeReports');       
        return pg;
    }
     public pageReference redirecttoDailyCntCallList()
    {
        
        pagereference pg = new pagereference('/apex/EZRE_SalesTeamCntDailyCallList');
        //pg.SetRedirect(True);
        return pg;
    }
}