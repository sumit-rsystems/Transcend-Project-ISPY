public with sharing class AdverseEventXML extends PageControllerBase {
	
	public boolean visitDate {get;set;}
	public boolean patientHospitalized {get;set;}
	public boolean caAERSReportFiled {get;set;}
	
	public boolean BaseSymptoms {get;set;}
	public boolean BaseEvent {get;set;} //Toxicity
	public boolean BaseGrade {get;set;}    
	public boolean BaseAttribution {get;set;} 
	public boolean BaseSymptomStatus {get;set;}
	public boolean BaseWasEventLifeThreatning {get;set;}
	public boolean BaseToxicityStatus {get;set;}
	public boolean BaseResultDefect {get;set;}
	public boolean BaseResolved {get;set;}
	public boolean BasePatientComplaint {get;set;}
	public boolean BaseDidTheInvestigatorFindEventUnusual {get;set;}
	public boolean BaseDidEventResultInDeath {get;set;}
	public boolean BaseDidEventRequiredHospitalization {get;set;}
	public boolean BaseSAE {get;set;}
	public boolean BaseOnsetDate {get;set;}  
	public boolean BaseEndDate {get;set;}
	
	public boolean AESymptoms {get;set;}
	public boolean AEEvent {get;set;} //Toxicity
	public boolean AEGrade {get;set;}    
	public boolean AEAttribution {get;set;} 
	public boolean AESymptomStatus {get;set;}
	public boolean AEWasEventLifeThreatning {get;set;}
	public boolean AEToxicityStatus {get;set;}
	public boolean AEResultDefect {get;set;}
	public boolean AEResolved {get;set;}
	public boolean AEPatientComplaint {get;set;}
	public boolean AEDidTheInvestigatorFindEventUnusual {get;set;}
	public boolean AEDidEventResultInDeath {get;set;}
	public boolean AEDidEventRequiredHospitalization {get;set;}
	public boolean AESAE {get;set;}
	public boolean AEOnsetDate {get;set;}  
	public boolean AEEndDate {get;set;}
	
	public String currentTab {get;set;}
	public String password {get;set;}
	public String errorMsg {get;set;}
	public AE_Detail__c AEObj {get;set;}
	public List<AE_Detail__c> AEList {get;set;}
	public String rId {get;set;}
	public Date LastVisitDate {get;set;}
	public List<BaselineSymptomsForm__c> baselineList {get;set;}
	public List<Allergy__c> allergyList {get;set;}
	public List<BaselineCondition__c> baselineConditionList {get;set;}
	public List<wrapCondition> wrapConditionList {get;set;}
	public List<wrapToxicity> wrapBaselineToxicityList{get;set;}
	public List<wrapToxicity> wrapAEToxicityList{get;set;}
	public Boolean isAllergyShow {get;set;}
	public Boolean isBaselineSymptomShow {get;set;}
	public Boolean isPriorAEShow {get;set;}
	public Boolean isbaselineConditionShow {get;set;}
	public String treatmentArmId{get;set;}
	public String treatmentArmName{get;set;}
	public Boolean isCurrentAEShow {get;set;}
	public List<Toxicity__c> toxicityDisplayList{get;set;}
	public boolean openInEditMode {get;set;}   
	public integer conditionSNo = 0;
	public Boolean isComplete{get;set;}
	public String nextTabName{get;set;}
	private String TrialPatientId{get;set;}
	public String AdverseEventId{get;set;}
	public boolean IsConfigSaved {get;set;}
	public AdverseEventXML() {
		CRFMaster__c aeCrfMaster = [Select c.Id From CRFMaster__c c where c.Object_Name__c ='AE_Detail__c'];
		CRFMaster__c baselineCrfMaster = [Select c.Id From CRFMaster__c c where c.Object_Name__c ='BaselineSymptomsForm__c'];
		
		List<XML_Configuration__c> lstXMLConfig = [select Id, CRF_Type__c, CRF_Type__r.Object_Name__c, Object_API_Name__c, Field_API_Name__c  from XML_Configuration__c where Object_API_Name__c IN ('AE_Detail__c','BaselineSymptomsForm__c','Toxicity__c')];
		for(XML_Configuration__c xmlConfig : lstXMLConfig) {
			if(xmlConfig.Field_API_Name__c == 'Visit_Date__c') {
				visitDate = true;
			} else if(xmlConfig.Field_API_Name__c == 'Patient_Hospitalized__c') {
				patientHospitalized = true;
			} else if (xmlConfig.Field_API_Name__c == 'caAERS_report_filed__c') {
				caAERSReportFiled = true;
			} else if (xmlConfig.CRF_Type__r.Object_Name__c == 'BaselineSymptomsForm__c' && xmlConfig.Field_API_Name__c == 'Symptom_Masters__c') {
				BaseSymptoms = true;
			} else if (xmlConfig.CRF_Type__r.Object_Name__c == 'BaselineSymptomsForm__c' && xmlConfig.Field_API_Name__c == 'Name,Toxicity_Other__c') {
				BaseEvent = true;
			} else if (xmlConfig.CRF_Type__r.Object_Name__c == 'BaselineSymptomsForm__c' && xmlConfig.Field_API_Name__c == 'Grade__c') {
				BaseGrade = true;
			} else if (xmlConfig.CRF_Type__r.Object_Name__c == 'BaselineSymptomsForm__c' && xmlConfig.Field_API_Name__c == 'Attribution__c') {
				BaseAttribution = true;
			} else if (xmlConfig.CRF_Type__r.Object_Name__c == 'BaselineSymptomsForm__c' && xmlConfig.Field_API_Name__c == 'Symptom_Status__c') {
				BaseSymptomStatus = true;
			} else if (xmlConfig.CRF_Type__r.Object_Name__c == 'BaselineSymptomsForm__c' && xmlConfig.Field_API_Name__c == 'Was_event_life_threatning__c') {
				BaseWasEventLifeThreatning = true;
			} else if (xmlConfig.CRF_Type__r.Object_Name__c == 'BaselineSymptomsForm__c' && xmlConfig.Field_API_Name__c == 'Toxicity_Status__c') {
				BaseToxicityStatus = true;
			} else if (xmlConfig.CRF_Type__r.Object_Name__c == 'BaselineSymptomsForm__c' && xmlConfig.Field_API_Name__c == 'Result_conginental_abnormality_defect__c') {
				BaseResultDefect = true;
			} else if (xmlConfig.CRF_Type__r.Object_Name__c == 'BaselineSymptomsForm__c' && xmlConfig.Field_API_Name__c == 'Resolved__c') {
				BaseResolved = true;
			} else if (xmlConfig.CRF_Type__r.Object_Name__c == 'BaselineSymptomsForm__c' && xmlConfig.Field_API_Name__c == 'Patient_Complaint__c') {
				BasePatientComplaint = true;
			} else if (xmlConfig.CRF_Type__r.Object_Name__c == 'BaselineSymptomsForm__c' && xmlConfig.Field_API_Name__c == 'Did_the_investigator_find_event_unusual__c') {
				BaseDidTheInvestigatorFindEventUnusual = true;
			} else if (xmlConfig.CRF_Type__r.Object_Name__c == 'BaselineSymptomsForm__c' && xmlConfig.Field_API_Name__c == 'Did_event_result_in_death__c') {
				BaseDidEventResultInDeath = true;
			} else if (xmlConfig.CRF_Type__r.Object_Name__c == 'BaselineSymptomsForm__c' && xmlConfig.Field_API_Name__c == 'Did_event_required_hospitalization__c') {
				BaseDidEventRequiredHospitalization = true;
			} else if (xmlConfig.CRF_Type__r.Object_Name__c == 'BaselineSymptomsForm__c' && xmlConfig.Field_API_Name__c == 'SAE__c') {
				BaseSAE = true;
			} else if (xmlConfig.CRF_Type__r.Object_Name__c == 'BaselineSymptomsForm__c' && xmlConfig.Field_API_Name__c == 'Onset_Date__c') {
				BaseOnsetDate = true;
			} else if (xmlConfig.CRF_Type__r.Object_Name__c == 'BaselineSymptomsForm__c' && xmlConfig.Field_API_Name__c == 'AE_End_Date__c') {
				BaseEndDate = true;
			} else if (xmlConfig.CRF_Type__r.Object_Name__c == 'AE_Detail__c' && xmlConfig.Field_API_Name__c == 'Symptom_Masters__c') {
				AESymptoms = true;
			} else if (xmlConfig.CRF_Type__r.Object_Name__c == 'AE_Detail__c' && xmlConfig.Field_API_Name__c == 'Name,Toxicity_Other__c') {
				AEEvent = true;
			} else if (xmlConfig.CRF_Type__r.Object_Name__c == 'AE_Detail__c' && xmlConfig.Field_API_Name__c == 'Grade__c') {
				AEGrade = true;
			} else if (xmlConfig.CRF_Type__r.Object_Name__c == 'AE_Detail__c' && xmlConfig.Field_API_Name__c == 'Attribution__c') {
				AEAttribution = true;
			} else if (xmlConfig.CRF_Type__r.Object_Name__c == 'AE_Detail__c' && xmlConfig.Field_API_Name__c == 'Symptom_Status__c') {
				AESymptomStatus = true;
			} else if (xmlConfig.CRF_Type__r.Object_Name__c == 'AE_Detail__c' && xmlConfig.Field_API_Name__c == 'Was_event_life_threatning__c') {
				AEWasEventLifeThreatning = true;
			} else if (xmlConfig.CRF_Type__r.Object_Name__c == 'AE_Detail__c' && xmlConfig.Field_API_Name__c == 'Toxicity_Status__c') {
				AEToxicityStatus = true;
			} else if (xmlConfig.CRF_Type__r.Object_Name__c == 'AE_Detail__c' && xmlConfig.Field_API_Name__c == 'Result_conginental_abnormality_defect__c') {
				AEResultDefect = true;
			} else if (xmlConfig.CRF_Type__r.Object_Name__c == 'AE_Detail__c' && xmlConfig.Field_API_Name__c == 'Resolved__c') {
				AEResolved = true;
			} else if (xmlConfig.CRF_Type__r.Object_Name__c == 'AE_Detail__c' && xmlConfig.Field_API_Name__c == 'Patient_Complaint__c') {
				AEPatientComplaint = true;
			} else if (xmlConfig.CRF_Type__r.Object_Name__c == 'AE_Detail__c' && xmlConfig.Field_API_Name__c == 'Did_the_investigator_find_event_unusual__c') {
				AEDidTheInvestigatorFindEventUnusual = true;
			} else if (xmlConfig.CRF_Type__r.Object_Name__c == 'AE_Detail__c' && xmlConfig.Field_API_Name__c == 'Did_event_result_in_death__c') {
				AEDidEventResultInDeath = true;
			} else if (xmlConfig.CRF_Type__r.Object_Name__c == 'AE_Detail__c' && xmlConfig.Field_API_Name__c == 'Did_event_required_hospitalization__c') {
				AEDidEventRequiredHospitalization = true;
			} else if (xmlConfig.CRF_Type__r.Object_Name__c == 'AE_Detail__c' && xmlConfig.Field_API_Name__c == 'SAE__c') {
				AESAE = true;
			} else if (xmlConfig.CRF_Type__r.Object_Name__c == 'AE_Detail__c' && xmlConfig.Field_API_Name__c == 'Onset_Date__c') {
				AEOnsetDate = true;
			} else if (xmlConfig.CRF_Type__r.Object_Name__c == 'AE_Detail__c' && xmlConfig.Field_API_Name__c == 'AE_End_Date__c') {
				AEEndDate = true;
			}
		}
	}
	public void saveConfiguration(){
		
		CRFMaster__c aeCrfMaster = [Select c.Id From CRFMaster__c c where c.Object_Name__c ='AE_Detail__c'];
		CRFMaster__c baselineCrfMaster = [Select c.Id From CRFMaster__c c where c.Object_Name__c ='BaselineSymptomsForm__c'];
		
		delete [select Id from XML_Configuration__c where Object_API_Name__c IN ('AE_Detail__c','BaselineSymptomsForm__c','Toxicity__c')];
		
		List<XML_Configuration__c> xmlList = new List<XML_Configuration__c>();
		
		if(visitDate) {
			xmlList.add(new XML_Configuration__c(CRF_Type__c = aeCrfMaster.Id, Object_API_Name__c = 'AE_Detail__c', Field_API_Name__c = 'Visit_Date__c'));
		}
		
		if(patientHospitalized) {
			xmlList.add(new XML_Configuration__c(CRF_Type__c = aeCrfMaster.Id, Object_API_Name__c = 'AE_Detail__c', Field_API_Name__c = 'Patient_Hospitalized__c'));
		}
		
		if(caAERSReportFiled) {
			xmlList.add(new XML_Configuration__c(CRF_Type__c = aeCrfMaster.Id, Object_API_Name__c = 'AE_Detail__c', Field_API_Name__c = 'caAERS_report_filed__c'));
		}
		
		if(BaseSymptoms) {
			xmlList.add(new XML_Configuration__c(CRF_Type__c = baselineCrfMaster.Id, Object_API_Name__c = 'Toxicity__c', Field_API_Name__c = 'Symptom_Masters__c'));
		}
		
		if(BaseEvent) {
			xmlList.add(new XML_Configuration__c(CRF_Type__c = baselineCrfMaster.Id, Object_API_Name__c = 'Toxicity__c', Field_API_Name__c = 'Name,Toxicity_Other__c'));
		}
		
		if(BaseGrade) {
			xmlList.add(new XML_Configuration__c(CRF_Type__c = baselineCrfMaster.Id, Object_API_Name__c = 'Toxicity__c', Field_API_Name__c = 'Grade__c'));
		}
		
		if(BaseAttribution) {
			xmlList.add(new XML_Configuration__c(CRF_Type__c = baselineCrfMaster.Id, Object_API_Name__c = 'Toxicity__c', Field_API_Name__c = 'Attribution__c'));
		}
		
		if(BaseSymptomStatus) {
			xmlList.add(new XML_Configuration__c(CRF_Type__c = baselineCrfMaster.Id, Object_API_Name__c = 'Toxicity__c', Field_API_Name__c = 'Symptom_Status__c'));
		}
		
		if(BaseWasEventLifeThreatning) {
			xmlList.add(new XML_Configuration__c(CRF_Type__c = baselineCrfMaster.Id, Object_API_Name__c = 'Toxicity__c', Field_API_Name__c = 'Was_event_life_threatning__c'));
		}
		
		if(BaseToxicityStatus) {
			xmlList.add(new XML_Configuration__c(CRF_Type__c = baselineCrfMaster.Id, Object_API_Name__c = 'Toxicity__c', Field_API_Name__c = 'Toxicity_Status__c'));
		}
		
		if(BaseResultDefect) {
			xmlList.add(new XML_Configuration__c(CRF_Type__c = baselineCrfMaster.Id, Object_API_Name__c = 'Toxicity__c', Field_API_Name__c = 'Result_conginental_abnormality_defect__c'));
		}
		
		if(BaseResolved) {
			xmlList.add(new XML_Configuration__c(CRF_Type__c = baselineCrfMaster.Id, Object_API_Name__c = 'Toxicity__c', Field_API_Name__c = 'Resolved__c'));
		}
		
		if(BasePatientComplaint) {
			xmlList.add(new XML_Configuration__c(CRF_Type__c = baselineCrfMaster.Id, Object_API_Name__c = 'Toxicity__c', Field_API_Name__c = 'Patient_Complaint__c'));
		}
		
		if(BaseDidTheInvestigatorFindEventUnusual) {
			xmlList.add(new XML_Configuration__c(CRF_Type__c = baselineCrfMaster.Id, Object_API_Name__c = 'Toxicity__c', Field_API_Name__c = 'Did_the_investigator_find_event_unusual__c'));
		}
		
		if(BaseDidEventResultInDeath) {
			xmlList.add(new XML_Configuration__c(CRF_Type__c = baselineCrfMaster.Id, Object_API_Name__c = 'Toxicity__c', Field_API_Name__c = 'Did_event_result_in_death__c'));
		}
		
		if(BaseDidEventRequiredHospitalization) {
			xmlList.add(new XML_Configuration__c(CRF_Type__c = baselineCrfMaster.Id, Object_API_Name__c = 'Toxicity__c', Field_API_Name__c = 'Did_event_required_hospitalization__c'));
		}
		
		if(BaseSAE) {
			xmlList.add(new XML_Configuration__c(CRF_Type__c = baselineCrfMaster.Id, Object_API_Name__c = 'Toxicity__c', Field_API_Name__c = 'SAE__c'));
		}
		
		if(BaseOnsetDate) {
			xmlList.add(new XML_Configuration__c(CRF_Type__c = baselineCrfMaster.Id, Object_API_Name__c = 'Toxicity__c', Field_API_Name__c = 'Onset_Date__c'));
		}
		
		if(BaseEndDate) {
			xmlList.add(new XML_Configuration__c(CRF_Type__c = baselineCrfMaster.Id, Object_API_Name__c = 'Toxicity__c', Field_API_Name__c = 'AE_End_Date__c'));
		}
		
		if(AESymptoms) {
			xmlList.add(new XML_Configuration__c(CRF_Type__c = aeCrfMaster.Id, Object_API_Name__c = 'Toxicity__c', Field_API_Name__c = 'Symptom_Masters__c'));
		}
		
		if(AEEvent) {
			xmlList.add(new XML_Configuration__c(CRF_Type__c = aeCrfMaster.Id, Object_API_Name__c = 'Toxicity__c', Field_API_Name__c = 'Name,Toxicity_Other__c'));
		}
		
		if(AEGrade) {
			xmlList.add(new XML_Configuration__c(CRF_Type__c = aeCrfMaster.Id, Object_API_Name__c = 'Toxicity__c', Field_API_Name__c = 'Grade__c'));
		}
		
		if(AEAttribution) {
			xmlList.add(new XML_Configuration__c(CRF_Type__c = aeCrfMaster.Id, Object_API_Name__c = 'Toxicity__c', Field_API_Name__c = 'Attribution__c'));
		}
		
		if(AESymptomStatus) {
			xmlList.add(new XML_Configuration__c(CRF_Type__c = aeCrfMaster.Id, Object_API_Name__c = 'Toxicity__c', Field_API_Name__c = 'Symptom_Status__c'));
		}
		
		if(AEWasEventLifeThreatning) {
			xmlList.add(new XML_Configuration__c(CRF_Type__c = aeCrfMaster.Id, Object_API_Name__c = 'Toxicity__c', Field_API_Name__c = 'Was_event_life_threatning__c'));
		}
		
		if(AEToxicityStatus) {
			xmlList.add(new XML_Configuration__c(CRF_Type__c = aeCrfMaster.Id, Object_API_Name__c = 'Toxicity__c', Field_API_Name__c = 'Toxicity_Status__c'));
		}
		
		if(AEResultDefect) {
			xmlList.add(new XML_Configuration__c(CRF_Type__c = aeCrfMaster.Id, Object_API_Name__c = 'Toxicity__c', Field_API_Name__c = 'Result_conginental_abnormality_defect__c'));
		}
		
		if(AEResolved) {
			xmlList.add(new XML_Configuration__c(CRF_Type__c = aeCrfMaster.Id, Object_API_Name__c = 'Toxicity__c', Field_API_Name__c = 'Resolved__c'));
		}
		
		if(AEPatientComplaint) {
			xmlList.add(new XML_Configuration__c(CRF_Type__c = aeCrfMaster.Id, Object_API_Name__c = 'Toxicity__c', Field_API_Name__c = 'Patient_Complaint__c'));
		}
		
		if(AEDidTheInvestigatorFindEventUnusual) {
			xmlList.add(new XML_Configuration__c(CRF_Type__c = aeCrfMaster.Id, Object_API_Name__c = 'Toxicity__c', Field_API_Name__c = 'Did_the_investigator_find_event_unusual__c'));
		}
		
		if(AEDidEventResultInDeath) {
			xmlList.add(new XML_Configuration__c(CRF_Type__c = aeCrfMaster.Id, Object_API_Name__c = 'Toxicity__c', Field_API_Name__c = 'Did_event_result_in_death__c'));
		}
		
		if(AEDidEventRequiredHospitalization) {
			xmlList.add(new XML_Configuration__c(CRF_Type__c = aeCrfMaster.Id, Object_API_Name__c = 'Toxicity__c', Field_API_Name__c = 'Did_event_required_hospitalization__c'));
		}
		
		if(AESAE) {
			xmlList.add(new XML_Configuration__c(CRF_Type__c = aeCrfMaster.Id, Object_API_Name__c = 'Toxicity__c', Field_API_Name__c = 'SAE__c'));
		}
		
		if(AEOnsetDate) {
			xmlList.add(new XML_Configuration__c(CRF_Type__c = aeCrfMaster.Id, Object_API_Name__c = 'Toxicity__c', Field_API_Name__c = 'Onset_Date__c'));
		}
		
		if(AEEndDate) {
			xmlList.add(new XML_Configuration__c(CRF_Type__c = aeCrfMaster.Id, Object_API_Name__c = 'Toxicity__c', Field_API_Name__c = 'AE_End_Date__c'));
		}
		
		try {
			insert xmlList;
			IsConfigSaved = true;
		} catch(Exception e) {
			IsConfigSaved = false;
		}
		
		/*if(BaselineFields != null && BaselineFields != '' ){
			List<String> str = BaselineFields.split('\\,');
			for(String st : str){
				if(st != ''){
					XML_Configuration__c xc = new XML_Configuration__c();
					xc.CRF_Type__c = baselineCrfMaster.Id;
					xc.Object_API_Name__c = 'Toxicity__c';
					xc.Field_API_Name__c = st;
					xmlList.add(xc);
					system.debug('====xmlList'+xmlList);
				}
			}
		}
		if(AeFields != null && AeFields != '' ){ 	
			List<String> str = AeFields.split('\\,');
			for(String st : str){
				if(st != ''){
					XML_Configuration__c xc = new XML_Configuration__c();
					xc.CRF_Type__c = aeCrfMaster.Id;
					if(st == 'Visit_Date__c'){
						xc.Object_API_Name__c = 'AE_Detail__c';
					} else {
						xc.Object_API_Name__c = 'Toxicity__c';
					}
					xc.Field_API_Name__c = st;
					xmlList.add(xc);
					system.debug('====xmlList'+xmlList);
				}	
			}
		}
		try {
			insert xmlList;
			IsConfigSaved = true;
		} catch(Exception e) {
			IsConfigSaved = false;
		}
		
		system.debug('====xmlList'+xmlList);*/	
	}
	
	public void editCRF() {
		
		
	}
	public class wrapCondition {
		public BaselineCondition__c baselineConditionObj {get;set;}
		public Boolean isReadOnly {get;set;}
		public Boolean isEditOnly {get;set;}
		public String conditionNumber {get;set;}
		public wrapCondition() {
			isReadOnly = false;
			isEditOnly = false;
		}
	}

//=======================wrapper class for Toxicity============================================================	
	public class wrapToxicity {
		public Toxicity__c ToxicityObj {get;set;}
		public boolean isBaseline{get;set;}
		public boolean isAE{get;set;}
		public Boolean isReadOnly {get;set;}
		public Boolean isEditOnly {get;set;}
		public wrapToxicity() {
			isReadOnly = false;
			isEditOnly = false;
			isBaseline = false;
			isAE = false;
		}
	}
	private  class RegistrationXML {    
	}
}