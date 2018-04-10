trigger ODS_AccountTrigger on Account (after update) 
{
    if(trigger.isAfter && trigger.isUpdate)
    {
        set<Id> accIdSet = new set<Id>();
        List<Contact> accountContacts = new List<Contact>();
        List<Contact> contactsToUpdate = new List<Contact>();
        Map<string, List<Contact>> accountContactMap = new Map<string, List<Contact>>();
        
        for(Account newAcc: trigger.new)
        {
            Account oldAcc = Trigger.OldMap.get(newAcc.id);
            if(oldAcc.Is_Portal_Access__c != newAcc.Is_Portal_Access__c)
            {
                accIdSet.add(newAcc.id);
            }
        }
        accountContacts = [SELECT id, AccountId, Account.Is_Portal_Access__c from Contact where AccountId IN: accIdSet];
        for(Contact accCon:accountContacts)
        {
            if(accountContactMap.containskey(accCon.AccountId))
            {
                accountContactMap.get(accCon.AccountId).add(accCon);
            }
            else
            {
                accountContactMap.put(accCon.AccountId, new List<Contact>{accCon});
            }
        }
        
        for(string accountId: accountContactMap.keySet())
        {
            for(Contact accountContact: accountContactMap.get(accountId))
            {
                Contact con = new Contact(id=accountContact.id);
                con.Is_Portal_Access__c = accountContact.Account.Is_Portal_Access__c;
                contactsToUpdate.add(con);
            }
        }
        update contactsToUpdate;
    }
}