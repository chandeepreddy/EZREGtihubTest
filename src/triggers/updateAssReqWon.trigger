/*
 * @CreatedBy        Selva Pandian
 * @version          1.0 
 * @date             2/5/2013 1:59 AM
 * @Modified By      Shahida K
 * @Modified Date    24/08/2016
 * @description      trigger to send FTE Requirement update email alert to PC.
 */  
trigger updateAssReqWon on Requirement__c (after update, before insert)
{
  
    public  String requirement='';
    public List<Messaging.SingleEmailMessage> emailList=new List<Messaging.SingleEmailMessage>();
    system.debug('EZRE_RecursionCheckforTrigger.isFutureUpdate'+EZRE_RecursionCheckforTrigger.isFutureUpdate);   
    
    if((trigger.isBefore)&&(trigger.isInsert))
    {
        for(Requirement__c req: trigger.new)
        {
            req.Resumes_Number__c = req.No_Of_Resumes__c;
        }
    }
    system.debug('requirement update=========='+EZRE_RecursionCheckforTrigger.isFutureUpdate);
  
    if((trigger.isAfter)&&(trigger.isUpdate))
    {
        if(EZRE_RecursionCheckforTrigger.isFutureUpdate!=true)
        { 
        EZRE_RecursionCheckforTrigger.isFutureUpdate=true;
        
        Map<String,RequirementAssignment__c> reqAssMap = new Map<String,RequirementAssignment__c>();
        user up = [Select u.Id from User u where (u.Profile.Name ='Lead Recruiter' or u.Profile.Name ='LR Chatter Only User') and Isactive = true limit 1];
        system.debug('LeadRecruiters==========='+up);
        List<RequirementAssignment__c> listreq = [Select Id, Name, won__c, Lead_Recruiter__c, Recruiter__c,Requirement__c,Requirement_Status__c from RequirementAssignment__c where requirement__c IN :Trigger.OldMap.KeySet() limit 1];
        system.debug('list of requirement==========='+listreq); 
        List<RequirementAssignment__c> RAA = new List<RequirementAssignment__c>();
        for(RequirementAssignment__c reqAss : listreq )
        {
            reqAssMap.put(reqAss.requirement__c,reqAss);
        }
        for(Requirement__c req :Trigger.old)
        {
            if(reqAssMap.containsKey(req.Id))
            {
              system.debug('LR============='+reqAssMap.get(req.Id).Lead_Recruiter__c);
              if(reqAssMap.get(req.Id).Lead_Recruiter__c == null)
                {
                   reqAssMap.get(req.Id).Lead_Recruiter__c = up.id;
                   system.debug('reqAssMap============='+reqAssMap);
                }
              if(req.won__c == true)
                {
                   reqAssMap.get(req.Id).won__c = 'Yes';
                  system.debug('won if============'+ reqAssMap.get(req.Id).won__c);
                }
              else 
                {
                   reqAssMap.get(req.Id).won__c = 'No';
                   system.debug('won else============'+ reqAssMap.get(req.Id).won__c);
                }      
                RAA.add(reqAssMap.get(req.Id));
            }
        }   
        if(RAA.size()>0)
        {
            Database.DMLOptions dml = new Database.DMLOptions();
            database.update(RAA,dml);
             system.debug('update=========='); 
        }
    //Blow line of code is to send email alert to PC when  FTE Requirements got updated.    
    //Check trigger fired or not for current transaction    
    if(!updateAssReqWonHelper.isTriggerFired)
    {
        updateAssReqWonHelper.isTriggerFired=true;
        system.debug('IsTriggerFired================='+updateAssReqWonHelper.isTriggerFired);
        List<sObject > requirementList=new List<sObject>();
        String linkToRecord; 
        String requirementName='';
        //Add FTE Requirements to list
        for(sObject requirementRecord: trigger.new)
        {
            if((requirementRecord.get('Requirement_Type__c')=='FTE')||(trigger.oldMap.get((ID)requirementRecord.Id).get('Requirement_Type__c')=='FTE'))
            {
                requirementList.add(requirementRecord);
                system.debug('requirementName==========='+requirementName);
            }
        }
        
        // Get all the Requirement fields 
        Map <String, Schema.SObjectField> requirementFieldMap =schema.SObjectType.Requirement__c.fields.getMap(); 
        List<Schema.SObjectField> fieldNames=requirementFieldMap.values();
        Map<String,String> fieldsNameMap=new Map<String,String>();
        Map<String,String>  fieldTypeMap=new Map<String,String>();
         Map<String,String>  userIdNameMap=new Map<String,String>();
        List<User> userList=EZRE_Requirement_DataUtility.fetchUsers();
        for(User userObj:userList)
        {
            if(!userIdNameMap.containsKey(userObj.Id))
                userIdNameMap.put(userObj.Id,userObj.Name);
        }
        system.debug('userIdNameMap======='+userIdNameMap);

        for(Schema.SObjectField field:fieldNames)
        {
          //Build map with requirement field names and label
           fieldsNameMap.put(field.getDescribe().getName(),field.getDescribe().getLabel());
           //Build map for requirement field name and its field type
           fieldTypeMap.put(field.getDescribe().getName(),String.valueOf(field.getDescribe().getType()));
        }
        // For each FTE Requirement in the trigger
        for (sObject requirementRecord:requirementList)
        {
        
            String htmltable='';
            String htmlBodyWithChange='';
            String htmlBodyWithNoChange='';
            String htmlBody='';
            requirementName=String.valueOf(requirementRecord.get('Name'));
            String greetings='Dear PC ,</br></br>';
            String htmlHeader=greetings+'Please find the below FTE Requirement Got Updated:'+'<b>'+requirementName+'</b>'+'</br></br> <table border="1"> '+
            '<tr bgcolor="#c4d9ed">'+ 
            '<th>Field Name</th>' +
            '<th>Old Value</th>' +
            '<th>New Value</th>' +      
            '</tr>';

            // For each field
            for(String fieldAPI:fieldsNameMap.Keyset())
            {
                String fieldLabel=fieldsNameMap.get(fieldAPI);
                String fieldOldValue;
                String fieldNewValue;
                String oldDateTimeStr;
                String newDateTimeStr;

                 system.debug('Field Type:======='+fieldTypeMap.get(fieldAPI));
                 system.debug('Field Type:======='+fieldAPI);
                // Check whether new value != than old value for the same record
                if ((requirementRecord.get(fieldAPI) !=trigger.oldMap.get((ID)requirementRecord.Id).get(fieldAPI))||(fieldAPI=='Id')||(fieldAPI=='LastModifiedById'))
                {
                     system.debug('trigger.New========='+requirementRecord.get(fieldAPI));
                     system.debug('trigger.oldMap========='+trigger.oldMap.get((ID)requirementRecord.Id).get(fieldAPI));
                     
                    if(trigger.oldMap.get((ID)requirementRecord.Id).get(fieldAPI)!=null){
                        //Datetime formatting to show date time field values in mail as required format
                        if(fieldTypeMap.get(fieldAPI)=='DateTime')
                        {
                            datetime dt= DateTime.valueOf(trigger.oldMap.get((ID)requirementRecord.Id).get(fieldAPI));
                            oldDateTimeStr = dt.format('MM-dd-yyyy hh:mm:ss a');
                            System.debug('oldDateTimeStr =========='+oldDateTimeStr);
                           
                        }
                        else if(fieldTypeMap.get(fieldAPI)=='Date')
                        {
                            //formatting date field to remove unwanted time value in time field
                            Date  oldDateValue= Date.valueOf(trigger.oldMap.get((ID)requirementRecord.Id).get(fieldAPI));
                            //fieldOldValue=String.valueOf(oldDateValue);
                            date oldDateToFormat = date.newInstance(oldDateValue.Year(),oldDateValue.Month(),oldDateValue.Day());
                            fieldOldValue= oldDateToFormat.format().replace('/','-');
                        }
                        else
                        {
                            //Other than date and date time field values
                            fieldOldValue=String.valueOf(trigger.oldMap.get((ID)requirementRecord.Id).get(fieldAPI));
                        }
                    }       
                    else{
                    
                        fieldOldValue='';
                    }
                    
                    if(requirementRecord.get(fieldAPI)!=null){
                    
                        //Datetime formatting to show date time field values in mail as required format
                        if(fieldTypeMap.get(fieldAPI)=='DateTime')
                        {
                             Datetime dtm= DateTime.valueOf(requirementRecord.get(fieldAPI));
                             newDateTimeStr = dtm.format('MM-dd-yyyy hh:mm:ss a');
                             System.debug('newDateTimeStr =========='+newDateTimeStr );
                         
                        }
                        else if(fieldTypeMap.get(fieldAPI)=='Date')
                        {
                            //formatting date field to remove unwanted time value in time field
                            Date  newDateValue= Date.valueOf(requirementRecord.get(fieldAPI));
                            //fieldNewValue=String.valueOf(newDateValue);
                             date newDateToFormat = date.newInstance(newDateValue.Year(),newDateValue.Month(),newDateValue.Day());
                             fieldNewValue= newDateToFormat.format().replace('/','-');
                        }
                        else
                        {
                            //Other than date and date time field values
                            fieldNewValue=String.valueOf(requirementRecord.get(fieldAPI));
                        }
                    }
                    else{
                    
                        fieldNewValue='';
                    }
                    
                    //No field value got changed in update event
                     system.debug('fieldLabel################'+fieldAPI);
                    if((fieldAPI=='SystemModstamp')||(fieldAPI=='LastModifiedDate')){
                    
                        if((fieldAPI=='SystemModstamp'))
                        {
                             system.debug('fieldAPI################'+fieldAPI);
                        }
                        else
                        {
                            if(String.isBlank(oldDateTimeStr))  
                            {
                                oldDateTimeStr='';
                            }    
                            
                            if(String.isBlank(newDateTimeStr))
                            {                       
                                newDateTimeStr='';  
                            }
    
                            htmlBodyWithNoChange+='<tr>'+
                            '<td>'+fieldLabel+'</td>'+
                            '<td>'+oldDateTimeStr+'</td>'+
                            '<td>'+newDateTimeStr+'</td>'+
                            +'</tr>';  
                        }
                        system.debug('fieldLabel################'+oldDateTimeStr);
                        system.debug('fieldLabel################'+newDateTimeStr);
                    } 
                    else
                    {    
                        //Requirement Field value got updated
                        if(fieldAPI=='Id')
                        {
                            linkToRecord=fieldOldValue;
                            system.debug('@@@@@@@@@@@@linkToRecord --If'+linkToRecord);
                        }
                       else if(fieldTypeMap.get(fieldAPI)=='DateTime')
                       {
                           if(String.isBlank(newDateTimeStr))
                                newDateTimeStr='';
                              
                            if(String.isBlank(oldDateTimeStr))
                                oldDateTimeStr='';
                              
                                system.debug('@@@@@@@@@@@@'+fieldAPI);
                                htmlBodyWithChange+='<tr>'+
                                '<td>'+fieldLabel+'</td>'+
                                '<td>'+oldDateTimeStr+'</td>'+
                                '<td>'+newDateTimeStr+'</td>'+
                                +'</tr>';       
                       }
                       else
                       {

                             if(fieldAPI=='LastModifiedById')
                             {
                                fieldOldValue=userIdNameMap.get(fieldOldValue);
                                fieldNewValue=userIdNameMap.get(fieldNewValue);
                                system.debug('htmlBody@@@@@@@@@@@@'+userIdNameMap.get(fieldOldValue)); 
                                system.debug('htmlBody@@@@@@@@@@@@'+userIdNameMap.get(fieldNewValue)); 
                                fieldLabel='ModifiedBy'; 
                                 htmlBodyWithNoChange+='<tr>'+
                                    '<td>'+fieldLabel+'</td>'+
                                    '<td>'+fieldOldValue+'</td>'+
                                    '<td>'+fieldNewValue+'</td>'+
                                    +'</tr>';
                             }
                             else
                             {
                                 if(fieldTypeMap.get(fieldAPI)=='CURRENCY')
                                {
                                    system.debug('##############currency'+fieldAPI);
                                    if(String.isNotBlank(fieldOldValue))
                                    {
                                        String oldCurrency;
                                        fieldOldValue=( Decimal.valueOf(fieldOldValue==null||fieldOldValue.trim()==''?'0':fieldOldValue).setScale(2) +0.0010).format(); 
                                        oldCurrency=fieldOldValue.substring(0,fieldOldValue.length()-1);
                                        system.debug('formated oldCurrency============'+oldCurrency);
                                        fieldOldValue='$'+oldCurrency;
                                      
                                    }    
                                    if(string.isNotBlank(fieldNewValue)) 
                                    {      
                                          String newCurrency; 
                                          fieldNewValue=( Decimal.valueOf(fieldNewValue==null||fieldNewValue.trim()==''?'0':fieldNewValue).setScale(2) +0.0010).format(); 
                                          newCurrency=fieldNewValue.substring(0,fieldNewValue.length()-1);  
                                          system.debug('formated newCurrency============'+newCurrency);                          
                                          fieldNewValue='$'+newCurrency;
                                    }    
                                }
                                
                                system.debug('@@@@@@@@@@@@'+fieldAPI);
                                htmlBodyWithChange+='<tr>'+
                                '<td>'+fieldLabel+'</td>'+
                                '<td>'+fieldOldValue+'</td>'+
                                '<td>'+fieldNewValue+'</td>'+
                                +'</tr>'; 
                             }  
                       }
 
                   } 
                  
                   htmlBody=htmlBodyWithChange+htmlBodyWithNoChange;
                   system.debug('htmlBody@@@@@@@@@@@@'+htmlBody); 
                   system.debug('htmlBodyWithNoChange==============='+htmlBodyWithNoChange);
               }
            }
            htmltable+=htmlHeader+htmlBody+'</table>'+'</br>'+'<a href="'+URL.getSalesforceBaseUrl().toExternalForm() +'/'+linkToRecord+'">'+'LinkToRecord'+'</br></a>';
            system.debug('htmltable==============='+htmltable);
            system.debug('@@@@@@@@@@@@linkToRecord'+linkToRecord);
            if(htmlBody!=htmlBodyWithNoChange)
            {
               system.debug('##############Fields got changed ');
                emailList.add(updateAssReqWonHelper.sendMail(htmltable));
            }
            else
            {
                system.debug('##############No filed got changed .No Need to send Mail alert');
            }   
        }     
    }
     system.debug('emailList size!!!!!!!!!!!!'+emailList.size());
     if(emailList.size()>0)
     {
         Messaging.sendEmail(emailList);
     }   
    }
   }
}