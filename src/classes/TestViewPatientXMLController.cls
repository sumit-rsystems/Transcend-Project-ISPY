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
private class TestViewPatientXMLController {

    @isTest static void myUnitTest1() {
       
         
        CRFMaster__c crfMaster = new CRFMaster__c(Object_Name__c ='Registration__c');
        insert crfMaster;
        XML_Configuration__c c1 = new XML_Configuration__c(Field_API_Name__c='First_Name__c',CRF_Type__c = crfMaster.Id,Object_API_Name__c = 'Patient_Custom__c');
        insert c1;
        XML_Configuration__c c2 = new XML_Configuration__c(Field_API_Name__c='Last_Name__c',CRF_Type__c = crfMaster.Id,Object_API_Name__c = 'Patient_Custom__c');
        insert c2;
        XML_Configuration__c c3 = new XML_Configuration__c(Field_API_Name__c='Race__c',CRF_Type__c = crfMaster.Id,Object_API_Name__c = 'Patient_Custom__c');
        insert c3;
        XML_Configuration__c c4 = new XML_Configuration__c(Field_API_Name__c='Ethnicity__c',CRF_Type__c = crfMaster.Id,Object_API_Name__c = 'Patient_Custom__c');
        insert c4;
        
        Trial__c t = new Trial__c(Name='Test Trial',Start_Date__c=System.today());
        insert t;
        Account a = new Account(Name='Test Account');
        insert a;
        Patient_Custom__c p = new Patient_Custom__c(Name='Test Patient',Institution__c=a.id,Last_Name__c='Last Name',Birthdate__c=System.today(),Race__c='Asian;White;Black or African American;American Indian or Alaska Native;Asian;Native Hawaiian or Other Pacific Islander;xyz',Gender__c='Male',Ethnicity__c='Hispanic or Latino');
        insert p;
        
        //Trial__c tri = new Trial__c();
        //tri.Name = 'test';
        //insert tri;
        
        
        
        Site__c site1 = new Site__c();
        site1.Name = 'test site1';
        site1.Type__c = 'test type';
        site1.Institute__c = a.Id;
        insert site1;
        
        TrialPatient__c tp = new TrialPatient__c();
        tp.Patient_Id__c = p.Id;
        tp.Trial_Id__c = t.Id;
        tp.Site__c=site1.Id;
        insert tp;
        
       
        Test.startTest();
        
        ViewPatientXMLController vp = new ViewPatientXMLController();
        vp.trialPatientIdSelected = tp.Id;
        vp.trial=t.Id;
        vp.institution=a.Id;
        vp.site = site1.Id;
        vp.sortExpression='Site__c';
        //vp.sortExpression='Site__c';
        vp.loadInstitution();
        vp.loadTrial();
        vp.loadSite();
        vp.loadInstitute();
        Boolean b1 = vp.hasNext;
        Boolean b2 = vp.hasPrevious;
        vp.last();
        vp.first();
        vp.next();
        vp.previous();
        vp.doSort();
        vp.getSortDirection();
        vp.setSortDirection('ASC');
        vp.setSortDirection('DESC');
        vp.submitTrialSummaryNote();
        Test.stopTest();
    }
    @isTest static void myUnitTest2() {
       
         
        CRFMaster__c crfMaster = new CRFMaster__c(Object_Name__c ='Registration__c');
        insert crfMaster;
        XML_Configuration__c c1 = new XML_Configuration__c(Field_API_Name__c='First_Name__c',CRF_Type__c = crfMaster.Id,Object_API_Name__c = 'Patient_Custom__c');
        insert c1;
        XML_Configuration__c c2 = new XML_Configuration__c(Field_API_Name__c='Last_Name__c',CRF_Type__c = crfMaster.Id,Object_API_Name__c = 'Patient_Custom__c');
        insert c2;
        XML_Configuration__c c3 = new XML_Configuration__c(Field_API_Name__c='Race__c',CRF_Type__c = crfMaster.Id,Object_API_Name__c = 'Patient_Custom__c');
        insert c3;
        XML_Configuration__c c4 = new XML_Configuration__c(Field_API_Name__c='Ethnicity__c',CRF_Type__c = crfMaster.Id,Object_API_Name__c = 'Patient_Custom__c');
        insert c4;
        
        Trial__c t = new Trial__c(Name='Test Trial',Start_Date__c=System.today());
        insert t;
        Account a = new Account(Name='Test Account');
        insert a;
        Patient_Custom__c p = new Patient_Custom__c(Name='Test Patient',Institution__c=a.id,Last_Name__c='Last Name',Birthdate__c=System.today(),Race__c='Asian;White;Black or African American;American Indian or Alaska Native;Asian;Native Hawaiian or Other Pacific Islander;xyz',Gender__c='Male',Ethnicity__c='Hispanic or Latino');
        insert p;
        
        //Trial__c tri = new Trial__c();
        //tri.Name = 'test';
        //insert tri;
        
        
        
        Site__c site1 = new Site__c();
        site1.Name = 'test site1';
        site1.Type__c = 'test type';
        site1.Institute__c = a.Id;
        insert site1;
        
        TrialPatient__c tp = new TrialPatient__c();
        tp.Patient_Id__c = p.Id;
        tp.Trial_Id__c = t.Id;
        tp.Site__c=site1.Id;
        insert tp;
        
        
        ArmPatient__c arm = new ArmPatient__c();
        arm.assignedToPatient__c=True;
        arm.TrialPatient__c = tp.Id;
        insert arm;
        
        AE_Detail__c ae = new AE_Detail__c();
        ae.TrialPatient__c=tp.Id;
        insert ae;
        Toxicity__c tox = new Toxicity__c();
        tox.AE_Detail__c = ae.Id;
        tox.TrialPatient__c=tp.id;
        tox.Grade__c='1-xxx';
        tox.Attribution__c='1 - Unrelated';
        tox.Onset_Date__c=System.today();
        tox.Was_event_life_threatning__c=true;
        tox.Did_event_result_in_death__c=true;
        tox.Did_event_required_hospitalization__c=true;
        tox.Did_the_investigator_find_event_unusual__c=true;
        tox.Result_conginental_abnormality_defect__c=true;
        tox.Result_persistent_significant_disability__c=true;
        insert tox;
        
        //Select id,Tumor_laterality__c,Is_DCIS_Present__c,Is_LCIS_Present__c,Is_invasive_tumor_present__c,HER2_neu_Marker_Status_Snomed__c,(
        //select Estrogen_Receptor_Status__c,Progesterone_Receptor_Status__c,HER2_neu_Marker__c from Receptors__r) from On_Study_Pathology_Form__c where TrialPatient__c=:trialPatientIdSelected
        
        On_Study_Pathology_Form__c patho = new On_Study_Pathology_Form__c();
        patho.TrialPatient__c=tp.Id;
        patho.Tumor_laterality__c='Left';
        patho.Does_the_patient_have_bilateral_breast_c__c='Yes';
        insert patho;
        
        Receptors__c receptor = new Receptors__c();
        receptor.On_Study_Pathology_Form__c=patho.Id;
        insert receptor;
        
        //Select id,pcr__c,Date_Of_Procedure__c,Is_DCIS_Present__c, Is_invasive_tumor_present__c, Is_LCIS_Present__c,Lymph_node_dissection_done__c,
        //(select Estrogen_Receptor_Status__c,Progesterone_Receptor_Status__c,HER2_neu_Marker__c from Receptors__r),
        //(Select Id,Adjudicated_Stage__c from Staging_Details__r) 
        //from Post_Surgaory_Summary__c where TrialPatient__c =:trialPatientIdSelected
        
        Post_Surgaory_Summary__c postSurgery = new Post_Surgaory_Summary__c();
        postSurgery.TrialPatient__c=tp.Id;
        insert postSurgery;
        
        Receptors__c receptor2 = new Receptors__c();
        receptor2.Post_Surgery_Summary__c=postSurgery.Id;
        insert receptor2;
        
        Staging_Detail__c stage = new Staging_Detail__c();
        stage.Post_Surgery_Summary__c=postSurgery.Id;
        stage.Adjudicated_Stage__c='sss';
        insert stage;
        
        Test.startTest();
        ViewPatientXMLController.TrialPatientWrapper w = new ViewPatientXMLController.TrialPatientWrapper(tp);
        ViewPatientXMLController vp = new ViewPatientXMLController();
        vp.trialPatientIdSelected = tp.Id;
        vp.trial=t.Id;
        vp.institution=a.Id;
        vp.site = site1.Id;
        vp.sortExpression='Site__c';
        //vp.sortExpression='Site__c';
        vp.loadInstitution();
        vp.loadTrial();
        vp.loadSite();
        vp.loadInstitute();
        Boolean b1 = vp.hasNext;
        Boolean b2 = vp.hasPrevious;
        vp.last();
        vp.first();
        vp.next();
        vp.previous();
        vp.doSort();
        vp.getSortDirection();
        vp.setSortDirection('ASC');
        vp.setSortDirection('DESC');
        vp.submitTrialSummaryNote();
        vp.populateFailedRegistration(tp.id,p.Id,t.id, site1.Id,null, 'sss', 'saa', 'saa','asas', 'sasa','1212', '23123');
        Test.stopTest();
    }
}