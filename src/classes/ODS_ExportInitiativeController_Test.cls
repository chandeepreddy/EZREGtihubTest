@isTest
/*  This Test Class is for export initiative controller */
public class ODS_ExportInitiativeController_Test {
       /* This method is for testing the export initiative with comments */
       static testmethod void exportinitiativewithComments_test(){      
         Date StartDate = date.parse('12/2/2017');
         Date EndDate = date.parse('12/30/2017');           
         ID Initiative = ODS_DataFactory_Test_Utility.exportinitiative('Test Class',2,'Testing Purpose','Testing Purpose',StartDate,EndDate,'Saved');         
         ODS_DataFactory_Test_Utility.exportEstimates(4.56,Initiative,'Analysis','Task1');          
         System.debug('Initiative'+Initiative );
         Test.startTest();     
         PageReference pgref = Page.ODS_ExportInitiativeExcel;       
         pgref.getParameters().put('InitiativeId',Initiative);
         Test.setCurrentPage(pgRef);
         Test.StopTest();
         ODS_ExportInitiativeController sc = new ODS_ExportInitiativeController();

       }  
       /* This method is for testing the export initiative with out comments */
       static testmethod void exportinitiativewithoutComments_test(){   
         Date StartDate = date.parse('12/2/2017');
         Date EndDate = date.parse('12/30/2017');   
         ID Initiative = ODS_DataFactory_Test_Utility.exportinitiative('Test Class',2,'Testing Purpose','',StartDate,EndDate,'Saved');         
         ODS_DataFactory_Test_Utility.exportEstimates(4.56,Initiative,'Analysis','Task1');          
        
         Test.startTest();        
         PageReference pgref = Page.ODS_ExportInitiativeExcel;         
         pgref.getParameters().put('InitiativeId',Initiative);
         Test.setCurrentPage(pgRef);
         Test.StopTest();
         ODS_ExportInitiativeController sc = new ODS_ExportInitiativeController();
       }    
       /* This method is for testing the export initiative with brief description */
       static testmethod void exportinitiativewithoutBrief_Description_test(){       
         Date StartDate = date.parse('12/2/2017');
         Date EndDate = date.parse('12/30/2017');   
         ID Initiative = ODS_DataFactory_Test_Utility.exportinitiative('Test Class',2,'','Testing Purpose',StartDate,EndDate,'Saved');         
         ODS_DataFactory_Test_Utility.exportEstimates(4.56,Initiative,'Analysis','Task1');          
                   
         Test.startTest();       
         PageReference pgref = Page.ODS_ExportInitiativeExcel;        
         pgref.getParameters().put('InitiativeId',Initiative);
         Test.setCurrentPage(pgRef);
         Test.StopTest();
         ODS_ExportInitiativeController sc = new ODS_ExportInitiativeController();
       }
}