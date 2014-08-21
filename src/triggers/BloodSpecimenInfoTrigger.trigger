trigger BloodSpecimenInfoTrigger on BloodSpecimenInfo__c (before insert, before update) {
	
	List<BloodSpecimenInfo__c> lstBloodSpecimenInfo = Trigger.new;
	
	Set<Id> bloodSpecimenIds = new Set<Id>();
	for(BloodSpecimenInfo__c bsi : Trigger.new) {
		bloodSpecimenIds.add(bsi.BloodSpecimenForm__c);
	}
	
	Map<Id, BloodSpecimenForm__c> mapBSF = new Map<Id, BloodSpecimenForm__c>([select Id, Status__c, Time_Point__c, TrialPatient__c, TrialPatient__r.Subject_Id__c from BloodSpecimenForm__c where Id IN :bloodSpecimenIds]);
	if(!mapBSF.isEmpty()){
		for(BloodSpecimenInfo__c bsi : lstBloodSpecimenInfo) {
			if(bsi.BloodSpecimenForm__c == null)continue;
		}
	}
		
	for(BloodSpecimenInfo__c bsi : lstBloodSpecimenInfo) {
		if(bsi.Shipped__c != null) {
			if(mapBSF.get(bsi.BloodSpecimenForm__c) == null) continue;
			if(bsi.Name.contains('Serum Specimen #')) {
				bsi.Specimen_ID__c = BloodSpecimenController.calculateSID(bsi.Name.substring(bsi.Name.length() - 1, bsi.Name.length()), 'Serum', mapBSF.get(bsi.BloodSpecimenForm__c).Time_Point__c, mapBSF.get(bsi.BloodSpecimenForm__c).TrialPatient__r.Subject_Id__c);
			}
			if(bsi.Name.contains('Plasma Specimen #')) {
				bsi.Specimen_ID__c = BloodSpecimenController.calculateSID(bsi.Name.substring(bsi.Name.length() - 1, bsi.Name.length()), 'Plasma', mapBSF.get(bsi.BloodSpecimenForm__c).Time_Point__c, mapBSF.get(bsi.BloodSpecimenForm__c).TrialPatient__r.Subject_Id__c);
			}
			if(bsi.Name.contains('Buffy coat specimen #')) {
				bsi.Specimen_ID__c = BloodSpecimenController.calculateSID(bsi.Name.substring(bsi.Name.length() - 1, bsi.Name.length()), 'Buffy coat', mapBSF.get(bsi.BloodSpecimenForm__c).Time_Point__c, mapBSF.get(bsi.BloodSpecimenForm__c).TrialPatient__r.Subject_Id__c);
			}
		} else {
			bsi.Specimen_ID__c = '';
		}
	}
}