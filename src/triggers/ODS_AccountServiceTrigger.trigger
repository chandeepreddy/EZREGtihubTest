/**
 * @author           Kalaiselvi R
 * @version          1.0 
 * @date             19-Oct-2016
 * @Status           Developed
 * @description      
 */
 
trigger ODS_AccountServiceTrigger on Account_Services__c (before insert, before update) {

    ODS_AccountServiceController objAccSrvce = new ODS_AccountServiceController();
    
    if(Trigger.isInsert)
    {
        objAccSrvce.validateUserById(Trigger.new);  
        objAccSrvce.validateServiceById(Trigger.new);      
    }
    
    if(Trigger.isupdate)
    {
        for(Account_Services__c objAcntSrvc: Trigger.new)
        {
            Account_Services__c accSrvc = Trigger.oldMap.get(objAcntSrvc.id);
            string oldTam = accSrvc.Technical_Account_manager__c;
            string oldSrvce = accSrvc.ODS_Services__c;
            
            if(!(oldTam.equalsignorecase(objAcntSrvc.Technical_Account_manager__c) && 
                    oldSrvce.equalsignorecase(objAcntSrvc.Technical_Account_manager__c)))
            {
                objAccSrvce.validateUserById(Trigger.new);
            }
            
            if(!oldSrvce.equalsignorecase(objAcntSrvc.ODS_Services__c))
            {
                objAccSrvce.validateServiceById(Trigger.new);
            }
        }
        
    }
}