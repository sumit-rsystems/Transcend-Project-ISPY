trigger ChemoTreatmentAfterInsertUpdate on Chemo_Treatment__c (after insert, after update) {

	if(Trigger.isInsert) {
		List<Chemo_Treatment__c> lstChemoTreatment = [Select (Select Name, Chemo_Treatment__c, Dose__c, End_Day__c, End_Month__c, End_Year__c, Frequency__c, Medication__c, Other_Madication__c, Route__c, Start_Day__c, Start_Month__c, Start_Year__c, Type__c, DoseValue__c From Concomitant_Medications__r) From Chemo_Treatment__c c 
								where TrialPatient__c = :Trigger.new[0].TrialPatient__c and Id != :trigger.new[0].Id and Status__c = 'Accepted' 
								order by CreatedDate desc limit 1];
		List<Concomitant_Medication__c> lstConMed_Copy = new List<Concomitant_Medication__c>();
		for(Chemo_Treatment__c ct : lstChemoTreatment) {
			if(Trigger.new[0].OriginalCRF__c != null) continue;
			List<Concomitant_Medication__c> lstConMed = ct.Concomitant_Medications__r;
			if(lstConMed == null) continue;
			for(Concomitant_Medication__c conMed : lstConMed) {
				Concomitant_Medication__c cmCopy = new Concomitant_Medication__c();
				cmCopy.Chemo_Treatment__c = Trigger.new[0].Id;
				cmCopy.Dose__c = conMed.Dose__c;
				cmCopy.DoseValue__c = conMed.DoseValue__c;
				cmCopy.End_Day__c = conMed.End_Day__c;
				cmCopy.End_Month__c = conMed.End_Month__c;
				cmCopy.End_Year__c = conMed.End_Year__c;
				cmCopy.Frequency__c = conMed.Frequency__c;
				cmCopy.Medication__c = conMed.Medication__c;
				cmCopy.Other_Madication__c = conMed.Other_Madication__c;
				cmCopy.Route__c = conMed.Route__c;
				cmCopy.Start_Day__c = conMed.Start_Day__c;
				cmCopy.Start_Month__c = conMed.Start_Month__c;
				cmCopy.Start_Year__c = conMed.Start_Year__c;
				cmCopy.Type__c = conMed.Type__c;
				lstConMed_Copy.add(cmCopy);
			}
		}	
		insert lstConMed_Copy;	
		Set<Id> newCreatedCrfIds = new Set<Id>();
		for(Chemo_Treatment__c ct : Trigger.new){
			if(ct.Status__c == 'Not Completed' && ct.OriginalCRF__c == null) {
				newCreatedCrfIds.add(ct.Id);
			}
		}	
		if(!newCreatedCrfIds.isEmpty()) {
			/*commented to get characters for other coding
			TaskManager.updateTaskStatusToInProgress('Chemo_Treatment__c', newCreatedCrfIds);
			*/
		}
	}
	if(Trigger.isUpdate){
		set<Id> crfIds = new set<Id>();
		set<Id> ctIds = new set<Id>();
		set<Id> originalIds = new set<Id>();
		Set<Id> trialPatients = new Set<Id>();
		Set<Id> approvalPendingCTIds = new Set<Id>();
		for(Chemo_Treatment__c ct : Trigger.new){
			if(ct.Status__c == 'Approval Pending' && Trigger.oldMap.get(ct.Id).Status__c != 'Approval Pending') {
				if(ct.OriginalCRF__c != null) {
					originalIds.add(ct.OriginalCRF__c);
				} else {
					approvalPendingCTIds.add(ct.Id);
				}
			}
			if(ct.Status__c != 'Accepted') continue;
			if(ct.Status__c != 'Cloned' && Trigger.oldMap.get(ct.Id).Status__c != 'Cloned') {
				trialPatients.add(ct.TrialPatient__c);
			}
			crfIds.add(ct.CRF__c);
			ctIds.add(ct.Id);
		}
		List<Snomed_Code__c> lstSnomed = [select id,CRF__c,Name from Snomed_Code__c where CRF__c IN : crfIds];
		if(!lstSnomed.isEmpty()) {
			delete lstSnomed;
		}
		if(!ctIds.isEmpty()) {
			SnomedCTCode.insertSnomedCodesForChemoTreatment(ctIds);
		}
	//complete task for rejected crf	
		if(!originalIds.isEmpty()) {
			/*commented to get characters for other coding
			TaskManager.completeTaskOfRejectedCRF(originalIds);
			*/
		}
		if(!approvalPendingCTIds.isEmpty()) {
			/*commented to get characters for other coding
			TaskManager.updateTask(approvalPendingCTIds, 'Chemo_Treatment__c');
			*/
		}
		if(!Test.isRunningTest() && !trialPatients.isEmpty()) {
            //RandomizationXMLBuilder.updatePatientXML(trialPatients);
            for(Chemo_Treatment__c currentValue : trigger.new){
            	for(Chemo_Treatment__c previousValue : trigger.old){
            		if(currentValue.Date_of_therapy__c != previousValue.Date_of_therapy__c){
	            		RandomizationXMLBuilder.updateStartDate(trialPatients);
            		}
            	}
            }
        }
	}
}