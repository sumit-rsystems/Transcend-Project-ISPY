trigger TherapyReceivedAfterInsertUpdate on Therapy_Received__c (after insert, after update) {

	/*if(Trigger.isInsert){
		List<Snomed_Code__c> lstSnomed = new List<Snomed_Code__c>();
		List<Code_Master__c> lstSnomedMaster = [select id,Name,Variable_Description__c from Code_Master__c where Name = 'Adj_AromataseInhib' or Name = 'Adj_OvarianSup' or Name = 'Adj_OvarianAbl' or Name = 'Adj_Tam' or Name = 'Adj_Trastuzumab'];
		for(Therapy_Received__c tr : Trigger.new){
			for(Followup_Form__c ff : lstFF){
				for(Code_Master__c sm : lstSnomedMaster){
					if(ff.Id == tr.Followup_Form__c){
						Snomed_Code__c sc = new Snomed_Code__c();
						sc.CRF__c = ff.CRF__c;
						sc.TrialPatient__c = ff.TrialPatient__c;
						if(tr.Therapy__c == 'Aromatase inhibitor' && sm.Name == 'Adj_AromataseInhib'){
							sc.Name = '108775004';
							SnomedCTCode.SnomedWrapper sw = SnomedCTCode.SnomedCode('108775004', 'Yes');
							sc.Value__c = sw.snomedCodeVal;
							sc.Code_System__c = sw.codeSystem;
							sc.Numeric_Value__c = sw.numericValue;
						} else if(tr.Therapy__c == 'Ovarian suppression' && sm.Name == 'Adj_OvarianSup'){
							sc.Name = '373840003';
							SnomedCTCode.SnomedWrapper sw = SnomedCTCode.SnomedCode('373840003', 'Yes');
							sc.Value__c = sw.snomedCodeVal;
							sc.Code_System__c = sw.codeSystem;
							sc.Numeric_Value__c = sw.numericValue;
						} else if(tr.Therapy__c == 'Ovarian ablation' && sm.Name == 'Adj_OvarianAbl'){
							sc.Name = '373844007';
							SnomedCTCode.SnomedWrapper sw = SnomedCTCode.SnomedCode('373844007', 'Yes');
							sc.Value__c = sw.snomedCodeVal;
							sc.Code_System__c = sw.codeSystem;
							sc.Numeric_Value__c = sw.numericValue;
						} else if(tr.Therapy__c == 'Trastuzumab' && sm.Name == 'Adj_Trastuzumab'){
							sc.Name = '224905';
							SnomedCTCode.SnomedWrapper sw = SnomedCTCode.SnomedCode('224905', 'Yes');
							sc.Value__c = sw.snomedCodeVal;
							sc.Code_System__c = sw.codeSystem;
							sc.Numeric_Value__c = sw.numericValue;
						} else if(tr.Therapy__c == 'Tamoxifen' && sm.Name == 'Adj_Tam'){
							sc.Name = '224905';
							SnomedCTCode.SnomedWrapper sw = SnomedCTCode.SnomedCode('10324', 'Yes');
							sc.Value__c = sw.snomedCodeVal;
							sc.Code_System__c = sw.codeSystem;
							sc.Numeric_Value__c = sw.numericValue;
						}
						lstSnomed.add(sc);
					}
				}
			}
		}
		if(!lstSnomed.isEmpty()){
			insert lstSnomed;
		}
	}*/
	if(Trigger.isUpdate){
		
		/*set<Id> setIds = new set<Id>();
		for(Therapy_Received__c tr : Trigger.new){
			setIds.add(tr.Followup_Form__c);
		}
		List<Followup_Form__c> lstFF = [select id,CRF__c,TrialPatient__c from Followup_Form__c where Id IN : setIds];
	
		set<Id> crfIds = new set<Id>();
		for(Followup_Form__c ff : lstFF){
			crfIds.add(ff.CRF__c);
		}
		List<Snomed_Code__c> lstSnomed = [select id,CRF__c,TrialPatient__c,Name from Snomed_Code__c where CRF__c IN : crfIds and (snomed_Code_Name__c = 'Adj_Trastuzumab' or snomed_Code_Name__c = 'Adj_OvarianAbl' or snomed_Code_Name__c = 'Adj_Tam' or snomed_Code_Name__c = 'Adj_AromataseInhib' or snomed_Code_Name__c = 'Adj_OvarianSup')];

		delete lstSnomed;*/
		
		/*for(Therapy_Received__c tr : Trigger.new){
			for(Followup_Form__c ff : lstFF){
				for(Snomed_Code__c sc : lstSnomed){
					if(sc.CRF__c == ff.CRF__c && tr.Followup_Form__c == ff.Id){
						if(tr.Therapy__c == 'Aromatase inhibitor'){
							sc.Name = '108775004';
							SnomedCTCode.SnomedWrapper sw = SnomedCTCode.SnomedCode('108775004', 'Yes');
							sc.Value__c = sw.snomedCodeVal;
							sc.Code_System__c = sw.codeSystem;
							sc.Numeric_Value__c = sw.numericValue;
						} else if(tr.Therapy__c == 'Ovarian suppression'){
							sc.Name = '373840003';
							SnomedCTCode.SnomedWrapper sw = SnomedCTCode.SnomedCode('373840003', 'Yes');
							sc.Value__c = sw.snomedCodeVal;
							sc.Code_System__c = sw.codeSystem;
							sc.Numeric_Value__c = sw.numericValue;
						} else if(tr.Therapy__c == 'Ovarian ablation'){
							sc.Name = '373844007';
							SnomedCTCode.SnomedWrapper sw = SnomedCTCode.SnomedCode('373844007', 'Yes');
							sc.Value__c = sw.snomedCodeVal;
							sc.Code_System__c = sw.codeSystem;
							sc.Numeric_Value__c = sw.numericValue;
						} else if(tr.Therapy__c == 'Trastuzumab'){
							sc.Name = '224905';
							SnomedCTCode.SnomedWrapper sw = SnomedCTCode.SnomedCode('224905', 'Yes');
							sc.Value__c = sw.snomedCodeVal;
							sc.Code_System__c = sw.codeSystem;
							sc.Numeric_Value__c = sw.numericValue;
						} else if(tr.Therapy__c == 'Tamoxifen'){
							sc.Name = '224905';
							SnomedCTCode.SnomedWrapper sw = SnomedCTCode.SnomedCode('10324', 'Yes');
							sc.Value__c = sw.snomedCodeVal;
							sc.Code_System__c = sw.codeSystem;
							sc.Numeric_Value__c = sw.numericValue;
						}
					}
				}
			}
		}
		if(!lstSnomed.isEmpty()){
			update lstSnomed;
		}*/
	}
	
	//SnomedCTCode.insertSnomedCodesForLongTermTherapy(Trigger.newMap.keySet());
}