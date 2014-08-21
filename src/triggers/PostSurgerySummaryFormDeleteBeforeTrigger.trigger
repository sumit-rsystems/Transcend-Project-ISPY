trigger PostSurgerySummaryFormDeleteBeforeTrigger on Post_Surgaory_Summary__c (before Delete,after Delete){    
     if(Trigger.isBefore){
        set<Id> setCrfIds = new set <Id>();
        set<Id> setCrfIdsr = new set <Id>();
        List<Post_Surgaory_Summary__c> lstREF = new List<Post_Surgaory_Summary__c>();
        List<Post_Surgaory_Summary__c> lstREFr = new List<Post_Surgaory_Summary__c>();
        List<Post_Surgaory_Summary__c> clonedelete= new List<Post_Surgaory_Summary__c>();
      
        for(Post_Surgaory_Summary__c rec : trigger.old){
            if(rec.OriginalCRF__c != null && rec.Status__c=='Accepted'){ 
               setCrfIds.add(rec.OriginalCRF__c);
            }
            else if(rec.Status__c=='Rejected'){
               setCrfIdsr.add(rec.ID);
            }
        }
      
        lstREFr = [select Id, Status__c,Root_CRF_Id__c,OriginalCRF__c from Post_Surgaory_Summary__c where OriginalCRF__c in :setCrfIdsr];
        System.debug('===lstREFr==='+ lstREFr);
        
        if(setCrfIdsr.size() > 0){
          for(Post_Surgaory_Summary__c ae : lstREFr ){
              clonedelete.add(new Post_Surgaory_Summary__c (id=ae.id));
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
              lstREF.add(new Post_Surgaory_Summary__c (id=ids));
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