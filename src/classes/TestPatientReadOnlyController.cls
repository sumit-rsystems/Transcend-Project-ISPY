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
private class TestPatientReadOnlyController  {

    @isTest static void myUnitTest() {
        // TO DO: implement unit test
            List<User> thisUser = [ select u.Id , u.IsActive from User u where profile.Name = 'System Administrator' and IsActive = true];
            System.runAs (thisUser[0]){
            
            Account accObj = new Account(); //inst
            
            List<Account> lstAccount = [Select a.RecordType.Name, a.RecordTypeId, a.Id From Account a where RecordType.Name = 'Institution'];
            
            if(!lstAccount.isEmpty()){
                
            accObj = lstAccount[0];
            
            Site__c site1 = new Site__c();
            site1.Name = 'test site1';
            site1.Type__c = 'test type';
            site1.Institute__c = accObj.Id;
            insert site1;
            
            Trial__c t = new Trial__c();
            t.Start_Date__c = system.today();
            insert t;
            
            Patient_Custom__c p = new Patient_Custom__c();
            p.Birthdate__c = date.newInstance(1960, 8, 7);
            p.Signed_Screening__c = true;
            p.Ethnicity__c = 'Hispanic or latino';
            p.Gender__c = 'female';
            p.Race__c = 'asian';
            p.First_Name__c = 'test';
            p.Last_Name__c = 'kumar';
            p.Zip__c = '12';
            p.Middle_Name__c = 'testing';
            p.Institute_Text__c = 'asc';
            p.Institution__c = accObj.Id;
            p.Medical_Record_Number__c = '1234';
            insert p;
            
            Registration__c reg = new Registration__c();
            reg.Patient__c = p.Id;
            reg.Registration_Date__c = System.today();
            reg.Trial__c = t.Id;
            reg.Institution__c = accObj.Id;
            reg.Site__c = site1.Id;
            reg.IRB_Approval_Date__c = System.today();
            reg.Screening_Informed_Consent_Date__c = System.today();
            reg.HIPPA_Consent_Date__c = System.today();
          //  reg.ACRIN_6693_MRS_Participant__c = 'Yes';
            insert reg;
            
            List<Registration__c> regList = [select TrialPatient__c from Registration__c where Id =:reg.Id order by LastModifiedDate desc limit 1];
            
            Apexpages.currentPage().getParameters().put('trialPat', regList[0].TrialPatient__c);
            patientReadOnlyController proc = new patientReadOnlyController();
            proc.getPatientObj();
            proc.getpatientIdAttribute();
            proc.setpatientIdAttribute('s');
            
            Apexpages.currentPage().getParameters().put('PatientId', p.Id);
            patientReadOnlyController proc1 = new patientReadOnlyController();
            proc1.getPatientObj();
            proc1.getpatientIdAttribute();
            proc1.setpatientIdAttribute('s');
            }
        }
    }
}