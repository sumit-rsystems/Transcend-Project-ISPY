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
private class TestAddToxicityComponent {

   
      @isTest  static  void myUnitTest() {
        // TO DO: implement unit test
        List<User> lstSiteUser = [Select u.IsActive, u.Id From User u where IsActive = true and id =: userinfo.getUserId()];
        System.runAs ( lstSiteUser[0] ) { 
            
        Account acc = new Account();
        List<Account> lstAccount = [Select a.Id From Account a limit 1];
        system.debug('-------lstAccount-------'+lstAccount);
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
        
        Trial__c trial1 = new Trial__c();
        trial1.Name='test Trial 1';
        insert trial1;  
            
        TrialPatient__c tp = new TrialPatient__c();
        tp.Patient_Id__c = p.Id;
        tp.Trial_Id__c = trial1.Id;
        insert tp;
        
        SymptomMaster__c smc = new SymptomMaster__c();
        smc.Name = 'test';
        insert smc;
        
        Toxicity_Master__c tox = new Toxicity_Master__c();
        tox.Symptom__c = smc.Name;
        tox.Symptom_Master__c = smc.Id;
        tox.Toxicity_Name__c = 'test1';
        tox.Grade_1__c = 'testing';
        tox.Grade_2__c = 'testing1';
        tox.Grade_3__c = 'testing3';
        tox.Grade_4__c = 'testing4';
        tox.Grade_5__c = 'testing5';
        insert tox;
        
        BaselineSymptomsForm__c bsf = new BaselineSymptomsForm__c();
        bsf.TrialPatient__c = tp.Id;
        bsf.Visit_Date__c = system.today();
        insert bsf;
        
        bsf.Status__c = 'Accepted';
        update bsf;
        
        AE_Detail__c aed1 = new AE_Detail__c();
        aed1.TrialPatient__c = tp.Id;
        aed1.Visit_Date__c = date.newInstance(2012, 7, 7);
        aed1.Patient_Hospitalized__c = true;
        insert aed1;
        
        aed1.Status__c = 'Accepted';
        update aed1;
        
        Toxicity__c toxi1 = new Toxicity__c();
        toxi1.AE_Detail__c = aed1.Id;
        toxi1.TrialPatient__c = tp.Id;
        toxi1.Symptom_Masters__c = smc.Id;
        toxi1.Resolved__c = true;
        toxi1.Onset_Date__c = system.today();
        toxi1.AE_End_Date__c = system.today();
        toxi1.Name = tox.Toxicity_Name__c;
        toxi1.Toxicity_Master__c = tox.Id;
        toxi1.Grade__c = 'testing';
        toxi1.Toxicity_Status__c = 'Yes';
        insert toxi1;
        
        Apexpages.currentPage().getParameters().put('aeid',aed1.Id);
        Apexpages.currentPage().getParameters().put('baselineid',bsf.Id);
        Apexpages.currentPage().getParameters().put('trialPat',tp.Id);
        
        AddToxicityComponent atc = new AddToxicityComponent();
        
        /*AddToxicityComponent.ToxicityWrapper tw = new AddToxicityComponent.ToxicityWrapper(); 
        tw.toxicity = toxi1;
        tw.toxiNumber = 1;*/
        
        //AddToxicityComponent.SymptomsWrapper sw = new AddToxicityComponent.SymptomsWrapper();
        //sw.symptomArm = sym;
        //sw.lstToxicityWrapper.add(tw);
        
        //List<AddToxicityComponent.SymptomsWrapper> swList = new List<AddToxicityComponent.SymptomsWrapper>();
        //swList.add(sw);
        
        atc.aeid = aed1.Id;
        List<AddToxicityComponent.SymptomsWrapper> swList = atc.getLstSymptomsWrapper();
        
        atc.setLstSymptomsWrapper(swList);
        
        Apexpages.currentPage().getParameters().put('symptomId',smc.Id);
        Apexpages.currentPage().getParameters().put('toxiNum','1');
        atc.EditToxicity();
        atc.updateToxicity();
        
        //atc.selectedtoxicityName = tox.Id;
        
        atc.addToxicity();
        atc.addGrade();
        atc.saveToxicity();
        Apexpages.currentPage().getParameters().put('toxiNum','1');
        atc.updateCancelToxicity();
        atc.removeToxicity();
        
        Apexpages.currentPage().getParameters().put('symptomId',smc.Id);
        atc.cancelToxicity();
        
        Apexpages.currentPage().getParameters().put('symptomId',smc.Id);
        atc.changeToxicitySymptomStatus();
        }
      }
   }
}