trigger ProtocolViolationDetailFormDeleteBeforeTrigger on ProtocolViolationDetail__c (before Delete,after Delete){     
     if(Trigger.isBefore){
        
     
        set<Id> setCrfIds = new set <Id>();
        set<Id> setCrfIdsr = new set <Id>();
        List<ProtocolViolationDetail__c> lstREF = new List<ProtocolViolationDetail__c>();
        List<ProtocolViolationDetail__c> lstREFr = new List<ProtocolViolationDetail__c>();
        List<ProtocolViolationDetail__c> clonedelete= new List<ProtocolViolationDetail__c>();
      
        for(ProtocolViolationDetail__c rec : trigger.old){
            if(rec.OriginalCRF__c != null && rec.Status__c=='Accepted'){ 
               setCrfIds.add(rec.OriginalCRF__c);
            }
            else if(rec.Status__c=='Rejected'){
               setCrfIdsr.add(rec.ID);
            }
        }
      
        lstREFr = [select Id, Status__c,Root_CRF_Id__c,OriginalCRF__c from ProtocolViolationDetail__c where OriginalCRF__c in :setCrfIdsr];
        System.debug('===lstREFr==='+ lstREFr);
        
        if(setCrfIdsr.size() > 0){
          for(ProtocolViolationDetail__c ae : lstREFr ){
              clonedelete.add(new ProtocolViolationDetail__c (id=ae.id));
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
              lstREF.add(new ProtocolViolationDetail__c (id=ids));
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