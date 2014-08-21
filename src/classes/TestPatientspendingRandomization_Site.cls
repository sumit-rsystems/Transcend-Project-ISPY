@isTest
public class TestPatientspendingRandomization_Site{
  public static testMethod void TestPatientspendingRandomization_Site(){
     
         Account acc= new Account();
         acc.Name='Test';
         insert acc;
         
         Site__c st = new Site__c();
         st.Institute__c = acc.Id;
         st.Name='Test';
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
       
        List<CRF__c> crf = new List<CRF__c>();
        crf.add(new CRF__c(Type__c = 'TissueSpecimenDetail__c', Status__c = 'Approval Not Required',Phase__c='Test Phase',TrialPatient__c=tp[0].Id, Patient__c = pc[4].id)); 
        crf.add(new CRF__c(Type__c = 'Randomization_Form__c', Status__c = 'Approval Not Required',Phase__c='Test Phase',TrialPatient__c=tp[1].Id, Patient__c = pc[3].id));            
        crf.add(new CRF__c(Type__c = 'PreEligibility_Checklist__c', Status__c = 'Accepted' ,Phase__c='Test Phase',TrialPatient__c=tp[2].Id, Patient__c = pc[0].id));             
        crf.add(new CRF__c(Type__c = 'Registration__c', Status__c = 'Approval Not Required',Phase__c='Test Phase',TrialPatient__c=tp[3].Id, Patient__c = pc[1].id));             
        insert crf;
        
       
  
     PatientspendingRandomization_Site psr=new PatientspendingRandomization_Site();
     psr.siteUserData();
     psr.dccUserData();
  }
}