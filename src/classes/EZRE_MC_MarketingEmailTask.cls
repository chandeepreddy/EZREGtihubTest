/*
 * @author           Kalaiselvi R
 * @version          1.0 
 * @date             06/05/2015
 * @description      Create send email task to the contact owners for the contacts who has not opened the emails.
 * @Modified by      Kalaiselvi R. To Upgrade Version3.0
 */  
 
global class EZRE_MC_MarketingEmailTask
{
   /* //To hold the Mailchimp Details custom settings record. 
    public static Mailchimp_Details__c MCDtls{get;set;} 
    //To hold the Campaign Name
    public static Map<String, String> mapCmpgnIdNme{get;set;} 
    //To Hold the campaign from email.
    public static Map<String,String> mapCmpgnIdFrmEml{get;set;}
    //To hold the set of Mailchimp campaign Id's
    public static Set<String> setCmpgnId{get;set;}
    //To hold the list of Contacts
    public static Map <String, List<Contact>> mapContact {get; set;}
    //To hold the list of Tasks
    public static Map <String, List<Task>> mapTask {get; set;}
    //To hold the mailchimp id and email for UnOpened contacts
    public static Map<String, Set<String>> mapUnOpenLst = new Map<String, Set<String>>();
    //To hold the email address of UnOpened contacts
    public static Set<String> unopendEmailAddr {get; set;}
    
    @future (callout=true) 
    public static void createSendEmailTask()
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
        DateTime startDate = DateTime.Now().addDays(-3);
        String frmtdStartDate = startDate.formatGMT('yyyy-MM-dd\'T\'HH:mm:ss.SSS\'Z\'');
        
        DateTime endDate = DateTime.Now().addDays(-2);
        String frmtdEndDate = endDate.formatGMT('yyyy-MM-dd\'T\'HH:mm:ss.SSS\'Z\'');
        
        MCDtls = new Mailchimp_Details__c();
        MCDtls = EZRE_Data_Utility.getMCDtls('MC Marketing');       
        Http h = new Http();        
        HttpRequest reqst = new HttpRequest();      
        reqst.setMethod('GET'); 
        reqst.setHeader('Authorization', 'apikey '+MCDtls.API_Key__c);
        reqst.setEndpoint('https://'+MCDtls.Domain_Name__c+'.api.mailchimp.com/3.0/campaigns?status=sent&before_send_time='+frmtdEndDate+'&since_send_time='+frmtdStartDate);
        reqst.setTimeout(120000);
        HttpResponse res = new HttpResponse();
        string strResponseBody;
        if(!Test.isRunningTest())
        {           
            res = h.send(reqst); 
            strResponseBody = res.getBody();
            if(res.getStatusCode() == 200) 
            {  
                Map<String, Object> mapRespJSON = (Map<String, Object>)JSON.deserializeUntyped(res.getBody());
                count = Integer.valueOf(mapRespJSON.get('total_items'));    
            }
        } 
        else
        {
        res.setStatusCode(200);
        strResponseBody ='{ "campaigns": [{ "id": "cfbbc15edd", "status": "sent", "recipients": { "list_id": "d91be5086a"}, "settings": { "subject_line": "Marketing", "reply_to": "indumathi_v@preludesys.com" } }] }';
        } 
        return count;
      }
      catch(System.CalloutException ex)
      {
       System.debug('## Exception in getMCCmpngLstCount ##'+ex);
       return count;
      } 
    }
   ///OBJECTIVE
   ///To get the list of Campaign.
   ///OBJECTIVE 
   public static void getMCCmpngLst()
    {
      try
      {
        DateTime startDate = DateTime.Now().addDays(-3);
        system.debug('***startDate'+startDate);
        String frmtdStartDate = startDate.formatGMT('yyyy-MM-dd\'T\'HH:mm:ss.SSS\'Z\'');
        
        DateTime endDate = DateTime.Now().addDays(-2);
        system.debug('***endDate'+endDate );
        String frmtdEndDate = endDate.formatGMT('yyyy-MM-dd\'T\'HH:mm:ss.SSS\'Z\''); 
        
        Integer iCampgnCount = getMCCmpngLstCount();
        MCDtls = new Mailchimp_Details__c();
        MCDtls = EZRE_Data_Utility.getMCDtls('MC Marketing');       
        Http h = new Http();        
        HttpRequest reqst = new HttpRequest();      
        reqst.setMethod('GET'); 
        reqst.setHeader('Authorization', 'apikey '+MCDtls.API_Key__c); 
        reqst.setEndpoint('https://'+MCDtls.Domain_Name__c+'.api.mailchimp.com/3.0/campaigns?status=sent&type=regular&count='+iCampgnCount+'&before_send_time='+frmtdEndDate+'&since_send_time='+frmtdStartDate);
        
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
            for(Object o: lstObj)
            {
                mapCmpgnsFlag = (Map<String, Object>)o;
                Object obj =  (Object)mapCmpgnsFlag.get('settings');
                mapSttngsFlag1 = (Map<String, Object>)obj;
                mapCmpgnIdNme.put(string.valueOf(mapCmpgnsFlag.get('id')),string.valueOf(mapSttngsFlag1.get('subject_line')));
                setCmpgnId.add(string.valueOf(mapCmpgnsFlag.get('id')));  
                mapCmpgnIdFrmEml.put(string.valueOf(mapCmpgnsFlag.get('id')),string.valueOf(mapSttngsFlag1.get('reply_to')));  
            }
            if(setCmpgnId.size()>0)
            {
                 getUnOpnedLst(setCmpgnId);
            }
        }
      }
      catch(System.CalloutException ex)
      {
       System.debug('## Exception in getMCCmpngLst ##'+ex); 
      }
          
    }
    ///OBJECTIVE
    ///To get the list of Contacts who didn't open the campaign emails.
    ///OBJECTIVE
     public static void getUnOpnedLst(set<string> campId)
    {
    try
    {
        for(string strCampId:campId)
        {
            MCDtls = new Mailchimp_Details__c();
            MCDtls = EZRE_Data_Utility.getMCDtls('MC Marketing');       
            Http h = new Http();        
            HttpRequest reqst = new HttpRequest();  
            reqst.setMethod('GET');
            reqst.setHeader('Authorization', 'apikey '+MCDtls.API_Key__c);               
            reqst.setEndpoint('https://'+MCDtls.Domain_Name__c+'.api.mailchimp.com/3.0/reports/'+strCampId+'/email-activity');
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
                unopendEmailAddr = new Set<String>();
              
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
        
                for(String s : mapEmlActvty.keySet()) 
                {
                    for( string s1 : mapEmlActvty.get(s)) 
                    {
                        //if(String.isEmpty(s1) && String.isBlank(s1)) 
                        if(s1 == '()') // To check empty, blank and null
                        {
                            unopendEmailAddr.add(s);
                        }
                    }
                }       
                mapUnOpenLst.put(StrcampId, unopendEmailAddr);   
            }
        }
        sendEmailTask(mapUnOpenLst);  
    }
    
    catch(System.CalloutException ex)
    {
         System.debug('## Exception in getCampaignEmail Activity ##'+ex);
    }
    
}
    
    ///OBJECTIVE
    ///To create Call Task for opened Contacts/Accounts
    ///OBJECTIVE
    public static void sendEmailTask(Map<String, Set<String>> mapCndtCmpgn)  {
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
        
         for(Contact c : lstContact) {
            setContId.add(c.Id);
         }
         
        mapContact = new Map <String, List<Contact>>();
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
        lstCallTask = EZRE_Data_Utility.fetchTaskRcrds(setContId);   
        
        mapTask = new Map <String, List<Task>>();
        if(lstCallTask.size() >0)
        {
            for(Task taskObj : lstCallTask) 
             {
                if(!(mapTask.ContainsKey(taskObj.Campaign_Id__c+'-The contact has not opened the email')))
                { 
                    
                    mapTask.put(taskObj.Campaign_Id__c, new List<Task> {taskObj});
                }
                else
                {
                    if(mapTask.ContainsKey(taskObj.Campaign_Id__c))
                    mapTask.get(taskObj.Campaign_Id__c).add(taskObj);             
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
                                if(!mapTask.ContainsKey(camp+'-The contact has not opened the email')) 
                                {
                                    conTask.subject = 'Send Email';
                                    conTask.Campaign_Id__c = camp+'-The contact has not opened the email';
                                    conTask.Priority  = 'high';
                                    conTask.description = mapCmpgnIdNme.get(camp)+' - The contact has not opened the email';
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
    }*/
 }