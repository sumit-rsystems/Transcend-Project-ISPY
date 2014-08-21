@isTest
public class TestEligiblebutPendingRegistrDrillDown{
   public static testMethod void  TestEligiblebutPendingRegistrDrillDown(){
         Account ac = new Account(Name='Test');
        insert ac;
        
        Trial__c tr = new Trial__c();
        tr.Name = 'testTrial';
        insert tr;
       
        Site__c sc = new Site__c();
        sc.Institute__c = ac.Id;
        insert sc;
        
        Patient_Custom__c pc=new Patient_Custom__c();
        pc.Institution__c=ac.Id;
        pc.Last_Name__c='test1';
        pc.Gender__c='male';
        pc.Birthdate__c=system.today();
        pc.Race__c='testRace';
        pc.Ethnicity__c='testEthnicity'; 
        insert pc;
        
        Registration__c  rg =  new Registration__c();
        rg.Status__c = 'Approval Not Required';
        rg.IRB_Approval_Date__c = System.today();
        rg.Screening_Informed_Consent_Date__c    = System.today();
        rg.HIPPA_Consent_Date__c = System.today();
        rg.Patient__c = pc.Id;
        rg.Registration_Date__c = System.today();
        rg.Trial__c = tr.Id;
        insert rg;
        
        TrialPatient__c tpObj = new TrialPatient__c();
        tpObj.Patient_Id__c = pc.Id;    
        tpObj.Trial_Id__c = tr.Id;
        tpObj.Site__c = sc.Id;
        insert tpObj;
        
        CRF__c crf = new CRF__c();
        crf.type__c = 'PreEligibility_Checklist__c';
        crf.Patient__c = pc.Id; 
        insert crf;
        
        PreEligibility_Checklist__c pec = new PreEligibility_Checklist__c (CRF_Id__c = crf.id,Patient__c = pc.Id, CompletedDate__c = System.today());
        insert pec;
        
      EligiblebutPendingRegistrationDrillDown eps0= new EligiblebutPendingRegistrationDrillDown();
      ApexPages.CurrentPage().getParameters().put('drilldown','Registered Patient');
      EligiblebutPendingRegistrationDrillDown eps= new EligiblebutPendingRegistrationDrillDown();
      ApexPages.CurrentPage().getParameters().put('drilldown','Pending Registration');
      EligiblebutPendingRegistrationDrillDown eps1= new EligiblebutPendingRegistrationDrillDown();
       
   }
}