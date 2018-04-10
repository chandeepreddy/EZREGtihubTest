/**
 * @author           Indumathi & Soumya
 * @version          1.0 
 * @date             July 2014
 * @Status           Developed
 * @description      This  is the controller Class which authorizes the given LinkedIn app 
 *                      and post the selected Requirement details on the LinkedIn wall on behalf of the app. 
 *                   
*/

public class EZRE_LinkedInIntegrationCntrl
{
    //To hold the LinkedIn app details from custom settings
    public string strhostURL {get; set;}   
    public static  string AccessToken{get;set;}
    public static String strHost{get;set;}
     
    /* <OBJECTIVE>
    *  To authorize the given LinkedIn app 
    *  </OBJECTIVE>   
    *  <RETURNS> 
    *  pagereference
    *  </RETURNS>
    */ 
    public PageReference Authorize()
    {
        String strHeaderHost, strBtnAction, rqmntId, reqIDFrmCookie, authCode, redirURI, hostURLFrmCookie, authURI, strActionFrmCookie;
        String[] hstURLSplit;
        PageReference pgRdrct = null;
        
        LinkedInDetails__c LnkdnAppDtls = new LinkedInDetails__c();
        LnkdnAppDtls = EZRE_SocialMedia_DataUtility.getLnkdnAppDtls('Recruiting App');
        
        //Check Custom Setting if Access Token is valid
        if(LnkdnAppDtls.validTo__c != NULL && LnkdnAppDtls.AccessToken__c != NULL && LnkdnAppDtls.AccessToken__c != '')
        {
            strHeaderHost =  ApexPages.currentPage().getParameters().get('host'); 
            rqmntId = ApexPages.currentPage().getParameters().get('id');
            createCookie('rqmntId', rqmntId);
            strBtnAction = ApexPages.currentPage().getParameters().get('btnAct');
            createCookie('btnAction', strBtnAction);
            createCookie('strToken', LnkdnAppDtls.AccessToken__c);
            postToLinkedInWall(rqmntId, '');
            
            //Check if the action is SAVE
            //if(strBtnAction == 'Save')
             //   pgRdrct = new PageReference(strHeaderHost + '/' + rqmntId);                
            //else
                pgRdrct = new PageReference('/apex/FaceBook_Login?id=' + rqmntId);            
        }
        else
        {   
            //First request of authorization to fetch the code
            if(ApexPages.currentPage().getParameters().containsKey('id'))
            {   
                createCookie('rqmntId',ApexPages.currentPage().getParameters().get('id'));
                strHeaderHost = ApexPages.currentPage().getHeaders().get('Host');
                createCookie('hostURL', strHeaderHost);
                strBtnAction = ApexPages.currentPage().getParameters().get('btnAct');
                createCookie('btnAction', strBtnAction);
                redirURI = 'https://'+ApexPages.currentPage().getHeaders().get('Host')+'/apex/EZRE_LinkedInIntegrationPg';
                //authURI = 'https://www.linkedin.com/uas/oauth2/authorization?response_type=code&client_id='+LnkdnAppDtls.API_Key__c+'&scope=r_fullprofile%20r_emailaddress%20r_network%20rw_nus&state=DCEEFWF45453sdffef424&redirect_uri='+redirURI;
                authURI = 'https://www.linkedin.com/uas/oauth2/authorization?response_type=code&client_id='+LnkdnAppDtls.API_Key__c+'&scope=w_share&state=DCEEFWF45453sdffef424&redirect_uri='+redirURI;
               
                pgRdrct = new PageReference(authURI);
            }
            //Final request to fetch the Access Token
            else if(ApexPages.currentPage().getParameters().containsKey('code'))
            {
                reqIDFrmCookie = accessCookie('rqmntId');
                authCode = ApexPages.currentPage().getParameters().get('code');
                redirURI = 'https://'+ApexPages.currentPage().getHeaders().get('Host')+'/apex/EZRE_LinkedInIntegrationPg';
                authURI = 'https://www.linkedin.com/uas/oauth2/accessToken?grant_type=authorization_code&code='+authCode+'&redirect_uri='+redirURI+'&client_id='+LnkdnAppDtls.API_Key__c+'&client_secret='+LnkdnAppDtls.API_Secret__c;
                
                if(!Test.isRunningTest())
                    doFinalAuthorization(authURI, reqIDFrmCookie);   
                
                hostURLFrmCookie = accessCookie('hostURL');                
                hstURLSplit = hostURLFrmCookie.split('\\.');
                reqIDFrmCookie = accessCookie('rqmntId');
                strActionFrmCookie = accessCookie('btnAction');
                
                //Check if the action is SAVE
                //if(strActionFrmCookie == 'Save')
                    //pgRdrct = new PageReference('https://' + hstURLSplit[1] + '.salesforce.com' + '/' + reqIDFrmCookie);                
               // else if(strActionFrmCookie == 'SaveNew')
                   // pgRdrct = new PageReference('/apex/EZRE_AssignRequirementPage?btnAct=SaveNew?id=' + rqmntId);                 
                pgRdrct = new PageReference('/apex/FaceBook_Login?id=' + rqmntId);
            }
        }
        return pgRdrct;
    }
    
