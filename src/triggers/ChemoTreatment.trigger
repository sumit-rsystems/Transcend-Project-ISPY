trigger ChemoTreatment on Chemo_Treatment__c (before insert,before update) {
  if(Trigger.isUpdate) {

        List<Chemo_Treatment__c> lstRandToShare = new List<Chemo_Treatment__c>();
        set<Id> setCrfIds = new set <Id>();
        for(Chemo_Treatment__c random : Trigger.new) {
           if(!Trigger.oldMap.get(random.Id).First_Save_and_Close__c && random.First_Save_and_Close__c) {
            lstRandToShare.add(random);
            
           } 
       }
       SharingManager.shareObjectWithSite(lstRandToShare, 'Chemo_Treatment__c', 'Site');
       }
}