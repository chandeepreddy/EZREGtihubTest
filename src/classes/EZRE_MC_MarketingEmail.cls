/*
 * @author           Keerthi Chandra
 * @version          1.0 
 * @date             06/05/2015
 * @description      Send emails to the contact owners for the contacts who opened the emails.
 * @Modified by      Kalaiselvi R. To upgrade version 3.0 to Marketing campaigns
 */  
 
global class EZRE_MC_MarketingEmail
{
   /* //To hold the Mailchimp Details custom settings record. 
    public static Mailchimp_Details__c MCDtls{get;set;} 
    //To hold the Campaign Name
    public static Map<String, String> mapCmpgnIdNme{get;set;} 
    //To Hold the campaign from email.
    public static Map<String,String> mapCmpgnIdFrmEml{get;set;}
    
    //To hold the set of Mailchimp campaign Id's
    public static Set<String> setCmpgnId{get;set;}

    //To hold the contact first name.
    public static Map<String, string> mapCntctName {get;set;}
    //To hold the contact id.
    public static Map<String, string> mapCntctId {get; set;}
    //To hold the list of contacts.
    Public static List<Contact> lstCon {get;set;}
    //To hold the contact last name.
    public static Map<string,string> mapCntctLNmae {get; set;}
    //To hold the contact phone number.
    public static Map<string,string> mapCntctPhone {get; set;}
    //To hold the contact designation
    public static Map<String,String> mapCntctTitle {get; set;}
    //To hold the list of Contacts
    public static Map <String, List<Contact>> mapContact {get; set;}
    //To hold the list of Tasks
    public static Map <String, List<Task>> mapTask {get; set;}
    
    public static Set<String> openEmailAddr {get; set;}
    public static Set<String> bounceEmailAddr {get; set;}
    public static Set<String> unopendEmailAddr {get; set;}
    public static Map<String, Set<String>> mapOpenLst = new Map<String, Set<String>>();
    public static Map<String, Set<String>> mapBounceLst = new Map<String, Set<String>>();
    public static Map<String, Set<String>> mapUnOpenLst = new Map<String, Set<String>>();

    
   //To hold the single email message.
   public static Messaging.SingleEmailMessage objMessage {get; set;}
    
   @future (callout=true) 
    public static void sendMailToContactOwnr()
    {       
        getMCCmpngLst();
    }
    
    ///OBJECTIVE
    ///To get the list of Campaign count.
    ///OBJECTIVE 
    public static integer getMCCmpngLstCount()
    {
      Integer count = 0;
      try
      {
        DateTime d = DateTime.Now().addDays(-5);       
        String s = string.valueOf(d);
        MCDtls = new Mailchimp_Details__c();
        MCDtls = EZRE_Data_Utility.getMCDtls('MC Marketing');       
        Http h = new Http();        
        HttpRequest reqst = new HttpRequest();      
        reqst.setMethod('GET'); 
        reqst.setHeader('Authorization', 'apikey '+MCDtls.API_Key__c);
        reqst.setEndpoint('https://'+MCDtls.Domain_Name__c+'.api.mailchimp.com/3.0/campaigns?status=sent&since_send_time='+s);
        reqst.setTimeout(120000);
        HttpResponse res = new HttpResponse();
        string strResponseBody;
        if(!Test.isRunningTest())
        {           
            res = h.send(reqst); 
            strResponseBody = res.getBody();
            System.debug('strResponseBody ------11----------'+strResponseBody );
            if(res.getStatusCode() == 200) {  
                Map<String, Object> mapRespJSON = (Map<String, Object>)JSON.deserializeUntyped(res.getBody());
                count = Integer.valueOf(mapRespJSON.get('total_items')); 
            }
        } 
        else
        {
        res.setStatusCode(200);
        strResponseBody ='{ "campaigns": [{ "id": "cfbbc15edd", "status": "sent", "recipients": { "list_id": "d91be5086a"}, "settings": { "subject_line": "Marketing", "reply_to": "indumathi_v@preludesys.com" } }] }';
        } 
           System.debug('count------11----------'+count);
           return count;
      }
      catch(System.CalloutException ex)
      {
        System.debug('## Exception in getMCCmpngLstCount ##'+ex);
        return count;
      } 
    }
    
    ///OBJECTIVE
    ///To get the list of Campaign Id's to which campaign has been sent.
    ///OBJECTIVE 
   public static void getMCCmpngLst()
    {
      try
      {
        DateTime d = DateTime.Now().addDays(-5);       
        String s = string.valueOf(d);
        Integer iCampgnCount = getMCCmpngLstCount();
        MCDtls = new Mailchimp_Details__c();
        MCDtls = EZRE_Data_Utility.getMCDtls('MC Marketing');       
        Http h = new Http();        
        HttpRequest reqst = new HttpRequest();      
        reqst.setMethod('GET'); 
        reqst.setHeader('Authorization', 'apikey '+MCDtls.API_Key__c); 
        reqst.setEndpoint('https://'+MCDtls.Domain_Name__c+'.api.mailchimp.com/3.0/campaigns?status=sent&type=regular&count='+iCampgnCount+'&since_send_time='+s);
        reqst.setTimeout(120000);
        HttpResponse res = new HttpResponse();
        string strResponseBody;
        if(!Test.isRunningTest())
        {           
            res = h.send(reqst); 
            strResponseBody = res.getBody(); 
             System.debug('strResponseBody ------22----------'+strResponseBody );
        } 
        else
        {
        res.setStatusCode(200);
        strResponseBody ='{ "campaigns": [{ "id": "cfbbc15edd", "status": "sent", "recipients": { "list_id": "d91be5086a"}, "settings": { "subject_line": "Marketing", "reply_to": "indumathi_v@preludesys.com" } }] }';
        }                               
            
        mapCmpgnIdNme = new Map<String, String>();
        mapCmpgnIdFrmEml = new Map<String,String>();
        setCmpgnId = new Set<String>();
        
        if(res.getStatusCode() == 200) 
        {
            Map<String, Object> mapRespJSON = (Map<String, Object>)JSON.deserializeUntyped(strResponseBody);
            List<Object> lstObj = new List<Object>();
            lstObj = (List<Object>)mapRespJSON.get('campaigns');
            Map<String, Object> mapCmpgnsFlag = new Map<String, Object>();
            Map<String, Object> mapSttngsFlag1 = new Map<String, Object>();
            if(lstObj.size()>0)  
            {
                for(Object o: lstObj)
                {
                    mapCmpgnsFlag = (Map<String, Object>)o;
                    Object obj =  (Object)mapCmpgnsFlag.get('settings');
                    mapSttngsFlag1 = (Map<String, Object>)obj;
                    if(!(string.valueOf(mapSttngsFlag1.get('subject_line')).startsWithIgnoreCase('Need'))) 
                    {
                        mapCmpgnIdNme.put(string.valueOf(mapCmpgnsFlag.get('id')),string.valueOf(mapSttngsFlag1.get('subject_line')));
                        System.debug('mapCmpgnIdNme------22----------'+mapCmpgnIdNme);
                        setCmpgnId.add(string.valueOf(mapCmpgnsFlag.get('id')));  
                        mapCmpgnIdFrmEml.put(string.valueOf(mapCmpgnsFlag.get('id')),string.valueOf(mapSttngsFlag1.get('reply_to'))); 
                    }
                    
                }
            }
            if(setCmpgnId.size()>0)  
            {
                getEmailActivity(setCmpgnId);
            }
        }
      }
      catch(System.CalloutException ex)
      {
        System.debug('## Exception in getMCCmpngLst ##'+ex);
      }  
    }
    
    ///OBJECTIVE
    ///To get the activity of all the campaigns
    ///OBJECTIVE
    public static void getEmailActivity(set<string> setCampId)
    {
    try
    {   for(string campId : setCampId)
        {
        MCDtls = new Mailchimp_Details__c();
        MCDtls = EZRE_Data_Utility.getMCDtls('MC Marketing');       
        Http h = new Http();        
        HttpRequest reqst = new HttpRequest();  
        reqst.setMethod('GET');
        reqst.setHeader('Authorization', 'apikey '+MCDtls.API_Key__c);               
        reqst.setEndpoint('https://'+MCDtls.Domain_Name__c+'.api.mailchimp.com/3.0/reports/'+campId+'/email-activity');
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
        res.setStatusCode(200);
        strResponseBody = '{ "emails": [{ "campaign_id": "cfbbc15edd", "list_id": "d91be5086a", "email_address": "indumathi_v@preludesys.com", "activity": [], "_links": [{ "rel": "parent", "href": "https://us9.api.mailchimp.com/3.0/reports//email-activity", "method": "GET" }] }] }';
        } 
        if(res.getStatusCode() == 200) 
        {
            Map<String, Object> result = (Map<String, Object>)JSON.deserializeUntyped(strResponseBody);
            List<Object> lstEmails = (List<Object>)result.get('emails');
            List<Object> lstActivity = new List<Object>();
            Map<String, Object> emailAttrbutes = new Map<String, Object>();
            Map<String, List<String>> mapCampEml = new Map<String, List<String>>();
            Map<String, List<String>> mapEmlActvty = new Map<String, List<String>>();
            openEmailAddr = new Set<String>();
            bounceEmailAddr = new Set<String>();
            unopendEmailAddr = new Set<String>();
          
            if(lstEmails.size()>0)
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
                    else {
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
                mapOpenLst.put(campId, openEmailAddr);
                mapBounceLst.put(campId, bounceEmailAddr);
                mapUnOpenLst.put(campId, unopendEmailAddr);   
            }    
        }
    }
    catch(System.CalloutException ex)
    {
        System.debug('## Exception in getCampaign OpenList ##'+ex);
    }   
    createCallTask(mapOpenLst);   
    upsrtMCCndtLst(mapOpenLst);       
    sendEmail(mapOpenLst); 
}
    ///OBJECTIVE
    ///To create Call Task for the contacts who has opened the campaigns
    ///OBJECTIVE  

   public static void createCallTask(Map<String, Set<String>> mapCndtCmpgn)  {
        Set<String> setAllEmlAddrss =new Set<String>();
        for(Set<String> setEmails: mapCndtCmpgn.values())
        {
            for(String emails : setEmails){
                setAllEmlAddrss.add(emails);
            }           
        }        

        List<Contact> lstContact = new List<Contact>();
        Set<Id> setContId = new Set<Id>();
        List<Task> lstConTask = new List<Task>();
        List<Task> lstCallTask = new List<Task>();
        
        lstContact = EZRE_Data_Utility.fetchConRecords(setAllEmlAddrss);  
        if(lstContact.size()>0)
        { 
            for(Contact c : lstContact) {
                setContId.add(c.Id);
            } 
        }           
        mapContact = new Map<String, List<Contact>>();
        if(lstContact.size()>0)
        { 
            for(Contact Cont : lstContact)  {
                if(!(mapContact.ContainsKey(Cont.Email)))
                {
                    mapContact.put(Cont.Email, new List<Contact> {cont}); 
                }
                else
                {
                    mapContact.get(Cont.Email).add(Cont);                
                }           
            } 
        }
        lstCallTask = EZRE_Data_Utility.fetchTaskRcrds(setContId );  
        
        mapTask = new Map <String, List<Task>>();
        if(lstCallTask.size()>0)
        { 
            for(Task taskObj : lstCallTask)  {
                if(!(mapTask.ContainsKey(taskObj.Campaign_Id__c+'-'+taskObj.subject+taskObj.WhoId)))
                {
                    mapTask.put(taskObj.Campaign_Id__c+taskObj.WhoId, new List<Task> {taskObj});
                }
                else
                {
                    mapTask.get(taskObj.Campaign_Id__c+taskObj.WhoId).add(taskObj);                
                }           
            }
        }
        if(mapCndtCmpgn.keyset() != null ){ 
            for(String camp : mapCndtCmpgn.keyset()) {
                if(mapCndtCmpgn.containsKey(camp)) { 
                    for(string emails : mapCndtCmpgn.get(camp)) {
                        if(mapContact.containsKey(emails)){
                            for(contact objContact : mapContact.get(emails)) {
                                Task conTask = new Task(WhoId = objContact.id);
                                if(!mapTask.ContainsKey(camp+'-Call'+objContact.id)) {
                                    conTask.subject = 'Call';
                                    conTask.Campaign_Id__c = camp+'-'+conTask.subject;
                                    conTask.Priority  = 'high';
                                    conTask.description = mapCmpgnIdNme.get(camp)+' - The contact has opened the email';
                                    conTask.ActivityDate = system.today();
                                    lstConTask.add(conTask);
                                }        
                            }
                        }
                    }
                }
            }
        }
        EZRE_RecursionCheck.isFutureUpdate = true;
        insert lstConTask;
    }
 
    ///OBJECTIVE
    ///Upsert the campaign and email details in the salesforce custom object.
    ///OBJECTIVE
    public static void upsrtMCCndtLst(Map<String, Set<String>> mapCndtCmpgn)
    {
        Set<String> setAllEmlAddrss;
        Set<String> setExstngEmlAddrss;
        List<MC_Marketing__c> lstToUpdate = new List<MC_Marketing__c>();
        List<MC_Marketing__c> lstToUpsert = new List<MC_Marketing__c>();
        
        mapCntctName = new Map<String,String>();
        mapCntctId = new Map<String,String>();
        mapCntctLNmae = new Map<String,String>();
        mapCntctPhone = new Map<String,String>();
        mapCntctTitle = new Map<String,String>();
        lstCon = new List<Contact>();

        for(String str : mapCndtCmpgn.KeySet())
        {
            setAllEmlAddrss = new Set<String>();
            setExstngEmlAddrss = new Set<String>();
            lstToUpdate = EZRE_Data_Utility.fetchMcConRecs(str,mapCndtCmpgn.get(str));
            setAllEmlAddrss = mapCndtCmpgn.get(str);            
            lstCon = EZRE_Data_Utility.fetchConRecords(setAllEmlAddrss);
        
            if(lstCon.size()>0)
            { 
                for(Contact objCntct : lstCon)
                {
                    mapCntctName.put(objCntct.Email, objCntct.FirstName);
                    mapCntctLNmae.put(objCntct.Email,objCntct.LastName);
                    mapCntctPhone.put(objCntct.Email,objCntct.Phone);
                    mapCntctTitle.put(objCntct.Email,objCntct.Title);
                    mapCntctId.put(objCntct.Email, objCntct.Id);        
                }
            }
            if(lstToUpdate.size()>0)
            {     
                for(MC_Marketing__c cntct : lstToUpdate )
                {
                    setExstngEmlAddrss.add(cntct.Contact_Email__c);                         
                }
            }
            if(setExstngEmlAddrss.size() != 0 || !setExstngEmlAddrss.isEmpty())
            {
                setAllEmlAddrss.removeAll(setExstngEmlAddrss);
            }
            if(setAllEmlAddrss.size()>0)
            { 
                for(String strNwEmlAddrss : setAllEmlAddrss)
                {           
                    MC_Marketing__c objToInsrt= new MC_Marketing__c();
                    objToInsrt.CampaignId__c = str;
                    objToInsrt.CampaignName__c = mapCmpgnIdNme.get(str);
                    objToInsrt.MC_From_Email__c = mapCmpgnIdFrmEml.get(str);
                    objToInsrt.Contact_Email__c = strNwEmlAddrss;
                    lstToUpsert.add(objToInsrt);
                }
            }
            if(lstToUpdate.size()>0)
            { 
                for(MC_Marketing__c obj: lstToUpdate)
                {
                    MC_Marketing__c updtCndt = new MC_Marketing__c(Id = obj.Id);
                    updtCndt.MC_Marketing_IsNew__c = False;
                    lstToUpsert.add(updtCndt);
                }     
            }
        }   
        try
        {
            List<MC_Marketing__c> upsrtLstCan = EZRE_Data_Utility.upsrtMcConRecs(lstToUpsert);
        }
        
        catch(Exception Ex)
        {
              EZRE_EmailLog.sendExceptionEmail('Error in EZRE_MC_MarketingEmail', 'Error in upsrtMCCndtLst\n ' +Ex.getMessage());     
        }
    }
    ///OBJECTIVE
    ///Build the email body.
    ///OBJECTIVE
    @TestVisible
    private static string createEmailBody(List<MC_Marketing__c> lstCndts)
    {
        string strHtmlBody = '';  
        String  strHtmlBody1 = '';  
        integer rowNo;      
        Map<string, List<MC_Marketing__c>> mapCmpgnIdRecs = new Map<string, List<MC_Marketing__c>>();
        if(lstCndts.size()>0)
        { 
            for(MC_Marketing__c objMCCmpgns: lstCndts)
            {           
                if(mapCmpgnIdRecs.containsKey(objMCCmpgns.CampaignId__c))
                {
                    mapCmpgnIdRecs.get(objMCCmpgns.CampaignId__c).add(objMCCmpgns);
                }
                else
                {
                    mapCmpgnIdRecs.put(objMCCmpgns.CampaignId__c,new List<MC_Marketing__c>{objMCCmpgns});
                }
                
            }
        }

        for(string strCmpgnId: mapCmpgnIdRecs.keyset())
        {
            strHtmlBody1  = +'<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">'
                       +'<html> <head> <style type="text/CSS"> table,td {word-break:break-all;word-wrap:break-word-all; -ms-word-wrap: break-word;!important}'
                       + '</style></head><body>'
                       +'<table width="80%" cellpadding="10" border="0">'
                       +'<tr cellspacing="0">'
                       +'<td style="text-align:center; background:#5190d1; font-weight:bold; color:#FFFFFF;">'
                       + mapCmpgnIdRecs.get(strCmpgnId)[0].CampaignName__c+'</td></tr></table>'+
                      '<table width="80%" cellpadding="10" border="0" style="border: none; word-wrap:break-word; table-layout: fixed;">';
            
            rowNo = 0;
            for(MC_Marketing__c strCntEml : mapCmpgnIdRecs.get(strCmpgnId))
            {
              strHtmlBody1 += '<tr cellspacing="0" style = "'+ (math.mod(rowNo,2)==0 ? 'background:#EBEBEB;' : 'background:#EEEEFF;') + '><td width="20%">' + strCntEml.Contact_Email__c+ '</td>' ;
              rowNo += 1;
              if(mapCntctName.get(strCntEml.Contact_Email__c) != null)
              {
                 strHtmlBody1 += '<td width="9%">' + mapCntctName.get(strCntEml.Contact_Email__c) + '</td>' ;
              }
              else{
                  strHtmlBody1 += '<td width="9%">' + ' ' + '</td>' ;
              }
              if(mapCntctLNmae.get(strCntEml.Contact_Email__c) != null)
              {
                 strHtmlBody1 += '<td width="12%">' + mapCntctLNmae.get(strCntEml.Contact_Email__c) + '</td>' ;
              }
              else
              {
                  strHtmlBody1 += '<td width="12%">' + ' ' + '</td>' ;
              }
              if(mapCntctPhone.get(strCntEml.Contact_Email__c) != null)
              {
                strHtmlBody1 += '<td width="10%">' + mapCntctPhone.get(strCntEml.Contact_Email__c) + '</td>';  
              }
              else
              {
                  strHtmlBody1 += '<td width="10%">' + ' ' + '</td>'; 
              }
              if(mapCntctTitle.get(strCntEml.Contact_Email__c) != null)
              {
                 strHtmlBody1 +=  '<td width="13%">' + mapCntctTitle.get(strCntEml.Contact_Email__c) + '</td>' ;
              }
              else{
                  strHtmlBody1 +=  '<td width="13%">' + ' ' + '</td>' ;
              }
              if(mapCntctId.get(strCntEml.Contact_Email__c) != null)
              {
                  strHtmlBody1 += '<td width="16%">' +  '<a href=' + System.Label.MC_Candidate_Id + '/' + mapCntctId.get(strCntEml.Contact_Email__c)  + '>' +mapCntctId.get(strCntEml.Contact_Email__c) + '</a></td>' ;
              }
              else{
                   strHtmlBody1 += '<td width="16%">' + ' ' + '</a></td>' ;
              }
              
               strHtmlBody1 += '</tr>' ;
            }
            
               strHtmlBody1 += '</table><br/>'+
               '</body></html>'; 
               strHtmlBody += strHtmlBody1;
        }   
        return strHtmlBody;
    }
    
    ///OBJECTIVE
    ///Send emails to the contact owner's.
    ///OBJECTIVE
     @TestVisible
    private static void sendEmail(Map<String, Set<String>> mapCmpgnIdSet)
    {
        List<MC_Marketing__c> lstCndt = new List<MC_Marketing__c>();
        List<String> lstCanEmls = new List<String>();
        List<Contact> lstContct = new List<Contact>();
        List<MC_Marketing__c> lstCanToupdt = new List<MC_Marketing__c>();
        Map<String,List<MC_Marketing__c>> mapOwnrEmMcCan = new Map<String,List<MC_Marketing__c>>();
        Map<String,String> mapOwnrEmlOwnrName = new Map<String,String>();
        List<MC_Marketing__c> lstCanUpdt = new List<MC_Marketing__c>();
        string strMailBody;
        string strCCEmail;
        lstCndt = EZRE_Data_Utility.fetchMcContctRecs(mapCmpgnIdSet.KeySet());
        
        if(lstCndt.size()>0)
        { 
            for(MC_Marketing__c c : lstCndt)
            {
                lstCanEmls.add(c.Contact_Email__c);
            } 
        }
        lstContct = EZRE_Data_Utility.fetchConRecs(lstCanEmls);
        
        if(lstCndt.size()>0)
        { 
            for(MC_Marketing__c lstCan : lstCndt)
            {
                if(lstContct.size()>0)
                { 
                    for(Contact con: lstContct)
                    {
                        if(lstCan.Contact_Email__c == con.Email)
                        {
                            lstCan.Contact_OwnerEmail__c = con.Owner.Email;
                            lstCan.Contact_OwnerName__c = con.Owner.Name;
                            lstCan.MC_Marketing_IsNew__c = True;
                            lstCanToupdt.add(lstCan);
                        }
                    }
                }
            }
        }   
        try
        {
            lstCanUpdt = EZRE_Data_Utility.McConRecUpdt(lstCanToupdt);
        }
        
        catch(Exception Ex)
        {
              EZRE_EmailLog.sendExceptionEmail('Error in EZRE_MC_MarketingEmail', 'Error in sendEmail\n ' +Ex.getMessage());     
        }
        
        for(MC_Marketing__c McCan : lstCanUpdt)
        {
            if(!(mapOwnrEmMcCan.ContainsKey(McCan.Contact_OwnerEmail__c)))
            {
                mapOwnrEmMcCan.put(McCan.Contact_OwnerEmail__c,new List<MC_Marketing__c> {McCan});
            }
            else
            {
                mapOwnrEmMcCan.get(McCan.Contact_OwnerEmail__c).add(McCan);              
            }           
            mapOwnrEmlOwnrName.put(McCan.Contact_OwnerEmail__c,McCan.Contact_OwnerName__c);
        }
                
       for(string strEmail: mapOwnrEmlOwnrName.keyset())
        {
            objMessage = new Messaging.SingleEmailMessage();
            strMailBody = createEmailBody(mapOwnrEmMcCan.get(strEmail));
            strCCEmail = label.EZRE_EmaiAddress;
            List<String> lstCCEmail = strCCEmail.split(',');
            objMessage.setToAddresses(new String[] {strEmail});
            objMessage.setCCAddresses(lstCCEmail);  
            objMessage.setSubject('Marketing: Contacts List');
            string strHtmlBody = '<font face="Calibri">' + 'Dear '+ mapOwnrEmlOwnrName.get(strEmail) + ',' +'<br/><br/>' 
                    + 'Please find below the details of those contacts who has opened the emails of Marketing:' 
                    + '<br/>' + '<br/>' + strMailBody + '<br/> Thanks,<br/> Prelude Team. </font>';
            objMessage.setHtmlBody(strHtmlBody);
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { objMessage });
        } 
     
    } */
}