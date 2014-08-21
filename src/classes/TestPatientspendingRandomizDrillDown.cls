@isTest
public class TestPatientspendingRandomizDrillDown{
   public static testMethod void TestPatientspendingRandomizDrillDown(){
       Account acc= new Account();
         acc.Name='Test';
         insert acc;
         
         Site__c st = new Site__c(Name = 'Test Site');
         st.Institute__c = acc.Id;
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
       
        List<CRF__c> crf = new List<CRF__c>();
        crf.add(new CRF__c(Complete_Date__c = System.Today(),Type__c = 'TissueSpecimenDetail__c', Status__c = 'Approval Not Required', Patient__c = pc[4].id));             
        crf.add(new CRF__c(Complete_Date__c = System.Today(),Type__c = 'PreEligibility_Checklist__c', Status__c = 'Accepted' , Patient__c = pc[0].id));             
        crf.add(new CRF__c(Complete_Date__c = System.Today(),Type__c = 'Registration__c', Status__c = 'Approval Not Required', Patient__c = pc[1].id));             
        insert crf;
         Trial__c tri = new Trial__c();
          tri.Name = 'test';
          insert tri;
       List<TrialPatient__c > tp = new List<TrialPatient__c >();
       tp.add(new TrialPatient__c (Patient_Id__c = pc[0].Id, Trial_Id__c = tri.Id, Site__c = st.Id));    
       tp.add(new TrialPatient__c (Patient_Id__c = pc[1].Id, Trial_Id__c = tri.Id, Site__c = st.Id));    
       tp.add(new TrialPatient__c (Patient_Id__c = pc[2].Id, Trial_Id__c = tri.Id, Site__c = st.Id));    
       tp.add(new TrialPatient__c (Patient_Id__c = pc[4].Id, Trial_Id__c = tri.Id, Site__c = st.Id));      
       insert tp;
       
          ApexPages.CurrentPage().getParameters().put('drilldown',''+st.Name);
        PatientspendingRandomizationDrillDown psr= new PatientspendingRandomizationDrillDown();
           
   }
  
}