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
private class TestPatientSummaryReport {  

   @isTest static void myUnitTest() { 
        // TO DO: implement unit test
    List<User> thisUser = [ select u.Id , u.IsActive from User u where IsActive = true and id =: userinfo.getUserId()];
    System.runAs (thisUser[0]){
            
    Account inst1 = new Account();
        
    List<Account> lstAccount = [Select a.Id From Account a limit 1];
    
    if(!lstAccount.isEmpty()){
                
        inst1 = lstAccount[0];
        
        Patient_Custom__c pc = new Patient_Custom__c();
        pc.Last_Name__c = 'test1';
        pc.Gender__c = 'Male';
        pc.Birthdate__c = date.newInstance(1977, 8, 7);
        pc.Race__c = 'White';
        pc.Ethnicity__c = 'Not Hispanic or Latino';
        pc.Institution__c = inst1.Id;
        insert pc;
        
        Trial__c tri = new Trial__c();
        tri.Name = 'Test';
        insert tri;
        
        Site__c siteObject = new Site__c(); 
        siteObject.Institute__c = inst1.Id;
        siteObject.IsTestSite__c = false;
        insert siteObject; 
        
        TrialPatient__c triPat = new TrialPatient__c();
        triPat.Trial_Id__c = tri.Id;
        triPat.Patient_Id__c = pc.Id;
        triPat.Site__c = siteObject.Id;
        triPat.Subject_Id__c = ''+123;
        insert triPat;
        
        Registration__c reg1 = new Registration__c();
        reg1.Patient__c = pc.Id;
        reg1.TrialPatient__c = triPat.Id;
        reg1.Registration_Date__c = system.today();
        reg1.Trial__c = tri.Id;
        reg1.Institution__c = inst1.Id;
        reg1.IRB_Approval_Date__c = date.newInstance(2008, 7, 7); 
        reg1.Screening_Informed_Consent_Date__c = date.newInstance(2009, 7, 7);
        reg1.HIPPA_Consent_Date__c = date.newInstance(2011, 7, 7);
        reg1.Effective_Time__c = system.now();
        reg1.ISPY2_Subject_Id__c = ''+123;
        reg1.Status__c = 'Approval Pending';
        insert reg1; 
        reg1.Status__c = 'Accepted';
        Test.startTest();
        update reg1; 
        Test.stopTest();
        
        
        Agent__c agent = new Agent__c();
        agent.Name = 'Paclitaxel (Taxol)';
        agent.Display_Order__c = 0;
        insert agent;
        
        Chemo_Treatment__c chemObject = new Chemo_Treatment__c();
        chemObject.TrialPatient__c = triPat.Id;
        chemObject.Cycle_number__c = 2.0;
        insert chemObject;
        
        Chemo_Therapy_Regimen__c chemo = new Chemo_Therapy_Regimen__c ();
        chemo.Chemo_Treatment__c = chemObject.Id;
        chemo.Agent__c = agent.Id;
        chemo.Effective_Time__c = system.now();
        insert chemo;
        
        Off_Study_Detail__c offStudy1 = new Off_Study_Detail__c(); 
        offStudy1.TrialPatient__c = triPat.Id; 
        offStudy1.Patient_completed_study_per_protocol__c = true;
        offStudy1.Patient_did_not_want_to_complete_MRI__c = true;
        offStudy1.Patient_did_nt_want_to_complete_core_bio__c = true;
        offStudy1.Patient_did_nt_continue_on_treatment_arm__c = true;
        offStudy1.Patient_did_not_have_surgery__c = true;
        offStudy1.Patient_Died__c = true;
        
        insert offStudy1;
        
        
        
        PatientSummaryReport psrObject = new PatientSummaryReport();
        List<String> sis = new List<String>();
        sis.add(inst1.Id);
        psrObject.selectedInstitute = sis;
        
        List<String> tids = new List<String>();
        tids.add(tri.Id);
        psrObject.selectedTrial = tids;
        psrObject.reportRequestAction(); 
        PatientSummaryReport.sortList(new List<Sobject>{chemo}, 'Effective_Time__c', 'asc'); 
        
        PatientSummaryReport.sortList(new List<Sobject>{chemo}, 'Effective_Time__c', 'desc'); // satisfy "else if" condition line 779
        
     }
   }
 }
        @isTest public static void unitTest1() {  
            
        Account inst1 = new Account();
        List<Account> lstAccount = [Select a.Id From Account a limit 1];
        if(!lstAccount.isEmpty()){
                    
        inst1 = lstAccount[0];
            
        Patient_Custom__c pc = new Patient_Custom__c();
        pc.Last_Name__c = 'test1';
        pc.Gender__c = 'Male';
        pc.Birthdate__c = date.newInstance(1977, 8, 7);
        pc.Race__c = 'White';
        pc.Ethnicity__c = 'Not Hispanic or Latino';
        pc.Institution__c = inst1.Id;
        insert pc;
        
        Trial__c tri = new Trial__c();
        tri.Name = 'Test';
        insert tri;
        
        Site__c siteObject = new Site__c(); 
        siteObject.Institute__c = inst1.Id;
        siteObject.IsTestSite__c = false;
        insert siteObject;  
        
        TrialPatient__c triPat = new TrialPatient__c();
        triPat.Trial_Id__c = tri.Id;
        triPat.Patient_Id__c = pc.Id;
        triPat.Site__c = siteObject.Id;
        triPat.Subject_Id__c = ''+123;
        insert triPat;
            
        Registration__c reg1 = new Registration__c();
        reg1.Patient__c = pc.Id;
        reg1.TrialPatient__c = triPat.Id;
        reg1.Registration_Date__c = system.today();
        reg1.Trial__c = tri.Id;
        reg1.Institution__c = inst1.Id;
        reg1.IRB_Approval_Date__c = date.newInstance(2008, 7, 7); 
        reg1.Screening_Informed_Consent_Date__c = date.newInstance(2009, 7, 7);
        reg1.HIPPA_Consent_Date__c = date.newInstance(2011, 7, 7);
        reg1.Effective_Time__c = system.now();
        reg1.ISPY2_Subject_Id__c = ''+123;
        reg1.Status__c = 'Approval Pending';
        insert reg1; 
        reg1.Status__c = 'Accepted';
        update reg1; 
                
        Report_Request__c reportReq = new Report_Request__c();
        reportReq.Report_Type__c = 'Patient Summary';
        reportReq.Status__c = 'In Progress';
        insert reportReq;
            
        PatientSummaryReport psrObject = new PatientSummaryReport();
        List<String> sis = new List<String>();
        sis.add(inst1.Id);
        psrObject.selectedInstitute = sis;
        
        List<String> tids = new List<String>();
        tids.add(tri.Id);
        psrObject.selectedTrial = tids;
        Apexpages.currentPage().getParameters().put('repReqId',reportReq.Id);
        psrObject.storePatientSummaryReport(reportReq.Id, new List<String>{tri.Id}, new List<String>{inst1.Id});
        
        psrObject.generatePatientSummaryReport();   
        
      }
   } 
}