/**
* @author           Gangadhar
* @version          1.0 
* @date             28/03/2016
* @Status           Developed
* @description      This class is to create a new set of Records in the workallocation object
*                   and delete the old records on daily basis.
* @Modified By      Kalaiselvi R 03/05/2016
* @Modified By      Shahida K  21/07/2016   
* 
*/
public class EZRE_DailyWorkAllocationNewSet {
 
   public Map <String, List <Account_Related_Campaign__c>> repAndAccntRltdCmpgnLstMap;
    public List<Account_Related_Campaign__c>  accRltdCmpgnsList;
    public String accntRltdCmpgnAllctnQry {get; set; }
    public String frcDtcmAccntAllctnQury;
    public String odsDtNtAccntAllctnQury;
    public Call_List_Allocation__c callListDetails;
    public integer dailyLimit { get; set; }
    public String repNames;
    Public Integer anualRevenueFromLimit;
    Public Integer anualRevenuToLimit;
    public List<Account_Related_Campaign__c>  allAccRltdCmpgnsList;
    public List<String> allrepNamesSet;
    public  Map<String,integer> repDataLimitMap;
    public List <Work_Allocation__c> objworkAllocationLst;
    public List <String> repNamesSet;
    List<String> accountStatusLst;
    Set<String> accountStatusSet;
    Public String accountStatus;
    public Map<String,List<Account>> forceDotComAccntMap;
    
