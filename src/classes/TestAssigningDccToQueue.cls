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
private class TestAssigningDccToQueue {

    @isTest static void myUnitTest() {
        // TO DO: implement unit test
        
        List<RecordType> recType = [select id,Name,SobjectType from RecordType where SobjectType = 'Account' and Name = 'DCC'];
        List<RecordType> recTypeInstitution = [select id,Name,SobjectType from RecordType where SobjectType = 'Account' and Name = 'Institution'];
        
        User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
        System.runAs ( thisUser ) {
            
        Account acc = new Account();
        acc.Name = 'TestDCC';
        acc.RecordTypeId = recType[0].Id;
        insert acc;
        
        Account acc1 = new Account();
        acc1.Name = 'TestDCC';
        acc1.RecordTypeId = recTypeInstitution[0].Id;
        insert acc1;
        
        acc1.RecordTypeId = recType[0].Id;
        update acc1;
        
        }
    }
    @isTest static void queueCreation() {
        
        List<User> thisUser = [Select u.IsActive, u.Id, u.ProfileId From User u where IsActive = true and Profile.Name = 'System Administrator'];
        System.runAs ( thisUser[0] ) { 
            
        List<Profile> lstProfile = [Select p.Name, p.Id From Profile p where Name = 'System Administrator'];
        
        QueueCreation quObj = new QueueCreation();
        QueueCreation.updateUserProf(lstProfile[0].Id, thisUser[0].Id);
            
            
        }
    }
}