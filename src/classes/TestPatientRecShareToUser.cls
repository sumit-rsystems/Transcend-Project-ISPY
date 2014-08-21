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
private class TestPatientRecShareToUser {

    @isTest static void myUnitTest() {
        // TO DO: implement unit test
        
            List<User> thisUser = [ select u.Id , u.IsActive from User u where profile.Name = 'System Administrator' and IsActive = true];
            System.runAs (thisUser[0]){
            
            Account acc = new Account();
            
            List<Account> lstAccount = [Select a.Id From Account a limit 1]; 
            
            if(!lstAccount.isEmpty()){
                
            acc = lstAccount[0];
            
            Site__c sit = new Site__c();
            sit.Institute__c = acc.Id;
            insert sit;
            
            Trial__c tri = new Trial__c();
            tri.Name = 'Test';
            insert tri;
            
            Patient_Custom__c pat = new Patient_Custom__c();
            pat.Race__c = 'Asian';
            pat.Last_Name__c = 'Test';
            pat.Gender__c = 'Female';
            pat.Ethnicity__c = 'Not Hispanic or Latino';
            pat.Birthdate__c = date.newInstance(1988, 7, 7);
            pat.Institution__c = acc.Id;
            insert pat;
            }
        }
    }
}