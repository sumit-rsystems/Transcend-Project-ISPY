trigger MammaPrintBeforeInsert on MammaPrintDetail__c (before insert , before update) {
	if(Trigger.isUpdate){
		for(MammaPrintDetail__c mpd : Trigger.new){
		}
	}
	
		
	Set<Id> ids = new Set<Id>();
	for(MammaPrintDetail__c mpd : Trigger.new){
		ids.add(mpd.TrialPatient__c);
	}
	List<Site_Trial__c> siteTrials = [Select s.Trial__c, s.Site__c, s.Name From Site_Trial__c s];
	Map<CRF__c, String> crfGroupNameMap = new Map<CRF__c, String>();
	List<TrialPatient__c> lstTrialPatient = [Select Site__c, Patient_Id__c,Trial_Id__c From TrialPatient__c where Id IN :ids];
	if(Trigger.isInsert){
		if(Trigger.isInsert){
			List<MammaPrintDetail__c> lstMPD = Trigger.new;
			List<CRF__c> lstCRF = new List<CRF__c>();
			for(MammaPrintDetail__c mpd : lstMPD){
				for(TrialPatient__c tp : lstTrialPatient) {
					if(tp.Id != mpd.TrialPatient__c) continue;
					CRF__c crf = new CRF__c();
					//crf.Name = 'TSD';
					crf.Type__c = 'MammaPrintDetail__c'; 
					crf.Detail__c = 'Details';
					if(mpd.Status__c == null) {
						crf.Status__c = 'Not Completed';	
					} else {
						crf.Status__c = mpd.Status__c;
					}
					if(!lstTrialPatient.isEmpty()){
						crf.Trial__c = lstTrialPatient[0].Trial_Id__c;
					}
					crf.TrialPatient__c = mpd.TrialPatient__c;
					crf.Complete_Date__c = System.today();
					crf.Patient__c = tp.Patient_Id__c;
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
					for(MammaPrintDetail__c mpd : lstMPD){
						if(tp.Patient_Id__c == crf.Patient__c) {
							mpd.CRF__c = crf.Id;
							mpd.Phase__c = 'Screening';
							if(mpd.Status__c == null) {
								mpd.Status__c = 'Not Completed';
							} 
						}
					}
				}
			}
		}
	}
	if(Trigger.isUpdate){
		Set<String> trialPatients = new Set<String>();
		Set<Id> setCrfIds = new Set<Id>();
		for(MammaPrintDetail__c mpd : Trigger.new){
			setCrfIds.add(mpd.CRF__c);
			trialPatients.add(mpd.TrialPatient__c);
		}
		List<CRF__c> lstCrf = [select id,Status__c from CRF__c where id IN : setCrfIds];
		for(MammaPrintDetail__c mpd : Trigger.new){
			for(CRF__c crf : lstCrf){
				if(crf.id == mpd.CRF__c && mpd.Status__c != Trigger.oldMap.get(mpd.id).Status__c){
					crf.Status__c = mpd.Status__c;
				}
			}
		}
		if(!lstCrf.isEmpty()){	
			update lstCrf;
		}
		
		
	}
	/*if(Trigger.isInsert){
		List<Snomed_Code__c> lstSnomed = new List<Snomed_Code__c>();
		List<Code_Master__c> lstSnomedMaster = [select id,Name,Variable_Description__c from Code_Master__c where Name = 'Her2TargetPrint_OS' or Name = 'MP_Risk' or Name = 'MP_Index'];
		for(MammaPrintDetail__c mpd : Trigger.new){
			for(Code_Master__c sm : lstSnomedMaster){
				if(mpd.TargetPrint_Her_2_Status__c != null && mpd.TargetPrint_Her_2_Status__c != ''){
					if(sm.Name == 'Her2TargetPrint_OS'){
						Snomed_Code__c sc = new Snomed_Code__c();
						sc.CRF__c = mpd.CRF__c;
						sc.TrialPatient__c = mpd.TrialPatient__c;
						sc.Name = '48675-3';
						sc.Code_Master__c = sm.Id;
						SnomedCTCode.SnomedWrapper sw = SnomedCTCode.SnomedCode('48675-3', mpd.TargetPrint_Her_2_Status__c);
						sc.Value__c = sw.snomedCodeVal;
						sc.Code_System__c = sw.codeSystem;
						sc.Numeric_Value__c = sw.numericValue;
						lstSnomed.add(sc);
					}
				} 
				if(mpd.MammaPrint_Risk__c != null && mpd.MammaPrint_Risk__c != ''){
					if(sm.Name == 'MP_Risk'){
						Snomed_Code__c sc = new Snomed_Code__c();
						sc.CRF__c = mpd.CRF__c;
						sc.TrialPatient__c = mpd.TrialPatient__c;
						sc.Name = 'IHTSDO_4668';
						sc.Code_Master__c = sm.Id;
						SnomedCTCode.SnomedWrapper sw = SnomedCTCode.SnomedCode('IHTSDO_4668', mpd.MammaPrint_Risk__c);
						sc.Value__c = sw.snomedCodeVal;
						sc.Code_System__c = sw.codeSystem;
						sc.Numeric_Value__c = sw.numericValue;
						lstSnomed.add(sc);
					}
				}
				if(mpd.MammaPrint_Index__c != 0 ){
					if(sm.Name == 'MP_Index'){
						Snomed_Code__c sc = new Snomed_Code__c();
						sc.CRF__c = mpd.CRF__c;
						sc.TrialPatient__c = mpd.TrialPatient__c;
						sc.Name = 'IHTSDO_4669';
						sc.Code_Master__c = sm.Id;
						SnomedCTCode.SnomedWrapper sw = SnomedCTCode.SnomedCode('IHTSDO_4669', mpd.MammaPrint_Index__c+'');
						sc.Value__c = sw.snomedCodeVal;
						sc.Code_System__c = sw.codeSystem;
						sc.Numeric_Value__c = sw.numericValue;
						lstSnomed.add(sc);
					}
				}
				if(mpd.Risk_Category__c != null && mpd.Risk_Category__c != '' ){
					if(sm.Name == 'MP_Cat'){
						Snomed_Code__c sc = new Snomed_Code__c();
						sc.CRF__c = mpd.CRF__c;
						sc.TrialPatient__c = mpd.TrialPatient__c;
						sc.Name = 'IHTSDO_4670_1';
						sc.Code_Master__c = sm.Id;
						SnomedCTCode.SnomedWrapper sw = SnomedCTCode.SnomedCode('IHTSDO_4670_1', mpd.H1_H2_status__c);
						sc.Value__c = sw.snomedCodeVal;
						sc.Code_System__c = sw.codeSystem;
						sc.Numeric_Value__c = sw.numericValue;
						lstSnomed.add(sc);
					}
				}
			}
		}
		if(!lstSnomed.isEmpty()){
			insert lstSnomed;
		}
	}
	if(Trigger.isUpdate){
		set<Id> setIds = new set<Id>();
		for(MammaPrintDetail__c mpd : Trigger.new){
			setIds.add(mpd.CRF__c);
		}
		List<Snomed_Code__c> lstSnomed = [select id,Value__c,CRF__c,Name from Snomed_Code__c where CRF__c IN : setIds];
		for(Snomed_Code__c sc : lstSnomed){
			for(MammaPrintDetail__c mpd : Trigger.new){
				if(mpd.CRF__c == sc.CRF__c){
					if(sc.Name == '48675-3'){
						if(mpd.TargetPrint_Her_2_Status__c != Trigger.oldMap.get(mpd.Id).TargetPrint_Her_2_Status__c){
							SnomedCTCode.SnomedWrapper sw = SnomedCTCode.SnomedCode('48675-3', mpd.TargetPrint_Her_2_Status__c);
							sc.Value__c = sw.snomedCodeVal;
							sc.Code_System__c = sw.codeSystem;
							sc.Numeric_Value__c = sw.numericValue;
						}
					}
					if(sc.Name == 'IHTSDO_4668'){
						if(mpd.MammaPrint_Risk__c != Trigger.oldMap.get(mpd.Id).MammaPrint_Risk__c){
							SnomedCTCode.SnomedWrapper sw = SnomedCTCode.SnomedCode('IHTSDO_4668', mpd.MammaPrint_Risk__c);
							sc.Value__c = sw.snomedCodeVal;
							sc.Code_System__c = sw.codeSystem;
							sc.Numeric_Value__c = sw.numericValue;
						}
					}
					if(sc.Name == 'IHTSDO_4669'){
						if(mpd.MammaPrint_Index__c != Trigger.oldMap.get(mpd.Id).MammaPrint_Index__c){
							SnomedCTCode.SnomedWrapper sw = SnomedCTCode.SnomedCode('IHTSDO_4669', mpd.MammaPrint_Index__c+'');
							sc.Value__c = sw.snomedCodeVal;
							sc.Code_System__c = sw.codeSystem;
							sc.Numeric_Value__c = sw.numericValue;
						}	
					}
					if(sc.Name == 'IHTSDO_4670_1'){
						if(mpd.Risk_Category__c != Trigger.oldMap.get(mpd.Id).Risk_Category__c){
							SnomedCTCode.SnomedWrapper sw = SnomedCTCode.SnomedCode('IHTSDO_4670_1', mpd.H1_H2_status__c);
							sc.Value__c = sw.snomedCodeVal;
							sc.Code_System__c = sw.codeSystem;
							sc.Numeric_Value__c = sw.numericValue;
						}	
					}
					
				}
			}
		}
		if(!lstSnomed.isEmpty()){
			update lstSnomed;
		}
	}*/
}