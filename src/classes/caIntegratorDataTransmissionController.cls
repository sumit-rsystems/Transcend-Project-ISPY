public with sharing class caIntegratorDataTransmissionController {
	
	public String csvContents {get;set;}
	List<Id> sIds = new List<Id>();
	String birthCountryId = '';
	
	public caIntegratorDataTransmissionController() {
		//csvContents = generateCaIntegratorCSVTitle() + generateCaIntegratorDataForPatient();
		generateCaIntegratorCSVTitle();
	}
	
	public void generateCaIntegratorDataForPatient(Id tpId) {
		
		String values = '';
		List<snomedWrapper> lstSnomedWrapper = new List<snomedWrapper>();
		
		List<TrialPatient__c> tpList = [Select t.Patient_Id__r.Id, t.Patient_Id__c,t.Subject_Id__c,
			(Select Date_of_therapy__c From Chemo_Treatments__r where Status__c = 'Accepted' order by Date_of_therapy__c asc limit 1),
			(Select Distant_progression_Date__c, End_Date__c, Local_progression_Date__c, Status__c,Survival_Status__c From Followup_Forms__r where Status__c = 'Accepted' and (Distant_progression_Date__c != null or Local_progression_Date__c != null ) order by End_Date__c asc),
			(Select o.Screening_Memogram_Prior_to_Mass_Detect__c,o.Most_Recent_Date__c,o.Status__c,o.How_was_the_cancer_first_detected__c, o.Mass_Identification_Date__c From On_Study_Eligibility_Forms__r o where status__c = 'Accepted'),
			(Select H1_H2_status__c, MammaPrint_Index__c, MammaPrint_Risk__c, TargetPrint_Her_2_Index__c, TargetPrint_Her_2_Status__c,Risk_Category__c From MammaPrint_Details__r where status__c = 'Approval Not Required'),
			(Select Longest_Diameter_Of_Index_Lesion_in_cm__c, MRI_Volume_in_cm3__c, Time_Point__c From MRI_Volumes__r where status__c = 'Accepted'),
			(Select Randomization_Result__c, Consent_Signed_Date__c, Did_Patient_Sign_Treatment_Consent_Form__c, Other_Reason_Did_Not_Sign_Consent_Form__c, Why_Patient_Not_Signed_Consent_Form__c From Randomization_Forms__r where status__c = 'Approval Not Required'),
			(Select Menopausal_Status__c, Status__c From Menopausal_Status_Details__r where status__c = 'Accepted') 
			From TrialPatient__c t where id = :tpId and Site__r.isTestSite__c = false];
		if(tpList.isEmpty()) {
			system.debug('Skipping as trial patient does not exist '+tpId);
			return;
		}
		
		List<Patient_Custom__c> lstPatient = [select Id ,Age__c, Race__c, Ethnicity__c,Institution__r.Name,Institution__r.Short_Name__c, Country_of_Birth__c, (Select caIntegratorValue__c, Code_Master__c, Value__c, Code_Master__r.Display_Order__c From Pre_Registration_Snomed_Codes__r order by Code_Master__r.Display_Order__c ASC) from Patient_Custom__c where id = :tpList[0].Patient_Id__c];
		if(lstPatient.isEmpty()) {
			system.debug('Skipping as patient does not exist '+tpId);
			return;
		}
		for(Patient_Custom__c patient : lstPatient) {
			String preRegValues = '';
			
			List<Pre_Registration_Snomed_Codes__c> lstPreRegSnomedCode = patient.Pre_Registration_Snomed_Codes__r;
			
			for(Pre_Registration_Snomed_Codes__c preRegSnomed : lstPreRegSnomedCode) {
				SnomedWrapper snomedWrapper = new SnomedWrapper();
				snomedWrapper.displayOrder = Integer.valueOf(preRegSnomed.Code_Master__r.Display_Order__c);
				snomedWrapper.patientId = patient.Id;
				snomedWrapper.snomedMasterId = preRegSnomed.Code_Master__c;
				snomedWrapper.subjectId = '';
				if(preRegSnomed.Code_Master__r.Display_Order__c == 3) {
					snomedWrapper.value = preRegSnomed.Value__c;
				} else { 
					if(preRegSnomed.caIntegratorValue__c == null) {
						preRegSnomed.caIntegratorValue__c = '';
					}
					snomedWrapper.value = preRegSnomed.caIntegratorValue__c;
				}
				lstSnomedWrapper.add(snomedWrapper);
				
			}
		}
		system.debug('lstSnomedWrapper : '+lstSnomedWrapper.size());
		List<TrialPatient__c> lstTrialPatient = [Select Id, Subject_Id__c, Patient_Id__c, Patient_Id__r.Country_of_Birth__c,
		(Select caIntegratorValue__c, Code_Master__c, Value__c, 
		Code_Master__r.Display_Order__c From Snomed_Codes__r order by Code_Master__r.Display_Order__c ASC), 
		(Select r.Type_of_lymph_node_involvement__c, r.TrialPatient__c, r.SystemModstamp, r.Status__c, 
		r.Size_of_largest_node__c, r.Reporting__c, r.RecordTypeId, r.ReasonNotConservationSurgeryCandidate__c, 
		r.ReasonNoSurg_PTx_Snomed__c, r.Partial_response_PR__c, r.Partial_response_PR_Date__c, 
		r.Palpable_nodes__c, r.OwnerId, r.Other__c, r.OtherReason__c, r.OriginalCRF__c, 
		r.Nodes_fixed_to_chest_wall__c, r.New_local_regional_recurrence__c, 
		r.New_local_regional_recurrence_Date__c, r.New_distant_progression__c, 
		r.New_distant_progression_Date__c, r.Name, r.Matted_nodes__c, r.Local_Regional__c, 
		r.LastModifiedDate, r.LastModifiedById, r.IsDeleted, r.IsCandidateForConservationSurgery__c, r.Id, 
		r.Distant__c, r.Disease_Extent__c, r.Date_of_clinical_assessment__c, r.Current_status_of_T4_tumor__c, 
		r.CreatedDate, r.CreatedById, r.Complete_response_CR__c, r.Complete_response_CR_Date__c, 
		r.Clinically_staging_period_T__c, r.Clinically_staging_period_N__c, r.Clinically_staging_period_M__c, 
		r.Clinical_Staging_Period__c, r.CRF__c, r.Breast_Conserv_Snomed__c, 
		r.Best_overall_Response_to_date__c From Response_Evaluation_Forms__r r where status__c='Accepted'), 
		(Select Is_DCIS_Present__c, Is_LCIS_Present__c From On_Study_Pathology_Forms__r where status__c='Accepted')
		 From TrialPatient__c t where Site__r.IsTestSite__c = false and id = :tpId];
		
		List<Chemo_Summary_Form__c> lstChemoSummary = [Select c.TrialPatient__c, (Select Treatment_End_Reasons__c From ChemoSummaryRegimenDetail__r where Treatment_End_Reasons__c != null and Treatment_End_Reasons__c = 'Treatment completed per protocol criteria') From Chemo_Summary_Form__c c where Status__c = 'Accepted' and TrialPatient__c = :tpId];
		
		String CompletedTxVal = '';
		String NonStudyChemoVal = '';
		String StudyChemoVal = '';
		if(!lstChemoSummary.isEmpty()) {
			Chemo_Summary_Form__c cs = lstChemoSummary[0];
			if(cs.ChemoSummaryRegimenDetail__r != null && !cs.ChemoSummaryRegimenDetail__r.isEmpty()) {
				CompletedTxVal = '1';
			} else {
				CompletedTxVal = '0';
			}
			
			List<Chemo_Therapy_Regimen__c> ctrList = [Select c.Other_Agent__c, c.Chemo_Treatment__c, c.Agent__r.Name, c.Agent__c From Chemo_Therapy_Regimen__c c where c.Chemo_Treatment__r.Status__c = 'Accepted' and c.Chemo_Treatment__r.TrialPatient__c = :cs.TrialPatient__c];
			for(Chemo_Therapy_Regimen__c ctr : ctrList) {
				if(ctr.Agent__r.Name != null && ctr.Agent__r.Name != '') {
					StudyChemoVal += ctr.Agent__r.Name + ',';
				}
				if(ctr.Other_Agent__c != null && ctr.Other_Agent__c != '') {
					NonStudyChemoVal += ctr.Other_Agent__c + ',';
				}
			}
		}
		
		List<Followup_Form__c> lstFollowup = [Select TrialPatient__c, Survival_Status__c, (Select Name, Site__c From Irradiated_Sites__r) From Followup_Form__c f where Status__c = 'Accepted' and TrialPatient__c = :tpId order by End_Date__c desc];
		Map<Id, String> mapFollowup = new Map<Id, String>();
		if(!lstFollowup.isEmpty()) {
			for(Followup_Form__c fu : lstFollowup) {
				String rtSite = '';
					if(fu.Irradiated_Sites__r != null && !fu.Irradiated_Sites__r.isEmpty()) {
					for(Irradiated_Site__c ir : fu.Irradiated_Sites__r) {
						if(ir.Site__c == 'Breast')
							rtSite += '1';
						if(ir.Site__c == 'Boost')
							rtSite += '2';
						if(ir.Site__c == 'Axilla')
							rtSite += '3';
						if(ir.Site__c == 'Supraclavicular node')
							rtSite += '4';
						if(ir.Site__c == 'Internal mammary node')
							rtSite += '5';
						if(ir.Site__c == 'Chest wall')
							rtSite += '6';
						if(ir.Site__c == 'Other')
							rtSite += '7';
					}
				}
				if(mapFollowup.containsKey(fu.TrialPatient__c)) {
					rtSite += mapFollowup.get(fu.TrialPatient__c);
				}
				mapFollowup.put(fu.TrialPatient__c, rtSite);
			}
		}
		
		Map<Id, Procedure__c> mapPro = new Map<Id, Procedure__c>();
		Map<Id, DCIS__c> mapDcis = new Map<Id, DCIS__c>();
		Map<Id, LCIS__c> mapLcis = new Map<Id, LCIS__c>();
		Map<Id, Invasive_Tumor_Detail__c> mapInv = new Map<Id, Invasive_Tumor_Detail__c>();
		Map<Id, Therapy_Received__c> mapTherapyRec = new Map<Id, Therapy_Received__c>();
		
		String her2NeuStatusPSS = '';
		List<Receptors__c> recList = [Select r.Post_Surgery_Summary__r.TrialPatient__c, r.Post_Surgery_Summary__c, r.HER2_neu_Marker__c From Receptors__c r where Post_Surgery_Summary__r.Status__c = 'Accepted' and Post_Surgery_Summary__r.TrialPatient__c = :tpId];
		if(!recList.isEmpty()) {
			if(recList[0].HER2_neu_Marker__c == 'Negative') {
				her2NeuStatusPSS = '0';
			} else if(recList[0].HER2_neu_Marker__c == 'Positive') {
				her2NeuStatusPSS = '1';
			} else if(recList[0].HER2_neu_Marker__c == 'Indeterminate') {
				her2NeuStatusPSS = '2';
			} else if(recList[0].HER2_neu_Marker__c == 'Not Reported') {
				her2NeuStatusPSS = '3';
			}
		}
		
		integer Her2IHCtest_OSVal = -1;
		integer Her2FISHtest_OSVal = -1;
		integer ERstatus_OSVal = -1;
		integer PRstatus_OSVal = -1;
		integer Her2IHCstatus_OSVal = -1;
		integer Her2FISHstatus_OSVal = -1;
		
		List<On_Study_Pathology_Form__c> ospList = [Select o.pg_onstudypathology_Id__c, 
			o.Tumor_laterality__c, o.TrialPatient__c, o.SystemModstamp, o.Status__c, 
			o.RecordTypeId, o.Phase__c, o.OwnerId, o.OriginalCRF__c, o.Name, 
			o.Is_invasive_tumor_present__c, o.Is_LCIS_Present__c, o.Is_DCIS_Present__c, 
			o.Id, o.Does_the_patient_have_bilateral_breast_c__c, o.CreatedDate, o.CreatedById, 
			o.CompletedDate__c, o.CRF__c, 
				(Select Id, OwnerId, IsDeleted, Name, CreatedDate, CreatedById, 
				LastModifiedDate, LastModifiedById, SystemModstamp, CB_11_Value__c, 
				CB_11__c, DAKO_Herceptest_Value__c, DAKO_Herceptest__c, ER_TS_OS_Snomed__c, 
				ERpos_OS_Snomed__c, Estrogen_Intensity_Score__c, Estrogen_Receptor_Proportion_Score__c, 
				Estrogen_Receptor_Status__c, FISH_test_not_done__c, Fish__c, 
				HER2_neu_Marker__c, Her2Pos_OS_Snomed__c, IHC__c, IHC_test_not_done__c, 
				Letarality__c, Other_FISH_Results__c, Other_FISH_Test_Value__c, 
				Other_FISH_Test__c, Other_IHC_Results__c, Other_IHC_Test_Value__c, 
				Other_IHC_Test__c, PgR_TS_OS_Snomed__c, Progesterone_Intensity_Score__c, 
				Progesterone_Receptor_Proportion_Score__c, Progesterone_Receptor_Status__c, 
				Total_Score_ER__c, Total_Score_PR__c, Ventana_Oncoprobe_Value__c, 
				Ventana_Oncoprobe__c, Ventana_kit_Value__c, Ventana_kit__c, Vysis_Path_Vision_Value__c, 
				Vysis_Path_Vision__c, pg_Receptors_Id__c, On_Study_Pathology_Form__c, 
				Post_Surgery_Summary__c, Type__c From Receptors__r), 
				
				(Select Id, OwnerId, IsDeleted, Name, CreatedDate, CreatedById, LastModifiedDate, 
				LastModifiedById, SystemModstamp, Date_Of_Procedure__c, Form_Name__c, Laterality__c, 
				Location__c, MRI__c, Mammography__c, Node_Result__c, Node_Type__c, Palpation_guided__c, 
				Post_Surgery_Summary__c, Procedure_Name__c, Stereotactic__c, Total_Examined_Nodes__c, 
				Total_Positive__c, TrialPatient__c, Ultrasound__c, pg_procedure_id__c From Procedures__r), 
				
				(Select Id, OwnerId, IsDeleted, Name, CreatedDate, CreatedById, LastModifiedDate, 
				LastModifiedById, SystemModstamp, Closest_Margin__c, Histological_Type__c, LCIS__c, 
				Margins__c, Specify_No__c, Specify_Units__c, Total_histological_span__c, 
				Total_histological_span_measurement_unit__c, Unknown_Not_Reported__c, Histology__c, 
				pg_Lcis_Id__c, Post_Surgery_Summary__c From LCIS__r), 
				
				(Select Id, OwnerId, IsDeleted, Name, CreatedDate, CreatedById, LastModifiedDate, 
				LastModifiedById, SystemModstamp, Anterior_Inferior_Size__c, Anterior_Inferior__c, 
				Anterior_Superior__c, Anterios_Superior_Size__c, Calcifications__c, 
				Closest_Margin__c, Deep_Margin_Size__c, Deep_Margin__c, 
				Derma_lymphatic_vascular_invasion__c, Dermal_Involvement__c, 
				Evidence_of_therapeutic_effects__c, Invasive_carcinoma_mixed_ductal_lobular__c, 
				Invasive_cribiform_carcinoma__c, Invasive_ductal_carcinoma_nos__c, 
				Invasive_lobular_carcinoma_alveolar_type__c, Invasive_lobular_carcinoma_classic_type__c, 
				Invasive_margins__c, Invasive_margins_size__c, Invasive_papillary_carcinoma__c, 
				Lateral_Size__c, Lateral__c, Lympatic_vascular_Invasion__c, 
				Medical_Size__c, Medical__c, Medullary_carcinoma__c, Mitotic_Count__c, 
				Mucinous_carcinoma__c, Multi_focal_Tumor__c, Muscle_involvement__c, 
				Nuclear_Grade__c, Other__c, Other_changes_present__c, 
				Other_if_other_mention_type_in_textbox__c, Overall_cancer_cellularity__c, 
				Paget_disease__c, Pleomorphic_lobular_carcinoma__c, SBR_Grade__c, 
				Signs_of_Treatment_Effect__c, Skin_Involvement__c, Specify_No__c, 
				Specify_Units__c, Total_Points__c, Tubular_carcinoma__c, Tubule_Papilla_formation__c, 
				Tubulolobular_carcinoma__c, Tumor_Measurement_Unit__c, Tumor_Size_Height__c, 
				Tumor_Size_Width__c, Tumor_Size__c, Ulceration_by_tumor__c, 
				Unknown_Not_Reported__c, Calcifications_Present__c, Anterior_Superior_Size__c, 
				Histology__c, pg_InvasiveTumor_Id__c, Post_Surgery_Summary__c From Invasive_Tumor_Details__r), 
				
				(Select Id, OwnerId, IsDeleted, Name, CreatedDate, CreatedById, LastModifiedDate, 
				LastModifiedById, SystemModstamp, Anterior_Inferior_Size__c, Anterior_Inferior__c, 
				Anterior_Superior_Size__c, Anterior_Superior__c, Apocrine__c, Calcifications__c, 
				Clinging__c, Closest_Margin__c, Comedonecrosis__c, Cribiform__c, Cruciform__c, DCIS__c, 
				Deep_Margin_Size__c, Deep_Margin__c, From_Slide__c, Intra_cystic_encysted_papillary__c, 
				Lateral_Size__c, Lateral__c, Margin__c, Medical_Size__c, Medical__c, Micropapillary__c, 
				Microscopic_foci_upto__c, Necrosis__c, Nuclear_Grade__c, Other__c, 
				Other_if_other_mention_type_in_textb__c, Papillary__c, 
				Present_as_scattered_microscopic_foci__c, Present_in_continous_section__c, 
				Punctate_necrosis__c, Solid__c, Spanning__c, Specific_Closest_Margin_Measurement_Unit__c, 
				Specific_Closest_Margin__c, To_Slide__c, Total_Histological_Span_Measurement_Unit__c, 
				Total_Histological_Span__c, Tumor_Size__c, Unknown_Not_Reported__c, 
				Calcifications_Present__c, Histology__c, Post_Surgery_Summary__c, pg_dcis_Id__c From DCIS__r) 
			From On_Study_Pathology_Form__c o where TrialPatient__c = :tpId and Status__c = 'Accepted'];
		if(ospList.size() > 0) {
			List<Receptors__c> recListOS = ospList[0].Receptors__r;
			if(!recListOS.isEmpty()) {
				
				if(recListOS[0].Estrogen_Receptor_Status__c == 'Negative') {
					ERstatus_OSVal = 1;
				} else if(recListOS[0].Estrogen_Receptor_Status__c == 'Positive') {
					ERstatus_OSVal = 2;
				} else if(recListOS[0].Estrogen_Receptor_Status__c == 'Indeterminate') {
					ERstatus_OSVal = 3;
				} else if(recListOS[0].Estrogen_Receptor_Status__c == 'Not Reported') {
					ERstatus_OSVal = 4;
				}
				
				if(recListOS[0].Progesterone_Receptor_Status__c == 'Negative') {
					PRstatus_OSVal = 1;
				} else if(recListOS[0].Progesterone_Receptor_Status__c == 'Positive') {
					PRstatus_OSVal = 2;
				} else if(recListOS[0].Progesterone_Receptor_Status__c == 'Indeterminate') {
					PRstatus_OSVal = 3;
				} else if(recListOS[0].Progesterone_Receptor_Status__c == 'Not Reported') {
					PRstatus_OSVal = 4;
				}
				
				if(recListOS[0].DAKO_Herceptest__c) {
					Her2IHCtest_OSVal = 1;
				} else if(recListOS[0].Ventana_kit__c) {
					Her2IHCtest_OSVal = 2;
				} else if(recListOS[0].CB_11__c) {
					Her2IHCtest_OSVal = 3;
				} else if(recListOS[0].Other_IHC_Test__c) {
					Her2IHCtest_OSVal = 4;
				} else if(recListOS[0].IHC_test_not_done__c) {
					Her2IHCtest_OSVal = 5;
				}
				
				if(recListOS[0].Ventana_Oncoprobe__c) {
					Her2FISHtest_OSVal = 1;
				} else if(recListOS[0].Other_FISH_Test__c) {
					Her2FISHtest_OSVal = 2;
				} else if(recListOS[0].FISH_test_not_done__c) {
					Her2FISHtest_OSVal = 3;
				}
				
				if(recListOS[0].Fish__c == 'Negative') {
					Her2FISHstatus_OSVal = 0;
				} else if(recListOS[0].Fish__c == 'Positive') {
					Her2FISHstatus_OSVal = 1;
				} else if(recListOS[0].Fish__c == 'Indeterminate') {
					Her2FISHstatus_OSVal = 2;
				} else if(recListOS[0].Fish__c == 'Not Reported') {
					Her2FISHstatus_OSVal = 3;
				}
				
				if(recListOS[0].IHC__c == 'Negative') {
					Her2IHCstatus_OSVal = 0;
				} else if(recListOS[0].IHC__c == 'Positive') {
					Her2IHCstatus_OSVal = 1;
				} else if(recListOS[0].IHC__c == 'Indeterminate') {
					Her2IHCstatus_OSVal = 2;
				} else if(recListOS[0].IHC__c == 'Not Reported') {
					Her2IHCstatus_OSVal = 3;
				}
			}
		}
		
		for(Procedure__c pro : [Select p.Procedure_Name__c, p.Post_Surgery_Summary__r.TrialPatient__c, p.Post_Surgery_Summary__c From Procedure__c p where Post_Surgery_Summary__r.Status__c = 'Accepted' and Post_Surgery_Summary__r.TrialPatient__c = :tpId]) {
			mapPro.put(pro.Post_Surgery_Summary__r.TrialPatient__c, pro);
		}
		
		for(DCIS__c dcis : [Select d.Post_Surgery_Summary__r.TrialPatient__c, d.Post_Surgery_Summary__c, d.DCIS__c, d.Total_Histological_Span__c From DCIS__c d where Post_Surgery_Summary__r.Status__c = 'Accepted' and Post_Surgery_Summary__r.TrialPatient__c = :tpId]) {
			mapDcis.put(dcis.Post_Surgery_Summary__r.TrialPatient__c, dcis);
		}
		
		for(LCIS__c lcis : [Select l.Total_histological_span__c, l.Post_Surgery_Summary__r.TrialPatient__c, l.Post_Surgery_Summary__c, l.LCIS__c From LCIS__c l where Post_Surgery_Summary__r.Status__c = 'Accepted' and Post_Surgery_Summary__r.TrialPatient__c = :tpId]) {
			mapLcis.put(lcis.Post_Surgery_Summary__r.TrialPatient__c, lcis);
		}
		
		for(Invasive_Tumor_Detail__c inv : [Select i.Post_Surgery_Summary__r.TrialPatient__c, i.Post_Surgery_Summary__c, i.Dermal_Involvement__c From Invasive_Tumor_Detail__c i where Post_Surgery_Summary__r.Status__c = 'Accepted' and Post_Surgery_Summary__r.TrialPatient__c = :tpId]) {
			mapInv.put(inv.Post_Surgery_Summary__r.TrialPatient__c, inv);
		}
		
		for(Therapy_Received__c tr : [Select t.Therapy__c, t.Followup_Form__r.TrialPatient__c, t.Followup_Form__r.Status__c, t.Followup_Form__c From Therapy_Received__c t where Therapy__c = 'Non-protocol chemotherapy' and Followup_Form__r.Status__c = 'Accepted' and Followup_Form__r.TrialPatient__c = :tpId]) {
			mapTherapyRec.put(tr.Followup_Form__r.TrialPatient__c, tr);
		}
		
		/*for(TrialPatient__c trialPatient : lstTrialPatient) {
			List<Response_Evaluation_Form__c> lstResEval = trialPatient.Response_Evaluation_Forms__r;
			List<On_Study_Pathology_Form__c> lstOSP = trialPatient.On_Study_Pathology_Forms__r;
			system.debug('mapSnomedNames.size() : '+mapSnomedNames.size());
			for(String name : mapSnomedNames.keySet()) {
				String value = '';
				if(name == 'BirthCountry') {
					value = trialPatient.Patient_Id__r.Country_of_Birth__c;
				} else if(name == 'Completed Tx') {
					value = CompletedTxVal;
				} else if(name == 'StudyChemo') {
					value = StudyChemoVal;
				} else if(name == 'NonStudyChemo') {
					value = NonStudyChemoVal;
				} else if(name == 'InterDiseaseExt') {
					 if(lstResEval != null) {
					 	for(Response_Evaluation_Form__c resEval : lstResEval) {
					 		if(resEval.Reporting__c == 'Inter Regimen') {
					 			if(resEval.Disease_Extent__c != null)
					 				value = resEval.Disease_Extent__c + '';
					 		}
					 	}
					 }
				} else if(name == 'InterNodeExt') {
					 if(lstResEval != null) {
					 	for(Response_Evaluation_Form__c resEval : lstResEval) {
					 		if(resEval.Reporting__c == 'Inter Regimen') {
					 			if(resEval.Size_of_largest_node__c != null)
					 				value = resEval.Size_of_largest_node__c + '';
					 		}
					 	}
					 }
				} else if(name == 'PresDiseaseExt') {
					 if(lstResEval != null) {
					 	for(Response_Evaluation_Form__c resEval : lstResEval) {
					 		if(resEval.Reporting__c == 'Pre Surgury') {
					 			if(resEval.Disease_Extent__c != null)
					 				value = resEval.Disease_Extent__c + '';
					 		}
					 	}
					 }
				} else if(name == 'PresNodeExt') {
					 if(lstResEval != null) {
					 	for(Response_Evaluation_Form__c resEval : lstResEval) {
					 		if(resEval.Reporting__c == 'Pre Surgury') {
					 			if(resEval.Size_of_largest_node__c != null)
					 				value = resEval.Size_of_largest_node__c + '';
					 		}
					 	}
					 }
				} else if(name == 'LNdissection_PS') {
					if(mapPro.get(tpId) != null && mapPro.get(tpId).Procedure_Name__c == 'Sentinel lymph node dissection') {
						value = '1';
					} else {
						value = '0';
					}
				} else if(name == 'Her2status_PS') {
					value = her2NeuStatusPSS;
				} else if(name == 'Her2IHCtest_OS') {
					value = Her2IHCtest_OSVal+'';
				} else if(name == 'Her2FISHtest_OS') {
					value = Her2FISHtest_OSVal+'';
				} else if(name == 'DCIS%_PS') {
					if(mapDcis.get(tpId) != null) {
						value = mapDcis.get(tpId).DCIS__c + '';
					}
				} else if(name == 'LCIS%_PS') {
					if(mapLcis.get(tpId) != null) {
						value = mapLcis.get(tpId).LCIS__c + '';
					}
				} else if(name == 'DCISspan_PS') {
					if(mapDcis.get(tpId) != null) {
						value = mapDcis.get(tpId).Total_histological_span__c + '';
					}
				} else if(name == 'LCISspan_PS') {
					if(mapLcis.get(tpId) != null) {
						value = mapLcis.get(tpId).Total_histological_span__c + '';
					}
				} else if(name == 'DermInvolve_PS') {
					if(mapInv.get(tpId) != null) {
						value = mapInv.get(tpId).Dermal_Involvement__c;
					}
				} else if(name == 'RtSite') {
					if(mapFollowup.get(tpId) != null) {
						value = mapFollowup.get(tpId);
					}
				} else if(name == 'InSitu_OS') {
					if(lstOSP != null && !lstOSP.isEmpty()) {
						if(lstOSP[0].Is_DCIS_Present__c == 'Yes') {
							value = '1';
						}
						if(lstOSP[0].Is_LCIS_Present__c == 'Yes') {
							value += '2';
						}
						if(lstOSP[0].Is_DCIS_Present__c == 'No' && lstOSP[0].Is_LCIS_Present__c == 'No') {
							value = '0';
						}
					}
				} else if(name == 'Adj_Chemo') {
					if(mapTherapyRec.get(tpId) != null) {
						value = '1';
					} else {
						value = '0';
					}
				}
				system.debug('name : '+name+'  value : '+value);
				SnomedWrapper sw = prepareNotCodedValues(trialPatient, value, name, mapSnomedNames.get(name));
				lstSnomedWrapper.add(sw);
			}
			system.debug('lstSnomedWrapper1:'+lstSnomedWrapper.size());
			for(SnomedWrapper swr : lstSnomedWrapper) {
				system.debug('Display Order : '+swr.displayOrder+'  value : '+swr.value);
			}	
			for(SnomedWrapper sm : lstSnomedWrapper) {
				if(trialPatient.Patient_Id__c == sm.patientId) {
					sm.subjectId = trialPatient.Subject_Id__c;
				}
			}
			List<Snomed_Code__c> lstSnomedCode = trialPatient.Snomed_Codes__r;
			if(lstSnomedCode != null && lstSnomedCode.size() > 0) {
				for(Snomed_Code__c snomed : lstSnomedCode) {
					SnomedWrapper sw = new SnomedWrapper();
					sw.displayOrder = Integer.valueOf(snomed.Code_Master__r.Display_Order__c);
					sw.patientId = trialPatient.Patient_Id__c;
					sw.snomedMasterId = snomed.Code_Master__c;
					sw.subjectId = trialPatient.Subject_Id__c;
					if(snomed.Code_Master__r.Display_Order__c == 3) {
						sw.value = snomed.Value__c;
					} else {
						if(snomed.caIntegratorValue__c == null) {
							snomed.caIntegratorValue__c = '';
						}
						sw.value = snomed.caIntegratorValue__c;
					}
					lstSnomedWrapper.add(sw);
				}
			}
		}*/
		
		system.debug('tpList[0].Subject_Id__c:'+tpList[0].Subject_Id__c);
		caIntegrator_Data__c cd = new caIntegrator_Data__c();
		cd.ISPY2ID__c = tpList[0].Subject_Id__c;
		cd.ExtractDate__c = system.today();
		cd.Institution__c = lstPatient[0].Institution__r.Short_Name__c;
		
		List<Post_Surgaory_Summary__c> pssList = [Select p.pcr__c, p.Size_of_Gross_Mass_Width__c, 
			p.Size_of_Gross_Mass_Height__c, p.RCB_Class__c,p.RCB_Index__c,Is_invasive_tumor_present__c,
			(Select Tumor_Size_Width__c,Tumor_Size_Height__c,Invasive_margins__c,Overall_cancer_cellularity__c,Lympatic_vascular_Invasion__c,Dermal_Involvement__c,Nuclear_Grade__c,Multi_focal_Tumor__c,SBR_Grade__c From Invasive_Tumor_Details__r), 
			(Select Procedure_Name__c From Procedures__r ),
			(Select LCIS__c,Histological_Type__c  From LCIS__r), 
			(Select DCIS__c,Nuclear_Grade__c,Punctate_necrosis__c,Comedonecrosis__c,Papillary__c,Micropapillary__c,Necrosis__c,Cribiform__c,Cruciform__c,Clinging__c,Solid__c,Apocrine__c,Intra_cystic_encysted_papillary__c,Other__c From DCIS__r),
			(Select Adjudicated_Stage__c,Metastasis__c, Node_Type__c, Tumor_Type__c From Staging_Details__r),
			(Select Estrogen_Receptor_Status__c, Progesterone_Receptor_Status__c,HER2_neu_Marker__c  From Receptors__r) ,
			(Select l.Additional_Nodes__c, l.Positive__c, l.Examined__c,Size_of_Largest_Tumor__c,Specific_Size_of_Largest_Tumor__c From Lymph_Nodes__r l) 
			From Post_Surgaory_Summary__c p where TrialPatient__c = :tpId and status__c = 'Accepted'];
		List<Followup_Form__c> fList = [Select f.Long_Term_Therapy_for_primary_Trial__c, f.Patient_received_adjuvant_therapy__c,  (Select Therapy__c From Therapy_Receiveds__r), (Select Site__c From Irradiated_Sites__r), f.Surgery__c, f.Radiation_Therapy__c, f.Hormone_Therapy__c, f.Chemotherapy__c, f.patient_diagnosed_local_progression__c, f.patient_diagnosed_distant_progression__c, f.Local_progression_Date__c, f.Local__c, f.Distant_progression_Date__c, f.Distant__c,f.Patient_diagnose_with_new__c,f.Date__c From Followup_Form__c f where TrialPatient__c = :tpId and status__c = 'Accepted' order by End_Date__c asc];
		
		List<Chemo_Treatment__c> ctList = [Select c.Date_of_therapy__c,c.Patient_weight__c, c.Patient_height__c, 
			 (Select Name From Growth_Factor__r)
			From Chemo_Treatment__c c where TrialPatient__c = :tpId and status__c = 'Accepted' 
			order by Cycle_number__c asc ];
		
		integer localProgressVal = -1;
		integer distProgressVal = -1;
		integer localProgSiteVal = -1;
		integer distProgSiteVal = -1;
		integer localProgTimeDays = -1;
		integer distProgTimeDays = -1;
		integer newPrimaryCa = -1;
		integer newPrimaryDays = -1;
		integer newPrimeTxVal = -1;
		integer rtTherapyVal = -1;
		String rtSiteVal = '';
		integer adj_AromataseInhib = -1;
		integer adj_OvarianSup = -1;
		integer adj_OvarianAbl = -1;
		integer adj_Tam = -1;
		integer adj_Trastuzumab = -1;
		integer adj_Chemo = -1;
		String adj_ChemoReg = '';
		integer adj_Other = -1;
		String adj_OtherVal = '';
		
		for(Followup_Form__c ff : fList) {
			if(localProgressVal == -1 && ff.patient_diagnosed_local_progression__c) {
				localProgressVal = 1;
				if(!ctList.isEmpty()) {
					localProgTimeDays = ctList[0].Date_of_therapy__c.daysBetween(ff.Local_progression_Date__c);
				}
				if(ff.Local__c.contains('Ipsilateral Breast')) {
					localProgSiteVal = 1;
				} else if(ff.Local__c.contains('Axillary Nodes')) {
					localProgSiteVal = 2;
				} else if(ff.Local__c.contains('Internal Mammary Nodes')) {
					localProgSiteVal = 3;
				} else if(ff.Local__c.contains('Supraclavicular Nodes')) {
					localProgSiteVal = 4;
				} else if(ff.Local__c.contains('Infraclavicular Nodes')) {
					localProgSiteVal = 5;
				} else if(ff.Local__c.contains('Chest Wall')) {
					localProgSiteVal = 6;
				} else if(ff.Local__c.contains('Local-regionalSkin&SubcutaneousTissue')) {
					localProgSiteVal = 7;
				}
			}
			if(distProgressVal == -1 && ff.patient_diagnosed_distant_progression__c) {
				distProgressVal = 1;
				if(!ctList.isEmpty()) {
					distProgTimeDays = ctList[0].Date_of_therapy__c.daysBetween(ff.Distant_progression_Date__c);
				}
				if(ff.Local__c.contains('Contralateral Breast')) {
					distProgSiteVal = 1;
				} else if(ff.Local__c.contains('Distant Lymph Nodes')) {
					distProgSiteVal = 2;
				} else if(ff.Local__c.contains('Pleura')) {
					distProgSiteVal = 3;
				} else if(ff.Local__c.contains('Lung')) {
					distProgSiteVal = 4;
				} else if(ff.Local__c.contains('Liver')) {
					distProgSiteVal = 5;
				} else if(ff.Local__c.contains('Distant skin & SubcutaneousTissue')) {
					distProgSiteVal = 6;
				} else if(ff.Local__c.contains('Bone')) {
					distProgSiteVal = 7;
				} else if(ff.Local__c.contains('Bone marrow')) {
					distProgSiteVal = 8;
				} else if(ff.Local__c.contains('Brain/CNS')) {
					distProgSiteVal = 9;
				} else if(ff.Local__c.contains('Other')) {
					distProgSiteVal = 10;
				}
			}
			if(ff.Patient_diagnose_with_new__c) {
				newPrimaryCa = 1;
				if(!ctList.isEmpty()) {
					newPrimaryDays = ctList[0].Date_of_therapy__c.daysBetween(ff.Date__c);
				}
			}
			
			if(newPrimeTxVal == -1 && ff.Surgery__c) {
				newPrimeTxVal = 1;
			} else if(newPrimeTxVal == -1 && ff.Chemotherapy__c) {
				newPrimeTxVal = 2;
			} else if(newPrimeTxVal == -1 && ff.Radiation_Therapy__c) {
				newPrimeTxVal = 3;
			} else if(newPrimeTxVal == -1 && ff.Hormone_Therapy__c) {
				newPrimeTxVal = 4;
			}
			
			if(rtTherapyVal == -1 && ff.Patient_received_adjuvant_therapy__c) {
				rtTherapyVal = 1;
				if(!ff.Irradiated_Sites__r.isEmpty()) {
					for(Irradiated_Site__c irs : ff.Irradiated_Sites__r) {
						if(irs.Site__c == 'Breast') {
							rtSiteVal += '1'+',';
						}
						if(irs.Site__c == 'Boost') {
							rtSiteVal += '2'+',';
						}
						if(irs.Site__c == 'Axilla') {
							rtSiteVal += '3'+',';
						}
						if(irs.Site__c == 'Supraclavicular node') {
							rtSiteVal += '4'+',';
						}
						if(irs.Site__c == 'Internal mammary node') {
							rtSiteVal += '5'+',';
						}
						if(irs.Site__c == 'Chest wall') {
							rtSiteVal += '6'+',';
						}
						if(irs.Site__c == 'Other') {
							rtSiteVal += '7'+',';
						}
					}
				}
			}
			
			if(ff.Long_Term_Therapy_for_primary_Trial__c) {
				for(Therapy_Received__c tr : ff.Therapy_Receiveds__r) {
					if(adj_AromataseInhib == -1 && tr.Therapy__c.contains('Aromatase inhibitor')) {
						adj_AromataseInhib = 1;
					}
					if(adj_OvarianSup == -1 && tr.Therapy__c.contains('Ovarian suppression')) {
						adj_OvarianSup = 1;
					}
					if(adj_OvarianAbl == -1 && tr.Therapy__c.contains('Ovarian ablation')) {
						adj_OvarianAbl = 1;
					}
					if(adj_Tam == -1 && tr.Therapy__c.contains('Tamoxifen')) {
						adj_Tam = 1;
					}
					if(adj_Trastuzumab == -1 && tr.Therapy__c.contains('Trastuzumab')) {
						adj_Trastuzumab = 1;
					}
					if(adj_Chemo == -1 && tr.Therapy__c.contains('Non-protocol chemotherapy')) {
						adj_Chemo = 1;
						adj_ChemoReg = tr.Detail__c;
					}
					if(adj_Other == -1 && tr.Therapy__c.contains('Other non-protocol therapy')) {
						adj_Other = 1;
						adj_OtherVal = tr.Detail__c;
					}
				}
			}
		}
		if(rtSiteVal.endsWith(',')) {
			rtSiteVal = rtSiteVal.substring(0, rtSiteVal.length()-1);
		}
		
		Response_Evaluation_Form__c baselineRef = null;
		for(Response_Evaluation_Form__c r : lstTrialPatient[0].Response_Evaluation_Forms__r) {
			if(r.Reporting__c == 'Baseline') {
				baselineRef = r;
			}
		}
		List<PreEligibility_Checklist__c> preList = [Select p.ECOG_Score__c,p.CRF_Id__c,p.Patient__c From PreEligibility_Checklist__c p where Patient__c = :lstPatient[0].Id and Status__c = 'Approval Not Required'];
		
		for(Code_Master__c cm : [Select s.Display_Order__c From Code_Master__c s where IsReportColumn__c = true order by Display_Order__c ASC]) {
			
			if(cm.Display_Order__c == 4) {
				//cd.Height__c = Decimal.valueOf(sWrapper.value);
				if(ctList.isEmpty())continue;
				cd.Height__c = ctList[0].Patient_height__c;
			}
			else if(cm.Display_Order__c == 5) {
				//cd.Weight__c = Decimal.valueOf(sWrapper.value);
				if(ctList.isEmpty())continue;
				cd.Weight__c = ctList[0].Patient_weight__c;
			}
			else if(cm.Display_Order__c == 6) {
				//cd.ECOG__c = Decimal.valueOf(sWrapper.value);
				if(preList.isEmpty())continue;
				if(preList[0].ECOG_Score__c != null && preList[0].ECOG_Score__c != '') {
					cd.ECOG__c = Decimal.valueOf(preList[0].ECOG_Score__c.substring(0,1));
				}
			}
			else if(cm.Display_Order__c == 7) {
				//cd.Age__c = Decimal.valueOf(sWrapper.value);
				cd.Age__c = lstPatient[0].Age__c;
			}
			else if(cm.Display_Order__c == 8) {
				//cd.Race__c = sWrapper.value;
				if(lstPatient[0].Race__c == 'American Indian or Alaska Native') {
					cd.Race__c = 1;
				} else if(lstPatient[0].Race__c == 'Asian') {
					cd.Race__c = 2;
				} else if(lstPatient[0].Race__c == 'Black or African American') {
					cd.Race__c = 3;
				} else if(lstPatient[0].Race__c == 'Native Hawaiian or Pacific Islander') {
					cd.Race__c = 4;
				} else if(lstPatient[0].Race__c == 'White') {
					cd.Race__c = 6;
				}
			}
			else if(cm.Display_Order__c == 9) {
				//cd.Ethn__c = Decimal.valueOf(sWrapper.value);
				if(lstPatient[0].Ethnicity__c == 'Hispanic or Latino') {
					cd.Ethn__c = 1;
				} else if(lstPatient[0].Ethnicity__c == 'Not Hispanic or Latino') {
					cd.Ethn__c = 2;
				}
			}
			else if(cm.Display_Order__c == 10) {
				//cd.BirthCountry__c = sWrapper.value;
				cd.BirthCountry__c = lstPatient[0].Country_of_Birth__c;
			}
			else if(cm.Display_Order__c == 11) {
				//cd.SurvStat__c = Decimal.valueOf(sWrapper.value);
				if(lstFollowup.isEmpty())continue;
				if(lstFollowup[0].Survival_Status__c == 'Alive') {
					cd.SurvStat__c = 1;
				} else if(lstFollowup[0].Survival_Status__c == 'Dead') {
					cd.SurvStat__c = 2;
				} else if(lstFollowup[0].Survival_Status__c == 'Lost to Follow-up') {
					cd.SurvStat__c = 3;
				} else if(lstFollowup[0].Survival_Status__c == 'Consent for Followup withdrawn') {
					cd.SurvStat__c = 4;
				}
			}
			else if(cm.Display_Order__c == 12) {
				//cd.SurvDateD__c = Decimal.valueOf(sWrapper.value);
				List<TrialPatient__c> tpList1 = [Select Id,(Select Screening_Informed_Consent_Date__c From Registrations__r where status__c = 'Approval Not Required'), (Select End_Date__c,CRF__c From Followup_Forms__r where status__c='Accepted' order by End_Date__c desc limit 1) From TrialPatient__c t where Site__r.isTestSite__c = false and id =:tpId];
				for(TrialPatient__c tp : tpList1) {
				    if(tp.Registrations__r.isEmpty() || tp.Followup_Forms__r.isEmpty())continue;
				    Date startDate = tp.Registrations__r[0].Screening_Informed_Consent_Date__c;
				    Date endDate = tp.Followup_Forms__r[0].End_Date__c;
		            cd.SurvDateD__c = startDate.daysBetween(endDate);
				}
			}
			else if(cm.Display_Order__c == 13) {
				//cd.RFS__c = Decimal.valueOf(sWrapper.value);
				if(tpList[0].Chemo_Treatments__r.isEmpty())continue;
				Date start = tpList[0].Chemo_Treatments__r[0].Date_of_therapy__c;
				Date lDate = null;
			    Date dDate = null;
			    Date deathDate = null;
			    Date finalDate = null;
			    for(Followup_Form__c fo : tpList[0].Followup_Forms__r) {
			        if(fo.Distant_progression_Date__c != null) {
			            if(dDate == null || dDate > fo.Distant_progression_Date__c) {
			            	dDate = fo.Local_progression_Date__c;
			            }
			        }
			        if(fo.Local_progression_Date__c != null) {
			            if(lDate == null || lDate > fo.Distant_progression_Date__c) {
			            	lDate = fo.Distant_progression_Date__c;
			            }
			        }
			        if(fo.Survival_Status__c == 'Dead') {
			            deathDate = fo.End_Date__c;
			        }
			        system.debug('Survival_Status__c:'+fo.Survival_Status__c);
			    }
			    system.debug('lDate:'+lDate+',dDate:'+dDate);
			    if(lDate != null && dDate != null) {
			        finalDate = lDate > dDate ? dDate : lDate;
			    } else if(lDate != null && dDate == null) {
			        finalDate = lDate;
			    } else if(lDate == null && dDate != null) {
			        finalDate = dDate;
			    } else if(deathDate != null) {
			        finalDate = deathDate;
			    }
			    if(start != null && finalDate != null) {
			    	cd.RFS__c = start.daysBetween(finalDate);
			    }
			}
			else if(cm.Display_Order__c == 14) {
				//cd.RFS_ind__c = Decimal.valueOf(sWrapper.value);
				cd.RFS_ind__c = 0;
				Date ldDate = null;
			    for(Followup_Form__c fo : tpList[0].Followup_Forms__r) {
			        boolean found = false;
			        if(fo.Distant_progression_Date__c != null) {
			            ldDate = fo.Distant_progression_Date__c;
			            found = true;
			        }
			        if(fo.Local_progression_Date__c != null) {
			            if(ldDate == null || (ldDate != null && ldDate > fo.Distant_progression_Date__c)) {
			            	ldDate = fo.Local_progression_Date__c;
			            }
			        }
			        if(found || fo.Survival_Status__c == 'Dead') {
			            cd.RFS_ind__c = 1;
			            break;
			        }
			    }
			} else if(cm.Display_Order__c == 15) {
				if(tpList[0].Menopausal_Status_Details__r.isEmpty())continue;
				String mStatus = tpList[0].Menopausal_Status_Details__r[0].Menopausal_Status__c;
				if(mStatus == 'Premenopausal(<6 months since LMP AND no prior bilateral ovariectomy AND not on estrogen replacement)') {
					cd.Menopausal_OS__c = 1; 
				} else if(mStatus == 'Perimenopausal(6-12 months since LMP AND no prior bilateral ovariectomy AND not on estrogen replacement)') {
					cd.Menopausal_OS__c = 2; 
				} else if(mStatus == 'Postmenopausal (prior bilateral ovariectomy OR > 12 months since LMP with no prior hysterectomy)') {
					cd.Menopausal_OS__c = 3; 
				} else if(mStatus == 'Above categories not applicable AND Age < 50') {
					cd.Menopausal_OS__c = 5; 
				} else if(mStatus == 'Above categories not applicable AND Age > 50') {
					cd.Menopausal_OS__c = 4; 
				}
			}
			else if(cm.Display_Order__c == 16) {
				//cd.Method_Detect__c = Decimal.valueOf(sWrapper.value);
				if(tpList[0].On_Study_Eligibility_Forms__r.isEmpty())continue;
				String canDet = tpList[0].On_Study_Eligibility_Forms__r[0].How_was_the_cancer_first_detected__c;
				if(canDet == 'Self exam') {
					cd.Method_Detect__c = 1;
				} else if(canDet == 'Clinical Exam') {
					cd.Method_Detect__c = 2;
				} else if(canDet == 'Screening Mammogram') {
					cd.Method_Detect__c = 3;
				} else if(canDet == 'Screening MRI') {
					cd.Method_Detect__c = 4;
				} else if(canDet == 'Unknown') {
					cd.Method_Detect__c = 5;
				} else if(canDet == 'Other') {
					cd.Method_Detect__c = 6;
				}
			}
			else if(cm.Display_Order__c == 17) {
				//cd.Interval_Cancer__c = Decimal.valueOf(sWrapper.value);
				if(tpList[0].On_Study_Eligibility_Forms__r.isEmpty())continue;
				On_Study_Eligibility_Form__c ose = tpList[0].On_Study_Eligibility_Forms__r[0];
				if(ose.Most_Recent_Date__c != null && ose.Mass_Identification_Date__c != null) {
					integer days = ose.Most_Recent_Date__c.daysBetween(ose.Mass_Identification_Date__c);
					if(days <= 730) {
                    	cd.Interval_Cancer__c = 1;
                    } else {
                    	cd.Interval_Cancer__c = 0;
                    }
				} else {
					cd.Interval_Cancer__c = 2;
				}
			}
			else if(cm.Display_Order__c == 18) {
				//cd.cTstage_OS__c = sWrapper.value;
				if(baselineRef == null)continue;
				cd.cTstage_OS__c = baselineRef.Clinically_staging_period_T__c;
			}
			else if(cm.Display_Order__c == 19) {
				//cd.cNstage_OS__c = sWrapper.value;
				if(baselineRef == null)continue;
				cd.cNstage_OS__c = baselineRef.Clinically_staging_period_N__c;
			}
			else if(cm.Display_Order__c == 20) {
				//cd.cStaging_OS__c = sWrapper.value;
				if(baselineRef == null)continue;
				cd.cStaging_OS__c = baselineRef.Clinically_staging_period_M__c;
			}
			else if(cm.Display_Order__c == 21) {
				//cd.BaseDiseaseExt__c = Decimal.valueOf(sWrapper.value);
				if(baselineRef == null)continue;
				cd.BaseDiseaseExt__c = baselineRef.Disease_Extent__c;
			}
			else if(cm.Display_Order__c == 22) {
				//cd.BaseNodeExt__c = Decimal.valueOf(sWrapper.value);
				if(baselineRef == null)continue;
				cd.BaseNodeExt__c = baselineRef.Size_of_largest_node__c;
			}
			else if(cm.Display_Order__c == 23) {
				//cd.InflamCa_OS__c = Decimal.valueOf(sWrapper.value);
				if(baselineRef == null)continue;
				if(baselineRef.Current_status_of_T4_tumor__c == 'Inflammatory') {
                    cd.InflamCa_OS__c = 1;
                } else {
                	cd.InflamCa_OS__c = 0;
                }
			}
			else if(cm.Display_Order__c == 24) {
				//cd.LNsampled_OS__c = Decimal.valueOf(sWrapper.value);
				boolean samplingPerformed = false;
				for(On_Study_Pathology_Form__c osp : ospList) {
					if(osp.Procedures__r != null) {
                        for(Procedure__c pro : osp.Procedures__r) {
                            if(pro.Form_Name__c == 'On-Study Pathology Form(Lymph Node Biopsies)') {
                                samplingPerformed = true;
                                break;
                            }
                        }
                    }
				}
				if(samplingPerformed) {
                    cd.LNsampled_OS__c = 1;
                } else {
                    cd.LNsampled_OS__c = 0;
                }
			}
			else if(cm.Display_Order__c == 25) {
				//cd.LNresult_OS__c = Decimal.valueOf(sWrapper.value);
				boolean samplingPerformed = false;
				for(On_Study_Pathology_Form__c osp : ospList) {
					if(osp.Procedures__r != null) {
                        for(Procedure__c pro : osp.Procedures__r) {
                            if(pro.Form_Name__c == 'On-Study Pathology Form(Lymph Node Biopsies)' && pro.Node_Result__c == 'Positive') {
                                samplingPerformed = true;
                                break;
                            }
                        }
                    }
				}
				if(samplingPerformed) {
                    cd.LNresult_OS__c = 1;
                } else {
                    cd.LNresult_OS__c = 0;
                }
			}
			else if(cm.Display_Order__c == 26) {
				List<Invasive_Tumor_Detail__c> iList = [Select Invasive_ductal_carcinoma_nos__c,Invasive_lobular_carcinoma_classic_type__c,Invasive_lobular_carcinoma_alveolar_type__c,Pleomorphic_lobular_carcinoma__c,Tubulolobular_carcinoma__c,Invasive_carcinoma_mixed_ductal_lobular__c,Tubular_carcinoma__c,Mucinous_carcinoma__c,Medullary_carcinoma__c,Invasive_papillary_carcinoma__c,Invasive_cribiform_carcinoma__c,Other__c From Invasive_Tumor_Detail__c i where On_Study_Pathology_Form__r.Status__c = 'Accepted' and On_Study_Pathology_Form__r.TrialPatient__c = :tpId];
				cd.InvHistology_OS__c = '';
				if(!iList.isEmpty()) {
					Invasive_Tumor_Detail__c inv = iList[0];
					if(inv.Invasive_ductal_carcinoma_nos__c) {
		                cd.InvHistology_OS__c = '1';
		            }
		            if(inv.Invasive_lobular_carcinoma_classic_type__c) {
						cd.InvHistology_OS__c += '2' + ',';
		            }
		            if(inv.Invasive_lobular_carcinoma_alveolar_type__c) {
		                cd.InvHistology_OS__c += '3' + ',';
		            }
		            if(inv.Pleomorphic_lobular_carcinoma__c) {
		                cd.InvHistology_OS__c = '4' + ',';
		            }
		            if(inv.Tubulolobular_carcinoma__c) {
		                cd.InvHistology_OS__c = '5' + ',';
		            }
		            if(inv.Invasive_carcinoma_mixed_ductal_lobular__c) {
		                cd.InvHistology_OS__c = '6' + ',';
		            }
		            if(inv.Tubular_carcinoma__c) {
		                cd.InvHistology_OS__c = '7' + ',';
		            }
		            if(inv.Mucinous_carcinoma__c) {
		                cd.InvHistology_OS__c = '8' + ',';
		            }
		            if(inv.Medullary_carcinoma__c) {
		                cd.InvHistology_OS__c = '9' + ',';
		            }
		            if(inv.Invasive_papillary_carcinoma__c) {
		                cd.InvHistology_OS__c = '10' + ',';
		            }
		            if(inv.Invasive_cribiform_carcinoma__c) {
		                cd.InvHistology_OS__c = '11' + ',';
		            }
		            if(inv.Other__c) {
		                cd.InvHistology_OS__c = '12';
		            }
		            if(cd.InvHistology_OS__c.endsWith(',')) {
		            	cd.InvHistology_OS__c = cd.InvHistology_OS__c.substring(0,cd.InvHistology_OS__c.length()-1);
		            }
				}
			}
			else if(cm.Display_Order__c == 27) {
				//cd.InvSBR_OS__c = Decimal.valueOf(sWrapper.value);
				for(On_Study_Pathology_Form__c tp : ospList) {
				    if(tp.Invasive_Tumor_Details__r.size() ==0)continue;
				    Invasive_Tumor_Detail__c ref = tp.Invasive_Tumor_Details__r[0];
				    if(ref.SBR_Grade__c == 'I') {
				        cd.InvSBR_OS__c = 1;
				    } else if(ref.SBR_Grade__c == 'II') {
				        cd.InvSBR_OS__c = 2;
				    } else if(ref.SBR_Grade__c == 'III') {
				        cd.InvSBR_OS__c = 3;
				    } else if(ref.SBR_Grade__c == 'Indeterminate') {
				        cd.InvSBR_OS__c = 4;
				    }
				}
			}
			else if(cm.Display_Order__c == 28) {
				//cd.InSitu_OS__c = Decimal.valueOf(sWrapper.value);
				cd.InSitu_OS__c = 0;
				if(!ospList.isEmpty()) {
					if(ospList[0].Is_DCIS_Present__c == 'Yes') {
						cd.InSitu_OS__c = 1;
					} else if(ospList[0].Is_LCIS_Present__c == 'Yes') {
						cd.InSitu_OS__c = 2;
					} 
				}
			}
			else if(cm.Display_Order__c == 29) {
				//cd.BilateralCa__c = Decimal.valueOf(sWrapper.value);
				if(!ospList.isEmpty()) {
					if(ospList[0].Does_the_patient_have_bilateral_breast_c__c == 'Yes') {
						cd.BilateralCa__c = 1;
					} else if(ospList[0].Does_the_patient_have_bilateral_breast_c__c == 'No'){
						cd.BilateralCa__c = 0;
					}
				}
			}
			else if(cm.Display_Order__c == 30) {
				//cd.Laterality__c = Decimal.valueOf(sWrapper.value);
				if(!ospList.isEmpty()) {
					if(ospList[0].Tumor_laterality__c == 'Left') {
						cd.Laterality__c = 1;
					} else if(ospList[0].Tumor_laterality__c == 'Right') {
						cd.Laterality__c = 2;
					}
				}
			}
			else if(cm.Display_Order__c == 31) {
				//cd.ERstatus_OS__c = Decimal.valueOf(sWrapper.value);
				if(ERstatus_OSVal != -1) {
					cd.ERstatus_OS__c = ERstatus_OSVal;
				}
			}
			else if(cm.Display_Order__c == 32) {
				//cd.PRstatus_OS__c = Decimal.valueOf(sWrapper.value);
				if(PRstatus_OSVal != -1) {
					cd.ERstatus_OS__c = PRstatus_OSVal;
				}
			}
			else if(cm.Display_Order__c == 33) {
				//cd.Her2IHCstatus_OS__c = Decimal.valueOf(sWrapper.value);
				if(Her2IHCstatus_OSVal!= -1) {
					cd.Her2IHCstatus_OS__c = Her2IHCstatus_OSVal;
				}
			}
			else if(cm.Display_Order__c == 34) {
				//cd.Her2FISHstatus_OS__c = Decimal.valueOf(sWrapper.value);
				if(Her2FISHstatus_OSVal != -1) {
					cd.Her2FISHstatus_OS__c = Her2FISHstatus_OSVal;
				}
			}
			else if(cm.Display_Order__c == 35) {
				//cd.Her2TargetPrint_OS__c = Decimal.valueOf(sWrapper.value);
				for(MammaPrintDetail__c mp : tpList[0].MammaPrint_Details__r) {
					if(mp.TargetPrint_Her_2_Status__c == 'Positive') {
						cd.Her2TargetPrint_OS__c = 1;
					} else if(mp.TargetPrint_Her_2_Status__c == 'Negative') {
						cd.Her2TargetPrint_OS__c = 0;
					}
				}
			}
			else if(cm.Display_Order__c == 36) {
				//cd.Her2IHCtest_OS__c = Decimal.valueOf(sWrapper.value);
				if(Her2IHCtest_OSVal != -1) {
					cd.Her2IHCtest_OS__c = Her2IHCtest_OSVal;
				}
			}
			else if(cm.Display_Order__c == 37) {
				//cd.Her2FISHtest_OS__c = Decimal.valueOf(sWrapper.value);
				if(Her2FISHtest_OSVal != -1) {
					cd.Her2FISHtest_OS__c = Her2FISHtest_OSVal;
				}
			}
			else if(cm.Display_Order__c == 38) {
				//cd.MP_Risk__c = Decimal.valueOf(sWrapper.value);
				for(MammaPrintDetail__c mp : tpList[0].MammaPrint_Details__r) {
					if(mp.MammaPrint_Risk__c == 'Low risk') {
						cd.MP_Risk__c = 0;
					} else if(mp.MammaPrint_Risk__c == 'High risk') {
						cd.MP_Risk__c = 1;
					} else if(mp.MammaPrint_Risk__c == 'Quantity not sufficient') {
						cd.MP_Risk__c = 2;
					} else if(mp.MammaPrint_Risk__c == 'Quality not sufficient') {
						cd.MP_Risk__c = 3;
					}
				}
			}
			else if(cm.Display_Order__c == 39) {
				//cd.MP_Index__c = Decimal.valueOf(sWrapper.value);
				for(MammaPrintDetail__c mp : tpList[0].MammaPrint_Details__r) {
					cd.MP_Index__c = mp.MammaPrint_Index__c;
				}
			}
			else if(cm.Display_Order__c == 40) {
				//cd.MP_Cat__c = Decimal.valueOf(sWrapper.value);
				for(MammaPrintDetail__c mp : tpList[0].MammaPrint_Details__r) {
					if(mp.H1_H2_status__c == 'H1') {
						cd.MP_Cat__c = 1;
					} else if(mp.H1_H2_status__c == 'H2') {
						cd.MP_Cat__c = 2;
					} else if(mp.H1_H2_status__c == 'Undetermined') {
						cd.MP_Cat__c = 3;
					}
				}
			}
			else if(cm.Display_Order__c == 41) {
				//cd.MRIvol_T0__c = Decimal.valueOf(sWrapper.value);
				for(MRI_Volume__c mri : tpList[0].MRI_Volumes__r) {
					if(mri.Time_Point__c == 'Pre-Treatment') {
						cd.MRIvol_T0__c = mri.MRI_Volume_in_cm3__c;
					}
				}
			}
			else if(cm.Display_Order__c == 42) {
				//cd.MRILD_T0__c = Decimal.valueOf(sWrapper.value);
				for(MRI_Volume__c mri : tpList[0].MRI_Volumes__r) {
					if(mri.Time_Point__c == 'Pre-Treatment') {
						cd.MRILD_T0__c = mri.Longest_Diameter_Of_Index_Lesion_in_cm__c;
					}
				}
			}
			else if(cm.Display_Order__c == 43) {
				//cd.Randomized__c = Decimal.valueOf(sWrapper.value);
				for(Randomization_Form__c ran : tpList[0].Randomization_Forms__r) {
					if(ran.Did_Patient_Sign_Treatment_Consent_Form__c && ran.Randomization_Result__c != null && ran.Randomization_Result__c != '' && ran.Randomization_Result__c != 'Not Randomized'){
						cd.Randomized__c = 1;
					} else if (!ran.Did_Patient_Sign_Treatment_Consent_Form__c && ran.Randomization_Result__c != null && ran.Randomization_Result__c != '' && ran.Randomization_Result__c != 'Not Randomized'){
						cd.Randomized__c = 2;
					} else if(ran.Randomization_Result__c == 'Not Randomized' && ran.Why_Patient_Not_Signed_Consent_Form__c == 'Patient found to be ineligible because they are MammaPrint Low, ER Positive, HER2 Negative') {
						cd.Randomized__c = 3;
					} else if(ran.Randomization_Result__c == 'Not Randomized' && ran.Why_Patient_Not_Signed_Consent_Form__c == 'Patient found to be ineligible because they did not meet other eligibility criteria') {
						cd.Randomized__c = 4;
					} else if(ran.Randomization_Result__c == 'Not Randomized' && ran.Why_Patient_Not_Signed_Consent_Form__c == 'Patient found to be ineligible because patient could not complete MRI') {
						cd.Randomized__c = 5;
					} else if(ran.Randomization_Result__c == 'Not Randomized' && ran.Why_Patient_Not_Signed_Consent_Form__c == 'Patient found to be ineligible because patient could not complete core biopsy') {
						cd.Randomized__c = 6;
					} else if(ran.Randomization_Result__c == 'Not Randomized' && ran.Why_Patient_Not_Signed_Consent_Form__c == 'Decided not to have neoadjuvant chemotherapy') {
						cd.Randomized__c = 7;
					} else if(ran.Randomization_Result__c == 'Not Randomized' && ran.Why_Patient_Not_Signed_Consent_Form__c == 'Decided not to be treated with a novel agent') {
						cd.Randomized__c = 8;
					} else if(ran.Randomization_Result__c == 'Not Randomized' && ran.Why_Patient_Not_Signed_Consent_Form__c == 'Other') {
						cd.Randomized__c = 9;
					}
				}
			}
			else if(cm.Display_Order__c == 44) {
				//cd.Breast_Conserv__c = Decimal.valueOf(sWrapper.value);
				if(baselineRef == null)continue;
				
				if(baselineRef.IsCandidateForConservationSurgery__c == 'Yes'){
					cd.Breast_Conserv__c = 1;
				} else if(baselineRef.IsCandidateForConservationSurgery__c == 'No' && baselineRef.ReasonNotConservationSurgeryCandidate__c == 'Multi-centric disease') {
					cd.Breast_Conserv__c = 2;
				} else if(baselineRef.IsCandidateForConservationSurgery__c == 'No' && baselineRef.ReasonNotConservationSurgeryCandidate__c == 'Inflammatory disease') {
					cd.Breast_Conserv__c = 3;
				} else if(baselineRef.IsCandidateForConservationSurgery__c == 'No' && baselineRef.ReasonNotConservationSurgeryCandidate__c == 'Diffuse micro calcifications') {
					cd.Breast_Conserv__c = 4;
				} else if(baselineRef.IsCandidateForConservationSurgery__c == 'No' && baselineRef.ReasonNotConservationSurgeryCandidate__c == 'Institutional norm') {
					cd.Breast_Conserv__c = 6;
				} else if(baselineRef.IsCandidateForConservationSurgery__c == 'No' && baselineRef.ReasonNotConservationSurgeryCandidate__c == 'Specific anatomy of primary') {
					cd.Breast_Conserv__c = 7;
				} else if(baselineRef.IsCandidateForConservationSurgery__c == 'No' && baselineRef.ReasonNotConservationSurgeryCandidate__c == 'Patient choice/family history') {
					cd.Breast_Conserv__c = 5;
				} else if(baselineRef.IsCandidateForConservationSurgery__c == 'No' && baselineRef.ReasonNotConservationSurgeryCandidate__c == 'Other') {
					cd.Breast_Conserv__c = 8;
				}
			}
			else if(cm.Display_Order__c == 45) {
				//1=Paclitaxel + AC
				//2=Paclitaxel/Trastuzumab + AC
				//3=Paclitaxel/Neratinib + AC
				//4=Paclitaxel/ABT-888/Carboplatin +AC
				//5=Paclitaxel/AMG386 + AC
				//6=Paclitaxel/Ganitumab + AC
				//7=Paclitaxel/MK-2206 + AC
				//8=Paclitaxel/MK-2206/Trastuzumab +AC
				List<Randomization_Form__c> rList = [Select r.Randomization_Result__c From Randomization_Form__c r where TrialPatient__c = :tpId];
				if(!rList.isEmpty()) {
					if(rList[0].Randomization_Result__c == 'Paclitaxel') {
						cd.ChemoCat__c = 1;
					} else if(rList[0].Randomization_Result__c == '=Paclitaxel + Trastuzumab') {
						cd.ChemoCat__c = 2;
					} else if(rList[0].Randomization_Result__c == 'Paclitaxel + Neratinib') {
						cd.ChemoCat__c = 3;
					} else if(rList[0].Randomization_Result__c == 'Paclitaxel + ABT-888 + Carboplatin') {
						cd.ChemoCat__c = 4;
					} else if(rList[0].Randomization_Result__c == 'Paclitaxel + AMG386') {
						cd.ChemoCat__c = 5;
					} else if(rList[0].Randomization_Result__c == 'Paclitaxel + Ganitumab') {
						cd.ChemoCat__c = 6;
					} else if(rList[0].Randomization_Result__c == 'Paclitaxel + MK-2206') {
						cd.ChemoCat__c = 7;
					} else if(rList[0].Randomization_Result__c == 'Paclitaxel + MK-2206 + Trastuzumab') {
						cd.ChemoCat__c = 8;
					}
				}
			}
			else if(cm.Display_Order__c == 46) {
				if(CompletedTxVal == null || CompletedTxVal == '')continue;
				cd.Completed_Tx__c = Decimal.valueOf(CompletedTxVal);
			}
			else if(cm.Display_Order__c == 47) {
				cd.StudyChemo__c = StudyChemoVal;
			}
			else if(cm.Display_Order__c == 48) {
				cd.NonStudyChemo__c = NonStudyChemoVal;
			}
			else if(cm.Display_Order__c == 49) {
				//cd.ChemoGrowthMeds__c = sWrapper.value;
				cd.ChemoGrowthMeds__c = '';
				for(Chemo_Treatment__c ct : ctList) {
					for(Growth_Factor__c gf : ct.Growth_Factor__r) {
						if(gf.Name == 'Neulasta') {
							cd.ChemoGrowthMeds__c += '1,';
						} else if(gf.Name == 'Neupogen') {
							cd.ChemoGrowthMeds__c += '2,';
						}
					}
				}
				if(cd.ChemoGrowthMeds__c == '') {
					cd.ChemoGrowthMeds__c = '0';
				} else {
					if(cd.ChemoGrowthMeds__c.endsWith(',')) {
						cd.ChemoGrowthMeds__c = cd.ChemoGrowthMeds__c.substring(0,cd.ChemoGrowthMeds__c.length()-1);
					}
				}
			}
			else if(cm.Display_Order__c == 50) {
				//cd.MRIvol_T1__c = Decimal.valueOf(sWrapper.value);
				for(MRI_Volume__c mri : tpList[0].MRI_Volumes__r) {
					if(mri.Time_Point__c == 'Early Treatment') {
						cd.MRIvol_T1__c = mri.MRI_Volume_in_cm3__c;
					}
				}
			}
			else if(cm.Display_Order__c == 51) {
				//cd.MRILD_T1__c = Decimal.valueOf(sWrapper.value);
				for(MRI_Volume__c mri : tpList[0].MRI_Volumes__r) {
					if(mri.Time_Point__c == 'Early Treatment') {
						cd.MRILD_T1__c = mri.Longest_Diameter_Of_Index_Lesion_in_cm__c;
					}
				}
			}
			else if(cm.Display_Order__c == 52) {
				//cd.MRIvol_T2__c = Decimal.valueOf(sWrapper.value);
				for(MRI_Volume__c mri : tpList[0].MRI_Volumes__r) {
					if(mri.Time_Point__c == 'Inter-Regimen') {
						cd.MRIvol_T2__c = mri.MRI_Volume_in_cm3__c;
					}
				}
			}
			else if(cm.Display_Order__c == 53) {
				//cd.MRILD_T2__c = Decimal.valueOf(sWrapper.value);
				for(MRI_Volume__c mri : tpList[0].MRI_Volumes__r) {
					if(mri.Time_Point__c == 'Inter-Regimen') {
						cd.MRILD_T2__c = mri.Longest_Diameter_Of_Index_Lesion_in_cm__c;
					}
				}
			}
			else if(cm.Display_Order__c == 54) {
				//cd.MRIvol_T3__c = Decimal.valueOf(sWrapper.value);
				for(MRI_Volume__c mri : tpList[0].MRI_Volumes__r) {
					if(mri.Time_Point__c == 'Pre-Surgery') {
						cd.MRIvol_T3__c = mri.MRI_Volume_in_cm3__c;
					}
				}
			}
			else if(cm.Display_Order__c == 55) {
				//cd.MRILD_T3__c = Decimal.valueOf(sWrapper.value);
				for(MRI_Volume__c mri : tpList[0].MRI_Volumes__r) {
					if(mri.Time_Point__c == 'Pre-Surgery') {
						cd.MRILD_T3__c = mri.Longest_Diameter_Of_Index_Lesion_in_cm__c;
					}
				}
			}
			else if(cm.Display_Order__c == 56) {
				//cd.MRIvol_T0_T1__c = Decimal.valueOf(sWrapper.value);
				decimal baselineVol = 0;
				for(MRI_Volume__c mri : tpList[0].MRI_Volumes__r) {
					if(mri.Time_Point__c == 'Pre-Treatment') {
						baselineVol = mri.MRI_Volume_in_cm3__c;
					}
				}
				decimal earlyVol = 0;
				for(MRI_Volume__c mri : tpList[0].MRI_Volumes__r) {
					if(mri.Time_Point__c == 'Early Treatment') {
						earlyVol = mri.MRI_Volume_in_cm3__c;
					}
				}
				if(baselineVol != 0) {
					cd.MRIvol_T0_T1__c = (earlyVol - baselineVol) / baselineVol;
				}
			}
			else if(cm.Display_Order__c == 57) {
				//cd.MRIvol_T0_T2__c = Decimal.valueOf(sWrapper.value);
				decimal baselineVol = 0;
				for(MRI_Volume__c mri : tpList[0].MRI_Volumes__r) {
					if(mri.Time_Point__c == 'Pre-Treatment') {
						baselineVol = mri.MRI_Volume_in_cm3__c;
					}
				}
				decimal interVol = 0;
				for(MRI_Volume__c mri : tpList[0].MRI_Volumes__r) {
					if(mri.Time_Point__c == 'Inter-Regimen') {
						interVol = mri.MRI_Volume_in_cm3__c;
					}
				}
				if(baselineVol != 0) {
					cd.MRIvol_T0_T2__c = (interVol - baselineVol) / baselineVol;
				}
			}
			else if(cm.Display_Order__c == 58) {
				//cd.MRIvol_T0_T3__c = Decimal.valueOf(sWrapper.value);
				decimal baselineVol = 0;
				for(MRI_Volume__c mri : tpList[0].MRI_Volumes__r) {
					if(mri.Time_Point__c == 'Pre-Treatment') {
						baselineVol = mri.MRI_Volume_in_cm3__c;
					}
				}
				decimal preVol = 0;
				for(MRI_Volume__c mri : tpList[0].MRI_Volumes__r) {
					if(mri.Time_Point__c == 'Pre-Surgery') {
						preVol = mri.MRI_Volume_in_cm3__c;
					}
				}
				if(baselineVol != 0) {
					cd.MRIvol_T0_T2__c = (preVol - baselineVol) / baselineVol;
				}
			}
			else if(cm.Display_Order__c == 59) {
				for(Response_Evaluation_Form__c r : lstTrialPatient[0].Response_Evaluation_Forms__r) {
					if(r.Reporting__c == 'Inter Regimen') {
						cd.InterDiseaseExt__c = r.Disease_Extent__c;
					}
				}
			}
			else if(cm.Display_Order__c == 60) {
				for(Response_Evaluation_Form__c r : lstTrialPatient[0].Response_Evaluation_Forms__r) {
					if(r.Reporting__c == 'Inter Regimen') {
						cd.InterNodeExt__c = r.Size_of_largest_node__c;
					}
				}
			}
			else if(cm.Display_Order__c == 61) {
				if(baselineRef != null && baselineRef.Disease_Extent__c != null) {
					cd.PresDiseaseExt__c = baselineRef.Disease_Extent__c;
				}
			}
			else if(cm.Display_Order__c == 62) {
				if(baselineRef != null && baselineRef.Disease_Extent__c != null) {
					cd.PresNodeExt__c = baselineRef.Size_of_largest_node__c;
				}
			}
			else if(cm.Display_Order__c == 63) {
				//cd.Surgery_Br__c = Decimal.valueOf(sWrapper.value);
				if(pssList.isEmpty() || pssList[0].Procedures__r.isEmpty()) {
					cd.Surgery_Br__c = 0;
				} else {
					for(Procedure__c p : pssList[0].Procedures__r) {
						if(p.Procedure_Name__c == 'Partial mastectomy') {
							cd.Surgery_Br__c = 1;
						} else if(p.Procedure_Name__c == 'Therapeutic mastectomy') {
							cd.Surgery_Br__c = 2;
						} else if(p.Procedure_Name__c == 'Skin Sparing Mastectomy') {
							cd.Surgery_Br__c = 3;
						} else if(p.Procedure_Name__c == 'Total skin sparing mastectomy') {
							cd.Surgery_Br__c = 4;
						} else if(p.Procedure_Name__c == 'Modified radical mastectomy') {
							cd.Surgery_Br__c = 5;
						}
					}
				}
				
			}
			else if(cm.Display_Order__c == 64) {
				if(mapPro.get(tpId) != null && mapPro.get(tpId).Procedure_Name__c == 'Sentinel lymph node dissection') {
					cd.LNdissection_PS__c = 1;
				} else {
					cd.LNdissection_PS__c = 0;
				}
			}
			else if(cm.Display_Order__c == 65) {
				//cd.NumPosLN_PS__c = Decimal.valueOf(sWrapper.value);
				cd.NumPosLN_PS__c = 0;
				if(pssList.isEmpty() || pssList[0].Lymph_Nodes__r.isEmpty())continue;
				for(Lymph_Nodes__c ln : pssList[0].Lymph_Nodes__r) {
					cd.NumPosLN_PS__c += ln.Positive__c;
				}
			}
			else if(cm.Display_Order__c == 66) {
				//cd.NumExLN_PS__c = Decimal.valueOf(sWrapper.value);
				cd.NumExLN_PS__c = 0;
				if(pssList.isEmpty() || pssList[0].Lymph_Nodes__r.isEmpty())continue;
				for(Lymph_Nodes__c ln : pssList[0].Lymph_Nodes__r) {
					cd.NumExLN_PS__c += ln.Examined__c;
				}
			}
			else if(cm.Display_Order__c == 67) {
				//cd.SizeMetLN_PS__c = Decimal.valueOf(sWrapper.value);
				if(pssList.isEmpty())continue;
				for(Lymph_Nodes__c ln : pssList[0].Lymph_Nodes__r) {
					if(ln.Additional_Nodes__c || ln.Size_of_Largest_Tumor__c == 'Not Reported')continue;
					if(ln.Size_of_Largest_Tumor__c == 'Specify' && cd.SizeMetLN_PS__c != null && cd.SizeMetLN_PS__c < ln.Specific_Size_of_Largest_Tumor__c) {
						cd.SizeMetLN_PS__c = ln.Specific_Size_of_Largest_Tumor__c;
					}
				}
			}
			else if(cm.Display_Order__c == 68) {
				//cd.pCR__c = Decimal.valueOf(sWrapper.value);
				if(pssList.isEmpty())continue;
				if(pssList[0].pcr__c) {
					cd.pCR__c = 1;
				} else {
					cd.pCR__c = 0;
				}
			}
			else if(cm.Display_Order__c == 69) {
				//cd.RCB_class__c = Decimal.valueOf(sWrapper.value);
				if(pssList.isEmpty() || pssList[0].RCB_Class__c == null)continue;
				if(pssList[0].RCB_Class__c == '0') {
					cd.RCB_class__c = 0;
				} else if(pssList[0].RCB_Class__c == 'I') {
					cd.RCB_class__c = 1;
				} else if(pssList[0].RCB_Class__c == 'II') {
					cd.RCB_class__c = 2;
				} else if(pssList[0].RCB_Class__c == 'III') {
					cd.RCB_class__c = 3;
				}
			}
			else if(cm.Display_Order__c == 70) {
				//cd.RCB_index__c = Decimal.valueOf(sWrapper.value);
				if(pssList.isEmpty() || pssList[0].RCB_index__c == null)continue;
				cd.RCB_index__c = pssList[0].RCB_index__c;
			}
			else if(cm.Display_Order__c == 71) {
				List<Invasive_Tumor_Detail__c> iList = [Select Invasive_ductal_carcinoma_nos__c,Invasive_lobular_carcinoma_classic_type__c,Invasive_lobular_carcinoma_alveolar_type__c,Pleomorphic_lobular_carcinoma__c,Tubulolobular_carcinoma__c,Invasive_carcinoma_mixed_ductal_lobular__c,Tubular_carcinoma__c,Mucinous_carcinoma__c,Medullary_carcinoma__c,Invasive_papillary_carcinoma__c,Invasive_cribiform_carcinoma__c,Other__c From Invasive_Tumor_Detail__c i where Post_Surgery_Summary__r.Status__c = 'Accepted' and Post_Surgery_Summary__r.TrialPatient__c = :tpId];
				cd.InvHistology_PS__c = '';
				if(!iList.isEmpty()) {
					Invasive_Tumor_Detail__c inv = iList[0];
					if(inv.Invasive_ductal_carcinoma_nos__c) {
		                cd.InvHistology_PS__c = '1';
		            }
		            if(inv.Invasive_lobular_carcinoma_classic_type__c) {
						cd.InvHistology_PS__c += '2' + ',';
		            }
		            if(inv.Invasive_lobular_carcinoma_alveolar_type__c) {
		                cd.InvHistology_PS__c += '3' + ',';
		            }
		            if(inv.Pleomorphic_lobular_carcinoma__c) {
		                cd.InvHistology_PS__c = '4' + ',';
		            }
		            if(inv.Tubulolobular_carcinoma__c) {
		                cd.InvHistology_PS__c = '5' + ',';
		            }
		            if(inv.Invasive_carcinoma_mixed_ductal_lobular__c) {
		                cd.InvHistology_PS__c = '6' + ',';
		            }
		            if(inv.Tubular_carcinoma__c) {
		                cd.InvHistology_PS__c = '7' + ',';
		            }
		            if(inv.Mucinous_carcinoma__c) {
		                cd.InvHistology_PS__c = '8' + ',';
		            }
		            if(inv.Medullary_carcinoma__c) {
		                cd.InvHistology_PS__c = '9' + ',';
		            }
		            if(inv.Invasive_papillary_carcinoma__c) {
		                cd.InvHistology_PS__c = '10' + ',';
		            }
		            if(inv.Invasive_cribiform_carcinoma__c) {
		                cd.InvHistology_PS__c = '11' + ',';
		            }
		            if(inv.Other__c) {
		                cd.InvHistology_PS__c = '12';
		            }
		            if(cd.InvHistology_PS__c.endsWith(',')) {
		            	cd.InvHistology_PS__c = cd.InvHistology_PS__c.substring(0,cd.InvHistology_PS__c.length()-1);
		            }
				}
			}
			else if(cm.Display_Order__c == 72) {
				//cd.InvSBR_PS__c = Decimal.valueOf(sWrapper.value);
				if(pssList.isEmpty() || pssList[0].Invasive_Tumor_Details__r.isEmpty())continue;
				Invasive_Tumor_Detail__c inv = pssList[0].Invasive_Tumor_Details__r[0];
				if(inv.SBR_Grade__c == 'I') {
					cd.InvSBR_PS__c = 1;
				} else if(inv.SBR_Grade__c == 'II') {
					cd.InvSBR_PS__c = 2;
				} else if(inv.SBR_Grade__c == 'Indeterminate') {
					cd.InvSBR_PS__c = 4;
				} else if(inv.SBR_Grade__c == 'III') {
					cd.InvSBR_PS__c = 3;
				}
			}
			else if(cm.Display_Order__c == 73) {
				//cd.InSitu_PS__c = Decimal.valueOf(sWrapper.value);
				if(pssList.isEmpty())continue;
				if(pssList[0].LCIS__r.isEmpty() && pssList[0].DCIS__r.isEmpty()) {
					cd.InSitu_PS__c = 0;
				} else if(!pssList[0].LCIS__r.isEmpty() && pssList[0].DCIS__r.isEmpty()) {
					cd.InSitu_PS__c = 2;
				} else if(pssList[0].LCIS__r.isEmpty() && !pssList[0].DCIS__r.isEmpty()) {
					cd.InSitu_PS__c = 1;
				}
			}
			else if(cm.Display_Order__c == 74) {
				//cd.PathologyStage_PS__c = Decimal.valueOf(sWrapper.value);
				if(pssList.isEmpty() || pssList[0].Staging_Details__r.isEmpty())continue;
				Staging_Detail__c sd = pssList[0].Staging_Details__r[0];
				if(sd.Adjudicated_Stage__c == 'Stage 0') {
					cd.PathologyStage_PS__c = 1;
				} else if(sd.Adjudicated_Stage__c == 'Stage IA') {
					cd.PathologyStage_PS__c = 2;
				} else if(sd.Adjudicated_Stage__c == 'Stage IB') {
					cd.PathologyStage_PS__c = 3;
				} else if(sd.Adjudicated_Stage__c == 'Stage IIA') {
					cd.PathologyStage_PS__c = 4;
				} else if(sd.Adjudicated_Stage__c == 'Stage IIB') {
					cd.PathologyStage_PS__c = 5;
				} else if(sd.Adjudicated_Stage__c == 'Stage IIIA') {
					cd.PathologyStage_PS__c = 6;
				} else if(sd.Adjudicated_Stage__c == 'Stage IIIB') {
					cd.PathologyStage_PS__c = 7;
				} else if(sd.Adjudicated_Stage__c == 'Stage IIIC') {
					cd.PathologyStage_PS__c = 8;
				} else if(sd.Adjudicated_Stage__c == 'Stage IV') {
					cd.PathologyStage_PS__c = 9;
				}
			}
			else if(cm.Display_Order__c == 75) {
				//cd.ERstatus_PS__c = Decimal.valueOf(sWrapper.value);
				if(pssList.isEmpty() || pssList[0].Receptors__r.isEmpty())continue;
				if(pssList[0].Receptors__r[0].Estrogen_Receptor_Status__c == 'Negative') {
					cd.ERstatus_PS__c = 0;
				} else if(pssList[0].Receptors__r[0].Estrogen_Receptor_Status__c == 'Positive') {
					cd.ERstatus_PS__c = 1;
				} else if(pssList[0].Receptors__r[0].Estrogen_Receptor_Status__c == 'Indeterminate') {
					cd.ERstatus_PS__c = 2;
				} else if(pssList[0].Receptors__r[0].Estrogen_Receptor_Status__c == 'Not Reported') {
					cd.ERstatus_PS__c = 3;
				}
			}
			else if(cm.Display_Order__c == 76) {
				//cd.PRstatus_PS__c = Decimal.valueOf(sWrapper.value);
				if(pssList.isEmpty() || pssList[0].Receptors__r.isEmpty())continue;
				if(pssList[0].Receptors__r[0].Progesterone_Receptor_Status__c  == 'Negative') {
					cd.PRstatus_PS__c = 0;
				} else if(pssList[0].Receptors__r[0].Progesterone_Receptor_Status__c  == 'Positive') {
					cd.PRstatus_PS__c = 1;
				} else if(pssList[0].Receptors__r[0].Progesterone_Receptor_Status__c  == 'Indeterminate') {
					cd.PRstatus_PS__c = 2;
				} else if(pssList[0].Receptors__r[0].Progesterone_Receptor_Status__c  == 'Not Reported') {
					cd.PRstatus_PS__c = 3;
				}
			}
			else if(cm.Display_Order__c == 77) {
				//cd.Her2status_PS__c = Decimal.valueOf(sWrapper.value);
				if(pssList.isEmpty() || pssList[0].Receptors__r.isEmpty())continue;
				if(pssList[0].Receptors__r[0].HER2_neu_Marker__c  == 'Negative') {
					cd.Her2status_PS__c = 0;
				} else if(pssList[0].Receptors__r[0].HER2_neu_Marker__c  == 'Positive') {
					cd.Her2status_PS__c = 1;
				} else if(pssList[0].Receptors__r[0].HER2_neu_Marker__c  == 'Indeterminate') {
					cd.Her2status_PS__c = 2;
				} else if(pssList[0].Receptors__r[0].HER2_neu_Marker__c  == 'Not Reported') {
					cd.Her2status_PS__c = 3;
				}
			}
			else if(cm.Display_Order__c == 78) {
				//cd.DCISHistology_PS__c = Decimal.valueOf(sWrapper.value);
				if(pssList.isEmpty() || pssList[0].DCIS__r.isEmpty())continue;
				if(pssList[0].DCIS__r[0].Punctate_necrosis__c) {
					cd.DCISHistology_PS__c = 1;
				} else if(pssList[0].DCIS__r[0].Comedonecrosis__c) {
					cd.DCISHistology_PS__c = 2;
				} else if(pssList[0].DCIS__r[0].Papillary__c) {
					cd.DCISHistology_PS__c = 3;
				} else if(pssList[0].DCIS__r[0].Micropapillary__c) {
					cd.DCISHistology_PS__c = 4;
				} else if(pssList[0].DCIS__r[0].Necrosis__c) {
					cd.DCISHistology_PS__c = 5;
				} else if(pssList[0].DCIS__r[0].Cribiform__c) {
					cd.DCISHistology_PS__c = 6;
				} else if(pssList[0].DCIS__r[0].Cruciform__c) {
					cd.DCISHistology_PS__c = 7;
				} else if(pssList[0].DCIS__r[0].Clinging__c) {
					cd.DCISHistology_PS__c = 8;
				} else if(pssList[0].DCIS__r[0].Solid__c) {
					cd.DCISHistology_PS__c = 9;
				} else if(pssList[0].DCIS__r[0].Apocrine__c) {
					cd.DCISHistology_PS__c = 10;
				} else if(pssList[0].DCIS__r[0].Intra_cystic_encysted_papillary__c) {
					cd.DCISHistology_PS__c = 11;
				} else if(pssList[0].DCIS__r[0].Other__c) {
					cd.DCISHistology_PS__c = 12;
				}
			}
			else if(cm.Display_Order__c == 79) {
				//cd.DCISGrade_PS__c = Decimal.valueOf(sWrapper.value);
				if(pssList.isEmpty() || pssList[0].DCIS__r.isEmpty())continue;
				if(pssList[0].DCIS__r[0].Nuclear_Grade__c == 'Grade I') {
					cd.DCISGrade_PS__c = 1;
				} else if(pssList[0].DCIS__r[0].Nuclear_Grade__c == 'Grade II') {
					cd.DCISGrade_PS__c = 2;
				} else if(pssList[0].DCIS__r[0].Nuclear_Grade__c == 'Grade III') {
					cd.DCISGrade_PS__c = 3;
				} else if(pssList[0].DCIS__r[0].Nuclear_Grade__c == 'Indeterminate') {
					cd.DCISGrade_PS__c = 4;
				} else if(pssList[0].DCIS__r[0].Nuclear_Grade__c == 'Not Reported') {
					cd.DCISGrade_PS__c = 5;
				}
			}
			else if(cm.Display_Order__c == 80) {
				//cd.DCIS_PS__c = Decimal.valueOf(sWrapper.value);
				if(pssList.isEmpty() || pssList[0].DCIS__r.isEmpty())continue;
				cd.DCIS_PS__c = pssList[0].DCIS__r[0].DCIS__c;
			}
			else if(cm.Display_Order__c == 81) {
				if(mapDcis.get(tpId) != null) {
					cd.DCISspan_PS__c = mapDcis.get(tpId).Total_histological_span__c;
				}
			}
			else if(cm.Display_Order__c == 82) {
				//cd.LCISHistology_PS__c = Decimal.valueOf(sWrapper.value);
				if(pssList.isEmpty() || pssList[0].LCIS__r.isEmpty())continue;
				if(pssList[0].LCIS__r[0].Histological_Type__c  == 'Classic') {
					cd.LCISHistology_PS__c = 1;
				} else if(pssList[0].LCIS__r[0].Histological_Type__c  == 'Small Cell') {
					cd.LCISHistology_PS__c = 2;
				} else if(pssList[0].LCIS__r[0].Histological_Type__c  == 'Large Cell') {
					cd.LCISHistology_PS__c = 3;
				} else if(pssList[0].LCIS__r[0].Histological_Type__c  == 'Pleomorphic') {
					cd.LCISHistology_PS__c = 4;
				} else if(pssList[0].LCIS__r[0].Histological_Type__c  == 'Unknown') {
					cd.LCISHistology_PS__c = 5;
				}
			}
			else if(cm.Display_Order__c == 83) {
				if(mapLcis.get(tpId) != null) {
					cd.LCIS_PS__c = mapLcis.get(tpId).LCIS__c;
				}
			}
			else if(cm.Display_Order__c == 84) {
				if(mapLcis.get(tpId) != null) {
					cd.LCISspan_PS__c = mapLcis.get(tpId).Total_histological_span__c;
				}
			}
			else if(cm.Display_Order__c == 85) {
				//cd.InvMultifocal_PS__c = Decimal.valueOf(sWrapper.value);
				if(pssList.isEmpty() || pssList[0].Invasive_Tumor_Details__r.isEmpty())continue;
				if(pssList[0].Invasive_Tumor_Details__r[0].Multi_focal_Tumor__c == 'Yes') {
					cd.InvMultifocal_PS__c = 1;
				} else if(pssList[0].Invasive_Tumor_Details__r[0].Multi_focal_Tumor__c == 'No') {
					cd.InvMultifocal_PS__c = 0;
				} else if(pssList[0].Invasive_Tumor_Details__r[0].Multi_focal_Tumor__c == 'Not reported') {
					cd.InvMultifocal_PS__c = 2;
				}
			}
			else if(cm.Display_Order__c == 86) {
				//cd.InvMargin_PS__c = Decimal.valueOf(sWrapper.value);
				if(pssList.isEmpty() || pssList[0].Invasive_Tumor_Details__r.isEmpty())continue;
				for(Invasive_Tumor_Detail__c inv : pssList[0].Invasive_Tumor_Details__r) {
					if(inv.Invasive_margins__c == 'Negative') {
						cd.InvMargin_PS__c = 0;
					} else if(inv.Invasive_margins__c == 'Positive') {
						cd.InvMargin_PS__c = 1;
					}
				}
			}
			else if(cm.Display_Order__c == 87) {
				//cd.Inv_PS__c = Decimal.valueOf(sWrapper.value);
				if(pssList.isEmpty() || pssList[0].Invasive_Tumor_Details__r.isEmpty())continue;
				for(Invasive_Tumor_Detail__c inv : pssList[0].Invasive_Tumor_Details__r) {
					cd.InvMargin_PS__c = inv.Overall_cancer_cellularity__c;
				}
			}
			else if(cm.Display_Order__c == 88) {
				//cd.LVI_PS__c = Decimal.valueOf(sWrapper.value);
				if(pssList.isEmpty() || pssList[0].Invasive_Tumor_Details__r.isEmpty())continue;
				for(Invasive_Tumor_Detail__c inv : pssList[0].Invasive_Tumor_Details__r) {
					if(inv.Lympatic_vascular_Invasion__c == 'No') {
						cd.LVI_PS__c = 0;
					} else if(inv.Lympatic_vascular_Invasion__c == 'Yes') {
						cd.LVI_PS__c = 1;
					} else if(inv.Lympatic_vascular_Invasion__c == 'Not Reported') {
						cd.LVI_PS__c = 2;
					}
				}
			}
			else if(cm.Display_Order__c == 89) {
				//cd.DermInvolve_PS__c = Decimal.valueOf(sWrapper.value);
				if(pssList.isEmpty() || pssList[0].Invasive_Tumor_Details__r.isEmpty())continue;
				for(Invasive_Tumor_Detail__c inv : pssList[0].Invasive_Tumor_Details__r) {
					if(inv.Dermal_Involvement__c == 'No') {
						cd.DermInvolve_PS__c = 0;
					} else if(inv.Dermal_Involvement__c == 'Yes') {
						cd.DermInvolve_PS__c = 1;
					} else if(inv.Dermal_Involvement__c == 'Suspicious') {
						cd.DermInvolve_PS__c = 2;
					} else if(inv.Dermal_Involvement__c == 'Not Reported') {
						cd.DermInvolve_PS__c = 3;
					} else if(inv.Dermal_Involvement__c == 'No skin/nipple present') {
						cd.DermInvolve_PS__c = 4;
					}
				}
			}
			else if(cm.Display_Order__c == 90) {
				//cd.ypT__c = sWrapper.value;
				if(pssList.isEmpty() || pssList[0].Staging_Details__r.isEmpty())continue;
				cd.ypT__c = pssList[0].Staging_Details__r[0].Tumor_Type__c;
			}
			else if(cm.Display_Order__c == 91) {
				//cd.ypN__c = sWrapper.value;
				if(pssList.isEmpty() || pssList[0].Staging_Details__r.isEmpty())continue;
				cd.ypN__c = pssList[0].Staging_Details__r[0].Node_Type__c;
			}
			else if(cm.Display_Order__c == 92) {
				//cd.ypM__c = sWrapper.value;
				if(pssList.isEmpty() || pssList[0].Staging_Details__r.isEmpty())continue;
				cd.ypM__c = pssList[0].Staging_Details__r[0].Metastasis__c;
			}
			else if(cm.Display_Order__c == 93) {
				//cd.GrossPathSize1_PS__c = Decimal.valueOf(sWrapper.value);
				if(!pssList.isEmpty()) {
					cd.GrossPathSize1_PS__c = pssList[0].Size_of_Gross_Mass_Width__c;
				}
			}
			else if(cm.Display_Order__c == 94) {
				//cd.GrossPathSize2_PS__c = Decimal.valueOf(sWrapper.value);
				if(!pssList.isEmpty()) {
					cd.GrossPathSize2_PS__c = pssList[0].Size_of_Gross_Mass_Height__c;
				}
			}
			else if(cm.Display_Order__c == 95) {
				//cd.InvPathSize1_PS__c = Decimal.valueOf(sWrapper.value);
				if(pssList.isEmpty() || pssList[0].Invasive_Tumor_Details__r.isEmpty())continue;
				for(Invasive_Tumor_Detail__c inv : pssList[0].Invasive_Tumor_Details__r) {
					cd.InvPathSize1_PS__c = inv.Tumor_Size_Width__c;
				}
			}
			else if(cm.Display_Order__c == 96) {
				//cd.InvPathSize2_PS__c = Decimal.valueOf(sWrapper.value);
				if(pssList.isEmpty() || pssList[0].Invasive_Tumor_Details__r.isEmpty())continue;
				for(Invasive_Tumor_Detail__c inv : pssList[0].Invasive_Tumor_Details__r) {
					cd.InvPathSize2_PS__c = inv.Tumor_Size_Height__c;
				}
			}
			else if(cm.Display_Order__c == 97) {
				//cd.LocalProgress__c = Decimal.valueOf(sWrapper.value);
				if(localProgressVal != -1) {
					cd.LocalProgress__c = localProgressVal;
				}
			}
			else if(cm.Display_Order__c == 98) {
				//cd.DistProgress__c = Decimal.valueOf(sWrapper.value);
				if(distProgressVal != -1) {
					cd.DistProgress__c = distProgressVal;
				}
			}
			else if(cm.Display_Order__c == 99) {
				//cd.LocalProgSite__c = Decimal.valueOf(sWrapper.value);
				if(localProgSiteVal != -1) {
					cd.LocalProgSite__c = localProgSiteVal;
				}
			}
			else if(cm.Display_Order__c == 100) {
				//cd.DistProgSite__c = Decimal.valueOf(sWrapper.value);
				if(distProgSiteVal != -1) {
					cd.DistProgSite__c = distProgSiteVal;
				}
			}
			else if(cm.Display_Order__c == 101) {
				//cd.LocalProgTimeD__c = Decimal.valueOf(sWrapper.value);
				if(localProgTimeDays != -1) {
					cd.LocalProgTimeD__c = localProgTimeDays;
				}
			}
			else if(cm.Display_Order__c == 102) {
				//cd.DistProgTimeD__c = Decimal.valueOf(sWrapper.value);
				if(distProgTimeDays != -1) {
					cd.DistProgTimeD__c = distProgTimeDays;
				}
			}
			else if(cm.Display_Order__c == 103) {
				//cd.NewPrimeCa__c = Decimal.valueOf(sWrapper.value);
				if(newPrimaryCa != -1) {
					cd.NewPrimeCa__c = newPrimaryCa;
				}
			}
			else if(cm.Display_Order__c == 104) {
				//cd.NewPrimeTimeD__c = Decimal.valueOf(sWrapper.value);
				if(newPrimaryDays != -1) {
					cd.NewPrimeTimeD__c = newPrimaryDays;
				}
			}
			else if(cm.Display_Order__c == 105) {
				//cd.NewPrimeTx__c = Decimal.valueOf(sWrapper.value);
				if(newPrimeTxVal != -1) {
					cd.NewPrimeTx__c = newPrimeTxVal;
				}
			}
			else if(cm.Display_Order__c == 106) {
				//cd.RtTherapy__c = Decimal.valueOf(sWrapper.value);
				if(rtTherapyVal != -1) {
					cd.RtTherapy__c = rtTherapyVal;
				}
			}
			else if(cm.Display_Order__c == 107) {
				//cd.RtSite__c = sWrapper.value;
				cd.RtSite__c = rtSiteVal;
			}
			else if(cm.Display_Order__c == 108) {
				//cd.Adj_AromataseInhib__c = Decimal.valueOf(sWrapper.value);
				if(adj_AromataseInhib != -1) {
					cd.Adj_AromataseInhib__c = adj_AromataseInhib;
				}
			}
			else if(cm.Display_Order__c == 109) {
				//cd.Adj_OvarianSup__c = Decimal.valueOf(sWrapper.value);
				if(adj_OvarianSup != -1) {
					cd.Adj_OvarianSup__c = adj_OvarianSup;
				}
			}
			else if(cm.Display_Order__c == 110) {
				//cd.Adj_OvarianAbl__c = Decimal.valueOf(sWrapper.value);
				if(adj_OvarianAbl != -1) {
					cd.Adj_OvarianAbl__c = adj_OvarianAbl;
				}
			}
			else if(cm.Display_Order__c == 111) {
				//cd.Adj_Tam__c = Decimal.valueOf(sWrapper.value);
				if(adj_Tam != -1) {
					cd.Adj_Tam__c = adj_Tam;
				}
			}
			else if(cm.Display_Order__c == 112) {
				//cd.Adj_Trastuzumab__c = Decimal.valueOf(sWrapper.value);
				if(adj_Trastuzumab != -1) {
					cd.Adj_Trastuzumab__c = adj_Trastuzumab;
				}
			}
			else if(cm.Display_Order__c == 113) {
				//cd.Adj_Chemo__c = Decimal.valueOf(sWrapper.value);
				if(adj_Chemo != -1) {
					cd.Adj_Chemo__c = adj_Chemo;
				}
			}
			else if(cm.Display_Order__c == 114) {
				//cd.Adj_ChemoReg__c = (sWrapper.value);
				cd.Adj_ChemoReg__c = adj_ChemoReg;
			}
			else if(cm.Display_Order__c == 115) {
				//cd.Adj_Other__c = Decimal.valueOf(sWrapper.value);
				if(adj_Other != -1) {
					cd.Adj_Other__c = adj_Other;
				}
			}
			else if(cm.Display_Order__c == 116) {
				//cd.Adu_OtherReg__c = (sWrapper.value);
				cd.Adu_OtherReg__c = adj_OtherVal;
			}
		}
		insert cd;
		
		/*Map<String, Map<String, String>> mapSnomedCodes = new Map<String, Map<String, String>>();
		for(SnomedWrapper sWrapper : lstSnomedWrapper) {
			
			if(mapSnomedCodes.containsKey(sWrapper.subjectId)) {
				mapSnomedCodes.get(sWrapper.subjectId).put(sWrapper.snomedMasterId, sWrapper.value);
				//system.debug('Display Order : '+sWrapper.displayOrder+'   value : '+sWrapper.value);
			} else {
				mapSnomedCodes.put(sWrapper.subjectId, new Map<String, String>{sWrapper.snomedMasterId=>sWrapper.value});
			}
		}
		
		
		for(String subjectId : mapSnomedCodes.keySet()) {
			values += subjectId+',';
			values += system.today()+',';
			Map<String, String> codeMap = mapSnomedCodes.get(subjectId);
			for(Id id : sIds) {
				
				if(mapSnomedCodes.get(subjectId).get(id) != null) {
					
					values += mapSnomedCodes.get(subjectId).get(id)+','; 
				} else {
					values += ',';
				}
			}
			values += '\n';
		}*/
		//return values;	
	}
	
	Map<String, Code_Master__c> mapSnomedNames = new Map<String, Code_Master__c>();
	String generateCaIntegratorCSVTitle() {
		
		String title = '';
		title += 'ISPY2ID,'; 
		title += 'ExtractDate,';
		List<Code_Master__c> lstSnomedMaster = [Select s.Id, s.Name, s.Display_Order__c From Code_Master__c s where IsReportColumn__c = true order by Display_Order__c ASC];
		for(Code_Master__c snomed : lstSnomedMaster) {
			title += snomed.Name+',';
			sIds.add(snomed.Id);
			if(snomed.Name == 'BirthCountry') {
				mapSnomedNames.put(snomed.Name, snomed);
			} else if(snomed.Name == 'Completed Tx') {
				mapSnomedNames.put(snomed.Name, snomed);
			} else if(snomed.Name == 'StudyChemo') {
				mapSnomedNames.put(snomed.Name, snomed);
			} else if(snomed.Name == 'NonStudyChemo') {
				mapSnomedNames.put(snomed.Name, snomed);
			} else if(snomed.Name == 'InterDiseaseExt') {
				mapSnomedNames.put(snomed.Name, snomed);
			} else if(snomed.Name == 'InterNodeExt') {
				mapSnomedNames.put(snomed.Name, snomed);
			} else if(snomed.Name == 'PresDiseaseExt') {
				mapSnomedNames.put(snomed.Name, snomed);
			} else if(snomed.Name == 'PresNodeExt') {
				mapSnomedNames.put(snomed.Name, snomed);
			} else if(snomed.Name == 'LNdissection_PS') {
				mapSnomedNames.put(snomed.Name, snomed);
			} else if(snomed.Name == 'Her2status_PS') {
				mapSnomedNames.put(snomed.Name, snomed);
			} else if(snomed.Name == 'Her2IHCtest_OS') {
				mapSnomedNames.put(snomed.Name, snomed);
			} else if(snomed.Name == 'Her2FISHtest_OS') {
				mapSnomedNames.put(snomed.Name, snomed);
			} else if(snomed.Name == 'DCIS%_PS') {
				mapSnomedNames.put(snomed.Name, snomed);
			} else if(snomed.Name == 'DCISspan_PS') {
				mapSnomedNames.put(snomed.Name, snomed);
			} else if(snomed.Name == 'LCIS%_PS') {
				mapSnomedNames.put(snomed.Name, snomed);
			} else if(snomed.Name == 'LCISspan_PS') {
				mapSnomedNames.put(snomed.Name, snomed);
			} else if(snomed.Name == 'DermInvolve_PS') {
				mapSnomedNames.put(snomed.Name, snomed);
			} else if(snomed.Name == 'RtSite') {
				mapSnomedNames.put(snomed.Name, snomed);
			} else if(snomed.Name == 'InSitu_OS') {
				mapSnomedNames.put(snomed.Name, snomed);
			} else if(snomed.Name == 'Adj_Chemo') {
				mapSnomedNames.put(snomed.Name, snomed);
			}
		}
		system.debug('mapSnomedNames.size() : '+mapSnomedNames.size());
		title += '\n';
		
 		return title;
	}
	
	public static snomedWrapper prepareNotCodedValues(TrialPatient__c trialPatient, String value, String name, Code_Master__c snomedMaster) {
		SnomedWrapper snomedWrapper = new SnomedWrapper();
		snomedWrapper.displayOrder = Integer.valueOf(snomedMaster.Display_Order__c);
		snomedWrapper.patientId = trialPatient.Patient_Id__c;
		snomedWrapper.snomedMasterId = snomedMaster.Id;
		snomedWrapper.subjectId = trialPatient.Subject_Id__c;
		snomedWrapper.value = value;
		//lstSnomedWrapper.add(snomedWrapper);
		return snomedWrapper;
	}
	
	public class SnomedWrapper {
		public integer displayOrder {get;set;}
		public String snomedMasterId {get;set;}
		public String subjectId {get;set;}
		public String patientId {get;set;}
		public String value {get;set;}
	}
}