/**
 * @author           Kalaiselvi R
 * @version          1.0 
 * @date             03-Jan-2017
 * @Status           Developed
 * @description      This is the controller class to fetch sprint details from Rally
 *
 */
public class ODS_RallyIntegration
{  
    /// <OBJECTIVE>
    /// Send http request and return response.
    /// </OBJECTIVE>  
    public static string InvokeRallyApi(string Usrname, String Passwrd, string EndPointUrl)
    {
        HTTPResponse response = new HTTPResponse();
        try    {
            HttpRequest request = new HttpRequest();
            request.setMethod('GET');
            request.setEndpoint(EndPointUrl);      
            Blob headerValue = Blob.valueOf(Usrname+ ':' + Passwrd);
            String authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(headerValue);
            request.setHeader('Authorization', authorizationHeader);
            Http http = new Http();
            response = http.send(request);
            
            return response.getBody();
        }
        catch(Exception ex)    {
            system.debug('json Exception: '+ex);
            return 'Error';
        }
        
    }
    /// <OBJECTIVE>
    /// Form requirement API to fetch User Story counts.
    /// </OBJECTIVE>
    public static string requirementApiFormation(String workspaceId, String status, String startDate, String endDate)
    {
      String requirementUrl = '';
      try   {
          List<string> Statuslist= new List<string>();
          Statuslist=status.split(':'); 
          system.debug('Statuslist:'+Statuslist);
          requirementUrl ='https://rally1.rallydev.com/slm/webservice/v2.0/hierarchicalrequirement?workspace=';
           
            system.debug('Statuslist[0]:'+Statuslist[0]);
            if(Statuslist.size()>1)
            {
                 requirementUrl += workspaceId+'&query=(((ScheduleState%20%3D%20%22'+Statuslist[0]+'%22)'
                                + '%20OR(ScheduleState%20%3D%20%22'+ Statuslist[1]+'%22)';
            }
            else{
                requirementUrl += workspaceId+'&query=((ScheduleState%20%3D%20'+Statuslist[0];
            }
            requirementUrl += ')%20AND%20(((Iteration.StartDate%20%3E=%20'+ startDate+')' 
            +'%20AND%20(Iteration.StartDate%20%3C=%20'+endDate+'+))%20OR%20'
            +'((Iteration.EndDate%20%3E=%20'+startDate+')' 
            +'%20AND%20(Iteration.EndDate%20%3C=%20'+endDate+'))))'
            +'&fetch=FormattedID,StartDate,EndDate,ScheduleState,CreationDate,PlanEstimate&start=1&pagesize=500';
            system.debug('requirementUrl : '+requirementUrl);
      }
      
      catch(Exception ex)    {
          system.debug(ex);
      }
      return requirementUrl;
    }
    /// <OBJECTIVE>
    /// Fetch the workspace id for corresponding Account and Service.
    /// </OBJECTIVE>  

