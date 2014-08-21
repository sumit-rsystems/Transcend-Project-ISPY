public without sharing class CRFStatusUtility {
    public static boolean isRandomizationCRFSubmitted(Id trialPatientId) {
        List<Randomization_Form__c> lstRandomizationFrom = [select Id from Randomization_Form__c where TrialPatient__c = :trialPatientId];
        if(!lstRandomizationFrom.isEmpty()) {
            return true;
        }
        return false;
    }
    
    @isTest public static void unitTest() {
        
        Account acc = new Account();
        acc.Name = 'test';
        insert acc;
        
        Patient_Custom__c p = new Patient_Custom__c();
        p.Birthdate__c = date.newInstance(1980, 08, 05);
        p.Institution__c = acc.Id;
        p.Last_Name__c = 'test';
        p.Gender__c = 'Male';
        p.Race__c = 'White';
        p.Ethnicity__c = 'Not Hispanic or Latino';
        insert p;
        
        TrialPatient__c tp = new TrialPatient__c();
        tp.Patient_Id__c = p.Id;
        insert tp;
        
        CRFStatusUtility.isRandomizationCRFSubmitted(tp.Id);
        
        Randomization_Form__c rfc = new Randomization_Form__c();
        rfc.TrialPatient__c = tp.Id;
        rfc.Did_Patient_Sign_Treatment_Consent_Form__c = true;
        rfc.Randomization_Result__c = 'Randomized';
        rfc.Status__c = 'Accepted';
        insert rfc;
        
        CRFStatusUtility.isRandomizationCRFSubmitted(tp.Id);
    }
}