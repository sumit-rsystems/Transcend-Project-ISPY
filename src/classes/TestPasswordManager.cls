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
private class TestPasswordManager {

    @isTest static void myUnitTest() {
        // TO DO: implement unit test

        List<User> lstSiteUser = [Select u.IsActive, u.SecurityCode__c, u.Id From User u where IsActive = true and Profile.Name = 'Site User'];     
        System.runAs (lstSiteUser[0]) { 
        
        PasswordManager pwm = new PasswordManager();
        String password =  PasswordManager.generatePassword();
        
         blob blobKey = Encodingutil.base64Decode(lstSiteUser[0].SecurityCode__c);
         String securityCode = EncodingUtil.convertToHex(blobKey);
         securityCode = securityCode.substring(0,8);
         
         PasswordManager.verifyPassword(lstSiteUser[0].Id, securityCode);
         
         PasswordManager.verifyPassword(lstSiteUser[0].Id, 'abcd');
         
         lstSiteUser[0].SecurityCode__c = 'NsGT38PxptmbhrJ8cIVWow==';
         update lstSiteUser[0];
         
         PasswordManager.verifyPassword(lstSiteUser[0].Id, securityCode);
         
         PasswordManager.generateSecurityToken();
         
        }
    }
}