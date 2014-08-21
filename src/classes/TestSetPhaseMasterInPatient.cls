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
private class TestSetPhaseMasterInPatient {

    @isTest static void myUnitTest1() {
        Account acc = new Account();
        acc.Name = 'testing';
        insert acc;
        
        Phase_Master__c phMaster1 = new Phase_Master__c();
        phMaster1.Name = 'Screening';
        phMaster1.Order__c = 300;  
        insert phMaster1;
        
        Phase_Master__c phMaster2 = new Phase_Master__c();
        phMaster2.Name = 'Treatment';
        phMaster2.Order__c = 301;  
        insert phMaster2;
        
        Phase_Master__c phMaster3 = new Phase_Master__c();
        phMaster3.Name = 'Follow Up';
        phMaster3.Order__c = 302;  
        insert phMaster3;
        
        Patient_Custom__c pt = new Patient_Custom__c();
        pt.Name = 'testPatient';
        pt.Institution__c = acc.id;
        pt.Last_Name__c = 'test';
        pt.Birthdate__c = date.newInstance(1970, 04, 05);
        pt.Gender__c = 'Male';
        pt.Race__c = 'White';
        pt.Ethnicity__c = 'Not Hispanic or Latino';
        pt.TestHarnessId__c = 'asc002';
        insert pt;
        
        Trial__c tc = new Trial__c();
        tc.Name = 'testTrial';
        insert tc;
        
        TrialPatient__c tpObj = new TrialPatient__c();
        tpObj.Patient_Id__c = pt.Id;    
        tpObj.Trial_Id__c = tc.Id;
        insert tpObj;
        
        Randomization_Form__c rfc = new Randomization_Form__c();
        rfc.TrialPatient__c = tpObj.Id;
        rfc.Why_Patient_Not_Signed_Consent_Form__c = 'Patient found to be ineligible for the study';
        rfc.Status__c = 'Approval Not Required';
        insert rfc;
        Randomization_Form__c rfc2 = [select Status__c from Randomization_Form__c where id = :rfc.id];
        update rfc2;
        
        Off_Study_Detail__c osd = new Off_Study_Detail__c();
        osd.TrialPatient__c = tpObj.Id;
        osd.Status__c = 'Approval Pending';
        insert osd;
        Off_Study_Detail__c osd2 = [select Status__c from Off_Study_Detail__c where id = :osd.id];
        osd2.Status__c = 'Accepted';
        update osd2;
        
    }
}