    public static void GetWorkspaceId(string userName, string password, string formattedMonthfirstDate,
                               string formattedMonthLastDate, string formattedFYStartDate, string formattedFYEndDate,String serviceWorkspaceId) 
    {
        try {
            string rallyResponse = '';
            string workspaceId = '';
            string resBody = '';
            string USCompltdResBody = '';
            string USInProgressResBody = '';
            string FYCompltdResBody = '';
            String workspaceUrl = 'https://rally1.rallydev.com/slm/webservice/v2.0/workspace';
            ODS_DashboardController objDashBoard = new ODS_DashboardController();   
            
            // if it is a test class, then it will go to the else loop
            if(!Test.isRunningTest())
            { 
                resBody = InvokeRallyApi(userName, password, workspaceUrl);
                if(resBody.contains('The username or password you entered is incorrect'))    {
                    rallyResponse = 'error';
                    ODS_DashboardController.SetRallyResponse(rallyResponse);
                }
                else    {
                    rallyResponse = 'success';
                    ODS_DashboardController.SetRallyResponse(rallyResponse);
                }
            }
            // Http Response for Test class
            else
            {
                 resBody = '{ "QueryResult": { "_rallyAPIMajor": "2", "_rallyAPIMinor": "0", "Errors": [], "Warnings": [], "TotalResultCount": 3,'
                                +'"StartIndex": 1, "PageSize": 100, "Results": [{ "_rallyAPIMajor": "2", "_rallyAPIMinor": "0",'
                                +'"_ref": "https://rally1.rallydev.com/slm/webservice/v2.0/hierarchicalrequirement/58381749777",'
                                +'"_refObjectUUID": "de008708-aad5-453f-8577-8faeb54a2014", "_objectVersion": "17",' 
                                +'"_refObjectName": "client payment email should come from toms@geographicfarm.com", "CreationDate": "2016-06-27T20:52:32.047Z",'
                                +'"_CreatedAt": "Jun 27, 2016", "FormattedID": "US82", "ScheduleState": "Completed", "_type": "HierarchicalRequirement" }] } }';   
            }
            Map<String,Object> jsonResp = (Map<String,Object>) JSON.deserializeUntyped(resBody);
            Map<String,Object> responsequery = (Map<String,Object>) jsonResp.get('QueryResult');  
            List<Object> responseResultLst = (List<Object>)responsequery.get('Results');
    
            Map<String,Object> Result = new Map<String,Object>();
        
            for(Object obj: responseResultLst)
            {
                Result=(Map<String,Object>) obj; 
                if(String.isBlank(ServiceWorkspaceId))               
                {
                    system.debug('============ServiceWorkspaceId null check'+ServiceWorkspaceId);
                    workspaceId = (string)Result.get('_ref');
                    system.debug('###########workspaceId  for testing'+workspaceId );
                }
                else
                {
                    workspaceId='https://rally1.rallydev.com/slm/webservice/v2.0/workspace/'+ServiceWorkspaceId;
                    system.debug('###########workspaceId  for testing'+workspaceId );
                    
                }
                
                String iterationUrl = 'https://rally1.rallydev.com/slm/webservice/v2.0/iteration?workspace='
                    +workspaceId+'&query=&fetch=StartDate,EndDate,State,TaskActualTotal,TaskEstimateTotal,TaskRemainingTotal&start=1&pagesize=500';
                GetIterationByWorkspaceId(userName, password, iterationUrl);
                
                string USCompltdUrl = requirementApiFormation(workspaceId,'Completed:Accepted', formattedMonthfirstDate, formattedMonthLastDate);
                string USInProgressUrl = requirementApiFormation(workspaceId,'In-Progress', formattedMonthfirstDate, formattedMonthLastDate);
                string FYcompltdUrl = requirementApiFormation(workspaceId, 'Completed:Accepted', formattedFYStartDate, formattedFYEndDate);

                // if it is a test class, then it will go to the else loop
                if(!Test.isRunningTest())   
                    USCompltdResBody = InvokeRallyApi(userName, password, USCompltdUrl);

                // Http Response for Test class
                else
                    USCompltdResBody = '{ "QueryResult": { "_rallyAPIMajor": "2", "_rallyAPIMinor": "0", "Errors": [], "Warnings": [], "TotalResultCount": 3,'
                                +'"StartIndex": 1, "PageSize": 100, "Results": [{ "_rallyAPIMajor": "2", "_rallyAPIMinor": "0",'
                                +'"_ref": "https://rally1.rallydev.com/slm/webservice/v2.0/hierarchicalrequirement/58381749777",'
                                +'"_refObjectUUID": "de008708-aad5-453f-8577-8faeb54a2014", "_objectVersion": "17",' 
                                +'"_refObjectName": "client payment email should come from toms@geographicfarm.com", "CreationDate": "2016-06-27T20:52:32.047Z",'
                                +'"_CreatedAt": "Jun 27, 2016", "FormattedID": "US82", "ScheduleState": "Completed", "_type": "HierarchicalRequirement" }] } }';
                    
                if(!string.isEmpty(USCompltdResBody))
                    ODS_DashboardController.SetUSCompletedByMonthYear(USCompltdResBody);
                
                // if it is a test class, then it will go to the else loop
                if(!Test.isRunningTest())    
                    USInProgressResBody = InvokeRallyApi(userName, password, USInProgressUrl);
               
                // Http Response for Test class
                else
                    USInProgressResBody = '{ "QueryResult": { "_rallyAPIMajor": "2", "_rallyAPIMinor": "0", "Errors": [], "Warnings": [], "TotalResultCount": 2,'
                                +'"StartIndex": 1, "PageSize": 100, "Results": [{ "_rallyAPIMajor": "2", "_rallyAPIMinor": "0",'
                                +'"_ref": "https://rally1.rallydev.com/slm/webservice/v2.0/hierarchicalrequirement/58381749777",'
                                +'"_refObjectUUID": "de008708-aad5-453f-8577-8faeb54a2014", "_objectVersion": "17",' 
                                +'"_refObjectName": "client payment email should come from toms@geographicfarm.com", "CreationDate": "2016-06-27T20:52:32.047Z",'
                                +'"_CreatedAt": "Jun 27, 2016", "FormattedID": "US82", "ScheduleState": "Completed", "_type": "HierarchicalRequirement" }] } }';
                
                if(!string.isEmpty(USInProgressResBody))
                    ODS_DashboardController.SetUSInProgressByMonthYear(USInProgressResBody);
                    
                // if it is a test class, then it will go to the else loop   
                if(!Test.isRunningTest())      
                    FYCompltdResBody = InvokeRallyApi(userName, password, FYcompltdUrl);
                
                // Http Response for Test class
                else
                    FYCompltdResBody = '{ "QueryResult": { "_rallyAPIMajor": "2", "_rallyAPIMinor": "0", "Errors": [], "Warnings": [], "TotalResultCount": 20,'
                                +'"StartIndex": 1, "PageSize": 100, "Results": [{ "_rallyAPIMajor": "2", "_rallyAPIMinor": "0",'
                                +'"_ref": "https://rally1.rallydev.com/slm/webservice/v2.0/hierarchicalrequirement/58381749777",'
                                +'"_refObjectUUID": "de008708-aad5-453f-8577-8faeb54a2014", "_objectVersion": "17",' 
                                +'"_refObjectName": "client payment email should come from toms@geographicfarm.com", "CreationDate": "2016-06-27T20:52:32.047Z",'
                                +'"_CreatedAt": "Jun 27, 2016", "FormattedID": "US82", "ScheduleState": "Completed", "_type": "HierarchicalRequirement" }] } }';
                if(!string.isEmpty(FYCompltdResBody)) 
                    ODS_DashboardController.SetUSCompletedByFY(FYCompltdResBody);
            }
            
        }
        catch(Exception ex)    {
            system.debug(ex);
        }
    } 
    
