public with sharing class DCISController extends ComponentControllerBase {
	
	public DCIS__c dcisObj {get;set;}
	private String patientId{get;set;}
	public String objId {get;}
	public string pathId{get;set;}
	
	/*public void setObjId(String setDcisId) {
		system.debug('__setDcisId__'+setDcisId);
		dcisObj = [select LastModifiedDate,id,Anterior_Inferior__c,Calcifications_Present__c,Anterior_Inferior_Size__c,Anterior_Superior__c,Anterior_Superior_Size__c,Apocrine__c,Calcifications__c,Clinging__c,Closest_Margin__c,Comedonecrosis__c,Cribiform__c,Cruciform__c,DCIS__c,Deep_Margin__c,Deep_Margin_Size__c,From_Slide__c,Intra_cystic_encysted_papillary__c,Lateral__c,Lateral_Size__c,Margin__c,Medical__c,Medical_Size__c,Micropapillary__c,Microscopic_foci_upto__c,Necrosis__c,Nuclear_Grade__c,Other__c,Other_if_other_mention_type_in_textb__c,Papillary__c,Present_as_scattered_microscopic_foci__c,Present_in_continous_section__c,Punctate_necrosis__c,Solid__c,Spanning__c,Specific_Closest_Margin__c,Specific_Closest_Margin_Measurement_Unit__c,To_Slide__c,Total_Histological_Span__c,Total_Histological_Span_Measurement_Unit__c,Tumor_Size__c,Unknown_Not_Reported__c from DCIS__c where id = :setDcisId];
		system.debug('__complete dcisObj.Nuclear_Grade__c__'+dcisObj.Nuclear_Grade__c);
	}*/
	
	public void setObjId(String formId) {
		system.debug('__formId__'+formId);
		String postid = Apexpages.currentPage().getParameters().get('postid');
		String PathologyId = Apexpages.currentPage().getParameters().get('PathologyId');
		
		List<DCIS__c> dcisTmpList = new List<DCIS__c>();
		if(postid != null) {
			dcisTmpList = [select LastModifiedDate,id,Anterior_Inferior__c,Calcifications_Present__c,Anterior_Inferior_Size__c,Anterior_Superior__c,Anterior_Superior_Size__c,Apocrine__c,Calcifications__c,Clinging__c,Closest_Margin__c,Comedonecrosis__c,Cribiform__c,Cruciform__c,DCIS__c,Deep_Margin__c,Deep_Margin_Size__c,From_Slide__c,Intra_cystic_encysted_papillary__c,Lateral__c,Lateral_Size__c,Margin__c,Medical__c,Medical_Size__c,Micropapillary__c,Microscopic_foci_upto__c,Necrosis__c,Nuclear_Grade__c,Other__c,Other_if_other_mention_type_in_textb__c,Papillary__c,Present_as_scattered_microscopic_foci__c,Present_in_continous_section__c,Punctate_necrosis__c,Solid__c,Spanning__c,Specific_Closest_Margin__c,Specific_Closest_Margin_Measurement_Unit__c,To_Slide__c,Total_Histological_Span__c,Total_Histological_Span_Measurement_Unit__c,Tumor_Size__c,Unknown_Not_Reported__c from DCIS__c where Post_Surgery_Summary__c = :formId];
		} else if(pathId!= null) {
			dcisTmpList = [select LastModifiedDate,id,Anterior_Inferior__c,Calcifications_Present__c,Anterior_Inferior_Size__c,Anterior_Superior__c,Anterior_Superior_Size__c,Apocrine__c,Calcifications__c,Clinging__c,Closest_Margin__c,Comedonecrosis__c,Cribiform__c,Cruciform__c,DCIS__c,Deep_Margin__c,Deep_Margin_Size__c,From_Slide__c,Intra_cystic_encysted_papillary__c,Lateral__c,Lateral_Size__c,Margin__c,Medical__c,Medical_Size__c,Micropapillary__c,Microscopic_foci_upto__c,Necrosis__c,Nuclear_Grade__c,Other__c,Other_if_other_mention_type_in_textb__c,Papillary__c,Present_as_scattered_microscopic_foci__c,Present_in_continous_section__c,Punctate_necrosis__c,Solid__c,Spanning__c,Specific_Closest_Margin__c,Specific_Closest_Margin_Measurement_Unit__c,To_Slide__c,Total_Histological_Span__c,Total_Histological_Span_Measurement_Unit__c,Tumor_Size__c,Unknown_Not_Reported__c from DCIS__c where On_Study_Pathology_Form__c = :formId];
		}
		
		if(!dcisTmpList.isEmpty()) {
			dcisObj = dcisTmpList[0];
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
			pageController.setDcisController(this);
	    }
	}
	
	public PageControllerBase getPageController() {
		return pageController;
	}
	
	public String onStudyPathologyId {get;set;}
	public String dcisPostId {get;set;}
	
	public DCISController(){
		System.debug('----DCIS Constructor---->');
		List<On_Study_Pathology_Form__c> lstPathology = null;
		List<Post_Surgaory_Summary__c> lstPostSur = new List<Post_Surgaory_Summary__c>();
		String postid = Apexpages.currentPage().getParameters().get('postid');
		String PathologyId = Apexpages.currentPage().getParameters().get('PathologyId');
		//patientId = Apexpages.currentPage().getParameters().get('patientId');
		dcisObj = new DCIS__c();
		List<DCIS__c> dcisList = new List<DCIS__c>();
		
		if(postid != null) {
			dcisList = [select LastModifiedDate,id,Anterior_Inferior__c,Calcifications_Present__c,Anterior_Inferior_Size__c,Anterior_Superior__c,Anterior_Superior_Size__c,Apocrine__c,Calcifications__c,Clinging__c,Closest_Margin__c,Comedonecrosis__c,Cribiform__c,Cruciform__c,DCIS__c,Deep_Margin__c,Deep_Margin_Size__c,From_Slide__c,Intra_cystic_encysted_papillary__c,Lateral__c,Lateral_Size__c,Margin__c,Medical__c,Medical_Size__c,Micropapillary__c,Microscopic_foci_upto__c,Necrosis__c,Nuclear_Grade__c,Other__c,Other_if_other_mention_type_in_textb__c,Papillary__c,Present_as_scattered_microscopic_foci__c,Present_in_continous_section__c,Punctate_necrosis__c,Solid__c,Spanning__c,Specific_Closest_Margin__c,Specific_Closest_Margin_Measurement_Unit__c,To_Slide__c,Total_Histological_Span__c,Total_Histological_Span_Measurement_Unit__c,Tumor_Size__c,Unknown_Not_Reported__c from DCIS__c where Post_Surgery_Summary__c = :postid];
		} else if(PathologyId != null) {
			dcisList = [select LastModifiedDate,id,Anterior_Inferior__c,Calcifications_Present__c,Anterior_Inferior_Size__c,Anterior_Superior__c,Anterior_Superior_Size__c,Apocrine__c,Calcifications__c,Clinging__c,Closest_Margin__c,Comedonecrosis__c,Cribiform__c,Cruciform__c,DCIS__c,Deep_Margin__c,Deep_Margin_Size__c,From_Slide__c,Intra_cystic_encysted_papillary__c,Lateral__c,Lateral_Size__c,Margin__c,Medical__c,Medical_Size__c,Micropapillary__c,Microscopic_foci_upto__c,Necrosis__c,Nuclear_Grade__c,Other__c,Other_if_other_mention_type_in_textb__c,Papillary__c,Present_as_scattered_microscopic_foci__c,Present_in_continous_section__c,Punctate_necrosis__c,Solid__c,Spanning__c,Specific_Closest_Margin__c,Specific_Closest_Margin_Measurement_Unit__c,To_Slide__c,Total_Histological_Span__c,Total_Histological_Span_Measurement_Unit__c,Tumor_Size__c,Unknown_Not_Reported__c from DCIS__c where On_Study_Pathology_Form__c = :PathologyId];
		}
		
		if(!dcisList.isEmpty()) {
			dcisObj = dcisList[0];
		}
		
		/*if(objId != null && objId != ''){
			dcisObj = [select LastModifiedDate,id,Anterior_Inferior__c,Calcifications_Present__c,Anterior_Inferior_Size__c,Anterior_Superior__c,Anterior_Superior_Size__c,Apocrine__c,Calcifications__c,Clinging__c,Closest_Margin__c,Comedonecrosis__c,Cribiform__c,Cruciform__c,DCIS__c,Deep_Margin__c,Deep_Margin_Size__c,From_Slide__c,Intra_cystic_encysted_papillary__c,Lateral__c,Lateral_Size__c,Margin__c,Medical__c,Medical_Size__c,Micropapillary__c,Microscopic_foci_upto__c,Necrosis__c,Nuclear_Grade__c,Other__c,Other_if_other_mention_type_in_textb__c,Papillary__c,Present_as_scattered_microscopic_foci__c,Present_in_continous_section__c,Punctate_necrosis__c,Solid__c,Spanning__c,Specific_Closest_Margin__c,Specific_Closest_Margin_Measurement_Unit__c,To_Slide__c,Total_Histological_Span__c,Total_Histological_Span_Measurement_Unit__c,Tumor_Size__c,Unknown_Not_Reported__c from DCIS__c where id = :objId];
			system.debug('__complete__'+dcisObj.Nuclear_Grade__c);
		}
		if(PathologyId != null && PathologyId != '' && !Test.isRunningTest()){	
			lstPathology = Database.query('select Id,LCIS__c,DCIS__c from On_Study_Pathology_Form__c where Id = \''+ PathologyId+'\'');
		}
		if(postid != null && postid != ''){ 
			lstPostSur = [select Id,DCIS__c,Invasive_Tumor_Detail__c from Post_Surgaory_Summary__c where Id = :postid];
		}*/
		/*if(patientId != null) {
			List<Histology__c> histologyList = [Select Id From Histology__c h where Patient__c =:patientId];
			system.debug('__histologyList__'+histologyList);
			if(!histologyList.isEmpty()) {
				dcisObj = [Select d.Unknown_Not_Reported__c, d.Tumor_Size__c, d.Total_Histological_Span__c, d.Total_Histological_Span_Measurement_Unit__c, d.To_Slide__c, d.SystemModstamp, d.Specific_Closest_Margin__c, d.Specific_Closest_Margin_Measurement_Unit__c, d.Spanning__c, d.Solid__c, d.Punctate_necrosis__c, d.Present_in_continous_section__c, d.Present_as_scattered_microscopic_foci__c, d.Papillary__c, d.OwnerId, d.Other_if_other_mention_type_in_textb__c, d.Other__c, d.Nuclear_Grade__c, d.Necrosis__c, d.Name, d.Microscopic_foci_upto__c, d.Micropapillary__c, d.Medical__c, d.Medical_Size__c, d.Margin__c, d.Lateral__c, d.Lateral_Size__c, d.LastModifiedDate, d.LastModifiedById, d.IsDeleted, d.Intra_cystic_encysted_papillary__c, d.Id, d.Histology__c, d.From_Slide__c, d.Deep_Margin__c, d.Deep_Margin_Size__c, d.DCIS__c, d.Cruciform__c, d.Cribiform__c, d.CreatedDate, d.CreatedById, d.Comedonecrosis__c, d.Closest_Margin__c, d.Clinging__c, d.Calcifications__c, d.Calcifications_Present__c, d.Apocrine__c, d.Anterior_Superior__c, d.Anterior_Superior_Size__c, d.Anterior_Inferior__c, d.Anterior_Inferior_Size__c From DCIS__c d where Histology__c =:histologyList[0].Id];
				system.debug('__dcisObj__'+dcisObj);
			}
		}*/
		/*if(!lstPostSur.isEmpty() && lstPostSur[0].DCIS__c != null){
			dcisObj = [select LastModifiedDate,id,Anterior_Inferior__c,Calcifications_Present__c,Anterior_Inferior_Size__c,Anterior_Superior__c,Anterior_Superior_Size__c,Apocrine__c,Calcifications__c,Clinging__c,Closest_Margin__c,Comedonecrosis__c,Cribiform__c,Cruciform__c,DCIS__c,Deep_Margin__c,Deep_Margin_Size__c,From_Slide__c,Intra_cystic_encysted_papillary__c,Lateral__c,Lateral_Size__c,Margin__c,Medical__c,Medical_Size__c,Micropapillary__c,Microscopic_foci_upto__c,Necrosis__c,Nuclear_Grade__c,Other__c,Other_if_other_mention_type_in_textb__c,Papillary__c,Present_as_scattered_microscopic_foci__c,Present_in_continous_section__c,Punctate_necrosis__c,Solid__c,Spanning__c,Specific_Closest_Margin__c,Specific_Closest_Margin_Measurement_Unit__c,To_Slide__c,Total_Histological_Span__c,Total_Histological_Span_Measurement_Unit__c,Tumor_Size__c,Unknown_Not_Reported__c from DCIS__c where id = :lstPostSur[0].DCIS__c];
		} else if((lstPathology != null && !lstPathology.isEmpty()) && lstPathology[0].DCIS__c != null){
			System.debug('----no value------>');
			dcisObj = [select LastModifiedDate,id,Anterior_Inferior__c,Calcifications_Present__c,Anterior_Inferior_Size__c,Anterior_Superior__c,Anterior_Superior_Size__c,Apocrine__c,Calcifications__c,Clinging__c,Closest_Margin__c,Comedonecrosis__c,Cribiform__c,Cruciform__c,DCIS__c,Deep_Margin__c,Deep_Margin_Size__c,From_Slide__c,Intra_cystic_encysted_papillary__c,Lateral__c,Lateral_Size__c,Margin__c,Medical__c,Medical_Size__c,Micropapillary__c,Microscopic_foci_upto__c,Necrosis__c,Nuclear_Grade__c,Other__c,Other_if_other_mention_type_in_textb__c,Papillary__c,Present_as_scattered_microscopic_foci__c,Present_in_continous_section__c,Punctate_necrosis__c,Solid__c,Spanning__c,Specific_Closest_Margin__c,Specific_Closest_Margin_Measurement_Unit__c,To_Slide__c,Total_Histological_Span__c,Total_Histological_Span_Measurement_Unit__c,Tumor_Size__c,Unknown_Not_Reported__c from DCIS__c where id = :lstPathology[0].DCIS__c];
		} */
	}
	
	public void saveDCIS(Id ospId) {
		system.debug('----saveDCIS() Called-------'+ospId+'<--');
		system.debug('__dcisObj__'+dcisObj);
		dcisObj.On_Study_Pathology_Form__c = ospId;
		upsert dcisObj;
		
		/*List<On_Study_Pathology_Form__c> lstPathology = Database.query('select Id,DCIS__c from On_Study_Pathology_Form__c where Id = \''+ ospId+'\'');
		lstPathology[0].DCIS__c = dcisObj.Id;
		lstPathology[0].Is_DCIS_Present__c = 'Yes';
		upsert lstPathology;*/
		//system.debug('----dcisObj.Id------- : '+dcisObj.Id);
		//CRFComponentIdManager.onStudyPathologyId = dcisObj.Id;
	}
	
	public void savePostDCIS(Id dcisPostId) {
		system.debug('----saveDCIS() Called-------'+dcisPostId+'<--');
		dcisObj.Post_Surgery_Summary__c = dcisPostId;
		upsert dcisObj;
		/*List<Post_Surgaory_Summary__c> lstPostSur = [select Id, DCIS__c from Post_Surgaory_Summary__c where Id =:dcisPostId];
		system.debug('----saveDCIS() Called-------'+lstPostSur);
		if(!lstPostSur.isEmpty()) {
			lstPostSur[0].DCIS__c = dcisObj.Id;
			upsert lstPostSur;
		}*/
		
	}
	
	/*public void saveBreastSurgicalProcedureDCIS(Id histologyId) {
		dcisObj.Histology__c = histologyId;
		upsert dcisObj;
	}*/
}