global class AccountActivityCreateddateUpdate implements Database.batchable<sobject>
{
    global Database.QueryLocator start(database.batchablecontext bc)
    {
           string query ='SELECT id,name,Activity_Created_Date__c from Account';
       return Database.getQueryLocator(query);
    }
    global void execute(database.batchablecontext bc,List<Account> lstAcc)
    {
        set<ID> setAccId = new Set<ID>();
        set<ID> setConId = new Set<ID>();

        List<account> lstacct = new List<account>();
        for(Account acc: lstAcc)
        {
            setAccId.add(acc.Id);
        }
        List<contact> lstcon = [select id,lastname,accountId from contact where accountId IN: setAccId];
        for(contact con: lstcon)
        {
            setConId.add(con.Id);
        }
        List<task> lstTask = [SELECT ActivityDate,whoid,whatid,createddate FROM Task where Whoid IN: setConId OR WhatId IN: setAccId ORDER BY  CreatedDate DESC ALL ROWS];
        if(lstTask.Size() >0)
        {
            for(Account accnt: lstAcc)
            {
               account acc = new account(id = accnt.Id); 
               acc.Activity_Created_Date__c = lstTask[0].Createddate;
               lstacct.add(acc);
            }
            update lstacct;
        }
    }
     global void finish(database.batchablecontext bc)
    {
    }
}