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
private class testclassCandidateMapfromCandidatesEdit
{
static testMethod void myUnitTest()
{

String oppid;
String cid;
String Userid;
Integer i,j,k;
/*Id id1 = UserInfo.getUserRoleId();
UserRole test1 = [Select Name from UserRole where id = :id1 limit 1];
system.test.starttest();
Profile p = [SELECT Id FROM Profile where Name = 'R Chatter Only User' ];
userRole r=[select id from userrole where Name = 'Recruiter' ];
User u = new User(Alias = 'testa', Email='standarduser1@testorg.com',
EmailEncodingKey='UTF-8', LastName='Testaa', LanguageLocaleKey='en_US',
LocaleSidKey='en_US', ProfileId = p.Id,
TimeZoneSidKey='America/Los_Angeles', UserName='standarduser1@testorg.com.ezredev',userRoleid=r.id);

System.runAs(u)
{*/
Candidate_Mapping__c coa =new Candidate_Mapping__c();

coa.status1__c = 'Applied';
coa.Employer_s_Authorization__c = 'test';
coa.LR_Comments__c = 'test by lr';
coa.MR_Comments__c = 'test by MR';
coa.Requirement_Owner_Email__c = 'testOwner@preludesys.com';
coa.Manager_Email_ID__c = 'testOwner1@preludesys.com';
coa.R_Comments__c = '';
coa.LR_Status__c = 'Rejected';
coa.MR_Status__c = 'Applied';
coa.LR_Status_Date__c = DateTime.now().format('MM-dd-yyyy hh:mm a z', 'America/Los_Angeles');
coa.MR_Status_Date__c = DateTime.now().format('MM-dd-yyyy hh:mm a z', 'America/Los_Angeles');
coa.Submitted_to_Client__c = 'Yes';
coa.Interview_Scheduled__c = 'Yes';
coa.Interview_Accepted__c = 'Yes';
coa.Client_Interviewed__c = 'Yes';
coa.Client_Offered__c = 'Yes';
coa.Candidate_started__c = 'Yes';
coa.Comments__c = '';
candidate__c cc1=new candidate__c();

cc1.Name='test';
cc1.Last_name__c='testoneo';
cc1.Current_city__c='chennai';
cc1.Current_state__c='Maine';
cc1.Gender__c='Male';
cc1.Employer_Name__c='ttt';
cc1.Email__c='test@gmail.com';
cc1.interview_contact_phone__c='Mobile Phone';
cc1.Contract_type__c='Corp to Corp';
cc1.visa_type__c='H1 B';
cc1.cost__c =100;
cc1.mobile_phone_no__c='9890043500';
cc1.employer_contact_email__c='test@gmail.com';
cc1.Employer_Contact_Name_Name__c='tt';
cc1.Employer_Mobile_No__c='9988009876';
cc1.Employer_Name__c = 'jos';
cc1.Employer_Work_Phone_No__c = '(425) 264-6771';

cc1.Followup_Date__c =date.today();
insert cc1;
coa.Candidate__c=cc1.id;
system.debug('candid:'+cc1.id);

requirement__c rc1=new requirement__c();

rc1.Name='SampathReq';
//rc1.Job_Title__c='.net';
rc1.Duration__c='6';
rc1.No_Of_Resumes__c=2;
rc1.Min_Cost__c=100;
rc1.Max_Cost__c=200;
rc1.Rate__c=200;
rc1.Rate_Basis__c='Hourly';
rc1.Status__c='open';
rc1.Position_Type__c='Contract';
rc1.State__c='CA';
rc1.City__c='CA';
rc1.Est_Start_Date__c=date.today();
rc1.won__c = true;
insert rc1;
coa.Requirement__c=rc1.id;

/*RequirementAssignment__c oppa=new RequirementAssignment__c();
oppa=new RequirementAssignment__c();
oppa.Requirement__c=rc1.Id;
oppa.Recruiter__c =u.Id;
oppa.won__c = 'yes';
System.Debug('U:'+ oppa.Recruiter__c);
insert oppa;*/

insert coa;
List<ContentVersion> cv = new List<ContentVersion>();
cv = [Select Id, Candidate_ID__c From ContentVersion where Candidate_ID__c =:coa.Candidate__c limit 1] ;
System.Debug('CV : '+ cv);
if(cv.Size()>0)
{
for(ContentVersion cv1 : cv)
{
Candidate__c can = new Candidate__c(Id = cc1.Id);
can.Resume_Attach__c = '0584000000003RrAAI';
update can;
}
}
CandidateMapfromCandidatesEdit cc = new CandidateMapfromCandidatesEdit();
cc.save();
apexpages.currentpage().getparameters().put('cid' , coa.id);
cc.save();
system.assert(coa!= null);
cc.cancel();
cc.save();
}
/*Profile p1 =[SELECT Id From Profile where Name= 'LR Chatter Only User'];
userRole r1 =[SELECT Id FROM UserRole where Name = 'Lead Recruiter'];
User u1 = new User(Alias = 'testuser', Email='testUser@testorg.com',
EmailEncodingKey='UTF-8', LastName='TestUseraa', LanguageLocaleKey='en_US',
LocaleSidKey='en_US', ProfileId = p1.Id,
TimeZoneSidKey='America/Los_Angeles', UserName='testUser@testorg.com.ezredev',userRoleid=r1.id);
System.runAs(u1){

Candidate_Mapping__c coa1 =new Candidate_Mapping__c();
coa1.status1__c = 'Applied';
coa1.Employer_s_Authorization__c = 'test';
coa1.LR_Comments__c = 'test by lr';
coa1.MR_Comments__c = 'test by MR';
coa1.Requirement_Owner_Email__c = 'testOwn1@preludesys.com';
coa1.Manager_Email_ID__c = 'testOwn1@preludesys.com';

coa1.R_Comments__c = '';
coa1.LR_Status__c = 'Rejected';
coa1.MR_Status__c = 'Applied';
coa1.LR_Status_Date__c = DateTime.now().format('MM-dd-yyyy hh:mm a z', 'America/Los_Angeles');
coa1.MR_Status_Date__c = DateTime.now().format('MM-dd-yyyy hh:mm a z', 'America/Los_Angeles');
coa1.Submitted_to_Client__c = 'Yes';
coa1.Interview_Scheduled__c = 'Yes';
coa1.Interview_Accepted__c = 'Yes';
coa1.Client_Interviewed__c = 'Yes';
coa1.Client_Offered__c = 'Yes';
coa1.Candidate_started__c = 'Yes';
coa1.Comments__c = '';
candidate__c cc1=new candidate__c();
cc1.Name='testtwo';
cc1.last_name__c='testtwo';
cc1.current_city__c='chennai';
cc1.current_state__c='Maine';
cc1.gender__c='Male';
cc1.Employer_Name__c='ttt';
cc1.email__c='test@gmail.com';
cc1.interview_contact_phone__c='Mobile Phone';
cc1.contract_type__c='w2';
cc1.visa_type__c='H1 B';
cc1.cost__c =100;
cc1.mobile_phone_no__c='9890043500';
cc1.employer_contact_email__c='test@gmail.com';
cc1.Employer_Contact_Name_Name__c='tyt';
cc1.Employer_Mobile_No__c='9988009876';
insert cc1;
coa1.Candidate__c=cc1.id;
system.debug('candid:'+cc1.id);

requirement__c rc1=new requirement__c();
rc1.Name='SampathReq0';
//rc1.Job_Title__c='.net0';
rc1.Duration__c='6';
rc1.No_Of_Resumes__c=2;
rc1.Min_Cost__c=100;
rc1.Max_Cost__c=200;
rc1.Rate__c=200;
rc1.Rate_Basis__c='Hourly';
rc1.Status__c='open';
rc1.Position_Type__c='Contract';
rc1.State__c='CA';
rc1.City__c='CA';
rc1.Est_Start_Date__c=date.today();
rc1.won__c = true;
insert rc1;
coa1.Requirement__c=rc1.id;

/*RequirementAssignment__c oppa=new RequirementAssignment__c();
oppa=new RequirementAssignment__c();
oppa.Requirement__c=rc1.Id;
oppa.lead_recruiter__c =u1.Id;
oppa.won__c = 'yes';
System.Debug('U:'+ oppa.lead_recruiter__c);
insert oppa;*/

/*insert coa1;
List<ContentVersion> cv = new List<ContentVersion>();
cv = [Select Id, Candidate_ID__c From ContentVersion limit 1] ;
if(cv.Size()>0)
{
for(ContentVersion cv1 : cv)
{
Candidate__c can = new Candidate__c(Id = cv1.Id);
//can.Cost__c = 0;
can.Resume_Attach__c = cv1.Id;
update can;
}
}
CandidateMapfromCandidatesEdit cc = new CandidateMapfromCandidatesEdit();
cc.save();
apexpages.currentpage().getparameters().put('cid' , coa1.id);
cc.save();

system.assert(coa1!= null);
cc.cancel();

cc.save();
}*/
//system.test.stoptest();
//}
}