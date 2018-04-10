/**
 * An apex page controller that exposes the site forgot password functionality
 */
public with sharing class ODS_ForgotPasswordController {
    public String username {get; set;}   
       
    public ODS_ForgotPasswordController() {}
    
    public PageReference forgotPassword() {
        boolean success = Site.forgotPassword(username);
        PageReference pr = Page.ForgotPasswordConfirmation;
        pr.setRedirect(true);
        
        if (success) {              
            return pr;
        }
        return null;
    }
    
    public PageReference cancel() {
        
        return null; 
    }
}