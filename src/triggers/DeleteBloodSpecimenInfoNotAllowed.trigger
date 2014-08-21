trigger DeleteBloodSpecimenInfoNotAllowed on BloodSpecimenInfo__c (before delete) {
	List<BloodSpecimenInfo__c> lstBloodSpecimenInfo = Trigger.old;
	
	Set<Id> bloodSpecimenIds = new Set<Id>();
	for(BloodSpecimenInfo__c bsi : Trigger.old) {
		bloodSpecimenIds.add(bsi.BloodSpecimenForm__c);
	}
	
	Map<Id, BloodSpecimenForm__c> mapBSF = new Map<Id, BloodSpecimenForm__c>([select Id, Status__c, Time_Point__c, TrialPatient__c, TrialPatient__r.Subject_Id__c from BloodSpecimenForm__c where Id IN :bloodSpecimenIds]);
	if(!mapBSF.isEmpty()){
		for(BloodSpecimenInfo__c bsi : lstBloodSpecimenInfo) {
			if(bsi.BloodSpecimenForm__c == null)continue;
		}
	}
}