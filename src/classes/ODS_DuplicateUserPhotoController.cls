/**
 * @author           Kalaiselvi R
 * @version          1.0 
 * @date             04-Nov-2016
 * @Status           Developed
 * @description      This is the controller for ODS_DuplicateUserPhotoTrigger to avoid duplicate user on user photo object.
 */
 
public class ODS_DuplicateUserPhotoController
{ 
    /// <OBJECTIVE>
    /// validate user in user photo object to avoid duplication.
    /// </OBJECTIVE>
    public void validateDupeUserPhoto(List<User_Photo__c> userPhotoList)
    {
        set<Id> userId = new set<Id>();
         
        for (User_Photo__c objUserPhoto : userPhotoList)
        {
             userId.add(objUserPhoto.user__C);
        }
        List<User_Photo__c> oldUsrPhotoLst = new List<User_Photo__c>();
        oldUsrPhotoLst = ODS_Data_Utility.fetchUserPhotoByUserId(userId);
        
        for (User_Photo__c objUserPhoto : userPhotoList)
        {      
            for(User_Photo__c oldUserPhoto : oldUsrPhotoLst)
            {         
                if(objUserPhoto.User__c == oldUserPhoto.User__c)         
                {              
                    objUserPhoto.addError( oldUserPhoto.User__r.Name + ' is already exist');        
                }     
            } 
        }
    }
}