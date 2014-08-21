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
private class TestRegistration {

    @isTest static void myUnitTest() {
        // TO DO: implement unit test
        
        List<User> thisUser = [ select u.Id , u.IsActive from User u where profile.Name = 'System Administrator' and IsActive = true];
        System.runAs (thisUser[0]){
            
        Account inst1 = new Account(); //inst
        
        List<Account> lstAccount = [Select a.RecordType.Name, a.RecordTypeId, a.Id From Account a where RecordType.Name = 'Institution'];
            
        if(!lstAccount.isEmpty()){
        
        Code_Master__c snomedObject = new Code_Master__c();
        snomedObject.Name = 'Race';
        insert snomedObject;
                
        inst1 = lstAccount[0];
            
        Site__c site1 = new Site__c();
        site1.Name = 'test site1';
        site1.Type__c = 'test type';
        site1.Institute__c = inst1.Id;
        insert site1;
        
        Patient_Custom__c pc = new Patient_Custom__c();
        pc.Last_Name__c = 'test2';
        pc.Gender__c = 'Male';
        pc.Birthdate__c = date.newInstance(1988, 7, 7);
        pc.Race__c = 'White';
        pc.Ethnicity__c = 'Not Hispanic or Latino';
        pc.Institution__c = inst1.Id;
        insert pc;
        
        List<Patient_Custom__c> lstPatient = [Select p.Initials__c, p.Last_Name__c, p.Institute_Text__c, p.Gender__c ,p.Birthdate__c ,p.Race__c ,p.Ethnicity__c ,p.Institution__c From Patient_Custom__c p where Id = : pc.Id];
        
        Trial__c tri = new Trial__c();
        tri.Name = 'test';
        insert tri;
        
        TrialPatient__c tp = new TrialPatient__c();
        tp.Patient_Id__c = lstPatient[0].Id;
        tp.Trial_Id__c = tri.Id;
        insert tp;
        
        Registration__c reg = new Registration__c(); 
        reg.Patient__c = lstPatient[0].Id;
        reg.Registration_Date__c = system.today();
        reg.Trial__c = tri.Id;
        reg.Institution__c = inst1.Id;
        reg.Site__c = site1.Id;
        reg.IRB_Approval_Date__c = system.today();
        reg.HIPPA_Consent_Date__c = system.today();
        reg.Screening_Informed_Consent_Date__c = system.today();
        reg.Effective_Time__c = system.now();
        reg.ISPY2_Subject_Id__c = ''+123;
        insert reg; 
        
        Attachment att = new Attachment();
        att.ParentId = reg.Id;
        att.Name = 'test';
        att.Body = Blob.valueOf('testing');
        insert att;
        
        Apexpages.currentPage().getParameters().put('isxmlpage','test');
        ApexPages.currentPage().getParameters().put('patientId',lstPatient[0].Id);   
        Apexpages.currentPage().getParameters().put('trial',tri.Id);
        ApexPages.StandardController controller = new ApexPages.StandardController(reg);
        Registration regObj1 = new Registration(controller);
        regObj1.registrationObj = reg;
        
        ApexPages.currentPage().getParameters().put('nextTab','saveAndClose');
        regObj1.nextTabName = 'saveAndClose';
        Test.startTest();
        regObj1.next(); 
        
        regObj1.currentTab = 'RegistrationTab';
        regObj1.next();
        Test.stopTest();
        
        Apexpages.currentPage().getParameters().put('prevTab','saveAndClose');
        
        ApexPages.currentPage().getParameters().put('patientId',lstPatient[0].Id);
        regObj1.ISPY2SubjectId = true;
        }
     }
  }

    @isTest static void myUnitTestNew() {
        
        List<User> thisUser = [ select u.Id , u.IsActive from User u where profile.Name = 'System Administrator' and IsActive = true];
        System.runAs (thisUser[0]){
            
            Account inst1 = new Account(); //inst
            
            Code_Master__c snomedObject = new Code_Master__c();
            snomedObject.Name = 'Race';
            insert snomedObject;
            
            List<Account> lstAccount = [Select a.RecordType.Name, a.RecordTypeId, a.Id From Account a where RecordType.Name = 'Institution'];
                
            if(!lstAccount.isEmpty()){
                
                inst1 = lstAccount[0];
                    
                Site__c site1 = new Site__c();
                site1.Name = 'test site1';
                site1.Type__c = 'test type';
                site1.Institute__c = inst1.Id;
                insert site1;
                
                Patient_Custom__c pc = new Patient_Custom__c();
                pc.Last_Name__c = 'test2';
                pc.Gender__c = 'Male';
                pc.Birthdate__c = date.newInstance(1988, 7, 7);
                pc.Race__c = 'White';
                pc.Ethnicity__c = 'Not Hispanic or Latino';
                pc.Institution__c = inst1.Id;
                insert pc;
                
                List<Patient_Custom__c> lstPatient = [Select p.Initials__c, p.Last_Name__c, p.Institute_Text__c, p.Gender__c ,p.Birthdate__c ,p.Race__c ,p.Ethnicity__c ,p.Institution__c From Patient_Custom__c p where Id = : pc.Id];
                
                Trial__c tri = new Trial__c();
                tri.Name = 'test';
                insert tri;
                
                TrialPatient__c tp = new TrialPatient__c();
                tp.Patient_Id__c = lstPatient[0].Id;
                tp.Trial_Id__c = tri.Id;
                insert tp;
                
                Registration__c reg = new Registration__c(); 
                reg.Patient__c = lstPatient[0].Id;
                reg.Registration_Date__c = system.today();
                reg.Trial__c = tri.Id;
                reg.Institution__c = inst1.Id;
                reg.Site__c = site1.Id;
                reg.IRB_Approval_Date__c = system.today();
                reg.HIPPA_Consent_Date__c = system.today();
                reg.Screening_Informed_Consent_Date__c = system.today();
                reg.Effective_Time__c = system.now();
                reg.ISPY2_Subject_Id__c = ''+123;
                insert reg; 
                
                Attachment att = new Attachment();
                att.ParentId = reg.Id;
                att.Name = 'test';
                att.Body = Blob.valueOf('testing');
                insert att;
                
                Apexpages.currentPage().getParameters().put('isxmlpage','test');
                ApexPages.currentPage().getParameters().put('patientId',lstPatient[0].Id);   
                Apexpages.currentPage().getParameters().put('trial',tri.Id);
                ApexPages.StandardController controller = new ApexPages.StandardController(reg);
                Registration regObj1 = new Registration(controller);
                regObj1.registrationObj = reg;
                
                ApexPages.currentPage().getParameters().put('nextTab','saveAndClose');
                regObj1.nextTabName = 'saveAndClose';
                
                regObj1.currentTab = 'RegistrationTab';
                
                Apexpages.currentPage().getParameters().put('prevTab','saveAndClose');
                
                ApexPages.currentPage().getParameters().put('patientId',lstPatient[0].Id);
                regObj1.ISPY2SubjectId = true;
                Test.startTest();
                regObj1.generateXML();
                
                regObj1.viewXML();
                
                regObj1.downloadXML();
                Test.stopTest();
            }
        }
    }
  
