trigger StagingAfterTrigger on Staging_Detail__c (after insert, after update) {
	
	/*
	//commented because logic changed
	if(Trigger.isUpdate) {
		Set<Id> postIds = new Set<Id>();
		for(Staging_Detail__c stage : Trigger.new){
			postIds.add(stage.Post_Surgery_Summary__c);
		}
		
		List<Post_Surgaory_Summary__c> lstPostSur = [select CRF__c, TrialPatient__c from Post_Surgaory_Summary__c where Id IN :postIds];
		Set<Id> CRFIds = new Set<Id>();
		for(Post_Surgaory_Summary__c pss : lstPostSur) {
			CRFIds.add(pss.CRF__c);
		}
		
		List<Snomed_Code__c> lstSnomedCode = [select id,CRF__c,Value__c,Name from Snomed_Code__c where CRF__c IN : CRFIds and snomed_Code_Name__c IN ('254292007 | tumour staging | '
											, '78873005 | T category | 78873005', '277206009 | N category | ', '277208005 | M category | ')];
		if(!lstSnomedCode.isEmpty()) {
			delete lstSnomedCode;
		}
	}
	SnomedCTCode.insertStagingRelatedCodes(Trigger.newMap.keySet());*/
	
	/*set<Id> setIds = new set<Id>();
	for(Staging_Detail__c stage : Trigger.new){
		setIds.add(stage.Post_Surgery_Summary__c);
	}
	List<Post_Surgaory_Summary__c> lstPost = [select id,CRF__c,TrialPatient__c from Post_Surgaory_Summary__c where Id IN : setIds];
	List<Code_Master__c> lstSnomedMaster = [select id,Name,Variable_Description__c from Code_Master__c where Name = 'PathologyStage_PS' 
											or Name = 'ypT' or Name = 'ypN' or Name = 'ypM'];
	if(Trigger.isInsert){
		List<Snomed_Code__c> lstSnomed = new List<Snomed_Code__c>();
		for(Staging_Detail__c stage : Trigger.new){
			for(Post_Surgaory_Summary__c pss : lstPost){
				for(Code_Master__c sm : lstSnomedMaster){
					if(stage.Post_Surgery_Summary__c == pss.Id){
						if(sm.Name == 'PathologyStage_PS'){
							Snomed_Code__c sc14 = new Snomed_Code__c();
							sc14.CRF__c = pss.CRF__c;
							sc14.TrialPatient__c = pss.TrialPatient__c;
							sc14.Name = '254292007';
							sc14.Code_Master__c = sm.Id;
							SnomedCTCode.SnomedWrapper sw14 = SnomedCTCode.SnomedCode('254292007', stage.Adjudicated_Stage__c);
							sc14.Value__c = sw14.snomedCodeVal;
							sc14.Code_System__c = sw14.codeSystem;
							sc14.Numeric_Value__c = sw14.numericValue;	
							lstSnomed.add(sc14);
						}
						if(sm.Name == 'ypT'){
							Snomed_Code__c sc14 = new Snomed_Code__c();
							sc14.CRF__c = pss.CRF__c;
							sc14.TrialPatient__c = pss.TrialPatient__c;
							sc14.Name = '78873005';
							sc14.Code_Master__c = sm.Id;
							SnomedCTCode.SnomedWrapper sw14 = SnomedCTCode.SnomedCode('78873005', stage.Tumor_Type__c);
							sc14.Value__c = sw14.snomedCodeVal;
							sc14.Code_System__c = sw14.codeSystem;
							sc14.Numeric_Value__c = sw14.numericValue;	
							lstSnomed.add(sc14);
						}
						if(sm.Name == 'ypN'){
							Snomed_Code__c sc14 = new Snomed_Code__c();
							sc14.CRF__c = pss.CRF__c;
							sc14.TrialPatient__c = pss.TrialPatient__c;
							sc14.Name = '277206009';
							sc14.Code_Master__c = sm.Id;
							SnomedCTCode.SnomedWrapper sw14 = SnomedCTCode.SnomedCode('277206009', stage.Node_Type__c);
							sc14.Value__c = sw14.snomedCodeVal;
							sc14.Code_System__c = sw14.codeSystem;
							sc14.Numeric_Value__c = sw14.numericValue;	
							lstSnomed.add(sc14);
						}
						if(sm.Name == 'ypM'){
							Snomed_Code__c sc14 = new Snomed_Code__c();
							sc14.CRF__c = pss.CRF__c;
							sc14.TrialPatient__c = pss.TrialPatient__c;
							sc14.Name = '277208005';
							sc14.Code_Master__c = sm.Id;
							SnomedCTCode.SnomedWrapper sw14 = SnomedCTCode.SnomedCode('277208005', stage.Metastasis__c);
							sc14.Value__c = sw14.snomedCodeVal;
							sc14.Code_System__c = sw14.codeSystem;
							sc14.Numeric_Value__c = sw14.numericValue;	
							lstSnomed.add(sc14);
						}
					}
				}
			}
		}
		if(!lstSnomed.isEmpty()){
			insert lstSnomed;
		}
	}
	if(Trigger.isUpdate){
		for(Staging_Detail__c stage : Trigger.new){
			setIds.add(stage.Post_Surgery_Summary__c);
		}
		set<Id> crfIds = new set<Id>();
		for(Post_Surgaory_Summary__c pss : lstPost){
			crfIds.add(pss.CRF__c);
		}
		List<Snomed_Code__c> lstSnomed = [select id,Value__c,Name,CRF__c from Snomed_Code__c where CRF__c IN : crfIds];
		for(Staging_Detail__c stage : Trigger.new){
			for(Post_Surgaory_Summary__c pss : lstPost){
				for(Snomed_Code__c sc : lstSnomed){
					if(stage.Post_Surgery_Summary__c == pss.Id && sc.CRF__c == pss.CRF__c){
						if(sc.Name == '254292007'){
							SnomedCTCode.SnomedWrapper sw = SnomedCTCode.SnomedCode('254292007', stage.Adjudicated_Stage__c);
							sc.Value__c = sw.snomedCodeVal;
							sc.Code_System__c = sw.codeSystem;
						}
						if(stage.Tumor_Type__c != null && sc.Name == '78873005'){
							SnomedCTCode.SnomedWrapper sw = SnomedCTCode.SnomedCode('78873005', stage.Tumor_Type__c);
							sc.Value__c = sw.snomedCodeVal;
							sc.Code_System__c = sw.codeSystem;
						}
						if(stage.Node_Type__c != null && sc.Name == '277206009'){
							SnomedCTCode.SnomedWrapper sw1 = SnomedCTCode.SnomedCode('277206009', stage.Node_Type__c);
							sc.Value__c = sw1.snomedCodeVal;
							sc.Code_System__c = sw1.codeSystem;
						}
						if(stage.Metastasis__c != null && sc.Name == '277208005'){
							SnomedCTCode.SnomedWrapper sw2 = SnomedCTCode.SnomedCode('277208005', stage.Metastasis__c);
							sc.Value__c = sw2.snomedCodeVal;
							sc.Code_System__c = sw2.codeSystem;
						}
					}
				}
			}
		}
		if(!lstSnomed.isEmpty()){
			update lstSnomed;
		}
	}*/
}