public class assigncandidatestatusemailalert
{  
    public void SendEmail()
      {
          //Selecting the userrole id of Requirement owners
                   List<UserRole> UsersRoleList = new List<UserRole>([Select Id, Name from UserRole  where Name = 'Vice President' or Name = 'Business Development Manager' or Name ='Management Representative' or Name ='Business Development Executive']);
                   System.debug('UserList123:' + UsersRoleList );
                    for(UserRole UsersRoleList123 :UsersRoleList)
                          {
                   //Selecting the user list based on the role id   
                                   List<User> UsersList  = new List<User>([ SELECT Id, Name, Email FROM User where IsActive = true and UserRoleId = : UsersRoleList123.Id]);
                                   System.debug('userlist1234' + UsersList);
                                   for ( User userlist1 : UsersList )
                                         {
                                                  //select the candidate mapping list based on the user id and requirements which are modified within last 14 days
                         List<Candidate_Mapping__c> candidatemappinglist = new List<Candidate_Mapping__c>( [SELECT Candidate__r.Candidate_Full_Name__c,Requirement__r.Name,Requirement__r.C_Name__r.Name, Requirement__r.Opportunity_Code__c, Requirement__r.CreatedDate,status1__c,Req_Owner_Email__c,Requirement_Owner__c FROM Candidate_Mapping__c where Submitted_to_Client__c ='' and status1__c = 'approved' and LastModifiedBy.Id = : userlist1.Id and LastModifiedDate  = Last_n_days : 14]);
                                                        system.debug('candidatemappinglist :' + candidatemappinglist );
                                                        String htmlBody ;     
                                                                      Messaging.SingleEmailMessage mail;
                                                                      htmlBody ='Dear '+userlist1.Name+',</br></br>';
                                                                      
                                                                      htmlBody =htmlBody +'<table style="border: 1px solid black;border-collapse:collapse;"><tr><td style="border: 1px solid black;"><b>Candidate</b> </td><td style="border: 1px solid black;"><b>Requirement</b> </td><td style="border: 1px solid black;"><b>Requirement Code</b></td><td style="border: 1px solid black;"><b>Client Name</b></td><td style="border: 1px solid black;"><b>Requirement Created Date</b></td></tr>';
       
                                                  
                                                                      for (Candidate_Mapping__c cm :candidatemappinglist )
                                                                             {                            
                                                                                           htmlBody = htmlBody + '<tr><td style="border: 1px solid black;">'+cm .Candidate__r.Candidate_Full_Name__c+'</td><td style="border: 1px solid black;">'+cm.Requirement__r.Name+'</td><td style="border: 1px solid black;">'+cm.Requirement__r.Opportunity_Code__c+'</td><td style="border: 1px solid black;">'+cm.Requirement__r.C_Name__r.Name+'</td><td style="border: 1px solid black;">'+cm.Requirement__r.CreatedDate+'</td></tr>';
                                                                             }
 
                                                                      htmlBody = htmlBody +'</table></br>Either it is yet to be submitted to the client or the details are not updated in the EZRE system.</br> Please close this action item asap. </br></br>Regards</br>EZRE Team';
                                                                      mail = new Messaging.SingleEmailMessage();
                                                                      OrgWideEmailAddress owea = [select Id from OrgWideEmailAddress where Address = 'ezre@preludesys.com' limit 1];
                                                                      mail.setOrgWideEmailAddressId(owea.Id); 
                                                                      String[] address = new String[]{userlist1.Email};
                                                                      mail.setToAddresses(address);
                                                                      mail.setHtmlBody(htmlBody );
                                                                      mail.setSubject('Submitted to client alert');
                                                                     // String[] bccaddress = new String[]{'abinaya_s@preludesys.com'};
                                                                      //mail.setBccAddresses(bccaddress);
                                                                      mail.saveAsActivity = false;
                                                          if( candidatemappinglist.size() > 0 )
                                                          {
                                                            //send email to the users list
                                                                      Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });  
                                                          }
                                       }
                          } 
      }
}