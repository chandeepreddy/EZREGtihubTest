trigger DuplicateLeadConversion on Lead (after update) {
    List<lead> ConvertedLeads = new List<Lead>();
    Map<String,Id> CompanyNameList = new Map<String,Id>();
    List<lead> DuplicateLeads = new List<Lead>();
    //List<lead> DupLeadsToconvert = new List<Lead>();
    List<Database.LeadConvert> lcList = new List<Database.LeadConvert>();
    Set<Id> LeadIds = new Set<Id>();
    Set<Id> CampaignIds = new Set<Id>();

    for(Lead ld : Trigger.New)
    {
        if(Trigger.OldMap.get(ld.Id).isConverted == false && Trigger.NewMap.get(ld.Id).isConverted == true && Trigger.NewMap.get(ld.Id).convertedAccountId != null)
        {
            CompanyNameList.put(ld.Company,ld.convertedAccountId);
            LeadIds.add(ld.Id);
            
        }
    }
    
     List<CampaignMember> getLeadCampaigns = [Select Id, LeadId, CampaignId from CampaignMember where LeadId in: LeadIds]; 
     If(getLeadCampaigns.size() > 0)
     {
     for(Campaignmember cam : getLeadCampaigns)
     {
         CampaignIds.add(cam.CampaignId);
     }
     } 
    
    
  //  DupLeadsToconvert = [select Id, Company from lead where company in: CompanyNameList.keyset() and isConverted = false];
   List<CampaignMember> DupLeadsToconvert = [ Select Id, LeadId,Lead.Company, CampaignId from CampaignMember where Lead.Company  in: CompanyNameList.keyset() and Lead.isConverted = false and CampaignId In: CampaignIds];
   
    for(CampaignMember dup : DupLeadsToconvert)
    {
       Database.LeadConvert lc = new Database.LeadConvert();
       lc.setLeadId(dup.LeadId);
       lc.setAccountId(CompanyNameList.get(dup.Lead.Company));
       lc.setConvertedStatus('Qualified');
       lcList.add(lc);
    }
    List<Database.LeadConvertResult> lcr = Database.convertLead(lcList);
    system.debug('lcr ++'+lcr);

}