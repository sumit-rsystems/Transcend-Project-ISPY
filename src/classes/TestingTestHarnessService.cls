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
private class TestingTestHarnessService {

    @isTest static void myUnitTest() {
        
        List<User> lstSiteUser = [Select u.IsActive, u.Id From User u where IsActive = true and id =: userinfo.getUserId()];
        System.runAs ( lstSiteUser[0] ) {
            
        List<RecordType> recordT = [Select r.Name, r.Id From RecordType r where SobjectType = 'Account' and Name='Institution'];
        
        Account inst1 = new Account();
        inst1.Name = 'test Institute 1';
        inst1.RecordTypeId = recordT[0].Id;  
        insert inst1;     
   
        Trial__c trial1 = new Trial__c();
        trial1.Name = 'test trial';
        insert trial1;
        
        Site__c site1 = new Site__c();
        site1.Name = 'test site1';
        site1.Type__c = 'test type';
        site1.Institute__c = inst1.Id;
        insert site1;
        
        Patient patbject = new Patient();
        patbject.FirstName = 'test';
        patbject.LastName = 'test';
        patbject.Gender = 'Male';
        patbject.Birthdate = '7/7/1987';
        patbject.Race = 'White';
        patbject.Ethnicity = 'Not Hispanic or Latino';
        patbject.MedicalRecordNumber = '3434';
        patbject.completedDate = '7/7/1990';
        patbject.Status = 'Accepted';
        patbject.TestHarnessId = 'asc-001';
        
        List<Patient> lstPatient = new List<Patient>(); // this indicates "patient" class
        lstPatient.add(patbject);
        
        TestHarnessService harnessObject = new TestHarnessService();
        harnessObject.createPatient(inst1.Id, site1.Id, trial1.Id,lstPatient);
        
        PatientRegistration prObject = new PatientRegistration();
        prObject.patientId = 'asc-001';
        prObject.regDate = '7/8/1985';
        prObject.hasPatientParticipateInRepeatMRIScan = 'yes';
        prObject.completedDate = '7/7/1997';
        prObject.Status = 'Accepted';
        prObject.IRBApprovalDate = '8/8/1996';
        prObject.HIPPAConsentDate = '9/9/1987';
        prObject.ScreeningConsentDate = '10/10/1996';
        
        List<PatientRegistration> lstPatientReg = new List<PatientRegistration>();
        lstPatientReg.add(prObject);
        
        harnessObject.createRegistration(inst1.Id, site1.Id, trial1.Id,lstPatientReg);
        
        PreEligibilityCRF preEligiblityCRF = new PreEligibilityCRF();
        preEligiblityCRF.PatientId = 'asc-001'; 
        preEligiblityCRF.HistologicallyConfirmedInvasiveCancer = 'true';
        preEligiblityCRF.ClinicallyRadiologicallyMeasurable = 'true';
        preEligiblityCRF.CytotoxicRegiments = 'true';
        preEligiblityCRF.X30DaysInvestigationalAgents = 'true';
        preEligiblityCRF.NotHadPriorRT = 'true';
        preEligiblityCRF.PatientIs18yearsOrOlder = 'true';
        preEligiblityCRF.NonPregnantNotLactating = 'true';  
        preEligiblityCRF.NoFerromegnaticProstheses = 'true';
        preEligiblityCRF.WillingToHaveCoreBiospy = 'true';
        preEligiblityCRF.WillinToHaveStudyMRI = 'true';
        preEligiblityCRF.ECOGScore = 'true';
        preEligiblityCRF.PatientSignedUpISPY2Screening = 'true';
        preEligiblityCRF.ReasonNotSigningScreeningConsent = 'true';
        preEligiblityCRF.CompletedDate = '12/12/12/';
        preEligiblityCRF.Status = 'Approval Not Required';
        
        List<PreEligibilityCRF> lstPRE = new List<PreEligibilityCRF>();
        lstPRE.add(preEligiblityCRF);
        
        harnessObject.createPreEligibilityCheckList(inst1.Id, site1.Id, trial1.Id,lstPRE);
        
        //==================="createMRIVolume" begins here============================
        
        MRIVolumeCRF mriObject = new MRIVolumeCRF();
        mriObject.PatientId = 'asc-001';
        mriObject.WasMRIReadable = 'Yes';
        mriObject.DataOfMRIScan = '9/9/2011';
        mriObject.TimePoint = 'Pre-Treatment';
        mriObject.MRIVolumeInCM = '2.4';
        mriObject.Laterality = 'Left';
        mriObject.LongestDiameterOfIndexLesion = '3.4';
        mriObject.AreSeparateMassesOrEnhancementsReported = 'Yes';
        mriObject.CompletedDate = '9/9/1983'; 
        mriObject.Status = 'Accepted';
        
        List<MRIVolumeCRF> lstMrivolume = new List<MRIVolumeCRF>();
        lstMrivolume.add(mriObject); 
        
        harnessObject.createMRIVolume(inst1.Id, site1.Id, trial1.Id,lstMrivolume); 
        }
      }
     @isTest static void myUnitTest1() {
        // TO DO: implement unit test
        
        List<User> lstSiteUser = [Select u.IsActive, u.Id From User u where IsActive = true and id =: userinfo.getUserId()];
        System.runAs ( lstSiteUser[0] ) { 
            
        List<RecordType> recordT = [Select r.Name, r.Id From RecordType r where SobjectType = 'Account' and Name='Institution'];
        
        Account inst1 = new Account();
        inst1.Name = 'test Institute 1';
        inst1.RecordTypeId = recordT[0].Id;  
        insert inst1;        
        
        Trial__c trial1 = new Trial__c();
        trial1.Name = 'test trial';
        insert trial1;
        
        Site__c site1 = new Site__c();
        site1.Name = 'test site1';
        site1.Type__c = 'test type';
        site1.Institute__c = inst1.Id;
        insert site1;
        
        Patient_Custom__c pc = new Patient_Custom__c();
        pc.First_Name__c = 'test';
        pc.Last_Name__c = 'test2';
        pc.Gender__c = 'Male';
        pc.Birthdate__c = date.newInstance(1987, 7, 7);
        pc.Race__c = 'White';
        pc.Ethnicity__c = 'Not Hispanic or Latino';
        pc.Institution__c = inst1.Id;
        pc.Medical_Record_Number__c = '3434';
        pc.TestHarnessId__c = 'ASC002';
        pc.IsTestHarnessPatient__c = true;
        insert pc;
        
        TrialPatient__c tp = new TrialPatient__c();
        tp.Patient_Id__c = pc.Id;
        tp.Trial_Id__c = trial1.Id;
        tp.Site__c = site1.Id;
        insert tp;
        
        Site_Trial__c siteObject = new Site_Trial__c();
        siteObject.Site__c = site1.Id;
        siteObject.Trial__c = trial1.Id; 
        siteObject.User__c = 'Site';
        insert siteObject;
        
        TestHarnessService harnessObject = new TestHarnessService();
        
        MenopausalStatus menoObj =  new MenopausalStatus();
        menoObj.PatientId = 'ASC002';
        menoObj.DateOfLastMenstrualPeriod = '9/9/1988';
        menoObj.UnknownDate = '9/9/1989';
        menoObj.UnknownDate12MonthsAgo = 'True';
        menoObj.OnEstrogenReplacement = 'True';
        menoObj.OnEstrogenReplacementMonths = '1.0';
        menoObj.OnEstrogenReplacementYears = '1234.0';
        menoObj.BilateralOophorectomy = 'True';
        menoObj.BilateralOophorectomyDate = '9/9/1988';
        menoObj.Hysterectomy = 'True';
        menoObj.HysterectomyDate = '9/9/1992';
        menoObj.CompletedDate = '9/9/1990';
        menoObj.Status = 'Accepted';    
        
        List<MenopausalStatus> lstMenoStatus = new List<MenopausalStatus>();
        
        lstMenoStatus.add(menoObj); 
        
        harnessObject.createMenopausalStatus(inst1.Id, site1.Id, trial1.Id,lstMenoStatus);
        
        //====================="else if" condition line 172=========================
        MenopausalStatus menoObj1 =  new MenopausalStatus();
        menoObj1.PatientId = 'ASC002';
        menoObj1.DateOfLastMenstrualPeriod = '9/9/1988';
        menoObj1.UnknownDate = '9/9/1989';
        menoObj1.UnknownDate12MonthsAgo = 'True';
        menoObj1.OnEstrogenReplacement = 'True';
        menoObj1.OnEstrogenReplacementMonths = '1.0';
        menoObj1.OnEstrogenReplacementYears = '1234.0';
        menoObj1.BilateralOophorectomy = 'True';
        menoObj1.BilateralOophorectomyDate = '9/9/1988';
        menoObj1.Hysterectomy = 'True';
        menoObj1.HysterectomyDate = '9/9/1992';
        menoObj1.CompletedDate = '9/9/1990';
        menoObj1.Status = 'Completed';  
        
        List<MenopausalStatus> lstMenoStatus1 = new List<MenopausalStatus>();
        
        lstMenoStatus1.add(menoObj1); 
        
        TestHarnessService harnessObject1 = new TestHarnessService();
        harnessObject1.createMenopausalStatus(inst1.Id, site1.Id, trial1.Id,lstMenoStatus1);
        
        //==========================END==============================================
        
        TissueSpecimenCRF tissueObject = new TissueSpecimenCRF();
        tissueObject.PatientId = 'ASC002';
        tissueObject.CRFId = 'TSF-001';
        tissueObject.ProcedureDate = '9/9/1996';
        tissueObject.GuidanceMethod = 'Ultrasound';
        tissueObject.OtherGuidanceMethod = 'test';
        tissueObject.TimePoint = 'Pre-treatment';
        tissueObject.NumberOfCoreBiopsyCollected = '4';
        tissueObject.ReasonAllSampleNotCollected = 'testing';
        tissueObject.CompletedDate = '9/9/1991';
        tissueObject.Status = 'Accepted';
        tissueObject.Other = 'testing';
        
        List<TissueSpecimenCRF> lstTissue = new List<TissueSpecimenCRF>();
        
        lstTissue.add(tissueObject); 
        
        harnessObject.createTissueSpecimen(inst1.Id, site1.Id, trial1.Id,lstTissue);
        
        //==================="else if" condition line 227=============================
        
        TissueSpecimenCRF tissueObject1 = new TissueSpecimenCRF();
        tissueObject1.PatientId = 'ASC002';
        tissueObject1.CRFId = 'TSF-001';
        tissueObject1.ProcedureDate = '9/9/1996';
        tissueObject1.GuidanceMethod = 'Ultrasound';
        tissueObject1.OtherGuidanceMethod = 'test';
        tissueObject1.TimePoint = 'Early Treatment';
        tissueObject1.NumberOfCoreBiopsyCollected = '4';
        tissueObject1.ReasonAllSampleNotCollected = 'testing';
        tissueObject1.CompletedDate = '9/9/1991';
        tissueObject1.Status = 'Completed';
        tissueObject1.Other = 'testing';
        
        List<TissueSpecimenCRF> lstTissue1 = new List<TissueSpecimenCRF>();
        
        lstTissue1.add(tissueObject1); 
        
        TestHarnessService harnessObject2 = new TestHarnessService();
        harnessObject2.createTissueSpecimen(inst1.Id, site1.Id, trial1.Id,lstTissue1);
        
        //===================END=======================================================
        }
    }
    
    @isTest static void myUnitTest2() {
        // TO DO: implement unit test
        
        List<User> lstSiteUser = [Select u.IsActive, u.Id From User u where IsActive = true and id =: userinfo.getUserId()];
        System.runAs ( lstSiteUser[0] ) { 
            
        List<RecordType> recordT = [Select r.Name, r.Id From RecordType r where SobjectType = 'Account' and Name='Institution'];
        
        Code_Master__c snomedObject = new Code_Master__c();
        snomedObject.Variable_Description__c = 'test';
        snomedObject.IsReportColumn__c = true;
        snomedObject.Display_Order__c = 3.0;
        snomedObject.Name = 'Institution';
        insert snomedObject;
        
        Account inst1 = new Account();
        inst1.Name = 'test Institute 1';
        inst1.RecordTypeId = recordT[0].Id;  
        insert inst1;        
        
        Trial__c trial1 = new Trial__c();
        trial1.Name = 'test trial';
        insert trial1;
        
        Site__c site1 = new Site__c();
        site1.Name = 'test site1';
        site1.Type__c = 'test type';
        site1.Institute__c = inst1.Id;
        insert site1;
        
        Patient_Custom__c pc = new Patient_Custom__c();
        pc.First_Name__c = 'test';
        pc.Last_Name__c = 'test2';
        pc.Gender__c = 'Male';
        pc.Birthdate__c = date.newInstance(1987, 7, 7);
        pc.Race__c = 'White';
        pc.Ethnicity__c = 'Not Hispanic or Latino';
        pc.Institution__c = inst1.Id;
        pc.Medical_Record_Number__c = '3434';
        pc.TestHarnessId__c = 'ASC002';
        pc.IsTestHarnessPatient__c = true;
        insert pc;
        
        Site_Trial__c siteObject = new Site_Trial__c();
        siteObject.Site__c = site1.Id;
        siteObject.Trial__c = trial1.Id; 
        siteObject.User__c = 'Site';
        insert siteObject;
        
        TrialPatient__c tp = new TrialPatient__c();
        tp.Patient_Id__c = pc.Id;
        tp.Trial_Id__c = trial1.Id;
        tp.Site__c = site1.Id;
        insert tp;
        
        TissueSpecimenDetail__c tissue = new TissueSpecimenDetail__c();
        tissue.Patient__c = pc.Id;
        tissue.TestHarnessId__c = pc.TestHarnessId__c;
        tissue.TrialPatient__c = tp.Id;
        tissue.Time_Point__c = 'Pre-Treatment';
        tissue.ProcedureDate__c = date.newInstance(2009, 8, 8);
        insert tissue;
        
        CoreBiopsySpecimen_TSF coreObject = new CoreBiopsySpecimen_TSF();
        coreObject.TissueSpecimenCRFId = 'ASC002';
        coreObject.CoreSpecimen = '12345';
        coreObject.Shipped = 'Yes';
        coreObject.ReasonSamplesNotShipped = 'Spilled on floor';
        coreObject.OtherReasonSamplesNotShipped = 'testing';
        
        List<CoreBiopsySpecimen_TSF> lstCoreBiopsy = new List<CoreBiopsySpecimen_TSF>();
        
        lstCoreBiopsy.add(coreObject); 
        
        TestHarnessService harnessObject = new TestHarnessService();
        harnessObject.createCoreBiopsyForTissueSpecimenCRF(inst1.Id, site1.Id, trial1.Id,lstCoreBiopsy);
        
        //========================END==================================================
        
        //==============begining of "MammaprintCRF" line 288===========================
        
        MammaprintCRF mammaObject = new MammaprintCRF();
        mammaObject.PatientId = 'ASC002';
        mammaObject.ReportDate = '9/9/1983';
        mammaObject.SpecimenCollectionDates = '9/9/1984';   
        mammaObject.SpecimenUsed = 'testing';
        mammaObject.MammaPrintRisk = 'Low risk';
        mammaObject.MammaPrintIndex = '3.5';
        mammaObject.TargetPrintHER2Index = '2.4';
        mammaObject.CompletedDate = '9/9/1982';
        mammaObject.Status = 'Accepted';
        
        List<MammaprintCRF> lstMammaprint = new List<MammaprintCRF>();
        lstMammaprint.add(mammaObject); 
        
        harnessObject.createMammaprint(inst1.Id, site1.Id, trial1.Id,lstMammaprint); 
        
        //============="else if" condition status=completed, begins here================
        
        MammaprintCRF mammaObject1 = new MammaprintCRF();
        mammaObject1.PatientId = 'ASC002';
        mammaObject1.ReportDate = '9/9/1983';
        mammaObject1.SpecimenCollectionDates = '9/9/1984';  
        mammaObject1.SpecimenUsed = 'testing';
        mammaObject1.MammaPrintRisk = 'Low risk';
        mammaObject1.MammaPrintIndex = '3.5';
        mammaObject1.TargetPrintHER2Index = '2.4';
        mammaObject1.CompletedDate = '9/9/1982';
        mammaObject1.Status = 'Completed';
        
        List<MammaprintCRF> lstMammaprint1 = new List<MammaprintCRF>();
        lstMammaprint1.add(mammaObject1); 
        
        TestHarnessService harnessObject5 = new TestHarnessService();
        harnessObject5.createMammaprint(inst1.Id, site1.Id, trial1.Id,lstMammaprint1); 
        
        //===============================END =============================================

        }
    }
    
