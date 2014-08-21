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
private class TestCheckStatusOfMasterCRFWithAllCRFs {
    static Account acc;
    static Site__c siteObject;
    static Contact con;
    static Patient_Custom__c pc;
    static Trial__c tri;
    static TrialPatient__c tp;
    static CRF__c crf;
    @isTest static void myUnitTest1() {
        CRFMaster__c crfMaster = new CRFMaster__c();
        crfMaster.CRFType__c = 'PreEligibility_Checklist__c';
        crfMaster.Object_Name__c = 'PreEligibility Checklists';
        insert crfMaster;
        
        acc = new Account();
        acc.Name = 'testing';
        insert acc;
        
        siteObject = new Site__c(); 
        siteObject.Institute__c = acc.Id;
        siteObject.IsTestSite__c = false;
        insert siteObject; 
        
        con = new Contact();
        con.AccountId = acc.Id;
        con.LastName = 'test';
        con.Site__c = siteObject.Id;
        con.Type__c = 'Surgeon';
        insert con;
        
        pc = new Patient_Custom__c();
        pc.Last_Name__c = 'test1';
        pc.Gender__c = 'Male';
        pc.Birthdate__c = date.newInstance(1977, 8, 7);
        pc.Race__c = 'White';
        pc.Ethnicity__c = 'Not Hispanic or Latino';
        pc.Institution__c = acc.Id;
        insert pc;
        
        crf = new CRF__c();
        crf.Status__c = 'test';
        crf.Patient__c = pc.id;
        insert crf;
        
        tri = new Trial__c();
        tri.Name = 'Test';
        insert tri;
        
        tp = new TrialPatient__c();
        tp.Trial_Id__c = tri.Id;
        tp.Patient_Id__c = pc.Id;
        tp.Site__c = siteObject.Id;
        tp.Subject_Id__c = ''+12345;
        insert tp;
    }
    
    @isTest static void myUnitTest2() {
    	myUnitTest1();
    	crf.Status__c = 'Not Completed';
        PreEligibility_Checklist__c pec = new PreEligibility_Checklist__c();
        pec.Patient__c = pc.Id;
        pec.CRF_Id__c = crf.id;
        pec.Status__c = 'Approval Not Required';
        insert pec;
        CheckStatusOfMasterCRFWithAllCRFs chk = new CheckStatusOfMasterCRFWithAllCRFs();
        chk.compareStatusAndSendEmail();
    }
    
     @isTest static void myUnitTest3() {
        myUnitTest1();
        crf.Status__c = 'Not Completed';
        AE_Detail__c aed1 = new AE_Detail__c();
        aed1.TrialPatient__c = tp.Id;
        aed1.Visit_Date__c = date.newInstance(2013, 6, 10);
        aed1.Patient_Hospitalized__c = true;
        aed1.CRF__c = crf.id;
        aed1.Status__c = 'Accepted';
        insert aed1;
        CheckStatusOfMasterCRFWithAllCRFs chk = new CheckStatusOfMasterCRFWithAllCRFs();
        chk.compareStatusAndSendEmail();
     }
     @isTest static void myUnitTest4() {
        myUnitTest1();
        crf.Status__c = 'Not Completed';
        TissueSpecimenDetail__c ts = new TissueSpecimenDetail__c();
        ts.Status__c = 'Accepted';
        ts.Patient__c = pc.Id;
        ts.TrialPatient__c = tp.Id;
        ts.ProcedureDate__c = date.newInstance(2012, 8, 10);
        ts.Time_Point__c = 'Pre-treatment';
        ts.CRFId__c = crf.Id;
        ts.NumberOfSamplesCollected__c = 1.0;
        insert ts;
        CheckStatusOfMasterCRFWithAllCRFs chk = new CheckStatusOfMasterCRFWithAllCRFs();
        chk.compareStatusAndSendEmail();
     }
     @isTest static void myUnitTest5() {
        myUnitTest1();
        crf.Status__c = 'Not Completed';
        Response_Evaluation_Form__c rev1 = new Response_Evaluation_Form__c();
        rev1.TrialPatient__c = tp.Id;
        rev1.CRF__c = crf.Id;
        rev1.Status__c = 'Not Completed';
        insert rev1;
        CheckStatusOfMasterCRFWithAllCRFs chk = new CheckStatusOfMasterCRFWithAllCRFs();
        chk.compareStatusAndSendEmail();
     }
     @isTest static void myUnitTest6() {
        myUnitTest1();
        crf.Status__c = 'Not Completed';
        Registration__c reg = new Registration__c(); 
        reg.Patient__c = pc.Id;
        reg.Registration_Date__c = system.today();
        reg.Trial__c = tri.Id;
        reg.Institution__c = acc.Id;
        reg.Site__c = siteObject.Id;
        reg.IRB_Approval_Date__c = system.today();
        reg.HIPPA_Consent_Date__c = system.today();
        reg.Screening_Informed_Consent_Date__c = system.today();
        reg.Effective_Time__c = system.now();
        reg.ISPY2_Subject_Id__c = ''+12345;
        reg.CRF__c = crf.id;
        insert reg;
        CheckStatusOfMasterCRFWithAllCRFs chk = new CheckStatusOfMasterCRFWithAllCRFs();
        chk.compareStatusAndSendEmail();
     }
     @isTest static void myUnitTest7() {
        myUnitTest1();
        crf.Status__c = 'Not Completed';
        ProtocolViolationDetail__c pv = new ProtocolViolationDetail__c();
        pv.TrialPatient__c = tp.Id;
        pv.Patient_Remains_on_Study__c = true;
        pv.Medication_non_complicance__c = true;
        pv.Status__c = 'Accepted';
        pv.CRFId__c = crf.id;
        insert pv;
        CheckStatusOfMasterCRFWithAllCRFs chk = new CheckStatusOfMasterCRFWithAllCRFs();
        chk.compareStatusAndSendEmail();
     }
     
