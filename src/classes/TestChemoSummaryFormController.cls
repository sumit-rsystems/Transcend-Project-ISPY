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
private class TestChemoSummaryFormController {

 
      @isTest static void myUnitTest1() {
        
        List<User> lstSiteUser = [Select u.IsActive, u.Id, SecurityCode__c From User u where IsActive = true and Profile.Name = 'Site User'];     
        System.runAs ( lstSiteUser[0] ) { 
        
        Account insAcc = new Account();
        
        List<Account> lstAccount = [Select a.Id From Account a limit 1];
        
        if(!lstAccount.isEmpty()){
            
        insAcc = lstAccount[0];
            
        Patient_Custom__c p = new Patient_Custom__c();
        p.Birthdate__c = date.newInstance(1950, 08, 05);
        p.Institution__c = insAcc.Id;
        p.Last_Name__c = 'test1';
        p.Gender__c = 'Male';
        p.Race__c = 'White';
        p.Ethnicity__c = 'Not Hispanic or Latino';
        insert p;
        
        TrialPatient__c trialPatient = new TrialPatient__c();
        trialPatient.Patient_Id__c = p.Id;
        trialPatient.FirstName__c = 'a';
        trialPatient.LastName__c = 'b';
        insert trialPatient;
        
        Chemo_Summary_Form__c chemoSummaryForm = new Chemo_Summary_Form__c ();
        chemoSummaryForm.TrialPatient__c = trialPatient.Id;
        chemoSummaryForm.Status__c = 'Not Completed';
        insert chemoSummaryForm;
        chemoSummaryForm.Status__c = 'Accepted';
        update chemoSummaryForm;
        
        Apexpages.currentPage().getParameters().put('trialPat',trialPatient.Id); 
        Apexpages.StandardController std = new Apexpages.StandardController(chemoSummaryForm);
        ChemoSummaryFormController chemoSummaryController1 = new ChemoSummaryFormController(std);
        
        chemoSummaryController1.saveMainCRF();
        chemoSummaryController1.chemoSummary = chemoSummaryForm;
        chemoSummaryController1.chemoSummaryId = chemoSummaryForm.Id;
        chemoSummaryController1.saveMainCRF();
        
        Apexpages.currentPage().getParameters().put('trialPat',trialPatient.Id); 
        Apexpages.currentPage().getParameters().put('formId',chemoSummaryController1.chemoSummary.Id);
        
        Agent__c agent = new Agent__c();
        agent.Name = 'test agent';
        agent.Display_Order__c = 0;
        insert agent;
        
        
        
      }
    }
  }

    @isTest static void ChemoSummaryAfterTrigger2() {      
        Account insAcc = new Account();
        insAcc.Name = 'test';
        insert insAcc;
        
        Patient_Custom__c p = new Patient_Custom__c();
        p.Birthdate__c = date.newInstance(1950, 08, 05);
        p.Institution__c = insAcc.Id;
        p.Last_Name__c = 'test1';
        p.Gender__c = 'Male';
        p.Race__c = 'White';
        p.Ethnicity__c = 'Not Hispanic or Latino';
        insert p;
        
        TrialPatient__c trialPatient = new TrialPatient__c();
        trialPatient.Patient_Id__c = p.Id;
        insert trialPatient;
        
        Chemo_Summary_Form__c chemoSummaryForm = new Chemo_Summary_Form__c ();
        chemoSummaryForm.TrialPatient__c = trialPatient.Id;
        chemoSummaryForm.Status__c = 'Approval Pending';
        insert chemoSummaryForm;
        update chemoSummaryForm;
        
        Apexpages.currentPage().getParameters().put('trialPat',trialPatient.Id); 
        Apexpages.StandardController std1 = new Apexpages.StandardController(chemoSummaryForm);
        
        ChemoSummaryFormController chemoSummaryController = new ChemoSummaryFormController(std1);
        
        
        Apexpages.currentPage().getParameters().put('nextTab','saveAndClose');
        
        
        
        chemoSummaryController.currentTab = 'lastTab';
        chemoSummaryController.previous();
        
        chemoSummaryController.currentTab = 'fifthTab';
        chemoSummaryController.previous();
        
        chemoSummaryController.currentTab = 'fourthTab';
        chemoSummaryController.previous();
        
        chemoSummaryController.currentTab = 'thirdTab';
        chemoSummaryController.previous();
        
        chemoSummaryController.currentTab = 'secondTab';
        chemoSummaryController.previous();
        
        chemoSummaryController.editCRF();
        chemoSummaryController.cloneCRF();
        chemoSummaryController.signAndSubmit();
        chemoSummaryController.cancelCRF();
        chemoSummaryController.resendCode();
  }
  
