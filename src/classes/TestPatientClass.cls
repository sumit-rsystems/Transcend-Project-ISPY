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
private class TestPatientClass {

    @isTest static void myUnitTest() {
        // TO DO: implement unit test
        
        List<User> thisUser = [ select u.Id , u.IsActive from User u where profile.Name = 'System Administrator' and IsActive = true];
        System.runAs (thisUser[0]){
            
        Patient_Custom__c pc = new Patient_Custom__c();
        
        ApexPages.StandardController ad = new ApexPages.StandardController(pc);
        PatientClass pc1 = new PatientClass(ad);
        
        Account acc1 = new Account();
            
        List<Account> lstAccount = [Select a.Id From Account a limit 1];
            
        if(!lstAccount.isEmpty()){
                
        acc1 = lstAccount[0];
        
        Site__c site1 = new Site__c();
        site1.Name = 'test site1';
        site1.Type__c = 'test type';
        site1.Institute__c = acc1.Id;
        insert site1;
        
        Contact con1 = new Contact();
        con1.LastName = 'test con';
        con1.AccountId = acc1.Id;
        con1.Site__c = site1.Id;
        con1.Type__c = 'MD';
        insert con1;
        
        Contact con2 = new Contact();
        con2.LastName = 'test con';
        con2.AccountId = acc1.Id;
        con2.Site__c = site1.Id;
        con2.Type__c = 'Surgeon';
        insert con2;
        
        //Contact c = new Contact(AccountId = acc1.id,site__c = site1.Id, lastname = 'lastname');
        pc.First_Name__c = 'test';
        pc.Last_Name__c = 'test';
        pc.Gender__c = 'Male';
        pc.Birthdate__c = system.today();
        pc.Race__c = 'White';
        pc.Ethnicity__c = 'Not Hispanic or Latino';
        pc.Institution__c = acc1.Id;
        //pc.Site__c = site1.Id;
        pc.Medical_Record_Number__c = '3434';
        insert pc;
        
        pc1.addPatient();
        
        pc1.patientObj.First_Name__c = 'test';
        pc1.patientObj.Last_Name__c = 'ASC';
        pc1.checkDuplicate();
        
        pc1.patientObj.First_Name__c = 'test';
        pc1.patientObj.Last_Name__c = 'test';
        pc1.checkDuplicate();
        
        pc1.patientObj.Medical_Record_Number__c = '3233';
        pc1.checkDuplicate();
        
        pc1.patientObj.Medical_Record_Number__c = '3434';
        pc1.checkDuplicate();
        
        pc1.patientObj.Gender__c = 'Male';
        pc1.patientObj.Birthdate__c = system.today();
        pc1.patientObj.Race__c = 'White';
        pc1.patientObj.Ethnicity__c = 'Not Hispanic or Latino';
        pc1.patientObj.Institution__c = acc1.Id;
        pc1.patientObj.Country_of_Birth__c = 'us';
        pc1.patientObj.Study_Registration_Eligibility__c = true;
        pc1.patientObj.SSN__c = '5421';
        pc1.patientObj.City__c = 'test';
        pc1.patientObj.Country__c = 'test';
        pc1.patientObj.Zip__c = '23456';
        pc1.patientObj.State__c = 'test';
        pc1.patientObj.Primary_MD__c = con1.Id;
        pc1.patientObj.Surgeon__c = con2.Id;
        pc1.isNewPatient = true;
        pc1.addPatient();
        
        ApexPages.currentPage().getParameters().put('patientId', pc.Id);
        pc1.updatePatient();
        Pagereference pr = pc1.redirectEditPage();
        Pagereference pr1 = pc1.redirectAddPage();
        }
     }
   }
}