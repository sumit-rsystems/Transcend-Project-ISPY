public with sharing class StagingComponentController extends ComponentControllerBase {
	public Staging_Detail__c stagObjLeft{get;set;}
	public Staging_Detail__c stagObjRight{get;set;}
	public String recId{get;set;} 
	
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
			pageController.setStagingCompController(this);
	    }
	}
	
	public PageControllerBase getPageController() {
		return pageController;
	}
	
	public String patientId{get;set;}
	
	public StagingComponentController() {
		String postid = Apexpages.currentPage().getParameters().get('postid');
		patientId = Apexpages.currentPage().getParameters().get('patientId');
		system.debug('__postid__'+ postid);
		
		stagObjLeft = new Staging_Detail__c();
		stagObjRight = new Staging_Detail__c();
				
		if(postid != null && postid != '') {
			List<Staging_Detail__c> stagList = [select s.Tumor_Type__c, s.T4_Tumor_final_status__c, s.SystemModstamp, s.Staging_Modifier_Type__c, s.Post_Surgery_Summary__c, s.OwnerId, s.Node_Type__c, s.Name, s.Modifier_multiple_primary__c, s.Modifier_indicates_recurrent__c, s.Modifier_designates__c, s.Modifier_classification_done__c, s.Metastasis__c, s.Letarality__c, s.LastModifiedDate, s.LastModifiedById, s.IsDeleted, s.Id, s.CreatedDate, s.CreatedById, s.Calculated_Stage__c, s.Calculated_Stage_Value__c, s.Adjudicated_Stage__c, s.Adjudicated_By__c, Adjudicated_By__r.Name From Staging_Detail__c s where Post_Surgery_Summary__c =: postid];
			system.debug('__stagList__'+stagList);
			for(Staging_Detail__c stagObj : stagList) {
				system.debug('__stagObj.Letarality__c__'+stagObj.Letarality__c);
				if(stagObj.Letarality__c == 'Left') {
					stagObjLeft = stagObj;
				} else if(stagObj.Letarality__c == 'Right') {
					stagObjRight = stagObj;
				}
			}
		} else if(patientId != null) {
			List<Staging_Detail__c> stagList = [Select s.Tumor_Type__c, s.T4_Tumor_final_status__c, s.SystemModstamp, s.Staging_Modifier_Type__c, s.Post_Surgery_Summary__c, s.Patient__c, s.OwnerId, s.Node_Type__c, s.Name, s.Modifier_multiple_primary__c, s.Modifier_indicates_recurrent__c, s.Modifier_designates__c, s.Modifier_classification_done__c, s.Metastasis__c, s.Letarality__c, s.LastModifiedDate, s.LastModifiedById, s.IsDeleted, s.Id, s.CreatedDate, s.CreatedById, s.Calculated_Stage__c, s.Calculated_Stage_Value__c, s.Adjudicated_Stage__c, s.Adjudicated_By__c,Adjudicated_By__r.Name  From Staging_Detail__c s where Patient__c != null];
			for(Staging_Detail__c stagObj : stagList) {
				if(stagObj.Letarality__c == 'Left') {
					stagObjLeft = stagObj;
				} else if(stagObj.Letarality__c == 'Right') {
					stagObjRight = stagObj;
				}
			}
		}
		system.debug('__stagObjLeft__'+stagObjLeft);
		system.debug('__stagObjRight__'+stagObjRight);
	}
	
	public void insertStageLeft(Id postId) {
		stagObjLeft.Post_Surgery_Summary__c = postId;
		stagObjLeft.Letarality__c = 'Left';
		system.debug('__stagObjLeft__'+stagObjLeft);
		upsert stagObjLeft;  
	}
	
	public void insertStageRight(Id postId) {
		stagObjRight.Post_Surgery_Summary__c = postId;
		stagObjRight.Letarality__c = 'Right';
		system.debug('__stagObjRight__'+stagObjRight);
		upsert stagObjRight;
	}
	
	public void insertBreastSurgicalStageLeft(Id PatientId) {
		stagObjLeft.Patient__c = PatientId;
		stagObjLeft.Letarality__c = 'Left';
		system.debug('__stagObjLeft__'+stagObjLeft);
		upsert stagObjLeft;  
	}
	
	public void insertBreastSurgicalStageRight(Id PatientId) {
		stagObjRight.Patient__c = PatientId;
		stagObjRight.Letarality__c = 'Right';
		system.debug('__stagObjRight__'+stagObjRight);
		system.debug('__stagObjRight.Adjudicated_Stage__c__'+stagObjRight.Adjudicated_Stage__c);
		upsert stagObjRight;
	}
}