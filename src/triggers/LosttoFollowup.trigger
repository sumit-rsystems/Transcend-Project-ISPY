trigger LosttoFollowup on Lost_to_Follow_Up__c (before insert,before update) {
  if(Trigger.isUpdate) {

        List<Lost_to_Follow_Up__c> lstRandToShare = new List<Lost_to_Follow_Up__c>();
        set<Id> setCrfIds = new set <Id>();
        for(Lost_to_Follow_Up__c random : Trigger.new) {
          if(!Trigger.oldMap.get(random.Id).First_Save_and_Close__c && random.First_Save_and_Close__c) {
            lstRandToShare.add(random);
            
           } 
       }
       SharingManager.shareObjectWithSite(lstRandToShare, 'Lost_to_Follow_Up__c', 'Site');
       }
}