/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class testt {

    static testMethod void myUnitTest() {
        
   String oppid;
        String cid;
        String Userid;
      MyCustomLookupController cc = new MyCustomLookupController();
        if(cid!=null)
        {
          cid = System.CurrentPageReference().getParameters().get('CF00N400000022LF9');
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
        for(User u : [Select Manager_Email__c From User where Manager_Email__c !=null  limit 1])
        {
          System.Debug('UserID:'+ u);
          if(u !=null)
          {
             Userid = u.Manager_Email__c;
             system.debug('sample:'+Userid);
          }
        }
        CandidateOpportunityAssociation__c coa =new CandidateOpportunityAssociation__c();
        coa.Manager_Email_ID__c=Userid;
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