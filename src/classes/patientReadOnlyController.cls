public with sharing class patientReadOnlyController {
    
    private String trialPatientId{get;set;}
    private String patientId{get;set;}
    public Patient_Custom__c patientObj{set;}
    public String subjectId {get;set;}
    
    private String patientIdAttribute {get;set;}
    
    public void setpatientIdAttribute (String s) {
        patientIdAttribute = s;
    }
    public String getpatientIdAttribute() {
        return patientIdAttribute;
    } 
    
    public patientReadOnlyController(apexPages.standardController std){
    } 
    
    public Patient_Custom__c getPatientObj() {
        System.debug('patientIdAttribute-----------'+patientIdAttribute);
        if(patientIdAttribute == null || patientIdAttribute == '') {
            patientId = Apexpages.currentPage().getParameters().get('PatientId');
            //system.assert(false,patientId);
        } else {
            patientId = patientIdAttribute; 
        }
        
        trialPatientId = Apexpages.currentPage().getParameters().get('trialPat');
        //system.assert(false,trialPatientId);
        List<Patient_Custom__c> lstPatient = new List<Patient_Custom__c>();
        subjectId = '';
        
        if(patientId != null) {
            lstPatient = [Select p.Zip__c, Middle_Name__c, Suffix__c, Initials__c, VIP__c, p.SystemModstamp, p.Surgeon__r.Name, p.Surgeon__c, p.Study_Registration_Eligibility__c, p.Status__c, p.State__c, p.Signed_Screening__c, p.Screen_Failure_Number__c, p.SSN__c, p.RecordTypeId, p.Race__c, p.Primary_MD__r.Name, p.Primary_MD__c, p.Owner.Name, p.OwnerId, p.Name, p.Medical_Record_Number__c, p.Last_Name__c, p.LastModifiedDate, p.LastModifiedBy.Name, p.LastModifiedById, p.LastActivityDate, p.IsDeleted, p.Institution__c, p.Institute_Text__c, p.Id, p.Gender__c, p.First_Name__c, p.Ethnicity__c, p.CreatedDate, p.CreatedBy.Name, p.CreatedById, p.Country_of_Birth__c, p.Country__c, p.City__c, p.Birthdate__c, p.Age__c, p.Address_Line_2__c, p.Address_Line_1__c, RecordType.Name From Patient_Custom__c p where Id = :patientId];
            if(!lstPatient.isEmpty()) {
                List<TrialPatient__c> trialPatList = [select Patient_Id__c, Subject_Id__c from TrialPatient__c where Patient_Id__c =:patientId];
                if(!trialPatList.isEmpty()) {
                    subjectId = trialPatList[0].Subject_Id__c;
                }
            }
        } else if(trialPatientId != null) {
            List<TrialPatient__c> trialPatList = [select Patient_Id__c, Subject_Id__c from TrialPatient__c where Id =:trialPatientId];
            if(!trialPatList.isEmpty()) {
                subjectId = trialPatList[0].Subject_Id__c;
                lstPatient = [Select p.Zip__c, Middle_Name__c, Suffix__c, Initials__c, VIP__c, p.SystemModstamp, p.Surgeon__r.Name, p.Surgeon__c, p.Study_Registration_Eligibility__c, p.Status__c, p.State__c, p.Signed_Screening__c, p.Screen_Failure_Number__c, p.SSN__c, p.RecordTypeId, p.Race__c, p.Primary_MD__r.Name, p.Primary_MD__c, p.Owner.Name, p.OwnerId, p.Name, p.Medical_Record_Number__c, p.Last_Name__c, p.LastModifiedDate, p.LastModifiedBy.Name, p.LastModifiedById, p.LastActivityDate, p.IsDeleted, p.Institution__c, p.Institute_Text__c, p.Id, p.Gender__c, p.First_Name__c, p.Ethnicity__c, p.CreatedDate, p.CreatedBy.Name, p.CreatedById, p.Country_of_Birth__c, p.Country__c, p.City__c, p.Birthdate__c, p.Age__c, p.Address_Line_2__c, p.Address_Line_1__c, RecordType.Name From Patient_Custom__c p where Id = :trialPatList[0].Patient_Id__c];
            }
        }
        Patient_Custom__c Patient = null;
        if(!lstPatient.isEmpty()) {
            Patient = lstPatient[0];
        }
        return Patient;
    }
    
    public patientReadOnlyController() {
        
    }
}