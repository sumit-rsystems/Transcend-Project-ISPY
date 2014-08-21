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
private class TestSetAeIdBeforeInsert {

   
      @isTest static void myUnitTest() {
        // TO DO: implement unit test
        
            List<User> lstSiteUser = [Select u.IsActive, u.Id, SecurityCode__c From User u where IsActive = true and Profile.Name = 'Site User'];     
            System.runAs ( lstSiteUser[0] ) { 
            
            Account acc = new Account();
            
            List<Account> lstAccount = [Select a.Id From Account a limit 1];
            
            if(!lstAccount.isEmpty()){
                
            acc = lstAccount[0];    
            
            Patient_Custom__c p = new Patient_Custom__c();
            p.Birthdate__c = date.newInstance(1950, 08, 05);
            p.Institution__c = acc.Id;
            p.Last_Name__c = 'test'; 
            p.Gender__c = 'Male';
            p.Race__c = 'White';
            p.Ethnicity__c = 'Not Hispanic or Latino';
            insert p;
        
            TrialPatient__c tp = new TrialPatient__c();
            tp.Patient_Id__c = p.Id;
            insert tp;
            
            AE_Detail__c ae = new AE_Detail__c();
            ae.TrialPatient__c = tp.Id;
            insert ae;
            
            Toxicity__c toxObjAE = new Toxicity__c(); // to satisfy "if" condition for "AE_Detail__c" , line 8 
            toxObjAE.TrialPatient__c = tp.Id;
            toxObjAE.AE_Detail__c = ae.Id;
            insert toxObjAE;
            
            BaselineSymptomsForm__c base = new BaselineSymptomsForm__c();
            base.TrialPatient__c = tp.Id;
            base.Visit_Date__c = date.newInstance(2012, 7, 7);
            insert base;
            
            Toxicity__c toxObjBase = new Toxicity__c(); // to satisfy "else if" condition for "BaselineSymptomsForm__c" , line 10  
            toxObjBase.TrialPatient__c = tp.Id;
            toxObjBase.Baseline_Symptoms_Form__c = base.Id;
            insert toxObjBase;
            }
        }
    }
}