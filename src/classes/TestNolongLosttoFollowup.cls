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
private class TestNolongLosttoFollowup {

    @isTest static void myUnitTest() {
            List<User> lstSiteUser = [Select u.IsActive, u.Id, SecurityCode__c From User u where IsActive = true and Profile.Name = 'Site User'];     
            System.runAs ( lstSiteUser[0] ) { 
            
            Account acc = new Account();
            
            List<Account> lstAccount = [Select a.Id From Account a limit 1];
            
            if(!lstAccount.isEmpty()){
                
            acc = lstAccount[0];
            
            Patient_Custom__c p = new Patient_Custom__c();
            p.Birthdate__c = date.newInstance(1980, 08, 05);
            p.Institution__c = acc.Id;
            p.Last_Name__c = 'test'; 
            p.Gender__c = 'Male';
            p.Race__c = 'White';
            p.Ethnicity__c = 'Not Hispanic or Latino';
            insert p;
            
            TrialPatient__c tp = new TrialPatient__c();
            tp.Patient_Id__c = p.Id;
            insert tp;
            
            No_Longer_lost_to_Followup__c nlffc=new No_Longer_lost_to_Followup__c();
            nlffc.TrialPatient__c = tp.Id;
            insert nlffc;
            
            Apexpages.currentPage().getParameters().put('trialPat',tp.Id);
            ApexPages.StandardController std = new ApexPages.StandardController(nlffc);
                 
            NolongLosttoFollowupController NLLFF=new NolongLosttoFollowupController(std);
            NLLFF.saveMainCRF();
            Apexpages.currentPage().getParameters().put('id',nlffc.Id);
            NLLFF.saveMainCRF();
            NLLFF.signAndSubmit();
            
            No_Longer_lost_to_Followup__c nlffc1=new No_Longer_lost_to_Followup__c();
            nlffc1.TrialPatient__c = tp.Id;
            insert nlffc1;
            
            Apexpages.currentPage().getParameters().put('trialPat',tp.Id);
            Apexpages.currentPage().getParameters().put('NLLTFupFormId',nlffc1.Id);
            
            ApexPages.StandardController std1 = new ApexPages.StandardController(nlffc1);
            NolongLosttoFollowupController NLLFF1=new NolongLosttoFollowupController(std1);
            
            
            Apexpages.currentPage().getParameters().put('nextTab','attachmentTab');
            NLLFF1.next();
            
            Apexpages.currentPage().getParameters().put('nextTab','CompleteTab');
            NLLFF1.next();
            
            Apexpages.currentPage().getParameters().put('prevTab','attachmentTab'); 
            NLLFF1.previous();
            NLLFF1.editCRF();
            NLLFF1.cloneCRF();
            NLLFF1.resendCode();
            NLLFF1.cancelCRF();
        
        }
      }
   }
}