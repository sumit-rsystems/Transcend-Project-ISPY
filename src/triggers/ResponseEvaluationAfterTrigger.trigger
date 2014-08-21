trigger ResponseEvaluationAfterTrigger on Response_Evaluation_Form__c (after insert, after update) {
	
	//SharingManager.shareObjectWithSite(Trigger.new, 'Response_Evaluation_Form__c', 'Site');
	//SharingManager.shareObjectWithSite(Trigger.new, 'Response_Evaluation_Form__c', 'Lab');
	//SharingManager.shareObjectWithSite(Trigger.new, 'Response_Evaluation_Form__c', 'Lab Technician');
	//SharingManager.shareObjectWithSite(Trigger.new, 'Response_Evaluation_Form__c', 'Lab Supervisor');
	
	if(Trigger.isInsert) {
		Set<Id> newCreatedCrfIds = new Set<Id>();
		for(Response_Evaluation_Form__c ref : Trigger.new){
			if(ref.Status__c == 'Not Completed' && ref.OriginalCRF__c == null) {
				newCreatedCrfIds.add(ref.Id);
			}
		}
		if(!newCreatedCrfIds.isEmpty()) {
			/*commented to get characters for other coding
			TaskManager.updateTaskStatusToInProgress('Response_Evaluation_Form__c', newCreatedCrfIds);
			*/
		}
	}
	if(Trigger.isUpdate){
		set<Id> crfIds = new set<Id>();
		set<Id> refIds = new set<Id>();
		Set<Id> approvalPendingRef = new Set<Id>();
		set<Id> originalIds = new set<Id>();
		
		for(Response_Evaluation_Form__c ref : Trigger.new){
			if(ref.Status__c == 'Approval Pending' && Trigger.oldMap.get(ref.Id).Status__c != 'Approval Pending') {
				if(ref.OriginalCRF__c != null) {
					originalIds.add(ref.OriginalCRF__c);
				} else {
					approvalPendingRef.add(ref.Id);
				}
			}
			
			if(ref.Status__c != 'Accepted') continue;
			crfIds.add(ref.CRF__c);
			refIds.add(ref.Id);
		}
		List<Snomed_Code__c> lstSnomed = [select id,CRF__c,Name from Snomed_Code__c where CRF__c IN : crfIds];
		//Added by Bakul on 26-12 to recreate snomed code records upon udate
		if(!lstSnomed.isEmpty()) {
			delete lstSnomed;
		}
	//complete task for rejected crf	
		if(!originalIds.isEmpty()) {
			/*commented to get characters for other coding
			TaskManager.completeTaskOfRejectedCRF(originalIds);
			*/
		}
		
		if(!refIds.isEmpty()) {
			SnomedCTCode.insertSnomedCodesForResponseEvaluation(refIds);
		}
	//complete task for newly added crf 
		if(!approvalPendingRef.isEmpty()) {
			/*commented to get characters for other coding
			TaskManager.updateTask(approvalPendingRef, 'Response_Evaluation_Form__c');
			*/
		}
	}
}