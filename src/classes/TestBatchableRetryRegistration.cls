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
private class TestBatchableRetryRegistration {

    @isTest public static void test1(){
        BatchableRetryRegistration job = new BatchableRetryRegistration();
        //Test.startTest();
        Trial__c t = new Trial__c(Name='Test Trial',Start_Date__c=System.today());
        insert t;
        Account a = new Account(Name='Test Account');
        insert a;
        Patient_Custom__c p = new Patient_Custom__c(Name='Test Patient',Institution__c=a.id,Last_Name__c='Last Name',Birthdate__c=System.today(),Race__c='xyz;White;Black or African American;American Indian or Alaska Native;Asian;Native Hawaiian or Other Pacific Islander',Gender__c='Male',Ethnicity__c='Hispanic or Latino');
        insert p;
        
        
        Trial__c tri = new Trial__c();
        tri.Name = 'test';
        insert tri;
        
        TrialPatient__c tp = new TrialPatient__c();
        tp.Patient_Id__c = p.Id;
        tp.Trial_Id__c = tri.Id;
        insert tp;
        
        
        Site__c site1 = new Site__c();
        site1.Name = 'test site1';
        site1.Type__c = 'test type';
        site1.Institute__c = a.Id;
        insert site1;
        
        Registration__c reg = new Registration__c(); 
        reg.Patient__c = p.Id;
        reg.Registration_Date__c = system.today();
        reg.Trial__c = t.Id;
        reg.Institution__c = a.Id;
        reg.Site__c = site1.Id;
        reg.IRB_Approval_Date__c = system.today();
        reg.HIPPA_Consent_Date__c = system.today();
        reg.Screening_Informed_Consent_Date__c = system.today();
        reg.Status__c = 'Accepted';
        reg.Effective_Time__c = system.now();
        reg.ISPY2_Subject_Id__c = ''+123;
        insert reg;
        
        Failed_Registration__c fr = new Failed_Registration__c(CRF_Id__c=reg.Id,CRF_Name__c='Patient Registration Form',Trial__c=t.id,Patient__c=p.id,Retry__c=true,Last_Status__c='Failure');
        insert fr;
        
        CRFMaster__c crfmst = new CRFMaster__c();
        crfmst.Object_Name__c ='Registration__c';
        insert crfmst;
        
        XML_Configuration__c xmlConfig = new XML_Configuration__c();
        xmlConfig.Field_API_Name__c ='First_Name__c';
        xmlConfig.CRF_Type__c = crfmst.Id;
        xmlConfig.Object_API_Name__c = 'Patient_Custom__c';
        insert xmlConfig;
        
        XML_Configuration__c xmlConfig2 = new XML_Configuration__c();
        xmlConfig2.Field_API_Name__c ='Last_Name__c';
        xmlConfig2.CRF_Type__c = crfmst.Id;
        xmlConfig2.Object_API_Name__c = 'Patient_Custom__c';
        insert xmlConfig2;
        
        XML_Configuration__c xmlConfig3 = new XML_Configuration__c();
        xmlConfig3.Field_API_Name__c ='SSN__c';
        xmlConfig3.CRF_Type__c = crfmst.Id;
        xmlConfig3.Object_API_Name__c = 'Patient_Custom__c';
        insert xmlConfig3;
        
        XML_Configuration__c xmlConfig4 = new XML_Configuration__c();
        xmlConfig4.Field_API_Name__c ='Race__c';
        xmlConfig4.CRF_Type__c = crfmst.Id;
        xmlConfig4.Object_API_Name__c = 'Patient_Custom__c';
        insert xmlConfig4;
        
        XML_Configuration__c xmlConfig5 = new XML_Configuration__c();
        xmlConfig5.Field_API_Name__c ='Ethnicity__c';
        xmlConfig5.CRF_Type__c = crfmst.Id;
        xmlConfig5.Object_API_Name__c = 'Patient_Custom__c';
        insert xmlConfig5;
        
        XML_Configuration__c xmlConfig6 = new XML_Configuration__c();
        xmlConfig6.Field_API_Name__c ='ISPY2_Subject_Id__c';
        xmlConfig6.CRF_Type__c = crfmst.Id;
        xmlConfig6.Object_API_Name__c = 'Registration__c';
        insert xmlConfig6;
        
        //Select p.Value__c,p.snomed_Code_Name__c, p.Code_Master__r.Name, p.Code_Master__c, p.Code_System__c, p.Code_System_Version__c From Pre_Registration_Snomed_Codes__c p where Patient__c =:patientId and  (Code_Master__r.Name ='Ethn' or Code_Master__r.Name ='Race'
        
        CRF__c crf = new CRF__c();
        crf.Trial__c= tri.Id;
        crf.TrialPatient__c = tp.Id;
        crf.Site__c = site1.Id;
        crf.Patient__c = p.Id;
        crf.Detail__c ='Details';
        insert crf;
        
        CRFMaster__c crfMaster = new CRFMaster__c(Object_Name__c ='TissueSpecimenDetail__c');
        insert crfMaster;
        
        XML_Configuration__c c1 = new XML_Configuration__c(Field_API_Name__c='First_Name__c',CRF_Type__c = crfMaster.Id,Object_API_Name__c = 'Patient_Custom__c');
        insert c1;
        XML_Configuration__c c2 = new XML_Configuration__c(Field_API_Name__c='Last_Name__c',CRF_Type__c = crfMaster.Id,Object_API_Name__c = 'Patient_Custom__c');
        insert c2;
        XML_Configuration__c c3 = new XML_Configuration__c(Field_API_Name__c='Race__c',CRF_Type__c = crfMaster.Id,Object_API_Name__c = 'Patient_Custom__c');
        insert c3;
        XML_Configuration__c c4 = new XML_Configuration__c(Field_API_Name__c='Ethnicity__c',CRF_Type__c = crfMaster.Id,Object_API_Name__c = 'Patient_Custom__c');
        insert c4;
        
        TissueSpecimenDetail__c tissue = new TissueSpecimenDetail__c();
        tissue.TrialPatient__c=tp.Id;
        tissue.Status__c='Approval Not Required';
        //tissue.RecordTypeId='';
        tissue.Patient__c = p.Id;
        tissue.NumberOfSamplesCollected__c =1;
        tissue.Effective_Time__c = System.now();
        tissue.CRFId__c = crf.Id;
        tissue.ProcedureDate__c=System.today();
        tissue.Time_Point__c='Pre-treatment';
        tissue.Guidance_Method_s__c='Ultrasound';
        tissue.PatientConsentedOutsideStudy__c=True;
        tissue.PatientConsentedStudy__c=True;
        insert tissue;
        Failed_Registration__c fr2 = new Failed_Registration__c(CRF_Id__c=tissue.Id,CRF_Name__c='Tissue Specimen Form',Trial__c=t.id,Patient__c=p.id,Retry__c=true,Last_Status__c='Failure');
        insert fr2;
        
        Failed_Registration__c fr3 = new Failed_Registration__c(CRF_Id__c=tissue.Id,CRF_Name__c='Tissue Specimen Form',IsConsent__c=True,Trial__c=t.id,Patient__c=p.id,Retry__c=true,Last_Status__c='Failure');
        insert fr3;
        
        CRFMaster__c crfMaster2 = new CRFMaster__c(Object_Name__c ='BloodSpecimenForm__c');
        insert crfMaster2;
        
        XML_Configuration__c c11 = new XML_Configuration__c(Field_API_Name__c='First_Name__c',CRF_Type__c = crfMaster2.Id,Object_API_Name__c = 'Patient_Custom__c');
        insert c11;
        XML_Configuration__c c12 = new XML_Configuration__c(Field_API_Name__c='Last_Name__c',CRF_Type__c = crfMaster2.Id,Object_API_Name__c = 'Patient_Custom__c');
        insert c12;
        XML_Configuration__c c13 = new XML_Configuration__c(Field_API_Name__c='Race__c',CRF_Type__c = crfMaster2.Id,Object_API_Name__c = 'Patient_Custom__c');
        insert c13;
        XML_Configuration__c c14 = new XML_Configuration__c(Field_API_Name__c='Ethnicity__c',CRF_Type__c = crfMaster2.Id,Object_API_Name__c = 'Patient_Custom__c');
        insert c14;
        
        BloodSpecimenForm__c blood= new BloodSpecimenForm__c ();
        blood.TrialPatient__c=tp.Id;
        blood.Status__c='Approval Not Required';
        //tissue.RecordTypeId='';
        //blood.Patient__c = p.Id;
        //blood.NumberOfSamplesCollected__c =1;
        blood.Effective_Time__c = System.now();
        blood.CRF__c = crf.Id;
        blood.CollectionDate__c=System.today();
        blood.Time_Point__c='Pre-treatment';
        //blood.Guidance_Method_s__c='Ultrasound';
        blood.Consented_to_use_specimen_study__c=True;
        blood.Contented_specimen_outside_study__c=True;
        insert blood;
        Failed_Registration__c fr4 = new Failed_Registration__c(CRF_Id__c=blood.Id,CRF_Name__c='Blood Specimen Form',Trial__c=t.id,Patient__c=p.id,Retry__c=true,Last_Status__c='Failure');
        insert fr4;
        
        Failed_Registration__c fr5 = new Failed_Registration__c(CRF_Id__c=blood.Id,CRF_Name__c='Blood Specimen Form',IsConsent__c=True,Trial__c=t.id,Patient__c=p.id,Retry__c=true,Last_Status__c='Failure');
        insert fr5;
        
        CRFMaster__c crfMaster3 = new CRFMaster__c(Object_Name__c ='AE_Detail__c');
        insert crfMaster3;
        
        XML_Configuration__c c21 = new XML_Configuration__c(Field_API_Name__c='First_Name__c',CRF_Type__c = crfMaster3.Id,Object_API_Name__c = 'Patient_Custom__c');
        insert c21;
        XML_Configuration__c c22 = new XML_Configuration__c(Field_API_Name__c='Last_Name__c',CRF_Type__c = crfMaster3.Id,Object_API_Name__c = 'Patient_Custom__c');
        insert c22;
        XML_Configuration__c c23 = new XML_Configuration__c(Field_API_Name__c='Race__c',CRF_Type__c = crfMaster3.Id,Object_API_Name__c = 'Patient_Custom__c');
        insert c23;
        XML_Configuration__c c24 = new XML_Configuration__c(Field_API_Name__c='Ethnicity__c',CRF_Type__c = crfMaster3.Id,Object_API_Name__c = 'Patient_Custom__c');
        insert c24;
        
        AE_Detail__c ae = new AE_Detail__c();
        ae.CRF__c=crf.Id;
        ae.Effective_Time__c=System.now();
        ae.TrialPatient__c=tp.Id;
        ae.CompletedDate__c=System.today();
        insert ae;
        
        Toxicity__c tx = new Toxicity__c();
        tx.AE_Detail__c = ae.Id;
        tx.AE_End_Date__c=System.today();
        tx.Effective_Time__c=System.now();
        tx.Onset_Date__c=System.today();
        insert tx;
        
        Failed_Registration__c fr6 = new Failed_Registration__c(CRF_Id__c=ae.Id,CRF_Name__c='AE Form',IsConsent__c=True,Trial__c=t.id,Patient__c=p.id,Retry__c=true,Last_Status__c='Failure');
        insert fr6;
        
        job.query='Select Trial__c, Retry__c, Patient__c, Number_of_Retry__c, Name, Last_Success_Message__c, Last_Status__c, Last_Run_DateTime__c, Last_Error_Message__c, Id From Failed_Registration__c where Retry__c=true limit 1';
        //Test.startTest();
        
        //job.retryRegistration(fr.Id, t.Id, p.id, reg.Id);
        //job.retryTissueSpecimenSubmission(fr2.Id, t.Id, p.id, tissue.Id);
        //job.retryTissueSpecimenConsentSubmission(fr3.Id, t.Id, p.id, tissue.Id);
        //job.retryBloodSpecimenSubmission(fr4.Id, t.Id, p.id, blood.Id);
        //job.retryBloodSpecimenConsentSubmission(fr5.Id, t.Id, p.id, blood.Id);
        //job.retryAdverseEventSubmission(fr6.Id, t.Id, p.id, ae.Id);
        
        Test.startTest();
        job.processFR(fr);
        job.processFR(fr2);
        job.processFR(fr3);
        job.processFR(fr4);
        job.processFR(fr5);
        job.processFR(fr6);
        
        
        ID batchProecssedId = Database.executeBatch(job,1);
        Test.stopTest();
        
        //ID batchProecssedId = Database.executeBatch(job,1);
        //Test.stopTest();
    }
    
