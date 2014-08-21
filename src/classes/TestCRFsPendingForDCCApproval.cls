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
private class TestCRFsPendingForDCCApproval {

    @isTest static void myUnitTest1() {
        
        Account acc = new Account();
        acc.Name = 'testing';
        insert acc;
        
        CRFMaster__c crfMaster = new CRFMaster__c();
        crfMaster.CRFType__c = 'Registration__c';
        crfMaster.Object_Name__c = 'Registration__c';
        insert crfMaster;
        
        Phase_Master__c phMaster = new Phase_Master__c();
        phMaster.Name = 'Screening';
        phMaster.Order__c = 108;  
        insert phMaster;
        
        Phase_Cycle__c phc = new Phase_Cycle__c();
        phc.Phase__c = phMaster.id;
        phc.Order__c = 110;
        insert phc;
        
        Phase_CRFs__c phCrf = new Phase_CRFs__c();
        phCrf.Phase_Cycle__c = phc.id;
        phCrf.CRF__c = crfMaster.Id;
        insert phCrf;
        
        Patient_Custom__c pt = new Patient_Custom__c();
        pt.Name = 'testPatient';
        pt.Institution__c = acc.id;
        pt.Last_Name__c = 'test';
        pt.Birthdate__c = date.newInstance(1970, 04, 05);
        pt.Gender__c = 'Male';
        pt.Race__c = 'White';
        pt.Ethnicity__c = 'Not Hispanic or Latino';
        pt.TestHarnessId__c = 'asc002';
        insert pt;
        
        Trial__c tc = new Trial__c();
        tc.Name = 'testTrial';
        insert tc;
         
        Task tsk = new Task();
        tsk.WhatId = pt.id;
        tsk.Subject = 'Complete Registration CRF';
        tsk.ActivityDate = system.today().addDays(3);
        tsk.Original_Due_Date__c = tsk.ActivityDate;
        tsk.Description = 'Please fill Registration CRF till date.';
        //tsk.OwnerId = Userinfo.getUserId();
        tsk.Type = 'Complete Registration CRF';
        tsk.Object_Label__c = 'Registration';
        tsk.Object_Name__c = 'Registration__c';
        //tsk.Status = 'In Progress';
        tsk.CallType = 'Internal';
        tsk.Trial_Id__c = tc.id;
        tsk.Trial__c = tc.Name;
        insert tsk;
        
        TrialPatient__c tpObj = new TrialPatient__c();
        tpObj.Patient_Id__c = pt.Id;    
        tpObj.Trial_Id__c = tc.Id;
        insert tpObj;
        
        CRFsPendingForDCCApproval crfPendingDcc = new CRFsPendingForDCCApproval();
        Apexpages.currentPage().getParameters().put('CRFName','Registration__c');
        
        crfPendingDcc.CRFPendingListsView();
        crfPendingDcc.selectedCRFViewOption = 'Registration__c';
        crfPendingDcc.createNewCRFsList();
        crfPendingDcc.CRFPendingRandomization();
        
    }
    
    @isTest static void myUnitTest2() {
        Account acc = new Account();
        acc.Name = 'testing';
        insert acc;
        
        CRFMaster__c crfMaster = new CRFMaster__c();
        crfMaster.CRFType__c = 'Chemo_Treatment__c';
        crfMaster.Object_Name__c = 'Chemo_Treatment__c';
        insert crfMaster;
        
        Phase_Master__c phMaster = new Phase_Master__c();
        phMaster.Name = 'Treatment';
        phMaster.Order__c = 109;  
        insert phMaster;
        
        Phase_Cycle__c phc = new Phase_Cycle__c();
        phc.Phase__c = phMaster.id;
        phc.Order__c = 111;
        insert phc;
        
        Phase_CRFs__c phCrf = new Phase_CRFs__c();
        phCrf.Phase_Cycle__c = phc.id;
        phCrf.CRF__c = crfMaster.Id;
        insert phCrf;
        
        Patient_Custom__c pt = new Patient_Custom__c();
        pt.Name = 'testPatient';
        pt.Institution__c = acc.id;
        pt.Last_Name__c = 'test';
        pt.Birthdate__c = date.newInstance(1970, 04, 05);
        pt.Gender__c = 'Male';
        pt.Race__c = 'White';
        pt.Ethnicity__c = 'Not Hispanic or Latino';
        pt.TestHarnessId__c = 'asc002';
        insert pt;
        
        Trial__c tc = new Trial__c();
        tc.Name = 'testTrial';
        insert tc;
        
        Task tsk = new Task();
        tsk.WhatId = pt.id;
        tsk.Subject = 'Complete Registration CRF';
        tsk.ActivityDate = system.today().addDays(3);
        tsk.Original_Due_Date__c = tsk.ActivityDate;
        tsk.Description = 'Please fill Registration CRF till date.';
        //tsk.OwnerId = Userinfo.getUserId();
        tsk.Type = 'Complete Chemo Treatment CRF';
        tsk.Object_Label__c = 'Chemo Treatment';
        tsk.Object_Name__c = 'Chemo_Treatment__c';
        //tsk.Status = 'In Progress';
        tsk.CallType = 'Internal';
        tsk.Trial_Id__c = tc.id;
        tsk.Trial__c = tc.Name;
        insert tsk;
        
        TrialPatient__c tpObj = new TrialPatient__c();
        tpObj.Patient_Id__c = pt.Id;    
        tpObj.Trial_Id__c = tc.Id;
        insert tpObj;
        
        CRFsPendingForDCCApproval crfPendingDcc = new CRFsPendingForDCCApproval();
        Apexpages.currentPage().getParameters().put('CRFName','Chemo_Treatment__c');
        
        crfPendingDcc.CRFPendingListsView();
        crfPendingDcc.selectedCRFViewOption = 'Chemo_Treatment__c';
        crfPendingDcc.createNewCRFsList();
        crfPendingDcc.CRFPendingRandomization();
    }
    
