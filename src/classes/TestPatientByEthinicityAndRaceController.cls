@isTest
public class  TestPatientByEthinicityAndRaceController{
  public static testMethod void test(){
          Account acc = new Account(Name='TEst Institution');
        insert acc;
        Date d= Date.Today();
        Patient_Custom__c patient= new Patient_Custom__c(Last_Name__c = 'Test last', Birthdate__c = d  ,Ethnicity__c='Hispanic or Latino', Age_Group__c = '20-30', Race__c = 'Asian' , Institution__c = acc.id);
        insert patient;
        Patient_Custom__c patient1= new Patient_Custom__c(Last_Name__c = 'Test last1', Birthdate__c = d  ,Ethnicity__c='Hispanic or Latino', Age_Group__c = '30-40', Race__c = 'Asian' , Institution__c = acc.id);
        insert patient1;
        Patient_Custom__c patient2= new Patient_Custom__c(Last_Name__c = 'Test last2', Birthdate__c = d  ,Ethnicity__c='Non Hispanic or Latino', Age_Group__c = '40-50', Race__c = 'Asian' , Institution__c = acc.id);
        insert patient2;
        Patient_Custom__c patient3= new Patient_Custom__c(Last_Name__c = 'Test last3', Birthdate__c = d  ,Ethnicity__c='NOn Hispanic or Latino', Age_Group__c = '50-60', Race__c = 'Asian' , Institution__c = acc.id);
        insert patient3;
        Patient_Custom__c patient4= new Patient_Custom__c(Last_Name__c = 'Test last4', Birthdate__c = d  ,Ethnicity__c='Hispanic or Latino', Age_Group__c = '60-70', Race__c = 'Asian' , Institution__c = acc.id);
        insert patient4;
        Patient_Custom__c patient5= new Patient_Custom__c(Last_Name__c = 'Test last5', Birthdate__c = d  ,Ethnicity__c='Hispanic or Latino', Age_Group__c = '70-80', Race__c = 'Asian' , Institution__c = acc.id);
        insert patient5;
        Patient_Custom__c patient6= new Patient_Custom__c(Last_Name__c = 'Test last6', Birthdate__c = d  ,Ethnicity__c='Hispanic or Latino', Age_Group__c = '80-90', Race__c = 'Asian' , Institution__c = acc.id);
        insert patient6;
        PatientByEthinicityAndRaceController per1 = new PatientByEthinicityAndRaceController();
        PageReference pageRef = Page.PatientByAgeEthinicity;
        pageRef.getParameters().put('institute', String.valueOf(acc.Id));
        Test.setCurrentPageReference(pageRef); 
       PatientByEthinicityAndRaceController per = new PatientByEthinicityAndRaceController();
        
        
  }
}