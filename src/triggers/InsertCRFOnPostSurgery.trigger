trigger InsertCRFOnPostSurgery on Post_Surgaory_Summary__c (before insert, before update) {
	
	Set<Id> ids = new Set<Id>();
	for(Post_Surgaory_Summary__c pss : Trigger.new){
		ids.add(pss.TrialPatient__c);
	}
	
	if(Trigger.isInsert) {
		List<Site_Trial__c> siteTrials = [Select s.Trial__c, s.Site__c, s.Name From Site_Trial__c s];
		Map<CRF__c, String> crfGroupNameMap = new Map<CRF__c, String>();
		
		List<TrialPatient__c> trialPatientList = [select Id, Site__c, Patient_Id__c,Trial_Id__c from TrialPatient__c where Id IN :ids];
		List<CRF__c> lstCRF = new List<CRF__c>();
		for(Post_Surgaory_Summary__c pss : Trigger.new){
			for(TrialPatient__c tmpListObj : trialPatientList) {
				if(pss.TrialPatient__c == tmpListObj.Id) {
					CRF__c crfObj = new CRF__c();
					crfObj.Patient__c = tmpListObj.Patient_Id__c; 
					crfObj.Type__c = 'Post_Surgaory_Summary__c';
					if(pss.Status__c != null) {
						crfObj.Status__c = pss.Status__c;
					} else {
						crfObj.Status__c = 'Not Completed'; 
					}
					if(!trialPatientList.isEmpty()){
						crfObj.Trial__c = trialPatientList[0].Trial_Id__c;
					}
					crfObj.TrialPatient__c = pss.TrialPatient__c;
					crfObj.Complete_Date__c = System.today();
					crfObj.Type__c = 'Post_Surgaory_Summary__c';
					crfObj.Phase__c = 'Screening';
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
		
		for(Post_Surgaory_Summary__c pss : Trigger.new){
			for(TrialPatient__c tmpListObj : trialPatientList) {
				for(CRF__c crfObj : lstCRF){
					if(crfObj.Patient__c == tmpListObj.Patient_Id__c){
						System.debug('--------------->');
						pss.CRF__c = crfObj.Id;
						if(pss.Status__c == null) {
							pss.Status__c = 'Not Completed';			
						}
					}
				}
			}
		}
	}
	
	if(Trigger.isUpdate) {
		Set<Id> crfIds = new Set<Id>();
		for(Post_Surgaory_Summary__c pss : Trigger.new){
			crfIds.add(pss.CRF__c);
		} 
		
		List<CRF__c> crfList = [select Id, Status__c from CRF__c where Id IN :crfIds];
		for(Post_Surgaory_Summary__c pss : Trigger.new){
			for(CRF__c crf : crfList){
				if(crf.id == pss.CRF__c && pss.Status__c != Trigger.oldMap.get(pss.Id).Status__c){
					crf.Status__c = pss.Status__c;
				}
			}
		}
		if(!crfList.isEmpty()) {
			update crfList;
		}
	}
	
	
	/*if(Trigger.isInsert){
		List<Snomed_Code__c> lstSnomed = new List<Snomed_Code__c>();
		List<Code_Master__c> lstSnomedMaster = [select id,Name,Variable_Description__c from Code_Master__c where Name = 'ypT' or Name = 'ypN' 
		or Name = 'ypM' or Name = 'pCR' or Name = 'RCB_class' or Name = 'RCB_index' or Name = 'InSitu_PS' or Name = 'LVI_PS' or Name = 'BaseNodeExt'
		or Name = 'InvMultifocal_PS' or Name = 'BaseDiseaseExt' or Name = 'DCISGrade_PS' or Name = 'InvMargin_PS' or Name = 'GrossPathSize1_PS' or Name = 'GrossPathSize2_PS' 
		or Name = 'InvPathSize1_PS' or Name = 'InvPathSize1_PS' or Name = 'InvPathSize2_PS' or Name = 'SizeMetLN_PS' or Name = 'InvHistology_PS'
		or Name = 'DCISHistology_PS' or Name = 'DCISspan_PS' or Name = 'LCISHistology_PS' ];
		for(Post_Surgaory_Summary__c pss : Trigger.new){
			for(Code_Master__c sm : lstSnomedMaster){
				if(sm.Name == 'pCR'){
					Snomed_Code__c sc3 = new Snomed_Code__c();
					sc3.CRF__c = pss.CRF__c;
					sc3.TrialPatient__c = pss.TrialPatient__c;
					sc3.Name = '103338009 | in complete remission |';
					sc3.Code_Master__c = sm.Id;
					SnomedCTCode.SnomedWrapper sw3 = SnomedCTCode.SnomedCode('103338009 | in complete remission |', 'N/A');
					sc3.Value__c = sw3.snomedCodeVal;
					sc3.Code_System__c = sw3.codeSystem;
					sc3.caIntegratorValue__c = sw3.caIntegratorValue;
					lstSnomed.add(sc3);
				}
				if(sm.Name == 'GrossPathSize1_PS' || sm.Name == 'GrossPathSize2_PS'){
					Snomed_Code__c sc6 = new Snomed_Code__c();
					sc6.CRF__c = pss.CRF__c;
					sc6.TrialPatient__c = pss.TrialPatient__c;
					sc6.Name = 'IHTSDO_4583_1'; 
					sc6.Code_Master__c = sm.Id;
					SnomedCTCode.SnomedWrapper sw6 = SnomedCTCode.SnomedCode('IHTSDO_4583_1', 'No Surgery');
					sc6.Value__c = sw6.snomedCodeVal;
					sc6.Code_System__c = sw6.codeSystem;
					sc6.caIntegratorValue__c = sw6.caIntegratorValue;
					lstSnomed.add(sc6);
				}
				if(sm.Name == 'RCB_class'){
					Snomed_Code__c sc11 = new Snomed_Code__c();
					sc11.CRF__c = pss.CRF__c;
					sc11.TrialPatient__c = pss.TrialPatient__c;
					sc11.Name = 'IHTSDO_4575';
					sc11.Code_Master__c = sm.Id;
					SnomedCTCode.SnomedWrapper sw11 = SnomedCTCode.SnomedCode('IHTSDO_4575', '');
					sc11.Value__c = sw11.snomedCodeVal;
					sc11.Code_System__c = sw11.codeSystem;
					sc11.caIntegratorValue__c = sw11.caIntegratorValue;
					lstSnomed.add(sc11);
				}
				Snomed_Code__c sc15 = new Snomed_Code__c();
				sc15.CRF__c = pss.CRF__c;
				sc15.TrialPatient__c = pss.TrialPatient__c;
				sc15.Name = '371510003 | proportion of specimen involved by tumour |';
				SnomedCTCode.SnomedWrapper sw15 = SnomedCTCode.SnomedCode('371510003 | proportion of specimen involved by tumour |', '');
				sc15.Value__c = sw15.snomedCodeVal;
				sc15.caIntegratorValue__c = sw15.caIntegratorValue;
				sc15.Code_System__c = sw15.codeSystem;
				lstSnomed.add(sc15);
				if(sm.Name == 'InvPathSize1_PS' || sm.Name == 'InvPathSize2_PS'){
					Snomed_Code__c sc20 = new Snomed_Code__c();
					sc20.CRF__c = pss.CRF__c;
					sc20.TrialPatient__c = pss.TrialPatient__c;
					sc20.Name = 'IHTSDO_4583_2';
					sc20.Code_Master__c = sm.Id;
					SnomedCTCode.SnomedWrapper sw20 = SnomedCTCode.SnomedCode('IHTSDO_4583_2', '');
					sc20.Value__c = sw20.snomedCodeVal;
					sc20.caIntegratorValue__c = sw20.caIntegratorValue;
					sc20.Code_System__c = sw20.codeSystem;
					lstSnomed.add(sc20);
				}
				if(sm.Name == 'SizeMetLN_PS'){
					Snomed_Code__c sc21 = new Snomed_Code__c();
					sc21.CRF__c = pss.CRF__c;
					sc21.TrialPatient__c = pss.TrialPatient__c;
					sc21.Name = 'IHTSDO_4594';
					sc21.Code_Master__c = sm.Id;
					SnomedCTCode.SnomedWrapper sw21 = SnomedCTCode.SnomedCode('IHTSDO_4594', pss.Lymph_node_dissection_done__c);
					sc21.Value__c = sw21.snomedCodeVal;
					sc21.caIntegratorValue__c = sw21.caIntegratorValue;
					sc21.Code_System__c = sw21.codeSystem;
					lstSnomed.add(sc21);
				}
			}
		}
		if(!lstSnomed.isEmpty()){
			insert lstSnomed;
		}
	}
	if(Trigger.isUpdate){
		set<Id> crfIds = new set<Id>();
		//set<Id> recIds = new set<Id>();
		//set<Id> dcisIds = new set<Id>();
		//set<Id> lcisIds = new set<Id>();
		//set<Id> invIds = new set<Id>();
		set<Id> proIds = new set<Id>();
		
		for(Post_Surgaory_Summary__c pss : Trigger.new){
			crfIds.add(pss.CRF__c);
			//recIds.add(pss.Receptors_Left__c);
			//recIds.add(pss.Receptors_Right__c);
			//dcisIds.add(pss.DCIS__c);
			//lcisIds.add(pss.LCIS__c);
			//invIds.add(pss.Invasive_Tumor_Detail__c);
		}
		List<Staging_Detail__c> lstStaging = [select id,Post_Surgery_Summary__c from Staging_Detail__c where Post_Surgery_Summary__c IN : Trigger.newMap.keySet()];
		List<Snomed_Code__c> lstSnomedCode = [select id,CRF__c,Value__c,Name from Snomed_Code__c where CRF__c IN : crfIds];
		//List<Receptors__c> lstRec = [select id,Post_Surgery_Summary__c,Estrogen_Receptor_Status__c,Progesterone_Receptor_Status__c,Fish__c,IHC__c from Receptors__c where Post_Surgery_Summary__c IN : Trigger.newMap.keySet()];
		List<DCIS__c> lstDCIS = [select Total_Histological_Span__c,Post_Surgery_Summary__c,id,Nuclear_Grade__c,Margin__c, Punctate_necrosis__c, Comedonecrosis__c, Papillary__c, Micropapillary__c, Necrosis__c, Cribiform__c, Cruciform__c, Clinging__c, Solid__c, Apocrine__c, Intra_cystic_encysted_papillary__c, Other__c,DCIS__c from DCIS__c where Post_Surgery_Summary__c IN : Trigger.newMap.keySet()];
		List<LCIS__c> lstLCIS = [select Total_histological_span__c ,LCIS__c, Post_Surgery_Summary__c from LCIS__c where Post_Surgery_Summary__c IN : Trigger.newMap.keySet()];
		List<Invasive_Tumor_Detail__c> lstInv = [select id,Post_Surgery_Summary__c,Lympatic_vascular_Invasion__c,Multi_focal_Tumor__c,Overall_cancer_cellularity__c,Invasive_margins__c from Invasive_Tumor_Detail__c where Post_Surgery_Summary__c IN : Trigger.newMap.keySet()];
		List<Procedure__c> lstPro = [select id,Procedure_Name__c, Post_Surgery_Summary__c from Procedure__c where Post_Surgery_Summary__c IN : Trigger.newMap.keySet()];
		List<Snomed_Code__c> lstSnomedCode1 = new List<Snomed_Code__c>();
		for(Post_Surgaory_Summary__c pss : Trigger.new){
			for(Snomed_Code__c sc : lstSnomedCode){
				if(sc.CRF__c == pss.CRF__c){
					if(sc.Name == '103338009'){
						if(pss.pcr__c){
							SnomedCTCode.SnomedWrapper sw = SnomedCTCode.SnomedCode('103338009', 'Yes');
							sc.Value__c = sw.snomedCodeVal;
							sc.Code_System__c = sw.codeSystem;
							sc.caIntegratorValue__c = sw.caIntegratorValue;
						} else {
							SnomedCTCode.SnomedWrapper sw = SnomedCTCode.SnomedCode('103338009', 'No');
							sc.Value__c = sw.snomedCodeVal;
							sc.Code_System__c = sw.codeSystem;
							sc.caIntegratorValue__c = sw.caIntegratorValue;
						}
					}
					if(pss.RCB_Class__c != null){
						if(sc.Name == 'IHTSDO_4575'){
							SnomedCTCode.SnomedWrapper sw = SnomedCTCode.SnomedCode('IHTSDO_4575', pss.RCB_Class__c);
							sc.Value__c = sw.snomedCodeVal;
							sc.Code_System__c = sw.codeSystem;
							sc.caIntegratorValue__c = sw.caIntegratorValue;
						}
					}
					if(sc.Name == '371510003 | proportion of specimen involved by tumour |'){
						if(pss.Is_invasive_tumor_present__c == 'Yes'){
							SnomedCTCode.SnomedWrapper sw = SnomedCTCode.SnomedCode('371510003 | proportion of specimen involved by tumour |', 'Present');
							sc.Value__c = sw.snomedCodeVal;
							sc.Code_System__c = sw.codeSystem;
							sc.caIntegratorValue__c = sw.caIntegratorValue;
						} else if(pss.Is_invasive_tumor_present__c == 'No'){
							SnomedCTCode.SnomedWrapper sw = SnomedCTCode.SnomedCode('371510003 | proportion of specimen involved by tumour |', 'Absent');
							sc.Value__c = sw.snomedCodeVal;
							sc.Code_System__c = sw.codeSystem;
							sc.caIntegratorValue__c = sw.caIntegratorValue;
					}
					
					if(sc.Name == 'IHTSDO_4595'){
						SnomedCTCode.SnomedWrapper sw = SnomedCTCode.SnomedCode('IHTSDO_4595', '');
						sc.Value__c = sw.snomedCodeVal;
						sc.Code_System__c = sw.codeSystem;
						sc.caIntegratorValue__c = sw.caIntegratorValue;
					}
					if(sc.Name == 'IHTSDO_4583_1'){
						SnomedCTCode.SnomedWrapper sw = SnomedCTCode.SnomedCode('IHTSDO_4583_1', 'No Surgery');
						sc.Value__c = sw.snomedCodeVal;
						sc.Code_System__c = sw.codeSystem;
						sc.caIntegratorValue__c = sw.caIntegratorValue;
					}
					if(sc.Name == 'IHTSDO_4583_2'){
						SnomedCTCode.SnomedWrapper sw = SnomedCTCode.SnomedCode('IHTSDO_4583_2', 'No Surgery');
						sc.Value__c = sw.snomedCodeVal;
						sc.Code_System__c = sw.codeSystem;
						sc.caIntegratorValue__c = sw.caIntegratorValue;
					}
					if(sc.Name == 'IHTSDO_4594'){
						SnomedCTCode.SnomedWrapper sw = SnomedCTCode.SnomedCode('IHTSDO_4594', pss.Lymph_node_dissection_done__c);
						sc.Value__c = sw.snomedCodeVal;
						sc.Code_System__c = sw.codeSystem;
						sc.caIntegratorValue__c = sw.caIntegratorValue;
					}
					if(sc.Name == 'IHTSDO_4567'){
						SnomedCTCode.SnomedWrapper sw = SnomedCTCode.SnomedCode('IHTSDO_4567', 'N/A');
						sc.Value__c = sw.snomedCodeVal;
						sc.Code_System__c = sw.codeSystem;
						sc.caIntegratorValue__c = sw.caIntegratorValue;
					}
						
				}
			}
			if(pss.Is_DCIS_Present__c == 'Yes' || pss.Is_LCIS_Present__c == 'Yes'){
				Snomed_Code__c sc = new Snomed_Code__c();
				sc.CRF__c = pss.CRF__c;
				sc.TrialPatient__c = pss.TrialPatient__c;
				sc.Name = '364708003';
				SnomedCTCode.SnomedWrapper sw = SnomedCTCode.SnomedCode('364708003', 'Yes');
				sc.Value__c = sw.snomedCodeVal;
				sc.Code_System__c = sw.codeSystem;
				sc.caIntegratorValue__c = sw.caIntegratorValue;
				lstSnomedCode1.add(sc);
			} else if(pss.Is_DCIS_Present__c == 'No' || pss.Is_LCIS_Present__c == 'No'){
				Snomed_Code__c sc = new Snomed_Code__c();
				sc.CRF__c = pss.CRF__c;
				sc.TrialPatient__c = pss.TrialPatient__c;
				sc.Name = '364708003';
				SnomedCTCode.SnomedWrapper sw = SnomedCTCode.SnomedCode('364708003', 'No');
				sc.Value__c = sw.snomedCodeVal;
				sc.Code_System__c = sw.codeSystem;
				sc.caIntegratorValue__c = sw.caIntegratorValue;
				lstSnomedCode1.add(sc);
			} else if(pss.Is_DCIS_Present__c == 'Not Reported' || pss.Is_LCIS_Present__c == 'Not Reported'){
				Snomed_Code__c sc = new Snomed_Code__c();
				sc.CRF__c = pss.CRF__c;
				sc.TrialPatient__c = pss.TrialPatient__c;
				sc.Name = '364708003';
				SnomedCTCode.SnomedWrapper sw = SnomedCTCode.SnomedCode('364708003', 'Not Reported');
				sc.Value__c = sw.snomedCodeVal;
				sc.Code_System__c = sw.codeSystem;
				sc.caIntegratorValue__c = sw.caIntegratorValue;
				lstSnomedCode1.add(sc);
			} else {
				Snomed_Code__c sc = new Snomed_Code__c();
				sc.CRF__c = pss.CRF__c;
				sc.TrialPatient__c = pss.TrialPatient__c;
				sc.Name = '364708003';
				SnomedCTCode.SnomedWrapper sw = SnomedCTCode.SnomedCode('364708003', 'No Surgery');
				sc.Value__c = sw.snomedCodeVal;
				sc.Code_System__c = sw.codeSystem;
				sc.caIntegratorValue__c = sw.caIntegratorValue;
				lstSnomedCode1.add(sc);
			}
		}
		if(!lstSnomedCode1.isEmpty()){
			upsert lstSnomedCode1;
		}
		if(!lstSnomedCode.isEmpty()){ 
			upsert lstSnomedCode;
		}
	}*/
}