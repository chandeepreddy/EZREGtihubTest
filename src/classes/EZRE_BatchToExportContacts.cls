/**
 * @author           Shahida
 * @version          1.0 
 * @date             18/12/2015
 * @Status           Developed
 * @description      Batch class to send Contacts as email attachment
 *
 */
global class EZRE_BatchToExportContacts implements Database.Batchable<sObject>, Database.Stateful
{
    public list<contact> lstContactRec;
    public list<contact>  lstCon;

    //Batch constructor
    global EZRE_BatchToExportContacts(){
       
    }

    //Batch start method
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
       //fetch all contacts having phone number
       return Database.getQueryLocator('Select  Name,Phone  From Contact Where phone!=null');
    }

    //Batch execute method
    global void execute(Database.BatchableContext BC, List<Contact> lstContactRec)
    {    
           
            lstCon=new list<contact>();         
            for(contact objCon:lstContactRec)
            {
                contact objcontact=new contact();
                objcontact.firstName=objCon.name;
                string strPhone=objCon.phone; 
                string strPhoneNo= strPhone.replaceAll('\\D','');   //replace all special character in the phone with space 
                strPhoneNo='1'+strPhoneNo;         //append '1' at the starting of phone number            
                objcontact.phone=strPhoneNo;
                lstCon.add(objcontact);
          
            }
        
    } 
      
    //Sending contacts mail attachment
    global void finish(Database.BatchableContext BC)
    {      
     
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            
            String strToAddress = System.Label.Email_Log_Address;    
            mail.setToAddresses( new String[] {strToAddress } );
            system.debug('---------------Emailid----------------'+strToAddress );
            mail.setSubject( 'Export Contacts');
            mail.setHtmlBody( 'Please find the attached csv file' );
            
            String contentCSV = '';
            //To create csv file content for attachment 
            for (Contact objCont :lstCon) {
                 Contact objContact=new Contact();
                 objContact.firstname=objCont.firstname;
                 objContact.phone=objCont.phone;
                 contentCSV += objContact.firstname + ',' + objContact.phone + '\n';
            }
            String content = 'Name, phone\n' + contentCSV;
            Messaging.EmailFileAttachment attachment = new Messaging.EmailFileAttachment();
            attachment.setFileName( 'Contacts.csv' );
            attachment.setBody( Blob.valueOf( content ) );
            mail.setFileAttachments( new Messaging.EmailFileAttachment[]{ attachment } );       
            Messaging.sendEmail( new Messaging.SingleEmailMessage[] { mail } );
        
       
        
    }
}