    @isTest static void myUnitTest3() {
        // TO DO: implement unit test
        
        List<User> lstSiteUser = [Select u.IsActive, u.Id From User u where IsActive = true and id =: userinfo.getUserId()];
        System.runAs ( lstSiteUser[0] ) { 
            
        List<RecordType> recordT = [Select r.Name, r.Id From RecordType r where SobjectType = 'Account' and Name='Institution'];
        
        Account inst1 = new Account();
        inst1.Name = 'test Institute 1';
        inst1.RecordTypeId = recordT[0].Id;  
        insert inst1; 
        
        Trial__c trial1 = new Trial__c();
        trial1.Name = 'test trial';
        insert trial1;
        
        Site__c site1 = new Site__c();
        site1.Name = 'test site1';
        site1.Type__c = 'test type';
        site1.Institute__c = inst1.Id;
        insert site1;
        
        Patient_Custom__c pc = new Patient_Custom__c();
        pc.First_Name__c = 'test';
        pc.Last_Name__c = 'test2';
        pc.Gender__c = 'Male';
        pc.Birthdate__c = date.newInstance(1987, 7, 7);
        pc.Race__c = 'White';
        pc.Ethnicity__c = 'Not Hispanic or Latino';
        pc.Institution__c = inst1.Id;
        pc.Medical_Record_Number__c = '3434';
        pc.TestHarnessId__c = 'ASC002';
        insert pc;
        
        Site_Trial__c siteObject = new Site_Trial__c();
        siteObject.Site__c = site1.Id;
        siteObject.Trial__c = trial1.Id; 
        siteObject.User__c = 'Site';
        insert siteObject;
        
        TrialPatient__c tp = new TrialPatient__c();
        tp.Patient_Id__c = pc.Id;
        tp.Trial_Id__c = trial1.Id;
        tp.Site__c = site1.Id;
        insert tp;
        
        TestHarnessService harnessObject = new TestHarnessService();
        
        //======================PreEligibilityCRF begins here ====================
        
        PreEligibilityCRF preObject = new PreEligibilityCRF();
        preObject.PatientId = 'ASC002';
        preObject.HistologicallyConfirmedInvasiveCancer = 'true';
        preObject.ClinicallyRadiologicallyMeasurable = 'true';
        preObject.CytotoxicRegiments = 'true';
        preObject.X30DaysInvestigationalAgents = 'true';
        preObject.NotHadPriorRT = 'true';
        preObject.PatientIs18yearsOrOlder = 'true';
        preObject.NonPregnantNotLactating = 'true'; 
        preObject.NoFerromegnaticProstheses = 'true';
        preObject.WillingToHaveCoreBiospy = 'true';
        preObject.WillinToHaveStudyMRI = 'true';
        preObject.ECOGScore = '0-Asymptomatic';
        preObject.PatientSignedUpISPY2Screening = 'true';   
        preObject.ReasonNotSigningScreeningConsent = 'Patient does not want to participate in a clinical trial';
        preObject.CompletedDate = '9/9/2011';
        preObject.Status = 'Accepted';
        
        List<PreEligibilityCRF> lstPreEligibility = new List<PreEligibilityCRF>();
        lstPreEligibility.add(preObject); 
        
        harnessObject.createPreEligibilityCheckList(inst1.Id, site1.Id, trial1.Id,lstPreEligibility); 
      }
  }
   
