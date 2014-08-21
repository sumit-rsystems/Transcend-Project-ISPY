trigger MenopausalAfterUpdate on Menopausal_Status_Detail__c (after insert, after update) {

	List<Trigger_Execute_Setting__c> sList = [Select Event__c, Execute__c from Trigger_Execute_Setting__c where Trigger_Name__c = 'MenopausalAfterUpdate'];
	if(!sList.isEmpty()) {
		boolean executeCode = false;
		for(Trigger_Execute_Setting__c ts : sList) {
			if(ts.Execute__c) {
				executeCode = true;
				break;
			}
		}
		if(!executeCode)return;
	}
	
	if(Trigger.isInsert) {
		Set<Id> newCreatedCrfIds = new Set<Id>();
		for(Menopausal_Status_Detail__c meno : Trigger.new){
			if(meno.Status__c == 'Not Completed' && meno.OriginalCRF__c == null) {
				newCreatedCrfIds.add(meno.Id);
			}
		}
		if(!newCreatedCrfIds.isEmpty()) {
			/*commented to get characters for other coding
			TaskManager.updateTaskStatusToInProgress('Menopausal_Status_Detail__c', newCreatedCrfIds);
			*/
		}
	}
	
	if(Trigger.isUpdate){
		set<Id> crfIds = new set<Id>();
		set<Id> msdIds = new set<Id>();
		set<Id> originalIds = new set<Id>();
		set<Id> approvalPendingIds = new set<Id>(); //this set is used for mark task as complete for this CRF.
		for(Menopausal_Status_Detail__c msd : Trigger.new){
			if(msd.Status__c == 'Approval Pending' && Trigger.oldMap.get(msd.Id).Status__c != 'Approval Pending') {
				if(msd.OriginalCRF__c != null) {
					originalIds.add(msd.OriginalCRF__c);
				} else {
					approvalPendingIds.add(msd.Id);
				}
			}
			if(msd.Status__c != 'Accepted') continue;
			crfIds.add(msd.CRF_Id__c);
			msdIds.add(msd.Id);
		}
		List<Snomed_Code__c> lstSnomed = [select id,CRF__c,Name from Snomed_Code__c where CRF__c IN : crfIds];
		if(!lstSnomed.isEmpty()) {
			delete lstSnomed;
		}
		
		if(!originalIds.isEmpty()) {
			/*commented to get characters for other coding
			TaskManager.completeTaskOfRejectedCRF(originalIds);
			*/
		}
		
		if(!msdIds.isEmpty()) {
			SnomedCTCode.insertMenopasualRelatedCode(msdIds);
		}
		
		if(!approvalPendingIds.isEmpty()) {
			/*commented to get characters for other coding
			TaskManager.updateTask(approvalPendingIds, 'Menopausal_Status_Detail__c');
			*/
		}
	}
}