    /// <OBJECTIVE>
    /// Fetch the workspace id for corresponding Account and Service.
    /// </OBJECTIVE>  
    public static string GetWorkspaceId(string userName, string password,string serviceWorkspaceId)
    {
        try{
            string rallyResponse = '';
            string workspaceId = '';
            string resBody = '';
            string workspaceUrl = 'https://rally1.rallydev.com/slm/webservice/v2.0/workspace';            
            // if it is a test class, then it will go to the else loop
            if(!Test.isRunningTest())
            { 
                resBody = InvokeRallyApi(userName, password, workspaceUrl);
                if(resBody.contains('The username or password you entered is incorrect'))    {
                    rallyResponse = 'error';
                }
                else    {
                    rallyResponse = 'success';
                }
            }
            // Http Response for Test class
            else
            {
                 resBody = '{ "QueryResult": { "_rallyAPIMajor": "2", "_rallyAPIMinor": "0", "Errors": [], "Warnings": [], "TotalResultCount": 3,'
                                +'"StartIndex": 1, "PageSize": 100, "Results": [{ "_rallyAPIMajor": "2", "_rallyAPIMinor": "0",'
                                +'"_ref": "https://rally1.rallydev.com/slm/webservice/v2.0/hierarchicalrequirement/58381749777",'
                                +'"_refObjectUUID": "de008708-aad5-453f-8577-8faeb54a2014", "_objectVersion": "17",' 
                                +'"_refObjectName": "client payment email should come from toms@geographicfarm.com", "CreationDate": "2016-06-27T20:52:32.047Z",'
                                +'"_CreatedAt": "Jun 27, 2016", "FormattedID": "US82", "ScheduleState": "Completed", "_type": "HierarchicalRequirement" }] } }';   
            }
            Map<String,Object> jsonResp = (Map<String,Object>) JSON.deserializeUntyped(resBody);
            Map<String,Object> responsequery = (Map<String,Object>) jsonResp.get('QueryResult');  
            List<Object> responseResultLst = (List<Object>)responsequery.get('Results');
    
            Map<String,Object> Result = new Map<String,Object>();
        
            for(Object obj: responseResultLst)
            {
                Result=(Map<String,Object>) obj; 

                if(String.isBlank(ServiceWorkspaceId))               
                {
                    system.debug('============ServiceWorkspaceId null check'+ServiceWorkspaceId);
                    workspaceId = (string)Result.get('_ref');
                }
                else
                {
                    workspaceId= 'https://rally1.rallydev.com/slm/webservice/v2.0/workspace/'+ServiceWorkspaceId;
                }
   
            }
            system.debug('##WorkspaceId to be identified:' +workspaceId);
            return workspaceId;
        }
        catch(Exception ex){
            system.debug(ex);
            return null;
        }
    }
    
