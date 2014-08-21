/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the 
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class TestDCCApprovalController {

    @isTest static void myUnitTest() {
        // TO DO: implement unit test
        
        List<User> thisUser = [ select u.Id , u.IsActive from User u where profile.Name = 'System Administrator' and IsActive = true];
        System.runAs (thisUser[0]){
        
        Account inst = new Account();
        List<Account> lstAccount = [select Id from Account limit 1];
        if(!lstAccount.isEmpty()) {
        inst = lstAccount[0];
        
        Patient_Custom__c p = new Patient_Custom__c();
        p.Birthdate__c = date.newInstance(1960, 8, 7);
        p.Ethnicity__c = 'Hispanic or latino';
        p.Gender__c = 'female';
        p.Race__c = 'asian';
        p.Last_Name__c = 'kumar';
        p.Institution__c = inst.Id;
        insert p;
        
        Trial__c t = new Trial__c();
        t.Start_Date__c = system.today();
        insert t;

        TrialPatient__c tp = new TrialPatient__c();
        tp.Trial_Id__c = t.Id;
        tp.Patient_Id__c = p.Id;
        insert tp;
        
        Registration__c reg = new Registration__c();
        reg.Patient__c = p.Id;
        reg.Registration_Date__c = System.today();
        reg.Trial__c = t.Id;
        reg.TrialPatient__c = tp.Id;
        reg.Institution__c = inst.Id;
        reg.IRB_Approval_Date__c = System.today();
        reg.Screening_Informed_Consent_Date__c = System.today();
        reg.HIPPA_Consent_Date__c = System.today();
        reg.Effective_Time__c = system.now();
        reg.ISPY2_Subject_Id__c = ''+123;  
        insert reg;
        
        Menopausal_Status_Detail__c msd = new Menopausal_Status_Detail__c();
        msd.Menopausal_Status__c = 'Above categories not applicable AND Age < 50';
        msd.TrialPatient__c = tp.Id;
        msd.Status__c = 'Approval Pending';
        insert msd;
        update msd;
        
//===============================approval for Menopausal_Status_Detail__c=============================================================
        Apexpages.currentPage().getParameters().put('trialPat', tp.Id);
        Apexpages.currentPage().getParameters().put('recId', msd.Id);
        Apexpages.currentPage().getParameters().put('object','Menopausal_Status_Detail__c');
        DCCApprovalController dac1 = new DCCApprovalController();

      }
    }
  }
  @isTest static void myUnitTest1() {
        // TO DO: implement unit test
        
        List<User> thisUser = [ select u.Id , u.IsActive from User u where profile.Name = 'System Administrator' and IsActive = true];
        System.runAs (thisUser[0]){
        
        Account inst = new Account();
        List<Account> lstAccount = [select Id from Account limit 1];
        if(!lstAccount.isEmpty()) {
        inst = lstAccount[0];
        
        Patient_Custom__c p = new Patient_Custom__c();
        p.Birthdate__c = date.newInstance(1960, 8, 7);
        p.Ethnicity__c = 'Hispanic or latino';
        p.Gender__c = 'female';
        p.Race__c = 'asian';
        p.Last_Name__c = 'kumar';
        p.Institution__c = inst.Id;
        insert p;
        
        Trial__c t = new Trial__c();
        t.Start_Date__c = system.today();
        insert t;

        TrialPatient__c tp = new TrialPatient__c();
        tp.Trial_Id__c = t.Id;
        tp.Patient_Id__c = p.Id;
        insert tp;
        
        Registration__c reg = new Registration__c();
        reg.Patient__c = p.Id;
        reg.Registration_Date__c = System.today();
        reg.Trial__c = t.Id;
        reg.TrialPatient__c = tp.Id;
        reg.Institution__c = inst.Id;
        reg.IRB_Approval_Date__c = System.today();
        reg.Screening_Informed_Consent_Date__c = System.today();
        reg.HIPPA_Consent_Date__c = System.today();
        reg.Effective_Time__c = system.now();
        reg.ISPY2_Subject_Id__c = ''+123;
        insert reg;
        
        Response_Evaluation_Form__c ref = new Response_Evaluation_Form__c();
        ref.TrialPatient__c = tp.Id;
        ref.Status__c = 'Approval Pending';
        insert ref;
        update ref;
        
//===============================approval for Response_Evaluation_Form__c=============================================================
        Apexpages.currentPage().getParameters().put('trialPat', tp.Id);         
        Apexpages.currentPage().getParameters().put('recId', ref.Id);
        Apexpages.currentPage().getParameters().put('object', 'Response_Evaluation_Form__c');
        DCCApprovalController dac2 = new DCCApprovalController();
      }
    }
  }
  @isTest static void myUnitTest2() {
        // TO DO: implement unit test
        
        List<User> thisUser = [ select u.Id , u.IsActive from User u where profile.Name = 'System Administrator' and IsActive = true];
        System.runAs (thisUser[0]){
        
        Account inst = new Account();
        List<Account> lstAccount = [select Id from Account limit 1];
        if(!lstAccount.isEmpty()) {
        inst = lstAccount[0];
        
        Patient_Custom__c p = new Patient_Custom__c();
        p.Birthdate__c = date.newInstance(1960, 8, 7);
        p.Ethnicity__c = 'Hispanic or latino';
        p.Gender__c = 'female';
        p.Race__c = 'asian';
        p.Last_Name__c = 'kumar';
        p.Institution__c = inst.Id;
        insert p;
        
        Trial__c t = new Trial__c();
        t.Start_Date__c = system.today();
        insert t;
        
        TrialPatient__c tp = new TrialPatient__c();
        tp.Trial_Id__c = t.Id;
        tp.Patient_Id__c = p.Id;
        insert tp;
        
        Registration__c reg = new Registration__c();
        reg.Patient__c = p.Id;
        reg.Registration_Date__c = System.today();
        reg.Trial__c = t.Id;
        reg.TrialPatient__c = tp.Id;
        reg.Institution__c = inst.Id;
        reg.IRB_Approval_Date__c = System.today();
        reg.Screening_Informed_Consent_Date__c = System.today();
        reg.HIPPA_Consent_Date__c = System.today();
        reg.Effective_Time__c = system.now();
        reg.ISPY2_Subject_Id__c = ''+123;
        insert reg;
        
        On_Study_Eligibility_Form__c osef = new  On_Study_Eligibility_Form__c();
        osef.How_was_the_cancer_first_detected__c = 'Clinical exam';
        osef.Patient__c = p.Id;
        osef.Status__c = 'Approval Pending';
        osef.TrialPatient__c = tp.Id;
        insert osef;
        update osef;
        
        On_Study_Pathology_Form__c ospf = new On_Study_Pathology_Form__c();
        ospf.Does_the_patient_have_bilateral_breast_c__c = 'Yes'; //on study path
        ospf.Tumor_laterality__c = 'Left';
        ospf.TrialPatient__c = tp.Id;
        ospf.Status__c = 'Approval Pending';
        insert ospf;
        update ospf;
        
//===============================approval for On_Study_Eligibility_Form__c=============================================================         
        Apexpages.currentPage().getParameters().put('recId', osef.Id);
        Apexpages.currentPage().getParameters().put('object', 'On_Study_Eligibility_Form__c');
        //Apexpages.currentPage().getParameters().get('workItemId');
        DCCApprovalController dac3 = new DCCApprovalController();

//===============================approval for On_Study_Pathology_Form__c=============================================================           
        Apexpages.currentPage().getParameters().put('recId', ospf.Id);
        Apexpages.currentPage().getParameters().put('object', 'On_Study_Pathology_Form__c');
        //Apexpages.currentPage().getParameters().get('workItemId');
        DCCApprovalController dac4 = new DCCApprovalController();
            
      }
    }
  }
      @isTest static void myUnitTest3() {
        // TO DO: implement unit test
        
        List<User> thisUser = [ select u.Id , u.IsActive from User u where profile.Name = 'System Administrator' and IsActive = true];
        System.runAs (thisUser[0]){
        
        Account inst = new Account();
        List<Account> lstAccount = [select Id from Account limit 1];
        if(!lstAccount.isEmpty()) {
        inst = lstAccount[0];
        
        Patient_Custom__c p = new Patient_Custom__c();
        p.Birthdate__c = date.newInstance(1960, 8, 7);
        p.Ethnicity__c = 'Hispanic or latino';
        p.Gender__c = 'female';
        p.Race__c = 'asian';
        p.Last_Name__c = 'kumar';
        p.Institution__c = inst.Id;
        insert p;
        
        Trial__c t = new Trial__c();
        t.Start_Date__c = system.today();
        insert t;
        
        TrialPatient__c tp = new TrialPatient__c();
        tp.Trial_Id__c = t.Id;
        tp.Patient_Id__c = p.Id;
        insert tp;
        
        Registration__c reg = new Registration__c();
        reg.Patient__c = p.Id;
        reg.Registration_Date__c = System.today();
        reg.Trial__c = t.Id;
        reg.TrialPatient__c = tp.Id;
        reg.Institution__c = inst.Id;
        reg.IRB_Approval_Date__c = System.today();
        reg.Screening_Informed_Consent_Date__c = System.today();
        reg.HIPPA_Consent_Date__c = System.today();
        reg.Effective_Time__c = system.now();
        reg.ISPY2_Subject_Id__c = ''+123;
        insert reg;
        
        Lab_and_Test__c lat = new Lab_and_Test__c();
        lat.TrialPatient__c = tp.Id;
        lat.Status__c = 'Approval Pending';
        insert lat;
        update lat;
        
 //===============================approval for Lab_and_Test__c=============================================================  
        Apexpages.currentPage().getParameters().put('trialPat', tp.Id);       
        Apexpages.currentPage().getParameters().put('recId', lat.Id);
        Apexpages.currentPage().getParameters().put('object', 'Lab_and_Test__c');
        //Apexpages.currentPage().getParameters().get('workItemId');
        DCCApprovalController dac5 = new DCCApprovalController(); 
        

      }
    }
  }
  
  @isTest static void myUnitTest31() {
        // TO DO: implement unit test
        
        List<User> thisUser = [ select u.Id , u.IsActive from User u where profile.Name = 'System Administrator' and IsActive = true];
        System.runAs (thisUser[0]){
        
        Account inst = new Account();
        List<Account> lstAccount = [select Id from Account limit 1];
        if(!lstAccount.isEmpty()) {
        inst = lstAccount[0];
        
        Patient_Custom__c p = new Patient_Custom__c();
        p.Birthdate__c = date.newInstance(1960, 8, 7);
        p.Ethnicity__c = 'Hispanic or latino';
        p.Gender__c = 'female';
        p.Race__c = 'asian';
        p.Last_Name__c = 'kumar';
        p.Institution__c = inst.Id;
        insert p;
        
        Trial__c t = new Trial__c();
        t.Start_Date__c = system.today();
        insert t;
        
        TrialPatient__c tp = new TrialPatient__c();
        tp.Trial_Id__c = t.Id;
        tp.Patient_Id__c = p.Id;
        insert tp;
        
        Registration__c reg = new Registration__c();
        reg.Patient__c = p.Id;
        reg.Registration_Date__c = System.today();
        reg.Trial__c = t.Id;
        reg.TrialPatient__c = tp.Id;
        reg.Institution__c = inst.Id;
        reg.IRB_Approval_Date__c = System.today();
        reg.Screening_Informed_Consent_Date__c = System.today();
        reg.HIPPA_Consent_Date__c = System.today();
        reg.Effective_Time__c = system.now();
        reg.ISPY2_Subject_Id__c = ''+123;
        insert reg;
       
        
        Lab_and_Test__c lat = new Lab_and_Test__c();
        lat.TrialPatient__c = tp.Id;
        lat.Status__c = 'Approval Pending';
        insert lat;
        update lat;
        
 //===============================approval for Lab_and_Test__c=============================================================  
        Apexpages.currentPage().getParameters().put('trialPat', tp.Id);       
        Apexpages.currentPage().getParameters().put('recId', lat.Id);
        Apexpages.currentPage().getParameters().put('object', 'Lab_and_Test__c');
        //Apexpages.currentPage().getParameters().get('workItemId');
        DCCApprovalController dac5 = new DCCApprovalController(); 
        

      }
    }
  }
   
   @isTest static void myUnitTest32() {
        // TO DO: implement unit test
        
        List<User> thisUser = [ select u.Id , u.IsActive from User u where profile.Name = 'System Administrator' and IsActive = true];
        System.runAs (thisUser[0]){
        
        Account inst = new Account();
        List<Account> lstAccount = [select Id from Account limit 1];
        if(!lstAccount.isEmpty()) {
        inst = lstAccount[0];
        
        Patient_Custom__c p = new Patient_Custom__c();
        p.Birthdate__c = date.newInstance(1960, 8, 7);
        p.Ethnicity__c = 'Hispanic or latino';
        p.Gender__c = 'female';
        p.Race__c = 'asian';
        p.Last_Name__c = 'kumar';
        p.Institution__c = inst.Id;
        insert p;
        
        Trial__c t = new Trial__c();
        t.Start_Date__c = system.today();
        insert t;
        
        TrialPatient__c tp = new TrialPatient__c();
        tp.Trial_Id__c = t.Id;
        tp.Patient_Id__c = p.Id;
        insert tp;
        
        Registration__c reg = new Registration__c();
        reg.Patient__c = p.Id;
        reg.Registration_Date__c = System.today();
        reg.Trial__c = t.Id;
        reg.TrialPatient__c = tp.Id;
        reg.Institution__c = inst.Id;
        reg.IRB_Approval_Date__c = System.today();
        reg.Screening_Informed_Consent_Date__c = System.today();
        reg.HIPPA_Consent_Date__c = System.today();
        reg.Effective_Time__c = system.now();
        reg.ISPY2_Subject_Id__c = ''+123;
        insert reg;
        
        BaselineSymptomsForm__c bsf = new BaselineSymptomsForm__c();
        bsf.Visit_Date__c = system.today();
        bsf.TrialPatient__c = tp.Id;
        bsf.Status__c = 'Approval Pending';
        insert bsf;
        update bsf;
        //===============================approval for BaselineSymptomsForm__c=============================================================  
        Apexpages.currentPage().getParameters().put('trialPat', tp.Id);        
        Apexpages.currentPage().getParameters().put('recId', bsf.Id);
        Apexpages.currentPage().getParameters().put('object', 'BaselineSymptomsForm__c');
        //Apexpages.currentPage().getParameters().get('workItemId');
        DCCApprovalController dac6 = new DCCApprovalController();

      }
    }
  }
   @isTest static void myUnitTest33() {
        // TO DO: implement unit test
        
        List<User> thisUser = [ select u.Id , u.IsActive from User u where profile.Name = 'System Administrator' and IsActive = true];
        System.runAs (thisUser[0]){
        
        Account inst = new Account();
        List<Account> lstAccount = [select Id from Account limit 1];
        if(!lstAccount.isEmpty()) {
        inst = lstAccount[0];
        
        Patient_Custom__c p = new Patient_Custom__c();
        p.Birthdate__c = date.newInstance(1960, 8, 7);
        p.Ethnicity__c = 'Hispanic or latino';
        p.Gender__c = 'female';
        p.Race__c = 'asian';
        p.Last_Name__c = 'kumar';
        p.Institution__c = inst.Id;
        insert p;
        
        Trial__c t = new Trial__c();
        t.Start_Date__c = system.today();
        insert t;
        
        TrialPatient__c tp = new TrialPatient__c();
        tp.Trial_Id__c = t.Id;
        tp.Patient_Id__c = p.Id;
        insert tp;
        
        Registration__c reg = new Registration__c();
        reg.Patient__c = p.Id;
        reg.Registration_Date__c = System.today();
        reg.Trial__c = t.Id;
        reg.TrialPatient__c = tp.Id;
        reg.Institution__c = inst.Id;
        reg.IRB_Approval_Date__c = System.today();
        reg.Screening_Informed_Consent_Date__c = System.today();
        reg.HIPPA_Consent_Date__c = System.today();
        reg.Effective_Time__c = system.now();
        reg.ISPY2_Subject_Id__c = ''+123;
        insert reg;
        
     
        
        ProtocolViolationDetail__c pvd = new ProtocolViolationDetail__c();
        pvd.TrialPatient__c = tp.Id;
        pvd.Patient__c = p.Id;
        pvd.Status__c = 'Approval Pending';
        insert pvd;
        update pvd;
 
//===============================approval for ProtocolViolationDetail__c=============================================================   
        Apexpages.currentPage().getParameters().put('trialPat', tp.Id);        
        Apexpages.currentPage().getParameters().put('recId', pvd.Id);
        Apexpages.currentPage().getParameters().put('object', 'ProtocolViolationDetail__c');
        //Apexpages.currentPage().getParameters().get('workItemId');
        DCCApprovalController dac7 = new DCCApprovalController();
      }
    }
  }
  @isTest static void myUnitTest4() {
        // TO DO: implement unit test
        
        List<User> thisUser = [ select u.Id , u.IsActive from User u where profile.Name = 'System Administrator' and IsActive = true];
        System.runAs (thisUser[0]){
        
        Account inst = new Account();
        List<Account> lstAccount = [select Id from Account limit 1];
        if(!lstAccount.isEmpty()) {
        inst = lstAccount[0];
        
        Patient_Custom__c p = new Patient_Custom__c();
        p.Birthdate__c = date.newInstance(1960, 8, 7);
        p.Ethnicity__c = 'Hispanic or latino';
        p.Gender__c = 'female';
        p.Race__c = 'asian';
        p.Last_Name__c = 'kumar';
        p.Institution__c = inst.Id;
        insert p;
        
        Trial__c t = new Trial__c();
        t.Start_Date__c = system.today();
        insert t;
        
        TrialPatient__c tp = new TrialPatient__c();
        tp.Trial_Id__c = t.Id;
        tp.Patient_Id__c = p.Id;
        insert tp;
        
        Registration__c reg = new Registration__c();
        reg.Patient__c = p.Id;
        reg.Registration_Date__c = System.today();
        reg.Trial__c = t.Id;
        reg.TrialPatient__c = tp.Id;
        reg.Institution__c = inst.Id;
        reg.IRB_Approval_Date__c = System.today();
        reg.Screening_Informed_Consent_Date__c = System.today();
        reg.HIPPA_Consent_Date__c = System.today();
        reg.Effective_Time__c = system.now();
        reg.ISPY2_Subject_Id__c = ''+123;
        insert reg;
        
        AE_Detail__c ae = new AE_Detail__c();
        ae.Visit_Date__c = system.today();
        ae.TrialPatient__c = tp.Id;
        ae.Status__c = 'Approval Pending';
        insert ae;
        update ae;
        
        Chemo_Treatment__c ct = new Chemo_Treatment__c();
        ct.Date_of_therapy__c = system.today();
        ct.Cycle_number__c = 1;
        ct.TrialPatient__c = tp.Id;
        ct.Status__c = 'Approval Pending';
        insert ct;
        update ct;
        
        Chemo_Summary_Form__c cs = new Chemo_Summary_Form__c();
        cs.TrialPatient__c = tp.Id;
        cs.Status__c = 'Approval Pending';
        insert cs;
        update cs;
        
//===============================approval for AE_Detail__c=============================================================      
        Apexpages.currentPage().getParameters().put('trialPat', tp.Id);   
        Apexpages.currentPage().getParameters().put('recId', ae.Id);
        Apexpages.currentPage().getParameters().put('object', 'AE_Detail__c');
        //Apexpages.currentPage().getParameters().get('workItemId');
        DCCApprovalController dac8 = new DCCApprovalController();


      }
    }
  }
  @isTest static void myUnitTest41() {
        // TO DO: implement unit test
        
        List<User> thisUser = [ select u.Id , u.IsActive from User u where profile.Name = 'System Administrator' and IsActive = true];
        System.runAs (thisUser[0]){
        
        Account inst = new Account();
        List<Account> lstAccount = [select Id from Account limit 1];
        if(!lstAccount.isEmpty()) {
        inst = lstAccount[0];
        
        Patient_Custom__c p = new Patient_Custom__c();
        p.Birthdate__c = date.newInstance(1960, 8, 7);
        p.Ethnicity__c = 'Hispanic or latino';
        p.Gender__c = 'female';
        p.Race__c = 'asian';
        p.Last_Name__c = 'kumar';
        p.Institution__c = inst.Id;
        insert p;
        
        Trial__c t = new Trial__c();
        t.Start_Date__c = system.today();
        insert t;
        
        TrialPatient__c tp = new TrialPatient__c();
        tp.Trial_Id__c = t.Id;
        tp.Patient_Id__c = p.Id;
        insert tp;
        
        Registration__c reg = new Registration__c();
        reg.Patient__c = p.Id;
        reg.Registration_Date__c = System.today();
        reg.Trial__c = t.Id;
        reg.TrialPatient__c = tp.Id;
        reg.Institution__c = inst.Id;
        reg.IRB_Approval_Date__c = System.today();
        reg.Screening_Informed_Consent_Date__c = System.today();
        reg.HIPPA_Consent_Date__c = System.today();
        reg.Effective_Time__c = system.now();
        reg.ISPY2_Subject_Id__c = ''+123;
        insert reg;
        
        AE_Detail__c ae = new AE_Detail__c();
        ae.Visit_Date__c = system.today();
        ae.TrialPatient__c = tp.Id;
        ae.Status__c = 'Approval Pending';
        insert ae;
        update ae;
        
        Chemo_Treatment__c ct = new Chemo_Treatment__c();
        ct.Date_of_therapy__c = system.today();
        ct.Cycle_number__c = 1;
        ct.TrialPatient__c = tp.Id;
        ct.Status__c = 'Approval Pending';
        insert ct;
        update ct;
        
        Chemo_Summary_Form__c cs = new Chemo_Summary_Form__c();
        cs.TrialPatient__c = tp.Id;
        cs.Status__c = 'Approval Pending';
        insert cs;
        update cs;
//===============================approval for Chemo_Treatment__c=============================================================    
        Apexpages.currentPage().getParameters().put('trialPat', tp.Id);       
        Apexpages.currentPage().getParameters().put('recId', ct.Id);
        Apexpages.currentPage().getParameters().put('object', 'Chemo_Treatment__c');
        //Apexpages.currentPage().getParameters().get('workItemId');
        DCCApprovalController dac9 = new DCCApprovalController();
            

            
      }
    }
  }@isTest static void myUnitTest42() {
        // TO DO: implement unit test
        
        List<User> thisUser = [ select u.Id , u.IsActive from User u where profile.Name = 'System Administrator' and IsActive = true];
        System.runAs (thisUser[0]){
        
        Account inst = new Account();
        List<Account> lstAccount = [select Id from Account limit 1];
        if(!lstAccount.isEmpty()) {
        inst = lstAccount[0];
        
        Patient_Custom__c p = new Patient_Custom__c();
        p.Birthdate__c = date.newInstance(1960, 8, 7);
        p.Ethnicity__c = 'Hispanic or latino';
        p.Gender__c = 'female';
        p.Race__c = 'asian';
        p.Last_Name__c = 'kumar';
        p.Institution__c = inst.Id;
        insert p;
        
        Trial__c t = new Trial__c();
        t.Start_Date__c = system.today();
        insert t;
        
        TrialPatient__c tp = new TrialPatient__c();
        tp.Trial_Id__c = t.Id;
        tp.Patient_Id__c = p.Id;
        insert tp;
        
        Registration__c reg = new Registration__c();
        reg.Patient__c = p.Id;
        reg.Registration_Date__c = System.today();
        reg.Trial__c = t.Id;
        reg.TrialPatient__c = tp.Id;
        reg.Institution__c = inst.Id;
        reg.IRB_Approval_Date__c = System.today();
        reg.Screening_Informed_Consent_Date__c = System.today();
        reg.HIPPA_Consent_Date__c = System.today();
        reg.Effective_Time__c = system.now();
        reg.ISPY2_Subject_Id__c = ''+123;
        insert reg;
        
        AE_Detail__c ae = new AE_Detail__c();
        ae.Visit_Date__c = system.today();
        ae.TrialPatient__c = tp.Id;
        ae.Status__c = 'Approval Pending';
        insert ae;
        update ae;
        
        Chemo_Treatment__c ct = new Chemo_Treatment__c();
        ct.Date_of_therapy__c = system.today();
        ct.Cycle_number__c = 1;
        ct.TrialPatient__c = tp.Id;
        ct.Status__c = 'Approval Pending';
        insert ct;
        update ct;
        
        Chemo_Summary_Form__c cs = new Chemo_Summary_Form__c();
        cs.TrialPatient__c = tp.Id;
        cs.Status__c = 'Approval Pending';
        insert cs;
        update cs;
        //===============================approval for Chemo_Summary_Form__c=============================================================     
        Apexpages.currentPage().getParameters().put('trialPat', tp.Id);       
        Apexpages.currentPage().getParameters().put('recId', cs.Id);
        Apexpages.currentPage().getParameters().put('object', 'Chemo_Summary_Form__c');
        //Apexpages.currentPage().getParameters().get('workItemId');
        DCCApprovalController dac10 = new DCCApprovalController();
            
      }
    }
  } 
  @isTest static void myUnitTest5() {
        // TO DO: implement unit test
        
        List<User> thisUser = [ select u.Id , u.IsActive from User u where profile.Name = 'System Administrator' and IsActive = true];
        System.runAs (thisUser[0]){
        
        Account inst = new Account();
        List<Account> lstAccount = [select Id from Account limit 1];
        if(!lstAccount.isEmpty()) {
        inst = lstAccount[0];
        
        Patient_Custom__c p = new Patient_Custom__c();
        p.Birthdate__c = date.newInstance(1960, 8, 7);
        p.Ethnicity__c = 'Hispanic or latino';
        p.Gender__c = 'female';
        p.Race__c = 'asian';
        p.Last_Name__c = 'kumar';
        p.Institution__c = inst.Id;
        insert p;
        
        Trial__c t = new Trial__c();
        t.Start_Date__c = system.today();
        insert t;
        
        TrialPatient__c tp = new TrialPatient__c();
        tp.Trial_Id__c = t.Id;
        tp.Patient_Id__c = p.Id;
        insert tp;
        
        Registration__c reg = new Registration__c();
        reg.Patient__c = p.Id;
        reg.Registration_Date__c = System.today();
        reg.Trial__c = t.Id;
        reg.TrialPatient__c = tp.Id;
        reg.Institution__c = inst.Id;
        reg.IRB_Approval_Date__c = System.today();
        reg.Screening_Informed_Consent_Date__c = System.today();
        reg.HIPPA_Consent_Date__c = System.today();
        reg.Effective_Time__c = system.now();
        reg.ISPY2_Subject_Id__c = ''+123;
        insert reg;
        
        MRI_Volume__c mri = new MRI_Volume__c();
        mri.TrialPatient__c = tp.Id;
        mri.MRI_Scan_Date__c = date.newInstance(2012, 7, 7);
        mri.MRI_Volume_in_cm3__c = 2.3;
        mri.Longest_Diameter_Of_Index_Lesion_in_cm__c = 2.4;
        mri.Time_Point__c = 'Pre-Treatment';
        mri.Status__c = 'Approval Pending';
        insert mri;
        //update mri;
        
        Apexpages.currentPage().getParameters().put('trialPat', tp.Id);     
        Apexpages.currentPage().getParameters().put('recId', mri.Id);
        Apexpages.currentPage().getParameters().put('object', 'MRI_Volume__c');
        DCCApprovalController dac = new DCCApprovalController();    
        
      }
    }
  }
  
  @isTest static void myUnitTest6() {
        // TO DO: implement unit test
        
        List<User> thisUser = [ select u.Id , u.IsActive from User u where profile.Name = 'System Administrator' and IsActive = true];
        System.runAs (thisUser[0]){
        
        Account inst = new Account();
        List<Account> lstAccount = [select Id from Account limit 1];
        if(!lstAccount.isEmpty()) {
        inst = lstAccount[0];
        
        Patient_Custom__c p = new Patient_Custom__c();
        p.Birthdate__c = date.newInstance(1960, 8, 7);
        p.Ethnicity__c = 'Hispanic or latino';
        p.Gender__c = 'female';
        p.Race__c = 'asian';
        p.Last_Name__c = 'kumar';
        p.Institution__c = inst.Id;
        insert p;
        
        Trial__c t = new Trial__c();
        t.Start_Date__c = system.today();
        insert t;
        
        TrialPatient__c tp = new TrialPatient__c();
        tp.Trial_Id__c = t.Id;
        tp.Patient_Id__c = p.Id;
        insert tp;
        
        Registration__c reg = new Registration__c();
        reg.Patient__c = p.Id;
        reg.Registration_Date__c = System.today();
        reg.Trial__c = t.Id;
        reg.TrialPatient__c = tp.Id;
        reg.Institution__c = inst.Id;
        reg.IRB_Approval_Date__c = System.today();
        reg.Screening_Informed_Consent_Date__c = System.today();
        reg.HIPPA_Consent_Date__c = System.today();
        reg.Effective_Time__c = system.now();
        reg.ISPY2_Subject_Id__c = ''+123;
        insert reg;
        
        Post_Surgaory_Summary__c pss = new Post_Surgaory_Summary__c();
        pss.TrialPatient__c = tp.Id;
        pss.Status__c = 'Approval Pending';
        insert pss;
        //update pss;
        
 //===============================approval for Post_Surgaory_Summary__c=============================================================       
        Approval.ProcessSubmitRequest CRFReq = new Approval.ProcessSubmitRequest();
        CRFReq.setComments('Submitting request for CRF approval.');
        CRFReq.setObjectId(pss.Id);
        CRFReq.setNextApproverIds(new Id[] {UserInfo.getUserId()});
        Approval.ProcessResult result = Approval.process(CRFReq);
        system.debug('result : '+result);
        String instanceId = result.getInstanceId();
        string[] NewWorkitemIds = result.getNewWorkitemIds();
        
        Apexpages.currentPage().getParameters().put('trialPat', tp.Id);     
        Apexpages.currentPage().getParameters().put('recId', pss.Id);
        Apexpages.currentPage().getParameters().put('object', 'Post_Surgaory_Summary__c');
        Apexpages.currentPage().getParameters().put('workItemId', NewWorkitemIds[0]);
        DCCApprovalController dac11 = new DCCApprovalController();   
        
        //dac11.decisionComments = 'Test';
        //dac11.reject();  
      }
    }
  }
  
  @isTest static void myUnitTest7() {
        // TO DO: implement unit test
        
        List<User> thisUser = [ select u.Id , u.IsActive from User u where profile.Name = 'System Administrator' and IsActive = true];
        System.runAs (thisUser[0]){
        
        Account inst = new Account();
        List<Account> lstAccount = [select Id from Account limit 1];
        if(!lstAccount.isEmpty()) {
        inst = lstAccount[0];
        
        Patient_Custom__c p = new Patient_Custom__c();
        p.Birthdate__c = date.newInstance(1960, 8, 7);
        p.Ethnicity__c = 'Hispanic or latino';
        p.Gender__c = 'female';
        p.Race__c = 'asian';
        p.Last_Name__c = 'kumar';
        p.Institution__c = inst.Id;
        insert p;
        
        Trial__c t = new Trial__c();
        t.Start_Date__c = system.today();
        insert t;
        
        TrialPatient__c tp = new TrialPatient__c();
        tp.Trial_Id__c = t.Id;
        tp.Patient_Id__c = p.Id;
        insert tp;
        
        Registration__c reg = new Registration__c();
        reg.Patient__c = p.Id;
        reg.Registration_Date__c = System.today();
        reg.Trial__c = t.Id;
        reg.TrialPatient__c = tp.Id;
        reg.Institution__c = inst.Id;
        reg.IRB_Approval_Date__c = System.today();
        reg.Screening_Informed_Consent_Date__c = System.today();
        reg.HIPPA_Consent_Date__c = System.today();
        reg.Effective_Time__c = system.now();
        reg.ISPY2_Subject_Id__c = ''+123;
        insert reg;
        
        Off_Study_Detail__c osd = new Off_Study_Detail__c();
        osd.TrialPatient__c = tp.Id;
        osd.Status__c = 'Approval Pending';
        insert osd;  
        update osd;
        
//===============================approval for Off_Study_Detail__c=============================================================          
        Approval.ProcessSubmitRequest CRFReq = new Approval.ProcessSubmitRequest();
        CRFReq.setComments('Submitting request for CRF approval.');
        CRFReq.setObjectId(osd.Id);
        CRFReq.setNextApproverIds(new Id[] {UserInfo.getUserId()});
        Approval.ProcessResult result = Approval.process(CRFReq);
        system.debug('result : '+result);
        String instanceId = result.getInstanceId();
        string[] NewWorkitemIds = result.getNewWorkitemIds();
        
        Apexpages.currentPage().getParameters().put('trialPat', tp.Id); 
        Apexpages.currentPage().getParameters().put('recId', osd.Id);
        Apexpages.currentPage().getParameters().put('object', 'Off_Study_Detail__c');
        Apexpages.currentPage().getParameters().put('workItemId', NewWorkitemIds[0]);
        DCCApprovalController dac12 = new DCCApprovalController();  
            
//===============================approval for Off_Study_Detail__c=============================================================
        osd.Status__c = 'Accepted';
        update osd;
                    
        Apexpages.currentPage().getParameters().put('recId', osd.Id);
        Apexpages.currentPage().getParameters().put('object', 'Off_Study_Detail__c');
        //Apexpages.currentPage().getParameters().get('workItemId');
        DCCApprovalController dac13 = new DCCApprovalController();  
        
        dac12.approve();
        dac12.reject();  
        //dac12.signAndSubmit();
        dac12.resendCode();
        dac12.cancel();                
      }
    }
  }
  
  @isTest static void myUnitTest8() {
        // TO DO: implement unit test
        
        List<User> thisUser = [ Select u.IsActive, u.Id, SecurityCode__c From User u where IsActive = true and Profile.Name = 'DCC User' and SecurityCode__c != null];
        System.runAs ( thisUser[0] ){
        
        Account inst = new Account();
        List<Account> lstAccount = [select Id from Account limit 1];
        if(!lstAccount.isEmpty()) {
        inst = lstAccount[0];
        
        Patient_Custom__c p = new Patient_Custom__c();
        p.Birthdate__c = date.newInstance(1960, 8, 7);
        p.Ethnicity__c = 'Hispanic or latino';
        p.Gender__c = 'female';
        p.Race__c = 'asian';
        p.Last_Name__c = 'kumar';
        p.Institution__c = inst.Id;
        insert p;
        
        Trial__c t = new Trial__c();
        t.Start_Date__c = system.today();
        insert t;
        
        TrialPatient__c tp = new TrialPatient__c();
        tp.Trial_Id__c = t.Id;
        tp.Patient_Id__c = p.Id;
        insert tp;
        
        Registration__c reg = new Registration__c();
        reg.Patient__c = p.Id;
        reg.Registration_Date__c = System.today();
        reg.Trial__c = t.Id;
        reg.TrialPatient__c = tp.Id;
        reg.Institution__c = inst.Id;
        reg.IRB_Approval_Date__c = System.today();
        reg.Screening_Informed_Consent_Date__c = System.today();
        reg.HIPPA_Consent_Date__c = System.today();
        reg.Effective_Time__c = system.now();
        reg.ISPY2_Subject_Id__c = ''+123;
        insert reg;
        
        MRI_Volume__c mri = new MRI_Volume__c();
        mri.TrialPatient__c = tp.Id;
        mri.MRI_Scan_Date__c = date.newInstance(2012, 7, 7);
        mri.MRI_Volume_in_cm3__c = 2.3;
        mri.Longest_Diameter_Of_Index_Lesion_in_cm__c = 2.4;
        mri.Time_Point__c = 'Pre-Treatment';
        mri.Status__c = 'Rejected';
        insert mri;
       // update mri;
        
        blob blobKey = Encodingutil.base64Decode(thisUser[0].SecurityCode__c);
        String securityCode = EncodingUtil.convertToHex(blobKey);
        securityCode = securityCode.substring(0,8);
        
        Apexpages.currentPage().getParameters().put('trialPat', tp.Id);     
        Apexpages.currentPage().getParameters().put('recId', mri.Id);
        Apexpages.currentPage().getParameters().put('object', 'MRI_Volume__c');
        DCCApprovalController dac = new DCCApprovalController();    
        
        dac.password = securityCode;
        dac.decision = 'approve';
        dac.signAndSubmit();
      }
    }
  }
  
  @isTest static void myUnitTest9() {
        // TO DO: implement unit test
        
        List<User> thisUser = [ Select u.IsActive, u.Id, SecurityCode__c From User u where IsActive = true and Profile.Name = 'DCC User' and SecurityCode__c != null];
        System.runAs ( thisUser[0] ){
        
        Account inst = new Account();
        List<Account> lstAccount = [select Id from Account limit 1];
        if(!lstAccount.isEmpty()) {
        inst = lstAccount[0];
        
        Patient_Custom__c p = new Patient_Custom__c();
        p.Birthdate__c = date.newInstance(1960, 8, 7);
        p.Ethnicity__c = 'Hispanic or latino';
        p.Gender__c = 'female';
        p.Race__c = 'asian';
        p.Last_Name__c = 'kumar';
        p.Institution__c = inst.Id;
        insert p;
        
        Trial__c t = new Trial__c();
        t.Start_Date__c = system.today();
        insert t;
        
        TrialPatient__c tp = new TrialPatient__c();
        tp.Trial_Id__c = t.Id;
        tp.Patient_Id__c = p.Id;
        insert tp;
        
        Registration__c reg = new Registration__c();
        reg.Patient__c = p.Id;
        reg.Registration_Date__c = System.today();
        reg.Trial__c = t.Id;
        reg.TrialPatient__c = tp.Id;
        reg.Institution__c = inst.Id;
        reg.IRB_Approval_Date__c = System.today();
        reg.Screening_Informed_Consent_Date__c = System.today();
        reg.HIPPA_Consent_Date__c = System.today();
        reg.Effective_Time__c = system.now();
        reg.ISPY2_Subject_Id__c = ''+123;
        insert reg;
        
        MRI_Volume__c mri = new MRI_Volume__c();
        mri.TrialPatient__c = tp.Id;
        mri.MRI_Scan_Date__c = date.newInstance(2012, 7, 7);
        mri.MRI_Volume_in_cm3__c = 2.3;
        mri.Longest_Diameter_Of_Index_Lesion_in_cm__c = 2.4;
        mri.Time_Point__c = 'Pre-Treatment';
        mri.Status__c = 'Rejected';
        insert mri;
        //update mri;
        
        blob blobKey = Encodingutil.base64Decode(thisUser[0].SecurityCode__c);
        String securityCode = EncodingUtil.convertToHex(blobKey);
        securityCode = securityCode.substring(0,8);
        
        Apexpages.currentPage().getParameters().put('trialPat', tp.Id);     
        Apexpages.currentPage().getParameters().put('recId', mri.Id);
        Apexpages.currentPage().getParameters().put('object', 'MRI_Volume__c');
        DCCApprovalController dac = new DCCApprovalController();    
        
        dac.decision = 'reject';
        dac.signAndSubmit();
      }
    }
  }
}