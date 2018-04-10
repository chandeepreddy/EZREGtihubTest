/**
 * @author           Shahida
 * @version          1.0 
 * @date             22/02/2016
 * @Status           Developed
 * @description      Batch class to duplicate candidates as email attachment
 *
 */
 global class EZRE_BatchToDuplicateCandidates implements Database.Batchable<sObject>, Database.Stateful
 {
    public list<Candidate__c> lstCandidates;
    public list<Candidate__c> lstDupeCandidates{get;set;}
    //Batch constructor
    global EZRE_BatchToDuplicateCandidates()
    {
       lstDupeCandidates=new list<Candidate__c>();
    }

    //Batch start method
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
       //fetch all candidates
       return Database.getQueryLocator('select id,name,Mobile_Phone_No__c,Email__c From Candidate__c order by Mobile_Phone_No__c,Email__c');
    }

    //Batch execute method
    global void execute(Database.BatchableContext BC, List<Candidate__c> lstCandidates)
    {   
        list<String> lstDuplicatefield=new list<string>();
        lstDuplicatefield.add('Mobile_Phone_No__c');
        lstDuplicatefield.add('Email__c');
        map<string,list<Candidate__c>>  mapCandByEmail=new map<string,list<Candidate__c>>();
        map<string,list<Candidate__c>>  mapCandByPhone=new map<string,list<Candidate__c>>();
        system.debug('@@@@@@@@@@@@@@@Fields to find duplicates'+lstDuplicatefield);
        system.debug('@@@@@@@@@@@@@@@lstCandidatesOfAllCandidates'+lstCandidates.size());
        set<Candidate__c> setDupCandRec=new set<Candidate__c>(); 
        

        ///<OBJECTIVE>
        ///For loop to get all candidates related to one email and one phone number
        ///<OBJECTIVE>
        if(lstCandidates.size()>0)
        {
        for(Candidate__c cand:lstCandidates)
        {
          
           if(mapCandByEmail.containskey(cand.Email__c ))
            {
               mapCandByEmail.get(cand.Email__c).add(cand);
            }
            else
            {
                  
                mapCandByEmail.Put(cand.Email__c ,new List<Candidate__c>{cand});
            }
            
            if(mapCandByPhone.containskey(cand.Mobile_Phone_No__c))
            {
               mapCandByPhone.get(cand.Mobile_Phone_No__c).add(cand);
            }
            else
            {
                  
              mapCandByPhone.Put(cand.Mobile_Phone_No__c ,new List<Candidate__c>{cand});
            }
        }
        }
        ///<OBJECTIVE>
        ///For loop to get all duplicate candidates based on email
        ///<OBJECTIVE>
        system.debug('@@@@@@@@@@mapCandByEmail'+mapCandByEmail);    
        set<String>  setEmail=new set<String>(); 
        for (String strEmail : mapCandByEmail.keySet())
        {
        if(String.isNotBlank(strEmail))
        {
            list<Candidate__c> lstCandtByEmail = mapCandByEmail.get(strEmail);                       
            if(lstCandtByEmail.size()>1)
            {
               
                setEmail.add(strEmail);
                system.debug('@@@@@@@@@@@@@@@@AllEmails'+strEmail);
                system.debug('@@@@@@@@@@@@@@@'+lstCandtByEmail.size());
                setDupCandRec.addAll(lstCandtByEmail);
                lstCandtByEmail.clear();
               
             }
          }
        }

        system.debug('@@@@@@@@@@@@@setDupCandRecBasedOnEmail'+setDupCandRec);
        ///<OBJECTIVE>
        ///For loop to get all duplicate candidates based on phone
        ///<OBJECTIVE>
        set<String> setPhone=new set<String>();
        for (String strPhone : mapCandByPhone.keySet())
        {
        list<Candidate__c> lstCandtByPhone =new list<Candidate__c>();
        if(String.isNotBlank(strPhone))
        {
            lstCandtByPhone = mapCandByPhone.get(strPhone);
            if(lstCandtByPhone.size()>1)
            {
             setPhone.add(strPhone);        
             system.debug('@@@@@@@@@@@@@@@@lstCandtByPhone'+lstCandtByPhone);   
             setDupCandRec.addAll(lstCandtByPhone);
             lstCandtByPhone.clear();
            }
            
        }

        }        
        ///<OBJECTIVE>
        ///For loop to get all duplicate candidates based on email and phone
        ///<OBJECTIVE>
        for(Candidate__c objcand:setDupCandRec)
        {
        lstDupeCandidates.add(objcand);
        }
        system.debug('@@@@@@@@@@@Set Of Duplicates base on Email and Phone'+lstDupeCandidates);
        system.debug('@@@@@@@@@@Set Of Duplicates base on Email and PhoneSize'+lstDupeCandidates.size());
    }
        
    //Sending Duplicate Candidate mail attachment
    global void finish(Database.BatchableContext BC)
    {      
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();           
            String strToAddress = System.Label.EZRE_DuplicateCandtToAddress;    
            list<string> lstToAddress=strToAddress.split(',');          
            mail.setToAddresses(lstToAddress);           
            system.debug('@@@@@@@@@@@@To Email For Sending duplicate candidates'+strToAddress );
            mail.setSubject( 'Export Duplicate Candidtes');
            mail.setHtmlBody( 'Please find the attached Duplicate Candidate csv file' );
            
            String contentCSV = '';
            //To create csv file content for attachment 
            for (Candidate__c Candt :lstDupeCandidates) {
                 Candidate__c objCandt=new Candidate__c();
                 objCandt.id=Candt.id;
                 objCandt.Name=Candt.Name;   
                 if(!String.isBlank(Candt.Email__c))
                 {             
                 objCandt.Email__c=Candt.Email__c;
                 }
                 else
                 {
                  objCandt.Email__c='';
                 }
                 if(!String.isBlank(Candt.Mobile_Phone_No__c))
                 {
                 objCandt.Mobile_Phone_No__c=Candt.Mobile_Phone_No__c;
                 }
                 else
                 {
                 objCandt.Mobile_Phone_No__c='';
                 }
                 
                 contentCSV += objCandt.id+','+objCandt.Name+ ',' + objCandt.Email__c+','+objCandt.Mobile_Phone_No__c+'\n';
            }
            String content = 'Candidate Id,Name,Email,Mobile Phone No\n' + contentCSV;
            Messaging.EmailFileAttachment attachment = new Messaging.EmailFileAttachment();
            attachment.setFileName( 'DuplicateCandidates.csv' );
            attachment.setBody( Blob.valueOf( content ) );
            mail.setFileAttachments( new Messaging.EmailFileAttachment[]{ attachment } );  
            system.debug('@@@@@@@@Duplicate Records To send Mail'+lstDupeCandidates);     
            system.debug('@@@@@@@@@Duplicate Records size'+lstDupeCandidates.size());    
            Messaging.sendEmail( new Messaging.SingleEmailMessage[] { mail } );
          
    }
}