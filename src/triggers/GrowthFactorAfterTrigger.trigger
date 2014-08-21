trigger GrowthFactorAfterTrigger on Growth_Factor__c (after insert, after update) {
	
	
	/*if(Trigger.isInsert){
		List<Snomed_Code__c> lstSnomed = new List<Snomed_Code__c>();
		List<Code_Master__c> lstSnomedMaster = [select id,Name,Variable_Description__c from Code_Master__c where Name = 'ChemoGrowthMeds'];
		for(Growth_Factor__c gf : Trigger.new){
			for(Chemo_Treatment__c ct : lstChemoTreat){
				if(gf.Chemo_Treatment__c == ct.Id){
					for(Code_Master__c sm : lstSnomedMaster){
						Snomed_Code__c sc = new Snomed_Code__c();
						sc.CRF__c = ct.CRF__c;
						sc.TrialPatient__c = ct.TrialPatient__c;
						sc.Name = '110461004';
						sc.Code_Master__c = sm.Id; 
						if(gf.Name == 'Neulasta' && gf.isReceived__c){
							SnomedCTCode.SnomedWrapper sw = SnomedCTCode.SnomedCode('110461004', 'Pegfilgrastim (Neulasta)');
							sc.Value__c = sw.snomedCodeVal;
							sc.Code_System__c = sw.codeSystem;
							sc.Numeric_Value__c = sw.numericValue;
						} else if(gf.Name == 'Neupogen' && gf.isReceived__c){
							SnomedCTCode.SnomedWrapper sw = SnomedCTCode.SnomedCode('110461004', 'Filgrastin (Neupogen)');
							sc.Value__c = sw.snomedCodeVal;
							sc.Code_System__c = sw.codeSystem;
							sc.Numeric_Value__c = sw.numericValue;
						} else {
							SnomedCTCode.SnomedWrapper sw = SnomedCTCode.SnomedCode('110461004', 'Not given');
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
		
		/*set<Id> chemoTreatIds = new set<Id>();
		for(Growth_Factor__c gf : Trigger.new){
			chemoTreatIds.add(gf.Chemo_Treatment__c);
		}
		List<Chemo_Treatment__c> lstChemoTreat = [select id,CRF__c,TrialPatient__c from Chemo_Treatment__c where Id IN : chemoTreatIds];
		
		set<Id> crfIds = new set<Id>();
		for(Chemo_Treatment__c ct : lstChemoTreat){
			crfIds.add(ct.CRF__c);
		}
		List<Snomed_Code__c> lstSnomed = [select id,CRF__c,Name,Value__c from Snomed_Code__c where CRF__c IN : crfIds and Name = '110461004 | adjunctive care | '];
		
		delete lstSnomed;*/
		
		/*for(Growth_Factor__c gf : Trigger.new){
			for(Snomed_Code__c sc : lstSnomed){
				for(Chemo_Treatment__c ct : lstChemoTreat){
					if(ct.CRF__c == sc.CRF__c && gf.Chemo_Treatment__c == ct.Id){
						if(sc.Name == '110461004'){
							if(gf.Name == 'Neulasta' && gf.isReceived__c){
								SnomedCTCode.SnomedWrapper sw = SnomedCTCode.SnomedCode('110461004', 'Pegfilgrastim (Neulasta)');
								sc.Value__c = sw.snomedCodeVal;
								sc.Code_System__c = sw.codeSystem;
								sc.Numeric_Value__c = sw.numericValue;
							} else if(gf.Name == 'Neupogen' && gf.isReceived__c){
								SnomedCTCode.SnomedWrapper sw = SnomedCTCode.SnomedCode('110461004', 'Filgrastin (Neupogen)');
								sc.Value__c = sw.snomedCodeVal;
								sc.Code_System__c = sw.codeSystem;
								sc.Numeric_Value__c = sw.numericValue;
							} else {
								SnomedCTCode.SnomedWrapper sw = SnomedCTCode.SnomedCode('110461004', 'Not given');
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
		}*/
	}
	//SnomedCTCode.insertSnomedCodesForGrowthFactor(Trigger.newMap.keySet());
}