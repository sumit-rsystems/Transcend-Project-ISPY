trigger IrradiatedSiteBeforeTrigger on Irradiated_Site__c (before insert, before update) {
	
	/*set<Id> setIds = new set<Id>();
	for(Irradiated_Site__c is : Trigger.new){
		setIds.add(is.Followup_Form__c);
	}
	List<Followup_Form__c> lstFF = [select id,CRF__c,TrialPatient__c from Followup_Form__c where Id IN : setIds];
	if(Trigger.isInsert){
		List<Snomed_Code__c> lstSnomed = new List<Snomed_Code__c>();
		List<Code_Master__c> lstSnomedMaster = [select id,Name,Variable_Description__c from Code_Master__c where Name = 'Adj_AromataseInhib'];
		for(Irradiated_Site__c is : Trigger.new){
			for(Followup_Form__c ff : lstFF){
				for(Code_Master__c sm : lstSnomedMaster){
					if(ff.Id == is.Followup_Form__c){
						Snomed_Code__c sc = new Snomed_Code__c();
						sc.CRF__c = ff.CRF__c;
						sc.TrialPatient__c = ff.TrialPatient__c;
						if(is.Site__c == 'Boost'){
							if(sm.Name == 'Adj_AromataseInhib'){
								sc.Name = 'IHTSDO_4585';
								sc.Code_Master__c = sm.Id;
								SnomedCTCode.SnomedWrapper sw = SnomedCTCode.SnomedCode('IHTSDO_4585', 'Yes');
								sc.Value__c = sw.snomedCodeVal;
								sc.Code_System__c = sw.codeSystem;
								sc.Numeric_Value__c = sw.numericValue;
							}
						} else if(is.Site__c == 'Axilla'){
							sc.Name = '429579007';
							SnomedCTCode.SnomedWrapper sw = SnomedCTCode.SnomedCode('429579007', 'Yes');
							sc.Value__c = sw.snomedCodeVal;
							sc.Code_System__c = sw.codeSystem;
							sc.Numeric_Value__c = sw.numericValue;
						} else if(is.Site__c == 'Supraclavicular node'){
							sc.Name = '429685005';
							SnomedCTCode.SnomedWrapper sw = SnomedCTCode.SnomedCode('429685005', 'Yes');
							sc.Value__c = sw.snomedCodeVal;
							sc.Code_System__c = sw.codeSystem;
							sc.Numeric_Value__c = sw.numericValue;
						} else if(is.Site__c == 'Internal mammary node'){
							sc.Name = '429685005';
							SnomedCTCode.SnomedWrapper sw = SnomedCTCode.SnomedCode('429685005', 'Yes');
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
	}
	if(Trigger.isUpdate){
		set<Id> crfIds = new set<Id>();
		for(Followup_Form__c ff : lstFF){
			crfIds.add(ff.CRF__c);
		}
		List<Snomed_Code__c> lstSnomed = [select id,CRF__c,TrialPatient__c,Name from Snomed_Code__c where CRF__c IN : crfIds];
		for(Irradiated_Site__c is : Trigger.new){
			for(Followup_Form__c ff : lstFF){
				for(Snomed_Code__c sc : lstSnomed){
					if(ff.CRF__c == sc.CRF__c && is.Followup_Form__c == ff.Id){
						if(is.Site__c == 'Boost'){
							if(sc.Name == 'IHTSDO_4585'){
								SnomedCTCode.SnomedWrapper sw = SnomedCTCode.SnomedCode('IHTSDO_4585', 'Yes');
								sc.Value__c = sw.snomedCodeVal;
								sc.Code_System__c = sw.codeSystem;
								sc.Numeric_Value__c = sw.numericValue;
							}
						} else if(is.Site__c == 'Axilla'){
							if(sc.Name == '429579007'){
								SnomedCTCode.SnomedWrapper sw = SnomedCTCode.SnomedCode('429579007', 'Yes');
								sc.Value__c = sw.snomedCodeVal;
								sc.Code_System__c = sw.codeSystem;
								sc.Numeric_Value__c = sw.numericValue;
							}
						} else if(is.Site__c == 'Supraclavicular node'){
							if(sc.Name == '429685005'){
								SnomedCTCode.SnomedWrapper sw = SnomedCTCode.SnomedCode('429685005', 'Yes');
								sc.Value__c = sw.snomedCodeVal;
								sc.Code_System__c = sw.codeSystem;
								sc.Numeric_Value__c = sw.numericValue;
							}
						} else if(is.Site__c == 'Internal mammary node'){
							if(sc.Name == '429685005'){
								SnomedCTCode.SnomedWrapper sw = SnomedCTCode.SnomedCode('429685005', 'Yes');
								sc.Value__c = sw.snomedCodeVal;
								sc.Code_System__c = sw.codeSystem;
								sc.Numeric_Value__c = sw.numericValue;
							}
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