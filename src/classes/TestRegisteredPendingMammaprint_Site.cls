@isTest
public class TestRegisteredPendingMammaprint_Site{
   public static testMethod void TestRegisteredPendingMammaprint_Site(){
   
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
          
          MammaPrintDetail__c mp =new MammaPrintDetail__c();
       mp.TrialPatient__c =tp.Id;
       mp.Status__c='Approval Not Required';
       insert mp;
          
      Registration__c reg= new  Registration__c();
      reg.site__c= st.Id;
      reg.IRB_Approval_Date__c=system.today();
      reg.Screening_Informed_Consent_Date__c =system.today();
      reg.HIPPA_Consent_Date__c =system.today();
      reg.Patient__c=p.Id;
      reg.Trial__c=tri.Id;
      reg.TrialPatient__c=tp.Id;
      reg.Status__c='Approval Not Required';
      reg.Registration_Date__c=system.today();
      
      //reg.Site__r.name='Test';
      insert reg;
    
        
        RegisteredPendingMammaprint_Site rpm= new  RegisteredPendingMammaprint_Site();
        rpm.siteUserData();
        rpm.dccUserData();
   }
}