  @isTest static void myUnitTest3() {
        
        List<User> lstSiteUser = [Select u.IsActive, u.Id, SecurityCode__c From User u where IsActive = true and Profile.Name = 'Site User'];     
        System.runAs ( lstSiteUser[0] ) { 
        
        Account insAcc = new Account();
        
        List<Account> lstAccount = [Select a.Id From Account a limit 1];
        
        if(!lstAccount.isEmpty()){
            
        insAcc = lstAccount[0];
            
        Patient_Custom__c p = new Patient_Custom__c();
        p.Birthdate__c = date.newInstance(1950, 08, 05);
        p.Institution__c = insAcc.Id;
        p.Last_Name__c = 'test1';
        p.Gender__c = 'Male';
        p.Race__c = 'White';
        p.Ethnicity__c = 'Not Hispanic or Latino';
        insert p;
        
        TrialPatient__c trialPatient = new TrialPatient__c();
        trialPatient.Patient_Id__c = p.Id;
        trialPatient.FirstName__c = 'a';
        trialPatient.LastName__c = 'b';
        insert trialPatient;
        
        Chemo_Summary_Form__c chemoSummaryForm = new Chemo_Summary_Form__c ();
        chemoSummaryForm.TrialPatient__c = trialPatient.Id;
        chemoSummaryForm.Status__c = 'Not Completed';
        insert chemoSummaryForm;
        chemoSummaryForm.Status__c = 'Accepted';
        update chemoSummaryForm;
        
        
        Chemo_Regimen__c chemoRegimen1 = new Chemo_Regimen__c();
        chemoRegimen1.Name = 'Anthracycline';
        insert chemoRegimen1;
        
        Apexpages.currentPage().getParameters().put('trialPat',trialPatient.Id); 
        Apexpages.StandardController std = new Apexpages.StandardController(chemoSummaryForm);
        ChemoSummaryFormController chemoSummaryController1 = new ChemoSummaryFormController(std);
        
        
        Apexpages.currentPage().getParameters().put('trialPat',trialPatient.Id); 
        Apexpages.currentPage().getParameters().put('formId',chemoSummaryController1.chemoSummary.Id);
        
        ChemoSummaryRegimenDetail__c chemoSummaryRegimenDetail2 = new ChemoSummaryRegimenDetail__c();
        chemoSummaryRegimenDetail2.First_Date_of_Therapy__c = system.today();
        chemoSummaryRegimenDetail2.Last_Date_of_Therapy__c = system.today();
        chemoSummaryRegimenDetail2.Treatment_End_Reasons__c = 'Treatment completed per protocol criteria';
        chemoSummaryRegimenDetail2.Chemo_Regimen__c = chemoRegimen1.Id;
        chemoSummaryRegimenDetail2.Chemo_Summary_Form__c = chemoSummaryForm.Id;
        insert chemoSummaryRegimenDetail2;
        
        Agent__c agent = new Agent__c();
        agent.Name = 'test agent';
        agent.Display_Order__c = 0;
        insert agent;
        
        
      }
    }
  }
  
  @isTest static void myUnitTest4() {
        
        Account insAcc = new Account();
        insAcc.Name = 'test';
        insert insAcc;
        
        Patient_Custom__c p = new Patient_Custom__c();
        p.Birthdate__c = date.newInstance(1950, 08, 05);
        p.Institution__c = insAcc.Id;
        p.Last_Name__c = 'test1';
        p.Gender__c = 'Male';
        p.Race__c = 'White';
        p.Ethnicity__c = 'Not Hispanic or Latino';
        insert p;
        
        TrialPatient__c trialPatient = new TrialPatient__c();
        trialPatient.Patient_Id__c = p.Id;
        insert trialPatient;
        
        Chemo_Summary_Form__c chemoSummaryForm = new Chemo_Summary_Form__c ();
        chemoSummaryForm.TrialPatient__c = trialPatient.Id;
        chemoSummaryForm.Status__c = 'Not Completed';
        insert chemoSummaryForm;
        chemoSummaryForm.Status__c = 'Accepted';
        update chemoSummaryForm;
        
        Chemo_Regimen__c chemoRegimen = new Chemo_Regimen__c();
        chemoRegimen.Name = 'Taxane';
        insert chemoRegimen;
         
       
        
        
        Apexpages.currentPage().getParameters().put('trialPat',trialPatient.Id); 
        Apexpages.StandardController std = new Apexpages.StandardController(chemoSummaryForm);
        ChemoSummaryFormController chemoSummaryController1 = new ChemoSummaryFormController(std);
        
        chemoSummaryController1.saveMainCRF();
        chemoSummaryController1.chemoSummary = chemoSummaryForm;
        chemoSummaryController1.chemoSummaryId = chemoSummaryForm.Id;
        chemoSummaryController1.saveMainCRF();
        
        Apexpages.currentPage().getParameters().put('trialPat',trialPatient.Id); 
        Apexpages.currentPage().getParameters().put('formId',chemoSummaryController1.chemoSummary.Id);
        
        ChemoSummaryRegimenDetail__c chemoSummaryRegimenDetail = new ChemoSummaryRegimenDetail__c();
        chemoSummaryRegimenDetail.First_Date_of_Therapy__c = system.today();
        chemoSummaryRegimenDetail.Last_Date_of_Therapy__c = system.today();
        chemoSummaryRegimenDetail.Treatment_End_Reasons__c = 'Treatment completed per protocol criteria';
        chemoSummaryRegimenDetail.Chemo_Regimen__c = chemoRegimen.Id;
        chemoSummaryRegimenDetail.Chemo_Summary_Form__c = chemoSummaryForm.Id;
        insert chemoSummaryRegimenDetail;
        
       
        
      }
    
  
  
