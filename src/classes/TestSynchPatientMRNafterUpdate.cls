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
private class TestSynchPatientMRNafterUpdate {

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
        
        Trial__c trial1 = new Trial__c();
        trial1.Name='test Trial 1';
        insert trial1; 
        
        Patient_Custom__c pc = new Patient_Custom__c();
        pc.First_Name__c = 'test';
        pc.Last_Name__c = 'test1';
        pc.Gender__c = 'Male';
        pc.Birthdate__c = system.today();
        pc.Race__c = 'White';
        pc.Ethnicity__c = 'Not Hispanic or Latino';
        pc.Institution__c = inst1.Id;
        pc.Medical_Record_Number__c = '3434';
        pc.Signed_Screening__c = true;
        insert pc;
        
        List<Patient_Custom__c> lstPatient = [Select p.Initials__c,p.Institute_Text__c  From Patient_Custom__c p where Id = : pc.Id];
        
        PreEligibility_Checklist__c pre = new PreEligibility_Checklist__c();
        pre.Patient__c = pc.Id;
        pre.Patient_signed_up_for_I_SPY2_screening__c = false;
        insert pre; 
        
        Registration__c reg1 = new Registration__c();
        reg1.Patient__c = pc.Id;
        reg1.First_Name__c = pc.First_Name__c;
        reg1.Last_Name__c = pc.Last_Name__c;
        reg1.Ethnicity__c = pc.Ethnicity__c;
        reg1.Race__c =  pc.Race__c;
        reg1.Gender__c = pc.Gender__c;
        reg1.Registration_Date__c = system.today();
        reg1.Trial__c = trial1.Id;
       // reg1.MRN__c = '3535';
        reg1.Initials__c = lstPatient[0].Initials__c;
        reg1.Institution__c = inst1.Id;
        reg1.Site__c = site1.Id;
        reg1.IRB_Approval_Date__c = date.newInstance(2008, 7, 7); //regist
        reg1.Screening_Informed_Consent_Date__c = date.newInstance(2009, 7, 7);
        reg1.HIPPA_Consent_Date__c = date.newInstance(2011, 7, 7);
        //reg1.ACRIN_6693_MRS_Participant__c = 'Yes'; 
        insert reg1;
        
        update pc;
        update pc;
         }
      }
   }
}