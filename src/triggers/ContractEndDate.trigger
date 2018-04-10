/**
 * @author           Keerthi R
 * @version          1.0 
 * @date             14/11/2013
 * @Status           Developed
 * @description      Trigger to update Contract End date on Candidate object.
 *
 */

trigger  ContractEndDate  on Candidate__c (after update,before Insert,before Update) 
{
  Candidate__c ca = Trigger.new[0];  
  if(Trigger.IsAfter)
  { 
	  if(Trigger.isUpdate)
	  { 
	        Map<Id,Candidate__c> newContactMap = Trigger.newMap;
	        System.debug('newContactMap:' +newContactMap);
	        Map<Id,Candidate__c> oldContactMap = Trigger.oldMap;
	         System.debug('oldContactMap:' + oldContactMap);
	         //Loop through the map
	        for(Id contactId:newContactMap.keySet())
	        { 
	            Candidate__c myNewContact = newContactMap.get(contactId);
	            System.debug('myNewContact :' +myNewContact );
	            Candidate__c myOldContact = oldContactMap.get(contactId);
	            System.debug('myOldContact :' + myOldContact );
	       
	            if(myNewContact.Contract_End_Date__c < myOldContact.Contract_End_Date__c)
	            {
	                trigger.new[0].Contract_End_Date__c.addError('Contract End date should be greater than the current contract end date​');
	            }
	            
	            if(myNewContact.Contract_End_Date__c <> myOldContact.Contract_End_Date__c)
	            {
	                if(ca.Contract_End_Date__c !=null)
	                {
	                   System.debug('Contract_End_Date__c:' + ca.Contract_End_Date__c);
	                   List<candidate_mapping__c> cm = new list<candidate_mapping__c>();
	                   cm = [select id, candidate__c,contract_end_date__c from candidate_mapping__c where candidate__c =:ca.id];
	                   
	                   for(candidate_mapping__c cm1 :cm)
	                   {
	                   cm1.id = cm1.id;
	                   cm1.contract_end_date__c = ca.Contract_End_Date__c;
	                   update cm1;  
	                   }   
	                   
	                            
	                } 
	            }
	        
	        }                     
	  }  
  }     
  

    if(Trigger.IsBefore)
    {
        
        Set<string> setEmailIds = new Set<string>();
        Set<string> setPhoneNumber = new Set<string>();
        if(Trigger.IsInsert)
        {
            
            for(Candidate__c Candidate: Trigger.New)
            {
                if(Candidate.Resume_Status__c != Null)
                {
                   Candidate.Resume_Status_Changed_Date__c = date.Today(); 
                }
                setEmailIds.add(Candidate.Email__c);
                setPhoneNumber.add(Candidate.Mobile_Phone_No__c);
            }
            List<Candidate__c> lstCandidatesByPhone =[select id,name,Mobile_Phone_No__c,Email__c 
                                                From Candidate__c
                                                Where Mobile_Phone_No__c IN: setPhoneNumber]; 
            if(lstCandidatesByPhone.Size() > 0)
            {
                try
                {
                   for(Candidate__c Can: Trigger.New)
                   {
                       
                       Can.AddError('Phone Number already Exists'); 
                   }
               }
               catch(DmlException Ex)
               {
                   system.Debug('Error Message:'+Ex);
               }
            }                                   
            List<Candidate__c> lstCandidatesByEmail =[select id,name,Mobile_Phone_No__c,Email__c 
                                                From Candidate__c
                                                Where Email__c IN: setEmailIds];    
            if(lstCandidatesByEmail.Size() > 0)
            {
                try
                {
                   for(Candidate__c Can: Trigger.New)
                   {
                       
                       Can.AddError('Email already Exists'); 
                   }
               }
               catch(DmlException Ex)
               {
                   system.Debug('Error Message:'+Ex);
               }
            }                                                   
           // system.Debug('@@@@@LstCandidates'+lstCandidatesByEmail );
            
        }
        if(Trigger.IsUpdate)
        {
            for(Candidate__c Cand: Trigger.New)
            {
                if (Trigger.oldMap.get(Cand.Id).Email__c != Trigger.newMap.get(Cand.Id).Email__c) 
                {
                    setEmailIds.add(Cand.Email__c);
                }    
                if (Trigger.oldMap.get(Cand.Id).Mobile_Phone_No__c != Trigger.newMap.get(Cand.Id).Mobile_Phone_No__c) 
                {
                    setPhoneNumber.add(Cand.Mobile_Phone_No__c);
                }
                if (Trigger.oldMap.get(Cand.id).Resume_status__c != Trigger.newMap.get(Cand.Id).Resume_status__c) 
                {
                    cand.Resume_Status_Changed_Date__c = date.Today();
                }                 
            }
            List<Candidate__c> lstCandidatesByPhone =[select id,name,Mobile_Phone_No__c,Email__c 
                                                From Candidate__c
                                                Where Mobile_Phone_No__c IN: setPhoneNumber]; 
            if(lstCandidatesByPhone.Size() > 0)
            {
                   for(Candidate__c Can: Trigger.New)
                   {
                       
                       Can.AddError('Phone Number already Exists'); 
                   }
               
            }                                   
            List<Candidate__c> lstCandidatesByEmail =[select id,name,Mobile_Phone_No__c,Email__c 
                                                From Candidate__c
                                                Where Email__c IN: setEmailIds];    
            if(lstCandidatesByEmail.Size() > 0)
            {
                   for(Candidate__c Can: Trigger.New)
                   {
                       
                       Can.AddError('Email already Exists'); 
                   }              
            }                   
            
        }
    }          
}