   @isTest static void myUnitTest1() {
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
        
        Patient_Custom__c pc = new Patient_Custom__c();
        pc.Last_Name__c = 'test2';
        pc.Gender__c = 'Male';
        pc.Birthdate__c = date.newInstance(1988, 7, 7);
        pc.Race__c = 'White';
        pc.Ethnicity__c = 'Not Hispanic or Latino';
        pc.Institution__c = inst1.Id;
        insert pc;
        
        List<Patient_Custom__c> lstPatient = [Select p.Initials__c, p.Last_Name__c, p.Institute_Text__c, p.First_Name__c, p.Gender__c ,p.Birthdate__c ,p.Race__c ,p.Ethnicity__c ,p.Institution__c From Patient_Custom__c p where Id = : pc.Id];
        
        Trial__c tri = new Trial__c();
        tri.Name = 'test';
        insert tri;
        
        TrialPatient__c tp = new TrialPatient__c();
        tp.Patient_Id__c = lstPatient[0].Id;
        tp.Trial_Id__c = tri.Id;
        insert tp;
        
        Registration__c reg = new Registration__c(); 
        reg.Patient__c = lstPatient[0].Id;
        reg.Registration_Date__c = system.today();
        reg.Trial__c = tri.Id;
        reg.Institution__c = inst1.Id;
        reg.Site__c = site1.Id;
        reg.IRB_Approval_Date__c = system.today();
        reg.HIPPA_Consent_Date__c = system.today();
        reg.Screening_Informed_Consent_Date__c = system.today();
        reg.Status__c = 'Accepted';
        reg.Effective_Time__c = system.now();
        reg.ISPY2_Subject_Id__c = ''+123;
        insert reg;
        update reg; 
        
        ApexPages.currentPage().getParameters().put('patientId',lstPatient[0].Id);   
        Apexpages.currentPage().getParameters().put('trial',tri.Id);
        ApexPages.StandardController controller = new ApexPages.StandardController(reg);
        Registration regObj1 = new Registration(controller);
        regObj1.registrationObj = reg;
        //regObj1.selectedInstitution = inst1.Id;
        
        regObj1.signAndSubmit();
        regObj1.resendCode();
        ApexPages.currentPage().getParameters().put('patientId',lstPatient[0].Id); 
        regObj1.customCancel();
        
        }
     }
  }
  @isTest static void myUnitTest2() { // for registration =  null (therefore not inserting reg)
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
        
        Patient_Custom__c pc = new Patient_Custom__c();
        pc.Last_Name__c = 'test2';
        pc.Gender__c = 'Male';
        pc.Birthdate__c = date.newInstance(1988, 7, 7);
        pc.Race__c = 'White';
        pc.Ethnicity__c = 'Not Hispanic or Latino';
        pc.Institution__c = inst1.Id;
        insert pc;
        
        Trial__c tri = new Trial__c();
        tri.Name = 'test';
        insert tri;
        
        TrialPatient__c tp = new TrialPatient__c();
        tp.Patient_Id__c = pc.Id;
        tp.Trial_Id__c = tri.Id;
        insert tp;
        
        Registration__c reg = new Registration__c(); // line 44 , if condition
        reg.Patient__c = pc.Id;
        reg.Registration_Date__c = system.today();
        reg.Trial__c = tri.Id;
        reg.Institution__c = inst1.Id;
        reg.Site__c = site1.Id;
        reg.IRB_Approval_Date__c = system.today();
        reg.HIPPA_Consent_Date__c = system.today();
        reg.Screening_Informed_Consent_Date__c = system.today();
        //insert reg; // dont insert to make it null 
       
        ApexPages.currentPage().getParameters().put('patientId',pc.Id);   
        Apexpages.currentPage().getParameters().put('trial',tri.Id);
        ApexPages.StandardController controller = new ApexPages.StandardController(reg);
        Registration regObj1 = new Registration(controller);
        regObj1.registrationObj = null;  // line number 134
        
        }
      }
   }
}