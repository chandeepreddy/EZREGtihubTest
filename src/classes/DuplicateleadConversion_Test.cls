@isTest
public class DuplicateleadConversion_Test {

    Static testmethod void testDuplicateLead()
    {
	Lead l = new Lead(Company = 'Test Lead',
                      LastName = 'Lead Last Name',
                      Lead_Gen_Name__c = 'Amit',
                      Website = 'www.Test1.com',
                      Status = '1: Calling');
    insert l;  
        Lead le = new Lead(Company = 'Test Lead',
                      LastName = 'Lead Last Name2',
                      Lead_Gen_Name__c = 'Amit',
                      Website = 'www.Test1.com',
                      Status = '1: Calling');
    insert le;  
    
    
    Campaign Cam = new Campaign(Name = 'Test Prelude');
    insert Cam;
        
    List<CampaignMember> CMInsert = new List<CampaignMember>();    
    CampaignMember CM1 = new campaignmember(status = 'Qualified', campaignid = cam.id, leadid = l.id);
    CMInsert.add(CM1);    
    CampaignMember CM2 = new campaignmember(status = 'Qualified', campaignid = cam.id, leadid = le.id);
    CMInsert.add(CM2);   
    Insert CMInsert;    
        
Database.LeadConvert lc = new database.LeadConvert();
lc.setLeadId(le.id);
lc.setDoNotCreateOpportunity(false);
//lc.setConvertedStatus('Converted');
LeadStatus convertStatus = [Select Id, MasterLabel FROM LeadStatus WHERE IsConverted=true LIMIT 1];
lc.setConvertedStatus(convertStatus.MasterLabel);


Database.LeadConvertResult lcr = Database.convertLead(lc);
System.assert(lcr.isSuccess());
//System.AssertEquals (1, [Select Id from Account].size());    
    }}