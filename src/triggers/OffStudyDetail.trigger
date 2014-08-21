trigger OffStudyDetail on Off_Study_Detail__c (before insert,before update) {
  if(Trigger.isUpdate) {

        List<Off_Study_Detail__c> lstRandToShare = new List<Off_Study_Detail__c>();
        set<Id> setCrfIds = new set <Id>();
        for(Off_Study_Detail__c random : Trigger.new) {
           if(!Trigger.oldMap.get(random.Id).First_Save_and_Close__c && random.First_Save_and_Close__c) {
            lstRandToShare.add(random);
            
           } 
       }
       SharingManager.shareObjectWithSite(lstRandToShare, 'Off_Study_Detail__c', 'Site');
       }
}