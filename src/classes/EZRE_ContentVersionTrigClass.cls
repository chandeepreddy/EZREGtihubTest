/*
 * @author           Indhu R,Shahida K
 * @version          1.0 
 * @date             30/01/2015
 * @Modified         18/02/2016
 * @description      This class is called in an Trigger for Asyncronous call
 */  
global class EZRE_ContentVersionTrigClass
{    
     /// OBJECTIVE
    /// Updating the Candidate Content Attachment and ts a future call method used in Trigger. 
    /// OBJECTIVE
    @future(callout=true)
    public static void updateCandtContent(ID ContentIdSet)
    {   
           List<candidate__c> CandLst = new List<candidate__C>();
            ContentVersion CntntVer =EZRE_Requirement_DataUtility.fetchCntVrsn(ContentIdSet); 
            system.debug('@@@@@@@@@@@@@@@@@@@@@@@@contentversion-'+CntntVer);                 
              
                    if(CntntVer.Candidate_ID__c != null || CntntVer.Candidate_ID__c != '')
                    {
                        system.debug('@@@@@@@@@@@@@@@@@CandidateId'+CntntVer.Candidate_ID__c );
                        Candidate__c objCandt = new Candidate__c(ID = CntntVer.Candidate_ID__c);
                        objCandt.Resume_Attach__c = CntntVer.Id;  
                        objCandt.ResumeAttachedDate__c=CntntVer.LastModifiedDate;  //update candidate resume attached field with content modified date   
                        system.debug('@@@@@@@@@@@@@@@@@Contentversion last modified date'+CntntVer.LastModifiedDate);        
                        update  objCandt;
                    }            
   }
    /*  @future(callout=true)
    public static void deleteCandtContent(set<ID> ContentIdSet)
    {  
    system.debug('@@@@@@@@@@@@@@@@@@@content version id class'+ContentIdSet);
        if(ContentIdSet.size()>0)
        {
           List<candidate__c> CandLst = new List<candidate__C>();
           //set<ID> CandLst = new List<candidate__C>();
          
            List<candidate__c>  CandList =EZRE_Requirement_DataUtility.fetchCand(ContentIdSet);
                        system.debug('@@@@@@@@@@@@@@@@@@@cndidate class'+CandList );    
               for(candidate__c Cand:CandList)
               { 
               system.debug('@@@@@@@@@@@@@@@@@@@cndidate class in loop'+Cand ); 
                        Candidate__c objCandt = new Candidate__c(ID = Cand.id);
                        objCandt.Resume_Attach__c = '';        
                                
                        CandLst.add(objCandt);
                } 
                 system.debug('@@@@@@@@@@@@@@@@@@@cndidate class in loop'+CandLst);         
                 update CandLst;
            }
     }*/
}