    @isTest static void myUnitTest4() {
        // TO DO: implement unit test
        
        List<User> lstSiteUser = [Select u.IsActive, u.Id From User u where IsActive = true and Profile.Name = 'System Administrator'];
        System.runAs ( lstSiteUser[0] ) { 
            
        List<RecordType> recordT = [Select r.Name, r.Id From RecordType r where SobjectType = 'Account' and Name='Institution'];
        
        Account inst1 = new Account();
        inst1.Name = 'test Institute 1';
        inst1.RecordTypeId = recordT[0].Id;  
        insert inst1;  
            
        Code_Master__c snomedObject = new Code_Master__c();
        snomedObject.Variable_Description__c = 'test';
        snomedObject.IsReportColumn__c = true;
        snomedObject.Display_Order__c = 3.0;
        snomedObject.Name = 'ERstatus_PS';
        insert snomedObject;
        
        Code_Master__c snomedObject1 = new Code_Master__c();
        snomedObject1.Variable_Description__c = 'test';
        snomedObject1.Display_Order__c = 3.0;
        snomedObject1.Name = 'PRstatus_PS';
       // insert snomedObject1; 
        
        Trial__c trial1 = new Trial__c();
        trial1.Name = 'test trial';
        insert trial1;
        
        Site__c site1 = new Site__c();
        site1.Name = 'test site1';
        site1.Type__c = 'test type';
        site1.Institute__c = inst1.Id;
        insert site1;
        
        Patient_Custom__c pc = new Patient_Custom__c();
        pc.First_Name__c = 'test';
        pc.Last_Name__c = 'test2';
        pc.Gender__c = 'Male';
        pc.Birthdate__c = date.newInstance(1987, 7, 7);
        pc.Race__c = 'White';
        pc.Ethnicity__c = 'Not Hispanic or Latino';
        pc.Institution__c = inst1.Id;
        pc.Medical_Record_Number__c = '3434';
        pc.TestHarnessId__c = 'ASC002';
        pc.IsTestHarnessPatient__c = true;
        insert pc;
        
        Site_Trial__c siteObject = new Site_Trial__c();
        siteObject.Site__c = site1.Id;
        siteObject.Trial__c = trial1.Id; 
        siteObject.User__c = 'Site';
        insert siteObject;
        
        TrialPatient__c tp = new TrialPatient__c();
        tp.Patient_Id__c = pc.Id;
        tp.Trial_Id__c = trial1.Id;
        tp.Site__c = site1.Id;
        insert tp;
        
        Post_Surgaory_Summary__c pss = new Post_Surgaory_Summary__c();
        pss.TrialPatient__c = tp.Id;
        pss.Date_Of_Procedure__c = date.newInstance(2012, 7, 7);
        pss.Type_Of_Tumor__c = 'Single Discrete Mass';
        pss.Status__c = 'Not Completed';
        insert pss;
        
        pss.Status__c = 'Accepted';
        update pss;
        
        OnStudyEligibilityCRF onstudyObject = new OnStudyEligibilityCRF();
        onstudyObject.PatientId = 'ASC002';
        onstudyObject.NoClinicalOrImagingEvidence = 'true';
        onstudyObject.NoUncontrolledorCardiovascularDiseas = 'true';
        onstudyObject.NoHistoryOfAllergicReactions = 'true';
        onstudyObject.NoUncontrolledIntercurrentIllness = 'true';
        onstudyObject.NotHadASentinelLymphNode = 'true';
        onstudyObject.LabValues = 'true';
        onstudyObject.Leukocytes3000L = 'true';
        onstudyObject.AbsoluteNeutrophilCount1500L = 'true';
        onstudyObject.Platelets100000L = 'true';
        onstudyObject.TotalBilirubinWithinInstitutional = 'true';
        onstudyObject.ASTSGOTOrALTSGPT15xinsti = 'true';
        onstudyObject.Creatinine15xInstitutionalULN = 'true';
        onstudyObject.HowWasTheCancerFirstDetected = 'Clinical exam';
        onstudyObject.IsMassPalpable = 'Yes';
        onstudyObject.OtherReasonForCancerFirstDetected = 'testing';
        onstudyObject.MassIdentificationDate = '10/9/2010';
        onstudyObject.ScreeningMemogramPriorToMassDetect = 'true';
        onstudyObject.MostRecentDate = '9/10/2010';
        onstudyObject.CompletedDate = '9/9/2010';
        onstudyObject.Status = 'Accepted';
        
        List<OnStudyEligibilityCRF> lstOnStudy = new List<OnStudyEligibilityCRF>();
        lstOnStudy.add(onstudyObject);
        
        TestHarnessService harnessObject = new TestHarnessService();
        harnessObject.createOnStudyEligibility(inst1.Id, site1.Id, trial1.Id,lstOnStudy);  
        
        
        //=============================== BEGINING OF "createOnStudyPathology"=============
        
        OnStudyPathologyCRF onstudyPathologyObject = new OnStudyPathologyCRF();
        onstudyPathologyObject.PatientId = 'ASC002';
        onstudyPathologyObject.CRFId = 'ASC002';
        onstudyPathologyObject.DoesThePatientHaveBilateralBreast = 'Yes';
        onstudyPathologyObject.Tumorlaterality = 'Left';
    //  onstudyPathologyObject.DCIS = ''+dcisObject.Id;
    //  onstudyPathologyObject.LCIS = ''+lcisObject.Id;
    //  onstudyPathologyObject.InvasiveTumorDetail = ''+invasiveObject.Id;
    //  onstudyPathologyObject.Receptors = ''+recpObject.Id;
        onstudyPathologyObject.CompletedDate = '9/9/2012';
        onstudyPathologyObject.Status = 'Accepted';
        
        List<OnStudyPathologyCRF> lstOnStudyPathology = new List<OnStudyPathologyCRF>();
        lstOnStudyPathology.add(onstudyPathologyObject); 
        
        harnessObject.createOnStudyPathology(inst1.Id, site1.Id, trial1.Id,lstOnStudyPathology);  
        
     }
  }
    @isTest static void myUnitTest5() {
        // TO DO: implement unit test
        
        List<User> lstSiteUser = [Select u.IsActive, u.Id From User u where IsActive = true and id =: userinfo.getUserId()];
        System.runAs ( lstSiteUser[0] ) { 
            
        List<RecordType> recordT = [Select r.Name, r.Id From RecordType r where SobjectType = 'Account' and Name='Institution'];
        
        Code_Master__c snomedObject = new Code_Master__c();
        snomedObject.Variable_Description__c = 'test';
        snomedObject.IsReportColumn__c = true;
        snomedObject.Display_Order__c = 3.0;
        snomedObject.Name = 'Institution';
        insert snomedObject;
        
        Account inst1 = new Account();
        inst1.Name = 'test Institute 1';
        inst1.RecordTypeId = recordT[0].Id;  
        insert inst1;        
        
        Trial__c trial1 = new Trial__c();
        trial1.Name = 'test trial';
        insert trial1;
        
        Site__c site1 = new Site__c();
        site1.Name = 'test site1';
        site1.Type__c = 'test type';
        site1.Institute__c = inst1.Id;
        insert site1;
        
        Patient_Custom__c pc = new Patient_Custom__c();
        pc.First_Name__c = 'test';
        pc.Last_Name__c = 'test2';
        pc.Gender__c = 'Male';
        pc.Birthdate__c = date.newInstance(1987, 7, 7);
        pc.Race__c = 'White';
        pc.Ethnicity__c = 'Not Hispanic or Latino';
        pc.Institution__c = inst1.Id;
        pc.Medical_Record_Number__c = '3434';
        pc.TestHarnessId__c = 'ASC002';
        insert pc;
        
        Site_Trial__c siteObject = new Site_Trial__c();
        siteObject.Site__c = site1.Id;
        siteObject.Trial__c = trial1.Id; 
        siteObject.User__c = 'Site';
        insert siteObject;
        
        TrialPatient__c tp = new TrialPatient__c();
        tp.Patient_Id__c = pc.Id;
        tp.Trial_Id__c = trial1.Id;
        tp.Site__c = site1.Id;
        insert tp;
        
        On_Study_Pathology_Form__c ospObj = new On_Study_Pathology_Form__c();
        ospObj.TrialPatient__c = tp.Id;
        ospObj.TestHarnessId__c = pc.TestHarnessId__c;
        ospObj.Does_the_patient_have_bilateral_breast_c__c = 'No';
        ospObj.Tumor_laterality__c = 'Left';
        insert ospObj;
        
        //====================="createProcedure" begins here========================
        
        Procedure_OSP_PSS proObject = new Procedure_OSP_PSS();
        proObject.CRFId = 'ASC002';
    //  proObject.isBreastSurgicalProcedure = 'true';
        proObject.Ultrasound = 'true';
        proObject.TotalPositive = '2.0';
        proObject.TotalExaminedNodes = '3.0';
        proObject.Stereotactic = 'true';
        proObject.ProcedureName = 'Bone';
        proObject.Palpationguided = 'true';
        proObject.NodeType = 'Sentinel (Lymph node)';
        proObject.NodeResult = 'Positive';
        proObject.Mammography = 'true';
        proObject.MRI = 'true';
        proObject.Location = 'Central';
        proObject.Laterality = 'Left';
        proObject.FormName = 'Breast Surgical Procedure Collection';
        proObject.DateOfProcedure = '9/9/2011';
        
        List<Procedure_OSP_PSS> lstProcedure = new List<Procedure_OSP_PSS>();
        lstProcedure.add(proObject); 
        
        TestHarnessService harnessObject = new TestHarnessService();
        harnessObject.createProcedure(inst1.Id, site1.Id, trial1.Id,lstProcedure);  
        
        //====================== DCIS begins here ====================================
        
        DCIS_OSP_CRF dcObject = new DCIS_OSP_CRF();
        dcObject.CRFId = 'ASC002';
        dcObject.Solid = 'true';
        dcObject.Calcifications = 'Yes';
        dcObject.CalcificationsPresent = 'DCIS';
        dcObject.Apocrine = 'true';
        dcObject.PunctateNecrosis = 'true';
        dcObject.Other = 'true';
        dcObject.Necrosis= 'true';
        dcObject.Micropapillary= 'true';
        dcObject.IntraCysticEncystedPapillary= 'true';
        dcObject.Cruciform = 'true';
        dcObject.Cribiform = 'true';
        dcObject.Comedonecrosis = 'true';
        dcObject.Papillary = 'true';
        dcObject.Clinging = 'true';
        
        List<DCIS_OSP_CRF> lstDcis = new List<DCIS_OSP_CRF>();
        lstDcis.add(dcObject);
        
        harnessObject.createDCIS(inst1.Id, site1.Id, trial1.Id,lstDcis); 
        
        //======================="createInvasiveTumor" begins here===========================
        
        InvasiveTumor_OSP_PSS invObject = new InvasiveTumor_OSP_PSS();
        invObject.CRFId = 'ASC002';
        invObject.InvasiveDuctalCarcinomaNos = 'true';
        invObject.InvasiveLobularCarcinomaClassicType = 'true';
        invObject.InvasiveLobularCarcinomaAlveolarType = 'true';
        invObject.PleomorphicLobularCarcinoma = 'true';
        invObject.TubulolobularCarcinoma = 'true';
        invObject.InvasiveCarcinomaMixedDuctalAndLobularType = 'true';
        invObject.TubularCarcinoma = 'true';
        invObject.MucinousCarcinoma = 'true';
        invObject.MedullaryCarcinoma = 'true';
        invObject.InvasivePapillaryCarcinoma = 'true';
        invObject.InvasiveCribiformCarcinoma = 'true';
        invObject.SignsOfTreatmentEffect = 'true';
        invObject.PagetDisease = 'true';
        invObject.UlcerationByTumor = 'true';
        invObject.DermaLymphaticVascularInvasion = 'true';
        
        List<InvasiveTumor_OSP_PSS> lstinv = new List<InvasiveTumor_OSP_PSS>();
        lstinv.add(invObject);
        
        harnessObject.createInvasiveTumor(inst1.Id, site1.Id, trial1.Id,lstinv);
        
      }
  }
    @isTest static void myUnitTest6() {
        // TO DO: implement unit test
        
        List<User> lstSiteUser = [Select u.IsActive, u.Id From User u where IsActive = true and Profile.Name = 'System Administrator'];
        System.runAs ( lstSiteUser[0] ) { 
            
        List<RecordType> recordT = [Select r.Name, r.Id From RecordType r where SobjectType = 'Account' and Name='Institution'];
      
        Code_Master__c snomedObject = new Code_Master__c();
        snomedObject.Variable_Description__c = 'test';
        snomedObject.IsReportColumn__c = true;
        snomedObject.Display_Order__c = 3.0;
        snomedObject.Name = 'pCR';
        insert snomedObject; 
        
        Account inst1 = new Account();
        inst1.Name = 'test Institute 1';
        inst1.RecordTypeId = recordT[0].Id;  
        insert inst1;  
            
        Trial__c trial1 = new Trial__c();
        trial1.Name = 'test trial';
        insert trial1;
        
        Site__c site1 = new Site__c();
        site1.Name = 'test site1';
        site1.Type__c = 'test type';
        site1.Institute__c = inst1.Id;
        insert site1;
        
        Patient_Custom__c pc = new Patient_Custom__c();
        pc.First_Name__c = 'test';
        pc.Last_Name__c = 'test2';
        pc.Gender__c = 'Male';
        pc.Birthdate__c = date.newInstance(1987, 7, 7);
        pc.Race__c = 'White';
        pc.Ethnicity__c = 'Not Hispanic or Latino';
        pc.Institution__c = inst1.Id;
        pc.Medical_Record_Number__c = '3434';
        pc.TestHarnessId__c = 'ASC002';
        insert pc;
        
        Site_Trial__c siteObject = new Site_Trial__c();
        siteObject.Site__c = site1.Id;
        siteObject.Trial__c = trial1.Id; 
        siteObject.User__c = 'Site';
        insert siteObject;
        
        TrialPatient__c tp = new TrialPatient__c();
        tp.Patient_Id__c = pc.Id;
        tp.Trial_Id__c = trial1.Id;
        tp.Site__c = site1.Id;
        insert tp;
        
        Post_Surgaory_Summary__c pss = new Post_Surgaory_Summary__c();
        pss.TrialPatient__c = tp.Id;
        pss.Date_Of_Procedure__c = date.newInstance(2012, 7, 7);
        pss.Type_Of_Tumor__c = 'Single Discrete Mass';
        pss.Status__c = 'Not Completed';
        insert pss;
        
        pss.Status__c = 'Accepted';
        update pss;
        
        On_Study_Pathology_Form__c ospObj = new On_Study_Pathology_Form__c();
        ospObj.TrialPatient__c = tp.Id;
        ospObj.TestHarnessId__c = pc.TestHarnessId__c;
        ospObj.Does_the_patient_have_bilateral_breast_c__c = 'No';
        ospObj.Tumor_laterality__c = 'Left';
        insert ospObj;
        
        //==========================createLCIS begins here ======================================
        
        LCIS_OSP_CRF lcObject = new LCIS_OSP_CRF();
        lcObject.CRFId = 'ASC002';
        lcObject.LCISType = 'Classic';
        
        List<LCIS_OSP_CRF> lstLcis = new List<LCIS_OSP_CRF>();
        lstLcis.add(lcObject); 
        
        TestHarnessService harnessObject = new TestHarnessService();
        harnessObject.createLCIS(inst1.Id, site1.Id, trial1.Id,lstLcis);  
        
        //==========================Receptor begins here ======================================
        
        Receptors_OSP_CRF recObject = new Receptors_OSP_CRF();
        recObject.OSPId = 'ASC002';
        recObject.ERStatus = 'Positive';
        recObject.ERProporationScore = 'Not available';
        recObject.ERIntensityScore = '1 (weak)';
        recObject.PRStatus = 'Positive';
        recObject.PRProporationScore = '1 (less than 1%)';
        recObject.IHCTestNotDone = 'true';
        recObject.FISHTestNotDone = 'true';
        //recObject.OSPId = ''+pss.Id;
    
        List<Receptors_OSP_CRF> lstRec = new List<Receptors_OSP_CRF>();
        lstRec.add(recObject); 
        
        harnessObject.createReceptors(inst1.Id, site1.Id, trial1.Id,lstRec); 
        }
      }
   @isTest static void myUnitTest7() {
        // TO DO: implement unit test
        
        List<User> lstSiteUser = [Select u.IsActive, u.Id From User u where IsActive = true and Profile.Name = 'System Administrator'];
        System.runAs ( lstSiteUser[0] ) { 
            
        List<RecordType> recordT = [Select r.Name, r.Id From RecordType r where SobjectType = 'Account' and Name='Institution'];
      
        Code_Master__c snomedObject = new Code_Master__c();
        snomedObject.Variable_Description__c = 'test';
        snomedObject.IsReportColumn__c = true;
        snomedObject.Display_Order__c = 3.0;
        snomedObject.Name = 'pCR';
        insert snomedObject; 
        
        Account inst1 = new Account();
        inst1.Name = 'test Institute 1';
        inst1.RecordTypeId = recordT[0].Id;  
        insert inst1;  
            
        Trial__c trial1 = new Trial__c();
        trial1.Name = 'test trial';
        insert trial1;
        
        Site__c site1 = new Site__c();
        site1.Name = 'test site1';
        site1.Type__c = 'test type';
        site1.Institute__c = inst1.Id;
        insert site1;
        
        Patient_Custom__c pc = new Patient_Custom__c();
        pc.First_Name__c = 'test';
        pc.Last_Name__c = 'test2';
        pc.Gender__c = 'Male';
        pc.Birthdate__c = date.newInstance(1987, 7, 7);
        pc.Race__c = 'White';
        pc.Ethnicity__c = 'Not Hispanic or Latino';
        pc.Institution__c = inst1.Id;
        pc.Medical_Record_Number__c = '3434';
        pc.TestHarnessId__c = 'ASC002';
        pc.IsTestHarnessPatient__c = true;
        insert pc;
        
        Site_Trial__c siteObject = new Site_Trial__c();
        siteObject.Site__c = site1.Id;
        siteObject.Trial__c = trial1.Id; 
        siteObject.User__c = 'Site';
        insert siteObject;
        
        TrialPatient__c tp = new TrialPatient__c();
        tp.Patient_Id__c = pc.Id;
        tp.Trial_Id__c = trial1.Id;
        tp.Site__c = site1.Id;
        insert tp;
        
        //====================================method "createBloodSpecimenSamples" begins here===========================
        
        BloodSpecimen_BSF bsfObj = new BloodSpecimen_BSF();
        bsfObj.CRFId = 'ASC002';
        bsfObj.Shipped = 'Yes';
        bsfObj.ReasonSamplesNotShipped = 'Other';
        bsfObj.OtherReasonSamplesNotShipped = 'test';
        
        List<BloodSpecimen_BSF> lstBsf = new List<BloodSpecimen_BSF>();
        lstBsf.add(bsfObj);
        
        TestHarnessService harnessObject = new TestHarnessService();
        harnessObject.createBloodSpecimenSamples(inst1.Id, site1.Id, trial1.Id,lstBsf);  
        
        //====================================method "createBloodSpecimen" begins here===================================
        
        BloodSpecimenCRF blood = new BloodSpecimenCRF();
        blood.CRFId = 'ASC002';
        blood.PatientId = 'ASC002';
        blood.PatientConsentedForThisStudy = 'true';
        blood.PatientConsentedForOutSideStudy = 'true';
        blood.TimePoint = 'Surgery';
        blood.ReasonallSamplenotCollected = 'Other';
        blood.CollectionDate = '9/9/2011';
        blood.CompletedDate = '9/9/2011';
        blood.Status = 'Completed';
        
        List<BloodSpecimenCRF> lstBlood = new List<BloodSpecimenCRF>();
        lstBlood.add(blood);
        
        harnessObject.createBloodSpecimen(inst1.Id, site1.Id, trial1.Id,lstBlood);  
         
    }
 }
       @isTest static void myUnitTest8() {
        // TO DO: implement unit test
       
        List<User> lstSiteUser = [Select u.IsActive, u.Id From User u where IsActive = true and Profile.Name = 'System Administrator'];
        System.runAs ( lstSiteUser[0] ) { 
           
        List<RecordType> recordT = [Select r.Name, r.Id From RecordType r where SobjectType = 'Account' and Name='Institution'];
       
        Account inst1 = new Account();
        inst1.Name = 'test Institute 1';
        inst1.RecordTypeId = recordT[0].Id; 
        insert inst1; 
           
        Code_Master__c snomedObject = new Code_Master__c();
        snomedObject.Variable_Description__c = 'test';
        snomedObject.IsReportColumn__c = true;
        snomedObject.Display_Order__c = 3.0;
        insert snomedObject;
       
        Trial__c trial1 = new Trial__c();
        trial1.Name = 'test trial';
        insert trial1;
       
        Site__c site1 = new Site__c();
        site1.Name = 'test site1';
        site1.Type__c = 'test type';
        site1.Institute__c = inst1.Id;
        insert site1;
       
        Patient_Custom__c pc = new Patient_Custom__c();
        pc.First_Name__c = 'test';
        pc.Last_Name__c = 'test2';
        pc.Gender__c = 'Male';
        pc.Birthdate__c = date.newInstance(1987, 7, 7);
        pc.Race__c = 'White';
        pc.Ethnicity__c = 'Not Hispanic or Latino';
        pc.Institution__c = inst1.Id;
        pc.Medical_Record_Number__c = '3434';
        pc.TestHarnessId__c = 'ASC002';
        pc.IsTestHarnessPatient__c = true;
        insert pc;
       
        Site_Trial__c siteObject = new Site_Trial__c();
        siteObject.Site__c = site1.Id;
        siteObject.Trial__c = trial1.Id;
        siteObject.User__c = 'Site';
        insert siteObject;
       
        TrialPatient__c tp = new TrialPatient__c();
        tp.Patient_Id__c = pc.Id;
        tp.Trial_Id__c = trial1.Id;
        tp.Site__c = site1.Id;
        insert tp;        
          
         //=============================== BEGINING OF "createOffStudy"=============

         OffStudyCRF offstudyObject = new OffStudyCRF();
         offstudyObject.PatientId = 'ASC002';
         offstudyObject.Datepatientwentoffstudy= '10/10/2012';
         offstudyObject.Patientcompletedstudyperprotocol= 'true';
         offstudyObject.PatientdidnotwanttocompleteMRI= 'true';
         offstudyObject.Patientdidntwanttocompletecorebio= 'true';
         offstudyObject.Patientdidntcontinueontreatmentarm=  'true';
         offstudyObject.Whypatientdidntcontinuetreatmentarm= 'Other';
         offstudyObject.Treatmentarmotherreason= '';
         offstudyObject.Patientdidnothavesurgery= 'true';
         offstudyObject.Patientdidnothavesurgeryreason= '';
         offstudyObject.PatientDied= 'true';
         offstudyObject.Didpatientwithdrawforsurvival= 'Yes';
         offstudyObject.Patientwithdrewforspecimens= 'Yes';
         offstudyObject.CompletedDate = '10/10/2012';
         offstudyObject.Status = 'Accepted';
    
    
         List<OffStudyCRF> lstOffStudy = new List<OffStudyCRF>();
         lstOffStudy.add(offstudyObject);
    
         TestHarnessService harnessObject = new TestHarnessService();
         harnessObject.createOffStudy(inst1.Id, site1.Id, trial1.Id,lstOffStudy);  



         //=============================== BEGINING OF "createNolongLosttoFollowup"=============


         NolongLosttoFollowupCRF nolonglostObject = new NolongLosttoFollowupCRF();
         nolonglostObject.PatientId = 'ASC002';
         nolonglostObject.NewInformation= 'Survial status only. Patient is no longer lost to survial follow-up';
         nolonglostObject.SurvialStatus= 'Alive';
         nolonglostObject.lastalivedeathdate= '10/10/2012';
         nolonglostObject.CompletedDate = '10/10/2012';
         nolonglostObject.Status = 'Accepted';
    
         List<NolongLosttoFollowupCRF> lstNoLongLost = new List<NolongLosttoFollowupCRF>();
         lstNoLongLost.add(nolonglostObject);
    
         harnessObject.createNolongLosttoFollowup(inst1.Id, site1.Id, trial1.Id,lstNoLongLost);  
       
     }
  }
  
