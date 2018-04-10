trigger updateresumessubmitted on Candidate_Mapping__c (after insert, after update) 
{

  integer ressubmitted;
  integer ressubmitted1;
string UserId = UserInfo.getUserId();
        System.Debug('UserId =' + UserId);
        
        Candidate_Mapping__c cm = Trigger.new[0];
  
    List<Aggregateresult> ar= new List<Aggregateresult>();
    //Map<Integer,Aggregateresult> getRequirement = new Map<Integer,Aggregateresult>();
    set<Id> RequirementIds = new Set<Id>();
    List<Requirement__c> reqlist = new List<Requirement__c>();
    List<Candidate_Mapping__c> listCM = new List<Candidate_Mapping__c>();
    
  if(Trigger.isUpdate || Trigger.isInsert)
    {       
    
      string contentId = Trigger.new[0].Id;
      
      listCM = [Select Candidate__c, Requirement__c from Candidate_Mapping__c where id =:contentId];               

      for(Candidate_Mapping__c cm1 : listCM)
          {
              system.debug('cm1:' + cm1);

              RequirementIds.add(cm1.Requirement__c);
          }
                    
      reqlist = [Select Id, Submitted_Resumes__c, status__c,cumulative_resumes_submitted__c from requirement__c where id =:RequirementIds  limit 1];
      system.debug('reqlist  :' +reqlist);
                    
      ar = [SELECT count(Id) cnt FROM Candidate_Mapping__c where (Status1__c != 'rejected' and Status1__c != 'LR Rejected' ) and requirement__c in:RequirementIds];
      system.debug('ar:' +ar);
                    
                     for(AggregateResult ar1 : ar)
                      {
                        ressubmitted = Integer.valueOf(ar1.get('cnt'));
                        system.debug('ressubmitted :' +ressubmitted);
                        
                        for(requirement__c req : reqlist)
                        {
                             req.cumulative_resumes_submitted__c = ressubmitted;
                             system.debug('cumulative_resumes_submitted__c :' +  req.cumulative_resumes_submitted__c);
                             system.debug('status__c12 :'+ req.status__c);
                             if(req.status__c == 'Open')
                               {
                                    system.debug('status__c123 :'+ req.status__c);
                                    for(integer i = 0 ; i< reqlist.size(); i++)
                                      {
                                           reqlist[i].Submitted_Resumes__c = ressubmitted; 
                                      }
                               }

                            if(req.status__c == 'Re-open' )
                               { 
                                                 system.debug('status__c1 :'+ req.status__c);
                                                 system.debug('cm.Status1__c11 :'+ cm.Status1__c);
                                                 system.debug('submitted_resumes :' + req.Submitted_Resumes__c);
                                                 system.debug('cm.LRdate__c :' + cm.LRdate__c);
                                            if(cm.status1__c == 'applied' && cm.createdbyid == UserId  || cm.status1__c == 'LR Approved' && cm.createdbyid == UserId  || cm.status1__c == 'Approved' && cm.createdbyid == UserId )
                                             {
                                                 system.debug('status__c00:'+ req.status__c);
                                                 req.Submitted_Resumes__c = req.Submitted_Resumes__c + 1;
                                                 system.debug('submitted_resumes0 :' + req.Submitted_Resumes__c);
                                             }
                                             else if (cm.status1__c == 'LR Rejected' && cm.createdbyid == UserId && req.Submitted_Resumes__c == 0 || cm.status1__c == 'Rejected' && cm.createdbyid == UserId && req.Submitted_Resumes__c == 0)
                                              {
                                                  system.debug('status__c 1123:'+ req.status__c);
                                                  req.Submitted_Resumes__c = 0;
                                                  system.debug('submitted_resumes3 :' + req.Submitted_Resumes__c);
                                              }
                                             
                                            else if (cm.status1__c == 'rejected' || cm.status1__c == 'LR Rejected')
                                               {
                                                    // system.debug('cm.LRdate__c :' + cm.LRdate__c);
                                                     system.debug('status__c 1122:'+ req.status__c);
                                                     req.Submitted_Resumes__c = req.Submitted_Resumes__c - 1;
                                                     system.debug('submitted_resumes2 :' + req.Submitted_Resumes__c);
                                               } 
                                            else 
                                               {
                                                 system.debug('status__c 1121:'+ req.status__c);
                                                 req.Submitted_Resumes__c = req.Submitted_Resumes__c;
                                                 system.debug('submitted_resumes1 :' + req.Submitted_Resumes__c);
                                               }
                               }
                           
                          system.debug('cm.Status1__c :'+ cm.Status1__c);
                          system.debug('status__c :'+ req.status__c);
                          system.debug('submitted_resumes3 :' + req.Submitted_Resumes__c);
                             
                                                 upsert reqlist;
                        system.debug('reqlist1:' +reqlist);               

                 //}

              }             
          }
    }

}