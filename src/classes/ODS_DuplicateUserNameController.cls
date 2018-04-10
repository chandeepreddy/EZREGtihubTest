/**
* @author           Kalaiselvi R
* @version          1.0 
* @date             20-Oct-2016
* @Status           Developed
* @description      This is the controller for ODS_DuplicateUserNameTrigger to avoid duplicate user on user account object.
*/

public class ODS_DuplicateUserNameController
{ 
    /// <OBJECTIVE>
    /// validate user name in user account object to avoid duplication.
    /// </OBJECTIVE>
    public void validateDupeUserName(List<User_Account__c> userList)
    {
        system.debug('@@@ validateDupeUserName' );
        set<Id> acntId = new set<Id>();
         
        for (User_Account__c usrAcc : userList)
        {
             acntId.add(usrAcc.Account__C);
        }
        List<User_Account__c> usrLst = new List<User_Account__c>();
        usrLst = ODS_Data_Utility.fetchUserAccountByAcntId(acntId);
        
        for (User_Account__c usrAcc : userList)
        {      
            for(User_Account__c ua: usrLst)
            {         
                if(usrAcc.User__c == ua.User__c && usrAcc.ODS_Services__c == ua.ODS_Services__c)         
                {              
                    usrAcc.addError( ua.User__r.Name + ' is already exist for this account');        
                }     
            } 
        }
    }
}