/**
 * @author           Keerthi Chandra
 * @version          1.0 
 * @date             12/05/2015
 * @Status           Developed
 * @description      Email Message class for sending Exceptions to users in mail.
 *
 */
global class EZRE_EmailLog
{
    ///<OBJECTIVE>
    ///To send exceptions in emails.
    public static void sendExceptionEmail(string strSubject,string strBody)
    {
        //To hold the To email addresses
        String[] strArrToAddr = new List<String>(); 
                       
        Messaging.SingleEmailMessage objEmailMsg = new Messaging.SingleEmailMessage(); 
        
        strArrToAddr = (Label.Email_Log_Address).split(';'); 
        objEmailMsg.setToAddresses(strArrToAddr);        
        objEmailMsg.setSubject(strSubject);
        objEmailMsg.setPlainTextBody(strBody);
        
        //Sends email
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { objEmailMsg });
           
    }

}