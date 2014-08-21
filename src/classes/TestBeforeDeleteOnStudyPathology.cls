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
private class TestBeforeDeleteOnStudyPathology {

    @isTest static void myUnitTest() {
        // TO DO: implement unit test
        
        List<User> thisUser = [ select u.Id , u.IsActive from User u where IsActive = true and id =: userinfo.getUserId()];
        System.runAs (thisUser[0]){
        
        Account acc = new Account();
        
        List<Account> lstAccount = [Select a.Id From Account a limit 1];
        
        if(!lstAccount.isEmpty()){
            
        acc = lstAccount[0];
        
        Patient_Custom__c pc = new Patient_Custom__c();
        pc.First_Name__c = 'test';
        pc.Last_Name__c = 'test1';
        pc.Birthdate__c = system.today();
        pc.Institution__c = acc.Id;
        pc.Race__c = 'White';
        pc.Ethnicity__c = 'Not Hispanic or Latino';
        insert pc;
        
        TrialPatient__c triPat = new TrialPatient__c();
        triPat.Patient_Id__c = pc.Id;
        insert triPat;
        
        /*DCIS__c dcis = new DCIS__c();
        insert dcis;
        
        LCIS__c lcis = new LCIS__c();
        insert lcis;
        
        Invasive_Tumor_Detail__c itd = new Invasive_Tumor_Detail__c();
        insert itd;
        
        Receptors__c rec = new Receptors__c();
        insert rec;*/
        
        On_Study_Pathology_Form__c ospObj = new On_Study_Pathology_Form__c();
        ospObj.TrialPatient__c = triPat.Id;
        ospObj.Does_the_patient_have_bilateral_breast_c__c = 'Yes';
        ospObj.Tumor_laterality__c = 'Left';
        /*ospObj.DCIS__c = dcis.Id;
        ospObj.LCIS__c = lcis.Id;
        ospObj.Invasive_Tumor_Detail__c = itd.Id;
        ospObj.Receptors__c = rec.Id;*/
        insert ospObj;
        
        delete ospObj;
        }
      }
   }
}