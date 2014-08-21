@isTest
public class  TestPatientsContinueOptedOutController{
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
        crf.add(new CRF__c(Type__c = 'PreEligibility_Checklist__c', Status__c = 'Approval Not Required', Patient__c = pc[4].id));             
        crf.add(new CRF__c(Type__c = 'PreEligibility_Checklist__c', Status__c = 'Accepted' , Patient__c = pc[0].id));             
        crf.add(new CRF__c(Type__c = 'PreEligibility_Checklist__c', Status__c = 'Approval Not Required', Patient__c = pc[1].id));             
        insert crf;
        
        Trial__c tri = new Trial__c();
        tri.Name = 'test';
        insert tri;
       
        List<TrialPatient__c > tp = new List<TrialPatient__c >();
       tp.add(new TrialPatient__c (Patient_Id__c = pc[0].Id, Trial_Id__c = tri.Id, Site__c = site.Id));    
       tp.add(new TrialPatient__c (Patient_Id__c = pc[1].Id, Trial_Id__c = tri.Id, Site__c = site.Id));    
       tp.add(new TrialPatient__c (Patient_Id__c = pc[2].Id, Trial_Id__c = tri.Id, Site__c = site.Id));    
       tp.add(new TrialPatient__c (Patient_Id__c = pc[3].Id, Trial_Id__c = tri.Id, Site__c = site.Id));      
       insert tp;
       
       List<Off_Study_Detail__c> off = new List<Off_Study_Detail__c>();
       off.add(new Off_Study_Detail__c(Status__c ='Accepted', TrialPatient__c = tp[0].Id));
       off.add(new Off_Study_Detail__c(Status__c ='Accepted', TrialPatient__c = tp[1].Id));
       off.add(new Off_Study_Detail__c(Status__c ='Not Accepted', TrialPatient__c = tp[2].Id));
        off.add(new Off_Study_Detail__c(Status__c ='Not Accepted', TrialPatient__c = tp[3].Id));
        insert off;
       List<Randomization_Form__c> rf = new List<Randomization_Form__c>();
       rf.add(new Randomization_Form__c(Randomization_Result__c = 'Paclitaxel', Status__c = 'Approval Not Required', Did_Patient_Sign_Treatment_Consent_Form__c = true,TrialPatient__c = tp[0].Id ));
       rf.add(new Randomization_Form__c(Randomization_Result__c = 'Paclitaxel', Status__c = 'Approval Not Required', Did_Patient_Sign_Treatment_Consent_Form__c = true,TrialPatient__c = tp[1].Id  ));
       rf.add(new Randomization_Form__c(Randomization_Result__c = 'Paclitaxel', Status__c = 'Approval Not Required', Did_Patient_Sign_Treatment_Consent_Form__c = true,TrialPatient__c = tp[2].Id  ));
       rf.add(new Randomization_Form__c(Randomization_Result__c = 'Paclitaxel', Status__c = 'Approval Not Required', Did_Patient_Sign_Treatment_Consent_Form__c = true,TrialPatient__c = tp[3].Id  ));
       insert rf;
        ApexPages.CurrentPage().getParameters().put('site', '\''+site.Id+'\'');
        PatientsContinueOptedOutController poc = new  PatientsContinueOptedOutController();
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
        crf.add(new CRF__c(Type__c = 'PreEligibility_Checklist__c', Status__c = 'Approval Not Required', Patient__c = pc[4].id));             
        crf.add(new CRF__c(Type__c = 'PreEligibility_Checklist__c', Status__c = 'Accepted' , Patient__c = pc[0].id));             
        crf.add(new CRF__c(Type__c = 'PreEligibility_Checklist__c', Status__c = 'Approval Not Required', Patient__c = pc[1].id));             
        insert crf;
        
        Trial__c tri = new Trial__c();
        tri.Name = 'test';
        insert tri;
       
        List<TrialPatient__c > tp = new List<TrialPatient__c >();
       tp.add(new TrialPatient__c (Patient_Id__c = pc[0].Id, Trial_Id__c = tri.Id, Site__c = site.Id));    
       tp.add(new TrialPatient__c (Patient_Id__c = pc[1].Id, Trial_Id__c = tri.Id, Site__c = site.Id));    
       tp.add(new TrialPatient__c (Patient_Id__c = pc[2].Id, Trial_Id__c = tri.Id, Site__c = site.Id));    
       tp.add(new TrialPatient__c (Patient_Id__c = pc[3].Id, Trial_Id__c = tri.Id, Site__c = site.Id));      
       insert tp;
       
       List<Off_Study_Detail__c> off = new List<Off_Study_Detail__c>();
       off.add(new Off_Study_Detail__c(Status__c ='Accepted', TrialPatient__c = tp[0].Id));
       off.add(new Off_Study_Detail__c(Status__c ='Accepted', TrialPatient__c = tp[1].Id));
       off.add(new Off_Study_Detail__c(Status__c ='Not Accepted', TrialPatient__c = tp[2].Id));
        off.add(new Off_Study_Detail__c(Status__c ='Not Accepted', TrialPatient__c = tp[3].Id));
        insert off;
       List<Randomization_Form__c> rf = new List<Randomization_Form__c>();
       rf.add(new Randomization_Form__c(Randomization_Result__c = 'Paclitaxel', Status__c = 'Approval Not Required', Did_Patient_Sign_Treatment_Consent_Form__c = true,TrialPatient__c = tp[0].Id ));
       rf.add(new Randomization_Form__c(Randomization_Result__c = 'Paclitaxel', Status__c = 'Approval Not Required', Did_Patient_Sign_Treatment_Consent_Form__c = true,TrialPatient__c = tp[1].Id  ));
       rf.add(new Randomization_Form__c(Randomization_Result__c = 'Paclitaxel', Status__c = 'Approval Not Required', Did_Patient_Sign_Treatment_Consent_Form__c = true,TrialPatient__c = tp[2].Id  ));
       rf.add(new Randomization_Form__c(Randomization_Result__c = 'Paclitaxel', Status__c = 'Approval Not Required', Did_Patient_Sign_Treatment_Consent_Form__c = true,TrialPatient__c = tp[3].Id  ));
       insert rf;
       PatientsContinueOptedOutController poc = new  PatientsContinueOptedOutController();
  }
}