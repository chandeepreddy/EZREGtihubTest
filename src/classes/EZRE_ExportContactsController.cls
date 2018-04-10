/**
 * @author           Shahida
 * @version          1.0 
 * @date             17/12/2015
 * @Status           Developed
 * @description      Controller class to Export Contacts as .csv file
 *
 */
 public class EZRE_ExportContactsController{ 
  public EZRE_ExportContactsController()
  {   
   
  }
  //Method to call bacth class
  public void exportContacts()
  {
    EZRE_BatchToExportContacts objbatch=new EZRE_BatchToExportContacts();   
    database.executeBatch(objbatch,200);
  
  }
  
}