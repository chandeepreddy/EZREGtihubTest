@isTest(SeeAllData=true)
private class testclassupdateresumessubmitted
{
    
     /* static testMethod void myTestdisplay()
          {
                //Integer rescount1;
                updateresumessubmitted urs =new updateresumessubmitted ();
                
                urs.updateresumessubmitted();
                
                requirement__c req = [select id, name, status__c from requirement__c where (status__c !='open' and status__c !='re-open')and (resumes_submitted__c = 0) and createddate <=2013-09-25T00:00:00.000+0000  limit 1];
                System.debug('req:' +req);
                
                /*aggregateresult coa =[select count(status1__c) rescount, requirement__c from candidate_mapping__c where (Status1__c != 'rejected' and Status1__c !='LR Rejected') and requirement__c =:req.id group by requirement__c limit 1];
                System.debug('coa:' + coa);
                
                rescount1 = Integer.valueOf(coa.get('rescount'));
                System.debug('rescount1 :' + rescount1);
                
                req.submitted_resumes__c = 0;
                req.cumulative_resumes_submitted__c = 0;
                
                update req;
                              
          }*/
}