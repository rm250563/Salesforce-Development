/**
##################################################################################################
# Project Name and Request Num..........: NSC Sales Central (Sales Force)
# File............................: EditFrom.Component 
# Created by................: Pankaj Kashayp                                                                  
# Created Date...........: 09-08-2016                                                                              
# Last Modified by......:  Saritha Karuturi 
# Last Modified Date..:    10-11-2016,10-08-2016
# Description...............: This class will be used as server side controller for above mentioned component.It is basically send the toplines and competitotrs infromation to components.
These componenets data will be displayed.

                              NSCI_AGILE-2048: Phase 2 Show list of toplines in the funnel
                              NSCI_AGILE-2047: Phase 1 Show list of competitors and purchased toplines
                              NSCI_AGILE-2049: Phase 3 Show list of toplines we have not sold

################################################################################################
*/


public class AccountController {
     
     @AuraEnabled 
    public static Account getAccount(Id Accountid) {
        return [ 
            SELECT Id, Name,A360_Values_As_Of_Date__c,X2011_Booked_Orders_Value__c,Available_Credit__c,Credit_Limit__c,Credit_Values_As_Of__c,X2010_Booked_Orders_Value__c,A360_Solution_Orders_YTD_2__c,X2012_Booked_Orders_Value__c,Open_Opportunity_Value__c,A360_Annuity_Revenue_YTD_3__c,A360_Solution_Orders_YTD_3__c,A360_CMS_Revenue_YTD_3__c,A360_Solution_Revenue_YTD_3__c,A360_File_Value_YTD_3__c,A360_Annuity_Revenue_YTD_2__c,A360_Current_File_Value__c,A360_CMS_Revenue_YTD_2__c,A360_Solution_Revenue_YTD_2__c,A360_File_Value_YTD_2__c,A360_Annuity_Revenue_YTD_1__c,A360_Solution_Orders_YTD_1__c,A360_File_Value_YTD_1__c,A360_CMS_Revenue_YTD_1__c,A360_Solution_Revenue_YTD_1__c,A360_CMS_Revenue_YTD__c,A360_Solution_Revenue_YTD__c,Account_Active_Date__c,Sync_To_Walker__c,Primary_Contact__c
            FROM Account 
            WHERE Id =:Accountid   
        ][0]; 
     }      
    @AuraEnabled
        public static List<String> getpickval()     
        {
                List<String> options = new List<String>();
        
                Schema.DescribeFieldResult fieldResult = account.Industry.getDescribe();
        
                List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        
                for (Schema.PicklistEntry f: ple) { 
                    options.add(f.getLabel());
                }       
                return options;
        }  
    
    @AuraEnabled
    public static account saveAccount(account acc)
    {
        update acc;  
        return acc;       
    }
    
    @AuraEnabled  
    public static String getUserProfile(Id Accountid) {
        String ProfileAccess = [select id,name from profile where id=:userinfo.getProfileId()][0].Name;
        string RecordtypeName =[SELECT Id,recordtype.name FROM Account  WHERE Id =:Accountid][0].recordtype.name;
  
        if(((ProfileAccess == '54 Hosted Solutions Sales Operations' || ProfileAccess =='55 Hosted Solutions Sales' ) && (RecordtypeName=='Customer'))  )
        {
            return 'AccessforFiftyFourProfile'; 
        }
        
       else if(((ProfileAccess == '54 Hosted Solutions Sales Operations' || ProfileAccess =='55 Hosted Solutions Sales' ) && (RecordtypeName != 'Customer')) || (ProfileAccess == '23 PRM Services User' || ProfileAccess == '24 PRM Marketing User')   || (ProfileAccess.contains('30 GS') || ProfileAccess.contains('31 GS'))){
            return 'ButtonNotAccess';    
        }  
        
      else if(ProfileAccess.contains('02 NSC UI Admin') || ProfileAccess.contains('03 PRM Admin') || ProfileAccess.contains('02 NSC Administrator') || ProfileAccess.contains('04 NSC UI Administrator'))
        {
            return 'ButtonAccess';     
        } 
          
        else  
        return 'ButtonNotAccess'; 
      }   
       @AuraEnabled 
       public static String ShowHodeEditWindowRevenue() {
           
       String ProfileAccess = [select id,name from profile where id=:userinfo.getProfileId()][0].Name;
    
        
       if((ProfileAccess == '54 Hosted Solutions Sales Operations' || ProfileAccess =='55 Hosted Solutions Sales' ) || (ProfileAccess == '23 PRM Services User' || ProfileAccess == '24 PRM Marketing User' )   || (ProfileAccess.contains('30 GS') || ProfileAccess.contains('31 GS'))){
            return 'WindowRevenueNotAccess';    
        }  
        
      else if(ProfileAccess.contains('02 NSC UI Admin') || ProfileAccess.contains('03 PRM Admin') || ProfileAccess.contains('02 NSC Administrator') || ProfileAccess.contains('04 NSC UI Administrator'))
        {
            return 'WindowRevenueAccess';     
        } 
          
        else  
        return 'WindowRevenueNotAccess'; 
       }
      
      @AuraEnabled
      public static List<String> getAcountCompetetors(Id Accountid){
       //List<Majors_Product_Matrix__c> comptest = new List<Majors_Product_Matrix__c>();
       //Account acc=new Account();
     String  acc=[Select id,name,Master_Customer_Number__c from Account where Id =:Accountid].Master_Customer_Number__c;
      String  comptest =[select id,name,Account_Name__c,MCN__c,Not_Sold_List__c,Purchased_List__c,New_Competetors__c,ATM_Client_SW__c,iServices__c,Channel_Management__c,ATM_SS_Fraud_SW__c,Check_Processing__c,Cx_Marketing__c,Remote_Distributed_Capture__c from Majors_Product_Matrix__c where MCN__c =:acc].New_Competetors__c;
        List<String> stnlst=comptest.split(';');
        if(stnlst.size()>0){
         return stnlst;
         }
         else{
         return null;
         }
          }

