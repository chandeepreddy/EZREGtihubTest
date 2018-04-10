public with Sharing class CustomAccountLookupController {
    


    
  public Account account {get;set;} // new account to create
  public List<Account> results{get;set;} // search results
  public string searchString{get;set;} // search keyword
 
  public Candidate__c candidate {get;set;}
  public List<Candidate__c> resultsCandidate {get;set;}
  //public CandidateOpportunityAssociation__c resultsCandidate {get;set;}
  public string searchCandidateString{get;set;}
  
  

  public CustomAccountLookupController() {
    account = new Account();
    candidate = new Candidate__c();
    // get the current search string
    searchString = System.currentPageReference().getParameters().get('lksrch');
    searchCandidateString = System.currentPageReference().getParameters().get('lksrch');
    runSearch();  
       
  }
 
  // performs the keyword search
  public PageReference search() {
    runSearch();
    return null;
  }
 
  // prepare the query and issue the search command
  private void runSearch() {
    // TODO prepare query string for complex serarches & prevent injections
    results = performSearch(searchString);  
    resultsCandidate = performSearch1(searchCandidateString); 
    //System.Debug('Results:' + results); 
    //System.Debug('Results Candidate:'+ resultsCandidate);       
  } 
 
  // run the search and return the records found. 
  private List<Account> performSearch(string searchString) {
 
    String soql = 'select id, name from Account';
    if(searchString!= '' && searchString!= null)
    string v = '%' + searchString+'%' ;
    soql = soql +  ' where name LIKE :v limit 25';
    System.debug(soql);
    return database.query(soql); 
 
  }

  private List<Candidate__c> performSearch1(string searchCandidateString) {
 
    String soql = 'select id, Name, Last_Name__c,Email__c,Cost__c,Location__c,Mobile_Phone_No__c, Skills__c,Visa_Type__c,OwnerId from candidate__c';
    if(searchCandidateString!= '' && searchCandidateString!= null)
    string k= '%' + searchCandidateString+'%';
    soql = soql +  ' where name LIKE :k limit 250';
    System.debug('SOQL:'+soql);
    return database.query(soql); 
 
  }
 
 
 
 // save the new account record
  public PageReference saveAccount() {
    // reset the account
    //insert candidate;
      // //candidate = new Candidate__c();  
    //PageReference acctPage = new PageReference('https://ap1.salesforce.com/a09/o');
    //acctPage.setRedirect(true);
    //return acctPage;
    PageReference acctPage = new PageReference('https://na2.salesforce.com/a0k/e');
    acctPage.setRedirect(true);
    return acctPage;
   }
 
 // Searching the Candidate
  //public PageReference Searching() {  
  //PageReference searchPage = new PageReference('https://na2.salesforce.com/_ui/common/search/client/ui/UnifiedSearchResults?');
  //PageReference searchPage = new PageReference('https://na2.salesforce.com/_ui/common/search/client/ui/UnifiedSearchResults?searchType=2&sen=068&sen=a12&sen=005&sen=a0l&sen=006&sen=a0k&str=ramesh&cache=h1660gr3#!/fen=a0k&initialViewMode=detail&str='); 
 // searchPage.setRedirect(true);  
  //return searchPage;
  //}  
  //public PageReference searchCandidate() {
 // PageReference searchPage = new PageReference('https://na2.salesforce.com/_ui/common/search/client/ui/UnifiedSearchResults?');     //https://na2.salesforce.com/_ui/common/search/client/ui/UnifiedSearchResults?searchType=2&sen=068&sen=a12&sen=005&sen=a0l&sen=006&sen=a0k&str=ramesh&cache=h1660gr3#!/fen=a0k&initialViewMode=detail&str= 
 // searchPage.setRedirect(true);  
 // return searchPage;
   
  //  }
  
  //public PageReference saveEdit() {
   //     PageReference editPage = new PageReference('https://na2.salesforce.com/a0990000006Dm7l');
   //     editPage.setRedirect(true);
   //     return editPage;
  //  }
  // used by the visualforce page to send the link to the right dom element
  public string getFormTag() {
    return System.currentPageReference().getParameters().get('frm');
  }
 
  // used by the visualforce page to send the link to the right dom element for the text box
  public string getTextBox() {
    return System.currentPageReference().getParameters().get('txt');
  }
  
 
}