     @isTest static void myUnitTest8() {
        myUnitTest1();
        crf.Status__c = 'Not Completed';
        Post_Surgaory_Summary__c pss = new Post_Surgaory_Summary__c();
        pss.TrialPatient__c = tp.Id;
        pss.Surgeon__c = con.Id;
        pss.Date_Of_Procedure__c = date.newInstance(2012, 7, 7);
        pss.Type_Of_Tumor__c = 'Single Discrete Mass';
        pss.Status__c = 'Accepted';
        pss.CRF__c = crf.id;
        insert pss;
        CheckStatusOfMasterCRFWithAllCRFs chk = new CheckStatusOfMasterCRFWithAllCRFs();
        chk.compareStatusAndSendEmail();
     }
     @isTest static void myUnitTest9() {
        myUnitTest1();
        crf.Status__c = 'Not Completed';
        On_Study_Pathology_Form__c ospObj = new On_Study_Pathology_Form__c();
        ospObj.TrialPatient__c = tp.Id;
        ospObj.Status__c = 'Accepted';
        ospObj.CRF__c = crf.Id;
        ospObj.Is_DCIS_Present__c='yes';
        ospObj.Is_invasive_tumor_present__c='yes';
        ospObj.Is_LCIS_Present__c='yes';
        ospObj.Does_the_patient_have_bilateral_breast_c__c = 'Yes';
        ospObj.Tumor_laterality__c = 'Left';
        insert ospObj;
        CheckStatusOfMasterCRFWithAllCRFs chk = new CheckStatusOfMasterCRFWithAllCRFs();
        chk.compareStatusAndSendEmail();
     }
     @isTest static void myUnitTest10() {
        myUnitTest1();
        crf.Status__c = 'Not Completed';
        Off_Study_Detail__c offStudy1 = new Off_Study_Detail__c();
        offStudy1.TrialPatient__c = tp.Id;
        offStudy1.CRF__c = crf.Id;
        offStudy1.Status__c = 'Accepted';
        insert offStudy1;
        CheckStatusOfMasterCRFWithAllCRFs chk = new CheckStatusOfMasterCRFWithAllCRFs();
        chk.compareStatusAndSendEmail();
     }
     @isTest static void myUnitTest11() {
        myUnitTest1();
        crf.Status__c = 'Not Completed';
        No_Longer_lost_to_Followup__c nlffc=new No_Longer_lost_to_Followup__c();
        nlffc.TrialPatient__c = tp.Id;
        nlffc.CRF__c = crf.Id;
        nlffc.Status__c = 'Accepted';
        insert nlffc;
        CheckStatusOfMasterCRFWithAllCRFs chk = new CheckStatusOfMasterCRFWithAllCRFs();
        chk.compareStatusAndSendEmail();
     }
     @isTest static void myUnitTest12() {
        myUnitTest1();
        crf.Status__c = 'Not Completed';
        Menopausal_Status_Detail__c msd1 = new Menopausal_Status_Detail__c(); // else part line 29
        msd1.TrialPatient__c = tp.Id;
        msd1.AgeVal__c = 'Age < 50';
        msd1.Date_of_Last_Menstrual_Period__c = date.newInstance(2012, 01, 05);
        msd1.On_Estrogen_Replacement__c = false;
        msd1.Bilateral_oophorectomy__c = false;
        msd1.Menopausal_Status__c = 'Above categories not applicable AND Age < 50';
        msd1.CRF_Id__c = crf.Id;
        msd1.Status__c = 'Accepted';
        insert msd1;
        CheckStatusOfMasterCRFWithAllCRFs chk = new CheckStatusOfMasterCRFWithAllCRFs();
        chk.compareStatusAndSendEmail();
     }
     @isTest static void myUnitTest13() {
        myUnitTest1();
        crf.Status__c = 'Not Completed';
        MammaPrintDetail__c mpd = new MammaPrintDetail__c();
        mpd.TrialPatient__c = tp.Id;
        //mpd.Tissue_Specimen_Detail__c = ts.Id;
        mpd.Report_Date__c = date.newInstance(2011, 7, 7);
        mpd.MammaPrint_Index__c = 0.5;
        mpd.MammaPrint_Risk__c = 'Low risk';
        mpd.Status__c = 'Approval Pending';
        mpd.CRF__c = crf.Id;
        insert mpd;
        CheckStatusOfMasterCRFWithAllCRFs chk = new CheckStatusOfMasterCRFWithAllCRFs();
        chk.compareStatusAndSendEmail();
     }
     @isTest static void myUnitTest14() {
        myUnitTest1();
        crf.Status__c = 'Not Completed';
        MRI_Volume__c mri = new MRI_Volume__c();
        mri.TrialPatient__c = tp.Id;
        mri.Time_Point__c = 'Pre-Treatment';
        mri.MRI_Scan_Date__c = date.newInstance(2012, 7, 7);
        mri.MRI_Volume_in_cm3__c = 2.3;
        mri.Longest_Diameter_Of_Index_Lesion_in_cm__c = 2.4;
        mri.CRF__c = crf.Id;
        mri.Status__c = 'Accepted';
        insert mri;    
        CheckStatusOfMasterCRFWithAllCRFs chk = new CheckStatusOfMasterCRFWithAllCRFs();
        chk.compareStatusAndSendEmail();
     }
     @isTest static void myUnitTest15() {
        myUnitTest1();
        crf.Status__c = 'Not Completed';
        Lab_and_Test__c lat = new Lab_and_Test__c();
        lat.TrialPatient__c = tp.Id;
        lat.Leukocytes__c = false;
        lat.Absolute_Neutrophil_Count_ANC__c = false;
        lat.Platelets__c = false;
        lat.Total_Bilirubin__c = false;
        lat.AST__c = false;
        lat.ALT__c = false;
        lat.Creatinine__c = false;
        lat.MUGA_Scan__c = false;
        lat.Cardiac_Echo__c = false;
        lat.Leukocytes_Institutional_Reference_Range__c = '12.0-34';
        lat.ANC_Industrial_Reference_Range__c = '12.0-34';
        lat.Platelets_Institutional_Reference_Range__c = '12.0-34';
        lat.Total_Bilirubin_Institutional_Reference__c = '12.0-34';
        lat.AST_Institutional_Reference_Range__c = '12.0-34';
        lat.ALT_Institutional_Reference_Range__c = '12.0-34';
        lat.Creatinine_Institutional_Reference_Range__c = '12.0-34';
        lat.Collection_Date__c = date.newInstance(2009, 8, 8);
        lat.MUGA_Scan_Date__c = date.newInstance(2009, 8, 8);
        lat.Collection_Date_for_Investigative_Agent__c = date.newInstance(2009, 8, 8);
        lat.Cardiac_Echo_Date__c = date.newInstance(2009, 8, 8);
        lat.Status__c = 'Approval Pending';
        lat.CRF__c = crf.Id;
        insert lat;
        CheckStatusOfMasterCRFWithAllCRFs chk = new CheckStatusOfMasterCRFWithAllCRFs();
        chk.compareStatusAndSendEmail();
     }
     @isTest static void myUnitTest16() {
        myUnitTest1();
        crf.Status__c = 'Not Completed';
        Lost_to_Follow_Up__c lffc1=new Lost_to_Follow_Up__c();
        lffc1.TrialPatient__c = tp.Id;
        lffc1.CRF__c = crf.Id;
        lffc1.Status__c = 'Accepted';
        insert lffc1;
        CheckStatusOfMasterCRFWithAllCRFs chk = new CheckStatusOfMasterCRFWithAllCRFs();
        chk.compareStatusAndSendEmail();
     }
     @isTest static void myUnitTest17() {
        myUnitTest1();
        crf.Status__c = 'Not Completed';
        Followup_Form__c followObject1 = new Followup_Form__c(); 
        followObject1.TrialPatient__c = tp.Id;
        followObject1.Survival_Status__c = 'Dead';
        followObject1.Start_Date__c = date.newInstance(2012, 7, 7);
        followObject1.End_Date__c = date.newInstance(2012, 8, 8);
        followObject1.patient_diagnosed_local_progression__c = true;
        followObject1.patient_diagnosed_distant_progression__c = false;
        followObject1.Menopausal_status__c = 'Menopaus';
        followObject1.CRF__c = crf.Id;
        followObject1.Status__c = 'Accepted';
        insert followObject1;
        CheckStatusOfMasterCRFWithAllCRFs chk = new CheckStatusOfMasterCRFWithAllCRFs();
        chk.compareStatusAndSendEmail();
     }
     
