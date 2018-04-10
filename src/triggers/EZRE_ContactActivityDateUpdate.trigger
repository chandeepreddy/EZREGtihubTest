/**
 * @author           
 * @version          
 * @date             19/04/2017
 * @Status           Developed
 * @description      Trigger to update Activity Date in Contact based on the activity creation.
 *
 */
Trigger EZRE_ContactActivityDateUpdate on Task (After Insert,After update) 
{
  List<account> accountList = new List<account>();
    List<Contact> updateContactLst = new List<Contact>();
    List<Lead> leadsToUpdate=new List<Lead>();
    List<Lead> leadstoUpdateLastActicityCreatedDate=new List<Lead>();
    List<Work_Allocation__c> workAllocationList = new List<Work_Allocation__c>();
    Set<ID> activityIdSet = new Set<ID>();
    Set<Id> activityLeadIdSet=new Set<Id>();
    Set<ID> accountIdSet = new Set<ID>();
    DateTime todayDt = system.today();
    system.debug('&&todayDt'+todayDt );
    //DateTime startDateTime = DateTime.newInstance(todayDt.year(),todayDt.Month(),todayDt.Day(),17,00,00);
    //DateTime endDateTime = DateTime.newInstance(todayDt.year(),todayDt.Month(),todayDt.Day(),40,59,59);
    
    Datetime currentDt = System.now(); // returns date time value in GMT time zone.

    system.debug('&&todayDt'+todayDt );
    DateTime startDateTime = DateTime.newInstance(currentDt.year(),currentDt.Month(),currentDt.Day(),-7,00,00);
    DateTime endDateTime = DateTime.newInstance(currentDt.year(),currentDt.Month(),currentDt.Day(),16,59,59);
    system.debug('@@1'+startDateTime );
    system.debug('@@2'+endDateTime );
    system.debug('isFutureUpdate $$##############' +EZRE_RecursionCheck.isFutureUpdate);
    if(EZRE_RecursionCheck.isFutureUpdate != true)
    {
        if(trigger.isAfter)
        { 
            if(trigger.isInsert)
            {
                 for(Task Tsk : trigger.new)
                {
                 system.debug('Task===================:'+Tsk );
                    if(Tsk.Whoid != null)
                    {
                        string taskWhoId = Tsk.Whoid;
                        if(taskWhoId.startsWith('00Q'))
                        {
                            activityLeadIdSet.add(Tsk.Whoid);
                        }
                    }
                    
                }
                if(activityLeadIdSet.size()>0)
                {
                    leadstoUpdateLastActicityCreatedDate=EZRE_Data_Utility.fetchLeadstoUpdateLastActicityCreatedDate(activityLeadIdSet);
                    system.debug('======='+leadstoUpdateLastActicityCreatedDate);
                }
                if(leadstoUpdateLastActicityCreatedDate.size()>0)
                {
                    for(Lead leadRec:leadstoUpdateLastActicityCreatedDate)
                    {
                        Lead objLead=new Lead(id=leadRec.id);
                        objLead.Last_Activity_Created_Date__c=system.now();
                        leadsToUpdate.add(objLead);
                    }
                    if(leadsToUpdate.size()>0)
                    {
                        EZRE_Data_Utility.leadsToUpdateLastActivtyCreatedDate(leadsToUpdate);
                    }
                }
            }
            if((trigger.isInsert) || (trigger.isUpdate))
            {       
                for(Task Tsk : trigger.new)
                {
                 system.debug('Task===================:'+Tsk );
                    if(Tsk.Whoid != null)
                    {
                        string taskWhoId = Tsk.Whoid;
                        if(taskWhoId.startsWith('003'))
                        {
                           activityIdSet.add(Tsk.Whoid);
                        }
                       
                    }
                    else if(Tsk.Whatid != null)
                    {
                          string accId = Tsk.Whatid;
                        if(accId.startsWith('001'))
                        {
                           accountIdSet.add(Tsk.Whatid);
                        }
                    }
                } 

                List<contact> contactList =EZRE_Data_Utility.fetchContacts(activityIdSet);
                if(accountIdSet.Size() >0)
                {
                    for(Id AccId:accountIdSet)
                    {
                        account acct = new account(id= AccId);
                        //acct.Activity_Created_Date__c = datetime.now();
                        acct.Activity_Created_Date__c = system.now();
                        accountList.add(acct);
                    }
                    EZRE_Data_Utility.updateAccountsList(accountList);
                }
                
                if(contactList.size() >0)
                {
                    system.debug('***Test');
                    for(contact con: contactList)
                    {
                        if(con.AccountId != null)
                        {
                            system.debug('***Test1');  
                            if(!(accountIdSet.Contains(con.AccountId)))
                            {
                                accountIdSet.add(con.AccountId);
                                account acc = new account(id= con.AccountId);
                                //acc.Activity_Created_Date__c = datetime.now();
                                acc.Activity_Created_Date__c = system.now();
                                accountList.add(acc);
                            }
                        }  
                       
                    }
                    for(contact con: contactList)
                    {
                        system.debug('***Test2');
                        contact cont = new contact(id= con.Id);
                        cont.Activity_Created_Date__c = System.now();
                        system.debug('***cont'+cont);
                        updateContactLst.add(cont);   
                    }
                    if(isRecursiveAccountTrigger.firedfromAccountTrigger)EZRE_Data_Utility.updateAccountsList(accountList);
                    EZRE_Data_Utility.updateContactsList(updateContactLst);
                }
                for(Work_Allocation__c work : EZRE_Data_Utility.fetchWorkAllctnCaledList(activityIdSet,startDateTime,endDateTime))
                {
                    system.debug('========work '+work );
                    Work_Allocation__c objwork = new Work_Allocation__c(id = work.Id);
                    objwork.Worked__c = true;
                    //objwork.Activity_Created_Date__c = datetime.now();
                    objwork.Activity_Created_Date__c = system.now();
                    workAllocationList.add(objwork);
                    system.debug('===================:'+workAllocationList);
                }
                EZRE_Data_Utility.updateWorkAllocationList(workAllocationList);
            }
        }
    }
    //Get sentiment score based on description of task from algorthmia sentiment analysis tool and update it in salesforce
    set<Id> taskId = new set<Id>();
    if((Trigger.isAfter)){
        for(Task objTask : trigger.new){
            if(Trigger.isInsert)    {
                if(objTask.description != null)
                    taskId.add(objTask.id);
            }
            if(Trigger.isUpdate)    {
                Task oldTask = Trigger.oldMap.get(objTask.Id);
                //Comparing the old comment and new comment, and old subject and new subject 
                if(oldTask.description != objTask.description || oldTask.subject != objTask.subject ) 
                    taskId.add(objTask.id);
            }
        }
        if(!taskId.isEmpty())
            EZRE_AlgorithmiaToolIntegration.InvokeAlgorithmiaApi(taskId);
    }
  
}