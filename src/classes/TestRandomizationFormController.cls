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
private class TestRandomizationFormController {

    @isTest static void myUnitTest() {
        // TO DO: implement unit test
        List<User> lstSiteUser = [ Select u.IsActive, u.Id, SecurityCode__c From User u where IsActive = true and Profile.Name = 'Site User'];     
        System.runAs ( lstSiteUser[0] ) { 
            
        Account acc = new Account();

        List<Account> lstAccount = [select Id from Account limit 1];
            
        if(!lstAccount.isEmpty()){
                
        acc = lstAccount[0];
        
        Patient_Custom__c p = new Patient_Custom__c();
        p.Birthdate__c = date.newInstance(1960, 8, 7);
        p.Institution__c = acc.Id;
        p.Last_Name__c = 'test'; 
        p.Gender__c = 'Male';
        p.Race__c = 'White';
        p.Ethnicity__c = 'Not Hispanic or Latino';
        insert p;
            
        TrialPatient__c tp = new TrialPatient__c();
        tp.FirstName__c = 'a';
        tp.LastName__c = 'b';
        tp.Patient_Id__c = p.Id;
        insert tp;
        
        /*Menopausal_Status_Detail__c msd = new Menopausal_Status_Detail__c();
        msd.TrialPatient__c = tp.Id;
       // msd.age__c = 52;
        msd.Status__c = 'Completed';
        msd.Menopausal_Status__c = 'Above categories not applicable AND Age < 50';
        insert msd;
        //update msd;
            
        MRI_Volume__c mvc = new MRI_Volume__c();
        mvc.TrialPatient__c = tp.Id;
        mvc.Status__c = 'Completed';
        mvc.MRI_Volume_in_cm3__c = 12.0;
        mvc.Time_Point__c = 'Pre-Treatment';
        mvc.MRI_Scan_Date__c = date.newInstance(2012, 7, 7);
        mvc.Longest_Diameter_Of_Index_Lesion_in_cm__c = 2.4;
        insert mvc;
        //update mvc;
        
        On_Study_Pathology_Form__c osp = new On_Study_Pathology_Form__c();
        osp.TrialPatient__c = tp.Id;
        osp.Status__c = 'Completed';
        osp.Does_the_patient_have_bilateral_breast_c__c = 'Yes'; //on study path
        osp.Tumor_laterality__c = 'Left';
        insert osp;
        //update osp;
            
        Receptors__c rec = new Receptors__c();
        rec.Estrogen_Receptor_Status__c = 'Positive';
        rec.IHC__c = 'Positive';
        rec.On_Study_Pathology_Form__c = osp.Id;
        insert rec;
        
        On_Study_Eligibility_Form__c osef = new On_Study_Eligibility_Form__c();
        osef.TrialPatient__c = tp.Id;
        osef.Status__c = 'Completed';
        osef.How_was_the_cancer_first_detected__c = 'Clinical exam';
        insert osef;
        //update osef;
        
        MammaPrintDetail__c mpc = new MammaPrintDetail__c();
        mpc.TrialPatient__c = tp.Id;
        mpc.Status__c = 'Completed';
        mpc.Report_Date__c = date.newInstance(2008, 7, 7);
        insert mpc;
        //update mpc; 
        */
        Randomization_Form__c rfc = new Randomization_Form__c();
        /*rfc.TrialPatient__c = tp.Id;
        rfc.Why_Patient_Not_Signed_Consent_Form__c = 'Patient found to be ineligible for the study';
        rfc.Status__c = 'Approval Not Required';
        insert rfc;*/
        //update rfc;
        
        Apexpages.currentPage().getParameters().put('trialPat',tp.Id);
        Apexpages.currentPage().getParameters().put('formId',rfc.Id);
        Apexpages.standardcontroller reg = new Apexpages.standardcontroller(rfc);
        Test.startTest();
        RandomizationFormController rf = new RandomizationFormController(reg);
        rf.saveMainCRF();
        Test.stopTest();
    }
  }
}
    @isTest static void myUnitTest2() { // else if part line 34
        // TO DO: implement unit test
        
        List<User> lstSiteUser = [ Select u.IsActive, u.Id, SecurityCode__c From User u where IsActive = true and Profile.Name = 'Site User'];     
        System.runAs ( lstSiteUser[0] ) { 
            
        Account acc = new Account();

        List<Account> lstAccount = [select Id from Account limit 1];
        if(!lstAccount.isEmpty()){
                
        acc = lstAccount[0];
            
        Patient_Custom__c p = new Patient_Custom__c();
        p.Birthdate__c = date.newInstance(1960, 8, 7);
        p.Institution__c = acc.Id;
        p.Last_Name__c = 'test'; // patient
        p.Gender__c = 'Male';
        p.Race__c = 'White';
        p.Ethnicity__c = 'Not Hispanic or Latino';
        
        insert p;
        
        TrialPatient__c tp = new TrialPatient__c();
        tp.FirstName__c = 'a';
        tp.LastName__c = 'b';
        tp.Patient_Id__c = p.Id;
        insert tp;
        
        Randomization_Form__c rfc = new Randomization_Form__c();
        rfc.TrialPatient__c = tp.Id;
        rfc.Why_Patient_Not_Signed_Consent_Form__c = 'Patient found to be ineligible for the study';
        insert rfc;
        
        Apexpages.currentPage().getParameters().put('trialPat',tp.Id);
        Apexpages.currentPage().getParameters().put('formId',rfc.Id);
        Apexpages.standardcontroller reg = new Apexpages.standardcontroller(rfc);
        RandomizationFormController rf = new RandomizationFormController(reg);
        
        Test.startTest();
        Apexpages.currentPage().getParameters().put('nextTab', 'saveAndClose');
        rf.next();
        
        rf.currentTab = 'SecondTab';
        rf.previous();
        
      //  rf.randomizePatient(true);
        rf.signAndSubmit();
        rf.resendCode();
        rf.cancelCRF();
        Test.stopTest();
      }
    }
  }
}