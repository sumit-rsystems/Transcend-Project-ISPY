public with sharing class LCISController extends ComponentControllerBase {
		
	public LCIS__c lcisObj {get;set;}
	public String objId {get;}
	public string pathId{get;set;}
	
	/*public void setObjId(String setLcisId) {
		system.debug('__setLcisId__'+setLcisId);
		lcisObj = [select LastModifiedDate ,id,Closest_Margin__c,Histological_Type__c,LCIS__c,Margins__c,Specify_No__c,Specify_Units__c,Total_histological_span__c,Total_histological_span_measurement_unit__c,Unknown_Not_Reported__c from LCIS__c where id = :setLcisId];
	}*/
	
	public void setObjId(String formId) {
		system.debug('__formId__'+formId);
		String postid = Apexpages.currentPage().getParameters().get('postid');
		String PathologyId = Apexpages.currentPage().getParameters().get('PathologyId');
		
		List<LCIS__c> lcisTmpList = new List<LCIS__c>();
		if(postid != null) {
			lcisTmpList = [select LastModifiedDate ,id,Closest_Margin__c,Histological_Type__c,LCIS__c,Margins__c,Specify_No__c,Specify_Units__c,Total_histological_span__c,Total_histological_span_measurement_unit__c,Unknown_Not_Reported__c from LCIS__c where Post_Surgery_Summary__c = : formId];
		} else if(pathId!= null) {
			lcisTmpList = [select LastModifiedDate ,id,Closest_Margin__c,Histological_Type__c,LCIS__c,Margins__c,Specify_No__c,Specify_Units__c,Total_histological_span__c,Total_histological_span_measurement_unit__c,Unknown_Not_Reported__c from LCIS__c where On_Study_Pathology_Form__c = : formId];
		}
		
		if(!lcisTmpList.isEmpty()) {
			lcisObj = lcisTmpList[0];
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
			pageController.setLcisComponentController(this);
	    }
	}
	
	public PageControllerBase getPageController() {
		return pageController;
	}
	
	public String onStudyPathologyId {get;set;}
	public String lcisPostId{get;set;}
	private String patientId{get;set;}
	
	public LCISController(){
		System.debug('----LCIS Constructor---->');
		List<On_Study_Pathology_Form__c> lstPathology = new List<On_Study_Pathology_Form__c>();
		List<Post_Surgaory_Summary__c> lstPostSur = new List<Post_Surgaory_Summary__c>();
		String postid = Apexpages.currentPage().getParameters().get('postid');
		String PathologyId = Apexpages.currentPage().getParameters().get('PathologyId');
		//patientId = Apexpages.currentPage().getParameters().get('patientId');
		lcisObj = new LCIS__c();
		List<LCIS__c> lcisList = new List<LCIS__c>();
		
		if(postid != null) {
			lcisList = [select LastModifiedDate ,id,Closest_Margin__c,Histological_Type__c,LCIS__c,Margins__c,Specify_No__c,Specify_Units__c,Total_histological_span__c,Total_histological_span_measurement_unit__c,Unknown_Not_Reported__c from LCIS__c where Post_Surgery_Summary__c = : postid];
		} else if(PathologyId != null) {
			lcisList = [select LastModifiedDate ,id,Closest_Margin__c,Histological_Type__c,LCIS__c,Margins__c,Specify_No__c,Specify_Units__c,Total_histological_span__c,Total_histological_span_measurement_unit__c,Unknown_Not_Reported__c from LCIS__c where On_Study_Pathology_Form__c = : PathologyId];
		}
		
		if(!lcisList.isEmpty()) {
			lcisObj = lcisList[0];
		}
		
		/*if(objId != null && objId != ''){
			lcisObj = [select LastModifiedDate ,id,Closest_Margin__c,Histological_Type__c,LCIS__c,Margins__c,Specify_No__c,Specify_Units__c,Total_histological_span__c,Total_histological_span_measurement_unit__c,Unknown_Not_Reported__c from LCIS__c where id = : objId];
		}
		if(PathologyId != null && PathologyId != '' && !Test.isRunningTest()){	
			lstPathology = Database.query('select Id,LCIS__c from On_Study_Pathology_Form__c where Id = \''+ PathologyId+'\'');
		}
		if(postid != null && postid != ''){
			lstPostSur = [select Id, LCIS__c,Invasive_Tumor_Detail__c from Post_Surgaory_Summary__c where Id = :postid];
		}
		if(patientId != null) {
			List<Histology__c> histologyList = [Select Id From Histology__c h where Patient__c =:patientId];
			if(!histologyList.isEmpty()) {
				lcisObj = [Select l.Unknown_Not_Reported__c, l.Total_histological_span_measurement_unit__c, l.Total_histological_span__c, l.SystemModstamp, l.Specify_Units__c, l.Specify_No__c, l.OwnerId, l.Name, l.Margins__c, l.LastModifiedDate, l.LastModifiedById, l.LCIS__c, l.IsDeleted, l.Id, l.Histology__c, l.Histological_Type__c, l.CreatedDate, l.CreatedById, l.Closest_Margin__c From LCIS__c l where Histology__c =:histologyList[0].Id];
			}
		}
		
		if(!lstPostSur.isEmpty() && lstPostSur[0].LCIS__c != null){
			lcisObj = [select LastModifiedDate ,id,Closest_Margin__c,Histological_Type__c,LCIS__c,Margins__c,Specify_No__c,Specify_Units__c,Total_histological_span__c,Total_histological_span_measurement_unit__c,Unknown_Not_Reported__c from LCIS__c where id = : lstPostSur[0].LCIS__c];
		} else if(!lstPathology.isEmpty() && lstPathology[0].LCIS__c != null){
			lcisObj = [select LastModifiedDate ,id,Closest_Margin__c,Histological_Type__c,LCIS__c,Margins__c,Specify_No__c,Specify_Units__c,Total_histological_span__c,Total_histological_span_measurement_unit__c,Unknown_Not_Reported__c from LCIS__c where id = : lstPathology[0].LCIS__c];
		} */
	}
	
	public void saveLCIS(Id ospId) {
		system.debug('----onStudyPathologyId------ : '+ospId);
		system.debug('__lcisObj__'+lcisObj);
		lcisObj.On_Study_Pathology_Form__c = ospId;
		upsert lcisObj;
		/*List<On_Study_Pathology_Form__c> lstPathology = Database.query('select Id,LCIS__c from On_Study_Pathology_Form__c where Id = \''+ ospId+'\'');
		system.debug('----saveLCIS() Called-------'+lstPathology);
		lstPathology[0].LCIS__c = lcisObj.Id;
		lstPathology[0].Is_LCIS_Present__c = 'Yes';
		upsert lstPathology;*/
	}
	
	public void savePostLCIS(Id lcisPostId) {
		system.debug('----PostSurgeryId------ : '+lcisPostId);
		//List<On_Study_Pathology_Form__c> lstPathology = Database.query('select Id,LCIS__c from On_Study_Pathology_Form__c where Id = \''+ lcisPostId+'\'');
		lcisObj.Post_Surgery_Summary__c = lcisPostId;
		upsert lcisObj;
		/*List<Post_Surgaory_Summary__c> lstPostSur = [select Id, LCIS__c from Post_Surgaory_Summary__c where Id =:lcisPostId];
		system.debug('----saveLCIS() Called-------'+lstPostSur);
		if(!lstPostSur.isEmpty()) {
			lstPostSur[0].LCIS__c = lcisObj.Id;
			//lstPostSur[0].Histological_Type_Snomed__c = SnomedCTCode.SnomedCode('Post_Surgaory_Summary__c','Histological_Type__c',lcisObj.Histological_Type__c);
			upsert lstPostSur;
		}*/
	}
	
	/*public void saveBreastSurgicalProcedureLCIS(Id histologyId) {
		lcisObj.Histology__c = histologyId;
		upsert lcisObj;
	}*/
}