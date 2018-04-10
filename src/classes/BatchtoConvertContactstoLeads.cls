global class BatchtoConvertContactstoLeads implements Database.Batchable<sObject> 
{
    List<lead> newleadids=new list<lead>();
    global Database.QueryLocator start(Database.BatchableContext bc) 
        {
    
            List<string> statuses = new List<string> {'4a: Outcome - Not Interested','4b: Outcome - Meeting Cancelled','4c: Outcome - Meeting Rescheduled', '4d: Outcome: Meeting - No Answer', '4e: Outcome - Pending Referral', '5c: Outcome - ODS1 Not Responding', '5d: Outcome - Priority Offshore'};
String query = 'SELECT Id,Force_com__c,Account.Executive_Summary__c,Status__c,Account.BillingLongitude, Account.BillingLatitude, FirstName,LastName,Account.BillingCountry,Account.BillingState,Account.BillingPostalCode,Account.BillingCity,Account.BillingStreet,Account.Website,Number_Validation__c,Account.Account_Status__c,Account.Description,Account.AnnualRevenue,Account.Name,Account.NumberOfEmployees,Salutation,Title,MobilePhone,Phone,Email,HasOptedOutOfEmail,Lead_Gen_Name__c,LeadSource,Inside_SalesRep__c,Description,If_Others_Please_Specify__c,IsContactConvertedtoLead__c,Account.Industry FROM Contact WHERE  IsContactConvertedtoLead__c =false AND status__c in: statuses and isDoNotDelete__c = false AND Force_com__c = true';
    
    return Database.getQueryLocator(query);
            
        }
    
global void execute(Database.BatchableContext bc, List<Contact> contact)
{
    System.debug('---------------- '+contact);
    Map<string, Integer> mapstatus = new  Map<string, Integer>();
    sObjectType SObjectName =  Contact.getSObjectType();
    Schema.DescribeSObjectResult objectSchema = SObjectName.getDescribe(); 
    map<String, Schema.SObjectField> fieldMap = objectSchema.fields.getMap(); 
    List<Schema.PicklistEntry> pickListValueList = fieldMap.get('Status__c').getDescribe().getPickListValues();
    
    integer i;
    i=1;
   
    for (Schema.PicklistEntry picklistVal: pickListValueList)
    {
        mapstatus.put(picklistVal.getLabel(),i);
        i = i+1;
    }
        system.debug('##mapstatusValue:' +mapstatus); 

         List<Lead> lstlead = new List<Lead>();
             for(Contact con: contact)
             {
                Lead lead =new Lead();
                    lead.FirstName= con.FirstName;
                    lead.LastName= con.LastName;
                    lead.Company=con.Account.Name;
                    lead.Status_in_Account__c=con.Account.Account_Status__c;
                 
                   //lead.Description2__c=con.Account.Description;
                   
                   //lead.Lead_Profile__c =con.description;
                     lead.Description =con.description;

                    lead.Salutation= con.Salutation;
                    lead.Title= con.Title;
                    lead.Executive_Summary__c = con.Account.Executive_Summary__c;
                    lead.MobilePhone=con.MobilePhone;
                    lead.Phone=con.Phone;
                    lead.Email= con.Email;
                    lead.HasOptedOutOfEmail=con.HasOptedOutOfEmail;
                    lead.Lead_Gen_Name__c=con.Lead_Gen_Name__c;
                    lead.LeadSource=con.LeadSource;
                    lead.Inside_Sales_Rep__c='';
                    lead.Industry=con.Account.Industry;
                    lead.NumberOfEmployees=con.Account.NumberOfEmployees;
                    lead.AnnualRevenue=con.Account.AnnualRevenue;
                    lead.Description=con.Account.Description;
                    lead.If_Others_Please_Specify__c=con.If_Others_Please_Specify__c;
                    lead.Number_Validation__c=con.Number_Validation__c;
                    lead.Website=con.Account.Website;
                    lead.Street=con.Account.BillingStreet;
                    lead.City=con.Account.BillingCity;
                    lead.PostalCode=con.Account.BillingPostalCode;
                    lead.State=con.Account.BillingState;
                    lead.Country=con.Account.BillingCountry;
                    lead.Latitude=con.Account.BillingLatitude;
                    lead.Longitude=con.Account.BillingLongitude;
                    lead.Status=con.Status__c;     
                    lead.Contact_Id__c= con.Id;
                    lead.IsContactConvertedasLead__c=True;
                 lstlead.add(lead);
             }
     Database.SaveResult[] srList = database.insert(lstlead,false);
     string ErrorString = '';
     
        // Iterate through each returned result
        for (Database.SaveResult sr : srList) {
        system.debug('$$sr '+sr );
            if (sr.isSuccess()) {
                // Operation was successful, so get the ID of the record that was processed
                System.debug('Successfully inserted Lead. Lead ID: ' + sr.getId());
               
            }
            else {
                // Operation failed, so get all errors                
                for(Database.Error err : sr.getErrors()) {
                    System.debug('The following error has occurred.');                    
                    System.debug(err.getStatusCode() + ': ' + err.getMessage());
                    ErrorString +=err.getStatusCode() + ': ' + err.getMessage();
                    System.debug('Lead fields that affected this error: ' + err.getFields());
                }
            }
        }
     
        List<lead> newleadids= [select Id,Contact_Id__c from Lead where Id IN:lstlead ];
        Map<Id,Id> mapleadid = new Map<Id,Id>();
        for(Lead newlead :newleadids)
        {
         mapleadid.put(newlead.Contact_Id__c,newlead.Id);
        }
         for(Contact con: contact)
             {
                if(mapleadid.containskey(con.Id))
                 {
                     String leadid =mapleadid.get(con.Id);
                     con.Lead_Id__c=leadid;
                     con.IsContactConvertedtoLead__c =true;
                     con.isDoNotDelete__c = true;
                 }else{
                    con.Lead_Id__c='Error';
                 }
             }
        Update contact;
       // }
      /*  catch(DmlException e) {
    System.debug('The following exception has occurred: ' + e.getMessage());
}*/
}
global void finish(Database.BatchableContext bc) 
    {  
      
    }
}