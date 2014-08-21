trigger ProcedureBeforeInsert on Procedure__c (before insert, before update) {
	
	//set<Id> setIds = new set<Id>();
	//for(Procedure__c pro : Trigger.new){
	//	setIds.add(pro.On_Study_Pathology_Form__c);
	//}
	//List<On_Study_Pathology_Form__c> lstOsp = [select id,CRF__c,TrialPatient__c from On_Study_Pathology_Form__c where Id IN : setIds];
	//Set<Id> trialPatientIds = new Set<Id>();
	//for(On_Study_Pathology_Form__c osp : lstOsp) {
	//	trialPatientIds.add(osp.TrialPatient__c);
	//}
	
	//List<Snomed_Code__c> snomedCodeList = [select id from Snomed_Code__c where TrialPatient__c in :trialPatientIds and (Name = 'FNA_Br_pretx' or Name = 'CoreNeedle_Br__pretx' or Name = 'Excisional_Br_pretx'
	//			 or Name = 'Excisional_Br_pretx' or Name = 'CoreNeedle_LN_Pretx' or Name = 'Bx_SN_Pretx' or Name = '392021009' or Name = 'IHTSDO_4683')];
	//if(!snomedCodeList.isEmpty()) {
	//	delete snomedCodeList;
	//}
	
	//deleting the existing snomed and inserting them again.
	//This code works in both update and insert scenarios
	//SnomedCTCode.insertProcedureRelatedCodes(Trigger.new.keySet());
	
	/*boolean FNA_Br_pretxDone = false;
	boolean CoreNeedle_Br_pretx = false;
	boolean CoreNeedle_LN_Pretx = false;
	boolean IHTSDO_4565 = false;
	boolean Bx_SN_Pretx = false;
	boolean FNA_LN_Pretx = false;
	
	Set<Id> allTrialPatients = new Set<Id>();
	
	Map<Id, integer> trialPatientAndTotalAuxSentPostiveNodesMap = new Map<Id, integer>();
	Map<Id, boolean> trialPatientAndSurgLumpectoryDoneMap = new Map<Id, boolean>();
	
	if(Trigger.isInsert){
		List<Snomed_Code__c> lstSnomed = new List<Snomed_Code__c>();
		set<Id> setIds = new set<Id>();
		for(Procedure__c pro : Trigger.new){
			setIds.add(pro.On_Study_Pathology_Form__c);
		}
		List<Code_Master__c> lstSnomedMaster = [select id,Name,Variable_Description__c from Code_Master__c 
				where Name = 'FNA_Br_pretx' or Name = 'CoreNeedle_Br__pretx' or Name = 'Excisional_Br_pretx'
				 or Name = 'Excisional_Br_pretx' or Name = 'CoreNeedle_LN_Pretx' or Name = 'Bx_SN_Pretx'];
		Map<String, Code_Master__c> snomedMasterMap = new Map<String, Code_Master__c>();
		for(Code_Master__c sm : lstSnomedMaster) {
			snomedMasterMap.put(sm.Name, sm);
		} 
		List<On_Study_Pathology_Form__c> lstOsp = [select id,CRF__c,TrialPatient__c from On_Study_Pathology_Form__c where Id IN : setIds];
		for(Procedure__c pro : Trigger.new){
			for(On_Study_Pathology_Form__c osp : lstOsp){
				if(pro.On_Study_Pathology_Form__c != osp.Id) continue;
				allTrialPatients.add(osp.TrialPatient__c);
				
				if(pro.Form_Name__c == 'On-Study Pathology Form(Lymph Node Biopsies)') {
					if(pro.Node_Type__c == 'Axillary (Lymph node)' || pro.Node_Type__c == 'Sentinel (Lymph node)') {
						if(pro.Node_Result__c == 'Positive') {
							integer totalAuxSentPositiveNodes = 0;
							if(trialPatientAndTotalAuxSentPostiveNodesMap.containsKey(osp.TrialPatient__c)) {
								totalAuxSentPositiveNodes = trialPatientAndTotalAuxSentPostiveNodesMap.get(osp.TrialPatient__c);
							}
							totalAuxSentPositiveNodes++;
							trialPatientAndTotalAuxSentPostiveNodesMap.put(osp.TrialPatient__c, totalAuxSentPositiveNodes);
						}
					}
				}
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
				} else if(pro.Procedure_Name__c == 'Partial mastectomy' || pro.Procedure_Name__c == 'Excisional biopsy (lymph node)'){
					//Snomed_Code__c sc = new Snomed_Code__c();
					//sc.CRF__c = osp.CRF__c;
					//sc.TrialPatient__c = osp.TrialPatient__c;
					//sc.Name = '392021009';
					//SnomedCTCode.SnomedWrapper sw = SnomedCTCode.SnomedCode('392021009', 'Yes');
					//sc.Value__c = sw.snomedCodeVal;
					//sc.Code_System__c = sw.codeSystem;
					//sc.caIntegratorValue__c = sw.caIntegratorValue;
					//lstSnomed.add(sc);
					trialPatientAndSurgLumpectoryDoneMap.put(osp.TrialPatient__c, true);
				}
			}
		}
		List<Snomed_Code__c> scList = [Select s.Value__c, s.TrialPatient__c, s.caIntegratorValue__c, s.Name From Snomed_Code__c s where s.TrialPatient__c in :allTrialPatients and s.Name in ('IHTSDO_4683','48635004','18498-6','44578009','29300007','IHTSDO_4565','274372001')];
		
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
			SnomedCTCode.SnomedWrapper sw = SnomedCTCode.SnomedCode('IHTSDO_4683', ''+totalAuxSentPositiveNodes);
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
		}
	}*/
}