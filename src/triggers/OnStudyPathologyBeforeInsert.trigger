trigger OnStudyPathologyBeforeInsert on On_Study_Pathology_Form__c (before insert, before update) {
	
	Set<Id> ids = new Set<Id>();
	for(On_Study_Pathology_Form__c osp : Trigger.new){
		ids.add(osp.TrialPatient__c);
	}
	List<Site_Trial__c> siteTrials = [Select s.Trial__c, s.Site__c, s.Name From Site_Trial__c s];
	Map<CRF__c, String> crfGroupNameMap = new Map<CRF__c, String>();
	
	List<TrialPatient__c> trialPatientList = [select Id, Site__c, Patient_Id__c,Trial_Id__c from TrialPatient__c where Id IN :ids];
	System.debug('----trialPatientList----->'+trialPatientList);
	if(Trigger.isInsert){
		List<CRF__c> lstCRF = new List<CRF__c>();
		for(On_Study_Pathology_Form__c osp : Trigger.new){
			for(TrialPatient__c tmpListObj : trialPatientList) {
				if(osp.TrialPatient__c == tmpListObj.Id) {
					CRF__c c = new CRF__c();
					c.Patient__c = tmpListObj.Patient_Id__c;
					if(osp.Status__c == null) { 
						c.Status__c = 'Not Completed';
					} else {
						c.Status__c = osp.Status__c;
					}
					if(!trialPatientList.isEmpty()){
						c.Trial__c = trialPatientList[0].Trial_Id__c;
					}
					c.TrialPatient__c = osp.TrialPatient__c;
					c.Complete_Date__c = System.today();
					c.Type__c = 'On_Study_Pathology_Form__c';
					c.Phase__c = 'Screening';
					lstCRF.add(c);
					for(Site_Trial__c st : siteTrials) {
	                	if(st.Trial__c == tmpListObj.Trial_Id__c && st.Site__c == tmpListObj.Site__c) {
	                		crfGroupNameMap.put(c, st.Name);
	                		break;
	                	}
	                }
				}
			} 
		}
		if(!lstCRF.isEmpty()){
			insert lstCRF;
		}
		List<Group> gList = [Select g.Name, g.Id From Group g where name in :crfGroupNameMap.values()];
		Map<String, Id> gNameIdMap = new Map<String, Id>();
        for(Group g :gList) {
        	gNameIdMap.put(g.Name, g.Id);
        }
        List<CRF__Share> lstCRFShare = new List<CRF__Share>();
		for(CRF__c crf : lstCRF){
			CRF__Share shareRec = new CRF__Share();
			System.debug('crfGroupNameMap.get(crf)---------'+crfGroupNameMap.get(crf));
			if(crfGroupNameMap.get(crf) != null && gNameIdMap.get(crfGroupNameMap.get(crf)) != null){
				shareRec.UserOrGroupId = gNameIdMap.get(crfGroupNameMap.get(crf));
				shareRec.AccessLevel = 'Edit';
				shareRec.ParentId =  crf.Id;
				lstCRFShare.add(shareRec);
			}
		}
		insert lstCRFShare;
		
		for(On_Study_Pathology_Form__c osp : Trigger.new){
			for(TrialPatient__c tmpListObj : trialPatientList) {
				for(CRF__c crfObj : lstCRF){
					if(crfObj.Patient__c == tmpListObj.Patient_Id__c){
						system.debug('RequiredFieldHandler.fromDataLoader : '+RequiredFieldHandler.fromDataLoader);
						system.debug('osp.Does_the_patient_have_bilateral_breast_c__c : '+osp.Does_the_patient_have_bilateral_breast_c__c);
						system.debug('osp.Tumor_laterality__c : '+osp.Tumor_laterality__c);
						if(!RequiredFieldHandler.fromDataLoader) {
							if(osp.Does_the_patient_have_bilateral_breast_c__c == null || osp.Does_the_patient_have_bilateral_breast_c__c == '') {
								throw new RequiredFieldException('Required field missing - Please provide Does the patient have bilateral breast cancer?');
							} else if(osp.Tumor_laterality__c == null || osp.Tumor_laterality__c == '') {
								throw new RequiredFieldException('Required field missing - Please provide Tumor laterality (or side with most advanced disease).');
							}
						}
						osp.CRF__c = crfObj.Id;
						if(osp.Status__c == null) {
							osp.Status__c = 'Not Completed';
						}
						osp.Phase__c = 'Screening';	
					}
				}
			}
		}
	}
	if(Trigger.isUpdate){
		//Map<Id, On_Study_Pathology_Form__c> approvalRequest = new Map<Id, On_Study_Pathology_Form__c>(); 
		set<Id> setCrfIds = new set<Id>();
		Set<String> trialPatients = new Set<String>();
		for(On_Study_Pathology_Form__c osp : Trigger.new){
			setCrfIds.add(osp.CRF__c);
			trialPatients.add(osp.TrialPatient__c);
			
		}
		List<CRF__c> lstCrf = [select id,Status__c from CRF__c where id IN : setCrfIds];
		//List<ProcessInstanceHistory> approvalRecordList = [select Id, IsPending, ProcessInstanceId, TargetObjectId, StepStatus, OriginalActorId, ActorId, RemindersSent, Comments, IsDeleted, CreatedDate, CreatedById, SystemModstamp from ProcessInstanceHistory where TargetObjectId IN :Trigger.newMap.keySet()];
		//List<ProcessInstance> approvalRecordList = [Select (Select Id, IsPending, ProcessInstanceId, TargetObjectId, StepStatus, OriginalActorId, ActorId, RemindersSent, Comments, IsDeleted, CreatedDate, CreatedById, SystemModstamp From StepsAndWorkitems) From ProcessInstance p];
		//system.debug('__approvalRecordList__'+approvalRecordList);
		for(On_Study_Pathology_Form__c osp : Trigger.new){
			for(CRF__c crf : lstCrf){
				System.debug('------osp.Id--------->'+osp.Id);
				System.debug('------crf.Id--------->'+crf.Id);
				System.debug('------osp.Status__c--------->'+osp.Status__c);
				System.debug('------condition--------->'+((crf.id == osp.CRF__c) && (osp.Status__c != Trigger.oldMap.get(osp.id).Status__c)));
				if(crf.id == osp.CRF__c && osp.Status__c != Trigger.oldMap.get(osp.id).Status__c){
					crf.Status__c = osp.Status__c;
					System.debug('------crf.Status__c1--------->'+crf.Status__c);
				} 
				System.debug('------crf.Status__c--------->'+crf.Status__c);
			}
			system.debug('__osp.Status__c__'+osp.Status__c);
		}
		
		if(!lstCrf.isEmpty()){
			update lstCrf;
		}
		
		
		
	}
//old commented
	/*for(On_Study_Pathology_Form__c osp : Trigger.new){
		osp.Patient_have_bilateral_breast_Snomed__c = SnomedCTCode.SnomedCode('On_Study_Pathology_Form__c','Does_the_patient_have_bilateral_breast_c__c','');
		osp.Patient_have_bilateral_breast_val_Snomed__c = SnomedCTCode.SnomedCode('On_Study_Pathology_Form__c','Does_the_patient_have_bilateral_breast_c__c',osp.Does_the_patient_have_bilateral_breast_c__c);
		osp.Tumor_laterality_Snomed__c = SnomedCTCode.SnomedCode('On_Study_Pathology_Form__c','Tumor_laterality__c','');
		osp.Tumor_laterality_val_Snomed__c = SnomedCTCode.SnomedCode('On_Study_Pathology_Form__c','Tumor_laterality__c',osp.Tumor_laterality__c);
	}*/
	
	/*List<Code_Master__c> lstSnomedMaster = [select id,Name,Variable_Description__c from Code_Master__c where Name = 'InvHistology_OSInvasive'
											or Name = 'ERstatus_OS' or Name = 'PRstatus_OS' or Name = 'BilateralCa' or Name = 'Laterality' 
											or Name = 'LNsampled_OS' or Name = 'LNresult_OS' or Name = 'InvSBR_OS'];
	Map<String, Code_Master__c> snomedMasterMap = new Map<String, Code_Master__c>();
	for(Code_Master__c sm : lstSnomedMaster) {
		snomedMasterMap.put(sm.Name, sm);
	}
		
	if(Trigger.isInsert && Trigger.isBefore){
		//set<Id> setIds = new set<Id>();
		set<Id> ospIds = new set<Id>();
		for(On_Study_Pathology_Form__c osp : Trigger.new){
			//setIds.add(osp.Receptors__c);
			ospIds.add(osp.Id);
		}
		List<Snomed_Code__c> lstSnomed = new List<Snomed_Code__c>();
		boolean samplingPerformed = false;
		boolean singleNode = false;
		List<Lymph_Nodes__c> lstLymphNodes = [Select l.Sentinel_Nodes__c, l.Single_Detection_Result__c, l.Procedure__r.On_Study_Pathology_Form__c, l.Procedure__c From Lymph_Nodes__c l where Procedure__r.On_Study_Pathology_Form__c IN :ospIds];
		for(Lymph_Nodes__c ln : lstLymphNodes) {
			if(ln.Sentinel_Nodes__c) {
				samplingPerformed = true;
				break;
			}
			
			if(ln.Single_Detection_Result__c) {
				singleNode = true;
				break;
			}
			
		}
		
		for(On_Study_Pathology_Form__c osp : Trigger.new){
			for(Code_Master__c sm : lstSnomedMaster){*/
			//old commented
				/*if(sm.Name == 'ERstatus_OS'){
					Snomed_Code__c sc = new Snomed_Code__c();
					sc.CRF__c = osp.CRF__c;
					sc.TrialPatient__c = osp.TrialPatient__c;
					sc.Name = '83302001';
					sc.Code_Master__c = sm.Id;
					SnomedCTCode.SnomedWrapper sw = SnomedCTCode.SnomedCode('83302001', '');
					sc.Code_System__c = sw.codeSystem;
					sc.caIntegratorValue__c = sw.caIntegratorValue;
					lstSnomed.add(sc);
				}
				if(sm.Name == 'PRstatus_OS'){
					Snomed_Code__c sc1 = new Snomed_Code__c();
					sc1.CRF__c = osp.CRF__c;
					sc1.TrialPatient__c = osp.TrialPatient__c;
					sc1.Name = '13892007';
					sc1.Code_Master__c = sm.Id;
					SnomedCTCode.SnomedWrapper sw1 = SnomedCTCode.SnomedCode('13892007', '');
					sc1.Code_System__c = sw1.codeSystem;
					sc1.caIntegratorValue__c = sw1.caIntegratorValue;
					lstSnomed.add(sc1);
				}*/
				/*if(sm.Name == 'BilateralCa'){
					Snomed_Code__c sc2 = new Snomed_Code__c();
					sc2.CRF__c = osp.CRF__c;
					sc2.TrialPatient__c = osp.TrialPatient__c;
					sc2.Name = '254838004';
					sc2.Code_Master__c = sm.Id;
					SnomedCTCode.SnomedWrapper sw2 = SnomedCTCode.SnomedCode('254838004', '');
					sc2.Code_System__c = sw2.codeSystem;
					sc2.caIntegratorValue__c = sw2.caIntegratorValue;
					lstSnomed.add(sc2);
				}
				if(sm.Name == 'Laterality'){
					Snomed_Code__c sc3 = new Snomed_Code__c();
					sc3.CRF__c = osp.CRF__c;
					sc3.TrialPatient__c = osp.TrialPatient__c;
					sc3.Name = '384727002';
					sc3.Code_Master__c = sm.Id;
					SnomedCTCode.SnomedWrapper sw3 = SnomedCTCode.SnomedCode('254838004', osp.Tumor_laterality__c);
					sc3.Value__c = sw3.snomedCodeVal;
					sc3.Code_System__c = sw3.codeSystem;
					sc3.caIntegratorValue__c = sw3.caIntegratorValue;
					lstSnomed.add(sc3);
				}
				if(sm.Name == 'LNsampled_OS'){
					Snomed_Code__c sc4 = new Snomed_Code__c();
					sc4.CRF__c = osp.CRF__c;
					sc4.TrialPatient__c = osp.TrialPatient__c;
					sc4.Name = '396487001';
					sc4.Code_Master__c = sm.Id;
					SnomedCTCode.SnomedWrapper sw4 = null;
					if(samplingPerformed) {
						sw4 = SnomedCTCode.SnomedCode('396487001', 'Yes');
					} else {
						sw4 = SnomedCTCode.SnomedCode('396487001', 'No');
					}
					sc4.Value__c = sw4.snomedCodeVal;
					sc4.Code_System__c = sw4.codeSystem;
					sc4.caIntegratorValue__c = sw4.caIntegratorValue;
					lstSnomed.add(sc4);
					
				}
				if(sm.Name == 'LNresult_OS'){
					Snomed_Code__c sc5 = new Snomed_Code__c();
					sc5.CRF__c = osp.CRF__c;
					sc5.TrialPatient__c = osp.TrialPatient__c;
					sc5.Name = '384727002';
					sc5.Code_Master__c = sm.Id;
					SnomedCTCode.SnomedWrapper sw5 = null;
					if(samplingPerformed) {
						sw5 = SnomedCTCode.SnomedCode('254838004', 'Yes');
					} else {
						sw5 = SnomedCTCode.SnomedCode('254838004', 'No');
					}
					
					sc5.Value__c = sw5.snomedCodeVal;
					sc5.Code_System__c = sw5.codeSystem;
					sc5.caIntegratorValue__c = sw5.caIntegratorValue;
					lstSnomed.add(sc5);
				}
				if(sm.Name == 'InvHistology_OSInvasive'){
					Snomed_Code__c scNew = new Snomed_Code__c();
					scNew.CRF__c = osp.CRF__c;
					scNew.TrialPatient__c = osp.TrialPatient__c;
					scNew.Name = '396785008';
					scNew.Code_Master__c = snomedMasterMap.get('InvHistology_OSInvasive').Id;
					//At the time of insertion we are considering the Grade value is empty. but on update it will be updated by actual value.
					SnomedCTCode.SnomedWrapper sw = SnomedCTCode.SnomedCode('396785008', '');  
					scNew.Code_System__c = sw.codeSystem;
					scNew.caIntegratorValue__c = sw.caIntegratorValue;
					lstSnomed.add(scNew);
				}
				
				if(sm.Name == 'InvSBR_OS'){
					Snomed_Code__c scNew = new Snomed_Code__c();
					scNew.CRF__c = osp.CRF__c;
					scNew.TrialPatient__c = osp.TrialPatient__c;
					scNew.Name = '371469007';
					scNew.Code_Master__c = snomedMasterMap.get('InvSBR_OS').Id;
					//At the time of insertion we are considering the Grade value is empty. but on update it will be updated by actual value.
					SnomedCTCode.SnomedWrapper sw = SnomedCTCode.SnomedCode('371469007', '');  
					scNew.Code_System__c = sw.codeSystem;
					scNew.caIntegratorValue__c = sw.caIntegratorValue;
					lstSnomed.add(scNew);
				}
			}
			
			Snomed_Code__c sc = new Snomed_Code__c();
			sc.CRF__c = osp.CRF__c;
			sc.TrialPatient__c = osp.TrialPatient__c;
			sc.Name = 'IHTSDO_4556';
			SnomedCTCode.SnomedWrapper sw = SnomedCTCode.SnomedCode('IHTSDO_4556', '');
			sc.Code_System__c = sw.codeSystem;
			sc.caIntegratorValue__c = sw.caIntegratorValue;
			lstSnomed.add(sc);
			
			Snomed_Code__c sc1 = new Snomed_Code__c();
			sc1.CRF__c = osp.CRF__c;
			sc1.TrialPatient__c = osp.TrialPatient__c;
			sc1.Name = 'IHTSDO_4559';
			SnomedCTCode.SnomedWrapper sw1 = SnomedCTCode.SnomedCode('IHTSDO_4559', '');
			sc1.Code_System__c = sw1.codeSystem;
			sc1.caIntegratorValue__c = sw1.caIntegratorValue;
			lstSnomed.add(sc1);
			
			Snomed_Code__c sc2 = new Snomed_Code__c();
			sc2.CRF__c = osp.CRF__c;
			sc2.TrialPatient__c = osp.TrialPatient__c;
			sc2.Name = '48676-1';
			SnomedCTCode.SnomedWrapper sw2 = SnomedCTCode.SnomedCode('48676-1', '');
			sc2.Code_System__c = sw2.codeSystem;
			sc2.caIntegratorValue__c = sw2.caIntegratorValue;
			lstSnomed.add(sc2);
		}
		if(!lstSnomed.isEmpty()){
			insert lstSnomed;
		}
	}
	boolean invSnomedInserted = false;
	if(Trigger.isUpdate){
		//set<Id> setIds = new set<Id>();
		set<Id> crfIds = new set<Id>();
		set<Id> proIds = new set<Id>();
		//set<Id> invIds = new set<Id>();
		set<Id> ospIds = new set<Id>();
		
		for(On_Study_Pathology_Form__c osp : Trigger.new){
			//setIds.add(osp.Receptors__c);
			proIds.add(osp.Procedure__c);
			crfIds.add(osp.CRF__c);
			//invIds.add(osp.Invasive_Tumor_Detail__c);
			ospIds.add(osp.Id);
		}
		//system.debug('invIds : '+invIds);
		List<Snomed_Code__c> lstSnomed = new List<Snomed_Code__c>();
		List<Invasive_Tumor_Detail__c> lstInvTumor = [Select i.Nuclear_Grade__c, i.Id From Invasive_Tumor_Detail__c i where On_Study_Pathology_Form__c IN :ospIds];
		List<Snomed_Code__c> lstSnomedCode = [select id,Value__c,Name,CRF__c from Snomed_Code__c where CRF__c IN : crfIds];
		List<Receptors__c> lstRec = [select id, HER2_neu_Marker__c, Estrogen_Receptor_Status__c,Progesterone_Receptor_Status__c,Estrogen_Total_Score__c,Progesterone_Total_Score__c from Receptors__c where On_Study_Pathology_Form__c IN : ospIds];
		List<Lymph_Nodes__c> lstLymphNodes = [Select l.Sentinel_Nodes__c,l.Single_Detection_Result__c,l.Procedure__r.On_Study_Pathology_Form__c, l.Procedure__c From Lymph_Nodes__c l where Procedure__c IN :proIds];
		for(On_Study_Pathology_Form__c osp : Trigger.new){
			for(Snomed_Code__c sc : lstSnomedCode){
				for(Invasive_Tumor_Detail__c inv : lstInvTumor) {
					system.debug('sc.CRF__c : '+sc.CRF__c);
					system.debug('osp.CRF__c : '+osp.CRF__c);
					//system.debug('osp.Invasive_Tumor_Detail__c : '+osp.Invasive_Tumor_Detail__c);
					system.debug('inv.On_Study_Pathology_Form__c : '+inv.On_Study_Pathology_Form__c);
					system.debug('inv.Id : '+inv.Id);
					system.debug('inv.Nuclear_Grade__c : '+inv.Nuclear_Grade__c);
					if((inv.On_Study_Pathology_Form__c == osp.Id) && (osp.CRF__c == sc.CRF__c)) {
						if(sc.Name == '396785008') {
							SnomedCTCode.SnomedWrapper sw = SnomedCTCode.SnomedCode('396785008', '');
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
				boolean samplingPerformed = false;
				boolean singleNode = false;
				for(Lymph_Nodes__c ln : lstLymphNodes) {
					if(ln.Sentinel_Nodes__c) {
						samplingPerformed = true;
						break;
					}
					
					if(ln.Single_Detection_Result__c) {
						singleNode = true;
						break;
					}
				}
				for(Lymph_Nodes__c ln : lstLymphNodes) {
					if(osp.CRF__c == sc.CRF__c && osp.Procedure__c == ln.Id){
						if(sc.Name == '396487001'){
							
							SnomedCTCode.SnomedWrapper sw = null;
							if(samplingPerformed) {
								sw = SnomedCTCode.SnomedCode('396487001', 'Yes');
							} else {
								sw = SnomedCTCode.SnomedCode('396487001', 'No');
							}
							
							sc.Value__c = sw.snomedCodeVal;
							sc.Code_System__c = sw.codeSystem;
							sc.caIntegratorValue__c = sw.caIntegratorValue;
							
						}
						if(sc.Name == '254838004'){
							SnomedCTCode.SnomedWrapper sw = null;
							if(samplingPerformed) {
								sw = SnomedCTCode.SnomedCode('254838004', 'Yes');
							} else {
								sw = SnomedCTCode.SnomedCode('254838004', 'No');
							}
							
							sc.Value__c = sw.snomedCodeVal;
							sc.Code_System__c = sw.codeSystem;
							sc.caIntegratorValue__c = sw.caIntegratorValue;
						}
					}
				}
				if(sc.Name == '254838004'){
					SnomedCTCode.SnomedWrapper sw = SnomedCTCode.SnomedCode('254838004', osp.Does_the_patient_have_bilateral_breast_c__c);
					sc.Value__c = sw.snomedCodeVal;
					sc.Code_System__c = sw.codeSystem;
					sc.caIntegratorValue__c = sw.caIntegratorValue;
				} else if(sc.Name == '384727002'){
					SnomedCTCode.SnomedWrapper sw = SnomedCTCode.SnomedCode('384727002', osp.Tumor_laterality__c);
					sc.Value__c = sw.snomedCodeVal;
					sc.Code_System__c = sw.codeSystem;
					sc.caIntegratorValue__c = sw.caIntegratorValue;
				}
				if(sc.Name == '396785008'){
					SnomedCTCode.SnomedWrapper sw = SnomedCTCode.SnomedCode('396785008', '');
					sc.Value__c = sw.snomedCodeVal;
					sc.Code_System__c = sw.codeSystem;
					sc.caIntegratorValue__c = sw.caIntegratorValue;
				} 
			}
		}
		if(!lstSnomedCode.isEmpty()){
			update lstSnomedCode;
		}
		if(!lstSnomed.isEmpty()) {
			insert lstSnomed; 
		}
	}*/
}