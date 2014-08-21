trigger FollowupFormAfterInsertUpdate on Followup_Form__c (after insert, after update) {
	if(Trigger.isInsert) {
		Set<Id> newCreatedCrfIds = new Set<Id>();
		for(Followup_Form__c ff : Trigger.new){
			if(ff.Status__c == 'Not Completed' && ff.OriginalCRF__c == null) {
				newCreatedCrfIds.add(ff.Id);
			}
		}
		if(!newCreatedCrfIds.isEmpty()) {
			/*commented to get characters for other coding
			TaskManager.updateTaskStatusToInProgress('Followup_Form__c', newCreatedCrfIds);
			*/
		}
	}
	if(Trigger.isUpdate) {
		set<Id> crfIds = new set<Id>();
		set<Id> ffIds = new set<Id>();
		set<Id> trialPatIds = new set<Id>();
		set<Id> approvalPendingIds = new set<Id>();
		set<Id> originalIds = new set<Id>();
		for(Followup_Form__c ff : Trigger.new){
			if(ff.Status__c == 'Approval Pending' && Trigger.oldMap.get(ff.Id).Status__c != 'Approval Pending') {
				if(ff.OriginalCRF__c != null) {
					originalIds.add(ff.OriginalCRF__c);
				} else {
					approvalPendingIds.add(ff.Id);
				}
			}
			if(ff.Status__c != 'Accepted') continue;
			crfIds.add(ff.CRF__c);
			ffIds.add(ff.Id);
			trialPatIds.add(ff.TrialPatient__c);
		}
		if(!trialPatIds.isEmpty()) {
			/*commented to get characters for other coding
			TaskManager.createFollowUpTask(trialPatIds);
			*/
		}
		List<Snomed_Code__c> lstSnomed = [select id,CRF__c,TrialPatient__c,Name from Snomed_Code__c where CRF__c IN :crfIds];
		if(!lstSnomed.isEmpty()) {
			delete lstSnomed;
		}
	//complete task for rejected crf
	/*commented to get characters for other coding	
		if(!originalIds.isEmpty()) {
			TaskManager.completeTaskOfRejectedCRF(originalIds);
		}
		if(!approvalPendingIds.isEmpty()) {
			TaskManager.updateTask(approvalPendingIds, 'Followup_Form__c');
		}
		*/
		if(!ffIds.isEmpty()) {
			SnomedCTCode.insertSnomedCodeForFollowup(ffIds);
		}
	}
}