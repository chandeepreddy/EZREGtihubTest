public with sharing class UpdateRequirementCode 
{

public static void display(Requirement__c[] req)
{
    
    AggregateResult[] val;
   
    string strCreatedBy;
    string strFormated ;
   
    strCreatedBy = DateTime.Now().Format('yyMMdd');
    strFormated = strCreatedBy;
    System.Debug('strCreatedBy : ' + strCreatedBy);
    System.debug('str :' + strFormated );           
    
    String userid = UserInfo.getUserId();
    System.debug('userid:' + userid);
    
    User userAlias = [select u.alias,u.id, u.Name from user u where u.id = :userid];
    string strUserAlias = userAlias.alias;
    System.Debug('UserAlias : ' + strUserAlias); 
   
    string strOppNumber = strUserAlias + strFormated;
    //string strOppNumber = OPP+ strFormated;
    strOppNumber = strOppNumber+ '%';
    System.Debug('strOppNumber: ' + strOppNumber );
     
    val = [select count(req1.Opportunity_Code__c) oppno from Requirement__c req1 where req1.Opportunity_Code__c like :strOppNumber]; 
   
    System.Debug('val  : ' + val);  

    string strConcat;
    integer oppnumber;
    for(AggregateResult ar1 : val)
    {
       oppnumber = Integer.valueOf(ar1.get('oppno'));
       oppnumber = oppnumber +1;
       System.Debug('oppno2:'+ oppnumber );
       
       /* if(oppnumber == 0)
       {
         oppnumber =1;
       }
        integer s = 0;
        oppnumber = s & oppnumber;
        s = s & oppnumber; */
    
    string oppNumberFormat;
    if(oppnumber <=9 )
    {
      oppNumberFormat = '0' + string.valueof(oppnumber);
      strConcat = strUserAlias + strFormated + oppNumberFormat ;      
    }
    else
    {
      strConcat = strUserAlias + strFormated + oppnumber ;
    }     
        
    //oppnumber = oppnumber + 1;
    //System.Debug('OppNumber :' + oppnumber );   
       
    } 
    System.Debug('strConcat : ' + strConcat); 
    
    
    for( Requirement__c req2: req)
    {
     req2.Opportunity_Code__c = strConcat;
     System.Debug('Opportunity_Code :' + req2.Opportunity_Code__c);
    } 

  }
}