       @isTest static void myUnitTest9() {
          // TO DO: implement unit test
      
        List<User> lstSiteUser = [Select u.IsActive, u.Id From User u where IsActive = true and Profile.Name = 'System Administrator'];
        System.runAs ( lstSiteUser[0] ) {
          
        List<RecordType> recordT = [Select r.Name, r.Id From RecordType r where SobjectType = 'Account' and Name='Institution'];
      
        Account inst1 = new Account();
        inst1.Name = 'test Institute 1';
        inst1.RecordTypeId = recordT[0].Id;
        insert inst1;
          
        Code_Master__c snomedObject = new Code_Master__c();
        snomedObject.Variable_Description__c = 'test';
        snomedObject.IsReportColumn__c = true;
        snomedObject.Display_Order__c = 3.0;
        insert snomedObject;
      
        Trial__c trial1 = new Trial__c();
        trial1.Name = 'test trial';
        insert trial1;
      
        Site__c site1 = new Site__c();
        site1.Name = 'test site1';
        site1.Type__c = 'test type';
        site1.Institute__c = inst1.Id;
        insert site1;
      
        Patient_Custom__c pc = new Patient_Custom__c();
        pc.First_Name__c = 'test';
        pc.Last_Name__c = 'test2';
        pc.Gender__c = 'Male';
        pc.Birthdate__c = date.newInstance(1987, 7, 7);
        pc.Race__c = 'White';
        pc.Ethnicity__c = 'Not Hispanic or Latino';
        pc.Institution__c = inst1.Id;
        pc.Medical_Record_Number__c = '3434';
        pc.TestHarnessId__c = 'ASC002';
        pc.IsTestHarnessPatient__c = true;
        insert pc;
      
        Site_Trial__c siteObject = new Site_Trial__c();
        siteObject.Site__c = site1.Id;
        siteObject.Trial__c = trial1.Id;
        siteObject.User__c = 'Site';
        insert siteObject;
      
        TrialPatient__c tp = new TrialPatient__c();
        tp.Patient_Id__c = pc.Id;
        tp.Trial_Id__c = trial1.Id;
        tp.Site__c = site1.Id;
        insert tp;       
         
         //=============================== BEGINING OF "createLosttoFollowup"=============

          LosttoFollowupCRF losttofollowupObject = new LosttoFollowupCRF();
           losttofollowupObject.PatientId = 'ASC002';
            losttofollowupObject.Lastcontactbefore2yrs= 'true';
            losttofollowupObject.Dateoflastcontact= '10/10/2012';
            losttofollowupObject.SocialSecDeathIndexResearch = 'true';
            losttofollowupObject.SocialSecDeathIndexResearchDate = '10/10/2012';
            losttofollowupObject.Sendcertifiedregisteredltrtoknown = 'true';
            losttofollowupObject.SendcertifiedregisteredltrDATE = '10/10/2012';
            losttofollowupObject.SendcertifiedregisteredltrResponse = 'Letter returned unclaimed or marked addressee unknown';
            losttofollowupObject.CompletedDate = '10/10/2012';
          losttofollowupObject.Status = 'Accepted';
   
   
           List<LosttoFollowupCRF> lstLosttoFollowup = new List<LosttoFollowupCRF>();
          lstLosttoFollowup.add(losttofollowupObject);
   
           TestHarnessService harnessObject = new TestHarnessService();
           harnessObject.createLosttoFollowup(inst1.Id, site1.Id, trial1.Id,lstLosttoFollowup); 


       //=============================== BEGINING OF "createLabandTest"=============

        LabandTestCRF labandtestObject = new LabandTestCRF();
         labandtestObject.PatientId = 'ASC002';
         labandtestObject.CollectionDate = '10/10/2012';
         labandtestObject.Leukocytes = 'true';
         labandtestObject.LeukocytesResult = '10';
         labandtestObject.LeukocytesInstitutionalReferenceRange = '100';
         labandtestObject.AbsoluteNeutrophilCountANC = 'true';
         labandtestObject.AbsoluteNeutrophilCountANCResult = '10';
         labandtestObject.ANCIndustrialReferenceRange = '100';
         labandtestObject.Platelets = 'true';
         labandtestObject.PlateletsResult = '10';
         labandtestObject.PlateletsInstitutionalReferenceRange = '100';
         labandtestObject.TotalBilirubin = 'true';
         labandtestObject.TotalBilirubinResult = '10';
         labandtestObject.TotalBilirubinInstitutionalReference = '100';
         labandtestObject.AST = 'true';
         labandtestObject.ASTResult = '10';
         labandtestObject.ASTInstitutionalReferenceRange = '100';
         labandtestObject.ALT = 'true';
         labandtestObject.ALTResult = '10';
         labandtestObject.ALTInstitutionalReferenceRange = '100';
         labandtestObject.Creatinine = 'true';
         labandtestObject.CreatinineResult = '10';
         labandtestObject.CreatinineInstitutionalReferenceRange = '100';
         labandtestObject.MUGAScan = 'true';
         labandtestObject.MUGAScanDate = '10/10/2012';
         labandtestObject.MUGAScanLVEF = '10';
         labandtestObject.MUGAInstitutionalLowerLimitofNormal = '10';
         labandtestObject.CardiacEcho = 'true';
         labandtestObject.CardiacEchoDate = '10/10/2012';
         labandtestObject.CardiacEchoLVEF = '10';
         labandtestObject.CardiacEchoInstitutionalLowerLimit = '10';
         labandtestObject.CollectionDate1 = '10/10/2012';
         labandtestObject.CompletedDate = '10/10/2012';
         labandtestObject.Status = 'Accepted';
   
   
         List<LabandTestCRF> lstLabandTest = new List<LabandTestCRF>();
         lstLabandTest.add(labandtestObject);
   
          
           harnessObject.createLabandTest(inst1.Id, site1.Id, trial1.Id,lstLabandTest); 

        }
      }
      @isTest static void myUnitTest10() {
        // TO DO: implement unit test
       
        List<User> lstSiteUser = [Select u.IsActive, u.Id From User u where IsActive = true and Profile.Name = 'System Administrator'];
        System.runAs ( lstSiteUser[0] ) {
           
        List<RecordType> recordT = [Select r.Name, r.Id From RecordType r where SobjectType = 'Account' and Name='Institution'];
       
        Account inst1 = new Account();
        inst1.Name = 'test Institute 1';
        inst1.RecordTypeId = recordT[0].Id; 
        insert inst1; 
           
        Code_Master__c snomedObject = new Code_Master__c();
        snomedObject.Variable_Description__c = 'test';
        snomedObject.IsReportColumn__c = true;
        snomedObject.Display_Order__c = 3.0;
        insert snomedObject;
       
        Trial__c trial1 = new Trial__c();
        trial1.Name = 'test trial';
        insert trial1;
       
        Site__c site1 = new Site__c();
        site1.Name = 'test site1';
        site1.Type__c = 'test type';
        site1.Institute__c = inst1.Id;
        insert site1;
       
        Patient_Custom__c pc = new Patient_Custom__c();
        pc.First_Name__c = 'test';
        pc.Last_Name__c = 'test2';
        pc.Gender__c = 'Male';
        pc.Birthdate__c = date.newInstance(1987, 7, 7);
        pc.Race__c = 'White';
        pc.Ethnicity__c = 'Not Hispanic or Latino';
        pc.Institution__c = inst1.Id;
        pc.Medical_Record_Number__c = '3434';
        pc.TestHarnessId__c = 'ASC002';
        pc.IsTestHarnessPatient__c = true;
        insert pc;
       
        Site_Trial__c siteObject = new Site_Trial__c();
        siteObject.Site__c = site1.Id;
        siteObject.Trial__c = trial1.Id;
        siteObject.User__c = 'Site';
        insert siteObject;
       
        TrialPatient__c tp = new TrialPatient__c();
        tp.Patient_Id__c = pc.Id;
        tp.Trial_Id__c = trial1.Id;
        tp.Site__c = site1.Id;
        insert tp;        
          
         //=============================== BEGINING OF "createResponseEvaluation"=============

        ResponseEvaluationCRF refObj = new ResponseEvaluationCRF();
       refObj.PatientId = 'ASC002';
       refObj.CRFId  = 'ASC002';
       refObj.ReportingPeriod = 'Baseline';
       refObj.Dateofclinicalassessment = '10/10/2012';
       refObj.DiseaseExtent = '2';
       refObj.Palpablenodes = 'Yes';
       refObj.Mattednodes = 'Yes';
       refObj.Nodesfixedtochestwall = 'Yes';
       refObj.Typeoflymphnodeinvolvement = 'Axillary';
       refObj.Sizeoflargestnode = '2';
       refObj.ClinicalStagingPeriod = 'Yes';
       refObj.ClinicallystagingperiodT = 'T4a';
       refObj.ClinicallystagingperiodN = 'N2a';
       refObj.ClinicallystagingperiodM = 'M1';
       refObj.CurrentStatusofT4Tumor = 'Chest wall';
       refObj.IsCandidateForConservationSurgery = 'No';
       refObj.ReasonNotConservationSurgeryCandidate = 'Other';
       refObj.OtherReason = '';
       refObj.ResponseStatus = 'Not adequately assessed';
       refObj.CompleteresponseCR = 'true';
       refObj.CompleteresponseCRDate = '10/10/2012';
       refObj.PartialresponsePR = 'true';
       refObj.PartialresponsePRDate = '10/10/2012';
       refObj.Newlocalregionalrecurrence = 'true';
       refObj.NewlocalregionalrecurrenceDate = '10/10/2012';
       refObj.Newdistantprogression = 'true';
       refObj.NewdistantprogressionDate = '10/10/2012';
       refObj.LocalRegional = 'Axillary Nodes';
       refObj.Distant = 'Other';
       refObj.OtherDistant = '';      
       refObj.CompletedDate = '10/10/2012';
       refObj.Status = 'Completed';
       
        List<ResponseEvaluationCRF> lstref = new List<ResponseEvaluationCRF>();
       lstref.add(refObj);
        
            TestHarnessService harnessObject = new TestHarnessService();
            harnessObject.createResponseEvaluation(inst1.Id, site1.Id, trial1.Id,lstref);  
        
        //================================BEGINING OF "createDiseaseAssessment"==============
        
        Disease_Assessment_CRF_REF daObj = new Disease_Assessment_CRF_REF();
        daObj.CRFId = 'ASC002';
        daObj.OClockPositionFrom = '1';
        daObj.OClockPositionTo = '1';
        daObj.Distancefromnipplecm = '2';
        daObj.LongestDiameter = '2';
        daObj.Clipplaced = 'Yes';
        
        List<Disease_Assessment_CRF_REF> lstda = new List<Disease_Assessment_CRF_REF>();
        lstda.add(daObj);
        
        harnessObject.createDiseaseAssessment(inst1.Id, site1.Id, trial1.Id,lstda);  
         
      }
   }
        @isTest static void myUnitTest11() {
        // TO DO: implement unit test
       
        List<User> lstSiteUser = [Select u.IsActive, u.Id From User u where IsActive = true and Profile.Name = 'System Administrator'];
        System.runAs ( lstSiteUser[0] ) {
           
        List<RecordType> recordT = [Select r.Name, r.Id From RecordType r where SobjectType = 'Account' and Name='Institution'];
       
        Account inst1 = new Account();
        inst1.Name = 'test Institute 1';
        inst1.RecordTypeId = recordT[0].Id; 
        insert inst1; 
           
        Code_Master__c snomedObject = new Code_Master__c();
        snomedObject.Variable_Description__c = 'test';
        snomedObject.IsReportColumn__c = true;
        snomedObject.Display_Order__c = 3.0;
        insert snomedObject;
       
        Trial__c trial1 = new Trial__c();
        trial1.Name = 'test trial';
        insert trial1;
       
        Site__c site1 = new Site__c();
        site1.Name = 'test site1';
        site1.Type__c = 'test type';
        site1.Institute__c = inst1.Id;
        insert site1;
       
        Patient_Custom__c pc = new Patient_Custom__c();
        pc.First_Name__c = 'test';
        pc.Last_Name__c = 'test2';
        pc.Gender__c = 'Male';
        pc.Birthdate__c = date.newInstance(1987, 7, 7);
        pc.Race__c = 'White';
        pc.Ethnicity__c = 'Not Hispanic or Latino';
        pc.Institution__c = inst1.Id;
        pc.Medical_Record_Number__c = '3434';
        pc.TestHarnessId__c = 'ASC002';
        pc.IsTestHarnessPatient__c = true;
        insert pc;
       
        Site_Trial__c siteObject = new Site_Trial__c();
        siteObject.Site__c = site1.Id;
        siteObject.Trial__c = trial1.Id;
        siteObject.User__c = 'Site';
        insert siteObject;
       
        TrialPatient__c tp = new TrialPatient__c();
        tp.Patient_Id__c = pc.Id;
        tp.Trial_Id__c = trial1.Id;
        tp.Site__c = site1.Id;
        insert tp;        
          
         //=============================== BEGINING OF "createChemoSummary"=============

        ChemoSummaryCRF csfObj = new ChemoSummaryCRF();
        csfObj.PatientId = 'ASC002';
        csfObj.CRFId  = 'ASC002';
        csfObj.FirstDateofTaxaneTherapy = '10/10/2012';
        csfObj.LastDateofTaxaneTherapy = '10/10/2012';
        csfObj.TaxaneRegimenTreatmentEndReasons = 'Disease progression, relapse during active treatment';
        csfObj.OtherReason = '';
        csfObj.FirstDateofAnthracyclineTherapy = '10/10/2012';
        csfObj.LastDateofAnthracyclineTherapy = '10/10/2012';
        csfObj.AnthracyclineRegimenTreatmentEndReason = 'Toxicity/side effects/complications';
        csfObj.OtherReason1 = '';       
        csfObj.FirstDateofInvestigationalTherapy = '10/10/2012';
        csfObj.LastDateofInvestigationalTherapy = '10/10/2012';
        csfObj.InvestigationalRegimenTreatmentEndReason = 'Patient withdrawal or refusal prior to beginning protocol therapy';
        csfObj.OtherReason2 = '';            
        csfObj.CompletedDate = '10/10/2012';
        csfObj.Status = 'Completed';
       
        List<ChemoSummaryCRF> lstcsf = new List<ChemoSummaryCRF>();
        lstcsf.add(csfObj);
        
           TestHarnessService harnessObject = new TestHarnessService();
           harnessObject.createChemoSummary(inst1.Id, site1.Id, trial1.Id,lstcsf);  
        
        //================================BEGINING OF "createChemoSummaryRegimen"==============
        
        ChemoSummaryRegimen_OSP_CRF csrObj = new ChemoSummaryRegimen_OSP_CRF();
        csrObj.CRFId = 'ASC002';
        csrObj.FirstDateofTherapy = '10/10/2012';
        csrObj.LastDateofTherapy  = '10/10/2012';
        csrObj.TreatmentEndReasons = 'Treatment completed per protocol criteria';
        csrObj.OtherReason = '';
             
        List<ChemoSummaryRegimen_OSP_CRF> lstcsr = new List<ChemoSummaryRegimen_OSP_CRF>();
        lstcsr.add(csrObj);
        
        harnessObject.createChemoSummaryRegimen(inst1.Id, site1.Id, trial1.Id,lstcsr);  
         
      }
   }
       @isTest static void myUnitTest12() {
        // TO DO: implement unit test
       
        List<User> lstSiteUser = [Select u.IsActive, u.Id From User u where IsActive = true and Profile.Name = 'System Administrator'];
        System.runAs ( lstSiteUser[0] ) {
           
        List<RecordType> recordT = [Select r.Name, r.Id From RecordType r where SobjectType = 'Account' and Name='Institution'];
       
        Account inst1 = new Account();
        inst1.Name = 'test Institute 1';
        inst1.RecordTypeId = recordT[0].Id; 
        insert inst1; 
           
        Code_Master__c snomedObject = new Code_Master__c();
        snomedObject.Variable_Description__c = 'test';
        snomedObject.IsReportColumn__c = true;
        snomedObject.Display_Order__c = 3.0;
        insert snomedObject;
       
        Trial__c trial1 = new Trial__c();
        trial1.Name = 'test trial';
        insert trial1;
       
        Site__c site1 = new Site__c();
        site1.Name = 'test site1';
        site1.Type__c = 'test type';
        site1.Institute__c = inst1.Id;
        insert site1;
       
        Patient_Custom__c pc = new Patient_Custom__c();
        pc.First_Name__c = 'test';
        pc.Last_Name__c = 'test2';
        pc.Gender__c = 'Male';
        pc.Birthdate__c = date.newInstance(1987, 7, 7);
        pc.Race__c = 'White';
        pc.Ethnicity__c = 'Not Hispanic or Latino';
        pc.Institution__c = inst1.Id;
        pc.Medical_Record_Number__c = '3434';
        pc.TestHarnessId__c = 'ASC002';
        pc.IsTestHarnessPatient__c = true;
        insert pc;
       
        Site_Trial__c siteObject = new Site_Trial__c();
        siteObject.Site__c = site1.Id;
        siteObject.Trial__c = trial1.Id;
        siteObject.User__c = 'Site';
        insert siteObject;
       
        TrialPatient__c tp = new TrialPatient__c();
        tp.Patient_Id__c = pc.Id;
        tp.Trial_Id__c = trial1.Id;
        tp.Site__c = site1.Id;
        insert tp;        
          
         //=============================== BEGINING OF "createProtocolViolation"=============

         ProtocolViolationCRF ProtocolViolation = new ProtocolViolationCRF();
         ProtocolViolation.PatientId = 'ASC002';
         ProtocolViolation.DateOfProtocolViolation = '10/10/2012';
         ProtocolViolation.Medicationnoncompliance = 'true';
         ProtocolViolation.Visitnoncomplicance = 'true';
         ProtocolViolation.Onstudyprocedurerequiredbyprotocol = 'true';
         ProtocolViolation.Incorrecttherapygiventopatient = 'true';
         ProtocolViolation.Screeningandonstudytestlabdone = 'true';
         ProtocolViolation.Screeningprocedurerequired = 'true';
         ProtocolViolation.Eligibilitycriteriaexception = 'true';
         ProtocolViolation.Enrollmentofineligeligibleiblepatient = 'true';
         ProtocolViolation.Patientbecamepregnantpriortosurgery = 'true';
         ProtocolViolation.OtherViolationCheckbox = 'true';
         ProtocolViolation.OtherTypeofViolation = '';
         ProtocolViolation.Narrativedescription = '';
         ProtocolViolation.PatientRemainsonStudy = 'true';
         ProtocolViolation.Patientwithdrawn = 'true';
         ProtocolViolation.OtherActionCheckbox = 'true';
         ProtocolViolation.OtherActionTaken = '';
         ProtocolViolation.LocalIRBNotified = 'No';        
         ProtocolViolation.CompletedDate = '10/10/2012';
         ProtocolViolation.Status = 'Accepted';
    
    
         List<ProtocolViolationCRF> lstProtocolViolation = new List<ProtocolViolationCRF>();
         lstProtocolViolation.add(ProtocolViolation);
    
         TestHarnessService harnessObject = new TestHarnessService();
         harnessObject.createProtocolViolation(inst1.Id, site1.Id, trial1.Id,lstProtocolViolation);  


        }
      }
       
