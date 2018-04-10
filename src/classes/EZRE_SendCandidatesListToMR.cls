/**
 * @author           Shahida K
 * @version          1.0 
 * @date             4/02/2016
 * @Status           Developed
 * @description      Send Email with candidates not approved by MR
 * @ModifiedDate     26/02/2016
 */
Public class EZRE_SendCandidatesListToMR
 {
  
   public void SendCandidatesListToMR()
   {
       
        Candidate_Mapping__c objAssignCandidate=new Candidate_Mapping__c();
        //List of candidates approved by LR and waiting for MR approval
        list<Candidate_Mapping__c > lstCandWaingForMRAppval= EZRE_Requirement_DataUtility.getCandsWatngForMRApprov();
        list<String> lstOwnerEmailId=new list<String>();
        
        Map<string,list<Candidate_Mapping__c>> MapEmailAndCandidate=new  Map<string,list<Candidate_Mapping__c>>();
        //Map to get records related to one requirment owner email id
        for(Candidate_Mapping__c  objCandRec :lstCandWaingForMRAppval)
        {
           if(MapEmailAndCandidate.containskey(objCandRec.Req_Owner_Email__c))
            {
               MapEmailAndCandidate.get(objCandRec.Req_Owner_Email__c).add(objCandRec);
            }
            else
            {
                 MapEmailAndCandidate.Put(objCandRec.Req_Owner_Email__c,new List<Candidate_Mapping__c>{objCandRec});
            }
                 
        }
        system.debug('@@@@@@@@@'+MapEmailAndCandidate);
        if(MapEmailAndCandidate.size()>0)  
        {
            system.debug('@@@@@@'+MapEmailAndCandidate.keyset());
            List<Messaging.SingleEmailMessage> lstEmailMessage = new List<Messaging.SingleEmailMessage>();
            //for loop to iterate through all the requirement owner email id's in map
            for(String strOwnerEmailId:MapEmailAndCandidate.keyset())
            {
               string strHtmlbody ='';
               String  StrRequirementOwnerName='';
               if(strOwnerEmailId != Null)
               {
                    system.debug('@@@@@@emailid afetre if condition'+strOwnerEmailId);                   
                    List<Candidate_Mapping__c> lstAssignCandRecord = MapEmailAndCandidate.get(strOwnerEmailId);
                    system.debug('@@@@@@set of records for each emailid'+lstAssignCandRecord);
                    system.debug('@@@@@@set of records for each emailid'+lstAssignCandRecord.size());
                    //For loop to form candidates list as table rows in html
                    for(Candidate_Mapping__c ObjAssignCandRec : lstAssignCandRecord)
                    {
                        string StrRequirement;             
                        string StrCandidateName;              
                        string StrRecruiter ;
                        string StrStatus ;                       
                        string strCandtMappingId; 
                        string strCandMappngName;
                        String dtCandidateCreatedDate;
                        strCandtMappingId=ObjAssignCandRec.id; 
                        strCandMappngName = ObjAssignCandRec.Name; 
                        dtCandidateCreatedDate=ObjAssignCandRec.candidate__r.CreatedDate.format('MM-dd-yyyy');
                      
                        if(ObjAssignCandRec.Job_Title__c!=null)
                        {
                             StrRequirement = ObjAssignCandRec.Job_Title__c;
                        }
                        else
                        {
                             StrRequirement ='';            
                        }
                        if(ObjAssignCandRec.Added_User__c!=null)
                        {
                            StrRecruiter= ObjAssignCandRec.Added_User__c;
                        }
                        else
                        {
                            StrRecruiter='';
                        }
                        if(ObjAssignCandRec.candidate__r.Candidate_Full_Name__c!=null)
                        {
                            StrCandidateName=ObjAssignCandRec.candidate__r.Candidate_Full_Name__c;
                            
                        }
                        else
                        {
                            StrCandidateName='';
                        }   
                        
                       
                        strHtmlbody +='<tr>' +
                        '<td>' + '<a href="'+URL.getSalesforceBaseUrl().toExternalForm() +'/'+strCandtMappingId+'">'+strCandMappngName+'</a></td>' +
                        '<td>' + StrRequirement +'</td>' +
                        '<td>' + StrCandidateName + '</td>' +                     
                        '<td>' + StrRecruiter + '</td>' +  
                        '<td>' + dtCandidateCreatedDate + '</td>' +     
                        '</tr>';
                                           
                    
                        
                    }
                      List<User> lstUser=[Select Name from user where Email=:strOwnerEmailId limit 1];
                        if(lstUser.size()>0)
                        {
                             StrRequirementOwnerName=lstUser[0].Name;
                        }
                       else{
                           StrRequirementOwnerName='';
                        }
                        system.debug('@@@@@@@@@@@@@@StrRequirementOwnerName'+StrRequirementOwnerName);
                        system.debug('@@@@@@first'+strOwnerEmailId);
                        String strMREmailAlertCcAddress = System.Label.EZRE_MREmailAlertCcAddress;                      
                        list<string> lstCcAddress=strMREmailAlertCcAddress.split(',');
                        String strMREmailAlertBccAddr=System.Label.EZRE_MREmailAlertBccAddress; 
                        list<string> lstBccAddr=strMREmailAlertBccAddr.split(',');
                        OrgWideEmailAddress owea = EZRE_OppActReport_DataUtility.getOrgWideEmailAddress();
                        Messaging.SingleEmailMessage email =  new Messaging.SingleEmailMessage(); 
                        email.setOrgWideEmailAddressId(owea.Id);                        
                        email.setToAddresses(new string[]{strOwnerEmailId});                       
                        email.setccAddresses(lstCcAddress);
                        email.setBccAddresses(lstBccAddr);   
                        email.setSubject('EZRE - Candidates Pending Approval Report');
                        email.setHtmlBody('Hi ' + StrRequirementOwnerName+','+'</br></br> Good Evening!'+ '</br></br> Please find the below table with candidates waiting for your(MR) Approval.'+'</br></br> Please approve or reject the resumes as appropriate ASAP.'+'</br></br> <table border="2"> '+
                        '<tr>'+ 
                        '<th> Record Id</th>' +
                        '<th> Requirement Name</th>' +
                        '<th> Candidate Name </th>' +   
                        '<th>Recruiter Name  </th>' +  
                        '<th>Candidate Created Date</th>' +                         
                        '</tr>' +
                        strHtmlbody + '</table>' + '</br></br> Regards, </br> EZRE Team');                                                 
                        lstEmailMessage.add(email);
                        strHtmlbody ='';
                }
            } 
            //Send table of candidate records as mail to MR                 
             Messaging.sendEmail(lstEmailMessage);    
            
        }
     
    }
}