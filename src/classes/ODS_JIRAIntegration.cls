/**
 * @author           Kirankumar
 * @version          1.0 
 * @date             08/08/2017
 * @Status           Developed
 * @description      This is the controller class to fetch sprint details from JIRA
 *
 */
public class ODS_JIRAIntegration
{  
    /// <OBJECTIVE>
    /// Send http request and return response.
    /// </OBJECTIVE>  
    public static string InvokeJiraApi(string Usrname, String Passwrd,String EndPointUrl)
    {
        HTTPResponse response = new HTTPResponse();
        try 
        {
            HttpRequest request = new HttpRequest();
            request.setMethod('GET');
            request.setEndpoint(EndPointUrl);      
            Blob headerValue = Blob.valueOf(Usrname+ ':' + Passwrd);
            String authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(headerValue);
            request.setHeader('Authorization', authorizationHeader);
            system.debug('###request:' +request);
            Http http = new Http();
            response = http.send(request);
            system.debug('@@@'+response.getBody());
            
            string statusResponse = response.getStatus();
            system.debug('@@@statusResponse'+statusResponse);
            
            return response.getBody();
        }
        catch(Exception ex)    
        {
            system.debug('json Exception: '+ex);
            return 'error';
        }
    }
    
    //To get the Average Sprint
    public static Decimal GetAverageSprintGap (string Usrname,string Passwrd,String BoardId, String DomainName)
    {
        Decimal averageSprintGap=0;
        string responseJson='';
        try
        {
             
                String apiUrl = '';
                string jiraResponse = '';
                Map<String,Object> Result = new Map<String,Object>();
                List<sprint> sprintlist = new List<sprint>();
                //Url forming to fetch the list of sprints
                //apiUrl ='https://'+DomainName+'.atlassian.net/rest/agile/1.0/board/'+BoardId+'/sprint';
                apiUrl ='https://'+DomainName+'/rest/agile/1.0/board/'+BoardId+'/sprint';
                // if it is a test class, then it will go to the else loop
                if(!Test.isRunningTest())
                {
                    responseJson = InvokeJiraApi(Usrname,Passwrd,apiUrl);
                    system.debug('^^^responseJson'+responseJson);
                }
                
                else
                {
                    responseJson = '{"maxResults": 50,"startAt": 0,"isLast": true,"values": [{"id": 8,"self": "https://preludesysindia.atlassian.net/rest/agile/1.0/sprint/8","state": "closed","name": "WEDC Sprint 1","startDate": "2017-07-01T10:05:25.211Z","endDate": "2017-07-15T10:05:00.000Z","completeDate": "2017-08-24T10:08:54.581Z","originBoardId": 3,"goal": ""}, {"id": 9,"self": "https://preludesysindia.atlassian.net/rest/agile/1.0/sprint/9","state": "closed","name": "WEDC Sprint 2","startDate": "2017-07-23T10:09:00.000Z","endDate": "2017-07-31T10:09:00.000Z","completeDate": "2017-08-24T10:17:54.702Z","originBoardId": 3,"goal": ""}, {"id": 10,"self": "https://preludesysindia.atlassian.net/rest/agile/1.0/sprint/10","state": "active","name": "WEDC Sprint 3","startDate": "2017-08-13T10:18:35.631Z","endDate": "2017-08-31T10:18:00.000Z","originBoardId": 3,"goal": ""}]}';
                }
            
                if(responseJson.contains('Unauthorized') || responseJson.contains('error') || responseJson.contains('board cannot be viewed'))
                {
                    jiraResponse = 'error';
                    ODS_DashboardController.SetJiraResponse(jiraResponse);
                }
                else
                {
                     jiraResponse = 'success';
                     ODS_DashboardController.SetJiraResponse(jiraResponse);
                     
                
                Map<string,object> jsonResponse = (Map<string,object>)JSON.deserializeUntyped(responseJson);
                List<Object> responseResultLst = (List<Object>)jsonResponse.get('values');
                //To get the sprint start date and end date for the sprints
                for(Object obj : responseResultLst)
                {
                    Result=(Map<String,Object>) obj;
                    sprint Sprints = new sprint();
                    string stDate = (string)Result.get('startDate');
                    string edDate = (string)Result.get('endDate');
                    if(stDate != null && edDate != null)
                    {
                        Sprints.sprintName = (string)Result.get('name');
                        Sprints.startDate = date.valueof(StDate);
                        Sprints.endDate = date.valueof(EdDate);
                        sprintlist.add(Sprints);  
                    }
                }
                system.debug('##sprintlist'+sprintlist);
                Integer totalNumberOfDays = 0;
                Integer totalSprints = 0;
                Integer totalNoOfDaysExcludingWeekends=0;
                //Calculate number of weekends and remove it from the total number of days
                if(sprintlist.size() > 1)
                {
                    for(integer i=0; i<sprintlist.size()-1; i++)
                    {
                         Date currentSprintEndDt = sprintlist[i].endDate;
                         Date NextSprintStartDt = sprintlist[i+1].startDate;
                         DateTime CurrentSprintEndDateTime = DateTime.newInstance(currentSprintEndDt.Year(),currentSprintEndDt.Month(),currentSprintEndDt.Day());
                         DateTime nextSprintStartDateTime = DateTime.newInstance(NextSprintStartDt.Year(),NextSprintStartDt.Month(),NextSprintStartDt.Day());
                         totalNumberOfDays = currentSprintendDt.daysBetween(NextSprintstartDt);
                         Integer NoofWeekEndsDays =  ODS_DateUtility.calculateWeekends(CurrentSprintEndDateTime, nextSprintStartDateTime );
                         Integer workingDays = (totalNumberOfDays - NoofWeekEndsDays );
                         totalNoOfDaysExcludingWeekends += workingDays;
                         totalSprints = totalSprints + 1;
                         if(totalNoOfDaysExcludingWeekends < 0)
                         {
                            totalNoOfDaysExcludingWeekends = 0;
                         }
                    }
                }
                else
                {
                    totalNoOfDaysExcludingWeekends = 0;
                    system.debug('totalNoOfDaysExcludingWeekends '+totalNoOfDaysExcludingWeekends);
                }
                system.debug(' ^^^totalNoOfDaysExcludingWeekends  '+totalNoOfDaysExcludingWeekends );
                system.debug(' ^^^totalSprints '+(totalSprints+1));
                //averageSprintGap = totalNoOfDaysExcludingWeekends / (totalSprints+1);
                averageSprintGap = decimal.valueof(totalNoOfDaysExcludingWeekends).divide((totalSprints+1), 1);
                
                }
                system.debug(' ^^^averageSprintGap '+averageSprintGap);  
            
            
            
        }
        catch(Exception ex)    
        {
            system.debug(ex);
        }
        return averageSprintGap;
    }
    
