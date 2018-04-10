/*
 * @author           Indhu R
 * @version          1.0 
 * @date             02/18/2015
 * @description      Send emails to all the candidates who are eligible to the created new requirement.
 * @modification     Updating the Mailchimp API V3.0 for all api calls
 * @modified By      Shahida Kalluri
 * @modified Date    01/16/2017
 * @description      Adding custom label to member subscription batch size.
 * @modified By      Shahida Kalluri
 * @modified Date    03/01/2017
 * @description      We have activated and used new api for the member subscription request.
 */   
global class EZRE_MailChimp_MultiListCampaign
{        
       
   /* @TestVisible
    private class JSONWrapper
    {
        public string id; 
        public string email;
    }
 
    ///OBJECTIVE
    ///Fetch the list of candidates and their mail ids by using SOSL query based on the requirement name
    ///OBJECTIVE
    @future (callout=true) 
    public static void sendReqmtMail(String strReqmtId)
    {        
        String subscriberStatus;
        set<string> setSFDCCandidates = new set<String>();       
        set<String> setMCMembers = new Set<String>();            
        List<String> lstSrchCrtra = new List<String>(); 
        Requirement__c reqmt = new Requirement__c();
        List<ID> lstRefAccs = new List<ID>();
        Mailchimp_Details__c  MCDtls = new Mailchimp_Details__c();
        Mailchimp_Details__c  MCListSubscriptionApiDtls = new Mailchimp_Details__c();
        List<List<SObject>> searchList = new  List<List<SObject>>();
        List<Candidate__c> lstCandidates = new List<Candidate__c>();
        List<RequirementAssignment__c> lstReqAssgnmnt = new List<RequirementAssignment__c>();
        RequirementAssignment__c reqAssignment = new RequirementAssignment__c();
        String CampaignListId;
        set<string> allSFDCCandidates = new set<String>();     
        string strRegex = '[\\s;.,:!?()-]'; 
        try
        {
            reqmt = EZRE_Data_Utility.fetchReqData(strReqmtId);
            reqAssignment = EZRE_Data_Utility.fetchReqAssgData(strReqmtId);
            lstReqAssgnmnt = EZRE_Data_Utility.fetchAllReqAssgData(strReqmtId);
            MCDtls = EZRE_Data_Utility.getMCDtls('MCAccount');
            MCListSubscriptionApiDtls = EZRE_Data_Utility.getMCDtls('MCMemberSubscription');
        }
        catch(Exception ex)
        {
            System.debug('Exception in fetching data'+ex.getMessage());
        }   
      
        if(reqmt.Easy1__c != null || reqmt.Easy1__c != '')
        {       
            lstSrchCrtra = reqmt.Easy1__c.split(strRegex);
        }
        List<String> result= new List<String>();

        for(integer i=0;i<lstSrchCrtra.size();i++)
        {          
            if(lstSrchCrtra[i] != '' && lstSrchCrtra[i] != ',' && lstSrchCrtra[i] != ';' && lstSrchCrtra[i] != '-' && lstSrchCrtra[i] != '.')
            {
                result.add(lstSrchCrtra[i]);
            }
        }
        
        String strFnlKywrd = String.join(result, ' AND ');  
        system.debug('strFnlKywrd =============='+strFnlKywrd );
        searchList = EZRE_Data_Utility.fetchSearchList(strFnlKywrd);   
        system.debug('searchList =============='+searchList );
        if(searchList.size()>0)
        {
            ContentVersion[] contents = ((List<ContentVersion>)searchList[0]); //Conversion                 
            for (ContentVersion cv: contents)    
            {
                lstRefAccs.add(cv.Candidate_ID__c);
            }        
            
            try
            {
                lstCandidates = EZRE_Data_Utility.fetchLstElgblCan(lstRefAccs);
            }
            catch(Exception ex)
            {
                System.debug('Exception----------'+ex.getMessage());
            }
        }    
        if(lstCandidates.size() >0)
        {
            for(candidate__c cand : lstCandidates)
            {
                if((cand.Category__c == reqmt.Job_Category__c || cand.Category__c == 'Open')&&
                        (cand.Email_Status__c == 'Active' &&  cand.Do_Not_Recruit__c == false))
                {
                    //list of eligible candidates from SFDC
                    setSFDCCandidates.add(cand.Email__c);
                }
            } 
        }
        if(setSFDCCandidates.size()>0)
        {
            try
            {
                //Create Mailchimp List
                CampaignListId=createNewList(MCDtls,reqmt);
                sleep(10000);
                if(CampaignListId != null)
                {
                     string strCampaignId = createMCCampaign(MCDtls, reqAssignment, reqmt,CampaignListId);
                     system.debug('strCampaignId created campaign'+strCampaignId );  
                     //subscribe the new sfdc members alone
                     subscriberStatus = subscribeListMembers(setSFDCCandidates,MCListSubscriptionApiDtls,CampaignListId);
                    
                }

            }
            catch(System.CalloutException ex)
            {
                System.debug('Exception in sendReqmtMail if Block'+ex.getMessage());  
            }

         }    
    } 
   
        ///OBJECTIVE
    ///Create new list for every campaign 
    ///OBJECTIVE
    private static string createNewList(Mailchimp_Details__c objMailChimpDtls,Requirement__c objReqmt)
    {
        try
        {
        
            Http h = new Http(); 
            HttpResponse res;       
            HttpRequest req = new HttpRequest(); 
            req.setMethod('POST');
            req.setHeader('Authorization', 'apikey '+objMailChimpDtls.API_Key__c);
            string strListName=objReqmt.Name; 
            MailchimpListDetails__c  listDetailsObj=MailchimpListDetails__c.getValues('MCListContactInfo');
            system.debug('listDetailsObj============='+listDetailsObj);
            String company=listDetailsObj.Company__c;
            String address1=listDetailsObj.Address1__c;
            String city=listDetailsObj.City__c;
            String state=listDetailsObj.State__c;
            String zip=listDetailsObj.Zip__c;
            String country=listDetailsObj.Country__c;
            String permissionRemainder=listDetailsObj.Permission_Reminder__c;
            String fromName=listDetailsObj.From_Name__c;
            String fromEmail=listDetailsObj.From_Email__c;
            
            system.debug('fromEmail==========='+fromEmail);
            req.setBody('{"name":"'+strListName+'","contact":{"company":"'+company+'","address1":"'+address1+'","address2":"","city":"'+city+'","state":"'+state+'","zip":"'+zip+'","country":"'+country+'","phone":""},"permission_reminder":"'+permissionRemainder+'","campaign_defaults":{"from_name":"'+fromName+'","from_email":"'+fromEmail+'","subject":"","language":"en"},"email_type_option":true}');
            req.setEndpoint('https://'+objMailChimpDtls.Domain_Name__c+'.api.mailchimp.com/3.0/lists'); 
            req.setTimeout(120000);             
            String listId;
            if(!Test.isRunningTest())
            {                    
                res = h.send(req);        
                JSONWrapper jsonWrapObj = (JSONWrapper)JSON.deserialize(res.getBody(), JSONWrapper.class);
                listId= jsonWrapObj.id;              
                system.debug('New listId res body==============='+res.getBody());
            }  
            else
            {
                //res.setStatusCode(200);
                string strResponseBody='{"id":"5f40ce7a52","name":"Analyst Requirement","contact":{"company":"MailChimp","address1":"675 Ponce De Leon Ave NE","address2":"Suite 5000","city":"Atlanta","state":"GA","zip":"30308","country":"US","phone":""},"permission_reminder":"Your receiving this email because you signed up for updates about Freddie newest hats.","use_archive_bar":true,"campaign_defaults":{"from_name":"Freddie","from_email":"shahida_m@preludesys.com","subject":"","language":"en"},"notify_on_subscribe":"","notify_on_unsubscribe":"","date_created":"2016-11-14T08:58:48+00:00","list_rating":0,"email_type_option":true,"subscribe_url_short":"http://eepurl.com/cox5Pn","subscribe_url_long":"http://google.us9.list-manage.com/subscribe?u=62148532aa27d5325dd4326f4&id=5f40ce7a52","beamer_address":"us9-c6dc19f3f9-73befb38d6@inbound.mailchimp.com","visibility":"pub","modules":[],"stats":{"member_count":0,"unsubscribe_count":0,"cleaned_count":0,"member_count_since_send":0,"unsubscribe_count_since_send":0,"cleaned_count_since_send":0,"campaign_count":0,"campaign_last_sent":"","merge_field_count":2,"avg_sub_rate":0,"avg_unsub_rate":0,"target_sub_rate":0,"open_rate":0,"click_rate":0,"last_sub_date":"","last_unsub_date":""},"_links":[{"rel":"self","href":"https://us9.api.mailchimp.com/3.0/lists/5f40ce7a52","method":"GET","targetSchema":"https://us9.api.mailchimp.com/schema/3.0/Lists/Instance.json"},{"rel":"parent","href":"https://us9.api.mailchimp.com/3.0/lists","method":"GET","targetSchema":"https://us9.api.mailchimp.com/schema/3.0/Lists/Collection.json","schema":"https://us9.api.mailchimp.com/schema/3.0/CollectionLinks/Lists.json"},{"rel":"update","href":"https://us9.api.mailchimp.com/3.0/lists/5f40ce7a52","method":"PATCH","schema":"https://us9.api.mailchimp.com/schema/3.0/Lists/Instance.json"},{"rel":"batch-sub-unsub-members ","href":"https://us9.api.mailchimp.com/3.0/lists/5f40ce7a52","method":"POST","schema":"https://us9.api.mailchimp.com/schema/3.0/Lists/Instance.json"},{"rel":"delete","href":"https://us9.api.mailchimp.com/3.0/lists/5f40ce7a52","method":"DELETE"},{"rel":"abuse-reports","href":"https://us9.api.mailchimp.com/3.0/lists/5f40ce7a52/abuse-reports","method":"GET","targetSchema":"https://us9.api.mailchimp.com/schema/3.0/Lists/Abuse/Collection.json","schema":"https://us9.api.mailchimp.com/schema/3.0/CollectionLinks/Lists/Abuse.json"},{"rel":"activity","href":"https://us9.api.mailchimp.com/3.0/lists/5f40ce7a52/activity","method":"GET","targetSchema":"https://us9.api.mailchimp.com/schema/3.0/Lists/Activity/Collection.json"},{"rel":"clients","href":"https://us9.api.mailchimp.com/3.0/lists/5f40ce7a52/clients","method":"GET","targetSchema":"https://us9.api.mailchimp.com/schema/3.0/Lists/Clients/Collection.json"},{"rel":"growth-history","href":"https://us9.api.mailchimp.com/3.0/lists/5f40ce7a52/growth-history","method":"GET","targetSchema":"https://us9.api.mailchimp.com/schema/3.0/Lists/Growth/Collection.json","schema":"https://us9.api.mailchimp.com/schema/3.0/CollectionLinks/Lists/Growth.json"},{"rel":"interest-categories","href":"https://us9.api.mailchimp.com/3.0/lists/5f40ce7a52/interest-categories","method":"GET","targetSchema":"https://us9.api.mailchimp.com/schema/3.0/Lists/InterestCategories/Collection.json","schema":"https://us9.api.mailchimp.com/schema/3.0/CollectionLinks/Lists/InterestCategories.json"},{"rel":"members","href":"https://us9.api.mailchimp.com/3.0/lists/5f40ce7a52/members","method":"GET","targetSchema":"https://us9.api.mailchimp.com/schema/3.0/Lists/Members/Collection.json","schema":"https://us9.api.mailchimp.com/schema/3.0/CollectionLinks/Lists/Members.json"},{"rel":"merge-fields","href":"https://us9.api.mailchimp.com/3.0/lists/5f40ce7a52/merge-fields","method":"GET","targetSchema":"https://us9.api.mailchimp.com/schema/3.0/Lists/MergeFields/Collection.json","schema":"https://us9.api.mailchimp.com/schema/3.0/CollectionLinks/Lists/MergeFields.json"},{"rel":"segments","href":"https://us9.api.mailchimp.com/3.0/lists/5f40ce7a52/segments","method":"GET","targetSchema":"https://us9.api.mailchimp.com/schema/3.0/Lists/Segments/Collection.json","schema":"https://us9.api.mailchimp.com/schema/3.0/CollectionLinks/Lists/Segments.json"},{"rel":"webhooks","href":"https://us9.api.mailchimp.com/3.0/lists/5f40ce7a52/webhooks","method":"GET","targetSchema":"https://us9.api.mailchimp.com/schema/3.0/Lists/Webhooks/Collection.json","schema":"https://us9.api.mailchimp.com/schema/3.0/CollectionLinks/Lists/Webhooks.json"},{"rel":"twitter-lead-gen-cards","href":"https://us9.api.mailchimp.com/3.0/lists/5f40ce7a52/twitter-lead-gen-cards","method":"GET","targetSchema":"https://us9.api.mailchimp.com/schema/3.0/Lists/TwitterLeadGenCards/Collection.json","schema":"https://us9.api.mailchimp.com/schema/3.0/CollectionLinks/Lists/TwitterLeadGenCards.json"},{"rel":"signup-forms","href":"https://us9.api.mailchimp.com/3.0/lists/5f40ce7a52/signup-forms","method":"GET","targetSchema":"https://us9.api.mailchimp.com/schema/3.0/Lists/SignupForms/Collection.json","schema":"https://us9.api.mailchimp.com/schema/3.0/CollectionLinks/Lists/SignupForms.json"}]}';
                listId= '5f40ce7a52';
                system.debug('New test listId ==============='+listId);
            }
             return listId;
        }
        catch(System.CalloutException ex)
        {
             System.debug('Exception in createNewList'+ex.getMessage());  
             return 'null';
        }
       
    }

    ///OBJECTIVE
    ///To subscribe new members in  Mailchimp
    ///OBJECTIVE
    private static string subscribeListMembers(set<string> setCandidates, Mailchimp_Details__c objMailChimpDtls,String listId)    
    {  
        try
        {   //EZRE_MC_Member_Subscription_Batch_Size label contains no.of subscribers adding to list for single request.             
            String customBatchSize=System.Label.EZRE_MC_Member_Subscription_Batch_Size; 
            system.debug('Batch size custom setting value:'+customBatchSize);
            system.debug('Subscribers to add======'+setCandidates);
            Set<string> batchOfCandidateEmailSet=new Set<String>();
            String strEmailBtchSbscrbe = '';
            Map<Integer,String> candidateEmailsBatchMap=new Map<Integer,String>();
            integer totalEmailCount=0;
            Integer keyValue=1;          
            if((customBatchSize.isNumeric())&&(integer.valueOf(customBatchSize)!=0))
            {
                system.debug('Subscribers batch size:'+customBatchSize);
                for(String cndteEmail:setCandidates)
                {
                    totalEmailCount=totalEmailCount+1;
                    Boolean isFinalBatchOfEmails;
                    strEmailBtchSbscrbe = strEmailBtchSbscrbe+'{"email_address": "'+cndteEmail+'", "status" : "subscribed"}';
                    batchOfCandidateEmailSet.add(cndteEmail);
                    if(totalEmailCount==setCandidates.size())
                    {
                        isFinalBatchOfEmails=true;
                    }
                    else
                    {
                        if(batchOfCandidateEmailSet.size()!=integer.valueOf(customBatchSize))
                        {
                            strEmailBtchSbscrbe=strEmailBtchSbscrbe+',';
                            system.debug('Emails Batch End============'+strEmailBtchSbscrbe);
                        }
                        
                    }
                    if(batchOfCandidateEmailSet.size()==integer.valueOf(customBatchSize)||isFinalBatchOfEmails==true)
                    {
                        system.debug('keyValue============='+keyValue);
                        system.debug('End Of Batches============'+strEmailBtchSbscrbe);        
                        candidateEmailsBatchMap.put(keyValue,strEmailBtchSbscrbe);
                        batchOfCandidateEmailSet.clear();
                        keyValue=keyValue+1;
                        strEmailBtchSbscrbe='';
                    }
                    
                } 
                if(candidateEmailsBatchMap.size()>0)
                {
                    for(Integer noOfEmailBatches:candidateEmailsBatchMap.Keyset())
                    {
                        String  subscribers=''; 
                        String  reqBody='{"members":[';
                        HttpResponse res;
                        if(candidateEmailsBatchMap.containsKey(noOfEmailBatches))
                        {
                            subscribers=candidateEmailsBatchMap.get(noOfEmailBatches);
                            subscribers=reqBody+subscribers+'],"update_existing":false}';
                            Http h = new Http();        
                            HttpRequest req = new HttpRequest(); 
                            req.setMethod('POST');
                            req.setHeader('Authorization', 'apikey '+objMailChimpDtls.API_Key__c);
                            req.setBody(subscribers);       
                            req.setEndpoint('https://'+objMailChimpDtls.Domain_Name__c+'.api.mailchimp.com/3.0/lists/'+listId);
                            req.setTimeout(120000);  
                            if(!Test.isRunningTest())
                            {         
                                res = h.send(req);
                                system.debug('Add subscribers Res body==============='+res.getBody());
                            }
                        }
                
                    }
                }
            }
            return 'true';
        }
        catch(System.CalloutException ex)
        {
            System.debug('Exception in updating members========'+ex.getMessage());
            return 'false';
            
        }
    }

    ///OBJECTIVE
    ///Create Campaign in Mailchimp
    ///OBJECTIVE    
    private static string createMCCampaign(Mailchimp_Details__c objMailChimp, RequirementAssignment__c objReqAssgn, Requirement__c objReqmt,String listId)    
    {                 
        try
        {
            string strCmpgnId = '';
            String strJobType;
            if(string.isNotBlank(objReqmt.Requirement_Type__c))
            {
                strJobType=objReqmt.Requirement_Type__c;
            }
            else{
                strJobType='';
            }
            String campaingSenderName='';
            String campaignSenderEmail='';
            String campaignSenderPhone='';
            if(string.isNotBlank(objReqAssgn.Lead_Recruiter__c))
            {
                campaingSenderName=objReqAssgn.Lead_Recruiter__r.Name;  
                campaignSenderEmail=objReqAssgn.Lead_Recruiter__r.Email;
                campaignSenderPhone=objReqAssgn.Lead_Recruiter__r.Phone;
            }
            else if(string.isNotBlank(objReqAssgn.Recruiter__c))
            {
                campaingSenderName=objReqAssgn.Recruiter__r.Name;
                campaignSenderEmail=objReqAssgn.Recruiter__r.Email;
                campaignSenderPhone=objReqAssgn.Recruiter__r.Phone; 
            }
            
            String body = '<html><body><br><br>'                      
            +'Greetings!!<br><br>This is '+ campaingSenderName + ' ' + 'from PreludeSys,'+
            '<br><br>'+'I have the following open position. Kindly go through the Job Details and if you are suitable and interested please let me know.'+
            '<br><br><table><tr></tr></table>'+
            '<td>Job Title</td><td>:</td>   <td>'+objReqmt.Name+
            '<br><tr><td>Job Type</td><td>:</td>   <td>'+strJobType+
            '<br></td></tr><tr><td>Duration</td><td>:</td>   <td>'+objReqmt.Duration__c+ 
            '<br></td></tr><tr><td>Location</td><td>:</td>   <td>'+objReqmt.Location__c ;  
            if(objReqmt.Preference__c != null)
            {
            body += '</td></tr><tr><td>Preference</td><td>:</td>    <td>'+objReqmt.Preference__c ;
            }

            body += '</td><br></tr><tr><td>Interview Type</td><td>:</td>   <td>'+objReqmt.Interview_Type__c+
            '</td></tr>'+
            '<br><br>' + 'Description: '+objReqmt.Skill_Set__c+
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

             system.debug('campaingSenderName:========'+campaingSenderName); 
             body += '<br><br>'+campaingSenderName;
                 
             system.debug('campaignSenderEmail:========'+campaignSenderEmail); 
             body += '<br>'+campaignSenderEmail;
                
             if(campaignSenderPhone!= null)
             {
                  system.debug('campaignSenderPhone:========'+campaignSenderPhone); 
                  body += '<br>'+campaignSenderPhone;
             }
            body += '<br><br>If this Job Description DOES NOT MATCH your skills AND/OR experience please forward this email to any of your friends who might be interested. Also share with us your latest Resume so that we can send you more SUITABLE Requirements in the future.</br></br>';
            body +=  '</body></html>';     
              
         
                String subject = 'Need' + ' ' + objReqmt.Name + ' ' + 'in' + ' ' + objReqmt.City__c + ',' + ' ' + objReqmt.State__c + ' ' + 'for' + ' ' + objReqmt.Position_Type__c;
                String fromEmail =campaignSenderEmail;
                String fromName = 'PreludeSys';
                String replyToName =campaignSenderEmail;
                String toName= '';
                Http h = new Http();        
                HttpRequest reqst = new HttpRequest();
                reqst.setMethod('POST');
                reqst.setHeader('Authorization', 'apikey '+objMailChimp.API_Key__c);                    
                HttpResponse res = new HttpResponse();
                body = body.replaceAll('\r\n', '<br/>').replaceAll('\n', '<br/>').replaceAll('\r', '<br/>');         
                reqst.setBody('{"type": "regular","recipients":{"list_id":"'+listId+'"}, "settings":{"subject_line":"'+subject+'","from_name":"'+fromName+'","reply_to":"'+replyToName+'","inline_css": true}}');                
                reqst.setEndpoint('https://'+objMailChimp.Domain_Name__c+'.api.mailchimp.com/3.0/campaigns'); 
                reqst.setTimeout(120000);
          
            if(!Test.isRunningTest())
            {                    
              res = h.send(reqst);        
              JSONWrapper jsonWrapObj = (JSONWrapper)JSON.deserialize(res.getBody(), JSONWrapper.class);
              strCmpgnId = jsonWrapObj.id;              
              
            }  
            else
            {
                res.setStatusCode(200);
                strCmpgnId = 'TestCampaign';
            }

            if(res.getStatusCode() == 200)
            {             
                createCampaignContent(objMailChimp,strCmpgnId,body); 
            }
            
            return strCmpgnId;   
        }
        catch(System.CalloutException ex)
        {
            System.debug('Exception in createCampaign'+ex.getMessage());  
            return null;
        }   
    }
     ///OBJECTIVE
    ///Create Content for the given Campaign in Mailchimp
    ///OBJECTIVE
    private static void createCampaignContent(Mailchimp_Details__c objMailChimp,String sCmpgnId, String sEmailCntnt)
    {
        try
        {
            Http h = new Http();        
            HttpRequest reqst = new HttpRequest();
            reqst.setMethod('PUT');
            reqst.setHeader('Authorization', 'apikey '+objMailChimp.API_Key__c);
            HttpResponse res = new HttpResponse();            
            reqst.setBody('{"html": "'+sEmailCntnt+'"}');            
            reqst.setEndpoint('https://'+objMailChimp.Domain_Name__c+'.api.mailchimp.com/3.0/campaigns/'+sCmpgnId+'/content'); 
            reqst.setTimeout(120000);
            if(!Test.isRunningTest())
            {                        
                res = h.send(reqst);                
            }  
            else
            {
                // do nothing
            }
        }
        catch(Exception ex)
        {
            System.debug('Exception in createCampaignContent'+ex.getMessage());  
        }
        
    }  
     
     ///OBJECTIVE
    ///To get the count of all the Campaign sent before 14 days.
    ///OBJECTIVE 
    private static integer getMCCmpngLstCount()
    {
      integer count=0;
      try
      {
        DateTime campaignSentDateTime = DateTime.Now().addDays(-14);        
        String campaignSentDateTimeStr = string.valueOf(campaignSentDateTime);
        system.debug('campaignSentDateTimeStr------------'+campaignSentDateTimeStr );
        Mailchimp_Details__c MCDtls = new Mailchimp_Details__c();
        MCDtls = EZRE_Data_Utility.getMCDtls('MCAccount');       
        Http h = new Http();        
        HttpRequest reqst = new HttpRequest();      
        reqst.setMethod('GET'); 
        reqst.setHeader('Authorization', 'apikey '+MCDtls.API_Key__c);
        reqst.setEndpoint('https://'+MCDtls.Domain_Name__c+'.api.mailchimp.com/3.0/campaigns?status=sent&since_send_time='+campaignSentDateTimeStr);
        
        reqst.setTimeout(120000);
        HttpResponse res = new HttpResponse();
        string strResponseBody;
        if(!Test.isRunningTest())
        {           
            res = h.send(reqst); 
            strResponseBody = res.getBody();
            System.debug('strResponseBody ------11----------'+strResponseBody );  
        }    
        else
        {
            res.setStatusCode(200);
            strResponseBody = strResponseBody ='{"campaigns":[{"id":"5d489f2be4","type":"regular","create_time":"2016-11-09T11:05:37+00:00","archive_url":"http://eepurl.com/cnWe35","long_archive_url":"http://us9.campaign-archive2.com/?u=62148532aa27d5325dd4326f4&id=5d489f2be4","status":"sent","emails_sent":3,"send_time":"2016-11-09T11:05:39+00:00","content_type":"html","recipients":{"list_id":"3f262a9b48","list_name":"Project Manager - 2 - 52972000161656","segment_text":"","recipient_count":3},"settings":{"subject_line":"Need Project Manager - 2 - 52972000161656 in astin, TX for Contract","title":"","from_name":"PreludeSys","reply_to":"indumathi_v@preludesys.com","use_conversation":false,"to_name":"","folder_id":"","authenticate":true,"auto_footer":false,"inline_css":true,"auto_tweet":false,"fb_comments":true,"timewarp":false,"template_id":0,"drag_and_drop":false},"tracking":{"opens":true,"html_clicks":true,"text_clicks":false,"goal_tracking":false,"ecomm360":false,"google_analytics":"","clicktale":"N"},"report_summary":{"opens":2,"unique_opens":2,"open_rate":1,"clicks":0,"subscriber_clicks":0,"click_rate":0,"ecommerce":{"total_orders":0,"total_spent":0,"total_revenue":0}},"delivery_status":{"enabled":false},"_links":[{"rel":"parent","href":"https://us9.api.mailchimp.com/3.0/campaigns","method":"GET","targetSchema":"https://us9.api.mailchimp.com/schema/3.0/Campaigns/Collection.json","schema":"https://us9.api.mailchimp.com/schema/3.0/CollectionLinks/Campaigns.json"},{"rel":"self","href":"https://us9.api.mailchimp.com/3.0/campaigns/5d489f2be4","method":"GET","targetSchema":"https://us9.api.mailchimp.com/schema/3.0/Campaigns/Instance.json"},{"rel":"delete","href":"https://us9.api.mailchimp.com/3.0/campaigns/5d489f2be4","method":"DELETE"},{"rel":"send","href":"https://us9.api.mailchimp.com/3.0/campaigns/5d489f2be4/actions/send","method":"POST"},{"rel":"cancel_send","href":"https://us9.api.mailchimp.com/3.0/campaigns/5d489f2be4/actions/cancel-send","method":"POST"},{"rel":"feedback","href":"https://us9.api.mailchimp.com/3.0/campaigns/5d489f2be4/feedback","method":"GET","targetSchema":"https://us9.api.mailchimp.com/schema/3.0/Campaigns/Feedback/Collection.json"},{"rel":"content","href":"https://us9.api.mailchimp.com/3.0/campaigns/5d489f2be4/content","method":"GET","targetSchema":"https://us9.api.mailchimp.com/schema/3.0/Campaigns/Content/Collection.json"},{"rel":"send_checklist","href":"https://us9.api.mailchimp.com/3.0/campaigns/5d489f2be4/send-checklist","method":"GET","targetSchema":"https://us9.api.mailchimp.com/schema/3.0/Campaigns/Checklist/Collection.json"},{"rel":"pause","href":"https://us9.api.mailchimp.com/3.0/campaigns/5d489f2be4/actions/pause","method":"POST"},{"rel":"resume","href":"https://us9.api.mailchimp.com/3.0/campaigns/5d489f2be4/actions/resume","method":"POST"},{"rel":"replicate","href":"https://us9.api.mailchimp.com/3.0/campaigns/5d489f2be4/actions/replicate","method":"POST"}]},{"id":"1237c83b96","type":"regular","create_time":"2016-11-09T11:22:20+00:00","archive_url":"http://eepurl.com/cnWnd1","long_archive_url":"http://us9.campaign-archive2.com/?u=62148532aa27d5325dd4326f4&id=1237c83b96","status":"sent","emails_sent":2,"send_time":"2016-11-09T11:22:21+00:00","content_type":"html","recipients":{"list_id":"3f262a9b48","list_name":"Project Manager - 2 - 52972000161656","segment_text":"","recipient_count":2},"settings":{"subject_line":"Need Project Manager - 2 - 52972000161656 in astin, TX for Contract","title":"","from_name":"PreludeSys","reply_to":"indumathi_v@preludesys.com","use_conversation":false,"to_name":"","folder_id":"","authenticate":true,"auto_footer":false,"inline_css":true,"auto_tweet":false,"fb_comments":true,"timewarp":false,"template_id":0,"drag_and_drop":false},"tracking":{"opens":true,"html_clicks":true,"text_clicks":false,"goal_tracking":false,"ecomm360":false,"google_analytics":"","clicktale":"N"},"report_summary":{"opens":1,"unique_opens":1,"open_rate":0.5,"clicks":0,"subscriber_clicks":0,"click_rate":0,"ecommerce":{"total_orders":0,"total_spent":0,"total_revenue":0}},"delivery_status":{"enabled":false},"_links":[{"rel":"parent","href":"https://us9.api.mailchimp.com/3.0/campaigns","method":"GET","targetSchema":"https://us9.api.mailchimp.com/schema/3.0/Campaigns/Collection.json","schema":"https://us9.api.mailchimp.com/schema/3.0/CollectionLinks/Campaigns.json"},{"rel":"self","href":"https://us9.api.mailchimp.com/3.0/campaigns/1237c83b96","method":"GET","targetSchema":"https://us9.api.mailchimp.com/schema/3.0/Campaigns/Instance.json"},{"rel":"delete","href":"https://us9.api.mailchimp.com/3.0/campaigns/1237c83b96","method":"DELETE"},{"rel":"send","href":"https://us9.api.mailchimp.com/3.0/campaigns/1237c83b96/actions/send","method":"POST"},{"rel":"cancel_send","href":"https://us9.api.mailchimp.com/3.0/campaigns/1237c83b96/actions/cancel-send","method":"POST"},{"rel":"feedback","href":"https://us9.api.mailchimp.com/3.0/campaigns/1237c83b96/feedback","method":"GET","targetSchema":"https://us9.api.mailchimp.com/schema/3.0/Campaigns/Feedback/Collection.json"},{"rel":"content","href":"https://us9.api.mailchimp.com/3.0/campaigns/1237c83b96/content","method":"GET","targetSchema":"https://us9.api.mailchimp.com/schema/3.0/Campaigns/Content/Collection.json"},{"rel":"send_checklist","href":"https://us9.api.mailchimp.com/3.0/campaigns/1237c83b96/send-checklist","method":"GET","targetSchema":"https://us9.api.mailchimp.com/schema/3.0/Campaigns/Checklist/Collection.json"},{"rel":"pause","href":"https://us9.api.mailchimp.com/3.0/campaigns/1237c83b96/actions/pause","method":"POST"},{"rel":"resume","href":"https://us9.api.mailchimp.com/3.0/campaigns/1237c83b96/actions/resume","method":"POST"},{"rel":"replicate","href":"https://us9.api.mailchimp.com/3.0/campaigns/1237c83b96/actions/replicate","method":"POST"}]},{"id":"13bf8787f9","type":"regular","create_time":"2016-11-09T11:26:52+00:00","archive_url":"http://eepurl.com/cnWpyH","long_archive_url":"http://us9.campaign-archive2.com/?u=62148532aa27d5325dd4326f4&id=13bf8787f9","status":"sent","emails_sent":0,"send_time":"2016-11-09T11:26:55+00:00","content_type":"html","recipients":{"list_id":"3f262a9b48","list_name":"Project Manager - 2 - 52972000161656","segment_text":"","recipient_count":0},"settings":{"subject_line":"Need Project Manager - 2 - 52972000161656 in astin, TX for Contract","title":"","from_name":"PreludeSys","reply_to":"indumathi_v@preludesys.com","use_conversation":false,"to_name":"","folder_id":"","authenticate":true,"auto_footer":false,"inline_css":true,"auto_tweet":false,"fb_comments":true,"timewarp":false,"template_id":0,"drag_and_drop":false},"tracking":{"opens":true,"html_clicks":true,"text_clicks":false,"goal_tracking":false,"ecomm360":false,"google_analytics":"","clicktale":"N"},"report_summary":{"opens":0,"unique_opens":0,"open_rate":0,"clicks":0,"subscriber_clicks":0,"click_rate":0,"ecommerce":{"total_orders":0,"total_spent":0,"total_revenue":0}},"delivery_status":{"enabled":false},"_links":[{"rel":"parent","href":"https://us9.api.mailchimp.com/3.0/campaigns","method":"GET","targetSchema":"https://us9.api.mailchimp.com/schema/3.0/Campaigns/Collection.json","schema":"https://us9.api.mailchimp.com/schema/3.0/CollectionLinks/Campaigns.json"},{"rel":"self","href":"https://us9.api.mailchimp.com/3.0/campaigns/13bf8787f9","method":"GET","targetSchema":"https://us9.api.mailchimp.com/schema/3.0/Campaigns/Instance.json"},{"rel":"delete","href":"https://us9.api.mailchimp.com/3.0/campaigns/13bf8787f9","method":"DELETE"},{"rel":"send","href":"https://us9.api.mailchimp.com/3.0/campaigns/13bf8787f9/actions/send","method":"POST"},{"rel":"cancel_send","href":"https://us9.api.mailchimp.com/3.0/campaigns/13bf8787f9/actions/cancel-send","method":"POST"},{"rel":"feedback","href":"https://us9.api.mailchimp.com/3.0/campaigns/13bf8787f9/feedback","method":"GET","targetSchema":"https://us9.api.mailchimp.com/schema/3.0/Campaigns/Feedback/Collection.json"},{"rel":"content","href":"https://us9.api.mailchimp.com/3.0/campaigns/13bf8787f9/content","method":"GET","targetSchema":"https://us9.api.mailchimp.com/schema/3.0/Campaigns/Content/Collection.json"},{"rel":"send_checklist","href":"https://us9.api.mailchimp.com/3.0/campaigns/13bf8787f9/send-checklist","method":"GET","targetSchema":"https://us9.api.mailchimp.com/schema/3.0/Campaigns/Checklist/Collection.json"},{"rel":"pause","href":"https://us9.api.mailchimp.com/3.0/campaigns/13bf8787f9/actions/pause","method":"POST"},{"rel":"resume","href":"https://us9.api.mailchimp.com/3.0/campaigns/13bf8787f9/actions/resume","method":"POST"},{"rel":"replicate","href":"https://us9.api.mailchimp.com/3.0/campaigns/13bf8787f9/actions/replicate","method":"POST"}]},{"id":"595e9ef3e2","type":"regular","create_time":"2016-11-09T11:34:19+00:00","archive_url":"http://eepurl.com/cnWuhz","long_archive_url":"http://us9.campaign-archive2.com/?u=62148532aa27d5325dd4326f4&id=595e9ef3e2","status":"sent","emails_sent":0,"send_time":"2016-11-09T11:34:20+00:00","content_type":"html","recipients":{"list_id":"3f262a9b48","list_name":"Project Manager - 2 - 52972000161656","segment_text":"","recipient_count":0},"settings":{"subject_line":"Need Project Manager - 2 - 52972000161656 in astin, TX for Contract","title":"","from_name":"PreludeSys","reply_to":"indumathi_v@preludesys.com","use_conversation":false,"to_name":"","folder_id":"","authenticate":true,"auto_footer":false,"inline_css":true,"auto_tweet":false,"fb_comments":true,"timewarp":false,"template_id":0,"drag_and_drop":false},"tracking":{"opens":true,"html_clicks":true,"text_clicks":false,"goal_tracking":false,"ecomm360":false,"google_analytics":"","clicktale":"N"},"report_summary":{"opens":0,"unique_opens":0,"open_rate":0,"clicks":0,"subscriber_clicks":0,"click_rate":0,"ecommerce":{"total_orders":0,"total_spent":0,"total_revenue":0}},"delivery_status":{"enabled":false},"_links":[{"rel":"parent","href":"https://us9.api.mailchimp.com/3.0/campaigns","method":"GET","targetSchema":"https://us9.api.mailchimp.com/schema/3.0/Campaigns/Collection.json","schema":"https://us9.api.mailchimp.com/schema/3.0/CollectionLinks/Campaigns.json"},{"rel":"self","href":"https://us9.api.mailchimp.com/3.0/campaigns/595e9ef3e2","method":"GET","targetSchema":"https://us9.api.mailchimp.com/schema/3.0/Campaigns/Instance.json"},{"rel":"delete","href":"https://us9.api.mailchimp.com/3.0/campaigns/595e9ef3e2","method":"DELETE"},{"rel":"send","href":"https://us9.api.mailchimp.com/3.0/campaigns/595e9ef3e2/actions/send","method":"POST"},{"rel":"cancel_send","href":"https://us9.api.mailchimp.com/3.0/campaigns/595e9ef3e2/actions/cancel-send","method":"POST"},{"rel":"feedback","href":"https://us9.api.mailchimp.com/3.0/campaigns/595e9ef3e2/feedback","method":"GET","targetSchema":"https://us9.api.mailchimp.com/schema/3.0/Campaigns/Feedback/Collection.json"},{"rel":"content","href":"https://us9.api.mailchimp.com/3.0/campaigns/595e9ef3e2/content","method":"GET","targetSchema":"https://us9.api.mailchimp.com/schema/3.0/Campaigns/Content/Collection.json"},{"rel":"send_checklist","href":"https://us9.api.mailchimp.com/3.0/campaigns/595e9ef3e2/send-checklist","method":"GET","targetSchema":"https://us9.api.mailchimp.com/schema/3.0/Campaigns/Checklist/Collection.json"},{"rel":"pause","href":"https://us9.api.mailchimp.com/3.0/campaigns/595e9ef3e2/actions/pause","method":"POST"},{"rel":"resume","href":"https://us9.api.mailchimp.com/3.0/campaigns/595e9ef3e2/actions/resume","method":"POST"},{"rel":"replicate","href":"https://us9.api.mailchimp.com/3.0/campaigns/595e9ef3e2/actions/replicate","method":"POST"}]},{"id":"4c2ffe6684","type":"regular","create_time":"2016-11-09T12:01:13+00:00","archive_url":"http://eepurl.com/cnWKcz","long_archive_url":"http://us9.campaign-archive1.com/?u=62148532aa27d5325dd4326f4&id=4c2ffe6684","status":"sent","emails_sent":0,"send_time":"2016-11-09T12:01:17+00:00","content_type":"html","recipients":{"list_id":"3f262a9b48","list_name":"Project Manager - 2 - 52972000161656","segment_text":"","recipient_count":0},"settings":{"subject_line":"Need Project Manager - 2 - 52972000161656 in astin, TX for Contract","title":"","from_name":"PreludeSys","reply_to":"indumathi_v@preludesys.com","use_conversation":false,"to_name":"","folder_id":"","authenticate":true,"auto_footer":false,"inline_css":true,"auto_tweet":false,"fb_comments":true,"timewarp":false,"template_id":0,"drag_and_drop":false},"tracking":{"opens":true,"html_clicks":true,"text_clicks":false,"goal_tracking":false,"ecomm360":false,"google_analytics":"","clicktale":"N"},"report_summary":{"opens":0,"unique_opens":0,"open_rate":0,"clicks":0,"subscriber_clicks":0,"click_rate":0,"ecommerce":{"total_orders":0,"total_spent":0,"total_revenue":0}},"delivery_status":{"enabled":false},"_links":[{"rel":"parent","href":"https://us9.api.mailchimp.com/3.0/campaigns","method":"GET","targetSchema":"https://us9.api.mailchimp.com/schema/3.0/Campaigns/Collection.json","schema":"https://us9.api.mailchimp.com/schema/3.0/CollectionLinks/Campaigns.json"},{"rel":"self","href":"https://us9.api.mailchimp.com/3.0/campaigns/4c2ffe6684","method":"GET","targetSchema":"https://us9.api.mailchimp.com/schema/3.0/Campaigns/Instance.json"},{"rel":"delete","href":"https://us9.api.mailchimp.com/3.0/campaigns/4c2ffe6684","method":"DELETE"},{"rel":"send","href":"https://us9.api.mailchimp.com/3.0/campaigns/4c2ffe6684/actions/send","method":"POST"},{"rel":"cancel_send","href":"https://us9.api.mailchimp.com/3.0/campaigns/4c2ffe6684/actions/cancel-send","method":"POST"},{"rel":"feedback","href":"https://us9.api.mailchimp.com/3.0/campaigns/4c2ffe6684/feedback","method":"GET","targetSchema":"https://us9.api.mailchimp.com/schema/3.0/Campaigns/Feedback/Collection.json"},{"rel":"content","href":"https://us9.api.mailchimp.com/3.0/campaigns/4c2ffe6684/content","method":"GET","targetSchema":"https://us9.api.mailchimp.com/schema/3.0/Campaigns/Content/Collection.json"},{"rel":"send_checklist","href":"https://us9.api.mailchimp.com/3.0/campaigns/4c2ffe6684/send-checklist","method":"GET","targetSchema":"https://us9.api.mailchimp.com/schema/3.0/Campaigns/Checklist/Collection.json"},{"rel":"pause","href":"https://us9.api.mailchimp.com/3.0/campaigns/4c2ffe6684/actions/pause","method":"POST"},{"rel":"resume","href":"https://us9.api.mailchimp.com/3.0/campaigns/4c2ffe6684/actions/resume","method":"POST"},{"rel":"replicate","href":"https://us9.api.mailchimp.com/3.0/campaigns/4c2ffe6684/actions/replicate","method":"POST"}]},{"id":"11c989e73d","type":"regular","create_time":"2016-11-09T12:59:06+00:00","archive_url":"http://eepurl.com/cnXdUL","long_archive_url":"http://us9.campaign-archive1.com/?u=62148532aa27d5325dd4326f4&id=11c989e73d","status":"sent","emails_sent":4,"send_time":"2016-11-09T13:22:16+00:00","content_type":"html","recipients":{"list_id":"2f72d0c941","list_name":"Management Systems","segment_text":"","recipient_count":4},"settings":{"subject_line":"Need Management Systems in chennai, AK for Contract","title":"","from_name":"PreludeSys","reply_to":"indumathi_v@preludesys.com","use_conversation":false,"to_name":"","folder_id":"","authenticate":true,"auto_footer":false,"inline_css":true,"auto_tweet":false,"fb_comments":true,"timewarp":false,"template_id":0,"drag_and_drop":false},"tracking":{"opens":true,"html_clicks":true,"text_clicks":false,"goal_tracking":false,"ecomm360":false,"google_analytics":"","clicktale":"N"},"report_summary":{"opens":0,"unique_opens":0,"open_rate":0,"clicks":0,"subscriber_clicks":0,"click_rate":0,"ecommerce":{"total_orders":0,"total_spent":0,"total_revenue":0}},"delivery_status":{"enabled":false},"_links":[{"rel":"parent","href":"https://us9.api.mailchimp.com/3.0/campaigns","method":"GET","targetSchema":"https://us9.api.mailchimp.com/schema/3.0/Campaigns/Collection.json","schema":"https://us9.api.mailchimp.com/schema/3.0/CollectionLinks/Campaigns.json"},{"rel":"self","href":"https://us9.api.mailchimp.com/3.0/campaigns/11c989e73d","method":"GET","targetSchema":"https://us9.api.mailchimp.com/schema/3.0/Campaigns/Instance.json"},{"rel":"delete","href":"https://us9.api.mailchimp.com/3.0/campaigns/11c989e73d","method":"DELETE"},{"rel":"send","href":"https://us9.api.mailchimp.com/3.0/campaigns/11c989e73d/actions/send","method":"POST"},{"rel":"cancel_send","href":"https://us9.api.mailchimp.com/3.0/campaigns/11c989e73d/actions/cancel-send","method":"POST"},{"rel":"feedback","href":"https://us9.api.mailchimp.com/3.0/campaigns/11c989e73d/feedback","method":"GET","targetSchema":"https://us9.api.mailchimp.com/schema/3.0/Campaigns/Feedback/Collection.json"},{"rel":"content","href":"https://us9.api.mailchimp.com/3.0/campaigns/11c989e73d/content","method":"GET","targetSchema":"https://us9.api.mailchimp.com/schema/3.0/Campaigns/Content/Collection.json"},{"rel":"send_checklist","href":"https://us9.api.mailchimp.com/3.0/campaigns/11c989e73d/send-checklist","method":"GET","targetSchema":"https://us9.api.mailchimp.com/schema/3.0/Campaigns/Checklist/Collection.json"},{"rel":"pause","href":"https://us9.api.mailchimp.com/3.0/campaigns/11c989e73d/actions/pause","method":"POST"},{"rel":"resume","href":"https://us9.api.mailchimp.com/3.0/campaigns/11c989e73d/actions/resume","method":"POST"},{"rel":"replicate","href":"https://us9.api.mailchimp.com/3.0/campaigns/11c989e73d/actions/replicate","method":"POST"}]},{"id":"a964efd745","type":"regular","create_time":"2016-11-11T10:17:58+00:00","archive_url":"http://eepurl.com/cogrN5","long_archive_url":"http://us9.campaign-archive1.com/?u=62148532aa27d5325dd4326f4&id=a964efd745","status":"sent","emails_sent":0,"send_time":"2016-11-11T10:18:00+00:00","content_type":"html","recipients":{"list_id":"3f262a9b48","list_name":"Project Manager - 2 - 52972000161656","segment_text":"","recipient_count":0},"settings":{"subject_line":"Need Talend Test Engineer in Chennai, GU for Contract","title":"","from_name":"PreludeSys","reply_to":"subhashini_r@preludesys.com","use_conversation":false,"to_name":"","folder_id":"","authenticate":true,"auto_footer":false,"inline_css":true,"auto_tweet":false,"fb_comments":true,"timewarp":false,"template_id":0,"drag_and_drop":false},"tracking":{"opens":true,"html_clicks":true,"text_clicks":false,"goal_tracking":false,"ecomm360":false,"google_analytics":"","clicktale":"N"},"report_summary":{"opens":0,"unique_opens":0,"open_rate":0,"clicks":0,"subscriber_clicks":0,"click_rate":0,"ecommerce":{"total_orders":0,"total_spent":0,"total_revenue":0}},"delivery_status":{"enabled":false},"_links":[{"rel":"parent","href":"https://us9.api.mailchimp.com/3.0/campaigns","method":"GET","targetSchema":"https://us9.api.mailchimp.com/schema/3.0/Campaigns/Collection.json","schema":"https://us9.api.mailchimp.com/schema/3.0/CollectionLinks/Campaigns.json"},{"rel":"self","href":"https://us9.api.mailchimp.com/3.0/campaigns/a964efd745","method":"GET","targetSchema":"https://us9.api.mailchimp.com/schema/3.0/Campaigns/Instance.json"},{"rel":"delete","href":"https://us9.api.mailchimp.com/3.0/campaigns/a964efd745","method":"DELETE"},{"rel":"send","href":"https://us9.api.mailchimp.com/3.0/campaigns/a964efd745/actions/send","method":"POST"},{"rel":"cancel_send","href":"https://us9.api.mailchimp.com/3.0/campaigns/a964efd745/actions/cancel-send","method":"POST"},{"rel":"feedback","href":"https://us9.api.mailchimp.com/3.0/campaigns/a964efd745/feedback","method":"GET","targetSchema":"https://us9.api.mailchimp.com/schema/3.0/Campaigns/Feedback/Collection.json"},{"rel":"content","href":"https://us9.api.mailchimp.com/3.0/campaigns/a964efd745/content","method":"GET","targetSchema":"https://us9.api.mailchimp.com/schema/3.0/Campaigns/Content/Collection.json"},{"rel":"send_checklist","href":"https://us9.api.mailchimp.com/3.0/campaigns/a964efd745/send-checklist","method":"GET","targetSchema":"https://us9.api.mailchimp.com/schema/3.0/Campaigns/Checklist/Collection.json"},{"rel":"pause","href":"https://us9.api.mailchimp.com/3.0/campaigns/a964efd745/actions/pause","method":"POST"},{"rel":"resume","href":"https://us9.api.mailchimp.com/3.0/campaigns/a964efd745/actions/resume","method":"POST"},{"rel":"replicate","href":"https://us9.api.mailchimp.com/3.0/campaigns/a964efd745/actions/replicate","method":"POST"}]},{"id":"78390833cd","type":"regular","create_time":"2016-11-11T12:01:21+00:00","archive_url":"http://eepurl.com/cohl9j","long_archive_url":"http://us9.campaign-archive1.com/?u=62148532aa27d5325dd4326f4&id=78390833cd","status":"sent","emails_sent":2,"send_time":"2016-11-11T12:19:00+00:00","content_type":"html","recipients":{"list_id":"6ba03c8513","list_name":"MailChimpRequirement","segment_text":"","recipient_count":2},"settings":{"subject_line":"Need MailChimpRequirement in chennai, AK for Contract","title":"","from_name":"PreludeSys","reply_to":"indumathi_v@preludesys.com","use_conversation":false,"to_name":"","folder_id":"","authenticate":true,"auto_footer":false,"inline_css":true,"auto_tweet":false,"fb_comments":true,"timewarp":false,"template_id":0,"drag_and_drop":false},"tracking":{"opens":true,"html_clicks":true,"text_clicks":false,"goal_tracking":false,"ecomm360":false,"google_analytics":"","clicktale":"N"},"report_summary":{"opens":0,"unique_opens":0,"open_rate":0,"clicks":0,"subscriber_clicks":0,"click_rate":0,"ecommerce":{"total_orders":0,"total_spent":0,"total_revenue":0}},"delivery_status":{"enabled":false},"_links":[{"rel":"parent","href":"https://us9.api.mailchimp.com/3.0/campaigns","method":"GET","targetSchema":"https://us9.api.mailchimp.com/schema/3.0/Campaigns/Collection.json","schema":"https://us9.api.mailchimp.com/schema/3.0/CollectionLinks/Campaigns.json"},{"rel":"self","href":"https://us9.api.mailchimp.com/3.0/campaigns/78390833cd","method":"GET","targetSchema":"https://us9.api.mailchimp.com/schema/3.0/Campaigns/Instance.json"},{"rel":"delete","href":"https://us9.api.mailchimp.com/3.0/campaigns/78390833cd","method":"DELETE"},{"rel":"send","href":"https://us9.api.mailchimp.com/3.0/campaigns/78390833cd/actions/send","method":"POST"},{"rel":"cancel_send","href":"https://us9.api.mailchimp.com/3.0/campaigns/78390833cd/actions/cancel-send","method":"POST"},{"rel":"feedback","href":"https://us9.api.mailchimp.com/3.0/campaigns/78390833cd/feedback","method":"GET","targetSchema":"https://us9.api.mailchimp.com/schema/3.0/Campaigns/Feedback/Collection.json"},{"rel":"content","href":"https://us9.api.mailchimp.com/3.0/campaigns/78390833cd/content","method":"GET","targetSchema":"https://us9.api.mailchimp.com/schema/3.0/Campaigns/Content/Collection.json"},{"rel":"send_checklist","href":"https://us9.api.mailchimp.com/3.0/campaigns/78390833cd/send-checklist","method":"GET","targetSchema":"https://us9.api.mailchimp.com/schema/3.0/Campaigns/Checklist/Collection.json"},{"rel":"pause","href":"https://us9.api.mailchimp.com/3.0/campaigns/78390833cd/actions/pause","method":"POST"},{"rel":"resume","href":"https://us9.api.mailchimp.com/3.0/campaigns/78390833cd/actions/resume","method":"POST"},{"rel":"replicate","href":"https://us9.api.mailchimp.com/3.0/campaigns/78390833cd/actions/replicate","method":"POST"}]},{"id":"67ce097c13","type":"regular","create_time":"2016-11-11T14:21:45+00:00","archive_url":"http://eepurl.com/coiJLT","long_archive_url":"http://us9.campaign-archive2.com/?u=62148532aa27d5325dd4326f4&id=67ce097c13","status":"sent","emails_sent":8,"send_time":"2016-11-11T14:41:06+00:00","content_type":"html","recipients":{"list_id":"99b65346a1","list_name":"Salesforce","segment_text":"","recipient_count":8},"settings":{"subject_line":"Need Salesforce in banglore, AK for ContractToHire","title":"","from_name":"PreludeSys","reply_to":"indumathi_v@preludesys.com","use_conversation":false,"to_name":"","folder_id":"","authenticate":true,"auto_footer":false,"inline_css":true,"auto_tweet":false,"fb_comments":true,"timewarp":false,"template_id":0,"drag_and_drop":false},"tracking":{"opens":true,"html_clicks":true,"text_clicks":false,"goal_tracking":false,"ecomm360":false,"google_analytics":"","clicktale":"N"},"report_summary":{"opens":0,"unique_opens":0,"open_rate":0,"clicks":0,"subscriber_clicks":0,"click_rate":0,"ecommerce":{"total_orders":0,"total_spent":0,"total_revenue":0}},"delivery_status":{"enabled":false},"_links":[{"rel":"parent","href":"https://us9.api.mailchimp.com/3.0/campaigns","method":"GET","targetSchema":"https://us9.api.mailchimp.com/schema/3.0/Campaigns/Collection.json","schema":"https://us9.api.mailchimp.com/schema/3.0/CollectionLinks/Campaigns.json"},{"rel":"self","href":"https://us9.api.mailchimp.com/3.0/campaigns/67ce097c13","method":"GET","targetSchema":"https://us9.api.mailchimp.com/schema/3.0/Campaigns/Instance.json"},{"rel":"delete","href":"https://us9.api.mailchimp.com/3.0/campaigns/67ce097c13","method":"DELETE"},{"rel":"send","href":"https://us9.api.mailchimp.com/3.0/campaigns/67ce097c13/actions/send","method":"POST"},{"rel":"cancel_send","href":"https://us9.api.mailchimp.com/3.0/campaigns/67ce097c13/actions/cancel-send","method":"POST"},{"rel":"feedback","href":"https://us9.api.mailchimp.com/3.0/campaigns/67ce097c13/feedback","method":"GET","targetSchema":"https://us9.api.mailchimp.com/schema/3.0/Campaigns/Feedback/Collection.json"},{"rel":"content","href":"https://us9.api.mailchimp.com/3.0/campaigns/67ce097c13/content","method":"GET","targetSchema":"https://us9.api.mailchimp.com/schema/3.0/Campaigns/Content/Collection.json"},{"rel":"send_checklist","href":"https://us9.api.mailchimp.com/3.0/campaigns/67ce097c13/send-checklist","method":"GET","targetSchema":"https://us9.api.mailchimp.com/schema/3.0/Campaigns/Checklist/Collection.json"},{"rel":"pause","href":"https://us9.api.mailchimp.com/3.0/campaigns/67ce097c13/actions/pause","method":"POST"},{"rel":"resume","href":"https://us9.api.mailchimp.com/3.0/campaigns/67ce097c13/actions/resume","method":"POST"},{"rel":"replicate","href":"https://us9.api.mailchimp.com/3.0/campaigns/67ce097c13/actions/replicate","method":"POST"}]},{"id":"4c43775ab9","type":"regular","create_time":"2016-11-14T05:03:23+00:00","archive_url":"http://eepurl.com/cow3kz","long_archive_url":"http://us9.campaign-archive1.com/?u=62148532aa27d5325dd4326f4&id=4c43775ab9","status":"sent","emails_sent":2,"send_time":"2016-11-14T05:04:34+00:00","content_type":"html","recipients":{"list_id":"8f9d01dd8e","list_name":"SeniorArchitect","segment_text":"","recipient_count":2},"settings":{"subject_line":"Need SeniorArchitect in Chennai, AR for ContractToHire","title":"","from_name":"PreludeSys","reply_to":"subhashini_r@preludesys.com","use_conversation":false,"to_name":"","folder_id":"","authenticate":true,"auto_footer":false,"inline_css":true,"auto_tweet":false,"fb_comments":true,"timewarp":false,"template_id":0,"drag_and_drop":false},"tracking":{"opens":true,"html_clicks":true,"text_clicks":false,"goal_tracking":false,"ecomm360":false,"google_analytics":"","clicktale":"N"},"report_summary":{"opens":0,"unique_opens":0,"open_rate":0,"clicks":0,"subscriber_clicks":0,"click_rate":0,"ecommerce":{"total_orders":0,"total_spent":0,"total_revenue":0}},"delivery_status":{"enabled":false},"_links":[{"rel":"parent","href":"https://us9.api.mailchimp.com/3.0/campaigns","method":"GET","targetSchema":"https://us9.api.mailchimp.com/schema/3.0/Campaigns/Collection.json","schema":"https://us9.api.mailchimp.com/schema/3.0/CollectionLinks/Campaigns.json"},{"rel":"self","href":"https://us9.api.mailchimp.com/3.0/campaigns/4c43775ab9","method":"GET","targetSchema":"https://us9.api.mailchimp.com/schema/3.0/Campaigns/Instance.json"},{"rel":"delete","href":"https://us9.api.mailchimp.com/3.0/campaigns/4c43775ab9","method":"DELETE"},{"rel":"send","href":"https://us9.api.mailchimp.com/3.0/campaigns/4c43775ab9/actions/send","method":"POST"},{"rel":"cancel_send","href":"https://us9.api.mailchimp.com/3.0/campaigns/4c43775ab9/actions/cancel-send","method":"POST"},{"rel":"feedback","href":"https://us9.api.mailchimp.com/3.0/campaigns/4c43775ab9/feedback","method":"GET","targetSchema":"https://us9.api.mailchimp.com/schema/3.0/Campaigns/Feedback/Collection.json"},{"rel":"content","href":"https://us9.api.mailchimp.com/3.0/campaigns/4c43775ab9/content","method":"GET","targetSchema":"https://us9.api.mailchimp.com/schema/3.0/Campaigns/Content/Collection.json"},{"rel":"send_checklist","href":"https://us9.api.mailchimp.com/3.0/campaigns/4c43775ab9/send-checklist","method":"GET","targetSchema":"https://us9.api.mailchimp.com/schema/3.0/Campaigns/Checklist/Collection.json"},{"rel":"pause","href":"https://us9.api.mailchimp.com/3.0/campaigns/4c43775ab9/actions/pause","method":"POST"},{"rel":"resume","href":"https://us9.api.mailchimp.com/3.0/campaigns/4c43775ab9/actions/resume","method":"POST"},{"rel":"replicate","href":"https://us9.api.mailchimp.com/3.0/campaigns/4c43775ab9/actions/replicate","method":"POST"}]}],"total_items":10,"_links":[{"rel":"parent","href":"https://us9.api.mailchimp.com/3.0/","method":"GET","targetSchema":"https://us9.api.mailchimp.com/schema/3.0/Root.json"},{"rel":"self","href":"https://us9.api.mailchimp.com/3.0/campaigns","method":"GET","targetSchema":"https://us9.api.mailchimp.com/schema/3.0/Campaigns/Collection.json","schema":"https://us9.api.mailchimp.com/schema/3.0/CollectionLinks/Campaigns.json"},{"rel":"create","href":"https://us9.api.mailchimp.com/3.0/campaigns","method":"POST","schema":"https://us9.api.mailchimp.com/schema/3.0/Campaigns/Instance.json"}]}';
        } 

        if(res.getStatusCode() == 200)
        {  
            Map<String, Object> mapRespJSON = (Map<String, Object>)JSON.deserializeUntyped(strResponseBody);
            if(mapRespJSON.containsKey('total_items'))
            {   
                count = integer.Valueof(mapRespJSON.get('total_items')); 
            }
        }
        System.debug('Campaign Count:========='+count);
        return count;
      }
      catch(System.CalloutException ex)
      {
        System.debug('## Exception in getMCCmpngLstCount ##'+ex);
        return count;
      } 
    }
    ///OBJECTIVE
    ///To get the list Id from all the Campaign sent before 7 days.
    ///OBJECTIVE 
    @future (callout=true)
    public static void getMCCmpngLst()
    {
      integer Campignscount = getMCCmpngLstCount();
      try
      {
        DateTime campaignSentDateTime = DateTime.Now().addDays(-14);     
        String campaignSentDateTimeStr = string.valueOf(campaignSentDateTime);
        DateTime dateTodelList= DateTime.Now().addDays(-7);
        System.debug('dateTodelList---------------'+dateTodelList);
        Set<String> listIdsToDelete=new Set<String>();
        System.debug('campaignSentDateTimeStr---------'+campaignSentDateTimeStr );
        Mailchimp_Details__c MCDtls = new Mailchimp_Details__c();
        MCDtls = EZRE_Data_Utility.getMCDtls('MCAccount');       
        Http h = new Http();        
        HttpRequest reqst = new HttpRequest();      
        reqst.setMethod('GET'); 
        reqst.setHeader('Authorization', 'apikey '+MCDtls.API_Key__c);
        reqst.setEndpoint('https://'+MCDtls.Domain_Name__c+'.api.mailchimp.com/3.0/campaigns?count='+Campignscount+'status=sent&since_send_time='+campaignSentDateTimeStr);
        reqst.setTimeout(120000);
        HttpResponse res = new HttpResponse();
        string strResponseBody;
        if(!Test.isRunningTest())
        {           
            res = h.send(reqst); 
            strResponseBody = res.getBody();
            System.debug('strResponseBody ------11----------'+strResponseBody );
           
        }       
        else
        {
            res.setStatusCode(200);
            strResponseBody ='{"campaigns":[{"id":"5d489f2be4","type":"regular","create_time":"2016-11-09T11:05:37+00:00","archive_url":"http://eepurl.com/cnWe35","long_archive_url":"http://us9.campaign-archive2.com/?u=62148532aa27d5325dd4326f4&id=5d489f2be4","status":"sent","emails_sent":3,"send_time":"2016-11-09T11:05:39+00:00","content_type":"html","recipients":{"list_id":"3f262a9b48","list_name":"Project Manager - 2 - 52972000161656","segment_text":"","recipient_count":3},"settings":{"subject_line":"Need Project Manager - 2 - 52972000161656 in astin, TX for Contract","title":"","from_name":"PreludeSys","reply_to":"indumathi_v@preludesys.com","use_conversation":false,"to_name":"","folder_id":"","authenticate":true,"auto_footer":false,"inline_css":true,"auto_tweet":false,"fb_comments":true,"timewarp":false,"template_id":0,"drag_and_drop":false},"tracking":{"opens":true,"html_clicks":true,"text_clicks":false,"goal_tracking":false,"ecomm360":false,"google_analytics":"","clicktale":"N"},"report_summary":{"opens":2,"unique_opens":2,"open_rate":1,"clicks":0,"subscriber_clicks":0,"click_rate":0,"ecommerce":{"total_orders":0,"total_spent":0,"total_revenue":0}},"delivery_status":{"enabled":false},"_links":[{"rel":"parent","href":"https://us9.api.mailchimp.com/3.0/campaigns","method":"GET","targetSchema":"https://us9.api.mailchimp.com/schema/3.0/Campaigns/Collection.json","schema":"https://us9.api.mailchimp.com/schema/3.0/CollectionLinks/Campaigns.json"},{"rel":"self","href":"https://us9.api.mailchimp.com/3.0/campaigns/5d489f2be4","method":"GET","targetSchema":"https://us9.api.mailchimp.com/schema/3.0/Campaigns/Instance.json"},{"rel":"delete","href":"https://us9.api.mailchimp.com/3.0/campaigns/5d489f2be4","method":"DELETE"},{"rel":"send","href":"https://us9.api.mailchimp.com/3.0/campaigns/5d489f2be4/actions/send","method":"POST"},{"rel":"cancel_send","href":"https://us9.api.mailchimp.com/3.0/campaigns/5d489f2be4/actions/cancel-send","method":"POST"},{"rel":"feedback","href":"https://us9.api.mailchimp.com/3.0/campaigns/5d489f2be4/feedback","method":"GET","targetSchema":"https://us9.api.mailchimp.com/schema/3.0/Campaigns/Feedback/Collection.json"},{"rel":"content","href":"https://us9.api.mailchimp.com/3.0/campaigns/5d489f2be4/content","method":"GET","targetSchema":"https://us9.api.mailchimp.com/schema/3.0/Campaigns/Content/Collection.json"},{"rel":"send_checklist","href":"https://us9.api.mailchimp.com/3.0/campaigns/5d489f2be4/send-checklist","method":"GET","targetSchema":"https://us9.api.mailchimp.com/schema/3.0/Campaigns/Checklist/Collection.json"},{"rel":"pause","href":"https://us9.api.mailchimp.com/3.0/campaigns/5d489f2be4/actions/pause","method":"POST"},{"rel":"resume","href":"https://us9.api.mailchimp.com/3.0/campaigns/5d489f2be4/actions/resume","method":"POST"},{"rel":"replicate","href":"https://us9.api.mailchimp.com/3.0/campaigns/5d489f2be4/actions/replicate","method":"POST"}]},{"id":"1237c83b96","type":"regular","create_time":"2016-11-09T11:22:20+00:00","archive_url":"http://eepurl.com/cnWnd1","long_archive_url":"http://us9.campaign-archive2.com/?u=62148532aa27d5325dd4326f4&id=1237c83b96","status":"sent","emails_sent":2,"send_time":"2016-11-09T11:22:21+00:00","content_type":"html","recipients":{"list_id":"3f262a9b48","list_name":"Project Manager - 2 - 52972000161656","segment_text":"","recipient_count":2},"settings":{"subject_line":"Need Project Manager - 2 - 52972000161656 in astin, TX for Contract","title":"","from_name":"PreludeSys","reply_to":"indumathi_v@preludesys.com","use_conversation":false,"to_name":"","folder_id":"","authenticate":true,"auto_footer":false,"inline_css":true,"auto_tweet":false,"fb_comments":true,"timewarp":false,"template_id":0,"drag_and_drop":false},"tracking":{"opens":true,"html_clicks":true,"text_clicks":false,"goal_tracking":false,"ecomm360":false,"google_analytics":"","clicktale":"N"},"report_summary":{"opens":1,"unique_opens":1,"open_rate":0.5,"clicks":0,"subscriber_clicks":0,"click_rate":0,"ecommerce":{"total_orders":0,"total_spent":0,"total_revenue":0}},"delivery_status":{"enabled":false},"_links":[{"rel":"parent","href":"https://us9.api.mailchimp.com/3.0/campaigns","method":"GET","targetSchema":"https://us9.api.mailchimp.com/schema/3.0/Campaigns/Collection.json","schema":"https://us9.api.mailchimp.com/schema/3.0/CollectionLinks/Campaigns.json"},{"rel":"self","href":"https://us9.api.mailchimp.com/3.0/campaigns/1237c83b96","method":"GET","targetSchema":"https://us9.api.mailchimp.com/schema/3.0/Campaigns/Instance.json"},{"rel":"delete","href":"https://us9.api.mailchimp.com/3.0/campaigns/1237c83b96","method":"DELETE"},{"rel":"send","href":"https://us9.api.mailchimp.com/3.0/campaigns/1237c83b96/actions/send","method":"POST"},{"rel":"cancel_send","href":"https://us9.api.mailchimp.com/3.0/campaigns/1237c83b96/actions/cancel-send","method":"POST"},{"rel":"feedback","href":"https://us9.api.mailchimp.com/3.0/campaigns/1237c83b96/feedback","method":"GET","targetSchema":"https://us9.api.mailchimp.com/schema/3.0/Campaigns/Feedback/Collection.json"},{"rel":"content","href":"https://us9.api.mailchimp.com/3.0/campaigns/1237c83b96/content","method":"GET","targetSchema":"https://us9.api.mailchimp.com/schema/3.0/Campaigns/Content/Collection.json"},{"rel":"send_checklist","href":"https://us9.api.mailchimp.com/3.0/campaigns/1237c83b96/send-checklist","method":"GET","targetSchema":"https://us9.api.mailchimp.com/schema/3.0/Campaigns/Checklist/Collection.json"},{"rel":"pause","href":"https://us9.api.mailchimp.com/3.0/campaigns/1237c83b96/actions/pause","method":"POST"},{"rel":"resume","href":"https://us9.api.mailchimp.com/3.0/campaigns/1237c83b96/actions/resume","method":"POST"},{"rel":"replicate","href":"https://us9.api.mailchimp.com/3.0/campaigns/1237c83b96/actions/replicate","method":"POST"}]},{"id":"13bf8787f9","type":"regular","create_time":"2016-11-09T11:26:52+00:00","archive_url":"http://eepurl.com/cnWpyH","long_archive_url":"http://us9.campaign-archive2.com/?u=62148532aa27d5325dd4326f4&id=13bf8787f9","status":"sent","emails_sent":0,"send_time":"2016-11-09T11:26:55+00:00","content_type":"html","recipients":{"list_id":"3f262a9b48","list_name":"Project Manager - 2 - 52972000161656","segment_text":"","recipient_count":0},"settings":{"subject_line":"Need Project Manager - 2 - 52972000161656 in astin, TX for Contract","title":"","from_name":"PreludeSys","reply_to":"indumathi_v@preludesys.com","use_conversation":false,"to_name":"","folder_id":"","authenticate":true,"auto_footer":false,"inline_css":true,"auto_tweet":false,"fb_comments":true,"timewarp":false,"template_id":0,"drag_and_drop":false},"tracking":{"opens":true,"html_clicks":true,"text_clicks":false,"goal_tracking":false,"ecomm360":false,"google_analytics":"","clicktale":"N"},"report_summary":{"opens":0,"unique_opens":0,"open_rate":0,"clicks":0,"subscriber_clicks":0,"click_rate":0,"ecommerce":{"total_orders":0,"total_spent":0,"total_revenue":0}},"delivery_status":{"enabled":false},"_links":[{"rel":"parent","href":"https://us9.api.mailchimp.com/3.0/campaigns","method":"GET","targetSchema":"https://us9.api.mailchimp.com/schema/3.0/Campaigns/Collection.json","schema":"https://us9.api.mailchimp.com/schema/3.0/CollectionLinks/Campaigns.json"},{"rel":"self","href":"https://us9.api.mailchimp.com/3.0/campaigns/13bf8787f9","method":"GET","targetSchema":"https://us9.api.mailchimp.com/schema/3.0/Campaigns/Instance.json"},{"rel":"delete","href":"https://us9.api.mailchimp.com/3.0/campaigns/13bf8787f9","method":"DELETE"},{"rel":"send","href":"https://us9.api.mailchimp.com/3.0/campaigns/13bf8787f9/actions/send","method":"POST"},{"rel":"cancel_send","href":"https://us9.api.mailchimp.com/3.0/campaigns/13bf8787f9/actions/cancel-send","method":"POST"},{"rel":"feedback","href":"https://us9.api.mailchimp.com/3.0/campaigns/13bf8787f9/feedback","method":"GET","targetSchema":"https://us9.api.mailchimp.com/schema/3.0/Campaigns/Feedback/Collection.json"},{"rel":"content","href":"https://us9.api.mailchimp.com/3.0/campaigns/13bf8787f9/content","method":"GET","targetSchema":"https://us9.api.mailchimp.com/schema/3.0/Campaigns/Content/Collection.json"},{"rel":"send_checklist","href":"https://us9.api.mailchimp.com/3.0/campaigns/13bf8787f9/send-checklist","method":"GET","targetSchema":"https://us9.api.mailchimp.com/schema/3.0/Campaigns/Checklist/Collection.json"},{"rel":"pause","href":"https://us9.api.mailchimp.com/3.0/campaigns/13bf8787f9/actions/pause","method":"POST"},{"rel":"resume","href":"https://us9.api.mailchimp.com/3.0/campaigns/13bf8787f9/actions/resume","method":"POST"},{"rel":"replicate","href":"https://us9.api.mailchimp.com/3.0/campaigns/13bf8787f9/actions/replicate","method":"POST"}]},{"id":"595e9ef3e2","type":"regular","create_time":"2016-11-09T11:34:19+00:00","archive_url":"http://eepurl.com/cnWuhz","long_archive_url":"http://us9.campaign-archive2.com/?u=62148532aa27d5325dd4326f4&id=595e9ef3e2","status":"sent","emails_sent":0,"send_time":"2016-11-09T11:34:20+00:00","content_type":"html","recipients":{"list_id":"3f262a9b48","list_name":"Project Manager - 2 - 52972000161656","segment_text":"","recipient_count":0},"settings":{"subject_line":"Need Project Manager - 2 - 52972000161656 in astin, TX for Contract","title":"","from_name":"PreludeSys","reply_to":"indumathi_v@preludesys.com","use_conversation":false,"to_name":"","folder_id":"","authenticate":true,"auto_footer":false,"inline_css":true,"auto_tweet":false,"fb_comments":true,"timewarp":false,"template_id":0,"drag_and_drop":false},"tracking":{"opens":true,"html_clicks":true,"text_clicks":false,"goal_tracking":false,"ecomm360":false,"google_analytics":"","clicktale":"N"},"report_summary":{"opens":0,"unique_opens":0,"open_rate":0,"clicks":0,"subscriber_clicks":0,"click_rate":0,"ecommerce":{"total_orders":0,"total_spent":0,"total_revenue":0}},"delivery_status":{"enabled":false},"_links":[{"rel":"parent","href":"https://us9.api.mailchimp.com/3.0/campaigns","method":"GET","targetSchema":"https://us9.api.mailchimp.com/schema/3.0/Campaigns/Collection.json","schema":"https://us9.api.mailchimp.com/schema/3.0/CollectionLinks/Campaigns.json"},{"rel":"self","href":"https://us9.api.mailchimp.com/3.0/campaigns/595e9ef3e2","method":"GET","targetSchema":"https://us9.api.mailchimp.com/schema/3.0/Campaigns/Instance.json"},{"rel":"delete","href":"https://us9.api.mailchimp.com/3.0/campaigns/595e9ef3e2","method":"DELETE"},{"rel":"send","href":"https://us9.api.mailchimp.com/3.0/campaigns/595e9ef3e2/actions/send","method":"POST"},{"rel":"cancel_send","href":"https://us9.api.mailchimp.com/3.0/campaigns/595e9ef3e2/actions/cancel-send","method":"POST"},{"rel":"feedback","href":"https://us9.api.mailchimp.com/3.0/campaigns/595e9ef3e2/feedback","method":"GET","targetSchema":"https://us9.api.mailchimp.com/schema/3.0/Campaigns/Feedback/Collection.json"},{"rel":"content","href":"https://us9.api.mailchimp.com/3.0/campaigns/595e9ef3e2/content","method":"GET","targetSchema":"https://us9.api.mailchimp.com/schema/3.0/Campaigns/Content/Collection.json"},{"rel":"send_checklist","href":"https://us9.api.mailchimp.com/3.0/campaigns/595e9ef3e2/send-checklist","method":"GET","targetSchema":"https://us9.api.mailchimp.com/schema/3.0/Campaigns/Checklist/Collection.json"},{"rel":"pause","href":"https://us9.api.mailchimp.com/3.0/campaigns/595e9ef3e2/actions/pause","method":"POST"},{"rel":"resume","href":"https://us9.api.mailchimp.com/3.0/campaigns/595e9ef3e2/actions/resume","method":"POST"},{"rel":"replicate","href":"https://us9.api.mailchimp.com/3.0/campaigns/595e9ef3e2/actions/replicate","method":"POST"}]},{"id":"4c2ffe6684","type":"regular","create_time":"2016-11-09T12:01:13+00:00","archive_url":"http://eepurl.com/cnWKcz","long_archive_url":"http://us9.campaign-archive1.com/?u=62148532aa27d5325dd4326f4&id=4c2ffe6684","status":"sent","emails_sent":0,"send_time":"2016-11-09T12:01:17+00:00","content_type":"html","recipients":{"list_id":"3f262a9b48","list_name":"Project Manager - 2 - 52972000161656","segment_text":"","recipient_count":0},"settings":{"subject_line":"Need Project Manager - 2 - 52972000161656 in astin, TX for Contract","title":"","from_name":"PreludeSys","reply_to":"indumathi_v@preludesys.com","use_conversation":false,"to_name":"","folder_id":"","authenticate":true,"auto_footer":false,"inline_css":true,"auto_tweet":false,"fb_comments":true,"timewarp":false,"template_id":0,"drag_and_drop":false},"tracking":{"opens":true,"html_clicks":true,"text_clicks":false,"goal_tracking":false,"ecomm360":false,"google_analytics":"","clicktale":"N"},"report_summary":{"opens":0,"unique_opens":0,"open_rate":0,"clicks":0,"subscriber_clicks":0,"click_rate":0,"ecommerce":{"total_orders":0,"total_spent":0,"total_revenue":0}},"delivery_status":{"enabled":false},"_links":[{"rel":"parent","href":"https://us9.api.mailchimp.com/3.0/campaigns","method":"GET","targetSchema":"https://us9.api.mailchimp.com/schema/3.0/Campaigns/Collection.json","schema":"https://us9.api.mailchimp.com/schema/3.0/CollectionLinks/Campaigns.json"},{"rel":"self","href":"https://us9.api.mailchimp.com/3.0/campaigns/4c2ffe6684","method":"GET","targetSchema":"https://us9.api.mailchimp.com/schema/3.0/Campaigns/Instance.json"},{"rel":"delete","href":"https://us9.api.mailchimp.com/3.0/campaigns/4c2ffe6684","method":"DELETE"},{"rel":"send","href":"https://us9.api.mailchimp.com/3.0/campaigns/4c2ffe6684/actions/send","method":"POST"},{"rel":"cancel_send","href":"https://us9.api.mailchimp.com/3.0/campaigns/4c2ffe6684/actions/cancel-send","method":"POST"},{"rel":"feedback","href":"https://us9.api.mailchimp.com/3.0/campaigns/4c2ffe6684/feedback","method":"GET","targetSchema":"https://us9.api.mailchimp.com/schema/3.0/Campaigns/Feedback/Collection.json"},{"rel":"content","href":"https://us9.api.mailchimp.com/3.0/campaigns/4c2ffe6684/content","method":"GET","targetSchema":"https://us9.api.mailchimp.com/schema/3.0/Campaigns/Content/Collection.json"},{"rel":"send_checklist","href":"https://us9.api.mailchimp.com/3.0/campaigns/4c2ffe6684/send-checklist","method":"GET","targetSchema":"https://us9.api.mailchimp.com/schema/3.0/Campaigns/Checklist/Collection.json"},{"rel":"pause","href":"https://us9.api.mailchimp.com/3.0/campaigns/4c2ffe6684/actions/pause","method":"POST"},{"rel":"resume","href":"https://us9.api.mailchimp.com/3.0/campaigns/4c2ffe6684/actions/resume","method":"POST"},{"rel":"replicate","href":"https://us9.api.mailchimp.com/3.0/campaigns/4c2ffe6684/actions/replicate","method":"POST"}]},{"id":"11c989e73d","type":"regular","create_time":"2016-11-09T12:59:06+00:00","archive_url":"http://eepurl.com/cnXdUL","long_archive_url":"http://us9.campaign-archive1.com/?u=62148532aa27d5325dd4326f4&id=11c989e73d","status":"sent","emails_sent":4,"send_time":"2016-11-09T13:22:16+00:00","content_type":"html","recipients":{"list_id":"2f72d0c941","list_name":"Management Systems","segment_text":"","recipient_count":4},"settings":{"subject_line":"Need Management Systems in chennai, AK for Contract","title":"","from_name":"PreludeSys","reply_to":"indumathi_v@preludesys.com","use_conversation":false,"to_name":"","folder_id":"","authenticate":true,"auto_footer":false,"inline_css":true,"auto_tweet":false,"fb_comments":true,"timewarp":false,"template_id":0,"drag_and_drop":false},"tracking":{"opens":true,"html_clicks":true,"text_clicks":false,"goal_tracking":false,"ecomm360":false,"google_analytics":"","clicktale":"N"},"report_summary":{"opens":0,"unique_opens":0,"open_rate":0,"clicks":0,"subscriber_clicks":0,"click_rate":0,"ecommerce":{"total_orders":0,"total_spent":0,"total_revenue":0}},"delivery_status":{"enabled":false},"_links":[{"rel":"parent","href":"https://us9.api.mailchimp.com/3.0/campaigns","method":"GET","targetSchema":"https://us9.api.mailchimp.com/schema/3.0/Campaigns/Collection.json","schema":"https://us9.api.mailchimp.com/schema/3.0/CollectionLinks/Campaigns.json"},{"rel":"self","href":"https://us9.api.mailchimp.com/3.0/campaigns/11c989e73d","method":"GET","targetSchema":"https://us9.api.mailchimp.com/schema/3.0/Campaigns/Instance.json"},{"rel":"delete","href":"https://us9.api.mailchimp.com/3.0/campaigns/11c989e73d","method":"DELETE"},{"rel":"send","href":"https://us9.api.mailchimp.com/3.0/campaigns/11c989e73d/actions/send","method":"POST"},{"rel":"cancel_send","href":"https://us9.api.mailchimp.com/3.0/campaigns/11c989e73d/actions/cancel-send","method":"POST"},{"rel":"feedback","href":"https://us9.api.mailchimp.com/3.0/campaigns/11c989e73d/feedback","method":"GET","targetSchema":"https://us9.api.mailchimp.com/schema/3.0/Campaigns/Feedback/Collection.json"},{"rel":"content","href":"https://us9.api.mailchimp.com/3.0/campaigns/11c989e73d/content","method":"GET","targetSchema":"https://us9.api.mailchimp.com/schema/3.0/Campaigns/Content/Collection.json"},{"rel":"send_checklist","href":"https://us9.api.mailchimp.com/3.0/campaigns/11c989e73d/send-checklist","method":"GET","targetSchema":"https://us9.api.mailchimp.com/schema/3.0/Campaigns/Checklist/Collection.json"},{"rel":"pause","href":"https://us9.api.mailchimp.com/3.0/campaigns/11c989e73d/actions/pause","method":"POST"},{"rel":"resume","href":"https://us9.api.mailchimp.com/3.0/campaigns/11c989e73d/actions/resume","method":"POST"},{"rel":"replicate","href":"https://us9.api.mailchimp.com/3.0/campaigns/11c989e73d/actions/replicate","method":"POST"}]},{"id":"a964efd745","type":"regular","create_time":"2016-11-11T10:17:58+00:00","archive_url":"http://eepurl.com/cogrN5","long_archive_url":"http://us9.campaign-archive1.com/?u=62148532aa27d5325dd4326f4&id=a964efd745","status":"sent","emails_sent":0,"send_time":"2016-11-11T10:18:00+00:00","content_type":"html","recipients":{"list_id":"3f262a9b48","list_name":"Project Manager - 2 - 52972000161656","segment_text":"","recipient_count":0},"settings":{"subject_line":"Need Talend Test Engineer in Chennai, GU for Contract","title":"","from_name":"PreludeSys","reply_to":"subhashini_r@preludesys.com","use_conversation":false,"to_name":"","folder_id":"","authenticate":true,"auto_footer":false,"inline_css":true,"auto_tweet":false,"fb_comments":true,"timewarp":false,"template_id":0,"drag_and_drop":false},"tracking":{"opens":true,"html_clicks":true,"text_clicks":false,"goal_tracking":false,"ecomm360":false,"google_analytics":"","clicktale":"N"},"report_summary":{"opens":0,"unique_opens":0,"open_rate":0,"clicks":0,"subscriber_clicks":0,"click_rate":0,"ecommerce":{"total_orders":0,"total_spent":0,"total_revenue":0}},"delivery_status":{"enabled":false},"_links":[{"rel":"parent","href":"https://us9.api.mailchimp.com/3.0/campaigns","method":"GET","targetSchema":"https://us9.api.mailchimp.com/schema/3.0/Campaigns/Collection.json","schema":"https://us9.api.mailchimp.com/schema/3.0/CollectionLinks/Campaigns.json"},{"rel":"self","href":"https://us9.api.mailchimp.com/3.0/campaigns/a964efd745","method":"GET","targetSchema":"https://us9.api.mailchimp.com/schema/3.0/Campaigns/Instance.json"},{"rel":"delete","href":"https://us9.api.mailchimp.com/3.0/campaigns/a964efd745","method":"DELETE"},{"rel":"send","href":"https://us9.api.mailchimp.com/3.0/campaigns/a964efd745/actions/send","method":"POST"},{"rel":"cancel_send","href":"https://us9.api.mailchimp.com/3.0/campaigns/a964efd745/actions/cancel-send","method":"POST"},{"rel":"feedback","href":"https://us9.api.mailchimp.com/3.0/campaigns/a964efd745/feedback","method":"GET","targetSchema":"https://us9.api.mailchimp.com/schema/3.0/Campaigns/Feedback/Collection.json"},{"rel":"content","href":"https://us9.api.mailchimp.com/3.0/campaigns/a964efd745/content","method":"GET","targetSchema":"https://us9.api.mailchimp.com/schema/3.0/Campaigns/Content/Collection.json"},{"rel":"send_checklist","href":"https://us9.api.mailchimp.com/3.0/campaigns/a964efd745/send-checklist","method":"GET","targetSchema":"https://us9.api.mailchimp.com/schema/3.0/Campaigns/Checklist/Collection.json"},{"rel":"pause","href":"https://us9.api.mailchimp.com/3.0/campaigns/a964efd745/actions/pause","method":"POST"},{"rel":"resume","href":"https://us9.api.mailchimp.com/3.0/campaigns/a964efd745/actions/resume","method":"POST"},{"rel":"replicate","href":"https://us9.api.mailchimp.com/3.0/campaigns/a964efd745/actions/replicate","method":"POST"}]},{"id":"78390833cd","type":"regular","create_time":"2016-11-11T12:01:21+00:00","archive_url":"http://eepurl.com/cohl9j","long_archive_url":"http://us9.campaign-archive1.com/?u=62148532aa27d5325dd4326f4&id=78390833cd","status":"sent","emails_sent":2,"send_time":"2016-11-11T12:19:00+00:00","content_type":"html","recipients":{"list_id":"6ba03c8513","list_name":"MailChimpRequirement","segment_text":"","recipient_count":2},"settings":{"subject_line":"Need MailChimpRequirement in chennai, AK for Contract","title":"","from_name":"PreludeSys","reply_to":"indumathi_v@preludesys.com","use_conversation":false,"to_name":"","folder_id":"","authenticate":true,"auto_footer":false,"inline_css":true,"auto_tweet":false,"fb_comments":true,"timewarp":false,"template_id":0,"drag_and_drop":false},"tracking":{"opens":true,"html_clicks":true,"text_clicks":false,"goal_tracking":false,"ecomm360":false,"google_analytics":"","clicktale":"N"},"report_summary":{"opens":0,"unique_opens":0,"open_rate":0,"clicks":0,"subscriber_clicks":0,"click_rate":0,"ecommerce":{"total_orders":0,"total_spent":0,"total_revenue":0}},"delivery_status":{"enabled":false},"_links":[{"rel":"parent","href":"https://us9.api.mailchimp.com/3.0/campaigns","method":"GET","targetSchema":"https://us9.api.mailchimp.com/schema/3.0/Campaigns/Collection.json","schema":"https://us9.api.mailchimp.com/schema/3.0/CollectionLinks/Campaigns.json"},{"rel":"self","href":"https://us9.api.mailchimp.com/3.0/campaigns/78390833cd","method":"GET","targetSchema":"https://us9.api.mailchimp.com/schema/3.0/Campaigns/Instance.json"},{"rel":"delete","href":"https://us9.api.mailchimp.com/3.0/campaigns/78390833cd","method":"DELETE"},{"rel":"send","href":"https://us9.api.mailchimp.com/3.0/campaigns/78390833cd/actions/send","method":"POST"},{"rel":"cancel_send","href":"https://us9.api.mailchimp.com/3.0/campaigns/78390833cd/actions/cancel-send","method":"POST"},{"rel":"feedback","href":"https://us9.api.mailchimp.com/3.0/campaigns/78390833cd/feedback","method":"GET","targetSchema":"https://us9.api.mailchimp.com/schema/3.0/Campaigns/Feedback/Collection.json"},{"rel":"content","href":"https://us9.api.mailchimp.com/3.0/campaigns/78390833cd/content","method":"GET","targetSchema":"https://us9.api.mailchimp.com/schema/3.0/Campaigns/Content/Collection.json"},{"rel":"send_checklist","href":"https://us9.api.mailchimp.com/3.0/campaigns/78390833cd/send-checklist","method":"GET","targetSchema":"https://us9.api.mailchimp.com/schema/3.0/Campaigns/Checklist/Collection.json"},{"rel":"pause","href":"https://us9.api.mailchimp.com/3.0/campaigns/78390833cd/actions/pause","method":"POST"},{"rel":"resume","href":"https://us9.api.mailchimp.com/3.0/campaigns/78390833cd/actions/resume","method":"POST"},{"rel":"replicate","href":"https://us9.api.mailchimp.com/3.0/campaigns/78390833cd/actions/replicate","method":"POST"}]},{"id":"67ce097c13","type":"regular","create_time":"2016-11-11T14:21:45+00:00","archive_url":"http://eepurl.com/coiJLT","long_archive_url":"http://us9.campaign-archive2.com/?u=62148532aa27d5325dd4326f4&id=67ce097c13","status":"sent","emails_sent":8,"send_time":"2016-11-11T14:41:06+00:00","content_type":"html","recipients":{"list_id":"99b65346a1","list_name":"Salesforce","segment_text":"","recipient_count":8},"settings":{"subject_line":"Need Salesforce in banglore, AK for ContractToHire","title":"","from_name":"PreludeSys","reply_to":"indumathi_v@preludesys.com","use_conversation":false,"to_name":"","folder_id":"","authenticate":true,"auto_footer":false,"inline_css":true,"auto_tweet":false,"fb_comments":true,"timewarp":false,"template_id":0,"drag_and_drop":false},"tracking":{"opens":true,"html_clicks":true,"text_clicks":false,"goal_tracking":false,"ecomm360":false,"google_analytics":"","clicktale":"N"},"report_summary":{"opens":0,"unique_opens":0,"open_rate":0,"clicks":0,"subscriber_clicks":0,"click_rate":0,"ecommerce":{"total_orders":0,"total_spent":0,"total_revenue":0}},"delivery_status":{"enabled":false},"_links":[{"rel":"parent","href":"https://us9.api.mailchimp.com/3.0/campaigns","method":"GET","targetSchema":"https://us9.api.mailchimp.com/schema/3.0/Campaigns/Collection.json","schema":"https://us9.api.mailchimp.com/schema/3.0/CollectionLinks/Campaigns.json"},{"rel":"self","href":"https://us9.api.mailchimp.com/3.0/campaigns/67ce097c13","method":"GET","targetSchema":"https://us9.api.mailchimp.com/schema/3.0/Campaigns/Instance.json"},{"rel":"delete","href":"https://us9.api.mailchimp.com/3.0/campaigns/67ce097c13","method":"DELETE"},{"rel":"send","href":"https://us9.api.mailchimp.com/3.0/campaigns/67ce097c13/actions/send","method":"POST"},{"rel":"cancel_send","href":"https://us9.api.mailchimp.com/3.0/campaigns/67ce097c13/actions/cancel-send","method":"POST"},{"rel":"feedback","href":"https://us9.api.mailchimp.com/3.0/campaigns/67ce097c13/feedback","method":"GET","targetSchema":"https://us9.api.mailchimp.com/schema/3.0/Campaigns/Feedback/Collection.json"},{"rel":"content","href":"https://us9.api.mailchimp.com/3.0/campaigns/67ce097c13/content","method":"GET","targetSchema":"https://us9.api.mailchimp.com/schema/3.0/Campaigns/Content/Collection.json"},{"rel":"send_checklist","href":"https://us9.api.mailchimp.com/3.0/campaigns/67ce097c13/send-checklist","method":"GET","targetSchema":"https://us9.api.mailchimp.com/schema/3.0/Campaigns/Checklist/Collection.json"},{"rel":"pause","href":"https://us9.api.mailchimp.com/3.0/campaigns/67ce097c13/actions/pause","method":"POST"},{"rel":"resume","href":"https://us9.api.mailchimp.com/3.0/campaigns/67ce097c13/actions/resume","method":"POST"},{"rel":"replicate","href":"https://us9.api.mailchimp.com/3.0/campaigns/67ce097c13/actions/replicate","method":"POST"}]},{"id":"4c43775ab9","type":"regular","create_time":"2016-11-14T05:03:23+00:00","archive_url":"http://eepurl.com/cow3kz","long_archive_url":"http://us9.campaign-archive1.com/?u=62148532aa27d5325dd4326f4&id=4c43775ab9","status":"sent","emails_sent":2,"send_time":"2016-11-14T05:04:34+00:00","content_type":"html","recipients":{"list_id":"8f9d01dd8e","list_name":"SeniorArchitect","segment_text":"","recipient_count":2},"settings":{"subject_line":"Need SeniorArchitect in Chennai, AR for ContractToHire","title":"","from_name":"PreludeSys","reply_to":"subhashini_r@preludesys.com","use_conversation":false,"to_name":"","folder_id":"","authenticate":true,"auto_footer":false,"inline_css":true,"auto_tweet":false,"fb_comments":true,"timewarp":false,"template_id":0,"drag_and_drop":false},"tracking":{"opens":true,"html_clicks":true,"text_clicks":false,"goal_tracking":false,"ecomm360":false,"google_analytics":"","clicktale":"N"},"report_summary":{"opens":0,"unique_opens":0,"open_rate":0,"clicks":0,"subscriber_clicks":0,"click_rate":0,"ecommerce":{"total_orders":0,"total_spent":0,"total_revenue":0}},"delivery_status":{"enabled":false},"_links":[{"rel":"parent","href":"https://us9.api.mailchimp.com/3.0/campaigns","method":"GET","targetSchema":"https://us9.api.mailchimp.com/schema/3.0/Campaigns/Collection.json","schema":"https://us9.api.mailchimp.com/schema/3.0/CollectionLinks/Campaigns.json"},{"rel":"self","href":"https://us9.api.mailchimp.com/3.0/campaigns/4c43775ab9","method":"GET","targetSchema":"https://us9.api.mailchimp.com/schema/3.0/Campaigns/Instance.json"},{"rel":"delete","href":"https://us9.api.mailchimp.com/3.0/campaigns/4c43775ab9","method":"DELETE"},{"rel":"send","href":"https://us9.api.mailchimp.com/3.0/campaigns/4c43775ab9/actions/send","method":"POST"},{"rel":"cancel_send","href":"https://us9.api.mailchimp.com/3.0/campaigns/4c43775ab9/actions/cancel-send","method":"POST"},{"rel":"feedback","href":"https://us9.api.mailchimp.com/3.0/campaigns/4c43775ab9/feedback","method":"GET","targetSchema":"https://us9.api.mailchimp.com/schema/3.0/Campaigns/Feedback/Collection.json"},{"rel":"content","href":"https://us9.api.mailchimp.com/3.0/campaigns/4c43775ab9/content","method":"GET","targetSchema":"https://us9.api.mailchimp.com/schema/3.0/Campaigns/Content/Collection.json"},{"rel":"send_checklist","href":"https://us9.api.mailchimp.com/3.0/campaigns/4c43775ab9/send-checklist","method":"GET","targetSchema":"https://us9.api.mailchimp.com/schema/3.0/Campaigns/Checklist/Collection.json"},{"rel":"pause","href":"https://us9.api.mailchimp.com/3.0/campaigns/4c43775ab9/actions/pause","method":"POST"},{"rel":"resume","href":"https://us9.api.mailchimp.com/3.0/campaigns/4c43775ab9/actions/resume","method":"POST"},{"rel":"replicate","href":"https://us9.api.mailchimp.com/3.0/campaigns/4c43775ab9/actions/replicate","method":"POST"}]}],"total_items":10,"_links":[{"rel":"parent","href":"https://us9.api.mailchimp.com/3.0/","method":"GET","targetSchema":"https://us9.api.mailchimp.com/schema/3.0/Root.json"},{"rel":"self","href":"https://us9.api.mailchimp.com/3.0/campaigns","method":"GET","targetSchema":"https://us9.api.mailchimp.com/schema/3.0/Campaigns/Collection.json","schema":"https://us9.api.mailchimp.com/schema/3.0/CollectionLinks/Campaigns.json"},{"rel":"create","href":"https://us9.api.mailchimp.com/3.0/campaigns","method":"POST","schema":"https://us9.api.mailchimp.com/schema/3.0/Campaigns/Instance.json"}]}';
            Set<string> strMCListId= new Set<string>();
            strMCListId.add('d91be5086a');
            deleteCampaignList(MCDtls,strMCListId);
        }
        if(res.getStatusCode() == 200)
        {  
            Map<String, Object> mapRespJSON = (Map<String, Object>)JSON.deserializeUntyped(strResponseBody);
             List<Object> lstObj = new List<Object>();
            lstObj = (List<Object>)mapRespJSON.get('campaigns');
                
            Map<String, Object> mapCmpgnsFlag = new Map<String, Object>();
            Map<String, Object> mapRecipients = new Map<String, Object>();
            Map<String, Object> mapSettings = new Map<String, Object>();
            
            if(lstObj.size() >0)
            {
                Set<string> setMCListId = new Set<string>();
                integer i=0;
                for(Object o: lstObj)
                {
                     String campaignSubject;
                     mapCmpgnsFlag = (Map<String, Object>)o;
                     Object objRecipients =  (Object)mapCmpgnsFlag.get('recipients');
                     mapRecipients =(Map<String, Object>)objRecipients;
                     
                     if(mapCmpgnsFlag.containsKey('settings'))
                     {
                        Object objSettings =  (Object)mapCmpgnsFlag.get('settings');
                        mapSettings =(Map<String, Object>)objSettings;
                     }
                     if(mapSettings.containsKey('subject_line'))
                         campaignSubject = (string)mapSettings.get('subject_line');
                        
                     String listName = 'Need'+' '+(string)mapRecipients.get('list_name');
                     System.debug('Filter listName ============'+listName ); 
                     
                     object  objCreatedTime =(object)mapCmpgnsFlag.get('create_time');
                     string campaignCreatedDate=(string)objCreatedTime;
                     
                     System.debug('objCreatedTime ============'+objCreatedTime ); 
                      
                     if((campaignSubject.contains(listName))&&(campaignCreatedDate<string.valueOf(dateTodelList)))
                     {
                         System.debug('campaignSubject containsNeed----------'+campaignSubject);  
                         String ListId = (string)mapRecipients.get('list_id');
                         setMCListId.add(ListId);
                         i++;
                         System.debug('count------11----------'+i); 
                     }
                         
                 }   
                  deleteCampaignList(MCDtls,setMCListId);  
            }  
            
        } 
      }
      catch(System.CalloutException ex)
      {
        System.debug('## Exception in getMCCmpngLstCount ##'+ex);
        
      } 
    }
    
    
    
    ///OBJECTIVE
    ///Method to delete MC list 
    ///OBJECTIVE
    private static void deleteCampaignList(Mailchimp_Details__c objMailChimpDtls,Set<String> setMcListIds)
    {
       try
        {  
            system.debug('List Id to Delete:========='+setMcListIds);
            for(string listId:setMcListIds)
            { 
                HttpResponse res;
                Http h = new Http();        
                HttpRequest req = new HttpRequest(); 
                req.setMethod('DELETE');
                req.setHeader('Authorization', 'apikey '+objMailChimpDtls.API_Key__c);
                req.setEndpoint('https://'+objMailChimpDtls.Domain_Name__c+'.api.mailchimp.com/3.0/lists/'+listId);
                req.setTimeout(120000);             
                if(!Test.isRunningTest())
                {         
                    res = h.send(req);
                    system.debug('delete response:=========='+res.getBody());
                }
            }
        
           
        }
        catch(System.CalloutException ex)
        {
            System.debug('Exception in deleteCampaignList========'+ex.getMessage());
        }
    }
    ///OBJECTIVE
    ///Method to delay the Mailchimp campaign send functionality
    ///OBJECTIVE
    private static void sleep(Long milliSeconds)
    {
            Long timeDiff = 0;
            DateTime firstTime = System.now();
            do
            {
                timeDiff = System.now().getTime() - firstTime.getTime();
                
            }
            while(timeDiff <= milliSeconds);
    }
    
*/
}