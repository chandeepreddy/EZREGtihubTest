public class CandidatesWithResume
{
      public List<wrapper> lstwrapper{get;set;}
     public List<Candidate__c> lstcand{get;set;}
    public CandidatesWithResume()
    {
        List<contentversion> objContentVersion = [Select Id,Title,FileExtension,Candidate_ID__c,LastModifiedDate from ContentVersion where Candidate_ID__c != ''];
        Set<ID> setIds = New Set<ID>();
        Set<ID> setCandIds = New Set<ID>();
        //lstFinalwrapper = new List<List<wrapper>>();
        map<String,Contentversion> mapcontent = new map<String,Contentversion>();
        for(ContentVersion conVersion :objContentVersion )
        {
           setIds.add(conVersion.Candidate_ID__c);
           mapcontent.put(conVersion.Candidate_ID__c,conVersion);
        }
        lstwrapper = new List<wrapper>();
        lstcand=[select id,name,Last_Name__c,download__c,Email__c,Home_Phone_No__c,Work_Phone_No__c,Mobile_Phone_No__c,resume_attach__c from candidate__c where  Id IN: setIds AND download__c = false LIMIT 999];
       
       
            for(candidate__c cand:lstcand)
            {
              
                    if(mapcontent.containskey(cand.Id))
                    {
                        
                        lstwrapper.add(new wrapper(cand,mapcontent.get(cand.Id)));
                        system.debug('======lstwrapper========='+lstwrapper);
                    }
                }     
               
    }
    public void updatecanddiates()
    {
        List<candidate__c> lstcandupdate = new List<candidate__C>();
           for(candidate__c cand:lstcand)
            {
               candidate__c objcand = new Candidate__c(id = cand.Id);
              
               objcand.download__c = true;
               lstcandupdate.add(objcand);
                }   
             update lstcandupdate;
    }
   public class wrapper
   {
        public contentversion cont{get;set;}
        public candidate__c cand{get;set;}
        public wrapper(Candidate__c candidate,ContentVersion content)
        {
          this.cont=content;
          this.Cand=candidate;
        }
   }
}