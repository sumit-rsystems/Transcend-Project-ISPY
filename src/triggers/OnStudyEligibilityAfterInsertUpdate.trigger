trigger OnStudyEligibilityAfterInsertUpdate on On_Study_Eligibility_Form__c (after insert, after update) {

    if(Trigger.isInsert) {
    	Set<Id> newCreatedCrfIds = new Set<Id>();
		for(On_Study_Eligibility_Form__c ose : Trigger.new) {
			if(ose.Status__c == 'Not Completed' && ose.OriginalCRF__c == null) {
				newCreatedCrfIds.add(ose.Id);
			}
		}
		if(!newCreatedCrfIds.isEmpty()) {
			/*commented to get characters for other coding
	        TaskManager.updateTaskStatusToInProgress('On_Study_Eligibility_Form__c', newCreatedCrfIds);
	        */
		}
    }
    if(Trigger.isUpdate) {
        Set<Id> crfIds = new Set<Id>();
        Set<Id> oseIds = new Set<Id>();
        Set<Id> originalIds = new Set<Id>();
        Set<Id> approvalPendingOseIds = new Set<Id>();
        for(On_Study_Eligibility_Form__c ose : Trigger.new) {
            if(ose.Status__c == 'Approval Pending' && Trigger.oldMap.get(ose.Id).Status__c != 'Approval Pending') {
                if(ose.OriginalCRF__c != null) {
					originalIds.add(ose.OriginalCRF__c);
                } else {
	                approvalPendingOseIds.add(ose.Id);
                }
            }
            if(ose.Status__c != 'Accepted') continue;
            crfIds.add(ose.CRF__c);
            oseIds.add(ose.Id);
        }
        List<Snomed_Code__c> snomedCodes = [Select id from Snomed_Code__c where CRF__c in :crfIds];
        if(!snomedCodes.isEmpty()) {
            delete snomedCodes;
        }
    //complete task for rejected crf	
		if(!originalIds.isEmpty()) {
			/*commented to get characters for other coding
			TaskManager.completeTaskOfRejectedCRF(originalIds);
			*/
		}
        if(!oseIds.isEmpty()) {
            SnomedCTCode.insertOnStudyEligibilityCode(oseIds);
        }
        if(!approvalPendingOseIds.isEmpty()) {
        	/*commented to get characters for other coding
            TaskManager.updateTask(approvalPendingOseIds, 'On_Study_Eligibility_Form__c');
            */
            SharingManager.shareAdditionalQuestionWithSite(approvalPendingOseIds, 'On_Study_Eligibility_Form__Share');
        }
    }
}