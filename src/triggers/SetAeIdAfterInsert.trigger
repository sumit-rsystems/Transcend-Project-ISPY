trigger SetAeIdAfterInsert on Toxicity__c (after insert) {
    if(Trigger.isInsert){
          SharingManager.shareObjectWithSite(Trigger.new, 'Toxicity__c', 'Site');
    }  

}