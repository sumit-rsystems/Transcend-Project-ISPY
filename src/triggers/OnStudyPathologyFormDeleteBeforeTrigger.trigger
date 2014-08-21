trigger OnStudyPathologyFormDeleteBeforeTrigger on On_Study_Pathology_Form__c (before Delete,after Delete){     
     if(Trigger.isBefore){
        
        if(TransactionTracker.TRANSACTION_NUM == 0){
           TransactionTracker.TRANSACTION_NUM = 1;
        } else{
              TransactionTracker.TRANSACTION_NUM = 0;
              return;
          }
        set<Id> setCrfIds = new set <Id>();
        set<Id> setCrfIdsr = new set <Id>();
        List<On_Study_Pathology_Form__c> lstREF = new List<On_Study_Pathology_Form__c>();
        List<On_Study_Pathology_Form__c> lstREFr = new List<On_Study_Pathology_Form__c>();
        List<On_Study_Pathology_Form__c> clonedelete= new List<On_Study_Pathology_Form__c>();
      
        for(On_Study_Pathology_Form__c rec : trigger.old){
            if(rec.OriginalCRF__c != null && rec.Status__c=='Accepted'){ 
               setCrfIds.add(rec.OriginalCRF__c);
            }
            else if(rec.Status__c=='Rejected'){
               setCrfIdsr.add(rec.ID);
            }
        }
      
        lstREFr = [select Id, Status__c,Root_CRF_Id__c,OriginalCRF__c from On_Study_Pathology_Form__c where OriginalCRF__c in :setCrfIdsr];
        System.debug('===lstREFr==='+ lstREFr);
        
        if(setCrfIdsr.size() > 0){
          for(On_Study_Pathology_Form__c ae : lstREFr ){
              clonedelete.add(new On_Study_Pathology_Form__c (id=ae.id));
          }
          System.debug('===clonedelete==='+ clonedelete);
          if(clonedelete.size() > 0){
             System.debug('===clonedelete1==='+ clonedelete);
             delete clonedelete;    
          }
        }
        
      
       if(setCrfIds.size() > 0){
          for(id ids : setCrfIds){
              System.debug('===setCrfIds==='+ setCrfIds);
              lstREF.add(new On_Study_Pathology_Form__c (id=ids));
          }
       }
      
       if(lstREF.size() > 0){
          delete lstREF;    
       }
     }
     
     if(Trigger.isAfter){
        ID id_to_clone=null;
        if(trigger.old[0].OriginalCRF__c != null){
           id_to_clone=trigger.old[0].OriginalCRF__c;
           CloneBuilder.cloneMeFutureCall(id_to_clone, '0','');
        }
     }
}