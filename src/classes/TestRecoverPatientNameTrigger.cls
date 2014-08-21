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
private class TestRecoverPatientNameTrigger {

    @isTest static void myUnitTest() {
        // TO DO: implement unit test
        
        List<User> thisUser = [ select u.Id , u.IsActive from User u where profile.Name = 'System Administrator' and IsActive = true];
        System.runAs (thisUser[0]){
            
        Account acc1 = new Account(); 
        
        List<Account> lstAccount = [Select a.Id From Account a limit 1];
        
        if(!lstAccount.isEmpty()){
            
        acc1 = lstAccount[0];
        
        Site__c site1 = new Site__c();
        site1.Name = 'test site1';
        site1.Type__c = 'test type';
        site1.Institute__c = acc1.Id;
        insert site1;
        
        Contact con1 = new Contact();
        con1.LastName = 'test con';
        con1.AccountId = acc1.Id;
        con1.Site__c = site1.Id;
        con1.Type__c = 'MD';
        insert con1;
        
        Contact con2 = new Contact();
        con2.LastName = 'test con';
        con2.AccountId = acc1.Id;
        con2.Site__c = site1.Id;
        con2.Type__c = 'Surgeon';
        insert con2;
        
        Patient_Custom__c pc = new Patient_Custom__c();
        pc.First_Name__c = 'test';
        pc.Last_Name__c = 'test';
        pc.Gender__c = 'Male';
        pc.Birthdate__c = date.newInstance(1983, 6, 6);
        pc.Race__c = 'White';
        pc.Ethnicity__c = 'Not Hispanic or Latino';
        pc.Institution__c = acc1.Id;
        pc.Medical_Record_Number__c = '3434';
        insert pc;
        
        pc.Signed_Screening__c = true;
        update pc;
        
        pc.Signed_Screening__c = false;
        update pc;
        }
      }
   }
}