trigger InsertCRFonFollowup on Followup_Form__c (before insert, before update) {
	
	Set<Id> ids = new Set<Id>();
	Set<Id> ownerIds = new Set<Id>();
	for(Followup_Form__c os : Trigger.new){
		ids.add(os.TrialPatient__c);
		ownerIds.add(os.OwnerId);
	}
	
	List<GroupMember> grpList = [Select id, GroupId,UserOrGroupId from GroupMember where UserOrGroupId IN :ownerIds];
	Map<Id, Id> ownerIdGroupIdMap = new Map<Id, Id>();
	for(GroupMember gm : grpList) {
		ownerIdGroupIdMap.put(gm.UserOrGroupId, gm.GroupId);
	}
	
	Map<Followup_Form__c,CRF__c> followUpCrfObjMap = new Map<Followup_Form__c,CRF__c>();
	
	List<Site_Trial__c> siteTrials = [Select s.Trial__c, s.Site__c, s.Name From Site_Trial__c s];
	Map<CRF__c, String> crfGroupNameMap = new Map<CRF__c, String>();
	
	if(Trigger.isInsert) {
		List<TrialPatient__c> trialPatientList = [select Id, Site__c, Patient_Id__c,Trial_Id__c from TrialPatient__c where Id IN :ids];
		List<CRF__c> lstCRF = new List<CRF__c>();
		for(Followup_Form__c os : Trigger.new){
			for(TrialPatient__c tmpListObj : trialPatientList) {
				if(os.TrialPatient__c == tmpListObj.Id) {
					CRF__c crfObj = new CRF__c();
					crfObj.Patient__c = tmpListObj.Patient_Id__c; 
					if(os.Status__c != null) {
						crfObj.Status__c = os.Status__c;
					} else {
						crfObj.Status__c = 'Not Completed';
					}
					crfObj.Status__c = os.Status__c;
					crfObj.Trial__c = tmpListObj.Trial_Id__c;
					crfObj.TrialPatient__c = os.TrialPatient__c;
					crfObj.Complete_Date__c = System.today();
					crfObj.Type__c = 'Followup_Form__c';
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
		
		for(Followup_Form__c os : Trigger.new){
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
	/*Decimal totalDose = 0;
	if(Trigger.isInsert){
		
		SnomedCTCode.insertSnomedCodeForFollowup(foIds);
		
		List<Irradiated_Site__c> lstIrr = [select Id, Total_dose_cGy_AP__c from Irradiated_Site__c where Followup_Form__c IN :foIds];
		for(Irradiated_Site__c ir : lstIrr) {
			totalDose += ir.Total_dose_cGy_AP__c;
		}
		List<Snomed_Code__c> lstSnomed = new List<Snomed_Code__c>();
		List<Code_Master__c> lstSnomedMaster = [select id,Name,Variable_Description__c from Code_Master__c where Name = 'SurvDateD' or Name = 'RFS' 
		or Name = 'RFS_ind' or Name = 'RtTherapy' or Name = 'LocalProgress' or Name = 'DistProgress' or Name = 'LocalProgTimeD' 
		or Name = 'DistProgTimeD' or Name = 'NewPrimeCa' or Name = 'NewPrimeTimeD' or Name = 'Adj_Chemo' or Name = 'Adj_ChemoReg' or Name = 'Adj_Other' or Name = 'Adu_OtherReg' 
		or Name = 'Adj_Trastuzumab' or Name = 'Adj_Tam' or Name = 'Adj_OvarianAbl' or Name = 'Adj_OvarianSup' or Name = 'Adj_AromataseInhib' 
		or Name = 'DistProgSite' or Name = 'RtBoTD' or Name = 'RtAxTD' or Name = 'RtSNTD' or Name = 'RtIMTD' or Name = 'RtCWTD' or Name = 'DistProgSite'];
		for(Followup_Form__c fo : Trigger.new){
			for(Code_Master__c sm : lstSnomedMaster){
				if(sm.Name == 'SurvStat'){
					Snomed_Code__c sc0 = new Snomed_Code__c();
					sc0.CRF__c = fo.CRF__c;
					sc0.TrialPatient__c = fo.TrialPatient__c;
					sc0.Name = '309032007';
					sc0.Code_Master__c = sm.Id;
					SnomedCTCode.SnomedWrapper sw0 = SnomedCTCode.SnomedCode('309032007', fo.Survival_Status__c);
					sc0.Value__c = sw0.snomedCodeVal;
					sc0.Code_System__c = sw0.codeSystem;
					//sc0.caIntegratorValue__c = sw0.caIntegratorValue;
					sc0.Numeric_Value__c = sw0.numericValue;
					lstSnomed.add(sc0);
				}
				if(sm.Name == 'SurvDateD'){
					Snomed_Code__c sc = new Snomed_Code__c();
					sc.CRF__c = fo.CRF__c;
					sc.TrialPatient__c = fo.TrialPatient__c;
					sc.Name = 'IHTSDO_4597';
					
					sc.Code_Master__c = sm.Id;
					SnomedCTCode.SnomedWrapper sw = SnomedCTCode.SnomedCode('IHTSDO_4597', '');	
					sc.Value__c = sw.snomedCodeVal;
					sc.Code_System__c = sw.codeSystem;
					//sc.caIntegratorValue__c = sw.caIntegratorValue;
					sc.Numeric_Value__c = sw.numericValue;
					lstSnomed.add(sc);
				}
				if(sm.Name == 'RFS'){
					Snomed_Code__c sc1 = new Snomed_Code__c();
					sc1.CRF__c = fo.CRF__c;
					sc1.TrialPatient__c = fo.TrialPatient__c;
					sc1.Name = 'IHTSDO_4598';
					sc1.Code_Master__c = sm.Id;
					SnomedCTCode.SnomedWrapper sw1 = SnomedCTCode.SnomedCode('IHTSDO_4598', '');
					sc1.Value__c = sw1.snomedCodeVal;
					sc1.Code_System__c = sw1.codeSystem;
					//sc1.caIntegratorValue__c = sw1.caIntegratorValue;
					sc1.Numeric_Value__c = sw1.numericValue;
					lstSnomed.add(sc1);
				}
				if(sm.Name == 'RFS_ind'){
					Snomed_Code__c sc2 = new Snomed_Code__c();
					sc2.CRF__c = fo.CRF__c;
					sc2.TrialPatient__c = fo.TrialPatient__c;
					sc2.Name = 'IHTSDO_4600';
					sc2.Code_Master__c = sm.Id;
					SnomedCTCode.SnomedWrapper sw2 = null;
					if(fo.patient_diagnosed_local_progression__c || fo.patient_diagnosed_distant_progression__c) {
						sw2 = SnomedCTCode.SnomedCode('IHTSDO_4600', '1');
					} else {
						sw2 = SnomedCTCode.SnomedCode('IHTSDO_4600', '0');
					}
					sc2.Value__c = sw2.snomedCodeVal;
					sc2.Code_System__c = sw2.codeSystem;
					//sc2.caIntegratorValue__c = sw2.caIntegratorValue;
					sc2.Numeric_Value__c = sw2.numericValue;
					lstSnomed.add(sc2);
				}
				if(sm.Name == 'RtTherapy'){
					Snomed_Code__c sc3 = new Snomed_Code__c();
					sc3.CRF__c = fo.CRF__c;
					sc3.TrialPatient__c = fo.TrialPatient__c;
					sc3.Name = '428923005';
					sc3.Code_Master__c = sm.Id;
					SnomedCTCode.SnomedWrapper sw3 = SnomedCTCode.SnomedCode('428923005', 'No');
					sc3.Value__c = sw3.snomedCodeVal;
					sc3.Code_System__c = sw3.codeSystem;
					sc3.Numeric_Value__c = sw3.numericValue;
					//sc3.caIntegratorValue__c = sw3.caIntegratorValue;
					lstSnomed.add(sc3);
				}
				
				if(sm.Name == 'Adj_OvarianSup'){
					Snomed_Code__c sc4 = new Snomed_Code__c();
					sc4.CRF__c = fo.CRF__c;
					sc4.TrialPatient__c = fo.TrialPatient__c;
					sc4.Name = 'IHTSDO_4584_1';
					sc4.Code_Master__c = sm.Id;
					SnomedCTCode.SnomedWrapper sw4 = SnomedCTCode.SnomedCode('IHTSDO_4584_1', totalDose+'');
					sc4.Value__c = sw4.snomedCodeVal;
					sc4.Code_System__c = sw4.codeSystem;
					//sc4.caIntegratorValue__c = sw4.caIntegratorValue;
					sc4.Numeric_Value__c = sw4.numericValue;
					lstSnomed.add(sc4);
				}
				
				Snomed_Code__c sc5 = new Snomed_Code__c();
				sc5.CRF__c = fo.CRF__c;
				sc5.TrialPatient__c = fo.TrialPatient__c;
				sc5.Name = 'IHTSDO_4586';
				SnomedCTCode.SnomedWrapper sw5 = SnomedCTCode.SnomedCode('IHTSDO_4586', '');
				sc5.Value__c = sw5.snomedCodeVal;
				sc5.Code_System__c = sw5.codeSystem;
				//sc5.caIntegratorValue__c = sw5.caIntegratorValue;
				sc5.Numeric_Value__c = sw5.numericValue;
				lstSnomed.add(sc5);
							
				Snomed_Code__c sc6 = new Snomed_Code__c();
				sc6.CRF__c = fo.CRF__c;
				sc6.TrialPatient__c = fo.TrialPatient__c;
				sc6.Name = 'IHTSDO_4584_2';
				SnomedCTCode.SnomedWrapper sw6 = SnomedCTCode.SnomedCode('IHTSDO_4584_2', '');
				sc6.Value__c = sw6.snomedCodeVal;
				sc6.Code_System__c = sw6.codeSystem;
				//sc6.caIntegratorValue__c = sw6.caIntegratorValue;
				sc6.Numeric_Value__c = sw6.numericValue;
				lstSnomed.add(sc6);
				
				if(sm.Name == 'LocalProgress'){
					Snomed_Code__c sc7 = new Snomed_Code__c();
					sc7.CRF__c = fo.CRF__c;
					sc7.TrialPatient__c = fo.TrialPatient__c;
					sc7.Name = '314955001';
					sc7.Code_Master__c = sm.Id;
					SnomedCTCode.SnomedWrapper sw7 = SnomedCTCode.SnomedCode('314955001', '');
					sc7.Value__c = sw7.snomedCodeVal;
					sc7.Code_System__c = sw7.codeSystem;
					//sc7.caIntegratorValue__c = sw7.caIntegratorValue;
					sc7.Numeric_Value__c = sw7.numericValue;
					lstSnomed.add(sc7);
				}
				if(sm.Name == 'DistProgress'){
					Snomed_Code__c sc8 = new Snomed_Code__c();
					sc8.CRF__c = fo.CRF__c;
					sc8.TrialPatient__c = fo.TrialPatient__c;
					sc8.Name = '373171005';
					sc8.Code_Master__c = sm.Id;
					SnomedCTCode.SnomedWrapper sw8 = SnomedCTCode.SnomedCode('373171005', '');
					sc8.Value__c = sw8.snomedCodeVal;
					sc8.Code_System__c = sw8.codeSystem;
					//sc8.caIntegratorValue__c = sw8.caIntegratorValue;
					sc8.Numeric_Value__c = sw8.numericValue;
					lstSnomed.add(sc8);
				}
				if(sm.Name == 'LocalProgTimeD'){
					Snomed_Code__c sc9 = new Snomed_Code__c();
					sc9.CRF__c = fo.CRF__c;
					sc9.TrialPatient__c = fo.TrialPatient__c;
					sc9.Name = 'TIMEPHASE_FirstLocal';
					sc9.Code_Master__c = sm.Id;
					SnomedCTCode.SnomedWrapper sw9 = SnomedCTCode.SnomedCode('TIMEPHASE_FirstLocal', '');
					sc9.Value__c = sw9.snomedCodeVal;
					sc9.Code_System__c = sw9.codeSystem;
					//sc9.caIntegratorValue__c = sw9.caIntegratorValue;
					sc9.Numeric_Value__c = sw9.numericValue;
					lstSnomed.add(sc9);
				}
				if(sm.Name == 'DistProgTimeD'){
					Snomed_Code__c sc10 = new Snomed_Code__c();
					sc10.CRF__c = fo.CRF__c;
					sc10.TrialPatient__c = fo.TrialPatient__c;
					sc10.Name = 'TIMEPHASE_FirstDist';
					sc10.Code_Master__c = sm.Id;
					SnomedCTCode.SnomedWrapper sw10 = SnomedCTCode.SnomedCode('TIMEPHASE_FirstDist', '');
					sc10.Value__c = sw10.snomedCodeVal;
					sc10.Code_System__c = sw10.codeSystem;
					//sc10.caIntegratorValue__c = sw10.caIntegratorValue;
					sc10.Numeric_Value__c = sw10.numericValue;
					lstSnomed.add(sc10);
				}
				if(sm.Name == 'NewPrimeCa'){
					Snomed_Code__c sc11 = new Snomed_Code__c();
					sc11.CRF__c = fo.CRF__c;
					sc11.TrialPatient__c = fo.TrialPatient__c;
					sc11.Name = 'IHTSDO_4680_1';
					sc11.Code_Master__c = sm.Id;
					SnomedCTCode.SnomedWrapper sw11 = SnomedCTCode.SnomedCode('IHTSDO_4680_1', '');
					sc11.Value__c = sw11.snomedCodeVal;
					sc11.Code_System__c = sw11.codeSystem;
					//sc11.caIntegratorValue__c = sw11.caIntegratorValue;
					sc11.Numeric_Value__c = sw11.numericValue;
					lstSnomed.add(sc11);
				}
				if(sm.Name == 'NewPrimeTimeD'){
					Snomed_Code__c sc110 = new Snomed_Code__c();
					sc110.CRF__c = fo.CRF__c;
					sc110.TrialPatient__c = fo.TrialPatient__c;
					sc110.Name = 'TIMEPHASE_FirstNew';
					sc110.Code_Master__c = sm.Id;
					//SnomedCTCode.SnomedWrapper sw110 = SnomedCTCode.SnomedCode('TIMEPHASE_FirstNew', '', (SObject)fo);
					SnomedCTCode.SnomedWrapper sw110 = SnomedCTCode.SnomedCode('TIMEPHASE_FirstNew', '');
					sc110.Value__c = sw110.snomedCodeVal;
					sc110.Code_System__c = sw110.codeSystem;
					sc110.Numeric_Value__c = sw110.numericValue;
					//sc110.caIntegratorValue__c = sw110.caIntegratorValue;
					lstSnomed.add(sc110);
				}
				
				if(sm.Name == 'Adj_Trastuzumab' || sm.Name == 'Adj_OvarianAbl' || sm.Name == 'Adj_Tam'){
					Snomed_Code__c sc12 = new Snomed_Code__c();
					sc12.CRF__c = fo.CRF__c;
					sc12.TrialPatient__c = fo.TrialPatient__c;
					sc12.Name = sm.Name;
					sc12.Code_Master__c = sm.Id;
					SnomedCTCode.SnomedWrapper sw12 = SnomedCTCode.SnomedCode('428923005',fo.Radiation_Therapy__c?'Yes' : 'No');
					sc12.Value__c = sw12.snomedCodeVal;
					sc12.Code_System__c = sw12.codeSystem;
					//sc12.caIntegratorValue__c = sw12.caIntegratorValue;
					sc12.Numeric_Value__c = sw12.numericValue;
					lstSnomed.add(sc12);
				}
				if(sm.Name == 'Adj_AromataseInhib'){
					Snomed_Code__c sc13 = new Snomed_Code__c();
					sc13.CRF__c = fo.CRF__c;
					sc13.TrialPatient__c = fo.TrialPatient__c;
					sc13.Name = 'Adj_AromataseInhib';
					sc13.Code_Master__c = sm.Id;
					SnomedCTCode.SnomedWrapper sw13 = SnomedCTCode.SnomedCode('IHTSDO_4585',lstIrr.size() > 0?'Yes' : 'No');
					sc13.Value__c = sw13.snomedCodeVal;
					sc13.Code_System__c = sw13.codeSystem;
					//sc13.caIntegratorValue__c = sw13.caIntegratorValue;
					sc13.Numeric_Value__c = sw13.numericValue;
					lstSnomed.add(sc13);
				}
				if(sm.Name == 'Adj_OvarianSup'){
					Snomed_Code__c sc14 = new Snomed_Code__c();
					sc14.CRF__c = fo.CRF__c;
					sc14.TrialPatient__c = fo.TrialPatient__c;
					sc14.Name = 'IHTSDO_4584_1';
					sc14.Code_Master__c = sm.Id;
					SnomedCTCode.SnomedWrapper sw14 = SnomedCTCode.SnomedCode('IHTSDO_4584_1','');
					sc14.Value__c = sw14.snomedCodeVal;
					sc14.Code_System__c = sw14.codeSystem;
					//sc14.caIntegratorValue__c = sw14.caIntegratorValue;
					sc14.Numeric_Value__c = sw14.numericValue;
					lstSnomed.add(sc14);
				}
				if(sm.Name == 'Adj_Chemo'){
					Snomed_Code__c sc141 = new Snomed_Code__c();
					sc141.CRF__c = fo.CRF__c;
					sc141.TrialPatient__c = fo.TrialPatient__c;
					sc141.Name = '371479009';
					sc141.Code_Master__c = sm.Id;
					SnomedCTCode.SnomedWrapper sw141 = SnomedCTCode.SnomedCode('371479009','');
					sc141.Value__c = sw141.snomedCodeVal;
					sc141.Code_System__c = sw141.codeSystem;
					//sc141.caIntegratorValue__c = sw141.caIntegratorValue;
					sc141.Numeric_Value__c = sw141.numericValue;
					lstSnomed.add(sc141);
				}
				if(sm.Name == 'Adj_ChemoReg' || sm.Name == 'Adj_Other' || sm.Name == 'Adu_OtherReg') {
					Snomed_Code__c sc15 = new Snomed_Code__c();
					sc15.CRF__c = fo.CRF__c;
					sc15.TrialPatient__c = fo.TrialPatient__c;
					sc15.Name = sm.Name;
					sc15.Code_Master__c = sm.Id;
					SnomedCTCode.SnomedWrapper sw15 = SnomedCTCode.SnomedCode('428923005',fo.Patient_received_adjuvant_therapy__c?'Yes' : 'No');
					sc15.Value__c = sw15.snomedCodeVal;
					sc15.Code_System__c = sw15.codeSystem;
					//sc15.caIntegratorValue__c = sw15.caIntegratorValue;
					sc15.Numeric_Value__c = sw15.numericValue;
					lstSnomed.add(sc15);
				}
				if(sm.Name == 'DistProgSite'){
					Snomed_Code__c sc16 = new Snomed_Code__c();
					sc16.CRF__c = fo.CRF__c;
					sc16.TrialPatient__c = fo.TrialPatient__c;
					sc16.Name = '385421009';
					sc16.Code_Master__c = sm.Id;
					SnomedCTCode.SnomedWrapper sw16 = SnomedCTCode.SnomedCode('385421009', '');
					sc16.Value__c = sw16.snomedCodeVal;
					sc16.Code_System__c = sw16.codeSystem;
					//sc16.caIntegratorValue__c = sw16.caIntegratorValue;
					sc16.Numeric_Value__c = sw16.numericValue;
					lstSnomed.add(sc16);
				}
				
				if(sm.Name == 'RtCWTD'){
					Snomed_Code__c sc17 = new Snomed_Code__c();
					sc17.CRF__c = fo.CRF__c;
					sc17.TrialPatient__c = fo.TrialPatient__c;
					sc17.Name = 'RtCWTD';
					sc17.Code_Master__c = sm.Id;
					SnomedCTCode.SnomedWrapper sw17 = SnomedCTCode.SnomedCode('IHTSDO_4584_5', '');
					sc17.Value__c = sw17.snomedCodeVal;
					sc17.Code_System__c = sw17.codeSystem;
					//sc17.caIntegratorValue__c = sw17.caIntegratorValue;
					sc17.Numeric_Value__c = sw17.numericValue;
					lstSnomed.add(sc17);
				}
				
				if(sm.Name == 'RtIMTD'){
					Snomed_Code__c sc18 = new Snomed_Code__c();
					sc18.CRF__c = fo.CRF__c;
					sc18.TrialPatient__c = fo.TrialPatient__c;
					sc18.Name = 'RtIMTD';
					sc18.Code_Master__c = sm.Id;
					SnomedCTCode.SnomedWrapper sw18 = SnomedCTCode.SnomedCode('IHTSDO_4584_4', '');
					sc18.Value__c = sw18.snomedCodeVal;
					sc18.Code_System__c = sw18.codeSystem;
					//sc18.caIntegratorValue__c = sw18.caIntegratorValue;
					sc18.Numeric_Value__c = sw18.numericValue;
					lstSnomed.add(sc18);
				}
				
				if(sm.Name == 'RtSNTD'){
					Snomed_Code__c sc18 = new Snomed_Code__c();
					sc18.CRF__c = fo.CRF__c;
					sc18.TrialPatient__c = fo.TrialPatient__c;
					sc18.Name = 'RtSNTD';
					sc18.Code_Master__c = sm.Id;
					SnomedCTCode.SnomedWrapper sw18 = SnomedCTCode.SnomedCode('IHTSDO_4584_3', '');
					sc18.Value__c = sw18.snomedCodeVal;
					sc18.Code_System__c = sw18.codeSystem;
					//sc18.caIntegratorValue__c = sw18.caIntegratorValue;
					sc18.Numeric_Value__c = sw18.numericValue;
					lstSnomed.add(sc18);
				}
				
				if(sm.Name == 'RtAxTD'){
					Snomed_Code__c sc18 = new Snomed_Code__c();
					sc18.CRF__c = fo.CRF__c;
					sc18.TrialPatient__c = fo.TrialPatient__c;
					sc18.Name = 'RtAxTD';
					sc18.Code_Master__c = sm.Id;
					SnomedCTCode.SnomedWrapper sw18 = SnomedCTCode.SnomedCode('IHTSDO_4584_2', '');
					sc18.Value__c = sw18.snomedCodeVal;
					sc18.Code_System__c = sw18.codeSystem;
					//sc18.caIntegratorValue__c = sw18.caIntegratorValue;
					sc18.Numeric_Value__c = sw18.numericValue;
					lstSnomed.add(sc18);
				}
				
				if(sm.Name == 'RtBoTD'){
					Snomed_Code__c sc18 = new Snomed_Code__c();
					sc18.CRF__c = fo.CRF__c;
					sc18.TrialPatient__c = fo.TrialPatient__c;
					sc18.Name = 'RtBoTD';
					sc18.Code_Master__c = sm.Id;
					SnomedCTCode.SnomedWrapper sw18 = SnomedCTCode.SnomedCode('IHTSDO_4586', '');
					sc18.Value__c = sw18.snomedCodeVal;
					sc18.Code_System__c = sw18.codeSystem;
					//sc18.caIntegratorValue__c = sw18.caIntegratorValue;
					sc18.Numeric_Value__c = sw18.numericValue;
					lstSnomed.add(sc18);
				}
				if(sm.Name == 'LocalProgSite'){
					Snomed_Code__c sc19 = new Snomed_Code__c();
					sc19.CRF__c = fo.CRF__c;
					sc19.TrialPatient__c = fo.TrialPatient__c;
					sc19.Name = 'RtBoTD';
					sc19.Code_Master__c = sm.Id;
					SnomedCTCode.SnomedWrapper sw19 = new SnomedCTCode.SnomedWrapper();
					if(fo.Local__c == 'Ipsilateral Breast') {
						sw19 = SnomedCTCode.SnomedCode('IHTSDO_4587', 'Yes');
					} else if(fo.Local__c == 'Axillary Nodes') {
						//NOT CODED
					} else if(fo.Local__c == 'Internal Mammary Nodes') {
						//NOT CODED
					} else if(fo.Local__c == 'Supraclavicular Nodes') {
						//NOT CODED
					} else if(fo.Local__c == 'Infraclavicular Nodes') {
						//NOT CODED
					} else if(fo.Local__c == 'Chest Wall') {
						//NOT CODED
					} else if(fo.Local__c == 'Local-regionalSkin&SubcutaneousTissue') {
						//NOT CODED
					}
					//SnomedCTCode.SnomedWrapper sw19 = SnomedCTCode.SnomedCode('IHTSDO_4586', fo.Local__c);
					sc19.Value__c = sw19.snomedCodeVal;
					sc19.Code_System__c = sw19.codeSystem;
					//sc19.caIntegratorValue__c = sw19.caIntegratorValue;
					sc19.Numeric_Value__c = sw19.numericValue;
					lstSnomed.add(sc19);
				}
			}
		}
		if(!lstSnomed.isEmpty()){
			insert lstSnomed;
		}
	}
	
	if(Trigger.isUpdate){
		
		List<Irradiated_Site__c> lstIrr = [select Id, Total_dose_cGy_AP__c from Irradiated_Site__c where Followup_Form__c IN :foIds];
		for(Irradiated_Site__c ir : lstIrr) {
			totalDose += ir.Total_dose_cGy_AP__c;
		}
		set<Id> crfIds = new set<Id>();
		for(Followup_Form__c ff : Trigger.new){
			crfIds.add(ff.CRF__c);
		}
		List<Snomed_Code__c> lstSnomed = [select id,CRF__c,TrialPatient__c,Name from Snomed_Code__c where CRF__c IN : crfIds];
		for(Followup_Form__c fo : Trigger.new){
			for(Snomed_Code__c sc : lstSnomed){
				if(fo.CRF__c == sc.CRF__c){
					if(sc.Name == '428923005'){
						if(fo.Radiation_Therapy__c == true){
							SnomedCTCode.SnomedWrapper sw = SnomedCTCode.SnomedCode('428923005', 'Yes');
							sc.Value__c = sw.snomedCodeVal;
							sc.Code_System__c = sw.codeSystem;
							//sc.caIntegratorValue__c = sw.caIntegratorValue;
							sc.Numeric_Value__c = sw.numericValue;
						} else {
							SnomedCTCode.SnomedWrapper sw = SnomedCTCode.SnomedCode('428923005', 'No');
							sc.Value__c = sw.snomedCodeVal;
							sc.Code_System__c = sw.codeSystem;
							//sc.caIntegratorValue__c = sw.caIntegratorValue;
							sc.Numeric_Value__c = sw.numericValue;
						}
					}
					if(sc.Name == 'IHTSDO_4600'){
						if(fo.patient_diagnosed_local_progression__c || fo.patient_diagnosed_distant_progression__c) {
							SnomedCTCode.SnomedWrapper sw = SnomedCTCode.SnomedCode('IHTSDO_4600', '1');
							sc.Value__c = sw.snomedCodeVal;
							sc.Code_System__c = sw.codeSystem;
							//sc.caIntegratorValue__c = sw.caIntegratorValue;
							sc.Numeric_Value__c = sw.numericValue;
						} else {
							SnomedCTCode.SnomedWrapper sw = SnomedCTCode.SnomedCode('IHTSDO_4600', '0');
							sc.Value__c = sw.snomedCodeVal;
							sc.Code_System__c = sw.codeSystem;
							//sc.caIntegratorValue__c = sw.caIntegratorValue;
							sc.Numeric_Value__c = sw.numericValue;
						}
					}
					if(sc.Name == '314955001'){
						if(fo.patient_diagnosed_local_progression__c == true){
							SnomedCTCode.SnomedWrapper sw = SnomedCTCode.SnomedCode('314955001', 'Yes');
							sc.Value__c = sw.snomedCodeVal;
							sc.Code_System__c = sw.codeSystem;
							//sc.caIntegratorValue__c = sw.caIntegratorValue;
							sc.Numeric_Value__c = sw.numericValue;
						} else {
							SnomedCTCode.SnomedWrapper sw = SnomedCTCode.SnomedCode('314955001', 'No');
							sc.Value__c = sw.snomedCodeVal;
							sc.Code_System__c = sw.codeSystem;
							//sc.caIntegratorValue__c = sw.caIntegratorValue;
							sc.Numeric_Value__c = sw.numericValue;
						}
					}
					if(sc.Name == '373171005'){
						if(fo.patient_diagnosed_distant_progression__c == true){
							SnomedCTCode.SnomedWrapper sw = SnomedCTCode.SnomedCode('373171005', 'Yes');
							sc.Value__c = sw.snomedCodeVal;
							sc.Code_System__c = sw.codeSystem;
							//sc.caIntegratorValue__c = sw.caIntegratorValue;
							sc.Numeric_Value__c = sw.numericValue;
						} else {
							SnomedCTCode.SnomedWrapper sw = SnomedCTCode.SnomedCode('373171005', 'No');
							sc.Value__c = sw.snomedCodeVal;
							sc.Code_System__c = sw.codeSystem;
							sc.Numeric_Value__c = sw.numericValue;
							//sc.caIntegratorValue__c = sw.caIntegratorValue;
						}
					}
					if(sc.Name == 'IHTSDO_4680_1'){
						if(fo.patient_diagnosed_distant_progression__c == true){
							SnomedCTCode.SnomedWrapper sw = SnomedCTCode.SnomedCode('IHTSDO_4680_1', 'Yes');
							sc.Value__c = sw.snomedCodeVal;
							sc.Code_System__c = sw.codeSystem;
							//sc.caIntegratorValue__c = sw.caIntegratorValue;
							sc.Numeric_Value__c = sw.numericValue;
						} else {
							SnomedCTCode.SnomedWrapper sw = SnomedCTCode.SnomedCode('IHTSDO_4680_1', 'No');
							sc.Value__c = sw.snomedCodeVal;
							sc.Code_System__c = sw.codeSystem;
							//sc.caIntegratorValue__c = sw.caIntegratorValue;
							sc.Numeric_Value__c = sw.numericValue;
						}
					}
					if(sc.Name == '385421009'){
						SnomedCTCode.SnomedWrapper sw = SnomedCTCode.SnomedCode('385421009', fo.Distant__c);
						sc.Value__c = sw.snomedCodeVal;
						sc.Code_System__c = sw.codeSystem;
						//sc.caIntegratorValue__c = sw.caIntegratorValue;
						sc.Numeric_Value__c = sw.numericValue;
					}
					if(sc.Name == 'TIMEPHASE_FirstNew'){
						SnomedCTCode.SnomedWrapper sw = SnomedCTCode.SnomedCode('TIMEPHASE_FirstNew', '');
						sc.Value__c = sw.snomedCodeVal;
						sc.Code_System__c = sw.codeSystem;
						//sc.caIntegratorValue__c = sw.caIntegratorValue;
						sc.Numeric_Value__c = sw.numericValue;
					}
					if(sc.Name == '309032007'){
						SnomedCTCode.SnomedWrapper sw = SnomedCTCode.SnomedCode('309032007', fo.Survival_Status__c);
						sc.Value__c = sw.snomedCodeVal;
						sc.Code_System__c = sw.codeSystem;
						//sc.caIntegratorValue__c = sw.caIntegratorValue;
						sc.Numeric_Value__c = sw.numericValue;
					}
					if(sc.Name == '371479009'){
						SnomedCTCode.SnomedWrapper sw = SnomedCTCode.SnomedCode('371479009', '');
						sc.Value__c = sw.snomedCodeVal;
						sc.Code_System__c = sw.codeSystem;
						//sc.caIntegratorValue__c = sw.caIntegratorValue;
						sc.Numeric_Value__c = sw.numericValue;
					}
					if(sc.Name == 'IHTSDO_4584_1'){
						SnomedCTCode.SnomedWrapper sw = SnomedCTCode.SnomedCode('IHTSDO_4584_1', totalDose+'');
						sc.Value__c = sw.snomedCodeVal;
						sc.Code_System__c = sw.codeSystem;
						//sc.caIntegratorValue__c = sw.caIntegratorValue;
						sc.Numeric_Value__c = sw.numericValue;
					}
				}
			}
		}
		if(!lstSnomed.isEmpty()){
			update lstSnomed;
		}
	}*/
	
	
	if(Trigger.isUpdate){
		set<Id> setCrfIds = new set<Id>();
		for(Followup_Form__c os : Trigger.new){
			setCrfIds.add(os.CRF__c);
		}
		List<CRF__c> lstCrf = [select id,Status__c from CRF__c where id IN : setCrfIds];
		for(Followup_Form__c os : Trigger.new){
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