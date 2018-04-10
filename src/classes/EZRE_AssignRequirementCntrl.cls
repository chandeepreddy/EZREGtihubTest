/*
 * @author           Soumya
 * @version          1.0 
 * @date             11/11/2014
 * @description      Controller for EZRE_AssignRequirementPage
 */  
public class EZRE_AssignRequirementCntrl
{
    public RequirementAssignment__c reqAssignment {get; set;}
    private  ApexPages.StandardController stdControllerObj; 
    
    //Constructor
    public EZRE_AssignRequirementCntrl(ApexPages.StandardController stdcontroller)
    {       
        this.stdControllerObj = stdController;
        this.reqAssignment  = (RequirementAssignment__c)stdControllerObj.getRecord();    
    } 
    
    //Method for Save action
    public pagereference save()
    {
        try
        {    
            PageReference pgRef;
            
            //Save Record
            stdControllerObj.Save();    
            
            this.reqAssignment  = (RequirementAssignment__c)stdControllerObj.getRecord();
            String strHost = 'https://'+ApexPages.currentPage().getHeaders().get('Host');
            PageReference ret = stdControllerObj.save();
            PageReference p = new PageReference('/'+ reqAssignment.Requirement__c); 
            p.setRedirect(true);              
            return p;               
        }
        catch(Exception excp)
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,excp.getMessage()));
            return null;                            
        }
    }
    
    //Method for Save&New action
    public Pagereference SaveAndNew()
    {       
        try 
        {   
            //Save
            stdControllerObj.Save();   
            Integer rqmntAssignCount = EZRE_SocialMedia_DataUtility.getCountRqmntAssgnmnt(reqAssignment.Requirement__c);
            String rqmntId = reqAssignment.Requirement__c;
            PageReference pgRef = new PageReference('/apex/EZRE_AssignRequirementPage');  
            pgRef.setRedirect(true); 
            this.reqAssignment  = (RequirementAssignment__c)stdControllerObj.getRecord();
            
            String strHost = 'https://'+ApexPages.currentPage().getHeaders().get('Host');
            PageReference ret = stdControllerObj.save();
            PageReference p = Page.EZRE_AssignRequirementPage;              
            p.setRedirect(true); 
            return p;
              
        } 

        catch(Exception excp)
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,excp.getMessage()));
            return null;             
        }
    }
    
    //Method for Cancel action
    public PageReference Cancel()
    {
        PageReference pgRef;
        this.reqAssignment  = (RequirementAssignment__c)stdControllerObj.getRecord();
        stdControllerObj.Cancel();
        Schema.DescribeSObjectResult describeResult = stdControllerObj.getRecord().getSObjectType().getDescribe();               
        
        //Check whether to navigate to Requirement page or list page
        if(reqAssignment.Requirement__c != NULL)
            pgRef = new PageReference('/' + reqAssignment.Requirement__c);
        else
            pgRef = new PageReference('/' + describeResult.getKeyPrefix() + '/o');
     
        pgRef.setRedirect(true); 
        
        return pgRef;
    }
}