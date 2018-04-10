global class EZRE_BatchToupdateContactCampaigns implements Database.Batchable<sObject>, Database.Stateful
{
    set<Id> allContactIds=new set<Id>();
    set<Id>  updatedContacts=new set<Id>(); 
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
       //fetch all contacts
       
       String queryString='Select id,Force_com__c,ADM__c,AnB__c,DataStax__c,GLIX__c,Holiday_Cards__c,LegMod__c,ODS_AWS__c,ODSDotNet__c,TurnsLift__c,Mini_FOX_Masco_W_B__c,KPO__c,Title_Insurance__c,VMS__c,free500hrs__c,DIS__c from contact';
       system.debug('queryString======'+queryString);
       return Database.getQueryLocator(queryString);
    }
    global void execute(Database.BatchableContext BC, List<contact> contactsList)
    {
      try
      {
        
        List<string> campaignList=new List<string>();
        campaignList.add('Force_com__c');
        campaignList.add('ADM__c');
        campaignList.add('AnB__c');
        campaignList.add('DataStax__c');
        campaignList.add('GLIX__c');
        campaignList.add('Holiday_Cards__c');
        campaignList.add('LegMod__c');
        campaignList.add('ODS_AWS__c');
        campaignList.add('ODSDotNet__c');
        campaignList.add('TurnsLift__c');
        campaignList.add('Mini_FOX_Masco_W_B__c');
        campaignList.add('KPO__c');
        campaignList.add('Title_Insurance__c');
        campaignList.add('VMS__c');
        campaignList.add('free500hrs__c');
        campaignList.add('DIS__c');
        
        Map<string,string>  mapping=new Map<string,string>();
        
        mapping.put('Force_com__c','ODS Force.com');
        mapping.put('ADM__c','ADM');
        mapping.put('AnB__c','AnB');
        mapping.put('DataStax__c','DataStax');
        mapping.put('GLIX__c','GLIX');
        mapping.put('Holiday_Cards__c','Holiday Cards');
        mapping.put('LegMod__c','LegMod');
        mapping.put('ODS_AWS__c','ODS AWS');
        mapping.put('ODSDotNet__c','ODS DOT NET');
        mapping.put('TurnsLift__c','TurnsLift');
        mapping.put('Mini_FOX_Masco_W_B__c','Mini – Fox_Masco_WB');
        mapping.put('KPO__c','KPO');
        mapping.put('Title_Insurance__c','Title Insurance');
        mapping.put('VMS__c','VMS');
        mapping.put('free500hrs__c','500 Hour Promotion');
        mapping.put('DIS__c','DIS');
        
        list<contact> allCheckedCampainsList=new list<contact>();
        for(contact con:contactsList)
        {  
           String allCheckedCampains='';
           allContactIds.add(con.id);
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
              
               Contact contactToUpdate=new Contact(id=con.id);
               contactToUpdate.Campaigns_Associated__c=allCheckedCampains;
               allCheckedCampainsList.add(contactToUpdate);
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
                System.debug('Successfully updated Contact Id' + sr.getId());
                updatedContacts.add(sr.getId());
               
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
            allContactIds.removeAll(updatedContacts);
           
            system.debug('failed Contacat Ids=========='+allContactIds);
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