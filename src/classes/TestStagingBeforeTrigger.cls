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
private class TestStagingBeforeTrigger {

    @isTest static void myUnitTest() {
        List<RecordType> recordT = [Select r.Name, r.Id From RecordType r where sObjectType='Contact' and Name='Doctor'];
        
        Profile SiteProp = [ Select p.UserType, p.Name, (Select Id From Users where IsActive = true) From Profile p where Name = 'System Administrator' ];
        List<User> lstSiteUser = SiteProp.Users;     
        System.runAs ( lstSiteUser[0] ) {
            
            Account inst1 = new Account();

            List<Account> lstAccount = [select Id from Account limit 1]; 
            
            if(!lstAccount.isEmpty()){
                
            inst1 = lstAccount[0];           // newly added logic line 30 to 36 to overcome the error of "setup and nonsetup" object
            
            Site__c s = new Site__c();
            s.Institute__c = inst1.Id;
            insert s;
            
            Contact con = new Contact();
            con.AccountId = inst1.Id;
            con.LastName = 'test';
            con.Site__c = s.Id;
            con.Type__c = 'Surgeon';
            con.RecordTypeId = recordT[0].Id;
            insert con;
            
            Patient_Custom__c p = new Patient_Custom__c();
            p.Birthdate__c = date.newInstance(1950, 08, 05);
            p.Institution__c = inst1.Id;
            p.Last_Name__c = 'test'; 
            p.Gender__c = 'Male';
            p.Race__c = 'White';
            p.Ethnicity__c = 'Not Hispanic or Latino';
            insert p;
            
            TrialPatient__c tp = new TrialPatient__c();
            tp.Patient_Id__c = p.Id;
            insert tp;
            
            InstitutionUser__c ins = new InstitutionUser__c();
            ins.Site__c = s.Id;
            ins.User__c = userinfo.getUserId();
            ins.Institution__c = inst1.Id;
            insert ins;
            
            Post_Surgaory_Summary__c pss = new Post_Surgaory_Summary__c();
            pss.TrialPatient__c = tp.Id;
            pss.Surgeon__c = con.Id;
            pss.Date_Of_Procedure__c = date.newInstance(2012, 7, 7);
            pss.Type_Of_Tumor__c = 'Single Discrete Mass';
            insert pss;
            
            Staging_Detail__c sd = new Staging_Detail__c();
            sd.Post_Surgery_Summary__c = pss.Id;
            sd.Tumor_Type__c = 'test';
            insert sd;
            
            sd.Tumor_Type__c = 'test1';
            update sd;
            }
        }
    }
}