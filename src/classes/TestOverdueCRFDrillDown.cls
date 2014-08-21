@isTest
public class TestOverdueCRFDrillDown{
  public static testMethod void TestOverdueCRFDrillDown(){
     
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
        
        Phase_Master__c phase = new Phase_Master__c(Name='testPhase', Order__c =1);
        insert phase;  
        List<TrialPatient__c > tp = new List<TrialPatient__c >();
        tp.add(new TrialPatient__c (Patient_Id__c = pc[0].Id, Trial_Id__c = tri.Id, Site__c = st.Id,Phase_Master__c = phase.Id));    
        tp.add(new TrialPatient__c (Patient_Id__c = pc[1].Id, Trial_Id__c = tri.Id, Site__c = st.Id,Phase_Master__c = phase.Id));    
        tp.add(new TrialPatient__c (Patient_Id__c = pc[2].Id, Trial_Id__c = tri.Id, Site__c = st.Id,Phase_Master__c = phase.Id));    
        tp.add(new TrialPatient__c (Patient_Id__c = pc[3].Id, Trial_Id__c = tri.Id, Site__c = st.Id,Phase_Master__c = phase.Id));      
        insert tp;
       
        List<CRF__c> crf = new List<CRF__c>();
        crf.add(new CRF__c(Type__c = 'TissueSpecimenDetail__c', Status__c = 'Approval Not Required',Phase__c='Test Phase',TrialPatient__c=tp[0].Id, Patient__c = pc[4].id)); 
        crf.add(new CRF__c(Type__c = 'Randomization_Form__c', Status__c = 'Approval Not Required',Phase__c='Test Phase',TrialPatient__c=tp[1].Id, Patient__c = pc[3].id));            
        crf.add(new CRF__c(Type__c = 'PreEligibility_Checklist__c', Status__c = 'Accepted' ,Phase__c='Test Phase',TrialPatient__c=tp[2].Id, Patient__c = pc[0].id));             
        crf.add(new CRF__c(Type__c = 'Registration__c', Status__c = 'Approval Not Required',Phase__c='Test Phase',TrialPatient__c=tp[3].Id, Patient__c = pc[1].id));             
        insert crf;
        Registration__c reg= new  Registration__c();
        reg.site__c= st.Id;
        reg.IRB_Approval_Date__c=system.today();
        reg.Screening_Informed_Consent_Date__c =system.today();
        reg.HIPPA_Consent_Date__c =system.today();
        reg.Patient__c=pc[0].Id;
        reg.Trial__c=tri.Id;
        reg.TrialPatient__c = tp[0].Id;
        reg.Registration_Date__c = system.today();
      //reg.Site__r.name='Test';
      insert reg;
     
      List<Task> task=new List<Task>();
     
       task.add(new Task(Subject='Sample Task',Original_Due_Date__c=System.today()-1,OwnerId = UserInfo.getUserId(),Status='In Progress',CRF_Form_Id__c=reg.Id,WhatId=pc[0].Id, Object_Name__c = 'TEst Object'));
       insert task;
       OverdueCRFDrillDown ocd0= new OverdueCRFDrillDown();
       ApexPages.currentpage().getparameters().put('drilldown',''+st.Name);
       
       OverdueCRFDrillDown ocd= new OverdueCRFDrillDown();
      /* set<Id> registrationId = new set<Id>();
       for(Task task1: task){
            registrationId.add(task1.whatId);  
        }
       List<CRF__c>  r  = [Select TrialPatient__r.Phase_Master__r.Name, Type__c, TrialPatient__r.Subject_Id__c from CRF__c where Patient__c in:registrationId and TrialPatient__r.site__c != null and TrialPatient__r.Phase_Master__r.Name !=null ];
      System.assert(false,r); */
  } 
}