trigger ArmPatientOnAfter on ArmPatient__c (after insert) {
	Set<Id> armIds = new Set<Id>();
	Set<Id> trialPatIds = new Set<Id>();
	for(ArmPatient__c ap : Trigger.new) {
		trialPatIds.add(ap.TrialPatient__c);
		armIds.add(ap.Arm_Id__c);
	}
	List<Arm__c> lstArm = [select Id, a.Trial_Id__c, a.Site_Id__c, a.Name, a.LastModifiedDate, a.Generic_Name__c, a.Description__c, a.CreatedDate from Arm__c a where Id IN :armIds];
	List<TrialPatient__c> lstTrialPatient = [select t.Trial_Id__c, t.Subject_Id__c, t.Stage__c, t.Site__c, t.Patient_Id__c, t.Name, t.Medical_Record_Number__c, t.LastName__c, t.LastModifiedDate, t.IsRandomized__c, t.Institution__c, t.Id, t.FirstName__c, t.CreatedDate From TrialPatient__c t where Id IN :trialPatIds];
	if(!lstArm.isEmpty() && !lstTrialPatient.isEmpty()) {
		ScheduleManager.generateSchedule(lstArm[0], lstTrialPatient[0]);
	}
}