trigger ReceptorsAfterTrigger on Receptors__c (after insert, after update) {
	
	/*
	//commented because logic changed this method will called from its parent's future method
	if(Trigger.isUpdate) {
		Set<Id> ospIds = new Set<Id>();
		Set<Id> postIds = new Set<Id>();
		
		for(Receptors__c rec : Trigger.new){
			ospIds.add(rec.On_Study_Pathology_Form__c);
			postIds.add(rec.Post_Surgery_Summary__c);
		}
		
		List<On_Study_Pathology_Form__c> lstOsp = [select id,CRF__c, TrialPatient__c from On_Study_Pathology_Form__c where Id IN : ospIds];
		List<Post_Surgaory_Summary__c> lstPost = [select id,CRF__c, TrialPatient__c from Post_Surgaory_Summary__c where Id IN : postIds];
		
		set<Id> crfIds = new set<Id>();
		for(Post_Surgaory_Summary__c pss : lstPost){
			crfIds.add(pss.CRF__c);
		}
		
		for(On_Study_Pathology_Form__c osp : lstOsp){
			crfIds.add(osp.CRF__c);
		}
		
		List<Snomed_Code__c> snomedCodeList = [select id from Snomed_Code__c where CRF__c in :crfIds and snomed_Code_Name__c IN ('83302001 | oestrogen receptor assay (ERA) | '
												, '13892007 | progesterone receptor assay measurement | ', 'IHTSDO_4559' , 'IHTSDO_4556', '48676-1', 
												'Her2FISHstatus_OS', 'Her2IHCtest_OS' , 'Her2FISHtest_OS', '16112-5' , '10861-3', '18474-7', '48675-3')];
		if(!snomedCodeList.isEmpty()) {
			delete snomedCodeList;
		}
	}
	
	SnomedCTCode.insertReceptorRelatedCodes(Trigger.newMap.keySet());*/
	
	/*List<Snomed_Code__c> lstSnomed = new List<Snomed_Code__c>();
	List<Code_Master__c> lstSnomedMaster = [select id,Name,Variable_Description__c from Code_Master__c where Name = 'ERstatus_PS' or Name = 'PRstatus_PS'
					or Name = 'ER_TS_OS' or Name = 'PgR_TS_OS' or Name = 'Her2IHCstatus_OS' or Name = 'Her2FISHstatus_OS' or Name = 'Her2IHCtest_OS' 
					or Name = 'Her2FISHtest_OS'];
	Map<String, Code_Master__c> snomedMasterMap = new Map<String, Code_Master__c>();
		for(Code_Master__c sm : lstSnomedMaster) {
			snomedMasterMap.put(sm.Name, sm);
		}
		
	Set<Id> ospIds = new Set<Id>();
	Set<Id> postIds = new Set<Id>();
	
	for(Receptors__c rec : Trigger.new){
		ospIds.add(rec.On_Study_Pathology_Form__c);
		postIds.add(rec.Post_Surgery_Summary__c);
	}
	
	List<On_Study_Pathology_Form__c> lstOsp = [select id,CRF__c, TrialPatient__c from On_Study_Pathology_Form__c where Id IN : ospIds];
	List<Post_Surgaory_Summary__c> lstPost = [select id,CRF__c, TrialPatient__c from Post_Surgaory_Summary__c where Id IN : postIds];
	System.debug('-----lstOsp------>'+lstOsp);
	if(Trigger.isInsert) {
		for(Receptors__c rec : Trigger.new){
			for(On_Study_Pathology_Form__c osp : lstOsp){
				if(rec.On_Study_Pathology_Form__c == osp.Id){
					
					Snomed_Code__c sc = new Snomed_Code__c();
					sc.CRF__c = osp.CRF__c;
					sc.TrialPatient__c = osp.TrialPatient__c;
					sc.Name = '83302001';
					sc.Code_Master__c = snomedMasterMap.get('ERstatus_PS').Id;
					SnomedCTCode.SnomedWrapper sw = SnomedCTCode.SnomedCode('83302001', rec.Estrogen_Receptor_Status__c);
					sc.Value__c = sw.snomedCodeVal;
					sc.Code_System__c = sw.codeSystem;
					sc.caIntegratorValue__c = sw.caIntegratorValue;
					lstSnomed.add(sc);
					
					Snomed_Code__c sc1 = new Snomed_Code__c();
					sc1.CRF__c = osp.CRF__c;
					sc1.TrialPatient__c = osp.TrialPatient__c;
					sc1.Name = '13892007';
					sc1.Code_Master__c = snomedMasterMap.get('PRstatus_PS').Id;
					SnomedCTCode.SnomedWrapper sw1 = SnomedCTCode.SnomedCode('13892007', rec.Progesterone_Receptor_Status__c);
					sc1.Value__c = sw1.snomedCodeVal;
					sc1.Code_System__c = sw1.codeSystem;
					sc1.caIntegratorValue__c = sw1.caIntegratorValue;
					lstSnomed.add(sc1);
					
					Snomed_Code__c sc2 = new Snomed_Code__c();
					sc2.CRF__c = osp.CRF__c;
					sc2.TrialPatient__c = osp.TrialPatient__c;
					sc2.Name = 'IHTSDO_4559';
					sc2.Code_Master__c = snomedMasterMap.get('ER_TS_OS').Id;
					SnomedCTCode.SnomedWrapper sw2 = SnomedCTCode.SnomedCode('IHTSDO_4559', rec.Total_Score_ER__c+'');
					sc2.Value__c = sw2.snomedCodeVal;
					sc2.Code_System__c = sw2.codeSystem;
					sc2.caIntegratorValue__c = sw2.caIntegratorValue;
					lstSnomed.add(sc2);
					
					Snomed_Code__c sc3 = new Snomed_Code__c();
					sc3.CRF__c = osp.CRF__c;
					sc3.TrialPatient__c = osp.TrialPatient__c;
					sc3.Name = 'IHTSDO_4556';
					sc3.Code_Master__c = snomedMasterMap.get('PgR_TS_OS').Id;
					SnomedCTCode.SnomedWrapper sw3 = SnomedCTCode.SnomedCode('IHTSDO_4556', rec.Total_Score_PR__c+'');
					sc3.Value__c = sw3.snomedCodeVal;
					sc3.Code_System__c = sw3.codeSystem;
					sc3.caIntegratorValue__c = sw3.caIntegratorValue;
					lstSnomed.add(sc3);
					
					Snomed_Code__c sc4 = new Snomed_Code__c();
					sc4.CRF__c = osp.CRF__c;
					sc4.TrialPatient__c = osp.TrialPatient__c;
					sc4.Name = '48676-1';
					sc4.Code_Master__c = snomedMasterMap.get('Her2IHCstatus_OS').Id;
					SnomedCTCode.SnomedWrapper sw4 = SnomedCTCode.SnomedCode('48676-1', rec.IHC__c);
					sc4.Value__c = sw4.snomedCodeVal;
					sc4.Code_System__c = sw4.codeSystem;
					sc4.caIntegratorValue__c = sw4.caIntegratorValue;
					lstSnomed.add(sc4);
					
					Snomed_Code__c sc5 = new Snomed_Code__c();
					sc5.CRF__c = osp.CRF__c;
					sc5.TrialPatient__c = osp.TrialPatient__c;
					sc5.Name = 'Her2FISHstatus_OS';
					sc5.Code_Master__c = snomedMasterMap.get('Her2FISHstatus_OS').Id;
					SnomedCTCode.SnomedWrapper sw5 = SnomedCTCode.SnomedCode('48676-1', rec.Fish__c);
					sc5.Value__c = sw5.snomedCodeVal;
					sc5.Code_System__c = sw5.codeSystem;
					sc5.caIntegratorValue__c = sw5.caIntegratorValue;
					lstSnomed.add(sc5);
					
					Snomed_Code__c sc6 = new Snomed_Code__c();
					sc6.CRF__c = osp.CRF__c;
					sc6.TrialPatient__c = osp.TrialPatient__c;
					sc6.Name = 'Her2IHCtest_OS';
					sc6.Code_Master__c = snomedMasterMap.get('Her2IHCtest_OS').Id;
					sc6.Value__c = 'Not Coded';
					lstSnomed.add(sc6);	
					
					Snomed_Code__c sc7 = new Snomed_Code__c();
					sc7.CRF__c = osp.CRF__c;
					sc7.TrialPatient__c = osp.TrialPatient__c;
					sc7.Name = 'Her2FISHtest_OS';
					sc7.Code_Master__c = snomedMasterMap.get('Her2FISHtest_OS').Id;
					sc7.Value__c = 'Not Coded';
					lstSnomed.add(sc7);	
				}
			}
			for(Post_Surgaory_Summary__c pss : lstPost){
				if(rec.Post_Surgery_Summary__c == pss.Id){
					Snomed_Code__c sc7 = new Snomed_Code__c();
					sc7.CRF__c = pss.CRF__c;
					sc7.TrialPatient__c = pss.TrialPatient__c;
					sc7.Name = '16112-5';
					SnomedCTCode.SnomedWrapper sw7 = SnomedCTCode.SnomedCode('16112-5', rec.Estrogen_Receptor_Status__c);
					sc7.Value__c = sw7.snomedCodeVal;
					sc7.Code_System__c = sw7.codeSystem;
					sc7.caIntegratorValue__c = sw7.caIntegratorValue;
					lstSnomed.add(sc7);
					
					Snomed_Code__c sc8 = new Snomed_Code__c();
					sc8.CRF__c = pss.CRF__c;
					sc8.TrialPatient__c = pss.TrialPatient__c;
					sc8.Name = '10861-3';
					SnomedCTCode.SnomedWrapper sw8 = SnomedCTCode.SnomedCode('10861-3', rec.Progesterone_Receptor_Status__c);
					sc8.Value__c = sw8.snomedCodeVal;
					sc8.Code_System__c = sw8.codeSystem;
					sc8.caIntegratorValue__c = sw8.caIntegratorValue;
					lstSnomed.add(sc8);
					
					Snomed_Code__c sc9 = new Snomed_Code__c();
					sc9.CRF__c = pss.CRF__c;
					sc9.TrialPatient__c = pss.TrialPatient__c;
					sc9.Name = '18474-7'; 
					SnomedCTCode.SnomedWrapper sw9 = SnomedCTCode.SnomedCode('18474-7', rec.IHC__c);
					sc9.Value__c = sw9.snomedCodeVal;
					sc9.Code_System__c = sw9.codeSystem;
					sc9.caIntegratorValue__c = sw9.caIntegratorValue;
					lstSnomed.add(sc9);
					
					Snomed_Code__c sc10 = new Snomed_Code__c();
					sc10.CRF__c = pss.CRF__c;
					sc10.TrialPatient__c = pss.TrialPatient__c;
					sc10.Name = '48675-3';
					SnomedCTCode.SnomedWrapper sw10 = SnomedCTCode.SnomedCode('48675-3', rec.Fish__c);
					sc10.Value__c = sw10.snomedCodeVal;
					sc10.Code_System__c = sw10.codeSystem;
					sc10.caIntegratorValue__c = sw10.caIntegratorValue;
					lstSnomed.add(sc10);
				}
			}
		}
		if(!lstSnomed.isEmpty()){
			insert lstSnomed;
		}
	}
	
	if(Trigger.isUpdate) {
		Set<Id> crfIds = new Set<Id>();
		
		for(Post_Surgaory_Summary__c pss : lstPost){
			crfIds.add(pss.CRF__c);
		}
		
		for(On_Study_Pathology_Form__c osp : lstOsp){
			crfIds.add(osp.CRF__c);
		}
		
		List<Snomed_Code__c> lstSnomedCode = [select id,CRF__c,Value__c,Name from Snomed_Code__c where CRF__c IN : crfIds];
		for(Receptors__c rec : Trigger.new){
			for(Snomed_Code__c sc : lstSnomedCode){
				for(Post_Surgaory_Summary__c pss : lstPost){
					if(sc.CRF__c == pss.CRF__c && (rec.Post_Surgery_Summary__c == pss.Id)){
						if(sc.Name == '16112-5'){	
							SnomedCTCode.SnomedWrapper sw = SnomedCTCode.SnomedCode('16112-5', rec.Estrogen_Receptor_Status__c);
							sc.Value__c = sw.snomedCodeVal;
							sc.Code_System__c = sw.codeSystem;
							sc.caIntegratorValue__c = sw.caIntegratorValue;
						}
						if(sc.Name == '10861-3'){
							SnomedCTCode.SnomedWrapper sw = SnomedCTCode.SnomedCode('10861-3', rec.Progesterone_Receptor_Status__c);
							sc.Value__c = sw.snomedCodeVal;
							sc.Code_System__c = sw.codeSystem;
							sc.caIntegratorValue__c = sw.caIntegratorValue;
						}
						if(sc.Name == '18474-7'){
							SnomedCTCode.SnomedWrapper sw = SnomedCTCode.SnomedCode('18474-7', rec.IHC__c);
							sc.Value__c = sw.snomedCodeVal;
							sc.Code_System__c = sw.codeSystem;
							sc.caIntegratorValue__c = sw.caIntegratorValue;
						}
						if(sc.Name == '48675-3'){
							SnomedCTCode.SnomedWrapper sw = SnomedCTCode.SnomedCode('48675-3', rec.Fish__c);
							sc.Value__c = sw.snomedCodeVal;
							sc.Code_System__c = sw.codeSystem;
							sc.caIntegratorValue__c = sw.caIntegratorValue;
						} 
					}
				}
			
				for(On_Study_Pathology_Form__c osp : lstOsp){
					if(osp.CRF__c == sc.CRF__c && osp.Id == rec.On_Study_Pathology_Form__c){
						if(sc.Name == '83302001'){
							SnomedCTCode.SnomedWrapper sw = SnomedCTCode.SnomedCode('83302001', rec.Estrogen_Receptor_Status__c);
							sc.Value__c = sw.snomedCodeVal;
							sc.Code_System__c = sw.codeSystem;
							sc.caIntegratorValue__c = sw.caIntegratorValue;
						}  else if(sc.Name == '13892007'){
							SnomedCTCode.SnomedWrapper sw = SnomedCTCode.SnomedCode('13892007', rec.Progesterone_Receptor_Status__c);
							sc.Value__c = sw.snomedCodeVal;
							sc.Code_System__c = sw.codeSystem;
							sc.caIntegratorValue__c = sw.caIntegratorValue;
						} else if(sc.Name == 'IHTSDO_4559'){
							SnomedCTCode.SnomedWrapper sw = SnomedCTCode.SnomedCode('IHTSDO_4559', ''+rec.Total_Score_ER__c);
							sc.Value__c = sw.snomedCodeVal;
							sc.Code_System__c = sw.codeSystem;
							sc.caIntegratorValue__c = sw.caIntegratorValue;
						} else if(sc.Name == 'IHTSDO_4556'){
							SnomedCTCode.SnomedWrapper sw = SnomedCTCode.SnomedCode('IHTSDO_4556', ''+rec.Total_Score_PR__c);
							sc.Value__c = sw.snomedCodeVal;
							sc.Code_System__c = sw.codeSystem;
							sc.caIntegratorValue__c = sw.caIntegratorValue;
						} else if(sc.Name == '48676-1'){
							SnomedCTCode.SnomedWrapper sw = SnomedCTCode.SnomedCode('48676-1', rec.HER2_neu_Marker__c);
							sc.Value__c = sw.snomedCodeVal;
							sc.Code_System__c = sw.codeSystem;
							sc.caIntegratorValue__c = sw.caIntegratorValue;
						}
					}
				}
			}
		}
		if(!lstSnomedCode.isEmpty()){
			upsert lstSnomedCode;
		}
	}*/
}