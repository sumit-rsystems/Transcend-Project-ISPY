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
private class TestCreateTrialPatientTrigger {

    @isTest static void myUnitTest() {
        // TO DO: implement unit test
        List<RecordType> recTypeAppPending = [select id,Name from RecordType where sObjectType = 'Registration__c' and Name = 'Approval Pending' ];
        List<InstitutionUser__c> lstinstObject = [Select i.User__c, i.Site__c, i.Institution__c,i.Trial__c, i.Id From InstitutionUser__c i where User__c != null and Site__c != null and Institution__c != null and Trial__c != null and User__r.IsActive = true limit 1];
        //List<User> thisUser = [ select u.Id , u.IsActive from User u where profile.Name = 'System Administrator' and IsActive = true];
        List<User> thisUser = [ select u.Id , u.IsActive from User u where id =:lstinstObject[0].User__c and IsActive = true];
        
        Account inst1 = new Account(); //inst
            
        List<Account> lstAccount1 = [Select a.RecordType.Name, a.RecordTypeId, a.Id From Account a where RecordType.Name = 'Institution' and id =: lstinstObject[0].Institution__c];
        
        Account dcc1 = new Account(); // inst or dcc
        
        List<Account> lstAccount2 = [Select a.Name ,a.RecordType.Name, a.RecordTypeId, a.Id From Account a where RecordType.Name = 'DCC'];
        
        if(!(lstAccount1.isEmpty() && lstAccount2.isEmpty())){
            
        inst1 = lstAccount1[0];
        dcc1 =  lstAccount2[0];
        
        InstitutionDcc__c instDCC1 = new InstitutionDcc__c();
        instDCC1.DCC_Id__c = dcc1.Id;
        instDCC1.Institution_Id__c = lstinstObject[0].Institution__c;
        insert instDCC1;
            
        InstitutionTrialDcc__c instTrialDcc = new InstitutionTrialDcc__c();
        instTrialDcc.DCC_Id__c = dcc1.Id;
        instTrialDcc.Institution_Id__c = lstinstObject[0].Institution__c;
        instTrialDcc.Trial_Id__c = lstinstObject[0].Trial__c;
        insert instTrialDcc;
        
        /*Group grp1 = new Group();
        grp1.Name = dcc1.Name;
        insert grp1;
        
        GroupMember gMember1 = new GroupMember();
        gMember1.UserOrGroupId = UserInfo.getUserId();
        gMember1.GroupId = grp1.Id;
        insert gMember1;*/
        
        System.runAs (thisUser[0]){
            
            /* Site__c site1 = new Site__c();
            site1.Name = 'test site1';
            site1.Type__c = 'test type';
            site1.Institute__c = inst1.Id;
            insert site1;*/
            
         /*   Trial__c trial1 = new Trial__c();
            trial1.Name='test Trial 1';
            //trial1.InstitutionDcc__c = instDCC1.Id;
            insert trial1; */
            
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
            
            //List<Patient_Custom__c> lstPatient = [Select p.Initials__c, p.Last_Name__c, p.Institute_Text__c, p.First_Name__c From Patient_Custom__c p where Id = : pc.Id];
            
            Registration__c reg1 = new Registration__c();
            reg1.Patient__c = pc.Id;
            reg1.Registration_Date__c = system.today();
            reg1.Trial__c = lstinstObject[0].Trial__c;
          //  reg1.MRN__c = '3535';
            reg1.Institution__c = inst1.Id;
            reg1.Site__c = lstinstObject[0].Site__c;
            reg1.IRB_Approval_Date__c = date.newInstance(2008, 7, 7); 
            reg1.Screening_Informed_Consent_Date__c = date.newInstance(2009, 7, 7);
            reg1.HIPPA_Consent_Date__c = date.newInstance(2011, 7, 7);
            //reg1.ACRIN_6693_MRS_Participant__c = 'Yes';
            //insert reg1; 
            
            if(!recTypeAppPending.isEmpty()) {
                reg1.RecordTypeId = recTypeAppPending[0].Id; 
            }
            upsert reg1;
            }
        }
    }
    
