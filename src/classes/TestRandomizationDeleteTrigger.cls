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
private class TestRandomizationDeleteTrigger {

    @isTest static void myUnitTest() {
        
        Account acc = new Account();

        List<Account> lstAccount = [select Id from Account limit 1];
            
        if(lstAccount.isEmpty()) return;
                
        acc = lstAccount[0];
        
        Patient_Custom__c p = new Patient_Custom__c();
        p.Birthdate__c = date.newInstance(1960, 8, 7);
        p.Institution__c = acc.Id;
        p.Last_Name__c = 'test'; 
        p.Gender__c = 'Male';
        p.Race__c = 'White';
        p.Ethnicity__c = 'Not Hispanic or Latino';
        insert p;
            
        TrialPatient__c tp = new TrialPatient__c();
        tp.FirstName__c = 'a';
        tp.LastName__c = 'b';
        tp.Patient_Id__c = p.Id;
        insert tp;
        
        Randomization_Form__c rfc = new Randomization_Form__c();
        rfc.TrialPatient__c = tp.Id;
        rfc.Why_Patient_Not_Signed_Consent_Form__c = 'Patient found to be ineligible for the study';
        rfc.Status__c = 'Approval Not Required';
        insert rfc;
        
        delete rfc;
    }
}