trigger candidatestartedupdate on Candidate_Mapping__c (after update) 
{

                if(Trigger.isUpdate)
                    {  
                    
                         string testId = Trigger.new[0].Id;
                          
                         system.debug('testId:' + testId);

                         set<ID> candidateids = New set<ID>();  
                          
                         system.debug('candidateids :' + candidateids);                      

                         set<ID> requirementids  = New set<ID>();
                          
                         system.debug('requirementids:' + requirementids); 
                          
                         List<Candidate_Mapping__c> cm1 = [select candidate__c,lr_id__c, requirement__c, status1__c,Candidate_started__c,Contract_End_Date__c,requirement__r.ownerid,createdbyid from Candidate_Mapping__c where id =:testId and MR_Status__c ='Approved' limit 1];

                         system.debug('cm1 size:' + cm1 .size());
                         for(Candidate_Mapping__c cm : cm1)
                               {                                       

                                  if (cm.Candidate_started__c == 'yes')
                                     {
                                        requirementids.add(cm.requirement__c);
                                        system.debug('requirementids:' + requirementids);

                                        candidateids.add(cm.candidate__c);
                                        system.debug('candidateids :' + candidateids); 
                                                  
                                     }
                               
                                  List<Requirement__c> reqlist = new List<Requirement__c>();
                                  reqlist  = [Select Id, won__c,CreatedById,ownerid from requirement__c where id in : requirementids limit 1];
                                  system.debug('reqlist size:' + reqlist.size());  
                                  
                                  List<RequirementAssignment__c> assignreq = new List<RequirementAssignment__c>();
                                  assignreq = [select Lead_Recruiter__c,recruiter__c,Requirement_Owner__c,createdbyid from RequirementAssignment__c where Requirement__c =:cm.requirement__c];                   
        
                                  List<Candidate__c> candidatelist = new List<Candidate__c>();
                                  candidatelist = [Select Id, Placed__c, Star_Candidate__c,Contract_End_Date__c,OwnerId from candidate__c where id =: candidateids limit 1];
                          
                                  system.debug('candidatelist size:' + candidatelist.size());
                                  
                          
                                  for(integer i = 0 ; i< reqlist.size(); i++)
                                           {
                                                 reqlist[i].won__c  = true; 
                                           }
        
                                  for(integer j = 0 ; j< candidatelist.size(); j++)
                                           { 
                                                 candidatelist[j].Star_Candidate__c = true; 
                                                 candidatelist[j].Placed__c = true;
                                                 candidatelist[j].Contract_End_Date__c =cm.Contract_End_Date__c ;
                                                 for(integer k=0; k<assignreq.size(); k++)
                                                    {
                                                      system.debug('lr id:' + assignreq[k].lead_recruiter__c );
                                                      system.debug('lrid1:' + cm.lr_id__c);
                                                      if( assignreq[k].lead_recruiter__c != null && assignreq[k].lead_recruiter__c == cm.lr_id__c )
                                                          {
                                                             candidatelist[j].ownerid = cm.lr_id__c;
                                                             break;
                                                          }
                                                      if( assignreq[k].lead_recruiter__c == null)
                                                          {
                                                            candidatelist[j].ownerid = cm.requirement__r.ownerid;
                                                          }
                                                    }    
                                             }       

                                  update reqlist;

                                  update candidatelist;
                              
                    }
             }
}