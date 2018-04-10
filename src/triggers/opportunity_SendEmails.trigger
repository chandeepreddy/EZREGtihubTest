trigger opportunity_SendEmails on Opportunity (after insert, after update) {
    List<Opportunity> opportunity_SendMail = new List<Opportunity>();
    if(trigger.isUpdate)
        {
            for(Opportunity opportunityObj: trigger.new){
                Opportunity opp_beforeUpdate = trigger.oldMap.get(opportunityObj.Id);
                if(opp_beforeUpdate.StageName != 'Closed Won' && opportunityObj.StageName == 'Closed Won' )
                    opportunity_SendMail.add(opportunityObj);
            }
        }   
    
    if(trigger.isInsert)
    {
        for(Opportunity opportunityObj: trigger.new){           
            if(opportunityObj.StageName == 'Closed Won' )
                opportunity_SendMail.add(opportunityObj);
        }
    }
    
    if(opportunity_SendMail !=NULL && !opportunity_SendMail.isEmpty())
        opportunity_SendEmailCntrl.sendEmailMethod(opportunity_SendMail);
    
}