global class batchupdateActivityDate
{
   /* 
    global Database.QueryLocator start(database.batchablecontext bc)
    {  
      string query ='SELECT ActivityDate,whoid,whatid,createddate FROM Task where Whatid != null ORDER BY  CreatedDate DESC';
       return Database.getQueryLocator(query);
    }
    global void execute(database.batchablecontext bc,List<task> tsklst)
    {
        Map<Id,task> maptsk = new Map<Id,task>();
        for(task task:tsklst)
        {
          if(maptsk.containsKey(task.Whatid))
          {
            
          }
          else
          {
            maptsk.put(task.Whatid,task);
          }
        }
        system.debug('@@@@maptsk'+maptsk);
        
        
        
        List<account> lstcon = new List<account>();
        
        for(string contf: maptsk.Keyset())
        {
          if(contf.startsWith('001'))
          {
             account acc = new account(id = contf); 
             acc.Activity_Created_Date__c = maptsk.get(contf).Createddate;
            lstcon.add(acc);
          }
        }
        update lstcon;
    }
    global void finish(database.batchablecontext bc)
    {
    }*/
}