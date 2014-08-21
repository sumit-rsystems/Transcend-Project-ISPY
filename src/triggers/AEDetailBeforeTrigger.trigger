trigger AEDetailBeforeTrigger on AE_Detail__c (before insert,before update) {

    if(Trigger.isUpdate) {

        List<AE_Detail__c> lstRandToShare = new List<AE_Detail__c>();
        set<Id> setCrfIds = new set <Id>();
        for(AE_Detail__c random : Trigger.new) {
           if(!Trigger.oldMap.get(random.Id).First_Save_and_Close__c && random.First_Save_and_Close__c) {
            lstRandToShare.add(random);
           }
       }
       SharingManager.shareObjectWithSite(lstRandToShare, 'AE_Detail__c', 'Site');
       }
}