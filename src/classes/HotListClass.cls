public with sharing class HotListClass {
       
    private Candidate__c[] candidates;

    public HotListClass() { 
        List<Candidate__c> candidate = [SELECT Name, Last_Name__c, Skills__c, Location__c, Relocation__c, Availability__c FROM Candidate__c where Bench__c = true];
        string Name, LastName, Skills, Relocation, Availability;
        Boolean Success;
        candidates = new List<Candidate__c>();
        for(Candidate__c cand : candidate)
        {
            if(cand.Name != null)
            {
                string CandName = cand.Name;
                system.debug('CandidateName' +CandName);                
                Name = CandName.capitalize();                                        
                system.debug('CandName' + Name);                                
            }
            if(cand.Last_Name__c != null)
            {
                string CandLastName = cand.Last_Name__c;
                system.debug('CandidateLastName' +CandLastName);                
                LastName = CandLastName.capitalize();                                        
                system.debug('CandLastName' + LastName);                                
            }
            if(cand.Skills__c != null)
            {
                string CandSkills = cand.Skills__c;
                system.debug('CandidateSkills' +CandSkills);                
                Skills = CandSkills.capitalize();                                        
                system.debug('CandSkills' + Skills);                                
            }            
            if(cand.Relocation__c != null)
            {
                string CandRelocation = cand.Relocation__c;
                system.debug('CandidateRelocation' +CandRelocation);                
                Relocation = CandRelocation.capitalize();                                        
                system.debug('CandRelocation' + Relocation);                                
            }
            if(cand.Availability__c != null)
            {
                Date CandAvailability;
                try
                {
                    CandAvailability = Date.Parse(cand.Availability__c);
                    system.debug('CandidateAvailability' + CandAvailability );                    
                }
                catch(Exception e)
                {
                    Success = false;
                }
                if(Success == false)
                {     
                    string CandidAvailability = cand.Availability__c;
                    system.debug('CandidateAvailability' +CandidAvailability );                               
                    Availability = CandidAvailability.capitalize();                                        
                    system.debug('CandAvailability' + Availability); 
                    Success = true;                               
                }
                else
                {   
                    Availability = CandAvailability.Format();
                    system.debug('CandAvailability' + Availability);
                }
            }                    
            candidates.add(new Candidate__c(Name=Name,Last_Name__c=LastName,Skills__c=Skills,Current_City__c=cand.Location__c,Relocation__c=Relocation,Availability__c=Availability));
        }
    }

    public Candidate__c[] getCandidates() {
        return candidates;
    }
}