     @isTest static void myUnitTest18() {
        myUnitTest1();
        crf.Status__c = 'Not Completed';
        Randomization_Form__c rfc = new Randomization_Form__c();
        rfc.TrialPatient__c = tp.Id;
        rfc.Why_Patient_Not_Signed_Consent_Form__c = 'Patient found to be ineligible for the study';
        rfc.Status__c = 'Approval Not Required';
        rfc.CRF__c = crf.Id;
        insert rfc;
        CheckStatusOfMasterCRFWithAllCRFs chk = new CheckStatusOfMasterCRFWithAllCRFs();
        chk.compareStatusAndSendEmail();
     }
     @isTest static void myUnitTest19() {
        myUnitTest1();
        crf.Status__c = 'Not Completed';
        On_Study_Eligibility_Form__c osef = new On_Study_Eligibility_Form__c();
        osef.TrialPatient__c = tp.Id;
        osef.How_was_the_cancer_first_detected__c = 'Clinical exam'; 
        osef.Status__c = 'Approval Pending';
        osef.CRF__c = crf.Id;
        insert osef;
        CheckStatusOfMasterCRFWithAllCRFs chk = new CheckStatusOfMasterCRFWithAllCRFs();
        chk.compareStatusAndSendEmail();
     }
     @isTest static void myUnitTest20() {
        myUnitTest1();
        crf.Status__c = 'Not Completed';
        Chemo_Treatment__c chemo = new Chemo_Treatment__c();
        chemo.TrialPatient__c = tp.Id;
        chemo.Cycle_number__c = 2.0;
        chemo.Date_of_therapy__c = date.newInstance(2012, 6, 6);
        chemo.Status__c = 'Approval Pending';
        chemo.CRF__c = crf.Id;
        insert chemo;
        CheckStatusOfMasterCRFWithAllCRFs chk = new CheckStatusOfMasterCRFWithAllCRFs();
        chk.compareStatusAndSendEmail();
     }
     @isTest static void myUnitTest21() {
        myUnitTest1();
        crf.Status__c = 'Not Completed';
        Chemo_Summary_Form__c chemoSummaryForm = new Chemo_Summary_Form__c ();
        chemoSummaryForm.TrialPatient__c = tp.Id;
        chemoSummaryForm.Status__c = 'Accepted';
        chemoSummaryForm.CRF__c = crf.Id;
        insert chemoSummaryForm;
        CheckStatusOfMasterCRFWithAllCRFs chk = new CheckStatusOfMasterCRFWithAllCRFs();
        chk.compareStatusAndSendEmail();
     }
     @isTest static void myUnitTest22() {
        myUnitTest1();
        crf.Status__c = 'Not Completed';
        BloodSpecimenForm__c bsf = new BloodSpecimenForm__c();
        bsf.TrialPatient__c = tp.Id;
        bsf.Reason_all_samples_not_collected__c = 'Other';
        bsf.CollectionDate__c = system.today();
        bsf.Time_Point__c = 'Pre-treatment';
        bsf.Status__c = 'Accepted';
        bsf.CRF__c = crf.Id;
        insert bsf;
        CheckStatusOfMasterCRFWithAllCRFs chk = new CheckStatusOfMasterCRFWithAllCRFs();
        chk.compareStatusAndSendEmail();
     }
     @isTest static void myUnitTest23() {
        myUnitTest1();
        crf.Status__c = 'Not Completed';
        BaselineSymptomsForm__c bsf = new BaselineSymptomsForm__c();
        bsf.TrialPatient__c = tp.Id;
        bsf.Visit_Date__c = system.today();
        bsf.CRF__c = crf.Id;
        bsf.Status__c = 'Approval Pending';
        insert bsf;
        CheckStatusOfMasterCRFWithAllCRFs chk = new CheckStatusOfMasterCRFWithAllCRFs();
        chk.compareStatusAndSendEmail();
     }
     /*
     @isTest static void myUnitTest24() {
        myUnitTest1();
        
        CheckStatusOfMasterCRFWithAllCRFs chk = new CheckStatusOfMasterCRFWithAllCRFs();
        chk.compareStatusAndSendEmail();
     }
     */    
}