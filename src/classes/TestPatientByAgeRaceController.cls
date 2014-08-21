@isTest
public class TestPatientByAgeRaceController{
 public static testMethod void test(){
          Account acc = new Account(Name = 'Test Account');
      insert acc;
      Site__c site = new Site__c(Name = 'Test Site', Institute__c = acc.Id);
      insert site;
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
        
        List<TrialPatient__c> tp = new List<TrialPatient__c>();
        tp.add(new TrialPatient__c(Patient_Id__c = p.Id, Trial_Id__c = tri.Id, Site__c = site.Id ));      
        tp.add(new TrialPatient__c(Patient_Id__c = pc[0].Id, Trial_Id__c = tri.Id, Site__c = site.Id ));
        tp.add(new TrialPatient__c(Patient_Id__c = pc[1].Id, Trial_Id__c = tri.Id, Site__c = site.Id ));      
        tp.add(new TrialPatient__c(Patient_Id__c = pc[2].Id, Trial_Id__c = tri.Id, Site__c = site.Id ));      
        tp.add(new TrialPatient__c(Patient_Id__c = pc[3].Id, Trial_Id__c = tri.Id, Site__c = site.Id ));            
        tp.add(new TrialPatient__c(Patient_Id__c = pc[4].Id, Trial_Id__c = tri.Id, Site__c = site.Id ));            
        tp.add(new TrialPatient__c(Patient_Id__c = pc[5].Id, Trial_Id__c = tri.Id, Site__c = site.Id ));            
          insert tp;
       PatientByAgeRaceController prc1 = new PatientByAgeRaceController();
        PageReference pageRef = Page.PatientByAgeEthinicity;
        pageRef.getParameters().put('institute', String.valueOf(acc.Id));
        Test.setCurrentPageReference(pageRef); 
        
       PatientByAgeRaceController prc = new PatientByAgeRaceController();
 }
}