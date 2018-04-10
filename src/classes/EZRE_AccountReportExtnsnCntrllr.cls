/*
 * @author           Lavanya Aningi
 * @version          1.0 
 * @date             03/04/2016
 * @description      Controller for EZRE_AccountReport
 * @Modification     Indumathi.V
 */  


public class EZRE_AccountReportExtnsnCntrllr
{

    
    public List<Event> activit = new List<Event>();
    public List<Opportunity> oppLst {get;set;}
    public List<Event> eventLst {get;set;}
    public List<Task> tskLst {get;set;}
    public List<activityWrapper> lstWrppr {get;set;}
    public Id AccId{get;set;}
    public List<Contact> cntctLst {get;set;}
    public Set<String> stageNameSet {get;set;}
    public string stageNamesString{get;set;} 
    public List<Initiative__c> initveLst {get;set;}
    public List<sObject> evtTaskobj {get;set;} 
    public List<sortWrapper> sortedWrpprLst {get;set;}
    public Map<Id,List<Contact>> mapCntctRprtsTo {get;set;}    
    public List<String> lCntctHrchy {get;set;}
    public List<Contact> lRootCntct {get;set;}
    public List<OrgHrchyWrppr> lstHrchyWrppr {get;set;}

    ///<OBJECTIVE>
    /// Constructor
    ///</OBJECTIVE>
    public EZRE_AccountReportExtnsnCntrllr(Apexpages.StandardController controller) 
    {
    
        try
        {
            AccId= ApexPages.currentPage().getParameters().get('id');  
            
        }catch(Exception ex) {}
         
        oppLst  = new List<Opportunity>();
        eventLst = new List<Event>();
        tskLst = new List<Task>();
        cntctLst = new List<Contact>();        
        stageNameSet  = new Set<string>();
        initveLst = new List<Initiative__c>();
        
        try
        {
        
            cntctLst    =   EZRE_Data_Utility.fetchCntctList(AccId);
            initveLst   =   EZRE_Data_Utility.fetchIntitveList(AccId);       
            eventLst    =   EZRE_Data_Utility.fetchEventList(AccId );
            tskLst      =   EZRE_Data_Utility.fetchTaskList(AccId );
        
        }
        catch(Exception ex) {}
        
        lstWrppr = new List<activityWrapper>(); 
        
        //Convert the list of Stage Names into a  string to include in the query
        stageNameSet = new Set<String>{'Prospecting', 'Qualification','Needs Analysis','Value Proposition','Id. Decision Makers','Perception Analysis','Proposal/Price Quote','Negotiation/Review','Resume Submitted','Phone Screen','1st Interview','2nd Interview'};
        stageNamesString = convertStageNameToString(stageNameSet); 
        
        //Account Owner Full Name should not include 'Sriram'
        String strAccntOwner = System.Label.OppReport_AccountOwnerFilter;   
        
        //List of Opportunity with Stage Name and Account Owner as filter condition
       
        try
        {           
            oppLst = EZRE_Data_Utility.getOppList(AccId,stageNamesString,strAccntOwner);
        }catch (Exception ex){}
       
        //method to get activity list
        fetchWrapperList(AccId);  
        
        //method to get contact org hierarchy
        getOrgChart(AccId);
        
      
    }
    
