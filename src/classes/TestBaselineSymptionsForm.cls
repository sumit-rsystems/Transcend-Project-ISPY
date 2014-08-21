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
private class TestBaselineSymptionsForm {

    @isTest static void myUnitTest() {
            
        List<User> thisUser = [ select u.Id , u.IsActive from User u where IsActive = true and id =: userinfo.getUserId()];
        System.runAs (thisUser[0]){
        
        Account acc = new Account();
        
        List<Account> lstAccount = [Select a.Id From Account a limit 1];
        
        if(!lstAccount.isEmpty()){
            
        acc = lstAccount[0];  
        
        Patient_Custom__c p = new Patient_Custom__c();
        p.Birthdate__c = date.newInstance(1950, 08, 05);
        p.Institution__c = acc.Id;
        p.Last_Name__c = 'test'; 
        p.Gender__c = 'Male';
        p.Race__c = 'White';
        p.Ethnicity__c = 'Not Hispanic or Latino';
        insert p;
        
        CRF__c crfObject = new CRF__c();
        crfObject.Patient__c = p.Id;
        crfObject.Status__c = 'Approval Pending';
        insert crfObject;
        
        crfObject.Status__c = 'Accepted';
        update crfObject;
        
        TrialPatient__c tp = new TrialPatient__c();
        tp.Patient_Id__c = p.Id;
        insert tp;
        
        Apexpages.currentPage().getParameters().put('trialPat',tp.Id);
        
        BaselineSymptomsForm__c dummyBSF = new BaselineSymptomsForm__c();
        Apexpages.StandardController dummystd = new Apexpages.StandardController(dummyBSF);
        BaselineSymptomsFormController dummybsfController = new BaselineSymptomsFormController(dummystd);
        dummybsfController.cancelCRF();
        dummybsfController.saveMainCRF();
        dummybsfController.cancelCRF();    
        
        BaselineSymptomsForm__c bsf = new BaselineSymptomsForm__c();
        bsf.TrialPatient__c = tp.Id;
        bsf.Visit_Date__c = system.today();
        bsf.CRF__c = crfObject.Id;
        bsf.Status__c = 'Approval Pending';
        insert bsf;
        update bsf;
        
        Allergy__c al = new Allergy__c();
        al.Allergy_Type__c = 'Drug';
        al.BaselineSymptomsForm__c = bsf.Id;
        insert al;
        
        Daignosis_Master__c diaObject = new Daignosis_Master__c();
        diaObject.SCTID__c = 'test';
        insert diaObject;
        
        BaselineCondition__c bc = new BaselineCondition__c();
        bc.BaselineSymptomsForm__c = bsf.Id;
        bc.Daignosis__c = diaObject.Id;
        insert bc;
        
        ComponentControllerBase ccb = new ComponentControllerBase(); // VIRTUAL CLASS "ComponentControllerBase"
        ccb.key = '1';
        
        PageControllerBase pcb = new PageControllerBase(); // VIRTUAL CLASS "PageControllerBase" BEGINS HERE
        pcb.getAddToxicityCompController();
        pcb.getComponentControllerMap();
        
        pcb.setComponentControllerMap('1', ccb);
        pcb.setAddToxicityCompController(ccb);
        
        Apexpages.currentPage().getParameters().put('baselineid',bsf.Id);
        Apexpages.StandardController std = new Apexpages.StandardController(bsf);
        BaselineSymptomsFormController bsfController = new BaselineSymptomsFormController(std);
        
        bsfController.getComponentControllerMap();
        bsfController.getAddToxicityCompController();
        bsfController.setComponentControllerMap('1', ccb);
        bsfController.setAddToxicityCompController(ccb);
       // bsfController.callAddToxicityControllerMethod(bsf.Id);
        
        bsfController.addAllergy();
        
        Apexpages.currentPage().getParameters().put('allergyNumber','1');
        for(BaselineSymptomsFormController.AllergyWrapper aWrapper : bsfController.lstAllergyWrapper) {
            if(aWrapper.allergyNumber == '1') {
                aWrapper.allergy.Allergy_Type__c = 'Other';
            }
        }
        bsfController.changeAllergyType();
        
        Apexpages.currentPage().getParameters().put('allergyNumber','1');
        for(BaselineSymptomsFormController.AllergyWrapper aWrapper : bsfController.lstAllergyWrapper) {
            if(aWrapper.allergyNumber == '1') {
                aWrapper.allergy.Allergy_Type__c = 'Drug';
            }
        }
        bsfController.changeAllergyType();
        bsfController.saveAllergy();
        bsfController.editAllergy();
        bsfController.updateAllergy();
        Apexpages.currentPage().getParameters().put('cancelIndex','1');
        bsfController.cancelAllergy();
        for(BaselineSymptomsFormController.AllergyWrapper aWrapper : bsfController.lstAllergyWrapper) {
            if(aWrapper.allergyNumber == '1') {
                Apexpages.currentPage().getParameters().put('recordId',aWrapper.allergy.Id);
            }
        }
        bsfController.editAllergy();
        bsfController.updateAllergy();
        bsfController.cancelAllergy();
        bsfController.removeAllergy();
        bsfController.getAllergySNo();
        
       }
    }
 }
 @isTest static void myUnitTest1() {
            
        List<User> thisUser = [ select u.Id , u.IsActive from User u where IsActive = true and id =: userinfo.getUserId()];
        System.runAs (thisUser[0]){
        
        Account acc = new Account();
        
        List<Account> lstAccount = [Select a.Id From Account a limit 1];
        
        if(!lstAccount.isEmpty()){
            
        acc = lstAccount[0];  
        
        Patient_Custom__c p = new Patient_Custom__c();
        p.Birthdate__c = date.newInstance(1950, 08, 05);
        p.Institution__c = acc.Id;
        p.Last_Name__c = 'test'; 
        p.Gender__c = 'Male';
        p.Race__c = 'White';
        p.Ethnicity__c = 'Not Hispanic or Latino';
        insert p;
        
        CRF__c crfObject = new CRF__c();
        crfObject.Patient__c = p.Id;
        crfObject.Status__c = 'Approval Pending';
        insert crfObject;
        
        crfObject.Status__c = 'Accepted';
        update crfObject;
        
        TrialPatient__c tp = new TrialPatient__c();
        tp.Patient_Id__c = p.Id;
        insert tp;
        
        Apexpages.currentPage().getParameters().put('trialPat',tp.Id);
        
        BaselineSymptomsForm__c dummyBSF = new BaselineSymptomsForm__c();
        Apexpages.StandardController dummystd = new Apexpages.StandardController(dummyBSF);
        BaselineSymptomsFormController dummybsfController = new BaselineSymptomsFormController(dummystd);
        dummybsfController.cancelCRF();
        dummybsfController.saveMainCRF();
        dummybsfController.cancelCRF();    
        
        BaselineSymptomsForm__c bsf = new BaselineSymptomsForm__c();
        bsf.TrialPatient__c = tp.Id;
        bsf.Visit_Date__c = system.today();
        bsf.CRF__c = crfObject.Id;
        bsf.Status__c = 'Approval Pending';
        insert bsf;
        update bsf;
        
        Allergy__c al = new Allergy__c();
        al.Allergy_Type__c = 'Drug';
        al.BaselineSymptomsForm__c = bsf.Id;
        insert al;
        
        Daignosis_Master__c diaObject = new Daignosis_Master__c();
        diaObject.SCTID__c = 'test';
        insert diaObject;
        
        BaselineCondition__c bc = new BaselineCondition__c();
        bc.BaselineSymptomsForm__c = bsf.Id;
        bc.Daignosis__c = diaObject.Id;
        insert bc;
        
        Apexpages.currentPage().getParameters().put('baselineid',bsf.Id);
        Apexpages.StandardController std = new Apexpages.StandardController(bsf);
        BaselineSymptomsFormController bsfController = new BaselineSymptomsFormController(std);
        
        Apexpages.currentPage().getParameters().put('tabNext','saveAndClose');
        bsfController.nextTabName = 'saveAndClose';
        bsfController.next();
        
        Apexpages.currentPage().getParameters().put('tabNext','CompleteTab');
        bsfController.nextTabName = 'CompleteTab';
        bsfController.next();
        
        bsfController.currentTab = 'BaselineSymptomsTab';
        bsfController.previous();
        
        bsfController.currentTab = 'AllergyBaselineTab';
        bsfController.previous();
        
        bsfController.signAndSubmit();
        bsfController.cancelCRF();
       }
    }
 }
    @isTest static void unitTestForDaignosisMethods() {
        
        List<User> thisUser = [ select u.Id , u.IsActive from User u where IsActive = true and id =: userinfo.getUserId()];
        System.runAs (thisUser[0]){
        
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
        
        Apexpages.currentPage().getParameters().put('trialPat',tp.Id);
        
        BaselineSymptomsForm__c dummyBSF = new BaselineSymptomsForm__c();
        Apexpages.StandardController dummystd = new Apexpages.StandardController(dummyBSF);
        BaselineSymptomsFormController dummybsfController = new BaselineSymptomsFormController(dummystd);
        
        dummybsfController.saveMainCRF();   
        
        dummybsfController.currentTab = 'CompleteTab';
        dummybsfController.previous();    
        
        BaselineSymptomsForm__c bsf = new BaselineSymptomsForm__c();
        bsf.TrialPatient__c = tp.Id;
        bsf.Visit_Date__c = system.today();
        insert bsf;
        
        Allergy__c al = new Allergy__c();
        al.Allergy_Type__c = 'Drug';
        al.BaselineSymptomsForm__c = bsf.Id;
        insert al;
        
        Daignosis_Master__c diaObject = new Daignosis_Master__c();
        diaObject.SCTID__c = 'test';
        insert diaObject;
        
        BaselineCondition__c bc = new BaselineCondition__c();
        bc.BaselineSymptomsForm__c = bsf.Id;
        bc.Daignosis__c = diaObject.Id;
        insert bc;
        
        Apexpages.currentPage().getParameters().put('baselineid',bsf.Id);
        Apexpages.StandardController std = new Apexpages.StandardController(bsf);
        BaselineSymptomsFormController bsfController = new BaselineSymptomsFormController(std);
        
        bsfController.addDiagnosis();
        bsfController.saveDiagnosis();
        bsfController.editDiagnosis();
        bsfController.updateDiagnosis();
        Apexpages.currentPage().getParameters().put('cancelIndex','1');
        bsfController.cancelDiagnosis();
        for(BaselineSymptomsFormController.BaselineConditionWrapper bWrapper : bsfController.lstConditionWrapper) {
            if(bWrapper.conditionNumber == '1') {
                Apexpages.currentPage().getParameters().put('recordId',bWrapper.baselineCondition.Id);
                Apexpages.currentPage().getParameters().put('conditionNumber','1');
            }
            bWrapper.baselineCondition.DiagnosisType__c = 'Other';
        //  bWrapper.baselineCondition.Daignosis__c = bc.Id;
        }
        bsfController.addDiagnosis();
       // bsfController.saveDiagnosis();
        bsfController.changeDiagnosisType();
        bsfController.editDiagnosis();
        bsfController.updateDiagnosis();
        Apexpages.currentPage().getParameters().put('cancelIndex','4');
        bsfController.cancelDiagnosis();
        bsfController.removeDiagnosis();
        bsfController.getConditionSNo();
        
        bsfController.currentTab = 'attachmentTab';
        bsfController.previous();
     }
    }
  }
}