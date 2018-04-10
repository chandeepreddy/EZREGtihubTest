global class BatchtoMoveCampaignstoLeads implements Database.Batchable<sObject>
{   
 public List<CampaignMember> campaignmemberslist= new List<CampaignMember>();
     global Database.QueryLocator start(Database.BatchableContext bc) 
        {
            String contactslist = 'SELECT Id,VMS__c,ODS_AWS__c,ODSDotNet__c,free500hrs__c,TurnsLift__c,KPO__c,Force_com__c,Staffing_Promotion_Status__c,Lead_Id__c,ODS_DotNet_Status__c,ODS_AWS_Status__c,DIS__c,VMS_Status__c,KPO_Status__c,AnB__c,Mini_FOX_Masco_W_B_ISR__c,Mini_FOX_Masco_W_B_Status__c,Mini_FOX_Masco_W_B__c,ADM__c,LegMod__c,Account.Staffing_Promotion_Data_Comments__c,Account.Staffing_Promotion_Inside_Sales_Rep__c,Account.Staffing_Promotion_Account_Status__c,DataStax__c,Account.Staffing_Promotion__c,Account.Force_com__c,GLIX__C,Holiday_Cards__c,Status__c,Account.Source__c,Account.Force_com_Data_Status__c,Account.Force_com_Data_Status_Comments__c,Account.Force_com_Account_Status__c,Account.AWS_Account_source__c,Account.DBITS__c,Account.Inside_SalesRep__c,Account.ITSAC__c,Account.ODSDotNet_Account_Status__c,Account.ODSDotNet_Data_Status_Comments__c,Account.ODSDotNet_Data_Status__c,Account.ODSDotNet_Inside_Sales_Rep__c,Account.ODSDotNet__c,Account.ODS_AWS_Account_Status__c,Account.ODS_AWS_Data_Status_Comments__c,Account.ODS_AWS_Data_Status__c,Account.ODS_AWS_Inside_SalesRep__c,Account.ODS_AWS__c,Account.Turnslift_Account_Status__c,Turnslift_Account_Status__c,Account.TurnsLift__c,Account.VMS_Account_Status__c,Account.VMS_ISR__c,Account.VMS__c,Account.KPO_Account_Status__c,Account.KPO__c,IsContactConvertedtoLead__c FROM Contact WHERE IsContactConvertedtoLead__c =true  ';
            return Database.getQueryLocator(contactslist);
        }
    global void execute(Database.BatchableContext bc, List<Contact> contactslist)
    {
        
         Map<String,Id> mapcampaigns = new Map<String,Id>();
         List<Campaign> cam=[SELECT Name,Id FROM Campaign];
            for(Campaign c: cam)
            {
              mapcampaigns.put(c.Name,c.Id); 
            }
        system.debug('@@@@mapcampaigns' +mapcampaigns );
         for(Contact eachcontact: contactslist)
         {
           if(eachcontact.Force_com__c==true)
           {
             id ForcecomId= mapcampaigns.get('ODS Force.com');
             PopulateForcecom(eachcontact,ForcecomId);                 
           }
           if(eachcontact.VMS__c==true)
           {
             id VMSId= mapcampaigns.get('VMS');
             PopulateVMS(eachcontact,VMSId);                 
           }    
           if(eachcontact.Holiday_Cards__c==true)
           {
             id HolidayCardsId= mapcampaigns.get('Holiday Cards');
             PopulateHolidayCards(eachcontact,HolidayCardsId);                
           }   
           if(eachcontact.GLIX__C==true)
           {
             id GLIXId= mapcampaigns.get('GLIX');
             PopulateGLIX(eachcontact,GLIXId);                
           }    
           if(eachcontact.KPO__c==true)
           {
             id KPOId= mapcampaigns.get('KPO');
             PopulateKPO(eachcontact,KPOId);                
           } 
           if(eachcontact.TurnsLift__c==true)
           {
             id TurnsliftId= mapcampaigns.get('TurnsLift');
             PopulateTurnsLift(eachcontact,TurnsliftId);                
           }    
            if(eachcontact.AnB__c==true)
           {
             id AnBId= mapcampaigns.get('AnB');
             PopulateAnB(eachcontact,AnBId);                
           }
           if(eachcontact.ADM__c==true)
           {
             id ADMId= mapcampaigns.get('ADM');
             PopulateADM(eachcontact,ADMId);                
           }
           if(eachcontact.free500hrs__c==true)
           {
               string CampaignName=string.valueOf('500 Hour Promotion');
            id hourpromotionId = mapcampaigns.get(CampaignName);
            Populate500hourpromotion(eachcontact,hourpromotionId);                
           }
           if(eachcontact.DataStax__c==true)
           {
             id DataStaxId= mapcampaigns.get('DataStax');
             PopulateDataStax(eachcontact,DataStaxId);                
           }
           if(eachcontact.LegMod__c==true)
           {
             id LegModId= mapcampaigns.get('LegMod');
             PopulateLegMod(eachcontact,LegModId);                
           }
           if(eachcontact.Mini_FOX_Masco_W_B__c==true)
           {
             id MiniFoxMascoWBId= mapcampaigns.get('Mini – Fox_Masco_WB');
             PopulateMiniFoxMascoWB(eachcontact,MiniFoxMascoWBId);                
           }
           if(eachcontact.DIS__c==true)
           {
             id DISId= mapcampaigns.get('DIS');
             PopulateDIS(eachcontact,DISId);                
           }
           if(eachcontact.ODS_AWS__c==true)
           {
             id AWSId= mapcampaigns.get('ODS AWS');
             PopulateAWS(eachcontact,AWSId);                
           }
           if(eachcontact.ODSDotNet__c==true)
           {
             id DotNetId= mapcampaigns.get('ODS DOT NET');
             PopulateODSDotNet(eachcontact,DotNetId);                
           }
          /* if(eachcontact.Account.DBITS__c==true)
           {
             id TexasDBITSId= mapcampaigns.get('Texas-DBITS');
             PopulateTexasDBITS(eachcontact,TexasDBITSId);                
           }
           if(eachcontact.Account.ITSAC__c==true)
           {
             id TexasITSACId= mapcampaigns.get('Texas-ITSAC');
             PopulateTexasITSAC(eachcontact,TexasITSACId);                
           }  */         
         }
         database.insert (campaignmemberslist, false);
          Database.SaveResult[] srList = database.insert(campaignmemberslist,false);
     
        // Iterate through each returned result
        for (Database.SaveResult sr : srList) {
        system.debug('$$sr '+sr );
            if (sr.isSuccess()) {
                // Operation was successful, so get the ID of the record that was processed
                System.debug('Successfully inserted Lead. Lead ID: ' + sr.getId());
               
            }
            else {
                // Operation failed, so get all errors                
                for(Database.Error err : sr.getErrors()) {
                    System.debug('The following error has occurred.');                    
                    System.debug(err.getStatusCode() + ': ' + err.getMessage());
                    System.debug('Lead fields that affected this error: ' + err.getFields());
                }
       
         }
         }
        }
      
   global void finish(Database.BatchableContext bc) 
    {

    }
        public void PopulateForcecom(contact contactRecord,id ForcecomId)
         {
           CampaignMember varcampaignmember= new CampaignMember();
         
           varcampaignmember.CampaignId =ForcecomId;
           varcampaignmember.LeadId=contactRecord.Lead_Id__c;
           varcampaignmember.Status=contactRecord.Status__c;
           varcampaignmember.Contact_Status__c=contactRecord.Status__c;
           varcampaignmember.Status__c=contactRecord.Account.Force_com_Account_Status__c;
           varcampaignmember.Source__c=contactRecord.Account.Source__c;
           varcampaignmember.Inside_SalesRep__c=contactRecord.Account.Inside_SalesRep__c;
           varcampaignmember.Data_Status__c=contactRecord.Account.Force_com_Data_Status__c;
           varcampaignmember.Comments__c=contactRecord.Account.Force_com_Data_Status_Comments__c;
           campaignmemberslist.add(varcampaignmember);
         }
         public void PopulateVMS(contact contactRecord,id VMSId)
         {
           CampaignMember varcampaignmember= new CampaignMember();
         
           varcampaignmember.CampaignId =VMSId;
           varcampaignmember.LeadId=contactRecord.Lead_Id__c;
                      varcampaignmember.Status=contactRecord.Status__c;

           varcampaignmember.Status__c=contactRecord.Account.VMS_Account_Status__c;
           varcampaignmember.Contact_Status__c=contactRecord.VMS_Status__c;
           varcampaignmember.Inside_SalesRep__c=contactRecord.Account.VMS_ISR__c;
           
           
           campaignmemberslist.add(varcampaignmember);
         }
       
         public void PopulateHolidayCards(contact contactRecord,id HolidayCardsId)
         {
           CampaignMember varcampaignmember= new CampaignMember();
         
           varcampaignmember.CampaignId =HolidayCardsId;
           varcampaignmember.LeadId=contactRecord.Lead_Id__c;           
           campaignmemberslist.add(varcampaignmember);
         } 
         public void PopulateGLIX(contact contactRecord,id GLIXId)
         {
           CampaignMember varcampaignmember= new CampaignMember();
         
           varcampaignmember.CampaignId =GLIXId;
           varcampaignmember.LeadId=contactRecord.Lead_Id__c;           
           campaignmemberslist.add(varcampaignmember);
         }  
         public void PopulateKPO(contact contactRecord,id KPOId)
         {
           CampaignMember varcampaignmember= new CampaignMember();
           varcampaignmember.Status=contactRecord.Status__c;     
           varcampaignmember.Contact_Status__c=contactRecord.KPO_Status__c;
           varcampaignmember.CampaignId =KPOId;
           varcampaignmember.LeadId=contactRecord.Lead_Id__c;  
           varcampaignmember.Status__c=contactRecord.Account.KPO_Account_Status__c;        
           campaignmemberslist.add(varcampaignmember);
         }           
         public void PopulateTurnsLift(contact contactRecord,id TurnsliftId)
         {
           CampaignMember varcampaignmember= new CampaignMember();
                      varcampaignmember.Status=contactRecord.Status__c;     
           varcampaignmember.Contact_Status__c=contactRecord.Turnslift_Account_Status__c;
           varcampaignmember.CampaignId =TurnsliftId;
           varcampaignmember.LeadId=contactRecord.Lead_Id__c;  
           varcampaignmember.Status__c=contactRecord.Account.Turnslift_Account_Status__c;          
           campaignmemberslist.add(varcampaignmember);
         } 
         public void PopulateAnB(contact contactRecord,id AnBId)
         {
           CampaignMember varcampaignmember= new CampaignMember();
                    varcampaignmember.Status=contactRecord.Status__c;     

           varcampaignmember.CampaignId =AnBId;
           varcampaignmember.LeadId=contactRecord.Lead_Id__c;          
           campaignmemberslist.add(varcampaignmember);
         } 
         public void PopulateADM(contact contactRecord,id ADMId)
         {
           CampaignMember varcampaignmember= new CampaignMember();
                    varcampaignmember.Status=contactRecord.Status__c;     

           varcampaignmember.CampaignId =ADMId;
           varcampaignmember.LeadId=contactRecord.Lead_Id__c;          
           campaignmemberslist.add(varcampaignmember);
         }
         public void Populate500hourpromotion(contact contactRecord,id hourpromotionId)
         {
           CampaignMember varcampaignmember= new CampaignMember();
         
           varcampaignmember.CampaignId =hourpromotionId;
           varcampaignmember.LeadId=contactRecord.Lead_Id__c;  
                      varcampaignmember.Status=contactRecord.Status__c;     

            varcampaignmember.Contact_Status__c=contactRecord.Staffing_Promotion_Status__c;
           varcampaignmember.Status__c=contactRecord.Account.Staffing_Promotion_Account_Status__c;
           varcampaignmember.Inside_SalesRep__c=contactRecord.Account.Staffing_Promotion_Inside_Sales_Rep__c;
           varcampaignmember.Comments__c=contactRecord.Account.Staffing_Promotion_Data_Comments__c;  
           campaignmemberslist.add(varcampaignmember);
         } 
         public void PopulateDataStax(contact contactRecord,id DataStaxId)
         {
           CampaignMember varcampaignmember= new CampaignMember();
                    varcampaignmember.Status=contactRecord.Status__c;     

           varcampaignmember.CampaignId =DataStaxId;
           varcampaignmember.LeadId=contactRecord.Lead_Id__c;      
           campaignmemberslist.add(varcampaignmember);
         }  
         public void PopulateLegMod(contact contactRecord,id LegModId)
         {
           CampaignMember varcampaignmember= new CampaignMember();
         
           varcampaignmember.CampaignId =LegModId;
           varcampaignmember.LeadId=contactRecord.Lead_Id__c;      
           campaignmemberslist.add(varcampaignmember);
         }
         public void PopulateMiniFoxMascoWB(contact contactRecord,id MiniFoxMascoWBId)
         {
           CampaignMember varcampaignmember= new CampaignMember();
         
           varcampaignmember.CampaignId =MiniFoxMascoWBId;
           varcampaignmember.LeadId=contactRecord.Lead_Id__c;  
                     varcampaignmember.Status=contactRecord.Status__c;     
 
            varcampaignmember.Contact_Status__c=contactRecord.Mini_FOX_Masco_W_B_Status__c;
           varcampaignmember.Status__c=contactRecord.Mini_FOX_Masco_W_B_Status__c;
           varcampaignmember.Inside_SalesRep__c=contactRecord.Mini_FOX_Masco_W_B_ISR__c;     
           campaignmemberslist.add(varcampaignmember);
         }
          public void PopulateDIS(contact contactRecord,id DISId)
         {
           CampaignMember varcampaignmember= new CampaignMember();
                    varcampaignmember.Status=contactRecord.Status__c;     

           varcampaignmember.CampaignId =DISId;
           varcampaignmember.LeadId=contactRecord.Lead_Id__c;      
           campaignmemberslist.add(varcampaignmember);
         }
         public void PopulateAWS(contact contactRecord,id AWSId)
         {
           CampaignMember varcampaignmember= new CampaignMember();
         
           varcampaignmember.CampaignId =AWSId;
           varcampaignmember.LeadId=contactRecord.Lead_Id__c;
                      varcampaignmember.Status=contactRecord.Status__c;     

           varcampaignmember.Contact_Status__c=contactRecord.ODS_AWS_Status__c;
           varcampaignmember.Status__c=contactRecord.Account.ODS_AWS_Account_Status__c;
           varcampaignmember.Source__c=contactRecord.Account.AWS_Account_source__c;
           varcampaignmember.Inside_SalesRep__c=contactRecord.Account.ODS_AWS_Inside_SalesRep__c;
           varcampaignmember.Data_Status__c=contactRecord.Account.ODS_AWS_Data_Status__c;
           varcampaignmember.Comments__c=contactRecord.Account.ODS_AWS_Data_Status_Comments__c;
           campaignmemberslist.add(varcampaignmember);
         }
         public void PopulateODSDotNet(contact contactRecord,id DotNetId)
         {
           CampaignMember varcampaignmember= new CampaignMember();
         
           varcampaignmember.CampaignId =DotNetId;
           varcampaignmember.LeadId=contactRecord.Lead_Id__c;
                      varcampaignmember.Status=contactRecord.Status__c;     

           varcampaignmember.Contact_Status__c=contactRecord.ODS_DotNet_Status__c;
           varcampaignmember.Status__c=contactRecord.Account.ODSDotNet_Account_Status__c;
           varcampaignmember.Inside_SalesRep__c=contactRecord.Account.ODSDotNet_Inside_Sales_Rep__c;
           varcampaignmember.Data_Status__c=contactRecord.Account.ODSDotNet_Data_Status__c;
           varcampaignmember.Comments__c=contactRecord.Account.ODSDotNet_Data_Status_Comments__c;
           campaignmemberslist.add(varcampaignmember);
         }
      /*   public void PopulateTexasDBITS(contact contactRecord,id TexasDBITSId)
         {
           CampaignMember varcampaignmember= new CampaignMember();
         
           varcampaignmember.CampaignId =TexasDBITSId;
           varcampaignmember.LeadId=contactRecord.Lead_Id__c;      
           campaignmemberslist.add(varcampaignmember);
         }
         public void PopulateTexasITSAC(contact contactRecord,id TexasITSACId)
         {
           CampaignMember varcampaignmember= new CampaignMember();
         
           varcampaignmember.CampaignId =TexasITSACId;
           varcampaignmember.LeadId=contactRecord.Lead_Id__c;      
           campaignmemberslist.add(varcampaignmember);
         } */      
}