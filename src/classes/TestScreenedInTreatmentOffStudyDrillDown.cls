@isTest
public class TestScreenedInTreatmentOffStudyDrillDown{
   public static testMethod void TestScreenedInTreatmentOffStudyDrillDown(){
      
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
       
      
        Trial__c tri = new Trial__c();
        tri.Name = 'test';
        insert tri;
       
       List<TrialPatient__c > tp = new List<TrialPatient__c >();
       tp.add(new TrialPatient__c (Patient_Id__c = pc[0].Id, Trial_Id__c = tri.Id, Site__c = site.Id));    
       tp.add(new TrialPatient__c (Patient_Id__c = pc[1].Id, Trial_Id__c = tri.Id, Site__c = site.Id));    
       tp.add(new TrialPatient__c (Patient_Id__c = pc[2].Id, Trial_Id__c = tri.Id, Site__c = site.Id));    
       tp.add(new TrialPatient__c (Patient_Id__c = pc[4].Id, Trial_Id__c = tri.Id, Site__c = site.Id));      
       insert tp;
        List<CRF__c> crf = new List<CRF__c>();
        crf.add(new CRF__c(Type__c = 'TissueSpecimenDetail__c', Status__c = 'Approval Not Required', Patient__c = pc[2].id));             
        crf.add(new CRF__c(Type__c = 'PreEligibility_Checklist__c', Status__c = 'Accepted' , Patient__c = pc[0].id));             
        crf.add(new CRF__c(Type__c = 'Registration__c', Status__c = 'Approval Not Required', Patient__c = pc[1].id));             
        insert crf;
       
        List<Off_Study_Detail__c> off = new List<Off_Study_Detail__c>();
       off.add(new Off_Study_Detail__c(Status__c ='Accepted', TrialPatient__c = tp[0].Id, CRF__c = crf[0].Id));
       off.add(new Off_Study_Detail__c(Status__c ='Accepted', TrialPatient__c = tp[1].Id, CRF__c = crf[1].Id));
       off.add(new Off_Study_Detail__c(Status__c ='Not Accepted', TrialPatient__c = tp[2].Id, CRF__c = crf[2].Id));
        off.add(new Off_Study_Detail__c(Status__c ='Not Accepted', TrialPatient__c = tp[3].Id, CRF__c = crf[0].Id));
        insert off;
       List<Randomization_Form__c> rf = new List<Randomization_Form__c>();
       rf.add(new Randomization_Form__c(Randomization_Result__c = 'Paclitaxel', Status__c = 'Approval Not Required', Did_Patient_Sign_Treatment_Consent_Form__c = true,TrialPatient__c = tp[0].Id ));
       rf.add(new Randomization_Form__c(Randomization_Result__c = 'Paclitaxel', Status__c = 'Approval Not Required', Did_Patient_Sign_Treatment_Consent_Form__c = true,TrialPatient__c = tp[1].Id  ));
       rf.add(new Randomization_Form__c(Randomization_Result__c = 'Paclitaxel', Status__c = 'Approval Not Required', Did_Patient_Sign_Treatment_Consent_Form__c = true,TrialPatient__c = tp[2].Id  ));
       rf.add(new Randomization_Form__c(Randomization_Result__c = 'Paclitaxel', Status__c = 'Approval Not Required', Did_Patient_Sign_Treatment_Consent_Form__c = true,TrialPatient__c = tp[3].Id  ));
       insert rf;
       
       /*  List<ArmPatient__c> apc = new list<ArmPatient__c>();
       apc.add(new ArmPatient__c(TrialPatient__c = tp[0], CreatedDate = Syste.Today(),Subject_Id__c = pc[0].Id, Patient_Id__c = pc[0].Id));
       apc.add(new ArmPatient__c(TrialPatient__c = tp[1], CreatedDate = Syste.Today(),Subject_Id__c = pc[1].Id, Patient_Id__c = pc[1].Id));
       apc.add(new ArmPatient__c(TrialPatient__c = tp[2], CreatedDate = Syste.Today(),Subject_Id__c = pc[2].Id, Patient_Id__c = pc[2].Id));
       insert apc; */ 
       
       ApexPages.CurrentPage().getParameters().put('drilldown', 'Off Study');
       ScreenedInTreatmentOffStudyDrillDown sto=new  ScreenedInTreatmentOffStudyDrillDown();
      
   
   }
   public static testMethod void TestScreenedInTreatmentOffStudyDrillDown3(){
      
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
       
      
        Trial__c tri = new Trial__c();
        tri.Name = 'test';
        insert tri;
       
       List<TrialPatient__c > tp = new List<TrialPatient__c >();
       tp.add(new TrialPatient__c (Patient_Id__c = pc[0].Id, Trial_Id__c = tri.Id, Site__c = site.Id));    
       tp.add(new TrialPatient__c (Patient_Id__c = pc[1].Id, Trial_Id__c = tri.Id, Site__c = site.Id));    
       tp.add(new TrialPatient__c (Patient_Id__c = pc[2].Id, Trial_Id__c = tri.Id, Site__c = site.Id));    
       tp.add(new TrialPatient__c (Patient_Id__c = pc[4].Id, Trial_Id__c = tri.Id, Site__c = site.Id));      
       insert tp;
        List<CRF__c> crf = new List<CRF__c>();
        crf.add(new CRF__c(Type__c = 'TissueSpecimenDetail__c', Status__c = 'Approval Not Required', Patient__c = pc[2].id));             
        crf.add(new CRF__c(Type__c = 'PreEligibility_Checklist__c', Status__c = 'Accepted' , Patient__c = pc[0].id));             
        crf.add(new CRF__c(Type__c = 'Registration__c', Status__c = 'Approval Not Required', Patient__c = pc[1].id));             
        insert crf;
       
        List<Off_Study_Detail__c> off = new List<Off_Study_Detail__c>();
       off.add(new Off_Study_Detail__c(Status__c ='Accepted', TrialPatient__c = tp[0].Id, CRF__c = crf[0].Id));
       off.add(new Off_Study_Detail__c(Status__c ='Accepted', TrialPatient__c = tp[1].Id, CRF__c = crf[1].Id));
       off.add(new Off_Study_Detail__c(Status__c ='Not Accepted', TrialPatient__c = tp[2].Id, CRF__c = crf[2].Id));
        off.add(new Off_Study_Detail__c(Status__c ='Not Accepted', TrialPatient__c = tp[3].Id, CRF__c = crf[0].Id));
        insert off;
       List<Randomization_Form__c> rf = new List<Randomization_Form__c>();
       rf.add(new Randomization_Form__c(Randomization_Result__c = 'Paclitaxel', Status__c = 'Approval Not Required', Did_Patient_Sign_Treatment_Consent_Form__c = true,TrialPatient__c = tp[0].Id ));
       rf.add(new Randomization_Form__c(Randomization_Result__c = 'Paclitaxel', Status__c = 'Approval Not Required', Did_Patient_Sign_Treatment_Consent_Form__c = true,TrialPatient__c = tp[1].Id  ));
       rf.add(new Randomization_Form__c(Randomization_Result__c = 'Paclitaxel', Status__c = 'Approval Not Required', Did_Patient_Sign_Treatment_Consent_Form__c = true,TrialPatient__c = tp[2].Id  ));
       rf.add(new Randomization_Form__c(Randomization_Result__c = 'Paclitaxel', Status__c = 'Approval Not Required', Did_Patient_Sign_Treatment_Consent_Form__c = true,TrialPatient__c = tp[3].Id  ));
       insert rf;
       
       /*  List<ArmPatient__c> apc = new list<ArmPatient__c>();
       apc.add(new ArmPatient__c(TrialPatient__c = tp[0], CreatedDate = Syste.Today(),Subject_Id__c = pc[0].Id, Patient_Id__c = pc[0].Id));
       apc.add(new ArmPatient__c(TrialPatient__c = tp[1], CreatedDate = Syste.Today(),Subject_Id__c = pc[1].Id, Patient_Id__c = pc[1].Id));
       apc.add(new ArmPatient__c(TrialPatient__c = tp[2], CreatedDate = Syste.Today(),Subject_Id__c = pc[2].Id, Patient_Id__c = pc[2].Id));
       insert apc; */
       ApexPages.CurrentPage().getParameters().put('drilldown', 'Screened');
       ScreenedInTreatmentOffStudyDrillDown sto=new  ScreenedInTreatmentOffStudyDrillDown();
      
   
   }
   public static testMethod void TestScreenedInTreatmentOffStudyDrillDown1(){
      
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
       
      
        Trial__c tri = new Trial__c();
        tri.Name = 'test';
        insert tri;
       
       List<TrialPatient__c > tp = new List<TrialPatient__c >();
       tp.add(new TrialPatient__c (Patient_Id__c = pc[0].Id, Trial_Id__c = tri.Id, Site__c = site.Id));    
       tp.add(new TrialPatient__c (Patient_Id__c = pc[1].Id, Trial_Id__c = tri.Id, Site__c = site.Id));    
       tp.add(new TrialPatient__c (Patient_Id__c = pc[2].Id, Trial_Id__c = tri.Id, Site__c = site.Id));    
       tp.add(new TrialPatient__c (Patient_Id__c = pc[4].Id, Trial_Id__c = tri.Id, Site__c = site.Id));      
       insert tp;
        List<CRF__c> crf = new List<CRF__c>();
        crf.add(new CRF__c(Type__c = 'TissueSpecimenDetail__c', Status__c = 'Approval Not Required', Patient__c = pc[2].id));             
        crf.add(new CRF__c(Type__c = 'PreEligibility_Checklist__c', Status__c = 'Accepted' , Patient__c = pc[0].id));             
        crf.add(new CRF__c(Type__c = 'Registration__c', Status__c = 'Approval Not Required', Patient__c = pc[1].id));             
        insert crf;
       
        List<Off_Study_Detail__c> off = new List<Off_Study_Detail__c>();
       off.add(new Off_Study_Detail__c(Status__c ='Accepted', TrialPatient__c = tp[0].Id, CRF__c = crf[0].Id));
       off.add(new Off_Study_Detail__c(Status__c ='Accepted', TrialPatient__c = tp[1].Id, CRF__c = crf[1].Id));
       off.add(new Off_Study_Detail__c(Status__c ='Not Accepted', TrialPatient__c = tp[2].Id, CRF__c = crf[2].Id));
        off.add(new Off_Study_Detail__c(Status__c ='Not Accepted', TrialPatient__c = tp[3].Id, CRF__c = crf[0].Id));
        insert off;
       List<Randomization_Form__c> rf = new List<Randomization_Form__c>();
       rf.add(new Randomization_Form__c(Randomization_Result__c = 'Paclitaxel', Status__c = 'Approval Not Required', Did_Patient_Sign_Treatment_Consent_Form__c = true,TrialPatient__c = tp[0].Id ));
       rf.add(new Randomization_Form__c(Randomization_Result__c = 'Paclitaxel', Status__c = 'Approval Not Required', Did_Patient_Sign_Treatment_Consent_Form__c = true,TrialPatient__c = tp[1].Id  ));
       rf.add(new Randomization_Form__c(Randomization_Result__c = 'Paclitaxel', Status__c = 'Approval Not Required', Did_Patient_Sign_Treatment_Consent_Form__c = true,TrialPatient__c = tp[2].Id  ));
       rf.add(new Randomization_Form__c(Randomization_Result__c = 'Paclitaxel', Status__c = 'Approval Not Required', Did_Patient_Sign_Treatment_Consent_Form__c = true,TrialPatient__c = tp[3].Id  ));
       insert rf;
       
       /*  List<ArmPatient__c> apc = new list<ArmPatient__c>();
       apc.add(new ArmPatient__c(TrialPatient__c = tp[0], CreatedDate = Syste.Today(),Subject_Id__c = pc[0].Id, Patient_Id__c = pc[0].Id));
       apc.add(new ArmPatient__c(TrialPatient__c = tp[1], CreatedDate = Syste.Today(),Subject_Id__c = pc[1].Id, Patient_Id__c = pc[1].Id));
       apc.add(new ArmPatient__c(TrialPatient__c = tp[2], CreatedDate = Syste.Today(),Subject_Id__c = pc[2].Id, Patient_Id__c = pc[2].Id));
       insert apc; */
       ApexPages.CurrentPage().getParameters().put('drilldown', 'In Treatment');
       ScreenedInTreatmentOffStudyDrillDown sto=new  ScreenedInTreatmentOffStudyDrillDown();
      
   
   }
    public static testMethod void TestScreenedInTreatmentOffStudyDrillDown2(){
      
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
       
      
        Trial__c tri = new Trial__c();
        tri.Name = 'test';
        insert tri;
       
       List<TrialPatient__c > tp = new List<TrialPatient__c >();
       tp.add(new TrialPatient__c (Patient_Id__c = pc[0].Id, Trial_Id__c = tri.Id, Site__c = site.Id));    
       tp.add(new TrialPatient__c (Patient_Id__c = pc[1].Id, Trial_Id__c = tri.Id, Site__c = site.Id));    
       tp.add(new TrialPatient__c (Patient_Id__c = pc[2].Id, Trial_Id__c = tri.Id, Site__c = site.Id));    
       tp.add(new TrialPatient__c (Patient_Id__c = pc[4].Id, Trial_Id__c = tri.Id, Site__c = site.Id));      
       insert tp;
        List<CRF__c> crf = new List<CRF__c>();
        crf.add(new CRF__c(Type__c = 'TissueSpecimenDetail__c', Status__c = 'Approval Not Required', Patient__c = pc[2].id));             
        crf.add(new CRF__c(Type__c = 'PreEligibility_Checklist__c', Status__c = 'Accepted' , Patient__c = pc[0].id));             
        crf.add(new CRF__c(Type__c = 'Registration__c', Status__c = 'Approval Not Required', Patient__c = pc[1].id));             
        insert crf;
       
        List<Off_Study_Detail__c> off = new List<Off_Study_Detail__c>();
       off.add(new Off_Study_Detail__c(Status__c ='Accepted', TrialPatient__c = tp[0].Id, CRF__c = crf[0].Id));
       off.add(new Off_Study_Detail__c(Status__c ='Accepted', TrialPatient__c = tp[1].Id, CRF__c = crf[1].Id));
       off.add(new Off_Study_Detail__c(Status__c ='Not Accepted', TrialPatient__c = tp[2].Id, CRF__c = crf[2].Id));
        off.add(new Off_Study_Detail__c(Status__c ='Not Accepted', TrialPatient__c = tp[3].Id, CRF__c = crf[0].Id));
        insert off;
       List<Randomization_Form__c> rf = new List<Randomization_Form__c>();
       rf.add(new Randomization_Form__c(Randomization_Result__c = 'Paclitaxel', Status__c = 'Approval Not Required', Did_Patient_Sign_Treatment_Consent_Form__c = true,TrialPatient__c = tp[0].Id ));
       rf.add(new Randomization_Form__c(Randomization_Result__c = 'Paclitaxel', Status__c = 'Approval Not Required', Did_Patient_Sign_Treatment_Consent_Form__c = true,TrialPatient__c = tp[1].Id  ));
       rf.add(new Randomization_Form__c(Randomization_Result__c = 'Paclitaxel', Status__c = 'Approval Not Required', Did_Patient_Sign_Treatment_Consent_Form__c = true,TrialPatient__c = tp[2].Id  ));
       rf.add(new Randomization_Form__c(Randomization_Result__c = 'Paclitaxel', Status__c = 'Approval Not Required', Did_Patient_Sign_Treatment_Consent_Form__c = true,TrialPatient__c = tp[3].Id  ));
       insert rf;
       
     /*  List<ArmPatient__c> apc = new list<ArmPatient__c>();
       apc.add(new ArmPatient__c(TrialPatient__c = tp[0], CreatedDate = Syste.Today(),Subject_Id__c = pc[0].Id, Patient_Id__c = pc[0].Id));
       apc.add(new ArmPatient__c(TrialPatient__c = tp[1], CreatedDate = Syste.Today(),Subject_Id__c = pc[1].Id, Patient_Id__c = pc[1].Id));
       apc.add(new ArmPatient__c(TrialPatient__c = tp[2], CreatedDate = Syste.Today(),Subject_Id__c = pc[2].Id, Patient_Id__c = pc[2].Id));
       insert apc; */
       ScreenedInTreatmentOffStudyDrillDown sto=new  ScreenedInTreatmentOffStudyDrillDown();
      
   
   }
}