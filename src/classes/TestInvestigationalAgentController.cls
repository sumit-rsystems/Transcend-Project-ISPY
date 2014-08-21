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
private class TestInvestigationalAgentController {

    @isTest static void myUnitTest() {
        // TO DO: implement unit test
        User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
        System.runAs ( thisUser ){
        
            Account inst = new Account();
            List<Account> lstAccount = [select Id from Account limit 1];
            if(!lstAccount.isEmpty()) {
                inst = lstAccount[0];
                
                Patient_Custom__c p = new Patient_Custom__c();
                p.Birthdate__c = date.newInstance(1960, 8, 7);
                p.Ethnicity__c = 'Hispanic or latino';
                p.Gender__c = 'female';
                p.Race__c = 'asian';
                p.Last_Name__c = 'kumar';
                p.Institution__c = inst.Id;
                insert p;
                
                Trial__c t = new Trial__c();
                t.Start_Date__c = system.today();
                insert t;
        
                TrialPatient__c tp = new TrialPatient__c();
                tp.Trial_Id__c = t.Id;
                tp.Patient_Id__c = p.Id;
                insert tp;
                
                Registration__c reg = new Registration__c();
                reg.Patient__c = p.Id;
                reg.Registration_Date__c = System.today();
                reg.Trial__c = t.Id;
                reg.TrialPatient__c = tp.Id;
                reg.Institution__c = inst.Id;
                reg.IRB_Approval_Date__c = System.today();
                reg.Screening_Informed_Consent_Date__c = System.today();
                reg.HIPPA_Consent_Date__c = System.today();
                insert reg;
                
                On_Study_Eligibility_Form__c ons = new On_Study_Eligibility_Form__c();
                ons.TrialPatient__c = tp.Id;
                ons.How_was_the_cancer_first_detected__c = 'Self exam';
                insert ons;
                
                ComponentControllerBase ccb = new ComponentControllerBase(); // VIRTUAL CLASS "ComponentControllerBase"
                ccb.key = '1';
                
                PageControllerBase pcb = new PageControllerBase(); // VIRTUAL CLASS "PageControllerBase" BEGINS HERE
                
                Apexpages.standardcontroller iac = new Apexpages.standardcontroller(ons);
                InvestigationalAgentController inv = new InvestigationalAgentController(iac);
            }
        }
    }
}