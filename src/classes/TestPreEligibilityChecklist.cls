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
@isTest(SeeAllData=true)
private class TestPreEligibilityChecklist {

   
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
            tp.FirstName__c = 'a';
            tp.LastName__c = 'b';
            insert tp;
            
            PreEligibility_Checklist__c preObjnull = new PreEligibility_Checklist__c(); // else if line 16
            preObjnull.Patient__c = p.Id;
            preObjnull .First_Save_and_Close__c = true;
            
            
            insert preObjnull;
            
            Apexpages.standardcontroller controller1 = new Apexpages.standardcontroller(preObjnull); // else if line 16 preEligibilityId == null
            PreEligibilityChecklist pre1 = new PreEligibilityChecklist(controller1);
           
            
            
            Apexpages.currentPage().getParameters().put('PatientId',p.Id); 
            //pre1.preId = preObjnull.Id; // if cond line 24
            pre1.insertCRF(); 
            
            Apexpages.currentPage().getParameters().put('PatientId',p.Id); 
            
            //pre1.preId = null; // else part line 30
            pre1.insertCRF(); 
            
            PreEligibility_Checklist__c preObj = new PreEligibility_Checklist__c();
            preObj.Patient__c = p.Id;
            insert preObj;
            
            Apexpages.currentPage().getParameters().put('preEligibilityId',preObj.Id); // if cond ,preEligibilityId != null line 14
            Apexpages.standardcontroller controller = new Apexpages.standardcontroller(preObj);
            PreEligibilityChecklist pre = new PreEligibilityChecklist(controller);
            Apexpages.currentPage().getParameters().put('nextTab','saveAndClose'); 
             pre.nextTabName = 'saveAndClose';
            
            Apexpages.currentPage().getParameters().put('PatientId',p.Id);
            pre.insertCRF();
            
            Apexpages.currentPage().getParameters().put('tabNext','Complete');
            pre.next();
            
            Apexpages.currentPage().getParameters().put('tabPrevious','Complete');
            pre.previous();
            
            pre.signAndSubmit();
            
            Apexpages.currentPage().getParameters().put('preEligibilityId',preObj.Id);
            pre.customCancel();
            Apexpages.currentPage().getParameters().put('trialPat',tp.Id); 
            ApexPages.currentPage().getParameters().put('nextTab','saveAndClose');
            pre.nextTabName = 'saveAndClose';
            }
        }
    }
}