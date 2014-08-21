@isTest
public class  TestRegisteredPendingMammaprint{
  public static testMethod void test(){
        Account acc = new Account(Name='TEst Institution');
        insert acc;
        Site__c site = new Site__c(Name = 'Test Site', Institute__c = acc.Id);
        insert site;
          Date d= Date.Today();
        List<Patient_Custom__c> pc = new List<Patient_Custom__c>();
        pc.add(new Patient_Custom__c(Last_Name__c = 'Test last', Birthdate__c = date.today().addYears(-20)  
        ,Ethnicity__c='Hispanic or Latino', Race__c = 'Asian' , Institution__c = acc.id));
        pc.add(new Patient_Custom__c(Last_Name__c = 'Test last', Birthdate__c = date.today().addYears(-30)  
        ,Ethnicity__c='Hispanic or Latino', Race__c = 'Asian' , Institution__c = acc.id));
       pc.add(new Patient_Custom__c(Last_Name__c = 'Test last', Birthdate__c = date.today().addYears(-40)  
        ,Ethnicity__c='Hispanic or Latino', Race__c = 'Asian' , Institution__c = acc.id));
       pc.add(new Patient_Custom__c(Last_Name__c = 'Test last', Birthdate__c = date.today().addYears(-50)  
        ,Ethnicity__c='Hispanic or Latino', Race__c = 'Asian' , Institution__c = acc.id));
       pc.add(new Patient_Custom__c(Last_Name__c = 'Test last', Birthdate__c = date.today().addYears(-60)  
        ,Ethnicity__c='Hispanic or Latino', Race__c = 'Asian' , Institution__c = acc.id));
       pc.add(new Patient_Custom__c(Last_Name__c = 'Test last', Birthdate__c = date.today().addYears(-70)  
        ,Ethnicity__c='Hispanic or Latino', Race__c = 'Asian' , Institution__c = acc.id));
       pc.add(new Patient_Custom__c(Last_Name__c = 'Test last', Birthdate__c = date.today().addYears(-80)  
        ,Ethnicity__c='Hispanic or Latino', Race__c = 'Asian' , Institution__c = acc.id));
       pc.add(new Patient_Custom__c(Last_Name__c = 'Test last', Birthdate__c = date.today().addYears(-90)  
        ,Ethnicity__c='Hispanic or Latino', Race__c = 'Asian' , Institution__c = acc.id));
       pc.add(new Patient_Custom__c(Last_Name__c = 'Test last', Birthdate__c = date.today()  
        ,Ethnicity__c='Hispanic or Latino', Race__c = 'Asian' , Institution__c = acc.id));
       insert pc;
       
          List<CRF__c> crf = new List<CRF__c>();
        crf.add(new CRF__c(Type__c = 'TissueSpecimenDetail__c', Status__c = 'Approval Not Required', Patient__c = pc[4].id));             
        crf.add(new CRF__c(Type__c = 'PreEligibility_Checklist__c', Status__c = 'Accepted' , Patient__c = pc[0].id));             
        crf.add(new CRF__c(Type__c = 'Registration__c', Status__c = 'Approval Not Required', Patient__c = pc[1].id));             
        insert crf;
        
        Trial__c tri = new Trial__c();
        tri.Name = 'test';
        insert tri;
        
       List<TrialPatient__c > tp = new List<TrialPatient__c >();
       tp.add(new TrialPatient__c (Patient_Id__c = pc[0].Id, Trial_Id__c = tri.Id, Site__c = site.Id));    
       tp.add(new TrialPatient__c (Patient_Id__c = pc[1].Id, Trial_Id__c = tri.Id, Site__c = site.Id));    
       tp.add(new TrialPatient__c (Patient_Id__c = pc[2].Id, Trial_Id__c = tri.Id, Site__c = site.Id));    
       tp.add(new TrialPatient__c (Patient_Id__c = pc[4].Id, Trial_Id__c = tri.Id, Site__c = site.Id));      
       insert tp;
        
        List<MammaPrintDetail__c > mp = new List<MammaPrintDetail__c >();
        mp.add(new MammaPrintDetail__c(CompletedDate__c = System.Today(),Status__c = 'Approval Not Required', TrialPatient__c = tp[1].Id));
        mp.add(new MammaPrintDetail__c(CompletedDate__c = System.Today(),Status__c = 'Approval Not Required', TrialPatient__c = tp[3].Id));
        mp.add(new MammaPrintDetail__c(CompletedDate__c = System.Today(),Status__c = 'Approval Not Required', TrialPatient__c = tp[0].Id));
        insert mp;
        
        List<Registration__c> rg = new List<Registration__c>();
        rg.add(new Registration__c(Registration_Date__c = System.Today(), Trial__c = tri.Id, Patient__c = pc[0].Id,HIPPA_Consent_Date__c = System.Today() , Screening_Informed_Consent_Date__c = System.Today(), IRB_Approval_Date__c = System.Today(), CompletedDate__c = System.Today(),Status__c = 'Approval Not Required', TrialPatient__c = tp[0].Id));
        rg.add(new Registration__c(Registration_Date__c = System.Today(), Trial__c = tri.Id,Patient__c = pc[1].Id,HIPPA_Consent_Date__c = System.Today() , Screening_Informed_Consent_Date__c = System.Today(),IRB_Approval_Date__c = System.Today(),CompletedDate__c = System.Today(),Status__c = 'Approval Not Required', TrialPatient__c = tp[1].Id));
        rg.add(new Registration__c(Registration_Date__c = System.Today(), Trial__c = tri.Id,Patient__c = pc[2].Id,HIPPA_Consent_Date__c = System.Today() , Screening_Informed_Consent_Date__c = System.Today(),IRB_Approval_Date__c = System.Today(),CompletedDate__c = System.Today(),Status__c = 'Approval Not Required', TrialPatient__c = tp[2].Id));
        rg.add(new Registration__c(Registration_Date__c = System.Today(), Trial__c = tri.Id,Patient__c = pc[3].Id,HIPPA_Consent_Date__c = System.Today() , Screening_Informed_Consent_Date__c = System.Today(),IRB_Approval_Date__c = System.Today(),CompletedDate__c = System.Today(),Status__c = 'Approval Not Required', TrialPatient__c = tp[3].Id));
        insert rg;
         ApexPages.CurrentPage().getParameters().put('site', '\''+site.Id+'\'');
        RegisteredPendingMammaprintController rpm = new  RegisteredPendingMammaprintController();
        
      
  }
   public static testMethod void test1(){
        Account acc = new Account(Name='TEst Institution');
        insert acc;
        Site__c site = new Site__c(Name = 'Test Site', Institute__c = acc.Id);
        insert site;
          Date d= Date.Today();
        List<Patient_Custom__c> pc = new List<Patient_Custom__c>();
        pc.add(new Patient_Custom__c(Last_Name__c = 'Test last', Birthdate__c = date.today().addYears(-20)  
        ,Ethnicity__c='Hispanic or Latino', Race__c = 'Asian' , Institution__c = acc.id));
        pc.add(new Patient_Custom__c(Last_Name__c = 'Test last', Birthdate__c = date.today().addYears(-30)  
        ,Ethnicity__c='Hispanic or Latino', Race__c = 'Asian' , Institution__c = acc.id));
       pc.add(new Patient_Custom__c(Last_Name__c = 'Test last', Birthdate__c = date.today().addYears(-40)  
        ,Ethnicity__c='Hispanic or Latino', Race__c = 'Asian' , Institution__c = acc.id));
       pc.add(new Patient_Custom__c(Last_Name__c = 'Test last', Birthdate__c = date.today().addYears(-50)  
        ,Ethnicity__c='Hispanic or Latino', Race__c = 'Asian' , Institution__c = acc.id));
       pc.add(new Patient_Custom__c(Last_Name__c = 'Test last', Birthdate__c = date.today().addYears(-60)  
        ,Ethnicity__c='Hispanic or Latino', Race__c = 'Asian' , Institution__c = acc.id));
       pc.add(new Patient_Custom__c(Last_Name__c = 'Test last', Birthdate__c = date.today().addYears(-70)  
        ,Ethnicity__c='Hispanic or Latino', Race__c = 'Asian' , Institution__c = acc.id));
       pc.add(new Patient_Custom__c(Last_Name__c = 'Test last', Birthdate__c = date.today().addYears(-80)  
        ,Ethnicity__c='Hispanic or Latino', Race__c = 'Asian' , Institution__c = acc.id));
       pc.add(new Patient_Custom__c(Last_Name__c = 'Test last', Birthdate__c = date.today().addYears(-90)  
        ,Ethnicity__c='Hispanic or Latino', Race__c = 'Asian' , Institution__c = acc.id));
       pc.add(new Patient_Custom__c(Last_Name__c = 'Test last', Birthdate__c = date.today()  
        ,Ethnicity__c='Hispanic or Latino', Race__c = 'Asian' , Institution__c = acc.id));
       insert pc;
       
          List<CRF__c> crf = new List<CRF__c>();
        crf.add(new CRF__c(Type__c = 'TissueSpecimenDetail__c', Status__c = 'Approval Not Required', Patient__c = pc[4].id));             
        crf.add(new CRF__c(Type__c = 'PreEligibility_Checklist__c', Status__c = 'Accepted' , Patient__c = pc[0].id));             
        crf.add(new CRF__c(Type__c = 'Registration__c', Status__c = 'Approval Not Required', Patient__c = pc[1].id));             
        insert crf;
        
        Trial__c tri = new Trial__c();
        tri.Name = 'test';
        insert tri;
        
       List<TrialPatient__c > tp = new List<TrialPatient__c >();
       tp.add(new TrialPatient__c (Patient_Id__c = pc[0].Id, Trial_Id__c = tri.Id, Site__c = site.Id));    
       tp.add(new TrialPatient__c (Patient_Id__c = pc[1].Id, Trial_Id__c = tri.Id, Site__c = site.Id));    
       tp.add(new TrialPatient__c (Patient_Id__c = pc[2].Id, Trial_Id__c = tri.Id, Site__c = site.Id));    
       tp.add(new TrialPatient__c (Patient_Id__c = pc[4].Id, Trial_Id__c = tri.Id, Site__c = site.Id));      
       insert tp;
        
        List<MammaPrintDetail__c > mp = new List<MammaPrintDetail__c >();
        mp.add(new MammaPrintDetail__c(CompletedDate__c = System.Today(),Status__c = 'Approval Not Required', TrialPatient__c = tp[1].Id));
        mp.add(new MammaPrintDetail__c(CompletedDate__c = System.Today(),Status__c = 'Approval Not Required', TrialPatient__c = tp[3].Id));
        mp.add(new MammaPrintDetail__c(CompletedDate__c = System.Today(),Status__c = 'Approval Not Required', TrialPatient__c = tp[0].Id));
        insert mp;
        
        List<Registration__c> rg = new List<Registration__c>();
        rg.add(new Registration__c(Registration_Date__c = System.Today(), Trial__c = tri.Id, Patient__c = pc[0].Id,HIPPA_Consent_Date__c = System.Today() , Screening_Informed_Consent_Date__c = System.Today(), IRB_Approval_Date__c = System.Today(), CompletedDate__c = System.Today(),Status__c = 'Approval Not Required', TrialPatient__c = tp[0].Id));
        rg.add(new Registration__c(Registration_Date__c = System.Today(), Trial__c = tri.Id,Patient__c = pc[1].Id,HIPPA_Consent_Date__c = System.Today() , Screening_Informed_Consent_Date__c = System.Today(),IRB_Approval_Date__c = System.Today(),CompletedDate__c = System.Today(),Status__c = 'Approval Not Required', TrialPatient__c = tp[1].Id));
        rg.add(new Registration__c(Registration_Date__c = System.Today(), Trial__c = tri.Id,Patient__c = pc[2].Id,HIPPA_Consent_Date__c = System.Today() , Screening_Informed_Consent_Date__c = System.Today(),IRB_Approval_Date__c = System.Today(),CompletedDate__c = System.Today(),Status__c = 'Approval Not Required', TrialPatient__c = tp[2].Id));
        rg.add(new Registration__c(Registration_Date__c = System.Today(), Trial__c = tri.Id,Patient__c = pc[3].Id,HIPPA_Consent_Date__c = System.Today() , Screening_Informed_Consent_Date__c = System.Today(),IRB_Approval_Date__c = System.Today(),CompletedDate__c = System.Today(),Status__c = 'Approval Not Required', TrialPatient__c = tp[3].Id));
        insert rg;
        ApexPages.CurrentPage().getParameters().put('site', '');
        RegisteredPendingMammaprintController rpm = new  RegisteredPendingMammaprintController();
        
      
  }
}