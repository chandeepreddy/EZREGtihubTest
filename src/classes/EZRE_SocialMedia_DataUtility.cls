/*
 * @author           Soumya & Indumathi
 * @version          1.0 
 * @date             11/11/2014
 * @description      Data utility class for LinkedIn and Facebook Integrations
 */  

public Class EZRE_SocialMedia_DataUtility
{
    //Fetch Facebook custom setting record
    public static FacebookDetails__c getFBAppDtls(String appName)
    {
        return(FacebookDetails__c.getValues(appName));
    }

    //Fetch Requirement record
    public static Requirement__c getRequirementDtls(String strRqmntId)
    {
        return([SELECT Id, Name,
                    Position_Type__c, 
                    City__c, 
                    State__c, 
                    Job_Description__c,
                    Experience__c,
                    Skill_Set__c 
                FROM 
                    Requirement__c 
                WHERE 
                    Id =: strRqmntId]);
    }
    
    //Fetch RequirementAssignment record
    public static RequirementAssignment__c getRqmntAssgnmnt(Id rqrmntId)
    {
        List<RequirementAssignment__c> lstReqAssgmnt = new List<RequirementAssignment__c>();
        lstReqAssgmnt = [SELECT Recruiter__r.Name, 
                            Recruiter__r.Email, 
                            Recruiter__r.phone, 
                            Lead_Recruiter__r.Name, 
                            Lead_Recruiter__r.Email, 
                            Lead_Recruiter__r.Phone 
                        FROM 
                            RequirementAssignment__c 
                        WHERE 
                            Requirement__c =: rqrmntId
                        ORDER BY 
                            CreatedDate desc];
        if(lstReqAssgmnt != NULL && !lstReqAssgmnt.isEmpty())
            return(lstReqAssgmnt[0]);
        else 
            return (new RequirementAssignment__c());
        
    }
    
    //Fetch LinkedIn Custom Settings record
    public static LinkedInDetails__c getLnkdnAppDtls(String appName)
    {
        return(LinkedInDetails__c.getValues(appName));
    }
    
    //Fetch MR Profile
    public static Id getMRProfileId(String profileName)
    {
        Profile profileObj = new Profile();       
        profileObj = [SELECT Id, Name
                        FROM 
                            Profile 
                        WHERE 
                            Name =: profileName];
        if(profileObj != NULL)
            return(profileObj.Id);
        else 
            return '';
        
    }
    
    //Fetch the count of RequirementAssignments related to a Requirement
    public Static Integer getCountRqmntAssgnmnt(String rqrmntId)
    {
        System.debug('rqrmntId--------------' + rqrmntId);
        Integer intCount = [SELECT COUNT() 
                    FROM 
                        RequirementAssignment__c 
                    WHERE 
                        Requirement__c =: rqrmntId];
        System.debug('return --------------->' + intCount);
        return intCount;
    }
}