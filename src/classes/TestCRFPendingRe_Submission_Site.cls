@isTest
public class TestCRFPendingRe_Submission_Site{
  public static testMethod void TestCRFPendingRe_Submission_Site(){
     
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
          
          CRF__c crf = new CRF__c();
          crf.TrialPatient__c = tp.Id;
          crf.Trial__c = tri.Id;
          crf.Patient__c = p.Id;
          crf.type__c='test';
          //crf.Phase__c = 'Test Phase';
          crf.Status__c = 'Rejected';
          insert crf;
    
      CRFPendingRe_Submission_Site cs=new CRFPendingRe_Submission_Site();
      cs.siteUserData();
      cs.dccUserData();
  }
}