    @isTest public static void test2(){
        BatchableRetryRegistration job = new BatchableRetryRegistration();
        //Test.startTest();
        Trial__c t = new Trial__c(Name='Test Trial',Start_Date__c=System.today());
        insert t;
        Account a = new Account(Name='Test Account');
        insert a;
        Patient_Custom__c p = new Patient_Custom__c(Name='Test Patient',Institution__c=a.id,Last_Name__c='Last Name',Birthdate__c=System.today(),Race__c='White;Black or African American;American Indian or Alaska Native;Asian;Native Hawaiian or Other Pacific Islander;xyz',Gender__c='Female',Ethnicity__c='Not Hispanic or Latino');
        insert p;
        
        
        Trial__c tri = new Trial__c();
        tri.Name = 'test';
        insert tri;
        
        TrialPatient__c tp = new TrialPatient__c();
        tp.Patient_Id__c = p.Id;
        tp.Trial_Id__c = tri.Id;
        insert tp;
        
        
        Site__c site1 = new Site__c();
        site1.Name = 'test site1';
        site1.Type__c = 'test type';
        site1.Institute__c = a.Id;
        insert site1;
        
        Registration__c reg = new Registration__c(); 
        reg.Patient__c = p.Id;
        reg.Registration_Date__c = system.today();
        reg.Trial__c = t.Id;
        reg.Institution__c = a.Id;
        reg.Site__c = site1.Id;
        reg.IRB_Approval_Date__c = system.today();
        reg.HIPPA_Consent_Date__c = system.today();
        reg.Screening_Informed_Consent_Date__c = system.today();
        reg.Status__c = 'Accepted';
        reg.Effective_Time__c = system.now();
        reg.ISPY2_Subject_Id__c = ''+123;
        insert reg;
        
        Failed_Registration__c fr = new Failed_Registration__c(CRF_Id__c=reg.Id,CRF_Name__c='Patient Registration Form',Trial__c=t.id,Patient__c=p.id,Retry__c=true,Last_Status__c='Failure');
        insert fr;
        
        CRFMaster__c crfmst = new CRFMaster__c();
        crfmst.Object_Name__c ='Registration__c';
        insert crfmst;
        
        XML_Configuration__c xmlConfig = new XML_Configuration__c();
        xmlConfig.Field_API_Name__c ='First_Name__c';
        xmlConfig.CRF_Type__c = crfmst.Id;
        xmlConfig.Object_API_Name__c = 'Patient_Custom__c';
        insert xmlConfig;
        
        XML_Configuration__c xmlConfig2 = new XML_Configuration__c();
        xmlConfig2.Field_API_Name__c ='Last_Name__c';
        xmlConfig2.CRF_Type__c = crfmst.Id;
        xmlConfig2.Object_API_Name__c = 'Patient_Custom__c';
        insert xmlConfig2;
        
        XML_Configuration__c xmlConfig3 = new XML_Configuration__c();
        xmlConfig3.Field_API_Name__c ='SSN__c';
        xmlConfig3.CRF_Type__c = crfmst.Id;
        xmlConfig3.Object_API_Name__c = 'Patient_Custom__c';
        insert xmlConfig3;
        
        XML_Configuration__c xmlConfig4 = new XML_Configuration__c();
        xmlConfig4.Field_API_Name__c ='Race__c';
        xmlConfig4.CRF_Type__c = crfmst.Id;
        xmlConfig4.Object_API_Name__c = 'Patient_Custom__c';
        insert xmlConfig4;
        
        XML_Configuration__c xmlConfig5 = new XML_Configuration__c();
        xmlConfig5.Field_API_Name__c ='Ethnicity__c';
        xmlConfig5.CRF_Type__c = crfmst.Id;
        xmlConfig5.Object_API_Name__c = 'Patient_Custom__c';
        insert xmlConfig5;
        
        XML_Configuration__c xmlConfig6 = new XML_Configuration__c();
        xmlConfig6.Field_API_Name__c ='ISPY2_Subject_Id__c';
        xmlConfig6.CRF_Type__c = crfmst.Id;
        xmlConfig6.Object_API_Name__c = 'Registration__c';
        insert xmlConfig6;
        
        //Select p.Value__c,p.snomed_Code_Name__c, p.Code_Master__r.Name, p.Code_Master__c, p.Code_System__c, p.Code_System_Version__c From Pre_Registration_Snomed_Codes__c p where Patient__c =:patientId and  (Code_Master__r.Name ='Ethn' or Code_Master__r.Name ='Race'
        
        CRF__c crf = new CRF__c();
        crf.Trial__c= tri.Id;
        crf.TrialPatient__c = tp.Id;
        crf.Site__c = site1.Id;
        crf.Patient__c = p.Id;
        crf.Detail__c ='Details';
        insert crf;
        
        CRFMaster__c crfMaster = new CRFMaster__c(Object_Name__c ='TissueSpecimenDetail__c');
        insert crfMaster;
        
        XML_Configuration__c c1 = new XML_Configuration__c(Field_API_Name__c='First_Name__c',CRF_Type__c = crfMaster.Id,Object_API_Name__c = 'Patient_Custom__c');
        insert c1;
        XML_Configuration__c c2 = new XML_Configuration__c(Field_API_Name__c='Last_Name__c',CRF_Type__c = crfMaster.Id,Object_API_Name__c = 'Patient_Custom__c');
        insert c2;
        XML_Configuration__c c3 = new XML_Configuration__c(Field_API_Name__c='Race__c',CRF_Type__c = crfMaster.Id,Object_API_Name__c = 'Patient_Custom__c');
        insert c3;
        XML_Configuration__c c4 = new XML_Configuration__c(Field_API_Name__c='Ethnicity__c',CRF_Type__c = crfMaster.Id,Object_API_Name__c = 'Patient_Custom__c');
        insert c4;
        
        TissueSpecimenDetail__c tissue = new TissueSpecimenDetail__c();
        tissue.TrialPatient__c=tp.Id;
        tissue.Status__c='Approval Not Required';
        //tissue.RecordTypeId='';
        tissue.Patient__c = p.Id;
        tissue.NumberOfSamplesCollected__c =1;
        tissue.Effective_Time__c = System.now();
        tissue.CRFId__c = crf.Id;
        tissue.ProcedureDate__c=System.today();
        tissue.Time_Point__c='Pre-treatment';
        tissue.Guidance_Method_s__c='Ultrasound;MRI;Stereotactic;Mammography;Palpation;';
        tissue.PatientConsentedOutsideStudy__c=False;
        tissue.PatientConsentedStudy__c=False;
        insert tissue;
        
        TissueSpecimenDetail__c tissue2 = new TissueSpecimenDetail__c();
        tissue2.TrialPatient__c=tp.Id;
        tissue2.Status__c='Approval Not Required';
        //tissue.RecordTypeId='';
        tissue2.Patient__c = p.Id;
        tissue2.NumberOfSamplesCollected__c =1;
        tissue2.Effective_Time__c = System.now();
        tissue2.CRFId__c = crf.Id;
        tissue2.ProcedureDate__c=System.today();
        tissue2.Time_Point__c='Pre-treatment';
        tissue2.Guidance_Method_s__c='Ultrasound;MRI;Stereotactic;Mammography;Palpation;';
        tissue2.PatientConsentedOutsideStudy__c=True;
        tissue2.PatientConsentedStudy__c=True;
        insert tissue2;
        
        
        
        Failed_Registration__c fr2 = new Failed_Registration__c(CRF_Id__c=tissue2.Id,CRF_Name__c='Tissue Specimen Form',Trial__c=t.id,Patient__c=p.id,Retry__c=true,Last_Status__c='Failure');
        insert fr2;
        
        Failed_Registration__c fr3 = new Failed_Registration__c(CRF_Id__c=tissue2.Id,CRF_Name__c='Tissue Specimen Form',IsConsent__c=True,Trial__c=t.id,Patient__c=p.id,Retry__c=true,Last_Status__c='Failure');
        insert fr3;
        
        CRFMaster__c crfMaster2 = new CRFMaster__c(Object_Name__c ='BloodSpecimenForm__c');
        insert crfMaster2;
        
        XML_Configuration__c c11 = new XML_Configuration__c(Field_API_Name__c='First_Name__c',CRF_Type__c = crfMaster2.Id,Object_API_Name__c = 'Patient_Custom__c');
        insert c11;
        XML_Configuration__c c12 = new XML_Configuration__c(Field_API_Name__c='Last_Name__c',CRF_Type__c = crfMaster2.Id,Object_API_Name__c = 'Patient_Custom__c');
        insert c12;
        XML_Configuration__c c13 = new XML_Configuration__c(Field_API_Name__c='Race__c',CRF_Type__c = crfMaster2.Id,Object_API_Name__c = 'Patient_Custom__c');
        insert c13;
        XML_Configuration__c c14 = new XML_Configuration__c(Field_API_Name__c='Ethnicity__c',CRF_Type__c = crfMaster2.Id,Object_API_Name__c = 'Patient_Custom__c');
        insert c14;
        
        BloodSpecimenForm__c blood= new BloodSpecimenForm__c ();
        blood.TrialPatient__c=tp.Id;
        blood.Status__c='Approval Not Required';
        //tissue.RecordTypeId='';
        //blood.Patient__c = p.Id;
        //blood.NumberOfSamplesCollected__c =1;
        blood.Effective_Time__c = System.now();
        blood.CRF__c = crf.Id;
        blood.CollectionDate__c=System.today();
        blood.Time_Point__c='Pre-treatment';
        //blood.Guidance_Method_s__c='Ultrasound';
        blood.Consented_to_use_specimen_study__c=True;
        blood.Contented_specimen_outside_study__c=True;
        insert blood;
        
        BloodSpecimenForm__c blood2= new BloodSpecimenForm__c ();
        blood2.TrialPatient__c=tp.Id;
        blood2.Status__c='Approval Not Required';
        //tissue.RecordTypeId='';
        //blood.Patient__c = p.Id;
        //blood.NumberOfSamplesCollected__c =1;
        blood2.Effective_Time__c = System.now();
        blood2.CRF__c = crf.Id;
        blood2.CollectionDate__c=System.today();
        blood2.Time_Point__c='Pre-treatment';
        //blood.Guidance_Method_s__c='Ultrasound';
        blood2.Consented_to_use_specimen_study__c=True;
        blood2.Contented_specimen_outside_study__c=True;
        insert blood2;
        
        Failed_Registration__c fr4 = new Failed_Registration__c(CRF_Id__c=blood2.Id,CRF_Name__c='Blood Specimen Form',Trial__c=t.id,Patient__c=p.id,Retry__c=true,Last_Status__c='Failure');
        insert fr4;
        
        Failed_Registration__c fr5 = new Failed_Registration__c(CRF_Id__c=blood2.Id,CRF_Name__c='Blood Specimen Form',IsConsent__c=True,Trial__c=t.id,Patient__c=p.id,Retry__c=true,Last_Status__c='Failure');
        insert fr5;
        
        CRFMaster__c crfMaster3 = new CRFMaster__c(Object_Name__c ='AE_Detail__c');
        insert crfMaster3;
        
        XML_Configuration__c c21 = new XML_Configuration__c(Field_API_Name__c='First_Name__c',CRF_Type__c = crfMaster3.Id,Object_API_Name__c = 'Patient_Custom__c');
        insert c21;
        XML_Configuration__c c22 = new XML_Configuration__c(Field_API_Name__c='Last_Name__c',CRF_Type__c = crfMaster3.Id,Object_API_Name__c = 'Patient_Custom__c');
        insert c22;
        XML_Configuration__c c23 = new XML_Configuration__c(Field_API_Name__c='Race__c',CRF_Type__c = crfMaster3.Id,Object_API_Name__c = 'Patient_Custom__c');
        insert c23;
        XML_Configuration__c c24 = new XML_Configuration__c(Field_API_Name__c='Ethnicity__c',CRF_Type__c = crfMaster3.Id,Object_API_Name__c = 'Patient_Custom__c');
        insert c24;
        
        AE_Detail__c ae = new AE_Detail__c();
        ae.CRF__c=crf.Id;
        ae.Effective_Time__c=System.now();
        ae.TrialPatient__c=tp.Id;
        ae.CompletedDate__c=System.today();
        insert ae;
        
        Toxicity__c tx = new Toxicity__c();
        tx.AE_Detail__c = ae.Id;
        tx.AE_End_Date__c=System.today();
        tx.Effective_Time__c=System.now();
        tx.Onset_Date__c=System.today();
        insert tx;
        
        Failed_Registration__c fr6 = new Failed_Registration__c(CRF_Id__c=ae.Id,CRF_Name__c='AE Form',IsConsent__c=True,Trial__c=t.id,Patient__c=p.id,Retry__c=true,Last_Status__c='Failure');
        insert fr6;
        
        job.query='Select CRF_Id__c,CRF_Name__c,IsConsent__c, Trial__c, Retry__c, Patient__c, Number_of_Retry__c, Name, Last_Success_Message__c, Last_Status__c, Last_Run_DateTime__c, Last_Error_Message__c, Id From Failed_Registration__c where Retry__c=true limit 10';
        Test.startTest();
        job.processFR(fr);
        job.processFR(fr2);
        job.processFR(fr3);
        job.processFR(fr4);
        job.processFR(fr5);
        job.processFR(fr6);
        
        
        ID batchProecssedId = Database.executeBatch(job,1);
        Test.stopTest();
    }
    