    //To get the Count of the Completed User Stories for life time
    public static Integer GetCompletedUserstoriesTillDate(String userName, String password, String BoardId,string domainName)
    {
        String apiUrl = '';
        string USCompletedResBody = '';
        Integer completedUserStories = 0;
        string jiraResponse = '';
        
        try   
        {
            //Url forming to get the Completed user stories
            //apiUrl = 'https://'+DomainName+'.atlassian.net/rest/agile/1.0/board/'+BoardId+'/issue?jql=%20sprint%20!=%20null%20and%20issueType=Story%20and%20status%20=%20Done%20and%20sprint%20in%20(OpenSprints()%20,%20ClosedSprints())';
            apiUrl = 'https://'+DomainName+'/rest/agile/1.0/board/'+BoardId+'/issue?jql=%20sprint%20!=%20null%20and%20issueType=Story%20and%20status%20=%20Done%20and%20sprint%20in%20(OpenSprints()%20,%20ClosedSprints())';
            system.debug('###apiUrl :' +apiUrl);
            // if it is a test class, then it will go to the else loop
            if(!Test.isRunningTest())
            {
                USCompletedResBody = InvokeJiraApi(userName, password,apiUrl);
                system.debug('$$$USCompletedResBody'+USCompletedResBody );
            }
            
            else
            {
                USCompletedResBody  = '{"expand": "schema,names","startAt": 0,"maxResults": 50,"total": 4,"issues": [{"expand": "operations,versionedRepresentations,editmeta,changelog,renderedFields","id": "10000","fields": {"issuetype": {"self": "https://preludesysindia.atlassian.net/rest/api/2/issuetype/10001","id": "10001","description": "A user story. Created by JIRA Software - do not edit or delete.","iconUrl": "https://preludesysindia.atlassian.net/images/icons/issuetypes/story.svg","name": "Story","subtask": false},"sprint": null,"project": {"self": "https://preludesysindia.atlassian.net/rest/api/2/project/10001","id": "10001","key": "DN","name": "Dot Net",},"resolution": {"self": "https://preludesysindia.atlassian.net/rest/api/2/resolution/10000","id": "10000","description": "Work has been completed on this issue.","name": "Done"},"resolutiondate": "2017-08-10T12:47:36.375+0530","workratio": -1,"lastViewed": "2017-08-10T12:49:17.542+0530","created": "2017-08-09T15:28:49.873+0530","epic": null,"labels": [],"updated": "2017-08-10T12:47:36.390+0530","status": {"self": "https://preludesysindia.atlassian.net/rest/api/2/status/10001","description": "","iconUrl": "https://preludesysindia.atlassian.net/","name": "Done","id": "10001","statusCategory": {"self": "https://preludesysindia.atlassian.net/rest/api/2/statuscategory/3","id": 3,"key": "done","colorName": "green","name": "Done"}},"summary": "Design Document",}}]}';
            }   
                
            if(USCompletedResBody.contains('Unauthorized') || USCompletedResBody.contains('error') || USCompletedResBody.contains('board cannot be viewed'))
            {
                jiraResponse = 'error';
                ODS_DashboardController.SetJiraResponse(jiraResponse);
                system.debug('$$$jiraResponse'+jiraResponse);
            }
            
            else
            {
            jiraResponse = 'success';
            ODS_DashboardController.SetJiraResponse(jiraResponse);
            Map<string,object> jsonResponse = (Map<string,object>)JSON.deserializeUntyped(USCompletedResBody);
            object completedUserStoriesobj = jsonResponse.get('total');
            completedUserStories = integer.valueOf(completedUserStoriesobj);
            system.debug('%%%completedUserStories'+completedUserStories);
            }
        }
        catch(Exception ex)    
        {
            system.debug(ex);
        }
        return completedUserStories;
    
    }    
    
