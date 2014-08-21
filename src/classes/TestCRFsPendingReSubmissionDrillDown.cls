@isTest
public class TestCRFsPendingReSubmissionDrillDown{
   public static testMethod void TestCRFsPendingReSubmissionDrillDown(){
        ApexPages.CurrentPage().getParameters().put('drilldown','Test Phase');
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
          
          TrialPatient__c tp = new TrialPatient__c(Site__c = st.Id);
          tp.Patient_Id__c = p.Id;
          tp.Trial_Id__c = tri.Id;
          tp.Site__c = site.Id;
          
          insert tp;
          
          CRF__c crf = new CRF__c();
          crf.TrialPatient__c = tp.Id;
          crf.Trial__c = tri.Id;
          crf.Patient__c = p.Id;
          crf.Phase__c = 'Test Phase';
          crf.Status__c = 'Rejected';
          crf.Type__c = 'Pre __c';
          crf.Complete_Date__c = System.Today();
          insert crf;
         
         CRFsPendingReSubmissionDrillDown crd =new CRFsPendingReSubmissionDrillDown();
   }
}