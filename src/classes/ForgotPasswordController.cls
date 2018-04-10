/**
 * An apex page controller that exposes the site forgot password functionality
 */
public with sharing class ForgotPasswordController {
    public String username {get; set;} 
    Public List<user> LoggedUserDetail {get; set;}  
       
    public ForgotPasswordController() {}
    
    public PageReference forgotPassword() {
    LoggedUserDetail=ODS_Data_Utility.getUserdetails(username);
    if(LoggedUserDetail.size()>0)
    {
        boolean success = Site.forgotPassword(username);
        PageReference pr = Page.ForgotPasswordConfirmation;
        pr.setRedirect(true);
        
        if (success) {              
            return pr;
        }
    }
    else
    {
    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL,'Please Enter Valid User Name.');
    ApexPages.addMessage(myMsg);
    
    } 
        return null;
    }
    
    public PageReference cancel() {
        
        return null; 
    }
}