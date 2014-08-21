trigger RandomizationDeleteTrigger on Randomization_Form__c (before delete) {
	if(Trigger.isBefore) {
		Set<Id> tpIds = new Set<Id>();
		List<Randomization_Form__c> lstRandomizationForm = Trigger.old;
		for(Randomization_Form__c rForm : lstRandomizationForm) {
			tpIds.add(rForm.TrialPatient__c);
		}
		
		delete [select Id from TrialPatientXML__c where TrialPatientId__c IN :tpIds];
		delete [select Id from ArmPatient__c where TrialPatient__c IN :tpIds];
	}
}