    ///<OBJECTIVE>
    //Method to allocate work for 
    ///</OBJECTIVE>
    public void execute() 
    {
        objworkAllocationLst=new List <Work_Allocation__c> ();
        
        //Fetch existing work allocation records and 
        objworkAllocationLst = EZRE_Data_Utility.fetchWorkAllocationList();
        system.debug('@@@@@ objworkAllocationLst: '+objworkAllocationLst );
        
        //Block of code is to delete existing work allocation object records and allocate new set of accounts to the reps.
        if (objworkAllocationLst.size() > 0) {
            EZRE_Data_Utility.deleteWorkAllocationList(objworkAllocationLst);
        }
        accRltdCmpgnsList=new List<Account_Related_Campaign__c> ();       
        repAndAccntRltdCmpgnLstMap=new Map <String, LIST <Account_Related_Campaign__c>> ();
        allAccRltdCmpgnsList=new List<Account_Related_Campaign__c>();
        List <Work_Allocation__c> objworkAllocation = new List <Work_Allocation__c> ();

        List <Account_Related_Campaign__c>  accountRep = new List <Account_Related_Campaign__c> () ;             
        List<Account> frcDtCmAccntLst=new List<Account>();
        List<Account> odsDtNtAccntLst=new List<Account>();          
        Map <String, Call_List_Allocation__c> callAllocationMap = Call_List_Allocation__c.getAll(); 
        
        repNamesSet = new List <String> ();
        allrepNamesSet=new  List<String>();
        accountStatusLst=new List<String>();
        accountStatusSet=new Set<String>();
        
        repDataLimitMap=new Map<String,integer>();
        
        //For loop to fetch all account and account related campaign records.
        //Records are fetched based on campaign and its related reps in custom settings.
        for (String camp: callAllocationMap.Keyset()) 
        {
            repNamesSet.clear();
            allRepNamesSet.clear();
            accountStatusLst.clear();
            accountStatusSet.clear();
            
            frcDtCmAccntLst.clear();
            odsDtNtAccntLst.clear();
            forceDotComAccntMap=new Map<String,List<Account>>();
           
            system.debug('########campaign'+camp);
            callListDetails=callAllocationMap.get(camp);
            dailyLimit = integer.valueof(callListDetails.Daily_Limit__c);
            system.debug('dailyLimit =============='+dailyLimit );
            repNames=callListDetails.Rep_Names__c;
            
            //Custom setting Rep Names List
            if(String.isNotBlank(repNames))
                allrepNamesSet=repNames.split(','); 
            
           
            for(String strRep:allrepNamesSet)     
            {
                if(String.isNotBlank(strRep))
                {
                      repNamesSet.add(strRep);    
                }
            }
            
            //Custom setting Account Status 
            accountStatus=callListDetails.Account_Status__c;
             if(String.isNotBlank(accountStatus))
                accountStatusLst=accountStatus.split(',');
                
            for(String strAccountStatus:accountStatusLst)
            {
                if(String.isNotBlank(strAccountStatus))
                {
                    accountStatusSet.add(strAccountStatus);
                }
            
            }   
            
            anualRevenueFromLimit=Integer.valueOf(callListDetails.Anual_Revenue_From__c);
            anualRevenuToLimit=Integer.valueOf(callListDetails.Anual_Revenue_To__c);    
            system.debug('####accountStatusSet =============='+accountStatusSet);
             
            if(repNamesSet.size()>0)
            {
                  system.debug('###anualRevenueFromLimit :==========='+anualRevenueFromLimit);
                  system.debug('###anualRevenuToLimit :==========='+anualRevenuToLimit);
                accntRltdCmpgnAllctnQry = 'SELECT Account__r.AnnualRevenue,ID,Account_Status__c,Account__c,Campaign__c,Data_Status__c,Rep_Name__c, Account__r.Id, Account__r.name,Account__r.TimeZone__c,Account__r.Activity_Created_Date__c,Account__r.Account_Status__c FROM Account_Related_Campaign__c WHERE ' +
                'Account__c!=null AND Account__r.AnnualRevenue>:anualRevenueFromLimit AND Account__r.AnnualRevenue<:anualRevenuToLimit AND Campaign__c =:camp AND Rep_Name__c IN: repNamesSet AND Account_Status__c IN:accountStatusSet Order By Account__r.Activity_Created_Date__c';
                
                system.debug('accntRltdCmpgnAllctnQry :==========='+accntRltdCmpgnAllctnQry);
                List<String>  accountIdList=new List<String>();
                accountRep = database.Query(accntRltdCmpgnAllctnQry);
                system.debug('accountRep:==========='+accountRep);
                
                if (accountRep.size() > 0)
                {
                    allAccRltdCmpgnsList.addAll(accountRep); 
                }
               
                for(String strRep:repNamesSet)
                {
                    if(!repDataLimitMap.containsKey(strRep))
                    {
                        repDataLimitMap.put(strRep,DailyLimit);
                    }
                }                    
                if(camp=='Force.com'){
              
                    frcDtcmAccntAllctnQury='Select AnnualRevenue,id,Activity_Created_Date__c,ODSDotNet__c,Account_Status__c,TimeZone__c,Force_com_Account_Status__c,Inside_SalesRep__c,Force_com__c from account WHERE '+'Force_com__c =true AND Force_com_Account_Status__c IN:accountStatusLst AND Inside_SalesRep__c IN: repNamesSet AND AnnualRevenue>:anualRevenueFromLimit AND AnnualRevenue<:anualRevenuToLimit Order By Activity_Created_Date__c ';
                    FrcDtCmAccntLst=database.Query(frcDtcmAccntAllctnQury);
                    system.debug('@@@@Force.comlist:==========='+FrcDtCmAccntLst);
                }
                if(camp=='ODS .Net'){
                
                    odsDtNtAccntAllctnQury='Select AnnualRevenue,id,Force_com__c,Activity_Created_Date__c,Account_Status__c,TimeZone__c,ODSDotNet_Account_Status__c,ODSDotNet_Inside_Sales_Rep__c,ODSDotNet__c from account WHERE '+'ODSDotNet__c =true AND ODSDotNet_Account_Status__c IN:accountStatusLst AND ODSDotNet_Inside_Sales_Rep__c IN: repNamesSet AND AnnualRevenue>:anualRevenueFromLimit AND AnnualRevenue<:anualRevenuToLimit Order By Activity_Created_Date__c ';
                    odsDtNtAccntLst=database.Query(odsDtNtAccntAllctnQury);
                    system.debug('@@@ODSDotNetlist:=============='+odsDtNtAccntLst);
                }
               
                if(FrcDtCmAccntLst.size()>0){
                
                    allocateForceDotComAccounts(FrcDtCmAccntLst,camp);    
                }
                if(odsDtNtAccntLst.size()>0){
                
                    allocateODSDotNetAccounts(odsDtNtAccntLst,camp);
                }
            }           
               system.debug('AccountStatusCustomSettingRec:=========='+accountStatusLst);                       
               system.debug('repNamesSet =============='+repNamesSet);
                
        }
        if(allAccRltdCmpgnsList.size()>0)
              allocateAccountRelatedCampaigns();
         
        //For loop to insert Account Related Campaign Records into work allocation object
        if (accRltdCmpgnsList.size()>0)
        {
            for (Account_Related_Campaign__c acc:accRltdCmpgnsList) 
            {
                Work_Allocation__c objwork = new Work_Allocation__c();
                objwork.name = acc.Rep_Name__c;
                objwork.Account_Name__c = acc.Account__c;
                objwork.Account_Campaign_Name__c = acc.Id;
                objwork.timezone__c = acc.Account__r.TimeZone__c;
                objwork.status__c = acc.Account__r.Account_Status__c;
                objwork.Campaign__c = acc.Campaign__c;
                objwork.Activity_Created_Date__c = acc.Account__r.Activity_Created_Date__c;
                objworkAllocation.add(objwork);
            }
        }
       system.debug('ARC Allocation==========='+objworkAllocation);
        EZRE_Data_Utility.insertWorkAllocationList(objworkAllocation);
    }
    ///<OBJECTIVE>
    //Method to get list of account related campaign records for each rep as per Data limit count. 
    ///</OBJECTIVE>
        public void allocateAccountRelatedCampaigns()
    {
        //For loop to Group map with rep to get list of Account related campaigns of each rep.
        for(Account_Related_Campaign__c accRldCmgn:allAccRltdCmpgnsList)    
        {
        
            if(repAndAccntRltdCmpgnLstMap.containsKey(accRldCmgn.Rep_Name__c))
                repAndAccntRltdCmpgnLstMap.get(accRldCmgn.Rep_Name__c).add(accRldCmgn);
            else
                repAndAccntRltdCmpgnLstMap.put(accRldCmgn.Rep_Name__c,new List<Account_Related_Campaign__c>{accRldCmgn});
                
        }   
        //For loop to prepare List of account related campaigns records to allocate records as per Data limit.
        if((repAndAccntRltdCmpgnLstMap != null) && (!repAndAccntRltdCmpgnLstMap.isEmpty()))
        {
            for(String Repstr:repAndAccntRltdCmpgnLstMap.keyset())
            {
              
                List<Account_Related_Campaign__c> srtdAccntRltdCmpgnLst=new List<Account_Related_Campaign__c>();
                if(repAndAccntRltdCmpgnLstMap.containsKey(Repstr))
                {
                    srtdAccntRltdCmpgnLst.addAll(repAndAccntRltdCmpgnLstMap.get(Repstr)); 
                }
                if(srtdAccntRltdCmpgnLst.size()>0)
                {
                    if((srtdAccntRltdCmpgnLst.size()<= repDataLimitMap.get(Repstr))) 
                    { 
                        accRltdCmpgnsList.addAll(srtdAccntRltdCmpgnLst);
                    }
                    else
                    {
                         for(integer i=0;i<repDataLimitMap.get(Repstr);i++)
                        {
                            if(i<=repDataLimitMap.get(Repstr))
                            {
                            accRltdCmpgnsList.add(srtdAccntRltdCmpgnLst[i]);
                            system.debug('ARC###########'+i);
                            system.debug('ARC###########'+srtdAccntRltdCmpgnLst.size());
                            }
                            else
                            {
                              system.debug('@@@@@@@@@@@Data Limit Reached for Rep'+Repstr);
                              break;
                            }
                        }
                    }                   
                } 
            }  
        }
    }
    ///<OBJECTIVE>
    //Method to group accounts based on force.com ISR names.
    ///</OBJECTIVE>
   public void allocateForceDotComAccounts(List<Account> FrcDtCmAccntLst,String Campaign)
   {
        List<Account> forceDotComAccntLst=new List<Account>(); 
       
        if(FrcDtCmAccntLst.size()>0)
        {
            for(Account accObj:FrcDtCmAccntLst)    
            {
              if(accObj.Inside_SalesRep__c!=null)
              {
                    if(forceDotComAccntMap.containsKey(accObj.Inside_SalesRep__c))
                        forceDotComAccntMap.get(accObj.Inside_SalesRep__c).add(accObj);
                    else
                        forceDotComAccntMap.put(accObj.Inside_SalesRep__c,new List<Account>{accObj});
               }     
            }
            allocateAccountCampaigns(forceDotComAccntMap,Campaign);
       }
       system.debug('forceDotComAccntMap:========'+forceDotComAccntMap);
    }
    ///<OBJECTIVE>
    //Method to group accounts based on ODS .Net ISR names.
    ///</OBJECTIVE>
    public void allocateODSDotNetAccounts(List<Account> ODSDtNtAccntLst,String Campaign)
    {
        List<Account> odsDotNetAccntLst=new List<Account>(); 
        Map<String,List<Account>> odsDotNetAccntMap=new Map<String,List<Account>>();
        if(ODSDtNtAccntLst.size()>0)
        {
            for(Account accObj:ODSDtNtAccntLst)    
            {
                if(accObj.ODSDotNet_Inside_Sales_Rep__c!=null)
                {
                    if(odsDotNetAccntMap.containsKey(accObj.ODSDotNet_Inside_Sales_Rep__c))
                        odsDotNetAccntMap.get(accObj.ODSDotNet_Inside_Sales_Rep__c).add(accObj);
                    else
                        odsDotNetAccntMap.put(accObj.ODSDotNet_Inside_Sales_Rep__c,new List<Account>{accObj});   
                }                   
            }
            allocateAccountCampaigns(odsDotNetAccntMap,Campaign);
        }
         system.debug('odsDotNetAccntMap:========'+odsDotNetAccntMap);
    } 
        
