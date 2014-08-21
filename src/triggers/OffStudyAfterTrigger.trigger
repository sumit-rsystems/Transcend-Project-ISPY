trigger OffStudyAfterTrigger on Off_Study_Detail__c (after insert, after update) {
	if(Trigger.isUpdate) {
		set<Id> crfIds = new set<Id>();
		set<Id> offIds = new set<Id>();
		set<Id> approvalPendingTrialPatIds = new set<Id>();
		set<Id> originalIds = new set<Id>();
		for(Off_Study_Detail__c off : Trigger.new){
			if(off.Status__c == 'Approval Pending' && Trigger.oldMap.get(off.Id).Status__c != 'Approval Pending') {
				if(off.OriginalCRF__c != null) {
					originalIds.add(off.OriginalCRF__c);
				}
			}
			if(off.Status__c != 'Accepted') continue;
			crfIds.add(off.CRF__c);
			offIds.add(off.Id);
		}
		List<Snomed_Code__c> lstSnomed = [select id,CRF__c,Name from Snomed_Code__c where CRF__c IN : crfIds];
		if(!lstSnomed.isEmpty()) {
			//first delete existing snomed codes
			delete lstSnomed;
		}
	//Now insert them again
		if(!offIds.isEmpty()) {
			SnomedCTCode.insertOffstudyRelatedCode(offIds);
		}
	//complete task for rejected crf
	/*	commented to get characters for other coding
		if(!originalIds.isEmpty()) {
			TaskManager.completeTaskOfRejectedCRF(originalIds);
		}
	//expire all task related to trialpatient	
		if(!approvalPendingTrialPatIds.isEmpty()) {
			TaskManager.updateTaskStatusToExpire(approvalPendingTrialPatIds);
		}
		*/
	}
}