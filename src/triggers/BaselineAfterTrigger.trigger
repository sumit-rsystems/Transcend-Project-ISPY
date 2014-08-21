trigger BaselineAfterTrigger on BaselineSymptomsForm__c (after insert, after update) {
	if(Trigger.isInsert) {
		Set<Id> newCreatedCrfIds = new Set<Id>();
		for(BaselineSymptomsForm__c bsf: trigger.new) {
			if(bsf.Status__c == 'Not Completed' && bsf.OriginalCRF__c == null) {
				newCreatedCrfIds.add(bsf.Id);
			}
		}
		if(!newCreatedCrfIds.isEmpty()) {
			/*
			TaskManager.updateTaskStatusToInProgress('BaselineSymptomsForm__c', newCreatedCrfIds);
			*/
		}
	}
	if(trigger.isUpdate) {
		Set<Id> baselineIds = new Set<Id>();
		Set<Id> acceptedIds = new Set<Id>();
		Set<Id> originalIds = new Set<Id>();
		for(BaselineSymptomsForm__c bsf: trigger.new) {
			if(bsf.Status__c == 'Accepted') {
				acceptedIds.add(bsf.Id);
			}
			
			if(bsf.Status__c == 'Approval Pending' && Trigger.oldMap.get(bsf.Id).Status__c != 'Approval Pending') {
				if(bsf.OriginalCRF__c != null) {
					originalIds.add(bsf.OriginalCRF__c);
				} else {
					baselineIds.add(bsf.Id);
				}
			}
		}
	//complete task for rejected crf	
		if(!originalIds.isEmpty()) {
			/*commented to get characters for other coding
			TaskManager.completeTaskOfRejectedCRF(originalIds);
			*/
		}
		if(!baselineIds.isEmpty()) {
			/*
			TaskManager.updateTask(baselineIds, 'BaselineSymptomsForm__c');
			*/
		}
		if(!acceptedIds.isEmpty()) {
			CTCAECodeManager.createCTCAECode(acceptedIds, 'BaselineSymptomsForm__c');
		}
	}
}