    public static Integer GetMonthlyCompletedUserStories(String userName, String password, String BoardId,string domainName,string Month,string year) 
    {
        string apiUrl = '';
        string USMonthlyCompletedResBody = '';
        Integer monthlyCompletedSprintCount = 0;
        string jiraResponse='';
        
        Map<Date,Integer> mapCompletedUserstoriesDate = new Map<Date,Integer>(); 
        try
        {
            //apiUrl = 'https://'+DomainName+'.atlassian.net/rest/agile/1.0/board/'+BoardId+'/issue?jql=issuetype%20=%20story%20and%20sprint%20in%20(%20OpenSprints(),ClosedSprints())%20and%20status%20=%20done';
            apiUrl = 'https://'+DomainName+'/rest/agile/1.0/board/'+BoardId+'/issue?jql=issuetype%20=%20story%20and%20sprint%20in%20(%20OpenSprints(),ClosedSprints())%20and%20status%20=%20done';
            system.debug('###apiUrl :' +apiUrl);
             if(!Test.isRunningTest())
             {
                USMonthlyCompletedResBody = InvokeJiraApi(userName, password,apiUrl);
                system.debug('^^^USMonthlyCompletedResBody '+USMonthlyCompletedResBody);
             }
             
             else
             {
                 USMonthlyCompletedResBody = '{"expand":"schema,names","startAt":0,"maxResults":50,"total":4,"issues":[{"expand":"operations,versionedRepresentations,editmeta,changelog,renderedFields","id":"10000","self":"https://preludesysindia.atlassian.net/rest/agile/1.0/issue/10000","key":"DN-1","fields":{"issuetype":{"self":"https://preludesysindia.atlassian.net/rest/api/2/issuetype/10001","id":"10001","description":"A user story. Created by JIRA Software - do not edit or delete.","iconUrl":"https://preludesysindia.atlassian.net/images/icons/issuetypes/story.svg","name":"Story","subtask":false},"timespent":null,"sprint":null,"project":{"self":"https://preludesysindia.atlassian.net/rest/api/2/project/10001","id":"10001","key":"DN","name":"Dot Net","avatarUrls":{"48x48":"https://preludesysindia.atlassian.net/secure/projectavatar?avatarId=10324","24x24":"https://preludesysindia.atlassian.net/secure/projectavatar?size=small&avatarId=10324","16x16":"https://preludesysindia.atlassian.net/secure/projectavatar?size=xsmall&avatarId=10324","32x32":"https://preludesysindia.atlassian.net/secure/projectavatar?size=medium&avatarId=10324"}},"fixVersions":[],"aggregatetimespent":null,"resolution":{"self":"https://preludesysindia.atlassian.net/rest/api/2/resolution/10000","id":"10000","description":"Work has been completed on this issue.","name":"Done"},"resolutiondate":"2017-08-10T12:47:36.375+0530","workratio":-1,"lastViewed":"2017-08-10T12:49:17.542+0530","watches":{"self":"https://preludesysindia.atlassian.net/rest/api/2/issue/DN-1/watchers","watchCount":1,"isWatching":true},"created":"2017-08-09T15:28:49.873+0530","epic":null,"priority":{"self":"https://preludesysindia.atlassian.net/rest/api/2/priority/3","iconUrl":"https://preludesysindia.atlassian.net/images/icons/priorities/medium.svg","name":"Medium","id":"3"},"labels":[],"aggregatetimeoriginalestimate":null,"timeestimate":null,"versions":[],"issuelinks":[],"assignee":null,"updated":"2017-08-10T12:47:36.390+0530","status":{"self":"https://preludesysindia.atlassian.net/rest/api/2/status/10001","description":"","iconUrl":"https://preludesysindia.atlassian.net/","name":"Done","id":"10001","statusCategory":{"self":"https://preludesysindia.atlassian.net/rest/api/2/statuscategory/3","id":3,"key":"done","colorName":"green","name":"Done"}},"components":[],"customfield_10050":null,"customfield_10051":null,"timeoriginalestimate":null,"customfield_10052":null,"description":null,"customfield_10053":null,"customfield_10054":null,"customfield_10010":["com.atlassian.greenhopper.service.sprint.Sprint@1ce79a[id=1,rapidViewId=2,state=CLOSED,name=Sprint 1,goal=,startDate=2017-08-10T09:04:45.869Z,endDate=2017-08-24T09:04:00.000Z,completeDate=2017-08-16T06:41:51.863Z,sequence=1]"],"customfield_10055":null,"customfield_10011":"0&#124;hzzzzz:","customfield_10012":null,"customfield_10013":"3_*:*_1_*:*_198397_*&#124;*_10000_*:*_1_*:*_76528122_*&#124;*_10001_*:*_1_*:*_0","timetracking":{},"customfield_10049":null,"customfield_10008":null,"attachment":[],"customfield_10009":null,"aggregatetimeestimate":null,"flagged":false,"summary":"Design Document","creator":{"self":"https://preludesysindia.atlassian.net/rest/api/2/user?username=admin","name":"admin","key":"admin","accountId":"557058:1c7f9ba7-1bc9-4322-842f-0224c2688cce","emailAddress":"gnanaprakasam_g@preludesys.com","avatarUrls":{"48x48":"https://avatar-cdn.atlassian.com/c5b3d85ce720897ecc873dfa6b436daf?s=48&d=https%3A%2F%2Fsecure.gravatar.com%2Favatar%2Fc5b3d85ce720897ecc873dfa6b436daf%3Fd%3Dmm%26s%3D48%26noRedirect%3Dtrue","24x24":"https://avatar-cdn.atlassian.com/c5b3d85ce720897ecc873dfa6b436daf?s=24&d=https%3A%2F%2Fsecure.gravatar.com%2Favatar%2Fc5b3d85ce720897ecc873dfa6b436daf%3Fd%3Dmm%26s%3D24%26noRedirect%3Dtrue","16x16":"https://avatar-cdn.atlassian.com/c5b3d85ce720897ecc873dfa6b436daf?s=16&d=https%3A%2F%2Fsecure.gravatar.com%2Favatar%2Fc5b3d85ce720897ecc873dfa6b436daf%3Fd%3Dmm%26s%3D16%26noRedirect%3Dtrue","32x32":"https://avatar-cdn.atlassian.com/c5b3d85ce720897ecc873dfa6b436daf?s=32&d=https%3A%2F%2Fsecure.gravatar.com%2Favatar%2Fc5b3d85ce720897ecc873dfa6b436daf%3Fd%3Dmm%26s%3D32%26noRedirect%3Dtrue"},"displayName":"Preludesys India","active":true,"timeZone":"Asia/Kolkata"},"subtasks":[],"reporter":{"self":"https://preludesysindia.atlassian.net/rest/api/2/user?username=admin","name":"admin","key":"admin","accountId":"557058:1c7f9ba7-1bc9-4322-842f-0224c2688cce","emailAddress":"gnanaprakasam_g@preludesys.com","avatarUrls":{"48x48":"https://avatar-cdn.atlassian.com/c5b3d85ce720897ecc873dfa6b436daf?s=48&d=https%3A%2F%2Fsecure.gravatar.com%2Favatar%2Fc5b3d85ce720897ecc873dfa6b436daf%3Fd%3Dmm%26s%3D48%26noRedirect%3Dtrue","24x24":"https://avatar-cdn.atlassian.com/c5b3d85ce720897ecc873dfa6b436daf?s=24&d=https%3A%2F%2Fsecure.gravatar.com%2Favatar%2Fc5b3d85ce720897ecc873dfa6b436daf%3Fd%3Dmm%26s%3D24%26noRedirect%3Dtrue","16x16":"https://avatar-cdn.atlassian.com/c5b3d85ce720897ecc873dfa6b436daf?s=16&d=https%3A%2F%2Fsecure.gravatar.com%2Favatar%2Fc5b3d85ce720897ecc873dfa6b436daf%3Fd%3Dmm%26s%3D16%26noRedirect%3Dtrue","32x32":"https://avatar-cdn.atlassian.com/c5b3d85ce720897ecc873dfa6b436daf?s=32&d=https%3A%2F%2Fsecure.gravatar.com%2Favatar%2Fc5b3d85ce720897ecc873dfa6b436daf%3Fd%3Dmm%26s%3D32%26noRedirect%3Dtrue"},"displayName":"Preludesys India","active":true,"timeZone":"Asia/Kolkata"},"customfield_10000":"{}","aggregateprogress":{"progress":0,"total":0},"customfield_10001":null,"customfield_10046":null,"customfield_10002":null,"customfield_10003":null,"customfield_10004":null,"environment":null,"duedate":null,"closedSprints":[{"id":1,"self":"https://preludesysindia.atlassian.net/rest/agile/1.0/sprint/1","state":"closed","name":"Sprint 1","startDate":"2017-08-10T09:04:45.869Z","endDate":"2017-08-24T09:04:00.000Z","completeDate":"2017-08-16T06:41:51.863Z","originBoardId":2,"goal":""}],"progress":{"progress":0,"total":0},"comment":{"comments":[],"maxResults":0,"total":0,"startAt":0},"votes":{"self":"https://preludesysindia.atlassian.net/rest/api/2/issue/DN-1/votes","votes":0,"hasVoted":false},"worklog":{"startAt":0,"maxResults":20,"total":0,"worklogs":[]}}},{"expand":"operations,versionedRepresentations,editmeta,changelog,renderedFields","id":"10001","self":"https://preludesysindia.atlassian.net/rest/agile/1.0/issue/10001","key":"DN-2","fields":{"issuetype":{"self":"https://preludesysindia.atlassian.net/rest/api/2/issuetype/10001","id":"10001","description":"A user story. Created by JIRA Software - do not edit or delete.","iconUrl":"https://preludesysindia.atlassian.net/images/icons/issuetypes/story.svg","name":"Story","subtask":false},"timespent":null,"sprint":null,"project":{"self":"https://preludesysindia.atlassian.net/rest/api/2/project/10001","id":"10001","key":"DN","name":"Dot Net","avatarUrls":{"48x48":"https://preludesysindia.atlassian.net/secure/projectavatar?avatarId=10324","24x24":"https://preludesysindia.atlassian.net/secure/projectavatar?size=small&avatarId=10324","16x16":"https://preludesysindia.atlassian.net/secure/projectavatar?size=xsmall&avatarId=10324","32x32":"https://preludesysindia.atlassian.net/secure/projectavatar?size=medium&avatarId=10324"}},"fixVersions":[],"aggregatetimespent":null,"resolution":{"self":"https://preludesysindia.atlassian.net/rest/api/2/resolution/10000","id":"10000","description":"Work has been completed on this issue.","name":"Done"},"resolutiondate":"2017-08-16T11:58:21.559+0530","workratio":-1,"lastViewed":"2017-08-16T11:58:21.529+0530","watches":{"self":"https://preludesysindia.atlassian.net/rest/api/2/issue/DN-2/watchers","watchCount":1,"isWatching":true},"created":"2017-08-09T15:29:17.008+0530","epic":null,"priority":{"self":"https://preludesysindia.atlassian.net/rest/api/2/priority/3","iconUrl":"https://preludesysindia.atlassian.net/images/icons/priorities/medium.svg","name":"Medium","id":"3"},"labels":[],"aggregatetimeoriginalestimate":null,"timeestimate":null,"versions":[],"issuelinks":[],"assignee":null,"updated":"2017-08-16T11:58:21.566+0530","status":{"self":"https://preludesysindia.atlassian.net/rest/api/2/status/10001","description":"","iconUrl":"https://preludesysindia.atlassian.net/","name":"Done","id":"10001","statusCategory":{"self":"https://preludesysindia.atlassian.net/rest/api/2/statuscategory/3","id":3,"key":"done","colorName":"green","name":"Done"}},"components":[],"customfield_10050":null,"customfield_10051":null,"timeoriginalestimate":null,"customfield_10052":null,"description":null,"customfield_10053":null,"customfield_10054":null,"customfield_10010":["com.atlassian.greenhopper.service.sprint.Sprint@1ce79a[id=1,rapidViewId=2,state=CLOSED,name=Sprint 1,goal=,startDate=2017-08-10T09:04:45.869Z,endDate=2017-08-24T09:04:00.000Z,completeDate=2017-08-16T06:41:51.863Z,sequence=1]"],"customfield_10055":null,"customfield_10011":"0&#124;i00007:","customfield_10012":null,"customfield_10013":"3_*:*_1_*:*_515168169_*&#124;*_10000_*:*_1_*:*_76976396_*&#124;*_10001_*:*_1_*:*_0","timetracking":{},"customfield_10049":null,"customfield_10008":null,"aggregatetimeestimate":null,"customfield_10009":null,"attachment":[],"flagged":false,"summary":"Understanding Document","creator":{"self":"https://preludesysindia.atlassian.net/rest/api/2/user?username=admin","name":"admin","key":"admin","accountId":"557058:1c7f9ba7-1bc9-4322-842f-0224c2688cce","emailAddress":"gnanaprakasam_g@preludesys.com","avatarUrls":{"48x48":"https://avatar-cdn.atlassian.com/c5b3d85ce720897ecc873dfa6b436daf?s=48&d=https%3A%2F%2Fsecure.gravatar.com%2Favatar%2Fc5b3d85ce720897ecc873dfa6b436daf%3Fd%3Dmm%26s%3D48%26noRedirect%3Dtrue","24x24":"https://avatar-cdn.atlassian.com/c5b3d85ce720897ecc873dfa6b436daf?s=24&d=https%3A%2F%2Fsecure.gravatar.com%2Favatar%2Fc5b3d85ce720897ecc873dfa6b436daf%3Fd%3Dmm%26s%3D24%26noRedirect%3Dtrue","16x16":"https://avatar-cdn.atlassian.com/c5b3d85ce720897ecc873dfa6b436daf?s=16&d=https%3A%2F%2Fsecure.gravatar.com%2Favatar%2Fc5b3d85ce720897ecc873dfa6b436daf%3Fd%3Dmm%26s%3D16%26noRedirect%3Dtrue","32x32":"https://avatar-cdn.atlassian.com/c5b3d85ce720897ecc873dfa6b436daf?s=32&d=https%3A%2F%2Fsecure.gravatar.com%2Favatar%2Fc5b3d85ce720897ecc873dfa6b436daf%3Fd%3Dmm%26s%3D32%26noRedirect%3Dtrue"},"displayName":"Preludesys India","active":true,"timeZone":"Asia/Kolkata"},"subtasks":[],"reporter":{"self":"https://preludesysindia.atlassian.net/rest/api/2/user?username=admin","name":"admin","key":"admin","accountId":"557058:1c7f9ba7-1bc9-4322-842f-0224c2688cce","emailAddress":"gnanaprakasam_g@preludesys.com","avatarUrls":{"48x48":"https://avatar-cdn.atlassian.com/c5b3d85ce720897ecc873dfa6b436daf?s=48&d=https%3A%2F%2Fsecure.gravatar.com%2Favatar%2Fc5b3d85ce720897ecc873dfa6b436daf%3Fd%3Dmm%26s%3D48%26noRedirect%3Dtrue","24x24":"https://avatar-cdn.atlassian.com/c5b3d85ce720897ecc873dfa6b436daf?s=24&d=https%3A%2F%2Fsecure.gravatar.com%2Favatar%2Fc5b3d85ce720897ecc873dfa6b436daf%3Fd%3Dmm%26s%3D24%26noRedirect%3Dtrue","16x16":"https://avatar-cdn.atlassian.com/c5b3d85ce720897ecc873dfa6b436daf?s=16&d=https%3A%2F%2Fsecure.gravatar.com%2Favatar%2Fc5b3d85ce720897ecc873dfa6b436daf%3Fd%3Dmm%26s%3D16%26noRedirect%3Dtrue","32x32":"https://avatar-cdn.atlassian.com/c5b3d85ce720897ecc873dfa6b436daf?s=32&d=https%3A%2F%2Fsecure.gravatar.com%2Favatar%2Fc5b3d85ce720897ecc873dfa6b436daf%3Fd%3Dmm%26s%3D32%26noRedirect%3Dtrue"},"displayName":"Preludesys India","active":true,"timeZone":"Asia/Kolkata"},"aggregateprogress":{"progress":0,"total":0},"customfield_10000":"{}","customfield_10001":null,"customfield_10046":null,"customfield_10002":null,"customfield_10003":null,"customfield_10004":null,"environment":null,"duedate":null,"closedSprints":[{"id":1,"self":"https://preludesysindia.atlassian.net/rest/agile/1.0/sprint/1","state":"closed","name":"Sprint 1","startDate":"2017-08-10T09:04:45.869Z","endDate":"2017-08-24T09:04:00.000Z","completeDate":"2017-08-16T06:41:51.863Z","originBoardId":2,"goal":""}],"progress":{"progress":0,"total":0},"comment":{"comments":[],"maxResults":0,"total":0,"startAt":0},"votes":{"self":"https://preludesysindia.atlassian.net/rest/api/2/issue/DN-2/votes","votes":0,"hasVoted":false},"worklog":{"startAt":0,"maxResults":20,"total":0,"worklogs":[]}}}]}';
             }
            
            if(USMonthlyCompletedResBody.contains('Unauthorized') ||  USMonthlyCompletedResBody.contains('error') || USMonthlyCompletedResBody.contains('board cannot be viewed'))
            {
                jiraResponse = 'error';
                ODS_DashboardController.SetJiraResponse(jiraResponse);
                system.debug('$$$jiraResponse'+jiraResponse);
            }
            
            else
            {
                jiraResponse = 'success';
                ODS_DashboardController.SetJiraResponse(jiraResponse);
                system.debug(USMonthlyCompletedResBody);
                Map<string,object> jsonResponse = (Map<string,object>)JSON.deserializeUntyped(USMonthlyCompletedResBody);
                List<Object> responseResultLst = (List<Object>)jsonResponse.get('issues');
                Map<String,Object> Result = new Map<String,Object>();
                Map<String,Object> FieldsResult = new Map<String,Object>();
                Map<String,Object> SprintResult = new Map<String,Object>();
                Map<string,Date> sptintIdWithResolutionDate = new Map<string,Date>();
                string timestring = 'T00:00:00.000Z';
                for(Object responseResult: responseResultLst)
                 {
                    Result=(Map<String,Object>) responseResult;
                    string SprintId = string.valueof(Result.get('id'));
                    FieldsResult = (Map<String,Object>)Result.get('fields');
                    string ReslDate = string.valueOf(FieldsResult.get('resolutiondate'));
                    List<string> FormattedDate = ReslDate.split('T');
                    List<String> ResolutionDateUnFormatted = FormattedDate[0].split('-');
                    Integer IntDate = integer.valueOf(ResolutionDateUnFormatted[0]);
                    Integer IntMonth = integer.valueOf(ResolutionDateUnFormatted[1]);
                    Integer IntYear = integer.valueOf(ResolutionDateUnFormatted[2]);
                    Date ResolutionDate = Date.newInstance(IntDate,IntMonth,IntYear);
                    sptintIdWithResolutionDate.put(SprintId,ResolutionDate);
                    
                   
    
                  }
                system.debug('$$$sptintIdWithResolutionDate'+sptintIdWithResolutionDate);
                Date startDate;
                Date lastDayOfMonth;
                if(Month == '0')
                {
                    startDate = Date.newInstance(integer.valueOf(year), 1, 1);
                    lastDayOfMonth = Date.newInstance(startDate.year(), 12, 31);
                }
                else
                {
                    startDate = Date.newInstance(integer.valueOf(year), integer.valueOf(Month), 1);
                    Integer numberOfDays = Date.daysInMonth(startDate.year(), startDate.month());
                    lastDayOfMonth = Date.newInstance(startDate.year(), startDate.month(), numberOfDays);
                }
                
                string formattedMonthfirstDate = String.valueOf(startDate.toStartOfMonth())+timestring ;
                string formattedMonthLastDate = String.valueOf(lastDayOfMonth )+timestring;
                for(Date ResolutionDt : sptintIdWithResolutionDate.values())
                {
                    if(ResolutionDt >= startDate && ResolutionDt <= lastDayOfMonth)
                    {
                        monthlyCompletedSprintCount = monthlyCompletedSprintCount + 1;
                    }
                    
                     
                }
                
                Integer count = 0;
                for(Date ResolutionDt : sptintIdWithResolutionDate.values())
                {
                        if(mapCompletedUserstoriesDate.containskey(ResolutionDt))
                        {
                            count = mapCompletedUserstoriesDate.get(ResolutionDt)+1;
                            
                            
                        }
                        else
                        {
                            count = 0;
                            count = count + 1;
                            
                        }
                mapCompletedUserstoriesDate.put(ResolutionDt,count);
                }
                system.debug('###$monthlyCompletedSprint'+monthlyCompletedSprintCount);
                system.debug('###$mapCompletedUserstoriesDate'+mapCompletedUserstoriesDate);
            }
    } 
    catch(Exception ex)    
    {
        system.debug(ex);
    }
        
    return monthlyCompletedSprintCount;
    }
    
