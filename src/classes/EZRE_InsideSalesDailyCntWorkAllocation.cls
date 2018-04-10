/**
 * @author           Kirankumar 
 * @version          1.0 
 * @date             26/04/2017
 * @Status           Developed
 * @description      Controller class for EZRE_salesteamDailycallList page to fetch work allocation object records and show to related ISR.
 */
public class EZRE_InsideSalesDailyCntWorkAllocation
{
    public String selectedFilter { get; set; }
    
    public String selectedTimeZone { get; set; }
    public String selectedRepName{ get; set; }
    public List<SelectOption> reasonforNotCalling {get;set;}
    public string reasonForNotCall {get;set;}
    public string Id {get;set;}
    public boolean hideColumn {get;set;}
    
    public List<Work_Allocation__c> acctsLst { get; set; }
    public List<selectOption> repNames{get;set;}
    List<String> repNamesLt = new List<String>(); 
    
    public  String campaign;
    public boolean iscalled;
    Map<String, Account_Call_List_Allocation__c> acntcallAllocationMap = Account_Call_List_Allocation__c.getAll();
    List<String> cmpnrepNames = new List<String>();
    List<string> campaigns = new List<string>();
    List<String> repNamesLst= new List<String>();
    Map<string,string> mapofRepNameWithCampgnName = new Map<string,string>();
    
    //<OBJECTIVE>
    //Method to fetch account records on page load that are assigned to each ISR
    //</OBJECTIVE>
    public EZRE_InsideSalesDailyCntWorkAllocation()
    {
          hideColumn = false;
          DateTime todayDt = system.today();
          Datetime currentDt = datetime.now(); // returns date time value in GMT time zone.
          reasonforNotCalling = new List<SelectOption>();
          reasonforNotCalling.add(new SelectOption('','None'));
          acctsLst = new List<Work_Allocation__c>();
          
          system.Debug('@@@acntcallAllocationMap '+acntcallAllocationMap );
          system.debug('@@#'+reasonForNotCall);
         
          for(Account_Call_List_Allocation__c acntAllc : acntcallAllocationMap.values())
          {
              String repNames = acntAllc.Account_ISR_Name__c;
              string repCmgnName = acntAllc.Name;
              system.Debug('@@@'+repNames);
              if(String.isNotBlank(repNames))
                repNamesLst = repNames.split(',');        
                for(string rep : repNamesLst )
                {
                    cmpnrepNames.add(rep );
                    mapofRepNameWithCampgnName.put(rep,repCmgnName );
                }
              system.Debug('repNamesLst1:==='+ repNamesLst);
          }
              
              system.Debug('mapofRepNameWithCampgnName:==='+ mapofRepNameWithCampgnName);
              system.Debug('repNamesLst2:==='+ cmpnrepNames);
                
           string selectedRepName = cmpnrepNames[0];
           system.Debug('selectedRepName========='+selectedRepName); 
           
           string selectedRepCpgnName = mapofRepNameWithCampgnName.get(selectedRepName);
           system.Debug('selectedRepCpgnName ========='+selectedRepCpgnName );
              
           for(string camp : acntcallAllocationMap.keyset())          
           {
               campaigns.add(camp);
           }
              
          system.debug('campaigns================'+campaigns);      
          repNames =new List<selectOption>();
          //repNames.add(new SelectOption('None','All'));
          if(cmpnrepNames.Size() >0)
          {
              for(String RepName : cmpnrepNames)
              {         
                  repNames.add(new SelectOption(RepName,RepName));  
              } 
          
          }    
          system.debug('repNames================'+repNames);   
          acctsLst =EZRE_Requirement_DataUtility.fetchWorkAllocation(selectedRepName ,selectedRepCpgnName); 

         system.debug('WorkallocationList================'+acctsLst );  
         
         schema.DescribeFieldResult fieldResult = Work_Allocation__c.Reason_for_not_calling__c.getDescribe();
         List<Schema.PicklistEntry> picklstEntry = fieldResult.getPicklistValues();
         
         for(Schema.PicklistEntry picklstValues : picklstEntry )
         {
             reasonforNotCalling.add(new SelectOption(picklstValues.getLabel(),picklstValues.getValue()));
         }
                  
         
    }
    //<OBJECTIVE>
    //Method to fetch work allocation records based on ISR user filter criteria.
    //</OBJECTIVE>
    public void filterAccounts()
    {
      
      system.debug('###campaigns '+campaigns );
      system.debug('###cmpnrepNames'+cmpnrepNames);
      
      string selectedRepCpgnName = mapofRepNameWithCampgnName.get(selectedRepName);
      system.Debug('selectedRepCpgnName ========='+selectedRepCpgnName ); 
      
      Boolean dlcondition = true;
      system.Debug('selectedRepName========='+selectedRepName); 
      acctsLst = new List<Work_Allocation__c>();
      String Query;

     
      if(selectedRepName != '')
      {
         
            Query = 'select id,name,Reason_for_not_calling__c,Contact__r.Name,Email__c ,CreatedDate,Phone__c,worked__C,Comments__c,status__c,TimeZone__c,Activity_Created_Date__c,account_name__C,Campaign__c,account_name__r.Name,Contact_Status__c,Account_Status__c,Contact_Title__c,Assigned_Account_Status__c,Assigned_Contact_Status__c from Work_Allocation__c where Name =: selectedRepName AND Is_Daily_CallList__c =: dlcondition AND Campaign__c =: selectedRepCpgnName';
           
            if(selectedTimeZone != 'null')
            {
                Query += ' AND TimeZone__C =: selectedTimeZone ';
            }
            
            if(selectedFilter != 'None')
            {
              iscalled = boolean.valueof(selectedFilter);
              Query += ' AND worked__C =: iscalled ';
            }
              Query += ' AND CreatedDate = Today Order By Activity_Created_Date__c';    
      }
     
      system.debug('###Query '+Query );
      acctsLst = database.Query(Query);
      system.debug('###acctsLst '+acctsLst );

    }
    
    //<OBJECTIVE>
    //Method to add reason for not calling in work allocation records
    //</OBJECTIVE>
    public void updateNotCallReason()
    {
        Work_Allocation__c wrkAllcton = new Work_Allocation__c();
        
        try
        {
            wrkAllcton.Id = Id;
            wrkAllcton.Reason_for_not_calling__c = reasonForNotCall ;
            update wrkAllcton;
        }
        
        catch (Exception EX)
        {
             system.debug('@@@@@@@DML Exception'+Ex);
        }
}
   
 }