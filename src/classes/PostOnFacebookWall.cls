/**
 * @author           Indumathi
 * @version          1.0 
 * @date             July 2014
 * @Status           Developed
 * @description      This  is the controller Class which authorizes the given facebook app 
 *                      and post the selected Requirement details on the Facebook wall on behalf of the app. 
 *                   
*/

public class PostOnFacebookWall
{
    //Facebook Details custom setting record
    public Static FacebookDetails__c FBAppDtls{get;set;}
    
    //To hold Requirement details
    public Static Requirement__c objRqrmnt {get;set;}
    
    //To hold RequirementAssignment details
    public Static RequirementAssignment__c  objRqrmntAssgnmnt{get;set;}
   
    //To store the id of the selected Requirement
    public string rqmntId {get; set;}

    /* <OBJECTIVE>
    *  checks the token validity and accordingly initiated the authorization process
    *  </OBJECTIVE>   
    *  <RETURNS> 
    *  pagereference
    *  </RETURNS>
    */    
    
    public PageReference Authorize()
    {
        String strHeaderHost,reqIDFrmCookie ,strBtnAction,hostURLFrmCookie,strActionFrmCookie;
        String[] hstURLSplit;
        PageReference pgRdrct = null;
    
        FBAppDtls = new FacebookDetails__c();
        FBAppDtls = EZRE_SocialMedia_DataUtility.getFBAppDtls('FacebookAPP');
        
        //rqmntId = ApexPages.currentPage().getParameters().get('id');
        rqmntId = accessCookie('rqmntId');
        System.debug('rqmntId==============='+rqmntId);
        
        
        //Checking the token validity
        if(FBAppDtls.AccessToken__c != NULL && FBAppDtls.AccessToken__c != '')
        {
            strHeaderHost=ApexPages.currentPage().getHeaders().get('Host');
            strBtnAction = accessCookie('btnAction');            
            //createCookie('btnAction', strBtnAction);
            System.debug('rqmntId###'+rqmntId);
            System.debug('strBtnAction###'+strBtnAction );
            
            hstURLSplit = strHeaderHost.split('\\.');
            postOnFBWall(rqmntId);
            
            //Check if the action is SAVE            
            if(strBtnAction == 'Save')                         
                pgRdrct = new PageReference('https://' + hstURLSplit[1] + '.salesforce.com' + '/' + rqmntId);
            else                
                pgRdrct = new PageReference('/apex/EZRE_AssignRequirementPage?btnAct=SaveNew?id=' + rqmntId);           
        }
        else
        {   
            //first request to fetch the code
            if(ApexPages.currentPage().getParameters().containsKey('id'))
            {     
                //createCookie('rqmntId',ApexPages.currentPage().getParameters().get('id'));
                strHeaderHost = ApexPages.currentPage().getHeaders().get('Host');
                String extndPrms = '';
                if(FBAppDtls.extendedPermissions__c != null && FBAppDtls.extendedPermissions__c != '')
                {
                    extndPrms = '&scope='+FBAppDtls.extendedPermissions__c;
                }
                strBtnAction= accessCookie('btnAction');
                rqmntId =accessCookie('rqmntId');
                //createCookie('btnAction', strBtnAction);
                String redirURI = 'https://'+ApexPages.currentPage().getHeaders().get('Host')+'/apex/Facebook_Login';
                System.debug('host:'+redirURI);
                    
                String authURI = 'https://graph.facebook.com/oauth/authorize?client_id='+FBAppDtls.clientID__c+'&redirect_uri='+redirURI+extndPrms+'&x_rid='+rqmntId +'&enable_profile_selector=true';
            
                System.debug('authURI 111111111111111111111111'+authURI );
                pgRdrct = new PageReference(authURI);
                 
            }
            // final request to fetch the User Access token based on the code generated above.
            else if(ApexPages.currentPage().getParameters().containsKey('code')) //second req
            {
                reqIDFrmCookie = accessCookie('rqmntId');
                System.debug('reqIDFrmCookie---->' + reqIDFrmCookie);
                System.debug('URI: '+ApexPages.currentPage().getUrl()); 
                String getCode = ApexPages.currentPage().getParameters().get('code');
                String extndPrms = '';
                
                if(FBAppDtls.extendedPermissions__c != null && FBAppDtls.extendedPermissions__c != ''){
                    extndPrms = '&scope='+FBAppDtls.extendedPermissions__c;
                }
                
                String redirURI = 'https://'+ApexPages.currentPage().getHeaders().get('Host')+'/apex/Facebook_Login';
                
                String authURI = 'https://graph.facebook.com/oauth/access_token?client_id='+FBAppDtls.clientID__c+'&redirect_uri='+redirURI+extndPrms+'&client_secret='+FBAppDtls.clientSecret__c+'&code='+getCode;                    
                System.debug('URL IS:'+authURI);
                strHeaderHost = ApexPages.currentPage().getHeaders().get('Host');

                hstURLSplit =strHeaderHost.split('\\.');
                reqIDFrmCookie = accessCookie('rqmntId');
                strActionFrmCookie = accessCookie('btnAction');
                //createCookie('btnAction', strBtnAction);
                System.debug('rqmntId### Final:'+reqIDFrmCookie );
                System.debug('btnAction###Final:'+'btnAction');
            
                //Check if the action is SAVE
                if(strActionFrmCookie == 'Save')
                    pgRdrct = new PageReference('https://' + hstURLSplit[1] + '.salesforce.com' + '/' + reqIDFrmCookie);
                else if(strActionFrmCookie == 'SaveNew')
                    pgRdrct = new PageReference('/apex/EZRE_AssignRequirementPage?btnAct=SaveNew?id=' + reqIDFrmCookie); 
                    
                doFinalAuthorization(authURI, FBAppDtls, reqIDFrmCookie );              
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
    private void doFinalAuthorization(String strURI, FacebookDetails__c ObjFBApp, String strRqmntId)
    {
        Http objHttp = new Http();
        HttpRequest objHttpReq = new HttpRequest();
        objHttpReq.setEndpoint(strURI);
        objHttpReq.setMethod('GET');
         if(!Test.isRunningTest())
        {
            HttpResponse objHttpResp = objHttp.send(objHttpReq);
            String strResp, pgTknAuthuri;
       
            strResp = objHttpResp.getBody();
            System.debug('FINAL RESP IS:'+strResp); 
            //token string in format of access_token=XXXXX&expires - we want the first value
            String strAccsstkn = '';
            if(strResp.indexOf('&') > -1){
                strAccsstkn = strResp.substring(13, strResp.indexOf('&'));
            }
            else 
            {
                strAccsstkn = strResp.substring(13,strResp.length());
            }
            
            pgTknAuthuri = 'https://graph.facebook.com/me/accounts?access_token='+strAccsstkn;
            //Commented above and added the below code
            //String pgTknAuthuri = 'https://graph.facebook.com/v2.2/313683442141584/accounts';
            System.debug('pgTknAuthuri IS:'+pgTknAuthuri);
            
            getPageToken(pgTknAuthuri,ObjFBApp); //commented and moved to line 170
            
            system.debug('Page Access Token' + ObjFBApp.AccessToken__c);
            FBAppDtls.ValidTo__c= DateTime.Now().addDays(60);
            System.debug('Access token:'+strAccsstkn);
            //update ObjFBApp; ***
            postOnFBWall(strRqmntId);
       }
    }
    
    
    /* <OBJECTIVE>
    *  To get Page token
    *  </OBJECTIVE>   
    *  <RETURNS>      
    *  </RETURNS>
    */ 
    public void getPageToken(String uri,FacebookDetails__c ObjFBApp)
    {
        Http h = new Http();    
        HttpRequest req = new HttpRequest();
        req.setEndpoint(uri);
        req.setMethod('GET');    
        if(Test.isRunningTest())
            return;
        HttpResponse res = h.send(req);     
        String resp = res.getBody();
        System.debug('FINAL RESP IS in getting Page Token:'+resp);     
        Map<String, Object> m = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
        List<Object> data = (List<Object>) m.get('data');        
        Map<String, Object> mapPgeDtls = new Map<String, Object>();
        for (Object o : data) 
        {
            mapPgeDtls = (Map<String, Object>) o;
            System.debug('>>> ' + mapPgeDtls);
            if((string.valueOf(mapPgeDtls.get('id'))) == ObjFBApp.UserId__c)
             {
                 ObjFBApp.AccessToken__c = string.valueOf(mapPgeDtls.get('access_token'));      
                 update ObjFBApp;
                 System.debug('ObjFBApp==========================='+ObjFBApp);   
             }
        
        }
    }
  

    /* <OBJECTIVE>
    *  Posts the details of Requirement on Facebook wall
    *  </OBJECTIVE>   
    *  <RETURNS>      
    *  </RETURNS>
    */ 
    @future(callout=true)
    public static void postOnFBWall(String strRqmntId)
    {
        FBAppDtls = new FacebookDetails__c();
        FBAppDtls = EZRE_SocialMedia_DataUtility.getFBAppDtls('FacebookAPP');
        objRqrmnt = new Requirement__c();
        objRqrmntAssgnmnt = new RequirementAssignment__c ();
        System.debug('strRqmntId====================='+strRqmntId);         
        objRqrmnt = EZRE_SocialMedia_DataUtility.getRequirementDtls(strRqmntId);
        System.debug('requirement id------>' + objRqrmnt);
         Map<String,String> mapAuthDtls ;
        if(objRqrmnt != NULL)
        {
            objRqrmntAssgnmnt = EZRE_SocialMedia_DataUtility.getRqmntAssgnmnt(objRqrmnt.Id);
            
            String strDtlsToPost = 'Immediate '+ (objRqrmnt.Position_Type__c!=NULL && objRqrmnt.Position_Type__c!='' ? objRqrmnt.Position_Type__c:'')
                                +' opportunity for a '+ (objRqrmnt.Name!=NULL && objRqrmnt.Name!='' ? objRqrmnt.Name:'') +' in '+ 
                                + (objRqrmnt.City__c!=NULL && objRqrmnt.City__c!='' ? objRqrmnt.City__c:'') + ' ,' + (objRqrmnt.State__c!=NULL && objRqrmnt.State__c!='' ? objRqrmnt.State__c:'') +'\r\n'
                                + (objRqrmnt.Skill_Set__c!=NULL && objRqrmnt.Skill_Set__c!='' ? objRqrmnt.Skill_Set__c:'') +'\r\n' +
                                
                                'Please contact '+ (objRqrmntAssgnmnt.Recruiter__r.Name!=NULL && objRqrmntAssgnmnt.Recruiter__r.Name!='' ? objRqrmntAssgnmnt.Recruiter__r.Name:
                                (objRqrmntAssgnmnt.Lead_Recruiter__r.Name != NULL && objRqrmntAssgnmnt.Lead_Recruiter__r.Name != '' ? objRqrmntAssgnmnt.Lead_Recruiter__r.Name:'')) + ' ' +
                                
                                (objRqrmntAssgnmnt.Recruiter__r.Email!=NULL && objRqrmntAssgnmnt.Recruiter__r.Email!='' ? objRqrmntAssgnmnt.Recruiter__r.Email:
                                (objRqrmntAssgnmnt.Lead_Recruiter__r.Email != NULL && objRqrmntAssgnmnt.Lead_Recruiter__r.Email != '' ? objRqrmntAssgnmnt.Lead_Recruiter__r.Email:'')) + ' ' +
                                
                                (objRqrmntAssgnmnt.Recruiter__r.phone!=NULL && objRqrmntAssgnmnt.Recruiter__r.phone!='' ? objRqrmntAssgnmnt.Recruiter__r.phone:
                                (objRqrmntAssgnmnt.Lead_Recruiter__r.Phone != NULL && objRqrmntAssgnmnt.Lead_Recruiter__r.Phone != '' ? objRqrmntAssgnmnt.Lead_Recruiter__r.Phone:''));

            System.debug('strDtlsToPost-----------'+strDtlsToPost);  
            mapAuthDtls = new Map<String,String>();
            mapAuthDtls.put('access_token',FBAppDtls.AccessToken__c ); 
            mapAuthDtls.put('message',strDtlsToPost);    
            mapAuthDtls.put('sk', 'posts_to_page');   
            mapAuthDtls.put('scope', 'read_stream');
            
            String endpoint = 'https://graph.facebook.com/'+FBAppDtls.UserId__c+'/feed'+'/';
            System.debug('EndPoint----------------->'+endpoint);

            Http objHttp = new Http();
            HttpRequest objHttpReq = new HttpRequest();           
            objHttpReq.setEndpoint(endpoint);
            objHttpReq.setTimeOut(120000);
            objHttpReq.setMethod('POST');
            System.debug('mapAuthDtls---->' + mapAuthDtls);
            objHttpReq.setBody(convertAuthMaptoString(mapAuthDtls));
            if(Test.isRunningTest())
                return;
            HttpResponse objHttpResp = objHttp.send(objHttpReq);
            String strRsp = objHttpResp.getBody();
            System.debug('Response------------->'+strRsp );

            if(objHttpResp.getStatusCode() == 302)
            {
                strRsp = '{"data": [{"url": "'+objHttpResp.getHeader('Location')+'"},]}';
            }
            
        }
        
    }
   
    
    /* <OBJECTIVE>
    *  Method to create map of access token and the details to post
    *  </OBJECTIVE>   
    *  <RETURNS>  
    *   String    
    *  </RETURNS>
    */ 
    
    public static String convertAuthMaptoString(Map<String,String> mapAuthDtls)
    {
        System.debug('mapAuthDtls-->' + mapAuthDtls);
        String strFlag = '';
        for(String key : mapAuthDtls.keySet())
        {
            System.debug('key------->' + key);
                if(strFlag == ''){
                    //strFlag += '?';
            }
            else{
                strFlag += '&';
            }
            strFlag += key+'='+EncodingUtil.urlEncode(mapAuthDtls.get(key), 'UTF-8');
        }
        System.debug('strFlag---->' + strFlag);
        return strFlag;
    }
    
    /* <OBJECTIVE>
    *  To create cookie
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