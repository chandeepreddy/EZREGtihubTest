/**
 * @author           Gangadhar
 * @version          1.0 
 * @date             29/03/2016
 * @Status           Developed
 * @description      Controller class for EZRE_SalesTeamDailyCallListExcel page.
 *
 */
public class EZRE_InsideSalesDailyWorkAllocationExcel
{
    public string SelectedFilter {get; set; }
    public String SelectedTimeZone { get; set; }
    public String SelectedRepName{ get; set; }
     public String UserCampaign{get;set;}
    public list<Work_Allocation__c> acctsLst{ get; set; }
    public  String campaign;
    List<String> repNamesSet= new List<String>(); 
       
    public EZRE_InsideSalesDailyWorkAllocationExcel()
    {
        
        SelectedFilter = apexpages.CurrentPage().GetParameters().get('Filter');
        SelectedTimeZone = apexpages.CurrentPage().GetParameters().get('TimeZone');
        SelectedRepName= apexpages.CurrentPage().GetParameters().get('RepName');
        UserCampaign= apexpages.CurrentPage().GetParameters().get('Campaign');
        
       
      
          Map<String, Account_Call_List_Allocation__c> acntcallAllocationMap = Account_Call_List_Allocation__c.getAll();
          Account_Call_List_Allocation__c  acntcallAllocation = new Account_Call_List_Allocation__c  ();
          User usr = EZRE_Data_Utility.fetchUser(UserInfo.getUserId());
          system.Debug('@@@usrDetails'+usr);
          system.Debug('@@@UserCampaign'+usr.Campaign__c);
          List<String> repNamesLst= new List<String>();
          
          if(usr.Campaign__c !=null)
          {
              campaign=usr.Campaign__c;
              system.Debug('@@@campaign'+campaign);
              system.Debug('@@@campaign1'+acntcallAllocationMap.get(usr.Campaign__c));
              
              List<Account_Call_List_Allocation__c> lstAllocation=new List<Account_Call_List_Allocation__c>();
              lstAllocation.add(acntcallAllocationMap.get(usr.Campaign__c));
              
              system.Debug('@@@lstAllocation'+lstAllocation);
                          
              if((lstAllocation.size()>0)&&(lstAllocation[0]!=null))
              {
                  acntcallAllocation =acntcallAllocationMap.get(usr.Campaign__c);
                  String repNames = acntcallAllocation.Account_ISR_Name__c;
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
            system.Debug('Rep without Null:==='+ repNamesLst);
                    
          }
          
        ContactListforRepExcel();
    }
    
    public void ContactListforRepExcel()
    {
        DateTime todayDt = system.today();
        Datetime currentDt = System.now(); // returns date time value in GMT time zone.

       //Datetime startDateTime = datetime.newInstance(todayDt.year(), todayDt.month(),todayDt.day(),17,0,0);
       //Datetime endDateTime = datetime.newInstance(todayDt.year(), todayDt.month(),todayDt.day(),40,59,59);
          
      DateTime startDateTime = DateTime.newInstance(currentDt.year(),currentDt.Month(),currentDt.Day(),-7,00,00);
      DateTime endDateTime = DateTime.newInstance(currentDt.year(),currentDt.Month(),currentDt.Day(),16,59,59);
      
      /*DateTime startDateTime = DateTime.newInstance(currentDt.year(),currentDt.Month(),currentDt.Day(),17,00,00);
      DateTime endDateTime = DateTime.newInstance(currentDt.year(),currentDt.Month(),currentDt.Day(),40,59,59);*/
      acctsLst = new List<Work_Allocation__c>();
      string Query;
        if(SelectedRepName != 'None')
      {
          Query = 'select id,name,Contact__r.Name,Email__c ,Phone__c,worked__C,Comments__c,status__c,TimeZone__c,Activity_Created_Date__c,account_name__C,Campaign__c,account_name__r.Name from Work_Allocation__c where Name =:SelectedRepName ';
          system.debug('==============1:If');
        if(UserCampaign!=null)
        {
               Query +=' AND Campaign__c =: UserCampaign ';   
        }
         if(SelectedTimeZone != 'null')
        {
          Query += ' AND TimeZone__C =: SelectedTimeZone ';
           system.debug('Time zone==============1:If');
        }
        if(SelectedFilter != 'None')
        {
          boolean iscalled = boolean.valueof(SelectedFilter);
          Query += ' AND worked__C=: iscalled AND CreatedDate >=: startDateTime  AND CreatedDate <=: endDateTime  ';
          system.debug('Worked:==============1:If');
        }
         Query += 'Order By Activity_Created_Date__c ';    
      }
      else
      {
        Query = 'select id,name,Contact__r.Name,Email__c ,Phone__c,worked__C,status__c,Comments__c,TimeZone__c,Campaign__c,Activity_Created_Date__c,account_name__C,account_name__r.Name from Work_Allocation__c WHERE Name IN: repNamesSet ';
        
          system.debug('=============2:Else');
        if(SelectedTimeZone != 'null')
        {
          Query += ' AND TimeZone__C =: SelectedTimeZone ';
        
           system.debug('Time Zone=============2:Else');
          if(SelectedFilter != 'None')
          {
              boolean iscalled = boolean.valueof(SelectedFilter);
              Query += ' AND worked__C=: iscalled ';
             system.debug('Worked:=============2:Else');
          }
           if(UserCampaign!=null)
            {
                   Query +=' AND Campaign__c =: UserCampaign ';   
            }
        }
        else
        {
          if(SelectedFilter != 'None')
          {
              boolean iscalled = boolean.valueof(SelectedFilter);
              Query += ' AND worked__C=: iscalled ';
              system.debug('Worked:============3:Else');
             if(UserCampaign!=null)
             {
                 Query +=' AND Campaign__c =: UserCampaign ';   
             }
          }
          else
          {
              Query += ' AND Campaign__c =: UserCampaign ';
          }
        }
         
         Query += ' AND CreatedDate = Today Order By Activity_Created_Date__c';
      }
      
      system.debug('Query :===================='+Query );
      acctsLst = database.Query(Query);
      system.debug('acctsLst:===================='+acctsLst);
      
 
}
    
}