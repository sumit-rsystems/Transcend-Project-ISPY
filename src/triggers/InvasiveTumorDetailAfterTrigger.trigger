trigger InvasiveTumorDetailAfterTrigger on Invasive_Tumor_Detail__c (after insert, after update) {
	
	/*
	//commented because logic changed this method will called from its parent's future method
	if(Trigger.isUpdate) {
		Set<Id> postIds = new Set<Id>();
		Set<Id> ospIds = new Set<Id>();
		for(Invasive_Tumor_Detail__c inv : trigger.new) {
			postIds.add(inv.Post_Surgery_Summary__c);
			ospIds.add(inv.On_Study_Pathology_Form__c);
		}
		
		List<Post_Surgaory_Summary__c> lstPostSur = [select CRF__c, TrialPatient__c from Post_Surgaory_Summary__c where Id IN :postIds];
		List<On_Study_Pathology_Form__c> lstOnStudyPath = [select CRF__c, TrialPatient__c from On_Study_Pathology_Form__c where Id IN :ospIds];
		
		Set<Id> CRFIds = new Set<Id>();
		for(Post_Surgaory_Summary__c pss : lstPostSur) {
			CRFIds.add(pss.CRF__c);
		}
		for(On_Study_Pathology_Form__c osp : lstOnStudyPath) {
			CRFIds.add(osp.CRF__c);
		}
		
		List<Snomed_Code__c> snomedCodeList = [select id from Snomed_Code__c where CRF__c in :crfIds and snomed_Code_Name__c IN ('395715009 | status of lymphatic (small vessel) invasion by tumour |'
										, 'IHTSDO_4570', '396631001 | surgical margin observable |', '396984004 | histologic feature of tumor |'
										, 'IHTSDO_4572', '396785008 | metastatic tumor, histologic type |', '371469007 | histologic grade |')];
		if(!snomedCodeList.isEmpty()) {
			delete snomedCodeList;
		}
	}
	
	SnomedCTCode.insertInvasiveTumorRelatedCodes(Trigger.newMap.keySet());*/
	/*Set<Id> postIds = new Set<Id>();
	Set<Id> ospIds = new Set<Id>();
	for(Invasive_Tumor_Detail__c inv : Trigger.New) {
		postIds.add(inv.Post_Surgery_Summary__c);
		ospIds.add(inv.On_Study_Pathology_Form__c);
	}
	
	List<Post_Surgaory_Summary__c> lstPostSur = [select CRF__c, TrialPatient__c, Is_invasive_tumor_present__c,Is_DCIS_Present__c ,Is_LCIS_Present__c ,(Select Id, OwnerId, IsDeleted, Name, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, Location__c, Procedure_Name__c, Laterality__c, Form_Name__c, Date_Of_Procedure__c, Node_Result__c, Node_Type__c, Ultrasound__c, Palpation_guided__c, Mammography__c, MRI__c, Stereotactic__c, Post_Surgery_Summary__c, TrialPatient__c, On_Study_Pathology_Form__c, Total_Positive__c, Total_Examined_Nodes__c From Procedures__r), (Select Id, OwnerId, IsDeleted, Name, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, DCIS__c, Unknown_Not_Reported__c, Tumor_Size__c, Present_in_continous_section__c, Spanning__c, Present_as_scattered_microscopic_foci__c, Microscopic_foci_upto__c, From_Slide__c, To_Slide__c, Deep_Margin__c, Deep_Margin_Size__c, Medical__c, Medical_Size__c, Lateral__c, Lateral_Size__c, Anterior_Superior__c, Anterior_Superior_Size__c, Anterior_Inferior__c, Anterior_Inferior_Size__c, Punctate_necrosis__c, Comedonecrosis__c, Papillary__c, Micropapillary__c, Necrosis__c, Cribiform__c, Cruciform__c, Clinging__c, Solid__c, Apocrine__c, Intra_cystic_encysted_papillary__c, Calcifications__c, Nuclear_Grade__c, Total_Histological_Span__c, Total_Histological_Span_Measurement_Unit__c, Margin__c, Closest_Margin__c, Specific_Closest_Margin__c, Specific_Closest_Margin_Measurement_Unit__c, Other__c, Other_if_other_mention_type_in_textb__c, Calcifications_Present__c, On_Study_Pathology_Form__c, Post_Surgery_Summary__c From DCIS__r) from Post_Surgaory_Summary__c where Id IN :postIds];
	List<On_Study_Pathology_Form__c> lstOnStudyPath = [select CRF__c, TrialPatient__c from On_Study_Pathology_Form__c where Id IN :ospIds];
	
	if(Trigger.isInsert) {
		List<Snomed_Code__c> lstSnomed = new List<Snomed_Code__c>();
		List<Code_Master__c> lstSnomedMaster = [select id,Name,Variable_Description__c from Code_Master__c where Name = 'LVI_PS' 
		or Name = 'InvMultifocal_PS' or Name = 'InvMargin_PS' or Name = 'InvHistology_PS' or Name = 'InvHistology_OSInvasive' or Name = 'InvSBR_OS'];
		
		Map<String, Code_Master__c> snomedMasterMap = new Map<String, Code_Master__c>();
		for(Code_Master__c sm : lstSnomedMaster) {
			snomedMasterMap.put(sm.Name, sm);
		}
		
		for(Invasive_Tumor_Detail__c inv : trigger.new){
			for(Code_Master__c sm : lstSnomedMaster){
				for(Post_Surgaory_Summary__c pss : lstPostSur) {
					if(inv.Post_Surgery_Summary__c == pss.Id) {
						if(sm.Name == 'LVI_PS'){
							Snomed_Code__c sc16 = new Snomed_Code__c();
							sc16.CRF__c = pss.CRF__c;
							sc16.TrialPatient__c = pss.TrialPatient__c;
							sc16.Name = '395715009';
							sc16.Code_Master__c = sm.Id;
							SnomedCTCode.SnomedWrapper sw16 = SnomedCTCode.SnomedCode('395715009', inv.Lympatic_vascular_Invasion__c);
							sc16.Value__c = sw16.snomedCodeVal;
							sc16.caIntegratorValue__c = sw16.caIntegratorValue;
							sc16.Code_System__c = sw16.codeSystem;
							lstSnomed.add(sc16);
						}
						if(sm.Name == 'InvMultifocal_PS'){
							Snomed_Code__c sc17 = new Snomed_Code__c();
							sc17.CRF__c = pss.CRF__c;
							sc17.TrialPatient__c = pss.TrialPatient__c;
							sc17.Name = 'IHTSDO_4570';
							sc17.Code_Master__c = sm.Id;
							SnomedCTCode.SnomedWrapper sw17 = SnomedCTCode.SnomedCode('IHTSDO_4570', inv.Multi_focal_Tumor__c);
							sc17.Value__c = sw17.snomedCodeVal;
							sc17.caIntegratorValue__c = sw17.caIntegratorValue;
							sc17.Code_System__c = sw17.codeSystem;
							lstSnomed.add(sc17);
						}
						if(sm.Name == 'InvMargin_PS'){
							if(pss.DCIS__r.Size()<=0 && pss.Procedures__r.Size()<=0) continue; 
							List<DCIS__c> dcisList = pss.DCIS__r;
							List<Procedure__c> lstPro = pss.Procedures__r;
							for(DCIS__c dcis : dcisList) {
								for(Procedure__c pro : lstPro){
									if(dcis.Post_Surgery_Summary__c == pss.Id && pro.Post_Surgery_Summary__c == pss.Id) {
										Snomed_Code__c sc19 = new Snomed_Code__c();
										sc19.CRF__c = pss.CRF__c;
										sc19.TrialPatient__c = pss.TrialPatient__c;
										sc19.Name = '396631001';
										sc19.Code_Master__c = sm.Id;
										Snomed_Code__c scodeValue = PostSurgeryChildsSnomedController.histologySnomed(dcis, inv, pro, pss, sc19);
										//SnomedCTCode.SnomedWrapper sw19 = SnomedCTCode.SnomedCode('396631001', '');
										sc19.Value__c = scodeValue.Value__c;
										sc19.caIntegratorValue__c = scodeValue.caIntegratorValue__c;
										sc19.Code_System__c = scodeValue.Code_System__c;
										lstSnomed.add(sc19);
									}
								}
							}
						}
						if(sm.Name == 'InvHistology_PS'){
							Snomed_Code__c sc22 = new Snomed_Code__c();
							sc22.CRF__c = pss.CRF__c;
							sc22.TrialPatient__c = pss.TrialPatient__c;
							sc22.Name = '396984004';
							sc22.Code_Master__c = sm.Id;
							SnomedCTCode.SnomedWrapper sw22 = SnomedCTCode.SnomedCode('396984004', ''); //Value for this variable will be update when updateTrigger will fire.
							sc22.Value__c = sw22.snomedCodeVal;
							sc22.caIntegratorValue__c = sw22.caIntegratorValue;
							sc22.Code_System__c = sw22.codeSystem;
							lstSnomed.add(sc22);
						}
						if(inv.Multi_focal_Tumor__c != null){
							Snomed_Code__c sc18 = new Snomed_Code__c();
							sc18.CRF__c = pss.CRF__c;
							sc18.TrialPatient__c = pss.TrialPatient__c;
							sc18.Name = 'IHTSDO_4572';
							SnomedCTCode.SnomedWrapper sw18 = SnomedCTCode.SnomedCode('IHTSDO_4572', 'Numerical value');
							sc18.Value__c = sw18.snomedCodeVal;
							sc18.caIntegratorValue__c = sw18.caIntegratorValue;
							sc18.Code_System__c = sw18.codeSystem;
							lstSnomed.add(sc18);
						}
					}
				}
				for(On_Study_Pathology_Form__c osp : lstOnStudyPath) {
					if(inv.On_Study_Pathology_Form__c == osp.Id) {
						if(sm.Name == 'InvHistology_OSInvasive'){
							Snomed_Code__c scNew = new Snomed_Code__c();
							scNew.CRF__c = osp.CRF__c;
							scNew.TrialPatient__c = osp.TrialPatient__c;
							scNew.Name = '396785008';
							scNew.Code_Master__c = snomedMasterMap.get('InvHistology_OSInvasive').Id;
							SnomedCTCode.SnomedWrapper sw = new SnomedCTCode.SnomedWrapper();
							//At the time of insertion we are considering the Grade value is empty. but on update it will be updated by actual value.
							if(inv.Other__c) {
								sw = SnomedCTCode.SnomedCode('396785008', 'Other');  
							}
							scNew.Code_System__c = sw.codeSystem;
							scNew.caIntegratorValue__c = sw.caIntegratorValue;
							lstSnomed.add(scNew);
						}
						if(sm.Name == 'InvSBR_OS'){
							Snomed_Code__c scNew1 = new Snomed_Code__c();
							scNew1.CRF__c = osp.CRF__c;
							scNew1.TrialPatient__c = osp.TrialPatient__c;
							scNew1.Name = '371469007';
							scNew1.Code_Master__c = snomedMasterMap.get('InvSBR_OS').Id;
							//At the time of insertion we are considering the Grade value is empty. but on update it will be updated by actual value.
							SnomedCTCode.SnomedWrapper sw = SnomedCTCode.SnomedCode('371469007', inv.Nuclear_Grade__c);  
							scNew1.Code_System__c = sw.codeSystem;
							scNew1.caIntegratorValue__c = sw.caIntegratorValue;
							lstSnomed.add(scNew1);
						}
					}
				}
			}
		}
		if(!lstSnomed.isEmpty()){
			insert lstSnomed;
		}
	}
	
	if(Trigger.isUpdate) {
		Set<Id> CRFIds = new Set<Id>();
		for(Post_Surgaory_Summary__c pss : lstPostSur) {
			CRFIds.add(pss.CRF__c);
		}
		for(On_Study_Pathology_Form__c osp : lstOnStudyPath) {
			CRFIds.add(osp.CRF__c);
		}
		
		List<Snomed_Code__c> lstSnomedCode = [select id,CRF__c,Value__c,Name from Snomed_Code__c where CRF__c IN : CRFIds];
		for(Invasive_Tumor_Detail__c inv : Trigger.New) {
			for(Snomed_Code__c sc : lstSnomedCode){
				for(Post_Surgaory_Summary__c pss : lstPostSur){
					if(inv.Post_Surgery_Summary__c == pss.Id && sc.CRF__c == pss.CRF__c) {
						if(sc.Name == '395715009'){
							SnomedCTCode.SnomedWrapper sw = SnomedCTCode.SnomedCode('395715009', inv.Lympatic_vascular_Invasion__c);
							sc.Value__c = sw.snomedCodeVal;
							sc.Code_System__c = sw.codeSystem;
							sc.caIntegratorValue__c = sw.caIntegratorValue;
						}
						if(sc.Name == 'IHTSDO_4570'){
							SnomedCTCode.SnomedWrapper sw = SnomedCTCode.SnomedCode('IHTSDO_4570', inv.Multi_focal_Tumor__c);
							sc.Value__c = sw.snomedCodeVal;
							sc.Code_System__c = sw.codeSystem;
							sc.caIntegratorValue__c = sw.caIntegratorValue;
						}
						if(sc.Name == '396631001'){
							if(pss.DCIS__r.Size()<=0 && pss.Procedures__r.Size()<=0) continue; 
							List<DCIS__c> dcisList = pss.DCIS__r;
							List<Procedure__c> lstPro = pss.Procedures__r;
							for(DCIS__c dcis : dcisList) {
								for(Procedure__c pro : lstPro){
									if(dcis.Post_Surgery_Summary__c == pss.Id && pro.Post_Surgery_Summary__c == pss.Id) {
										Snomed_Code__c scodeValue = PostSurgeryChildsSnomedController.histologySnomed(dcis, inv, pro, pss, sc);
										sc.Value__c = scodeValue.Value__c;
										sc.caIntegratorValue__c = scodeValue.caIntegratorValue__c;
										sc.Code_System__c = scodeValue.Code_System__c;
									}
								}
							}
						}
						if(sc.Name == '396984004'){
							SnomedCTCode.SnomedWrapper sw = SnomedCTCode.SnomedCode('396984004', '');
							sc.Value__c = sw.snomedCodeVal;
							sc.Code_System__c = sw.codeSystem;
							sc.caIntegratorValue__c = sw.caIntegratorValue;
						}
						if(sc.Name == 'IHTSDO_4572'){
							if(inv.Multi_focal_Tumor__c != null){
								SnomedCTCode.SnomedWrapper sw = SnomedCTCode.SnomedCode('IHTSDO_4572', 'Numerical value');
								sc.Value__c = sw.snomedCodeVal;
								sc.Code_System__c = sw.codeSystem;
								sc.caIntegratorValue__c = sw.caIntegratorValue;
							}
						}
					}
				}
				
				for(On_Study_Pathology_Form__c osp : lstOnStudyPath) {
					if(inv.On_Study_Pathology_Form__c == osp.Id && sc.CRF__c == osp.CRF__c) {
						if(sc.Name == '396785008') {
							SnomedCTCode.SnomedWrapper sw = new SnomedCTCode.SnomedWrapper();
							if(inv.Other__c) {
								sw = SnomedCTCode.SnomedCode('396785008', 'Other');
							}
							sc.Value__c = sw.snomedCodeVal;
							sc.Code_System__c = sw.codeSystem;
							sc.caIntegratorValue__c = sw.caIntegratorValue;
						}
						if(sc.Name == '371469007') {
							SnomedCTCode.SnomedWrapper sw = SnomedCTCode.SnomedCode('371469007', inv.Nuclear_Grade__c);
							sc.Value__c = sw.snomedCodeVal;
							sc.Code_System__c = sw.codeSystem;
							sc.caIntegratorValue__c = sw.caIntegratorValue;
						}
					}
				}
			}
		}
		if(!lstSnomedCode.isEmpty()){ 
			upsert lstSnomedCode;
		}
	}*/
}