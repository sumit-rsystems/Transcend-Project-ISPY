trigger PreEligibilityBeforeTrigger on PreEligibility_Checklist__c (before insert,before update) {

    if(Trigger.isUpdate) {

        List<PreEligibility_Checklist__c> lstRandToShare = new List<PreEligibility_Checklist__c>();
        set<Id> setCrfIds = new set <Id>();
        for(PreEligibility_Checklist__c random : Trigger.new) {
            if(!Trigger.oldMap.get(random.Id).First_Save_and_Close__c && random.First_Save_and_Close__c) {
            lstRandToShare.add(random);
            
           } 
           setCrfIds.add(random.CRF_Id__c);
       }
       SharingManager.shareObjectWithSite(lstRandToShare, 'PreEligibility_Checklist__c', 'Site');
       }
}