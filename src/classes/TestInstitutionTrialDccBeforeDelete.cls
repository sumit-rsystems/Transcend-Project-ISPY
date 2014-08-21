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
private class TestInstitutionTrialDccBeforeDelete {

    @isTest static void myUnitTest() {
        List<InstitutionUser__c> lstinstObject = [Select i.User__c, i.Site__c, i.Institution__c,i.Trial__c, i.Id From InstitutionUser__c i where User__c != null and Site__c != null and Institution__c != null and Trial__c != null and User__r.IsActive = true limit 1];
        List<User> thisUser = [ select u.Id , u.IsActive from User u where id =:lstinstObject[0].User__c and IsActive = true];
        
        Account inst1 = new Account(); //inst
        List<Account> lstAccount1 = [Select a.RecordType.Name, a.RecordTypeId, a.Id From Account a where RecordType.Name = 'Institution' and id =: lstinstObject[0].Institution__c];
        
        Account dcc1 = new Account(); // inst or dcc
        List<Account> lstAccount2 = [Select a.Name ,a.RecordType.Name, a.RecordTypeId, a.Id From Account a where RecordType.Name = 'DCC'];
        if(!(lstAccount1.isEmpty() && lstAccount2.isEmpty())){
            
            inst1 = lstAccount1[0];
            dcc1 =  lstAccount2[0];
            
            InstitutionDcc__c instDCC1 = new InstitutionDcc__c();
            instDCC1.DCC_Id__c = dcc1.Id;
            instDCC1.Institution_Id__c = lstinstObject[0].Institution__c;
            insert instDCC1;
                
            InstitutionTrialDcc__c instTrialDcc = new InstitutionTrialDcc__c();
            instTrialDcc.DCC_Id__c = dcc1.Id;
            instTrialDcc.Institution_Id__c = lstinstObject[0].Institution__c;
            instTrialDcc.Trial_Id__c = lstinstObject[0].Trial__c;
            insert instTrialDcc;
            
            delete instTrialDcc;
        }
    }
}