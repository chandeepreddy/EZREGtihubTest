@isTest
private class TestMyCustom_Opportunities
{
 
    static testMethod void myUnitTest() 
    { 
        String oppid;
        String cid;
      MyCustomLookupController_Opportunities cc = new MyCustomLookupController_Opportunities();
        if(cid!=null)
        {
          cid = System.CurrentPageReference().getParameters().get('CF00N400000022LFE');
        }
        else
        {
            for(Candidate__c c : [select Candidate__c.ID from Candidate__c LIMIT 1])
             {
              system.debug('cid:'+c);
               if(c!=null)
               {
                cid= c.ID;
               }
             }
        }
        if(oppid!=null)
        {
          oppid = System.CurrentPageReference().getParameters().get('CF00N400000022LFE');
        }
        else
        {
                     // oppid='0064000000LotUZ';
         for(Opportunity op: [select Opportunity.ID from Opportunity LIMIT 1])
         {
          system.debug('opid:'+op);
           if(op!=null)
           {
            oppid = op.ID;
           }
         }
         
        }
        system.debug('oppid:'+oppid);
        CandidateOpportunityAssociation__c coa =new CandidateOpportunityAssociation__c();
        coa.Manager_Email_ID__c='elango_m@preludesys.com';
        coa.CandidateId__c=cid;//'a0kS0000000e1To';
        coa.OpportunityId__c=oppid;
        coa.Status__c='Applied';
        coa.Opportunity_Comments__c='test';

        insert coa;
        system.debug('insert coa:'+coa);
        
        cc.save();
       // cc.saveNew();
        cc.cancel();
        
       system.assert(coa!= null);
       
        
       
       
    }
}