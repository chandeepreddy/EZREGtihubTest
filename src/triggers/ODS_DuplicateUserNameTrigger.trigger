/**
 * @author           Kalaiselvi R
 * @version          1.0 
 * @date             20-Oct-2016
 * @Status           Developed
 * @description      This is the trigger to avoid duplicate users in user account object.
 */
 
trigger ODS_DuplicateUserNameTrigger on User_Account__c (before insert, before update)
{  
     ODS_DuplicateUserNameController objDupeUserName = new ODS_DuplicateUserNameController();
     
     if(Trigger.isInsert)
     { 
         objDupeUserName.validateDupeUserName(Trigger.new);
     } 
      if(Trigger.isupdate)
      {
        for(User_Account__c  usrAcc : Trigger.new)
        {
            User_Account__c  ua = Trigger.oldMap.get(usrAcc.id);
            string oldUserName = usrAcc.user__C;            
            if(!oldUserName.equalsignorecase(usrAcc.user__C))
            {
                objDupeUserName.validateDupeUserName(Trigger.new);
            }
        }
        
    }
}