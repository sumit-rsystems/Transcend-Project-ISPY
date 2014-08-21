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
private class TestUserAfterInsertTrigger {

    @isTest static void myUnitTest() {
        // TO DO: implement unit test
        
        List<Profile> lstProfile = [select Id from Profile where Name = 'Site User'];
        User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
        System.runAs ( thisUser ){
            /*
            thisUser.ProfileId = lstProfile[0].Id;
            insert thisUser;*/
            
            User usr = new User();
            usr.FirstName = 'test';
            usr.LastName = 'test1';
            usr.Username = 'abs1@gmail.com';
            usr.Alias = 'a';
            usr.ProfileId = lstProfile[0].Id;
            usr.Email = 'abcd@gmail.com';
            usr.TimeZoneSidKey = 'America/Los_Angeles';
            usr.LocaleSidKey = 'en_US';
            usr.EmailEncodingKey = 'ISO-8859-1';
            usr.LanguageLocaleKey = 'en_US';
            insert usr;
            
        }
    }
}