    ///<OBJECTIVE>
    /// Method to construct Activity wrapper list
    ///</OBJECTIVE> 
    private void fetchWrapperList(String accIdString)
    {
        eventLst  = EZRE_Data_Utility.fetchEventList(accIdString);      
        tskLst = EZRE_Data_Utility.fetchTaskList(accIdString);
      
        evtTaskobj = new List<sObject>();
        evtTaskobj.addall((List<sObject>)(eventLst));
        evtTaskobj.addall((List<sObject>)(tskLst));
       
        sortedWrpprLst = new List<sortWrapper>();
        
        for(sObject obj : evtTaskobj)
        {
            sortedWrpprLst.add(new sortWrapper(obj));
            
        }
      
        sortedWrpprLst.sort();
    
        
        for(sortWrapper wrpObj: sortedWrpprLst)
        {
             String sub = string.valueOf(wrpObj.obj.get('Subject'));
             String id = string.valueOf(wrpObj.obj.get('Id'));
              String name;
             if(wrpObj.obj.getSObject('Who') != null)
             {
                name = string.valueOf(wrpObj.obj.getSObject('Who').get('Name'));
             }           
             
             String ownerId = string.valueOf(wrpObj.obj.get('OwnerId'));
             Date actDate = date.valueOf(wrpObj.obj.get('ActivityDate'));
             String ownerName;
             if(wrpObj.obj.getSObject('Owner') != null)
             {
                 ownerName = string.valueOf(wrpObj.obj.getSObject('Owner').get('Name'));
             }
             String whoId= string.valueOf(wrpObj.obj.get('WhoId'));
             
             
             lstWrppr.add(new activityWrapper(sub,id,name,ownerId,actDate,ownerName,whoId));    
        }
        
    
    }
    
    ///<OBJECTIVE>
    /// Wrapper class to sort the list of activities
    ///</OBJECTIVE> 
    
    public class sortWrapper implements Comparable
    {
        public sObject obj {get;set;}
        
        public sortWrapper(Sobject sObj)
        {
            obj = sObj;         
        }
        
        public integer compareTo(Object compareTo)
        {
            sortWrapper compareToMember = (sortWrapper)compareTo;
            
            Integer returnValue = 0;         
           
            Date  dt1 = date.valueOf(obj.get('ActivityDate'));
            Date dt2 = date.valueOf(compareToMember.obj.get('ActivityDate'));
     
           if(dt1 < dt2)        
            {
                returnValue = 1;
                
            }
            else if(dt1 > dt2)                
            {
                returnValue = -1;
                
            }
            return returnValue;
            
        }
        
    }
    
    
    ///<OBJECTIVE>
    /// Method to convert the set of Opportunity Stage Names to a single string
    ///</OBJECTIVE>  
     private String convertStageNameToString(Set<String> stageNameSet)
    {
        String str = '(\'';
        for (String s : stageNameSet)
        {
            str += s + '\',\'';
        }

        str  = str.substring(0,str.length()-2);
        str += ')';      
        return  str;
    }
    
    
 
    ///<OBJECTIVE>
    /// Wrapper Class to get Both the list of Events and Tasks
    ///</OBJECTIVE>
    
    public class activityWrapper 
    {
        public string subject{get;set;}
        public Id recrdId {get;set;}
        public String name{get;set;}
         public String assignedTo{get;set;}
          public Date activityDate{get;set;}
          public string ownerName {get;set;}
          public String whoId {get;set;}
        
        
        public activityWrapper(String subj, Id recrdId,String name, String assgnedTo, Date actDate, string ownerName,String whoId)
        {
             this.subject = subj;
             this.recrdId = recrdId;
             this.name =  name;
             this.assignedTo= assgnedTo;
             this.activityDate=  actDate;
             this.ownerName = ownerName;
             this.whoId = whoId;
        
        }
      
    }
    
    ///<OBJECTIVE>
    /// Method for Export as PDF button
    ///</OBJECTIVE>
    public pageReference exportAsPDF()
    {
        Pagereference pgf = new PageReference('/apex/EZRE_AccountReport_PDF?id='+AccId);
        pgf.setRedirect(true);
        return pgf;
    }
  
    
    ///<OBJECTIVE>
    ///Method to get the contact hierarchy in the report
    ///</OBJECTIVE>
    
