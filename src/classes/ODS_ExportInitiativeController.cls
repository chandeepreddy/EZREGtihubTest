public class ODS_ExportInitiativeController{   
    public string CurrenInitiativeId {get;set;}
    public string InitiativeName {get;set;}
    public string InitiativeAccount {get;set;}
    public string BriefDescription {get;set;}
    public string InitiativeAccountService {get;set;}
    public Date FromDate {get;set;}
    public Date ToDate {get;set;}
    public string Status {get;set;}
    public string ApproverName {get;set;}
    public string Assumption {get;set;}
    public string Comments {get;set;}
    public boolean CheckAssumption {get;set;}
    public boolean CheckComments {get; set;}
    public boolean CheckBriefDescription {get; set;}
    public boolean CheckBriefDescription_Assumption {get; set;}
    public Date ApprovedDate {get;set;}
    public string InitiativeEntries {get;set;}
    public string InitiativeDescription_Assumption {get;set;}
    public  String Account {get;set;}
    /* This Constructor is used to set all the neccessary information needed for ExportInitiativeExcel VF Page. */
    public ODS_ExportInitiativeController(){
           CurrenInitiativeId = Apexpages.currentpage().getparameters().get('InitiativeId');
           System.debug('@@@@@CurrenInitiativeId'+CurrenInitiativeId);        
           String BriefDescription_Size;
           String Comments_Size;
           Initiatives__c initiativeUtility = ODS_Data_Utility.FetchExportInitiativeByID(CurrenInitiativeId);
           system.debug('initiativeUtility=========='+initiativeUtility);
           if( initiativeUtility  != null){
                   InitiativeName = initiativeUtility.Name;
                   InitiativeAccount = initiativeUtility.Account_Service__r.Account__r.Name;
                   if(InitiativeAccount!=null)
                        Account = InitiativeAccount.replaceAll(',', ' ');
                   InitiativeAccountService = initiativeUtility.Account_Service__r.ODS_Service_Name__c;
                   
                   BriefDescription = initiativeUtility.Brief_Description__c;
                   Status = initiativeUtility.Status__c;
                   FromDate = initiativeUtility.Probable_Start_Date__c;
                   ToDate = initiativeUtility.Probable_End_Date__c;
                   ApproverName = initiativeUtility.Approver_Name__r.Name;
                   Comments = initiativeUtility.Comments__c;
                   Assumption = initiativeUtility.Assumption__c;
                   System.debug(Comments);
                   System.debug(BriefDescription);                                                
                   if( (BriefDescription != null) ){
                             if((BriefDescription.trim().length()  > 0) ){
                                   CheckBriefDescription_Assumption  = true;
                             }
                             else{
                                   CheckBriefDescription_Assumption = false;
                             }
                   }  
                   else{
                             CheckBriefDescription_Assumption = false;
                   }                        

                   ApprovedDate = initiativeUtility.Approved_Date__c;
           }   
           
           InitiativeDescription_Assumption = BuildInitiaitiveHtml(); 
           InitiativeEntries =  BuildEstimateHtml();   
           System.debug('@@@@InitiativeEntries:'+InitiativeEntries);  
    }
    
    
    public string BuildInitiaitiveHtml(){
            Initiatives__c init = [select Brief_Description__c, Assumption__c from Initiatives__c Where  Id =: CurrenInitiativeId];
            String InitiativeBuilder = '<table>';       
            InitiativeBuilder += '<tr>';
            InitiativeBuilder += '</tr>';           
            InitiativeBuilder += '<table border=\'7 px solid #d7d7d7\'  style="width: 500px;">';            
            InitiativeBuilder += '<tr>';
            InitiativeBuilder += '<th style="background: #3399cc; border: 7px solid #d7d7d7; border-right: none; border-bottom: none;  color: #fff; font-size: 14px;   padding:5px; text-align: center;"><strong>BRIEF-DESCRIPTION</strong>';
            InitiativeBuilder += '</th>';
            InitiativeBuilder += '<th style="background: #3399cc; border: 7px solid #d7d7d7; border-right: none; border-bottom: none;  color: #fff; font-size: 14px;   padding:5px; text-align: center;"><strong>ASSUMPTION</strong>';
            InitiativeBuilder += '</th>';           
            InitiativeBuilder += '</tr>';
             
            InitiativeBuilder += '<tr>';
            InitiativeBuilder += '<td style=" padding:5px; border: 7px solid #d7d7d7; border-right: none; border-bottom: none; text-align: left; ">';
            if(init.Brief_Description__c != null){
                    InitiativeBuilder += init.Brief_Description__c;
            }
            InitiativeBuilder += '</td>';
            InitiativeBuilder += '<td style=" padding:5px; border: 7px solid #d7d7d7; border-right: none; border-bottom: none; text-align: left; ">';
            if(init.Assumption__c != null){
                 InitiativeBuilder += init.Assumption__c;
            }
            InitiativeBuilder += '</td>';
            InitiativeBuilder += '</tr>';
            InitiativeBuilder += '</table>';
            InitiativeBuilder += '</table>';
            return InitiativeBuilder;
    }
   
    /* This Method is used to get all the Estimates from the currentInitiativeId in table format to show the table format in exportInitiativeExcel VF Page.  */
    public string BuildEstimateHtml(){
              Integer increment_serialno = 1;
              List<Estimate__c> estimates = [Select Phase__c,Task_Components__c,Assumptions__c,Hours__c FROM Estimate__c where Initiative_Lookup__c =: CurrenInitiativeId];
              String EstimateBuilder = '<table border=\'1 px solid #d7d7d7\'   id=\'Tblinitiative\' cellpadding=\'0\' cellspacing=\'0\' width=\'100%\'>';               
              EstimateBuilder += '<tr>';
              EstimateBuilder += '<th style="background: #3399cc; border: 1px solid #d7d7d7; border-right: none; border-bottom: none;  color: #fff; font-size: 14px;   padding:5px; text-align: center;"><strong>S.No</strong>';
              EstimateBuilder += '</th>';

              EstimateBuilder += '<th style="background: #3399cc; border: 1px solid #d7d7d7; border-right: none; border-bottom: none;  color: #fff; font-size: 14px;   padding:5px; text-align: center;"><strong>PHASE</strong>';
              EstimateBuilder += '</th>';
              EstimateBuilder += '<th style="background: #3399cc; border: 1px solid #d7d7d7; border-right: none; border-bottom: none;  color: #fff; font-size: 14px;   padding:5px; text-align: center;"><strong>TASK/COMPONENTS</strong>';
              EstimateBuilder += '</th>';
              EstimateBuilder += '<th style="background: #3399cc; border: 1px solid #d7d7d7; border-right: none; border-bottom: none;  color: #fff; font-size: 14px;   padding:5px; text-align: center;"><strong>ASSUMPTIONS</strong>';
              EstimateBuilder += '</th>';
              EstimateBuilder += '<th style="background: #3399cc; border: 1px solid #d7d7d7; border-right: none; border-bottom: none;  color: #fff; font-size: 14px;   padding:5px; text-align: center;"><strong>HOURS</strong>';
              EstimateBuilder += '</th>';
              EstimateBuilder += '</tr>';
              Decimal Count = 0;
              for(Estimate__c est : estimates){
                   EstimateBuilder += '<tr>';
                   EstimateBuilder += '<td style=" padding:5px; border: 1px solid #d7d7d7; border-right: none; border-bottom: none; text-align: left; ">';
                   EstimateBuilder += increment_serialno;
                   EstimateBuilder += '</td>';
                   EstimateBuilder += '<td style=" padding:5px; border: 1px solid #d7d7d7; border-right: none; border-bottom: none; text-align: left; ">';
                   EstimateBuilder += est.Phase__c;
                   EstimateBuilder += '</td>';
                   EstimateBuilder += '<td style=" padding:5px; border: 1px solid #d7d7d7; border-right: none; border-bottom: none; text-align: left; ">';
                   EstimateBuilder += est.Task_Components__c;
                   EstimateBuilder += '</td>';
                   EstimateBuilder += '<td style=" padding:5px; border: 1px solid #d7d7d7; border-right: none; border-bottom: none; text-align: left; ">';
                   if(est.Assumptions__c != null){
                         EstimateBuilder += est.Assumptions__c;
                   }      
                   EstimateBuilder += '</td>';
                   EstimateBuilder += '<td style=" padding:5px; border: 1px solid #d7d7d7; border-right: none; border-bottom: none; text-align: center; ">';
                   EstimateBuilder += est.Hours__c;
                   EstimateBuilder += '</td>';
                   EstimateBuilder += '</tr>';
                   Count +=est.Hours__c; 
                   increment_serialno++;
              }
              EstimateBuilder += '<tr style="background-color:#B0E2FF">';
              EstimateBuilder += '<td style=" padding:5px; border: 1px solid #d7d7d7; border-right: none; border-bottom: none; text-align: center; ">';
              EstimateBuilder += 'Total Hours';
              EstimateBuilder += '</td>';
              EstimateBuilder += '<td style=" padding:5px; border: 1px solid #d7d7d7; border-right: none; border-bottom: none; text-align: left; ">';
              EstimateBuilder += '</td>';
              EstimateBuilder += '<td style=" padding:5px; border: 1px solid #d7d7d7; border-right: none; border-bottom: none; text-align: left; ">';
              EstimateBuilder += '</td>';
              EstimateBuilder += '<td style=" padding:5px; border: 1px solid #d7d7d7; border-right: none; border-bottom: none; text-align: left; ">';
              EstimateBuilder += '</td>';
              EstimateBuilder += '<td style=" padding:5px; border: 1px solid #d7d7d7; border-right: none; border-bottom: none; text-align: center; ">';
              EstimateBuilder += Count;
              EstimateBuilder += '</td>';
              EstimateBuilder += '</tr>';
              EstimateBuilder += '</table>';
              return EstimateBuilder;
     }

}