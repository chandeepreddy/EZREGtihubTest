/*
 * @author           Gangadhar R
 * @version          1.0 
 * @date             26/02/2016
 * @description      Test class for EZRE_InsideSalesRep_Report
 * @Modified By      Shahida K 
 * @Modified Date    24.06.2016
 * @modifiedBy       Shahida K
 * @modifiedDate     20/01/2016
 * @description      Added Lead Gen Name and If Others Please Specify field to account and contact test data.
 */  
@IsTest
public class EZRE_InsideSalesRep_Report_Test
{
    /// <OBJECTIVE>
   /// Method is to Test the RunReport method  in insidesalesReport class with force.com account and force.com Contact
   /// </OBJECTIVE> 
   public static testmethod void  runReportPositiveSFDC_Test()
   {
         Profile prof = EZRE_DataFactory_Test_Utility.getProfile('System Administrator');
         //Fech User role
         UserRole  UserRole = [select id,name from UserRole Where Name = 'ISR-India'];   
         //Fetch user      
         user usr = EZRE_DataFactory_Test_Utility.CreateUserWithRole('standt','standarduser@testorg.com','UTF-8','Testing','en_US','en_US',Prof.Id,'America/Los_Angeles','Testuser1568@testmail24.com',UserRole.Id);
         
        System.runAs(usr)
        {       
            test.startTest();  
            //Insert account with Force.com as true
            Account acc = new Account(Name='test',phone='9808796756',AnnualRevenue = 1000,force_com__c = true,Inside_SalesRep__c='Sen Poulami',website='www.yahoo.com',Lead_Gen_Name__c='Others',if_Others_Please_Specify__c='Shahida',NumberOfEmployees=100,Industry = 'Technology');
            insert acc;
            //Insert account with Force.com as true
            Account acc1 = new Account(Name='testaccount',phone='9808796756',AnnualRevenue = 2000,force_com__c = true,Inside_SalesRep__c='Sen Poulami',website='www.abc.com',Lead_Gen_Name__c='Others',if_Others_Please_Specify__c='Shahida',NumberOfEmployees=100,Industry = 'Technology');
            insert acc1;
            //Insert contact with selected status '3: Meeting Set'
            contact Con = new contact(lastName = 'TestContact',AccountId = acc.Id,force_com__c = true,Status__c='3: Meeting Set',Lead_Gen_Name__c='Others',if_Others_Please_Specify__c='Shahida');
            insert con;
            //Insert contact with selected status '3: Meeting Set'
            contact Con1 = new contact(lastName = 'TestNewContact',AccountId = acc1.Id,force_com__c = true,Status__c='3: Meeting Set',Lead_Gen_Name__c='Others',if_Others_Please_Specify__c='Shahida');
            insert con1;
            //Insert Task with subject 'Connect(new)'
            Task act = new Task(Subject='Connect(new)',Whoid=Con.id,status='testSTatus',priority='testPriority');
            insert act;

            EZRE_InsideSalesRep_Report insideRepobj = new EZRE_InsideSalesRep_Report();
            EZRE_InsideSalesRep_Report.summary   insideRepsumry = new EZRE_InsideSalesRep_Report.summary(usr.name,2,2,0); 
                              
            insideRepobj.dtFromDate=Date.Today().addDays(-50);          
            insideRepobj.dtToDate =Date.Today().addDays(2);                       
            insideRepobj.strFilterValue = 'SFDC';
            insideRepobj.strContactFilterValue='SFDC';   
            insideRepobj.getFilterValues();
            insideRepobj.RunReport();
            insideRepobj.hidetable();
            insideRepobj.ExportAsCSV(); 
            insideRepobj.getContactFilterValues();  
                                  
            test.stopTest();
         
       }     
        
   } 
   /// <OBJECTIVE>
   /// Method is to Test the RunReport method  in insidesalesReport class with DataStax account and DataStax contact
   /// </OBJECTIVE> 
   public static testmethod void  runReportPositiveDatastax_Test()
   {
          Profile prof = EZRE_DataFactory_Test_Utility.getProfile('System Administrator');
         //Fech User role
         UserRole  UserRole = [select id,name from UserRole Where Name = 'ISR-India'];   
         //Fetch user      
         user usr = EZRE_DataFactory_Test_Utility.CreateUserWithRole('standt','standarduser@testorg.com','UTF-8','Testing','en_US','en_US',Prof.Id,'America/Los_Angeles','Testuser1568@testmail24.com',UserRole.Id);
         
       
        System.runAs(usr)
        {       
            test.startTest();
            //Insert account with Force.com as true         
            Account acc = new Account(Name='test',phone='9808796756',AnnualRevenue = 1000,DataStax__c = true,Inside_SalesRep__c='Sen Poulami',website='www.test.com',Lead_Gen_Name__c='Others',if_Others_Please_Specify__c='Shahida',NumberOfEmployees=100,Industry = 'Technology');
            insert acc;
            //Insert account with Force.com as true
            Account acc1 = new Account(Name='testaccount',phone='9808796756',AnnualRevenue = 2000,DataStax__c = true,Inside_SalesRep__c='Sen Poulami',website='www.testwebsite.com',Lead_Gen_Name__c='Others',if_Others_Please_Specify__c='Shahida',NumberOfEmployees=100,Industry = 'Technology');
            insert acc1;
            //Insert contact with selected status '3: Meeting Set'
            contact Con = new contact(lastName = 'TestContact',AccountId = acc.Id,DataStax__c= true,Status__c='3: Meeting Set',Lead_Gen_Name__c='Others',if_Others_Please_Specify__c='Shahida');
            insert con;
            //Insert contact with selected status '3: Meeting Set'
            contact Con1 = new contact(lastName = 'TestNewContact',AccountId = acc1.Id,DataStax__c = true,Status__c='3: Meeting Set',Lead_Gen_Name__c='Others',if_Others_Please_Specify__c='Shahida');
            insert con1;
            //Insert Task with subject 'Connect(new)'
            Task act = new Task(Subject='Connect(new)',Whoid=Con.id,status='testSTatus',priority='testPriority');
            insert act;
           
            EZRE_InsideSalesRep_Report insideRepobj = new EZRE_InsideSalesRep_Report();
            EZRE_InsideSalesRep_Report.summary   insideRepsumry = new EZRE_InsideSalesRep_Report.summary(usr.name,2,2,0); 
                              
            insideRepobj.dtFromDate=Date.Today().addDays(-50);          
            insideRepobj.dtToDate =Date.Today().addDays(2);                       
            insideRepobj.strFilterValue = 'DataStax';
            insideRepobj.strContactFilterValue='DataStax';          
            insideRepobj.getFilterValues();
            insideRepobj.RunReport();
            insideRepobj.hidetable();
            insideRepobj.ExportAsCSV(); 
            insideRepobj.getContactFilterValues();
                               
            test.stopTest();
          
       } 
            
        
   } 
    /// <OBJECTIVE>
   /// Method is to Test the RunReport method  in insidesalesReport class with ODS DotNet account and  ODS DotNet contact
   /// </OBJECTIVE>  
   public static testmethod void  runReportPositiveODSDotNet_Test()
   {
          Profile prof = EZRE_DataFactory_Test_Utility.getProfile('System Administrator');
         //Fech User role
         UserRole  UserRole = [select id,name from UserRole Where Name = 'ISR-India'];   
         //Fetch user      
         user usr = EZRE_DataFactory_Test_Utility.CreateUserWithRole('standt','standarduser@testorg.com','UTF-8','Testing','en_US','en_US',Prof.Id,'America/Los_Angeles','Testuser1568@testmail24.com',UserRole.Id);
         
       
        System.runAs(usr)
        {       
            test.startTest();  
            //Insert account with Force.com as true
            Account acc = new Account(Name='test',phone='9808796756',AnnualRevenue = 1000,ODSDotNet__c = true,Inside_SalesRep__c='Sen Poulami',website='www.yahoo.com',Lead_Gen_Name__c='Others',if_Others_Please_Specify__c='Shahida',NumberOfEmployees=100,Industry = 'Technology');
            insert acc;
            //Insert account with Force.com as true
            Account acc1 = new Account(Name='testaccount',phone='9808796756',AnnualRevenue = 2000,ODSDotNet__c = true,Inside_SalesRep__c='Sen Poulami',website='www.abc.com',Lead_Gen_Name__c='Others',if_Others_Please_Specify__c='Shahida',NumberOfEmployees=100,Industry = 'Technology');
            insert acc1;
            //Insert contact with selected status '3: Meeting Set'
            contact Con = new contact(lastName = 'TestContact',AccountId = acc.Id,ODSDotNet__c = true,Status__c='3: Meeting Set',Lead_Gen_Name__c='Others',if_Others_Please_Specify__c='Shahida');
            insert con;
            //Insert contact with selected status '3: Meeting Set'
            contact Con1 = new contact(lastName = 'TestNewContact',AccountId = acc1.Id,ODSDotNet__c = true,Status__c='3: Meeting Set',Lead_Gen_Name__c='Others',if_Others_Please_Specify__c='Shahida');
            insert con1;
            //Insert Task with subject 'Connect(new)'
            Task act = new Task(Subject='Connect(new)',Whoid=Con.id,status='testSTatus',priority='testPriority');
            insert act;

            EZRE_InsideSalesRep_Report insideRepobj = new EZRE_InsideSalesRep_Report();
            EZRE_InsideSalesRep_Report.summary   insideRepsumry = new EZRE_InsideSalesRep_Report.summary(usr.name,2,2,0); 
                              
            insideRepobj.dtFromDate=Date.Today().addDays(-50);          
            insideRepobj.dtToDate =Date.Today().addDays(2);                      
            insideRepobj.strFilterValue = 'ODSDotNet';
            insideRepobj.strContactFilterValue='ODSDotNet';  
            insideRepobj.getFilterValues();
            insideRepobj.RunReport();
            insideRepobj.hidetable();
            insideRepobj.ExportAsCSV(); 
            insideRepobj.getContactFilterValues();  
                                    
            test.stopTest();
          
       }     
        
   } 
    /// <OBJECTIVE>
   /// Method is to Test the RunReport method  in insidesalesReportCSV classwith Force.com account
   /// </OBJECTIVE> 
  public static testmethod void  runReportPositiveSFDCInCsv_Test()
   {
          Profile prof = EZRE_DataFactory_Test_Utility.getProfile('System Administrator');
         //Fech User role
         UserRole  UserRole = [select id,name from UserRole Where Name = 'ISR-India'];   
         //Fetch user      
         user usr = EZRE_DataFactory_Test_Utility.CreateUserWithRole('standt','standarduser@testorg.com','UTF-8','Testing','en_US','en_US',Prof.Id,'America/Los_Angeles','Testuser1568@testmail24.com',UserRole.Id);
         
        System.runAs(usr)
        {       
            test.startTest();  
            //Insert account with Force.com as true                 
             Account acc = new Account(Name='test',phone='9808796756',AnnualRevenue = 1000,force_com__c = true,Inside_SalesRep__c='Sen Poulami',website='www.gmail.com',Lead_Gen_Name__c='Others',if_Others_Please_Specify__c='Shahida',NumberOfEmployees=100,Industry = 'Technology');
            insert acc;
            //Insert account with Force.com as true     
            Account acc1 = new Account(Name='testaccount',phone='9808796756',AnnualRevenue = 2000,force_com__c = true,Inside_SalesRep__c='Sen Poulami',website='www.abcd.com',Lead_Gen_Name__c='Others',if_Others_Please_Specify__c='Shahida',NumberOfEmployees=100,Industry = 'Technology');
            insert acc1;
            //Insert contact with selected status '3: Meeting Set'
            contact Con = new contact(lastName = 'TestContact',AccountId = acc.Id,force_com__c = true,Status__c='3: Meeting Set',Lead_Gen_Name__c='Others',if_Others_Please_Specify__c='Shahida');
            insert con;
            //Insert contact with selected status '3: Meeting Set'
            contact Con1 = new contact(lastName = 'TestNewContact',AccountId = acc1.Id,force_com__c = true,Status__c='3: Meeting Set',Lead_Gen_Name__c='Others',if_Others_Please_Specify__c='Shahida');
            insert con1;
             //Insert Task with subject 'Connect(new)'
            Task act = new Task(Subject='Connect(new)',Whoid=Con.id,status='testSTatus',priority='testPriority');
            insert act;
            system.debug('-----------taskCreatedDate'+act.createdDate);
             
             string FromDateTime=string.valueOf(Date.Today());
             string ToDateTime=string.valueOf(Date.Today().addDays(5));
                          
             System.currentPageReference().getParameters().put('FromDate',FromDateTime);
             System.currentPageReference().getParameters().put('ToDate',ToDateTime);
             System.currentPageReference().getParameters().put('strFilterValue','SFDC');   
             System.currentPageReference().getParameters().put('ContactFilter','SFDC');                    
                        
            EZRE_InsideSalesRepReportAsCsv insideSalRepCsv=new EZRE_InsideSalesRepReportAsCsv();  
            EZRE_InsideSalesRepReportAsCsv.summary  summeryWrapper=new EZRE_InsideSalesRepReportAsCsv.summary(usr.name,2,2,0);                 
            insideSalRepCsv.FromDate=Date.Today().addDays(-50);
            insideSalRepCsv.ToDate =Date.Today().addDays(2);    
            insideSalRepCsv.strFilterValue = 'SFDC';
            insideSalRepCsv.strContactFilterValue='SFDC';                     
            insideSalRepCsv.RunReport();
            test.stopTest();
          
       }  
       
        
   }
    /// <OBJECTIVE>
   /// Method is to Test the RunReport method  in insidesalesReportCSV classwith DataStax account
   /// </OBJECTIVE> 
 public static testmethod void  runReportPositiveDataStaxInCsv_Test()
   {
          Profile prof = EZRE_DataFactory_Test_Utility.getProfile('System Administrator');
         //Fech User role
         UserRole  UserRole = [select id,name from UserRole Where Name = 'ISR-India'];   
         //Fetch user      
         user usr = EZRE_DataFactory_Test_Utility.CreateUserWithRole('standt','standarduser@testorg.com','UTF-8','Testing','en_US','en_US',Prof.Id,'America/Los_Angeles','Testuser1568@testmail24.com',UserRole.Id);
         
       
        System.runAs(usr)
        {       
            test.startTest();   
            //Insert account with Force.com as true                 
             Account acc = new Account(Name='test',phone='9808796756',AnnualRevenue = 1000,DataStax__c= true,Inside_SalesRep__c='Sen Poulami',website='www.gmail.com',Lead_Gen_Name__c='Others',if_Others_Please_Specify__c='Shahida',NumberOfEmployees=100,Industry = 'Technology');
            insert acc;
            //Insert account with Force.com as true     
            Account acc1 = new Account(Name='testaccount',phone='9808796756',AnnualRevenue = 2000,DataStax__c= true,Inside_SalesRep__c='Sen Poulami',website='www.abcd.com',Lead_Gen_Name__c='Others',if_Others_Please_Specify__c='Shahida',NumberOfEmployees=100,Industry = 'Technology');
            insert acc1;
            //Insert contact with selected status '3: Meeting Set'
            contact Con = new contact(lastName = 'TestContact',AccountId = acc.Id,DataStax__c= true,Status__c='3: Meeting Set',Lead_Gen_Name__c='Others',if_Others_Please_Specify__c='Shahida');
            insert con;
            //Insert contact with selected status '3: Meeting Set'
            contact Con1 = new contact(lastName = 'TestNewContact',AccountId = acc1.Id,DataStax__c= true,Status__c='3: Meeting Set',Lead_Gen_Name__c='Others',if_Others_Please_Specify__c='Shahida');
            insert con1;
            //Insert Task with subject 'Connect(new)'
            Task act = new Task(Subject='Connect(new)',Whoid=Con.id,status='testSTatus',priority='testPriority');
            insert act;
             
             string FromDateTime=string.valueOf(Date.Today());
             string ToDateTime=string.valueOf(Date.Today().addDays(5));
                          
             System.currentPageReference().getParameters().put('FromDate',FromDateTime);
             System.currentPageReference().getParameters().put('ToDate',ToDateTime);
             System.currentPageReference().getParameters().put('strFilterValue','DataStax');   
             System.currentPageReference().getParameters().put('ContactFilter','DataStax');         
             
            EZRE_InsideSalesRepReportAsCsv insideSalRepCsv=new EZRE_InsideSalesRepReportAsCsv();  
            EZRE_InsideSalesRepReportAsCsv.summary  summeryWrapper=new EZRE_InsideSalesRepReportAsCsv.summary(usr.name,2,2,0);                 
            insideSalRepCsv.FromDate=Date.Today().addDays(-50);
            insideSalRepCsv.ToDate =Date.Today().addDays(2);    
            insideSalRepCsv.strFilterValue ='DataStax';  
            insideSalRepCsv.strContactFilterValue='DataStax';          
            insideSalRepCsv.RunReport();
            test.stopTest();
        
            
       }  
        
        
   }  
     /// <OBJECTIVE>
   /// Method is to Test the RunReport method  in insidesalesReportCSV classwith Force.com account
   /// </OBJECTIVE> 
  public static testmethod void  runReportPositiveODSDotNetInCsv_Test()
   {
         Profile prof = EZRE_DataFactory_Test_Utility.getProfile('System Administrator');
         //Fech User role
         UserRole  UserRole = [select id,name from UserRole Where Name = 'ISR-India'];   
         //Fetch user      
         user usr = EZRE_DataFactory_Test_Utility.CreateUserWithRole('standt','standarduser@testorg.com','UTF-8','Testing','en_US','en_US',Prof.Id,'America/Los_Angeles','Testuser1568@testmail24.com',UserRole.Id);
         
       
        System.runAs(usr)
        {       
            test.startTest();  
            //Insert account with Force.com as true                 
             Account acc = new Account(Name='test',phone='9808796756',AnnualRevenue = 1000,ODSDotNet__c = true,Inside_SalesRep__c='Sen Poulami',website='www.gmail.com',Lead_Gen_Name__c='Others',if_Others_Please_Specify__c='Shahida',NumberOfEmployees=100,Industry = 'Technology');
            insert acc;
            //Insert account with Force.com as true     
            Account acc1 = new Account(Name='testaccount',phone='9808796756',AnnualRevenue = 2000,ODSDotNet__c = true,Inside_SalesRep__c='Sen Poulami',website='www.abcd.com',Lead_Gen_Name__c='Others',if_Others_Please_Specify__c='Shahida',NumberOfEmployees=100,Industry = 'Technology');
            insert acc1;
            //Insert contact with selected status '3: Meeting Set'
            contact Con = new contact(lastName = 'TestContact',AccountId = acc.Id,ODSDotNet__c = true,Status__c='3: Meeting Set',Lead_Gen_Name__c='Others',if_Others_Please_Specify__c='Shahida');
            insert con;
            //Insert contact with selected status '3: Meeting Set'
            contact Con1 = new contact(lastName = 'TestNewContact',AccountId = acc1.Id,ODSDotNet__c = true,Status__c='3: Meeting Set',Lead_Gen_Name__c='Others',if_Others_Please_Specify__c='Shahida');
            insert con1;
             //Insert Task with subject 'Connect(new)'
            Task act = new Task(Subject='Connect(new)',Whoid=Con.id,status='testSTatus',priority='testPriority');
            insert act;
            system.debug('-----------taskCreatedDate'+act.createdDate);
             
             string FromDateTime=string.valueOf(Date.Today());
             string ToDateTime=string.valueOf(Date.Today().addDays(5));
                          
             System.currentPageReference().getParameters().put('FromDate',FromDateTime);
             System.currentPageReference().getParameters().put('ToDate',ToDateTime);
             System.currentPageReference().getParameters().put('strFilterValue','ODSDotNet');   
             System.currentPageReference().getParameters().put('ContactFilter','ODSDotNet');    
             
            EZRE_InsideSalesRepReportAsCsv insideSalRepCsv=new EZRE_InsideSalesRepReportAsCsv();  
            EZRE_InsideSalesRepReportAsCsv.summary  summeryWrapper=new EZRE_InsideSalesRepReportAsCsv.summary(usr.name,2,2,0);                 
            insideSalRepCsv.FromDate=Date.Today().addDays(-50);
            insideSalRepCsv.ToDate =Date.Today().addDays(2);    
            insideSalRepCsv.strFilterValue = 'ODSDotNet';
            insideSalRepCsv.strContactFilterValue='ODSDotNet';                     
            insideSalRepCsv.RunReport();
            test.stopTest();
          
       }  
       
        
   }
     
  
}