       @isTest static void myUnitTest13() {
        // TO DO: implement unit test
       
        List<User> lstSiteUser = [Select u.IsActive, u.Id From User u where IsActive = true and Profile.Name = 'System Administrator'];
        System.runAs ( lstSiteUser[0] ) {
           
        List<RecordType> recordT = [Select r.Name, r.Id From RecordType r where SobjectType = 'Account' and Name='Institution'];
       
        Account inst1 = new Account();
        inst1.Name = 'test Institute 1';
        inst1.RecordTypeId = recordT[0].Id; 
        insert inst1; 
           
        Code_Master__c snomedObject = new Code_Master__c();
        snomedObject.Variable_Description__c = 'test';
        snomedObject.IsReportColumn__c = true;
        snomedObject.Display_Order__c = 3.0;
        insert snomedObject;
       
        Trial__c trial1 = new Trial__c();
        trial1.Name = 'test trial';
        insert trial1;
       
        Site__c site1 = new Site__c();
        site1.Name = 'test site1';
        site1.Type__c = 'test type';
        site1.Institute__c = inst1.Id;
        insert site1;
       
        Patient_Custom__c pc = new Patient_Custom__c();
        pc.First_Name__c = 'test';
        pc.Last_Name__c = 'test2';
        pc.Gender__c = 'Male';
        pc.Birthdate__c = date.newInstance(1987, 7, 7);
        pc.Race__c = 'White';
        pc.Ethnicity__c = 'Not Hispanic or Latino';
        pc.Institution__c = inst1.Id;
        pc.Medical_Record_Number__c = '3434';
        pc.TestHarnessId__c = 'ASC002';
        pc.IsTestHarnessPatient__c = true;
        insert pc;
       
        Site_Trial__c siteObject = new Site_Trial__c();
        siteObject.Site__c = site1.Id;
        siteObject.Trial__c = trial1.Id;
        siteObject.User__c = 'Site';
        insert siteObject;
       
        TrialPatient__c tp = new TrialPatient__c();
        tp.Patient_Id__c = pc.Id;
        tp.Trial_Id__c = trial1.Id;
        tp.Site__c = site1.Id;
        insert tp;        
          
         //=============================== BEGINING OF "createAEForm"=============

        AEFormCRF aeObj= new AEFormCRF();
        aeObj.PatientId = 'ASC002';
        aeObj.CRFId  = 'ASC002';
        aeObj.VisitDate = '10/10/2012';
        aeObj.PatientHospitalized = 'true';
        aeObj.caAERSreportfiled = 'true';
        aeObj.CompletedDate = '10/10/2012';
        aeObj.Status = 'Completed';
       
        List<AEFormCRF> lstae = new List<AEFormCRF>();
        lstae.add(aeObj);
        
        TestHarnessService harnessObject = new TestHarnessService();
        harnessObject.createAEForm(inst1.Id, site1.Id, trial1.Id,lstae);  
        
        //================================BEGINING OF "createToxicity"==============
        
        Toxicity_OSP_CRF toxObj = new Toxicity_OSP_CRF();
        toxObj.CRFId = 'ASC002';
        toxObj.SymptomStatus = 'Yes';
        toxObj.SymptomMasters = 'a0sc0000000NLk4AAG';
        toxObj.ToxicityAgent = 'a0tc0000001kcrnAAA';
        toxObj.ToxicityOther = '';
        toxObj.ToxicityStatus = 'Yes';
        toxObj.Grade = '2 - Moderately hypocellular or >25 - <50% reduction from normal cellularity for age';
        toxObj.Attribution = '2 - Unlikely';
        toxObj.Waseventlifethreatning = 'true';
        toxObj.Dideventrequiredhospitalization = 'true';
        toxObj.Resultpersistentsignificantdisability = 'true';
        toxObj.Resultconginentalabnormalitydefect = 'true';
        toxObj.Didtheinvestigatorfindeventunusual = 'true';
        toxObj.Dideventresultindeath = 'false';
        toxObj.OnsetDate = '10/10/2012';
        toxObj.SAE = 'Yes';
        toxObj.Resolved = 'true';
        toxObj.AEEndDate = '10/10/2012';
        toxObj.PatientComplaint = 'test';
             
        List<Toxicity_OSP_CRF> lsttox = new List<Toxicity_OSP_CRF>();
        lsttox.add(toxObj);
        
        harnessObject.createToxicity(inst1.Id, site1.Id, trial1.Id,lsttox);  
         
      }
   }
   
       @isTest static void myUnitTest14() {
        // TO DO: implement unit test
       
        List<User> lstSiteUser = [Select u.IsActive, u.Id From User u where IsActive = true and Profile.Name = 'System Administrator'];
        System.runAs ( lstSiteUser[0] ) {
           
        List<RecordType> recordT = [Select r.Name, r.Id From RecordType r where SobjectType = 'Account' and Name='Institution'];
       
        Account inst1 = new Account();
        inst1.Name = 'test Institute 1';
        inst1.RecordTypeId = recordT[0].Id; 
        insert inst1; 
           
        Code_Master__c snomedObject = new Code_Master__c();
        snomedObject.Variable_Description__c = 'test';
        snomedObject.IsReportColumn__c = true;
        snomedObject.Display_Order__c = 3.0;
        insert snomedObject;
       
        Trial__c trial1 = new Trial__c();
        trial1.Name = 'test trial';
        insert trial1;
       
        Site__c site1 = new Site__c();
        site1.Name = 'test site1';
        site1.Type__c = 'test type';
        site1.Institute__c = inst1.Id;
        insert site1;
       
        Patient_Custom__c pc = new Patient_Custom__c();
        pc.First_Name__c = 'test';
        pc.Last_Name__c = 'test2';
        pc.Gender__c = 'Male';
        pc.Birthdate__c = date.newInstance(1987, 7, 7);
        pc.Race__c = 'White';
        pc.Ethnicity__c = 'Not Hispanic or Latino';
        pc.Institution__c = inst1.Id;
        pc.Medical_Record_Number__c = '3434';
        pc.TestHarnessId__c = 'ASC002';
        pc.IsTestHarnessPatient__c = true;
        insert pc;
       
        Site_Trial__c siteObject = new Site_Trial__c();
        siteObject.Site__c = site1.Id;
        siteObject.Trial__c = trial1.Id;
        siteObject.User__c = 'Site';
        insert siteObject;
       
        TrialPatient__c tp = new TrialPatient__c();
        tp.Patient_Id__c = pc.Id;
        tp.Trial_Id__c = trial1.Id;
        tp.Site__c = site1.Id;
        insert tp;        
          
         //=============================== BEGINING OF "createFollowupForm"=============

        FollowupCRF ffObj = new FollowupCRF();
        ffObj.PatientId = 'ASC002';
        ffObj.CRFId  = 'ASC002';
        ffObj.StartDate = '10/10/2012';
        ffObj.EndDate = '10/10/2012';
        ffObj.Patientdocclinialassessment = 'true';
        ffObj.ClinicalassessmentDate = '10/10/2012';
        ffObj.SurvivalStatus = 'Alive';
        ffObj.PatientDiagnoseWithNew = 'true';
        ffObj.Dates = '10/10/2012';
        ffObj.Surgery = 'true';
        ffObj.SurgeryDetails = 'Test';
        ffObj.Chemotherapy = 'true';
        ffObj.ChemotherapyDetails = 'Test';
        ffObj.RadiationTherapy = 'true';
        ffObj.RadiationTherapyDetails = 'Test';
        ffObj.HormoneTherapy = 'true'; 
        ffObj.HormoneTherapyDetails = 'Test';
        ffObj.CauseofDeath = 'Due to this disease';
        ffObj.DescribeCauseOfDeath = '';
        ffObj.patientdiagnosedlocalprogression= 'true';
        ffObj.LocalprogressionDate = '10/10/2012';
        ffObj.patientdiagnoseddistantprogression = 'true';
        ffObj.DistantprogressionDate = '10/10/2012';
        ffObj.Recurrenceprogressioninformation = 'Clinical Exam';
        ffObj.Local = 'Axillary Nodes';
        ffObj.Distant = 'Distant Lymph Nodes';
        ffObj.Other = 'Test';
        ffObj.Patientreceivedadjuvanttherapy = 'true';
        ffObj.RadiationTherapyStartDate = '10/10/2012';
        ffObj.RadiationTherapyEndDate = '10/10/2012';
        ffObj.LongTermTherapyforprimaryTrial = 'true';
        ffObj.patienthaveamenstrualperiod = 'true';
        ffObj.DateofLastMenstrualperiodUKData12M = 'true';
        ffObj.DateofLastMenstrualperiod = '10/10/2012';
        ffObj.OnEstrogenReplacement = 'true';
        ffObj.OnEstrogenReplacementMonths = '2';
        ffObj.OnEstrogenReplacementYears = '2';
        ffObj.Bilateraloophorectomy = 'true';
        ffObj.BilateraloophorectomyDate = '10/10/2012';
        ffObj.Hysterectomy = 'true';
        ffObj.HysterectomyDate = '10/10/2012';
        ffObj.Menopausalstatus = 'Above categories not applicable AND Age < 50';
        ffObj.CompletedDate = '10/10/2012';
        ffObj.Status = 'Completed';
       
        List<FollowupCRF> lstff = new List<FollowupCRF>();
       lstff.add(ffObj);
        
            TestHarnessService harnessObject = new TestHarnessService();
            harnessObject.createFollowupForm(inst1.Id, site1.Id, trial1.Id,lstff);  
        
        //================================BEGINING OF "createTherapyReceived"==============
        
        TherapyReceivedCRF trObj = new TherapyReceivedCRF();
        trObj.CRFId = 'ASC002';
        trObj.Therapy = 'Tamoxifen';
        trObj.Detail = '';
        trObj.StartDateDatePerformed = '10/10/2012';
        trObj.EndDate = '10/10/2012';
        
        List<TherapyReceivedCRF> lsttr = new List<TherapyReceivedCRF>();
        lsttr.add(trObj);
        
        harnessObject.createTherapyReceived(inst1.Id, site1.Id, trial1.Id,lsttr);  

      //================================BEGINING OF "createIrradiatedSite"==============
        
        IrradiatedSiteCRF isObj = new IrradiatedSiteCRF();
        isObj.CRFId = 'ASC002';
        isObj.Site = 'Boost';
        isObj.Laterality = 'Left';
        isObj.DoseperFXcGy = '10';
        isObj.TotalFX= '2';
        isObj.TotaldosecGyAP = '17'; 
        
        List<IrradiatedSiteCRF> lstis = new List<IrradiatedSiteCRF>();
        lstis.add(isObj);
        
        harnessObject.createIrradiatedSite(inst1.Id, site1.Id, trial1.Id,lstis);  
         
      }
   }
   
