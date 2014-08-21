trigger ChemoTherapyRegimenAfterTrigger on Chemo_Therapy_Regimen__c (after insert, after update) {
	if(Trigger.isInsert){
		SharingManager.shareObjectWithSite(Trigger.new, 'Chemo_Therapy_Regimen__c', 'Site');
	}
}