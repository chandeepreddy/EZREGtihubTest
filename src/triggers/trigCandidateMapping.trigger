trigger trigCandidateMapping on Candidate_Mapping__c (after update, after insert){
    Candidate_Mapping__c cm = Trigger.new[0];
    List<Candidate__c> updateCandidateList = new List<Candidate__c>();
    List<ContentVersion> listR = new List<ContentVersion>();
    Map<Id,ContentVersion> getCandidate = new Map<Id,ContentVersion>();
    set<Id> candidateIds = new Set<Id>();
    List<ContentVersion> listData = new List<ContentVersion>();    
    List<Candidate_Mapping__c> listCM = new List<Candidate_Mapping__c>();    
    
    
    if(Trigger.isInsert || Trigger.isUpdate){
    
        string contentId = Trigger.new[0].Id;        
        
        listCM = [Select Candidate__c from Candidate_Mapping__c where id = : contentId];//limit 1
        system.debug('size of the list.....'+listCM.size());
        
        for(Candidate_Mapping__c cm1 : listCM){
            candidateIds.add(cm1.Candidate__c);
        }
        listData = [Select Id,Candidate_Id__c from ContentVersion where Candidate_Id__c =: candidateIds];
        system.debug('size of the listData.......'+listData.size());
        
        for(ContentVersion cv: listData){
            //String cvId = cv.Candidate_Id__c;
            getCandidate.put(cv.Candidate_Id__c,cv);
        }
        
        for (Candidate_Mapping__c cm1 : listCM){
            //String rId = cm1.Candidate__c;
            //listR = [Select Id,Candidate_ID__c from ContentVersion where Candidate_Id__c =:cm1.Candidate__c];
            listR.add(getCandidate.get(cm1.Candidate__c));
            System.Debug('listR - Insert'+ listR);

            for(ContentVersion cv1 : listR){
            /* if(cv1.Candidate_ID__c == null)
                  {
                     cv1.adderror('candidate must be selected');      
                  }*/
                Candidate__c can = new Candidate__c();
                if(can.id != null)
                {
                //can.id = cv1.Candidate_Id__c;
                can.Resume_Attach__c = cv1.Id;
                system.debug('can.Resume_Attach__c - Trigger Insert' + can.Resume_Attach__c);
                updateCandidateList.add(can);
                }
                //update can;           
            }   
        }
        update updateCandidateList;
    }
    if(Trigger.isAfter)
    {
        if(Trigger.isInsert)
        {
        set<Id> reqIdSet=new set<Id>();         
        set<Id> candMapCrtdUserSet=new set<Id>();
        //Map of assign candidate created by user and list of assign candidate 
        map<Id,set<Id>>  assgnCandCrtdUsrMap =new  map<Id,set<Id>> ();    
        //map of requirement and assign candidate list 
        map<Id,list<Candidate_Mapping__c>>  assgnCandAndReqMap =new  map<Id,list<Candidate_Mapping__c>> ();    
        map<Id,list<Candidate_Mapping__c>> assgnCandUsrMap=new  map<Id,list<Candidate_Mapping__c>> (); 
        
        for(Candidate_Mapping__c CandMap:trigger.new)
        {        
           system.debug('-----------------------------Inserting candidate mapping Rec'+CandMap); 
           if(CandMap.RequirementAssignment__c==null)
           {               
               reqIdSet.add(CandMap.Requirement__c);
               candMapCrtdUserSet.add(CandMap.CreatedById);
               if(assgnCandAndReqMap.containskey(CandMap.Requirement__c))
                {
                    assgnCandAndReqMap.get(CandMap.Requirement__c).add(CandMap);
                }
               else
                {
                    assgnCandAndReqMap.put(CandMap.Requirement__c,new list<Candidate_Mapping__c>{CandMap});
                }
               
                if(assgnCandCrtdUsrMap.containskey(CandMap.Requirement__c))
                {
                assgnCandCrtdUsrMap.get(CandMap.Requirement__c).add(CandMap.CreatedById);
                }
                else
                {
                    assgnCandCrtdUsrMap.put(CandMap.Requirement__c,new set<Id>{CandMap.CreatedById});
                }
                 if(assgnCandUsrMap.containskey(CandMap.CreatedById))
                {
                assgnCandUsrMap.get(CandMap.CreatedById).add(CandMap);
                }
                else
                {
                    assgnCandUsrMap.put(CandMap.CreatedById,new list<Candidate_Mapping__c>{CandMap});
                }
            }
        }
        system.debug('Requirement id set of cand Mapping --------------'+reqIdSet);
        system.debug('--------------assigncandReqId&Candidate mapping Map'+assgnCandAndReqMap);
        system.debug('--------------assigncandReqId&Candidate mapping created by user set Map'+assgnCandCrtdUsrMap);
        system.debug('Assign Candidate Createdbyid--------'+candMapCrtdUserSet);
          
        list<RequirementAssignment__c> assignReqList=EZRE_Requirement_DataUtility.fetchAssgnReq(reqIdSet,candMapCrtdUserSet);
        system.debug('list of assign reqmnts--------------------'+assignReqList);
        
        //map of requirement id and requirement assignment list       
        map<Id,list<RequirementAssignment__c>>  assgnReqAndReqMap =new  map<Id,list<RequirementAssignment__c>> ();              
        set<Id>  assgnReqSet=new set<Id>();
        //map of recruiter Id and requirement assignment list  
        map<Id,list<RequirementAssignment__c>>  userMap =new  map<Id,list<RequirementAssignment__c>> ();  
        map<id,set<id>> reqUserMap=new map<id,set<id>>();
        
        for(RequirementAssignment__c  assgnReq:assignReqList)
        {
            //requirement id and assign requirement list
            if(assgnReqAndReqMap.containskey(assgnReq.Requirement__c))
            {
                assgnReqAndReqMap.get(assgnReq.Requirement__c).add(assgnReq);
            }
            else
            {
                assgnReqAndReqMap.put(assgnReq.Requirement__c,new list<RequirementAssignment__c>{assgnReq});
            }
           
            //lead and assign requirement
            if(assgnReq.Lead_Recruiter__c!=null)
            {
                 assgnReqSet.add(assgnReq.Lead_Recruiter__c);
                if(userMap.containskey(assgnReq.Lead_Recruiter__c))
                {
                    userMap.get(assgnReq.Lead_Recruiter__c).add(assgnReq);
                }
                else
                {
                    userMap.put(assgnReq.Lead_Recruiter__c,new list<RequirementAssignment__c>{assgnReq});
                }
                if(reqUserMap.containskey(assgnReq.Requirement__c))
                {
                    reqUserMap.get(assgnReq.Requirement__c).add(assgnReq.Lead_Recruiter__c);
                }
                else
                {
                    reqUserMap.put(assgnReq.Requirement__c,new set<Id>{assgnReq.Lead_Recruiter__c});
                }
            }
            
            if(assgnReq.Recruiter__c!=null)  //lead and assign requirement
            {
                assgnReqSet.add(assgnReq.Recruiter__c);
                if(userMap.containskey(assgnReq.Recruiter__c))
                {
                    userMap.get(assgnReq.Recruiter__c).add(assgnReq);
                }
                else
                {
                    userMap.put(assgnReq.Recruiter__c,new list<RequirementAssignment__c>{assgnReq});
                }
                 if(reqUserMap.containskey(assgnReq.Requirement__c))
                {
                    reqUserMap.get(assgnReq.Requirement__c).add(assgnReq.Recruiter__c);
                }
                else
                {
                    reqUserMap.put(assgnReq.Requirement__c,new set<Id>{assgnReq.Recruiter__c});
                }       
                
            }
            
        }
        system.debug('----------------assgnreq R and LR &AssgnReqMap'+reqUserMap);
        system.debug('------------------Req&AssignReq Map'+assgnReqAndReqMap);
        list<Candidate_Mapping__c> assgnCandToUpdate=new list<Candidate_Mapping__c>(); 
        
        for(Id req:reqIdSet)
        {
              //set<Id> assgnCandUsersList=assgnCandCrtdUsrMap.get(req);
            if(assgnReqAndReqMap.containskey(req))
            {
                if(reqUserMap.containskey(req))
                {
                    set<Id> assgnCandUsersList=reqUserMap.get(req);
                    system.debug('------------'+assgnCandUsersList);
                    for(id assgnCandUser:assgnCandUsersList)
                    {
                       system.debug('--------------assgnCandUser'+assgnCandUser);
                        if(userMap.containskey(assgnCandUser))
                        {
                            list<RequirementAssignment__c>  assignReqLst=userMap.get(assgnCandUser);
                            assignReqLst.sort();
                            system.debug('----------------------'+assignReqLst[0].id);
                            if(assgnCandUsrMap.containskey(assgnCandUser))
                            {
                                list<Candidate_Mapping__c> assignCandList=assgnCandUsrMap.get(assgnCandUser);
                                for(Candidate_Mapping__c assignCand:assignCandList)
                                {
                                    system.debug('--------------assignCandcreatedbyId'+assignCand.createdbyId);
                                    Candidate_Mapping__c  assignCandObj=new Candidate_Mapping__c();
                                    assignCandObj.id=assignCand.id;
                                    assignCandObj.RequirementAssignment__c=assignReqLst[assignReqLst.size()-1].id;
                                    assgnCandToUpdate.add(assignCandObj);   
                                }
                                system.debug('--------------------assgnCandToUpdate'+assgnCandToUpdate);
                            }
                        }   
                    }
                } 
            }
        }
         update assgnCandToUpdate; 
        }
        }
}