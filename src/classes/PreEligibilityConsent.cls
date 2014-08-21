public with sharing class PreEligibilityConsent {
    public List<Patient_Custom__c> patientList {get;set;}
    public PreEligibilityConsent(){
        patientList = new List<Patient_Custom__c>();
        List<Patient_Custom__c> pList = [Select p.Signed_Screening__c, p.Name, p.Institution__c, p.Institute_Text__c, p.CreatedDate, (Select Name From Registrations__r order by LastModifiedDate desc limit 1), (Select Name, LastModifiedDate From PreEligibility_Checklists__r where Patient_signed_up_for_I_SPY2_screening__c = true) From Patient_Custom__c p];
        if(!pList.isEmpty()){
            for(Patient_Custom__c p : pList){
                if(p.Registrations__r.size() > 0)continue;
                if(p.PreEligibility_Checklists__r.size() < 1)continue;
                patientList.add(p);
            }       
        }
    }
    @isTest public static void  test1(){
        Account acc = new Account();
        acc.Name = 'testing';
        insert acc;
        
        CRFMaster__c crfMaster = new CRFMaster__c();
        crfMaster.CRFType__c = 'Patient Registration Form';
        crfMaster.CRFType__c = 'Registration__c';
        crfMaster.Object_Name__c = 'Registration__c';
        insert crfMaster;
        
        Phase_Master__c phMaster = new Phase_Master__c();
        phMaster.Name = 'Screening';
        phMaster.Order__c = 108;  
        insert phMaster;
        
        Phase_Cycle__c phc = new Phase_Cycle__c();
        phc.Phase__c = phMaster.id;
        phc.Order__c = 110;
        insert phc;
        
        Phase_CRFs__c phCrf = new Phase_CRFs__c();
        phCrf.Phase_Cycle__c = phc.id;
        phCrf.CRF__c = crfMaster.Id;
        insert phCrf;
        
        Patient_Custom__c pt = new Patient_Custom__c();
        pt.Name = 'testPatient';
        pt.Institution__c = acc.id;
        pt.Last_Name__c = 'test';
        pt.Birthdate__c = date.newInstance(1970, 04, 05);
        pt.Gender__c = 'Male';
        pt.Race__c = 'White';
        pt.Ethnicity__c = 'Not Hispanic or Latino';
        pt.TestHarnessId__c = 'asc002';
        insert pt;
        
        Trial__c tc = new Trial__c();
        tc.Name = 'testTrial';
        insert tc;
        
        PreEligibilityConsent pElgibility = new PreEligibilityConsent();
    }
}