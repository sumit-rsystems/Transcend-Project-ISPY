public class BloodSpecimenFormPdf {
    public BloodSpecimenForm__c bloodSpecimen {get;set;}
    public List<SerumSpecimenWrapper> lstSerumSpecimenWrapper {get;set;}
    public List<PlasmaSpecimenWrapper> lstPlasmaSpecimenWrapper {get;set;}
    public List<BuffySpecimenWrapper> lstBuffySpecimenWrapper {get;set;}
    TissueSpecimenDetail__c tissueSpecimenForm ;
    public TrialPatient__c trialPatientObj {get;set;}
    public Patient_Custom__c Patient {get;set;}
    public boolean isReasonAllDisabled {get;set;}
    public boolean isOtherReasonAllDisabled {get;set;}
       
    
    public BloodSpecimenFormPdf (Apexpages.StandardController std){
        lstBuffySpecimenWrapper = new List<BuffySpecimenWrapper>(); 
        lstSerumSpecimenWrapper = new List<SerumSpecimenWrapper>();
        lstPlasmaSpecimenWrapper = new List<PlasmaSpecimenWrapper>();
        
        string tsSpecimenId = ApexPages.currentPage().getParameters().get('tsSpecimenId');
        tissueSpecimenForm = new TissueSpecimenDetail__c();
        if(tsSpecimenId != null)
            tissueSpecimenForm = [Select TrialPatient__r.Patient_Id__c From TissueSpecimenDetail__c  where id =: tsSpecimenId];    
        
        if(tissueSpecimenForm.TrialPatient__r.Patient_Id__c != null){
            trialPatientObj  = [select Subject_Id__c from TrialPatient__c where id=:tissueSpecimenForm.TrialPatient__c];
            Patient = [select initials__c,Institute_Text__c from Patient_Custom__c where id=:tissueSpecimenForm.TrialPatient__r.Patient_Id__c];
        }
        
        string bloodSpecimenId = Apexpages.currentPage().getParameters().get('bloodSpecimenId'); 
        if(bloodSpecimenId != null && bloodSpecimenId != '')
            bloodSpecimen = [Select b.Effective_Time__c,b.TrialPatient__c, b.TrialPatient__r.Name, b.CRF__c,b.TrialPatient__r.Patient_Id__c, b.Time_Point__c, b.Status__c, b.Reason_all_samples_not_collected__c, b.Phase__c, b.Other_Reason_samples_not_shipped__c, b.Name, b.Id, b.Contented_specimen_outside_study__c, b.Consented_to_use_specimen_study__c, b.CompletedDate__c, b.CollectionDate__c, (Select Name, BloodSpecimenForm__c, Shipped__c, Reason_samples_not_shipped__c, Other_Reason_samples_not_shipped__c, Specimen_ID__c From BloodSpecimenInfo__r) From BloodSpecimenForm__c b where Id = :bloodSpecimenId];
        
        /* 
        for(integer i=1;i<=3;i++) {
            SerumSpecimenWrapper serumSpecimen = new SerumSpecimenWrapper();
            serumSpecimen.bloodSpecimenInfo = new BloodSpecimenInfo__c();
            serumSpecimen.isCollected = false;
            serumSpecimen.SpecimenNumber = 'Serum Specimen #'+i;
            serumSpecimen.isShippedDisabled = true;
            serumSpecimen.isReasonDisabled = true;
            serumSpecimen.isOtherDisabled = true;
            lstSerumSpecimenWrapper.add(serumSpecimen);
        }  
        
         
        for(integer i=1;i<=3;i++) {
            PlasmaSpecimenWrapper plasmaSpecimen = new PlasmaSpecimenWrapper();
            plasmaSpecimen.isCollected = false;
            plasmaSpecimen.bloodSpecimenInfo = new BloodSpecimenInfo__c();
            plasmaSpecimen.SpecimenNumber = 'Plasma Specimen #'+i;
            plasmaSpecimen.isShippedDisabled = true;
            plasmaSpecimen.isReasonDisabled = true;
            plasmaSpecimen.isOtherDisabled = true;
            lstPlasmaSpecimenWrapper.add(plasmaSpecimen);
        }
        
        for(integer i=1;i<=2;i++) {
            BuffySpecimenWrapper buffySpecimen = new BuffySpecimenWrapper();
            buffySpecimen.bloodSpecimenInfo = new BloodSpecimenInfo__c();
            buffySpecimen.isCollected = false;
            buffySpecimen.SpecimenNumber = 'Buffy coat specimen #'+i;
            buffySpecimen.isShippedDisabled = true;
            buffySpecimen.isReasonDisabled = true;
            buffySpecimen.isOtherDisabled = true;
            lstBuffySpecimenWrapper.add(buffySpecimen);
        } */ 
       
    }
    
    public class SerumSpecimenWrapper {
        public String SpecimenNumber {get;set;}
        public boolean isCollected {get;set;}
        public boolean isShippedDisabled {get;set;}
        public boolean isReasonDisabled {get;set;}
        public boolean isOtherDisabled {get;set;}
        public BloodSpecimenInfo__c bloodSpecimenInfo {get;set;}
    }
    
    public class PlasmaSpecimenWrapper { 
        public String SpecimenNumber {get;set;}
        public boolean isCollected {get;set;}
        public boolean isShippedDisabled {get;set;}
        public boolean isReasonDisabled {get;set;}
        public boolean isOtherDisabled {get;set;}
        public BloodSpecimenInfo__c bloodSpecimenInfo {get;set;}
    }
    
    public class BuffySpecimenWrapper {
        public String SpecimenNumber {get;set;}
        public boolean isCollected {get;set;}
        public boolean isShippedDisabled {get;set;}
        public boolean isReasonDisabled {get;set;}
        public boolean isOtherDisabled {get;set;}
        public BloodSpecimenInfo__c bloodSpecimenInfo {get;set;}
    } 
}