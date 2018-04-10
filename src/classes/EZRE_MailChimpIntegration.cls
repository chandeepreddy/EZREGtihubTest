/*
 * @author           keerthi Chandra
 * @version          1.0 
 * @date             10/20/2014
 * @description      Send emails to all the candidates who are eligible to the created new requirement.
 */   
global class EZRE_MailChimpIntegration
{
    
    // To hold the candidates id's list
    public static List<ID> lstRefAccs{get;set;}
    // To hold the details of Requirement
    public static Requirement__c reqmt{get; set;} 
    // To hold the details of Assigned Requirement
    public static RequirementAssignment__c reqAssignment{get; set;}   
    // List of Candidates
    public static List<Candidate__c> lstCandidates {get;set;}    
    //holds campaign id
    public static string strCmpgnId{get;set;}
    //set of Subscribers in Mailchimp
    public static set<string> setMCSubscribers{get;set;}
    //Set of Salesforce candidates
    public static set<string> setSFDCCandidates{get;set;}
    //Set of members to get subscribed from Mailchimp List
    public static set<string> setToSubscribe{get;set;}
    //Set of members to get unsubscribed from Mailchimp list
    public static set<string> setToUnSubscribe{get;set;}    
    //Mailchimp Account Details custom setting record
    public Static Mailchimp_Details__c MCDtls{get;set;}
    public static List<String> lstSrchCrtra{get;set;}
    
    
    ///OBJECTIVE
    ///Fetch the list of candidates and their mail ids by using SOSL query based on the requirement name
    ///OBJECTIVE
     @future (callout=true) 
    public static void sendReqmtMail(Id strReqmtId)
    {
        setSFDCCandidates = new set<String>(); 
        reqmt = EZRE_Data_Utility.fetchReq(strReqmtId);
        string strRegex = '[\\s;.,:!?()-]';
        
        if(reqmt.Easy1__c != null || reqmt.Easy1__c != '')
        {       
            lstSrchCrtra = reqmt.Easy1__c.split(strRegex);
        }
        List<String> result= new List<String>();

        for(integer i=0;i<lstSrchCrtra.size();i++)
        {
          /*string val=lstSrchCrtra[i].replaceAll(',','').trim();
         
          if(val != '' && val != ',')
          {
             result.add(val);
          }*/
          if(lstSrchCrtra[i] != '' && lstSrchCrtra[i] != ',' && lstSrchCrtra[i] != ';' && lstSrchCrtra[i] != '-' && lstSrchCrtra[i] != '.')
          {
              result.add(lstSrchCrtra[i]);
          }

        }
        System.debug('Result============='+result);

        String strFnlKywrd = String.join(result, ' AND ');
        System.debug('strFnlKywrd============='+strFnlKywrd);               
        

        List<List<SObject>> searchList = EZRE_Data_Utility.fetchSearchList(strFnlKywrd);        
        ContentVersion[] contents = ((List<ContentVersion>)searchList[0]); //Conversion 
        lstRefAccs = new List<ID>();    
        for (ContentVersion cv: contents)    
        {
            lstRefAccs.add(cv.Candidate_ID__c);
        }
        
       lstCandidates = new List<Candidate__c>();
         lstCandidates = EZRE_Data_Utility.fetchLstElgblCan(lstRefAccs);
        System.debug('Candidates=========================='+lstCandidates);
        for(candidate__c cand : lstCandidates)
        {
            if((cand.Category__c == reqmt.Job_Category__c || cand.Category__c == 'Open')&&(cand.Email_Status__c == 'Active' &&  cand.Do_Not_Recruit__c == false))
            {
                setSFDCCandidates.add(cand.Email__c);
            }
        }
        
       
        /*for (Candidate__c objCndt: lstCandidates)    
        {
            setSFDCCandidates.add(objCndt.Email__c);
        }*/
        System.debug('setSFDCCandidates============================'+setSFDCCandidates);
        getMCLstMembers();
        syncSFDCandMCList();
        unSubscribeMembers();
        subscribeMembers();        
        sendMCCampaign(strReqmtId);
       
    }
    
     
    
    ///OBJECTIVE
    ///Get the list of members in the list in Mailchimp
    ///OBJECTIVE
    private static void getMCLstMembers()
    {
        String strEmailId;
        MCDtls = new Mailchimp_Details__c();
        MCDtls = EZRE_Data_Utility.getMCDtls('MCAccount');
        Http h = new Http();        
        HttpRequest req = new HttpRequest();
        req.setMethod('POST');
        req.setBody('{"apikey": "'+MCDtls.API_Key__c+'","id": "'+MCDtls.List_Id__c+'"}');        
        req.setEndpoint('https://'+MCDtls.Domain_Name__c+'.api.mailchimp.com/2.0/lists/members.JSON'); 
                    
        if(!Test.isRunningTest())
        {
            HttpResponse res = h.send(req);        
            system.debug(':: Response in getting list members :: ********'+res.getbody());
            JSONParser parser = JSON.createParser(res.getBody());
            setMCSubscribers= new Set<String>();
            while (parser.nextToken() != null) 
            {
                //if current token is a field name
                if (parser.getCurrentToken() == JSONToken.FIELD_NAME)
                {
                    String fieldName = parser.getText();
                    System.debug('fieldName: ' + fieldName);
                    //move to token after the field name
                    parser.nextToken(); 
                    if(fieldName == 'email')
                    {
                        strEmailId = parser.getText();
                        system.debug(':: strEmailId :: ********'+strEmailId);
                        setMCSubscribers.add(strEmailId);
                        system.debug('Members in MC list:: ********'+setMCSubscribers.size());
                        
                    }
                }              
            }            
        }
       
       
    }
    
    ///OBJECTIVE
    ///To sync SFDC and Mailchimp lists
    ///OBJECTIVE
    private static void syncSFDCandMCList()
    {
        setToSubscribe = new set<string>();
        setToUnSubscribe = new set<String>();      
        if(!Test.isRunningTest())
        {
            if(!setMCSubscribers.isEmpty() ||setMCSubscribers.size()!= 0)
            {
                for(String mcEmail: setMCSubscribers)
                {
                    if(!setSFDCCandidates.contains(mcEmail))
                    {
                            setToUnSubscribe.add(mcEmail);
                    }
                    System.debug('setToUnSubscribe========================='+setToUnSubscribe);
                
                }
            }
        }
    }  

    ///OBJECTIVE
    ///To subscribe new members in  Mailchimp
    ///OBJECTIVE
    private static void subscribeMembers()    
    { 
        MCDtls = new Mailchimp_Details__c();
        MCDtls = EZRE_Data_Utility.getMCDtls('MCAccount');
        String strEmailBtchSbscrbe = '';
        System.debug('List of Subscribers==================='+setSFDCCandidates.size());  
        String strDfltEmailId = System.Label.MC_DefaultEmail;
        System.debug('Email address from Custom label---------------------------'+strDfltEmailId);
        for(String str: strDfltEmailId.split(';'))
        {
            setSFDCCandidates.add(str);
        }
        System.debug('List of Subscribers$$$$$$$$$$$$$$$$$$$$$$$$$$$$'+setSFDCCandidates);  
        if(!setSFDCCandidates.isEmpty() || setSFDCCandidates.size()!= 0)
        {            
            for(String str : setSFDCCandidates)
            {
                strEmailBtchSbscrbe += '{"email":{"email":"'+str+'"}},';
            }
        }       
        
        strEmailBtchSbscrbe = strEmailBtchSbscrbe.substringBeforeLast(',') ;
        System.debug('strEmailBtchSbscrbe for subscribers============='+strEmailBtchSbscrbe); 
        Http h = new Http();        
        HttpRequest req = new HttpRequest(); 
        req.setMethod('POST');
        req.setBody('{"apikey": "'+MCDtls.API_Key__c+'","id": "'+MCDtls.List_Id__c+'","batch":['+strEmailBtchSbscrbe+'],"double_optin": false,"update_existing":true}');               
        req.setEndpoint('https://'+MCDtls.Domain_Name__c+'.api.mailchimp.com/2.0/lists/batch-subscribe.JSON');      
       
        if(!Test.isRunningTest())
        {         
            HttpResponse res = h.send(req);        
            system.debug(':: Response while adding batch of subscribers to MC list :: ********'+res.getbody());
        }
    }
            
    
    
    ///OBJECTIVE
    ///To unsubscribe members from Mailchimp
    ///OBJECTIVE
    private static void unSubscribeMembers()    
    { 
        MCDtls = new Mailchimp_Details__c();
        MCDtls = EZRE_Data_Utility.getMCDtls('MCAccount');
        System.debug('List of UnSubscribers==================='+setToUnSubscribe.size()); 
        String strEmailBtchUnSbscrbe = '';
        
        if(!setToUnSubscribe.isEmpty() || setToUnSubscribe.size()!= 0)
        {       
            for(String str : setToUnSubscribe)
            {
                strEmailBtchUnSbscrbe += '{"email":"'+str+'"},';          
            }   
        }
        
        strEmailBtchUnSbscrbe = strEmailBtchUnSbscrbe.substringBeforeLast(',') ;
        System.debug('strEmailBtchUnSbscrbe for subscribers============='+strEmailBtchUnSbscrbe); 
        System.debug('List of Unsubscribers==================='+setToUnSubscribe.size()); 
        Http h = new Http();        
        HttpRequest reqst = new HttpRequest();
        reqst.setMethod('POST');
        reqst.setBody('{"apikey": "'+MCDtls.API_Key__c+'","id":"'+MCDtls.List_Id__c+'","batch":['+strEmailBtchUnSbscrbe+'],"delete_member":true,"send_goodbye": false}');       
        reqst.setEndpoint('https://'+MCDtls.Domain_Name__c+'.api.mailchimp.com/2.0/lists/batch-unsubscribe.JSON');
        if(!Test.isRunningTest())
        { 
            HttpResponse res = h.send(reqst);        
            system.debug('::Response while unsubscribing members in  MC list :: ********'+res.getbody());  
        }
               
    }    
 
    
    ///OBJECTIVE
    ///Create Campaign in Mailchimp
    ///OBJECTIVE
    
   private static void createMCCampaign(Id strReqmtId)    
    {  
        MCDtls = new Mailchimp_Details__c();
        MCDtls = EZRE_Data_Utility.getMCDtls('MCAccount');
        reqmt = EZRE_Data_Utility.fetchReqData(strReqmtId);    
        reqAssignment = EZRE_Data_Utility.fetchReqAssgData(strReqmtId);
     
        String body = '<html><body><br><br>'
                    /*+'<a href="https://www.google.co.in/">Like us on Facebook</a>'
                    +'<a href="https://www.linkedin.com/nhome/?trk=">Connect us at LinkedIn</a>'*/
                    +'This is '+ reqAssignment.Lead_Recruiter__r.Name + ' ' + 'from PreludeSys,'+
                    '<br><br>'+'I have the following open position. Kindly go through the Job Details and if you are suitable and interested please let me know.'+
                    '<br><br><table><tr></tr></table>'+
                    '<td>Job Title</td><td>:</td>   <td>'+reqmt.Name+
                    '<br><tr><td>Job Type</td><td>:</td>   <td>'+reqmt.Requirement_Type__c+
                    '<br></td></tr><tr><td>Duration</td><td>:</td>   <td>'+reqmt.Duration__c+ 
                    '<br></td></tr><tr><td>Location</td><td>:</td>   <td>'+reqmt.Location__c ;  
                    if(reqmt.Preference__c != null)
                    {
                        body += '</td></tr><tr><td>Preference</td><td>:</td>    <td>'+reqmt.Preference__c ;
                    }
                    
                body += '</td><br></tr><tr><td>Interview Type</td><td>:</td>   <td>'+reqmt.Interview_Type__c+
                    '</td></tr>'+
                    '<br><br>' + 'Description: '+reqmt.Skill_Set__c+
                    '<br><br><br>'+'</td><b>Please reply with your latest Resume and following info:</b>'+'<br>'+
                    '<br><br><table><tr>'+ 
                    '<td>Candidate Full Name:</td><td>' +
                    '</td></tr><tr><td>Present Location:</td><td>' +
                    '</td></tr><tr><td>Contact Phone Number:</td><td>' +
                    '</td></tr><tr><td>Email ID:</td><td>' +
                    '</td></tr><tr><td>Skype ID:</td><td>' +
                    '</td></tr><tr><td>Notice period:</td><td>' +
                    '</td></tr><tr><td>Visa Status:</td><td>' +
                    '</td></tr><tr><td>Willing to Relocate:</td><td>Yes/No</td><td>' +
                    '</td></tr><tr><td>Availability for Interview:</td>' +
                    '</tr></table>'+
                    '<br><br><br><table><tr>'+'Relevant Exp:<td>' +
                    '</td></tr><tr><td>Total Work Exp:</td><td>' +
                    '</td></tr><tr><td>Total US Exp:</td><td>' +
                    '</td></tr></table>'+
                    '<br><br><br><table><tr>'+'If Applicable:<td>' +
                    '</td></tr><tr><td>Employer Details:</td><td>' +
                    '</td></tr><tr><td>Company Name:</td><td>' +
                    '</td></tr><tr><td>Contact Person Name:</td><td>' +
                    '</td></tr><tr><td>Email:</td><td>' +
                    '</td></tr><tr><td>Phone:</td><td>' +
                    '</td></tr></table>'+
                    '<br><br>' +'Thanks & Regards,';
                    if(reqAssignment.Lead_Recruiter__r.Name != null)
                    {
                        body += '<br><br>'+reqAssignment.Lead_Recruiter__r.Name;
                        if(reqAssignment.Lead_Recruiter__r.Email != null)
                        {
                            body += '<br>'+reqAssignment.Lead_Recruiter__r.Email;
                        }
                        if(reqAssignment.Lead_Recruiter__r.Phone != null)
                        {
                            body += '<br>'+reqAssignment.Lead_Recruiter__r.Phone;
                        }
                    } 
                body += '<br><br>If this Job Description DOES NOT MATCH your skills AND/OR experience please forward this email to any of your friends who might be interested. Also share with us your latest Resume so that we can send you more SUITABLE Requirements in the future.</br></br>';
                body +=  '</body></html>';     
            
       
        String subject = 'Need' + ' ' + reqmt.Name + ' ' + 'in' + ' ' + reqmt.City__c + ',' + ' ' + reqmt.State__c + ' ' + 'for' + ' ' + reqmt.Position_Type__c;
        String fromEmail = reqAssignment.Lead_Recruiter__r.Email;
        String fromName = 'PreludeSys';
        String toName= '';
        Http h = new Http();        
        HttpRequest reqst = new HttpRequest();
        reqst.setMethod('POST');
        HttpResponse res = new HttpResponse();
        reqst.setBody('{"apikey": "'+MCDtls.API_Key__c+'","type": "regular","options":{"list_id":"'+MCDtls.List_Id__c+'","subject":"'+subject+'","from_email":"'+fromEmail+'","from_name":"'+fromName+'","to_name":"'+toName+'","inline_css": true},"content":{"html":"'+body+'" }}');
        reqst.setEndpoint('https://'+MCDtls.Domain_Name__c+'.api.mailchimp.com/2.0/campaigns/create.JSON'); 
        if(!Test.isRunningTest())
        {
            system.debug('##body :' +body);          
            res = h.send(reqst);
            system.debug(':: Response for creating campaign: ********'+res.getbody()); 
            JSONWrapper jsonWrapObj = (JSONWrapper)JSON.deserialize(res.getBody(), JSONWrapper.class);
            strCmpgnId = jsonWrapObj.id;
            system.debug(':: strCmpgnId :: ********'+strCmpgnId);
        }
        
        
                
    }
    
    @TestVisible
    private class JSONWrapper
    {
        public string id; 
        public string email;
    }
    
    ///OBJECTIVE
    ///Create Campaign in Mailchimp
    ///OBJECTIVE
    
    private static void sendMCCampaign(Id strReqmtId)    
    {  
        MCDtls = new Mailchimp_Details__c();
        MCDtls = EZRE_Data_Utility.getMCDtls('MCAccount');
        createMCCampaign(strReqmtId);           
        Http h = new Http();        
        HttpRequest reqst = new HttpRequest();  
        reqst.setMethod('POST'); 
        reqst.setBody('{"apikey": "'+MCDtls.API_Key__c+'","cid":"'+strCmpgnId+'"}');        
        reqst.setEndpoint('https://'+MCDtls.Domain_Name__c+'.api.mailchimp.com/2.0/campaigns/send.JSON');       
        if(!Test.isRunningTest())
        { 
            HttpResponse res = h.send(reqst);        
            system.debug(':: Response for sending mails :: ********'+res.getbody());            
        }
        
        //deleteMCCampaign();
        
        
    }
    
    ///OBJECTIVE
    ///Delete previously created Campaign in Mailchimp
    ///OBJECTIVE
    
    /*private static void deleteMCCampaign()    
    {  
        MCDtls = new Mailchimp_Details__c();
        MCDtls = EZRE_Data_Utility.getMCDtls('MCAccount');       
        Http h = new Http();        
        HttpRequest reqst = new HttpRequest();  
        reqst.setMethod('POST');
        reqst.setBody('{"apikey": "'+MCDtls.API_Key__c+'","cid":"'+MCDtls.Campaign_Id__c+'"}');        
        reqst.setEndpoint('https://'+MCDtls.Domain_Name__c+'.api.mailchimp.com/2.0/campaigns/delete.JSON');
        if(!Test.isRunningTest())
        {
            if((MCDtls.Campaign_Id__c != null )&&( strCmpgnId != MCDtls.Campaign_Id__c))
            {
                HttpResponse res = h.send(reqst);        
                system.debug(':: Response for deleting campaign :: ********'+res.getbody()); 
                
            }           
        }
        
        MCDtls.Campaign_Id__c = strCmpgnId;
        update MCDtls;
        
    }*/
}