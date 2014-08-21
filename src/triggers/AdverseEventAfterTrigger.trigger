trigger AdverseEventAfterTrigger on AE_Detail__c (after insert, after update) {
	if(Trigger.isInsert) {
		Set<Id> newCreatedCrfIds = new Set<Id>();
		for(AE_Detail__c ae: trigger.new) {
			if(ae.Status__c == 'Not Completed' && ae.OriginalCRF__c == null) {
				newCreatedCrfIds.add(ae.Id);
			}
		}
		if(!newCreatedCrfIds.isEmpty()) {
			/*commented to get characters for other coding
			TaskManager.updateTaskStatusToInProgress('AE_Detail__c', newCreatedCrfIds);
			*/
		}
	}
	
	if(trigger.isUpdate) {
		Set<Id> aeIds = new Set<Id>();
		Set<Id> originalIds = new Set<Id>();
		Set<Id> acceptedIds = new Set<Id>();
		for(AE_Detail__c ae: trigger.new) {
			if(ae.Status__c == 'Accepted') {
				acceptedIds.add(ae.Id);
			}
			if(ae.Status__c == 'Approval Pending' && Trigger.oldMap.get(ae.Id).Status__c != 'Approval Pending') {
				if(ae.OriginalCRF__c != null) {
					originalIds.add(ae.OriginalCRF__c);
				} else {
					aeIds.add(ae.Id);
				}
			}
		}
		if(!aeIds.isEmpty()) {
			/*commented to get characters for other coding
			TaskManager.updateTask(aeIds, 'AE_Detail__c');
			*/
		}
	//complete task for rejected crf	
		if(!originalIds.isEmpty()) {
			/*
			TaskManager.completeTaskOfRejectedCRF(originalIds);
			*/
		}
		if(!acceptedIds.isEmpty()) {
			CTCAECodeManager.createCTCAECode(acceptedIds, 'AE_Detail__c'); 
		}
	}
}