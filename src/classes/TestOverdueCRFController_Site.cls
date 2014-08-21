@isTest
public class TestOverdueCRFController_Site{

    public static testMethod void test(){
         Account ac= new Account();
         ac.Name='Test';
         insert ac;
         
         Site__c st = new Site__c();
         st.Institute__c = ac.Id;
         insert st;
        
        Trial__c tc= new Trial__c();
        insert tc;
         
        Patient_Custom__c pc=new Patient_Custom__c();
        pc.Institution__c=ac.Id;
        pc.Last_Name__c='test1';
        pc.Gender__c='male';
        pc.Birthdate__c=system.today();
        pc.Race__c='hii';
        pc.Ethnicity__c='hello'; 
        insert pc;
         
        
         
        BaselineSymptomsForm__c bsf = new BaselineSymptomsForm__c();
        insert bsf;
        
        TrialPatient__c tpObj = new TrialPatient__c();
        tpObj.Patient_Id__c = pc.Id;    
        tpObj.Trial_Id__c = tc.Id;
        tpObj.Site__c = st.Id;
        insert tpObj;
        
        Registration__c reg= new  Registration__c();
        reg.site__c= st.Id;
        reg.IRB_Approval_Date__c=system.today();
        reg.Screening_Informed_Consent_Date__c =system.today();
        reg.HIPPA_Consent_Date__c =system.today();
        reg.Patient__c=pc.Id;
        reg.Trial__c=tc.Id;
        reg.TrialPatient__c = tpObj.Id;
        reg.Registration_Date__c = system.today();
      //reg.Site__r.name='Test';
      insert reg;
        
        CRF__c crf = new CRF__c();
        crf.type__c = 'PreEligibility_Checklist__c';
        crf.Patient__c = pc.Id; 
        insert crf;
     
        List<Task> task=new List<Task>();
     
        task.add(new Task(Subject='Sample Task',Original_Due_Date__c=System.today()-10,OwnerId = UserInfo.getUserId(),Status='In Progress',CRF_Form_Id__c=reg.Id,WhatId=pc.Id, Object_Name__c = 'TEst Object'));
        insert task;
         
         OverdueCRFController_Site overdue1 = new OverdueCRFController_Site();
         ApexPages.CurrentPage().getParameters().put('Site','\''+st.Id+'\'');
         ApexPages.CurrentPage().getParameters().put('tabular','yes');
         OverdueCRFController_Site overdue = new OverdueCRFController_Site();
         
    }
}