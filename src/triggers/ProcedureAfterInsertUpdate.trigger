trigger ProcedureAfterInsertUpdate on Procedure__c (after insert, after update) {
	if(Trigger.isInsert){
          SharingManager.shareObjectWithSite(Trigger.new, 'Procedure__c', 'Site');
    }  
	
	
	/*
	//commented because logic changed this method will called from its parent's future method
	set<Id> setIds = new set<Id>();
	set<Id> posIds = new set<Id>();
	for(Procedure__c pro : Trigger.new){
		if(pro.On_Study_Pathology_Form__c != null) {
			setIds.add(pro.On_Study_Pathology_Form__c);
		}
		if(pro.Post_Surgery_Summary__c != null ) {
			posIds.add(pro.Post_Surgery_Summary__c);
		}
	}
	
	List<On_Study_Pathology_Form__c> lstOsp = [select id,CRF__c,TrialPatient__c from On_Study_Pathology_Form__c where Id IN : setIds];
	Set<Id> trialPatientIds = new Set<Id>();
	for(On_Study_Pathology_Form__c osp : lstOsp) {
		trialPatientIds.add(osp.TrialPatient__c);
	}
	
	List<Post_Surgaory_Summary__c> pssList = [select id,CRF__c,TrialPatient__c from Post_Surgaory_Summary__c where Id IN : posIds];
	for(Post_Surgaory_Summary__c pss : pssList) {
		trialPatientIds.add(pss.TrialPatient__c);
	}
	
	List<Snomed_Code__c> snomedCodeList = [select id from Snomed_Code__c where TrialPatient__c in :trialPatientIds and (snomed_Code_Name__c = '48635004 | fine needle biopsy | ' or snomed_Code_Name__c = '18498-6' or snomed_Code_Name__c = '44578009 | core needle biopsy of breast | '
				 or snomed_Code_Name__c = '29300007 | core needle biopsy of lymph node | ' or snomed_Code_Name__c = 'IHTSDO_4565' or snomed_Code_Name__c = '274372001 | surgical biopsy of lymph node | ' or snomed_Code_Name__c = '392021009 | lumpectomy of breast | ' or snomed_Code_Name__c = 'IHTSDO_4683')];
	if(!snomedCodeList.isEmpty()) {
		delete snomedCodeList;
	}
	
	//deleting the existing snomed and inserting them again.
	//This code works in both update and insert scenarios
	SnomedCTCode.insertProcedureRelatedCodes(Trigger.newMap.keySet());*/
	
	/*boolean FNA_Br_pretxDone = false;
	boolean CoreNeedle_Br_pretx = false;
	boolean CoreNeedle_LN_Pretx = false;
	boolean IHTSDO_4565 = false;
	boolean Bx_SN_Pretx = false;
	boolean FNA_LN_Pretx = false;
	
	Set<Id> allTrialPatients = new Set<Id>();
	
	Map<Id, integer> trialPatientAndTotalAuxSentPostiveNodesMap = new Map<Id, integer>();
	Map<Id, integer> trialPatientAndTotalAuxSentExamineNodesMap = new Map<Id, integer>();
	Map<Id, boolean> trialPatientAndSurgLumpectoryDoneMap = new Map<Id, boolean>();
	
	Set<Id> procIds = Trigger.newMap.keySet();
	List<Procedure__c> procList = [Select p.pg_procedure_id__c, p.Ultrasound__c, p.TrialPatient__c, p.Total_Positive__c, p.Total_Examined_Nodes__c, p.SystemModstamp, p.Stereotactic__c, p.Procedure_Name__c, p.Post_Surgery_Summary__c, p.Palpation_guided__c, p.OwnerId, p.On_Study_Pathology_Form__c, p.Node_Type__c, p.Node_Result__c, p.Name, p.Mammography__c, p.MRI__c, p.Location__c, p.Laterality__c, p.LastModifiedDate, p.LastModifiedById, p.IsDeleted, p.Id, p.Form_Name__c, p.Date_Of_Procedure__c, p.CreatedDate, p.CreatedById, (Select Additional_Nodes__c, Axillary_Nodes__c, Positive__c, Procedure__c, Sentinel_Nodes__c From Lymph_Nodes__r) From Procedure__c p where id IN :procIds];
	
	List<Snomed_Code__c> lstSnomed = new List<Snomed_Code__c>();
	set<Id> setIds = new set<Id>();
	set<Id> posIds = new Set<Id>();
	for(Procedure__c pro : procList){
		if(pro.On_Study_Pathology_Form__c != null) {
			setIds.add(pro.On_Study_Pathology_Form__c);
		}
		if(pro.Post_Surgery_Summary__c != null) {
			posIds.add(pro.Post_Surgery_Summary__c);
		}
	}
	List<Code_Master__c> lstSnomedMaster = [select id,Name,Variable_Description__c from Code_Master__c 
			where Name IN ('FNA_Br_pretx', 'CoreNeedle_Br__pretx', 'Excisional_Br_pretx','Surgery_Br', 'Excisional_Br_pretx', 'CoreNeedle_LN_Pretx', 'Bx_SN_Pretx', 'NumExLN_PS', 'NumPosLN_PS')];
	Map<String, Code_Master__c> snomedMasterMap = new Map<String, Code_Master__c>();
	for(Code_Master__c sm : lstSnomedMaster) {
		snomedMasterMap.put(sm.Name, sm);
	} 
	List<On_Study_Pathology_Form__c> lstOsp = [select id,CRF__c,TrialPatient__c from On_Study_Pathology_Form__c where Id IN : setIds];
	for(Procedure__c pro : procList){
		for(On_Study_Pathology_Form__c osp : lstOsp){
			if(pro.On_Study_Pathology_Form__c != osp.Id) continue;
			allTrialPatients.add(osp.TrialPatient__c);
			
			if(pro.Procedure_Name__c == 'FNA'){
				Snomed_Code__c sc = new Snomed_Code__c();
				sc.CRF__c = osp.CRF__c;
				sc.TrialPatient__c = osp.TrialPatient__c;
				sc.Name = '48635004';
				sc.Code_Master__c = snomedMasterMap.get('FNA_Br_pretx').Id;
				SnomedCTCode.SnomedWrapper sw = SnomedCTCode.SnomedCode('48635004', 'Yes');
				sc.Value__c = sw.snomedCodeVal;
				sc.Code_System__c = sw.codeSystem;
				sc.caIntegratorValue__c = sw.caIntegratorValue;
				lstSnomed.add(sc);
				FNA_Br_pretxDone = true;
			} else if(pro.Procedure_Name__c == 'FNA (lymph node)'){
				Snomed_Code__c sc = new Snomed_Code__c();
				sc.CRF__c = osp.CRF__c;
				sc.TrialPatient__c = osp.TrialPatient__c;
				sc.Name = '18498-6';
				SnomedCTCode.SnomedWrapper sw = SnomedCTCode.SnomedCode('18498-6', pro.Node_Result__c);
				sc.Value__c = sw.snomedCodeVal;
				sc.Code_System__c = sw.codeSystem;
				sc.caIntegratorValue__c = sw.caIntegratorValue;
				lstSnomed.add(sc);
				FNA_LN_Pretx = true;
			} else if(pro.Procedure_Name__c == 'Core biopsy'){
				Snomed_Code__c sc = new Snomed_Code__c();
				sc.CRF__c = osp.CRF__c;
				sc.TrialPatient__c = osp.TrialPatient__c;
				sc.Name = '44578009';
				sc.Code_Master__c = snomedMasterMap.get('CoreNeedle_Br__pretx').Id;
				SnomedCTCode.SnomedWrapper sw = SnomedCTCode.SnomedCode('44578009', 'Yes');
				sc.Value__c = sw.snomedCodeVal;
				sc.Code_System__c = sw.codeSystem;
				sc.caIntegratorValue__c = sw.caIntegratorValue;
				lstSnomed.add(sc);
				CoreNeedle_Br_pretx = true;
			} else if(pro.Procedure_Name__c == 'Core biopsy (lymph node)'){
				Snomed_Code__c sc = new Snomed_Code__c();
				sc.CRF__c = osp.CRF__c;
				sc.TrialPatient__c = osp.TrialPatient__c;
				sc.Code_Master__c = snomedMasterMap.get('CoreNeedle_LN_Pretx').Id;
				sc.Name = '29300007';
				SnomedCTCode.SnomedWrapper sw = SnomedCTCode.SnomedCode('29300007', pro.Node_Result__c);
				sc.Value__c = sw.snomedCodeVal;
				sc.Code_System__c = sw.codeSystem;
				sc.caIntegratorValue__c = sw.caIntegratorValue;
				lstSnomed.add(sc);
				CoreNeedle_LN_Pretx = true;
			} else if(pro.Procedure_Name__c == 'Incisional biopsy'){
				Snomed_Code__c sc = new Snomed_Code__c();
				sc.CRF__c = osp.CRF__c;
				sc.TrialPatient__c = osp.TrialPatient__c;
				sc.Name = 'IHTSDO_4565';
				sc.Code_Master__c = snomedMasterMap.get('Excisional_Br_pretx').Id;
				SnomedCTCode.SnomedWrapper sw = SnomedCTCode.SnomedCode('IHTSDO_4565', pro.Node_Result__c);
				sc.Value__c = sw.snomedCodeVal;
				sc.Code_System__c = sw.codeSystem;
				sc.caIntegratorValue__c = sw.caIntegratorValue;
				lstSnomed.add(sc);
				IHTSDO_4565 = true;
			} else if(pro.Node_Type__c == 'Sentinel (Lymph node)'){
				Snomed_Code__c sc = new Snomed_Code__c();
				sc.CRF__c = osp.CRF__c;
				sc.TrialPatient__c = osp.TrialPatient__c;
				sc.Name = '274372001';
				sc.Code_Master__c = snomedMasterMap.get('Bx_SN_Pretx').Id;
				SnomedCTCode.SnomedWrapper sw = SnomedCTCode.SnomedCode('274372001', pro.Node_Result__c);
				sc.Value__c = sw.snomedCodeVal;
				sc.Code_System__c = sw.codeSystem;
				sc.caIntegratorValue__c = sw.caIntegratorValue;
				lstSnomed.add(sc);
			}
		}
	}
	
	List<Post_Surgaory_Summary__c> postList = [select id,CRF__c,TrialPatient__c from Post_Surgaory_Summary__c where Id IN : posIds];
	for(Procedure__c pro : procList){
		for(Post_Surgaory_Summary__c pss : postList) {
			if(pss.Id != pro.Post_Surgery_Summary__c)continue;
			
			if(pro.Procedure_Name__c == 'Partial mastectomy' || pro.Procedure_Name__c == 'Therapeutic Mastectomy' || pro.Procedure_Name__c == 'Skin Sparing Mastectomy' || pro.Procedure_Name__c == 'Total skin sparing mastectomy' || pro.Procedure_Name__c == 'Modified radical mastectomy') {
				Snomed_Code__c sc = new Snomed_Code__c();
				sc.CRF__c = pss.CRF__c;
				sc.TrialPatient__c = pss.TrialPatient__c;
				sc.Name = '172043006';
				sc.Code_Master__c = snomedMasterMap.get('Surgery_Br').Id;
				SnomedCTCode.SnomedWrapper sw = SnomedCTCode.SnomedCode('172043006', 'Yes');
				sc.Value__c = sw.snomedCodeVal;
				sc.Code_System__c = sw.codeSystem;
				sc.caIntegratorValue__c = sw.caIntegratorValue;
				lstSnomed.add(sc);
			} else {
				Snomed_Code__c sc = new Snomed_Code__c();
				sc.CRF__c = pss.CRF__c;
				sc.TrialPatient__c = pss.TrialPatient__c;
				sc.Name = '172043006';
				sc.Code_Master__c = snomedMasterMap.get('Surgery_Br').Id;
				SnomedCTCode.SnomedWrapper sw = SnomedCTCode.SnomedCode('172043006', 'No');
				sc.Value__c = sw.snomedCodeVal;
				sc.Code_System__c = sw.codeSystem;
				sc.caIntegratorValue__c = sw.caIntegratorValue;
				lstSnomed.add(sc);
			}
			if(pro.Procedure_Name__c == 'Partial mastectomy' || pro.Procedure_Name__c == 'Excisional biopsy (lymph node)'){
				trialPatientAndSurgLumpectoryDoneMap.put(pss.TrialPatient__c, true);
			}*/
			//wrong logic for Axillary and Sentinel lymph nodes. These should be fetch from lymph node object not from procedure object.
			/*if(pro.Node_Type__c == 'Axillary (Lymph node)' || pro.Node_Type__c == 'Sentinel (Lymph node)') {
				if(pro.Node_Result__c == 'Positive') {
					integer totalAuxSentPositiveNodes = 0;
					if(trialPatientAndTotalAuxSentPostiveNodesMap.containsKey(pss.TrialPatient__c)) {
						totalAuxSentPositiveNodes = trialPatientAndTotalAuxSentPostiveNodesMap.get(pss.TrialPatient__c);
					}
					totalAuxSentPositiveNodes++;
					trialPatientAndTotalAuxSentPostiveNodesMap.put(pss.TrialPatient__c, totalAuxSentPositiveNodes);
				}
			}*/
	
			/*integer totalAuxSentPositiveNodes = 0;
			integer totalAuxSentExamineNodes = 0;
			for(Lymph_Nodes__c lymph : pro.Lymph_Nodes__r) {
				if(lymph.Procedure__c == pro.Id) {
					if(lymph.Axillary_Nodes__c || lymph.Sentinel_Nodes__c) {
				//===============for positive nodes=============================================== 		
						if(trialPatientAndTotalAuxSentPostiveNodesMap.containsKey(pss.TrialPatient__c)) {
							totalAuxSentPositiveNodes = trialPatientAndTotalAuxSentPostiveNodesMap.get(pss.TrialPatient__c);
						}
						totalAuxSentPositiveNodes+= Integer.valueOf(lymph.Positive__c);
						trialPatientAndTotalAuxSentPostiveNodesMap.put(pss.TrialPatient__c, totalAuxSentPositiveNodes);
						
				//===============for examine nodes===============================================		
						if(trialPatientAndTotalAuxSentExamineNodesMap.containsKey(pss.TrialPatient__c)) {
							totalAuxSentExamineNodes = trialPatientAndTotalAuxSentExamineNodesMap.get(pss.TrialPatient__c);
						}
						totalAuxSentExamineNodes+= Integer.valueOf(lymph.Positive__c);
						trialPatientAndTotalAuxSentExamineNodesMap.put(pss.TrialPatient__c, totalAuxSentExamineNodes);
					}
				}
			}
		}
	}
	
	List<Snomed_Code__c> scList = [Select s.Value__c, s.TrialPatient__c, s.caIntegratorValue__c, s.Name From Snomed_Code__c s where s.TrialPatient__c in :allTrialPatients and s.Name in ('IHTSDO_4683','48635004','18498-6','44578009','29300007','IHTSDO_4565','274372001')];
//===============for positive nodes===============================================
	Set<Id> trialPatientIds = trialPatientAndTotalAuxSentPostiveNodesMap.keySet();
	for(Id tpId : trialPatientIds) {
		integer totalAuxSentPositiveNodes = -1;
		Snomed_Code__c sc = null;
		boolean codeExists = false;
		for(Snomed_Code__c sc1 : scList) {
			if(sc1.TrialPatient__c == tpId && sc1.Name == 'IHTSDO_4683') {
				totalAuxSentPositiveNodes = Integer.valueOf(sc1.Value__c); 
				codeExists = true;
			}
		}
		if(!codeExists)sc = new Snomed_Code__c();
		if(trialPatientAndTotalAuxSentPostiveNodesMap.containsKey(tpId)) {
			if(trialPatientAndTotalAuxSentPostiveNodesMap.get(tpId) > 0 && totalAuxSentPositiveNodes == -1) {
				totalAuxSentPositiveNodes = trialPatientAndTotalAuxSentPostiveNodesMap.get(tpId);
			} else if(totalAuxSentPositiveNodes > 0 && trialPatientAndTotalAuxSentPostiveNodesMap.get(tpId) > 0){
				totalAuxSentPositiveNodes += trialPatientAndTotalAuxSentPostiveNodesMap.get(tpId);
			}
		}
		
		//sc.CRF__c = osp.CRF__c;
		sc.TrialPatient__c = tpId;
		sc.Name = 'IHTSDO_4683';
		SnomedCTCode.SnomedWrapper sw = new SnomedCTCode.SnomedWrapper();
		if(totalAuxSentPositiveNodes != -1) {
			sw = SnomedCTCode.SnomedCode('IHTSDO_4683', ''+totalAuxSentPositiveNodes);
		} else {
			sw = SnomedCTCode.SnomedCode('IHTSDO_4683', 'No axillary');
		}
		sc.Value__c = sw.snomedCodeVal;
		sc.Code_System__c = sw.codeSystem;
		sc.caIntegratorValue__c = sw.caIntegratorValue;
		lstSnomed.add(sc);
	}
	
//===============for Examine nodes===============================================
	trialPatientIds.clear();
	trialPatientIds = trialPatientAndTotalAuxSentExamineNodesMap.keySet();
	for(Id tpId : trialPatientIds) {
		integer totalAuxSentExamineNodes = -1;
		Snomed_Code__c sc = null;
		boolean codeExists = false;
		for(Snomed_Code__c sc1 : scList) {
			if(sc1.TrialPatient__c == tpId && sc1.Name == 'IHTSDO_4683') {
				totalAuxSentExamineNodes = Integer.valueOf(sc1.Value__c); 
				codeExists = true;
			}
		}
		if(!codeExists)sc = new Snomed_Code__c();
		if(trialPatientAndTotalAuxSentExamineNodesMap.containsKey(tpId)) {
			if(trialPatientAndTotalAuxSentExamineNodesMap.get(tpId) > 0 && totalAuxSentExamineNodes == -1) {
				totalAuxSentExamineNodes = trialPatientAndTotalAuxSentExamineNodesMap.get(tpId);
			} else if(totalAuxSentExamineNodes > 0 && trialPatientAndTotalAuxSentExamineNodesMap.get(tpId) > 0){
				totalAuxSentExamineNodes += trialPatientAndTotalAuxSentExamineNodesMap.get(tpId);
			}
		}
		
		//sc.CRF__c = osp.CRF__c;
		sc.TrialPatient__c = tpId;
		sc.Name = 'IHTSDO_4683';
		SnomedCTCode.SnomedWrapper sw = new SnomedCTCode.SnomedWrapper();
		if(totalAuxSentExamineNodes != -1) {
			sw = SnomedCTCode.SnomedCode('313195009 | procedure carried out | : 363589002 | associated procedure | = 284429001 | examination of axillary lymph nodes |', ''+totalAuxSentExamineNodes);
		} else {
			sw = SnomedCTCode.SnomedCode('313195009 | procedure carried out | : 363589002 | associated procedure | = 284429001 | examination of axillary lymph nodes |', '0');
		}
		sc.Value__c = sw.snomedCodeVal;
		sc.Code_System__c = sw.codeSystem;
		sc.caIntegratorValue__c = sw.caIntegratorValue;
		lstSnomed.add(sc);
	}

	trialPatientIds.clear();
	trialPatientIds = trialPatientAndSurgLumpectoryDoneMap.keySet();
	for(Id tpId : trialPatientIds) {
		boolean surgeryLumpectomyDone = trialPatientAndSurgLumpectoryDoneMap.get(tpId);
		integer snomedValue = 0;
		Snomed_Code__c sc = null;
		boolean codeExists = false;
		for(Snomed_Code__c sc1 : scList) {
			if(sc1.TrialPatient__c == tpId && sc1.Name == '392021009') {
				snomedValue = Integer.valueOf(sc1.Value__c); 
				codeExists = true;
			}
		}
		if(!codeExists)sc = new Snomed_Code__c();
		
		if(snomedValue > 0) break;
		
		//sc.CRF__c = osp.CRF__c;
		sc.TrialPatient__c = tpId;
		sc.Name = '392021009';
		SnomedCTCode.SnomedWrapper sw = null;
		if(surgeryLumpectomyDone) {
			sw = SnomedCTCode.SnomedCode('392021009', 'Yes');
		} else {
			sw = SnomedCTCode.SnomedCode('392021009', 'No');
		}
		sc.Value__c = sw.snomedCodeVal;
		sc.Code_System__c = sw.codeSystem;
		sc.caIntegratorValue__c = sw.caIntegratorValue;
		lstSnomed.add(sc);
	}
	
	if(!lstSnomed.isEmpty()){
		upsert lstSnomed;
	}*/
}