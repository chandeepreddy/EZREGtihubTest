/**
 * @author           Kiran Kumar
 * @version          1.0 
 * @date             26/11/2015
 * @Status           Developed
 * @description      Class for opportunity email report 
 *
 */

public  class EZRE_OppEmail_Report
{
    public Set<string> setStgeName {get;set;}
    public List<Opportunity> lstAllOpp {get;set;}
    public List<Task> lstOpenTasks {get;set;}
    public List<Event> lstOpenEvnts {get;set;}
    public set<Id> setOpenOppIds {get;set;}
    public set<Id> setClosedOppIds {get;set;}
    public List<Opportunity> lstOppWthoutActvts {get;set;}  
    public string strStageNames{get;set;} 

    public EZRE_OppEmail_Report()
    {
        Set<string> setStgeName = new Set<String>{'Prospecting', 'Qualification','Needs Analysis','Value Proposition','Id. Decision Makers','Perception Analysis','Proposal/Price Quote','Negotiation/Review','Resume Submitted','Phone Screen','1st Interview','2nd Interview'};
        strStageNames = convertStageNameToString(setStgeName);   
        String str = '(\'';
        for (String s : setStgeName )
        {
            str += s + '\',\'';
        }
        system.debug('###str:' +str);
        str  = str.substring(0,str.length()-2);
        str += ')'; 
        setOpenOppIds = new set<Id>();
        setClosedOppIds = new set<Id>(); 
        lstOppWthoutActvts  = new List<Opportunity>(); 
              
    }
    
    //<OBJECT>
    //Method to convert "setStgeName" from set to string
     //<OBJECT>
    
    private String convertStageNameToString(Set<String> setStageName)
    {
        String str = '(\'';
        for (String s : setStageName)
        {
            str += s + '\',\'';
        }

        str  = str.substring(0,str.length()-2);
        str += ')';      
        return  str;
    }
    // Method to get opportunity records of each owner and email oppportunity report 
    public void callScheduleMethod()
    {
        //List of all Opportunities with Stage and Account Owner Name filtered
        String strAccntOwner = System.Label.OppReport_AccountOwnerFilter;       
        lstAllOpp = new List<Opportunity>();        
        lstAllOpp = EZRE_OppActReport_DataUtility.getAllOppList(strStageNames,strAccntOwner);      
        for(Opportunity objOpp : lstAllOpp)
        {
            setClosedOppIds.add(objOpp.Id);
            
        }       
        
        //List of all open tasks
        lstOpenTasks = new List<Task>();
        lstOpenTasks = EZRE_OppActReport_DataUtility.getOpenTaskList();
       
        for(Task objTsk : lstOpenTasks)
        {
            setOpenOppIds.add(objTsk.WhatId);           
            
        }
        
        //List of all open events
        List<Event> lstOpenEvnts= new List<Event>();  
        lstOpenEvnts = EZRE_OppActReport_DataUtility.getOpenEventsList();        
       
        for(Event objEvnt: lstOpenEvnts)
        {
            setOpenOppIds.add(objEvnt.WhatId);
            
        }
       
        setClosedOppIds.removeAll(setOpenOppIds);  
             
        lstOppWthoutActvts = EZRE_OppActReport_DataUtility.getAllOppWthoutActvs(setClosedOppIds); 
        Map<string,List<Opportunity>> mapOppRec = new Map<string,List<Opportunity>>();
        
        //For loop to get map of opportunity owner id and opportunity record of one perticular owner
        for(Opportunity objOppRec  : lstOppWthoutActvts)
        {
       
             if(mapOppRec.containsKey(objOppRec.OwnerId))
                {
                    mapOppRec.get(objOppRec.OwnerId).add(objOppRec);
                }
            else
                {
                    mapOppRec.put(objOppRec.OwnerId, new List<Opportunity> {objOppRec});
                }
        }
          Map<id,user> userDetailsMap=new Map<id,user>();           
         List<User> UserList=EZRE_OppActReport_DataUtility.getOpportunityOwnerInfo(); 
         for(user objuser:UserList)
         {
             if(!userDetailsMap.containsKey(objuser.id))
                 userDetailsMap.put(objuser.id,objuser);
         }
         system.debug('userDetailsMap========'+userDetailsMap);   
            
        
        //For loop to get list opportunity records related to one pericular owner
        for(string strName : mapOppRec.keyset())
        {
          List<opportunity> lstOppRec = mapOppRec.get(strName);
          string strHtmlbody='';
          string strEmailAddr;
          string strUserName ;
           string profileName;
          for(Opportunity oppRec : lstOppRec )
          {
                string strAcntName;             
                string strOppName;              
                string dtFollowup ;
                string strOwnerId = oppRec.OwnerId;
               
                if(oppRec.Follow_up_Date__c!=null)
                {
                     dtFollowup = String.valueOf(oppRec.Follow_up_Date__c);
                }
                else
                {
                     dtFollowup ='';            
                }
                if(oppRec.Account.Name!=null)
                {
                    strAcntName= oppRec.Account.Name;
                }
                else
                {
                    strAcntName='';
                }
                if(oppRec.Name!=null)
                {
                    strOppName= oppRec.Name;
                }
                else
                {
                    strOppName='';
                }
               
               // User objUser=EZRE_OppActReport_DataUtility.getOpportunityOwnerInfo(strOwnerId);
                if(userDetailsMap.containsKey(strOwnerId))
                {    
                    user objUser=userDetailsMap.get(strOwnerId);
                    strEmailAddr=objUser.Email;
                    strUserName = objUser.Name;
                    profileName=objUser.profile.name;
                    system.debug('profileName========='+profileName);
                 }
                strHtmlbody +='<tr>' +
                '<td>' + strAcntName +'</td>' +
                '<td>' + strOppName + '</td>' +
                '<td>' + dtFollowup + '</td>' +
                '<td>' + strUserName + '</td>' +
                '</tr>';
           }
            String strOppCcAddress='';
           if((profileName=='ISR')||(profileName=='Lead Gen Team'))
            {
                  strOppCcAddress=System.Label.OpportunityReportRelatedToISRandLG; 
                  system.debug('profileName ISR/LG========='+strOppCcAddress);
            }               
            else
            {
                 strOppCcAddress = System.Label.OpportunityReportCcAddress;  
                 system.debug('profileName other========='+strOppCcAddress);
            }   
            list<string> strCcAddress=strOppCcAddress.split(';');
          
            //send opportunity records  related to owner as email 
            Messaging.SingleEmailMessage email =  new Messaging.SingleEmailMessage();
            OrgWideEmailAddress owea = EZRE_OppActReport_DataUtility.getOrgWideEmailAddress();
            email.setOrgWideEmailAddressId(owea.Id);  
            List<String> sendTo = new List<String>();
            sendTo.add(strEmailAddr);
            email.setToAddresses(sendTo);
            email.setccAddresses(strCcAddress);
            email.setSubject('Opportunity Activity Report');
            email.setHtmlBody('Hi ' + strUserName   + '</br></br> Please find the below table which do not have a open activity(Due date greater than today)</br> <table border="2"> '+
            '<tr>'+ 
            '<th> Account Name </th>' +
            '<th> Opportunity Name </th>' +
            '<th> Follow up Date </th>' +
            '<th> opportunity Owner </th>' +
            '</tr>' +
            strHtmlbody + '</table>' + '</br></br> Regards, </br> EZRE Team');          
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { email });
        }
    }
}