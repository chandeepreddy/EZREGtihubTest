/**
 * @author           Krishnakumari
 * @version          1.0 
 * @date             26-May-2017
 * @Status           In Development
 * @description      To insert the attachment in the document record
 */

@RestResource(urlMapping='/ODS_DragAndDrop/v1/*')
global class ODS_DragAndDropRESTAPI
{
    @HttpPost
    global static String attachDoc(){
        RestRequest req = RestContext.request;
        RestResponse res = Restcontext.response;
        
        String fName = req.params.get('FileName'); 
        String docName = req.params.get('DocName'); 
        String accountService= req.params.get('AccountService');
        String accountId= req.params.get('AccountId'); 
        String folderId= req.params.get('ParentId');
        String fileType= req.params.get('ContentType');
        Blob postContent = req.requestBody; 
        
        system.debug('==accountService==='+accountService);
        system.debug('==folderId==='+folderId);
        
        Account_Services__c[] accountServices = [SELECT Id,Account__r.Name,Document_Suffix__c FROM Account_Services__c where Id=:accountService];

        String attachmentName = accountServices[0].Document_Suffix__c +'_'+ fName;//Append the account service id to the attachment name
        
        //To insert the document
        Documents__c newDocument = ODS_Data_Utility.InsertDocument(docName,accountService,accountId,fileType,folderId);
        
        //To insert the attachment under the document  
        
        Attachment a = ODS_Data_Utility.InsertAttachment(newDocument.Id,postContent,attachmentName);
        
        //To update the attachment id in the document
        ODS_Data_Utility.UpdateDocument(newDocument.Id,a.Id);
        system.debug('==AttachName==='+a.name);
        return a.Id;
   }
}