    @isTest static void myUnitTest3() {
        Account acc = new Account();
        acc.Name = 'testing';
        insert acc;
        
        CRFMaster__c crfMaster = new CRFMaster__c();
        crfMaster.CRFType__c = 'Followup_Form__c';
        crfMaster.Object_Name__c = 'Followup_Form__c';
        insert crfMaster;
        
        Phase_Master__c phMaster = new Phase_Master__c();
        phMaster.Name = 'Follow Up';
        phMaster.Order__c = 109;  
        insert phMaster;
        
        Phase_Cycle__c phc = new Phase_Cycle__c();
        phc.Phase__c = phMaster.id;
        phc.Order__c = 111;
        insert phc;
        
        Phase_CRFs__c phCrf = new Phase_CRFs__c();
        phCrf.Phase_Cycle__c = phc.id;
        phCrf.CRF__c = crfMaster.Id;
        insert phCrf;
        
        Patient_Custom__c pt = new Patient_Custom__c();
        pt.Name = 'testPatient';
        pt.Institution__c = acc.id;
        pt.Last_Name__c = 'test';
        pt.Birthdate__c = date.newInstance(1970, 04, 05);
        pt.Gender__c = 'Male';
        pt.Race__c = 'White';
        pt.Ethnicity__c = 'Not Hispanic or Latino';
        pt.TestHarnessId__c = 'asc002';
        insert pt;
        
        Trial__c tc = new Trial__c();
        tc.Name = 'testTrial';
        insert tc;
        
        Task tsk = new Task();
        tsk.WhatId = pt.id;
        tsk.Subject = 'Complete Follow Up CRF';
        tsk.ActivityDate = system.today().addDays(3);
        tsk.Original_Due_Date__c = tsk.ActivityDate;
        tsk.Description = 'Please fill Registration CRF till date.';
        //tsk.OwnerId = Userinfo.getUserId();
        tsk.Type = 'Complete Chemo Treatment CRF';
        tsk.Object_Label__c = 'Follow Up';
        tsk.Object_Name__c = 'Followup_Form__c';
        //tsk.Status = 'In Progress';
        tsk.CallType = 'Internal';
        tsk.Trial_Id__c = tc.id;
        tsk.Trial__c = tc.Name;
        insert tsk;
        
        TrialPatient__c tpObj = new TrialPatient__c();
        tpObj.Patient_Id__c = pt.Id;    
        tpObj.Trial_Id__c = tc.Id;
        insert tpObj;
        
        CRFsPendingForDCCApproval crfPendingDcc = new CRFsPendingForDCCApproval();
        Apexpages.currentPage().getParameters().put('CRFName','Followup_Form__c');
        
        crfPendingDcc.CRFPendingListsView();
        crfPendingDcc.selectedCRFViewOption = 'Followup_Form__c';
        crfPendingDcc.createNewCRFsList();
        crfPendingDcc.CRFPendingRandomization();
        
        crfPendingDcc.selectedCRFViewOption = 'Patients pending Randomization';
        crfPendingDcc.createNewCRFsList();
        
        crfPendingDcc.selectedCRFViewOption = 'pending submission';
        crfPendingDcc.createNewCRFsList();
        
        crfPendingDcc.selectedCRFViewOption = 'pending re-submission';
        crfPendingDcc.createNewCRFsList();
        
        crfPendingDcc.selectedCRFViewOption = 'Patients pending registration';
        crfPendingDcc.createNewCRFsList();
        
        Apexpages.currentPage().getParameters().put('CRFName','Randomization_Form__c');
        crfPendingDcc.CRFPendingListsView();
        
        CRFsPendingForDCCApproval.CRFRandomizationWrapper crfWap = new CRFsPendingForDCCApproval.CRFRandomizationWrapper();
        
    }
}