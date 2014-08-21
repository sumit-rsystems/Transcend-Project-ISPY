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
private class TestInstitutionUserProfileAssign {

    @isTest static void myUnitTest() {
        // TO DO: implement unit test
        
        List<RecordType> recInst = [select id,Name from RecordType where Name = 'Institution'];
        List<RecordType> recDcc = [select id,Name from RecordType where Name = 'DCC'];
        List<Profile> lstProNew = [select id,Name from Profile where Name = 'Lab Technician'];
        //List<User> lstUser = [select Id,ProfileId from User where ProfileId = :lstProNew[0].Id];
        User thisUser = [ select Id from User where Id = :UserInfo.getUserId()];
        System.runAs ( thisUser ) {
            Account acc = new Account();
            acc.Name = 'DCC Group1';
            acc.RecordTypeId = recInst[0].Id;
            insert acc;
            
            Account dcc = new Account();
            dcc.Name = 'DCC Group1';
            dcc.RecordTypeId = recDcc[0].Id;
            insert dcc;
            
            Site__c sit = new Site__c();
            sit.Institute__c = acc.Id;
            insert sit;
            
            Trial__c tri = new Trial__c();
            tri.Name = 'Test';
            insert tri;
            
            Site_Trial__c st = new Site_Trial__c();
            st.Site__c = sit.Id;
            st.Trial__c = tri.Id;
            insert st;
            
             User usr = new User();
             usr.FirstName = 'test';
             usr.LastName = 'test1';
             usr.Username = system.currentTimeMillis()+'@gmail.com';
             usr.Alias = 'a';
             usr.ProfileId = lstProNew[0].Id;
             usr.Email = 'abcd@gmail.com';
             usr.TimeZoneSidKey = 'America/Los_Angeles';
             usr.LocaleSidKey = 'en_US';
             usr.EmailEncodingKey = 'ISO-8859-1';
             usr.LanguageLocaleKey = 'en_US';
             usr.SecurityCode__c = 'mssK/HQUxhugwWpXpwhiLg==';
             insert usr;
             
            InstitutionTrialDcc__c instTrialDcc = new InstitutionTrialDcc__c();
            instTrialDcc.DCC_Id__c = dcc.Id;
            instTrialDcc.Institution_Id__c = acc.Id;
            instTrialDcc.Trial_Id__c = tri.Id;  
            insert instTrialDcc; 
            
            InstitutionUser__c iu = new InstitutionUser__c();
            iu.Institution__c = acc.Id;
            iu.User__c = usr.Id;
            iu.Trial__c = tri.Id;
            iu.Site__c = sit.Id;
            insert iu;
            
            InstitutionUser__c iu1 = new InstitutionUser__c();
            iu1.Institution__c = acc.Id;
            iu1.User__c = usr.Id;
            iu1.Trial__c = tri.Id;
            iu1.Site__c = sit.Id;
            iu1.IsInstituteAdmin__c = true;
            insert iu1;
            
        }
    }
}