    public static Integer GetMonthlyInProgressUS(String userName, String password, String BoardId,string domainName,string Month,string year)
    {
        string apiUrl = '';
        string USMonthlyInProgressResBody = '';
        Integer monthlyInProgressSprintCount = 0;
        string jiraResponse = '';
         
        try
        {
            //apiUrl = 'https://'+DomainName+'.atlassian.net/rest/agile/1.0/board/'+BoardId+'/issue?jql=issuetype%20=%20story%20and%20sprint%20in%20(OpenSprints())%20and%20status%20=%20%27In%20Progress%27';
            apiUrl = 'https://'+DomainName+'/rest/agile/1.0/board/'+BoardId+'/issue?jql=issuetype%20=%20story%20and%20sprint%20in%20(OpenSprints())%20and%20status%20=%20%27In%20Progress%27';
            
            if(!Test.isRunningTest())
             {
                USMonthlyInProgressResBody = InvokeJiraApi(userName, password,apiUrl);
                system.debug('^^^USMonthlyInProgressResBody '+USMonthlyInProgressResBody);
             }
             
             else
             {
                 USMonthlyInProgressResBody  = '{"expand":"schema,names","startAt":0,"maxResults":50,"total":2,"issues":[{"expand":"operations,versionedRepresentations,editmeta,changelog,renderedFields","id":"10005","self":"https://preludesysindia.atlassian.net/rest/agile/1.0/issue/10005","key":"DN-6","fields":{"issuetype":{"self":"https://preludesysindia.atlassian.net/rest/api/2/issuetype/10001","id":"10001","description":"A user story. Created by JIRA Software - do not edit or delete.","iconUrl":"https://preludesysindia.atlassian.net/images/icons/issuetypes/story.svg","name":"Story","subtask":false},"timespent":null,"sprint":{"id":3,"self":"https://preludesysindia.atlassian.net/rest/agile/1.0/sprint/3","state":"active","name":"Sprint 3","startDate":"2017-09-11T06:47:00.000Z","endDate":"2017-09-29T06:47:00.000Z","originBoardId":2,"goal":""},"project":{"self":"https://preludesysindia.atlassian.net/rest/api/2/project/10001","id":"10001","key":"DN","name":"Dot Net","avatarUrls":{"48x48":"https://preludesysindia.atlassian.net/secure/projectavatar?avatarId=10324","24x24":"https://preludesysindia.atlassian.net/secure/projectavatar?size=small&avatarId=10324","16x16":"https://preludesysindia.atlassian.net/secure/projectavatar?size=xsmall&avatarId=10324","32x32":"https://preludesysindia.atlassian.net/secure/projectavatar?size=medium&avatarId=10324"}},"fixVersions":[],"aggregatetimespent":null,"resolution":null,"resolutiondate":null,"workratio":-1,"lastViewed":"2017-08-22T12:29:31.519+0530","watches":{"self":"https://preludesysindia.atlassian.net/rest/api/2/issue/DN-6/watchers","watchCount":1,"isWatching":true},"created":"2017-08-09T15:30:40.791+0530","epic":null,"priority":{"self":"https://preludesysindia.atlassian.net/rest/api/2/priority/3","iconUrl":"https://preludesysindia.atlassian.net/images/icons/priorities/medium.svg","name":"Medium","id":"3"},"labels":[],"timeestimate":null,"aggregatetimeoriginalestimate":null,"versions":[],"issuelinks":[],"assignee":null,"updated":"2017-08-22T17:53:03.329+0530","status":{"self":"https://preludesysindia.atlassian.net/rest/api/2/status/3","description":"This issue is being actively worked on at the moment by the assignee.","iconUrl":"https://preludesysindia.atlassian.net/images/icons/statuses/inprogress.png","name":"In Progress","id":"3","statusCategory":{"self":"https://preludesysindia.atlassian.net/rest/api/2/statuscategory/4","id":4,"key":"indeterminate","colorName":"yellow","name":"In Progress"}},"components":[],"customfield_10050":null,"customfield_10051":null,"timeoriginalestimate":null,"customfield_10052":null,"description":null,"customfield_10053":null,"customfield_10054":null,"customfield_10010":["com.atlassian.greenhopper.service.sprint.Sprint@4ff49014[id=3,rapidViewId=2,state=ACTIVE,name=Sprint 3,goal=,startDate=2017-09-11T06:47:00.000Z,endDate=2017-09-29T06:47:00.000Z,completeDate=<null>,sequence=3]"],"customfield_10011":"0&#124;i00013:","customfield_10055":null,"customfield_10012":null,"customfield_10013":null,"timetracking":{},"customfield_10049":null,"customfield_10008":null,"attachment":[],"customfield_10009":null,"aggregatetimeestimate":null,"flagged":false,"summary":"Deployment Document","creator":{"self":"https://preludesysindia.atlassian.net/rest/api/2/user?username=admin","name":"admin","key":"admin","accountId":"557058:1c7f9ba7-1bc9-4322-842f-0224c2688cce","emailAddress":"gnanaprakasam_g@preludesys.com","avatarUrls":{"48x48":"https://avatar-cdn.atlassian.com/c5b3d85ce720897ecc873dfa6b436daf?s=48&d=https%3A%2F%2Fsecure.gravatar.com%2Favatar%2Fc5b3d85ce720897ecc873dfa6b436daf%3Fd%3Dmm%26s%3D48%26noRedirect%3Dtrue","24x24":"https://avatar-cdn.atlassian.com/c5b3d85ce720897ecc873dfa6b436daf?s=24&d=https%3A%2F%2Fsecure.gravatar.com%2Favatar%2Fc5b3d85ce720897ecc873dfa6b436daf%3Fd%3Dmm%26s%3D24%26noRedirect%3Dtrue","16x16":"https://avatar-cdn.atlassian.com/c5b3d85ce720897ecc873dfa6b436daf?s=16&d=https%3A%2F%2Fsecure.gravatar.com%2Favatar%2Fc5b3d85ce720897ecc873dfa6b436daf%3Fd%3Dmm%26s%3D16%26noRedirect%3Dtrue","32x32":"https://avatar-cdn.atlassian.com/c5b3d85ce720897ecc873dfa6b436daf?s=32&d=https%3A%2F%2Fsecure.gravatar.com%2Favatar%2Fc5b3d85ce720897ecc873dfa6b436daf%3Fd%3Dmm%26s%3D32%26noRedirect%3Dtrue"},"displayName":"Preludesys India","active":true,"timeZone":"Asia/Kolkata"},"subtasks":[],"reporter":{"self":"https://preludesysindia.atlassian.net/rest/api/2/user?username=admin","name":"admin","key":"admin","accountId":"557058:1c7f9ba7-1bc9-4322-842f-0224c2688cce","emailAddress":"gnanaprakasam_g@preludesys.com","avatarUrls":{"48x48":"https://avatar-cdn.atlassian.com/c5b3d85ce720897ecc873dfa6b436daf?s=48&d=https%3A%2F%2Fsecure.gravatar.com%2Favatar%2Fc5b3d85ce720897ecc873dfa6b436daf%3Fd%3Dmm%26s%3D48%26noRedirect%3Dtrue","24x24":"https://avatar-cdn.atlassian.com/c5b3d85ce720897ecc873dfa6b436daf?s=24&d=https%3A%2F%2Fsecure.gravatar.com%2Favatar%2Fc5b3d85ce720897ecc873dfa6b436daf%3Fd%3Dmm%26s%3D24%26noRedirect%3Dtrue","16x16":"https://avatar-cdn.atlassian.com/c5b3d85ce720897ecc873dfa6b436daf?s=16&d=https%3A%2F%2Fsecure.gravatar.com%2Favatar%2Fc5b3d85ce720897ecc873dfa6b436daf%3Fd%3Dmm%26s%3D16%26noRedirect%3Dtrue","32x32":"https://avatar-cdn.atlassian.com/c5b3d85ce720897ecc873dfa6b436daf?s=32&d=https%3A%2F%2Fsecure.gravatar.com%2Favatar%2Fc5b3d85ce720897ecc873dfa6b436daf%3Fd%3Dmm%26s%3D32%26noRedirect%3Dtrue"},"displayName":"Preludesys India","active":true,"timeZone":"Asia/Kolkata"},"customfield_10000":"{}","aggregateprogress":{"progress":0,"total":0},"customfield_10001":null,"customfield_10046":null,"customfield_10002":null,"customfield_10003":null,"customfield_10004":null,"environment":null,"duedate":null,"progress":{"progress":0,"total":0},"votes":{"self":"https://preludesysindia.atlassian.net/rest/api/2/issue/DN-6/votes","votes":0,"hasVoted":false},"comment":{"comments":[],"maxResults":0,"total":0,"startAt":0},"worklog":{"startAt":0,"maxResults":20,"total":0,"worklogs":[]}}}]}';
             }
            
            
            
            if(USMonthlyInProgressResBody.contains('Unauthorized') || USMonthlyInProgressResBody.contains('error') || USMonthlyInProgressResBody.contains('board cannot be viewed'))
            {
                jiraResponse = 'error';
                ODS_DashboardController.SetJiraResponse(jiraResponse);
                system.debug('$$$jiraResponse'+jiraResponse);
            }
            
            else
            {
            jiraResponse = 'success';
            ODS_DashboardController.SetJiraResponse(jiraResponse);
            Map<string,object> jsonResponse = (Map<string,object>)JSON.deserializeUntyped(USMonthlyInProgressResBody);
            List<Object> responseResultLst = (List<Object>)jsonResponse.get('issues');
            Map<String,Object> Result = new Map<String,Object>();
            Map<String,Object> FieldsResult = new Map<String,Object>();
            Map<String,Object> SprintResult = new Map<String,Object>();
            Map<string,Date> SprintIdWithUpdatedDate = new Map<string,Date>();
            string timestring = 'T00:00:00.000Z';
            for(Object responseResult: responseResultLst)
             {
                Result=(Map<String,Object>) responseResult;
                string SprintId = string.valueof(Result.get('id'));
                FieldsResult = (Map<String,Object>)Result.get('fields');
                string updatedDateStr = string.valueOf(FieldsResult.get('updated'));
                List<string> FormattedDate = updatedDateStr.split('T');
                List<String> UpdatedDateUnFormatted = FormattedDate[0].split('-');
                Integer IntDate = integer.valueOf(UpdatedDateUnFormatted[0]);
                Integer IntMonth = integer.valueOf(UpdatedDateUnFormatted[1]);
                Integer IntYear = integer.valueOf(UpdatedDateUnFormatted[2]);
                Date UpdatedDate = Date.newInstance(IntDate,IntMonth,IntYear);
                SprintIdWithUpdatedDate.put(SprintId,UpdatedDate);
            }
            system.debug('##SprintIdWithUpdatedDate'+SprintIdWithUpdatedDate);
            Date startDate;
            Date lastDayOfMonth;
            if(Month == '0')
            {
                startDate = Date.newInstance(integer.valueOf(year), 1, 1);
                lastDayOfMonth = Date.newInstance(startDate.year(), 12, 31);
            }
            else
            {
                startDate = Date.newInstance(integer.valueOf(year), integer.valueOf(Month), 1);
                Integer numberOfDays = Date.daysInMonth(startDate.year(), startDate.month());
                lastDayOfMonth = Date.newInstance(startDate.year(), startDate.month(), numberOfDays);
            }
            string formattedMonthfirstDate = String.valueOf(startDate.toStartOfMonth())+timestring ;
            string formattedMonthLastDate = String.valueOf(lastDayOfMonth )+timestring;
            for(Date updatedDate : SprintIdWithUpdatedDate.values())
            {
                if(updatedDate >= startDate && updatedDate <= lastDayOfMonth)
                {
                    monthlyInProgressSprintCount = monthlyInProgressSprintCount + 1;
                }
            }
            system.debug('###monthlyInProgressSprintCount'+monthlyInProgressSprintCount);
            }
          }
        catch(Exception ex)
        {
            system.debug(ex);
        }
        return monthlyInProgressSprintCount;
    }
    
