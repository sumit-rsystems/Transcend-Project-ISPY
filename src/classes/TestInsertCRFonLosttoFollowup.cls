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
private class TestInsertCRFonLosttoFollowup {

    @isTest static void myUnitTest1() {
        Account acc = new Account();
        acc.Name = 'testing';
        insert acc;
        
        CRFMaster__c crfMaster = new CRFMaster__c();
        crfMaster.CRFType__c = 'Registration__c';
        crfMaster.Object_Name__c = 'Registration__c';
        insert crfMaster;
        
        Phase_Master__c phMaster = new Phase_Master__c();
        phMaster.Name = 'Screening';
        phMaster.Order__c = 108;  
        insert phMaster;
        
        Phase_Cycle__c phc = new Phase_Cycle__c();
        phc.Phase__c = phMaster.id;
        phc.Order__c = 110;
        insert phc;
        
        Phase_CRFs__c phCrf = new Phase_CRFs__c();
        phCrf.Phase_Cycle__c = phc.id;
        phCrf.CRF__c = crfMaster.Id;
        insert phCrf;
        
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
        
        
        Lost_to_Follow_Up__c lf = new Lost_to_Follow_Up__c();
        lf.TrialPatient__c = tpObj.id;
        insert lf;
        
        Lost_to_Follow_Up__c lf2 = [select id from Lost_to_Follow_Up__c where id = :lf.id];
        update lf2;
    }
}