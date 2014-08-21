trigger TempTrialPatient on Temp_Trial_Patient__c (before insert) {

	caIntegratorDataTransmissionController cdt = new caIntegratorDataTransmissionController();
	cdt.generateCaIntegratorDataForPatient(Trigger.new[0].Name);
}