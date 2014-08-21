trigger CRFRecCreationOnMenopausalStatusDetail on Menopausal_Status_Detail__c (before insert, before update) {
	
	List<Trigger_Execute_Setting__c> sList = [Select Event__c, Execute__c from Trigger_Execute_Setting__c where Trigger_Name__c = 'CRFRecCreationOnMenopausalStatusDetail'];
	if(!sList.isEmpty()) {
		boolean executeCode = false;
		for(Trigger_Execute_Setting__c ts : sList) {
			if(ts.Execute__c) {
				executeCode = true;
				break;
			}
		}
		if(!executeCode)return;
	}
	
	set<Id> msdId = new set<Id>();
	for(Menopausal_Status_Detail__c msd : Trigger.new){
		msdId.add(msd.TrialPatient__c);
	}
	List<Site_Trial__c> siteTrials = [Select s.Trial__c, s.Site__c, s.Name From Site_Trial__c s];
	Map<CRF__c, String> crfGroupNameMap = new Map<CRF__c, String>();
	
	List<TrialPatient__c> lstTrialPat1 = [select id,Patient_Id__r.Age__c,Site__c,Trial_Id__c from TrialPatient__c where Id IN : msdId];
	
	if(Trigger.isInsert){
		System.debug('--status-->');
		List<CRF__c> lstCRF = new List<CRF__c>();
		for(Menopausal_Status_Detail__c msd : Trigger.new){
			for(TrialPatient__c triPat : lstTrialPat1){
				CRF__c c = new CRF__c();
				if(triPat.Patient_Id__c != null){
					c.Patient__c = triPat.Patient_Id__c; 
				}
				if(!lstTrialPat1.isEmpty()){	
					c.Trial__c = lstTrialPat1[0].Trial_Id__c;
				}
				c.TrialPatient__c = msd.TrialPatient__c;
				c.Complete_Date__c = System.today();
				if(msd.Status__c == null) {
					c.Status__c = 'Not Completed';
				} else {
					c.Status__c = msd.Status__c;
				}
				c.Type__c = 'Menopausal_Status_Detail__c';
				c.Phase__c = 'Screening';
				lstCRF.add(c);
				for(Site_Trial__c st : siteTrials) {
                	if(st.Trial__c == triPat.Trial_Id__c && st.Site__c == triPat.Site__c) {
                		crfGroupNameMap.put(c, st.Name);
                		break;
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
		
		for(Menopausal_Status_Detail__c msd : Trigger.new){
			for(TrialPatient__c triPat : lstTrialPat1){
				for(CRF__c c : lstCRF){
					if(c.Patient__c == triPat.Patient_Id__c){
						System.debug('--------------->');
						if(!RequiredFieldHandler.fromDataLoader) {
							if(msd.Menopausal_Status__c == null || msd.Menopausal_Status__c == '') {
								throw new RequiredFieldException('Required field missing - Please provide Menopausal Status.');
							} 
						}
						msd.CRF_Id__c = c.Id;
						msd.Phase__c = 'Screening';
						if(msd.Status__c == null) {
							msd.Status__c = 'Not Completed';
						}
					}
				}
			}
		}
	}
	if(Trigger.isUpdate){
		set<Id> setCrfIds = new set<Id>();
		for(Menopausal_Status_Detail__c msd : Trigger.new){
			setCrfIds.add(msd.CRF_Id__c);
		}
		List<CRF__c> lstCrf = [select id,Status__c from CRF__c where id IN : setCrfIds];
		for(Menopausal_Status_Detail__c msd : Trigger.new){
			for(CRF__c crf : lstCrf){
				if(crf.id == msd.CRF_Id__c && msd.Status__c != Trigger.oldMap.get(msd.id).Status__c){
					crf.Status__c = msd.Status__c;
				}
			}
		}
		update lstCrf;
		set<Id> patIds = new set<Id>();
		set<Id> trialIds = new set<Id>();
		set<Id> patTrialIds = new set<Id>();
		set<String> trialPatients = new set<String>();
		for(Menopausal_Status_Detail__c msd : Trigger.new){
			patTrialIds.add(msd.TrialPatient__c);
			trialPatients.add(msd.TrialPatient__c);
		}
		List<TrialPatient__c> lstTrialPat = [select id,Patient_Id__c,Site__c,Trial_Id__c from TrialPatient__c where Id = : patTrialIds];
		for(TrialPatient__c triPat : lstTrialPat){
			patIds.add(triPat.Patient_Id__c);
			trialIds.add(triPat.Trial_Id__c);
		}
		List<Patient_Custom__c> lstPat = [select id,Institution__c from Patient_Custom__c where Id IN : patIds];
		set<Id> InstIds = new set<Id>();
		for(Patient_Custom__c pat : lstPat){
			InstIds.add(pat.Institution__c);
		}
		set<String> lstDccNames = new set<String>();
		set<Id> lstInstIds = new set<Id>();
		set<Id> setTrial = new set<Id>();
		set<Id> setSite = new set<Id>();
		set<String> setGrpNames = new set<String>();
		List<InstitutionTrialDcc__c> lstInsDcc = [select id,DCC_Id__c,DCC_Id__r.Name,Institution_Id__c,Trial_Id__c from InstitutionTrialDcc__c where Institution_Id__c IN : InstIds and Trial_Id__c IN : trialIds];
		for(InstitutionTrialDcc__c insTriDcc : lstInsDcc){
			lstDccNames.add(insTriDcc.DCC_Id__r.Name);
			lstInstIds.add(insTriDcc.Institution_Id__c);
		}
		List<InstitutionUser__c> lstInstUser = [select id,Institution__c,Site__c,Trial__c,User__c from InstitutionUser__c where Institution__c IN :lstInstIds and Trial__c IN : trialIds];
		for(InstitutionUser__c tr : lstInstUser){
			setTrial.add(tr.Trial__c);
			setSite.add(tr.Site__c);
		}
		List<RecordType> lstRecordType = Database.query('select Id, Name from RecordType where sObjectType = \'Site__c\' and Name = \'Site\'');
		List<Site_Trial__c> lstSiteTrial = new List<Site_Trial__c>();
		if(!lstRecordType.isEmpty()){
			lstSiteTrial = [select id,Site__c,Trial__c,Name from Site_Trial__c where Trial__c IN : setTrial and Site__c IN : setSite and Site__r.RecordTypeId = :lstRecordType[0].Id];
		}
		for(Site_Trial__c st : lstSiteTrial){
			setGrpNames.add(st.Name);
		}
		List<Group> lstSiteGrp = [select Id,Name,Type from Group where Name IN : setGrpNames and Type = 'Regular'];
		List<Menopausal_Status_Detail__Share> lstMsdShareSite = new List<Menopausal_Status_Detail__Share>();
		for(Menopausal_Status_Detail__c msd : Trigger.new){
			for(InstitutionTrialDcc__c instDcc : lstInsDcc){
				for(InstitutionUser__c insUser : lstInstUser){
					for(Site_Trial__c st : lstSiteTrial){
						for(Group grp : lstSiteGrp){
							if(grp.Name == st.Name && st.Trial__c == insUser.Trial__c && st.Site__c == insUser.Site__c && instDcc.Institution_Id__c == insUser.Institution__c){
								Menopausal_Status_Detail__Share msdShare = new Menopausal_Status_Detail__Share();
								msdShare.AccessLevel = 'Edit';
								msdShare.UserOrGroupId = grp.Id;
								msdShare.ParentId = msd.Id;
								lstMsdShareSite.add(msdShare);
							}
						}
					}
				}
			}
		}
		if(!lstMsdShareSite.isEmpty()){
			insert lstMsdShareSite;
		}
		List<RecordType> lstRecType = [Select r.SobjectType, r.Name, r.Id From RecordType r where r.SobjectType = 'Menopausal_Status_Detail__c' and r.Name = 'Approval Pending'];
		List<Group> lstGrp = [select Id,Name,Type from Group where Name IN : lstDccNames and Type = 'Regular'];
		List<Menopausal_Status_Detail__Share> lstMsdShare = new List<Menopausal_Status_Detail__Share>();
		for(Menopausal_Status_Detail__c msd : Trigger.new){
			if(msd.RecordTypeId != lstRecType[0].Id)continue;
			for(TrialPatient__c triPat : lstTrialPat){
				if(msd.TrialPatient__c == triPat.Id){
					for(Patient_Custom__c pat : lstPat){
						if(pat.Id == triPat.Patient_Id__c){
							for(InstitutionTrialDcc__c insTriDcc : lstInsDcc){
								if(pat.Institution__c == insTriDcc.Institution_Id__c && insTriDcc.Trial_Id__c == triPat.Trial_Id__c){
									for(Group grp : lstGrp){
										if(grp.Name == insTriDcc.DCC_Id__r.Name){
											Menopausal_Status_Detail__Share msdShare = new Menopausal_Status_Detail__Share();
											msdShare.AccessLevel = 'Read';
											msdShare.UserOrGroupId = grp.Id;
											msdShare.ParentId = msd.Id;
											lstMsdShare.add(msdShare);
										}
									}
								}
							}
						}
					}
				}
			}
		}
		if(!lstMsdShare.isEmpty()){
			insert lstMsdShare;
		}
	}
	for(Menopausal_Status_Detail__c msd : Trigger.new){
		if(msd.Menopausal_Status__c == null) {
			Datetime crfCreationDate = msd.Effective_Time__c != null ? msd.Effective_Time__c : System.today(); 
			if(msd.Date_of_Last_Menstrual_Period__c > crfCreationDate.addMonths(-6) && !msd.On_Estrogen_Replacement__c && !msd.Bilateral_oophorectomy__c){
				msd.Menopausal_Status__c = 'Premenopausal(<6 months since LMP AND no prior bilateral ovariectomy AND not on estrogen replacement)';
			} else if(msd.Date_of_Last_Menstrual_Period__c < crfCreationDate.addMonths(-6) && msd.Date_of_Last_Menstrual_Period__c > crfCreationDate.addMonths(-12) && !msd.On_Estrogen_Replacement__c && !msd.Bilateral_oophorectomy__c){
				msd.Menopausal_Status__c = 'Perimenopausal(6-12 months since LMP AND no prior bilateral ovariectomy AND not on estrogen replacement)';
			} else if(msd.Date_of_Last_Menstrual_Period__c < crfCreationDate.addMonths(-12) || msd.Bilateral_oophorectomy__c){
				msd.Menopausal_Status__c = 'Postmenopausal (prior bilateral ovariectomy OR > 12 months since LMP with no prior hysterectomy)';
			} /*else {
				system.debug('ok3');
				msd.Menopausal_Status__c = '';
			}*/
		}
		
		//msd.Date_of_Last_Menstrual_Period_Snomed__c = SnomedCTCode.SnomedCode('Menopausal_Status_Detail__c','Date_of_Last_Menstrual_Period__c','');
		//msd.Unknown_Date_Snomed__c = SnomedCTCode.SnomedCode('Menopausal_Status_Detail__c','Unknown_Date__c','');
		/*if(msd.On_Estrogen_Replacement__c){
			msd.On_Estrogen_Replacement_Snomed__c = SnomedCTCode.SnomedCode('Menopausal_Status_Detail__c','On_Estrogen_Replacement__c','true');
		} else {
			msd.On_Estrogen_Replacement_Snomed__c = SnomedCTCode.SnomedCode('Menopausal_Status_Detail__c','On_Estrogen_Replacement__c','false');
		}
		if(msd.Bilateral_oophorectomy__c){
			msd.Bilateral_Oophorectomy_Snomed__c = SnomedCTCode.SnomedCode('Menopausal_Status_Detail__c','Bilateral_oophorectomy__c','true');
		} else {
			msd.Bilateral_Oophorectomy_Snomed__c = SnomedCTCode.SnomedCode('Menopausal_Status_Detail__c','Bilateral_oophorectomy__c','false');
		}
		if(msd.Hysterectomy__c){
			msd.Hysterectomy_Snomed__c = SnomedCTCode.SnomedCode('Menopausal_Status_Detail__c','Hysterectomy__c','true');
		} else {
			msd.Hysterectomy_Snomed__c = SnomedCTCode.SnomedCode('Menopausal_Status_Detail__c','Hysterectomy__c','false');
		}
		msd.Menopausal_Status_Val_Snomed__c = SnomedCTCode.SnomedCode('Menopausal_Status_Detail__c','Menopausal_Status__c',msd.Menopausal_Status__c);
		msd.MenoStatus_OS_Snomed__c = SnomedCTCode.SnomedCode('Menopausal_Status_Detail__c','Menopausal_Status__c','');*/
	}
	/*if(Trigger.isInsert){
		List<Code_Master__c> lstSnomedMaster = [select id,Name,Variable_Description__c from Code_Master__c where Name = 'Menopausal_OS'];
		List<Snomed_Code__c> lstSnomed = new List<Snomed_Code__c>();
		for(Menopausal_Status_Detail__c msd : Trigger.new){
			for(Code_Master__c sm : lstSnomedMaster){
				if(sm.Name == 'Menopausal_OS') {
					Snomed_Code__c sc = new Snomed_Code__c();
					sc.CRF__c = msd.CRF_Id__c;
					sc.TrialPatient__c = msd.TrialPatient__c;
					sc.Name = '161712005'; 
					SnomedCTCode.SnomedWrapper sw = SnomedCTCode.SnomedCode('161712005', msd.Menopausal_Status__c);
					sc.Value__c = sw.snomedCodeVal;
					sc.Code_System__c = sw.codeSystem;
					sc.caIntegratorValue__c = sw.caIntegratorValue;
					sc.Code_Master__c = sm.Id;
					lstSnomed.add(sc);
				}
			} 
		}
		if(!lstSnomed.isEmpty()){
			insert lstSnomed;
		}
	}
	if(Trigger.isUpdate){
		set<Id> crfIds = new set<Id>();
		for(Menopausal_Status_Detail__c msd : Trigger.new){
			crfIds.add(msd.CRF_Id__c);
		}
		List<Snomed_Code__c> lstSnomed = [select id,CRF__c,Value__c,Name from Snomed_Code__c where CRF__c IN : crfIds];
		for(Menopausal_Status_Detail__c msd : Trigger.new){
			for(Snomed_Code__c sc : lstSnomed){
				if(sc.CRF__c == msd.CRF_Id__c){
					if(sc.Name == '161712005'){
						SnomedCTCode.SnomedWrapper sw = SnomedCTCode.SnomedCode('161712005', msd.Menopausal_Status__c);
						sc.Value__c = sw.snomedCodeVal;
						sc.Code_System__c = sw.codeSystem;
						sc.caIntegratorValue__c = sw.caIntegratorValue;
					}
				}
			}
		}
		if(!lstSnomed.isEmpty()){
			update lstSnomed;
		}
	}*/
	/*if(Trigger.isUpdate){
		set<Id> crfIds = new set<Id>();
		for(Menopausal_Status_Detail__c msd : Trigger.new){
			crfIds.add(msd.CRF_Id__c);
		}
		List<Snomed_Code__c> lstSnomed = [select id,CRF__c,Value__c,Name from Snomed_Code__c where CRF__c IN : crfIds];
		if(!lstSnomed.isEmpty()) {
			delete lstSnomed;
		}
	}
	SnomedCTCode.insertMenopasualRelatedCode(Trigger.newMap.keySet());*/
}