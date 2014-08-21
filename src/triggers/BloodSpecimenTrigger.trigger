trigger BloodSpecimenTrigger on BloodSpecimenForm__c (before insert,before update) {

    if(Trigger.isUpdate) {

        List<BloodSpecimenForm__c> lstRandToShare = new List<BloodSpecimenForm__c>();
        set<Id> setCrfIds = new set <Id>();
        for(BloodSpecimenForm__c random : Trigger.new) {
        	        
         	if(!Trigger.oldMap.get(random.Id).First_Save_and_Close__c && random.First_Save_and_Close__c) {
            	lstRandToShare.add(random);
	        } 
           	setCrfIds.add(random.CRF__c);
       	}
      SharingManager.shareObjectWithSite(lstRandToShare, 'BloodSpecimenForm__c', 'Site');
    } 
}