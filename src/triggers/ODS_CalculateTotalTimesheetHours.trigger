trigger ODS_CalculateTotalTimesheetHours on Time_Sheet_Details__c (after delete,after update, after insert, after undelete) {
    list<Initiatives__c> initiativesToUpdate = new list<Initiatives__c>();
    list<Initiatives__c> submtdInitiativesToUpdate = new list<Initiatives__c>();
    set<id> setInitiativeIds = new set<id>();
    if(trigger.isInsert){
      for(Time_Sheet_Details__c timeSheetInitiative : Trigger.new){
          if(timeSheetInitiative.Intiative__c != null){
              setInitiativeIds.add(timeSheetInitiative.Intiative__c);
          }
       }
    }
    else if(trigger.isDelete){
        for(Time_Sheet_Details__c timeSheetInitiative : Trigger.old){
            system.debug('###timeSheetInitiativeId:'+timeSheetInitiative.Id);
            if(timeSheetInitiative.Intiative__c != null){
                setInitiativeIds.add(timeSheetInitiative.Intiative__c);
            }
            system.debug('###setInitiativeIds:' +setInitiativeIds);
         }
    }
    else if(trigger.isUnDelete){
         for(Time_Sheet_Details__c timeSheetInitiative : Trigger.new){
         if(timeSheetInitiative.Intiative__c != null){
             setInitiativeIds.add(timeSheetInitiative.Intiative__c);
         }
         }
    }
    else if(trigger.isUpdate){
        system.debug('##Entering update criteria');
        for(Time_Sheet_Details__c timeSheetInitiative : trigger.new){
            if(trigger.oldmap.get(timeSheetInitiative.id).Intiative__c != timeSheetInitiative.Intiative__c && timeSheetInitiative.Intiative__c!=null){
                setInitiativeIds.add(timeSheetInitiative.Intiative__c);
                setInitiativeIds.add(trigger.oldmap.get(timeSheetInitiative.id).Intiative__c);
            }
            system.debug('###Old status:' +trigger.oldmap.get(timeSheetInitiative.id).TimesheetStatus__c);
            system.debug('###New status:' +timeSheetInitiative.TimesheetStatus__c);
            if(trigger.oldmap.get(timeSheetInitiative.id).TimesheetStatus__c != timeSheetInitiative.TimesheetStatus__c && timeSheetInitiative.Intiative__c!=null){                
                setInitiativeIds.add(timeSheetInitiative.Intiative__c);
            }
        }
    }
    AggregateResult[] listtimesheetdetails = [SELECT SUM(Hours_Worked__c), Intiative__c FROM Time_Sheet_Details__c 
                                                where Intiative__c IN :setInitiativeIds AND Timesheet__r.Status__c= 'Approved' 
                                                GROUP BY Intiative__c];
    system.debug('###listtimesheetdetails:' +listtimesheetdetails);
    if(listtimesheetdetails.size() > 0){
        for(AggregateResult ar:listtimesheetdetails) {
            system.debug('###Approved ar:' + ar);
            Id initiatId = (ID)ar.get('Intiative__c');
            Decimal hours = (DECIMAL)ar.get('expr0');
            system.debug('##Approved hours:' +hours);
            Initiatives__c objinitiative = new Initiatives__c(Id=initiatId);
            objinitiative.Consumed_Hours__c = hours;            
            initiativesToUpdate.add(objinitiative);
            system.debug('###objinitiative:' +objinitiative);
        }
    }
    else{
        system.debug('###No Records');
        for(Id initiativeId:setInitiativeIds){
            Initiatives__c objinitiative = new Initiatives__c(Id=initiativeId);
            objinitiative.Consumed_Hours__c = 0;
            initiativesToUpdate.add(objinitiative);
        }
    }
    update initiativesToUpdate;
    
    AggregateResult[] submitdTimesheetDtls = [SELECT SUM(Hours_Worked__c), Intiative__c FROM Time_Sheet_Details__c 
                                                where Intiative__c IN :setInitiativeIds 
                                                AND (Timesheet__r.Status__c= 'Submitted' OR Timesheet__r.Status__c='Saved' OR Timesheet__r.Status__c='Approved') 
                                                GROUP BY Intiative__c];
    system.debug('###submitdTimesheetDtls:' +submitdTimesheetDtls);
    if(submitdTimesheetDtls.size() > 0){
        for(AggregateResult ar: submitdTimesheetDtls) {
            system.debug('###ar:' + ar);
            Id initiatId = (ID)ar.get('Intiative__c');
            Decimal hours = (DECIMAL)ar.get('expr0');
            system.debug('##hours:' +hours);
            Initiatives__c objinitiative = new Initiatives__c(Id=initiatId);
            objinitiative.Submitted_Hours__c = hours;
            objinitiative.Status__c = 'Active Initiative';      
            submtdInitiativesToUpdate.add(objinitiative);
            system.debug('###objinitiative:' +objinitiative);
        }
    }
    else{
        system.debug('###No Submitted Records');
        for(Id initiativeId: setInitiativeIds){
            Initiatives__c objinitiative = new Initiatives__c(Id=initiativeId);
            objinitiative.Submitted_Hours__c = 0;
            submtdInitiativesToUpdate.add(objinitiative);
        }
    }
    update submtdInitiativesToUpdate;

}