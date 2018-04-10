public with sharing class EZRE_CandidateResumeReports 
{
        public List<ContentVersion> lstContent { get; set;}
        public List<Candidate__c> lstCand {get; set;}
        
        public EZRE_CandidateResumeReports()
        {
                ExportReports();
        }
        
        public void ExportReports()
        {
                Set<Id> setDocId = new Set<Id>();
                for(ContentDocument Resume :[SELECT Id,LatestPublishedVersionId,ParentId,Title FROM ContentDocument WHERE ParentId = '0584000000003RrAAI'])
                {
                        setDocId.add(Resume.LatestPublishedVersionId);
                }
                system.debug('###Total Resumes:' +setDocId.size());
                system.debug('###Resumes Doc Id:' +setDocId);
                lstContent = new List<ContentVersion>(); 
                lstContent = [SELECT Id,Title, Candidate_ID__c, CreatedById, CreatedDate FROM ContentVersion WHERE Candidate_ID__c = null AND id IN:  setDocId];
                system.debug('###Resume without Candidates:' + lstContent.size());
                Set<Id> setCandidateId =  new Set<Id>();
                for(ContentVersion Content : [SELECT Id,Title, Candidate_ID__c, CreatedById, CreatedDate FROM ContentVersion WHERE Candidate_ID__c != null AND id IN:  setDocId])
                {
                        setCandidateId.add(Content.Candidate_ID__c);
                }
                system.debug('###Resume with Candidates:' + setCandidateId.size());
                system.debug('###Resume with Candidates Id:' + setCandidateId);
                lstCand = new List<Candidate__c> ();
                lstCand = [SELECT Candidate_Full_Name__c, Email__c,Id, Name FROM Candidate__c where Id NOT IN: setCandidateId];
                System.debug('###Candidates without Resume:' +lstCand.size()); 
                System.debug('###Candidates list without Resume:' +lstCand); 
                /* Set<Id> setMappedCandts = new Set<Id>();
                for(Candidate__c Candt: lstCand)
                {
                        List<List<SObject>> searchList = EZRE_Data_Utility.fetchSearchList(Candt.Candidate_Full_Name__c);        
                        ContentVersion[] contents = ((List<ContentVersion>)searchList[0]); //Conversion 
                        if(contents.size() > 0)
                        {
                                setMappedCandts.add(Candt.id);
                        }
                }
                System.debug('###Mapping Candidates:' +setMappedCandts.size());*/
        }

        public PageReference ExportCandidatesWithoutResume()
        {
                PageReference pgRef = page.EZRE_ExportCandidatesWithoutResume;
                pgRef.setRedirect(false);
                return pgRef;
        }
        
        public PageReference ExportResumeWithoutCandidates()
        {
                PageReference pgRef = page.EZRE_ExportResumeWithoutCandidates;
                pgRef.setRedirect(false);
                return pgRef;
        }
        
}