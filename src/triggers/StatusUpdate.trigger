/*
* @author           Soumya N,
* @version          1.0 
 * @date            08/10/2014
* @description      Trigger to update status on Candidate Mapping
*/ 
trigger StatusUpdate on Candidate_Mapping__c (before insert, before update) 
{

    public string strConvertedDate {get; set;}  
    if(Trigger.isInsert)
    {    
        for(Candidate_Mapping__c ac : Trigger.new)
        {        
            if(ac.Status1__c == 'Applied')
            {
                ac.Requirement_Owner_Email__c = ac.Req_Owner_Email__c; 
               
            }
            if (ac.LR_Status__c == 'Approved')
            {           
                ac.status1__c = 'LR Approved';
                ac.Manager_Email_ID__c = ac.Req_Owner_Email__c; 
                ac.LR_Status_Date__c = DateTime.now().format('MM-dd-yyyy  hh:mm a z', 'America/Los_Angeles');
            } 
            if (ac.LR_Status__c == 'Rejected')
            {
                ac.status1__c = 'LR Rejected';
                ac.Manager_Email_ID__c = ac.Req_Owner_Email__c;
                ac.LR_Status_Date__c = DateTime.now().format('MM-dd-yyyy  hh:mm a z', 'America/Los_Angeles');
            } 
            if (ac.MR_Status__c == 'Approved')
            {    
                ac.MR_Status1__c = 'Approved';
                ac.status1__c = 'Approved';
                ac.Manager_Email_ID__c = ac.Req_Owner_Email__c;
                ac.MR_Status_Date__c = DateTime.now().format('MM-dd-yyyy  hh:mm a z', 'America/Los_Angeles'); 
                ac.MR_Approved_Date__c=date.today();
            }       
            if (ac.MR_Status__c == 'Rejected')
            {
                ac.Manager_Email_ID__c = ac.Req_Owner_Email__c;
                ac.status1__c = 'Rejected';
                ac.MR_Status_Date__c = DateTime.now().format('MM-dd-yyyy  hh:mm a z', 'America/Los_Angeles');
            } 
        }
    } 
    if(Trigger.isUpdate)
    {
    
        for(Candidate_Mapping__c ac : Trigger.new)
        {           
            candidate_mapping__c ac1 = Trigger.oldMap.get(ac.ID);
            Map<Id,Candidate_Mapping__c> newContactMap = Trigger.newMap;  
            Map<Id,Candidate_Mapping__c> oldContactMap = Trigger.oldMap; 

            if (ac.LR_Status__c == 'Approved')
            {       
                ac.status1__c = 'LR Approved';
                ac.Manager_Email_ID__c = ac.Req_Owner_Email__c;
            } 

            if (ac.LR_Status__c == 'Rejected')
            { 
                ac.status1__c = 'LR Rejected';
                ac.Manager_Email_ID__c = ac.Req_Owner_Email__c;
            } 
            if(ac.LR_Status__c != ac1.LR_Status__c)
            { 
                ac.LR_Status_Date__c = DateTime.now().format('MM-dd-yyyy  hh:mm a z', 'America/Los_Angeles'); 
            }


            if (ac.MR_Status__c == 'Approved')
            {    
            
                for(Id contactId:newContactMap.keySet())     
                { 
                    //Loop through the map   
                    Candidate_Mapping__c myNewContact = newContactMap.get(contactId);  
                    Candidate_Mapping__c myOldContact = oldContactMap.get(contactId);    
                    if (myNewContact.MR_Status__c <> myOldContact.MR_Status__c)  
                    {
                        ac.MR_Status1__c = 'Approved';
                    
                    }
                    else
                    {
                        ac.MR_Status1__c = 'None';
                    }
                } 
                ac.status1__c = 'Approved';
                ac.Manager_Email_ID__c = ac.Req_Owner_Email__c; 

            }       

            if (ac.MR_Status__c == 'Rejected' && ac.MR_Status__c != ac1.MR_Status__c)
            {
                ac.Manager_Email_ID__c = ac.Req_Owner_Email__c;
                ac.status1__c = 'Rejected';
            
            } 
            if( ac.MR_Status__c != ac1.MR_Status__c)
            {
                ac.MR_Status_Date__c = DateTime.now().format('MM-dd-yyyy  hh:mm a z', 'America/Los_Angeles');
                if(ac.MR_Status__c=='Approved')
                {
                    ac.MR_Approved_Date__c=date.today();
                }
            }

            if (ac.Submitted_to_Client__c == 'Yes')
            {       
                ac.status1__c = 'Submitted to Client';            
                ac.Priority__c = 'a';
            }

            if (ac.Submitted_to_Client__c == 'No')
            {       
                ac.status1__c = 'Not Submitted to Client';            
                ac.Priority__c = 'a'; 

            }    
            if(ac.Submitted_to_Client__c != ac1.Submitted_to_Client__c)
            {
                ac.Submitted_to_Client_Date__c= DateTime.now().format('MM-dd-yyyy  hh:mm a z', 'America/Los_Angeles'); 
            }

            if (ac.Interview_Scheduled__c == 'Yes' )
            {       
                ac.status1__c = 'Interview Requested';             
                ac.Priority__c = 'b';  
            } 
            if (ac.Interview_Scheduled__c == 'No')
            {       
                ac.status1__c = 'Not Shortlisted For Interview';             
                ac.Priority__c = 'b';    
             
            } 

            if(ac.Interview_Scheduled__c != ac1.Interview_Scheduled__c)
            {
                ac.Interview_Scheduled_Date__c= DateTime.now().format('MM-dd-yyyy  hh:mm a z', 'America/Los_Angeles'); 
            }

            if (ac.Interview_Accepted__c == 'Yes')
            {       
                ac.status1__c = 'Interview Accepted';                   
                ac.Priority__c = 'c';               
            } 

            if (ac.Interview_Accepted__c == 'No')
            {       
                ac.status1__c = 'Candidate Not Available';                   
                ac.Priority__c = 'c';              
            }

            if(ac.Interview_Accepted__c != ac1.Interview_Accepted__c)
            {
                ac.Interview_Accepted_Date__c= DateTime.now().format('MM-dd-yyyy  hh:mm a z', 'America/Los_Angeles'); 
            }

            if (ac.Client_Interviewed__c == 'Yes')
            {       
                ac.status1__c = 'Client Interviewed';                    
                ac.Priority__c = 'd';                        
            } 


            if (ac.Client_Interviewed__c == 'No')
            {       
                ac.status1__c = 'Client Did Not Interview';                    
                ac.Priority__c = 'd';             
            } 

            if(ac.Client_Interviewed__c != ac1.Client_Interviewed__c)
            {
                ac.Client_Interview_Date__c= DateTime.now().format('MM-dd-yyyy  hh:mm a z', 'America/Los_Angeles'); 
            }

            if (ac.Client_Offered__c == 'Yes')
            {       
                ac.status1__c = 'Client Offered';               
                ac.Priority__c = 'e';                
            } 

            if (ac.Client_Offered__c == 'No')
            {       
                ac.status1__c = 'Interviewed and rejected';               
                ac.Priority__c = 'e';             
            }

            if(ac.Client_Offered__c != ac1.Client_Offered__c)
            {
                ac.Client_Offer_Date__c= DateTime.now().format('MM-dd-yyyy  hh:mm a z', 'America/Los_Angeles'); 
            }

            if (ac.Candidate_started__c == 'Yes')
            {       
                ac.status1__c = 'Candidate started';                  
                ac.Priority__c = 'f';
            
            } 

            if (ac.Candidate_started__c == 'No')
            {       
                ac.status1__c = 'Candidate did not start';                  
                ac.Priority__c = 'f';                 
            }

            if(ac.Candidate_started__c != ac1.Candidate_started__c)
            {
                ac.started_date__c= DateTime.now().format('MM-dd-yyyy  hh:mm a z', 'America/Los_Angeles'); 
            } 
        
        }   
    }
    //Changes Done By Gangadhar 
    //Purpose:For FTE Details Validations.
    
    /*if(Trigger.isInsert || Trigger.IsUpdate)
    { 
        set<ID> setReqId = new Set<ID>();
        set<ID> setCanId = new Set<ID>();
        for(Candidate_Mapping__c CanMap : Trigger.new)
        {
            setReqId.add(CanMap.Requirement__c);
            setCanId.add(CanMap.Candidate__c);
        }
             List<Requirement__c> lstReq = [select name,FTE__c from Requirement__c where id IN:setReqId];
             List<Candidate__c> lstCan = [select name,FTE__c from Candidate__c where id IN: setCanId];
             for(requirement__c req:lstReq)
             {
                 for(Candidate__c cand:lstCan )
                 {
                     if(Req.FTE__c == True && Cand.FTE__c == False)
                    {
                        for(Candidate_Mapping__c AssCand : Trigger.new)
                        {
                            AssCand.AddError('FTE Requirement Needs FTE Field in Candidate Profile to be checked');
                        }
                    }
                     
                 }  
             }
    }*/
}