/**
* @author           Gnana Prakash G
* @version          1.0 
* @date             27-DEC-2017
* @Status           Developed
* @ModifiedBy       Anil
* @description      This is the controller for generating work order details excel
*
*/
global class ODS_WorkorderDetailsController
{
    public string AccountManagerName {get; set;}
    public string AccountPartnerName {get; set;}
    public string ExecutionPartnerName {get; set;}
    public string WorkOrderCategory {get; set;}
    public string WorkOrderHead {get; set;}
    public string ProjectType {get; set;}
    public string ProjectSubCategory {get; set;}
    public string ProjectName {get; set;}   
    public string ClientName {get; set;}
    public string ClientAddress1 {get; set;}
    public string ClientAddress2 {get; set;}
    public string ClientCity {get; set;}
    public string ClientState {get; set;}
    public string ClientZipCode {get; set;}
    public Double WorkorderBillRate {get; set;}
    public string WorkorderBillFrequency {get; set;}
    public string SubscriptionFee {get; set;}
    public string SubscriptionFeeFrequency {get; set;}
    public string MinimumBillableHoursPerMonth {get; set;}
    public string WorkorderPaymentTerms {get; set;}
    public string ProjectStartDate {get; set;}
    public string ProjectEndDate {get; set;}
    public string LcaRequired {get; set;}
    public string InvoiceSubmissionMode {get; set;}
    public string InvoiceContactName {get; set;}
    public string InvoiceContactEmail {get; set;}
    public string InvoiceContactAddress1 {get; set;}
    public string InvoiceContactAddress2 {get; set;}
    public string InvoiceContactCity {get; set;}
    public string InvoiceContactState {get; set;}
    public string InvoiceContactZipCode {get; set;}
    public string FollowupContactName {get; set;}
    public string FollowupContactEmail {get; set;}
    public string FollowupContactWorkPhone {get; set;}
    public string FollowupContactMobilePhone {get; set;}
    public string FollowupContactComments {get; set;}
    
    public Account Acct {get; set;}
    public ODS_WorkOrderSettings__c WOSettings {get; set;}
    public static string FileName {get; set;}
      
    
    public ODS_WorkorderDetailsController(ApexPages.StandardController controller) 
    {
        Account currentAcct = (Account)controller.getRecord();
        Acct = new Account();
        
        String AccObj = ApexPages.currentPage().getParameters().get('obj');
        system.debug('###AccountIds:' + currentAcct.Id);
        system.debug('###AccObj:' + AccObj );
        WOSettings = ODS_WorkOrderSettings__c.getValues('SFDC');
        
        if(AccObj != null && AccObj != '')
        {
            Map<String, Object> AccDeserializeMap = (Map<String, Object>) JSON.deserializeUntyped(AccObj);
            String AccDeserializeStr = JSON.serialize(AccDeserializeMap);
            try
            {
                SObject sObj = (SObject)JSON.deserialize(AccDeserializeStr, Sobject.class);
                System.debug(' sObject in Edit Mode: '+sObj);
                Acct = (Account) sObj;
            }
            catch(Exception ex)
            {
                
            }
        }
        else if(currentAcct.Id != null){
            Acct = ODS_Data_Utility.FetchWorkOrderAccount(currentAcct.Id);
        }
        
        if(Acct != null){
            GetWorkOrderDetails();
        }
    }
    
    /* Fetching all the data needed for the VF Page ODS_Workorder_Details.*/
    public void GetWorkOrderDetails()
    {
        AccountManagerName = Acct.Owner.Name;
        AccountPartnerName = WOSettings.Account_Partner_Name__c;
        ExecutionPartnerName = WOSettings.Execution_Partner_Name__c;
        WorkOrderCategory = WOSettings.Work_Order_Category__c;
        WorkOrderHead = WOSettings.Work_Order_Head__c;
        ProjectType = WOSettings.Project_Type__c;
        ProjectSubCategory = WOSettings.Project_Sub_Category__c;
        ProjectName = Acct.Name;
        ClientName = Acct.Name;
        ClientAddress1 = Acct.BillingStreet;
        ClientAddress2 = Acct.ShippingStreet;
        ClientCity = Acct.BillingCity;
        ClientState = Acct.BillingState;
        ClientZipCode = Acct.BillingPostalCode;
        WorkorderBillRate = WOSettings.Bill_Rate__c;
        WorkorderBillFrequency = WOSettings.Billing_Frequency__c;
        SubscriptionFee = string.valueOf(WOSettings.Subscription_Fee__c);
        SubscriptionFeeFrequency = WOSettings.Subscription_Fee_Frequency__c;
        MinimumBillableHoursPerMonth = string.valueOf(Acct.Minimum_billable_hours__c);
        WorkorderPaymentTerms = WOSettings.Payment_Terms__c;
        ProjectStartDate = string.valueOf(Acct.SOW_Status_Date__c);
        system.debug('Acct.SOW_Status_Date__c before'+Acct.SOW_Status_Date__c);
        if(Acct.SOW_Status_Date__c != null)
        {
            ProjectEndDate = string.valueOf((Acct.SOW_Status_Date__c).addDays(365));
        }
        system.debug('Acct.SOW_Status_Date__c after'+Acct.SOW_Status_Date__c);
        LcaRequired = string.valueOf(WOSettings.LCA_Required__c);
        InvoiceSubmissionMode = Acct.Invoice_Type__c;
        InvoiceContactName = Acct.InvoiceContact__r.Name;
        InvoiceContactEmail = Acct.InvoiceContact__r.Email;
        InvoiceContactAddress1 = Acct.InvoiceContact__r.MailingStreet;
        InvoiceContactAddress2 = Acct.InvoiceContact__r.OtherStreet;
        InvoiceContactCity = Acct.InvoiceContact__r.MailingCity;
        InvoiceContactState = Acct.InvoiceContact__r.MailingState;
        InvoiceContactZipCode = Acct.InvoiceContact__r.MailingPostalCode;    
    }
    
    /* This method will fire from process builder(ODS_Generate Work Order Email). */
    @InvocableMethod
    public static void SendWorkOrderEmail(List<string> AccountId)
    {
        system.debug('$$$Mail Invoked');
        Contact con;
        if(AccountId.size() > 0){
              List<String> lstToAddress = new List<String>();
              List<String> lstCcAddress = new List<String>();
              ODS_WorkOrderSettings__c WorkOrderSettings = ODS_WorkOrderSettings__c.getValues('SFDC');
              List<Messaging.singleEmailMessage> mails = new List<Messaging.singleEmailMessage>();

              List<Account> acctsToSendEmail = new List<Account>();
              acctsToSendEmail = [SELECT Id,Name,
                                  Owner.Name,
                                  BillingStreet,
                                  BillingCity,
                                  BillingState,
                                  BillingCountry,
                                  BillingPostalCode,
                                  ShippingStreet,
                                  Minimum_billable_hours__c,
                                  SOW__c,
                                  SOW_Status_Date__c,
                                  Customer_Engagement_Type__c,
                                  Invoice_Type__c,
                                  InvoiceContact__r.Name,
                                  InvoiceContact__r.Email,
                                  InvoiceContact__r.MailingStreet,
                                  InvoiceContact__r.MailingCity,
                                  InvoiceContact__r.MailingState,
                                  InvoiceContact__r.MailingCountry,
                                  InvoiceContact__r.MailingPostalCode,
                                  Account_Status__c,
                                  InvoiceContact__r.OtherStreet,
                                  User__c,User__r.Email, Primary_Customer_Contact__c, Primary_Customer_Contact__r.Email, IsSendWorkOrderEmail__c FROM Account WHERE Id =: AccountId];
        if(acctsToSendEmail.size() > 0){
               con = new Contact(LastName='Selva', Phone='044 6741 7600', AccountId=acctsToSendEmail[0].ID);
               insert con;    
        }
        for(Account acc : acctsToSendEmail){                   
               PageReference WOExcel = Page.ODS_Workorder_Details;        
               WOExcel.getParameters().put('Id',acc.Id);
               String JsonVal = JSON.serialize(acc);
               system.debug('JsonVal '+JsonVal);
               WOExcel.getParameters().put('Obj',JsonVal); 
               system.debug('Entered==='+acc.Account_Status__c );   
               system.debug('Entered==='+acc.Customer_Engagement_Type__c);   
               if(acc.Customer_Engagement_Type__c == 'ODS' && (acc.Account_Status__c == 'Active Customer' || acc.Account_Status__c == 'Customer') && acc.User__c != null && acc.Primary_Customer_Contact__c != null ){ 
                            /* We maintain targeted work_order email recepients in custom label(If multiple with comma seperated) */
                            String split_emailswithcomma = System.Label.Work_order_recipients;
                            if(split_emailswithcomma != null){
                                        List<String> splitted_emails = split_emailswithcomma.split(',');                                        
                                        if(splitted_emails.size() > 0  ){   
                                                for(String  email : splitted_emails){
                                                           lstCcAddress.add(email);
                                                }
                                        }
                                        else { lstCcAddress.add(split_emailswithcomma); }
                            }

                            FileName = acc.Name + '_' + WorkOrderSettings.Project_Sub_Category__c + '_' + WorkOrderSettings.Project_Type__c;
                            Blob body;
                            try { 
                                         body = WOExcel.getContent();
                                         System.debug('@@@@@@@@@body ------------'+body);
                            } 
                            catch (VisualforceException e) {
                                         System.debug('====exception==='+e.getmessage());
                                         body = Blob.valueOf('Work Order');
                            }
                            Messaging.EmailFileAttachment attachement = new Messaging.EmailFileAttachment();
                            attachement.setContentType('application/vnd.ms-excel');
                            attachement.setFileName('Internal Work Order_'+ FileName +'.xls');
                            attachement.setInline(false);
                            WOExcel.setRedirect(true);
                            attachement.Body = body; 
        
                            system.debug('##attachement in mail:' +attachement);
                            Messaging.singleEmailMessage mail = new Messaging.singleEmailMessage();
                            system.debug('lstToAddress +'+lstToAddress);
                            mail.setToAddresses(lstCcAddress);
                            
                            mail.setSenderDisplayName('Preludesys - ODS');
                            mail.setTargetObjectId(con.Id);
                            mail.setTreatTargetObjectAsRecipient(false);
                            mail.setWhatId(acc.Id);
                            mail.setSaveAsActivity(true);
                            mail.setSubject('Internal Work Order_'+ FileName);
                            String strHtmlBody = '<font face="Calibri " size="3"> Hi Team, <br/><br/>Please find attached the Work Order for ' + FileName ; 
                            strHtmlBody += '<br/><br/>Thanks, <br/><br/> PreludeSys <br/><br/> </font>';
                            mail.setHtmlBody(strHtmlBody);
                            mail.setFileAttachments(new Messaging.EmailFileAttachment[] {attachement});
                            mails.add(mail);
                }
            }
            try{                                            
                   Messaging.sendEmail(mails);
                   delete con;
                   for(Account acc : acctsToSendEmail){
                         if(acc.Customer_Engagement_Type__c == 'ODS' && (acc.Account_Status__c == 'Active Customer' || acc.Account_Status__c == 'Customer') && acc.User__c != null && acc.Primary_Customer_Contact__c != null ){ 
                                   acc.IsSendWorkOrderEmail__c = True ;      
                         }                 
                   }
                   update acctsToSendEmail;
            }
            catch(Exception e){
                         System.debug(e);
            }
 
        }       
    }
}