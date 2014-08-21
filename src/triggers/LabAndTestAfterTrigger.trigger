trigger LabAndTestAfterTrigger on Lab_and_Test__c (after insert, after update) {
	if(Trigger.isInsert) {
		Set<Id> newCreatedCrfIds = new Set<Id>();
		for(Lab_and_Test__c lat: trigger.new) {
			if(lat.Status__c == 'Not Completed' && lat.OriginalCRF__c == null) {
				newCreatedCrfIds.add(lat.Id);
			}
		}
		/*commented to get characters for other coding
		if(!newCreatedCrfIds.isEmpty()) {
			TaskManager.updateTaskStatusToInProgress('Lab_and_Test__c', newCreatedCrfIds);
		}
		*/
	}
	
	if(trigger.isUpdate) {
		Set<Id> latIds = new Set<Id>();
		Set<Id> originalIds = new Set<Id>();
		for(Lab_and_Test__c lat: trigger.new) {
			if(lat.Status__c == 'Approval Pending' && Trigger.oldMap.get(lat.Id).Status__c != 'Approval Pending') {
				if(lat.OriginalCRF__c != null) {
					originalIds.add(lat.OriginalCRF__c);
				} else {
					latIds.add(lat.Id);
				}
			}
		}
	//complete task for rejected crf	
		if(!originalIds.isEmpty()) {
			/*commented to get characters for other coding
			TaskManager.completeTaskOfRejectedCRF(originalIds);
			*/
		}
		if(!latIds.isEmpty()) {
			/*commented to get characters for other coding
			TaskManager.updateTask(latIds, 'Lab_and_Test__c');
			*/
			SharingManager.shareAdditionalQuestionWithSite(latIds, 'Lab_and_Test__Share');
		}
	}
}