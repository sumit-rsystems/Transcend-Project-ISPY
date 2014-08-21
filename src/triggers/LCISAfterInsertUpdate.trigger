trigger LCISAfterInsertUpdate on LCIS__c (after insert, after update) {
	
	/*
	//commented because logic changed this method will called from its parent's future method
	if(Trigger.isUpdate) {
		Set<Id> postIds = new Set<Id>();
		for(LCIS__c lcis : trigger.new) {
			postIds.add(lcis.Post_Surgery_Summary__c);
		}
		
		List<Post_Surgaory_Summary__c> lstPostSur = [select CRF__c, TrialPatient__c from Post_Surgaory_Summary__c where Id IN :postIds];
		Set<Id> CRFIds = new Set<Id>();
		for(Post_Surgaory_Summary__c pss : lstPostSur) {
			CRFIds.add(pss.CRF__c);
		}
		
		List<Snomed_Code__c> lstSnomedCode = [select id,CRF__c,Value__c,Name from Snomed_Code__c where CRF__c IN : CRFIds and snomed_Code_Name__c IN ('IHTSDO_4567')];
		if(!lstSnomedCode.isEmpty()) {
			delete lstSnomedCode;
		}
	}
	SnomedCTCode.insertLCISRelatedCodes(Trigger.newMap.keySet());*/
	/*Set<Id> postIds = new Set<Id>();
	Set<Id> ospIds = new Set<Id>();
	
	for(LCIS__c lcis : trigger.new) {
		postIds.add(lcis.Post_Surgery_Summary__c);
		ospIds.add(lcis.On_Study_Pathology_Form__c);
	}
	
	List<Post_Surgaory_Summary__c> lstPostSur = [select CRF__c, TrialPatient__c,(Select Id, OwnerId, IsDeleted, Name, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, Location__c, Procedure_Name__c, Laterality__c, Form_Name__c, Date_Of_Procedure__c, Node_Result__c, Node_Type__c, Ultrasound__c, Palpation_guided__c, Mammography__c, MRI__c, Stereotactic__c, Post_Surgery_Summary__c, TrialPatient__c, On_Study_Pathology_Form__c, Total_Positive__c, Total_Examined_Nodes__c, Surgeon__c, Patient__c, is_breast_surgical_procedure__c From Procedures__r), (Select Id, OwnerId, IsDeleted, Name, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, DCIS__c, Unknown_Not_Reported__c, Tumor_Size__c, Present_in_continous_section__c, Spanning__c, Present_as_scattered_microscopic_foci__c, Microscopic_foci_upto__c, From_Slide__c, To_Slide__c, Deep_Margin__c, Deep_Margin_Size__c, Medical__c, Medical_Size__c, Lateral__c, Lateral_Size__c, Anterior_Superior__c, Anterior_Superior_Size__c, Anterior_Inferior__c, Anterior_Inferior_Size__c, Punctate_necrosis__c, Comedonecrosis__c, Papillary__c, Micropapillary__c, Necrosis__c, Cribiform__c, Cruciform__c, Clinging__c, Solid__c, Apocrine__c, Intra_cystic_encysted_papillary__c, Calcifications__c, Nuclear_Grade__c, Total_Histological_Span__c, Total_Histological_Span_Measurement_Unit__c, Margin__c, Closest_Margin__c, Specific_Closest_Margin__c, Specific_Closest_Margin_Measurement_Unit__c, Other__c, Other_if_other_mention_type_in_textb__c, Calcifications_Present__c, Histology__c, On_Study_Pathology_Form__c, Post_Surgery_Summary__c From DCIS__r) from Post_Surgaory_Summary__c where Id IN :postIds];
	List<On_Study_Pathology_Form__c> lstOnStudyPath = [select CRF__c, TrialPatient__c from On_Study_Pathology_Form__c where Id IN :ospIds];
	
	if(Trigger.isInsert) {
		List<Snomed_Code__c> lstSnomed = new List<Snomed_Code__c>();
		List<Code_Master__c> lstSnomedMaster = [select id,Name,Variable_Description__c from Code_Master__c where Name = 'InvMargin_PS' 
		or Name = 'LCISHistology_PS' or Name = 'InSitu_OS' or Name = 'InSitu_PS'];
		
		for(LCIS__c lcis : trigger.new){
			for(Code_Master__c sm : lstSnomedMaster){
				for(Post_Surgaory_Summary__c pss : lstPostSur) {
					if(lcis.Post_Surgery_Summary__c == pss.Id) {
						if(sm.Name == 'LCISHistology_PS'){
							Snomed_Code__c sc25 = new Snomed_Code__c();
							sc25.CRF__c = pss.CRF__c;
							sc25.TrialPatient__c = pss.TrialPatient__c;
							sc25.Name = '33731-1'; //this same code also used in DCIS
							sc25.Code_Master__c = sm.Id;
							SnomedCTCode.SnomedWrapper sw25 = SnomedCTCode.SnomedCode('33731-1', lcis.LCIS__c+''); 
							sc25.Value__c = sw25.snomedCodeVal;
							sc25.caIntegratorValue__c = sw25.caIntegratorValue;
							sc25.Code_System__c = sw25.codeSystem;
							lstSnomed.add(sc25);
						}
						if(sm.Name == 'InSitu_PS'){
							if(pss.DCIS__r.Size()<=0) continue;
							List<DCIS__c> dcisList = pss.DCIS__r;
							Map<Id, Decimal> postIdDcisPercent = new Map<Id, Decimal>();
							for(DCIS__c dcis : dcisList) {
								postIdDcisPercent.put(dcis.Post_Surgery_Summary__c, dcis.DCIS__c);
							}
							Snomed_Code__c sc14 = new Snomed_Code__c();
							sc14.CRF__c = pss.CRF__c;
							sc14.TrialPatient__c = pss.TrialPatient__c;
							sc14.Name = 'IHTSDO_4567';
							sc14.Code_Master__c = sm.Id;
							SnomedCTCode.SnomedWrapper sw14;
							if(postIdDcisPercent.get(lcis.Post_Surgery_Summary__c) > lcis.LCIS__c) {
								sw14 = SnomedCTCode.SnomedCode('IHTSDO_4567', postIdDcisPercent.get(lcis.Post_Surgery_Summary__c)+'');
							} else {
								sw14 = SnomedCTCode.SnomedCode('IHTSDO_4567', lcis.LCIS__c+'');
							}
							//SnomedCTCode.SnomedWrapper sw14 = SnomedCTCode.SnomedCode('IHTSDO_4567', 'N/A');
							sc14.Value__c = sw14.snomedCodeVal;
							sc14.caIntegratorValue__c = sw14.caIntegratorValue;
							sc14.Code_System__c = sw14.codeSystem;
							lstSnomed.add(sc14);
						}
					}
				}
				
				for(On_Study_Pathology_Form__c osp : lstOnStudyPath) {
					if(lcis.On_Study_Pathology_Form__c == osp.Id) {
						if(sm.Name == 'InSitu_OS'){
							Snomed_Code__c sc28 = new Snomed_Code__c();
							sc28.CRF__c = pss.CRF__c;
							sc28.TrialPatient__c = pss.TrialPatient__c;
							sc28.Name = 'IHTSDO_4567';
							sc28.Code_Master__c = sm.Id;
							SnomedCTCode.SnomedWrapper sw28 = SnomedCTCode.SnomedCode('IHTSDO_4567', ''); 
							sc28.Value__c = sw28.snomedCodeVal;
							sc28.caIntegratorValue__c = sw28.caIntegratorValue;
							sc28.Code_System__c = sw28.codeSystem;
							lstSnomed.add(sc28);
						}
					}
				}
			}
		}
		if(!lstSnomed.isEmpty()){
			upsert lstSnomed;
		}
	}
	
	if(Trigger.isUpdate) {
		Set<Id> CRFIds = new Set<Id>();
		for(Post_Surgaory_Summary__c pss : lstPostSur) {
			CRFIds.add(pss.CRF__c);
		}
		
		List<Snomed_Code__c> lstSnomedCode = [select id,CRF__c,Value__c,Name from Snomed_Code__c where CRF__c IN : CRFIds];
		for(LCIS__c lcis : trigger.new) {
			for(Snomed_Code__c sc : lstSnomedCode){
				for(Post_Surgaory_Summary__c pss : lstPostSur){
					if(lcis.Post_Surgery_Summary__c == pss.Id && sc.CRF__c == pss.CRF__c) {
						if(sc.Name == '33731-1'){
							SnomedCTCode.SnomedWrapper sw = SnomedCTCode.SnomedCode('33731-1', lcis.LCIS__c+'');
							sc.Value__c = sw.snomedCodeVal;
							sc.Code_System__c = sw.codeSystem;
							sc.caIntegratorValue__c = sw.caIntegratorValue;
						} 
						if(sc.Name == 'IHTSDO_4567'){
							if(pss.DCIS__r.Size()<=0) continue;
							List<DCIS__c> dcisList = pss.DCIS__r;
							Map<Id, Decimal> postIdDcisPercent = new Map<Id, Decimal>();
							for(DCIS__c dcis : dcisList) {
								postIdDcisPercent.put(dcis.Post_Surgery_Summary__c, dcis.DCIS__c);
							}
							SnomedCTCode.SnomedWrapper swSpan;
							if(postIdDcisPercent.get(lcis.Post_Surgery_Summary__c) > lcis.LCIS__c) {
								swSpan = SnomedCTCode.SnomedCode('IHTSDO_4567', postIdDcisPercent.get(lcis.Post_Surgery_Summary__c)+'');  
							} else {
								swSpan = SnomedCTCode.SnomedCode('IHTSDO_4567', lcis.LCIS__c+'');
							}
							sc.Value__c = swSpan.snomedCodeVal;
							sc.Code_System__c = swSpan.codeSystem;
							sc.caIntegratorValue__c = swSpan.caIntegratorValue;
						}  
					}
				}
			}
		}
	}*/
}