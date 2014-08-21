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
private class TestCTCAECodeManager {

    
    @isTest static  void myUnitTest() {
        // TO DO: implement unit test
        
        SymptomMaster__c smObject = new SymptomMaster__c();
        smObject.Name = 'test';
        insert smObject;
        
        Toxicity_Master__c toxObject = new Toxicity_Master__c();
        toxObject.Symptom__c = smObject.Name;
        toxObject.Symptom_Master__c = smObject.Id;
        toxObject.Toxicity_Name__c = 'test1';
        toxObject.Grade_1__c = 'testing';
        toxObject.Grade_2__c = 'testing1';
        toxObject.Grade_3__c = 'testing3';
        toxObject.Grade_4__c = 'testing4';
        toxObject.Grade_5__c = 'testing5';
        insert toxObject;
        
        CTCAECodeMaster__c cmObject = new CTCAECodeMaster__c();
        cmObject.Symptom_Master__c = smObject.Id;
        cmObject.Toxicity_Master__c = toxObject.Id;
        insert cmObject;
        
        CTCAECodeManager ctObj = new CTCAECodeManager();
        CTCAECodeManager.getCodeForSymptomAndToxicity(smObject.Id, toxObject.Id);
    }
}