/**
 * @author           Gangadhar R
 * @version          1.0 
 * @date             10/7/2015
 * @Status           Developed
 * @description      Test Utility Class is a public test class that contain reusable code for test data creation.
 *
 */
@isTest
public class CDOC_DataFactory_Test_Utility
{ 
     ///OBJECTIVE
    /// Insert records in "attachment" standard object and return the inserted attachment record.
    ///OBJECTIVE
    public static  attachment InsertAttachment(Id cdId)
    { 
        Attachment attach = new Attachment();
            attach.Name='Unit';
            Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
            attach.body=bodyBlob;
            attach.parentId = cdId;
        
            insert attach;
            return attach;
    }
    ///<OBJECTIVE>
    /// Fetch list of Attachments.
    ///<OBJECTIVE>
    public static List<attachment> fetchAttachments(Id CDId)
    {
         return [select id, name from Attachment where parent.id =:CDId];
    }
     ///OBJECTIVE
    /// Insert records in "CDOC__c" custom object and return the inserted CDOC__c record.
    ///OBJECTIVE
    public static  CDOC__c InsertCDOC()
    { 
        CDOC__c cd = new CDOC__c();
            cd.Name = 'Unit';
            insert cd;
            return cd;
    }
}