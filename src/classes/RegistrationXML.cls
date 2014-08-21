public with sharing class RegistrationXML {
	//public string PatientFieldCheck{get;set;}
	//public string RegistrationFieldCheck{get;set;}
	public boolean IsConfigSaved {get;set;}
	 
	public Boolean firstNmLastNmInitl{get;set;}
	public Boolean RaceEthnicity{get;set;}
	public Boolean SSN{get;set;} 
	public Boolean ISPY2SubjectId{get;set;}
	 
	public RegistrationXML() {
		CRFMaster__c crfmst = [Select c.Id From CRFMaster__c c where c.Object_Name__c ='Registration__c'];
		List<XML_Configuration__c> lstXMLConfig = [select Id, CRF_Type__c, CRF_Type__r.Object_Name__c, Object_API_Name__c, Field_API_Name__c from XML_Configuration__c where Object_API_Name__c IN ('Registration__c','Patient_Custom__c')];
		
		for(XML_Configuration__c xmlConfig : lstXMLConfig) {
			if((xmlConfig.CRF_Type__c == crfmst.Id && xmlConfig.Object_API_Name__c == 'Patient_Custom__c' && xmlConfig.Field_API_Name__c == 'First_Name__c') || (xmlConfig.CRF_Type__c == crfmst.Id && xmlConfig.Object_API_Name__c == 'Patient_Custom__c' && xmlConfig.Field_API_Name__c == 'Last_Name__c')|| (xmlConfig.CRF_Type__c == crfmst.Id && xmlConfig.Object_API_Name__c == 'Patient_Custom__c' && xmlConfig.Field_API_Name__c == 'Initials__c')) {
				firstNmLastNmInitl = true;		
			} else if((xmlConfig.CRF_Type__c == crfmst.Id && xmlConfig.Object_API_Name__c == 'Patient_Custom__c' && xmlConfig.Field_API_Name__c == 'Race__c') || (xmlConfig.CRF_Type__c == crfmst.Id && xmlConfig.Object_API_Name__c == 'Patient_Custom__c' && xmlConfig.Field_API_Name__c == 'Ethnicity__c')) {
				RaceEthnicity = true;
			} else if(xmlConfig.CRF_Type__c == crfmst.Id && xmlConfig.Object_API_Name__c == 'Patient_Custom__c' && xmlConfig.Field_API_Name__c == 'SSN__c') {
				SSN = true;
			} else if(xmlConfig.CRF_Type__c == crfmst.Id && xmlConfig.Object_API_Name__c == 'Registration__c' && xmlConfig.Field_API_Name__c == 'ISPY2_Subject_Id__c') {
				ISPY2SubjectId = true;
			}/*else if(xmlConfig.CRF_Type__c == crfmst.Id && xmlConfig.Object_API_Name__c == 'Patient_Custom__c' && xmlConfig.Field_API_Name__c == 'Country_of_Birth__c') {
				Countryofbirth = true;
			}else if(xmlConfig.CRF_Type__c == crfmst.Id && xmlConfig.Object_API_Name__c == 'Patient_Custom__c' && xmlConfig.Field_API_Name__c == 'Gender__c') {
				Gender = true;
			} else if((xmlConfig.CRF_Type__c == crfmst.Id && xmlConfig.Object_API_Name__c == 'Patient_Custom__c' && xmlConfig.Field_API_Name__c == 'Medical_Record_Number__c') ||(xmlConfig.CRF_Type__c == crfmst.Id && xmlConfig.Object_API_Name__c == 'Patient_Custom__c' && xmlConfig.Field_API_Name__c == 'Institute_Text__c')){
				MRNInstitute = true;
			} else if(xmlConfig.CRF_Type__c == crfmst.Id && xmlConfig.Object_API_Name__c == 'Patient_Custom__c' && xmlConfig.Field_API_Name__c == 'Zip__c') {
				Zip = true;
			} else if(xmlConfig.CRF_Type__c == crfmst.Id && xmlConfig.Object_API_Name__c == 'Registration__c' && xmlConfig.Field_API_Name__c == 'Registration_Date__c') {
				RegistrationDate = true;
			} else if(xmlConfig.CRF_Type__c == crfmst.Id && xmlConfig.Object_API_Name__c == 'Registration__c' && xmlConfig.Field_API_Name__c == 'CreatedById') {
				StudyCoordinator = true;
			} else if(xmlConfig.CRF_Type__c == crfmst.Id && xmlConfig.Object_API_Name__c == 'Registration__c' && xmlConfig.Field_API_Name__c == 'ACRIN_6693_MRS_Participant__c') {
				ACRIN6698RepeatScanConsent = true;
			} else if(xmlConfig.CRF_Type__c == crfmst.Id && xmlConfig.Object_API_Name__c == 'Registration__c' && xmlConfig.Field_API_Name__c == 'Oncologist__c') {
				Oncologist = true;
			} else if(xmlConfig.CRF_Type__c == crfmst.Id && xmlConfig.Object_API_Name__c == 'Registration__c' && xmlConfig.Field_API_Name__c == 'Surgeon__c') {
				Surgeon = true;
			} else if(xmlConfig.CRF_Type__c == crfmst.Id && xmlConfig.Object_API_Name__c == 'Registration__c' && xmlConfig.Field_API_Name__c == 'Clinical_Coordinator__c') {
				ClinicalCoordinator = true;
			} else if(xmlConfig.CRF_Type__c == crfmst.Id && xmlConfig.Object_API_Name__c == 'Registration__c' && xmlConfig.Field_API_Name__c == 'Radiology_Coordinator__c') {
				RadiologyCoordinator = true;
			} else if(xmlConfig.CRF_Type__c == crfmst.Id && xmlConfig.Object_API_Name__c == 'Registration__c' && xmlConfig.Field_API_Name__c == 'IRB_Approval_Date__c') {
				IRBApprovalDate = true;
			} else if(xmlConfig.CRF_Type__c == crfmst.Id && xmlConfig.Object_API_Name__c == 'Registration__c' && xmlConfig.Field_API_Name__c == 'Screening_Informed_Consent_Date__c') {
				ScreeningInformedConsentDate = true;
			} else if(xmlConfig.CRF_Type__c == crfmst.Id && xmlConfig.Object_API_Name__c == 'Registration__c' && xmlConfig.Field_API_Name__c == 'HIPPA_Consent_Date__c') {
				HIPPAConsentDate = true;
			}*/
		}	
	}	
	
	public void saveConfiguration() {
		CRFMaster__c crfmst = [Select c.Id From CRFMaster__c c where c.Object_Name__c ='Registration__c'];
		delete [select Id from XML_Configuration__c where Object_API_Name__c IN ('Registration__c','Patient_Custom__c')];
		List<XML_Configuration__c> xmlList = new List<XML_Configuration__c>();
		
		if(firstNmLastNmInitl) {
			xmlList.add(new XML_Configuration__c(CRF_Type__c = crfmst.Id, Object_API_Name__c = 'Patient_Custom__c', Field_API_Name__c = 'First_Name__c'));
			xmlList.add(new XML_Configuration__c(CRF_Type__c = crfmst.Id, Object_API_Name__c = 'Patient_Custom__c', Field_API_Name__c = 'Last_Name__c'));
			xmlList.add(new XML_Configuration__c(CRF_Type__c = crfmst.Id, Object_API_Name__c = 'Patient_Custom__c', Field_API_Name__c = 'Initials__c'));
		}
		if(RaceEthnicity) {
			xmlList.add(new XML_Configuration__c(CRF_Type__c = crfmst.Id, Object_API_Name__c = 'Patient_Custom__c', Field_API_Name__c = 'Race__c'));
			xmlList.add(new XML_Configuration__c(CRF_Type__c = crfmst.Id, Object_API_Name__c = 'Patient_Custom__c', Field_API_Name__c = 'Ethnicity__c'));
		}
		if(SSN){
			xmlList.add(new XML_Configuration__c(CRF_Type__c = crfmst.Id, Object_API_Name__c = 'Patient_Custom__c', Field_API_Name__c = 'SSN__c'));
		}
		if(ISPY2SubjectId) {
			xmlList.add(new XML_Configuration__c(CRF_Type__c = crfmst.Id, Object_API_Name__c = 'Registration__c', Field_API_Name__c = 'ISPY2_Subject_Id__c'));
		}
		/*if(Gender) {
			xmlList.add(new XML_Configuration__c(CRF_Type__c = crfmst.Id, Object_API_Name__c = 'Patient_Custom__c', Field_API_Name__c = 'Gender__c'));
		}
		if(Countryofbirth) {
			xmlList.add(new XML_Configuration__c(CRF_Type__c = crfmst.Id, Object_API_Name__c = 'Patient_Custom__c', Field_API_Name__c = 'Country_of_Birth__c'));
		}
		if(MRNInstitute) {
			xmlList.add(new XML_Configuration__c(CRF_Type__c = crfmst.Id, Object_API_Name__c = 'Patient_Custom__c', Field_API_Name__c = 'Medical_Record_Number__c'));
			xmlList.add(new XML_Configuration__c(CRF_Type__c = crfmst.Id, Object_API_Name__c = 'Patient_Custom__c', Field_API_Name__c = 'Institute_Text__c'));
		}
		if(Zip) {
			xmlList.add(new XML_Configuration__c(CRF_Type__c = crfmst.Id, Object_API_Name__c = 'Patient_Custom__c', Field_API_Name__c = 'Zip__c'));
		}
		if(RegistrationDate) {
			xmlList.add(new XML_Configuration__c(CRF_Type__c = crfmst.Id, Object_API_Name__c = 'Registration__c', Field_API_Name__c = 'Registration_Date__c'));
		}
		if(StudyCoordinator) {
			xmlList.add(new XML_Configuration__c(CRF_Type__c = crfmst.Id, Object_API_Name__c = 'Registration__c', Field_API_Name__c = 'CreatedById'));
		}
		if(ACRIN6698RepeatScanConsent){
			xmlList.add(new XML_Configuration__c(CRF_Type__c = crfmst.Id, Object_API_Name__c = 'Registration__c', Field_API_Name__c = 'ACRIN_6693_MRS_Participant__c'));
		}
		if(Oncologist) {
			xmlList.add(new XML_Configuration__c(CRF_Type__c = crfmst.Id, Object_API_Name__c = 'Registration__c', Field_API_Name__c = 'Oncologist__c'));
		}
		if(Surgeon) {
			xmlList.add(new XML_Configuration__c(CRF_Type__c = crfmst.Id, Object_API_Name__c = 'Registration__c', Field_API_Name__c = 'Surgeon__c'));
		}
		if(ClinicalCoordinator) {
			xmlList.add(new XML_Configuration__c(CRF_Type__c = crfmst.Id, Object_API_Name__c = 'Registration__c', Field_API_Name__c = 'Clinical_Coordinator__c'));
		}
		if(RadiologyCoordinator) {
			xmlList.add(new XML_Configuration__c(CRF_Type__c = crfmst.Id, Object_API_Name__c = 'Registration__c', Field_API_Name__c = 'Radiology_Coordinator__c'));
		}
		if(IRBApprovalDate) {																										 
			xmlList.add(new XML_Configuration__c(CRF_Type__c = crfmst.Id, Object_API_Name__c = 'Registration__c', Field_API_Name__c = 'IRB_Approval_Date__c'));
		}
		if(ScreeningInformedConsentDate) {
			xmlList.add(new XML_Configuration__c(CRF_Type__c = crfmst.Id, Object_API_Name__c = 'Registration__c', Field_API_Name__c = 'Screening_Informed_Consent_Date__c'));
		}
		if(HIPPAConsentDate) {																											
			xmlList.add(new XML_Configuration__c(CRF_Type__c = crfmst.Id, Object_API_Name__c = 'Registration__c', Field_API_Name__c = 'HIPPA_Consent_Date__c'));
		}*/
		
		try {
			insert xmlList;
			IsConfigSaved = true;
		} catch(Exception e) {
			IsConfigSaved = false;
		}
	}
}