public with sharing class Receptors extends ComponentControllerBase {
	
	public Receptors__c recObj {get;set;}
	public Receptors__c recObjRight {get;set;}
	public String objId {get;}
	
	/*public void setObjId(String recepId) {
		system.debug('__recepId__'+recepId);
		recObj = [Select r.Vysis_Path_Vision__c, r.Vysis_Path_Vision_Value__c, r.Ventana_kit__c, r.Ventana_kit_Value__c, r.Ventana_Oncoprobe__c, r.Ventana_Oncoprobe_Value__c, r.Total_Score_PR__c, r.Total_Score_ER__c, r.SystemModstamp, r.Progesterone_Receptor_Status__c, r.Progesterone_Receptor_Proportion_Score__c, r.Progesterone_Intensity_Score__c, r.PgR_TS_OS_Snomed__c, r.OwnerId, r.Other_IHC_Test__c, r.Other_IHC_Test_Value__c, r.Other_IHC_Results__c, r.Other_FISH_Test__c, r.Other_FISH_Test_Value__c, r.Other_FISH_Results__c, r.Name, r.Letarality__c, r.LastModifiedDate, r.LastModifiedById, r.IsDeleted, r.Id, r.IHC_test_not_done__c, r.IHC__c, r.Her2Pos_OS_Snomed__c, r.HER2_neu_Marker__c, r.Fish__c, r.FISH_test_not_done__c, r.Estrogen_Receptor_Status__c, r.Estrogen_Receptor_Proportion_Score__c, r.Estrogen_Intensity_Score__c, r.ERpos_OS_Snomed__c, r.ER_TS_OS_Snomed__c, r.DAKO_Herceptest__c, r.DAKO_Herceptest_Value__c, r.CreatedDate, r.CreatedById, r.CB_11__c, r.CB_11_Value__c From Receptors__c r where id = :recepId];
		if(recObj.Letarality__c == 'Right') {
			recObjRight = recObj;
		}
	}*/
	
	public void setObjId(String formId) {
		system.debug('__formId__'+formId);
		String postid = Apexpages.currentPage().getParameters().get('postid');
		String PathologyId = Apexpages.currentPage().getParameters().get('PathologyId');
		if(postid != null) {
			List<Receptors__c> receptorList = [Select r.Vysis_Path_Vision__c ,r.Progesterone_Total_Score_Number__c ,r.Estrogen_Total_Score_Number__c,r.Vysis_Path_Vision_Value__c, r.Ventana_kit__c, r.Ventana_kit_Value__c, r.Ventana_Oncoprobe__c, r.Ventana_Oncoprobe_Value__c, r.Total_Score_PR__c, r.Total_Score_ER__c, r.SystemModstamp, r.Progesterone_Receptor_Status__c, r.Progesterone_Receptor_Proportion_Score__c, r.Progesterone_Intensity_Score__c, r.PgR_TS_OS_Snomed__c, r.OwnerId, r.Other_IHC_Test__c, r.Other_IHC_Test_Value__c, r.Other_IHC_Results__c, r.Other_FISH_Test__c, r.Other_FISH_Test_Value__c, r.Other_FISH_Results__c, r.Name, r.Letarality__c, r.LastModifiedDate, r.LastModifiedById, r.IsDeleted, r.Id, r.IHC_test_not_done__c, r.IHC__c, r.Her2Pos_OS_Snomed__c, r.HER2_neu_Marker__c, r.Fish__c, r.FISH_test_not_done__c, r.Estrogen_Receptor_Status__c, r.Estrogen_Receptor_Proportion_Score__c, r.Estrogen_Intensity_Score__c, r.ERpos_OS_Snomed__c, r.ER_TS_OS_Snomed__c, r.DAKO_Herceptest__c, r.DAKO_Herceptest_Value__c, r.CreatedDate, r.CreatedById, r.CB_11__c, r.CB_11_Value__c From Receptors__c r where Post_Surgery_Summary__c = :formId];
			for (Receptors__c receptorObj : receptorList) {
				if(receptorObj.Letarality__c == 'Right') {
					recObjRight = receptorObj;
				} else {
					recObj = receptorObj;
				}
			}
			
		} else if(PathologyId != null) {
			List<Receptors__c> receptorList = [Select r.Vysis_Path_Vision__c,r.Progesterone_Total_Score_Number__c ,r.Estrogen_Total_Score_Number__c,r.Vysis_Path_Vision_Value__c, r.Ventana_kit__c, r.Ventana_kit_Value__c, r.Ventana_Oncoprobe__c, r.Ventana_Oncoprobe_Value__c, r.Total_Score_PR__c, r.Total_Score_ER__c, r.SystemModstamp, r.Progesterone_Receptor_Status__c, r.Progesterone_Receptor_Proportion_Score__c, r.Progesterone_Intensity_Score__c, r.PgR_TS_OS_Snomed__c, r.OwnerId, r.Other_IHC_Test__c, r.Other_IHC_Test_Value__c, r.Other_IHC_Results__c, r.Other_FISH_Test__c, r.Other_FISH_Test_Value__c, r.Other_FISH_Results__c, r.Name, r.Letarality__c, r.LastModifiedDate, r.LastModifiedById, r.IsDeleted, r.Id, r.IHC_test_not_done__c, r.IHC__c, r.Her2Pos_OS_Snomed__c, r.HER2_neu_Marker__c, r.Fish__c, r.FISH_test_not_done__c, r.Estrogen_Receptor_Status__c, r.Estrogen_Receptor_Proportion_Score__c, r.Estrogen_Intensity_Score__c, r.ERpos_OS_Snomed__c, r.ER_TS_OS_Snomed__c, r.DAKO_Herceptest__c, r.DAKO_Herceptest_Value__c, r.CreatedDate, r.CreatedById, r.CB_11__c, r.CB_11_Value__c From Receptors__c r where On_Study_Pathology_Form__c = :formId];
			if(!receptorList.isEmpty()) {
				recObj = receptorList[0];
			}
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
			pageController.setReceptorsComponentController(this);
	    }
	}
	
	public PageControllerBase getPageController() {
		return pageController;
	}
	public String subFormLaterlity {get;set;}
	public Integer ERTotalScoreHiddenId{get;set;}
	public Integer PRTotalScoreHiddenId{get;set;}
	public String recId {get;set;}//
	private String patientId{get;set;}
	
	public Receptors(){
		system.debug('__subFormLaterlity__'+subFormLaterlity);
		List<On_Study_Pathology_Form__c> lstPathology = new List<On_Study_Pathology_Form__c>();
		List<Post_Surgaory_Summary__c> lstPostSur = new List<Post_Surgaory_Summary__c>();
		String postid = Apexpages.currentPage().getParameters().get('postid');
		String PathologyId = Apexpages.currentPage().getParameters().get('PathologyId');
		//patientId = Apexpages.currentPage().getParameters().get('patientId');
		
		recObj = new Receptors__c();
		recObjRight = new Receptors__c();
		
		if(postid != null) {
			List<Receptors__c> receptorList = [Select r.Vysis_Path_Vision__c,r.Progesterone_Total_Score_Number__c , r.Estrogen_Total_Score_Number__c,r.Vysis_Path_Vision_Value__c, r.Ventana_kit__c, r.Ventana_kit_Value__c, r.Ventana_Oncoprobe__c, r.Ventana_Oncoprobe_Value__c, r.Total_Score_PR__c, r.Total_Score_ER__c, r.SystemModstamp, r.Progesterone_Receptor_Status__c, r.Progesterone_Receptor_Proportion_Score__c, r.Progesterone_Intensity_Score__c, r.PgR_TS_OS_Snomed__c, r.OwnerId, r.Other_IHC_Test__c, r.Other_IHC_Test_Value__c, r.Other_IHC_Results__c, r.Other_FISH_Test__c, r.Other_FISH_Test_Value__c, r.Other_FISH_Results__c, r.Name, r.Letarality__c, r.LastModifiedDate, r.LastModifiedById, r.IsDeleted, r.Id, r.IHC_test_not_done__c, r.IHC__c, r.Her2Pos_OS_Snomed__c, r.HER2_neu_Marker__c, r.Fish__c, r.FISH_test_not_done__c, r.Estrogen_Receptor_Status__c, r.Estrogen_Receptor_Proportion_Score__c, r.Estrogen_Intensity_Score__c, r.ERpos_OS_Snomed__c, r.ER_TS_OS_Snomed__c, r.DAKO_Herceptest__c, r.DAKO_Herceptest_Value__c, r.CreatedDate, r.CreatedById, r.CB_11__c, r.CB_11_Value__c From Receptors__c r where Post_Surgery_Summary__c = :postid];
			for (Receptors__c receptorObj : receptorList) {
				if(receptorObj.Letarality__c == 'Right') {
					recObjRight = receptorObj;
				} else {
					recObj = receptorObj;
				}
			}
			
		} else if(PathologyId != null) {
			List<Receptors__c> receptorList = [Select r.Vysis_Path_Vision__c,r.Progesterone_Total_Score_Number__c , r.Estrogen_Total_Score_Number__c,r.Vysis_Path_Vision_Value__c, r.Ventana_kit__c, r.Ventana_kit_Value__c, r.Ventana_Oncoprobe__c, r.Ventana_Oncoprobe_Value__c, r.Total_Score_PR__c, r.Total_Score_ER__c, r.SystemModstamp, r.Progesterone_Receptor_Status__c, r.Progesterone_Receptor_Proportion_Score__c, r.Progesterone_Intensity_Score__c, r.PgR_TS_OS_Snomed__c, r.OwnerId, r.Other_IHC_Test__c, r.Other_IHC_Test_Value__c, r.Other_IHC_Results__c, r.Other_FISH_Test__c, r.Other_FISH_Test_Value__c, r.Other_FISH_Results__c, r.Name, r.Letarality__c, r.LastModifiedDate, r.LastModifiedById, r.IsDeleted, r.Id, r.IHC_test_not_done__c, r.IHC__c, r.Her2Pos_OS_Snomed__c, r.HER2_neu_Marker__c, r.Fish__c, r.FISH_test_not_done__c, r.Estrogen_Receptor_Status__c, r.Estrogen_Receptor_Proportion_Score__c, r.Estrogen_Intensity_Score__c, r.ERpos_OS_Snomed__c, r.ER_TS_OS_Snomed__c, r.DAKO_Herceptest__c, r.DAKO_Herceptest_Value__c, r.CreatedDate, r.CreatedById, r.CB_11__c, r.CB_11_Value__c From Receptors__c r where On_Study_Pathology_Form__c = :PathologyId];
			if(!receptorList.isEmpty()) {
				recObj = receptorList[0];
			}
		}
		
		/*if(objId != null && objId != ''){
			recObj = [Select r.Vysis_Path_Vision__c,r.Progesterone_Total_Score_Number__c , r.Estrogen_Total_Score_Number__c, r.Vysis_Path_Vision_Value__c, r.Ventana_kit__c, r.Ventana_kit_Value__c, r.Ventana_Oncoprobe__c, r.Ventana_Oncoprobe_Value__c, r.Total_Score_PR__c, r.Total_Score_ER__c, r.SystemModstamp, r.Progesterone_Receptor_Status__c, r.Progesterone_Receptor_Proportion_Score__c, r.Progesterone_Intensity_Score__c, r.PgR_TS_OS_Snomed__c, r.OwnerId, r.Other_IHC_Test__c, r.Other_IHC_Test_Value__c, r.Other_IHC_Results__c, r.Other_FISH_Test__c, r.Other_FISH_Test_Value__c, r.Other_FISH_Results__c, r.Name, r.Letarality__c, r.LastModifiedDate, r.LastModifiedById, r.IsDeleted, r.Id, r.IHC_test_not_done__c, r.IHC__c, r.Her2Pos_OS_Snomed__c, r.HER2_neu_Marker__c, r.Fish__c, r.FISH_test_not_done__c, r.Estrogen_Receptor_Status__c, r.Estrogen_Receptor_Proportion_Score__c, r.Estrogen_Intensity_Score__c, r.ERpos_OS_Snomed__c, r.ER_TS_OS_Snomed__c, r.DAKO_Herceptest__c, r.DAKO_Herceptest_Value__c, r.CreatedDate, r.CreatedById, r.CB_11__c, r.CB_11_Value__c From Receptors__c r where id = :objId];
		}*/
		/*if(PathologyId != null && PathologyId != ''){	
			lstPathology = Database.query('select Id,LCIS__c,DCIS__c,Receptors__c from On_Study_Pathology_Form__c where Id = \''+ PathologyId+'\'');
		}
		if(postid != null && postid != ''){
			lstPostSur = [select Id, LCIS__c,Invasive_Tumor_Detail__c,Receptors_Left__c,Receptors_Right__c from Post_Surgaory_Summary__c where Id = :postid];
		}*/
		/*if(patientId != null) {
			system.debug('__patientId__'+patientId);
			List<Histology__c> histologyList = [Select Id From Histology__c h where Patient__c =:patientId];
			system.debug('__histologyList__'+histologyList);
			if(!histologyList.isEmpty()) {
				List<Receptors__c> receptorsList = [Select r.Vysis_Path_Vision__c,r.Progesterone_Total_Score_Number__c , r.Estrogen_Total_Score_Number__c,r.Vysis_Path_Vision_Value__c, r.Ventana_kit__c, r.Ventana_kit_Value__c, r.Ventana_Oncoprobe__c, r.Ventana_Oncoprobe_Value__c, r.Total_Score_PR__c, r.Total_Score_ER__c, r.SystemModstamp, r.Progesterone_Receptor_Status__c, r.Progesterone_Receptor_Proportion_Score__c, r.Progesterone_Intensity_Score__c, r.PgR_TS_OS_Snomed__c, r.OwnerId, r.Other_IHC_Test__c, r.Other_IHC_Test_Value__c, r.Other_IHC_Results__c, r.Other_FISH_Test__c, r.Other_FISH_Test_Value__c, r.Other_FISH_Results__c, r.Name, r.Letarality__c, r.LastModifiedDate, r.LastModifiedById, r.IsDeleted, r.Id, r.IHC_test_not_done__c, r.IHC__c, r.Histology__c, r.Her2Pos_OS_Snomed__c, r.HER2_neu_Marker__c, r.Fish__c, r.FISH_test_not_done__c, r.Estrogen_Receptor_Status__c, r.Estrogen_Receptor_Proportion_Score__c, r.Estrogen_Intensity_Score__c, r.ERpos_OS_Snomed__c, r.ER_TS_OS_Snomed__c, r.DAKO_Herceptest__c, r.DAKO_Herceptest_Value__c, r.CreatedDate, r.CreatedById, r.CB_11__c, r.CB_11_Value__c From Receptors__c r where Histology__c =:histologyList[0].Id];
				system.debug('__receptorsList__'+receptorsList);
				for(Receptors__c receptorsObj: receptorsList) {
					system.debug('__receptorsObj.Letarality__c__'+receptorsObj.Letarality__c);
					if(receptorsObj.Letarality__c == 'Left') {
						system.debug('---->Left');
						recObj = receptorsObj; 
					} else if(receptorsObj.Letarality__c == 'Right') {
						system.debug('---->Right');
						recObjRight = receptorsObj; 
					}
				}
			}
		}*/
		
		/*if(!lstPostSur.isEmpty()) {
			if(lstPostSur[0].Receptors_Left__c != null){
				recObj = [Select r.Vysis_Path_Vision__c,r.Progesterone_Total_Score_Number__c , r.Estrogen_Total_Score_Number__c,r.Vysis_Path_Vision_Value__c, r.Ventana_kit__c, r.Ventana_kit_Value__c, r.Ventana_Oncoprobe__c, r.Ventana_Oncoprobe_Value__c, r.Total_Score_PR__c, r.Total_Score_ER__c, r.SystemModstamp, r.Progesterone_Receptor_Status__c, r.Progesterone_Receptor_Proportion_Score__c, r.Progesterone_Intensity_Score__c, r.PgR_TS_OS_Snomed__c, r.OwnerId, r.Other_IHC_Test__c, r.Other_IHC_Test_Value__c, r.Other_IHC_Results__c, r.Other_FISH_Test__c, r.Other_FISH_Test_Value__c, r.Other_FISH_Results__c, r.Name, r.Letarality__c, r.LastModifiedDate, r.LastModifiedById, r.IsDeleted, r.Id, r.IHC_test_not_done__c, r.IHC__c, r.Her2Pos_OS_Snomed__c, r.HER2_neu_Marker__c, r.Fish__c, r.FISH_test_not_done__c, r.Estrogen_Receptor_Status__c, r.Estrogen_Receptor_Proportion_Score__c, r.Estrogen_Intensity_Score__c, r.ERpos_OS_Snomed__c, r.ER_TS_OS_Snomed__c, r.DAKO_Herceptest__c, r.DAKO_Herceptest_Value__c, r.CreatedDate, r.CreatedById, r.CB_11__c, r.CB_11_Value__c From Receptors__c r where id = :lstPostSur[0].Receptors_Left__c];
			} else {
				recObj = new Receptors__c();
			}
			 
			if(lstPostSur[0].Receptors_Right__c != null){
				recObjRight = [Select r.Vysis_Path_Vision__c,r.Progesterone_Total_Score_Number__c , r.Estrogen_Total_Score_Number__c,r.Vysis_Path_Vision_Value__c, r.Ventana_kit__c, r.Ventana_kit_Value__c, r.Ventana_Oncoprobe__c, r.Ventana_Oncoprobe_Value__c, r.Total_Score_PR__c, r.Total_Score_ER__c, r.SystemModstamp, r.Progesterone_Receptor_Status__c, r.Progesterone_Receptor_Proportion_Score__c, r.Progesterone_Intensity_Score__c, r.PgR_TS_OS_Snomed__c, r.OwnerId, r.Other_IHC_Test__c, r.Other_IHC_Test_Value__c, r.Other_IHC_Results__c, r.Other_FISH_Test__c, r.Other_FISH_Test_Value__c, r.Other_FISH_Results__c, r.Name, r.Letarality__c, r.LastModifiedDate, r.LastModifiedById, r.IsDeleted, r.Id, r.IHC_test_not_done__c, r.IHC__c, r.Her2Pos_OS_Snomed__c, r.HER2_neu_Marker__c, r.Fish__c, r.FISH_test_not_done__c, r.Estrogen_Receptor_Status__c, r.Estrogen_Receptor_Proportion_Score__c, r.Estrogen_Intensity_Score__c, r.ERpos_OS_Snomed__c, r.ER_TS_OS_Snomed__c, r.DAKO_Herceptest__c, r.DAKO_Herceptest_Value__c, r.CreatedDate, r.CreatedById, r.CB_11__c, r.CB_11_Value__c From Receptors__c r where id = :lstPostSur[0].Receptors_Right__c];
			} else {
				recObjRight = new Receptors__c();
			}	
		}  else if(!lstPathology.isEmpty() && lstPathology[0].Receptors__c != null){
			recObj = [Select r.Vysis_Path_Vision__c,r.Progesterone_Total_Score_Number__c , r.Estrogen_Total_Score_Number__c,r.Vysis_Path_Vision_Value__c, r.Ventana_kit__c, r.Ventana_kit_Value__c, r.Ventana_Oncoprobe__c, r.Ventana_Oncoprobe_Value__c, r.Total_Score_PR__c, r.Total_Score_ER__c, r.SystemModstamp, r.Progesterone_Receptor_Status__c, r.Progesterone_Receptor_Proportion_Score__c, r.Progesterone_Intensity_Score__c, r.PgR_TS_OS_Snomed__c, r.OwnerId, r.Other_IHC_Test__c, r.Other_IHC_Test_Value__c, r.Other_IHC_Results__c, r.Other_FISH_Test__c, r.Other_FISH_Test_Value__c, r.Other_FISH_Results__c, r.Name, r.Letarality__c, r.LastModifiedDate, r.LastModifiedById, r.IsDeleted, r.Id, r.IHC_test_not_done__c, r.IHC__c, r.Her2Pos_OS_Snomed__c, r.HER2_neu_Marker__c, r.Fish__c, r.FISH_test_not_done__c, r.Estrogen_Receptor_Status__c, r.Estrogen_Receptor_Proportion_Score__c, r.Estrogen_Intensity_Score__c, r.ERpos_OS_Snomed__c, r.ER_TS_OS_Snomed__c, r.DAKO_Herceptest__c, r.DAKO_Herceptest_Value__c, r.CreatedDate, r.CreatedById, r.CB_11__c, r.CB_11_Value__c From Receptors__c r where id = :lstPathology[0].Receptors__c];
		} */
	}
	
	public void insertRec(Id ospId){
	 	recObj.Total_Score_ER__c = ERTotalScoreHiddenId;
	 	recObj.Total_Score_PR__c = PRTotalScoreHiddenId;
	 	recObj.On_Study_Pathology_Form__c = ospId;
	 	upsert recObj;
	 	/*List<On_Study_Pathology_Form__c> lstPathology = Database.query('select Id,LCIS__c,TrialPatient__r.Patient_Id__c from On_Study_Pathology_Form__c where Id = \''+ ospId+'\'');
	 	lstPathology[0].Receptors__c = recObj.Id;
	 	//lstPathology[0].Total_Score_ER_Snomed__c = SnomedCTCode.SnomedCode('On_Study_Pathology_Form__c','Total_Score_ER__c','');
		//lstPathology[0].Total_Score_PR_Snomed__c = SnomedCTCode.SnomedCode('On_Study_Pathology_Form__c','Total_Score_PR__c','');
		//lstPathology[0].Estrogen_Receptor_Status_Snomed__c = SnomedCTCode.SnomedCode('On_Study_Pathology_Form__c','Estrogen_Receptor_Status__c','');
		//lstPathology[0].Estrogen_Receptor_Status_Val_Snomed__c = SnomedCTCode.SnomedCode('On_Study_Pathology_Form__c','Estrogen_Receptor_Status__c',recObj.Estrogen_Receptor_Status__c);
		//lstPathology[0].Progesterone_Receptor_Status_Snomed__c = SnomedCTCode.SnomedCode('On_Study_Pathology_Form__c','Progesterone_Receptor_Status__c','');
		//lstPathology[0].Progesterone_Receptor_Status_val_Snomed__c = SnomedCTCode.SnomedCode('On_Study_Pathology_Form__c','Progesterone_Receptor_Status__c',recObj.Progesterone_Receptor_Status__c);
		//lstPathology[0].HER2_neu_Marker_Status_Snomed__c = SnomedCTCode.SnomedCode('On_Study_Pathology_Form__c','HER2_neu_Marker__c','');
		//lstPathology[0].HER2_neu_Marker_Status_val_Snomed__c = SnomedCTCode.SnomedCode('On_Study_Pathology_Form__c','HER2_neu_Marker__c',recObj.HER2_neu_Marker__c);
		//lstPathology[0].IHC_Snomed__c = SnomedCTCode.SnomedCode('On_Study_Pathology_Form__c','IHC__c','');
		//lstPathology[0].IHC_Val_Snomed__c = SnomedCTCode.SnomedCode('On_Study_Pathology_Form__c','IHC__c',recObj.IHC__c);
		//lstPathology[0].Fish_Snomed__c = SnomedCTCode.SnomedCode('On_Study_Pathology_Form__c','Fish__c','');
		//lstPathology[0].Fish_val_Snomed__c = SnomedCTCode.SnomedCode('On_Study_Pathology_Form__c','Fish__c',recObj.Fish__c);
	 	upsert lstPathology;
	 	System.debug('-------lstPathology------->'+lstPathology);*/
	 	//Pagereference pr = new Pagereference('/'+lstPathology[0].TrialPatient__r.Patient_Id__c);
	 	//return pr;
	}
	
	public void insertRecPostLeft(Id recId){
	 	System.debug('-------recId------->'+recId);
	 	System.debug('-------recObj------->'+recObj);
	 	System.debug('-------ERTotalScoreHiddenId------->'+ERTotalScoreHiddenId);
	 	System.debug('-------PRTotalScoreHiddenId------->'+PRTotalScoreHiddenId);
	 	recObj.Total_Score_ER__c = ERTotalScoreHiddenId;
	 	recObj.Total_Score_PR__c = PRTotalScoreHiddenId;
	 	recObj.Letarality__c = 'Left';
	 	recObj.Post_Surgery_Summary__c = recId;
	 	upsert recObj;
	 	system.debug('-------recObj.Id------->'+recObj.Id);
	 	/*List<Post_Surgaory_Summary__c> lstPostSurgery = Database.query('select Id,LCIS__c,TrialPatient__r.Patient_Id__c from Post_Surgaory_Summary__c where Id = \''+ recId+'\'');
	 	lstPostSurgery[0].Receptors_Left__c = recObj.Id;*/
	 	/*lstPostSurgery[0].Estrogen_Receptor_Status_Snomed__c = SnomedCTCode.SnomedCode('Post_Surgaory_Summary__c','Estrogen_Receptor_Status__c','');
	 	lstPostSurgery[0].Estrogen_Receptor_Status_Val_Snomed__c = SnomedCTCode.SnomedCode('Post_Surgaory_Summary__c','Estrogen_Receptor_Status__c',recObj.Estrogen_Receptor_Status__c);
	 	lstPostSurgery[0].Progesteron_Receptor_Status_Snomed__c = SnomedCTCode.SnomedCode('Post_Surgaory_Summary__c','Progesterone_Receptor_Status__c','');
	 	lstPostSurgery[0].Progesterone_Receptor_Status_val_Snomed__c = SnomedCTCode.SnomedCode('Post_Surgaory_Summary__c','Progesterone_Receptor_Status__c',recObj.Progesterone_Receptor_Status__c);
	 	lstPostSurgery[0].IHC_Snomed__c = SnomedCTCode.SnomedCode('Post_Surgaory_Summary__c','IHC__c','');
	 	lstPostSurgery[0].IHC_Val_Snomed__c = SnomedCTCode.SnomedCode('Post_Surgaory_Summary__c','IHC__c',recObj.IHC__c);
	 	lstPostSurgery[0].Fish_Snomed__c = SnomedCTCode.SnomedCode('Post_Surgaory_Summary__c','Fish__c','');
	 	lstPostSurgery[0].Fish_val_Snomed__c = SnomedCTCode.SnomedCode('Post_Surgaory_Summary__c','Fish__c',recObj.Fish__c);*/
	 	/*upsert lstPostSurgery;
	 	System.debug('-------lstPostSurgery------->'+lstPostSurgery);
	 	System.debug('-------lstPostSurgery[0].Receptors_Left__c------->'+lstPostSurgery[0].Receptors_Left__c);*/
	 	//Pagereference pr = new Pagereference('/'+lstPathology[0].TrialPatient__r.Patient_Id__c);
	 	//return pr;
	}
	
	public void insertRecPostRight(Id recId){
	 	System.debug('-------recId------->'+recId);
	 	System.debug('-------recObjRight------->'+recObjRight);
	 	System.debug('-------ERTotalScoreHiddenId------->'+ERTotalScoreHiddenId);
	 	System.debug('-------PRTotalScoreHiddenId------->'+PRTotalScoreHiddenId);
	 	recObjRight.Total_Score_ER__c = ERTotalScoreHiddenId;
	 	recObjRight.Total_Score_PR__c = PRTotalScoreHiddenId;
	 	recObjRight.Letarality__c = 'Right';
	 	recObjRight.Post_Surgery_Summary__c = recId;
	 	upsert recObjRight;
	 	system.debug('-------recObjRight.Id------->'+recObjRight.Id);
	 	/*List<Post_Surgaory_Summary__c> lstPostSurgery = Database.query('select Id,LCIS__c,TrialPatient__r.Patient_Id__c from Post_Surgaory_Summary__c where Id = \''+ recId+'\'');
	 	System.debug('-------lstPostSurgery------->'+lstPostSurgery);
	 	lstPostSurgery[0].Receptors_Right__c = recObjRight.Id;*/
	 	/*lstPostSurgery[0].Estrogen_Receptor_Status_Snomed__c = SnomedCTCode.SnomedCode('Post_Surgaory_Summary__c','Estrogen_Receptor_Status__c','');
	 	lstPostSurgery[0].Estrogen_Receptor_Status_Val_Snomed__c = SnomedCTCode.SnomedCode('Post_Surgaory_Summary__c','Estrogen_Receptor_Status__c',recObjRight.Estrogen_Receptor_Status__c);
	 	lstPostSurgery[0].Progesteron_Receptor_Status_Snomed__c = SnomedCTCode.SnomedCode('Post_Surgaory_Summary__c','Progesterone_Receptor_Status__c','');
	 	lstPostSurgery[0].Progesterone_Receptor_Status_val_Snomed__c = SnomedCTCode.SnomedCode('Post_Surgaory_Summary__c','Progesterone_Receptor_Status__c',recObjRight.Progesterone_Receptor_Status__c);
	 	lstPostSurgery[0].IHC_Snomed__c = SnomedCTCode.SnomedCode('Post_Surgaory_Summary__c','IHC__c','');
	 	lstPostSurgery[0].IHC_Val_Snomed__c = SnomedCTCode.SnomedCode('Post_Surgaory_Summary__c','IHC__c',recObjRight.IHC__c);
	 	lstPostSurgery[0].Fish_Snomed__c = SnomedCTCode.SnomedCode('Post_Surgaory_Summary__c','Fish__c','');
	 	lstPostSurgery[0].Fish_val_Snomed__c = SnomedCTCode.SnomedCode('Post_Surgaory_Summary__c','Fish__c',recObjRight.Fish__c);*/
	 	/*upsert lstPostSurgery;
	 	System.debug('-------lstPostSurgery------->'+lstPostSurgery);
	 	System.debug('-------lstPostSurgery[0].Receptors_Right__c------->'+lstPostSurgery[0].Receptors_Right__c);*/
	 	//Pagereference pr = new Pagereference('/'+lstPathology[0].TrialPatient__r.Patient_Id__c);
	 	//return pr;
	}

//===============================function is for Breast Surgical Procedure Form===================================	
/*	public void insertRecBreastSurgicalRight(Id histologyId){
		recObjRight.Total_Score_ER__c = ERTotalScoreHiddenId;
	 	recObjRight.Total_Score_PR__c = PRTotalScoreHiddenId;
	 	recObjRight.Histology__c = histologyId;
	 	recObjRight.Letarality__c = 'Right';
	 	system.debug('__recObjRight__'+recObjRight);
	 	upsert recObjRight;
	}
	
//===============================function is for Breast Surgical Procedure Form===================================	
	public void insertRecBreastSurgicalLeft(Id histologyId){
		recObj.Total_Score_ER__c = ERTotalScoreHiddenId;
	 	recObj.Total_Score_PR__c = PRTotalScoreHiddenId;
	 	recObj.Histology__c = histologyId;
	 	recObj.Letarality__c = 'Left';
	 	system.debug('__recObj.Estrogen_Receptor_Status__c__'+recObj.Estrogen_Receptor_Status__c);
	 	upsert recObj; 
	} */
}