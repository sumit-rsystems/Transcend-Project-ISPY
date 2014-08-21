trigger BloodSpecimenAfterTrigger on BloodSpecimenForm__c (after insert, after update) {
	if(Trigger.isInsert) {
		/*commented to get characters for other coding
		TaskManager.updateTaskStatusToInProgress('BloodSpecimenForm__c', trigger.newMap.keySet());
		*/
	}
	
	if(Trigger.isUpdate) {
		Set<Id> bloodIds = new Set<Id>();
		for(BloodSpecimenForm__c bsf: trigger.new) {
			if(bsf.Status__c != 'Approval Not Required') continue;
			if(Trigger.oldMap.get(bsf.Id).Status__c != 'Approval Not Required') {
				bloodIds.add(bsf.Id);
			}
		}
		if(!bloodIds.isEmpty()) {
			/*
			TaskManager.updateTask(bloodIds, 'BloodSpecimenForm__c');
			*/
		}
	}
}