    /// <OBJECTIVE>
    /// Fetch sprint details (iterations) from rally for corresponding Account and Service.
    /// </OBJECTIVE>  
    public static void GetIterationByWorkspaceId(String userName, String password, String iterationUrl) 
    {
        try    {
            string resBody = '';
            // if it is a test class, then it will go to the else loop
            if(!Test.isRunningTest())      
                    resBody = InvokeRallyApi(userName, password, iterationUrl);
            
            // Http Response for Test class
            else    {
                InvokeRallyApi(userName, password, iterationUrl);
                    resBody = '{ "QueryResult": { "_rallyAPIMajor": "2", "_rallyAPIMinor": "0", "Errors": [], "Warnings": [], "TotalResultCount": 9,' 
                        +'"StartIndex": 1, "PageSize": 500, "Results": [{ "_ref": "https://rally1.rallydev.com/slm/webservice/v2.0/iteration/54397087370",' 
                        +'"_refObjectName": "Sprint #1", "EndDate": "2016-04-21T06:59:59.000Z", "StartDate": "2016-04-14T07:00:00.000Z", "_type": "Iteration" },' 
                        +'{ "_ref": "https://rally1.rallydev.com/slm/webservice/v2.0/iteration/54398000615", "_refObjectName": "Sprint #2",' 
                        +'"EndDate": "2016-05-05T06:59:59.000Z", "StartDate": "2016-04-21T07:00:00.000Z", "_type": "Iteration" }] } }';
            }
            if(!string.isEmpty(resBody )) 
                ODS_DashboardController.CalculateSprintGaps(resBody);
        }
        catch(Exception ex)    {
            system.debug(ex);
        }
    }
    
    public static string GetCompAcceptedUserstoriesTillDate(String userName, String password, String workspaceId)
    {
        String requirementUrl = '';
        string USCompAcceptResBody = '';
        try   
        {
            requirementUrl ='https://rally1.rallydev.com/slm/webservice/v2.0/hierarchicalrequirement?workspace=';
            requirementUrl += workspaceId+'&query=((ScheduleState%20=%20%22Completed%22)%20or%20(ScheduleState%20=%20%22Accepted%22))'
            +'&order=CreationDate&fetch=RevisionHistory,%20FormattedID,StartDate,EndDate,ScheduleState,CreationDate,PlanEstimate&pagesize=2000';
            system.debug('###Comp Accepted requirementUrl : '+requirementUrl);
            if(!Test.isRunningTest())   
                USCompAcceptResBody = InvokeRallyApi(userName, password, requirementUrl);
            else
            {
                USCompAcceptResBody=' {"QueryResult": {"_rallyAPIMajor": "2", "_rallyAPIMinor": "0", "Errors": [],'
                +' "Warnings": [], "TotalResultCount": 72, "StartIndex": 1, "PageSize": 1000,"Results": [{"_rallyAPIMajor": "2", "_rallyAPIMinor": "0",'
                +'"_ref": "https://rally1.rallydev.com/slm/webservice/v2.0/hierarchicalrequirement/63415898526",' 
                +'"_refObjectUUID": "64d51bc9-6b5f-44ec-ada7-679864d4fbac", "_objectVersion": "16",'
                +' "_refObjectName": "Create HTML Prototype", "CreationDate": "2016-09-21T13:00:06.255Z",'
                +' "_CreatedAt": "Sep 21, 2016", "RevisionHistory": {"_rallyAPIMajor": "2",'
                +' "_rallyAPIMinor": "0", "_ref": "https://rally1.rallydev.com/slm/webservice/v2.0/revisionhistory/63415898527",'
                +' "_refObjectUUID": "254894cb-98b4-45fe-ac6b-d84e9184cff6", "_objectVersion": "1",'
                +' "CreationDate": "2016-09-21T13:00:06.255Z", "_CreatedAt": "Sep 21, 2016", "_type": "RevisionHistory"},'
                +' "ScheduleState": "Accepted", "Blocked": false, "PlanEstimate": 56.0, "_type": "HierarchicalRequirement"}]}}';
            }
        }
                
        catch(Exception ex)    
        {
            system.debug(ex);
        }
        return USCompAcceptResBody;
    }
    
