@isTest
private class ODS_DateUtility_Test
{
    static testMethod void getDaystoAddForSundayByDoW_Test()
    {
        Test.startTest();
        ODS_DateUtility.getDaystoAddForSundayByDoW('Mon');
        ODS_DateUtility.getDaystoAddForSundayByDoW('Tue');
        ODS_DateUtility.getDaystoAddForSundayByDoW('Wed');
        ODS_DateUtility.getDaystoAddForSundayByDoW('Thu');
        ODS_DateUtility.getDaystoAddForSundayByDoW('Fri');
        ODS_DateUtility.getDaystoAddForSundayByDoW('Sat');
        ODS_DateUtility.getDaystoAddForSundayByDoW('Sun');
        Test.stopTest();
    }
    
    static testMethod void GetWeekBoundaryDatesByMonth_Test()
    {
        Test.startTest();
        DateTime startDtTme = DateTime.parse('01/11/2016 12:00 AM');
        DateTime EndDtTme = DateTime.parse('01/12/2016 12:00 AM');
        ODS_DateUtility.GetWeekBoundaryDatesByMonth(startDtTme);
        ODS_DateUtility.calculateWeekends(startDtTme,EndDtTme);
        ODS_DateUtility.getHoursByDayofDate('Mon');
        ODS_DateUtility.getHoursByDayofDate('Tue');
        ODS_DateUtility.getHoursByDayofDate('Wed');
        ODS_DateUtility.getHoursByDayofDate('Thu');
        ODS_DateUtility.getHoursByDayofDate('Fri');
        ODS_DateUtility.getHoursByDayofDate('Sat');
        ODS_DateUtility.getHoursByDayofDate('Sun');
        Test.stopTest();
    }
}