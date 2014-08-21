public with sharing class TissueSpecimenFormPdfGenerator {
   
    public TissueSpecimenDetail__c tissueSpecimenForm {get;set;}
    public List<CoreBiopsyWrapper> lstCoreBiopsyWrapper {get;set;}
    public TrialPatient__c trialPatientObj {get;set;}
    public Patient_Custom__c Patient {get;set;}
    public string initials {get;set;}

   
    public TissueSpecimenFormPdfGenerator(Apexpages.StandardController std) {
        string tsSpecimenId = ApexPages.currentPage().getParameters().get('Id');
        lstCoreBiopsyWrapper = new List<CoreBiopsyWrapper>();
        tissueSpecimenForm = new TissueSpecimenDetail__c();
        if(tsSpecimenId != null)
            tissueSpecimenForm = [Select TrialPatient__r.Patient_Id__c,PatientConsentedOutsideStudy__c ,PatientConsentedStudy__c,TissueSpecimenDetail__c.status__c,Time_Point__c,Other_Reason_not_all_samples_collected__c ,Reason_all_samples_not_collected__c ,Guidance_Method_s__c,Other_Guidance_Method__c,ProcedureDate__c,TrialPatient__c From TissueSpecimenDetail__c  where id =: tsSpecimenId];
        //system.assert(false,TissueSpecimenDetail__c.status__c);
        List<Core_Biopsy_Specimens__c>  tmpCoreBiopsyList = new  List<Core_Biopsy_Specimens__c> ();
        tmpCoreBiopsyList = [Select TissueSpecimenDetail__c, SpecimenID__c, Shipped__c, Reason_samples_not_shipped__c, Other_Reason_samples_not_shipped__c From Core_Biopsy_Specimens__c  where TissueSpecimenDetail__c = :tissueSpecimenForm.Id order by Effective_Time__c DESC];
        
        integer coreBiopsyNumber = 0;
        for(Core_Biopsy_Specimens__c cbs : tmpCoreBiopsyList) {
            if(cbs.Shipped__c != null) {
                CoreBiopsyWrapper cbWrapper = new CoreBiopsyWrapper(); 
                cbWrapper.coreBiopsySpecimen = cbs;
                cbWrapper.coreBiopsyNumber = 'Core Specimen #'+(++coreBiopsyNumber)+' (Frozen)';
                lstCoreBiopsyWrapper.add(cbWrapper);
            }
        }
        
        if(tissueSpecimenForm.TrialPatient__r.Patient_Id__c != null){
            trialPatientObj  = [select Subject_Id__c from TrialPatient__c where id=:tissueSpecimenForm.TrialPatient__c];
            Patient = [select initials__c,Institute_Text__c from Patient_Custom__c where id=:tissueSpecimenForm.TrialPatient__r.Patient_Id__c];
        }
    }
    
    public class CoreBiopsyWrapper {
        public String coreBiopsyNumber {get;set;}
        public Core_Biopsy_Specimens__c coreBiopsySpecimen {get;set;}
    }
     
}