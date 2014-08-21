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
private class TestDeleteToxicityOnAEBeforeDelete {

    
      @isTest static void myUnitTest() {
        // TO DO: implement unit test
            List<User> thisUser = [ select u.Id , u.IsActive from User u where profile.Name = 'System Administrator' and IsActive = true];
            System.runAs (thisUser[0]){
            
            Account inst1 = new Account(); //inst
            
            List<Account> lstAccount = [Select a.RecordType.Name, a.RecordTypeId, a.Id From Account a where RecordType.Name = 'Institution'];
            
            if(!lstAccount.isEmpty()){
                
            inst1 = lstAccount[0];
            
            Site__c site1 = new Site__c();
            site1.Name = 'test site1';
            site1.Type__c = 'test type';
            site1.Institute__c = inst1.Id;
            insert site1;
            
            Patient_Custom__c p = new Patient_Custom__c();
            p.Ethnicity__c = 'Hispanic or latino';
            p.Gender__c = 'female';
            p.Race__c = 'asian;indian';
            p.Last_Name__c = 'kumar';
            p.Status__c = 'approval not required';
            p.First_Name__c = 'test';
            p.Birthdate__c = date.newInstance(1980, 08, 05);
            p.Institution__c = inst1.Id;
            insert p;
            
            List<Patient_Custom__c> lstPatient = [Select p.Initials__c, First_Name__c, Last_Name__c, Gender__c, Race__c, p.Institute_Text__c,p.Ethnicity__c From Patient_Custom__c p where Id = : p.Id];
            
            Trial__c t = new Trial__c();
            t.Name = 'test';
            insert t;
            
            TrialPatient__c tp = new TrialPatient__c();
            tp.Patient_Id__c = p.Id;
            tp.FirstName__c = 'a';
            tp.LastName__c = 'b';
            tp.Trial_Id__c = t.Id;
            insert tp;
            
            CRF__c crf = new CRF__c();
            crf.Patient__c = p.Id;
            crf.Type__c = 'type1';
            crf.Detail__c = 'detail';
            crf.Status__c = 'Not Completed';
            insert crf;
            
            Registration__c reg = new Registration__c();
            reg.Patient__c = p.Id;
            reg.First_Name__c = lstPatient[0].First_Name__c;
            reg.Last_Name__c = lstPatient[0].Last_Name__c;
            reg.Ethnicity__c = lstPatient[0].Ethnicity__c;
            reg.Race__c =  lstPatient[0].Race__c;
            reg.Gender__c = lstPatient[0].Gender__c;
            reg.Registration_Date__c = System.today();
            reg.Trial__c = t.Id;
            reg.Initials__c = lstPatient[0].Initials__c;
            reg.Institution__c = inst1.Id;
            reg.Site__c = site1.Id;
            reg.IRB_Approval_Date__c = date.newInstance(2008, 7, 7); 
            reg.Screening_Informed_Consent_Date__c = date.newInstance(2009, 7, 7);
            reg.HIPPA_Consent_Date__c = date.newInstance(2011, 7, 7);
        //  reg.ACRIN_6693_MRS_Participant__c = 'Yes';
            insert reg;
            
            AE_Detail__c ae = new AE_Detail__c();
            ae.TrialPatient__c = tp.Id;
            insert ae;
            
            Toxicity__c toxiObj = new Toxicity__c();
            toxiObj.AE_Detail__c = ae.Id;
            insert toxiObj;
            
            delete ae;
            }
        }
    }
}