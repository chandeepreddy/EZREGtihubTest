/**
 * @author           Indumathi.V
 * @version          1.0 
 * @date             30-Sept-2016
 * @Status           Developed
 * @description      Custom Iterable class used EZRE_MCOldDataDeletionBatch for deleting Mailchimp objects
 *                  
 **/
global class EZRE_MC_CustomIterable{
/*global class EZRE_MC_CustomIterable implements Iterable<SObject>,Iterator<SObject>

   public Iterator<SObject> iterator() { return this; }
  
   public Mailchimp_Details__c MCDtls{get;set;} 
   public List<MCCandidateList__c> lstMCCndt {get;set;}
   public List<MC_Marketing__c> lstMCMrktng {get;set;}
   public List<SObject> sobjs {get; set;} 
   Integer i {get; set;} 
   
    ///OBJECTIVE
    ///To get the list of data from MCCandidateList__c which has been modified last 10 days 
    ///OBJECTIVE 
    public List<MCCandidateList__c> getMCCndtSbsrbrLst()
    {
         MCDtls = new Mailchimp_Details__c();
         lstMCCndt = new List<MCCandidateList__c>();
         
         MCDtls = EZRE_Data_Utility.getMCDtls('MCAccount');
         System.debug('MCDtls -----------'+MCDtls );
        Integer iDate = 10;
        
        System.debug('MCDtls.DateforDeletion__c-----Marktng------'+MCDtls.DateforDeletion__c);

        
        If(MCDtls.DateforDeletion__c != null)
        {
            System.debug('iDate ----Candidate-1------'+iDate );
            iDate = Integer.valueOf(MCDtls.DateforDeletion__c);
        }
        
        System.debug('iDate ----Candidate-2------'+iDate );
        
         lstMCCndt = EZRE_Data_Utility.getMCCndtOldData(iDate );
         
         System.debug('lstMCCndt -----------'+lstMCCndt.size() );
         return lstMCCndt ;     
    
    }
    
    ///OBJECTIVE
    ///To get the list of data from MCMarketing__c which has been modified last 10 days 
    ///OBJECTIVE 
    public List<MC_Marketing__c> getMCMrktngSbsrbrLst()
    {
        MCDtls = new Mailchimp_Details__c();
        lstMCMrktng = new List<MC_Marketing__c>();
         
        MCDtls = EZRE_Data_Utility.getMCDtls('MC Marketing');
        System.debug('MCDtls -----------'+MCDtls );
        Integer iDate = 10;
        
        System.debug('MCDtls.DateforDeletion__c-----Marktng------'+MCDtls.DateforDeletion__c);
        
        If( MCDtls.DateforDeletion__c != null || MCDtls.DateforDeletion__c != 0 )
        {
            iDate = Integer.valueOf(MCDtls.DateforDeletion__c);
            System.debug('iDate -----Marktng--1----'+iDate );
        }
        
        System.debug('iDate -----Marktng-2----'+iDate );
        
        lstMCMrktng = EZRE_Data_Utility.getMCMrktngOldData(iDate );
         
        System.debug('lstMCMrktng -----------'+lstMCMrktng.size() );
        return lstMCMrktng ; 
        
    }
       
    
       
    public EZRE_MC_CustomIterable ()
    { 
        sobjs = new List<SObject>();
        i=0;
        
        getMCCndtSbsrbrLst();
        getMCMrktngSbsrbrLst();

        
        for( MC_Marketing__c objMrktng : lstMCMrktng) 
        {
            sobjs.add(objMrktng);
        }
        
        for( MCCandidateList__c objCndt : lstMCCndt) 
        {
            sobjs.add(objCndt);
        }
        System.debug('sobjs------in CustomIterable------'+sobjs);
        
    } 
    
    
    global boolean hasNext()
    { 
       if(i >= sobjs.size()) 
           return false; 
       else 
           return true; 
    }    
   
   global SObject next()
   { 
       if(i == 8){ i++; return null;} 
       i=i+1; 
       return sobjs[i-1]; 
        
   } 
    
    */
   
}