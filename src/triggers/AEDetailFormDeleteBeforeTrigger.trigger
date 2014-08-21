trigger AEDetailFormDeleteBeforeTrigger on AE_Detail__c(before Delete,after Delete){    
     if(Trigger.isBefore){
       
        set<Id> setCrfIds = new set <Id>();
        set<Id> setCrfIdsr = new set <Id>();
        List<AE_Detail__c> lstREF = new List<AE_Detail__c>();
        List<AE_Detail__c> lstREFr = new List<AE_Detail__c>();
        List<AE_Detail__c> clonedelete= new List<AE_Detail__c>();
        
        
        for(AE_Detail__c  rec : trigger.old){
           
            if(rec.OriginalCRF__c != null && rec.Status__c=='Accepted'){ 
               setCrfIds.add(rec.OriginalCRF__c);
            }
            else if(rec.Status__c=='Rejected'){
               setCrfIdsr.add(rec.ID);
            } 
        }
        
        lstREFr = [select Id, Status__c,Root_CRF_Id__c,OriginalCRF__c from AE_Detail__c where OriginalCRF__c in :setCrfIdsr And Status__c!='Accepted' ];
        if(setCrfIdsr.size() > 0){
          for(AE_Detail__c ae : lstREFr ){
              clonedelete.add(new AE_Detail__c (id=ae.id));
          }
          
          if(clonedelete.size() > 0){
             
             delete clonedelete;    
          }
        }
        
      
       if(setCrfIds.size() > 0){
          for(id ids : setCrfIds){
              
              lstREF.add(new AE_Detail__c (id=ids));
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