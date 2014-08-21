trigger SetAeIdBeforeInsert on Toxicity__c (before insert) {
	
//=====Start logic for set AE Ids=======================================	
	Map<String, List<Toxicity__c>> patientToxicities = new Map<String, List<Toxicity__c>>();
	
	Set<Id> aeIds = new Set<Id>();
	Set<Id> baseIds = new Set<Id>();
	for(Toxicity__c t : trigger.new) {
		if(t.AE_Detail__c != null) {
			aeIds.add(t.AE_Detail__c);
		} else if(t.Baseline_Symptoms_Form__c != null) {
			baseIds.add(t.Baseline_Symptoms_Form__c);
		}
	}
	
	List<AE_Detail__c> aePatients = [Select a.TrialPatient__c From AE_Detail__c a where Id in :aeIds];
	List<BaselineSymptomsForm__c> basePatients = [Select b.TrialPatient__c From BaselineSymptomsForm__c b where id in :baseIds];
	
	Set<Id> trialPatientIds = new Set<Id>();
	for(Toxicity__c t : trigger.new) {
		for(AE_Detail__c aed : aePatients) {
			if(t.AE_Detail__c == aed.Id) {
				t.TrialPatient__c = aed.TrialPatient__c;
				trialPatientIds.add(aed.TrialPatient__c);
			}
		}
	}
	
	for(Toxicity__c t : trigger.new) {
		for(BaselineSymptomsForm__c aed : basePatients) {
			if(t.Baseline_Symptoms_Form__c == aed.Id) {
				t.TrialPatient__c = aed.TrialPatient__c;
				trialPatientIds.add(aed.TrialPatient__c);
			}
		}
	}
	
	List<TrialPatient__c> trialPatientsWithToxicties = [Select t.Id, (Select Id From Toxicities__r) From TrialPatient__c t where t.Id in :trialPatientIds];
	Map<Id,Decimal> tpAEs = new Map<Id, Decimal>();
	for(TrialPatient__c trialPatObj : trialPatientsWithToxicties) {
		tpAEs.put(trialPatObj.id, trialPatObj.Toxicities__r.size());
		for(Toxicity__c t : trigger.new) {
			if(t.Attribution__c != '0 - Baseline' && t.TrialPatient__c == trialPatObj.id) {
				t.AE_ID__c = tpAEs.get(trialPatObj.id) + 1;
				tpAEs.put(trialPatObj.id, t.AE_ID__c);
			}
		}
	}
//=====End logic for set AE Ids=======================================
//=====Start logic change Name if it is more than 80 characters=======================================
	set<Id> toxiMasterIds = new set<Id>();
	for(Toxicity__c t : trigger.new) {
		toxiMasterIds.add(t.Toxicity_Master__c);
	}
	List<Toxicity_Master__c> lstToxMater = [select Id, Toxicity_Name__c from Toxicity_Master__c where Id IN:toxiMasterIds];
	for(Toxicity__c t : trigger.new) {
		for(Toxicity_Master__c TM : lstToxMater) {
			if(t.Toxicity_Master__c != TM.Id) continue;
			if(TM.Toxicity_Name__c.length() > 80) {
				t.Name = TM.Toxicity_Name__c.substring(0,77)+'...';
			} else {
				t.Name = TM.Toxicity_Name__c;
			}
		}
	}
//=====End logic change Name if it is more than 80 characters=======================================
}