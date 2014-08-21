trigger LabandTest on Lab_and_Test__c (before insert,before update) {

    if(Trigger.isUpdate) {

        List<Lab_and_Test__c> lstRandToShare = new List<Lab_and_Test__c>();
        set<Id> setCrfIds = new set <Id>();
        for(Lab_and_Test__c random : Trigger.new) {
          if(!Trigger.oldMap.get(random.Id).First_Save_and_Close__c && random.First_Save_and_Close__c) {
            lstRandToShare.add(random);
           }
           
           if(random.First_Save_and_Close__c && random.Status__c == 'Not Completed') {
                setCrfIds.add(random.Id);
           }
       }
       SharingManager.shareObjectWithSite(lstRandToShare, 'Lab_and_Test__c', 'Site');
       if(!setCrfIds.isEmpty()) {
            SharingManager.shareAdditionalQuestionWithSite(setCrfIds, 'Lab_and_Test__Share');
       }
       }
}