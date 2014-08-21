trigger TissueSpecimeFormTrigger on TissueSpecimenDetail__c (before insert, before update) {
	if(Trigger.isInsert){
		List<TissueSpecimenDetail__c> lstTSD = Trigger.new;
		List<CRF__c> lstCRF = new List<CRF__c>();
		Set<Id> ids = new Set<Id>();
		for(TissueSpecimenDetail__c tsd : lstTSD){
			ids.add(tsd.TrialPatient__c);
		}
		system.debug('ids : '+ids);
		List<Site_Trial__c> siteTrials = [Select s.Trial__c, s.Site__c, s.Name From Site_Trial__c s];
		Map<CRF__c, String> crfGroupNameMap = new Map<CRF__c, String>();
	
		List<TrialPatient__c> lstTrialPatient = [Select Site__c, t.Patient_Id__c,Trial_Id__c From TrialPatient__c t where Id IN :ids];
		system.debug('lstTrialPatient : '+lstTrialPatient);
		for(TissueSpecimenDetail__c tsd : lstTSD){
			for(TrialPatient__c tp : lstTrialPatient) {
				if(tp.Id == tsd.TrialPatient__c) {
					CRF__c crf = new CRF__c();
					//crf.Name = 'TSD';
					crf.Type__c = 'TissueSpecimenDetail__c'; 
					crf.Detail__c = 'Details';
					if(tsd.Status__c == null) {
						crf.Status__c = 'Not Completed';
					} else {
						crf.Status__c = tsd.Status__c;
					}
					crf.Patient__c = tp.Patient_Id__c;
					crf.Trial__c = tp.Trial_Id__c;
					crf.TrialPatient__c = tsd.TrialPatient__c;
					lstCRF.add(crf);
					for(Site_Trial__c st : siteTrials) {
	                	if(st.Trial__c == tp.Trial_Id__c && st.Site__c == tp.Site__c) {
	                		crfGroupNameMap.put(crf, st.Name);
	                		break;
	                	}
	                }
				}
			}
		}
		if(lstCRF != null && lstCRF.size() > 0) {
			insert lstCRF;
		}
		system.debug('lstCRF : '+lstCRF);
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
				for(TissueSpecimenDetail__c tsd : lstTSD){
					if(tp.Patient_Id__c == crf.Patient__c) {
						system.debug('RequiredFieldHandler.fromDataLoader : '+RequiredFieldHandler.fromDataLoader);
						system.debug('tsd.ProcedureDate__c : '+tsd.ProcedureDate__c);
						if(!RequiredFieldHandler.fromDataLoader) {
							if(tsd.ProcedureDate__c == null) {
								throw new RequiredFieldException('Required field missing - Please provide procedure Date.');
							} else if(tsd.Time_Point__c == null || tsd.Time_Point__c == '') {
								throw new RequiredFieldException('Required field missing - Please provide time point.');
							}
						}
						if(tsd.Status__c == null) {
							tsd.Status__c = 'Not Completed';
						}
						tsd.CRFId__c = crf.Id;
					}
				}
			}
		}
	}
	if(Trigger.isUpdate){
		for(TissueSpecimenDetail__c tsd : Trigger.new){
		}
		set<Id> setCrfIds = new set<Id>();
		Set<Id> tsIds = new Set<Id>();
		for(TissueSpecimenDetail__c tsd : Trigger.new){
			setCrfIds.add(tsd.CRFId__c);
		}
		List<CRF__c> lstCrf = [select id,Status__c from CRF__c where id IN : setCrfIds];
		for(TissueSpecimenDetail__c tsd : Trigger.new){
			for(CRF__c crf : lstCrf){
				if(crf.id == tsd.CRFId__c && tsd.Status__c != Trigger.oldMap.get(tsd.id).Status__c){
					crf.Status__c = tsd.Status__c;
					crf.Complete_Date__c = tsd.CompletedDate__c;
				}
			}
			if(tsd.Status__c == 'Approval Not Required' && tsd.Time_Point__c == 'Pre-Treatment') {
				tsIds.add(tsd.Id);
			}
		}
		if(!lstCrf.isEmpty()){	
			update lstCrf;
		}
		/*commented to get characters for other coding
		if(!tsIds.isEmpty()) {
			TaskManager.createTaskAfterTissueSpecimenApproval(tsIds);
		}
		*/
	}
	
}