/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
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
private class TestCheckApprovalPendingStatus {

    static testMethod void testAESchedule() {
        
        Test.startTest();
        RecordType rt = [Select r.SobjectType, r.Name, r.Id From RecordType r where r.SobjectType = 'Account' and Name = 'Institution'];
        Account inst1 = [select Id from Account where RecordTypeId = :rt.Id limit 1];
        
        Site__c s = new Site__c();
        s.Institute__c = inst1.Id;
        insert s;
        
        Trial__c trial1 = new Trial__c();
        trial1.Name='test Trial 1';
        insert trial1;  
        
        Patient_Custom__c p = new Patient_Custom__c();
        p.Birthdate__c = date.newInstance(1950, 08, 05);
        p.Institution__c = inst1.Id;
        p.Last_Name__c = 'test'; 
		p.Gender__c = 'Male';
		p.Race__c = 'White';
		p.Ethnicity__c = 'Not Hispanic or Latino';
        insert p;
        
        TrialPatient__c tp = new TrialPatient__c();
        tp.Patient_Id__c = p.Id;
        tp.Trial_Id__c = trial1.Id;
        insert tp;
        
        AE_Detail__c aed1 = new AE_Detail__c();
        aed1.TrialPatient__c = tp.Id;
        aed1.Visit_Date__c = date.newInstance(2012, 7, 7);
        aed1.Patient_Hospitalized__c = true;
        insert aed1;
        
        Apexpages.Standardcontroller std = new Apexpages.Standardcontroller(aed1);
        AdverseEventController aec = new AdverseEventController(std);
        aec.signAndSubmit();
        System.assert(aec.errorMsg != null || aec.errorMsg != '');
        
        aed1.Status__c = 'Not Completed';
        update aed1;
        
        String jobId = System.schedule('testCheckApprovalPendingStatus',
      		CheckApprovalPendingStatus.CRON_EXP, new CheckApprovalPendingStatus());

      	// Get the information from the CronTrigger API object
      	CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId];

      	// Verify the expressions are the same
      	System.assertEquals(CheckApprovalPendingStatus.CRON_EXP, ct.CronExpression);

	    // Verify the job has not run
	    System.assertEquals(0, ct.TimesTriggered);
	    Test.stopTest();
    }
    
    static testMethod void testOSEchedule() {
    	
    	Test.startTest();
    	RecordType rt = [Select r.SobjectType, r.Name, r.Id From RecordType r where r.SobjectType = 'Account' and Name = 'Institution'];
        Account inst1 = [select Id from Account where RecordTypeId = :rt.Id limit 1];
        
        Site__c s = new Site__c();
        s.Institute__c = inst1.Id;
        insert s;
        
        Trial__c trial1 = new Trial__c();
        trial1.Name='test Trial 1';
        insert trial1;  
        
        Patient_Custom__c p = new Patient_Custom__c();
        p.Birthdate__c = date.newInstance(1950, 08, 05);
        p.Institution__c = inst1.Id;
        p.Last_Name__c = 'test'; 
		p.Gender__c = 'Male';
		p.Race__c = 'White';
		p.Ethnicity__c = 'Not Hispanic or Latino';
        insert p;
        
        TrialPatient__c tp = new TrialPatient__c();
        tp.Patient_Id__c = p.Id;
        tp.Trial_Id__c = trial1.Id;
        insert tp;

		On_Study_Eligibility_Form__c osef = new On_Study_Eligibility_Form__c();
        osef.TrialPatient__c = tp.Id;
        osef.How_was_the_cancer_first_detected__c = 'Clinical exam'; 
        osef.Status__c = 'Not Completed';
        insert osef;
        
        Apexpages.Standardcontroller std = new Apexpages.Standardcontroller(osef);
        OnStudyEligibilityFormsNew oseController = new OnStudyEligibilityFormsNew(std);
        oseController.signAndSubmit();
        System.assert(oseController.errorMsg != null || oseController.errorMsg != '');
        
        osef.Status__c = 'Not Completed';
        update osef;
        
        String jobId = System.schedule('testCheckApprovalPendingStatus',
      		CheckApprovalPendingStatus.CRON_EXP, new CheckApprovalPendingStatus());

      	// Get the information from the CronTrigger API object
      	CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId];

      	// Verify the expressions are the same
      	System.assertEquals(CheckApprovalPendingStatus.CRON_EXP, ct.CronExpression);

	    // Verify the job has not run
	    System.assertEquals(0, ct.TimesTriggered);
	    Test.stopTest();
    }
}