  @isTest static void myUnitTest5() {
        
        Account insAcc = new Account();
        insAcc.Name = 'test';
        insert insAcc;
        
        Patient_Custom__c p = new Patient_Custom__c();
        p.Birthdate__c = date.newInstance(1950, 08, 05);
        p.Institution__c = insAcc.Id;
        p.Last_Name__c = 'test1';
        p.Gender__c = 'Male';
        p.Race__c = 'White';
        p.Ethnicity__c = 'Not Hispanic or Latino';
        insert p;
        
        TrialPatient__c trialPatient = new TrialPatient__c();
        trialPatient.Patient_Id__c = p.Id;
        insert trialPatient;
        
        Agent__c agent = new Agent__c();
        agent.Name = 'test agent';
        agent.Display_Order__c = 0;
        insert agent;
        
         
		
        Chemo_Summary_Form__c chemoSummaryForm = new Chemo_Summary_Form__c ();
        chemoSummaryForm.TrialPatient__c = trialPatient.Id;
        chemoSummaryForm.Status__c = 'Not Completed';
        insert chemoSummaryForm;
        chemoSummaryForm.Status__c = 'Accepted';
        update chemoSummaryForm;
        
        Chemo_Regimen__c chemoRegimen2 = new Chemo_Regimen__c();
        chemoRegimen2.Name = 'Investigational';
        insert chemoRegimen2;
        
        
        Apexpages.currentPage().getParameters().put('trialPat',trialPatient.Id); 
        Apexpages.StandardController std = new Apexpages.StandardController(chemoSummaryForm);
        ChemoSummaryFormController chemoSummaryController1 = new ChemoSummaryFormController(std);
        
        chemoSummaryController1.saveMainCRF();
        chemoSummaryController1.chemoSummary = chemoSummaryForm;
        chemoSummaryController1.chemoSummaryId = chemoSummaryForm.Id;
        chemoSummaryController1.saveMainCRF();
        
        Apexpages.currentPage().getParameters().put('trialPat',trialPatient.Id); 
        Apexpages.currentPage().getParameters().put('formId',chemoSummaryController1.chemoSummary.Id);
        
        ChemoSummaryRegimenDetail__c chemoSummaryRegimenDetail1 = new ChemoSummaryRegimenDetail__c();
        chemoSummaryRegimenDetail1.First_Date_of_Therapy__c = system.today();
        chemoSummaryRegimenDetail1.Last_Date_of_Therapy__c = system.today();
        chemoSummaryRegimenDetail1.Treatment_End_Reasons__c = 'Treatment completed per protocol criteria';
        chemoSummaryRegimenDetail1.Chemo_Regimen__c = chemoRegimen2.Id;
        chemoSummaryRegimenDetail1.Chemo_Summary_Form__c = chemoSummaryForm.Id;
        insert chemoSummaryRegimenDetail1;
        
        
        
        ChemoSummaryRegimenDetail__c chemoSummaryRegimenDetail3 = new ChemoSummaryRegimenDetail__c();
        chemoSummaryRegimenDetail3.First_Date_of_Therapy__c = system.today();
        chemoSummaryRegimenDetail3.Last_Date_of_Therapy__c = system.today();
        chemoSummaryRegimenDetail3.Treatment_End_Reasons__c = 'Treatment completed per protocol criteria';
        chemoSummaryRegimenDetail3.Chemo_Regimen__c = chemoRegimen2.Id;
        chemoSummaryRegimenDetail3.Chemo_Summary_Form__c = chemoSummaryForm.Id;
        insert chemoSummaryRegimenDetail3;
        
       
      }
      @isTest static void myUnitTest6() {
	  
        
        Account insAcc = new Account();
        insAcc.Name = 'test';
        insert insAcc;
        
        Patient_Custom__c p = new Patient_Custom__c();
        p.Birthdate__c = date.newInstance(1950, 08, 05);
        p.Institution__c = insAcc.Id;
        p.Last_Name__c = 'test1';
        p.Gender__c = 'Male';
        p.Race__c = 'White';
        p.Ethnicity__c = 'Not Hispanic or Latino';
        insert p;
        
        TrialPatient__c trialPatient = new TrialPatient__c();
        trialPatient.Patient_Id__c = p.Id;
        insert trialPatient;
        
         
        Chemo_Summary_Form__c chemoSummaryForm = new Chemo_Summary_Form__c ();
        chemoSummaryForm.TrialPatient__c = trialPatient.Id;
        chemoSummaryForm.Status__c = 'Not Completed';
        insert chemoSummaryForm;
        chemoSummaryForm.Status__c = 'Accepted';
        update chemoSummaryForm;
        
       
      }
	  
	 
    }