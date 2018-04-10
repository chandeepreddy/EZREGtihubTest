/**
 * @author           Gangadhar R
 * @version          1.0 
 * @date             8/07/2015
 * @Status           Developed
 * @description      This Trigger is to stop the Duplictaes on the attachment object.
 *
 */
trigger AttachmentNameDuplicate on Attachment (before insert) 
{
     
    List<String> lstAttachNames = new List<String>();
    for(Attachment att : trigger.New)
    {
        lstAttachNames.add(att.Name);
    }
        List<attachment> lstAttach = CDOC_Data_Utility.getAttachments(lstAttachNames); 
        if(lstAttach.size() >0)
        {
            for(Attachment att : trigger.New)
            {
              att.addError('Cannot upload a file with same Name.Please retry with different Name');
            }
        } 
}