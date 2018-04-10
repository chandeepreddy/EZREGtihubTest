/**
 * @author           Indhu
 * @version          1.0 
 * @date             06-Jan-2014
 * @Status           Developed
 * @description      This is a helper class that sends daily productivity details of specific user as email.
 *                   
 */
 
public class EZRE_SendMailDailyProductivity
{
    public List<DailyProductivityWrapper> lstDailyProdWrapper {get; set;}
    public List<ContentVersion> LstContVersion {get ;set;}
    public List<Candidate_Mapping__c> LstCandMapping {get ;set;}
    public List<Requirement__c> LstRequirement {get ;set;}
    public EZRE_DailyProductivityDetails__c objDailyProd{get;set;}
    
    public EZRE_SendMailDailyProductivity()
    {
        objDailyProd = EZRE_DailyProductivityDetails__c.getValues('DailyProductivityReport');
        getDailyProductivityList();        
    }
    
    public void sendMail()
    {
        sendMailDailyProductivity();
    }
    
    public void getDailyProductivityList()
    {
        lstContVersion = EZRE_DailyProductivity_DataUtility.getContntVersList(objDailyProd.DailyProductivity_User__c);
        
        lstCandMapping = EZRE_DailyProductivity_DataUtility.getCandMappngList();
                          
        lstRequirement = EZRE_DailyProductivity_DataUtility.getReqmtList(objDailyProd.DailyProductivity_User__c);
        
        lstDailyProdWrapper = new List<DailyProductivityWrapper>();        
        lstDailyProdWrapper.add(new DailyProductivityWrapper(lstContVersion,lstCandMapping,lstRequirement)); 
        system.debug('Total Wrapper List:' +lstDailyProdWrapper);                          
    } 
    
    public class DailyProductivityWrapper
    {
        public List<ContentVersion> lstContentVersionWrapper {get; set;}
        public List<Candidate_Mapping__c> LstCandMappingWrapper {get; set;}
        public List<Requirement__c> LstRequirementWrapper {get; set;}
        
        public DailyProductivityWrapper(List<ContentVersion> LstContVer,List<Candidate_Mapping__c> LstCandMap,
                                        List<Requirement__c> LstReq)
        {    
            LstContentVersionWrapper = LstContVer;
            LstCandMappingWrapper = LstCandMap;
            LstRequirementWrapper = LstReq;
        }
    }
    
    public void sendMailDailyProductivity()
    {
        string strFromEmailId = '';
        string strFromDisplayName = '';
        strFromEmailId = objDailyProd.DailyProductivity_FromEmail__c;
        strFromDisplayName = objDailyProd.DailyProductivity_FromDiaplayName__c;
        string strEmailContent = '';
        string strEmailAttachment = '';
        strEmailContent = getEmailContentsDailyReport();
        strEmailAttachment = getEmailAttachmentDailyReport();
        
        if(strEmailAttachment != null && !strEmailAttachment.equals(''))
        {
            Messaging.SingleEmailMessage objMail = new Messaging.SingleEmailMessage();
            objMail.setHTMLBody(strEmailContent);            
            
            objMail.setOrgWideEmailAddressId(EZRE_DailyProductivity_DataUtility.getOrgWideEmailId());
            objMail.setReplyTo(strFromEmailId);        
             
            String[] strToAddress = (objDailyProd.DailyProductivity_ToEmail__c).split(',');
            objMail.setToAddresses(strToAddress);
            String[] strCCAddress = (objDailyProd.DailyProductivity_CCEmail__c).split(',');
            objMail.setCcAddresses(strCCAddress);
            
            String strSubject = objDailyProd.DailyProductivity_MailSubject__c;
            
            objMail.setSubject(strSubject);
            objMail.setSaveAsActivity(false);
            
            if (strEmailAttachment != null && !strEmailAttachment.equals(''))
            {
                Messaging.EmailFileAttachment excelAttchment = new Messaging.EmailFileAttachment();
                blob excelBlob = Blob.valueOf(strEmailAttachment);
                
                String strFileName = objDailyProd.DailyProductivity_ReportName__c +'.xls' ;
                System.debug('----------filename ------------' + strFileName);                        
                excelAttchment.setFileName(strFileName);
                
                excelAttchment.setBody(excelBlob);
                System.debug('===== Excel Content====' + excelBlob);
                objMail.setFileAttachments(new Messaging.EmailFileAttachment[]{excelAttchment});
            }
            
            System.debug('===== Sending Email');            
            
            Messaging.SendEmailResult[] results = Messaging.sendEmail(new Messaging.SingleEmailMessage[] { objMail });
            if (results[0].isSuccess()) 
            {
                System.debug('The email was sent successfully.');
            } 
            else 
            {
                System.debug('The email failed to send: '+ results[0].getErrors()[0].getMessage());
            }
        }                
    }
    
    public string getEmailContentsDailyReport()
    {
        String strEmailContentValue = '';
        
        if (lstDailyProdWrapper!= null && lstDailyProdWrapper.size() > 0)
        {
            strEmailContentValue = objDailyProd.DailyProductivity_EmailBody__c;
        }
        
        return strEmailContentValue;        
    }
    