    public static Map<string,Integer> GetTotalCompletedUSWithDate(String userName, String password, String BoardId,string domainName,string Month,string year) 
    {
        string apiUrl = '';
        string USMonthlyCompletedResBody = '';
        Integer monthlyCompletedSprintCount = 0;
        Map<string,Integer> mapCompletedUserstoriesDte = new Map<string,Integer>(); 
        string jiraResponse = '';
        try
        {
            //apiUrl = 'https://'+DomainName+'.atlassian.net/rest/agile/1.0/board/'+BoardId+'/issue?jql=issuetype%20=%20story%20and%20sprint%20in%20(%20OpenSprints(),ClosedSprints())%20and%20status%20=%20done';
            apiUrl = 'https://'+DomainName+'/rest/agile/1.0/board/'+BoardId+'/issue?jql=issuetype%20=%20story%20and%20sprint%20in%20(%20OpenSprints(),ClosedSprints())%20and%20status%20=%20done';
            
            if(!Test.isRunningTest())
            {
                USMonthlyCompletedResBody = InvokeJiraApi(userName, password,apiUrl);
                system.debug('^^^USMonthlyCompletedResBody '+USMonthlyCompletedResBody );
            }
            
            else
            {
                USMonthlyCompletedResBody  = '{"expand":"schema,names","startAt":0,"maxResults":50,"total":4,"issues":[{"expand":"operations,versionedRepresentations,editmeta,changelog,renderedFields","id":"10000","self":"https://preludesysindia.atlassian.net/rest/agile/1.0/issue/10000","key":"DN-1","fields":{"issuetype":{"self":"https://preludesysindia.atlassian.net/rest/api/2/issuetype/10001","id":"10001","description":"A user story. Created by JIRA Software - do not edit or delete.","iconUrl":"https://preludesysindia.atlassian.net/images/icons/issuetypes/story.svg","name":"Story","subtask":false},"timespent":null,"sprint":null,"project":{"self":"https://preludesysindia.atlassian.net/rest/api/2/project/10001","id":"10001","key":"DN","name":"Dot Net","avatarUrls":{"48x48":"https://preludesysindia.atlassian.net/secure/projectavatar?avatarId=10324","24x24":"https://preludesysindia.atlassian.net/secure/projectavatar?size=small&avatarId=10324","16x16":"https://preludesysindia.atlassian.net/secure/projectavatar?size=xsmall&avatarId=10324","32x32":"https://preludesysindia.atlassian.net/secure/projectavatar?size=medium&avatarId=10324"}},"fixVersions":[],"aggregatetimespent":null,"resolution":{"self":"https://preludesysindia.atlassian.net/rest/api/2/resolution/10000","id":"10000","description":"Work has been completed on this issue.","name":"Done"},"resolutiondate":"2017-08-10T12:47:36.375+0530","workratio":-1,"watches":{"self":"https://preludesysindia.atlassian.net/rest/api/2/issue/DN-1/watchers","watchCount":1,"isWatching":true},"lastViewed":"2017-08-10T12:49:17.542+0530","created":"2017-08-09T15:28:49.873+0530","epic":null,"priority":{"self":"https://preludesysindia.atlassian.net/rest/api/2/priority/3","iconUrl":"https://preludesysindia.atlassian.net/images/icons/priorities/medium.svg","name":"Medium","id":"3"},"labels":[],"timeestimate":null,"aggregatetimeoriginalestimate":null,"versions":[],"issuelinks":[],"assignee":null,"updated":"2017-08-10T12:47:36.390+0530","status":{"self":"https://preludesysindia.atlassian.net/rest/api/2/status/10001","description":"","iconUrl":"https://preludesysindia.atlassian.net/","name":"Done","id":"10001","statusCategory":{"self":"https://preludesysindia.atlassian.net/rest/api/2/statuscategory/3","id":3,"key":"done","colorName":"green","name":"Done"}},"components":[],"customfield_10050":null,"customfield_10051":null,"timeoriginalestimate":null,"customfield_10052":null,"description":null,"customfield_10053":null,"customfield_10054":null,"customfield_10010":["com.atlassian.greenhopper.service.sprint.Sprint@2fed2de5[id=1,rapidViewId=2,state=CLOSED,name=Sprint 1,goal=,startDate=2017-08-10T09:04:45.869Z,endDate=2017-08-24T09:04:00.000Z,completeDate=2017-08-16T06:41:51.863Z,sequence=1]"],"customfield_10055":null,"customfield_10011":"0&#124;hzzzzz:","customfield_10012":null,"customfield_10013":"3_*:*_1_*:*_198397_*&#124;*_10000_*:*_1_*:*_76528122_*&#124;*_10001_*:*_1_*:*_0","timetracking":{},"customfield_10049":null,"customfield_10008":null,"aggregatetimeestimate":null,"customfield_10009":null,"attachment":[],"flagged":false,"summary":"Design Document","creator":{"self":"https://preludesysindia.atlassian.net/rest/api/2/user?username=admin","name":"admin","key":"admin","accountId":"557058:1c7f9ba7-1bc9-4322-842f-0224c2688cce","emailAddress":"gnanaprakasam_g@preludesys.com","avatarUrls":{"48x48":"https://avatar-cdn.atlassian.com/c5b3d85ce720897ecc873dfa6b436daf?s=48&d=https%3A%2F%2Fsecure.gravatar.com%2Favatar%2Fc5b3d85ce720897ecc873dfa6b436daf%3Fd%3Dmm%26s%3D48%26noRedirect%3Dtrue","24x24":"https://avatar-cdn.atlassian.com/c5b3d85ce720897ecc873dfa6b436daf?s=24&d=https%3A%2F%2Fsecure.gravatar.com%2Favatar%2Fc5b3d85ce720897ecc873dfa6b436daf%3Fd%3Dmm%26s%3D24%26noRedirect%3Dtrue","16x16":"https://avatar-cdn.atlassian.com/c5b3d85ce720897ecc873dfa6b436daf?s=16&d=https%3A%2F%2Fsecure.gravatar.com%2Favatar%2Fc5b3d85ce720897ecc873dfa6b436daf%3Fd%3Dmm%26s%3D16%26noRedirect%3Dtrue","32x32":"https://avatar-cdn.atlassian.com/c5b3d85ce720897ecc873dfa6b436daf?s=32&d=https%3A%2F%2Fsecure.gravatar.com%2Favatar%2Fc5b3d85ce720897ecc873dfa6b436daf%3Fd%3Dmm%26s%3D32%26noRedirect%3Dtrue"},"displayName":"Preludesys India","active":true,"timeZone":"Asia/Kolkata"},"subtasks":[],"reporter":{"self":"https://preludesysindia.atlassian.net/rest/api/2/user?username=admin","name":"admin","key":"admin","accountId":"557058:1c7f9ba7-1bc9-4322-842f-0224c2688cce","emailAddress":"gnanaprakasam_g@preludesys.com","avatarUrls":{"48x48":"https://avatar-cdn.atlassian.com/c5b3d85ce720897ecc873dfa6b436daf?s=48&d=https%3A%2F%2Fsecure.gravatar.com%2Favatar%2Fc5b3d85ce720897ecc873dfa6b436daf%3Fd%3Dmm%26s%3D48%26noRedirect%3Dtrue","24x24":"https://avatar-cdn.atlassian.com/c5b3d85ce720897ecc873dfa6b436daf?s=24&d=https%3A%2F%2Fsecure.gravatar.com%2Favatar%2Fc5b3d85ce720897ecc873dfa6b436daf%3Fd%3Dmm%26s%3D24%26noRedirect%3Dtrue","16x16":"https://avatar-cdn.atlassian.com/c5b3d85ce720897ecc873dfa6b436daf?s=16&d=https%3A%2F%2Fsecure.gravatar.com%2Favatar%2Fc5b3d85ce720897ecc873dfa6b436daf%3Fd%3Dmm%26s%3D16%26noRedirect%3Dtrue","32x32":"https://avatar-cdn.atlassian.com/c5b3d85ce720897ecc873dfa6b436daf?s=32&d=https%3A%2F%2Fsecure.gravatar.com%2Favatar%2Fc5b3d85ce720897ecc873dfa6b436daf%3Fd%3Dmm%26s%3D32%26noRedirect%3Dtrue"},"displayName":"Preludesys India","active":true,"timeZone":"Asia/Kolkata"},"aggregateprogress":{"progress":0,"total":0},"customfield_10000":"{}","customfield_10001":null,"customfield_10002":null,"customfield_10046":null,"customfield_10003":null,"customfield_10004":null,"environment":null,"duedate":null,"closedSprints":[{"id":1,"self":"https://preludesysindia.atlassian.net/rest/agile/1.0/sprint/1","state":"closed","name":"Sprint 1","startDate":"2017-08-10T09:04:45.869Z","endDate":"2017-08-24T09:04:00.000Z","completeDate":"2017-08-16T06:41:51.863Z","originBoardId":2,"goal":""}],"progress":{"progress":0,"total":0},"votes":{"self":"https://preludesysindia.atlassian.net/rest/api/2/issue/DN-1/votes","votes":0,"hasVoted":false},"comment":{"comments":[],"maxResults":0,"total":0,"startAt":0},"worklog":{"startAt":0,"maxResults":20,"total":0,"worklogs":[]}}}]}';
            }
             
            if(USMonthlyCompletedResBody.contains('Unauthorized') || USMonthlyCompletedResBody.contains('error') || USMonthlyCompletedResBody.contains('board cannot be viewed'))
            {
                jiraResponse = 'error';
                ODS_DashboardController.SetJiraResponse(jiraResponse);
                system.debug('$$$jiraResponse'+jiraResponse);
            }
            
            else
            {
            jiraResponse = 'success';
            ODS_DashboardController.SetJiraResponse(jiraResponse);
            Map<string,object> jsonResponse = (Map<string,object>)JSON.deserializeUntyped(USMonthlyCompletedResBody);
            List<Object> responseResultLst = (List<Object>)jsonResponse.get('issues');
            Map<String,Object> Result = new Map<String,Object>();
            Map<String,Object> FieldsResult = new Map<String,Object>();
            Map<String,Object> SprintResult = new Map<String,Object>();
            Map<string,Date> sptintIdWithResolutionDate = new Map<string,Date>();
            string timestring = 'T00:00:00.000Z';
            for(Object responseResult: responseResultLst)
             {
                Result=(Map<String,Object>) responseResult;
                string SprintId = string.valueof(Result.get('id'));
                FieldsResult = (Map<String,Object>)Result.get('fields');
                string ReslDate = string.valueOf(FieldsResult.get('resolutiondate'));
                List<string> FormattedDate = ReslDate.split('T');
                List<String> ResolutionDateUnFormatted = FormattedDate[0].split('-');
                Integer IntDate = integer.valueOf(ResolutionDateUnFormatted[0]);
                Integer IntMonth = integer.valueOf(ResolutionDateUnFormatted[1]);
                Integer IntYear = integer.valueOf(ResolutionDateUnFormatted[2]);
                Date ResolutionDate = Date.newInstance(IntDate,IntMonth,IntYear);
                sptintIdWithResolutionDate.put(SprintId,ResolutionDate);
                
               

              }
            system.debug('$$$sptintIdWithResolutionDate'+sptintIdWithResolutionDate);
            Date startDate;
            Date lastDayOfMonth;
            if(Month == '0')
            {
                startDate = Date.newInstance(integer.valueOf(year), 1, 1);
                lastDayOfMonth = Date.newInstance(startDate.year(), 12, 31);
            }
            else
            {
                startDate = Date.newInstance(integer.valueOf(year), integer.valueOf(Month), 1);
                Integer numberOfDays = Date.daysInMonth(startDate.year(), startDate.month());
                lastDayOfMonth = Date.newInstance(startDate.year(), startDate.month(), numberOfDays);
            }
            
            string formattedMonthfirstDate = String.valueOf(startDate.toStartOfMonth())+timestring ;
            string formattedMonthLastDate = String.valueOf(lastDayOfMonth )+timestring;
            
            
            Integer count = 0;
            for(Date ResolutionDt : sptintIdWithResolutionDate.values())
            {
                    string dateValue = string.valueOf(ResolutionDt);
                    system.debug('###dateValue'+dateValue);
                    List<String> CompletedDateSplitted = dateValue.split('-');
                    system.debug('###CompletedDateSplitted '+CompletedDateSplitted );
                    string creationYearMonthKey = CompletedDateSplitted[0]+CompletedDateSplitted[1]+CompletedDateSplitted[2];
                    system.debug('%%%creationYearMonthKey '+creationYearMonthKey );
                    if(mapCompletedUserstoriesDte.containskey(creationYearMonthKey ))
                    {
                        count = mapCompletedUserstoriesDte.get(creationYearMonthKey)+1;
                        
                        
                    }
                    else
                    {
                        count = 0;
                        count = count + 1;
                        
                    }
            mapCompletedUserstoriesDte.put(creationYearMonthKey,count);
            }
        }
            system.debug('###$monthlyCompletedSprint'+monthlyCompletedSprintCount);
            system.debug('###$mapCompletedUserstoriesDte'+mapCompletedUserstoriesDte);
    } 
    catch(Exception ex)    
    {
        system.debug(ex);
    }
        
    return mapCompletedUserstoriesDte;
    }
    
    //Wrapper Class
    Public class sprint
    {
        public string sprintName{get;set;}
        public date startDate{get;set;}
        public date endDate{get;set;}
    }
}