    @isTest public static void test3(){
        BatchableRetryRegistration job = new BatchableRetryRegistration();
        //Test.startTest();
        Trial__c t = new Trial__c(Name='Test Trial',Start_Date__c=System.today());
        insert t;
        Account a = new Account(Name='Test Account');
        insert a;
        Patient_Custom__c p = new Patient_Custom__c(Name='Test Patient',Institution__c=a.id,Last_Name__c='Last Name',Birthdate__c=System.today(),Race__c='Black or African American;American Indian or Alaska Native;Asian;Native Hawaiian or Other Pacific Islander;xyz;White',Gender__c='Female',Ethnicity__c='Not Hispanic or Latino');
        insert p;
        
        
        Trial__c tri = new Trial__c();
        tri.Name = 'test';
        insert tri;
        
        TrialPatient__c tp = new TrialPatient__c();
        tp.Patient_Id__c = p.Id;
        tp.Trial_Id__c = tri.Id;
        insert tp;
        
        
        Site__c site1 = new Site__c();
        site1.Name = 'test site1';
        site1.Type__c = 'test type';
        site1.Institute__c = a.Id;
        insert site1;
        
        Registration__c reg = new Registration__c(); 
        reg.Patient__c = p.Id;
        reg.Registration_Date__c = system.today();
        reg.Trial__c = t.Id;
        reg.Institution__c = a.Id;
        reg.Site__c = site1.Id;
        reg.IRB_Approval_Date__c = system.today();
        reg.HIPPA_Consent_Date__c = system.today();
        reg.Screening_Informed_Consent_Date__c = system.today();
        reg.Status__c = 'Accepted';
        reg.Effective_Time__c = system.now();
        reg.ISPY2_Subject_Id__c = ''+123;
        insert reg;
        
        Failed_Registration__c fr = new Failed_Registration__c(CRF_Id__c=reg.Id,CRF_Name__c='Patient Registration Form',Trial__c=t.id,Patient__c=p.id,Retry__c=true,Last_Status__c='Failure');
        insert fr;
        
        CRFMaster__c crfmst = new CRFMaster__c();
        crfmst.Object_Name__c ='Registration__c';
        insert crfmst;
        
        XML_Configuration__c xmlConfig = new XML_Configuration__c();
        xmlConfig.Field_API_Name__c ='First_Name__c';
        xmlConfig.CRF_Type__c = crfmst.Id;
        xmlConfig.Object_API_Name__c = 'Patient_Custom__c';
        insert xmlConfig;
        
        XML_Configuration__c xmlConfig2 = new XML_Configuration__c();
        xmlConfig2.Field_API_Name__c ='Last_Name__c';
        xmlConfig2.CRF_Type__c = crfmst.Id;
        xmlConfig2.Object_API_Name__c = 'Patient_Custom__c';
        insert xmlConfig2;
        
        XML_Configuration__c xmlConfig3 = new XML_Configuration__c();
        xmlConfig3.Field_API_Name__c ='SSN__c';
        xmlConfig3.CRF_Type__c = crfmst.Id;
        xmlConfig3.Object_API_Name__c = 'Patient_Custom__c';
        insert xmlConfig3;
        
        XML_Configuration__c xmlConfig4 = new XML_Configuration__c();
        xmlConfig4.Field_API_Name__c ='Race__c';
        xmlConfig4.CRF_Type__c = crfmst.Id;
        xmlConfig4.Object_API_Name__c = 'Patient_Custom__c';
        insert xmlConfig4;
        
        XML_Configuration__c xmlConfig5 = new XML_Configuration__c();
        xmlConfig5.Field_API_Name__c ='Ethnicity__c';
        xmlConfig5.CRF_Type__c = crfmst.Id;
        xmlConfig5.Object_API_Name__c = 'Patient_Custom__c';
        insert xmlConfig5;
        
        XML_Configuration__c xmlConfig6 = new XML_Configuration__c();
        xmlConfig6.Field_API_Name__c ='ISPY2_Subject_Id__c';
        xmlConfig6.CRF_Type__c = crfmst.Id;
        xmlConfig6.Object_API_Name__c = 'Registration__c';
        insert xmlConfig6;
        
        //Select p.Value__c,p.snomed_Code_Name__c, p.Code_Master__r.Name, p.Code_Master__c, p.Code_System__c, p.Code_System_Version__c From Pre_Registration_Snomed_Codes__c p where Patient__c =:patientId and  (Code_Master__r.Name ='Ethn' or Code_Master__r.Name ='Race'
        
        CRF__c crf = new CRF__c();
        crf.Trial__c= tri.Id;
        crf.TrialPatient__c = tp.Id;
        crf.Site__c = site1.Id;
        crf.Patient__c = p.Id;
        crf.Detail__c ='Details';
        insert crf;
        
        CRFMaster__c crfMaster = new CRFMaster__c(Object_Name__c ='TissueSpecimenDetail__c');
        insert crfMaster;
        
        XML_Configuration__c c1 = new XML_Configuration__c(Field_API_Name__c='First_Name__c',CRF_Type__c = crfMaster.Id,Object_API_Name__c = 'Patient_Custom__c');
        insert c1;
        XML_Configuration__c c2 = new XML_Configuration__c(Field_API_Name__c='Last_Name__c',CRF_Type__c = crfMaster.Id,Object_API_Name__c = 'Patient_Custom__c');
        insert c2;
        XML_Configuration__c c3 = new XML_Configuration__c(Field_API_Name__c='Race__c',CRF_Type__c = crfMaster.Id,Object_API_Name__c = 'Patient_Custom__c');
        insert c3;
        XML_Configuration__c c4 = new XML_Configuration__c(Field_API_Name__c='Ethnicity__c',CRF_Type__c = crfMaster.Id,Object_API_Name__c = 'Patient_Custom__c');
        insert c4;
        
        TissueSpecimenDetail__c tissue = new TissueSpecimenDetail__c();
        tissue.TrialPatient__c=tp.Id;
        tissue.Status__c='Approval Not Required';
        //tissue.RecordTypeId='';
        tissue.Patient__c = p.Id;
        tissue.NumberOfSamplesCollected__c =1;
        tissue.Effective_Time__c = System.now();
        tissue.CRFId__c = crf.Id;
        tissue.ProcedureDate__c=System.today();
        tissue.Time_Point__c='Pre-treatment';
        tissue.Guidance_Method_s__c='Ultrasound;MRI;Stereotactic;Mammography;Palpation;';
        tissue.PatientConsentedOutsideStudy__c=False;
        tissue.PatientConsentedStudy__c=False;
        insert tissue;
        
        TissueSpecimenDetail__c tissue2 = new TissueSpecimenDetail__c();
        tissue2.TrialPatient__c=tp.Id;
        tissue2.Status__c='Approval Not Required';
        //tissue.RecordTypeId='';
        tissue2.Patient__c = p.Id;
        tissue2.NumberOfSamplesCollected__c =1;
        tissue2.Effective_Time__c = System.now();
        tissue2.CRFId__c = crf.Id;
        tissue2.ProcedureDate__c=System.today();
        tissue2.Time_Point__c='Pre-treatment';
        tissue2.Guidance_Method_s__c='Ultrasound;MRI;Stereotactic;Mammography;Palpation;';
        tissue2.PatientConsentedOutsideStudy__c=True;
        tissue2.PatientConsentedStudy__c=True;
        insert tissue2;
        
        
        
        Failed_Registration__c fr2 = new Failed_Registration__c(CRF_Id__c=tissue2.Id,CRF_Name__c='Tissue Specimen Form',Trial__c=t.id,Patient__c=p.id,Retry__c=true,Last_Status__c='Failure');
        insert fr2;
        
        Failed_Registration__c fr3 = new Failed_Registration__c(CRF_Id__c=tissue2.Id,CRF_Name__c='Tissue Specimen Form',IsConsent__c=True,Trial__c=t.id,Patient__c=p.id,Retry__c=true,Last_Status__c='Failure');
        insert fr3;
        
        CRFMaster__c crfMaster2 = new CRFMaster__c(Object_Name__c ='BloodSpecimenForm__c');
        insert crfMaster2;
        
        XML_Configuration__c c11 = new XML_Configuration__c(Field_API_Name__c='First_Name__c',CRF_Type__c = crfMaster2.Id,Object_API_Name__c = 'Patient_Custom__c');
        insert c11;
        XML_Configuration__c c12 = new XML_Configuration__c(Field_API_Name__c='Last_Name__c',CRF_Type__c = crfMaster2.Id,Object_API_Name__c = 'Patient_Custom__c');
        insert c12;
        XML_Configuration__c c13 = new XML_Configuration__c(Field_API_Name__c='Race__c',CRF_Type__c = crfMaster2.Id,Object_API_Name__c = 'Patient_Custom__c');
        insert c13;
        XML_Configuration__c c14 = new XML_Configuration__c(Field_API_Name__c='Ethnicity__c',CRF_Type__c = crfMaster2.Id,Object_API_Name__c = 'Patient_Custom__c');
        insert c14;
        
        BloodSpecimenForm__c blood= new BloodSpecimenForm__c ();
        blood.TrialPatient__c=tp.Id;
        blood.Status__c='Approval Not Required';
        //tissue.RecordTypeId='';
        //blood.Patient__c = p.Id;
        //blood.NumberOfSamplesCollected__c =1;
        blood.Effective_Time__c = System.now();
        blood.CRF__c = crf.Id;
        blood.CollectionDate__c=System.today();
        blood.Time_Point__c='Pre-treatment';
        //blood.Guidance_Method_s__c='Ultrasound';
        blood.Consented_to_use_specimen_study__c=True;
        blood.Contented_specimen_outside_study__c=True;
        insert blood;
        
        BloodSpecimenForm__c blood2= new BloodSpecimenForm__c ();
        blood2.TrialPatient__c=tp.Id;
        blood2.Status__c='Approval Not Required';
        //tissue.RecordTypeId='';
        //blood.Patient__c = p.Id;
        //blood.NumberOfSamplesCollected__c =1;
        blood2.Effective_Time__c = System.now();
        blood2.CRF__c = crf.Id;
        blood2.CollectionDate__c=System.today();
        blood2.Time_Point__c='Pre-treatment';
        //blood.Guidance_Method_s__c='Ultrasound';
        blood2.Consented_to_use_specimen_study__c=True;
        blood2.Contented_specimen_outside_study__c=True;
        insert blood2;
        
        Failed_Registration__c fr4 = new Failed_Registration__c(CRF_Id__c=blood2.Id,CRF_Name__c='Blood Specimen Form',Trial__c=t.id,Patient__c=p.id,Retry__c=true,Last_Status__c='Failure');
        insert fr4;
        
        Failed_Registration__c fr5 = new Failed_Registration__c(CRF_Id__c=blood2.Id,CRF_Name__c='Blood Specimen Form',IsConsent__c=True,Trial__c=t.id,Patient__c=p.id,Retry__c=true,Last_Status__c='Failure');
        insert fr5;
        
        CRFMaster__c crfMaster3 = new CRFMaster__c(Object_Name__c ='AE_Detail__c');
        insert crfMaster3;
        
        XML_Configuration__c c21 = new XML_Configuration__c(Field_API_Name__c='First_Name__c',CRF_Type__c = crfMaster3.Id,Object_API_Name__c = 'Patient_Custom__c');
        insert c21;
        XML_Configuration__c c22 = new XML_Configuration__c(Field_API_Name__c='Last_Name__c',CRF_Type__c = crfMaster3.Id,Object_API_Name__c = 'Patient_Custom__c');
        insert c22;
        XML_Configuration__c c23 = new XML_Configuration__c(Field_API_Name__c='Race__c',CRF_Type__c = crfMaster3.Id,Object_API_Name__c = 'Patient_Custom__c');
        insert c23;
        XML_Configuration__c c24 = new XML_Configuration__c(Field_API_Name__c='Ethnicity__c',CRF_Type__c = crfMaster3.Id,Object_API_Name__c = 'Patient_Custom__c');
        insert c24;
        
        AE_Detail__c ae = new AE_Detail__c();
        ae.CRF__c=crf.Id;
        ae.Effective_Time__c=System.now();
        ae.TrialPatient__c=tp.Id;
        ae.CompletedDate__c=System.today();
        insert ae;
        
        Toxicity__c tx = new Toxicity__c();
        tx.AE_Detail__c = ae.Id;
        tx.AE_End_Date__c=System.today();
        tx.Effective_Time__c=System.now();
        tx.Onset_Date__c=System.today();
        insert tx;
        
        Failed_Registration__c fr6 = new Failed_Registration__c(CRF_Id__c=ae.Id,CRF_Name__c='AE Form',IsConsent__c=True,Trial__c=t.id,Patient__c=p.id,Retry__c=true,Last_Status__c='Failure');
        insert fr6;
        
        job.query='Select CRF_Id__c,CRF_Name__c,IsConsent__c, Trial__c, Retry__c, Patient__c, Number_of_Retry__c, Name, Last_Success_Message__c, Last_Status__c, Last_Run_DateTime__c, Last_Error_Message__c, Id From Failed_Registration__c where Retry__c=true limit 10';
        Test.startTest();
        job.processFR(fr);
        job.processFR(fr2);
        job.processFR(fr3);
        job.processFR(fr4);
        job.processFR(fr5);
        job.processFR(fr6);
        
        
        ID batchProecssedId = Database.executeBatch(job,1);
        Test.stopTest();
    }
    @isTest public static void test4(){
        BatchableRetryRegistration job = new BatchableRetryRegistration();
        //Test.startTest();
        Trial__c t = new Trial__c(Name='Test Trial',Start_Date__c=System.today());
        insert t;
        Account a = new Account(Name='Test Account');
        insert a;
        Patient_Custom__c p = new Patient_Custom__c(Name='Test Patient',Institution__c=a.id,Last_Name__c='Last Name',Birthdate__c=System.today(),Race__c='American Indian or Alaska Native;Asian;Native Hawaiian or Other Pacific Islander;xyz;White;Black or African American',Gender__c='Female',Ethnicity__c='Not Hispanic or Latino');
        insert p;
        
        
        Trial__c tri = new Trial__c();
        tri.Name = 'test';
        insert tri;
        
        TrialPatient__c tp = new TrialPatient__c();
        tp.Patient_Id__c = p.Id;
        tp.Trial_Id__c = tri.Id;
        insert tp;
        
        
        Site__c site1 = new Site__c();
        site1.Name = 'test site1';
        site1.Type__c = 'test type';
        site1.Institute__c = a.Id;
        insert site1;
        
        Registration__c reg = new Registration__c(); 
        reg.Patient__c = p.Id;
        reg.Registration_Date__c = system.today();
        reg.Trial__c = t.Id;
        reg.Institution__c = a.Id;
        reg.Site__c = site1.Id;
        reg.IRB_Approval_Date__c = system.today();
        reg.HIPPA_Consent_Date__c = system.today();
        reg.Screening_Informed_Consent_Date__c = system.today();
        reg.Status__c = 'Accepted';
        reg.Effective_Time__c = system.now();
        reg.ISPY2_Subject_Id__c = ''+123;
        insert reg;
        
        Failed_Registration__c fr = new Failed_Registration__c(CRF_Id__c=reg.Id,CRF_Name__c='Patient Registration Form',Trial__c=t.id,Patient__c=p.id,Retry__c=true,Last_Status__c='Failure');
        insert fr;
        
        CRFMaster__c crfmst = new CRFMaster__c();
        crfmst.Object_Name__c ='Registration__c';
        insert crfmst;
        
        XML_Configuration__c xmlConfig = new XML_Configuration__c();
        xmlConfig.Field_API_Name__c ='First_Name__c';
        xmlConfig.CRF_Type__c = crfmst.Id;
        xmlConfig.Object_API_Name__c = 'Patient_Custom__c';
        insert xmlConfig;
        
        XML_Configuration__c xmlConfig2 = new XML_Configuration__c();
        xmlConfig2.Field_API_Name__c ='Last_Name__c';
        xmlConfig2.CRF_Type__c = crfmst.Id;
        xmlConfig2.Object_API_Name__c = 'Patient_Custom__c';
        insert xmlConfig2;
        
        XML_Configuration__c xmlConfig3 = new XML_Configuration__c();
        xmlConfig3.Field_API_Name__c ='SSN__c';
        xmlConfig3.CRF_Type__c = crfmst.Id;
        xmlConfig3.Object_API_Name__c = 'Patient_Custom__c';
        insert xmlConfig3;
        
        XML_Configuration__c xmlConfig4 = new XML_Configuration__c();
        xmlConfig4.Field_API_Name__c ='Race__c';
        xmlConfig4.CRF_Type__c = crfmst.Id;
        xmlConfig4.Object_API_Name__c = 'Patient_Custom__c';
        insert xmlConfig4;
        
        XML_Configuration__c xmlConfig5 = new XML_Configuration__c();
        xmlConfig5.Field_API_Name__c ='Ethnicity__c';
        xmlConfig5.CRF_Type__c = crfmst.Id;
        xmlConfig5.Object_API_Name__c = 'Patient_Custom__c';
        insert xmlConfig5;
        
        XML_Configuration__c xmlConfig6 = new XML_Configuration__c();
        xmlConfig6.Field_API_Name__c ='ISPY2_Subject_Id__c';
        xmlConfig6.CRF_Type__c = crfmst.Id;
        xmlConfig6.Object_API_Name__c = 'Registration__c';
        insert xmlConfig6;
        
        //Select p.Value__c,p.snomed_Code_Name__c, p.Code_Master__r.Name, p.Code_Master__c, p.Code_System__c, p.Code_System_Version__c From Pre_Registration_Snomed_Codes__c p where Patient__c =:patientId and  (Code_Master__r.Name ='Ethn' or Code_Master__r.Name ='Race'
        
        CRF__c crf = new CRF__c();
        crf.Trial__c= tri.Id;
        crf.TrialPatient__c = tp.Id;
        crf.Site__c = site1.Id;
        crf.Patient__c = p.Id;
        crf.Detail__c ='Details';
        insert crf;
        
        CRFMaster__c crfMaster = new CRFMaster__c(Object_Name__c ='TissueSpecimenDetail__c');
        insert crfMaster;
        
        XML_Configuration__c c1 = new XML_Configuration__c(Field_API_Name__c='First_Name__c',CRF_Type__c = crfMaster.Id,Object_API_Name__c = 'Patient_Custom__c');
        insert c1;
        XML_Configuration__c c2 = new XML_Configuration__c(Field_API_Name__c='Last_Name__c',CRF_Type__c = crfMaster.Id,Object_API_Name__c = 'Patient_Custom__c');
        insert c2;
        XML_Configuration__c c3 = new XML_Configuration__c(Field_API_Name__c='Race__c',CRF_Type__c = crfMaster.Id,Object_API_Name__c = 'Patient_Custom__c');
        insert c3;
        XML_Configuration__c c4 = new XML_Configuration__c(Field_API_Name__c='Ethnicity__c',CRF_Type__c = crfMaster.Id,Object_API_Name__c = 'Patient_Custom__c');
        insert c4;
        
        TissueSpecimenDetail__c tissue = new TissueSpecimenDetail__c();
        tissue.TrialPatient__c=tp.Id;
        tissue.Status__c='Approval Not Required';
        //tissue.RecordTypeId='';
        tissue.Patient__c = p.Id;
        tissue.NumberOfSamplesCollected__c =1;
        tissue.Effective_Time__c = System.now();
        tissue.CRFId__c = crf.Id;
        tissue.ProcedureDate__c=System.today();
        tissue.Time_Point__c='Pre-treatment';
        tissue.Guidance_Method_s__c='Ultrasound;MRI;Stereotactic;Mammography;Palpation;';
        tissue.PatientConsentedOutsideStudy__c=False;
        tissue.PatientConsentedStudy__c=False;
        insert tissue;
        
        TissueSpecimenDetail__c tissue2 = new TissueSpecimenDetail__c();
        tissue2.TrialPatient__c=tp.Id;
        tissue2.Status__c='Approval Not Required';
        //tissue.RecordTypeId='';
        tissue2.Patient__c = p.Id;
        tissue2.NumberOfSamplesCollected__c =1;
        tissue2.Effective_Time__c = System.now();
        tissue2.CRFId__c = crf.Id;
        tissue2.ProcedureDate__c=System.today();
        tissue2.Time_Point__c='Pre-treatment';
        tissue2.Guidance_Method_s__c='Ultrasound;MRI;Stereotactic;Mammography;Palpation;';
        tissue2.PatientConsentedOutsideStudy__c=True;
        tissue2.PatientConsentedStudy__c=True;
        insert tissue2;
        
        
        
        Failed_Registration__c fr2 = new Failed_Registration__c(CRF_Id__c=tissue2.Id,CRF_Name__c='Tissue Specimen Form',Trial__c=t.id,Patient__c=p.id,Retry__c=true,Last_Status__c='Failure');
        insert fr2;
        
        Failed_Registration__c fr3 = new Failed_Registration__c(CRF_Id__c=tissue2.Id,CRF_Name__c='Tissue Specimen Form',IsConsent__c=True,Trial__c=t.id,Patient__c=p.id,Retry__c=true,Last_Status__c='Failure');
        insert fr3;
        
        CRFMaster__c crfMaster2 = new CRFMaster__c(Object_Name__c ='BloodSpecimenForm__c');
        insert crfMaster2;
        
        XML_Configuration__c c11 = new XML_Configuration__c(Field_API_Name__c='First_Name__c',CRF_Type__c = crfMaster2.Id,Object_API_Name__c = 'Patient_Custom__c');
        insert c11;
        XML_Configuration__c c12 = new XML_Configuration__c(Field_API_Name__c='Last_Name__c',CRF_Type__c = crfMaster2.Id,Object_API_Name__c = 'Patient_Custom__c');
        insert c12;
        XML_Configuration__c c13 = new XML_Configuration__c(Field_API_Name__c='Race__c',CRF_Type__c = crfMaster2.Id,Object_API_Name__c = 'Patient_Custom__c');
        insert c13;
        XML_Configuration__c c14 = new XML_Configuration__c(Field_API_Name__c='Ethnicity__c',CRF_Type__c = crfMaster2.Id,Object_API_Name__c = 'Patient_Custom__c');
        insert c14;
        
        BloodSpecimenForm__c blood= new BloodSpecimenForm__c ();
        blood.TrialPatient__c=tp.Id;
        blood.Status__c='Approval Not Required';
        //tissue.RecordTypeId='';
        //blood.Patient__c = p.Id;
        //blood.NumberOfSamplesCollected__c =1;
        blood.Effective_Time__c = System.now();
        blood.CRF__c = crf.Id;
        blood.CollectionDate__c=System.today();
        blood.Time_Point__c='Pre-treatment';
        //blood.Guidance_Method_s__c='Ultrasound';
        blood.Consented_to_use_specimen_study__c=True;
        blood.Contented_specimen_outside_study__c=True;
        insert blood;
        
        BloodSpecimenForm__c blood2= new BloodSpecimenForm__c ();
        blood2.TrialPatient__c=tp.Id;
        blood2.Status__c='Approval Not Required';
        //tissue.RecordTypeId='';
        //blood.Patient__c = p.Id;
        //blood.NumberOfSamplesCollected__c =1;
        blood2.Effective_Time__c = System.now();
        blood2.CRF__c = crf.Id;
        blood2.CollectionDate__c=System.today();
        blood2.Time_Point__c='Pre-treatment';
        //blood.Guidance_Method_s__c='Ultrasound';
        blood2.Consented_to_use_specimen_study__c=True;
        blood2.Contented_specimen_outside_study__c=True;
        insert blood2;
        
        Failed_Registration__c fr4 = new Failed_Registration__c(CRF_Id__c=blood2.Id,CRF_Name__c='Blood Specimen Form',Trial__c=t.id,Patient__c=p.id,Retry__c=true,Last_Status__c='Failure');
        insert fr4;
        
        Failed_Registration__c fr5 = new Failed_Registration__c(CRF_Id__c=blood2.Id,CRF_Name__c='Blood Specimen Form',IsConsent__c=True,Trial__c=t.id,Patient__c=p.id,Retry__c=true,Last_Status__c='Failure');
        insert fr5;
        
        CRFMaster__c crfMaster3 = new CRFMaster__c(Object_Name__c ='AE_Detail__c');
        insert crfMaster3;
        
        XML_Configuration__c c21 = new XML_Configuration__c(Field_API_Name__c='First_Name__c',CRF_Type__c = crfMaster3.Id,Object_API_Name__c = 'Patient_Custom__c');
        insert c21;
        XML_Configuration__c c22 = new XML_Configuration__c(Field_API_Name__c='Last_Name__c',CRF_Type__c = crfMaster3.Id,Object_API_Name__c = 'Patient_Custom__c');
        insert c22;
        XML_Configuration__c c23 = new XML_Configuration__c(Field_API_Name__c='Race__c',CRF_Type__c = crfMaster3.Id,Object_API_Name__c = 'Patient_Custom__c');
        insert c23;
        XML_Configuration__c c24 = new XML_Configuration__c(Field_API_Name__c='Ethnicity__c',CRF_Type__c = crfMaster3.Id,Object_API_Name__c = 'Patient_Custom__c');
        insert c24;
        
        AE_Detail__c ae = new AE_Detail__c();
        ae.CRF__c=crf.Id;
        ae.Effective_Time__c=System.now();
        ae.TrialPatient__c=tp.Id;
        ae.CompletedDate__c=System.today();
        insert ae;
        
        Toxicity__c tx = new Toxicity__c();
        tx.AE_Detail__c = ae.Id;
        tx.AE_End_Date__c=System.today();
        tx.Effective_Time__c=System.now();
        tx.Onset_Date__c=System.today();
        insert tx;
        
        Failed_Registration__c fr6 = new Failed_Registration__c(CRF_Id__c=ae.Id,CRF_Name__c='AE Form',IsConsent__c=True,Trial__c=t.id,Patient__c=p.id,Retry__c=true,Last_Status__c='Failure');
        insert fr6;
        
        job.query='Select CRF_Id__c,CRF_Name__c,IsConsent__c, Trial__c, Retry__c, Patient__c, Number_of_Retry__c, Name, Last_Success_Message__c, Last_Status__c, Last_Run_DateTime__c, Last_Error_Message__c, Id From Failed_Registration__c where Retry__c=true limit 10';
        Test.startTest();
        job.processFR(fr);
        job.processFR(fr2);
        job.processFR(fr3);
        job.processFR(fr4);
        job.processFR(fr5);
        job.processFR(fr6);
        
        
        ID batchProecssedId = Database.executeBatch(job,1);
        Test.stopTest();
    }
    @isTest public static void test5(){
        BatchableRetryRegistration job = new BatchableRetryRegistration();
        //Test.startTest();
        Trial__c t = new Trial__c(Name='Test Trial',Start_Date__c=System.today());
        insert t;
        Account a = new Account(Name='Test Account');
        insert a;
        Patient_Custom__c p = new Patient_Custom__c(Name='Test Patient',Institution__c=a.id,Last_Name__c='Last Name',Birthdate__c=System.today(),Race__c='Asian;Native Hawaiian or Other Pacific Islander;xyz;White;Black or African American;American Indian or Alaska Native',Gender__c='Female',Ethnicity__c='Not Hispanic or Latino');
        insert p;
        
        
        Trial__c tri = new Trial__c();
        tri.Name = 'test';
        insert tri;
        
        TrialPatient__c tp = new TrialPatient__c();
        tp.Patient_Id__c = p.Id;
        tp.Trial_Id__c = tri.Id;
        insert tp;
        
        
        Site__c site1 = new Site__c();
        site1.Name = 'test site1';
        site1.Type__c = 'test type';
        site1.Institute__c = a.Id;
        insert site1;
        
        Registration__c reg = new Registration__c(); 
        reg.Patient__c = p.Id;
        reg.Registration_Date__c = system.today();
        reg.Trial__c = t.Id;
        reg.Institution__c = a.Id;
        reg.Site__c = site1.Id;
        reg.IRB_Approval_Date__c = system.today();
        reg.HIPPA_Consent_Date__c = system.today();
        reg.Screening_Informed_Consent_Date__c = system.today();
        reg.Status__c = 'Accepted';
        reg.Effective_Time__c = system.now();
        reg.ISPY2_Subject_Id__c = ''+123;
        insert reg;
        
        Failed_Registration__c fr = new Failed_Registration__c(CRF_Id__c=reg.Id,CRF_Name__c='Patient Registration Form',Trial__c=t.id,Patient__c=p.id,Retry__c=true,Last_Status__c='Failure');
        insert fr;
        
        CRFMaster__c crfmst = new CRFMaster__c();
        crfmst.Object_Name__c ='Registration__c';
        insert crfmst;
        
        XML_Configuration__c xmlConfig = new XML_Configuration__c();
        xmlConfig.Field_API_Name__c ='First_Name__c';
        xmlConfig.CRF_Type__c = crfmst.Id;
        xmlConfig.Object_API_Name__c = 'Patient_Custom__c';
        insert xmlConfig;
        
        XML_Configuration__c xmlConfig2 = new XML_Configuration__c();
        xmlConfig2.Field_API_Name__c ='Last_Name__c';
        xmlConfig2.CRF_Type__c = crfmst.Id;
        xmlConfig2.Object_API_Name__c = 'Patient_Custom__c';
        insert xmlConfig2;
        
        XML_Configuration__c xmlConfig3 = new XML_Configuration__c();
        xmlConfig3.Field_API_Name__c ='SSN__c';
        xmlConfig3.CRF_Type__c = crfmst.Id;
        xmlConfig3.Object_API_Name__c = 'Patient_Custom__c';
        insert xmlConfig3;
        
        XML_Configuration__c xmlConfig4 = new XML_Configuration__c();
        xmlConfig4.Field_API_Name__c ='Race__c';
        xmlConfig4.CRF_Type__c = crfmst.Id;
        xmlConfig4.Object_API_Name__c = 'Patient_Custom__c';
        insert xmlConfig4;
        
        XML_Configuration__c xmlConfig5 = new XML_Configuration__c();
        xmlConfig5.Field_API_Name__c ='Ethnicity__c';
        xmlConfig5.CRF_Type__c = crfmst.Id;
        xmlConfig5.Object_API_Name__c = 'Patient_Custom__c';
        insert xmlConfig5;
        
        XML_Configuration__c xmlConfig6 = new XML_Configuration__c();
        xmlConfig6.Field_API_Name__c ='ISPY2_Subject_Id__c';
        xmlConfig6.CRF_Type__c = crfmst.Id;
        xmlConfig6.Object_API_Name__c = 'Registration__c';
        insert xmlConfig6;
        
        //Select p.Value__c,p.snomed_Code_Name__c, p.Code_Master__r.Name, p.Code_Master__c, p.Code_System__c, p.Code_System_Version__c From Pre_Registration_Snomed_Codes__c p where Patient__c =:patientId and  (Code_Master__r.Name ='Ethn' or Code_Master__r.Name ='Race'
        
        CRF__c crf = new CRF__c();
        crf.Trial__c= tri.Id;
        crf.TrialPatient__c = tp.Id;
        crf.Site__c = site1.Id;
        crf.Patient__c = p.Id;
        crf.Detail__c ='Details';
        insert crf;
        
        CRFMaster__c crfMaster = new CRFMaster__c(Object_Name__c ='TissueSpecimenDetail__c');
        insert crfMaster;
        
        XML_Configuration__c c1 = new XML_Configuration__c(Field_API_Name__c='First_Name__c',CRF_Type__c = crfMaster.Id,Object_API_Name__c = 'Patient_Custom__c');
        insert c1;
        XML_Configuration__c c2 = new XML_Configuration__c(Field_API_Name__c='Last_Name__c',CRF_Type__c = crfMaster.Id,Object_API_Name__c = 'Patient_Custom__c');
        insert c2;
        XML_Configuration__c c3 = new XML_Configuration__c(Field_API_Name__c='Race__c',CRF_Type__c = crfMaster.Id,Object_API_Name__c = 'Patient_Custom__c');
        insert c3;
        XML_Configuration__c c4 = new XML_Configuration__c(Field_API_Name__c='Ethnicity__c',CRF_Type__c = crfMaster.Id,Object_API_Name__c = 'Patient_Custom__c');
        insert c4;
        
        TissueSpecimenDetail__c tissue = new TissueSpecimenDetail__c();
        tissue.TrialPatient__c=tp.Id;
        tissue.Status__c='Approval Not Required';
        //tissue.RecordTypeId='';
        tissue.Patient__c = p.Id;
        tissue.NumberOfSamplesCollected__c =1;
        tissue.Effective_Time__c = System.now();
        tissue.CRFId__c = crf.Id;
        tissue.ProcedureDate__c=System.today();
        tissue.Time_Point__c='Pre-treatment';
        tissue.Guidance_Method_s__c='Ultrasound;MRI;Stereotactic;Mammography;Palpation;';
        tissue.PatientConsentedOutsideStudy__c=False;
        tissue.PatientConsentedStudy__c=False;
        insert tissue;
        
        TissueSpecimenDetail__c tissue2 = new TissueSpecimenDetail__c();
        tissue2.TrialPatient__c=tp.Id;
        tissue2.Status__c='Approval Not Required';
        //tissue.RecordTypeId='';
        tissue2.Patient__c = p.Id;
        tissue2.NumberOfSamplesCollected__c =1;
        tissue2.Effective_Time__c = System.now();
        tissue2.CRFId__c = crf.Id;
        tissue2.ProcedureDate__c=System.today();
        tissue2.Time_Point__c='Pre-treatment';
        tissue2.Guidance_Method_s__c='Ultrasound;MRI;Stereotactic;Mammography;Palpation;';
        tissue2.PatientConsentedOutsideStudy__c=True;
        tissue2.PatientConsentedStudy__c=True;
        insert tissue2;
        
        
        
        Failed_Registration__c fr2 = new Failed_Registration__c(CRF_Id__c=tissue2.Id,CRF_Name__c='Tissue Specimen Form',Trial__c=t.id,Patient__c=p.id,Retry__c=true,Last_Status__c='Failure');
        insert fr2;
        
        Failed_Registration__c fr3 = new Failed_Registration__c(CRF_Id__c=tissue2.Id,CRF_Name__c='Tissue Specimen Form',IsConsent__c=True,Trial__c=t.id,Patient__c=p.id,Retry__c=true,Last_Status__c='Failure');
        insert fr3;
        
        CRFMaster__c crfMaster2 = new CRFMaster__c(Object_Name__c ='BloodSpecimenForm__c');
        insert crfMaster2;
        
        XML_Configuration__c c11 = new XML_Configuration__c(Field_API_Name__c='First_Name__c',CRF_Type__c = crfMaster2.Id,Object_API_Name__c = 'Patient_Custom__c');
        insert c11;
        XML_Configuration__c c12 = new XML_Configuration__c(Field_API_Name__c='Last_Name__c',CRF_Type__c = crfMaster2.Id,Object_API_Name__c = 'Patient_Custom__c');
        insert c12;
        XML_Configuration__c c13 = new XML_Configuration__c(Field_API_Name__c='Race__c',CRF_Type__c = crfMaster2.Id,Object_API_Name__c = 'Patient_Custom__c');
        insert c13;
        XML_Configuration__c c14 = new XML_Configuration__c(Field_API_Name__c='Ethnicity__c',CRF_Type__c = crfMaster2.Id,Object_API_Name__c = 'Patient_Custom__c');
        insert c14;
        
        BloodSpecimenForm__c blood= new BloodSpecimenForm__c ();
        blood.TrialPatient__c=tp.Id;
        blood.Status__c='Approval Not Required';
        //tissue.RecordTypeId='';
        //blood.Patient__c = p.Id;
        //blood.NumberOfSamplesCollected__c =1;
        blood.Effective_Time__c = System.now();
        blood.CRF__c = crf.Id;
        blood.CollectionDate__c=System.today();
        blood.Time_Point__c='Pre-treatment';
        //blood.Guidance_Method_s__c='Ultrasound';
        blood.Consented_to_use_specimen_study__c=True;
        blood.Contented_specimen_outside_study__c=True;
        insert blood;
        
        BloodSpecimenForm__c blood2= new BloodSpecimenForm__c ();
        blood2.TrialPatient__c=tp.Id;
        blood2.Status__c='Approval Not Required';
        //tissue.RecordTypeId='';
        //blood.Patient__c = p.Id;
        //blood.NumberOfSamplesCollected__c =1;
        blood2.Effective_Time__c = System.now();
        blood2.CRF__c = crf.Id;
        blood2.CollectionDate__c=System.today();
        blood2.Time_Point__c='Pre-treatment';
        //blood.Guidance_Method_s__c='Ultrasound';
        blood2.Consented_to_use_specimen_study__c=True;
        blood2.Contented_specimen_outside_study__c=True;
        insert blood2;
        
        Failed_Registration__c fr4 = new Failed_Registration__c(CRF_Id__c=blood2.Id,CRF_Name__c='Blood Specimen Form',Trial__c=t.id,Patient__c=p.id,Retry__c=true,Last_Status__c='Failure');
        insert fr4;
        
        Failed_Registration__c fr5 = new Failed_Registration__c(CRF_Id__c=blood2.Id,CRF_Name__c='Blood Specimen Form',IsConsent__c=True,Trial__c=t.id,Patient__c=p.id,Retry__c=true,Last_Status__c='Failure');
        insert fr5;
        
        CRFMaster__c crfMaster3 = new CRFMaster__c(Object_Name__c ='AE_Detail__c');
        insert crfMaster3;
        
        XML_Configuration__c c21 = new XML_Configuration__c(Field_API_Name__c='First_Name__c',CRF_Type__c = crfMaster3.Id,Object_API_Name__c = 'Patient_Custom__c');
        insert c21;
        XML_Configuration__c c22 = new XML_Configuration__c(Field_API_Name__c='Last_Name__c',CRF_Type__c = crfMaster3.Id,Object_API_Name__c = 'Patient_Custom__c');
        insert c22;
        XML_Configuration__c c23 = new XML_Configuration__c(Field_API_Name__c='Race__c',CRF_Type__c = crfMaster3.Id,Object_API_Name__c = 'Patient_Custom__c');
        insert c23;
        XML_Configuration__c c24 = new XML_Configuration__c(Field_API_Name__c='Ethnicity__c',CRF_Type__c = crfMaster3.Id,Object_API_Name__c = 'Patient_Custom__c');
        insert c24;
        
        AE_Detail__c ae = new AE_Detail__c();
        ae.CRF__c=crf.Id;
        ae.Effective_Time__c=System.now();
        ae.TrialPatient__c=tp.Id;
        ae.CompletedDate__c=System.today();
        insert ae;
        
        Toxicity__c tx = new Toxicity__c();
        tx.AE_Detail__c = ae.Id;
        tx.AE_End_Date__c=System.today();
        tx.Effective_Time__c=System.now();
        tx.Onset_Date__c=System.today();
        insert tx;
        
        Failed_Registration__c fr6 = new Failed_Registration__c(CRF_Id__c=ae.Id,CRF_Name__c='AE Form',IsConsent__c=True,Trial__c=t.id,Patient__c=p.id,Retry__c=true,Last_Status__c='Failure');
        insert fr6;
        
        job.query='Select CRF_Id__c,CRF_Name__c,IsConsent__c, Trial__c, Retry__c, Patient__c, Number_of_Retry__c, Name, Last_Success_Message__c, Last_Status__c, Last_Run_DateTime__c, Last_Error_Message__c, Id From Failed_Registration__c where Retry__c=true limit 10';
        Test.startTest();
        job.processFR(fr);
        job.processFR(fr2);
        job.processFR(fr3);
        job.processFR(fr4);
        job.processFR(fr5);
        job.processFR(fr6);
        
        
        ID batchProecssedId = Database.executeBatch(job,1);
        Test.stopTest();
    }
    @isTest public static void test6(){
        BatchableRetryRegistration job = new BatchableRetryRegistration();
        //Test.startTest();
        Trial__c t = new Trial__c(Name='Test Trial',Start_Date__c=System.today());
        insert t;
        Account a = new Account(Name='Test Account');
        insert a;
        Patient_Custom__c p = new Patient_Custom__c(Name='Test Patient',Institution__c=a.id,Last_Name__c='Last Name',Birthdate__c=System.today(),Race__c='Native Hawaiian or Other Pacific Islander;xyz;White;Black or African American;American Indian or Alaska Native;Asian',Gender__c='NA',Ethnicity__c='Not Hispanic or Latino');
        insert p;
        
        
        Trial__c tri = new Trial__c();
        tri.Name = 'test';
        insert tri;
        
        TrialPatient__c tp = new TrialPatient__c();
        tp.Patient_Id__c = p.Id;
        tp.Trial_Id__c = tri.Id;
        insert tp;
        
        
        Site__c site1 = new Site__c();
        site1.Name = 'test site1';
        site1.Type__c = 'test type';
        site1.Institute__c = a.Id;
        insert site1;
        
        Registration__c reg = new Registration__c(); 
        reg.Patient__c = p.Id;
        reg.Registration_Date__c = system.today();
        reg.Trial__c = t.Id;
        reg.Institution__c = a.Id;
        reg.Site__c = site1.Id;
        reg.IRB_Approval_Date__c = system.today();
        reg.HIPPA_Consent_Date__c = system.today();
        reg.Screening_Informed_Consent_Date__c = system.today();
        reg.Status__c = 'Accepted';
        reg.Effective_Time__c = system.now();
        reg.ISPY2_Subject_Id__c = ''+123;
        insert reg;
        
        Failed_Registration__c fr = new Failed_Registration__c(CRF_Id__c=reg.Id,CRF_Name__c='Patient Registration Form',Trial__c=t.id,Patient__c=p.id,Retry__c=true,Last_Status__c='Failure');
        insert fr;
        
        CRFMaster__c crfmst = new CRFMaster__c();
        crfmst.Object_Name__c ='Registration__c';
        insert crfmst;
        
        XML_Configuration__c xmlConfig = new XML_Configuration__c();
        xmlConfig.Field_API_Name__c ='First_Name__c';
        xmlConfig.CRF_Type__c = crfmst.Id;
        xmlConfig.Object_API_Name__c = 'Patient_Custom__c';
        insert xmlConfig;
        
        XML_Configuration__c xmlConfig2 = new XML_Configuration__c();
        xmlConfig2.Field_API_Name__c ='Last_Name__c';
        xmlConfig2.CRF_Type__c = crfmst.Id;
        xmlConfig2.Object_API_Name__c = 'Patient_Custom__c';
        insert xmlConfig2;
        
        XML_Configuration__c xmlConfig3 = new XML_Configuration__c();
        xmlConfig3.Field_API_Name__c ='SSN__c';
        xmlConfig3.CRF_Type__c = crfmst.Id;
        xmlConfig3.Object_API_Name__c = 'Patient_Custom__c';
        insert xmlConfig3;
        
        XML_Configuration__c xmlConfig4 = new XML_Configuration__c();
        xmlConfig4.Field_API_Name__c ='Race__c';
        xmlConfig4.CRF_Type__c = crfmst.Id;
        xmlConfig4.Object_API_Name__c = 'Patient_Custom__c';
        insert xmlConfig4;
        
        XML_Configuration__c xmlConfig5 = new XML_Configuration__c();
        xmlConfig5.Field_API_Name__c ='Ethnicity__c';
        xmlConfig5.CRF_Type__c = crfmst.Id;
        xmlConfig5.Object_API_Name__c = 'Patient_Custom__c';
        insert xmlConfig5;
        
        XML_Configuration__c xmlConfig6 = new XML_Configuration__c();
        xmlConfig6.Field_API_Name__c ='ISPY2_Subject_Id__c';
        xmlConfig6.CRF_Type__c = crfmst.Id;
        xmlConfig6.Object_API_Name__c = 'Registration__c';
        insert xmlConfig6;
        
        //Select p.Value__c,p.snomed_Code_Name__c, p.Code_Master__r.Name, p.Code_Master__c, p.Code_System__c, p.Code_System_Version__c From Pre_Registration_Snomed_Codes__c p where Patient__c =:patientId and  (Code_Master__r.Name ='Ethn' or Code_Master__r.Name ='Race'
        
        CRF__c crf = new CRF__c();
        crf.Trial__c= tri.Id;
        crf.TrialPatient__c = tp.Id;
        crf.Site__c = site1.Id;
        crf.Patient__c = p.Id;
        crf.Detail__c ='Details';
        insert crf;
        
        CRFMaster__c crfMaster = new CRFMaster__c(Object_Name__c ='TissueSpecimenDetail__c');
        insert crfMaster;
        
        XML_Configuration__c c1 = new XML_Configuration__c(Field_API_Name__c='First_Name__c',CRF_Type__c = crfMaster.Id,Object_API_Name__c = 'Patient_Custom__c');
        insert c1;
        XML_Configuration__c c2 = new XML_Configuration__c(Field_API_Name__c='Last_Name__c',CRF_Type__c = crfMaster.Id,Object_API_Name__c = 'Patient_Custom__c');
        insert c2;
        XML_Configuration__c c3 = new XML_Configuration__c(Field_API_Name__c='Race__c',CRF_Type__c = crfMaster.Id,Object_API_Name__c = 'Patient_Custom__c');
        insert c3;
        XML_Configuration__c c4 = new XML_Configuration__c(Field_API_Name__c='Ethnicity__c',CRF_Type__c = crfMaster.Id,Object_API_Name__c = 'Patient_Custom__c');
        insert c4;
        
        TissueSpecimenDetail__c tissue = new TissueSpecimenDetail__c();
        tissue.TrialPatient__c=tp.Id;
        tissue.Status__c='Approval Not Required';
        //tissue.RecordTypeId='';
        tissue.Patient__c = p.Id;
        tissue.NumberOfSamplesCollected__c =1;
        tissue.Effective_Time__c = System.now();
        tissue.CRFId__c = crf.Id;
        tissue.ProcedureDate__c=System.today();
        tissue.Time_Point__c='Pre-treatment';
        tissue.Guidance_Method_s__c='Ultrasound;MRI;Stereotactic;Mammography;Palpation;';
        tissue.PatientConsentedOutsideStudy__c=False;
        tissue.PatientConsentedStudy__c=False;
        insert tissue;
        
        TissueSpecimenDetail__c tissue2 = new TissueSpecimenDetail__c();
        tissue2.TrialPatient__c=tp.Id;
        tissue2.Status__c='Approval Not Required';
        //tissue.RecordTypeId='';
        tissue2.Patient__c = p.Id;
        tissue2.NumberOfSamplesCollected__c =1;
        tissue2.Effective_Time__c = System.now();
        tissue2.CRFId__c = crf.Id;
        tissue2.ProcedureDate__c=System.today();
        tissue2.Time_Point__c='Pre-treatment';
        tissue2.Guidance_Method_s__c='Ultrasound;MRI;Stereotactic;Mammography;Palpation;';
        tissue2.PatientConsentedOutsideStudy__c=True;
        tissue2.PatientConsentedStudy__c=True;
        insert tissue2;
        
        
        
        Failed_Registration__c fr2 = new Failed_Registration__c(CRF_Id__c=tissue2.Id,CRF_Name__c='Tissue Specimen Form',Trial__c=t.id,Patient__c=p.id,Retry__c=true,Last_Status__c='Failure');
        insert fr2;
        
        Failed_Registration__c fr3 = new Failed_Registration__c(CRF_Id__c=tissue2.Id,CRF_Name__c='Tissue Specimen Form',IsConsent__c=True,Trial__c=t.id,Patient__c=p.id,Retry__c=true,Last_Status__c='Failure');
        insert fr3;
        
        CRFMaster__c crfMaster2 = new CRFMaster__c(Object_Name__c ='BloodSpecimenForm__c');
        insert crfMaster2;
        
        XML_Configuration__c c11 = new XML_Configuration__c(Field_API_Name__c='First_Name__c',CRF_Type__c = crfMaster2.Id,Object_API_Name__c = 'Patient_Custom__c');
        insert c11;
        XML_Configuration__c c12 = new XML_Configuration__c(Field_API_Name__c='Last_Name__c',CRF_Type__c = crfMaster2.Id,Object_API_Name__c = 'Patient_Custom__c');
        insert c12;
        XML_Configuration__c c13 = new XML_Configuration__c(Field_API_Name__c='Race__c',CRF_Type__c = crfMaster2.Id,Object_API_Name__c = 'Patient_Custom__c');
        insert c13;
        XML_Configuration__c c14 = new XML_Configuration__c(Field_API_Name__c='Ethnicity__c',CRF_Type__c = crfMaster2.Id,Object_API_Name__c = 'Patient_Custom__c');
        insert c14;
        
        BloodSpecimenForm__c blood= new BloodSpecimenForm__c ();
        blood.TrialPatient__c=tp.Id;
        blood.Status__c='Approval Not Required';
        //tissue.RecordTypeId='';
        //blood.Patient__c = p.Id;
        //blood.NumberOfSamplesCollected__c =1;
        blood.Effective_Time__c = System.now();
        blood.CRF__c = crf.Id;
        blood.CollectionDate__c=System.today();
        blood.Time_Point__c='Pre-treatment';
        //blood.Guidance_Method_s__c='Ultrasound';
        blood.Consented_to_use_specimen_study__c=True;
        blood.Contented_specimen_outside_study__c=True;
        insert blood;
        
        BloodSpecimenForm__c blood2= new BloodSpecimenForm__c ();
        blood2.TrialPatient__c=tp.Id;
        blood2.Status__c='Approval Not Required';
        //tissue.RecordTypeId='';
        //blood.Patient__c = p.Id;
        //blood.NumberOfSamplesCollected__c =1;
        blood2.Effective_Time__c = System.now();
        blood2.CRF__c = crf.Id;
        blood2.CollectionDate__c=System.today();
        blood2.Time_Point__c='Pre-treatment';
        //blood.Guidance_Method_s__c='Ultrasound';
        blood2.Consented_to_use_specimen_study__c=True;
        blood2.Contented_specimen_outside_study__c=True;
        insert blood2;
        
        Failed_Registration__c fr4 = new Failed_Registration__c(CRF_Id__c=blood2.Id,CRF_Name__c='Blood Specimen Form',Trial__c=t.id,Patient__c=p.id,Retry__c=true,Last_Status__c='Failure');
        insert fr4;
        
        Failed_Registration__c fr5 = new Failed_Registration__c(CRF_Id__c=blood2.Id,CRF_Name__c='Blood Specimen Form',IsConsent__c=True,Trial__c=t.id,Patient__c=p.id,Retry__c=true,Last_Status__c='Failure');
        insert fr5;
        
        CRFMaster__c crfMaster3 = new CRFMaster__c(Object_Name__c ='AE_Detail__c');
        insert crfMaster3;
        
        XML_Configuration__c c21 = new XML_Configuration__c(Field_API_Name__c='First_Name__c',CRF_Type__c = crfMaster3.Id,Object_API_Name__c = 'Patient_Custom__c');
        insert c21;
        XML_Configuration__c c22 = new XML_Configuration__c(Field_API_Name__c='Last_Name__c',CRF_Type__c = crfMaster3.Id,Object_API_Name__c = 'Patient_Custom__c');
        insert c22;
        XML_Configuration__c c23 = new XML_Configuration__c(Field_API_Name__c='Race__c',CRF_Type__c = crfMaster3.Id,Object_API_Name__c = 'Patient_Custom__c');
        insert c23;
        XML_Configuration__c c24 = new XML_Configuration__c(Field_API_Name__c='Ethnicity__c',CRF_Type__c = crfMaster3.Id,Object_API_Name__c = 'Patient_Custom__c');
        insert c24;
        
        AE_Detail__c ae = new AE_Detail__c();
        ae.CRF__c=crf.Id;
        ae.Effective_Time__c=System.now();
        ae.TrialPatient__c=tp.Id;
        ae.CompletedDate__c=System.today();
        insert ae;
        
        Toxicity__c tx = new Toxicity__c();
        tx.AE_Detail__c = ae.Id;
        tx.AE_End_Date__c=System.today();
        tx.Effective_Time__c=System.now();
        tx.Onset_Date__c=System.today();
        insert tx;
        
        Failed_Registration__c fr6 = new Failed_Registration__c(CRF_Id__c=ae.Id,CRF_Name__c='AE Form',IsConsent__c=True,Trial__c=t.id,Patient__c=p.id,Retry__c=true,Last_Status__c='Failure');
        insert fr6;
        
        job.query='Select CRF_Id__c,CRF_Name__c,IsConsent__c, Trial__c, Retry__c, Patient__c, Number_of_Retry__c, Name, Last_Success_Message__c, Last_Status__c, Last_Run_DateTime__c, Last_Error_Message__c, Id From Failed_Registration__c where Retry__c=true limit 10';
        Test.startTest();
        job.processFR(fr);
        job.processFR(fr2);
        job.processFR(fr3);
        job.processFR(fr4);
        job.processFR(fr5);
        job.processFR(fr6);
        
        
        ID batchProecssedId = Database.executeBatch(job,1);
        Test.stopTest();
    }
    @isTest public static void test7(){
        BatchableRetryRegistration job = new BatchableRetryRegistration();
        //Test.startTest();
        Trial__c t = new Trial__c(Name='Test Trial',Start_Date__c=System.today());
        insert t;
        Account a = new Account(Name='Test Account');
        insert a;
        Patient_Custom__c p = new Patient_Custom__c(Name='Test Patient',Institution__c=a.id,Last_Name__c='Last Name',Birthdate__c=System.today(),Race__c='xyz;White;Black or African American;American Indian or Alaska Native;Asian;Native Hawaiian or Other Pacific Islander',Gender__c='Female',Ethnicity__c='Not Hispanic or Latino');
        insert p;
        
        
        Trial__c tri = new Trial__c();
        tri.Name = 'test';
        insert tri;
        
        TrialPatient__c tp = new TrialPatient__c();
        tp.Patient_Id__c = p.Id;
        tp.Trial_Id__c = tri.Id;
        insert tp;
        
        
        Site__c site1 = new Site__c();
        site1.Name = 'test site1';
        site1.Type__c = 'test type';
        site1.Institute__c = a.Id;
        insert site1;
        
        Registration__c reg = new Registration__c(); 
        reg.Patient__c = p.Id;
        reg.Registration_Date__c = system.today();
        reg.Trial__c = t.Id;
        reg.Institution__c = a.Id;
        reg.Site__c = site1.Id;
        reg.IRB_Approval_Date__c = system.today();
        reg.HIPPA_Consent_Date__c = system.today();
        reg.Screening_Informed_Consent_Date__c = system.today();
        reg.Status__c = 'Accepted';
        reg.Effective_Time__c = system.now();
        reg.ISPY2_Subject_Id__c = ''+123;
        insert reg;
        
        Failed_Registration__c fr = new Failed_Registration__c(CRF_Id__c=reg.Id,CRF_Name__c='Patient Registration Form',Trial__c=t.id,Patient__c=p.id,Retry__c=true,Last_Status__c='Failure');
        insert fr;
        
        CRFMaster__c crfmst = new CRFMaster__c();
        crfmst.Object_Name__c ='Registration__c';
        insert crfmst;
        
        XML_Configuration__c xmlConfig = new XML_Configuration__c();
        xmlConfig.Field_API_Name__c ='First_Name__c';
        xmlConfig.CRF_Type__c = crfmst.Id;
        xmlConfig.Object_API_Name__c = 'Patient_Custom__c';
        insert xmlConfig;
        
        XML_Configuration__c xmlConfig2 = new XML_Configuration__c();
        xmlConfig2.Field_API_Name__c ='Last_Name__c';
        xmlConfig2.CRF_Type__c = crfmst.Id;
        xmlConfig2.Object_API_Name__c = 'Patient_Custom__c';
        insert xmlConfig2;
        
        XML_Configuration__c xmlConfig3 = new XML_Configuration__c();
        xmlConfig3.Field_API_Name__c ='SSN__c';
        xmlConfig3.CRF_Type__c = crfmst.Id;
        xmlConfig3.Object_API_Name__c = 'Patient_Custom__c';
        insert xmlConfig3;
        
        XML_Configuration__c xmlConfig4 = new XML_Configuration__c();
        xmlConfig4.Field_API_Name__c ='Race__c';
        xmlConfig4.CRF_Type__c = crfmst.Id;
        xmlConfig4.Object_API_Name__c = 'Patient_Custom__c';
        insert xmlConfig4;
        
        XML_Configuration__c xmlConfig5 = new XML_Configuration__c();
        xmlConfig5.Field_API_Name__c ='Ethnicity__c';
        xmlConfig5.CRF_Type__c = crfmst.Id;
        xmlConfig5.Object_API_Name__c = 'Patient_Custom__c';
        insert xmlConfig5;
        
        XML_Configuration__c xmlConfig6 = new XML_Configuration__c();
        xmlConfig6.Field_API_Name__c ='ISPY2_Subject_Id__c';
        xmlConfig6.CRF_Type__c = crfmst.Id;
        xmlConfig6.Object_API_Name__c = 'Registration__c';
        insert xmlConfig6;
        
        //Select p.Value__c,p.snomed_Code_Name__c, p.Code_Master__r.Name, p.Code_Master__c, p.Code_System__c, p.Code_System_Version__c From Pre_Registration_Snomed_Codes__c p where Patient__c =:patientId and  (Code_Master__r.Name ='Ethn' or Code_Master__r.Name ='Race'
        
        CRF__c crf = new CRF__c();
        crf.Trial__c= tri.Id;
        crf.TrialPatient__c = tp.Id;
        crf.Site__c = site1.Id;
        crf.Patient__c = p.Id;
        crf.Detail__c ='Details';
        insert crf;
        
        CRFMaster__c crfMaster = new CRFMaster__c(Object_Name__c ='TissueSpecimenDetail__c');
        insert crfMaster;
        
        XML_Configuration__c c1 = new XML_Configuration__c(Field_API_Name__c='First_Name__c',CRF_Type__c = crfMaster.Id,Object_API_Name__c = 'Patient_Custom__c');
        insert c1;
        XML_Configuration__c c2 = new XML_Configuration__c(Field_API_Name__c='Last_Name__c',CRF_Type__c = crfMaster.Id,Object_API_Name__c = 'Patient_Custom__c');
        insert c2;
        XML_Configuration__c c3 = new XML_Configuration__c(Field_API_Name__c='Race__c',CRF_Type__c = crfMaster.Id,Object_API_Name__c = 'Patient_Custom__c');
        insert c3;
        XML_Configuration__c c4 = new XML_Configuration__c(Field_API_Name__c='Ethnicity__c',CRF_Type__c = crfMaster.Id,Object_API_Name__c = 'Patient_Custom__c');
        insert c4;
        
        TissueSpecimenDetail__c tissue = new TissueSpecimenDetail__c();
        tissue.TrialPatient__c=tp.Id;
        tissue.Status__c='Approval Not Required';
        //tissue.RecordTypeId='';
        tissue.Patient__c = p.Id;
        tissue.NumberOfSamplesCollected__c =1;
        tissue.Effective_Time__c = System.now();
        tissue.CRFId__c = crf.Id;
        tissue.ProcedureDate__c=System.today();
        tissue.Time_Point__c='Pre-treatment';
        tissue.Guidance_Method_s__c='Ultrasound;MRI;Stereotactic;Mammography;Palpation;';
        tissue.PatientConsentedOutsideStudy__c=False;
        tissue.PatientConsentedStudy__c=False;
        insert tissue;
        
        TissueSpecimenDetail__c tissue2 = new TissueSpecimenDetail__c();
        tissue2.TrialPatient__c=tp.Id;
        tissue2.Status__c='Approval Not Required';
        //tissue.RecordTypeId='';
        tissue2.Patient__c = p.Id;
        tissue2.NumberOfSamplesCollected__c =1;
        tissue2.Effective_Time__c = System.now();
        tissue2.CRFId__c = crf.Id;
        tissue2.ProcedureDate__c=System.today();
        tissue2.Time_Point__c='Pre-treatment';
        tissue2.Guidance_Method_s__c='Ultrasound;MRI;Stereotactic;Mammography;Palpation;';
        tissue2.PatientConsentedOutsideStudy__c=True;
        tissue2.PatientConsentedStudy__c=True;
        insert tissue2;
        
        
        
        Failed_Registration__c fr2 = new Failed_Registration__c(CRF_Id__c=tissue2.Id,CRF_Name__c='Tissue Specimen Form',Trial__c=t.id,Patient__c=p.id,Retry__c=true,Last_Status__c='Failure');
        insert fr2;
        
        Failed_Registration__c fr3 = new Failed_Registration__c(CRF_Id__c=tissue2.Id,CRF_Name__c='Tissue Specimen Form',IsConsent__c=True,Trial__c=t.id,Patient__c=p.id,Retry__c=true,Last_Status__c='Failure');
        insert fr3;
        
        CRFMaster__c crfMaster2 = new CRFMaster__c(Object_Name__c ='BloodSpecimenForm__c');
        insert crfMaster2;
        
        XML_Configuration__c c11 = new XML_Configuration__c(Field_API_Name__c='First_Name__c',CRF_Type__c = crfMaster2.Id,Object_API_Name__c = 'Patient_Custom__c');
        insert c11;
        XML_Configuration__c c12 = new XML_Configuration__c(Field_API_Name__c='Last_Name__c',CRF_Type__c = crfMaster2.Id,Object_API_Name__c = 'Patient_Custom__c');
        insert c12;
        XML_Configuration__c c13 = new XML_Configuration__c(Field_API_Name__c='Race__c',CRF_Type__c = crfMaster2.Id,Object_API_Name__c = 'Patient_Custom__c');
        insert c13;
        XML_Configuration__c c14 = new XML_Configuration__c(Field_API_Name__c='Ethnicity__c',CRF_Type__c = crfMaster2.Id,Object_API_Name__c = 'Patient_Custom__c');
        insert c14;
        
        BloodSpecimenForm__c blood= new BloodSpecimenForm__c ();
        blood.TrialPatient__c=tp.Id;
        blood.Status__c='Approval Not Required';
        //tissue.RecordTypeId='';
        //blood.Patient__c = p.Id;
        //blood.NumberOfSamplesCollected__c =1;
        blood.Effective_Time__c = System.now();
        blood.CRF__c = crf.Id;
        blood.CollectionDate__c=System.today();
        blood.Time_Point__c='Pre-treatment';
        //blood.Guidance_Method_s__c='Ultrasound';
        blood.Consented_to_use_specimen_study__c=True;
        blood.Contented_specimen_outside_study__c=True;
        insert blood;
        
        BloodSpecimenForm__c blood2= new BloodSpecimenForm__c ();
        blood2.TrialPatient__c=tp.Id;
        blood2.Status__c='Approval Not Required';
        //tissue.RecordTypeId='';
        //blood.Patient__c = p.Id;
        //blood.NumberOfSamplesCollected__c =1;
        blood2.Effective_Time__c = System.now();
        blood2.CRF__c = crf.Id;
        blood2.CollectionDate__c=System.today();
        blood2.Time_Point__c='Pre-treatment';
        //blood.Guidance_Method_s__c='Ultrasound';
        blood2.Consented_to_use_specimen_study__c=True;
        blood2.Contented_specimen_outside_study__c=True;
        insert blood2;
        
        Failed_Registration__c fr4 = new Failed_Registration__c(CRF_Id__c=blood2.Id,CRF_Name__c='Blood Specimen Form',Trial__c=t.id,Patient__c=p.id,Retry__c=true,Last_Status__c='Failure');
        insert fr4;
        
        Failed_Registration__c fr5 = new Failed_Registration__c(CRF_Id__c=blood2.Id,CRF_Name__c='Blood Specimen Form',IsConsent__c=True,Trial__c=t.id,Patient__c=p.id,Retry__c=true,Last_Status__c='Failure');
        insert fr5;
        
        CRFMaster__c crfMaster3 = new CRFMaster__c(Object_Name__c ='AE_Detail__c');
        insert crfMaster3;
        
        XML_Configuration__c c21 = new XML_Configuration__c(Field_API_Name__c='First_Name__c',CRF_Type__c = crfMaster3.Id,Object_API_Name__c = 'Patient_Custom__c');
        insert c21;
        XML_Configuration__c c22 = new XML_Configuration__c(Field_API_Name__c='Last_Name__c',CRF_Type__c = crfMaster3.Id,Object_API_Name__c = 'Patient_Custom__c');
        insert c22;
        XML_Configuration__c c23 = new XML_Configuration__c(Field_API_Name__c='Race__c',CRF_Type__c = crfMaster3.Id,Object_API_Name__c = 'Patient_Custom__c');
        insert c23;
        XML_Configuration__c c24 = new XML_Configuration__c(Field_API_Name__c='Ethnicity__c',CRF_Type__c = crfMaster3.Id,Object_API_Name__c = 'Patient_Custom__c');
        insert c24;
        
        AE_Detail__c ae = new AE_Detail__c();
        ae.CRF__c=crf.Id;
        ae.Effective_Time__c=System.now();
        ae.TrialPatient__c=tp.Id;
        ae.CompletedDate__c=System.today();
        insert ae;
        
        Toxicity__c tx = new Toxicity__c();
        tx.AE_Detail__c = ae.Id;
        tx.AE_End_Date__c=System.today();
        tx.Effective_Time__c=System.now();
        tx.Onset_Date__c=System.today();
        insert tx;
        
        Failed_Registration__c fr6 = new Failed_Registration__c(CRF_Id__c=ae.Id,CRF_Name__c='AE Form',IsConsent__c=True,Trial__c=t.id,Patient__c=p.id,Retry__c=true,Last_Status__c='Failure');
        insert fr6;
        
        job.query='Select CRF_Id__c,CRF_Name__c,IsConsent__c, Trial__c, Retry__c, Patient__c, Number_of_Retry__c, Name, Last_Success_Message__c, Last_Status__c, Last_Run_DateTime__c, Last_Error_Message__c, Id From Failed_Registration__c where Retry__c=true limit 10';
        Test.startTest();
        job.processFR(fr);
        job.processFR(fr2);
        job.processFR(fr3);
        job.processFR(fr4);
        job.processFR(fr5);
        job.processFR(fr6);
        
        
        ID batchProecssedId = Database.executeBatch(job,1);
        Test.stopTest();
    }
    @isTest public static void test8(){
        BatchableRetryRegistration job = new BatchableRetryRegistration();
        //Test.startTest();
        Trial__c t = new Trial__c(Name='Test Trial',Start_Date__c=System.today());
        insert t;
        Account a = new Account(Name='Test Account');
        insert a;
        Patient_Custom__c p = new Patient_Custom__c(Name='Test Patient',Institution__c=a.id,Last_Name__c='Last Name',Birthdate__c=System.today(),Race__c='xyz;pqr;White;Black or African American;American Indian or Alaska Native;Asian;Native Hawaiian or Other Pacific Islander',Gender__c='NA',Ethnicity__c='Not Hispanic or Latino');
        insert p;
        
        
        Trial__c tri = new Trial__c();
        tri.Name = 'test';
        insert tri;
        
        TrialPatient__c tp = new TrialPatient__c();
        tp.Patient_Id__c = p.Id;
        tp.Trial_Id__c = tri.Id;
        insert tp;
        
        
        Site__c site1 = new Site__c();
        site1.Name = 'test site1';
        site1.Type__c = 'test type';
        site1.Institute__c = a.Id;
        insert site1;
        
        Registration__c reg = new Registration__c(); 
        reg.Patient__c = p.Id;
        reg.Registration_Date__c = system.today();
        reg.Trial__c = t.Id;
        reg.Institution__c = a.Id;
        reg.Site__c = site1.Id;
        reg.IRB_Approval_Date__c = system.today();
        reg.HIPPA_Consent_Date__c = system.today();
        reg.Screening_Informed_Consent_Date__c = system.today();
        reg.Status__c = 'Accepted';
        reg.Effective_Time__c = system.now();
        reg.ISPY2_Subject_Id__c = ''+123;
        insert reg;
        
        Failed_Registration__c fr = new Failed_Registration__c(CRF_Id__c=reg.Id,CRF_Name__c='Patient Registration Form',Trial__c=t.id,Patient__c=p.id,Retry__c=true,Last_Status__c='Failure');
        insert fr;
        
        CRFMaster__c crfmst = new CRFMaster__c();
        crfmst.Object_Name__c ='Registration__c';
        insert crfmst;
        
        XML_Configuration__c xmlConfig = new XML_Configuration__c();
        xmlConfig.Field_API_Name__c ='First_Name__c';
        xmlConfig.CRF_Type__c = crfmst.Id;
        xmlConfig.Object_API_Name__c = 'Patient_Custom__c';
        insert xmlConfig;
        
        XML_Configuration__c xmlConfig2 = new XML_Configuration__c();
        xmlConfig2.Field_API_Name__c ='Last_Name__c';
        xmlConfig2.CRF_Type__c = crfmst.Id;
        xmlConfig2.Object_API_Name__c = 'Patient_Custom__c';
        insert xmlConfig2;
        
        XML_Configuration__c xmlConfig3 = new XML_Configuration__c();
        xmlConfig3.Field_API_Name__c ='SSN__c';
        xmlConfig3.CRF_Type__c = crfmst.Id;
        xmlConfig3.Object_API_Name__c = 'Patient_Custom__c';
        insert xmlConfig3;
        
        XML_Configuration__c xmlConfig4 = new XML_Configuration__c();
        xmlConfig4.Field_API_Name__c ='Race__c';
        xmlConfig4.CRF_Type__c = crfmst.Id;
        xmlConfig4.Object_API_Name__c = 'Patient_Custom__c';
        insert xmlConfig4;
        
        XML_Configuration__c xmlConfig5 = new XML_Configuration__c();
        xmlConfig5.Field_API_Name__c ='Ethnicity__c';
        xmlConfig5.CRF_Type__c = crfmst.Id;
        xmlConfig5.Object_API_Name__c = 'Patient_Custom__c';
        insert xmlConfig5;
        
        XML_Configuration__c xmlConfig6 = new XML_Configuration__c();
        xmlConfig6.Field_API_Name__c ='ISPY2_Subject_Id__c';
        xmlConfig6.CRF_Type__c = crfmst.Id;
        xmlConfig6.Object_API_Name__c = 'Registration__c';
        insert xmlConfig6;
        
        //Select p.Value__c,p.snomed_Code_Name__c, p.Code_Master__r.Name, p.Code_Master__c, p.Code_System__c, p.Code_System_Version__c From Pre_Registration_Snomed_Codes__c p where Patient__c =:patientId and  (Code_Master__r.Name ='Ethn' or Code_Master__r.Name ='Race'
        
        CRF__c crf = new CRF__c();
        crf.Trial__c= tri.Id;
        crf.TrialPatient__c = tp.Id;
        crf.Site__c = site1.Id;
        crf.Patient__c = p.Id;
        crf.Detail__c ='Details';
        insert crf;
        
        CRFMaster__c crfMaster = new CRFMaster__c(Object_Name__c ='TissueSpecimenDetail__c');
        insert crfMaster;
        
        XML_Configuration__c c1 = new XML_Configuration__c(Field_API_Name__c='First_Name__c',CRF_Type__c = crfMaster.Id,Object_API_Name__c = 'Patient_Custom__c');
        insert c1;
        XML_Configuration__c c2 = new XML_Configuration__c(Field_API_Name__c='Last_Name__c',CRF_Type__c = crfMaster.Id,Object_API_Name__c = 'Patient_Custom__c');
        insert c2;
        XML_Configuration__c c3 = new XML_Configuration__c(Field_API_Name__c='Race__c',CRF_Type__c = crfMaster.Id,Object_API_Name__c = 'Patient_Custom__c');
        insert c3;
        XML_Configuration__c c4 = new XML_Configuration__c(Field_API_Name__c='Ethnicity__c',CRF_Type__c = crfMaster.Id,Object_API_Name__c = 'Patient_Custom__c');
        insert c4;
        
        TissueSpecimenDetail__c tissue = new TissueSpecimenDetail__c();
        tissue.TrialPatient__c=tp.Id;
        tissue.Status__c='Approval Not Required';
        //tissue.RecordTypeId='';
        tissue.Patient__c = p.Id;
        tissue.NumberOfSamplesCollected__c =1;
        tissue.Effective_Time__c = System.now();
        tissue.CRFId__c = crf.Id;
        tissue.ProcedureDate__c=System.today();
        tissue.Time_Point__c='Pre-treatment';
        tissue.Guidance_Method_s__c='Ultrasound;MRI;Stereotactic;Mammography;Palpation;';
        tissue.PatientConsentedOutsideStudy__c=False;
        tissue.PatientConsentedStudy__c=False;
        insert tissue;
        
        TissueSpecimenDetail__c tissue2 = new TissueSpecimenDetail__c();
        tissue2.TrialPatient__c=tp.Id;
        tissue2.Status__c='Approval Not Required';
        //tissue.RecordTypeId='';
        tissue2.Patient__c = p.Id;
        tissue2.NumberOfSamplesCollected__c =1;
        tissue2.Effective_Time__c = System.now();
        tissue2.CRFId__c = crf.Id;
        tissue2.ProcedureDate__c=System.today();
        tissue2.Time_Point__c='Pre-treatment';
        tissue2.Guidance_Method_s__c='Ultrasound;MRI;Stereotactic;Mammography;Palpation;';
        tissue2.PatientConsentedOutsideStudy__c=True;
        tissue2.PatientConsentedStudy__c=True;
        insert tissue2;
        
        
        
        Failed_Registration__c fr2 = new Failed_Registration__c(CRF_Id__c=tissue2.Id,CRF_Name__c='Tissue Specimen Form',Trial__c=t.id,Patient__c=p.id,Retry__c=true,Last_Status__c='Failure');
        insert fr2;
        
        Failed_Registration__c fr3 = new Failed_Registration__c(CRF_Id__c=tissue2.Id,CRF_Name__c='Tissue Specimen Form',IsConsent__c=True,Trial__c=t.id,Patient__c=p.id,Retry__c=true,Last_Status__c='Failure');
        insert fr3;
        
        CRFMaster__c crfMaster2 = new CRFMaster__c(Object_Name__c ='BloodSpecimenForm__c');
        insert crfMaster2;
        
        XML_Configuration__c c11 = new XML_Configuration__c(Field_API_Name__c='First_Name__c',CRF_Type__c = crfMaster2.Id,Object_API_Name__c = 'Patient_Custom__c');
        insert c11;
        XML_Configuration__c c12 = new XML_Configuration__c(Field_API_Name__c='Last_Name__c',CRF_Type__c = crfMaster2.Id,Object_API_Name__c = 'Patient_Custom__c');
        insert c12;
        XML_Configuration__c c13 = new XML_Configuration__c(Field_API_Name__c='Race__c',CRF_Type__c = crfMaster2.Id,Object_API_Name__c = 'Patient_Custom__c');
        insert c13;
        XML_Configuration__c c14 = new XML_Configuration__c(Field_API_Name__c='Ethnicity__c',CRF_Type__c = crfMaster2.Id,Object_API_Name__c = 'Patient_Custom__c');
        insert c14;
        
        BloodSpecimenForm__c blood= new BloodSpecimenForm__c ();
        blood.TrialPatient__c=tp.Id;
        blood.Status__c='Approval Not Required';
        //tissue.RecordTypeId='';
        //blood.Patient__c = p.Id;
        //blood.NumberOfSamplesCollected__c =1;
        blood.Effective_Time__c = System.now();
        blood.CRF__c = crf.Id;
        blood.CollectionDate__c=System.today();
        blood.Time_Point__c='Pre-treatment';
        //blood.Guidance_Method_s__c='Ultrasound';
        blood.Consented_to_use_specimen_study__c=True;
        blood.Contented_specimen_outside_study__c=True;
        insert blood;
        
        BloodSpecimenForm__c blood2= new BloodSpecimenForm__c ();
        blood2.TrialPatient__c=tp.Id;
        blood2.Status__c='Approval Not Required';
        //tissue.RecordTypeId='';
        //blood.Patient__c = p.Id;
        //blood.NumberOfSamplesCollected__c =1;
        blood2.Effective_Time__c = System.now();
        blood2.CRF__c = crf.Id;
        blood2.CollectionDate__c=System.today();
        blood2.Time_Point__c='Pre-treatment';
        //blood.Guidance_Method_s__c='Ultrasound';
        blood2.Consented_to_use_specimen_study__c=True;
        blood2.Contented_specimen_outside_study__c=True;
        insert blood2;
        
        Failed_Registration__c fr4 = new Failed_Registration__c(CRF_Id__c=blood2.Id,CRF_Name__c='Blood Specimen Form',Trial__c=t.id,Patient__c=p.id,Retry__c=true,Last_Status__c='Failure');
        insert fr4;
        
        Failed_Registration__c fr5 = new Failed_Registration__c(CRF_Id__c=blood2.Id,CRF_Name__c='Blood Specimen Form',IsConsent__c=True,Trial__c=t.id,Patient__c=p.id,Retry__c=true,Last_Status__c='Failure');
        insert fr5;
        
        CRFMaster__c crfMaster3 = new CRFMaster__c(Object_Name__c ='AE_Detail__c');
        insert crfMaster3;
        
        XML_Configuration__c c21 = new XML_Configuration__c(Field_API_Name__c='First_Name__c',CRF_Type__c = crfMaster3.Id,Object_API_Name__c = 'Patient_Custom__c');
        insert c21;
        XML_Configuration__c c22 = new XML_Configuration__c(Field_API_Name__c='Last_Name__c',CRF_Type__c = crfMaster3.Id,Object_API_Name__c = 'Patient_Custom__c');
        insert c22;
        XML_Configuration__c c23 = new XML_Configuration__c(Field_API_Name__c='Race__c',CRF_Type__c = crfMaster3.Id,Object_API_Name__c = 'Patient_Custom__c');
        insert c23;
        XML_Configuration__c c24 = new XML_Configuration__c(Field_API_Name__c='Ethnicity__c',CRF_Type__c = crfMaster3.Id,Object_API_Name__c = 'Patient_Custom__c');
        insert c24;
        
        AE_Detail__c ae = new AE_Detail__c();
        ae.CRF__c=crf.Id;
        ae.Effective_Time__c=System.now();
        ae.TrialPatient__c=tp.Id;
        ae.CompletedDate__c=System.today();
        insert ae;
        
        Toxicity__c tx = new Toxicity__c();
        tx.AE_Detail__c = ae.Id;
        tx.AE_End_Date__c=System.today();
        tx.Effective_Time__c=System.now();
        tx.Onset_Date__c=System.today();
        insert tx;
        
        Failed_Registration__c fr6 = new Failed_Registration__c(CRF_Id__c=ae.Id,CRF_Name__c='AE Form',IsConsent__c=True,Trial__c=t.id,Patient__c=p.id,Retry__c=true,Last_Status__c='Failure');
        insert fr6;
        
        job.query='Select CRF_Id__c,CRF_Name__c,IsConsent__c, Trial__c, Retry__c, Patient__c, Number_of_Retry__c, Name, Last_Success_Message__c, Last_Status__c, Last_Run_DateTime__c, Last_Error_Message__c, Id From Failed_Registration__c where Retry__c=true limit 10';
        Test.startTest();
        job.processFR(fr);
        job.processFR(fr2);
        job.processFR(fr3);
        job.processFR(fr4);
        job.processFR(fr5);
        job.processFR(fr6);
        
        
        ID batchProecssedId = Database.executeBatch(job,1);
        Test.stopTest();
    }
}