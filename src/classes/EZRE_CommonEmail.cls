global class EZRE_CommonEmail
 {
     public static void sendWOAssignEmail(string ToEmailIds,string CCEmailIds,string strSubject,string strBody)
	{
	    //To hold the email addresses
	    String[] toAddresses = new List<String>();
	    //To hold the email addresses
	    String[] ccAddresses = new List<String>();	    
	    string  fromAddress;
	    //To hold the email subject
	    String strEmailSubject;
	    //To hold the email body
	    String strplainBody;
	    //list<string> lstToEmail = new List<string>();
	    
	    toAddresses  = ToEmailIds.split(';');
	    ccAddresses  = CCEmailIds.split(';');
	    
	    //To hold the current organization id
	    OrgWideEmailAddress owea = [select Id,address from OrgWideEmailAddress where DisplayName = 'EZRE'];
	    
	    Messaging.SingleEmailMessage emailMsg = new Messaging.SingleEmailMessage(); 
	    fromAddress = owea.address;
	    
	    emailMsg.setOrgWideEmailAddressId(fromAddress);
	              
	    emailMsg.setToAddresses(toAddresses);
	    
	    emailMsg.setCcAddresses(ccAddresses);   
	          
	    strEmailSubject = strSubject;
	    //Set the subject
	    emailMsg.setSubject(strEmailSubject);
	    //Build the body of the emails with the workorder id link.
	    strplainBody = strBody;
	    emailMsg.setPlainTextBody(strplainBody);
	    
	    //Send emails
	    Messaging.sendEmail(new Messaging.SingleEmailMessage[] { emailMsg });
	       
	}
}