/**
 * @author           Shahida k
 * @version          1.0 
 * @date             18/02/2016
 * @Status           Developed
 * @description      Class to get duplicate candidates based on email and mobile phone fields
 *
 */
public class EZRE_DuplicateCandidateDwnLoadController {
public list<Candidate__c> lstDupeCandidates{get;set;}
public EZRE_DuplicateCandidateDwnLoadController()
{
   
}
public pagereference exportDuplicateCandidates()
{

EZRE_BatchToDuplicateCandidates objCand=new  EZRE_BatchToDuplicateCandidates ();
database.executeBatch(objCand,2000);
return null;
}
}