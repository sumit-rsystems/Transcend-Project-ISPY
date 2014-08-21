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
private class TestChemoTreatmentAfterInsertUpdate {

   
      @isTest static void myUnitTest() {
        // TO DO: implement unit test
        
        Account acc = new Account();
        acc.Name = 'test';
        insert acc;

        Patient_Custom__c p = new Patient_Custom__c();
        p.Birthdate__c = date.newInstance(1980, 08, 05);
        p.Institution__c = acc.Id;
        p.Last_Name__c = 'test'; 
        p.Gender__c = 'Male';
        p.Race__c = 'White';
        p.Ethnicity__c = 'Not Hispanic or Latino';
        insert p;
            
        TrialPatient__c tp = new TrialPatient__c();
        tp.Patient_Id__c = p.Id;
        insert tp;
        
        CRF__c crfObject = new CRF__c();
        crfObject.Patient__c = p.Id;
        crfObject.Status__c = 'Approval Pending';
        crfObject.TrialPatient__c = tp.Id;
        insert crfObject;
        update crfObject;
        
        Snomed_Code__c snomed = new Snomed_Code__c();
        snomed.TrialPatient__c = tp.Id;
        snomed.CRF__c = crfObject.Id;
        insert snomed;
         
        Chemo_Treatment__c chemo = new Chemo_Treatment__c();
        chemo.TrialPatient__c = tp.Id;
        chemo.Cycle_number__c = 2.0;
        chemo.Date_of_therapy__c = date.newInstance(2012, 6, 6);
        chemo.Status__c = 'Approval Pending';
        chemo.CRF__c = crfObject.Id;
        insert chemo;
        update chemo;
        
    }
    
    @isTest static void myUnitTest1() {
        // TO DO: implement unit test
        
        Account acc = new Account();
        acc.Name = 'test';
        insert acc;
        
        Patient_Custom__c p = new Patient_Custom__c();
        p.Birthdate__c = date.newInstance(1980, 08, 05);
        p.Institution__c = acc.Id;
        p.Last_Name__c = 'test'; 
        p.Gender__c = 'Male';
        p.Race__c = 'White';
        p.Ethnicity__c = 'Not Hispanic or Latino';
        insert p;
            
        TrialPatient__c tp = new TrialPatient__c();
        tp.Patient_Id__c = p.Id;
        insert tp;
        
        CRF__c crfObject = new CRF__c();
        crfObject.Patient__c = p.Id;
        crfObject.Status__c = 'Accepted';
        crfObject.TrialPatient__c = tp.Id;
        insert crfObject;
        update crfObject;
        
        Snomed_Code__c snomed = new Snomed_Code__c();
        snomed.TrialPatient__c = tp.Id;
        snomed.CRF__c = crfObject.Id;
        insert snomed;
            
        Chemo_Treatment__c chemo = new Chemo_Treatment__c();
        chemo.TrialPatient__c = tp.Id;
        chemo.Cycle_number__c = 2.0;
        chemo.Date_of_therapy__c = date.newInstance(2012, 6, 6);
        chemo.Status__c = 'Accepted';
        chemo.CRF__c = crfObject.Id;
        insert chemo;
        update chemo;
        
    }
}