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
private class TestAfterInsertOnSite {

    @isTest static void myUnitTest() {
        // TO DO: implement unit test
        //Profile dccProp = [ Select p.UserType, p.Name, (Select u.IsActive, u.Id From Users u where IsActive = true) From Profile p where Name = 'Developers' ];
        //List<User> lstDccUser = dccProp.Users;
        Profile p = [SELECT Id FROM Profile WHERE Name='Developers']; 
        User u2 = new User(Alias = 'newUser', Email='newuser@testorgbakuldevorg.com', 
         EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
         LocaleSidKey='en_US', ProfileId = p.Id, 
         TimeZoneSidKey='America/Los_Angeles', UserName='newuser@testorgbakuldevorg.com');
         
        System.runAs (u2) {
        
            List<RecordType> lstRecType = [select Id,Name,SobjectType from RecordType where SobjectType = 'Account' and Name = 'Institution'];
            
            Account acc = new Account();
            acc.RecordTypeId = lstRecType[0].Id;
            acc.Name = 'Test';
            insert acc;
            
            Site__c st = new Site__c();
            st.Institute__c = acc.Id;
            st.Name = 'Test';
            insert st;
        }
    }
}