     public void getOrgChart(String accntIdString)
    {
        lstHrchyWrppr = new List<OrgHrchyWrppr>(); 
        lRootCntct = new List<Contact>();
        List<Contact> lAllCntct = new List<Contact>();
        try 
        {
            lAllCntct = EZRE_Data_Utility.fetchCntctList(AccId);
        }catch(Exception ex){}
             
        mapCntctRprtsTo = new Map<Id,List<Contact>>();       
        lCntctHrchy  = new List<String>();    
        
        for(Contact oCntct : lAllCntct)
        {
            if(oCntct.ReportsTo.Id == null)
            {
                lRootCntct.add(oCntct);         
                
            }
            else if(oCntct.ReportsTo.Id != null)
            {
                if(!mapCntctRprtsTo.containskey(oCntct.ReportsTo.id))
                {
                    List<Contact> conlist = new List<Contact>();                                   
                    conlist.add(oCntct);
                    mapCntctRprtsTo.put(oCntct.ReportsTo.id, conlist );
                }
                else
                {
                    List<Contact> templist = mapCntctRprtsTo.get(oCntct.ReportsTo.Id);
                    mapCntctRprtsTo.remove(oCntct.ReportsTo.Id);
                    templist.add(oCntct);
                    mapCntctRprtsTo.put(oCntct.ReportsTo.Id,templist);
                }
                
            }
        
        }        
         
       
    }
    
    ///<OBJECTIVE>
    ///Wrapper class to contain the nodes and their children
    ///</OBJECTIVE>

    public class OrgHrchyWrppr
    {
        public Contact gpCntct {get; set;}
        public List<Contact> prntCntct {get;set;}
        public Map<ID,List<Contact>> chldCntct {get;set;}
        public Map<ID,List<Contact>> grndChldCntct {get;set;}
        
        public OrgHrchyWrppr(Contact gpCntct,List<Contact> prntCntct, Map<ID,List<Contact>>chldCntct,Map<ID,List<Contact>> grndChldCntct)
        {
            this.gpCntct = gpCntct;
            this.prntCntct = prntCntct;
            this.chldCntct = chldCntct;
            this.grndChldCntct = grndChldCntct;
        }       
        
    }
    
    
    
    ///<OBJECTIVE>
    ///Method to generate list of OrgHrchyWrppr Wrapper 
    ///</OBJECTIVE>
    public List<OrgHrchyWrppr> getHrchyWrppr()
    {
        Integer i=0;        
        
        Map<Id,List<Contact>> mapCntctWthId = new Map<Id,List<Contact>>();
        Set<Contact> setCntct= new Set<Contact>();
              
        for(Id cntctId : mapCntctRprtsTo.keyset())
        {
            setCntct.addall(mapCntctRprtsTo.get(cntctId));
            
        }   
      
        for(Contact objCntct : setCntct)
        {
            if(mapCntctRprtsTo.containskey(objCntct.id))
            {
                mapCntctWthId.put(objCntct.id,mapCntctRprtsTo.get(objCntct.id));
            }
           else
            {
                Contact newCntct = new Contact();
                newCntct.FirstName='';
                newCntct.LastName='dummy';
                List<Contact> tempc= new List<Contact>();                
                mapCntctWthId.put(objCntct.id,tempc);
            }
        }     
        
        Map<ID,List<Contact>> mapChldCntct= new  Map<ID,List<Contact>>(); 
               
        for(Contact gPrntCntct : lRootCntct)
        {

            List<contact> lPrntCntct = mapCntctRprtsTo.get(gPrntCntct.id);           
            
            if(lPrntCntct != Null)
            {
                for(Contact ccd: lPrntCntct)
                {
                    List<Contact> icon = new List<Contact>();
                    icon = mapCntctWthId.get(ccd.id);
                    IF(icon !=null && icon.size()>0)
                    {
                        mapChldCntct.put(ccd.id,icon);                      
                    }                   
                    else
                    {
                        contact newCntct = new Contact();
                        newCntct.FirstName='';
                        newCntct.LastName='dummy';
                        icon = new List<Contact>();                      
                        mapChldCntct.put(ccd.id,icon);  
                    }
                }
            }
            lstHrchyWrppr.add(new OrgHrchyWrppr(gPrntCntct,lPrntCntct,mapChldCntct,mapCntctWthId));            
            i++;  
            
        }
       
        return lstHrchyWrppr;
        
    }
    
    
}