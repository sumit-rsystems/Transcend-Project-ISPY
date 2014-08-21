trigger OnStudyEligibilityBeforeInsert on On_Study_Eligibility_Form__c (before insert, before update) {
	
	Set<Id> ids = new Set<Id>();
	for(On_Study_Eligibility_Form__c ose : Trigger.new){
		ids.add(ose.TrialPatient__c);
	}
	List<Site_Trial__c> siteTrials = [Select s.Trial__c, s.Site__c, s.Name From Site_Trial__c s];
	Map<CRF__c, String> crfGroupNameMap = new Map<CRF__c, String>();
	
	List<TrialPatient__c> trialPatientList = [select Id, Site__c, Patient_Id__c,Trial_Id__c from TrialPatient__c where Id IN :ids];
	if(Trigger.isInsert){
		List<CRF__c> lstCRF = new List<CRF__c>();
		for(On_Study_Eligibility_Form__c ose : Trigger.new){
			for(TrialPatient__c tmpListObj : trialPatientList) {
				if(ose.TrialPatient__c == tmpListObj.Id) {
					CRF__c c = new CRF__c();
					c.Patient__c = tmpListObj.Patient_Id__c;
					if(ose.Status__c == null) { 
						c.Status__c = 'Not Completed';
					} else {
						c.Status__c = ose.Status__c;
					}
					if(!trialPatientList.isEmpty()){
						c.Trial__c = trialPatientList[0].Trial_Id__c;
					}
					c.TrialPatient__c = ose.TrialPatient__c;
					c.Complete_Date__c = System.today();
					c.Type__c = 'On_Study_Eligibility_Form__c';
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
		for(On_Study_Eligibility_Form__c ose : Trigger.new){
			for(TrialPatient__c tmpListObj : trialPatientList) {
				for(CRF__c crfObj : lstCRF){
					if(crfObj.Patient__c == tmpListObj.Patient_Id__c){
						if(!RequiredFieldHandler.fromDataLoader) {
							if(ose.How_was_the_cancer_first_detected__c == null || ose.How_was_the_cancer_first_detected__c == '') {
								throw new RequiredFieldException('Required field missing - Please provide How was the cancer first detected?.');
							}
						}
						ose.CRF__c = crfObj.Id;
						if(ose.Status__c == null) {
							ose.Status__c = 'Not Completed';
						}
						ose.Phase__c = 'Screening';	
					}
				}
			}
		}
	}
	if(Trigger.isUpdate){
		set<Id> setCrfIds = new set<Id>();
		Set<String> trialPatients = new Set<String>();
		for(On_Study_Eligibility_Form__c ose : Trigger.new){
			setCrfIds.add(ose.CRF__c);
			trialPatients.add(ose.TrialPatient__c);
		}
		List<CRF__c> lstCrf = [select id,Status__c from CRF__c where id IN : setCrfIds];
		for(On_Study_Eligibility_Form__c ose : Trigger.new){
			for(CRF__c crf : lstCrf){
				if(crf.id == ose.CRF__c && ose.Status__c != Trigger.oldMap.get(ose.id).Status__c){
					crf.Status__c = ose.Status__c;
				}
			}
		}
		if(!lstCrf.isEmpty()){
			update lstCrf;
		}
		
	}
	/*for(On_Study_Eligibility_Form__c ose : Trigger.new){
		ose.How_was_the_cancer_first_detected_Snomed__c = SnomedCTCode.SnomedCode('On_Study_Eligibility_Form__c','How_was_the_cancer_first_detected__c','');
		ose.Cancer_first_detected_val_Snomed__c = SnomedCTCode.SnomedCode('On_Study_Eligibility_Form__c','How_was_the_cancer_first_detected__c',ose.How_was_the_cancer_first_detected__c);
	}*/
	
	/*if(Trigger.isInsert){ 
		List<Snomed_Code__c> lstSnomed = new List<Snomed_Code__c>();
		List<Code_Master__c> lstSnomedMaster = [select id,Name,Variable_Description__c from Code_Master__c where Name = 'Method_Detect' or Name = 'Interval_Cancer'];
		for(On_Study_Eligibility_Form__c ose : Trigger.new){
			for(Code_Master__c sm : lstSnomedMaster){
				if(sm.Name == 'Method_Detect'){
					Snomed_Code__c sc = new Snomed_Code__c();
					sc.CRF__c = ose.CRF__c;
					sc.TrialPatient__c = ose.TrialPatient__c;
					sc.Name = '373573001';
					sc.Code_Master__c = sm.Id;
					SnomedCTCode.SnomedWrapper sw = SnomedCTCode.SnomedCode('373573001', ose.How_was_the_cancer_first_detected__c);
					sc.Value__c = sw.snomedCodeVal;
					sc.Code_System__c = sw.codeSystem;
					sc.caIntegratorValue__c = sw.caIntegratorValue;
					lstSnomed.add(sc);
				}
				if(sm.Name == 'Interval_Cancer' && ose.Status__c == 'Accepted'){
					Snomed_Code__c sc1 = new Snomed_Code__c();
					sc1.CRF__c = ose.CRF__c;
					sc1.TrialPatient__c = ose.TrialPatient__c;
					sc1.Name = 'IHTSDO_4552';
					sc1.Code_Master__c = sm.Id;
					SnomedCTCode.SnomedWrapper sw1 = new SnomedCTCode.SnomedWrapper();
					if(ose.Screening_Memogram_Prior_to_Mass_Detect__c) {
						Integer Interval_Cancer = 0;
						if(ose.Mass_Identification_Date__c > ose.Most_Recent_Date__c) {
							Interval_Cancer = Integer.valueOf(ose.Mass_Identification_Date__c.daysBetween(ose.Most_Recent_Date__c)/365.2425);
						} else {
							Interval_Cancer = Integer.valueOf(ose.Mass_Identification_Date__c.daysBetween(ose.Most_Recent_Date__c)/365.2425);
						}
						
						sw1 = SnomedCTCode.SnomedCode('IHTSDO_4552', (Interval_Cancer > 2?'No':'Yes'));
					} else {
						sw1 = SnomedCTCode.SnomedCode('IHTSDO_4552', 'N/A');
					}
					//SnomedCTCode.SnomedWrapper sw1 = SnomedCTCode.SnomedCode('IHTSDO_4552', (ose.Screening_Memogram_Prior_to_Mass_Detect__c == true?'Yes':'N/A'));
					sc1.Value__c = sw1.snomedCodeVal;
					sc1.Code_System__c = sw1.codeSystem;
					sc1.caIntegratorValue__c = sw1.caIntegratorValue;
					lstSnomed.add(sc1);
				}
			}
		}
		if(!lstSnomed.isEmpty()){
			insert lstSnomed;
		}
	}
	if(Trigger.isUpdate){
		set<Id> crfIds = new set<Id>();
		for(On_Study_Eligibility_Form__c ose : Trigger.new){
			crfIds.add(ose.CRF__c);
		}
		List<Snomed_Code__c> lstSnomed = [select id,CRF__c,Value__c,Name from Snomed_Code__c where CRF__c IN : crfIds];
		for(On_Study_Eligibility_Form__c ose : Trigger.new){
			for(Snomed_Code__c sc : lstSnomed){
				if(sc.CRF__c == ose.CRF__c){
					if(sc.Value__c == '373573001') {
						SnomedCTCode.SnomedWrapper sw = SnomedCTCode.SnomedCode('373573001', ose.How_was_the_cancer_first_detected__c);
						sc.Value__c = sw.snomedCodeVal;
						sc.Code_System__c = sw.codeSystem;
						sc.caIntegratorValue__c = sw.caIntegratorValue;
					}
					if(sc.Value__c == 'IHTSDO_4552' && ose.Status__c == 'Accepted') {
						SnomedCTCode.SnomedWrapper sw1 = new SnomedCTCode.SnomedWrapper();
						if(ose.Screening_Memogram_Prior_to_Mass_Detect__c) {
							Integer Interval_Cancer = 0;
							if(ose.Mass_Identification_Date__c > ose.Most_Recent_Date__c) {
								Interval_Cancer = Integer.valueOf(ose.Mass_Identification_Date__c.daysBetween(ose.Most_Recent_Date__c)/365.2425);
							} else {
								Interval_Cancer = Integer.valueOf(ose.Mass_Identification_Date__c.daysBetween(ose.Most_Recent_Date__c)/365.2425);
							}
							
							sw1 = SnomedCTCode.SnomedCode('IHTSDO_4552', (Interval_Cancer > 2?'No':'Yes'));
						} else {
							sw1 = SnomedCTCode.SnomedCode('IHTSDO_4552', 'N/A');
						}
						//SnomedCTCode.SnomedWrapper sw1 = SnomedCTCode.SnomedCode('IHTSDO_4552', (ose.Screening_Memogram_Prior_to_Mass_Detect__c == true?'Yes':'N/A'));
						sc.Value__c = sw1.snomedCodeVal;
						sc.Code_System__c = sw1.codeSystem;
						sc.caIntegratorValue__c = sw1.caIntegratorValue;
					}
				}
			}
		}
		if(!lstSnomed.isEmpty()){ 
			update lstSnomed;
		}
	}*/
}