        @isTest static void myUnitTest15() {
        // TO DO: implement unit test
       
        List<User> lstSiteUser = [Select u.IsActive, u.Id From User u where IsActive = true and Profile.Name = 'System Administrator'];
        System.runAs ( lstSiteUser[0] ) {
           
        List<RecordType> recordT = [Select r.Name, r.Id From RecordType r where SobjectType = 'Account' and Name='Institution'];
       
        Account inst1 = new Account();
        inst1.Name = 'test Institute 1';
        inst1.RecordTypeId = recordT[0].Id; 
        insert inst1; 
           
        Code_Master__c snomedObject = new Code_Master__c();
        snomedObject.Variable_Description__c = 'test';
        snomedObject.IsReportColumn__c = true;
        snomedObject.Display_Order__c = 3.0;
        insert snomedObject;
       
        Trial__c trial1 = new Trial__c();
        trial1.Name = 'test trial';
        insert trial1;
       
        Site__c site1 = new Site__c();
        site1.Name = 'test site1';
        site1.Type__c = 'test type';
        site1.Institute__c = inst1.Id;
        insert site1;
       
        Patient_Custom__c pc = new Patient_Custom__c();
        pc.First_Name__c = 'test';
        pc.Last_Name__c = 'test2';
        pc.Gender__c = 'Male';
        pc.Birthdate__c = date.newInstance(1987, 7, 7);
        pc.Race__c = 'White';
        pc.Ethnicity__c = 'Not Hispanic or Latino';
        pc.Institution__c = inst1.Id;
        pc.Medical_Record_Number__c = '3434';
        pc.TestHarnessId__c = 'ASC002';
        pc.IsTestHarnessPatient__c = true;
        insert pc;
       
        Site_Trial__c siteObject = new Site_Trial__c();
        siteObject.Site__c = site1.Id;
        siteObject.Trial__c = trial1.Id;
        siteObject.User__c = 'Site';
        insert siteObject;
       
        TrialPatient__c tp = new TrialPatient__c();
        tp.Patient_Id__c = pc.Id;
        tp.Trial_Id__c = trial1.Id;
        tp.Site__c = site1.Id;
        insert tp;        
          
         //=============================== BEGINING OF "createBaselineSymptoms"=============

        BaselineSymptomsCRF bsObj = new BaselineSymptomsCRF();
        bsObj.PatientId = 'ASC002';
        bsObj.CRFId  = 'ASC002';
        bsObj.VisitDate = '10/10/2012';       
        bsObj.CompletedDate = '10/10/2012';
        bsObj.Status = 'Completed';
       
        List<BaselineSymptomsCRF> lstbsf = new List<BaselineSymptomsCRF>();
        lstbsf.add(bsObj);
        
        TestHarnessService harnessObject = new TestHarnessService();
        harnessObject.createBaselineSymptoms(inst1.Id, site1.Id, trial1.Id,lstbsf);  
        
        //================================BEGINING OF "createAllergy"==============
        
        Allergy_CRF_BSF aObj = new Allergy_CRF_BSF();
        aObj.CRFId = 'ASC002';
        aObj.AllergyType = 'Non-Drug';
        aObj.OtherAllergy = '';
        aObj.Allergies = 'a0xc0000000BhPfAAK';
        aObj.Reactions = 'Anaphylaxis';
        aObj.OtherReactions = '10/10/2012';
        aObj.Severity = '1-Mild';
        aObj.Yearfirstseen = '2012';
        aObj.FormName = 'Baseline Symptoms Form(Allergies)';
        
        List<Allergy_CRF_BSF> lsta = new List<Allergy_CRF_BSF>();
        lsta.add(aObj);
        
        harnessObject.createAllergy(inst1.Id, site1.Id, trial1.Id,lsta);  

        //================================BEGINING OF "createBaselineCondition"==============
        
        BaselineCondition_OSP_CRF bcObj = new BaselineCondition_OSP_CRF();
        bcObj.CRFId = 'ASC002';
        bcObj.DiagnosisType = 'Condition';
        bcObj.OtherDaignosis = '';
        bcObj.Daignosis = 'a14c00000006ufqAAA';
        bcObj.SeverityGrade = '2-Moderate';
        bcObj.Attribution = '0-Baseline'; 
        bcObj.OnsetMonth = '10';
        bcObj.OnsetDay = '10';
        bcObj.OnsetYear = '2012';
        bcObj.Resolved = 'Yes';
        bcObj.EndMonth = '10';
        bcObj.EndDay = '10';
        bcObj.EndYear = '2012';
        
        List<BaselineCondition_OSP_CRF> lstbc = new List<BaselineCondition_OSP_CRF>();
        lstbc.add(bcObj);
        
        harnessObject.createBaselineCondition(inst1.Id, site1.Id, trial1.Id,lstbc);  

       //================================BEGINING OF "createToxicities"==============
        
        Toxicity_OSP_CRF ToxObj = new Toxicity_OSP_CRF();
        ToxObj.CRFId = 'ASC002';
        ToxObj.SymptomStatus = 'Yes';
        ToxObj.SymptomMasters = 'a0sc0000000NLk4AAG';
        ToxObj.ToxicityAgent = 'a0tc0000001kcrmAAA';
        ToxObj.ToxicityOther = '';
        ToxObj.ToxicityStatus = 'Yes'; 
        ToxObj.Grade = 'Periods of asystole; non-urgent medical management indicated';
        ToxObj.Attribution = '2 - Unlikely';
        ToxObj.Waseventlifethreatning = 'true';
        ToxObj.Dideventrequiredhospitalization = 'true';
        ToxObj.Resultpersistentsignificantdisability = 'true';
        ToxObj.Resultconginentalabnormalitydefect = 'true';
        ToxObj.Didtheinvestigatorfindeventunusual = 'true';
        ToxObj.Dideventresultindeath = 'false';
        ToxObj.OnsetDate = '10/10/2012';
        ToxObj.SAE = 'Yes';
        ToxObj.Resolved = 'true';
        ToxObj.AEEndDate = '10/10/2012';
        ToxObj.PatientComplaint = 'test';
            
        List<Toxicity_OSP_CRF> lstTox = new List<Toxicity_OSP_CRF>();
        lstTox.add(ToxObj);
        
        harnessObject.createToxicities(inst1.Id, site1.Id, trial1.Id,lstTox);  
         
      }
   }


      @isTest static void myUnitTest16() {
        // TO DO: implement unit test
       
        List<User> lstSiteUser = [Select u.IsActive, u.Id From User u where IsActive = true and Profile.Name = 'System Administrator'];
        System.runAs ( lstSiteUser[0] ) {
           
        List<RecordType> recordT = [Select r.Name, r.Id From RecordType r where SobjectType = 'Account' and Name='Institution'];
       
        Account inst1 = new Account();
        inst1.Name = 'test Institute 1';
        inst1.RecordTypeId = recordT[0].Id; 
        insert inst1; 
           
        Code_Master__c snomedObject = new Code_Master__c();
        snomedObject.Variable_Description__c = 'test';
        snomedObject.IsReportColumn__c = true;
        snomedObject.Display_Order__c = 3.0;
        insert snomedObject;
       
        Trial__c trial1 = new Trial__c();
        trial1.Name = 'test trial';
        insert trial1;
       
        Site__c site1 = new Site__c();
        site1.Name = 'test site1';
        site1.Type__c = 'test type';
        site1.Institute__c = inst1.Id;
        insert site1;
       
        Patient_Custom__c pc = new Patient_Custom__c();
        pc.First_Name__c = 'test';
        pc.Last_Name__c = 'test2';
        pc.Gender__c = 'Male';
        pc.Birthdate__c = date.newInstance(1987, 7, 7);
        pc.Race__c = 'White';
        pc.Ethnicity__c = 'Not Hispanic or Latino';
        pc.Institution__c = inst1.Id;
        pc.Medical_Record_Number__c = '3434';
        pc.TestHarnessId__c = 'ASC002';
        pc.IsTestHarnessPatient__c = true;
        insert pc;
       
        Site_Trial__c siteObject = new Site_Trial__c();
        siteObject.Site__c = site1.Id;
        siteObject.Trial__c = trial1.Id;
        siteObject.User__c = 'Site';
        insert siteObject;
       
        TrialPatient__c tp = new TrialPatient__c();
        tp.Patient_Id__c = pc.Id;
        tp.Trial_Id__c = trial1.Id;
        tp.Site__c = site1.Id;
        insert tp;        
          
         //=============================== BEGINING OF "createPostSurgery"=============

        PostSurgeryCRF psfObj = new  PostSurgeryCRF(); 
        psfObj.PatientId = 'ASC002';
        psfObj.CRFId  = 'ASC002'; 
        psfObj.DateOfProcedure = '10/10/2012';
        psfObj.Surgeon = '003c0000005ebTkAAI';     
        psfObj.SurgeonOther = '';
        psfObj.TypeOfTumor = 'Multifocal Discrete Masses';
        psfObj.SizeofGrossMassHeight = '10';
        psfObj.SizeofGrossMassWidth = '10';
        psfObj.GrossMassMeasurementUnit = 'CM';
        psfObj.SizeofLargestGrossMassHeight = '10';
       psfObj.SizeofLargestGrossMassWidth = '10';
        psfObj.LargestGrossMassMeasurementUnit = 'CM';
        psfObj.Totalspanmultifocalgrossmassheight = '10';
        psfObj.Totalspanmultifocalgrossmasswidth = '10';
        psfObj.TotalSpanMeasurementUnit = 'CM';
        psfObj.Spanofgrosschangesheight = '10';
        psfObj.Spanofgrosschangeswidth = '10';
        psfObj.GrossChangesMeasurementUnit = 'CM';
        psfObj.Lymphnodedissectiondone = 'Yes';
        psfObj.AreCalcificationsPresent = 'Yes';
        psfObj.CalcificationDetails = 'Benign';
        psfObj.IsDCISPresent = 'Yes';
        psfObj.IsLCISPresent = 'Yes';
        psfObj.Isinvasivetumorpresent = 'Yes';
        psfObj.separatelysubmittedmargins = 'Yes';
        psfObj.InvasiveCAPresent = 'Yes';
        psfObj.InvasiveCAattruemargin = 'Yes';
        psfObj.InSituDiseasePresent = 'Yes';
        psfObj.InSituDiseaseAtTrueMargin = 'Yes';
        psfObj.OtherChangesPresent = 'Yes';
        psfObj.OtherChanges  = 'Papilloma';
        psfObj.OtherChange  = '';
        psfObj.pcr  = 'true';
        psfObj.PrimaryTumorBedArea = '';
        psfObj.OverallCenterCellularity = '10';
        psfObj.percentageofCAinSituDisease = '10';
        psfObj.Numberoflymphnodespositive = '';
        psfObj.Diameteroflargestmet = '';
        psfObj.RCBindex  = '10';
        psfObj.RCBClass = '';
        psfObj.CompletedDate = '10/10/2012';
        psfObj.Status = 'Completed';
        List<PostSurgeryCRF> lstpsf = new List<PostSurgeryCRF>();
        lstpsf.add(psfObj);
        
        TestHarnessService harnessObject = new TestHarnessService();
        harnessObject.createPostSurgery(inst1.Id, site1.Id, trial1.Id,lstpsf);  
        
        //================================BEGINING OF "createProcedureSpecimen"==============
        
        Procedure_Specimen_Detail_OSP_PSS psObj = new Procedure_Specimen_Detail_OSP_PSS();
        psObj.CRFId = 'ASC002';
        psObj.Procedure = 'a0Zc0000001GbNKEA0';
        psObj.Specimen = 'Main specimen with separately submitted margins';
        psObj.MainSpecimensubmittedforhistology = 'Yes';
        psObj.SingleSpecimentsubmittedforhistology = '';
        psObj.MediallateralGrossspecimensize = '10';
        psObj.Mediallateralsizeunit = 'CM';
        psObj.AnteriordeepGrossspecimensize = '10';
        psObj.Anteriordeepsizeunit = 'MM';
        psObj.SuperorinferiorGrossspecimensize = '10';
        psObj.Superorinferiorsizeunit = 'MM';
        psObj.TotalSlices = '20';
        psObj.SlicingMethod = 'Anterior/Posterior';
        psObj.SlicePlane1 = 'Ant-most';
        psObj.Slice1 = '2';
        psObj.Block1 = '2';
        psObj.SlicePlane2 = 'Post-most';
        psObj.Slice2 = '2';
        psObj.Block2 = '2';
        psObj.PerformingLab = 'a0ic00000019kD4AAI';
        psObj.Lymphnodetissuepresentinsample= 'true';        
        
        List<Procedure_Specimen_Detail_OSP_PSS> lstps = new List<Procedure_Specimen_Detail_OSP_PSS>();
        lstps.add(psObj);
        
        harnessObject.createProcedureSpecimen(inst1.Id, site1.Id, trial1.Id,lstps);  

        //================================BEGINING OF "createLymphNode"==============
        
        Lymph_Nodes_OSP_CRF lnObj = new Lymph_Nodes_OSP_CRF();
        lnObj.CRFId = 'ASC002';
        lnObj.Procedure= 'a0Zc0000001GbNKEA0';
        lnObj.Letarality = 'Left';
        lnObj.SentinelNodes = 'true';
        lnObj.Location = 'Unknown/not indicated';
        lnObj.Positive = '4'; 
        lnObj.Examined = '5';
        lnObj.MethodofDetection = 'Unknown';
        lnObj.SingleDetectionResult = 'true';
        lnObj.ClusterDetectionResult = 'true';
        lnObj.FocusDetectionResult = 'true';
        lnObj.NotreportedDetectionResult = 'false';
        lnObj.SizeofLargestTumor = 'Specify';
        lnObj.SpecificSizeofLargestTumor = '5';
        lnObj.TumorSizeMeasurementUnit = 'CM';
        lnObj.ExtramodalExtension = 'Yes';
        lnObj.AxillaryNodes = 'true';      
        lnObj.Positive1= '5';
        lnObj.Examined1 = '5';
        lnObj.MethodofDetection1 = 'Unknown';
        lnObj.SingleDetectionResult1 = 'true';
        lnObj.ClusterDetectionResult1= 'true';
        lnObj.FocusDetectionResult1 = 'true';
        lnObj.NotreportedDetectionResult1 = 'false';
        lnObj.SizeofLargestTumor1 = 'Specify';
        lnObj.SpecificSizeofLargestTumor1 = '4';
        lnObj.TumorSizeMeasurementUnit1 = 'MM';
        lnObj.ExtramodalExtension1 = 'Yes';
        lnObj.AdditionalNodes = 'true';
        lnObj.Location1 = 'Supraclavicular';
        lnObj.Positive2 = '10';
        lnObj.Examined2 = '10';
        lnObj.SizeofLargestTumor2 = 'Specify';
        lnObj.SpecificSizeofLargestTumor2 = '5';
        lnObj.TumorSizeMeasurementUnit2 = 'MM';
       lnObj.ExtramodalExtension2= 'Yes';      
        
        List<Lymph_Nodes_OSP_CRF> lstln = new List<Lymph_Nodes_OSP_CRF>();
        lstln.add(lnObj);
        
        harnessObject.createLymphNode(inst1.Id, site1.Id, trial1.Id,lstln);  

       //================================BEGINING OF "createReceptor"==============
        
       Receptors_OSP_CRF recObj = new Receptors_OSP_CRF();
        recObj.OSPId = 'ASC002';
        recObj.ERStatus = 'Negative';
        recObj.ERProporationScore = '2 (1%-10%)';
        recObj.ERIntensityScore = '1 (weak)';
        recObj.TotalScoreER = '3';
        recObj.PRStatus = 'Negative'; 
        recObj.PRProporationScore = '1 (less than 1%)';
        recObj.PRIntensityScore = '1 (weak)';
        recObj.TotalScorePR = '2';
        recObj.HER2neuMarkerStatus = 'Negative';
        recObj.DAKOHerceptest = '1';
        recObj.OtherIHCTest = 'Test';
        recObj.OtherIHCResult = 'Test';
        recObj.VentanaKit = '1';
        recObj.CB11 = '1';
        recObj.IHCTestNotDone = 'true';
        recObj.VentanaOncoprobe = '1';
        recObj.OtherFISHTest = 'Test';
        recObj.OtherFISHResults = 'Test';
        recObj.FISHTestNotDone = 'true';
        recObj.VysisPathVision = 'true';
        recObj.VysisPathVisionValue = 'Test';
        recObj.Letarality = 'Left';      
            
        List<Receptors_OSP_CRF> lstrec = new List<Receptors_OSP_CRF>();
        lstrec.add(recObj);
        
        harnessObject.createReceptor(inst1.Id, site1.Id, trial1.Id,lstrec);  

      //================================BEGINING OF "createStagingDetail"==============
        
       Staging_OSP_CRF sdObj = new Staging_OSP_CRF();
       sdObj.CRFId = 'ASC002';
       sdObj.Letarality = 'Left';
       sdObj.StagingModifierType = 'Clinical Staging';
       sdObj.Modifiermultipleprimary = 'false';
       sdObj.Modifierclassificationdone = 'true';
       sdObj.Modifierindicatesrecurrent = 'true'; 
       sdObj.Modifierdesignates = 'false';
       sdObj.TumorType = 'Tis';
       sdObj.NodeType = 'N0';
       sdObj.Metastasis = 'M0';
       sdObj.CalculatedStage = 'Stage 0';
       sdObj.CalculatedStageValue = 'TisN0M0';
       sdObj.AdjudicatedStage = 'Stage IA';
       sdObj.AdjudicatedBy = '003c000000LC5VmAAL';
       sdObj.T4Tumorfinalstatus = 'Skin only';             
            
        List<Staging_OSP_CRF> lstsd = new List<Staging_OSP_CRF>();
        lstsd.add(sdObj);
        
        harnessObject.createStagingDetail(inst1.Id, site1.Id, trial1.Id,lstsd); 
        
         //================================BEGINING OF "createProcedures"==============
        
       Procedure_OSP_PSS proObj = new Procedure_OSP_PSS();
       proObj.CRFId = 'ASC002';
       proObj.ProcedureName = 'Sentinel lymph node dissection';
       proObj.Laterality = 'Left';
      proObj.Location = 'Axillary (lymph node)';               
            
        List<Procedure_OSP_PSS> lstpro = new List<Procedure_OSP_PSS>();
        lstpro.add(proObj);
        
        harnessObject.createProcedures(inst1.Id, site1.Id, trial1.Id,lstpro);  

         //================================BEGINING OF "createDCISs"==============
        
        DCIS_OSP_CRF dcisObj = new DCIS_OSP_CRF();
       dcisObj.CRFId = 'ASC002';
        dcisObj.DCIS = '10';
        dcisObj.UnknownNotReported = 'false';
        dcisObj.TotalHistologicalSpan = '5';
       dcisObj.TotalHistologicalSpanMeasurementUnit = 'CM';
        dcisObj.Margin = 'Positive'; 
       dcisObj.ClosestMargin = 'Specify';
       dcisObj.SpecificClosestMargin = '5';
       dcisObj.SpecificClosestMarginMeasurementUnit = 'MM';
       dcisObj.PunctateNecrosis = 'true';
       dcisObj.Comedonecrosis = 'true';
       dcisObj.Papillary = 'true';
       dcisObj.Micropapillary = 'true';
       dcisObj.Necrosis = 'true';
       dcisObj.Cribiform = 'true';
       dcisObj.Cruciform = 'true'; 
        dcisObj.Clinging = 'true';
        dcisObj.Solid = 'true';
        dcisObj.Apocrine = 'true';      
        dcisObj.IntraCysticEncystedPapillary = 'true';
        dcisObj.Other = 'true';
        dcisObj.Otherifothermentiontypeintextbox = '';
        dcisObj.NuclearGrade = 'Grade I (low)';         
            
        List<DCIS_OSP_CRF> lstdcis = new List<DCIS_OSP_CRF>();
        lstdcis.add(dcisObj);
        
        harnessObject.createDCISs(inst1.Id, site1.Id, trial1.Id,lstdcis);  

         //================================BEGINING OF "createLCISs"==============
        
       LCIS_OSP_CRF lcisObj = new LCIS_OSP_CRF();
       lcisObj.CRFId = 'ASC002';
       lcisObj.LCIS = '5';
       lcisObj.UnknownNotReported = 'false';
       lcisObj.Totalhistologicalspan = '2';
       lcisObj.Totalhistologicalspanmeasurementunit = 'MM';
       lcisObj.HistologicalType = 'Classic';        
            
        List<LCIS_OSP_CRF> lstlcis = new List<LCIS_OSP_CRF>();
        lstlcis.add(lcisObj);
        
        harnessObject.createLCISs(inst1.Id, site1.Id, trial1.Id,lstlcis);  

         //================================BEGINING OF "createInvasiveTumors"==============
        
       InvasiveTumor_OSP_PSS itObj = new InvasiveTumor_OSP_PSS();
       itObj.CRFId = 'ASC002';
      itObj.Overallcancercellularity = '10';
       itObj.UnknownNotReported = 'false';
       itObj.TumorSizeHeight = '5';
       itObj.TumorSizeWidth = '5';
       itObj.TumorMeasurementUnit = 'MM'; 
       itObj.MultifocalTumor = 'Yes';
       itObj.Invasivemargins = 'Negative';
       itObj.ClosestMargin = 'Specifiy';
       itObj.SpecifyNo = '2';
      itObj.SpecifyUnits = 'MM';
       itObj.InvasiveDuctalCarcinomaNos = 'true';
       itObj.InvasiveLobularCarcinomaClassicType = 'true';
       itObj.InvasiveLobularCarcinomaAlveolarType = 'true';
       itObj.PleomorphicLobularCarcinoma = 'true';        
        itObj.TubulolobularCarcinoma = 'true';
        itObj.InvasiveCarcinomaMixedDuctalAndLobularType = 'true';
        itObj.TubularCarcinoma = 'true';
        itObj.MucinousCarcinoma = 'true';
        itObj.MedullaryCarcinoma = 'true';
        itObj.InvasivePapillaryCarcinoma = 'true';
        itObj.InvasiveCribiformCarcinoma = 'true';
        itObj.Other = 'true';
        itObj.Otherifothermentiontypeintextbox = '';
        itObj.NuclearGrade = 'Grade I (low)';
        itObj.MitoticCount = '2pt';
        itObj.TubulePapillaFormation = '1pt';
        itObj.TotalPoints = '';
        itObj.SBRGrade = '';
        itObj.LympaticVascularInvasion = 'None';
        itObj.DermalInvolvement = 'No';
        itObj.Muscleinvolvement = 'No';
        itObj.Evidenceoftherapeuticeffects = 'Yes';
        itObj.Otherchangespresent  = 'Yes';
               
            
        List<InvasiveTumor_OSP_PSS> lstit = new List<InvasiveTumor_OSP_PSS>();
        lstit.add(itObj);
        
        harnessObject.createInvasiveTumors(inst1.Id, site1.Id, trial1.Id,lstit);
          
         
      }
   }

