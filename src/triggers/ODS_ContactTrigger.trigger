trigger ODS_ContactTrigger on Contact (after update,before Update) 
{
    if(trigger.isAfter && trigger.isUpdate)
    {
        set<Id> conIdSet = new set<Id>();
        set<Id> conNameIdSet = new set<Id>();
        List<User> contactUsers = new List<User>();
        List<User> contactUserNames = new List<User>();
        List<User> usersToUpdate = new List<User>();
        List<User> userNamesToUpdate = new List<User>();
        Map<string, List<User>> contactUserMap = new Map<string, List<User>>();
        Map<string, List<User>> contactUserNameMap = new Map<string, List<User>>();
        
        for(Contact newCon: trigger.new)
        {
            Contact oldCon = Trigger.OldMap.get(newCon.id);
            if(oldCon.Is_Portal_Access__c != newCon.Is_Portal_Access__c)
                conIdSet.add(newCon.id);
            if(oldCon.FirstName!= newCon.FirstName || oldCon.LastName!= newCon.LastName)
                conNameIdSet.add(newCon.id);
        }
        contactUsers = [SELECT id, ContactId, Contact.Is_Portal_Access__c from User where ContactId IN: conIdSet];
        contactUserNames = ODS_Data_Utility.getContactUserName(conNameIdSet);
        
        for(User conUsr: contactUsers)
        {
            if(contactUserMap.containskey(conUsr.ContactId))
                contactUserMap.get(conUsr.ContactId).add(conUsr);
            else
                contactUserMap.put(conUsr.ContactId, new List<User>{conUsr});
        }
        
        for(User conUsrName: contactUserNames)
        {
            if(contactUserNameMap.containskey(conUsrName.ContactId))
                contactUserNameMap.get(conUsrName.ContactId).add(conUsrName);
            else
                contactUserNameMap.put(conUsrName.ContactId, new List<User>{conUsrName});
        }
        
        for(string contactId: contactUserMap.keySet())
        {
            for(User contactUser: contactUserMap.get(ContactId))
            {
                User usr = new User(id=contactUser.id);
                usr.Is_Portal_Access__c = contactUser.Contact.Is_Portal_Access__c;
                usr.Is_Customer_Portal_Activated__c = True;
                usersToUpdate.add(usr);
            }
        }
        for(string contactId: contactUserNameMap.keySet())
        {
            for(User contactUserName: contactUserNameMap.get(ContactId))
            {
                User usr = new User(id=contactUserName.id);
                usr.FirstName = contactUserName.Contact.FirstName;
                usr.LastName = contactUserName.Contact.LastName;
                userNamesToUpdate.add(usr);
            }
        }
        update usersToUpdate;
        ODS_Data_Utility.updateConUserName(userNamesToUpdate);
    }
    if(trigger.isBefore && trigger.isUpdate)
    {
        Set<ID> contID = new Set<ID>(); 
        for(Contact con : Trigger.New)
        {
            if(con.IS_Approver__c == True)
            {
                contID.add(con.Id);
            }
            
        }
        if(contID.size()>0){
            List<User> lstUser = [Select id,lastname,ContactID from User where ContactID IN:contID];
            
            if((lstUser.isempty()) )
            {
                for(Contact cnt : Trigger.New)
                {
                    IF(cnt.IS_Approver__c = true)
                    {
                    
                        cnt.addError('Please provide access to Community portal by enabling them as External Customer');
                   }
                }
            }
        }
    }
}