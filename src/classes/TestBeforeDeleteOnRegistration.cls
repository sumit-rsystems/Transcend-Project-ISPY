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
private class TestBeforeDeleteOnRegistration {

    @isTest static void myUnitTest() {
        // TO DO: implement unit test
        List<User> thisUser = [ select u.Id , u.IsActive from User u where profile.Name = 'System Administrator' and IsActive = true];
        System.runAs (thisUser[0]){
            
            Account inst1 = new Account(); //inst
            
            List<Account> lstAccount1 = [Select a.RecordType.Name, a.RecordTypeId, a.Id From Account a where RecordType.Name = 'Institution'];
            
            Account dcc1 = new Account(); // inst or dcc
            
            List<Account> lstAccount2 = [Select a.Name ,a.RecordType.Name, a.RecordTypeId, a.Id From Account a where RecordType.Name = 'DCC'];
            
            if(!(lstAccount1.isEmpty() && lstAccount2.isEmpty())){
                
            inst1 = lstAccount1[0];
            dcc1 =  lstAccount2[0];
                
            Site__c site1 = new Site__c();
            site1.Name = 'test site1';
            site1.Type__c = 'test type';
            site1.Institute__c = inst1.Id;
            insert site1;
            
            InstitutionDcc__c instDCC1 = new InstitutionDcc__c();
            instDCC1.DCC_Id__c = dcc1.Id;
            instDCC1.Institution_Id__c = inst1.Id;
            insert instDCC1;
            
            Trial__c trial1 = new Trial__c();
            trial1.Name='test Trial 1';
            //trial1.InstitutionDcc__c = instDCC1.Id;
            insert trial1; 
            
            InstitutionTrialDcc__c instTrialDcc = new InstitutionTrialDcc__c();
            instTrialDcc.DCC_Id__c = dcc1.Id;
            instTrialDcc.Institution_Id__c = inst1.Id;
            instTrialDcc.Trial_Id__c = trial1.Id;
            insert instTrialDcc;
            
            Group grp1 = new Group();
            grp1.Name = dcc1.Name;
            insert grp1;
            
            GroupMember gMember1 = new GroupMember();
            gMember1.UserOrGroupId = UserInfo.getUserId();
            gMember1.GroupId = grp1.Id;
            insert gMember1;
            
            Patient_Custom__c pc = new Patient_Custom__c();
            pc.First_Name__c = 'test';
            pc.Last_Name__c = 'test2';
            pc.Gender__c = 'Male';
            pc.Birthdate__c = date.newInstance(1988, 7, 7);
            pc.Race__c = 'White';
            pc.Ethnicity__c = 'Not Hispanic or Latino';
            pc.Institution__c = inst1.Id;
            pc.Medical_Record_Number__c = '3434';
            insert pc;
            
            List<Patient_Custom__c> lstPatient = [Select p.Initials__c, p.Last_Name__c, p.Institute_Text__c, p.First_Name__c From Patient_Custom__c p where Id = : pc.Id];
            
            Registration__c reg1 = new Registration__c();
            reg1.Patient__c = pc.Id;
            reg1.First_Name__c = lstPatient[0].First_Name__c;
            reg1.Last_Name__c = lstPatient[0].Last_Name__c;
            reg1.Gender__c = pc.Gender__c;
            reg1.Registration_Date__c = system.today();
            reg1.Trial__c = trial1.Id;
          //  reg1.MRN__c = '3535';
            reg1.Initials__c = lstPatient[0].Initials__c;
            reg1.Ethnicity__c = pc.Ethnicity__c;
            reg1.Race__c =  pc.Race__c;
            reg1.Institution__c = inst1.Id;
            reg1.Site__c = site1.Id;
            reg1.IRB_Approval_Date__c = date.newInstance(2008, 7, 7); 
            reg1.Screening_Informed_Consent_Date__c = date.newInstance(2009, 7, 7);
            reg1.HIPPA_Consent_Date__c = date.newInstance(2011, 7, 7);
        //  reg1.ACRIN_6693_MRS_Participant__c = 'Yes';
            insert reg1; 
            
            Registration__c reg2 = [select TrialPatient__c from Registration__c where Id =:reg1.Id order by LastModifiedDate desc limit 1];
            
            MRI_Volume__c mri = new MRI_Volume__c();
            mri.TrialPatient__c = reg2.TrialPatient__c;
            mri.MRI_Scan_Date__c = date.newInstance(2012, 7, 7);
            mri.MRI_Volume_in_cm3__c = 2.3;
            mri.Longest_Diameter_Of_Index_Lesion_in_cm__c = 2.4;
            mri.Time_Point__c = 'Pre-Treatment';
            insert mri;
            
            delete reg1;
            }
        }
    }
}