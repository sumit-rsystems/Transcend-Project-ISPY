public with sharing class OffStudyPdfGenerator {
   
    public Off_Study_Detail__c offStudyObj {get;set;}
    //public List<CoreBiopsyWrapper> lstCoreBiopsyWrapper {get;set;}
    public TrialPatient__c trialPatientObj {get;set;}
    public Patient_Custom__c Patient {get;set;}
    public string initials {get;set;}

   
    public OffStudyPdfGenerator(Apexpages.StandardController std) {
        string offStudyIdValue = ApexPages.currentPage().getParameters().get('Id');
        //lstCoreBiopsyWrapper = new List<CoreBiopsyWrapper>();
        offStudyObj = new Off_Study_Detail__c ();
        if(offStudyIdValue != null)
            offStudyObj = [Select TrialPatient__r.Patient_Id__c,Date_patient_went_off_study__c,Patient_completed_study_per_protocol__c,Patient_did_nt_continue_on_treatment_arm__c,Patient_did_nt_want_to_complete_core_bio__c,Patient_did_not_have_surgery__c,Patient_did_not_want_to_complete_MRI__c,Patient_Died__c,status__c,TrialPatient__c From Off_Study_Detail__c  where id =:offStudyIdValue];
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
        
        if(offStudyObj.TrialPatient__r.Patient_Id__c != null){
            trialPatientObj  = [select Subject_Id__c from TrialPatient__c where id=:offStudyObj.TrialPatient__c];
            Patient = [select initials__c,Institute_Text__c from Patient_Custom__c where id=:offStudyObj.TrialPatient__r.Patient_Id__c];
        }
    }
    
    public class CoreBiopsyWrapper {
        public String coreBiopsyNumber {get;set;}
        public Core_Biopsy_Specimens__c coreBiopsySpecimen {get;set;}
    }
     
}