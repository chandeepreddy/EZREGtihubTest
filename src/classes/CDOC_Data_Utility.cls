/**
 * @author           Gangadhar R
 * @version          1.0 
 * @date             10/7/2015
 * @Status           Developed
 * @description      Data Utility is a class for fetching data from objects and for performing DML operations in objects.
 *
 */
public class CDOC_Data_Utility
{
    ///<OBJECTIVE>
    /// Fetch the attachment Details.
    ///<OBJECTIVE>
    public static List<attachment> getAttachments(list<string> lstAttachNames)
    {
        return  [SELECT Name FROM Attachment where name IN :lstAttachNames];
    }
}