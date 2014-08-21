trigger NoLongerlosttoFollowup on No_Longer_lost_to_Followup__c (before update) {
  if(Trigger.isUpdate) {
        List<No_Longer_lost_to_Followup__c> lstRandToShare = new List<No_Longer_lost_to_Followup__c>();
        set<Id> setCrfIds = new set <Id>();
        for(No_Longer_lost_to_Followup__c random : Trigger.new) {
         if(!Trigger.oldMap.get(random.Id).First_Save_and_Close__c && random.First_Save_and_Close__c) {
            lstRandToShare.add(random);
           } 
       }
       SharingManager.shareObjectWithSite(lstRandToShare, 'No_Longer_lost_to_Followup__c', 'Site');
       }
}