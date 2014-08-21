trigger OnStudyPathologyAfterTrigger on On_Study_Pathology_Form__c (after insert, after update) {
	if(Trigger.isInsert) {
		Set<Id> ospIds = new Set<Id>();
		for(On_Study_Pathology_Form__c osp : Trigger.new){
			if(osp.Status__c == 'Not Completed' && osp.OriginalCRF__c == null) {
				ospIds.add(osp.Id);
			}
		}
		if(!ospIds.isEmpty()) {
			/*commented to get characters for other coding
			TaskManager.updateTaskStatusToInProgress('On_Study_Pathology_Form__c', ospIds);
			*/
		}
	}
	if(Trigger.isUpdate){
		set<Id> crfIds = new set<Id>();
		set<Id> ospIds = new set<Id>();
		set<Id> originalIds = new set<Id>();
		set<Id> approvalPendingOspIds = new set<Id>();
		for(On_Study_Pathology_Form__c osp : Trigger.new){
			if(osp.Status__c == 'Approval Pending' && Trigger.oldMap.get(osp.Id).Status__c != 'Approval Pending') {
				if(osp.OriginalCRF__c != null) {
					originalIds.add(osp.OriginalCRF__c);
				} else {
					approvalPendingOspIds.add(osp.Id);
				}
			}
			if(osp.Status__c != 'Accepted') continue;
			crfIds.add(osp.CRF__c);
			ospIds.add(osp.Id);
		}
		List<Snomed_Code__c> lstSnomedCode = [select id,Name,CRF__c from Snomed_Code__c where CRF__c IN : crfIds];
		if(!lstSnomedCode.isEmpty()) {
			delete lstSnomedCode;
		}
	//complete task for rejected crf	
		if(!originalIds.isEmpty()) {
			/*commented to get characters for other coding
			TaskManager.completeTaskOfRejectedCRF(originalIds);
			*/
		}
		if(!Test.isRunningTest() && !ospIds.isEmpty()) {
			SnomedCTCode.insertOnStudyPathologyCode(ospIds);
		}
		if(!approvalPendingOspIds.isEmpty()) {
			/*commented to get characters for other coding
			TaskManager.updateTask(approvalPendingOspIds, 'On_Study_Pathology_Form__c');
			*/
		}
	}
}