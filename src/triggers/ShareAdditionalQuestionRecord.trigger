trigger ShareAdditionalQuestionRecord on CRFAdditionalQuestion__c (after insert) {
	Set<String> crfMasterNames = new Set<String>();
	for(CRFAdditionalQuestion__c caq : Trigger.new) {
		crfMasterNames.add(caq.CRFType__c);
	}
	
	List<CRFMaster__c> lstCrfMaster = [select Id, Name, CRFType__c, Object_Name__c from CRFMaster__c where Name IN:crfMasterNames];
	Set<Id> onStudyIds = new Set<Id>(); //Ids of on study eligibility
	Set<Id> labAndTestIds = new Set<Id>(); //Ids of lab And Test
	for(CRFAdditionalQuestion__c caq : Trigger.new) {
		for(CRFMaster__c crfm : lstCrfMaster) {
			if(crfm.Name == caq.CRFType__c) {
				system.debug('crfm.Name: '+crfm.Name);
				if(crfm.Name == '00009') {
					onStudyIds.add(caq.CRFId__c);
				} else if(crfm.Name == '00055'){
					labAndTestIds.add(caq.CRFId__c);
				}
			}
		}
	}
	
	system.debug('onStudyIds: '+onStudyIds);
	system.debug('labAndTestIds: '+labAndTestIds);
	//get cloned records and share its created CRFAdditionalQuestion
	if(!onStudyIds.isEmpty()) {
		Map<Id, On_Study_Eligibility_Form__c> mapOSE = new Map<Id, On_Study_Eligibility_Form__c>([select Id, OriginalCRF__c, Status__c from On_Study_Eligibility_Form__c where Id IN:onStudyIds and OriginalCRF__c!=null]);
		if(!mapOSE.isEmpty()) {
			SharingManager.shareAdditionalQuestionWithSite(mapOSE.keySet(), 'On_Study_Eligibility_Form__Share');
		}
	}
	
	//get cloned records and share its created CRFAdditionalQuestion
	if(!labAndTestIds.isEmpty()) {
		Map<Id, Lab_and_Test__c> mapLAT = new Map<Id, Lab_and_Test__c>([select Id, OriginalCRF__c, Status__c from Lab_and_Test__c where Id IN:labAndTestIds and OriginalCRF__c!=null]);
		if(!mapLAT.isEmpty()) {
			SharingManager.shareAdditionalQuestionWithSite(mapLAT.keySet(), 'Lab_and_Test__Share');
		}
	}
	
	
}