trigger ChangePatientNamePreEligibilityAfterInsertUpdate on PreEligibility_Checklist__c (after insert, after update) {
	
	/*if(TransactionTracker.TRANSACTION_NUM == 0) {
		TransactionTracker.TRANSACTION_NUM = 1;
	} else {
		TransactionTracker.TRANSACTION_NUM = 0;
		return;
	}*/
	//List<RecordType> recTypeApproval = [select id,Name from RecordType where sObjectType = 'PreEligibility_Checklist__c' and Name = 'Approval Pending' ];
	
	Set<Id> CRFIds = new Set<Id>();
	Set<Id> patientIds = new Set<Id>();
	Set<Id> recIds = new Set<Id>();
	Set<Id> recIdForTask = new Set<Id>();
	for(PreEligibility_Checklist__c preObj : Trigger.new) {
		if(preObj.Status__c != 'Approval Not Required') continue;
		patientIds.add(preObj.Patient__c);
		recIds.add(preObj.Id);
		CRFIds.add(preObj.CRF_Id__c);
		system.debug('__preObj.Patient__c__'+preObj.Patient__c);
		system.debug('__preObj.Patient_signed_up_for_I_SPY2_screening__c__'+preObj.Patient_signed_up_for_I_SPY2_screening__c);
		if(Trigger.isUpdate && preObj.Patient_signed_up_for_I_SPY2_screening__c) {
			//for update only
			recIdForTask.add(preObj.Id);
		} else if(Trigger.isInsert && preObj.Patient_signed_up_for_I_SPY2_screening__c) {
			//for insert only
			recIdForTask.add(preObj.Id);
		}
	}
	system.debug('__recIdForTask__'+recIdForTask);
	if(!recIdForTask.isEmpty()) {
		/*commented to get characters for other coding
		TaskManager.createTaskAfterPreEligibility(recIdForTask);
		*/
	}
	
	/*List<Patient_Custom__c> patientList = [select Id, First_Name__c, Last_Name__c, Signed_Screening__c from Patient_Custom__c where Id IN :patientIds];
	
	List<Patient_Custom__c> updatePatientList = new List<Patient_Custom__c>();
	for(PreEligibility_Checklist__c preObj : Trigger.new) {
		if(preObj.RecordTypeId != recTypeApproval[0].Id)continue;
		
		for(Patient_Custom__c patientObj : patientList) {
			if(patientObj.Signed_Screening__c != preObj.Patient_signed_up_for_I_SPY2_screening__c) {
				patientObj.Signed_Screening__c = preObj.Patient_signed_up_for_I_SPY2_screening__c;
				updatePatientList.add(patientObj);
			}
		}
	}
	system.debug('__updatePatientList__'+updatePatientList);
	if(!updatePatientList.isEmpty()) {
		update updatePatientList;
	}*/
	
	/*if(Trigger.isInsert){
		List<Code_Master__c> lstSnomedMaster = [select id,Name,Variable_Description__c from Code_Master__c where Name = 'ECOG'];
		List<Snomed_Code__c> lstSnomed = new List<Snomed_Code__c>();
		for(PreEligibility_Checklist__c pre : Trigger.new){
			for(Code_Master__c sm : lstSnomedMaster){
				if(pre.ECOG_Score__c == null){
					Snomed_Code__c sc = new Snomed_Code__c();
					sc.CRF__c = pre.CRF_Id__c;
					sc.Name = '423740007';
					SnomedCTCode.SnomedWrapper sw = SnomedCTCode.SnomedCode('423740007', pre.ECOG_Score__c);
					sc.Value__c = sw.snomedCodeVal;
					sc.Code_System__c = sw.codeSystem;
					sc.Numeric_Value__c = sw.numericValue;
					sc.Code_Master__c = sm.Id;
					lstSnomed.add(sc);
				}
			}
		}
		if(!lstSnomed.isEmpty()){
			insert lstSnomed;
		}
	}*/
	if(Trigger.isUpdate){
		/*List<Snomed_Code__c> lstSnomed = new List<Snomed_Code__c>();
		set<Id> setIds = new set<Id>();
		for(PreEligibility_Checklist__c pre : Trigger.new){
			setIds.add(pre.CRF_Id__c);
		}
		List<Snomed_Code__c> lstSnomedCode = [select id,CRF__c,Value__c,Name from Snomed_Code__c where CRF__c IN : setIds];
		for(PreEligibility_Checklist__c pre : Trigger.new){
			for(Snomed_Code__c sc : lstSnomedCode){
				if(pre.CRF_Id__c == sc.CRF__c){ 
					if(sc.Name == '423740007'){
						SnomedCTCode.SnomedWrapper sw = SnomedCTCode.SnomedCode('423740007', pre.ECOG_Score__c);
						sc.Value__c = sw.snomedCodeVal;
						sc.Code_System__c = sw.codeSystem;
						sc.Numeric_Value__c = sw.numericValue;
					}
				}
			}
		}
		if(!lstSnomedCode.isEmpty()){
			update lstSnomedCode;
		}*/
		List<Pre_Registration_Snomed_Codes__c> lstSnomedCode = [select id,CRF__c,Value__c,Name from Pre_Registration_Snomed_Codes__c where CRF__c IN : CRFIds];
		if(!lstSnomedCode.isEmpty() && !Test.isRunningTest()) {
			delete lstSnomedCode;
		} 
		if(!recIds.isEmpty()) {
			SnomedCTCode.insertPrelEligibilityCodes(recIds);
		}
	}
	
}