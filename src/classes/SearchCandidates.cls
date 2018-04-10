public with sharing class SearchCandidates
{ 
     
    public Boolean myCheckbox { get; set; }
    public String inputValue { get; set; }
    public List<Candidate__c> candidates {get; set;}
    public List<ContentDocument> contentdocs {get; set;}
    public String UserEmail {get; set;}
    
     
    // for pagination
    public Integer pageSize {get;set;}
    public Integer currentPage  {get;set;}
    public String currentPageInfo   {get;set;}
    
    // for disabling pagination links
    public Boolean showPrevious {get;set;}
    public Boolean showNext {get;set;}
    
    private Integer totalRecords;
    private Integer pageNumber; 
    public List<SearchCandidateWrapper> srch_wrap {get;set;}
    ApexPages.Message myMsg {get;set;}
   
    Public class SearchCandidateWrapper{
    
    public candidate__c candate{get;set;}
    public List<ContentDocumentLink> contdoc{get;set;}
    public Boolean contentListSize {get;set;}
    public String contentNilString {get;set;}
    public Boolean contentFileSize {get;set;}
   
   
    public SearchCandidateWrapper(candidate__c c,List<ContentDocumentLink> cd){
    candate = c;
    
    if(cd.size() == 0)
    contentFileSize = false;
    else
    contentFileSize = true;
    
    contdoc = cd;
    contentNilString = '-';
    
    if(c.content__r.size() == 0)
    contentListSize = false;
    else
    contentListSize = true;
    }
    
    }                 

    public PageReference search()    
      { 
          string uid= UserInfo.getUserId(); 
          User emailAddress =[SELECT Email FROM User WHERE ID = :uid];
          UserEmail = emailAddress.Email;
          getCandidates();
          return null; 
      }
      
    

 
    public void getCandidates()
      {
        Try
        {    
                             
             List<List<SObject>> searchList = [FIND :inputValue IN ALL FIELDS RETURNING ContentVersion(Candidate_ID__c)];         
             
             List<Id> convertIds = new List<Id>();     
             string canid;                    
             ContentVersion[] contents = ((List<ContentVersion>)searchList[0]); //Conversion
             
             system.debug(Logginglevel.info,'contents disp'+contents.size());
             
                                 
             List<ID> refAccs = new List<ID> ();   
             for (ContentVersion z: contents )    
             {
                refAccs.add(z.Candidate_ID__c);
                
                if(z.Candidate_ID__c != null)
                convertIds.add(z.Candidate_ID__c);
             }
             
             
             List<List<SObject>> searchList1 = EZRE_Requirement_DataUtility.getCandidatelist(inputValue);
             List<Candidate__c> candid_Id = EZRE_Requirement_DataUtility.getCandidatequery(searchList1[0]);
             for(Candidate__c ca_id : candid_Id){
             convertIds.add(ca_id.id);
             refAccs.add(ca_id.id);
             }
             
             List<List<SObject>> searchList2 = EZRE_Requirement_DataUtility.getContentDocument(inputValue);
             List<ContentDocument> contdocobj = EZRE_Requirement_DataUtility.getContentDocumentquery(searchList2[0]);
             List<Id> contdocids = new List<id>();
             for(ContentDocument cd : contdocobj){
             contdocids.add(cd.id);
             }
             List<ContentDocumentLink> s_Id = new List<ContentDocumentLink>();
             List<ContentDocumentlink> s_Id1 = new List<ContentDocumentLink>();
             
             if(contdocids.size() > 0)
             s_Id = EZRE_Requirement_DataUtility.getContentDocumentlinkquery(contdocids);
             
          /*   List<Id> contdocids1 = new List<id>();
             for(ContentDocumentLink cdl: s_Id){
             contdocids1.add(cdl.LinkedEntityId);
             }
             List<Candidate__c> c_id = [SELECT Id FROM Candidate__c WHERE Id IN: contdocids1];
             for(Candidate__c ca1_id : c_id){
             refAccs.add(ca1_id.id);
             } */
             
             for(ContentDocumentLink cdl : s_Id){
             system.debug(Logginglevel.info,'getsobjecttype disp'+cdl.linkedentityid);
             if(cdl.linkedentityid.getSobjectType() == Candidate__c.getSobjectType()){
             system.debug(Logginglevel.info,'getsobjecttype disp'+cdl.linkedentityid.getSobjectType());
             refAccs.add(cdl.linkedentityid);
             }
             }
             myCheckbox = false;
                                  
             
             candidates =Database.query('Select Id,Name,Last_Name__c,Skills__c,Visa_Type__c,Employer_Name__c,Mobile_Phone_No__c,Cost__c,Email__c, (select ContentDocumentID,ContentVersion.Title,ContentDocument.Title FROM Content__r) from Candidate__c where Id in :refAccs LIMIT 1000');                                  
             
             
             if(candidates.size() == 0){
             system.debug(Logginglevel.info,'Error display ');
             ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO,'No Rows returned');
             apexpages.addmessage(myMsg);
             }
             srch_wrap = new List<SearchCandidateWrapper>();
             
             if(convertIds.size() > 0)
             s_Id1 = EZRE_Requirement_DataUtility.getContentDocumentlinkFromCandidate(convertIds);
             
             for(candidate__c ca : candidates){
             List<ContentDocumentLink> cdoc = new List<ContentDocumentLink>();
             for(ContentDocumentLink cdlink: s_Id ){
             if(cdlink.LinkedEntityId == ca.id){
             cdoc.add(cdlink);
             }
             }
             for(ContentDocumentLink cdlink1: s_Id1 ){
             if(cdlink1.LinkedEntityId == ca.id){
             cdoc.add(cdlink1);
             }
             }
             
             srch_wrap.add(new SearchCandidateWrapper(ca,cdoc));
             }
             
             system.debug(Logginglevel.info,'SearchCandidateWrapper disp'+srch_wrap);
                 
             currentPage = 0;
             pageSize = 10;
             pageNumber = 1;
             showPrevious = false;
             totalRecords = candidates.size();
                 
                 boolean boolActivateValue = EZRE_Search_Candidate_Log_Activation__c.getInstance('SearchCandidateLog').Activate_Search_Candidate_Log__c;
                 system.debug('@@@@@@searchLogCusSetting'+boolActivateValue);
                 if(boolActivateValue)
                 {
                     list<Search_Candidate_Audit_Log__c> lstSearchCand = new List<Search_Candidate_Audit_Log__c>();
                  lstSearchCand = [select id,Searched_Value__c from Search_Candidate_Audit_Log__c where Searched_Value__c =:inputValue];
                  system.debug('@@@@@@listcandafterquerying'+lstSearchCand);
                  //if(lstSearchCand.size()<=0)
                 
                      system.debug('@@@@@@listcandafterqueryingenterinto the if condition '+lstSearchCand);
                      Search_Candidate_Audit_Log__c  objSearchCandAudLog = new Search_Candidate_Audit_Log__c();
                      objSearchCandAudLog.Name = userInfo.getName();
                      objSearchCandAudLog.Searched_Value__c = inputValue;
                      objSearchCandAudLog.Search_Count__c = totalRecords;
                      objSearchCandAudLog.Clicked_DateTime__c = datetime.now();
                      insert objSearchCandAudLog;
                  }   
             if(totalRecords > pageSize)
                showNext = true;
             else
                showNext = false;       
            
             currentPageInfo = 'Showing Page ' + pageNumber +   ' of ' + (Math.mod(totalRecords, pageSize) == 0 ? totalRecords/pageSize : (totalRecords/pageSize) + 1); 
             System.Debug('currentPageInfo ' +currentPageInfo);
        }
        catch(Exception ex)
        {
            String error = ex.getMessage();
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, error));
            if(srch_wrap != null)
            srch_wrap.clear();
            //system.debug('No input is entered');
        }
     }
     
   public void showPrevious()
    {
        currentPage = currentPage - pageSize;
        pageNumber--;
        enableDisablePaginationLinks();     
    }
    
   public void showNext()
    {
        currentPage = currentPage + pageSize;
        pageNumber++;
        enableDisablePaginationLinks();
    }
    
   public void showFirst()
    {
        currentPage = 0;
        pageNumber = 1;
        enableDisablePaginationLinks();
    }
    
   public void showLast()
    {
        currentPage = (Math.mod(totalRecords, pageSize) == 0) ? totalRecords - pageSize : (totalRecords / pageSize) * pageSize;
        pageNumber = (Math.mod(totalRecords, pageSize) == 0 ? totalRecords/pageSize : (totalRecords/pageSize) + 1);
        enableDisablePaginationLinks();
    }
    
   private void enableDisablePaginationLinks()
    {
        if(currentPage == 0)
        {
            showPrevious = false;
        }
        else
        {
            showPrevious = true;
        }   
        if((totalRecords - pageSize) <= currentPage)
        {
            showNext = false;
        }
        else
        {
            showNext = true;
        }
        currentPageInfo = 'Showing Page ' + pageNumber +   ' of ' + (Math.mod(totalRecords, pageSize) == 0 ? totalRecords/pageSize : (totalRecords/pageSize) + 1);
    }    
         
 }