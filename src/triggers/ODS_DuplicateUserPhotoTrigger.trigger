/**
 * @author           Kalaiselvi R
 * @version          1.0 
 * @date             04-Nov-2016
 * @Status           Developed
 * @description      This is the trigger to avoid duplicate users in user photo object.
 */
 
trigger ODS_DuplicateUserPhotoTrigger on User_Photo__c (before insert, before update)
{  
     ODS_DuplicateUserPhotoController objDupeUserPhoto = new ODS_DuplicateUserPhotoController();
     
     if(Trigger.isInsert)
     { 
         objDupeUserPhoto.validateDupeUserPhoto(Trigger.new);
     } 
      if(Trigger.isupdate)
      {
        for(User_Photo__c  objUserPhoto : Trigger.new)
        {
            User_Photo__c  usrPhoto = Trigger.oldMap.get(objUserPhoto.id);
            string oldUserId = usrPhoto.user__C;            
            if(!oldUserId.equalsignorecase(objUserPhoto.user__C))
            {
                objDupeUserPhoto.validateDupeUserPhoto(Trigger.new);
            }
        }
        
    }
}