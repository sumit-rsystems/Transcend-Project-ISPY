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
private class TestPreEligibilityInfo {

    @isTest static void myUnitTest() {
        // TO DO: implement unit test
            List<User> lstSiteUser = [Select u.IsActive, u.Id, SecurityCode__c From User u where IsActive = true and Profile.Name = 'Site User'];     
            System.runAs ( lstSiteUser[0] ) { 
            
            Account acc = new Account();
            
            List<Account> lstAccount = [Select a.Id From Account a limit 1];
            
            if(!lstAccount.isEmpty()){
                
            acc = lstAccount[0];
            
            Patient_Custom__c p = new Patient_Custom__c();
            p.Ethnicity__c = 'Hispanic or latino';
            p.Gender__c = 'female';
            p.Race__c = 'asian;indian';
            p.Last_Name__c = 'kumar';
            p.Status__c = 'approval not required';
            p.Birthdate__c = date.newInstance(1950, 08, 05);
            p.Signed_Screening__c = true;
            p.Institution__c = acc.Id;
            insert p;
            
            PreEligibility_Checklist__c pec = new PreEligibility_Checklist__c();
            pec.Patient__c = p.Id;
            insert pec;
            
            Apexpages.standardcontroller Pre = new Apexpages.standardcontroller(pec);
            PreEligibilityInfo pein = new PreEligibilityInfo(Pre);
            Apexpages.currentPage().getParameters().put('CF00Nc0000000Glkx_lkid',p.Id);
            pein.Next();
            
            Patient_Custom__c p1 = new Patient_Custom__c();
            p1.Ethnicity__c = 'Hispanic or latino';
            p1.Gender__c = 'female';
            p1.Race__c = 'asian;indian';
            p1.Last_Name__c = 'kumar';
            p1.Status__c = 'approval not required';
            p1.Birthdate__c = date.newInstance(1950, 08, 05);
            p1.Institution__c = acc.Id;
            insert p1;
            
            PreEligibility_Checklist__c pec1 = new PreEligibility_Checklist__c();
            pec1.Patient__c = p1.Id;
            insert pec1;
            
            PreEligibilityInfo pein1 = new PreEligibilityInfo(Pre);
            Apexpages.currentPage().getParameters().put('CF00Nc0000000Glkx_lkid',p1.Id);
            pein1.Next();
        }
      }
   }
}