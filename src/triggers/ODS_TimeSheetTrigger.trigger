trigger ODS_TimeSheetTrigger on Timesheet__c (after insert,before update) 
{
    Integer Count = 0;
    List<aggregateResult> lstTimeDetails = new List<aggregateResult>();
    system.debug('***');
    Set<Id> setId = new Set<Id>();
    for(Timesheet__c objTmesht : trigger.new)
    {
        system.debug('***objTmesht.Id'+objTmesht.Id);
        setId.add(objTmesht.Id);
     }
    system.debug('***setId'+setId);
    lstTimeDetails = [SELECT Resource__c from Time_Sheet_Details__c WHERE Timesheet__c =: setId Group By Resource__c];
    system.debug('***lstTimeDetails'+lstTimeDetails);
    
    List<Timesheet__c> lstTmeSht = [SELECT Id from Timesheet__c WHERE Id IN: setId];
    
    if(lstTimeDetails.size() !=0)
    {
        for(AggregateResult objAg : lstTimeDetails)
        {
            Count++;
        }
    }
    system.debug('***'+Count);
    /*for(Timesheet__c objTmesht : trigger.new)
    {
        objTmesht.Regular_Count__c = Count;
        update objTmesht;
    }*/
    for(Timesheet__c objTmesht : lstTmeSht)
    {
        objTmesht.Regular_Count__c = Count;
        upsert objTmesht ;
    }
}