@isTest
public class  TestProtocolViolationsController{
  public static testMethod void test(){
      try{
           Account acc= new Account();
         acc.Name='Test';
         insert acc;
         
         Site__c st = new Site__c();
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
        crf.add(new CRF__c(Type__c = 'TissueSpecimenDetail__c', Status__c = 'Approval Not Required', Patient__c = pc[4].id));             
        crf.add(new CRF__c(Type__c = 'PreEligibility_Checklist__c', Status__c = 'Accepted' , Patient__c = pc[0].id));             
        crf.add(new CRF__c(Type__c = 'Registration__c', Status__c = 'Approval Not Required', Patient__c = pc[1].id));             
        insert crf;
        
        ProtocolViolationDetail__c pvc = new ProtocolViolationDetail__c(CRFId__c = crf[0].Id , Patient__c =  pc[0].id, Incorrect_therapy_given_to_patient__c = true , Eligibility_criteria_exception__c = false, On_study_procedure_required_by_protocol__c = true);
        insert pvc;
       
          ProtocolViolationsController p0 = new ProtocolViolationsController();
          ApexPages.CurrentPage().getParameters().put('Site','\''+st.Id+'\'');
          ProtocolViolationsController p = new ProtocolViolationsController();
     }
     Catch(Exception e){
         System.assert(false,e.getstacktracestring()+''+e);
     }
  }
}