    /* <OBJECTIVE>
    *  Final Authorization process to get Access token
    *  </OBJECTIVE>   
    *  <RETURNS>      
    *  </RETURNS>
    */  
    public void doFinalAuthorization(String strURI, String strRqmntId)
    {
        Http http = new Http();
        HttpRequest httpReq = new HttpRequest();
        httpReq.setEndpoint(strURI);
        httpReq.setMethod('GET');
        HttpResponse httpResp = http.send(httpReq);         
        JSONWrapper jsonWrapObj = (JSONWrapper)JSON.deserialize(httpResp.getBody(), JSONWrapper.class);
        createCookie('strToken', jsonWrapObj.access_token);
        
        postToLinkedInWall(strRqmntId, jsonWrapObj.access_token); 
    } 
  
    /* <OBJECTIVE>
    *       Wrapper class to store the JSON response
    *  </OBJECTIVE>   
    *  <RETURNS>  
    *       Wrapper class
    *  </RETURNS>*/    
    public class JSONWrapper
    {
        public Integer expires_in;
        public String access_token;
    }
    
    /* <OBJECTIVE>
    *       Post the details of Requirement to LinkedIn Wall
    *  </OBJECTIVE>   
    *  <RETURNS>      
    *  </RETURNS>
    */ 
    public void postToLinkedInWall(String strRqmntId, String strAccessToken)
    {
        String strPositionType, strReqmntName, strReqCity, strReqState, strReqSkill, strRecruiter;
        String strAccsTkn, strRecruiterEmail, strRecruiterPhone, strPostReqString, strAccsTknFrmCookie, strPostReq;
        DOM.Document doc = new DOM.Document();
        
        Requirement__c r = EZRE_SocialMedia_DataUtility.getRequirementDtls(strRqmntId);
        
        LinkedInDetails__c LnkdnAppDtls = EZRE_SocialMedia_DataUtility.getLnkdnAppDtls('Recruiting App');
        system.debug('@@@@LinkedIn Details'+LnkdnAppDtls);
        if(LnkdnAppDtls.AccessToken__c != '' && LnkdnAppDtls.AccessToken__c != NULL)
            strAccsTkn = LnkdnAppDtls.AccessToken__c;
        else
            strAccsTkn = accessCookie('strToken');
        
        strPositionType = (r.Position_Type__c!=NULL && r.Position_Type__c!='' ? r.Position_Type__c:'');
        strReqmntName = r.Name!=NULL && r.Name!='' ? r.Name:'';
        strReqCity = r.City__c!=NULL && r.City__c!='' ? r.City__c:'';
        strReqState = r.State__c!=NULL && r.State__c!='' ? r.State__c:'';
        strReqSkill = r.Skill_Set__c!=NULL && r.Skill_Set__c!='' ? r.Skill_Set__c:'';
        
        RequirementAssignment__c rqmntAsgmnt = EZRE_SocialMedia_DataUtility.getRqmntAssgnmnt(r.Id);
        if(rqmntAsgmnt !=NULL)
        {
            strRecruiter = rqmntAsgmnt.Recruiter__r.Name!=NULL && rqmntAsgmnt.Recruiter__r.Name!='' ? rqmntAsgmnt.Recruiter__r.Name:
                                (rqmntAsgmnt.Lead_Recruiter__r.Name != NULL && rqmntAsgmnt.Lead_Recruiter__r.Name != '' ? rqmntAsgmnt.Lead_Recruiter__r.Name:'');
                                
            strRecruiterEmail = rqmntAsgmnt.Recruiter__r.Email!=NULL && rqmntAsgmnt.Recruiter__r.Email!='' ? rqmntAsgmnt.Recruiter__r.Email:
                                (rqmntAsgmnt.Lead_Recruiter__r.Email != NULL && rqmntAsgmnt.Lead_Recruiter__r.Email != '' ? rqmntAsgmnt.Lead_Recruiter__r.Email:'');
            
            strRecruiterPhone = rqmntAsgmnt.Recruiter__r.phone!=NULL && rqmntAsgmnt.Recruiter__r.phone!='' ? rqmntAsgmnt.Recruiter__r.phone:
                                (rqmntAsgmnt.Lead_Recruiter__r.Phone != NULL && rqmntAsgmnt.Lead_Recruiter__r.Phone != '' ? rqmntAsgmnt.Lead_Recruiter__r.Phone:'');
        }
        
        strPostReq = 'Immediate '+ strPositionType +' opportunity for a '+ strReqmntName +' in '+ strReqCity + ' ,' + strReqState +'\r\n' + strReqSkill +'\r\n';
        if(strRecruiter != '' || strRecruiterEmail != '' || strRecruiterPhone != '') 
        {
            strPostReq =  strPostReq + ' Please contact ';
            if(strRecruiter != '')
                strPostReq =  strPostReq + strRecruiter;
            if(strRecruiterEmail != '')
                strPostReq =  strPostReq + ' ' + strRecruiterEmail;
            if(strRecruiterEmail != '')
                strPostReq =  strPostReq + ' ' + strRecruiterPhone;
        }

        dom.XmlNode share = doc.createRootElement('share',null,null);
        dom.XmlNode comment = share.addChildElement('comment',null,null);
        dom.XmlNode content = share.addChildElement('content',null,null);
        dom.XmlNode title = content.addChildElement('title',null,null).addTextNode('New Job Opening in Preludesys');   
        dom.XmlNode description = content.addChildElement('description',null,null).addTextNode(strPostReq);
        dom.XmlNode submittedurl = content.addChildElement('submitted-url',null,null).addTextNode('www.preludesys.com');
        dom.XmlNode visibility = share.addChildElement('visibility',null,null);
        dom.XmlNode code = visibility.addChildElement('code',null,null).addTextNode('anyone');
        
        String contents = doc.toXmlString(); 
        system.debug('####contents :' +contents);
        String endpoint = 'https://api.linkedin.com/v1/people/~/shares?oauth2_access_token='+strAccsTkn;

        HttpRequest httpReq = new HttpRequest();
        httpReq.setEndpoint(endpoint);
        httpReq.setMethod('POST');
        httpReq.setHeader('Content-Type','application/xml');
        httpReq.setHeader('x-li-format','xml');    
        httpReq.setbody(contents);
        httpReq.setHeader('Content-Length','3999');
        httpReq.setTimeOut(120000);
        
        Http http = new Http();
        HTTPResponse httpResp = http.send(httpReq);
        system.debug('######httpResp:' +httpResp);
        strAccsTknFrmCookie = accessCookie('strToken');
        if(strAccsTknFrmCookie != '')
        {
            LnkdnAppDtls = new LinkedInDetails__c();
            LnkdnAppDtls = EZRE_SocialMedia_DataUtility.getLnkdnAppDtls('Recruiting App');
        
            LnkdnAppDtls.AccessToken__c = strAccsTknFrmCookie;
            LnkdnAppDtls.ValidTo__c = Datetime.now().addMonths(2);      
            update LnkdnAppDtls;
        }
    }
    
    /* <OBJECTIVE>
    *       Create Cookies
    *  </OBJECTIVE>   
    *  <RETURNS>      
    *  </RETURNS>
    */
    public void createCookie(String strCookieName, String strCookieValue)
    {
        System.debug('CURRENT PAGE SETTING A COOKIE:'+ApexPages.currentPage()+ ' with value='+strCookieValue);
        
        Cookie cookieObj = new Cookie(strCookieName,strCookieValue,null,-1,false);
        System.debug('actCookie---->' + cookieObj);
        ApexPages.currentPage().setCookies(new Cookie[]{cookieObj});        
    } 
    
    /* <OBJECTIVE>
    *       Retrieve Cookie values
    *  </OBJECTIVE>   
    *  <RETURNS>      
    *  </RETURNS>
    */ 
    public String accessCookie(String strCookieName)
    {
        String strCookie = strCookieName;
        Cookie cookieObj = ApexPages.currentPage().getCookies().get(strCookieName);
        return cookieObj.getValue();
    }
}