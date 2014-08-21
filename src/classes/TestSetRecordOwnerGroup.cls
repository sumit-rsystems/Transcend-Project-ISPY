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
private class TestSetRecordOwnerGroup {

    @isTest static void myUnitTest() {
        
            List<User> lstSiteUser = [Select u.IsActive, u.Id, SecurityCode__c From User u where IsActive = true and Profile.Name = 'Site User'];     
            System.runAs ( lstSiteUser[0] ) { 
            
            Account acc1 = new Account();
            
            List<Account> lstAccount = [Select a.Id From Account a limit 1];
            
            if(!lstAccount.isEmpty()){
                
            acc1 = lstAccount[0];
        
            Group g = new Group();
            g.Email = 'abc@pgr.com';
            g.Name = 'sdfs';
            g.Type='Queue';
            insert g;
            
            GroupMember gm = new GroupMember();
            gm.UserOrGroupId = lstSiteUser[0].Id;
            gm.GroupId = g.Id;
            insert gm;
            
            Patient_Custom__c pc = new Patient_Custom__c();
            pc.OwnerId = lstSiteUser[0].Id;
            pc.Race__c = 'Asian';
            pc.Ethnicity__c = 'Hispanic or Latino';
            pc.First_Name__c  = 'hkjkl';
            pc.Last_Name__c  = 'hkjksdfl';
            pc.Gender__c  = 'Female';
            pc.Birthdate__c = date.newInstance(1990, 7, 7);
            pc.Institution__c = acc1.Id;
            insert pc;
            }
        }
    }
}