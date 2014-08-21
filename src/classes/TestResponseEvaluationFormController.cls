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
private class TestResponseEvaluationFormController {

    @isTest static void myUnitTest() {
        // TO DO: implement unit test
        
        List<User> lstSiteUser = [Select u.IsActive, u.Id, SecurityCode__c From User u where IsActive = true and Profile.Name = 'Site User'];     
        System.runAs ( lstSiteUser[0] ) { 
        
        Account acc = new Account();
        
        List<Account> lstAccount = [Select a.Id From Account a limit 1];
        
        if(!lstAccount.isEmpty()){
            
        acc = lstAccount[0];
        
        ResponseEvaluationFormController refc = new ResponseEvaluationFormController();
      
        Patient_Custom__c p = new Patient_Custom__c();
        p.Birthdate__c = date.newInstance(1950, 08, 05);
        p.Institution__c = acc.Id;
        p.Last_Name__c = 'test'; // patient
        p.Gender__c = 'Male';
        p.Race__c = 'White';
        p.Ethnicity__c = 'Not Hispanic or Latino';
        insert p;
        
        TrialPatient__c tp = new TrialPatient__c();
        tp.Patient_Id__c = p.Id;
        insert tp;
        
        CRF__c crf = new CRF__c();
        crf.Status__c = 'Accepted';
        crf.Patient__c = p.Id;
        insert crf;
        
        //=======================line 55 else part , since i havent "inserted" Response_Evaluation_Form__c============
        
        Response_Evaluation_Form__c rev1 = new Response_Evaluation_Form__c();
        rev1.TrialPatient__c = tp.Id;
        rev1.CRF__c = crf.Id;
        rev1.Status__c = 'Not Completed';
        
        Apexpages.currentPage().getParameters().put('trialPat',tp.Id); 
        Apexpages.StandardController std1 = new Apexpages.StandardController(rev1);
        ResponseEvaluationFormController rfc1 = new ResponseEvaluationFormController(std1);
            
            //======================finished==============================================================================
        }
    }  
}
    @isTest static void myUnitTest1() {
        // TO DO: implement unit test
        
        List<User> lstSiteUser = [Select u.IsActive, u.Id, SecurityCode__c From User u where IsActive = true and Profile.Name = 'Site User'];
             
        System.runAs(lstSiteUser[0]){ 
        
        Account acc = new Account();
        
        List<Account> lstAccount = [Select a.Id From Account a limit 1];
        
        if(!lstAccount.isEmpty()){
            
        acc = lstAccount[0];
        
        Patient_Custom__c p = new Patient_Custom__c();
        p.Birthdate__c = date.newInstance(1950, 08, 05);
        p.Institution__c = acc.Id;
        p.Last_Name__c = 'test'; // patient
        p.Gender__c = 'Male';
        p.Race__c = 'White';
        p.Ethnicity__c = 'Not Hispanic or Latino';
        insert p;
        
        TrialPatient__c tp = new TrialPatient__c();
        tp.Patient_Id__c = p.Id;
        
        insert tp;
        
        Response_Evaluation_Form__c rev = new Response_Evaluation_Form__c();
        rev.TrialPatient__c = tp.Id;
        rev.Clinical_Staging_Period__c = 'Yes';
        rev.Clinically_staging_period_T__c = 'T4';
        rev.Clinically_staging_period_N__c = 'N1a';
        rev.Clinically_staging_period_M__c = 'M1';
        rev.ReasonNotConservationSurgeryCandidate__c = 'Multi-centric disease';
        rev.Palpable_nodes__c = 'Yes';
        rev.Matted_nodes__c = null;  
        rev.Status__c = 'Not Completed'; 
        insert rev;
                  
        rev.Status__c = 'Accepted'; 
        update rev;
            
        Disease_Assessment__c da = new Disease_Assessment__c();
        da.Clip_placed__c = 'No';
        da.O_Clock_Position_To__c = '3';
        da.O_Clock_Position_From__c = '1';
        da.Longest_Diameter__c = 23.0;
        da.Distance_from_nipple__c = 23.0;
        da.Response_Evaluation_Form__c = rev.Id;
        insert da;
        
        Apexpages.currentPage().getParameters().put('trialPat',tp.Id);
        Apexpages.StandardController std = new Apexpages.StandardController(rev);
        ResponseEvaluationFormController rfc = new ResponseEvaluationFormController(std);
        rfc.getTargetLesionSNo();
        rfc.responseEval = rev;
        rfc.currentTab = 'DiseaseAssessmetTab';  // causing error null pointer exception
        rfc.next();  
        rfc.currentTab = 'responseStatus';
        rfc.next();
        rfc.currentTab = 'CommentsAndAttachments';
        rfc.next();
        Apexpages.currentPage().getParameters().put('tabNext','saveAndClose');
        rfc.nextTabName = 'saveAndClose';
        rfc.next();
        
        Apexpages.currentPage().getParameters().put('tabPrevious','CommentsAndAttachments');
        rfc.currentTab = 'Complete';
        rfc.previous();
        
        rfc.currentTab = 'CommentsAndAttachments';
        rfc.previous();
        
        rfc.currentTab = 'responseStatus';
        rfc.previous();
        
        rfc.responseEval = rev;
        
        rfc.respEvalId = rev.Id;
        rfc.editResponseEvaluationForm();
        rfc.signAndSubmit();
        ResponseEvaluationFormController.DiseaseAssessmentWrapper dac = new ResponseEvaluationFormController.DiseaseAssessmentWrapper();
        dac.isReadOnly = true;
        dac.targetLesion = 1;
        dac.diseaseAssessment = da;
               
                
       ResponseEvaluationFormController.DiseaseAssessmentWrapper dac1 = new ResponseEvaluationFormController.DiseaseAssessmentWrapper();
       dac1.isReadOnly = true;
       dac1.diseaseAssessment = da;
       
       dac1.diseaseAssessment.Clip_placed__c = dac.diseaseAssessment.Clip_placed__c;
       dac1.diseaseAssessment.Distance_from_nipple__c = dac.diseaseAssessment.Distance_from_nipple__c;
       dac1.diseaseAssessment.Longest_Diameter__c = dac.diseaseAssessment.Longest_Diameter__c;
       dac1.diseaseAssessment.O_Clock_Position_To__c = dac.diseaseAssessment.O_Clock_Position_To__c;
       dac1.diseaseAssessment.O_Clock_Position_From__c = dac.diseaseAssessment.O_Clock_Position_From__c;
       dac1.targetLesion = dac.targetLesion;
        
       List<ResponseEvaluationFormController.DiseaseAssessmentWrapper> lstDAW = new List<ResponseEvaluationFormController.DiseaseAssessmentWrapper>();
       lstDAW.add(dac1);
       rfc.lstDiseaseAssessmentWrapper = lstDAW;
       rfc.saveDiseaseAssessment();
       system.debug('lstDiseaseAssessmentWrapper-----' +rfc.lstDiseaseAssessmentWrapper[0].diseaseAssessment.Id);
       Apexpages.currentPage().getParameters().put('recordId',rfc.lstDiseaseAssessmentWrapper[0].diseaseAssessment.Id);
       rfc.editDAssessment();
       Apexpages.currentPage().getParameters().put('cancelIndex','1');
       rfc.updateRecord();
       rfc.addLesion();
       
       rfc.respEvalId = null;
      // rfc.saveMainCRF();
       
       rfc.submitCRF();
       //rfc.cancelCRF();
      // rfc.signAndSubmit();
       rfc.editCRF();
       rfc.resendCode();
       rfc.cloneCRF();
       rfc.cancelCRF();
       rfc.cancel(); 
       rfc.remove();
      }
    }  
  }
  @isTest static void ResponseEvaluationAfterTrigger() {
        // TO DO: implement unit test
        
        Account acc = new Account();
        acc.Name = 'test';
        insert acc; 
      
        Patient_Custom__c p = new Patient_Custom__c();
        p.Birthdate__c = date.newInstance(1950, 08, 05);
        p.Institution__c = acc.Id;
        p.Last_Name__c = 'test'; 
        p.Gender__c = 'Male';
        p.Race__c = 'White';
        p.Ethnicity__c = 'Not Hispanic or Latino';
        insert p;
        
        TrialPatient__c tp = new TrialPatient__c();
        tp.Patient_Id__c = p.Id;
        insert tp;
        
        Response_Evaluation_Form__c rev1 = new Response_Evaluation_Form__c();
        rev1.TrialPatient__c = tp.Id;
        rev1.Status__c = 'Approval Pending';
        rev1.Reporting__c = 'Inter-regimen';
        insert rev1;
        rev1.Status__c = 'Accepted';
        update rev1;
  }
}