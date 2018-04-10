/**
 * @author           Shahida
 * @version          1.0 
 * @date             22/12/2015
 * @Status           Developed
 * @description      Controller class to Export Contacts as .csv file
 *
 */
 public class EZRE_ExportContactController{

  public list<contact> lstCon{ get; set; }  
  public  EZRE_ExportContactsDate__c objExpCon;
  
  public EZRE_ExportContactController()
  { 
 
           
         DateTime dtExpCon=[select ExportedDate__c  from EZRE_ExportContactsDate__c Limit 1].ExportedDate__c;  //custom setting to set current date
          system.debug('------------after------------------'+dtExpCon );
         //list of contacts updated before the custom setting date    
         list<contact> lstContactRec=[SELECT Id, AccountId, Fax, Email,name ,lastmodifieddate,phone,FirstName, Force_com__c, HomePhone, 
                                    LastName,Inside_Sales_Rep__c, Title,MailingCity, MailingCountry, MailingState, MailingStreet, MailingPostalCode,
                                    MobilePhone, OtherPhone, Salutation, Account.Owner.name,Account.name FROM Contact where ((MobilePhone!=null) or (phone!=null)) and force_com__c=true and lastmodifieddate<:dtExpCon Limit 900];
                                    
                                    
                                    
         lstCon=new list<contact>();
         
         //for loop to iterate through all the contacts in the list
        for(contact objCon:lstContactRec)
        {
            contact objcontact=new contact();
            objcontact.Salutation=objCon.Salutation;
            objcontact.firstName=objCon.FirstName;
            objcontact.LastName=objCon.LastName;            
            objcontact.Inside_Sales_Rep__c=objCon.Inside_Sales_Rep__c;
            objcontact.Title=objCon.Title;
            objcontact.MailingStreet=objCon.MailingStreet;
            objcontact.MailingCity=objCon.MailingCity;
            objcontact.MailingState=objCon.MailingState;
            objcontact.MailingPostalCode=objCon.MailingPostalCode;
            objcontact.MailingCountry=objCon.MailingCountry;                     
            string strPhone=objCon.Phone; 
            string strPhoneNo;
            if(!String.isBlank(strPhone))
            {
            strPhoneNo= strPhone.replaceAll('\\D','');//replace all special characters inPhone with space
            strPhoneNo='1'+strPhoneNo;   //appending 1 at the starting of Phone number  
            }
            else
            {
                strPhoneNo='';
            }               
            objcontact.Phone=strPhoneNo;
            
            
            string strMobilePhone=objCon.MobilePhone; 
            string strMobilePhoneNo;
            if(!String.isBlank(strMobilePhone))
            {
            strMobilePhoneNo= strMobilePhone.replaceAll('\\D','');//replace all special characters in MobilePhone with space
            strMobilePhoneNo='1'+strMobilePhoneNo;   //appending 1 at the starting of MobilePhone number  
            }
            else
            {
                strMobilePhoneNo='';
            }               
            objcontact.MobilePhone=strMobilePhoneNo;
            
            objcontact.Fax=objCon.Fax;
            objcontact.Email=objCon.Email;         
            objcontact.Department=objCon.Account.Owner.name;      
            objcontact.AssistantName=objCon.Account.name;
            objcontact.Id=objCon.Id;            
            lstCon.add(objcontact);
            
        }
     system.debug('@@@@@@@@@@@@@@@@@list of contacts'+lstCon);
  }
  
  
 // <OBJECTIVE>
 //Method to update custom setting to current date when we click "Export Contacts" button
  public pagereference getContacts()
  {    
     
     DateTime dT = System.now();           
     list<EZRE_ExportContactsDate__c> lstExpCon=[select ExportedDate__c  from EZRE_ExportContactsDate__c Limit 1];
       system.debug('------------after------------------'+lstExpCon);
       list<EZRE_ExportContactsDate__c> lstExportedDates=new list<EZRE_ExportContactsDate__c>();
     for(EZRE_ExportContactsDate__c ExpCon :lstExpCon)
     {
           EZRE_ExportContactsDate__c objExpCon=new EZRE_ExportContactsDate__c();
           objExpCon.ExportedDate__c= dT;
           objExpCon.id=ExpCon.id;
           lstExportedDates.add(objExpCon);
          
      }
       update lstExportedDates;
  
       pagereference pg=page.EZRE_ExportContactDetailPage;
       pg.setRedirect(false);
       return pg;
  }
  
}