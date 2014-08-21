trigger MammaPrintAfterTrigger on MammaPrintDetail__c (after insert, after update) {
	if(Trigger.isInsert) {
		/*commented to get characters for other coding
		TaskManager.updateMammaPrintTaskStatusToInProgress('MammaPrintDetail__c', trigger.newMap.keySet());
		*/
	}
	if(Trigger.isUpdate){
		set<Id> setIds = new set<Id>();
		set<Id> mpdIds = new set<Id>();
		set<Id> completeMPdIds = new set<Id>();
		for(MammaPrintDetail__c mpd : Trigger.new){
			if(mpd.Status__c == 'Completed') {
				completeMPdIds.add(mpd.Id);
			}
			if(mpd.Status__c != 'Approval Not Required') continue;
			setIds.add(mpd.CRF__c);
			mpdIds.add(mpd.Id);
		}
		List<Snomed_Code__c> lstSnomed = [select id,CRF__c,Name from Snomed_Code__c where CRF__c IN : setIds];
		if(!lstSnomed.isEmpty()) {
			delete lstSnomed;
		}
		if(!mpdIds.isEmpty()) {
			if(!Test.isRunningTest()) {
				SnomedCTCode.insertMammaPrintCode(mpdIds);
				/*commented to get characters for other coding
				TaskManager.updateTaskOfMammaPrint(mpdIds, 'MammaPrintDetail__c');
				*/
			}
		}
		
		if(!completeMPdIds.isEmpty()) {
			SharingManager.shareObjectWithSite(Trigger.new, 'MammaPrintDetail__c', 'Lab');
			if(!Test.isRunningTest()) {
				/*commented to get characters for other coding
				TaskManager.createTaskAfterMammaprintCompletion(completeMPdIds);
				*/
				//TaskManager.updateTaskOfMammaPrint(completeMPdIds, 'MammaPrintDetail__c');
			}
		}
		
	}
}