    public static string GetInprogressUserstoriesTillDate(String userName, String password, String workspaceId)
    {
        String requirementUrl = '';
        string USInprogressResBody = '';
        try   
        {
            requirementUrl ='https://rally1.rallydev.com/slm/webservice/v2.0/hierarchicalrequirement?workspace=';
            requirementUrl += workspaceId+'&query=(ScheduleState%20=%20%22In-Progress%22)'
            +'&order=CreationDate&fetch=RevisionHistory,%20FormattedID,StartDate,EndDate,ScheduleState,CreationDate,PlanEstimate&pagesize=2000';
            system.debug('##In Progress requirementUrl : '+requirementUrl);
            if(!Test.isRunningTest())   
                USInprogressResBody = InvokeRallyApi(userName, password, requirementUrl);
            else
            {
                USInprogressResBody =' {"QueryResult": {"_rallyAPIMajor": "2", "_rallyAPIMinor": "0", "Errors": [],'
                +' "Warnings": [], "TotalResultCount": 2, "StartIndex": 1, "PageSize": 1000,"Results": [{"_rallyAPIMajor": "2", "_rallyAPIMinor": "0",'
                +'"_ref": "https://rally1.rallydev.com/slm/webservice/v2.0/hierarchicalrequirement/63415898526",' 
                +'"_refObjectUUID": "64d51bc9-6b5f-44ec-ada7-679864d4fbac", "_objectVersion": "16",'
                +' "_refObjectName": "Create HTML Prototype", "CreationDate": "2016-09-21T13:00:06.255Z",'
                +' "_CreatedAt": "Sep 21, 2016", "RevisionHistory": {"_rallyAPIMajor": "2",'
                +' "_rallyAPIMinor": "0", "_ref": "https://rally1.rallydev.com/slm/webservice/v2.0/revisionhistory/63415898527",'
                +' "_refObjectUUID": "254894cb-98b4-45fe-ac6b-d84e9184cff6", "_objectVersion": "1",'
                +' "CreationDate": "2016-09-21T13:00:06.255Z", "_CreatedAt": "Sep 21, 2016", "_type": "RevisionHistory"},'
                +' "ScheduleState": "In-Progress", "Blocked": false, "PlanEstimate": 56.0, "_type": "HierarchicalRequirement"}]}}';
            }
        }
                
        catch(Exception ex)    
        {
            system.debug(ex);
        }
        return USInprogressResBody;
    }
    
    public static string GetRevisionsByDescription(String userName, String password, String changedFromStatus, String changedToStatus, String workspaceId)
    {
        string requirementUrl = '';
        string revisionsResBody = '';
        try   
        {
            requirementUrl = 'https://rally1.rallydev.com/slm/webservice/v2.0/Revisions?workspace='+ workspaceId +'&query='
                    + '((Description%20contains%20%22%20SCHEDULE%20STATE%20changed%20from%20['+ changedFromStatus
                    +']%20to%20['+ changedToStatus +']%22)%20OR%20(Description%20contains%20%22SCHEDULE%20STATE%20changed%20from%20['
                    + changedFromStatus +']%20to%20['+ changedToStatus +']%22))&fetch=RevisionHistory,Description,CreationDate'
                    + '&order=%20creationdate%20desc&pagesize=2000';              
            system.debug('requirementUrl Revisions By Description : '+requirementUrl);
            if(!Test.isRunningTest())   
                revisionsResBody = InvokeRallyApi(userName, password, requirementUrl); 
            else{
                revisionsResBody = '{"QueryResult": {"_rallyAPIMajor": "2","_rallyAPIMinor": "0","Errors": [],"Warnings": [],'
                        + '"TotalResultCount": 1,"StartIndex": 1,"PageSize": 20,"Results": [{"_rallyAPIMajor": "2","_rallyAPIMinor":'
                        + '"0","_ref": "https://rally1.rallydev.com/slm/webservice/v2.0/revision/99559765356","_refObjectUUID": '
                        + '"66839c77-4018-4da3-bed2-50789832e667","_objectVersion": "1","CreationDate": "2017-03-14T09:47:23.248Z",'
                        + '"_CreatedAt": "Mar 14","Description": "SCHEDULE STATE changed from [In-Progress] to [Completed], '
                        + 'FLOW STATE CHANGED DATE changed from [Thu Mar 02 02:05:40 MST 2017] to [Tue Mar 14 03:47:23 MDT 2017]",'
                        + '"RevisionHistory": {"_rallyAPIMajor": "2","_rallyAPIMinor": "0","_ref": "https://rally1.rallydev.com/slm'
                        + '/webservice/v2.0/revisionhistory/90589953168","_refObjectUUID": "580f6db7-6f32-4104-bdfe-bf46d5ee2244",'
                        + '"_objectVersion": "1","CreationDate": "2017-02-02T09:08:47.907Z","_CreatedAt": "Feb 2","_type": '
                        + '"RevisionHistory"},"_type": "Revision"}]}}' ;           
            }           
        }      
        catch(Exception ex)    
        {
            system.debug(ex);
        }
        return revisionsResBody;
    }
    
    
}