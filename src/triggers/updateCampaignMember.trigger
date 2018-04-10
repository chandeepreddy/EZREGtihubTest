trigger updateCampaignMember on Task (before insert, before update) {
    Profile p = [SELECT Id FROM Profile WHERE Name='ISR'];
    
    List<Campaignmember> campaignmemberlist = new List<Campaignmember>();
    
    Set<Id> LeadIds = new Set<Id>();
    Set<String> campaignNames = new Set<String>();
    for(Task t : trigger.new){
        String wId = t.WhoId;
        if(wId!=null && (wId.startsWith('00Q') || wId.startsWith('003'))  && !LeadIds.contains(t.WhoId)){
            LeadIds.add(t.WhoId);
            campaignNames.add(t.Campaign__c);
            system.debug('==task campaign name==' +t.Campaign__c);
            system.debug('====campaignNamesSet===' +campaignNames);
        }
    }
    system.debug('===leadids===' +leadids);
    List<Lead> leadlist = new List<lead>();
    
    List<campaignmember> campmem = [SELECT Id, Campaign.name, sprint__c,campaignId, Run__c, LeadId FROM CampaignMember where (LeadId in:LeadIds or contactid in:LeadIds) and Campaign.name in: campaignNames];
    List<campaignmember> cmlist = new List<campaignmember>();
    system.debug('===campmem===' +campmem);
     if(trigger.isInsert && trigger.isbefore){
        if(campmem.size()>0){
        system.debug('===campmemsize>0===');
        if(p.Id == UserInfo.getProfileId())
        {
            for(task t:trigger.new){  
               // task tk = trigger.oldmap.get(t.id);
                if(t.Status == 'Completed'){
                    system.debug('===entertask===');
                    
                    for(campaignmember c: campmem){
                        t.Campaign_lookup__c = c.CampaignId;
                        system.debug('===' +c.campaignid);
                        system.debug('===entercampmem===');
                        
                        if(cmlist.size()<1) {
                            if(c.Run__c == 'Run 0'){
                                t.Run__c = 'Run 1';
                                c.Run__c = 'Run 1';
                                t.Sprint__c = c.Sprint__c;
                                system.debug('===entered===');
                                cmlist.add(c);
                            }}
                        
                        if(cmlist.size()<1) {
                            if(c.Run__c == 'Run 1'){
                                t.Run__c = 'Run 2';
                                c.Run__c = 'Run 2';
                                t.Sprint__c = c.Sprint__c;
                                system.debug('===entered===');
                                cmlist.add(c);
                            }}
                        
                        if(cmlist.size()<1) {
                            if(c.Run__c == 'Run 2'){
                                t.Run__c = 'Run 3';
                                c.Run__c = 'Run 3';
                                t.Sprint__c = c.Sprint__c;
                                system.debug('===entered===');
                                cmlist.add(c);
                            }}
                        
                        if(cmlist.size()<1) {
                            if(c.Run__c == 'Run 3'){
                                t.Run__c = 'Run 4';
                                c.Run__c = 'Run 4';
                                t.Sprint__c = c.Sprint__c;
                                system.debug('===entered===');
                                cmlist.add(c);
                            }}
                        
                        if(cmlist.size()<1) {
                            if(c.Run__c == 'Run 4'){
                                t.Run__c = 'Run 5';
                                c.Run__c = 'Run 5';
                                t.Sprint__c = c.Sprint__c;
                                system.debug('===entered===');
                                cmlist.add(c);
                            }}
                        
                        if(cmlist.size()<1) {
                            if(c.Run__c == 'Run 5'){
                                t.Run__c = 'Run 6';
                                c.Run__c = 'Run 6';
                                system.debug('===entered===');
                                cmlist.add(c);
                            }}
                        
                        if(cmlist.size()<1) {
                            if(c.Run__c == 'Run 6'){
                                t.Run__c = 'Run 7';
                                c.Run__c = 'Run 7';
                                t.Sprint__c = c.Sprint__c;
                                system.debug('===entered===');
                                cmlist.add(c);
                            }}
                        
                        if(cmlist.size()<1) {
                            if(c.Run__c == 'Run 7'){
                                t.Run__c = 'Run 8';
                                t.Sprint__c = c.Sprint__c;
                                c.Run__c = 'Run 8';
                                system.debug('===entered===');
                                cmlist.add(c);
                            }}
                        
                        if(cmlist.size()<1) {
                            if(c.Run__c == 'Run 8'){
                                t.addError('Already there is a Run 8 activity logged');
                                system.debug('===entered===');
                                cmlist.add(c);
                            }}
                        
                        
                    }
                }                update cmlist;  }
            
        }}}
    if(trigger.isUpdate && trigger.isbefore){
        if(campmem.size()>0){
        system.debug('===campmemsize>0===');
        if(p.Id == UserInfo.getProfileId())
        {
            for(task t:trigger.new){  
                task tk = trigger.oldmap.get(t.id);
                if(t.Status == 'Completed' & t.Status != tk.Status){
                    system.debug('===entertask===');
                    
                    for(campaignmember c: campmem){
                        t.Campaign_lookup__c = c.CampaignId;
                        system.debug('===' +c.campaignid);
                        system.debug('===entercampmem===');
                        
                        if(cmlist.size()<1) {
                            if(c.Run__c == 'Run 0'){
                                t.Run__c = 'Run 1';
                                c.Run__c = 'Run 1';
                                t.Sprint__c = c.Sprint__c;
                                system.debug('===entered===');
                                cmlist.add(c);
                            }}
                        
                        if(cmlist.size()<1) {
                            if(c.Run__c == 'Run 1'){
                                t.Run__c = 'Run 2';
                                c.Run__c = 'Run 2';
                                t.Sprint__c = c.Sprint__c;
                                system.debug('===entered===');
                                cmlist.add(c);
                            }}
                        
                        if(cmlist.size()<1) {
                            if(c.Run__c == 'Run 2'){
                                t.Run__c = 'Run 3';
                                c.Run__c = 'Run 3';
                                t.Sprint__c = c.Sprint__c;
                                system.debug('===entered===');
                                cmlist.add(c);
                            }}
                        
                        if(cmlist.size()<1) {
                            if(c.Run__c == 'Run 3'){
                                t.Run__c = 'Run 4';
                                c.Run__c = 'Run 4';
                                t.Sprint__c = c.Sprint__c;
                                system.debug('===entered===');
                                cmlist.add(c);
                            }}
                        
                        if(cmlist.size()<1) {
                            if(c.Run__c == 'Run 4'){
                                t.Run__c = 'Run 5';
                                c.Run__c = 'Run 5';
                                t.Sprint__c = c.Sprint__c;
                                system.debug('===entered===');
                                cmlist.add(c);
                            }}
                        
                        if(cmlist.size()<1) {
                            if(c.Run__c == 'Run 5'){
                                t.Run__c = 'Run 6';
                                c.Run__c = 'Run 6';
                                system.debug('===entered===');
                                cmlist.add(c);
                            }}
                        
                        if(cmlist.size()<1) {
                            if(c.Run__c == 'Run 6'){
                                t.Run__c = 'Run 7';
                                c.Run__c = 'Run 7';
                                t.Sprint__c = c.Sprint__c;
                                system.debug('===entered===');
                                cmlist.add(c);
                            }}
                        
                        if(cmlist.size()<1) {
                            if(c.Run__c == 'Run 7'){
                                t.Run__c = 'Run 8';
                                t.Sprint__c = c.Sprint__c;
                                c.Run__c = 'Run 8';
                                system.debug('===entered===');
                                cmlist.add(c);
                            }}
                        
                        if(cmlist.size()<1) {
                            if(c.Run__c == 'Run 8'){
                                t.addError('Already there is a Run 8 activity logged');
                                system.debug('===entered===');
                                cmlist.add(c);
                            }}
                        
                        
                    }
                }                update cmlist;  }
            
        }}}
    for(task t:trigger.new){
        system.debug('@@@CHECK@@@');
        
        for(campaignmember c: campmem){
            system.debug('@@@TEST56576@@@');
            
            t.Campaign_lookup__c = c.CampaignId;
            system.debug('------' +c.campaignid);
            
        }}
}