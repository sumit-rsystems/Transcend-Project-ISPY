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
private class TestCloneBuilder {

    @isTest static void myUnitTest() {
        // TO DO: implement unit test
        
        List<User> lstSiteUser = [Select u.IsActive, u.Id, SecurityCode__c From User u where IsActive = true and Profile.Name = 'Site User'];     
        System.runAs ( lstSiteUser[0] ) { 
        
        Account acc1 = new Account();
            
        List<Account> lstAccount = [Select a.RecordType.Name, a.RecordTypeId, a.Id From Account a where RecordType.Name = 'Institution'];
        
        if(!lstAccount.isEmpty()){
                
        acc1 = lstAccount[0];
        
        Patient_Custom__c pc = new Patient_Custom__c();
        pc.First_Name__c = 'test';
        pc.Last_Name__c = 'test';
        pc.Gender__c = 'Male';
        pc.Birthdate__c = date.newInstance(1991, 8, 8);
        pc.Race__c = 'White';
        pc.Ethnicity__c = 'Not Hispanic or Latino';
        pc.Institution__c = acc1.Id;
        insert pc;
        
        TrialPatient__c tp = new TrialPatient__c();
        tp.Patient_Id__c = pc.Id;
        insert tp; 
        
        ProtocolViolationDetail__c protObject = new ProtocolViolationDetail__c();
        protObject.Patient__c = pc.Id;
        protObject.TrialPatient__c = tp.Id;
        insert protObject;
        
        CloneBuilder clone = new CloneBuilder();
        
        CloneBuilder.cloneMeFutureCall(protObject.Id, '0', '');
        CloneBuilder.cloneMe(new Set<String>{protObject.Id}, '0', '');  
        CloneBuilder.cloneAdditionQuestion(new Set<String>{protObject.Id}, '0', '');
      }
    }
  }
}