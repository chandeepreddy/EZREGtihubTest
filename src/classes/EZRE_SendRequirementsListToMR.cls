/**
 * @author           Gangadhar R.
 * @version          1.0 
 * @date             29/02/2016
 * @Status           Developed
 * @description      Send Email with requirements Open for More than 30 days
 */
Public class EZRE_SendRequirementsListToMR
 { 
   ///<OBJECTIVE>
   ///Method to fetch requirements open/reopen more than 30 days and send email list to requirement owner email
   ///</OBJECTIVE>
   public list<Requirement__c> lstReqOpen;
   public void sendRequirementsListToMR()
   {       
       //List contains requirements open/reopen more than 30 days and send email list to requirement owner email
        Date statusUpdatedDt ; 
        if(!Test.isRunningTest())
        {
            statusUpdatedDt = system.today().addDays(-30);
            lstReqOpen = EZRE_Requirement_DataUtility.fetchReqData(statusUpdatedDt);
            system.debug('@@@@@@@@@isNotRunningTestRequiremnetList'+lstReqOpen);
        }
        else
        {
            statusUpdatedDt = system.today();
            lstReqOpen = EZRE_Requirement_DataUtility.fetchReqmntData();
            system.debug('@@@@@@@@@tRunningTestRequiremnetList'+lstReqOpen);
        }
        Map<string,list<Requirement__c>> MapEmailAndReqmnt=new  Map<string,list<Requirement__c>>();
        //For loop to get records related to one requirment owner email id      
        for(Requirement__c  objReq :lstReqOpen)
        {
           system.debug('@@@@@@@@@Map Of req owner Email'+objReq.Owner.email);
           if(MapEmailAndReqmnt.containskey(objReq.Owner.email))
            {
               MapEmailAndReqmnt.get(objReq.Owner.email).add(objReq);
            }
            else
            {
                 MapEmailAndReqmnt.Put(objReq.Owner.email,new List<Requirement__c>{objReq});
            }       
        }
        system.debug('@@@@@@@@@Map Of req owner Email and Requirements'+MapEmailAndReqmnt);
        if(MapEmailAndReqmnt.size()>0)  
        {
            system.debug('@@@@@@'+MapEmailAndReqmnt.keyset());
            List<Messaging.SingleEmailMessage> lstEmailMessage = new List<Messaging.SingleEmailMessage>();
            //for loop to iterate through all the requirement owner email id's in map
            for(String strOwnerEmailId:MapEmailAndReqmnt.keyset())
            {
               string  strHtmlbody ='';
               String strOwnerName='';            
               if(strOwnerEmailId != Null)
               {
                    system.debug('@@@@@@emailid after if condition'+strOwnerEmailId);                   
                    List<Requirement__c> lstRequirement = MapEmailAndReqmnt.get(strOwnerEmailId);
                    system.debug('@@@@@@set of records for each emailid'+lstRequirement);
                    system.debug('@@@@@@set of records for each emailid'+lstRequirement.size());
                    //For loop to form candidates list as table rows in html
                    for(Requirement__c ObjReqmnt : lstRequirement)
                    {
                        strOwnerName=ObjReqmnt.Owner.name;                       
                        String strReqName=ObjReqmnt.Name;
                        String strStatus;                      
                        String strReqmntCode;
                        
                        if(!String.isBlank(ObjReqmnt.Status__c)&&ObjReqmnt.Status__c!=null)
                        {
                            strStatus=ObjReqmnt.Status__c;
                        }
                        else{
                            
                            strStatus='';
                        }                        
                       
                        Date dt = ObjReqmnt.StatusUpdated_Date__c;
                        String strStatusUpdatedt;
                     
                        if((String.ValueOf(dt)!='')&&(String.ValueOf(dt)!=null))
                        {
                         strStatusUpdatedt=DateTime.newInstance(dt.year(),dt.month(),dt.day()).format('MM-dd-yyyy');
                            
                        }
                        else{
                            strStatusUpdatedt='';    
                        }
                                                    
                        String   strReqmntCreatedDate=ObjReqmnt.CreatedDate.format('MM-dd-yyyy');
                        Decimal intResumesRequested=ObjReqmnt.No_Of_Resumes__c;
                        Decimal intResumesSubmitted=ObjReqmnt.ResumesSubmitted__c;
                        if(!String.isBlank(ObjReqmnt.Opportunity_Code__c))
                        {
                            strReqmntCode=ObjReqmnt.Opportunity_Code__c;
                            
                        }
                        else{
                            strReqmntCode='';
                        }
                        String strReqmntId=ObjReqmnt.id;

                        strHtmlbody +='<tr>' +
                        '<td>' + '<a href="'+URL.getSalesforceBaseUrl().toExternalForm() +'/'+strReqmntId+'">'+strReqName+'</a></td>' +
                        '<td>' + strReqmntCode + '</td>' +  
                        '<td>' + strStatus + '</td>' +                     
                        '<td>' + strStatusUpdatedt + '</td>' +  
                        '<td>' + strReqmntCreatedDate + '</td>' +  
                        '<td>' + intResumesRequested + '</td>' +  
                        '<td>' + intResumesSubmitted + '</td>' + 
                        '<td>' + strOwnerName +'</td>' +                                                                           
                        '</tr>';   
                    system.debug('@@@@@@@@@@@@@@strOwnerName'+strOwnerName);
                    }
                        
                        system.debug('@@@@@@first'+strOwnerEmailId);
                        String strMREmailAlertCcAddress = System.Label.EZRE_OpenReqmntEmailAlrtCcAddr;                      
                        list<string> lstCcAddress=strMREmailAlertCcAddress.split(',');
                        String strMREmailAlertBccAddr=System.Label.EZRE_OpenReqmntEmailAlrtBccAddr; 
                        list<string> lstBccAddr=strMREmailAlertBccAddr.split(',');
                        OrgWideEmailAddress owea = EZRE_OppActReport_DataUtility.getOrgWideEmailAddress();
                        Messaging.SingleEmailMessage email =  new Messaging.SingleEmailMessage(); 
                        email.setOrgWideEmailAddressId(owea.Id); 
                        email.setToAddresses(new string[]{strOwnerEmailId});                                                            
                        email.setBccAddresses(lstBccAddr);                       
                        email.setccAddresses(lstCcAddress); 
                        email.setSubject('EZRE-Requirement Aging Report');
                        email.setHtmlBody('Hi ' + strOwnerName+','+'</br></br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Find below list of requirements that were opened by you and are in open status for more than 30 days. Please review them and if you have any inactive requirement in the list please close them. This helps us to plan our work better.'+'</br></br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Expecting your quick action on this. Thanks in advance.'+'</br></br></br> <table border="2"> '+
                        '<tr>'+ 
                        '<th>Requirement Name</th>' +
                        '<th>Requirement Code</th>' +                          
                        '<th>Status</th>' +   
                        '<th>Requirement Open/Reopened Date</th>' +  
                        '<th>Requirement Created Date</th>' +  
                        '<th>Resumes Requested</th>' +  
                        '<th>Resumes Submitted</th>' +  
                        '<th>Requirement Owner Name</th>' +
                        '</tr>' +
                        strHtmlbody + '</table>' + '</br></br> Regards, </br> EZRE Team');                                                 
                        lstEmailMessage.add(email);
                        strHtmlbody =''; 
                }
            }    
            //Send table of oepn/Reopen requirement records to MR                 
             Messaging.sendEmail(lstEmailMessage);              
        }   
    }
}