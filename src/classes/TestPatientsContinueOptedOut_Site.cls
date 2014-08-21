@isTest
public class TestPatientsContinueOptedOut_Site{
  public static testMethod void TestPatientsContinueOptedOut_Site(){
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
       tp.add(new TrialPatient__c (Patient_Id__c = pc[0].Id, Trial_Id__c = tri.Id, Site__c = st.Id));    
       tp.add(new TrialPatient__c (Patient_Id__c = pc[1].Id, Trial_Id__c = tri.Id, Site__c = st.Id));    
       tp.add(new TrialPatient__c (Patient_Id__c = pc[2].Id, Trial_Id__c = tri.Id, Site__c = st.Id));    
       tp.add(new TrialPatient__c (Patient_Id__c = pc[3].Id, Trial_Id__c = tri.Id, Site__c = st.Id));      
       insert tp;
       
       List<Off_Study_Detail__c> off = new List<Off_Study_Detail__c>();
       off.add(new Off_Study_Detail__c(Status__c ='Accepted', TrialPatient__c = tp[0].Id));
       off.add(new Off_Study_Detail__c(Status__c ='Accepted', TrialPatient__c = tp[1].Id));
       off.add(new Off_Study_Detail__c(Status__c ='Not Accepted', TrialPatient__c = tp[2].Id));
        off.add(new Off_Study_Detail__c(Status__c ='Not Accepted', TrialPatient__c = tp[3].Id));
       List<Randomization_Form__c> rf = new List<Randomization_Form__c>();
       rf.add(new Randomization_Form__c(Randomization_Result__c = 'Paclitaxel', Status__c = 'Approval Not Required', Did_Patient_Sign_Treatment_Consent_Form__c = true,TrialPatient__c = tp[0].Id ));
       rf.add(new Randomization_Form__c(Randomization_Result__c = 'Paclitaxel', Status__c = 'Approval Not Required', Did_Patient_Sign_Treatment_Consent_Form__c = true,TrialPatient__c = tp[1].Id  ));
       rf.add(new Randomization_Form__c(Randomization_Result__c = 'Paclitaxel', Status__c = 'Approval Not Required', Did_Patient_Sign_Treatment_Consent_Form__c = true,TrialPatient__c = tp[2].Id  ));
       rf.add(new Randomization_Form__c(Randomization_Result__c = 'Paclitaxel', Status__c = 'Approval Not Required', Did_Patient_Sign_Treatment_Consent_Form__c = true,TrialPatient__c = tp[3].Id  ));
       insert rf;
  
    PatientsContinueOptedOut_Site pco= new PatientsContinueOptedOut_Site();
    pco.siteUserData();
    
  }
}