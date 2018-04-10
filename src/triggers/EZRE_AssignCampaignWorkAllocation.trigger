trigger EZRE_AssignCampaignWorkAllocation on Work_Allocation__c (after insert)
{
    List<Work_Allocation__c> lstWrk = new List<Work_Allocation__c >();
    for(Work_Allocation__c wrkAlc : trigger.new)
    {
        if(wrkAlc.Is_Daily_CallList__c != true)
        {
        Work_Allocation__c myAccount = wrkAlc ;
        Work_Allocation__c objWrkAllc = [SELECT ID,Is_Daily_CallList__c,Contact__r.Account.Inside_SalesRep__c,Contact__r.Account.ODS_AWS_Inside_SalesRep__c,Contact__r.Force_com__c,Contact__r.ODS_AWS__c,Contact__r.Inside_SalesRep__c,Contact__r.ODS_AWS_Inside_SalesRep__c from Work_Allocation__c WHERE Id=: myAccount.Id];
        system.debug('**InsideFor**');
        //if(objWrkAllc.Is_Daily_CallList__c != true)
        //{
            system.debug('**InsideIf**'+wrkAlc.Contact__c);
            system.debug('**InsideIf**'+wrkAlc.Contact__r.Force_com__c);
            system.debug('**InsideIf**'+wrkAlc.Contact__r.ODS_AWS__c);
            system.debug('**InsideIf**');
            if(objWrkAllc.contact__r.Force_com__c == true)
            {
                system.debug('**InsideIf1**');
                objWrkAllc.Campaign__c = 'Force.Com';
                objWrkAllc.Name = objWrkAllc.Contact__r.Account.Inside_SalesRep__c;
            }
            else if (objWrkAllc.contact__r.ODS_AWS__c == true)
            {
                system.debug('**InsideElseif**');
                objWrkAllc.Campaign__c = 'ODS AWS';
                objWrkAllc.Name = objWrkAllc.Contact__r.Account.ODS_AWS_Inside_SalesRep__c;
            }
        lstWrk.add(objWrkAllc);
        }
    }
    update lstWrk;
}