/**
 * @author           Gnana Prakash
 * @version          1.0 
 * @date             28-Sep-2016
 * @Status           Developed
 * @description      The main purpose of this class that exposes the site login functionality
 */

global with sharing class ODSLoginController
{
    global String username {get; set;}
    global String password {get; set;}
    global ODSLoginController()
    {
    }
    global PageReference login()
    {

        
        string PortalAccessResult= getPortalAccess();
        
        if(PortalAccessResult=='InvalidUser'){
             ApexPages.addMessage( new ApexPages.Message(ApexPages.Severity.ERROR,'Your login attempt has failed. Make sure the username and password are correct.'));
            return null;
        }     
        else if(ApexPages.currentPage().getParameters().get('g-recaptcha-response')==null||ApexPages.currentPage().getParameters().get('g-recaptcha-response')=='')
        {
            system.debug('g-recaptcha-response==='+ApexPages.currentPage().getParameters().get('g-recaptcha-response'));
            ApexPages.addMessage( new ApexPages.Message(ApexPages.Severity.ERROR,Label.ODS_recaptcha));
            return null;
        }
        else if(PortalAccessResult=='NoAccess')
        {
             ApexPages.addMessage( new ApexPages.Message(ApexPages.Severity.ERROR,Label.ODS_Is_Portal_Access));    
             return null;
        }
        else
        {  
            if(!string.isEmpty(username))
                username = username.trim();  
            return Site.login(username, password, null);
        }
    }
    
    global PageReference ForgotPassword()
    {       
        PageReference pgRef = Page.Forgot_Password;
        pgRef.setRedirect(True);
        return pgRef;
    } 
    
    Public string getPortalAccess()
    {
       
          Boolean IsPortalAccess = false;
          string Result = '';
          
          if(!string.isEmpty(username))
              username = username.trim();
           
          User[] users= ODS_Data_Utility.getPortalAccessByUserName(username);
          if(users.size()> 0){
                IsPortalAccess  = users[0].Is_Portal_Access__c;
                if(IsPortalAccess){
                    Result = 'AccessEnabled';
                }else{
                    Result = 'NoAccess';
                }
           }else{
                Result = 'InvalidUser';
           }
        return Result ;

    } 
    
}