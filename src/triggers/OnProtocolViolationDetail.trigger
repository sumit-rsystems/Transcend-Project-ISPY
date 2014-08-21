trigger OnProtocolViolationDetail on ProtocolViolationDetail__c (before insert,before update) {
  if(Trigger.isUpdate) {

        List<ProtocolViolationDetail__c> lstRandToShare = new List<ProtocolViolationDetail__c>();
        set<Id> setCrfIds = new set <Id>();
        for(ProtocolViolationDetail__c random : Trigger.new) {
          if(!Trigger.oldMap.get(random.Id).First_Save_and_Close__c && random.First_Save_and_Close__c) {
            lstRandToShare.add(random);
            
           }
       }
       SharingManager.shareObjectWithSite(lstRandToShare, 'ProtocolViolationDetail__c', 'Site');
       }
}