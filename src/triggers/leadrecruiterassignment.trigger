trigger leadrecruiterassignment on RequirementAssignment__c (before insert) 
{
RequirementAssignment__c myopportunity = trigger.new[0];
String Newuser;
String Flag='No';
Integer LRcount=100;
Integer LRtotcount=100;
Integer RMcount=0; 
Integer loopi=0, CurrUserCnt=0, AllUserCnt=0;
AggregateResult[] val;

// changed if condition to send error message only if the opportunity is being assigned to lead recruiter -- abinaya 16.apr.12
 
    if(myopportunity.Lead_Recruiter__c == null && (myopportunity.Lead_Recruiter__r.Profile.Name == 'Lead Recruiter' || myopportunity.Lead_Recruiter__r.Profile.Name == 'LR Chatter Only User') )
    {
        trigger.new[0].Lead_Recruiter__c.addError(' Select User'); 
    }

if(myopportunity.Lead_Recruiter__c!= null)
{
    
    val = [ Select count(RequirementAssignment__c.Lead_Recruiter__c) cnt from RequirementAssignment__c
    where RequirementAssignment__c.Status__c='Open' 
    and RequirementAssignment__c.Lead_Recruiter__c=:myopportunity.Lead_Recruiter__c and  RequirementAssignment__c.Lead_Recruiter__r.UserRole.Name!='Recruiter'];

      for(AggregateResult ar1 : val)
       {
            LRcount = Integer.valueOf(ar1.get('cnt'));
            System.Debug('cnt:'+ LRcount);
            System.Debug('cnt1:'+ val);
        CurrUserCnt = LRcount + 1;
        System.Debug('CurrUserCnt :'+ CurrUserCnt );

          if(Integer.valueOf(ar1.get('cnt'))>=16)
             {
                LRcount = 100;  
                trigger.new[0].Lead_Recruiter__c.addError('Selected LR have maximum Assignments'); 
             } 
            //if(Integer.valueOf(ar1.get('cnt'))==3)
            //{
               
if(CurrUserCnt==16) 
{

//Select u.Id, u.Name from User u where u.UserRole.Name = 'Lead Recruiter'  and u.UserRole.ParentRoleId != null and u.ManagerId!=null and u.Id!='00540000001BviTAAS'
//list the other LR of the assigning manager for eg: if manager is martin, list all th LR's under martin
// LIST<User> UserList = [Select u.Id from User u where u.UserRole.Name = 'Lead Recruiter' and u.UserRole.ParentRoleId != null    and u.ManagerId!=null  and u.Id!=:myopportunity.AssignedUser__c]; //and u.ManagerId = :myopportunity.ManagerId__c
 LIST<User> UserList = [Select u.Id from User u where (u.Profile.Name ='Lead Recruiter' or u.Profile.Name ='LR Chatter Only User') and u.UserRole.ParentRoleId != null and u.ManagerId!=null  and u.Id!=:myopportunity.Lead_Recruiter__c and u.IsActive=true]; //and u.ManagerId = :myopportunity.ManagerId__c
 System.Debug('UserList : ' + UserList);
 for(integer i = 0; i<UserList.size(); i++)
 {
     Newuser = UserList[i].Id; 
        //AggregateResult[] val = [Select count(Assign_To__c) cnt from Opportunity where Opportunity.Status__c='Open' and Opportunity.Assign_To__c=:Newuser ];
     val = [Select count(RequirementAssignment__c.Lead_Recruiter__c) cnt from RequirementAssignment__c where RequirementAssignment__c.Status__c='Open' and RequirementAssignment__c.Lead_Recruiter__c=:Newuser ];
        
     for(AggregateResult ar11 : val)
     {
        loopi=loopi+1;
        System.debug('UUser : '+ i + ' : ' +Newuser );
        System.debug('ccount : '+ i + ' : ' +ar11.get('cnt'));
        Integer Jar1 = Integer.valueOf(ar11.get('cnt'));
         if(Jar1 ==16)
          {
            AllUserCnt=1;
          }
          else
          {
            AllUserCnt=2;
            break;
          }
        if(Jar1<=16)
        {
            LRcount = Jar1;//Integer.valueOf(ar1.get('cnt'));
            LRcount =LRcount +1;
            //System.debug('Count : '+ i + ' : ' +LRcount ); 
            //trigger.new[0].Assign_To__c.addError('Selected LR have maximum Assignments'); 
            //break; 
        }        
      } 
      if(AllUserCnt==2){break;}
      if(loopi==0)
      {LRcount=0;}
  }
         }//else part
  
       //   }    
       }
}

  
  if(string.valueOf(LRcount)!='')
    {
        //trigger.new[0].LR_Count__c=string.valueOf(LRcount);
        trigger.new[0].LR_Count__c='NO'; 
        //LIST<Opportunity> Opportunity = [update Opportunity set LR_Count__c = 'No'];
    }
    else
    {
        trigger.new[0].LR_Count__c='NOooo';
        //LIST<Opportunity> Opportunity = [update Opportunity set LR_Count__c = 'No'];
    }
//if(LRcount==100 ) 
    if(AllUserCnt==1)
    {
        Flag='Yes';
    }
    
    for(RequirementAssignment__c myopportunity1 : trigger.new)
    {
          myopportunity1.LR_Count__c = Flag;
        //myopportunity1.LR_Count__c = string.valueOf(LRcount);
        //myopportunity1.LR_Count__c = string.valueOf(AllUserCnt);
    }


}