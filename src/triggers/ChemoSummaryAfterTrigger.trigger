trigger ChemoSummaryAfterTrigger on Chemo_Summary_Form__c (after insert, after update) {
	if(Trigger.isInsert) {
		Set<Id> newCreatedCrfIds = new Set<Id>();
		for(Chemo_Summary_Form__c csf: trigger.new) {
			if(csf.Status__c == 'Not Completed' && csf.OriginalCRF__c == null) {
				newCreatedCrfIds.add(csf.Id);
			}
		}
		if(!newCreatedCrfIds.isEmpty()) {
			/*
			TaskManager.updateTaskStatusToInProgress('Chemo_Summary_Form__c', newCreatedCrfIds);
			*/
		}
	}
	if(trigger.isUpdate) {
		Set<Id> csfIds = new Set<Id>();
		Set<Id> originalIds = new Set<Id>();
		for(Chemo_Summary_Form__c csf: trigger.new) {
			if(csf.Status__c == 'Approval Pending' && Trigger.oldMap.get(csf.Id).Status__c != 'Approval Pending') {
				if(csf.OriginalCRF__c != null) {
					originalIds.add(csf.OriginalCRF__c);
				} else {
					csfIds.add(csf.Id);
				}
			}
		}
	//complete task for rejected crf	
		if(!originalIds.isEmpty()) {
			/*commented to get characters for other coding
			TaskManager.completeTaskOfRejectedCRF(originalIds);
			*/
		}
		if(!csfIds.isEmpty()) {
			/*commented to get characters for other coding
			TaskManager.updateTask(csfIds, 'Chemo_Summary_Form__c');
			*/
		}
	}
}