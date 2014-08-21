@isTest
public class  TestpretreatmentCompltMammafilled{
  public static testMethod void test(){
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
       
       List<TissueSpecimenDetail__c > ts = new List<TissueSpecimenDetail__c >();
        ts.add(new TissueSpecimenDetail__c (ProcedureDate__c = System.Today(),Time_Point__c  = 'Pre-Treatment',CRFId__c= crf[0].Id,  TrialPatient__c = tp[0].Id));             
        ts.add(new TissueSpecimenDetail__c (ProcedureDate__c = System.Today(),Time_Point__c  = 'Pre-Treatment',CRFId__c= crf[1].Id,  TrialPatient__c = tp[1].Id));             
        ts.add(new TissueSpecimenDetail__c (ProcedureDate__c = System.Today(),Time_Point__c  = 'Pre-Treatment',CRFId__c= crf[2].Id,   TrialPatient__c = tp[2].Id));             
        insert ts;
        
         List<MammaPrintDetail__c > mp = new List<MammaPrintDetail__c >();
        mp.add(new MammaPrintDetail__c (Status__c = 'Completed', Tissue_Specimen_Detail__c = ts[0].id,  TrialPatient__c = tp[0].Id));             
        mp.add(new MammaPrintDetail__c (Status__c = 'Completed', Tissue_Specimen_Detail__c  = ts[1].id, TrialPatient__c = tp[1].Id));  
        mp.add(new MammaPrintDetail__c (Status__c = 'Completed', Tissue_Specimen_Detail__c  = ts[2].id,  TrialPatient__c = tp[2].Id));  
        insert mp;
        pretreatmentCompltMammafilledController pcm1 = new  pretreatmentCompltMammafilledController();
          ApexPages.CurrentPage().getParameters().put('site','\''+st.Id+'\'');
        pretreatmentCompltMammafilledController pcm = new  pretreatmentCompltMammafilledController();
        
        
  }
}