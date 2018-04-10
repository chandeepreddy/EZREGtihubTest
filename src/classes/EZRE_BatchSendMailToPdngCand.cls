/**
 * @author           Soumya
 * @version          1.0 
 * @date             28/11/2014
 * @Status           Developed
 * @description      This class is used to send Email to Recruiters with the list of Pending Candidates
 *                   
*/
global class EZRE_BatchSendMailToPdngCand implements Database.Batchable<sObject>,Database.Stateful  
{  
    global Map<String , List<Candidate_Mapping__c>> MapUsrCandidate;
    List<Candidate_Mapping__c> lstPendingCandidates; 
   
    /* <OBJECTIVE>
    *  Fetch the list of Pending candidates
    *  </OBJECTIVE>   
    */  
   global EZRE_BatchSendMailToPdngCand()  
   {  
       List<String> lstRecruiterNames = new List<String>();
       
       //Map to maintain Recruiter and related Pending Candidates
       MapUsrCandidate = new Map<String, List<Candidate_Mapping__c>>() ;  
         
       //Recruiter List
       List<User> lstRecruiter = new List<User>() ;
       
       lstRecruiter = [select id , name , Email , ManagerId from User where Profile.Name = 'Recruiter' and isActive =: true] ;  
       
       for(User ur : lstRecruiter)  
       {  
           lstRecruiterNames.add(ur.Name) ;  
       }  
        
       //Fetch Pending Candidates related to Recruiter
       lstPendingCandidates = new List<Candidate_Mapping__c>() ;  
       lstPendingCandidates = [Select Id, Name, Last_Name__c, Candidate__r.Name, Candidate__r.Last_Name__c, 
                                Client_Name__c, Requirement__r.Name, Requirement__r.Owner.Name, 
                                LastModifiedDate, Added_User__c, Requirement__r.OwnerId, Status1__c 
                                From Candidate_Mapping__c 
                                Where Status1__c != 'Candidate started' AND Status1__c != 'Rejected' AND Added_User__c in: lstRecruiterNames];         
   }  
  
    /* <OBJECTIVE>
    *  Construct the list of Pending candidates related to Recruiters
    *  </OBJECTIVE>   
    *  <RETURNS> 
    *  pagereference
    *  </RETURNS>
    */ 
   global Database.QueryLocator start(Database.BatchableContext BC)  
   {  

        List<String> lstRecruiterNames = new List<String>();
       
       //Map to maintain Recruiter and related Pending Candidates
       MapUsrCandidate = new Map<String, List<Candidate_Mapping__c>>() ;  
         
       //Recruiter List
       List<User> lstRecruiter = new List<User>() ;
       lstRecruiter = [select id , name , Email , ManagerId from User where Profile.Name = 'Recruiter' and isActive =: true];  
       
       for(User ur : lstRecruiter)  
       {  
           lstRecruiterNames.add(ur.Name) ;            
       }  
        
       //Fetch Pending Candidates related to Recruiter
       lstPendingCandidates = new List<Candidate_Mapping__c>() ; 
       if(!Test.isRunningTest())
            lstPendingCandidates = [Select Id, Name, Last_Name__c, Candidate__r.Name, Candidate__r.Last_Name__c, Client_Name__c, Requirement__r.Name, Requirement__r.Owner.Name, LastModifiedDate, Added_User__c, Requirement__r.OwnerId, Status1__c From Candidate_Mapping__c Where Added_User__c in: lstRecruiterNames AND Status1__c != 'Candidate started' AND Status1__c != 'Rejected'];
        else
            lstPendingCandidates = [Select Id, Name, Last_Name__c, Candidate__r.Name, Candidate__r.Last_Name__c, Client_Name__c, Requirement__r.Name, Requirement__r.Owner.Name, LastModifiedDate, Added_User__c, Requirement__r.OwnerId, Status1__c From Candidate_Mapping__c];
       
       //Creating map of Recruiter and related Pending Candidates  
       for(Candidate_Mapping__c c : lstPendingCandidates)  
       {  
          if(MapUsrCandidate.containsKey(c.Added_User__c))  
          {  
              //Fetch the list of Pending Candidates and add the new Candidate in it  
              List<Candidate_Mapping__c> tempList = MapUsrCandidate.get(c.Added_User__c) ;  
              tempList.add(c);  
              //Putting the refreshed case list in map  
              MapUsrCandidate.put(c.Added_User__c , tempList) ;  
          }  
          else  
          {  
              //Creating a list of Pending Candidates
              MapUsrCandidate.put(c.Added_User__c , new List<Candidate_Mapping__c>{c}) ;  
          }  
      }  
      //Batch on all Recruiters 
      String query = 'select id , name , Email from User where Profile.Name = \'Recruiter\'';       
      return Database.getQueryLocator(query);  
   }  
   
    /* <OBJECTIVE>
    *  Send mail to Recruiter with the list of Pending Candidates
    *  </OBJECTIVE>   
    *  <RETURNS> 
    *  Void
    *  </RETURNS>
    */ 
   global void execute(Database.BatchableContext BC, List<sObject> scope)  
   {  
         
      for(Sobject s : scope)  
      {  
          //Type cast sObject in user object  
          User ur = (User)s ;  
            
          if(MapUsrCandidate.containsKey(ur.Name))  
          {  
              //Fetching all Pending Candidates
              List<Candidate_Mapping__c> allCasesOfSalesRep = MapUsrCandidate.get(ur.Name) ;  
                
              String body = '' ;  
              //Creating tabular format for the Candidate details  
              body = BodyFormat(allCasesOfSalesRep) ;  
                
              //Sending Mail  
              Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage() ;  
                
              String[] toAddresses = new String[] {ur.Email} ;  
              mail.setToAddresses(toAddresses) ;  
              mail.setSubject('Pending Candidates List');  
              mail.setHtmlBody('Hi ' + ur.Name + ',<BR/><BR/>Please check if the candidate status is current and updated, If not kindly update the same,<BR/><BR/>' + body + '<BR/><BR/>Thanks!');  
          
              Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });  
          }  
      }  
   }  
   

    /* <OBJECTIVE>
    *  Construct the table with Candidate details
    *  </OBJECTIVE>   
    *  <RETURNS> 
    *  String
    *  </RETURNS>
    */ 
   public String BodyFormat(List<Candidate_Mapping__c> lstCandidatesPending)  
   {  
       String strMailBody = '' ;  
       for(Candidate_Mapping__c cs : lstCandidatesPending)  
       {   
            //datetime strLastModDate = cs.LastModifiedDate;
            datetime dt = cs.LastModifiedDate;
            String day = String.valueOf(dt.day());
            String month = String.valueOf(dt.month());
            String year = String.valueOf(dt.year());
            string strLastModDate= day +'-' + month +'-'+ year;
            //Date dt = strLastModDate.Date();
           //list<string> strdt = strLastModDate.split('');
          // list<string> lststrdate = 'strdt(0)+'/'+strdt(1)+'/'+strdt(2)'; 
           system.debug('###########' +strLastModDate);
           //strMailBody += '<tr><td style="border: 1px solid black">'+ cs.Candidate__r.Name +'</td>'+'<td style="border: 1px solid black">'+ cs.Candidate__r.Last_Name__c + '</td>'+'<td style="border: 1px solid black">'+ cs.client_Name__c + '</td>'+'<td style="border: 1px solid black">'+ cs.Requirement__r.Name + '</td>'+'<td style="border: 1px solid black">'+  (cs.LastModifiedDate).format('MM/DD/YYYY') + '</t></td>'+'<td style="border: solid black">'+ cs.Status1__c +'</td>'+'<td style="border: 1px solid black">'+ cs.Added_User__c + '</td>'+'<td style="border: 1px solid black">'+ cs.Requirement__r.Owner.Name + '</td>'+'</tr>' ;       
            strMailBody += 
                            '<tr cellspacing="0">' +
                            '<td  style="border: 1px solid black" cellspacing="0">'+ cs.Candidate__r.Name +'</td>'+
                            '<td  style="border: 1px solid black" cellspacing="0">'+ cs.Candidate__r.Last_Name__c + '</td>'+
                            '<td  style="border: 1px solid black" cellspacing="0">'+ cs.client_Name__c + '</td>'+
                            '<td  style="border: 1px solid black" cellspacing="0">'+ cs.Requirement__r.Name + '</td>'+
                            '<td  style="border: 1px solid black" cellspacing="0">'+ strLastModDate + '</td>'+
                            '<td  style="border: 1px solid black" cellspacing="0">'+ cs.Status1__c +'</td>'+
                            '<td  style="border: 1px solid black" cellspacing="0">'+ cs.Added_User__c + '</td>'+
                            '<td  style="border: 1px solid black" cellspacing="0">'+ cs.Requirement__r.Owner.Name + '</td>'+
                            '</tr>' ;  
       }  
       strMailBody = strMailBody.replace('null' , '') ;  
       String strFinalMailBody = '' ;  
       //strFinalMailBody = '<Body><table style="border: 1px solid black; font-family: Calibri" > <td bgcolor="Gray"> Candidate First Name </td> <td bgcolor="Gray"> Last Name </td><td bgcolor="Gray"> Client Name </td><td bgcolor="Gray"> Requirement Job Title </td><td bgcolor="Gray"> Last Modified Date </td><td bgcolor="Gray"> Candidate Status </td><td bgcolor="Gray"> Added User </td><td bgcolor="Gray"> Requirement Owner </td>' + strMailBody +'</table>' ;      return strFinalMailBody ;  
       strFinalMailBody= '<Body>'+
                        '<table style="border: 1px solid black; font-family: Calibri" bgcolor="#7FFFD4" cellspacing="0"> '+
                        '<tr cellspacing="0">' +
                        '<th bgcolor="1E90FF"  style="border: 1px solid black" cellspacing="0" > Candidate First Name </th>'+
                        '<th bgcolor="1E90FF"  style="border: 1px solid black" cellspacing="0"> Last Name </th>'+
                        '<th bgcolor="1E90FF"  style="border: 1px solid black" cellspacing="0"> Client Name </th>'+
                        '<th bgcolor="1E90FF"  style="border: 1px solid black" cellspacing="0"> Requirement Job Title </th>'+
                        '<th bgcolor="1E90FF"  style="border: 1px solid black" cellspacing="0"> Last Modified Date </th>'+
                        '<th bgcolor="1E90FF"  style="border: 1px solid black" cellspacing="0"> Candidate Status </th>'+
                        '<th bgcolor="1E90FF"  style="border: 1px solid black" cellspacing="0"> Added User </th>'+
                        '<th bgcolor="1E90FF"  style="border: 1px solid black" cellspacing="0"> Requirement Owner </th>'+
                        '</tr>'+
                        + strMailBody +'</table>' ;
       return strFinalMailBody ; 
   }  
  
   global void finish(Database.BatchableContext BC)  
   {  
   }  
  
}