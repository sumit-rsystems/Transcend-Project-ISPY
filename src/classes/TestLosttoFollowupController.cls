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
private class TestLosttoFollowupController {

    @isTest static void LosttoFollowupController() {
        // TO DO: implement unit test
        
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
            
            Lost_to_Follow_Up__c lffc=new Lost_to_Follow_Up__c();
            lffc.TrialPatient__c = tp.Id;
            insert lffc;
            
            Apexpages.currentPage().getParameters().put('trialPat',tp.Id);
            ApexPages.StandardController std = new ApexPages.StandardController(lffc);
                 
            LosttoFollowupController LFC=new LosttoFollowupController(std);
            LFC.saveMainCRF();
            Apexpages.currentPage().getParameters().put('id',lffc.Id);
            LFC.saveMainCRF();
            LFC.signAndSubmit();
            
            Lost_to_Follow_Up__c lffc1=new Lost_to_Follow_Up__c();
            lffc1.TrialPatient__c = tp.Id;
            insert lffc1;
            
            Apexpages.currentPage().getParameters().put('trialPat',tp.Id);
            Apexpages.currentPage().getParameters().put('ltfupformId',lffc.Id);
            
            ApexPages.StandardController std1 = new ApexPages.StandardController(lffc1);
            LosttoFollowupController LFC1=new LosttoFollowupController(std1);
            
            Apexpages.currentPage().getParameters().put('nextTab','saveAndClose');
            LFC1.nextTabName = 'saveAndClose';
            LFC1.next();
            
            LFC1.currentTab = 'attachmentTab';
            LFC1.previous();
            
            LFC1.editCRF();
            LFC1.cloneCRF();
            LFC1.resendCode();
            LFC1.cancelCRF();
            }
        }
    }
}