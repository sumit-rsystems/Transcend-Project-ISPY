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
private class TestOnStudyEligibilityFormsNew {

    @isTest static void myUnitTest() {
        // TO DO: implement unit test
        
        Profile SiteProp = [ Select p.UserType, p.Name, (Select u.IsActive, u.Id From Users u where IsActive = true) From Profile p where Name = 'System Administrator'];
        List<User> lstSiteUser = SiteProp.Users;     
        System.runAs ( lstSiteUser[0] ) { 
        
        Trial__c trial1 = new Trial__c();
        trial1.Name = 'test trial';
        insert trial1;
        
        Account acc1 = new Account();

        List<Account> lstAccount = [select Id from Account limit 1]; 
            
        if(!lstAccount.isEmpty()){
                
        acc1 = lstAccount[0];           // newly added logic to overcome the error of "setup and nonsetup" object
        
        Site__c site1 = new Site__c();
        site1.Name = 'test site1';
        site1.Type__c = 'test type';
        site1.Institute__c = acc1.Id;
        insert site1;
        
        Patient_Custom__c pc = new Patient_Custom__c();
        pc.First_Name__c = 'test';
        pc.Last_Name__c = 'test';
        pc.Gender__c = 'Male';
        pc.Birthdate__c = date.newInstance(1978, 7, 8);
        pc.Race__c = 'White';
        pc.Ethnicity__c = 'Not Hispanic or Latino';
        pc.Institution__c = acc1.Id;
        pc.Medical_Record_Number__c = '3434';
        pc.Signed_Screening__c = true;
        insert pc;
        
        TrialPatient__c tp = new TrialPatient__c();
        tp.Trial_Id__c = trial1.Id;
        tp.Site__c = site1.Id;
        tp.Patient_Id__c = pc.Id;
        insert tp;
        
        On_Study_Eligibility_Form__c osef1 = new On_Study_Eligibility_Form__c(); // line 93 if cond, onStudyEleId == null
        osef1.How_was_the_cancer_first_detected__c = 'Screening mammogram';
        osef1.Is_mass_palpable__c = 'yes';
        osef1.TrialPatient__c = tp.Id;
        insert osef1;
        
        Apexpages.currentPage().getParameters().put('trialPat', tp.Id);
        Apexpages.standardcontroller obj1 = new Apexpages.standardcontroller(osef1); // line 93 if cond, onStudyEleId == null
        OnStudyEligibilityFormsNew ose1 = new OnStudyEligibilityFormsNew(obj1);
        
        ose1.CRFinsert(); // line 94 if cond, onStudyEleId == null
        
        ose1.CRFinsert(); // line 112 else cond, onStudyEleId == null
        
       }
    }
 }
    @isTest static void myUnitTest1() { // second method i had to made to overcome the error "too many future calls "
        // TO DO: implement unit test
        
        Profile SiteProp = [ Select p.UserType, p.Name, (Select u.IsActive, u.Id From Users u where IsActive = true) From Profile p where Name = 'System Administrator'];
        List<User> lstSiteUser = SiteProp.Users;     
        System.runAs ( lstSiteUser[0] ) { 
        
        Trial__c trial1 = new Trial__c();
        trial1.Name = 'test trial';
        insert trial1;
        
        Account acc1 = new Account();

        List<Account> lstAccount = [select Id from Account limit 1]; 
            
        if(!lstAccount.isEmpty()){
                
        acc1 = lstAccount[0];           // newly added logic to overcome the error of "setup and nonsetup" object
        
        Site__c site1 = new Site__c();
        site1.Name = 'test site1';
        site1.Type__c = 'test type';
        site1.Institute__c = acc1.Id;
        insert site1;
        
        Patient_Custom__c pc = new Patient_Custom__c();
        pc.First_Name__c = 'test';
        pc.Last_Name__c = 'test';
        pc.Gender__c = 'Male';
        pc.Birthdate__c = date.newInstance(1978, 7, 8);
        pc.Race__c = 'White';
        pc.Ethnicity__c = 'Not Hispanic or Latino';
        pc.Institution__c = acc1.Id;
        pc.Medical_Record_Number__c = '3434';
        pc.Signed_Screening__c = true;
        insert pc;
        
        TrialPatient__c tp = new TrialPatient__c();
        tp.Trial_Id__c = trial1.Id;
        tp.Site__c = site1.Id;
        tp.Patient_Id__c = pc.Id;
        insert tp;
        
        On_Study_Eligibility_Form__c osef = new On_Study_Eligibility_Form__c();
        osef.How_was_the_cancer_first_detected__c = 'Screening mammogram';
        osef.Is_mass_palpable__c = 'yes';
        osef.TrialPatient__c = tp.Id;
        insert osef;
            
        PreEligibility_Checklist__c pre = new PreEligibility_Checklist__c();
        pre.Patient__c = pc.Id;
        insert pre;
        
        QuestionAnswer__c ques = new QuestionAnswer__c();
        ques.Question__c = 'Patient has no history of deep venous thrombosis (DVT), arterial thromboembolism, or pulmonary thromboembolism within 12 months prior to screening';
        insert ques;
        
        CRFAdditionalQuestion__c crf = new CRFAdditionalQuestion__c();
        crf.QuestionAnswer__c = ques.Id;
        crf.CRFId__c = osef.Id;
        crf.Answer__c = 'true';
        insert crf;
        
        Arm__c ar = new Arm__c();
        ar.Name = 'test';
        insert ar;
        
        AdditionalQuestion__c adq = new AdditionalQuestion__c();
        adq.QuestionId__c = ques.Id;
        adq.ArmId__c = ar.Id;
        insert adq;
        
        ArmPatient__c arm = new ArmPatient__c();
        arm.Arm_Id__c = ar.Id;
        insert arm;
        
        ComponentControllerBase ccb = new ComponentControllerBase(); // VIRTUAL CLASS "ComponentControllerBase"
        ccb.key = '1';
        
        PageControllerBase pcb = new PageControllerBase(); // VIRTUAL CLASS "PageControllerBase" BEGINS HERE
        pcb.getAddQuesComponentController();
        pcb.getComponentControllerMap();
        
        pcb.setAddQuesComponentController(ccb);
        pcb.setComponentControllerMap('1', ccb);
        
        Apexpages.currentPage().getParameters().put('trialPat',tp.Id);
        Apexpages.currentPage().getParameters().put('onStudyEleId',osef.Id);
        
        Apexpages.standardcontroller obj = new Apexpages.standardcontroller(osef);
        OnStudyEligibilityFormsNew ose = new OnStudyEligibilityFormsNew(obj);
        ose.addQuesController.getlstQuesAnsWrapper();
        
        ose.getAddQuesComponentController();
        ose.getComponentControllerMap();
        
        ose.setAddQuesComponentController(ccb);
        ose.setComponentControllerMap('1', ccb);
        
       // ose.callAddQuesControllerMethod(crf.Id); // causing error 
        
        Apexpages.currentPage().getParameters().put('trialPat',tp.Id);
        
        ose.CRFinsert();
        ose.isSigned = true;
       // Apexpages.currentPage().getParameters().put('tabNext','Methodofdetection');
        Apexpages.currentPage().getParameters().put('tabNext','saveAndClose'); 
        ose.nextTabName = 'saveAndClose';
        try {
                ose.next();
            
        
        
        Apexpages.currentPage().getParameters().put('tabNext','Complete'); 
        ose.nextTabName = 'Complete';
        ose.next();
        
        ose.currentTab = 'Methodofdetection';
        ose.next();
        
        Apexpages.currentPage().getParameters().put('tabPrevious','Methodofdetection');
        ose.previous();
        
        ose.signAndSubmit();
        
        Apexpages.currentPage().getParameters().put('trialPat',tp.Id);
        ose.resendCode();
        ose.editCRF();
        
        ose.cloneCRF();
        ose.customCancel();
        }catch (Exception e) {
               System.debug('The following exception has occurred: ' + e.getMessage()); 
            }  
         }
      }
   }
}