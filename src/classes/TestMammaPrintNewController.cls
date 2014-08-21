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
private class TestMammaPrintNewController {

   @isTest static void myUnitTest() {
        // TO DO: implement unit test
        
        List<User> lstSiteUser = [Select u.IsActive, u.Id, SecurityCode__c From User u where IsActive = true and Profile.Name = 'Site User'];     
        System.runAs ( lstSiteUser[0] ) { 
        
        Account inst1 = new Account();
        
        List<Account> lstAccount = [Select a.Id From Account a limit 1];
        
        if(!lstAccount.isEmpty()){
            
        inst1 = lstAccount[0];
        
        Patient_Custom__c p = new Patient_Custom__c();
        p.Birthdate__c = date.newInstance(1960, 8, 7);
        p.Institution__c = inst1.Id;
        p.Last_Name__c = 'test'; 
        p.Gender__c = 'Male';
        p.Race__c = 'White';
        p.Ethnicity__c = 'Not Hispanic or Latino';
        insert p;
        
        TrialPatient__c tp = new TrialPatient__c();
        tp.Patient_Id__c = p.Id;
        insert tp;
        
        TissueSpecimenDetail__c ts = new TissueSpecimenDetail__c();
        ts.Status__c = 'completed';
        ts.ProcedureDate__c = date.newInstance(2012, 8, 10);
        ts.Time_Point__c = 'Pre-treatment'; 
        ts.TrialPatient__c = tp.Id;
        insert ts;
        
        Core_Biopsy_Specimens__c cb = new Core_Biopsy_Specimens__c();
        cb.SpecimenID__c = '1111';
        cb.TissueSpecimenDetail__c = ts.Id;
        insert cb;
        
        MammaPrintDetail__c mpd = new MammaPrintDetail__c();
        mpd.TrialPatient__c = tp.Id;
        mpd.Tissue_Specimen_Detail__c = ts.Id;
        mpd.Report_Date__c = date.newInstance(2011, 7, 7);
        mpd.MammaPrint_Index__c = 0.5;
        mpd.MammaPrint_Risk__c = 'Low risk';
        mpd.Status__c = 'Approval Pending';
        insert mpd;
        mpd.Status__c = 'Completed';
        update mpd;
        
        Apexpages.currentPage().getParameters().put('trialPat',tp.Id);
        Apexpages.standardcontroller reg = new ApexPages.StandardController(mpd);
        MammaPrintNewController mpd1 = new MammaPrintNewController(reg); 
        mpd1.selectSpecimenUsed = cb.Id;
        
        mpd1.collectSpecimenIDs();
        mpd1.selectSpecimen = ts.Id;
        mpd1.collectSpecimenIDs();
        mpd1.specimenCollectionDate();
        
        mpd1.currentTab = 'FirstTab';
        mpd1.selectSpecimen = ts.Id;
        mpd1.next();
        Apexpages.currentPage().getParameters().put('nextTab','saveAndClose');
        mpd1.nextTabName = 'saveAndClose';
        mpd1.next();
        
        mpd1.currentTab = 'SecondTab';
        mpd1.previous();
        mpd1.complete();
        mpd1.getCompletedFormList();
        
        }
      }
   } 
    @isTest static void myUnitTest1() {
        
        List<User> lstSiteUser = [Select u.IsActive, u.Id, SecurityCode__c From User u where IsActive = true and Profile.Name = 'Site User'];     
        System.runAs ( lstSiteUser[0] ) { 
        
        Account inst1 = new Account();
        
        List<Account> lstAccount = [Select a.Id From Account a limit 1];
        
        if(!lstAccount.isEmpty()){
            
        inst1 = lstAccount[0];
        
        Patient_Custom__c p = new Patient_Custom__c();
        p.Birthdate__c = date.newInstance(1960, 8, 7);
        p.Institution__c = inst1.Id;
        p.Last_Name__c = 'test'; 
        p.Gender__c = 'Male';
        p.Race__c = 'White';
        p.Ethnicity__c = 'Not Hispanic or Latino';
        insert p;
        
        TrialPatient__c tp = new TrialPatient__c();
        tp.Patient_Id__c = p.Id;
        insert tp;
        
        TissueSpecimenDetail__c ts1 = new TissueSpecimenDetail__c();
        ts1.Status__c = 'Not Completed';
        ts1.ProcedureDate__c = date.newInstance(2012, 8, 6);
        ts1.TrialPatient__c = tp.Id;
        ts1.Time_Point__c = 'Pre-Treatment Re-Biopsy';
        insert ts1;
        update ts1; 
        
        MammaPrintDetail__c mpd2 = new MammaPrintDetail__c();
        mpd2.TrialPatient__c = tp.Id;
        mpd2.Tissue_Specimen_Detail__c = ts1.Id;
        mpd2.Report_Date__c = date.newInstance(2011, 8, 7);
        mpd2.MammaPrint_Index__c = 0.5;
        mpd2.MammaPrint_Risk__c = 'Low risk';
        mpd2.Status__c = 'Approval Pending';
        insert mpd2;
        mpd2.Status__c = 'Completed';
        update mpd2;
        
        Apexpages.currentPage().getParameters().put('trialPat',tp.Id);
        Apexpages.standardcontroller reg1 = new ApexPages.StandardController(mpd2);
        MammaPrintNewController mpd3 = new MammaPrintNewController(reg1); //first constructor 
        mpd3.specimenCollectionDate();
        
        
        mpd3.signAndSubmit();
        mpd3.cancelCRF();
        mpd3.resendCode();
        }
      }
   } 
   @isTest static void myUnitTest2() { // line 120 "lstTissueSpecimen = empty" also covering "MammaPrintAfterTrigger"
        
        List<User> lstSiteUser = [Select u.IsActive, u.Id, SecurityCode__c From User u where IsActive = true and Profile.Name = 'Site User'];     
        System.runAs ( lstSiteUser[0] ) { 
        
        Account inst1 = new Account();
        
        List<Account> lstAccount = [Select a.Id From Account a limit 1];
        
        if(!lstAccount.isEmpty()){
            
        inst1 = lstAccount[0];
        
        Patient_Custom__c p = new Patient_Custom__c();
        p.Birthdate__c = date.newInstance(1960, 8, 7);
        p.Institution__c = inst1.Id;
        p.Last_Name__c = 'test'; 
        p.Gender__c = 'Male';
        p.Race__c = 'White';
        p.Ethnicity__c = 'Not Hispanic or Latino';
        insert p;
        
        TrialPatient__c tp = new TrialPatient__c();
        tp.Patient_Id__c = p.Id;
        insert tp;
        
        TissueSpecimenDetail__c ts1 = new TissueSpecimenDetail__c();
        ts1.Status__c = null;
        ts1.ProcedureDate__c = date.newInstance(2012, 8, 6);
        ts1.TrialPatient__c = tp.Id;
        ts1.Time_Point__c = 'Pre-Treatment Re-Biopsy';
        insert ts1;
        update ts1;
        
        MammaPrintDetail__c mpd2 = new MammaPrintDetail__c();
        mpd2.TrialPatient__c = tp.Id;
        mpd2.Tissue_Specimen_Detail__c = ts1.Id;
        mpd2.Report_Date__c = date.newInstance(2011, 8, 7);
        mpd2.MammaPrint_Index__c = 0.5;
        mpd2.MammaPrint_Risk__c = 'Low risk';
        mpd2.Status__c = 'Approval Pending';
        insert mpd2;
        mpd2.Status__c = 'Approval Not Required';
        update mpd2;
        
        Apexpages.currentPage().getParameters().put('trialPat',tp.Id);
        Apexpages.standardcontroller reg1 = new ApexPages.StandardController(mpd2);
        MammaPrintNewController mpd3 = new MammaPrintNewController(reg1);  
        mpd3.specimenCollectionDate();
        
        }
      }
   } 
}