trigger DCISAfterInsertTrigger on DCIS__c (after insert, after update) {
	
	/*
	//commented because logic changed this method will called from its parent's future method
	if(Trigger.isUpdate) {
		Set<Id> postIds = new Set<Id>();
		for(DCIS__c dcis : trigger.new) {
			postIds.add(dcis.Post_Surgery_Summary__c);
		}
		List<Post_Surgaory_Summary__c> lstPostSur = [select CRF__c, TrialPatient__c from Post_Surgaory_Summary__c where Id IN :postIds];
		Set<Id> CRFIds = new Set<Id>();
		for(Post_Surgaory_Summary__c pss : lstPostSur) {
			CRFIds.add(pss.CRF__c);
		}
		List<Snomed_Code__c> lstSnomedCode = [select id,CRF__c,Value__c,Name from Snomed_Code__c where CRF__c IN : CRFIds and snomed_Code_Name__c IN ('371469007 | histologic grade | ', 
											'33731-1', 'IHTSDO_4678', '396631001 | surgical margin observable |')];
		if(!lstSnomedCode.isEmpty()) {
			delete lstSnomedCode;
		}
	}
	SnomedCTCode.insertDCISRelatedCodes(Trigger.newMap.keySet());*/
	/*Set<Id> postIds = new Set<Id>();
	for(DCIS__c dcis : trigger.new) {
		postIds.add(dcis.Post_Surgery_Summary__c);
	}
	List<Post_Surgaory_Summary__c> lstPostSur = [select CRF__c, TrialPatient__c,Is_invasive_tumor_present__c,Is_DCIS_Present__c ,Is_LCIS_Present__c ,(Select Id, OwnerId, IsDeleted, Name, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, Location__c, Procedure_Name__c, Laterality__c, Form_Name__c, Date_Of_Procedure__c, Node_Result__c, Node_Type__c, Ultrasound__c, Palpation_guided__c, Mammography__c, MRI__c, Stereotactic__c, Post_Surgery_Summary__c, TrialPatient__c, On_Study_Pathology_Form__c, Total_Positive__c, Total_Examined_Nodes__c From Procedures__r), (Select Id, OwnerId, IsDeleted, Name, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, Multi_focal_Tumor__c, Tumor_Size_Height__c, Tumor_Size_Width__c, Tumor_Measurement_Unit__c, Deep_Margin__c, Deep_Margin_Size__c, Medical__c, Medical_Size__c, Lateral__c, Lateral_Size__c, Anterior_Superior__c, Anterior_Superior_Size__c, Anterior_Inferior__c, Anterior_Inferior_Size__c, Invasive_ductal_carcinoma_nos__c, Tubular_carcinoma__c, Mucinous_carcinoma__c, Invasive_lobular_carcinoma_alveolar_type__c, Medullary_carcinoma__c, Pleomorphic_lobular_carcinoma__c, Invasive_papillary_carcinoma__c, Invasive_cribiform_carcinoma__c, Invasive_carcinoma_mixed_ductal_lobular__c, Other__c, Signs_of_Treatment_Effect__c, Calcifications__c, Nuclear_Grade__c, Mitotic_Count__c, Tubule_Papilla_formation__c, Lympatic_vascular_Invasion__c, Skin_Involvement__c, Other_changes_present__c, Evidence_of_therapeutic_effects__c, Muscle_involvement__c, Dermal_Involvement__c, Invasive_lobular_carcinoma_classic_type__c, Tubulolobular_carcinoma__c, Invasive_margins__c, Closest_Margin__c, Overall_cancer_cellularity__c, Unknown_Not_Reported__c, Other_if_other_mention_type_in_textbox__c, Tumor_Size__c, Invasive_margins_size__c, Specify_No__c, Specify_Units__c, Total_Points__c, SBR_Grade__c, Paget_disease__c, Ulceration_by_tumor__c, Derma_lymphatic_vascular_invasion__c, Calcifications_Present__c, Histology__c, On_Study_Pathology_Form__c, Post_Surgery_Summary__c From Invasive_Tumor_Details__r) from Post_Surgaory_Summary__c where Id IN :postIds];
	
	if(Trigger.isInsert) {
		List<Snomed_Code__c> lstSnomed = new List<Snomed_Code__c>();
		List<Code_Master__c> lstSnomedMaster = [select id,Name,Variable_Description__c from Code_Master__c where Name = 'DCISGrade_PS' 
		or Name = 'InvMargin_PS' or Name = 'InvHistology_PS' or Name = 'DCISHistology_PS' or Name = 'DCISspan_PS'];
		for(Post_Surgaory_Summary__c pss : lstPostSur) {
			for(DCIS__c dcis : trigger.new){
				if(dcis.Post_Surgery_Summary__c == pss.Id) {
					for(Code_Master__c sm : lstSnomedMaster){
						if(sm.Name == 'DCISGrade_PS'){
							Snomed_Code__c sc13 = new Snomed_Code__c();
							sc13.CRF__c = pss.CRF__c;
							sc13.TrialPatient__c = pss.TrialPatient__c;
							sc13.Name = '371469007';
							sc13.Code_Master__c = sm.Id;
							SnomedCTCode.SnomedWrapper sw13 = SnomedCTCode.SnomedCode('371469007', dcis.Nuclear_Grade__c);
							sc13.Value__c = sw13.snomedCodeVal;
							sc13.Code_System__c = sw13.codeSystem;
							sc13.caIntegratorValue__c = sw13.caIntegratorValue;
							lstSnomed.add(sc13);
						}
						if(sm.Name == 'DCISHistology_PS'){
							SnomedCTCode.SnomedWrapper sw = new SnomedCTCode.SnomedWrapper();
							if(dcis.Punctate_necrosis__c) {
								Snomed_Code__c sc22 = new Snomed_Code__c();
								sc22.CRF__c = pss.CRF__c;
								sc22.TrialPatient__c = pss.TrialPatient__c;
								sc22.Name = '33731-1';
								sc22.Code_Master__c = sm.Id;
								sw = SnomedCTCode.SnomedCode('33731-1', 'Punctuate Necrosis');
								sc22.caIntegratorValue__c = sw.caIntegratorValue;
								lstSnomed.add(sc22);
							}
							if(dcis.Comedonecrosis__c) {
								Snomed_Code__c sc22 = new Snomed_Code__c();
								sc22.CRF__c = pss.CRF__c;
								sc22.TrialPatient__c = pss.TrialPatient__c;
								sc22.Name = '33731-1';
								sc22.Code_Master__c = sm.Id;
								sw = SnomedCTCode.SnomedCode('33731-1', 'Comedonecrosis');
								sc22.caIntegratorValue__c = sw.caIntegratorValue;
								lstSnomed.add(sc22);
							}
							if(dcis.Papillary__c) {
								Snomed_Code__c sc22 = new Snomed_Code__c();
								sc22.CRF__c = pss.CRF__c;
								sc22.TrialPatient__c = pss.TrialPatient__c;
								sc22.Name = '33731-1';
								sc22.Code_Master__c = sm.Id;
								sw = SnomedCTCode.SnomedCode('33731-1', 'Papillary');
								sc22.caIntegratorValue__c = sw.caIntegratorValue;
								lstSnomed.add(sc22);
							}
							if(dcis.Micropapillary__c) {
								Snomed_Code__c sc22 = new Snomed_Code__c();
								sc22.CRF__c = pss.CRF__c;
								sc22.TrialPatient__c = pss.TrialPatient__c;
								sc22.Name = '33731-1';
								sc22.Code_Master__c = sm.Id;
								sw = SnomedCTCode.SnomedCode('33731-1', 'Micropapillary');
								sc22.caIntegratorValue__c = sw.caIntegratorValue;
								lstSnomed.add(sc22);
							}
							if(dcis.Necrosis__c) {
								Snomed_Code__c sc22 = new Snomed_Code__c();
								sc22.CRF__c = pss.CRF__c;
								sc22.TrialPatient__c = pss.TrialPatient__c;
								sc22.Name = '33731-1';
								sc22.Code_Master__c = sm.Id;
								sw = SnomedCTCode.SnomedCode('33731-1', 'Necrosis');
								sc22.caIntegratorValue__c = sw.caIntegratorValue;
								lstSnomed.add(sc22);
							}
							if(dcis.Cribiform__c) {
								Snomed_Code__c sc22 = new Snomed_Code__c();
								sc22.CRF__c = pss.CRF__c;
								sc22.TrialPatient__c = pss.TrialPatient__c;
								sc22.Name = '33731-1';
								sc22.Code_Master__c = sm.Id;
								sw = SnomedCTCode.SnomedCode('33731-1', 'Cribiform');
								sc22.caIntegratorValue__c = sw.caIntegratorValue;
								lstSnomed.add(sc22);
							}
							if(dcis.Cruciform__c) {
								Snomed_Code__c sc22 = new Snomed_Code__c();
								sc22.CRF__c = pss.CRF__c;
								sc22.TrialPatient__c = pss.TrialPatient__c;
								sc22.Name = '33731-1';
								sc22.Code_Master__c = sm.Id;
								sw = SnomedCTCode.SnomedCode('33731-1', 'Cruciform');
								sc22.caIntegratorValue__c = sw.caIntegratorValue;
								lstSnomed.add(sc22);
							}
							if(dcis.Clinging__c) {
								Snomed_Code__c sc22 = new Snomed_Code__c();
								sc22.CRF__c = pss.CRF__c;
								sc22.TrialPatient__c = pss.TrialPatient__c;
								sc22.Name = '33731-1';
								sc22.Code_Master__c = sm.Id;
								sw = SnomedCTCode.SnomedCode('33731-1', 'Clinging');
								sc22.caIntegratorValue__c = sw.caIntegratorValue;
								lstSnomed.add(sc22);
							}
							if(dcis.Solid__c) {
								Snomed_Code__c sc22 = new Snomed_Code__c();
								sc22.CRF__c = pss.CRF__c;
								sc22.TrialPatient__c = pss.TrialPatient__c;
								sc22.Name = '33731-1';
								sc22.Code_Master__c = sm.Id;
								sw = SnomedCTCode.SnomedCode('33731-1', 'Solid');
								sc22.caIntegratorValue__c = sw.caIntegratorValue;
								lstSnomed.add(sc22);
							}
							if(dcis.Apocrine__c) {
								Snomed_Code__c sc22 = new Snomed_Code__c();
								sc22.CRF__c = pss.CRF__c;
								sc22.TrialPatient__c = pss.TrialPatient__c;
								sc22.Name = '33731-1';
								sc22.Code_Master__c = sm.Id;
								sw = SnomedCTCode.SnomedCode('33731-1', 'Apocrine');
								sc22.caIntegratorValue__c = sw.caIntegratorValue;
								lstSnomed.add(sc22);
							}
							if(dcis.Intra_cystic_encysted_papillary__c) {
								Snomed_Code__c sc22 = new Snomed_Code__c();
								sc22.CRF__c = pss.CRF__c;
								sc22.TrialPatient__c = pss.TrialPatient__c;
								sc22.Name = '33731-1';
								sc22.Code_Master__c = sm.Id;
								sw = SnomedCTCode.SnomedCode('33731-1', 'Intra-cystic');
								sc22.caIntegratorValue__c = sw.caIntegratorValue;
								lstSnomed.add(sc22);
							}
							if(dcis.Other__c) {
								Snomed_Code__c sc22 = new Snomed_Code__c();
								sc22.CRF__c = pss.CRF__c;
								sc22.TrialPatient__c = pss.TrialPatient__c;
								sc22.Name = '33731-1';
								sc22.Code_Master__c = sm.Id;
								sw = SnomedCTCode.SnomedCode('33731-1', 'Other');
								sc22.caIntegratorValue__c = sw.caIntegratorValue;
								lstSnomed.add(sc22);
							}
						}
						if(sm.Name == 'DCISspan_PS'){
							Snomed_Code__c sc24 = new Snomed_Code__c();
							sc24.CRF__c = pss.CRF__c;
							sc24.TrialPatient__c = pss.TrialPatient__c;
							sc24.Name = 'IHTSDO_4678';
							sc24.Code_Master__c = sm.Id;
							SnomedCTCode.SnomedWrapper sw24 = SnomedCTCode.SnomedCode('IHTSDO_4678', dcis.Total_Histological_Span__c+''); 
							sc24.Value__c = sw24.snomedCodeVal;
							sc24.caIntegratorValue__c = sw24.caIntegratorValue;
							sc24.Code_System__c = sw24.codeSystem;
							lstSnomed.add(sc24);
						}
						if(sm.Name == 'InvMargin_PS'){
							//List<Invasive_Tumor_Detail__c> invList = [select id,Post_Surgery_Summary__c,Lympatic_vascular_Invasion__c,Multi_focal_Tumor__c,Overall_cancer_cellularity__c,Invasive_margins__c from Invasive_Tumor_Detail__c where Post_Surgery_Summary__c IN :postIds];
							//List<Procedure__c> lstPro = [select id,Procedure_Name__c, Post_Surgery_Summary__c from Procedure__c where Post_Surgery_Summary__c IN : postIds];
							if(pss.Invasive_Tumor_Details__r.Size()<=0 && pss.Procedures__r.Size()<=0) continue; 
							List<Invasive_Tumor_Detail__c> invList = pss.Invasive_Tumor_Details__r;
							List<Procedure__c> lstPro = pss.Procedures__r;
							for(Invasive_Tumor_Detail__c inv : invList) {
								for(Procedure__c pro : lstPro){
									if(inv.Post_Surgery_Summary__c == pss.Id && pro.Post_Surgery_Summary__c == pss.Id) {
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
		List<Snomed_Code__c> lstSnomedCode = [select id,CRF__c,Value__c,Name from Snomed_Code__c where CRF__c IN : CRFIds];
		for(Post_Surgaory_Summary__c pss : lstPostSur){
			for(DCIS__c dcis : Trigger.New) {
				if(dcis.Post_Surgery_Summary__c == pss.Id) {
					for(Snomed_Code__c sc : lstSnomedCode){
						if(sc.CRF__c == pss.CRF__c) {
							if(sc.Name == '371469007'){
								SnomedCTCode.SnomedWrapper sw = SnomedCTCode.SnomedCode('371469007', dcis.Nuclear_Grade__c);
								sc.Value__c = sw.snomedCodeVal;
								sc.Code_System__c = sw.codeSystem;
								sc.caIntegratorValue__c = sw.caIntegratorValue;
							}
							if(sc.Name == 'IHTSDO_4678'){ 
								SnomedCTCode.SnomedWrapper swSpan = SnomedCTCode.SnomedCode('IHTSDO_4678', dcis.Total_Histological_Span__c+'');
								sc.Value__c = swSpan.snomedCodeVal;
								sc.Code_System__c = swSpan.codeSystem;
								sc.caIntegratorValue__c = swSpan.caIntegratorValue;
							}
							if(sc.Name == '396631001'){
								//List<Invasive_Tumor_Detail__c> invList = [select id,Post_Surgery_Summary__c,Lympatic_vascular_Invasion__c,Multi_focal_Tumor__c,Overall_cancer_cellularity__c,Invasive_margins__c from Invasive_Tumor_Detail__c where Post_Surgery_Summary__c IN :postIds];
								//List<Procedure__c> lstPro = [select id,Procedure_Name__c, Post_Surgery_Summary__c from Procedure__c where Post_Surgery_Summary__c IN : postIds];
								if(pss.Invasive_Tumor_Details__r.Size()<=0 && pss.Procedures__r.Size()<=0) continue; 
								List<Invasive_Tumor_Detail__c> invList = pss.Invasive_Tumor_Details__r;
								List<Procedure__c> lstPro = pss.Procedures__r;
								for(Invasive_Tumor_Detail__c inv : invList) {
									for(Procedure__c pro : lstPro){
										if(inv.Post_Surgery_Summary__c == pss.Id && pro.Post_Surgery_Summary__c == pss.Id) {
											Snomed_Code__c scodeValue = PostSurgeryChildsSnomedController.histologySnomed(dcis, inv, pro, pss, sc);
											sc.Value__c = scodeValue.Value__c;
											sc.caIntegratorValue__c = scodeValue.caIntegratorValue__c;
											sc.Code_System__c = scodeValue.Code_System__c;
										}
									}
								}
							}
							if(sc.Name == '33731-1'){
								SnomedCTCode.SnomedWrapper sw = new SnomedCTCode.SnomedWrapper();
								sc.caIntegratorValue__c = '';
								if(dcis.Punctate_necrosis__c) {
									sw = SnomedCTCode.SnomedCode('33731-1', 'Punctuate Necrosis');
									sc.caIntegratorValue__c += sw.caIntegratorValue+',';
								}
								if(dcis.Comedonecrosis__c) {
									sw = SnomedCTCode.SnomedCode('33731-1', 'Comedonecrosis');
									sc.caIntegratorValue__c += sw.caIntegratorValue+',';
								}
								if(dcis.Papillary__c) {
									sw = SnomedCTCode.SnomedCode('33731-1', 'Papillary');
									sc.caIntegratorValue__c += sw.caIntegratorValue+',';
								}
								if(dcis.Micropapillary__c) {
									sw = SnomedCTCode.SnomedCode('33731-1', 'Micropapillary');
									sc.caIntegratorValue__c += sw.caIntegratorValue+',';
								}
								if(dcis.Necrosis__c) {
									sw = SnomedCTCode.SnomedCode('33731-1', 'Necrosis');
									sc.caIntegratorValue__c += sw.caIntegratorValue+',';
								}
								if(dcis.Cribiform__c) {
									sw = SnomedCTCode.SnomedCode('33731-1', 'Cribiform');
									sc.caIntegratorValue__c += sw.caIntegratorValue+',';
								}
								if(dcis.Cruciform__c) {
									sw = SnomedCTCode.SnomedCode('33731-1', 'Cruciform');
									sc.caIntegratorValue__c += sw.caIntegratorValue+',';
								}
								if(dcis.Clinging__c) {
									sw = SnomedCTCode.SnomedCode('33731-1', 'Clinging');
									sc.caIntegratorValue__c += sw.caIntegratorValue+',';
								}
								if(dcis.Solid__c) {
									sw = SnomedCTCode.SnomedCode('33731-1', 'Solid');
									sc.caIntegratorValue__c += sw.caIntegratorValue+',';
								}
								if(dcis.Apocrine__c) {
									sw = SnomedCTCode.SnomedCode('33731-1', 'Apocrine');
									sc.caIntegratorValue__c += sw.caIntegratorValue+',';
								}
								if(dcis.Intra_cystic_encysted_papillary__c) {
									sw = SnomedCTCode.SnomedCode('33731-1', 'Intra-cystic');
									sc.caIntegratorValue__c += sw.caIntegratorValue+',';
								}
								if(dcis.Other__c) {
									sw = SnomedCTCode.SnomedCode('33731-1', 'Other');
									sc.caIntegratorValue__c += sw.caIntegratorValue+',';
								}
								sc.Value__c = sw.snomedCodeVal;
								sc.Code_System__c = sw.codeSystem;
							}
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