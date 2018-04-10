/**
*@author         Shahida K
*@status         Developed
*@createdDate    24/03/2016 
*@description    Test class for the Inside Sales Rep Report Email Alert Class
*/
@isTest
public class EZRE_InsideSalesRep_MonthlyReport_Test
{
public static testmethod void runReport_SFDCData_Test()
{
        //Fech User role
         UserRole  UserRole = [select id,name from UserRole Where Name = 'ISR-India'];   
         //Fetch user      
         user usr = [select id,name,userRoleId from user where userRoleId =: UserRole.Id AND isActive=true LIMIT 1];
         System.runAs(usr)
        {       
            test.startTest();  
            //Insert account with Force.com as true
            Account acc = EZRE_DataFactory_Test_Utl.createSfdcAccnt('test',1000,true,usr.Id,'www.yahoo.com');
         
            //Insert account with Force.com as true
            Account acc1 =EZRE_DataFactory_Test_Utl.createSfdcAccnt('testaccount',2000,true,usr.Id,'www.abc.com');
           
            //Insert contact with selected status '3: Meeting Set'
            contact Con =EZRE_DataFactory_Test_Utl.createSfdcContact('TestContact',acc.Id,true,'3: Meeting Set');
                       
            //Insert contact with selected status '3: Meeting Set'
            contact Con1 = EZRE_DataFactory_Test_Utl.createSfdcContact('TestNewContact',acc1.Id,true,'3: Meeting Set');
           
            //Insert Task with subject 'Connect(new)'
            Task act = EZRE_DataFactory_Test_Utl.createTask('Connect(new)',Con.id,'testSTatus','testPriority');

            EZRE_InsideSalesRep_MonthlyReport insideRepobj = new EZRE_InsideSalesRep_MonthlyReport();          
            insideRepobj.RunReport();                 
            test.stopTest();
          
       }     



}
///<OBJECTIVE>
///Method to test Inside Sales Rep Report email alert class functionlity
///</OBJECTIVE>
public static testmethod void runReport_DataStax_Test()
{
        //Fech User role
         UserRole  UserRole = [select id,name from UserRole Where Name = 'ISR-India'];   
         //Fetch user      
         user usr = [select id,name,userRoleId from user where userRoleId =: UserRole.Id AND isActive=true LIMIT 1];
         System.runAs(usr)
        {       
            test.startTest();  
            //Insert account with Force.com as true
            Account acc = EZRE_DataFactory_Test_Utl.createDataStaxAccnt('test',1000,true,usr.Id,'www.yahoo.com');
            
            //Insert account with Force.com as true
            Account acc1 =EZRE_DataFactory_Test_Utl.createDataStaxAccnt('testaccount',2000,true,usr.Id,'www.abc.com');      
            
            //Insert contact with selected status '3: Meeting Set'
            contact Con =EZRE_DataFactory_Test_Utl.createSfdcContact('TestContact',acc.Id,true,'3: Meeting Set');
                       
            //Insert contact with selected status '3: Meeting Set'
            contact Con1 = EZRE_DataFactory_Test_Utl.createSfdcContact('TestNewContact',acc1.Id,true,'3: Meeting Set');
           
            //Insert Task with subject 'Connect(new)'
            Task act = EZRE_DataFactory_Test_Utl.createTask('Connect(new)',Con.id,'testSTatus','testPriority');

            EZRE_InsideSalesRep_MonthlyReport insideRepobj = new EZRE_InsideSalesRep_MonthlyReport();          
            insideRepobj.RunReport();                 
            test.stopTest();
          
       }     



}





}