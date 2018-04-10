/**
 * @author           Indumathi
 * @version          1.0 
 * @date             19/11/2015
 * @Status           Developed
 * @description      Test Utility Class is a public test class that contain reusable code for test data creation.
 *
 */
@isTest
public class EZRE_OppRprt_DataFactory_Test_Utility
{ 
    ///<OBJECTIVE>
    ///Create Account record.
    ///<OBJECTIVE>
    public static Account createAcc(String strAccName)
    {
        Account acc = new Account();
        acc.Name = strAccName;
        insert acc;
        return acc;
    }
    
    
    ///OBJECTIVE
    /// Insert and Return Opportunity
    ///OBJECTIVE
    public static Opportunity createOpp(String strName,Id strAccId, String strStgName)
    { 
        Opportunity objOpp =new Opportunity ();                       
                    objOpp.Name = strName;
                    objOpp.AccountId= strAccId;
                    objOpp.CloseDate = Date.Today();
                    objOpp.Follow_up_Date__c= Date.today();
                    objOpp.StageName= strStgName;
                                        
                    insert objOpp;  
                    return objOpp;      
    }
    
    ///OBJECTIVE
    /// Insert and Return Task
    ///OBJECTIVE
    public static Task createTask(String strSubjct, String strOppId, Id strUsrId, Date dtActvtyDate, String strStatus)
    {
        Task objTsk = new Task();
        objTsk.ActivityDate = dtActvtyDate;
        //objTsk.ActivityDate = Date.Today()-1;
        objTsk.OwnerId = strUsrId;
        objTsk.Subject = strSubjct;
        objTsk.WhatId =strOppId ;
        objTsk.Status = strStatus;
        insert objTsk;
        return objTsk;
    
    }
    
    
    ///OBJECTIVE
    /// Insert and Return Event
    ///OBJECTIVE
    public static Event createEvent(String strSubjct, String strOppId, Id strUsrId,Date dtActvtyDate)
    {
        Event objevnt = new Event();
        objevnt.ActivityDate = dtActvtyDate;
        //objevnt.ActivityDate = Date.Today()-1;
        objevnt.OwnerId = strUsrId;
        objevnt.Subject = strSubjct;
        objevnt.WhatId = strOppId;
        objevnt.StartDateTime = dtActvtyDate;
        objevnt.EndDateTime = dtActvtyDate;
         
        insert objevnt;
        return objevnt;
    
    }
   
   
    ///OBJECTIVE
    /// Insert and Return User
    ///OBJECTIVE
    public static User createUser(String strAlias, String strEmail,String strEmailEncodKey,
                                  String strLastName,String strLangLocalKey,String strLocalSideKey,
                                  String strProfileId,String strTimeZoneKey,String strUserName)
    
    {
          User objUser = new User();
                    objUser.Alias = strAlias;
                    objUser.Email = strEmail; 
                    objUser.EmailEncodingKey = strEmailEncodKey;
                    objUser.LastName = strLastName;
                    objUser.LanguageLocaleKey = strLangLocalKey;
                    objUser.LocaleSidKey = strLocalSideKey;
                    objUser.ProfileId = strProfileId;
                    objUser.TimeZoneSidKey = strTimeZoneKey;
                    objUser.UserName = strUserName;                  
                    insert objUser;
                    return objUser;

    }
    
    ///<OBJECTIVE>
    /// Fetch the Cron trigger Details.
    ///<OBJECTIVE>
    public static CronTrigger getCronTriggewrDetails(string JobId)
    {
        return  [select id, CronExpression, TimesTriggered, NextFireTime from CronTrigger where id = :JobId];
    }

    }