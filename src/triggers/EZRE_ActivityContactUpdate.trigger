/**
 * @author           Gangadhar
 * @version          1.0 
 * @date             24/03/2016
 * @Status           Developed
 * @description      Trigger to update the account based on the activity creation.
 *
 */
Trigger EZRE_ActivityContactUpdate on Task (After Insert) 
{
    List<account> accountList = new List<account>();
    List<Work_Allocation__c> workAllocationList = new List<Work_Allocation__c>();
    Set<ID> activityIdSet = new Set<ID>();
    
    Set<ID> accountIdSet = new Set<ID>();
    
    //EZRE_RecursionCheck rc = new EZRE_RecursionCheck();
   // if(rc.canIRun()) {
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
                        string conId = Tsk.Whoid;
                        if(conId.startsWith('003'))
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
                        acct.Activity_Created_Date__c = datetime.now();
                        accountList.add(acct);
                    }
                    EZRE_Data_Utility.updateAccountsList(accountList);
                }
                if(contactList.size() >0)
                {
                    for(contact con: contactList)
                    {
                        if(con.AccountId != null)
                        {
                              
                            if(!(accountIdSet.Contains(con.AccountId)))
                            {
                                accountIdSet.add(con.AccountId);
                                account acc = new account(id= con.AccountId);
                                acc.Activity_Created_Date__c = datetime.now();
                                accountList.add(acc);
                            }
                        }     
                    }
                    EZRE_Data_Utility.updateAccountsList(accountList);
                }
                /*for(Work_Allocation__c work : EZRE_Data_Utility.fetchWorkAllctnCaledList(accountIdSet))
                {
                    Work_Allocation__c objwork = new Work_Allocation__c(id = work.Id);
                    objwork.Worked__c = true;
                    workAllocationList.add(objwork);
                    system.debug('===================:'+workAllocationList);
                }
                EZRE_Data_Utility.updateWorkAllocationList(workAllocationList);*/
            }
        }
    }
}