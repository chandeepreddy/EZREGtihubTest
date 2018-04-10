public class SendEmailController {
@AuraEnabled
    public static Candidate__c getCandidateId(Id recordId) 
    {                  
            return [SELECT Id,email__c FROM Candidate__c WHERE Id=:recordId];
           
          
    }
}