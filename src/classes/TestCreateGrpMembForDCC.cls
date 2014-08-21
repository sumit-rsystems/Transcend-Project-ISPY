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
private class TestCreateGrpMembForDCC {

    @isTest static void myUnitTest() {
        // TO DO: implement unit test
        
        List<RecordType> recInst = [select id,Name from RecordType where Name = 'DCC'];
        List<Profile> lstProfId = [Select p.Name, p.Id From Profile p where Name = 'DCC User'];
        List<User> thisUser = [ select Id,ProfileId from User where ProfileId = : lstProfId[0].Id];
        User thisUser1 = [ select Id from User where Id = :UserInfo.getUserId() ];
        System.runAs ( thisUser1 ) {
	        Account acc = new Account();
	        acc.Name = 'DCC Group1';
	        acc.RecordTypeId = recInst[0].Id;
	        insert acc;
	        
	        DCC_User__c du = new DCC_User__c();
	        du.DCC__c = acc.Id;
	        du.User__c = thisUser[0].Id;
	        insert du;
	    }
    }
    
    @isTest static void myUnitTest1() {
        // TO DO: implement unit test
        
        List<RecordType> recInst = [select id,Name from RecordType where Name = 'DCC'];
        List<Profile> lstProfId = [Select p.Name, p.Id From Profile p where Name = 'DCC User'];
        List<User> thisUser = [ select Id,ProfileId from User where ProfileId = : lstProfId[0].Id];
        User thisUser1 = [ select Id from User where Id = :UserInfo.getUserId() ];
        System.runAs ( thisUser1 ) {
	        Account acc = new Account();
	        acc.Name = 'DCC Group1';
	        acc.RecordTypeId = recInst[0].Id;
	        insert acc;
	        
	        DCC_User__c du = new DCC_User__c();
	        du.DCC__c = acc.Id;
	        du.User__c = thisUser[0].Id;
	        insert du;
	        
	        delete du;
	    }
    }
}