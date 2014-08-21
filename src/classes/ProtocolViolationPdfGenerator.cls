public with sharing class ProtocolViolationPdfGenerator {
    public ProtocolViolationDetail__c protocolViolation {get;set;}
    //public List<CoreBiopsyWrapper> lstCoreBiopsyWrapper {get;set;}
    public TrialPatient__c trialPatientObj {get;set;}
    public Patient_Custom__c Patient {get;set;}
    public string initials {get;set;}

   
    public ProtocolViolationPdfGenerator(Apexpages.StandardController std) {
        string protocolViolationId  = ApexPages.currentPage().getParameters().get('Id');
        //lstCoreBiopsyWrapper = new List<CoreBiopsyWrapper>();
        protocolViolation = new ProtocolViolationDetail__c ();
        if(protocolViolationId != null)
        protocolViolation = [Select Status__c, Visit_non_complicance__c,CRFId__c, TrialPatient__c, Screening_procedure_required__c, Screening_and_on_study_test_lab_done__c, Phase__c, Patient_withdrawn__c, Patient_became_pregnant_prior_to_surgery__c, Patient__c, Patient_Remains_on_Study__c, Other_Violation_Checkbox__c, Other_Type_of_Violation__c, Other_Action__c, Other_Action_Checkbox__c, On_study_procedure_required_by_protocol__c, Narrative_description__c, Medication_non_complicance__c, Local_IRB_Notified__c, Incorrect_therapy_given_to_patient__c, Enrollment_of_ineligeligibleible_patient__c, Eligibility_criteria_exception__c, DateOfProtocolViolation__c, CompletedDate__c From ProtocolViolationDetail__c p where Id = :protocolViolationId];      
        // system.assert(false,Off_Study_Detail__c.status__c);
        // List<Core_Biopsy_Specimens__c>  tmpCoreBiopsyList = new  List<Core_Biopsy_Specimens__c> ();
        // tmpCoreBiopsyList = [Select TissueSpecimenDetail__c, SpecimenID__c, Shipped__c, Reason_samples_not_shipped__c, Other_Reason_samples_not_shipped__c From Core_Biopsy_Specimens__c  where TissueSpecimenDetail__c = :tissueSpecimenForm.Id order by Effective_Time__c DESC];
        
       /* integer coreBiopsyNumber = 0;
        for(Core_Biopsy_Specimens__c cbs : tmpCoreBiopsyList) {
            if(cbs.Shipped__c != null) {
                CoreBiopsyWrapper cbWrapper = new CoreBiopsyWrapper(); 
                cbWrapper.coreBiopsySpecimen = cbs;
                cbWrapper.coreBiopsyNumber = 'Core Specimen #'+(++coreBiopsyNumber)+' (Frozen)';
                lstCoreBiopsyWrapper.add(cbWrapper);
            }
        }*/
        
        if(protocolViolation.TrialPatient__r.Patient_Id__c != null){
            trialPatientObj  = [select Subject_Id__c from TrialPatient__c where id=:protocolViolation.TrialPatient__c];
            Patient = [select initials__c,Institute_Text__c from Patient_Custom__c where id=:protocolViolation.TrialPatient__r.Patient_Id__c];
        }
    }
    
    public class CoreBiopsyWrapper {
        public String coreBiopsyNumber {get;set;}
        public Core_Biopsy_Specimens__c coreBiopsySpecimen {get;set;}
    }
     
}