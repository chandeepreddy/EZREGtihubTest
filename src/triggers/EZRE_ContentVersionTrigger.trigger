/**
 * @author           Indhu R,Shahida K
 * @version          1.0 
 * @date             30/1/2015
 * @Modified         18/02/2016
 * @Status           Developed
 * @description      Trigger to update Content on Candidate object.
 *
 */

trigger EZRE_ContentVersionTrigger on ContentVersion (after update,after delete) 
{
    if(Trigger.isAfter)
    {    
        
       /* if(Trigger.isDelete)
        {       
            set<ID> ContentIdSet = new Set<ID>();       
            for(ContentVersion  objContentVer : Trigger.old)
            {
                if(objContentVer.candidate_id__c != null || objContentVer.candidate_id__c != '')
                {
                    ContentIdSet.add(objContentVer.candidate_id__c);
                }
                 system.debug('@@@@@@@@@@@@@@@@@@@content version id after delete'+objContentVer.candidate_id__c);
            } 
             system.debug('@@@@@@@@@@@@@@@@@@@content version id after delete'+ContentIdSet);
            EZRE_ContentVersionTrigClass.deleteCandtContent(ContentIdSet);               
        }
*/
              
        if(Trigger.isUpdate)
        {     
           
            for(ContentVersion objContnVrsn: Trigger.new)
            {
               EZRE_ContentVersionTrigClass.updateCandtContent(objContnVrsn.Id);  
                 
            }
            
             
 
        }        
    } 
        
}