   @isTest static void myUnitTest1() {
        // TO DO: implement unit test
        List<RecordType> recTypeAppPending = [select id,Name from RecordType where sObjectType = 'Registration__c' and Name = 'Approval Pending' ];
        List<InstitutionUser__c> lstinstObject = [Select i.User__c, i.Site__c, i.Institution__c,i.Trial__c, i.Id From InstitutionUser__c i where User__c != null and Site__c != null and Institution__c != null and Trial__c != null and User__r.IsActive = true limit 1];
        //List<User> thisUser = [ select u.Id , u.IsActive from User u where profile.Name = 'System Administrator' and IsActive = true];
        List<User> thisUser = [ select u.Id , u.IsActive from User u where id =:lstinstObject[0].User__c and IsActive = true];
        
        Account inst1 = new Account(); //inst
            
        List<Account> lstAccount1 = [Select a.RecordType.Name, a.RecordTypeId, a.Id From Account a where RecordType.Name = 'Institution' and id =: lstinstObject[0].Institution__c];
        
        Account dcc1 = new Account(); // inst or dcc
        
        List<Account> lstAccount2 = [Select a.Name ,a.RecordType.Name, a.RecordTypeId, a.Id From Account a where RecordType.Name = 'DCC'];
        
        if(!(lstAccount1.isEmpty() && lstAccount2.isEmpty())){
            
        inst1 = lstAccount1[0];
        dcc1 =  lstAccount2[0];
        
        InstitutionDcc__c instDCC1 = new InstitutionDcc__c();
        instDCC1.DCC_Id__c = dcc1.Id;
        instDCC1.Institution_Id__c = lstinstObject[0].Institution__c;
        insert instDCC1;
        
        
        /*Group grp1 = new Group();
        grp1.Name = dcc1.Name;
        insert grp1;
        
        GroupMember gMember1 = new GroupMember();
        gMember1.UserOrGroupId = UserInfo.getUserId();
        gMember1.GroupId = grp1.Id;
        insert gMember1;*/
        
        InstitutionTrialDcc__c instTrialDcc = new InstitutionTrialDcc__c();
        instTrialDcc.DCC_Id__c = dcc1.Id;
        instTrialDcc.Institution_Id__c = lstinstObject[0].Institution__c;
        instTrialDcc.Trial_Id__c = lstinstObject[0].Trial__c;
        insert instTrialDcc;
        
        Contact con1 = new Contact();
        con1.LastName = 'test con1';
        con1.AccountId = inst1.Id;
        con1.Site__c = lstinstObject[0].Site__c;
        con1.Type__c = 'Oncologist';  
        insert con1;
        
        Contact con2 = new Contact();
        con2.LastName = 'test con2';
        con2.AccountId = inst1.Id;
        con2.Site__c = lstinstObject[0].Site__c;
        con2.Type__c = 'Clinical Coordinator';
        insert con2;
        
        Contact con3 = new Contact();
        con3.LastName = 'test con3';
        con3.AccountId = inst1.Id;
        con3.Site__c = lstinstObject[0].Site__c;
        con3.Type__c = 'Radiology Coordinator';
        insert con3;
        
        Contact con4 = new Contact();
        con4.LastName = 'test con4';
        con4.AccountId = inst1.Id;
        con4.Site__c = lstinstObject[0].Site__c;
        con4.Type__c = 'Surgeon';
        insert con4;
        
        
        System.runAs (thisUser[0]){
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
            
            //List<Patient_Custom__c> lstPatient = [Select p.Initials__c, p.Last_Name__c, p.Institute_Text__c, p.First_Name__c From Patient_Custom__c p where Id = : pc.Id];
            
            Registration__c reg2 = new Registration__c();
            reg2.Patient__c = pc.Id;
            reg2.Registration_Date__c = system.today();
            reg2.Trial__c = lstinstObject[0].Trial__c;
            reg2.Oncologist__c = con1.Id;
            reg2.Clinical_Coordinator__c = con2.Id;
            reg2.Radiology_Coordinator__c = con3.Id;
            reg2.Surgeon__c = con4.Id;
            reg2.Institution__c = inst1.Id;
            reg2.Site__c = lstinstObject[0].Site__c;
            reg2.IRB_Approval_Date__c = date.newInstance(2008, 7, 7); 
            reg2.Screening_Informed_Consent_Date__c = date.newInstance(2009, 7, 7);
            reg2.HIPPA_Consent_Date__c = date.newInstance(2011, 7, 7);
            //reg2.ACRIN_6693_MRS_Participant__c = 'Yes';
            insert reg2; 
            }
        }
    }
}