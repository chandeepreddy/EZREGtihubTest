/**
*@author        Shahida K
*@version       1.0
*@createdDate   15/03/2016
*@status        developed
*@description   Trigger to update meeting set date with date that contact status modified to 'meeting set'
*/

trigger EZRE_MeetingSetDate on Contact (after insert,after update) 
{
//Trigger to update meeting set date with lastmodified date when status is 'meeting set'
    if(trigger.isAfter)
    {
        if(trigger.isInsert)
        {
             set<Id> contactIdSet=new set<Id>();
             for(contact conct:trigger.new)
             {
                 contactIdSet.add(conct.id);            
             }
             system.debug('############contacts inserted'+contactIdSet);
            list<contact>  contactList=[select id,name,status__c,lastmodifiedDate from contact where status__c='3: Meeting Set' and id IN:contactIdSet];
            system.debug('##############Meeting set contacts'+contactList);
            if(contactList.size()>0)
            {
                for(contact cont:contactList)
                {
                  contact contactObj=new contact();
                  contactObj.id=cont.id;
                  contactObj.Meeting_Set_Date__c=cont.LastmodifiedDate;
                  update contactObj;
                }
            }
        }
        //trigger to update meeting set date with lastmodified date when status update to 'meeting set'
        if(trigger.isUpdate)
        {
            Map<Id,Contact> newContactMap=trigger.newMap;
            System.debug('############newContactMap'+newContactMap);
            Map<Id,Contact> oldContactMap=trigger.oldMap;
            System.debug('############oldContactMap'+oldContactMap);
            for(Id ContactId :newContactMap.keyset())
            {
               Contact newContact=newContactMap.get(ContactId);
               Contact oldContact=oldContactMap.get(ContactId);
               
               if(newContact.status__c<>oldContact.status__c)
               {
                   system.debug('##############newContactstatus'+newContact.status__c);
                   system.debug('##############newContactstatus'+oldContact.status__c);             
                   if(newContact.status__c=='3: Meeting Set')
                   {
                         Contact contactObj=new Contact();
                         contactObj.Id=newContact.Id;
                         contactObj.Meeting_Set_Date__c=newContact.LastmodifiedDate;
                         //update contact meeting set date with lastmodified date when status is 'Meeting set'
                         update contactObj;                  
                   }
               
               }
               
            
            }
            
        
        }

    }
}