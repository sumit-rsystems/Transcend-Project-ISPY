@isTest
public class TestPatientBySiteDCC{
  public static testMethod void TestPatientBySiteDCC(){
        Account ac= new Account();
        ac.Name='Test';
        insert ac;
      
        Patient_Custom__c pc=new Patient_Custom__c();
        pc.Institution__c=ac.Id;
        pc.Last_Name__c='test1';
        pc.Gender__c='male';
        pc.Birthdate__c=system.today();
        pc.Race__c='hii';
        pc.Ethnicity__c='hello'; 
        insert pc;
        
        Trial__c tc= new Trial__c();
        insert tc;
        
        Site__c st = new Site__c();
        st.Institute__c=ac.Id;
        insert st;
        
        TrialPatient__c tp= new TrialPatient__c();
        tp.Site__c=st.Id;
        tp.Trial_Id__c=tc.Id;
        tp.Patient_Id__c=pc.Id;
        insert tp;
        
        PatientBySiteDCC ps= new PatientBySiteDCC();
        
  
  }
}