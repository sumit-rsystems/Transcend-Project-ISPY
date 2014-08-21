trigger RegistrationBeforeTrigger on Registration__c (before insert,before update) {

    if(Trigger.isUpdate) {

        List<Registration__c> lstRandToShare = new List<Registration__c>();
        set<Id> setCrfIds = new set <Id>();
        for(Registration__c random : Trigger.new) {
            if(!Trigger.oldMap.get(random.Id).First_Save_and_Close__c && random.First_Save_and_Close__c) {
            lstRandToShare.add(random);
            
           } 
           setCrfIds.add(random.CRF__c);
       }
       SharingManager.shareObjectWithSite(lstRandToShare, 'Registration__c', 'Site');
       }
}