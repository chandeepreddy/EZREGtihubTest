/*
* @author           Indumathi.V
* @version          1.0 
* @date             22/3/2016
* @description      Trigger to update Opportunity Execution partner.
*/ 
trigger EZRE_Opp_UpdteExctnPrtnr on Opportunity (before insert) 
{
    Set<Id> setAccntIds = new set<Id>();
    
    if(Trigger.isInsert)
    {
        for(Opportunity opp : Trigger.new )
        {            
            setAccntIds.add(opp.AccountId);         
        }
    }
    
    Map<Id,Account> mapOppAccnt = new Map<Id,Account>([Select Id, Name, Client_Partner__c from Account where Id IN: setAccntIds]);
    
    for(Opportunity opp: Trigger.new)
    {      
        if(mapOppAccnt.get(opp.AccountId) != null)
        {         
            opp.Execution_Partner__c = mapOppAccnt.get(opp.AccountId).Client_Partner__c;
            
        }
        
    }   
    
}