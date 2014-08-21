trigger ChemoSummaryForm on Chemo_Summary_Form__c (before insert,before update) {
  if(Trigger.isUpdate) {

        List<Chemo_Summary_Form__c> lstRandToShare = new List<Chemo_Summary_Form__c>();
        set<Id> setCrfIds = new set <Id>();
        for(Chemo_Summary_Form__c random : Trigger.new) {
         if(!Trigger.oldMap.get(random.Id).First_Save_and_Close__c && random.First_Save_and_Close__c) {
            lstRandToShare.add(random);
            
           }
       }
       SharingManager.shareObjectWithSite(lstRandToShare, 'Chemo_Summary_Form__c', 'Site');
       }
}