        @isTest static void myUnitTest17() {
        // TO DO: implement unit test
       
        List<User> lstSiteUser = [Select u.IsActive, u.Id From User u where IsActive = true and Profile.Name = 'System Administrator'];
        System.runAs ( lstSiteUser[0] ) {
           
        List<RecordType> recordT = [Select r.Name, r.Id From RecordType r where SobjectType = 'Account' and Name='Institution'];
       
        Account inst1 = new Account();
        inst1.Name = 'test Institute 1';
        inst1.RecordTypeId = recordT[0].Id; 
        insert inst1; 
           
        Code_Master__c snomedObject = new Code_Master__c();
        snomedObject.Variable_Description__c = 'test';
        snomedObject.IsReportColumn__c = true;
        snomedObject.Display_Order__c = 3.0;
        insert snomedObject;
       
        Trial__c trial1 = new Trial__c();
        trial1.Name = 'test trial';
        insert trial1;
       
        Site__c site1 = new Site__c();
        site1.Name = 'test site1';
        site1.Type__c = 'test type';
        site1.Institute__c = inst1.Id;
        insert site1;
       
        Patient_Custom__c pc = new Patient_Custom__c();
        pc.First_Name__c = 'test';
        pc.Last_Name__c = 'test2';
        pc.Gender__c = 'Male';
        pc.Birthdate__c = date.newInstance(1987, 7, 7);
        pc.Race__c = 'White';
        pc.Ethnicity__c = 'Not Hispanic or Latino';
        pc.Institution__c = inst1.Id;
        pc.Medical_Record_Number__c = '3434';
        pc.TestHarnessId__c = 'ASC002';
        pc.IsTestHarnessPatient__c = true;
        insert pc;
       
        Site_Trial__c siteObject = new Site_Trial__c();
        siteObject.Site__c = site1.Id;
        siteObject.Trial__c = trial1.Id;
        siteObject.User__c = 'Site';
        insert siteObject;
       
        TrialPatient__c tp = new TrialPatient__c();
        tp.Patient_Id__c = pc.Id;
        tp.Trial_Id__c = trial1.Id;
        tp.Site__c = site1.Id;
        insert tp;        
          
         //=============================== BEGINING OF "createChemoTreatment"=============

        ChemoTreatmentCRF ctfsObj = new ChemoTreatmentCRF();
        ctfsObj.PatientId = 'ASC002';
        ctfsObj.CRFId  = 'ASC002';
        ctfsObj.Dateoftherapy = '10/10/2012';   
        ctfsObj.Cyclenumber = '1';
        ctfsObj.Didpatientgooffstudytreatment = 'true';
        ctfsObj.Patientweight = '10';
        ctfsObj.Patientheight = '10';           
        ctfsObj.CompletedDate = '10/10/2012';        
        ctfsObj.Status = 'Completed';
       
        List<ChemoTreatmentCRF> lstctf = new List<ChemoTreatmentCRF>();
        lstctf.add(ctfsObj);
        
        TestHarnessService harnessObject = new TestHarnessService();
        harnessObject.createChemoTreatment(inst1.Id, site1.Id, trial1.Id,lstctf);  
        
        //================================BEGINING OF "createChemoTherapyRegimen"==============
        
        ChemoTherapyRegimen_CRF_CTF ctrObj = new ChemoTherapyRegimen_CRF_CTF();
        ctrObj.CRFId = 'ASC002';
        ctrObj.Agent = 'a11c0000000s9D7';
        ctrObj.PrescribedDose = '10';
        ctrObj.TotalDoseAdministered = '10';
        ctrObj.Day = '1';
        ctrObj.DoseDelay = 'No';
        ctrObj.DoseMod = '10';
        ctrObj.Dosemodification = 'Other';
        ctrObj.OtherDoseModReason = '';
        ctrObj.Didpatientstopreceiving = 'true';
        ctrObj.Reasonwhypatientstoppedreceiving = 'Due to progression';
        ctrObj.OtherReasonPatientStopReceiving = '';
        ctrObj.OtherAgent = '';
        ctrObj.PrescribeddoseUnits = 'mg/m2';
        ctrObj.AdministereddoseUnits = 'mg';      
        
        List<ChemoTherapyRegimen_CRF_CTF> lstctr = new List<ChemoTherapyRegimen_CRF_CTF>();
        lstctr.add(ctrObj);
        
        harnessObject.createChemoTherapyRegimen(inst1.Id, site1.Id, trial1.Id,lstctr);  

        //================================BEGINING OF "createGrowthFactor"==============
        
        GrowthFactor_CRF_CTF gfObj = new GrowthFactor_CRF_CTF();
        gfObj.CRFId = 'ASC002';
        gfObj.Name = 'Neulasta';
        gfObj.Dose = '10';
        gfObj.TotalDose = '10';
        gfObj.Route = 'IV';
        gfObj.Notes = ''; 
        gfObj.isReceived= 'true';      
        
        List<GrowthFactor_CRF_CTF> lstgf = new List<GrowthFactor_CRF_CTF>();
        lstgf .add(gfObj);
        
        harnessObject.createGrowthFactor(inst1.Id, site1.Id, trial1.Id,lstgf);  

       //================================BEGINING OF "createConcomitantMedication"==============
        
        ConcomitantMedication_CRF_CTF cmObj = new ConcomitantMedication_CRF_CTF();
        cmObj.CRFId = 'ASC002';
        cmObj.Type = 'Other';
        cmObj.OtherMadication = '';
        cmObj.Medication = '';
        cmObj.StartYear = '10';
        cmObj.StartMonth = '10'; 
        cmObj.StartDay = '10';
        cmObj.EndYear = '10';
        cmObj.EndMonth = '10';
        cmObj.EndDay = '10';
        cmObj.DoseValue = '';
        cmObj.Dose = 'mcg';
        cmObj.Route = '';
        cmObj.Frequency = 'Once daily';    
            
        List<ConcomitantMedication_CRF_CTF> lstcm = new List<ConcomitantMedication_CRF_CTF>();
        lstcm.add(cmObj);
        
        harnessObject.createConcomitantMedication(inst1.Id, site1.Id, trial1.Id,lstcm);  
         
      }
   }


        
       @isTest static void ExceptionHandling() {
        // TO DO: implement unit test
        
        List<User> lstSiteUser = [Select u.IsActive, u.Id From User u where IsActive = true and id =: userinfo.getUserId()];
        System.runAs ( lstSiteUser[0] ) { 
            
        List<RecordType> recordT = [Select r.Name, r.Id From RecordType r where SobjectType = 'Account' and Name='Institution'];
        
        Code_Master__c snomedObject = new Code_Master__c();
        snomedObject.Variable_Description__c = 'test';
        snomedObject.IsReportColumn__c = true;
        snomedObject.Display_Order__c = 3.0;
        snomedObject.Name = 'Institution';
        insert snomedObject;
        
        Account inst1 = new Account();
        inst1.Name = 'test Institute 1';
        inst1.RecordTypeId = recordT[0].Id;  
        insert inst1;        
        
        Trial__c trial1 = new Trial__c();
        trial1.Name = 'test trial';
        insert trial1;
        
        Site__c site1 = new Site__c();
        site1.Name = 'test site1';
        site1.Type__c = 'test type';
        site1.Institute__c = inst1.Id;
        insert site1;
        
        Patient_Custom__c pc = new Patient_Custom__c();
        pc.First_Name__c = 'test';
        pc.Last_Name__c = 'test2';
        pc.Gender__c = 'Male';
        pc.Birthdate__c = date.newInstance(1987, 7, 7);
        pc.Race__c = 'White';
        pc.Ethnicity__c = 'Not Hispanic or Latino';
        pc.Institution__c = inst1.Id;
        pc.Medical_Record_Number__c = '3434';
        pc.TestHarnessId__c = 'ASC002';
        pc.IsTestHarnessPatient__c = true;
        insert pc;
        
        Site_Trial__c siteObject = new Site_Trial__c();
        siteObject.Site__c = site1.Id;
        siteObject.Trial__c = trial1.Id; 
        siteObject.User__c = 'Site';
        insert siteObject;
        
        TrialPatient__c tp = new TrialPatient__c();
        tp.Patient_Id__c = pc.Id;
        tp.Trial_Id__c = trial1.Id;
        tp.Site__c = site1.Id;
        insert tp;
        
        RandomizationTestingDetail__c randObj = new RandomizationTestingDetail__c();
        randObj.IsRandomized__c = true;
        randObj.Trial_Name__c = 'test trial';
        insert randObj;
        
        //========================LastName================================================
        Patient patbject1 = new Patient();
        patbject1.Gender = 'Male';
        patbject1.Birthdate = '7/7/1987';
        patbject1.Race = 'White';
        patbject1.Ethnicity = 'Not Hispanic or Latino';
        patbject1.TestHarnessId = 'ASC002';
        
        List<Patient> lstPatient1 = new List<Patient>(); // this indicates "patient" class
        lstPatient1.add(patbject1);
        
        TestHarnessService harnessObject = new TestHarnessService();
        harnessObject.createPatient(inst1.Id, site1.Id, trial1.Id,lstPatient1);
        
        harnessObject.getRandomizationResult('CreatedDate DESC'); // method "getRandomizationResult()" begins and ends here
        
        //=======================Birthdate==================================================
        Patient patbject2 = new Patient();
        patbject2.LastName = 'test';
        patbject2.Gender = 'Male';
        patbject2.Race = 'White';
        patbject2.Ethnicity = 'Not Hispanic or Latino';
        patbject2.TestHarnessId = 'ASC002';
        
        List<Patient> lstPatient2 = new List<Patient>(); // this indicates "patient" class
        lstPatient2.add(patbject2);
        
        TestHarnessService harnessObject1 = new TestHarnessService();
        harnessObject1.createPatient(inst1.Id, site1.Id, trial1.Id,lstPatient2);
      }
   } 
   
