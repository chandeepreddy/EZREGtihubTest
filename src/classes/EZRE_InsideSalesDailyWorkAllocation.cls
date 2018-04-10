/**
 * @author           Gangadhar
 * @version          1.0 
 * @date             23/03/2016
 * @Status           Developed
 * @description      Controller class for EZRE_salesteamDailycallList page to fetch work allocation object records and show to related ISR.
 * @Modified By      Shahida M
 * @Modified Date    27.06.2016  
 */
public class EZRE_InsideSalesDailyWorkAllocation
{
    public String selectedFilter { get; set; }
    
    public String selectedTimeZone { get; set; }
    public String selectedRepName{ get; set; }
    
    list<Work_Allocation__c> workAlloc;
    public List<Work_Allocation__c> acctsLst { get; set; }
    public List<selectOption> repNames{get;set;}
    
    public  String campaign;
    public boolean iscalled;
    //<OBJECTIVE>
    //Method to fetch account records on page load that are assigned to each ISR
    //</OBJECTIVE>
    public EZRE_InsideSalesDailyWorkAllocation()
    {
    
          workAlloc=new List<Work_Allocation__c>();
          acctsLst = new List<Work_Allocation__c>();
          Map<String, Call_List_Allocation__c> callAllocationMap = Call_List_Allocation__c.getAll();
          Call_List_Allocation__c callAllocation = new Call_List_Allocation__c();
          User usr = EZRE_Data_Utility.fetchUser(UserInfo.getUserId());
          system.Debug('@@@usrDetails'+usr);
          system.Debug('@@@UserCampaign'+usr.Campaign__c);
          List<String> repNamesLst= new List<String>();
          List<String> repNamesSet= new List<String>(); 
          if(usr.Campaign__c !=null)
          {
              campaign=usr.Campaign__c;
              List<Call_List_Allocation__c> lstAllocation=new List<Call_List_Allocation__c>();
              lstAllocation.add(callAllocationMap.get(usr.Campaign__c));
                          
              if((lstAllocation.size()>0)&&(lstAllocation[0]!=null))
              {
                  callAllocation=callAllocationMap.get(usr.Campaign__c);
                  String repNames = callAllocation.Rep_Names__c;
                  system.Debug('@@@'+repNames);
                  if(String.isNotBlank(repNames))
                    repNamesLst = repNames.split(',');        
                  system.Debug('repNamesLst:==='+ repNamesLst);
              }
              for(String strRep:repNamesLst)     
              {
                if(String.isNotBlank(strRep))
                {
                    
                      repNamesSet.add(strRep);    
                }
             }
            system.Debug('Rep without Nulls:==='+ repNamesLst);
                    
          }
          repNames =new List<selectOption>();
          repNames.add(new SelectOption('None','All'));
          if(repNamesSet.Size() >0)
          {
              for(String RepName:repNamesSet)
              {         
                  repNames.add(new SelectOption(RepName,RepName));  
              } 
          
          }    
          system.debug('repNames================'+repNames);   
          acctsLst =EZRE_Requirement_DataUtility.fetchWorkAllocation(repNamesSet,usr.Campaign__c); 

         system.debug('WorkallocationList================'+acctsLst );   
    }
    //<OBJECTIVE>
    //Method to fetch work allocation records based on ISR user filter criteria.
    //</OBJECTIVE>
    public void filterAccounts()
    {
      
      User usr = EZRE_Data_Utility.fetchUser(UserInfo.getUserId());
      campaign = usr.Campaign__c;
      system.Debug('selectedRepName========='+selectedRepName); 
      acctsLst = new List<Work_Allocation__c>();
      String Query;
     
      if(selectedRepName != 'None')
      {
         
          Query = 'select id,name,worked__C,Comments__c,status__c,TimeZone__c,Activity_Created_Date__c,account_name__C,Campaign__c,account_name__r.Name from Work_Allocation__c where Name =: selectedRepName AND Campaign__c =: campaign ';
       
        if(selectedTimeZone != 'null')
        {
            Query += ' AND TimeZone__C =: selectedTimeZone ';
        }
          iscalled = boolean.valueof(selectedFilter);
          Query += ' AND worked__C =: iscalled ';
        
          Query += 'Order By Activity_Created_Date__c';    
      }
      else
      {
        Query = 'select id,name,worked__C,status__c,Comments__c,TimeZone__c,Campaign__c,Activity_Created_Date__c,account_name__C,account_name__r.Name from Work_Allocation__c where Campaign__c =: campaign ';

        if(selectedTimeZone != 'null')
        {
            
          Query += ' AND TimeZone__C =: selectedTimeZone ';
        
         
          if(selectedFilter != 'None')
          {
              
              iscalled = boolean.valueof(selectedFilter);
              Query += ' AND worked__C =: iscalled ';
          }
        }
        else
        {
          if(selectedFilter != 'None')
          {
              
              iscalled = boolean.valueof(selectedFilter);
              Query += ' AND worked__C=: iscalled ';
          }
        }
         Query += 'Order By Activity_Created_Date__c';
      }
    
      acctsLst = database.Query(Query);

    }
    //<OBJECTIVE>
    //Method redirects to EZRE_SalesTeamDailyCallListExcel page and downloads allocated records for inside sales reps.
    //</OBJECTIVE>
    public PageReference exportToExcel() 
    {
        pageReference pg = new PageReference('/apex/EZRE_SalesTeamDailyCallListExcel?RepName='+selectedRepName+'&TimeZone='+selectedTimeZone+'&Filter='+selectedFilter+'&Campaign='+campaign);
         pg.SetRedirect(true);
        return pg;
        
    }
 
}