       @AuraEnabled
      public static List<String> getAcountPurchasedlist(Id Accountid){
      
       //Account acc1=new Account();
      String acc1=[Select id,name,Master_Customer_Number__c from Account where Id =:Accountid].Master_Customer_Number__c;
      String  purchasedstng =[select id,name,Account_Name__c,MCN__c,Not_Sold_List__c,Purchased_List__c,New_Competetors__c,ATM_Client_SW__c,iServices__c,Channel_Management__c,ATM_SS_Fraud_SW__c,Check_Processing__c,Cx_Marketing__c,Remote_Distributed_Capture__c from Majors_Product_Matrix__c where MCN__c =:acc1].Purchased_List__c;
        List<String> stnlst1=purchasedstng.split(';');
        if(stnlst1.size()>0){
         return stnlst1;
         }
         else{
         
         return null;
         }
          }
      
      @AuraEnabled
      public static List<String> getAcountNotSoldlist(Id Accountid){
      
      // Account acc2=new Account();
      String acc2=[Select id,name,Master_Customer_Number__c from Account where Id =:Accountid].Master_Customer_Number__c;
      String  nosoldstng =[select id,name,Account_Name__c,MCN__c,Not_Sold_List__c,Purchased_List__c,New_Competetors__c,ATM_Client_SW__c,iServices__c,Channel_Management__c,ATM_SS_Fraud_SW__c,Check_Processing__c,Cx_Marketing__c,Remote_Distributed_Capture__c from Majors_Product_Matrix__c where MCN__c =:acc2].Not_Sold_List__c;
        List<String> stnlst2=nosoldstng.split(';');
        if(stnlst2.size()>0){
         return stnlst2;
         }
         else{
         return null;
         }
          }

  
      
   //To get open opportunity products for account
      @AuraEnabled
      public static List<AggregateResult> getOpportunityProducts(Id Accountid){
       
       set<string> stageset=new set<String>{'Analyzing','Validating','Offering','Proposing','Closing'};
       List<AggregateResult> prditem=new List<AggregateResult>();
       List<Opportunity> opplist=new List<Opportunity>();
       opplist=[Select id,name,AccountId,StageName from Opportunity where AccountId =:Accountid AND StageName IN:stageset];
         system.debug('#####' +opplist);
         set<Id> prdctlineset=new set<id>();
     
      for(Opportunity oppid :opplist){   
          prdctlineset.add(oppid.id);
       
       }
       
       prditem=[Select sum(TotalPrice),PricebookEntry.Product2.Name,count(OpportunityId) from OpportunityLineItem where OpportunityId IN:prdctlineset group By PricebookEntry.Product2.name Order By  Sum(TotalPrice) DESC];
            if(prditem.size()>=0){
                    return prditem;
                    }
                    else{
                    return null;
                    }
      }  
     
    //To get Closed/Booked opportunities products related to account  
         @AuraEnabled
      public static List<AggregateResult> getOpportunityClosedProducts(Id Accountid){

       List<AggregateResult> prdcloseditem=new List<AggregateResult>();
       List<Opportunity> opplist1=new List<Opportunity>();
       opplist1=[Select id,name,AccountId,StageName from Opportunity where AccountId =:Accountid AND StageName='Closed/Booked'];
         set<Id> prdctlineset1=new set<id>();
          set<Id> prdctlineset2=new set<id>();
      for(Opportunity oppid1 :opplist1){
      
         prdctlineset1.add(oppid1.id);
 
       }
       
       prdcloseditem=[Select sum(TotalPrice),PricebookEntry.Product2.Name,count(OpportunityId) from OpportunityLineItem where OpportunityId IN:prdctlineset1 group By PricebookEntry.Product2.name Order By Sum(TotalPrice) DESC];
          if(prdcloseditem.size()>0){
          return prdcloseditem;
          }
          else{
              return null;
          }

        }
         
   @AuraEnabled
   
    public static String saveCompetetors(String testvalue)
    {
 
      ToplineCompetetors__c mpm =[Select Id, Competetors__c From ToplineCompetetors__c limit 1];
                   if(testvalue!=null){
                   mpm.Competetors__c = mpm.Competetors__c+';'+testvalue;
                   system.debug('%%%%%%%' +mpm.Competetors__c);
                   }
              upsert mpm;
         
        return mpm.Competetors__c;
              
    }
    
     @AuraEnabled 
    public static Map<String,String> getLabelofAccount(){
        List<String> LableList=new List<String>();
        String type='Account';
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Map<String,String> ApiLabelMap=new Map<String,String>();
        Schema.SObjectType leadSchema = schemaMap.get(type);
        Map<String, Schema.SObjectField> fieldMap = leadSchema.getDescribe().fields.getMap();
        for (String fieldName: fieldMap.keySet()) {
         //System.debug(fieldMap.get(fieldName).getDescribe().getLabel());//It provides to get the object fields label.
            if(!ApiLabelMap.containsKey(fieldName)){
                ApiLabelMap.put(fieldName, fieldMap.get(fieldName).getDescribe().getLabel());
            } 
        }
        return ApiLabelMap;
    }
    
    
     
}