   @isTest static void ExceptionHandling2() {
        // TO DO: implement unit test
        
        List<User> lstSiteUser = [Select u.IsActive, u.Id From User u where IsActive = true and id =: userinfo.getUserId()];
        System.runAs ( lstSiteUser[0] ) { 
            
        List<RecordType> recordT = [Select r.Name, r.Id From RecordType r where SobjectType = 'Account' and Name='Institution'];
        
        Code_Master__c snomedObject = new Code_Master__c();
        snomedObject.Variable_Description__c = 'test';
        snomedObject.IsReportColumn__c = true;
        snomedObject.Display_Order__c = 3.0;
        snomedObject.Name = 'Institution';
        insert snomedObject;
        
        Account inst1 = new Account();
        inst1.Name = 'test Institute 1';
        inst1.RecordTypeId = recordT[0].Id;  
        insert inst1;        
        
        Trial__c trial1 = new Trial__c();
        trial1.Name = 'test trial';
        insert trial1;
        
        Site__c site1 = new Site__c();
        site1.Name = 'test site1';
        site1.Type__c = 'test type';
        site1.Institute__c = inst1.Id;
        insert site1;
        
        Patient_Custom__c pc = new Patient_Custom__c();
        pc.First_Name__c = 'test';
        pc.Last_Name__c = 'test2';
        pc.Gender__c = 'Male';
        pc.Birthdate__c = date.newInstance(1987, 7, 7);
        pc.Race__c = 'White';
        pc.Ethnicity__c = 'Not Hispanic or Latino';
        pc.Institution__c = inst1.Id;
        pc.Medical_Record_Number__c = '3434';
        pc.TestHarnessId__c = 'ASC002';
        pc.IsTestHarnessPatient__c = true;
        insert pc;
        
        Site_Trial__c siteObject = new Site_Trial__c();
        siteObject.Site__c = site1.Id;
        siteObject.Trial__c = trial1.Id; 
        siteObject.User__c = 'Site';
        insert siteObject;
        
        TrialPatient__c tp = new TrialPatient__c();
        tp.Patient_Id__c = pc.Id;
        tp.Trial_Id__c = trial1.Id;
        tp.Site__c = site1.Id;
        insert tp;
        
        RandomizationTestingDetail__c randObj = new RandomizationTestingDetail__c();
        randObj.IsRandomized__c = true;
        randObj.Trial_Name__c = 'test trial';
        insert randObj;
        
        //=========================="createRegistration" EXCEPTION begins here ==============
        
        PatientRegistration patRegObj = new PatientRegistration();
        patRegObj.patientId = 'ASC002';
        patRegObj.hasPatientParticipateInRepeatMRIScan = 'yes';
        patRegObj.completedDate = '7/7/1997';
        patRegObj.Status = 'Accepted';
        patRegObj.IRBApprovalDate = '8/8/1996';
        patRegObj.HIPPAConsentDate = '9/9/1987';
        patRegObj.ScreeningConsentDate = '10/10/1996';
        
        List<PatientRegistration> lstPatReg = new List<PatientRegistration>();
        lstPatReg.add(patRegObj);
        
        TestHarnessService harnessObject = new TestHarnessService();
        harnessObject.createRegistration(inst1.Id, site1.Id, trial1.Id,lstPatReg);
        
        //=========================reg date = future ==========================================
        
        PatientRegistration patRegObj1 = new PatientRegistration();
        patRegObj1.patientId = 'ASC002';
        patRegObj1.regDate = '7/8/2015';
        patRegObj1.hasPatientParticipateInRepeatMRIScan = 'yes';
        patRegObj1.completedDate = '7/7/1997';
        patRegObj1.Status = 'Accepted';
        patRegObj1.IRBApprovalDate = '8/8/1996';
        patRegObj1.HIPPAConsentDate = '9/9/1987';
        patRegObj1.ScreeningConsentDate = '10/10/1996';
        
        List<PatientRegistration> lstPatReg1 = new List<PatientRegistration>();
        lstPatReg1.add(patRegObj1);
        
        TestHarnessService harnessObject1 = new TestHarnessService();
        harnessObject1.createRegistration(inst1.Id, site1.Id, trial1.Id,lstPatReg1);
      }
   } 
   
   @isTest static void ExceptionHandling3() {
        // TO DO: implement unit test
        
        List<User> lstSiteUser = [Select u.IsActive, u.Id From User u where IsActive = true and id =: userinfo.getUserId()];
        System.runAs ( lstSiteUser[0] ) { 
            
        List<RecordType> recordT = [Select r.Name, r.Id From RecordType r where SobjectType = 'Account' and Name='Institution'];
        
        Code_Master__c snomedObject = new Code_Master__c();
        snomedObject.Variable_Description__c = 'test';
        snomedObject.IsReportColumn__c = true;
        snomedObject.Display_Order__c = 3.0;
        snomedObject.Name = 'Institution';
        insert snomedObject;
        
        Account inst1 = new Account();
        inst1.Name = 'test Institute 1';
        inst1.RecordTypeId = recordT[0].Id;  
        insert inst1;        
        
        Trial__c trial1 = new Trial__c();
        trial1.Name = 'test trial';
        insert trial1;
        
        Site__c site1 = new Site__c();
        site1.Name = 'test site1';
        site1.Type__c = 'test type';
        site1.Institute__c = inst1.Id;
        insert site1;
        
        Patient_Custom__c pc = new Patient_Custom__c();
        pc.First_Name__c = 'test';
        pc.Last_Name__c = 'test2';
        pc.Gender__c = 'Male';
        pc.Birthdate__c = date.newInstance(1987, 7, 7);
        pc.Race__c = 'White';
        pc.Ethnicity__c = 'Not Hispanic or Latino';
        pc.Institution__c = inst1.Id;
        pc.Medical_Record_Number__c = '3434';
        pc.TestHarnessId__c = 'ASC002';
        pc.IsTestHarnessPatient__c = true;
        insert pc;
        
        Site_Trial__c siteObject = new Site_Trial__c();
        siteObject.Site__c = site1.Id;
        siteObject.Trial__c = trial1.Id; 
        siteObject.User__c = 'Site';
        insert siteObject;
        
        TrialPatient__c tp = new TrialPatient__c();
        tp.Patient_Id__c = pc.Id;
        tp.Trial_Id__c = trial1.Id;
        tp.Site__c = site1.Id;
        insert tp;
        
        RandomizationTestingDetail__c randObj = new RandomizationTestingDetail__c();
        randObj.IsRandomized__c = true;
        randObj.Trial_Name__c = 'test trial';
        insert randObj;
        
        //=========================="hasPatientParticipateInRepeatMRIScan = no " ==============
        
        PatientRegistration patRegObj2 = new PatientRegistration();
        patRegObj2.patientId = 'ASC002';
        patRegObj2.regDate = '7/8/2011';
        patRegObj2.completedDate = '7/7/1997';
        patRegObj2.hasPatientParticipateInRepeatMRIScan = 'No';
        patRegObj2.Status = 'Accepted';
        patRegObj2.IRBApprovalDate = '8/8/1996';
        patRegObj2.HIPPAConsentDate = '9/9/1987';
        patRegObj2.ScreeningConsentDate = '10/10/1996';
        
        List<PatientRegistration> lstPatReg2 = new List<PatientRegistration>();
        lstPatReg2.add(patRegObj2);
        
        TestHarnessService harnessObject2 = new TestHarnessService();
        harnessObject2.createRegistration(inst1.Id, site1.Id, trial1.Id,lstPatReg2);
      }
   } 
   
   @isTest static void ExceptionHandling1() {
        // TO DO: implement unit test
        
        List<User> lstSiteUser = [Select u.IsActive, u.Id From User u where IsActive = true and id =: userinfo.getUserId()];
        System.runAs ( lstSiteUser[0] ) { 
            
        List<RecordType> recordT = [Select r.Name, r.Id From RecordType r where SobjectType = 'Account' and Name='Institution'];
        
        Code_Master__c snomedObject = new Code_Master__c();
        snomedObject.Variable_Description__c = 'test';
        snomedObject.IsReportColumn__c = true;
        snomedObject.Display_Order__c = 3.0;
        snomedObject.Name = 'Institution';
        insert snomedObject;
        
        Account inst1 = new Account();
        inst1.Name = 'test Institute 1';
        inst1.RecordTypeId = recordT[0].Id;  
        insert inst1;        
        
        Trial__c trial1 = new Trial__c();
        trial1.Name = 'test trial';
        insert trial1;
        
        Site__c site1 = new Site__c();
        site1.Name = 'test site1';
        site1.Type__c = 'test type';
        site1.Institute__c = inst1.Id;
        insert site1;
        
        Patient_Custom__c pc = new Patient_Custom__c();
        pc.First_Name__c = 'test';
        pc.Last_Name__c = 'test2';
        pc.Gender__c = 'Male';
        pc.Birthdate__c = date.newInstance(1987, 7, 7);
        pc.Race__c = 'White';
        pc.Ethnicity__c = 'Not Hispanic or Latino';
        pc.Institution__c = inst1.Id;
        pc.Medical_Record_Number__c = '3434';
        pc.TestHarnessId__c = 'ASC002';
        pc.IsTestHarnessPatient__c = true;
        insert pc;
        
        Site_Trial__c siteObject = new Site_Trial__c();
        siteObject.Site__c = site1.Id;
        siteObject.Trial__c = trial1.Id; 
        siteObject.User__c = 'Site';
        insert siteObject;
        
        TrialPatient__c tp = new TrialPatient__c();
        tp.Patient_Id__c = pc.Id;
        tp.Trial_Id__c = trial1.Id;
        tp.Site__c = site1.Id;
        insert tp;
        
        RandomizationTestingDetail__c randObj = new RandomizationTestingDetail__c();
        randObj.IsRandomized__c = true;
        randObj.Trial_Name__c = 'test trial';
        insert randObj;
        
        //=========================Race=====================================================
        Patient patbject3 = new Patient();
        patbject3.LastName = 'test';
        patbject3.Gender = 'Male';
        patbject3.Ethnicity = 'Not Hispanic or Latino';
        patbject3.Birthdate = '7/7/1987';
        patbject3.TestHarnessId = 'ASC002';
        
        List<Patient> lstPatient3 = new List<Patient>(); // this indicates "patient" class
        lstPatient3.add(patbject3);
        
        TestHarnessService harnessObject2 = new TestHarnessService();
        harnessObject2.createPatient(inst1.Id, site1.Id, trial1.Id,lstPatient3);
        
        //=========================Ethnicity=================================================
        Patient patbject4 = new Patient();
        patbject4.Gender = 'Male';
        patbject4.LastName = 'test';
        patbject4.Birthdate = '7/7/1987';
        patbject4.Race = 'White';
        patbject4.TestHarnessId = 'ASC002';
        
        List<Patient> lstPatient4 = new List<Patient>(); // this indicates "patient" class
        lstPatient4.add(patbject4);
        
        TestHarnessService harnessObject3 = new TestHarnessService();
        harnessObject3.createPatient(inst1.Id, site1.Id, trial1.Id,lstPatient4);
        
        //========================IRBApprovalDate ==============================================
        
        PatientRegistration patRegObj3 = new PatientRegistration();
        patRegObj3.patientId = 'ASC002';
        patRegObj3.regDate = '7/8/2011';
        patRegObj3.hasPatientParticipateInRepeatMRIScan = 'yes';
        patRegObj3.completedDate = '7/7/1997';
        patRegObj3.Status = 'Accepted';
        patRegObj3.HIPPAConsentDate = '9/9/1987';
        patRegObj3.ScreeningConsentDate = '10/10/1996';
        
        List<PatientRegistration> lstPatReg3 = new List<PatientRegistration>();
        lstPatReg3.add(patRegObj3);
        
        harnessObject3.createRegistration(inst1.Id, site1.Id, trial1.Id,lstPatReg3);
        
        //=========================ScreeningConsentDate =========================================
        PatientRegistration patRegObj4 = new PatientRegistration();
        patRegObj4.patientId = 'ASC002';
        patRegObj4.regDate = '7/8/1985';
        patRegObj4.hasPatientParticipateInRepeatMRIScan = 'yes';
        patRegObj4.completedDate = '7/7/1997';
        patRegObj4.Status = 'Accepted';
        patRegObj4.IRBApprovalDate = '8/8/1996';
        patRegObj4.HIPPAConsentDate = '9/9/1987';
        
        List<PatientRegistration> lstPatReg4 = new List<PatientRegistration>();
        lstPatReg4.add(patRegObj4);
        
        TestHarnessService harnessObject4 = new TestHarnessService();
        harnessObject4.createRegistration(inst1.Id, site1.Id, trial1.Id,lstPatReg4);
        
        //=======================HIPPA  ==========================================================
        PatientRegistration patRegObj5 = new PatientRegistration();
        patRegObj5.patientId = 'ASC002';
        patRegObj5.regDate = '7/8/2010';
        patRegObj5.hasPatientParticipateInRepeatMRIScan = 'yes';
        patRegObj5.completedDate = '7/7/1997';
        patRegObj5.Status = 'Accepted';
        patRegObj5.IRBApprovalDate = '8/8/1996';
        patRegObj5.ScreeningConsentDate = '10/10/1996';
        
        List<PatientRegistration> lstPatReg5 = new List<PatientRegistration>();
        lstPatReg5.add(patRegObj5);
        
        TestHarnessService harnessObject1 = new TestHarnessService();
        harnessObject1.createRegistration(inst1.Id, site1.Id, trial1.Id,lstPatReg5);
      }
   } 
}