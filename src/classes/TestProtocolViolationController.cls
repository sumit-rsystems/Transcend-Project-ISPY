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
private class TestProtocolViolationController {

    @isTest static void myUnitTest() {
        // TO DO: implement unit test
            List<User> lstSiteUser = [Select u.IsActive, u.Id, SecurityCode__c From User u where IsActive = true and Profile.Name = 'Site User'];     
            System.runAs ( lstSiteUser[0] ) { 
            
            Account inst1 = new Account();
            
            List<Account> lstAccount = [Select a.Id From Account a limit 1];
            
            if(!lstAccount.isEmpty()){
                
            inst1 = lstAccount[0];
            
            Patient_Custom__c pc = new Patient_Custom__c();
            pc.First_Name__c = 'test';
            pc.Last_Name__c = 'test1';
            pc.Gender__c = 'Male';
            pc.Birthdate__c = date.newInstance(1977, 8, 7);
            pc.Race__c = 'White';
            pc.Ethnicity__c = 'Not Hispanic or Latino';
            pc.Institution__c = inst1.Id;
            pc.Medical_Record_Number__c = '3434';
            insert pc;
            
            Trial__c tri = new Trial__c();
            tri.Name = 'Test';
            insert tri;
        
            TrialPatient__c triPat = new TrialPatient__c();
            triPat.Trial_Id__c = tri.Id;
            triPat.Patient_Id__c = pc.Id;
            insert triPat;
                
            ProtocolViolationDetail__c pv = new ProtocolViolationDetail__c();
            pv.TrialPatient__c = triPat.Id;
            pv.Patient_Remains_on_Study__c = true;
            pv.Medication_non_complicance__c = true;
            insert pv; 
            
           //Apexpages.currentPage().getParameters().put('formId',pv.Id);
            Apexpages.currentPage().getParameters().put('trialPat',triPat.Id);
            ApexPages.StandardController cont1 = new ApexPages.StandardController(pv); 
            ProtocolViolationController pvc = new ProtocolViolationController(cont1);
            Pagereference pr = pvc.saveMainCRF();
                        
            Apexpages.currentPage().getParameters().put('formId',pv.Id);
            Apexpages.currentPage().getParameters().put('trialPat',triPat.Id);
            Pagereference pr1 = pvc.saveMainCRF();
            pvc.currentTab = 'FirstTab';
            pvc.protocolViolation = pv;
            pvc.next();
            Apexpages.currentPage().getParameters().put('nextTab', 'saveAndClose');
            pvc.currentTab = 'SecondTab';
            pvc.next();
            pvc.previous();
            Pagereference pr2 = pvc.signAndSubmit();
            pvc.resendCode();
            pvc.editCRF();
            pvc.cloneCRF(); 
            pvc.cancelCRF();
            
            ProtocolViolationDetail__c pv1 = new ProtocolViolationDetail__c();
            
            Apexpages.currentPage().getParameters().put('formId',null);
            Apexpages.currentPage().getParameters().put('trialPat',triPat.Id);
            ApexPages.StandardController cont2 = new ApexPages.StandardController(pv1); 
            ProtocolViolationController pvc1 = new ProtocolViolationController(cont2);
            pvc1.saveMainCRF();
        }
      }
   }
   
   @isTest static void myUnitTest1() {
        // TO DO: implement unit test
            List<User> lstSiteUser = [Select u.IsActive, u.Id, SecurityCode__c From User u where IsActive = true and Profile.Name = 'Site User'];     
            System.runAs ( lstSiteUser[0] ) { 
            
            Account inst1 = new Account();
            
            List<Account> lstAccount = [Select a.Id From Account a limit 1];
            
            if(!lstAccount.isEmpty()){
                
            inst1 = lstAccount[0];
            
            Patient_Custom__c pc = new Patient_Custom__c();
            pc.First_Name__c = 'test';
            pc.Last_Name__c = 'test1';
            pc.Gender__c = 'Male';
            pc.Birthdate__c = date.newInstance(1977, 8, 7);
            pc.Race__c = 'White';
            pc.Ethnicity__c = 'Not Hispanic or Latino';
            pc.Institution__c = inst1.Id;
            pc.Medical_Record_Number__c = '3434';
            insert pc;
            
            Trial__c tri = new Trial__c();
            tri.Name = 'Test';
            insert tri;
        
            TrialPatient__c triPat = new TrialPatient__c();
            triPat.Trial_Id__c = tri.Id;
            triPat.Patient_Id__c = pc.Id;
            insert triPat;
                
            ProtocolViolationDetail__c pv = new ProtocolViolationDetail__c();
            pv.TrialPatient__c = triPat.Id;
            pv.Patient_Remains_on_Study__c = true;
            pv.Medication_non_complicance__c = true;
            insert pv; 
            
            ProtocolViolationDetail__c pv1 = new ProtocolViolationDetail__c();
            pv1.TrialPatient__c = triPat.Id;
            pv1.Patient_Remains_on_Study__c = true;
            pv1.Medication_non_complicance__c = true;
            pv1.Status__c = 'Approval Pending';
            pv1.OriginalCRF__c = pv.Id;
            insert pv1;
            
            pv1.Status__c = 'Accepted';
            update pv1;
        }
      }
   }
}