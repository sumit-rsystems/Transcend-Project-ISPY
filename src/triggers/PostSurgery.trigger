trigger PostSurgery on Post_Surgaory_Summary__c (before insert,before update) {
  if(Trigger.isUpdate) {

        List<Post_Surgaory_Summary__c> lstRandToShare = new List<Post_Surgaory_Summary__c>();
        set<Id> setCrfIds = new set <Id>();
        for(Post_Surgaory_Summary__c random : Trigger.new) {
          if(!Trigger.oldMap.get(random.Id).First_Save_and_Close__c && random.First_Save_and_Close__c) {
            lstRandToShare.add(random);
            
           } 
       }
       SharingManager.shareObjectWithSite(lstRandToShare, 'Post_Surgaory_Summary__c', 'Site');
       }
}