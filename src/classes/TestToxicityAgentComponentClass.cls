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
private class TestToxicityAgentComponentClass {

  
      @isTest static  void myUnitTest() {
        // TO DO: implement unit test
        
        List<User> lstSiteUser = [Select u.IsActive, u.Id From User u where IsActive = true and Profile.Name = 'System Administrator'];
        System.runAs ( lstSiteUser[0] ) { 
            
        Account acc = new Account();
        acc.Name = 'testting acc';
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
        
        Agent__c agentObj = new Agent__c();
        agentObj.Name = 'test agent';
        agentObj.Display_Order__c = 0;
        insert agentObj; 
        
        Toxicity_Master__c tox = new Toxicity_Master__c();
        tox.Toxicity_Name__c = 'test1';
        tox.Grade_1__c = 'testing';
        tox.Grade_2__c = 'testing1';
        tox.Grade_3__c = 'testing3';
        tox.Grade_4__c = 'testing4';
        tox.Grade_5__c = 'testing5';
        insert tox;
        
        AE_Detail__c aedObj = new AE_Detail__c();
        aedObj.TrialPatient__c = tp.Id;
        aedObj.Visit_Date__c = date.newInstance(2012, 7, 7);
        aedObj.Patient_Hospitalized__c = true;
        insert aedObj;
        
        Arm__c armObj = new Arm__c();
        armObj.Name = 'test agent';
        insert armObj;
        
        Toxicity_Agent__c toxagentObj = new Toxicity_Agent__c ();
        toxagentObj.Toxicity_Master__c = tox.Id;
        toxagentObj.Agent__c = agentObj.Id;
        insert toxagentObj;
        
        Toxicity__c toxi1 = new Toxicity__c();
        toxi1.AE_Detail__c = aedObj.Id;
        toxi1.TrialPatient__c = tp.Id;
        toxi1.Resolved__c = true;
        toxi1.Onset_Date__c = system.today();
        toxi1.AE_End_Date__c = system.today();
        toxi1.Name = tox.Toxicity_Name__c;
        toxi1.Toxicity_Master__c = tox.Id;
        toxi1.Grade__c = 'testing';
        toxi1.Toxicity_Status__c = 'Yes';
        toxi1.Toxicity_Agent__c = toxagentObj.Id;
        toxi1.Attribution__c = '5 - Definite';
        toxi1.Patient_Complaint__c = 'test complain';
        insert toxi1;
        
        Apexpages.currentPage().getParameters().put('aeid',aedObj.Id);
        Apexpages.currentPage().getParameters().put('trialPat',tp.Id);
        ToxicityAgentComponentClass tacObj = new ToxicityAgentComponentClass();
        
        tacObj.aeid = aedObj.Id;
        tacObj.TreatmentArmId = armObj.Id;
        tacObj.trialPatId = tp.Id;
        
        tacObj.getLstWrapToxiAgent();
        
        Apexpages.currentPage().getParameters().put('toxAgentId',toxagentObj.Id);
        tacObj.saveToxicity();
        
        Apexpages.currentPage().getParameters().put('toxAgentId',toxagentObj.Id);
        tacObj.EditToxicity();
        
        Apexpages.currentPage().getParameters().put('toxAgentId',toxagentObj.Id);
        tacObj.updateCancelToxicity();
        
        Apexpages.currentPage().getParameters().put('toxAgentId',toxagentObj.Id);
        tacObj.removeToxicity(); 
        
        }
    }
  
