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
private class TestEnablePatientInPortal {

    @isTest static void myUnitTest() {
        // TO DO: implement unit test
        
        List<User> thisUser = [Select u.IsActive, u.Id ,u.Patient_Id__c,u.ProfileId,u.Username From User u where IsActive = true and Profile.Name = 'System Administrator'];   
        
        System.runAs (thisUser[0]) {   
            
        Account inst1 = new Account(); 
        inst1.Name = 'test';
        insert inst1;
        
        Trial__c tri = new Trial__c();
        tri.Name = 'test';
        insert tri;
            
        Site__c site1 = new Site__c();
        site1.Name = 'test site1';
        site1.Type__c = 'test type';
        site1.Institute__c = inst1.Id;
        insert site1;
        
        Site_Trial__c sitetrial = new Site_Trial__c();
        sitetrial.Site__c = site1.Id;
        sitetrial.Trial__c = tri.Id;
        insert sitetrial;
        
        Patient_Custom__c pc = new Patient_Custom__c();
        pc.First_Name__c = 'test';
        pc.Last_Name__c = 'test2';
        pc.Gender__c = 'Male';
        pc.Birthdate__c = date.newInstance(1988, 7, 7);
        pc.Race__c = 'White';
        pc.Ethnicity__c = 'Not Hispanic or Latino';
        pc.Institution__c = inst1.Id;
        pc.Email__c = thisUser[0].Username;
        insert pc;
        
        TrialPatient__c tp = new TrialPatient__c();
        tp.Patient_Id__c = pc.Id;
        tp.Trial_Id__c = tri.Id;
        insert tp;
         
        Registration__c reg = new Registration__c(); 
        reg.Patient__c = pc.Id;
        reg.TrialPatient__c = tp.Id;
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
        
       /* List<Patient_Custom__c> lstPat = new List<Patient_Custom__c>();
        lstPat.add(pc);*/
        
        EnablePatientInPortal eppObject = new EnablePatientInPortal();
        eppObject.patientId = pc.Id; 
        eppObject.institution = inst1.Id;
        eppObject.site = site1.Id;
        eppObject.trial = tri.Id; 
        
        eppObject.loadInstitution();
        
        eppObject.Pagination();
        eppObject.loadSite();
        eppObject.loadTrial();
        
        eppObject.redioButtn = 'Need Access';
        eppObject.loadRedioButton();
        
        eppObject.redioButtn = 'Revoke';
        eppObject.loadRedioButton();
        
        /*eppObject.GetCurrentPatientList();
        eppObject.PreparePageNumberList();
        eppObject.GoToPageNumber();
        eppObject.GoToFirstPage();
        eppObject.GoToLastPage();
        eppObject.checkPreviousDisable();
        eppObject.checkNextDisable();
        eppObject.PrintPageRecordDetail();
        */
        
        eppObject.patientId = pc.Id; 
        eppObject.enablePartalAccess(); 
        eppObject.DeactiviteUSer();
        
        //eppObject.BuildPagination(patieWrap);
        //eppObject.GetCurrentPropertyList(); 
        
        
       // eppObject.GoToNextPage();
       // eppObject.GoToPreviousPage();
       
       EnablePatientInPortal eppObject1 = new EnablePatientInPortal(); // to satisfy "else" part line 183 of "Pagination" method
       eppObject1.patientId = pc.Id; 
       eppObject1.institution = inst1.Id;
       eppObject1.site = null;
       eppObject1.trial = null;
        
       eppObject1.Pagination();
        
      }
   }
}