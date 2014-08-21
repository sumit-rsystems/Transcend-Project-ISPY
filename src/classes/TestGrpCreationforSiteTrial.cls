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
private class TestGrpCreationforSiteTrial {

    @isTest static void myUnitTest() {
        // TO DO: implement unit test
        Profile SiteProp = [ Select p.UserType, p.Name, (Select u.IsActive, u.Id From Users u where IsActive = true) From Profile p where Name = 'Site User'];
        List<User> lstSiteUser = SiteProp.Users;     
        System.runAs ( lstSiteUser[0] ) { 
            Account acc = new Account();
            acc.Name = 'test acc';
            insert acc;
            
            Site__c s = new Site__c();
            s.Institute__c = acc.Id;
            s.Name = 'test site';
            insert s;
            
            Trial__c t = new Trial__c();
            t.Name = 'Test trial';
            insert t;
            
            Site_Trial__c st = new Site_Trial__c();
            st.Site__c = s.Id;
            st.Trial__c = t.Id;
            insert st;
        }
    }
}