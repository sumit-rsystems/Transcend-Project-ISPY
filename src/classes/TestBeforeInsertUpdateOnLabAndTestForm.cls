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
private class TestBeforeInsertUpdateOnLabAndTestForm {

    @isTest static void myUnitTest() {
        // TO DO: implement unit test
        List<User> thisUser = [ select u.Id , u.IsActive from User u where IsActive = true and id =: userinfo.getUserId()];
        System.runAs (thisUser[0]){

            
        Account acc = new Account();
        
        List<Account> lstAccount = [Select a.Id From Account a limit 1];
        
        if(!lstAccount.isEmpty()){
            
        acc = lstAccount[0];
        
        Patient_Custom__c pc = new Patient_Custom__c();
        pc.First_Name__c = 'test';
        pc.Last_Name__c = 'test1';
        pc.Gender__c = 'Male';
        pc.Birthdate__c = date.newInstance(1960, 7, 7);
        pc.Race__c = 'White';
        pc.Institution__c = acc.Id;
        pc.Ethnicity__c = 'Not Hispanic or Latino';
        insert pc;
        
        Trial__c tri = new Trial__c();
        tri.Name = 'Test';
        insert tri;
    
        TrialPatient__c triPat = new TrialPatient__c();
        triPat.Trial_Id__c = tri.Id;
        triPat.Patient_Id__c = pc.Id;
        insert triPat;
        
        CRF__c crf = new CRF__c();
        crf.Patient__c = triPat.Patient_Id__c;
        insert crf;
        
        Lab_and_Test__c lat = new Lab_and_Test__c();
        lat.TrialPatient__c = triPat.Id;
        lat.CRF__c = crf.Id;
        lat.Status__c = 'Not Completed';
        insert lat;
            
        lat.Status__c = 'Completed';
        update lat;
         }
      }
   }
}