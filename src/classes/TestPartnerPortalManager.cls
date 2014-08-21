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
private class TestPartnerPortalManager {

    @isTest static void myUnitTest() {
        // TO DO: implement unit test
        
        List<User> thisUser = [Select u.IsActive, u.Id ,u.Patient_Id__c,u.ProfileId From User u where IsActive = true and id =: userinfo.getUserId()];   
        
        System.runAs (thisUser[0]) {   
            
            List<RecordType> recordT = [Select r.Name, r.Id From RecordType r where sObjectType = 'Account' and Name='Institution' order by Name];
            
            Code_Master__c snomedObject = new Code_Master__c();
            snomedObject.Variable_Description__c = 'test';
            snomedObject.IsReportColumn__c = true;
            snomedObject.Display_Order__c = 3.0;
            snomedObject.Name = 'Institution';
            insert snomedObject;
          
            Account accObj = new Account();
            accObj.Name = 'test Institute 1';
            accObj.RecordTypeId = recordT[0].Id;
            insert accObj; 
            
            Site__c siteObj = new Site__c();
            siteObj.Institute__c =  accObj.Id;
            insert siteObj;
            
            Pre_Registration_Snomed_Codes__c pre = new Pre_Registration_Snomed_Codes__c();
            pre.Code_Master__c = snomedObject.Id;
            insert pre;
            
            Patient_Custom__c patObj = new Patient_Custom__c();
            patObj.Birthdate__c = date.newInstance(1960, 8, 7);
            patObj.Ethnicity__c = 'Hispanic or latino';
            patObj.Gender__c = 'female';
            patObj.Race__c = 'asian';
            patObj.First_Name__c = 'test';
            patObj.Last_Name__c = 'kumar';
            patObj.Institution__c = accObj.Id;
            insert patObj;
            
            Contact conObj = new Contact();
            conObj.AccountId = accObj.Id;
            conObj.Site__c = siteObj.id;
            conObj.Patient__c = patObj.Id;
            conObj.LastName = 'Bond';
            insert conObj;
            
            set<id> patIds = new set<id>();
            patIds.add(patObj.Id);
            
            Set<Id> accIds = new Set<Id>();
            accIds.add(accObj.Id);
            
           
            PartnerPortalManager partnerObject = new PartnerPortalManager();
           // PartnerPortalManager.createPartnerPortalUser(patObj.Id); // causing error: Future method cannot be called from a future or batch method
            PartnerPortalManager.createPartnerPortalUser(patIds); 
            PartnerPortalManager.enableAccountsAsPartners(accIds);
        }
    }
}