    public string getEmailAttachmentDailyReport()
    {
        String strContents = '';
        
        String strTabChar = '\t';
        String strEmptyChar = '-';
        String strNewLineChar = '\n';        
        
        if (lstDailyProdWrapper != null && lstDailyProdWrapper.size() > 0)
        {
            strContents = '\t\t\t\t<b>Daily Productivity Report</b> \n\n';
            
            if(lstContVersion !=null && lstContVersion.size() >0)
            {
                strContents += 'Resumes Submitted \n';
                strContents += 'Title \t Published User \n';
                for(ContentVersion objConVer: lstContVersion)
                {
                    if(objConVer.title != null)
                    {
                        strContents += objConVer.title;
                    }
                    strContents += strTabChar; 
                    if(objConVer.createdBy.name != null)
                    {
                        strContents += objConVer.createdBy.name;
                    }
                    strContents += strTabChar +strNewLineChar ;
                }
                strContents += strNewLineChar +strNewLineChar ;
            }
            
            if(LstCandMapping !=null && LstCandMapping.size() >0)
            {
                strContents += 'Candidate Submission\n';
                strContents += 'Candidate: First Name\tLast Name\tClient Name\tRequirement: Job title\tLast Modified Date';
                strContents += '\tStatus\tAdded User\tRequirement Owner\tResume Source \n';
                for(Candidate_Mapping__c objCandMap: LstCandMapping)
                {
                    if(objCandMap.Candidate__r.name !=null)
                    {
                        strContents += objCandMap.Candidate__r.name  ;
                    }                    
                    strContents += strTabChar;
                    
                    if(objCandMap.Candidate__r.last_name__c != null)
                    {
                        strContents += objCandMap.Candidate__r.last_name__c;
                    }
                    strContents += strTabChar;
                    
                    if(objCandMap.Client_Name__c != null)
                    {
                        strContents += objCandMap.Client_Name__c;
                    }
                    strContents += strTabChar;
                    
                    if(objCandMap.Requirement__r.name != null)
                    {
                        strContents += objCandMap.Requirement__r.name;
                    }
                    strContents += strTabChar;
                    
                    if(objCandMap.lastModifiedDate != null)
                    {
                        strContents += objCandMap.lastModifiedDate;
                    }
                    strContents += strTabChar;
                    
                    if(objCandMap.Status1__c != null)
                    {
                        strContents += objCandMap.Status1__c;
                    }
                    strContents += strTabChar;
                    
                    if(objCandMap.Added_User__c != null)
                    {
                        strContents += objCandMap.Added_User__c;
                    }
                    strContents += strTabChar;
                    
                    if(objCandMap.requirement__r.Owner.name !=null)
                    {
                        strContents += objCandMap.requirement__r.Owner.name;
                    }
                    strContents += strTabChar;
                    
                    if(objCandMap.Candidate__r.Resume_Source__c != null)
                    {
                        strContents += objCandMap.Candidate__r.Resume_Source__c;                    
                    }
                    strContents += strTabChar +strNewLineChar;                    
                }
                strContents += strNewLineChar +strNewLineChar ;
            }
            
            if(LstRequirement !=null && LstRequirement.size() >0)
            {
                strContents += 'Requirement Assignment Tracker \n';
                strContents += 'Created Date\tRequirement Code\tStatus\tClient Name\tJob title\tResumes Requested';
                strContents += '\tResumes submitted\tCumulative Resumes Submitted\tFirst Resume';
                strContents += '\tFirst Response(Days)\tReq Closed Date\tReq Closed(Days) \n';
                for(Requirement__c objReqmt: LstRequirement)
                {
                    if(objReqmt.createddate!=null)
                    {
                        strContents += objReqmt.createddate ;
                    }
                    strContents += strTabChar;
                    
                    if(objReqmt.Opportunity_Code__c!=null)
                    {
                        strContents += objReqmt.Opportunity_Code__c ;
                    }
                    strContents += strTabChar;
                    
                    if(objReqmt.Status__c!=null)
                    {
                        strContents += objReqmt.Status__c ;
                    }
                    strContents += strTabChar;
                    
                    if(objReqmt.C_Name__r.Name !=null)
                    {
                        strContents += objReqmt.C_Name__r.Name ;
                    }
                    strContents += strTabChar;
                    
                    if(objReqmt.Name!=null)
                    {
                        strContents += objReqmt.Name ;
                    }
                    strContents += strTabChar;
                    
                    if(objReqmt.No_Of_Resumes__c!=null)
                    {
                        strContents += objReqmt.No_Of_Resumes__c ;
                    }
                    strContents += strTabChar;
                    
                    if(objReqmt.Submitted_Resumes__c!=null)
                    {
                        strContents += objReqmt.Submitted_Resumes__c ;
                    }
                    strContents += strTabChar;
                    
                    if(objReqmt.cumulative_resumes_submitted__c!=null)
                    {
                        strContents += objReqmt.cumulative_resumes_submitted__c ;
                    }
                    strContents += strTabChar;
                    
                    if(objReqmt.Assign_Candidate_date__c !=null)
                    {
                        strContents += objReqmt.Assign_Candidate_date__c ;
                    }
                    strContents += strTabChar;
                    
                    if(objReqmt.First_Response__c!=null)
                    {
                        strContents += objReqmt.First_Response__c ;
                    }
                    strContents += strTabChar;
                    
                    if(objReqmt.Req_Closed_Date__c!=null)
                    {
                        strContents += objReqmt.Req_Closed_Date__c ;
                    }
                    strContents += strTabChar;
                    
                    if(objReqmt.Req_Closed_hrs__c!=null)
                    {
                        strContents += objReqmt.Req_Closed_hrs__c;                    
                    }
                    strContents += strTabChar +strNewLineChar;
                }
                strContents += strNewLineChar +strNewLineChar ;
            }  
        }
        
        system.debug('----------Contents---------' +strContents);
        return strContents;        
    }
}