trigger BaselineSymptomsForm on BaselineSymptomsForm__c (before update) {

    if(Trigger.isUpdate) {

        List<BaselineSymptomsForm__c> lstRandToShare = new List<BaselineSymptomsForm__c>();
        set<Id> setCrfIds = new set <Id>();
        for(BaselineSymptomsForm__c random : Trigger.new) {
         if(!Trigger.oldMap.get(random.Id).First_Save_and_Close__c && random.First_Save_and_Close__c) {
            lstRandToShare.add(random);
            
           }
       }
       SharingManager.shareObjectWithSite(lstRandToShare, 'BaselineSymptomsForm__c', 'Site');
       }
}