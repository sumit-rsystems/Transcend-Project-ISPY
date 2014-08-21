@isTest
public class TestEligiblePendingRegistration_Site{
    public static testMethod void TestEligiblePendingRegistration_Site(){
        
        Account acc = new Account(Name = 'TEstAcc');
        insert acc;
        
        Patient_Custom__c p = new Patient_Custom__c();
        p.Birthdate__c = date.newInstance(1980, 08, 05);
        p.Institution__c = acc.Id;
        p.Last_Name__c = 'test'; 
        p.Gender__c = 'Male';
        p.Race__c = 'White';
        p.Ethnicity__c = 'Not Hispanic or Latino';
        insert p;
        
        Site__c st = new Site__c(Institute__c = acc.Id);
        insert st;
        
        Trial__c tri = new Trial__c();
        tri.Name = 'test';
        insert tri;
        
        TrialPatient__c tp = new TrialPatient__c(Site__c = st.Id);
        tp.Patient_Id__c = p.Id;
        tp.Trial_Id__c = tri.Id;
        
        insert tp;
        
       /* Registration__c reg= new  Registration__c();
        //reg.site__c= st.Id;
        reg.IRB_Approval_Date__c=system.today();
        reg.Screening_Informed_Consent_Date__c =system.today();
        reg.HIPPA_Consent_Date__c =system.today();
        reg.Patient__c=p.Id;
        reg.Trial__c=tri.Id;
        reg.TrialPatient__c = tp.Id;
        reg.Registration_Date__c = system.today();
        insert reg;*/
        
        CRF__c crf = new CRF__c();
        crf.TrialPatient__c = tp.Id;
        crf.Trial__c = tri.Id;
        crf.Patient__c = p.Id;
        crf.Phase__c = 'Test Phase';
        crf.Type__c = 'PreEligibility_Checklist__c';
        insert crf;
        
        EligiblePendingRegistration_Site eps= new EligiblePendingRegistration_Site();
        eps.siteUserData();
        eps.dccUserData();
    }
}