trigger RadiationSiteAfterInsertUpdate on Irradiated_Site__c (after insert, after update) {

	/*
	//commented because logic changed this method will called from its parent's future method
	if(Trigger.isUpdate) {
		Set<Id> ffIds = new Set<Id>();
		for(Irradiated_Site__c site: Trigger.new) {
			ffIds.add(site.Followup_Form__c);
		}
		List<Followup_Form__c> ffList = [Select Id, CRF__c, (Select i.Total_dose_cGy_AP__c, i.Total_FX__c, i.TotalFX__c, i.Site__c, i.Name, i.Followup_Form__c, i.Followup_Form__r.CRF__C, i.Dose_per_FX_cGy__c From Irradiated_Sites__r i) From Followup_Form__c where id in :ffIds];
		Set<Id> crfIds = new Set<Id>();
		for(Followup_Form__c ff : ffList) {
			crfIds.add(ff.CRF__c);
		}
			
		List<Snomed_Code__c> lstSnomed = [Select Id from Snomed_Code__c where CRF__C in :crfIds  and (snomed_Code_Name__c = '428923005 | radiotherapy to breast | ' 
								or snomed_Code_Name__c = 'IHTSDO_4584_1' or snomed_Code_Name__c = 'IHTSDO_4584_5' or snomed_Code_Name__c = 'IHTSDO_4584_4' 
								or snomed_Code_Name__c = 'IHTSDO_4584_3' or snomed_Code_Name__c = 'IHTSDO_4584_2' or snomed_Code_Name__c = 'IHTSDO_4586')];
		if(!lstSnomed.isEmpty()) {
			delete lstSnomed; 
		}
	}
	SnomedCTCode.insertSnomedCodesForRadiationTherapy(Trigger.newMap.keySet());*/
}