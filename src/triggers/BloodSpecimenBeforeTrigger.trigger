trigger BloodSpecimenBeforeTrigger on BloodSpecimenForm__c (before insert, before update) {
	if(Trigger.isInsert){
		List<BloodSpecimenForm__c> lstBloodSpecimen = Trigger.new;
		List<CRF__c> lstCRF = new List<CRF__c>();
		Set<Id> ids = new Set<Id>();
		for(BloodSpecimenForm__c bloodSpecimen : lstBloodSpecimen){
			ids.add(bloodSpecimen.TrialPatient__c);
		}
		
		List<Site_Trial__c> siteTrials = [Select s.Trial__c, s.Site__c, s.Name From Site_Trial__c s];
		Map<CRF__c, String> crfGroupNameMap = new Map<CRF__c, String>();
		
		List<TrialPatient__c> lstTrialPatient = [Select id, Patient_Id__c, Site__c, Trial_Id__c From TrialPatient__c where Id IN :ids];
		
		for(BloodSpecimenForm__c bloodSpecimen : lstBloodSpecimen){
			for(TrialPatient__c tp : lstTrialPatient) {
				if(tp.Id != bloodSpecimen.TrialPatient__c) continue;
				CRF__c crf = new CRF__c();
				//crf.Name = 'TSD';
				crf.Detail__c = 'Details';
				if(bloodSpecimen.Status__c == null) {
					crf.Status__c = 'Not Completed';	
				} else {
					crf.Status__c = bloodSpecimen.Status__c;
				}
				if(!lstTrialPatient.isEmpty()){
					crf.Trial__c = lstTrialPatient[0].Trial_Id__c;
				}
				crf.TrialPatient__c = bloodSpecimen.TrialPatient__c;
				crf.Complete_Date__c = System.today();
				crf.Patient__c = tp.Patient_Id__c;
				crf.Type__c = 'BloodSpecimenForm__c';
				crf.Phase__c = 'Screening';
				lstCRF.add(crf);
				for(Site_Trial__c st : siteTrials) {
                	if(st.Trial__c == tp.Trial_Id__c && st.Site__c == tp.Site__c) {
                		crfGroupNameMap.put(crf, st.Name);
                		break;
                	}
                }
			}
			
		}
		
		if(lstCRF != null && lstCRF.size() > 0) {
			insert lstCRF;
		}
		List<Group> gList = [Select g.Name, g.Id From Group g where name in :crfGroupNameMap.values()];
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
		
		for(CRF__c crf : lstCRF) {
			for(TrialPatient__c tp : lstTrialPatient) {
				for(BloodSpecimenForm__c bloodSpecimen : lstBloodSpecimen){
					if(tp.Patient_Id__c == crf.Patient__c) {
						if(bloodSpecimen.Status__c == null) {
							bloodSpecimen.Status__c = 'Not Completed';	
						} 
						bloodSpecimen.CRF__c = crf.Id;
					}
				}
			}
		}
	}
	if(Trigger.isUpdate){
		set<Id> setCrfIds = new set<Id>();
		for(BloodSpecimenForm__c bloodSpecimen : Trigger.new){
			setCrfIds.add(bloodSpecimen.CRF__c);
		}
		List<CRF__c> lstCrf = [select id,Status__c from CRF__c where id IN : setCrfIds];
		for(BloodSpecimenForm__c bloodSpecimen : Trigger.new){
			for(CRF__c crf : lstCrf){
				if(crf.id == bloodSpecimen.CRF__c && bloodSpecimen.Status__c != Trigger.oldMap.get(bloodSpecimen.id).Status__c){
					crf.Status__c = bloodSpecimen.Status__c;
				}
			}
		}
		if(!lstCrf.isEmpty()){	
			update lstCrf;
		}
	}
}