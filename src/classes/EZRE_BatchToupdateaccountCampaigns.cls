global class EZRE_BatchToupdateaccountCampaigns implements Database.Batchable<sObject>, Database.Stateful
{
    set<Id> allaccountIds=new set<Id>();
    set<Id>  updatedaccounts=new set<Id>(); 
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
       //fetch all accounts
       
       String queryString='Select id,DataStax__c,Force_com__c,KPO__c,ODS_AWS__c,ODSDotNet__c,DBITS__c,ITSAC__c,TurnsLift__c,VMS__c ,Staffing_Promotion__c,MAP__c,SAP__c,Staffing__c,Start_Up_VC__c from account';
       system.debug('queryString======'+queryString);
       return Database.getQueryLocator(queryString);
    }
    global void execute(Database.BatchableContext BC, List<account> accountsList)
    {
      try
      {
        
        List<string> campaignList=new List<string>();
        campaignList.add('Staffing_Promotion__c');
        campaignList.add('DataStax__c');
        campaignList.add('Force_com__c');
        campaignList.add('KPO__c');
        campaignList.add('MAP__c');
        campaignList.add('ODS_AWS__c');             
        campaignList.add('ODSDotNet__c');
        campaignList.add('SAP__c');
        campaignList.add('Staffing__c');
        campaignList.add('Start_Up_VC__c');
        campaignList.add('DBITS__c');
        campaignList.add('ITSAC__c');       
        campaignList.add('TurnsLift__c');
        campaignList.add('VMS__c');
        
        
        Map<string,string>  mapping=new Map<string,string>();
        
       //mapping.put('Staffing_Promotion__c','');
        mapping.put('DataStax__c','DataStax');      
        mapping.put('Force_com__c','ODS Force.com');            
        mapping.put('KPO__c','KPO');        
        //mapping.put('MAP__c','');         
        mapping.put('ODS_AWS__c','ODS AWS');
        mapping.put('ODSDotNet__c','ODS DOT NET');      
        // mapping.put('SAP__c','');
        //mapping.put('Staffing__c','');
        //mapping.put('Start_Up_VC__c','');
        mapping.put('DBITS__c','Texas-DBITS');
        mapping.put('ITSAC__c','Texas-ITSAC');
        mapping.put('TurnsLift__c','TurnsLift');
        mapping.put('VMS__c','VMS');
        
        
        list<account> allCheckedCampainsList=new list<account>();
        for(account con:accountsList)
        {  
           String allCheckedCampains='';
           allaccountIds.add(con.id);
           for(string strcampign:campaignList)
           {    
              if(con.get(strcampign)==true)
              {
                String checkedCampaign=mapping.get(strcampign);
                 system.debug('allCheckedCampains before========='+allCheckedCampains);      
                allCheckedCampains=checkedCampaign+';'+allCheckedCampains;
                system.debug('allCheckedCampains after========='+allCheckedCampains);         
              }
           }
           system.debug('allCheckedCampains========='+allCheckedCampainsList);
           if(allCheckedCampains!=null)
           {
              
               account accountToUpdate=new account(id=con.id);
               accountToUpdate.Campaigns_Associated__c=allCheckedCampains;
               allCheckedCampainsList.add(accountToUpdate);
           }
        }
        if(allCheckedCampainsList.size()>0)
        {
           
             Database.SaveResult[] srList = database.update(allCheckedCampainsList,false);
     
        // Iterate through each returned result
        for (Database.SaveResult sr : srList) {
        system.debug('$$sr '+sr );
            if (sr.isSuccess()) {
                // Operation was successful, so get the ID of the record that was processed
                System.debug('Successfully updated account Id' + sr.getId());
                updatedaccounts.add(sr.getId());
               
            }
            else {
                // Operation failed, so get all errors                
                for(Database.Error err : sr.getErrors()) {
                     System.debug('Successfully inserted Lead. Lead ID: ' + sr.getId());
                    System.debug('The following error has occurred.');                    
                    System.debug(err.getStatusCode() + ': ' + err.getMessage());
                    
                }
            }
            }
            }
            allaccountIds.removeAll(updatedaccounts);
           
            system.debug('failed accounts Ids=========='+allaccountIds);
        }
        catch(Exception ex)
        {
            system.debug('===============ex'+ex);
        }
        
    }
    global void finish(Database.BatchableContext BC)
    {
       
  
    }
    

}