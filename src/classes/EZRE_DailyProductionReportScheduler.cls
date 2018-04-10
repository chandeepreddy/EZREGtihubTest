global class EZRE_DailyProductionReportScheduler implements Schedulable
{
    global  void Execute(schedulableContext SC)
    {        
        //EZRE_SendProductionReportWithAttachement sch = new EZRE_SendProductionReportWithAttachement();
        //EZRE_SendProductionReportWithAttachement.sendEmail();
        
        EZRE_SendMailDailyProductivity objSendMail = new EZRE_SendMailDailyProductivity();
        objSendMail.sendMail();
    }
}