    ///<OBJECTIVE>
    //Method to prepare list of accounts to allocate for force.com and ODS .Net ISR's.
    ///</OBJECTIVE>          
    public void allocateAccountCampaigns(Map<String,List<Account>> repandAccntCmpgnsMap,String cmpgn)
    {
         List<Account>  accntCmpgnsToallwct=new List<Account> ();           
        system.debug('repandAccntCmpgnsMap:======'+repandAccntCmpgnsMap);
        List < Work_Allocation__c > objAccworkAllocation = new List < Work_Allocation__c > ();
             
        if((repandAccntCmpgnsMap != null) && (!repandAccntCmpgnsMap.isEmpty()))
        {     
            for(String Repstr:repandAccntCmpgnsMap.keyset())
            {
                system.debug('AccountCampaignrep======'+Repstr);
                List<Account> accntCmpgnLst= new List<Account>();
                if(repandAccntCmpgnsMap.containsKey(Repstr))
                {
                    accntCmpgnLst.addAll(repandAccntCmpgnsMap.get(Repstr)); 
                }
                    
                if(accntCmpgnLst.size()>0)
                {
                    system.debug('No Of accounts exist for Rep======'+accntCmpgnLst.size());
                   
                    
                    if(accntCmpgnLst.size()<= repDataLimitMap.get(Repstr)) 
                     { 
                         accntCmpgnsToallwct.addAll(accntCmpgnLst);
                         system.debug('data limit if block'+accntCmpgnsToallwct);
                     }
                    else{                        
                        for(integer i=0;i<repDataLimitMap.get(Repstr);i++)
                        {
                            
                            if(i<=repDataLimitMap.get(Repstr))
                            {
                            accntCmpgnsToallwct.add(accntCmpgnLst[i]);
                            system.debug('&&&&&&&&&&&&&&&&&&'+i);
                            system.debug('&&&&&&&&&&&&&&&&&&&&&'+accntCmpgnLst.size());
                            }
                            else
                            {
                              system.debug('@@@@Data Limit Reached skip loop'+Repstr);
                              break;
                            }
                            
                        }
                    }
                }   
            } 
        }
       
        
        ///<OBJECTIVE>
        //for lopp to insert forc.com and ODS .Net account records in work allocation object for work allocation to reps.
        ///</OBJECTIVE>
        if (accntCmpgnsToallwct.size()>0)
        {
            for (Account acc:accntCmpgnsToallwct) 
            {
                Work_Allocation__c objwork = new Work_Allocation__c();
                objwork.Account_Name__c = acc.id;
                objwork.timezone__c = acc.TimeZone__c;
                objwork.status__c = acc.Account_Status__c;
                objwork.Activity_Created_Date__c = acc.Activity_Created_Date__c;
                if((acc.ODSDotNet__c==true)&&(cmpgn=='ODS .Net'))
                {
                    objwork.Campaign__c ='ODS .Net';
                    objwork.name = acc.ODSDotNet_Inside_Sales_Rep__c;
                }
                else if((acc.Force_com__c==true)&&(cmpgn=='Force.com'))
                {
                    objwork.Campaign__c = 'Force.com';
                    objwork.name = acc.Inside_SalesRep__c;
                }
                objAccworkAllocation.add(objwork);
            }
        }
        system.debug('Account Campaign Allocation======='+objAccworkAllocation);
        EZRE_Data_Utility.insertWorkAllocationList(objAccworkAllocation);
    }
       
   
   
}