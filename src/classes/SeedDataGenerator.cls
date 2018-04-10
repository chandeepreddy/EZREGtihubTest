public class SeedDataGenerator
{
    public static Map<Integer, HS_DataGenerationObjects__c> APINameMap {get;set;}
    public static Map<Integer, string> CSVContentMap {get;set;}
    public static Map<string, string> LookupFieldsMap {get;set;}
    public static boolean IsObjContainLookup{get;set;}
    public static Map<string, string> ObjectIDsMap {get;set;}
    
    public SeedDataGenerator()
    {
         CreateDataMapsByCustomSetting();
        List<Integer> sequenceOrderList = new List<Integer>();
        sequenceOrderList.addAll(CSVContentMap.keySet());
        sequenceOrderList.sort();
        List<List<sObject>> AllObjects = new List<List<sObject>>();
        List<sObject> IndividualObject = new List<sObject>();
        ObjectIDsMap= new Map<string, string>();
        Database.SaveResult[] savedResult;
        //List<DataGenerationLog__c> DataLog = new list<DataGenerationLog__c>();
        for(Integer sequenceOrder : sequenceOrderList){
            IsObjContainLookup = False;
            String contents = CSVContentMap.get(sequenceOrder) ;
          //  contents =  'name, CurrencyIsoCode\npavithra,USD';
            List<List<String>> parsedCSVContent = parseCSV(contents );
            
            if(LookupFieldsMap.containsKey((APINameMap.get(sequenceOrder)).Object_API_Name__c)){
                IsObjContainLookup = True;
            }                                       
            list<sObject> eachSObject=  InsertCsvTosObject(parsedCSVContent, (APINameMap.get(sequenceOrder)).Object_API_Name__c);                               
            //AllObjects.add(eachSObject);
            savedResult = Database.insert(eachSObject);
            string keyValue = '';
            for(sObject eachsObjectRecord: eachSObject){
                system.debug('##eachsObjectRecord:' +eachsObjectRecord);
                system.debug('###Ref'+(APINameMap.get(sequenceOrder)).Reference_Name__c);
                system.debug('###Ref1'+ eachsObjectRecord.get(string.valueOf((APINameMap.get(sequenceOrder)).Reference_Name__c)));
                keyValue += eachsObjectRecord.get(string.valueOf((APINameMap.get(sequenceOrder)).Reference_Name__c)) + '-' + eachsObjectRecord.get('Id') + ';';            
            }  
            ObjectIDsMap.put(((APINameMap.get(sequenceOrder)).Object_API_Name__c).toLowercase().trim() , keyValue);
            system.debug('###ObjectIDsMap:' +ObjectIDsMap); 
            string insertSuccessRecords ='';
            string status = 'Success';
            integer successRows = 0;
            integer failureRows = 0;
            string responseMessage = '';
            for (Database.SaveResult sr : savedResult) {
                if(sr.isSuccess()){
                    successRows += 1;
                    insertSuccessRecords += sr.getId() + ';';
                    responseMessage += sr.getId() + '-Records inserted successfully';
                }
                else{
                    failureRows += 1;
                    status = 'Failure';
                    responseMessage += sr.getId() + '-';
                    for(Database.Error err : sr.getErrors()) {
                        responseMessage += err.getMessage();
                    }
                }               
            }
            /*DataGenerationLog__c DataGenLog = new DataGenerationLog__c();
            DataGenLog.API_Name__c= (APINameMap.get(sequenceOrder)).Object_API_Name__c;
            DataGenLog.InsertedIDs__c = insertSuccessRecords;
            DataGenLog.Object_Name__c= (APINameMap.get(sequenceOrder)).Object_API_Name__c;
            DataGenLog.Response_Message__c= ResponseMessage;
            DataGenLog.No_Of_Rows_Failed__c = failureRows;
            DataGenLog.No_Of_Rows_Inserted__c = successRows;
            DataGenLog.Status__c = Status;
            DataLog.add(DataGenLog);*/
            
        }
        //insert DataLog;

        /*for(list<sObject>  objList : AllObjects){
            
            for(sObject obj :objList ){
                IndividualObject.add(obj);
            }
        }*/
        
    }
    
    public static void CreateDataMapsByCustomSetting()
    {
        Map<string, HS_DataGenerationObjects__c> dataGenCustomSettings = HS_DataGenerationObjects__c.getAll();        
        APINameMap = new Map<Integer, HS_DataGenerationObjects__c>();
        CSVContentMap = new Map<Integer, string>();
        LookupFieldsMap = new map<string, string>();
        string StaticCSVFolderName  = Label.HS_StaticCSVFolderName ;
        
        for(HS_DataGenerationObjects__c dataGenObject : dataGenCustomSettings.values()){
        if(dataGenObject.IsActive__c){
            PageReference fileReference = new PageReference('/resource/'+ StaticCSVFolderName + '/' + dataGenObject.CSV_File_Name__c);             
            system.debug('###fileReference :' +fileReference);
            Blob contentAsBlob;
            String contentAsText ='';
            if(!Test.isRunningTest()){
                try{
                    contentAsBlob = fileReference.getContent();
                    system.debug('Content Blob:' + contentAsBlob);
                    contentAsText = blobToString(contentAsBlob,'ISO-8859-1');
                    system.debug('Text Content:' + contentAsText); 
                    //contentAsText = EncodingUtil.base64Encode(contentAsBlob );
                }
                catch(Exception ex){
                    system.debug('##Exception:' +ex);
                }
            }
            else{
                contentAsText = 'NAME,CURRENCYISOCODE,COUNTRY__C\nLisbon,USD,UK15';
            }
            system.debug('###contentAsText :' +contentAsText);
            if(contentAsText != ''){
                CSVContentMap.put(Integer.valueOf(dataGenObject.Sequence_Of_Insert__c), contentAsText);
                APINameMap.put(Integer.valueOf(dataGenObject.Sequence_Of_Insert__c), dataGenObject);
                string LookupFld = '';
                if(dataGenObject.Lookup_1__c != null){                
                    LookupFld += string.valueof(dataGenObject.Lookup_1__c);                    
                } 
                /*if(dataGenObject.Lookup_2__c != null){                
                    LookupFld += ',' + string.valueof(dataGenObject.Lookup_2__c);                    
                }
                if(dataGenObject.Lookup_4__c != null){                
                    LookupFld += ',' + string.valueof(dataGenObject.Lookup_3__c);                    
                }
                if(dataGenObject.Lookup_3__c != null){                
                    LookupFld += ',' + string.valueof(dataGenObject.Lookup_4__c);                    
                } */
                
                if(LookupFld != ''){
                    LookupFieldsMap.put(string.valueof(dataGenObject.Object_API_Name__c),LookupFld);
                }
            }         
        }
        }
        
    }
    
    public static String blobToString(Blob input, String inCharset){
        String hex = EncodingUtil.convertToHex(input);
        System.assertEquals(0, hex.length() & 1);
        final Integer bytesCount = hex.length() >> 1;
        String[] bytes = new String[bytesCount];
        for(Integer i = 0; i < bytesCount; ++i)
            bytes[i] =  hex.mid(i << 1, 2);
        return EncodingUtil.urlDecode('%' + String.join(bytes, '%'), inCharset);
    }
    
    public static List<List<String>> parseCSV(String contents)
    {
        List<List<String>> allFields = new List<List<String>>();
    
        // replace instances where a double quote begins a field containing a comma
        // in this case you get a double quote followed by a doubled double quote
        // do this for beginning and end of a field
        contents = contents.replaceAll(',"""',',"DBLQT').replaceall('""",','DBLQT",');
        // now replace all remaining double quotes - we do this so that we can reconstruct
        // fields with commas inside assuming they begin and end with a double quote
        contents = contents.replaceAll('""','DBLQT');
        // we are not attempting to handle fields with a newline inside of them
        // so, split on newline to get the spreadsheet rows
        List<String> lines = new List<String>();
        try {
            lines = contents.split('\n');
        } catch (System.ListException e) {
            System.debug('Limits exceeded?' + e.getMessage());
        }
        Integer num = 0;
        for(String line : lines) {
            // check for blank CSV lines (only commas)
            if (line.replaceAll(',','').trim().length() == 0) break;
            
            List<String> fields = line.split(',');  
            List<String> cleanFields = new List<String>();
            String compositeField;
            Boolean makeCompositeField = false;
            for(String field : fields) {
                if (field.startsWith('"') && field.endsWith('"')) {
                    cleanFields.add(field.replaceAll('DBLQT','"'));
                } else if (field.startsWith('"')) {
                    makeCompositeField = true;
                    compositeField = field;
                } else if (field.endsWith('"')) {
                    compositeField += ',' + field;
                    cleanFields.add(compositeField.replaceAll('DBLQT','"'));
                    makeCompositeField = false;
                } else if (makeCompositeField) {
                    compositeField +=  ',' + field;
                } else {
                    cleanFields.add(field.replaceAll('DBLQT','"'));
                }
            }            
            allFields.add(cleanFields);
        }        
        return allFields;       
    }
    
    public static boolean IsLookupField(string objectAPIName, string ColumnName)
    {
        boolean isLookup = False;
        system.debug('###objectAPIName:' +objectAPIName+ '###ColumnName:' + ColumnName);
        system.debug('====LookupFieldsMap:' + LookupFieldsMap);
        string LookupFields = string.valueof(LookupFieldsMap.get(objectAPIName)).toLowercase();
        string ColumnNameTrim = ColumnName.trim().toLowercase();
        if(LookupFieldsMap.containsKey(objectAPIName)){
            system.debug('###LookupfieldsMapkey:' +LookupFieldsMap.get(objectAPIName));
            system.debug('###ColumnNameTrim:' +ColumnNameTrim);
            if(((LookupFieldsMap.get(objectAPIName)).toLowerCase()).contains(ColumnNameTrim)){            
                system.debug('Lokup available');
                isLookup = true;
            }                       
        }
        return isLookup;
    }    
    public static string FetchIdByLookup(string ObjectAPI, string ColumnName,string ColumnValue)
    {
        string ListOfLookupField = '';
        string LookupObjectAPIName;
        string LookupID = '';
        //string ProfileName  = Label.HS_Profile_Name;
        Map<string, string> LookupFieldobjectMap = new Map<string,string>();
        Map<string, string> InsertedObjectMap = new Map<string,string>();
        system.debug('###ColoumnName:'+ColumnName);
        /*if(ColumnName != 'ProfileId'){
            if(LookupFieldsMap.containsKey(ObjectAPI)){
                ListOfLookupField = string.valueof(LookupFieldsMap.get(ObjectAPI));
                system.debug('##ListOfLookupField:' +ListOfLookupField);
                string[] LookupFieldArr = (ListOfLookupField).split(',');
                system.debug('##LookupFieldArr:' +LookupFieldArr);
                for(integer i=0; i<LookupFieldArr.size(); i++){  
                    string eachLookupField = LookupFieldArr[i];
                    system.debug('##eachLookupField:' +eachLookupField);
                    if(eachLookupField.contains('.')){
                        system.debug('Contains a period character' + eachLookupField);
                        string[] eachLookupEntity = eachLookupField.split('\\.');
                        system.debug('##eachLookupEntity:' +eachLookupEntity);                        
                        LookupFieldobjectMap.put((eachLookupEntity[1]).tolowercase().trim(),(eachLookupEntity[0]).tolowercase().trim());
                    }
                    else{
                        system.debug('Does not contain a period character' + eachLookupField);
                        LookupFieldobjectMap.put((eachLookupField).tolowercase().trim(),(eachLookupField).tolowercase().trim());
                    }
                }
                system.debug('##LookupFieldobjectMap:' +LookupFieldobjectMap);
            }*/
            system.debug('##ColumnName:' +ColumnName);
            if(LookupFieldobjectMap.containsKey(ColumnName.tolowercase().trim())){
                system.debug('##LookupFieldobjectMap:' +LookupFieldobjectMap);
                LookupObjectAPIName = LookupFieldobjectMap.get(ColumnName.tolowercase().trim());
                system.debug('##LookupObjectAPIName:' +LookupObjectAPIName);
                system.debug('##ObjectIDsMap:' +ObjectIDsMap);
                if(ObjectIDsMap.containsKey(LookupObjectAPIName)){
                    string ObjectID = ObjectIDsMap.get(LookupObjectAPIName);
                    system.debug('##ObjectID:' +ObjectID);    
                    string[] objectKeyValueArr = ObjectID.split(';');
                    for(integer i=0; i<objectKeyValueArr.size(); i++){
                        string allObjectField = objectKeyValueArr[i];
                        string[] eachObjectEntity = allObjectField.split('-');                        
                        InsertedObjectMap.put(eachObjectEntity[0],(eachObjectEntity[1]));  
                        system.debug('###Inserted Object Map:' +InsertedObjectMap);
                       }  
                   }
                   
                if(InsertedObjectMap.containsKey(ColumnValue)){
                    LookupID =  InsertedObjectMap.get(ColumnValue);
                   }
               }
          // }
           /*else{           
               system.debug('###InsideProfileColumn:'+ColumnName);
               Profile profileRec = new Profile();
               profileRec = [Select Id, Name from Profile where Name =: ProfileName LIMIT 1];
               system.debug('###profileRec :'+profileRec);
               if(profileRec != null)
                   LookupID = profileRec.Id;
           }*/
          return LookupID;
    }
    
    public static list<sObject> InsertCsvTosObject(List<List<String>> parsedCSV, string objectApiName)
    {  
        Schema.sObjectType objectDef = Schema.getGlobalDescribe().get(objectApiName).getDescribe().getSObjectType();
        system.debug(objectDef);        
        list<sObject> objects = new list<sObject>();
        list<string> headers = new list<string>();    
        set<string> lookupColNameSet = new set<string>();       
        for(list<string> row : parsedCSV){
            for(string col : row){              
                headers.add(col);
                if(IsObjContainLookup){
                    boolean isLookupField = IsLookupField(string.valueOf(objectDef), col);
                    system.debug('###column name:' +col);
                    if(isLookupField){ 
                        system.debug('====Is a lookup field'); 
                        lookupColNameSet.add(col.tolowercase().trim());
                    }
                }
            }
            break;
        }
        system.debug('========================= File Column Headers');
        system.debug(headers);            
        integer rowNumber = 0;
        for(list<string> row : parsedCSV){
            system.debug('========================= Row Index' + rowNumber);
            if(rowNumber == 0){
                rowNumber++;
                continue;
            }
            else{
                sObject thisObj = objectDef.newSobject();
                system.debug('###string Object Name:' + string.valueOf(objectDef));
                Schema.SObjectType objectSchema = Schema.getGlobalDescribe().get(string.valueOf(objectDef));
                system.debug('##ObjectSchema:' + objectSchema);
                Map<String, Schema.SObjectField> fieldMap = objectSchema.getDescribe().fields.getMap();
                system.debug('##fieldMap:' + fieldMap);
                
                integer colIndex = 0;
                for(string columnValue : row){                   
                    string headerName = headers[colIndex].trim();
                    system.debug('========================= Column Name ' + headerName);
                    if(headerName.length() > 0){                  
                       try{     
                            system.debug('========================= lookupColNameSet ' + lookupColNameSet); 
                             Schema.DisplayType fielddataType = fieldMap.get(headerName).getDescribe().getType();
                             if(lookupColNameSet.Contains(headerName.tolowercase().trim())){
                                
                                system.debug('=======entering the lookup id ====');
                                string LookupID = FetchIdByLookup(objectApiName,headerName,columnValue.trim());
                                system.debug('###LookupID inside Parse CSV:' +LookupID);
                                Id i = Id.valueOf(LookupID);
                                thisObj.put(headerName,i);  
                            }
                            else{   
                            
                                system.debug('###fielddataType:' +fielddataType);                          
                                if(fielddataType == Schema.DisplayType.Currency || fielddataType == Schema.DisplayType.Double){
                                    system.debug('##columnValue:' +columnValue);
                                    thisObj.put(headerName, Decimal.valueOf(columnValue.trim()));
                                }
                                else if(fielddataType == Schema.DisplayType.Integer){
                                    thisObj.put(headerName, integer.valueOf(columnValue.trim()));
                                    system.debug('##columnValue:' +columnValue);
                                }
                                else if(fielddataType == Schema.DisplayType.Boolean){
                                    thisObj.put(headerName, boolean.valueOf(columnValue.trim()));
                                    system.debug('##columnValue:' +columnValue);
                                }
                                else if(fielddataType == Schema.DisplayType.DateTime){
                                    thisObj.put(headerName, DateTime.parse(columnValue.trim()));
                                    system.debug('##columnValue:' +columnValue);
                                }
                                else if(fielddataType == Schema.DisplayType.Date){
                                    thisObj.put(headerName, Date.parse(columnValue.trim()));
                                    system.debug('##columnValue:' +columnValue);
                                }
                                else{
                                    thisObj.put(headerName, columnValue.trim());
                                    system.debug('##columnValue:' +columnValue);
                                    system.debug('##headerName:' +headerName);
                                }
                                
                            }
                        }
                        catch(exception e){
                            system.debug('============== Invalid field specified in header ' + headerName+'###'+e);                           
                        }
                        colIndex++;
                    }
                } 
                objects.add(thisObj);
                rowNumber++;
            }       
        }       
       try{
         
           return objects;
       } 
       catch(Exception ex){
          return objects;
       }
    }
            
}