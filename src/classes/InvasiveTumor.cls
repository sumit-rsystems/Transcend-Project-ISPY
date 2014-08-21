public with sharing class InvasiveTumor extends ComponentControllerBase {
	
	public Invasive_Tumor_Detail__c objITD {get;set;}
	public String objId {get;}
	public string pathId{get;set;}
	
	/*public void setObjId(String setInvasiveId) {
		system.debug('__setInvasiveId__'+setInvasiveId);
		objITD = [Select LastModifiedDate ,Unknown_Not_Reported__c,Paget_disease__c,Ulceration_by_tumor__c,Derma_lymphatic_vascular_invasion__c, Tumor_Size__c, Tumor_Size_Width__c, Tumor_Size_Height__c, Tumor_Measurement_Unit__c,Tubulolobular_carcinoma__c,Tubule_Papilla_formation__c,Tubular_carcinoma__c, Total_Points__c,SystemModstamp,Specify_Units__c,Specify_No__c, Skin_Involvement__c, Signs_of_Treatment_Effect__c,SBR_Grade__c,Pleomorphic_lobular_carcinoma__c,Overall_cancer_cellularity__c, Other_if_other_mention_type_in_textbox__c, Other_changes_present__c, Other__c,Nuclear_Grade__c, Name, Muscle_involvement__c, Multi_focal_Tumor__c, Mucinous_carcinoma__c, Mitotic_Count__c, Medullary_carcinoma__c, Medical__c, Medical_Size__c, Lympatic_vascular_Invasion__c, Lateral__c, Lateral_Size__c,  Invasive_papillary_carcinoma__c, Invasive_margins_size__c, Invasive_margins__c, Invasive_lobular_carcinoma_classic_type__c, Invasive_lobular_carcinoma_alveolar_type__c, Invasive_ductal_carcinoma_nos__c, Invasive_cribiform_carcinoma__c, Invasive_carcinoma_mixed_ductal_lobular__c, Id, Evidence_of_therapeutic_effects__c,Dermal_Involvement__c, Deep_Margin__c, Deep_Margin_Size__c, Closest_Margin__c, Calcifications__c, Anterior_Superior_Size__c, Anterior_Superior__c, Anterior_Inferior__c, Anterior_Inferior_Size__c, Calcifications_Present__c From Invasive_Tumor_Detail__c where id = :setInvasiveId];
	}*/
	
	public void setObjId(String formId) {
		system.debug('__formId__'+formId);
		String postid = Apexpages.currentPage().getParameters().get('postid');
		String PathologyId = Apexpages.currentPage().getParameters().get('PathologyId');
		List<Invasive_Tumor_Detail__c> invasiveTmpList = new List<Invasive_Tumor_Detail__c>();
		
		if(postid != null) {
			invasiveTmpList = [Select LastModifiedDate ,Unknown_Not_Reported__c,Paget_disease__c,Ulceration_by_tumor__c,Derma_lymphatic_vascular_invasion__c, Tumor_Size__c, Tumor_Size_Width__c, Tumor_Size_Height__c, Tumor_Measurement_Unit__c,Tubulolobular_carcinoma__c,Tubule_Papilla_formation__c,Tubular_carcinoma__c, Total_Points__c,SystemModstamp,Specify_Units__c,Specify_No__c, Skin_Involvement__c, Signs_of_Treatment_Effect__c,SBR_Grade__c,Pleomorphic_lobular_carcinoma__c,Overall_cancer_cellularity__c, Other_if_other_mention_type_in_textbox__c, Other_changes_present__c, Other__c,Nuclear_Grade__c, Name, Muscle_involvement__c, Multi_focal_Tumor__c, Mucinous_carcinoma__c, Mitotic_Count__c, Medullary_carcinoma__c, Medical__c, Medical_Size__c, Lympatic_vascular_Invasion__c, Lateral__c, Lateral_Size__c,  Invasive_papillary_carcinoma__c, Invasive_margins_size__c, Invasive_margins__c, Invasive_lobular_carcinoma_classic_type__c, Invasive_lobular_carcinoma_alveolar_type__c, Invasive_ductal_carcinoma_nos__c, Invasive_cribiform_carcinoma__c, Invasive_carcinoma_mixed_ductal_lobular__c, Id, Evidence_of_therapeutic_effects__c,Dermal_Involvement__c, Deep_Margin__c, Deep_Margin_Size__c, Closest_Margin__c, Calcifications__c, Anterior_Superior_Size__c, Anterior_Superior__c, Anterior_Inferior__c, Anterior_Inferior_Size__c, Calcifications_Present__c From Invasive_Tumor_Detail__c where Post_Surgery_Summary__c = : formId];
		} else if(pathId!= null) {
			invasiveTmpList = [Select LastModifiedDate ,Unknown_Not_Reported__c,Paget_disease__c,Ulceration_by_tumor__c,Derma_lymphatic_vascular_invasion__c, Tumor_Size__c, Tumor_Size_Width__c, Tumor_Size_Height__c, Tumor_Measurement_Unit__c,Tubulolobular_carcinoma__c,Tubule_Papilla_formation__c,Tubular_carcinoma__c, Total_Points__c,SystemModstamp,Specify_Units__c,Specify_No__c, Skin_Involvement__c, Signs_of_Treatment_Effect__c,SBR_Grade__c,Pleomorphic_lobular_carcinoma__c,Overall_cancer_cellularity__c, Other_if_other_mention_type_in_textbox__c, Other_changes_present__c, Other__c,Nuclear_Grade__c, Name, Muscle_involvement__c, Multi_focal_Tumor__c, Mucinous_carcinoma__c, Mitotic_Count__c, Medullary_carcinoma__c, Medical__c, Medical_Size__c, Lympatic_vascular_Invasion__c, Lateral__c, Lateral_Size__c,  Invasive_papillary_carcinoma__c, Invasive_margins_size__c, Invasive_margins__c, Invasive_lobular_carcinoma_classic_type__c, Invasive_lobular_carcinoma_alveolar_type__c, Invasive_ductal_carcinoma_nos__c, Invasive_cribiform_carcinoma__c, Invasive_carcinoma_mixed_ductal_lobular__c, Id, Evidence_of_therapeutic_effects__c,Dermal_Involvement__c, Deep_Margin__c, Deep_Margin_Size__c, Closest_Margin__c, Calcifications__c, Anterior_Superior_Size__c, Anterior_Superior__c, Anterior_Inferior__c, Anterior_Inferior_Size__c, Calcifications_Present__c From Invasive_Tumor_Detail__c where On_Study_Pathology_Form__c = : formId];
		}
		
		if(!invasiveTmpList.isEmpty()) {
			objITD = invasiveTmpList[0];
		}
	}
	
	public String getKey() {
		return key;
	}
	
	public void setKey(String value) {
		if(value!= null){
         Key  = value;
         if(pageController!= null)
            pageController.setComponentControllerMap(Key, this);
      	}
	}
	
	public void setPageController(PageControllerBase value) {
		if (value!= null) {
			pageController = value;
			pageController.setIvtComponentController(this);
	    }
	}
	
	public PageControllerBase getPageController() {
		return pageController;
	}
	
	public String onStudyPathologyId{get;set;}
	public String invasivePostId{get;set;}
	public Integer Ins{get;set;}
	public String totalPoints{get;set;}
	public String SBRGrade{get;set;}
	private String patientId{get;set;}
	
	public InvasiveTumor(){
		System.debug('----Invasive Constructor---->');
		List<On_Study_Pathology_Form__c> lstPathology = new List<On_Study_Pathology_Form__c>();
		List<Post_Surgaory_Summary__c> lstPostSur = new List<Post_Surgaory_Summary__c>();
		String PathologyId = Apexpages.currentPage().getParameters().get('PathologyId');
		String postid = Apexpages.currentPage().getParameters().get('postid');
		//patientId = Apexpages.currentPage().getParameters().get('patientId');
		objITD = new Invasive_Tumor_Detail__c();
		List<Invasive_Tumor_Detail__c> invasiveList = new List<Invasive_Tumor_Detail__c>();
		
		if(postid != null) {
			invasiveList = [Select LastModifiedDate ,Unknown_Not_Reported__c,Paget_disease__c,Ulceration_by_tumor__c,Derma_lymphatic_vascular_invasion__c, Tumor_Size__c, Tumor_Size_Width__c, Tumor_Size_Height__c, Tumor_Measurement_Unit__c,Tubulolobular_carcinoma__c,Tubule_Papilla_formation__c,Tubular_carcinoma__c, Total_Points__c,SystemModstamp,Specify_Units__c,Specify_No__c, Skin_Involvement__c, Signs_of_Treatment_Effect__c,SBR_Grade__c,Pleomorphic_lobular_carcinoma__c,Overall_cancer_cellularity__c, Other_if_other_mention_type_in_textbox__c, Other_changes_present__c, Other__c,Nuclear_Grade__c, Name, Muscle_involvement__c, Multi_focal_Tumor__c, Mucinous_carcinoma__c, Mitotic_Count__c, Medullary_carcinoma__c, Medical__c, Medical_Size__c, Lympatic_vascular_Invasion__c, Lateral__c, Lateral_Size__c,  Invasive_papillary_carcinoma__c, Invasive_margins_size__c, Invasive_margins__c, Invasive_lobular_carcinoma_classic_type__c, Invasive_lobular_carcinoma_alveolar_type__c, Invasive_ductal_carcinoma_nos__c, Invasive_cribiform_carcinoma__c, Invasive_carcinoma_mixed_ductal_lobular__c, Id, Evidence_of_therapeutic_effects__c,Dermal_Involvement__c, Deep_Margin__c, Deep_Margin_Size__c, Closest_Margin__c, Calcifications__c, Anterior_Superior_Size__c, Anterior_Superior__c, Anterior_Inferior__c, Anterior_Inferior_Size__c, Calcifications_Present__c From Invasive_Tumor_Detail__c where Post_Surgery_Summary__c = : postid];
		} else if(PathologyId != null) {
			invasiveList = [Select LastModifiedDate ,Unknown_Not_Reported__c,Paget_disease__c,Ulceration_by_tumor__c,Derma_lymphatic_vascular_invasion__c, Tumor_Size__c, Tumor_Size_Width__c, Tumor_Size_Height__c, Tumor_Measurement_Unit__c,Tubulolobular_carcinoma__c,Tubule_Papilla_formation__c,Tubular_carcinoma__c, Total_Points__c,SystemModstamp,Specify_Units__c,Specify_No__c, Skin_Involvement__c, Signs_of_Treatment_Effect__c,SBR_Grade__c,Pleomorphic_lobular_carcinoma__c,Overall_cancer_cellularity__c, Other_if_other_mention_type_in_textbox__c, Other_changes_present__c, Other__c,Nuclear_Grade__c, Name, Muscle_involvement__c, Multi_focal_Tumor__c, Mucinous_carcinoma__c, Mitotic_Count__c, Medullary_carcinoma__c, Medical__c, Medical_Size__c, Lympatic_vascular_Invasion__c, Lateral__c, Lateral_Size__c,  Invasive_papillary_carcinoma__c, Invasive_margins_size__c, Invasive_margins__c, Invasive_lobular_carcinoma_classic_type__c, Invasive_lobular_carcinoma_alveolar_type__c, Invasive_ductal_carcinoma_nos__c, Invasive_cribiform_carcinoma__c, Invasive_carcinoma_mixed_ductal_lobular__c, Id, Evidence_of_therapeutic_effects__c,Dermal_Involvement__c, Deep_Margin__c, Deep_Margin_Size__c, Closest_Margin__c, Calcifications__c, Anterior_Superior_Size__c, Anterior_Superior__c, Anterior_Inferior__c, Anterior_Inferior_Size__c, Calcifications_Present__c From Invasive_Tumor_Detail__c where On_Study_Pathology_Form__c = : PathologyId];
		}
		
		if(!invasiveList.isEmpty()) {
			objITD = invasiveList[0];
		}
		
		/*if(objId != null && objId != ''){
			objITD = [Select LastModifiedDate ,Unknown_Not_Reported__c,Paget_disease__c,Ulceration_by_tumor__c,Derma_lymphatic_vascular_invasion__c, Tumor_Size__c, Tumor_Size_Width__c, Tumor_Size_Height__c, Tumor_Measurement_Unit__c,Tubulolobular_carcinoma__c,Tubule_Papilla_formation__c,Tubular_carcinoma__c, Total_Points__c,SystemModstamp,Specify_Units__c,Specify_No__c, Skin_Involvement__c, Signs_of_Treatment_Effect__c,SBR_Grade__c,Pleomorphic_lobular_carcinoma__c,Overall_cancer_cellularity__c, Other_if_other_mention_type_in_textbox__c, Other_changes_present__c, Other__c,Nuclear_Grade__c, Name, Muscle_involvement__c, Multi_focal_Tumor__c, Mucinous_carcinoma__c, Mitotic_Count__c, Medullary_carcinoma__c, Medical__c, Medical_Size__c, Lympatic_vascular_Invasion__c, Lateral__c, Lateral_Size__c,  Invasive_papillary_carcinoma__c, Invasive_margins_size__c, Invasive_margins__c, Invasive_lobular_carcinoma_classic_type__c, Invasive_lobular_carcinoma_alveolar_type__c, Invasive_ductal_carcinoma_nos__c, Invasive_cribiform_carcinoma__c, Invasive_carcinoma_mixed_ductal_lobular__c, Id, Evidence_of_therapeutic_effects__c,Dermal_Involvement__c, Deep_Margin__c, Deep_Margin_Size__c, Closest_Margin__c, Calcifications__c, Anterior_Superior_Size__c, Anterior_Superior__c, Anterior_Inferior__c, Anterior_Inferior_Size__c, Calcifications_Present__c From Invasive_Tumor_Detail__c where id = : objId];
		}
		if(PathologyId != null && PathologyId != '' && !Test.isRunningTest()){	
			lstPathology = Database.query('select Id,LCIS__c,DCIS__c,Invasive_Tumor_Detail__c from On_Study_Pathology_Form__c where Id = \''+ PathologyId+'\'');
		}
		if(postid != null && postid != ''){
			lstPostSur = [select Id, Invasive_Tumor_Detail__c from Post_Surgaory_Summary__c where Id = :postid];
		}
		if(patientId != null) {
			List<Histology__c> histologyList = [Select Id From Histology__c h where Patient__c =:patientId];
			if(!histologyList.isEmpty()) {
				objITD = [Select i.Unknown_Not_Reported__c, i.Ulceration_by_tumor__c, i.Tumor_Size__c, i.Tumor_Size_Width__c, i.Tumor_Size_Height__c, i.Tumor_Measurement_Unit__c, i.Tubulolobular_carcinoma__c, i.Tubule_Papilla_formation__c, i.Tubular_carcinoma__c, i.Total_Points__c, i.SystemModstamp, i.Specify_Units__c, i.Specify_No__c, i.Skin_Involvement__c, i.Signs_of_Treatment_Effect__c, i.SBR_Grade__c, i.Pleomorphic_lobular_carcinoma__c, i.Paget_disease__c, i.OwnerId, i.Overall_cancer_cellularity__c, i.Other_if_other_mention_type_in_textbox__c, i.Other_changes_present__c, i.Other__c, i.Nuclear_Grade__c, i.Name, i.Muscle_involvement__c, i.Multi_focal_Tumor__c, i.Mucinous_carcinoma__c, i.Mitotic_Count__c, i.Medullary_carcinoma__c, i.Medical__c, i.Medical_Size__c, i.Lympatic_vascular_Invasion__c, i.Lateral__c, i.Lateral_Size__c, i.LastModifiedDate, i.LastModifiedById, i.IsDeleted, i.Invasive_papillary_carcinoma__c, i.Invasive_margins_size__c, i.Invasive_margins__c, i.Invasive_lobular_carcinoma_classic_type__c, i.Invasive_lobular_carcinoma_alveolar_type__c, i.Invasive_ductal_carcinoma_nos__c, i.Invasive_cribiform_carcinoma__c, i.Invasive_carcinoma_mixed_ductal_lobular__c, i.Id, i.Histology__c, i.Evidence_of_therapeutic_effects__c, i.Dermal_Involvement__c, i.Derma_lymphatic_vascular_invasion__c, i.Deep_Margin__c, i.Deep_Margin_Size__c, i.CreatedDate, i.CreatedById, i.Closest_Margin__c, i.Calcifications__c, i.Calcifications_Present__c, i.Anterior_Superior__c, i.Anterior_Superior_Size__c, i.Anterior_Inferior__c, i.Anterior_Inferior_Size__c From Invasive_Tumor_Detail__c i where Histology__c =:histologyList[0].Id];
			}
		}
		if(!lstPostSur.isEmpty() && lstPostSur[0].Invasive_Tumor_Detail__c != null){
			objITD = [Select LastModifiedDate ,Unknown_Not_Reported__c,Paget_disease__c,Ulceration_by_tumor__c,Derma_lymphatic_vascular_invasion__c, Tumor_Size__c, Tumor_Size_Width__c, Tumor_Size_Height__c, Tumor_Measurement_Unit__c,Tubulolobular_carcinoma__c,Tubule_Papilla_formation__c,Tubular_carcinoma__c, Total_Points__c,SystemModstamp,Specify_Units__c,Specify_No__c, Skin_Involvement__c, Signs_of_Treatment_Effect__c,SBR_Grade__c,Pleomorphic_lobular_carcinoma__c,Overall_cancer_cellularity__c, Other_if_other_mention_type_in_textbox__c, Other_changes_present__c, Other__c,Nuclear_Grade__c, Name, Muscle_involvement__c, Multi_focal_Tumor__c, Mucinous_carcinoma__c, Mitotic_Count__c, Medullary_carcinoma__c, Medical__c, Medical_Size__c, Lympatic_vascular_Invasion__c, Lateral__c, Lateral_Size__c,  Invasive_papillary_carcinoma__c, Invasive_margins_size__c, Invasive_margins__c, Invasive_lobular_carcinoma_classic_type__c, Invasive_lobular_carcinoma_alveolar_type__c, Invasive_ductal_carcinoma_nos__c, Invasive_cribiform_carcinoma__c, Invasive_carcinoma_mixed_ductal_lobular__c, Id, Evidence_of_therapeutic_effects__c,Dermal_Involvement__c, Deep_Margin__c, Deep_Margin_Size__c, Closest_Margin__c, Calcifications__c, Anterior_Superior_Size__c, Anterior_Superior__c, Anterior_Inferior__c, Anterior_Inferior_Size__c, Calcifications_Present__c From Invasive_Tumor_Detail__c where id = :lstPostSur[0].Invasive_Tumor_Detail__c];
		} else if(!lstPathology.isEmpty() && lstPathology[0].Invasive_Tumor_Detail__c != null){
			objITD = [Select LastModifiedDate ,Unknown_Not_Reported__c,Paget_disease__c,Ulceration_by_tumor__c,Derma_lymphatic_vascular_invasion__c, Tumor_Size__c, Tumor_Size_Width__c, Tumor_Size_Height__c, Tumor_Measurement_Unit__c,Tubulolobular_carcinoma__c,Tubule_Papilla_formation__c,Tubular_carcinoma__c, Total_Points__c,SystemModstamp,Specify_Units__c,Specify_No__c, Skin_Involvement__c, Signs_of_Treatment_Effect__c,SBR_Grade__c,Pleomorphic_lobular_carcinoma__c,Overall_cancer_cellularity__c, Other_if_other_mention_type_in_textbox__c, Other_changes_present__c, Other__c,Nuclear_Grade__c, Name, Muscle_involvement__c, Multi_focal_Tumor__c, Mucinous_carcinoma__c, Mitotic_Count__c, Medullary_carcinoma__c, Medical__c, Medical_Size__c, Lympatic_vascular_Invasion__c, Lateral__c, Lateral_Size__c,  Invasive_papillary_carcinoma__c, Invasive_margins_size__c, Invasive_margins__c, Invasive_lobular_carcinoma_classic_type__c, Invasive_lobular_carcinoma_alveolar_type__c, Invasive_ductal_carcinoma_nos__c, Invasive_cribiform_carcinoma__c, Invasive_carcinoma_mixed_ductal_lobular__c, Id, Evidence_of_therapeutic_effects__c,Dermal_Involvement__c, Deep_Margin__c, Deep_Margin_Size__c, Closest_Margin__c, Calcifications__c, Anterior_Superior_Size__c, Anterior_Superior__c, Anterior_Inferior__c, Anterior_Inferior_Size__c, Calcifications_Present__c From Invasive_Tumor_Detail__c where id = :lstPathology[0].Invasive_Tumor_Detail__c];
		} */
	}
	
	public void saveInvasiveTumor(Id ospId) {
		system.debug('----saveInvasiveTumor() Called-------');
		objITD.Total_Points__c = totalPoints;
		objITD.SBR_Grade__c = SBRGrade;
		system.debug('__objITD__'+objITD);
		objITD.On_Study_Pathology_Form__c = ospId;
		upsert objITD;
		/*List<On_Study_Pathology_Form__c> lstPathology = Database.query('select Id,LCIS__c from On_Study_Pathology_Form__c where Id = \''+ ospId+'\'');
		lstPathology[0].Invasive_Tumor_Detail__c = objITD.id;
		lstPathology[0].Is_invasive_tumor_present__c = 'Yes';
		//lstPathology[0].Nuclear_Grade_Snomed__c = SnomedCTCode.SnomedCode('On_Study_Pathology_Form__c','Nuclear_Grade__c',objITD.Nuclear_Grade__c);
		upsert lstPathology;*/
	}
	
	/*public void sumGrade(){
		Integer nG = 0;
		Integer tP = 0;
		Integer mC = 0;
		system.debug('---objITD.Nuclear_Grade__c------'+objITD.Nuclear_Grade__c);
		if(objITD.Nuclear_Grade__c != null){
			if(objITD.Nuclear_Grade__c == 'Grade I (low)'){
				nG = 1;
			} else if(objITD.Nuclear_Grade__c == 'Grade II (Intermediate)'){
				nG = 2;
			} else if(objITD.Nuclear_Grade__c == 'Grade III (high)'){
				nG = 3;
			}
		}
		system.debug('---objITD.Mitotic_Count__c------'+objITD.Mitotic_Count__c);
		if(objITD.Mitotic_Count__c != null){
			String mitoticCount;
			mitoticCount = objITD.Mitotic_Count__c.subString(0,1);
			if(mitoticCount != 'N' && mitoticCount != 'I'){
				mC = Integer.valueOf(mitoticCount);
				system.debug('---mC------'+mC);
			}
		}
		system.debug('---objITD.Tubule_Papilla_formation__c------'+objITD.Tubule_Papilla_formation__c);
		if(objITD.Tubule_Papilla_formation__c != null){
			String tubPapilla;
			tubPapilla = objITD.Tubule_Papilla_formation__c.subString(0,1);
			if(tubPapilla != 'N' && tubPapilla != 'I'){	
				tP = Integer.valueOf(tubPapilla);
				system.debug('---tP------'+tP);
			}
		}
		//system.debug('---tubPapilla------'+tubPapilla);
		Ins = nG + mC + tP;
		System.debug('--Ins--->'+Ins);
	}*/
	
	public void savePostInvasiveTumor(Id invasivePostId) {
		system.debug('----saveInvasiveTumor__'+invasivePostId);
		objITD.Total_Points__c = totalPoints;
		if(SBRGrade != 'N/A') {
			objITD.SBR_Grade__c = SBRGrade;
		}
		objITD.Post_Surgery_Summary__c = invasivePostId;
		upsert objITD;
		
		/*List<Post_Surgaory_Summary__c> lstPostSur = [select Id, LCIS__c from Post_Surgaory_Summary__c where Id =:invasivePostId];
		system.debug('----saveInvasive() Called-------'+lstPostSur);
		if(!lstPostSur.isEmpty()) {
			lstPostSur[0].Invasive_Tumor_Detail__c = objITD.Id;
			//lstPostSur[0].Nuclear_Grade_Snomed__c = SnomedCTCode.SnomedCode('Post_Surgaory_Summary__c','Nuclear_Grade__c','');
			//lstPostSur[0].Nuclear_Grade_val_Snomed__c = SnomedCTCode.SnomedCode('Post_Surgaory_Summary__c','Nuclear_Grade__c',objITD.Nuclear_Grade__c);
			//lstPostSur[0].Overall_cancer_cellularity_Snomed__c = SnomedCTCode.SnomedCode('Post_Surgaory_Summary__c','Overall_cancer_cellularity__c','');
			//lstPostSur[0].Tumor_multi_focal_snomed__c = SnomedCTCode.SnomedCode('Post_Surgaory_Summary__c','Multi_focal_Tumor__c','');
			//lstPostSur[0].Tumor_multi_focal_val_snomed__c = SnomedCTCode.SnomedCode('Post_Surgaory_Summary__c','Multi_focal_Tumor__c',objITD.Multi_focal_Tumor__c);
			upsert lstPostSur;
		}*/
	}
	
	/*public void saveBreastSurgicalProcedureITD(Id histologyId) {
		objITD.Histology__c = histologyId;
		upsert objITD;
	}*/
}