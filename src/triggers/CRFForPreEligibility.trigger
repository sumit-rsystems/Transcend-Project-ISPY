trigger CRFForPreEligibility on PreEligibility_Checklist__c (before insert, before update) {
		if(Trigger.isInsert){
		Set<id> patientIdset = new Set<id>();
		for(PreEligibility_Checklist__c pre : Trigger.new){
			patientIdset.add(pre.Patient__c);
		}
		Map<id,string> patientIdGroupNameMap = new Map<id,string>(); 
		if(!patientIdset.isEmpty()){
			List<Patient_Custom__c> patientList = [Select p.Institution__r.Inst_Group__c, p.Institution__c From Patient_Custom__c p where id IN :patientIdset];
			if(!patientList.isEmpty()){
				for(Patient_Custom__c p : patientList){
					if(p.Institution__c == null || p.Institution__r.Inst_Group__c == null)continue;
					patientIdGroupNameMap.put(p.id,p.Institution__r.Inst_Group__c);
				}
			}			
		}
		
		Map<CRF__c, String> crfGroupNameMap = new Map<CRF__c, String>();
		
		List<CRF__c> lstCRF = new List<CRF__c>();
		for(PreEligibility_Checklist__c pre : Trigger.new){
			if(pre.Patient__c != null){
				CRF__c c = new CRF__c();
				c.Patient__c = pre.Patient__c; 
				//c.Type__c = 'MSD';
				//c.Detail__c = 'MSD';
				c.Complete_Date__c = System.today();
				c.Status__c = pre.Status__c; 
				c.Type__c = 'PreEligibility_Checklist__c';
				c.Phase__c = 'Screening';
				lstCRF.add(c);
				if(pre.Patient__c != null && patientIdGroupNameMap.get(pre.Patient__c) != null ){
					System.debug('patientIdGroupNameMap---------'+patientIdGroupNameMap.get(pre.Patient__c));
					crfGroupNameMap.put(c,patientIdGroupNameMap.get(pre.Patient__c));
				}
			}
		}
		if(!lstCRF.isEmpty()){
			insert lstCRF;
		}
		
		List<Group> gList = [Select g.Name, g.Id From Group g where name in :crfGroupNameMap.values() and Type = 'Regular'];
        Map<String, Id> gNameIdMap = new Map<String, Id>();
        for(Group g :gList) {
        	gNameIdMap.put(g.Name, g.Id);
        }
        List<CRF__Share> lstCRFShare = new List<CRF__Share>();
		for(CRF__c crf : lstCRF){
			CRF__Share shareRec = new CRF__Share();
			System.debug('crfGroupNameMap.get(crf)---------'+crfGroupNameMap.get(crf));
			if(crfGroupNameMap.get(crf) != null && gNameIdMap.get(crfGroupNameMap.get(crf)) != null){
				shareRec.UserOrGroupId = gNameIdMap.get(crfGroupNameMap.get(crf));
				shareRec.AccessLevel = 'Edit';
				shareRec.ParentId =  crf.Id;
				lstCRFShare.add(shareRec);
			}
		}
		insert lstCRFShare;
		
		for(PreEligibility_Checklist__c pre : Trigger.new){
			for(CRF__c c : lstCRF){
				if(c.Patient__c == pre.Patient__c){
					System.debug('--------------->');
					pre.CRF_Id__c = c.Id;
					if(pre.Status__c == null) {	
						pre.Status__c = 'Not Completed';
					}
					pre.Phase__c = 'Screening';	
				}
			}
		}
	}
	if(Trigger.isUpdate){
		set<Id> setCrfIds = new set<Id>();
		for(PreEligibility_Checklist__c pre : Trigger.new){
			setCrfIds.add(pre.CRF_Id__c);
		}
		List<CRF__c> lstCrf = [select id,Status__c from CRF__c where id IN : setCrfIds];
		for(PreEligibility_Checklist__c pre : Trigger.new){
			for(CRF__c crf : lstCrf){
				if(crf.id == pre.CRF_Id__c && pre.Status__c != Trigger.oldMap.get(pre.id).Status__c){
					crf.Status__c = pre.Status__c;
				}
			}
		}
		update lstCrf;
	}
	
	//create Trial Patient
	//Handled for both Insert and Update events
	Set<Id> patientIdset = new Set<Id>();
	Set<Id> tpIdset = new Set<Id>();
	for(PreEligibility_Checklist__c pre : Trigger.new){
		patientIdset.add(pre.Patient__c);
		if(pre.TrialPatient__c != null) {
			tpIdset.add(pre.TrialPatient__c);
		}
	}
	
	Map<Id, Patient_Custom__c> mapPatient = new Map<Id, Patient_Custom__c>([select Id, Name, First_Name__c, Last_Name__c from Patient_Custom__c where Id IN:patientIdset]);
	Map<Id, TrialPatient__c> mapTrialPatient = new Map<Id, TrialPatient__c>([select Id, Site__c from TrialPatient__c where Id IN:tpIdset]);
	
	List<TrialPatient__c> lstInsertTP = new List<TrialPatient__c>();
	List<TrialPatient__c> lstUpdateTP = new List<TrialPatient__c>();
	for(PreEligibility_Checklist__c pre : Trigger.new){
		if(pre.Site__c == null) continue;
		system.debug('pre.Site__c: '+pre.Site__c);
		if(pre.TrialPatient__c == null) {
			TrialPatient__c trialPatient = new TrialPatient__c();
			trialPatient.Patient_Id__c = pre.Patient__c;
			trialPatient.Trial_Id__c = pre.Trial__c;
		    trialPatient.Site__c = pre.Site__c;
		    trialPatient.Name = mapPatient.get(pre.Patient__c).Name;
		    trialPatient.FirstName__c = mapPatient.get(pre.Patient__c).First_Name__c;
		    trialPatient.LastName__c = mapPatient.get(pre.Patient__c).Last_Name__c;
		    lstInsertTP.add(trialPatient);
		} else if(Trigger.isUpdate && pre.Site__c != Trigger.oldMap.get(pre.Id).Site__c) {
			TrialPatient__c trialPatient = mapTrialPatient.get(pre.TrialPatient__c);
			trialPatient.Site__c = pre.Site__c;
			lstUpdateTP.add(trialPatient);
		}
		
	}
	
	if(!lstInsertTP.isEmpty()) {
		insert lstInsertTP;
	}
	
	if(!lstUpdateTP.isEmpty()) {
		update lstUpdateTP;
	}
	
	for(PreEligibility_Checklist__c pre : Trigger.new){
		for(TrialPatient__c tp : lstInsertTP){
			if(tp.Patient_Id__c != pre.Patient__c) continue;
			pre.TrialPatient__c = tp.Id;
		}
	}
	
}