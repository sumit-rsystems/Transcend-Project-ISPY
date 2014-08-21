trigger InsertCRFonNolongerLosttoFollowup on No_Longer_lost_to_Followup__c (before insert, before update) {
	
	Set<Id> ids = new Set<Id>();
	for(No_Longer_lost_to_Followup__c os : Trigger.new){
		ids.add(os.TrialPatient__c);
	}
	 
	if(Trigger.isInsert) {
		List<Site_Trial__c> siteTrials = [Select s.Trial__c, s.Site__c, s.Name From Site_Trial__c s];
		Map<CRF__c, String> crfGroupNameMap = new Map<CRF__c, String>();
		
		List<TrialPatient__c> trialPatientList = [select Id, Site__c, Patient_Id__c,Trial_Id__c from TrialPatient__c where Id IN :ids];
		List<CRF__c> lstCRF = new List<CRF__c>();
		for(No_Longer_lost_to_Followup__c os : Trigger.new){
			for(TrialPatient__c tmpListObj : trialPatientList) {
				if(os.TrialPatient__c == tmpListObj.Id) {
					CRF__c crfObj = new CRF__c();
					crfObj.Patient__c = tmpListObj.Patient_Id__c; 
					crfObj.Type__c = 'No Longer Lost to Followup Form';
					if(os.Status__c != null) {
						crfObj.Status__c = os.Status__c;
					} else {
						crfObj.Status__c = 'Not Completed';
					}
					crfObj.Trial__c = tmpListObj.Trial_Id__c;
					crfObj.TrialPatient__c = os.TrialPatient__c;
					crfObj.Complete_Date__c = System.today();
					crfObj.Type__c = 'No_Longer_lost_to_Followup__c';
					crfObj.Phase__c = 'Followup';
					lstCRF.add(crfObj); 
					for(Site_Trial__c st : siteTrials) {
	                	if(st.Trial__c == tmpListObj.Trial_Id__c && st.Site__c == tmpListObj.Site__c) {
	                		crfGroupNameMap.put(crfObj, st.Name);
	                		break;
	                	}
	                }
				}
			}
		}
		if(!lstCRF.isEmpty()){
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
		
		for(No_Longer_lost_to_Followup__c os : Trigger.new){
			for(TrialPatient__c tmpListObj : trialPatientList) {
				for(CRF__c crfObj : lstCRF){
					if(crfObj.Patient__c == tmpListObj.Patient_Id__c){
						System.debug('--------------->');
						os.CRF__c = crfObj.Id;
						if(os.Status__c == null) {
							os.Status__c = 'Not Completed';			
						}
					}
				}
			}
		}
	}
	
	if(Trigger.isUpdate){
		set<Id> setCrfIds = new set<Id>();
		for(No_Longer_lost_to_Followup__c os : Trigger.new){
			setCrfIds.add(os.CRF__c);
		}
		List<CRF__c> lstCrf = [select id,Status__c from CRF__c where id IN : setCrfIds];
		for(No_Longer_lost_to_Followup__c os : Trigger.new){
			for(CRF__c crf : lstCrf){
				if(crf.id == os.CRF__c && os.Status__c != Trigger.oldMap.get(os.id).Status__c){
					crf.Status__c = os.Status__c;
				}
			}
		}
		if(!lstCrf.isEmpty()){	
			update lstCrf;
		}
	}
	

}