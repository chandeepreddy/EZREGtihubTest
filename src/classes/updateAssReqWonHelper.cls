/*
 * @author           Shahida K
 * @version          1.0 
 * @date             24/08/2016
 * @description      Helper class for updateAssReqWon trigger to send FTE Requirement update email alert to PC.
 */  
global class updateAssReqWonHelper
{
    public static Boolean isTriggerFired=false;
    public static Messaging.SingleEmailMessage sendMail(String htmltable)
    {
        system.debug('============'+isTriggerFired);
        Messaging.SingleEmailMessage email =  new Messaging.SingleEmailMessage(); 
        String toAddress=System.Label.EZRE_FieldTrackingReportToAddress;
        list<string> toAddressList=toAddress.split(',');  
        email.setToAddresses(toAddressList);
        System.debug('Email ToAddresses============='+toAddressList);
        String BccAddressStr=system.label.EZRE_FieldTrackingReportBCcAddress;
        if(String.isNotBlank(BccAddressStr))
        {
             List<String> lstBccAddr=BccAddressStr.split(',');
             email.setBccAddresses(lstBccAddr);
        }
        OrgWideEmailAddress owea=EZRE_OppActReport_DataUtility.getOrgWideEmailAddress(); 
        email.setOrgWideEmailAddressId(owea.Id);
        email.setSubject('FTE Requirements Got Updated');
        email.setHtmlBody(htmltable+'</br> Regards, </br> EZRE Team');
        return email;
    }
  
}