        @isTest static void myUnitTest1() { // else if line 126 "toxi1.Toxicity_Status__c = 'No'"
        // TO DO: implement unit test
        
        List<User> lstSiteUser = [Select u.IsActive, u.Id From User u where IsActive = true and Profile.Name = 'System Administrator'];
        System.runAs ( lstSiteUser[0] ) { 
            
        Account acc = new Account();
        acc.Name = 'testting acc';
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
        
        Agent__c agentObj = new Agent__c();
        agentObj.Name = 'test agent';
        agentObj.Display_Order__c = 0;
        insert agentObj; 
        
        Toxicity_Master__c tox = new Toxicity_Master__c();
        tox.Toxicity_Name__c = 'test1';
        tox.Grade_1__c = 'testing';
        tox.Grade_2__c = 'testing1';
        tox.Grade_3__c = 'testing3';
        tox.Grade_4__c = 'testing4';
        tox.Grade_5__c = 'testing5';
        insert tox;
        
        AE_Detail__c aedObj = new AE_Detail__c();
        aedObj.TrialPatient__c = tp.Id;
        aedObj.Visit_Date__c = date.newInstance(2012, 7, 7);
        aedObj.Patient_Hospitalized__c = true;
        insert aedObj;
        
        Arm__c armObj = new Arm__c();
        armObj.Name = 'test agent';
        insert armObj;
        
        Toxicity_Agent__c toxagentObj = new Toxicity_Agent__c ();
        toxagentObj.Toxicity_Master__c = tox.Id;
        toxagentObj.Agent__c = agentObj.Id;
        insert toxagentObj;
        
        Toxicity__c toxi1 = new Toxicity__c();
        toxi1.AE_Detail__c = aedObj.Id;
        toxi1.TrialPatient__c = tp.Id;
        toxi1.Resolved__c = true;
        toxi1.Onset_Date__c = system.today();
        toxi1.AE_End_Date__c = system.today();
        toxi1.Name = tox.Toxicity_Name__c;
        toxi1.Toxicity_Master__c = tox.Id;
        toxi1.Grade__c = 'testing';
        toxi1.Toxicity_Status__c = 'No';
        toxi1.Toxicity_Agent__c = toxagentObj.Id;
        toxi1.Attribution__c = '5 - Definite';
        toxi1.Patient_Complaint__c = 'test complain';
        insert toxi1;
        
        Apexpages.currentPage().getParameters().put('aeid',aedObj.Id);
        Apexpages.currentPage().getParameters().put('trialPat',tp.Id);
        ToxicityAgentComponentClass tacObj = new ToxicityAgentComponentClass();
        
        tacObj.aeid = aedObj.Id;
        tacObj.TreatmentArmId = armObj.Id;
        tacObj.trialPatId = tp.Id;
        
        tacObj.getLstWrapToxiAgent();
        
        Apexpages.currentPage().getParameters().put('toxAgentId',toxagentObj.Id);
        tacObj.saveToxicity();
        
        
        //============================else if line 155 "toxi.Toxicity_Status__c = 'Not assessed'"=============================
        
        Toxicity__c toxi = new Toxicity__c();
        toxi.AE_Detail__c = aedObj.Id;
        toxi.TrialPatient__c = tp.Id;
        toxi.Resolved__c = true;
        toxi.Onset_Date__c = system.today();
        toxi.AE_End_Date__c = system.today();
        toxi.Name = tox.Toxicity_Name__c;
        toxi.Toxicity_Master__c = tox.Id;
        toxi.Grade__c = 'testing';
        toxi.Toxicity_Status__c = 'Not assessed';
        toxi.Toxicity_Agent__c = toxagentObj.Id;
        toxi.Attribution__c = '5 - Definite';
        toxi.Patient_Complaint__c = 'test complain';
        insert toxi;
        
        Apexpages.currentPage().getParameters().put('aeid',aedObj.Id);
        Apexpages.currentPage().getParameters().put('trialPat',tp.Id);
        ToxicityAgentComponentClass tacObj1 = new ToxicityAgentComponentClass();
        
        tacObj1.aeid = aedObj.Id;
        tacObj1.TreatmentArmId = armObj.Id;
        tacObj1.trialPatId = tp.Id;
        
        tacObj1.getLstWrapToxiAgent();
        
        Apexpages.currentPage().getParameters().put('toxAgentId',toxagentObj.Id);
        tacObj1.saveToxicity(); 
        
        
        }
    }
}