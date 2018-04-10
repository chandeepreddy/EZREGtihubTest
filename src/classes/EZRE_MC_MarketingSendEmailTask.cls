/*
 * @author           Kirankumar D
 * @version          1.0 
 * @date             13/06/2016
 * @description      Create send email task to the contact owners for the contacts to whom campaign has sent.
 * @Modified by      Kalaiselvi R. To Upgrade Version3.0
 */  
 
global class EZRE_MC_MarketingSendEmailTask
{
  /*  //To hold the Mailchimp Details custom settings record. 
    public static Mailchimp_Details__c MCDtls{get;set;} 
    //To hold the Campaign Name
    public static Map<String, String> mapCmpgnIdNme{get;set;} 
    //To Hold the campaign from email.
    public static Map<String,String> mapCmpgnIdFrmEml{get;set;}
    //To hold the Mailchimp id and email
    public static Map<String, Set<String>> mapCmpgnCndt{get;set;}   
    //To hold the set of Mailchimp campaign Id's
    public static Set<String> setCmpgnId{get;set;}
    //To hold the set of Mailchimp campaign Id's
    public static Set<String> sentEmlAdr{get;set;}
    
    public static List<Task> lstCallTask{get;set;}
    public static Map <String, List<Contact>> mapContact{get;set;}
    public static Map<String, set<String>> mapSentEmailLst = new Map<String, set<String>>();
    
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
                    mapCmpgnIdNme.put(string.valueOf(mapCmpgnsFlag.get('id')),string.valueOf(mapSttngsFlag1.get('subject_line')));
                    setCmpgnId.add(string.valueOf(mapCmpgnsFlag.get('id')));  
                    mapCmpgnIdFrmEml.put(string.valueOf(mapCmpgnsFlag.get('id')),string.valueOf(mapSttngsFlag1.get('reply_to')));  
                }
            }    

            if(setCmpgnId.size()>0)  
            {
               getCampaignSentList(setCmpgnId);
            }
        }
      }
      catch(System.CalloutException ex)
      {
        System.debug('***Exception in getMCCmpngLst'+ex);
      } 
          
    }
    
    ///OBJECTIVE
    ///To get the list of email Id's to which campaign has sent.
    ///OBJECTIVE
    public static void getCampaignSentList(set<string> campId)
    {
    try
     {
        for(string strCampId : campId)
        {
            MCDtls = new Mailchimp_Details__c();
            //mapCmpgnCndt = new Map<String, Set<String>>();
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
            res.setStatusCode(200);
            strResponseBody = '{ "emails": [{ "campaign_id": "cfbbc15edd", "list_id": "d91be5086a", "email_address": "indumathi_v@preludesys.com", "activity": [], "_links": [{ "rel": "parent", "href": "https://us9.api.mailchimp.com/3.0/reports//email-activity", "method": "GET" }] }] }';
            } 
            if(res.getStatusCode() == 200) 
            { 
                Map<String, Object> result = (Map<String, Object>)JSON.deserializeUntyped(strResponseBody);
                List<Object> lstObj =  (List<Object>)result.get('emails');
                Map<String, Object> mapFlag = new Map<String, Object>();
                sentEmlAdr = new set<String>();
                
                if(lstObj.size()>0)  
                {
                    for(Object o: lstObj)
                    {
                        mapFlag = (Map<String, Object>)o;               
                        sentEmlAdr.add(string.valueOf(mapFlag.get('email_address')));                     
                    }  
                }      
                mapSentEmailLst.put(strCampId,sentEmlAdr);
            }
        }
        createEmailTask(mapSentEmailLst);
     }
      catch(System.CalloutException ex)
      {
        System.debug('***Exception in getCampaignSentList'+ex);
      }   
    }
    
    ///OBJECTIVE
    ///To create send Email Task for Contacts to whom campaign has sent
    ///OBJECTIVE
    public static void createEmailTask(Map<String, Set<String>> mapCndtCmpgn)
    {
        set<string> setAllEmlAddrss = new set<string>();
        for(Set<String> setEmails: mapCndtCmpgn.values())
        {
            for(String emails : setEmails)
            {
                setAllEmlAddrss.add(emails);
            }           
        }
        
        List<Contact> lstContact = new List<Contact>();
        List<Task> lstConTask = new List<Task>();
        lstCallTask = new List<Task>();
        Set<Id> setContId = new Set<Id>();
        
        lstContact = EZRE_Data_Utility.fetchConRecords(setAllEmlAddrss);
        
        for(Contact c : lstContact)
         {
            setContId.add(c.Id);
        }

        mapContact = new Map <String, List<Contact>>();
        for(Contact Cont : lstContact) 
        {
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
        
        Map <String, List<Task>> mapTask = new Map <String, List<Task>>();
       
        if(lstCallTask.size()>0)  
        {
            for(Task taskObj : lstCallTask) 
            {
                if(!(mapTask.ContainsKey(taskObj.Campaign_Id__c+'-'+taskObj.subject+'-An Email Campaign has been sent')))
                {
                    mapTask.put(taskObj.Campaign_Id__c, new List<Task> {taskObj});
                }
                else
                {
                    mapTask.get(taskObj.Campaign_Id__c).add(taskObj);
                }           
            }
        }
        
        if(mapCndtCmpgn.keyset() != null )
        {
            for(String camp : mapCndtCmpgn.keyset()) 
            {
               if(mapCndtCmpgn.containsKey(camp))
                {
                    for(string emails : mapCndtCmpgn.get(camp))
                     {
                        if(mapContact.containsKey(emails))
                        {
                            for(contact objContact : mapContact.get(emails))
                             {
                                Task conTask = new Task(WhoId = objContact.id);
                                
                                if(!mapTask.ContainsKey(camp+'-Send Email'+'-An Email Campaign has been sent'))
                                {    
                                    conTask.subject = 'Send Email';
                                    conTask.description = mapCmpgnIdNme.get(camp)+' - An Email Campaign has been sent';
                                    conTask.status = 'Completed';
                                    conTask.Campaign_Id__c = camp+'-'+conTask.subject+'-An Email Campaign has been sent';
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
     }   */
 }