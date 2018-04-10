/**
 * @author           Shahida
 * @version          1.0 
 * @date             28/09/2015
 * @Status           Developed
 * @description      class to generate and export contact report for campaigns in account related campaign object.
 *
 */
Public class EZRE_CntctsRprtOnAccntRltdCmpgnCntrllr
{
    transient Public String selectedRep{get;set;}
    transient Public String selectedCampaign{get;set;}
    transient Public  List<contact> contactsList{get;set;}
    transient Public  List<Account_Related_Campaign__c> accntRltdCmpnList;
    Public List<Contact> contactsListToShow{get;set;}
    transient Public String ODSAWSContact{get;set;}
    transient  Public String TitleInsuranceContact{get;set;}
    transient Public Boolean isTitleInsurance{get;set;}
    transient Public Boolean isODSAWS{get;set;}
    
    public EZRE_CntctsRprtOnAccntRltdCmpgnCntrllr()
    {  
        contactsListToShow=new  List<Contact>();
        accntRltdCmpnList=new List<Account_Related_Campaign__c>();
    }
    ///<OBJECTIVE>
    ///Method to get List of Rep Names
    ///</OBJECTIVE>
    public List<SelectOption> getRepNames()
    {
       
        List<SelectOption> repOptions = new List<SelectOption>();
        Schema.DescribeFieldResult fieldResult = Account_Related_Campaign__c.Rep_Name__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        repOptions.add(new SelectOption('None','None'));
        for( Schema.PicklistEntry f : ple)
            repOptions.add(new SelectOption(f.getLabel(), f.getValue()));
        return repOptions;
        
    }
     ///<OBJECTIVE>
    ///Method to get List of Campaigns
    ///</OBJECTIVE>
    public List<SelectOption> getCampaigns()
    {
        
        List<SelectOption> CmpgnOptions = new List<SelectOption>();
        Schema.DescribeFieldResult fieldResult = Account_Related_Campaign__c.Campaign__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        CmpgnOptions.add(new SelectOption('None','None'));
        for( Schema.PicklistEntry f : ple)
            CmpgnOptions.add(new SelectOption(f.getLabel(), f.getValue()));
        return CmpgnOptions;
        
    }
     ///<OBJECTIVE>
    ///Method to check mandatory field
    ///</OBJECTIVE>
    Public void mandatoryCheck()
    {
          contactsList=new List<contact>();
          contactsListToShow.clear();  
          if(selectedRep=='None')
          {
              ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please Select RepName'));
          }
          else if(selectedCampaign=='None')
          {
               ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please Select Campaign'));
          }
          else
          {
              showReport();
          }
    }
    ///<OBJECTIVE>
    ///Method to show report
    ///</OBJECTIVE>
    Public void showReport()
    {    
         
          System.debug('RepName=================='+selectedRep);
          System.debug('campaign============'+selectedCampaign);    
         
           String queryARC='select Account__c,campaign__c,Rep_Name__c from Account_Related_Campaign__c  where '; 
           String queryContacts;
           isTitleInsurance=false;
           isODSAWS=false;
          if(selectedCampaign=='Title Insurance')
          {
               isTitleInsurance=true;
               queryContacts='Select Account.Id,Account.Name,Account.Account_Status__c,Account.TimeZone__c,firstName,lastName,Phone,MobilePhone,email,Title_Insurance__c,Title_Insurance_Status__c,ODS_AWS__c,ODS_AWS_Status__c,Title,Inside_SalesRep__c from contact where '; 
               queryContacts+='Title_Insurance__c=true'; 
               queryARC+='Rep_Name__c!=null AND campaign__c=:selectedCampaign AND Rep_Name__c=:selectedRep';
               accntRltdCmpnList=Database.query(queryARC);
               contactsList=Database.query(queryContacts); 
          }
          else if(selectedCampaign=='ODS AWS')
          { 
                isODSAWS=true;
                queryContacts='Select Account.Id,Account.Name,Account.Account_Status__c,Account.TimeZone__c,firstName,lastName,Phone,MobilePhone,email,Title_Insurance__c,Title_Insurance_Status__c,ODS_AWS__c,ODS_AWS_Status__c,Title,Inside_SalesRep__c from contact where '; 
                queryContacts+='ODS_AWS__c=true'; 
                queryARC+='Rep_Name__c!=null AND campaign__c=:selectedCampaign AND Rep_Name__c=:selectedRep';
                accntRltdCmpnList=Database.query(queryARC);
                contactsList=Database.query(queryContacts);
          }
         System.debug('contactsList============'+contactsList);
         System.debug('accntRltdCmpnList============'+accntRltdCmpnList);
         Map<String,List<contact>> accntContactsMap=new  Map<String,List<contact>>();  
         Map<String,List<Account_Related_Campaign__c>> accntARCMap=new  Map<String,List<Account_Related_Campaign__c>>();  
         
         //Build map on contacts list to get list of contacts of each account
         for(contact cntctObj:contactsList)
         {
              system.debug('cntctObj.account.Id============='+cntctObj.account.Id);
             if(cntctObj.account.Id!=null)
             {
                 if(accntContactsMap.containsKey(cntctObj.account.Id))
                 {
                      accntContactsMap.get(cntctObj.account.Id).add(cntctObj);
                 }
                 else
                 {
                      accntContactsMap.put(cntctObj.account.Id,new list<contact>{cntctObj});
                 }
                 system.debug('accntContactsMap============='+accntContactsMap);
             }
         }
         
          //Build map on account related campaign list to get list of account related campaign of each account
         for(Account_Related_Campaign__c accRltdCmpgnObj:accntRltdCmpnList)
         {
             if(accRltdCmpgnObj.account__c!=null)
             {
                 if(accntARCMap.containsKey(accRltdCmpgnObj.account__c))
                 {
                      accntARCMap.get(accRltdCmpgnObj.account__c).add(accRltdCmpgnObj);
                 }
                 else
                 {
                      accntARCMap.put(accRltdCmpgnObj.account__c,new list<Account_Related_Campaign__c>{accRltdCmpgnObj});
                 }
                 system.debug('accntARCMap============='+accntARCMap);
             }
         }
          //Build list of contacts for selected campaigns and RepName in account related campaign object.
          for(String accId:accntARCMap.Keyset()) 
          {
              system.debug('accId============='+accId);
              if(accntContactsMap.containsKey(accId))
              {
                  contactsListToShow.addAll(accntContactsMap.get(accId));
              }
            
          }
            system.debug('contactsListToShow============='+contactsListToShow.size());
        
    }
    ///<OBJECTIVE>
    ///Method to export report
    ///</OBJECTIVE>
    Public PageReference exportReport()
    {
    
        PageReference pgRef=new PageReference('/apex/EZRE_CntctsRprtOnAccntRltdCmpgnExcel');
        return pgRef;
    
    }

}