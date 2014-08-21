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
private class TestOnStudyEligibilityBeforeInsert {

    @isTest static void myUnitTest() {
        // TO DO: implement unit test
        
        Account acc1 = new Account();
        acc1.Name = 'test';
        insert acc1;
        
        Patient_Custom__c pc = new Patient_Custom__c();
        pc.First_Name__c = 'test';
        pc.Last_Name__c = 'test';
        pc.Gender__c = 'Male';
        pc.Birthdate__c = system.today();
        pc.Race__c = 'White';
        pc.Ethnicity__c = 'Not Hispanic or Latino';
        pc.Institution__c = acc1.Id;
        pc.Medical_Record_Number__c = '3434';
        pc.Signed_Screening__c = true;
        insert pc;
        
        TrialPatient__c tp = new TrialPatient__c();
        tp.Patient_Id__c = pc.Id;
        insert tp;
        
        CRF__c crfObject = new CRF__c();
        crfObject.Patient__c = pc.Id;
        crfObject.Status__c = 'Approval Pending';
        crfObject.TrialPatient__c = tp.Id;
        insert crfObject;
        update crfObject;
        
        Snomed_Code__c snomed = new Snomed_Code__c();
        snomed.TrialPatient__c = tp.Id;
        snomed.CRF__c = crfObject.Id;
        insert snomed;
        
        On_Study_Eligibility_Form__c osef = new On_Study_Eligibility_Form__c();
        osef.TrialPatient__c = tp.Id;
        osef.How_was_the_cancer_first_detected__c = 'Clinical exam'; 
        osef.Status__c = 'Approval Pending';
        osef.CRF__c = crfObject.Id;
        insert osef;
        
        osef.Status__c = 'Accepted';
        update osef;
  }
}