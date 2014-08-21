@isTest
public class TestPatientPhase_Site{
  public static testMethod void TestMethodPatientPhase_Site(){
     
        Account acc = new Account(Name = 'TEstAcc');
          insert acc;
          
          Phase_Master__c phase = new Phase_Master__c(Name ='Test Phase',  Order__c = 1 );

          insert phase;
          
          Patient_Custom__c p = new Patient_Custom__c();
          p.Birthdate__c = date.newInstance(1980, 08, 05);
          p.Institution__c = acc.Id;
          p.Last_Name__c = 'test'; 
          p.Gender__c = 'Male';
          p.Race__c = 'White';
          p.Ethnicity__c = 'Not Hispanic or Latino';
          p.Phase_Master__c = phase.id;
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
          PatientPhase_Site ps = new PatientPhase_Site();
          ps.siteUserData();
    }
}