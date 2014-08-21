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
private class TestCreatingGroupMemberOnUser {

    /* @isTest static void myUnitTest() {
        // TO DO: implement unit test
        Test.startTest();
         
        Account acc = new Account();
        acc.Name = 'Test';
        //insert acc;
        
        Site__c st = new Site__c();
        st.Name = 'Test';
        st.Type__c = 'Test';
        st.Institute__c = acc.Id;
        //insert st;
        
        Contact con = new Contact();
        con.LastName = 'Test';
        con.Site__c = st.Id;
        con.AccountId = acc.Id;
        //insert con;
        
        List<Profile> pro = [select id from Profile];
         
        
        User ur = getPortalUser('PowerPartner', null, true);
        
        Test.stopTest();
    }
    
    public static User getPortalUser(String portalType, User userWithRole, Boolean doInsert) {    
            // Make sure the running user has a role otherwise an exception
            //   will be thrown.
            if(userWithRole == null) {  
                 
                if(UserInfo.getUserRoleId() == null) {
     
                    UserRole r = new UserRole(name = 'TEST ROLE');
                    Database.insert(r);
                     
                    userWithRole = new User(alias = 'hasrole', email='userwithrole@roletest1.com', userroleid = r.id,
                                        emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
                                        localesidkey='en_US', profileid = UserInfo.getProfileId(),
                                        timezonesidkey='America/Los_Angeles', username='userwithrole@testorg.com');
                } else {
                    userWithRole = new User(Id = UserInfo.getUserId(), UserRoleId = UserInfo.getUserRoleId());
                }
                 
                System.assert(userWithRole.userRoleId != null,
                              'This test requires the target org to have at least one UserRole created. Please create a user role in this organization and try again.');
            }
 
            Account a;
            Contact c;
            System.runAs(userWithRole) {
     
                a = new Account(name = 'TEST ACCOUNT');
                Database.insert(a);
                
                Site__c st = new Site__c();
                st.Name = 'Test';
                st.Type__c = 'Test';
                st.Institute__c = a.Id;
                insert st;
                         
                c = new Contact(AccountId = a.id,site__c = st.Id, lastname = 'lastname');
                Database.insert(c);
     
            }
             
            // Get any profile for the given type.
            Profile p = [select id
                          from profile
                         where usertype = :portalType limit 1];  
             
            String testemail = 'puser000@amamama.com';
            User pu = new User(profileId = p.id, username = testemail, email = testemail,
                               emailencodingkey = 'UTF-8', localesidkey = 'en_US',
                               languagelocalekey = 'en_US', timezonesidkey = 'America/Los_Angeles',
                               alias='cspu', lastname='lastname', contactId = c.id);
             
            if(doInsert) {
                Database.insert(pu);
        }
            return pu;
        }*/ 
    
}