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
private class TestInsertCRFOnPostSurgeryTrigger {

    @isTest static void myUnitTest() {
        // TO DO: implement unit test
        
        User thisUser = [Select u.IsActive, u.Id From User u where IsActive = true and id =: userinfo.getUserId()];     
        System.runAs (thisUser) {   
        
        Code_Master__c snomedObject = new Code_Master__c();
        snomedObject.Variable_Description__c = 'test';
        snomedObject.IsReportColumn__c = true;
        snomedObject.Display_Order__c = 3.0;
        snomedObject.Name = 'LCIS__c';
        insert snomedObject;
        
        Snomed_Code__c snomed = new Snomed_Code__c();
        snomed.Code_Master__c = snomedObject.Id;
        insert snomed;
        
        Account accObj = new Account();
        
        List<Account> lstAccount = [Select a.RecordType.Name, a.RecordTypeId, a.Id From Account a where RecordType.Name = 'Institution']; 
        
        if(!lstAccount.isEmpty()){
                
        accObj = lstAccount[0];     
        
        Patient_Custom__c p = new Patient_Custom__c();
        p.Ethnicity__c = 'Hispanic or latino';
        p.Gender__c = 'female';
        p.Race__c = 'asian';
        p.Last_Name__c = 'kumar';
        p.Status__c = 'approval not required';
        p.First_Name__c = 'test';
        p.Birthdate__c = date.newInstance(1980, 08, 05);
        p.Institution__c = accObj.Id;
        insert p;
        
        TrialPatient__c tp = new TrialPatient__c();
        tp.Patient_Id__c = p.Id;
        insert tp;
        
        CRF__c crf = new CRF__c();
        crf.Patient__c = p.Id;
        crf.Status__c = 'Not Completed';
        insert crf;
        
        Post_Surgaory_Summary__c pss = new Post_Surgaory_Summary__c();
        pss.Date_Of_Procedure__c = system.today();
        pss.TrialPatient__c = tp.Id;
        pss.Is_DCIS_Present__c = 'Yes';
        pss.pcr__c = true;
        pss.RCB_Class__c = 'rcb';
        pss.Is_invasive_tumor_present__c = 'Yes';
        insert pss;
        
        pss.Status__c = 'Completed';
        update pss;
           }
        }
    }
}