public class ZohoCallOutHandler {
    @future (callout=true)
    public static void afterInsert(set<id> accId) {
        List<Account> updateAcc = new List<Account>();
        list<WrapDetails> deatilWrap = new list<WrapDetails>();
        List<Account> acc = [select id, Name, BillingCity, BillingCountry, BillingState, Zoho_Id__c From account where id =:accId];
        String zohoId;
        string externalId;
        for(account a : acc){
            externalId = a.Zoho_Id__c;
            WrapDetails wd = new WrapDetails();
            if(a.Name == null || a.Name == ''){
                wd.Company_Name = '';
            }
            else{
                wd.Company_Name = a.Name;
            }
            if(a.billingcity == null || a.billingcity == ''){
                wd.Company_Location = '';
            }
            else{
                wd.Company_Location = a.billingcity;
            }
            if(a.BillingState == null || a.BillingState == ''){
                wd.State = '';
            }
            else{
                wd.State = a.BillingState;
                
            }
            if(a.BillingCountry == null || a.BillingCountry == ''){
                wd.Country = '';
            }
            else{
                wd.Country = a.BillingCountry;
                
            }
            deatilWrap.add(wd);
        }
        string wrapDetails = json.serialize(deatilWrap);
        string wrap = wrapDetails.removeStart('[');
        string objwrap = wrap.removeEnd(']');
        system.debug('test>>>>>>'+objwrap);
        
        HttpRequest accReq = new HttpRequest();
        HttpResponse res = new HttpResponse();
        accReq.setHeader('Content-Type','application/json');
        String endpoint ='';
        
        if(externalId == null){
            endpoint = 'https://people.zoho.com/people/api/forms/json/Account_Info/insertRecord?authtoken=77fa2d37ffaa108eb2a5e5831f90e2f9&inputData='+EncodingUtil.urlEncode(objwrap, 'UTF-8');
        }
        else{
            endpoint = 'https://people.zoho.com/people/api/forms/json/Account_Info/updateRecord?authtoken=77fa2d37ffaa108eb2a5e5831f90e2f9&inputData='+EncodingUtil.urlEncode(objwrap, 'UTF-8')+ '&recordId='+externalId;
        }
        
        system.debug('endpoint>>>>>>>>>>>'+endpoint);
        accReq.setEndpoint(endpoint);
        accReq.setMethod('POST');
        
        Http http = new Http();
        try {
            string resBody = '';
            if(Test.isrunningtest()==false){
                res = http.send(accReq);
            }
                System.debug('success=================='+res.getBody());
                resBody = res.getBody();
                system.debug('resBody=============='+resBody);
                system.JSONParser jp = JSON.Createparser(resBody);
                while(jp.nextToken() != null){
                    if(jp.getText() == 'pkId' ){
                        jp.nextToken();
                        zohoID = jp.getText();
                        system.debug('ZohoId======'+zohoID);
                    }
                }
                
                for(Account acnt : acc){
                    if(acnt.Zoho_Id__c == null || zohoID != null){
                        Account objAcc = new Account(id = acnt.id);
                        objAcc.Zoho_Id__c = zohoID;
                        updateAcc.add(objAcc);
                    }
                }
                update updateAcc;
          
        }
        catch(System.CalloutException e) {
            System.debug('Callout error: '+ e.getMessage());
            System.debug(res.toString());
        }
    }
    public class WrapDetails{
        string Company_Name;
        string Company_Location;
        string State;
        string Country;
    }
}