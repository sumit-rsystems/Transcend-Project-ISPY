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
private class TestCTCAECodeLoader {

   
      @isTest static void myUnitTest() {
        
        SymptomMaster__c smObject = new SymptomMaster__c();
        smObject.Name = 's1';
        insert smObject;
        
        Toxicity_Master__c toxObject = new Toxicity_Master__c();
        toxObject.Symptom__c = smObject.Name;
        toxObject.Symptom_Master__c = smObject.Id;
        toxObject.Toxicity_Name__c = 't1';
        toxObject.Grade_1__c = 'testing';
        toxObject.Grade_2__c = 'testing1';
        toxObject.Grade_3__c = 'testing3';
        toxObject.Grade_4__c = 'testing4';
        toxObject.Grade_5__c = 'testing5';
        insert toxObject;
        
        SymptomMaster__c smObject1 = new SymptomMaster__c();
        smObject1.Name = 's2';
        insert smObject1;
        
        Toxicity_Master__c toxObject1 = new Toxicity_Master__c();
        toxObject1.Symptom__c = smObject1.Name;
        toxObject1.Symptom_Master__c = smObject1.Id;
        toxObject1.Toxicity_Name__c = 't2';
        toxObject1.Grade_1__c = 'testing1';
        toxObject1.Grade_2__c = 'testing2';
        toxObject1.Grade_3__c = 'testing3';
        toxObject1.Grade_4__c = 'testing4';
        toxObject1.Grade_5__c = 'testing5';
        insert toxObject1;
        
        CTCAECodeLoader loadObject = new CTCAECodeLoader();
        
        loadObject.fileBody = Blob.valueOf('"s1"\n"s2"\n"s3"');
        loadObject.fileName = 'symptoms.csv';
        loadObject.storeCSVRecords();
        
        loadObject.fileBody = Blob.valueOf('"s1","t1","c1","1","gd1"\n1"s2","t2","c2","2","gd2"\n1"s3","t3","c3","3","gd4"\n"s1","t1","c1","4","gd1"\n"s2","t2","c2","5","gd2"');
        loadObject.fileName = 'toxicity.csv';
        loadObject.storeCSVRecords();
        
        loadObject.fileBody = Blob.valueOf('"s1","t1","c1"\n"s2","t2","c2"\n"s3","t3","c3"');
        loadObject.fileName = 'ctcCodes.csv';
        loadObject.storeCSVRecords(); 
        
    }
}