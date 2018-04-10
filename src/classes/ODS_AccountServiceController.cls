/**
 * @author           Kalaiselvi R
 * @version          1.0 
 * @date             20-Oct-2016
 * @Status           Developed
 * @description      
 */
 
 public class ODS_AccountServiceController
 {
    public set<Id> accId {get;set;}
    public set<Id> usrId  {get;set;}
    public List<User_Account__c> usrLst {get;set;}
    public List<Account_Services__c> srvceLst {get;set;}
    
    /// <OBJECTIVE>
    /// Validate user in Account Service object to check whether the user is associated with the account or not.
    /// </OBJECTIVE>
    public void validateUserById(List<Account_Services__c> accSrvceLst)
    {
        accId = new set<Id>();
        usrLst = new List<User_Account__c>();
        srvceLst = new List<Account_Services__c>();
        
        for(Account_Services__c objAccSrvce: accSrvceLst)
        {
           accId.add(objAccSrvce.Account__C);
        } 

        usrLst = ODS_Data_Utility.fetchUserAccountByAcntId(accId);
        Set<string> setUserServiceId = new Set<string>();
        for(User_Account__c objUserLst: usrLst){
            setUserServiceId.add(objUserLst.User__c+','+objUserLst.ODS_Services__c);
        }

        for(Account_Services__c objAccSrvce: accSrvceLst)
        {
           string tamId = objAccSrvce.Technical_Account_manager__c; 
           string srvcId = objAccSrvce.ODS_Services__c; 
           if(!setUserServiceId.contains(tamId+','+srvcId))
               objAccSrvce.adderror('The User and Service is not associated with this account, Please add them in the User accounts');
        }
    }
    /// <OBJECTIVE>
    /// validate service name in Account Service object to avoid duplication.
    /// </OBJECTIVE>
    public void validateServiceById(List<Account_Services__c> accSrvceLst)
    {
        accId = new set<Id>();
        usrLst = new List<User_Account__c>();
        srvceLst = new List<Account_Services__c>();
        
        for(Account_Services__c objAccSrvce: accSrvceLst)
        {
           accId.add(objAccSrvce.Account__C);
        } 
        
        srvceLst = ODS_Data_Utility.fetchAccountServicesById(accId);
        
        for(Account_Services__c objAccSrvce: accSrvceLst)
        {
            for(Account_Services__c  acSrvce : srvceLst)
            {
                if(objAccSrvce.ODS_Services__c == acSrvce.ODS_Services__c)         
                {              
                    objAccSrvce.adderror('The service '+acSrvce.ODS_Services__r.Name__C+' is already exist for this accounts');      
                }  
            }
        }
    }  
 }