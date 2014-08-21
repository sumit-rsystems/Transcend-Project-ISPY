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
private class TestRandomizationBeforeTrigger {

    @isTest static void myUnitTest() {
        // TO DO: implement unit test
        List<User> lstSiteUser = [Select u.IsActive, u.Id From User u where IsActive = true];     
        System.runAs ( lstSiteUser[0] ) { 
        
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
        
        Arm__c arm = new Arm__c();
        arm.Name = 'Randomized';
        insert arm;
        
        ArmPatient__c armPat = new ArmPatient__c();
        armPat.Arm_Id__c = arm.Id;
        armpat.TrialPatient__c = tp.Id;
        armPat.assignedToPatient__c = true;
        insert armPat;
        
        Randomization_Form__c rfc = new Randomization_Form__c();
        rfc.TrialPatient__c = tp.Id;
        rfc.Did_Patient_Sign_Treatment_Consent_Form__c = true;
        rfc.Randomization_Result__c = 'Randomized';
        rfc.Status__c = 'Accepted';
        insert rfc;
        update rfc;
        
      }
   }
}