/*
 * @author           Indumathi
 * @version          1.0 
 * @date             1/19/2015
 * @description      Send emails to R/LR whenever the campaign is opened by the candidate
 */   
 

global class EZRE_MCEmailToAssignmentOwner
{
    
   /* public static Mailchimp_Details__c MCDtls{get;set;} 
    public static Map<String, String> mapCmpgnIdNme{get;set;} 
    public static Map<String,String> mapCmpgnIdFrmEml{get;set;}    
    public static Set<String> setCmpgnId{get;set;}
    public static Set<String> setEmlAddrss{get;set;}  
    public static Map<String, string> mapCndteName {get;set;}
    public static Map<String, string> mapCndteId {get; set;}
    public static List<Candidate__c> lstCan {get;set;}
    public static list<candidate__c> lstcand {get; set;}    
    public static Map<String, Object> mapSttngsFlag = new Map<String, Object>();
    public static Map<String, Set<String>> mapOpenLst = new Map<String, Set<String>>();    
    public static Map<String, Set<String>> mapUnOpenLst = new Map<String, Set<String>>();
    public static Set<String> openEmailAddr {get; set;}
    public static Set<String> bounceEmailAddr {get; set;}
    public static Set<String> unopendEmailAddr {get; set;}
    public static List<MCCandidateList__c> lstToUpdate{get;set;}
    public static List<MCCandidateList__c> lstCndtToSendEmail = new List<MCCandidateList__c>();

    ///OBJECTIVE
    ///Fetch the list of candidates and their mail ids by using SOSL query based on the requirement name
    ///OBJECTIVE
    @future (callout=true) 
    public static void sendMailToAssgnmntOwnr()
    {       
       
        getMCCmpngLst();        
        updateUnsubCand();
        updateBouncedCand();            
    }
    
    ///OBJECTIVE
    ///MEthod to fetch the number of campaign created in Mailchimp for past 5 days
    ///OBJECTIVE
    public static integer getMCCmpngLstCount()
    {
        Integer count = 0;
        try
        {
            DateTime d = DateTime.Now().addDays(-5);       
            String s = string.valueOf(d);
            MCDtls = new Mailchimp_Details__c();
            MCDtls = EZRE_Data_Utility.getMCDtls('MCAccount');       
            Http h = new Http();        
            HttpRequest reqst = new HttpRequest();      
            reqst.setMethod('GET'); 
            reqst.setHeader('Authorization', 'apikey '+MCDtls.API_Key__c);
            reqst.setEndpoint('https://'+MCDtls.Domain_Name__c+'.api.mailchimp.com/3.0/campaigns?status=sent&list_id='+MCDtls.List_Id__c+'&since_send_time='+s);
            reqst.setTimeout(120000);

            HttpResponse res = new HttpResponse();
            string strResponseBody;
            if(!Test.isRunningTest())
            {           
                res = h.send(reqst); 
                strResponseBody = res.getBody();
                Map<String, Object> mapRespJSON = (Map<String, Object>)JSON.deserializeUntyped(res.getBody());
                count = Integer.valueOf(mapRespJSON.get('total_items'));            
            } 
            else
            {
                strResponseBody = '{"total":1,"data":[{"id":"f272fef804","content_type":"html","status":"sent","from_email":"test@test.com","title":"Need salesforce"}],"errors":[]}';  
            } 

            return count;
        }
        catch(System.CalloutException ex)
        {
            System.debug('##Exception in getMCCmpngLstCount## '+ex.getMessage());
            return count;
        } 
    }
    
    ///OBJECTIVE
    ///Method to fetch the list of campaign created in Mailchimp for past 5 days
    ///OBJECTIVE
    public static void getMCCmpngLst()
    {
        try
        {
            DateTime d = DateTime.Now().addDays(-5);       
            String s = string.valueOf(d);
            Integer iCampgnCount = getMCCmpngLstCount();
            MCDtls = new Mailchimp_Details__c();
            MCDtls = EZRE_Data_Utility.getMCDtls('MCAccount');       
            Http h = new Http();        
            HttpRequest reqst = new HttpRequest();      
            reqst.setMethod('GET'); 
            reqst.setHeader('Authorization', 'apikey '+MCDtls.API_Key__c); 
            reqst.setEndpoint('https://'+MCDtls.Domain_Name__c+'.api.mailchimp.com/3.0/campaigns?status=sent&type=regular&count='+iCampgnCount+'&list_id='+MCDtls.List_Id__c+'&since_send_time='+s);
            reqst.setTimeout(120000);

            HttpResponse res = new HttpResponse();
            string strResponseBody;
            if(!Test.isRunningTest())
            {           
                res = h.send(reqst); 
                strResponseBody = res.getBody();
                
            } 
            else
            {
                strResponseBody = '{"campaigns": [{ "id": "234ded12ee", "create_time": "2016-07-15T05:51:36+00:00", "status": "sent", "emails_sent": 1, "send_time": "2016-07-15T05:51:38+00:00", "content_type": "html", "recipients": { "list_id": "9f852d08f6", "list_name": "ListforTesting" }, "settings": { "subject_line": "Need SFDCTester in Chennai, AL for Contract", "title": "sales", "from_name": "PreludeSys", "reply_to": "kalaiselvi_r@preludesys.com" }, "tracking": { "opens": true }, "_links": [{ "rel": "parent", "href": "https://us9.api.mailchimp.com/3.0/campaigns", "method": "GET" }] }] }';
                
            }                              

            mapCmpgnIdNme = new Map<String, String>();
            mapCmpgnIdFrmEml = new Map<String,String>();
            setCmpgnId = new Set<String>();

            Map<String, Object> mapRespJSON = (Map<String, Object>)JSON.deserializeUntyped(strResponseBody);
            List<Object> lstObj = new List<Object>();
            lstObj = (List<Object>)mapRespJSON.get('campaigns');

            Map<String, Object> mapCmpgnsFlag = new Map<String, Object>();
            Map<String, Object> mapSttngsFlag1 = new Map<String, Object>();
            if(lstObj.size() >0)
            {
                for(Object o: lstObj)
                {
                    mapCmpgnsFlag = (Map<String, Object>)o;
                    Object obj =  (Object)mapCmpgnsFlag.get('settings');
                    mapSttngsFlag1 = (Map<String, Object>)obj;
                    mapCmpgnIdNme.put(string.valueOf(mapCmpgnsFlag.get('id')),string.valueOf(mapSttngsFlag1.get('subject_line')));
                    setCmpgnId.add(string.valueOf(mapCmpgnsFlag.get('id')));  
                    mapCmpgnIdFrmEml.put(string.valueOf(mapCmpgnsFlag.get('id')),string.valueOf(mapSttngsFlag1.get('reply_to')));  
                }   
            }
            
            
            bounceEmailAddr = new Set<String>();
            //openEmailAddr = new Set<String>();
            unopendEmailAddr = new Set<String>();
            if(setCmpgnId.size()>0)  
            {
                getEmailActivity(setCmpgnId);
            }
                             
        }
        catch(System.CalloutException ex)
        {
            System.debug('## Excepion in getMCCmpngLst ##'+ex.getMessage());
        }  
    }
    
    ///OBJECTIVE
    ///Method to upsert MC Candidate List 
    ///OBJECTIVE
    public static void upsrtMCCndtLst(Map<String, Set<String>> mapCndtCmpgn)
    {
        Set<String> setAllEmlAddrss;
        Set<String> setExstngEmlAddrss;
        List<MCCandidateList__c> lstTotalCandidates = new List<MCCandidateList__c>();
        //List<MCCandidateList__c> lstToUpdate; 
        List<MCCandidateList__c> lstToUpsert = new List<MCCandidateList__c>();
        
        lstTotalCandidates = [Select Id, Campaign_Id__c, Candidate_Email__c, IsNew__c from MCCandidateList__c ];
        Map<String, MCCandidateList__c> mapCmpgnCndte = new Map<String, MCCandidateList__c>();
        if(lstTotalCandidates.size() >0)
        {
            for(MCCandidateList__c objMCCndt : lstTotalCandidates)
            { 
                String key = objMCCndt.Campaign_Id__c + objMCCndt.Candidate_Email__c;        
                mapCmpgnCndte.put(key, objMCCndt);
            }
        }

        mapCndteName = new Map<String,String>();
        mapCndteId = new Map<String,String>();
        lstCan = new List<Candidate__c>();
        for(String str : mapCndtCmpgn.KeySet())
        {
            lstToUpdate = new List<MCCandidateList__c>();
            setAllEmlAddrss = new Set<String>();
            setExstngEmlAddrss = new Set<String>();
            set<String> setEml = new set<String>();
            if(mapCndtCmpgn.get(str) != null )
            {
                for(String sEmail : mapCndtCmpgn.get(str))
                {
                    setEml.add(sEmail);
                }
            }
            
            for(String sEmil : setEml)
            {
                String sKey = str+sEmil;
                if(mapCmpgnCndte.get(skey) != null)
                {
                    lstToUpdate.add(mapCmpgnCndte.get(skey));
                }
                
            }
            //lstToUpdate = mapCmpgnCndte.get(skey);
            
            //[Select Id, Campaign_Id__c, Candidate_Email__c, IsNew__c from MCCandidateList__c 
                                    //where (Campaign_Id__c = : str) AND (Candidate_Email__c IN : mapCndtCmpgn.get(str))];
            setAllEmlAddrss = mapCndtCmpgn.get(str);
            try
            {
                lstCan =[SELECT id, name, Email__c FROM Candidate__c WHERE Email__c IN: setAllEmlAddrss];
            }
            catch(Exception ex)
            {
                System.debug('excetion 1111111111111111'+ex.getMessage());
            }
                        
            if(lstCan.size() >0 && !lstCan.isEmpty())
            {
                for(Candidate__c objCnd : lstCan)
                {
                    mapCndteName.put(objCnd.Email__c, objCnd.Name);
                    mapCndteId.put(objCnd.Email__c, objCnd.Id);
                }
            }
            
            if(lstToUpdate != null) // && !lstToUpdate.isEmpty())
            {
                for(MCCandidateList__c objCndt : lstToUpdate )
                {
                    setExstngEmlAddrss.add(objCndt.Candidate_Email__c);              
                }
            }
            
            if(setExstngEmlAddrss.size() > 0 && !setExstngEmlAddrss.isEmpty())
            {
                setAllEmlAddrss.removeAll(setExstngEmlAddrss);
            }
            
            for(String strNwEmlAddrss : setAllEmlAddrss)
            {           
                MCCandidateList__c objToInsrt= new MCCandidateList__c();
                objToInsrt.Campaign_Id__c = str;
                objToInsrt.Campaign_Name__c = mapCmpgnIdNme.get(str);
                objToInsrt.From_Email__c = mapCmpgnIdFrmEml.get(str);
                objToInsrt.Candidate_Email__c = strNwEmlAddrss;
                lstToUpsert.add(objToInsrt);
            }
            if(lstToUpdate.size() >0 && !lstToUpdate.isEmpty())
            {
                for(MCCandidateList__c obj: lstToUpdate)
                {
                    MCCandidateList__c updtCndt = new MCCandidateList__c(Id = obj.Id);
                    updtCndt.IsNew__c = False;
                    lstToUpsert.add(updtCndt);
                } 
            }            
        }
        try  
        {
            upsert lstToUpsert;
        }
        catch(Exception Ex)
        {
              System.debug('Exception in Error in upsrtMCCndtLst ' +Ex.getMessage());     
        }
    }
    
    ///OBJECTIVE
    ///Method to create Email content
    ///OBJECTIVE
    @TestVisible
    private static string createEmailBody(List<MCCandidateList__c> lstCmpgnMails)
    {
        string strHtmlBody = '';  
        String  strHtmlBody1 = '';      
        Map<string, List<MCCandidateList__c>> mapCmpgnIdEmail = new Map<string, List<MCCandidateList__c>>();
        
        for(MCCandidateList__c objMCCmpgns: lstCmpgnMails)
        {           
            if(mapCmpgnIdEmail.containsKey(objMCCmpgns.Campaign_Id__c))
            {
                mapCmpgnIdEmail.get(objMCCmpgns.Campaign_Id__c).add(objMCCmpgns);
            }
            else
            {
                mapCmpgnIdEmail.put(objMCCmpgns.Campaign_Id__c,new List<MCCandidateList__c>{objMCCmpgns});
            }
        }

        for(string strCmpgnId: mapCmpgnIdEmail.keyset())
        {
            strHtmlBody1  = +'<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">'
                       +'<html> <head> <style type="text/CSS"> table,td {word-break:break-all;word-wrap:break-word-all; -ms-word-wrap: break-word;!important}'
                       + '</style></head><body>'
                       +'<table style="width: 500px;table-layout: fixed;word-wrap: break-word;border: 1px solid black; font-family: Calibri;" bgcolor="#7FFFD4" cellspacing="0" table.print-friendly tr td, table.print-friendly tr th {page-break-inside: avoid/>'
                       +'<tr cellspacing="0">'
                       +'<td style="width: 200px;border: 1px solid black" bgcolor="1E90FF" cellspacing="0" colspan = "1" align = "center" colspan="3">'
                       + mapCmpgnIdEmail.get(strCmpgnId)[0].Campaign_Name__c+'</td></tr>'+         
                      '<tr cellspacing="0">';
               
            for(MCCandidateList__c strCndEml : mapCmpgnIdEmail.get(strCmpgnId))
            {
              strHtmlBody1 += '<td  style="border: 1px solid black" cellspacing="0">' + strCndEml.Candidate_Email__c + '</td>' ;
              if(mapCndteName.get(strCndEml.Candidate_Email__c) != null)
              {
                 strHtmlBody1 += '<td  style="border: 1px solid black" cellspacing="0">' + mapCndteName.get(strCndEml.Candidate_Email__c) + '</td>' ;
              }
              else{
                  strHtmlBody1 += '<td style="border: 1px solid black" cellspacing="0">' + ' ' + '</td>' ;
              }
              if(mapCndteId.get(strCndEml.Candidate_Email__c) != null)
              {
                 strHtmlBody1 += '<td  style="border: 1px solid black" cellspacing="0">' +  '<a href=' + System.Label.MC_Candidate_Id + '/' + mapCndteId.get(strCndEml.Candidate_Email__c)  + '>' +mapCndteId.get(strCndEml.Candidate_Email__c) + '</a></td>' ;
              }
              else{
                  strHtmlBody1 += '<td style="border: 1px solid black" cellspacing="0">' + ' ' + '</td>' ;
              }
              
              strHtmlBody1 +=  '</tr>' ;
            }
            
               strHtmlBody1 += '</table>'+
               '</body></html>'; 
               strHtmlBody += strHtmlBody1;
        } 
        return strHtmlBody;
    }
    
    ///OBJECTIVE
    ///Method to send Email
    ///OBJECTIVE
    @TestVisible
    private static void sendEmail(Map<String, Set<String>> mapCmpgnIdSet)
    {
       
        System.debug('mapCmpgnIdSet------------------'+mapCmpgnIdSet);
        //List<MCCandidateList__c> lstCndtToSendEmail = new List<MCCandidateList__c>();
        string strCCEmail;
        Map<string, List<MCCandidateList__c>> mapLstMCCandt = new Map<string, List<MCCandidateList__c>>();
        Map<string, string> mapUserNameMail = new Map<string, string>();
        List<User> lstUserName = new List<User>();
        try
        {
        lstCndtToSendEmail = [Select Id, Campaign_Id__c,Campaign_Name__c, From_Email__c,Candidate_Email__c, IsNew__c from MCCandidateList__c 
                       where (Campaign_Id__c IN : mapCmpgnIdSet.KeySet()) AND (IsNew__c = True) AND (MC_List_Type__c != 'Marketing') AND (Campaign_Name__c like 'Need %')];
        
        }
        catch(Exception ex )
        {
            System.debug('ex111111111111111'+ex.getMessage());
        }
        System.debug('lstCndtToSendEmail ------------------'+lstCndtToSendEmail );
        
        if(!lstCndtToSendEmail.isEmpty())
        {
             for(MCCandidateList__c objMCCandt : lstCndtToSendEmail)
            {
                if(mapLstMCCandt.containsKey(objMCCandt.From_Email__c))
                {
                    mapLstMCCandt.get(objMCCandt.From_Email__c).add(objMCCandt);
                }
                else
                {
                    mapLstMCCandt.put(objMCCandt.From_Email__c,new List<MCCandidateList__c>{objMCCandt});
                }
            }
            
             for(User objUser: [Select id, Name, Email from User where Email IN : mapLstMCCandt.keyset()])
            {
                mapUserNameMail.put(objUser.Email, objUser.Name);
            }
            
            for(string strFromEmail: mapLstMCCandt.keyset())
            {
                strCCEmail = label.EZRE_EmaiAddress;
                List<String> lstCCEmail = strCCEmail.split(',');
                Messaging.SingleEmailMessage objMessage = new Messaging.SingleEmailMessage();
                string strMailBody = createEmailBody(mapLstMCCandt.get(strFromEmail));
                objMessage.setToAddresses(new String[] {strFromEmail});
                objMessage.setCCAddresses(lstCCEmail);   
                objMessage.setSubject('Email Blast: Candidates List');
                string strHtmlBody = '<font face="Calibri">' + 'Dear '+ mapUserNameMail.get(strFromEmail) +'<br/>' 
                        + 'Please find below the details of those candidates who has opened the emails from Email Blast:, ' 
                        + '<br/>' + '<br/>' + strMailBody + '</font>';

                objMessage.setHtmlBody(strHtmlBody);
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { objMessage });
            }
                
        }
      
        
       
    }
    
    ///OBJECTIVE
    ///Method to update unsubscribed candidates
    ///OBJECTIVE
    public static void updateUnsubCand()
    {
     list<candidate__c> upcandUnsub = new list<candidate__c>();
     lstcand = new list<candidate__c>();
     lstcand = EZRE_Data_Utility.fetchLstcan(setEmlAddrss);
       if(lstcand.size()>0)
       {
           for(candidate__c Finalcandlist :lstcand)
           {
               Finalcandlist.email_status__c = 'Unsubscribed';
               upcandUnsub.add(Finalcandlist);
           }
           try
           {
                update upcandUnsub;
           }
           catch(Exception Ex)
           {
              EZRE_EmailLog.sendExceptionEmail('Error in EZRE_MCEmailToAssignmentOwner', 'Error in updateUnsubCand\n ' +Ex.getMessage());     
           }                   
       }
    }
    
    ///OBJECTIVE
    ///Method to update bounced email address in candidates
    ///OBJECTIVE
    public static void updateBouncedCand()
    {
        
        list<candidate__c> upcandBounced = new list<candidate__c>();
        lstcand = new list<candidate__c>();
        lstcand = EZRE_Data_Utility.fetchLstcan(bounceEmailAddr);
        
        if(lstcand.size()>0)
        {
           for(candidate__c finalcandlist :lstcand)
           {
               finalcandlist.email_status__c = 'Bounced';
               upcandBounced.add(finalcandlist);
           }
           try
           {
               update upcandBounced;
           }
           catch(Exception Ex)
           {
                  EZRE_EmailLog.sendExceptionEmail('Error in EZRE_MCEmailToAssignmentOwner', 'Error in updateBouncedCand\n ' +Ex.getMessage());     
           }
        }
    }  

    ///OBJECTIVE
    ///Method to get Campaign Activity in Mailchimp 
    ///OBJECTIVE
    public static void getEmailActivity(Set<String> setMCCmpgnId)
    {
        try
        {
            for(String strCmpId: setMCCmpgnId )
            {  
                MCDtls = new Mailchimp_Details__c();
                MCDtls = EZRE_Data_Utility.getMCDtls('MCAccount');       
                Http h = new Http();        
                HttpRequest reqst = new HttpRequest();  
                reqst.setMethod('GET');
                reqst.setHeader('Authorization', 'apikey '+MCDtls.API_Key__c);               
                reqst.setEndpoint('https://'+MCDtls.Domain_Name__c+'.api.mailchimp.com/3.0/reports/'+strCmpId+'/email-activity');
                reqst.setTimeout(120000);

                HttpResponse res = new HttpResponse();
                string strResponseBody;
                if(!Test.isRunningTest())
                {       
                res = h.send(reqst);   
                strResponseBody = res.getBody();     
                system.debug(':: Response for getting  campaign open list:: ********'+res.getbody());
                }
                else
                {
                    strResponseBody = '{"emails":[{"campaign_id":"234ded12ee","list_id":"9f852d08f6","email_id":"0c77e24ccc951af2ccd8958c0db791f6","email_address":"indumathi_v@preludesys.com","activity":[],"_links":[]}],"campaign_id":"234ded12ee","total_items":1,"_links":[]}';
                    
                } 

                Map<String, Object> result = (Map<String, Object>)JSON.deserializeUntyped(strResponseBody);
                List<Object> lstEmails = (List<Object>)result.get('emails');
                List<Object> lstActivity = new List<Object>();
                Map<String, Object> emailAttrbutes = new Map<String, Object>();
                Map<String, List<String>> mapCampEml = new Map<String, List<String>>();
                Map<String, List<String>> mapEmlActvty = new Map<String, List<String>>();
                openEmailAddr = new Set<String>();
                //bounceEmailAddr = new Set<String>();
                //unopendEmailAddr = new Set<String>();
                
                if(lstEmails.size() > 0)
                {
                    for(Object objEmail :lstEmails )
                    {
                        emailAttrbutes = (Map<String, Object>)objEmail;
                        for(String sEmail: emailAttrbutes.keySet())
                        {                
                            if(sEmail == 'activity')
                            {    
                                lstActivity.add((List<Object>)emailAttrbutes.get(sEmail));        
                                if(mapEmlActvty.containsKey(string.valueOf(emailAttrbutes.get('email_address'))))
                                {
                                    mapEmlActvty.get(string.valueOf(emailAttrbutes.get('email_address'))).add(string.valueOf(emailAttrbutes.get('activity')));
                                }
                                else
                                {
                                    mapEmlActvty.put(string.valueOf(emailAttrbutes.get('email_address')), new List<String>{string.valueOf(emailAttrbutes.get('activity'))}); 
                                }
                            } 
                        } 
                    }
                }
               

                for(String s : mapEmlActvty.keySet()) 
                {
                    
                    for( string s1 : mapEmlActvty.get(s)) 
                    {
                       
                        //if(String.isEmpty(s1) && String.isBlank(s1)) 
                        if(s1 == '()') // To check empty, blank and null
                        {
                            unopendEmailAddr.add(s);
                        }
                        else 
                        {
                            if(s1.containsIgnoreCase('open'))
                            {
                                openEmailAddr.add(s);
                            }
                            if(s1.containsIgnoreCase('bounce'))
                            {
                                bounceEmailAddr.add(s);
                            }
                        }
                    }
                }
                
            
                mapOpenLst.put(strCmpId, openEmailAddr);
                 
            }
            upsrtMCCndtLst(mapOpenLst);       
            sendEmail(mapOpenLst);  
        }
    
        catch(System.CalloutException ex)
        {
            System.debug('## Exception in getEmailActivity##'+ex.getMessage());
        }
    }
    
    ///OBJECTIVE
    ///Method to get Unsubscribed email list from Mailchimp 
    ///OBJECTIVE
    public static void getMCCandUnsubscribesList( string campId)    
    {  
        try
        {
            setEmlAddrss = new Set<String>(); 
            MCDtls = new Mailchimp_Details__c();
            MCDtls = EZRE_Data_Utility.getMCDtls('MCAccount');       
            Http h = new Http();        
            HttpRequest reqst = new HttpRequest();  
            reqst.setMethod('GET');
            reqst.setHeader('Authorization', 'apikey '+MCDtls.API_Key__c);        
            reqst.setEndpoint('https://'+MCDtls.Domain_Name__c+'.api.mailchimp.com/3.0/reports/'+campId+'/unsubscribed');
            reqst.setTimeout(120000);

            HttpResponse res = new HttpResponse();
            string strResponseBody;
            if(!Test.isRunningTest())
            {       
                res = h.send(reqst);   
                strResponseBody = res.getBody();      
            }
            else
            {
                strResponseBody = '{"unsubscribes":[{"email_id": "62eeb292278cc15f5817cb78f7790b08","email_address":"urist.mcvankab@freddiesjokes.com","timestamp": "2015-09-17 17:47:33","reason": "","campaign_id": "8d6f39ce45","list_id": "57afe96172","_links": [{"rel": "parent","href": "https://usX.api.mailchimp.com/3.0/reports/8d6f39ce45/unsubscribed","method": "GET","targetSchema": "https://api.mailchimp.com/schema/3.0/Reports/Unsubs/Collection.json"}],"campaign_id": "","_links": [], "total_items": 1}]}';
            }

            Map<String, Object> mapRespJSON = (Map<String, Object>)JSON.deserializeUntyped(strResponseBody);
            List<Object> lstObj =  (List<Object>)mapRespJSON.get('unsubscribes');
            Map<String, Object> mapFlag = new Map<String, Object>();
            for(Object o: lstObj)
            {
                mapFlag = (Map<String, Object>)o;               
                setEmlAddrss.add(string.valueOf(mapFlag.get('email_address')));                     
            }                
        }
        catch(System.CalloutException ex)
        {
            System.debug('## Exception in getMCCandUnsubscribesList##'+ex.getMessage());
        } 

    }*/
}