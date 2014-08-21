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
private class TestingTestHarnessCRFUploadController {

    @isTest static void myUnitTest() {
        // TO DO: implement unit test
        
        List<User> lstSiteUser = [Select u.IsActive, u.Id From User u where Profile.Name = 'System Administrator' and IsActive = true];
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
        
        Patient_Custom__c patObj = new Patient_Custom__c();
        patObj.Last_Name__c = 'test2';
        patObj.Gender__c = 'Male';
        patObj.Birthdate__c = date.newInstance(1988, 7, 7);
        patObj.Race__c = 'White';
        patObj.Ethnicity__c = 'Not Hispanic or Latino';
        patObj.Institution__c = inst1.Id;
        patObj.IsTestHarnessPatient__c = true;
        insert patObj;
        
        TrialPatient__c tp = new TrialPatient__c();
        tp.Patient_Id__c = patObj.Id;
        tp.Trial_Id__c = trial1.Id;
        tp.IsRandomized__c = false;
        insert tp;
        
        ErrorLog__c errorObject = new ErrorLog__c();
        errorObject.message__c = 'hello test';
        errorObject.IsSuccess__c = true;
        errorObject.Result__c = 'pass';
        insert errorObject;
        
        Pre_Registration_Snomed_Codes__c pre = new Pre_Registration_Snomed_Codes__c();
        pre.Code_Master__c = snomedObject.Id;
        insert pre;
        
        Apexpages.currentPage().getParameters().put('inst',inst1.Id);
        Apexpages.currentPage().getParameters().put('site',site1.Id);
        Apexpages.currentPage().getParameters().put('trial',trial1.Id);
        Apexpages.currentPage().getParameters().put('transId',errorObject.Id);
        
        TestHarnessCRFUploadController csvObject = new TestHarnessCRFUploadController();
        
        csvObject.loadSite();
        csvObject.submitDetails();
        
        csvObject.fileName = 'aaa.txt';
        csvObject.uploadCSV(); 
        
        csvObject.fileName = 'Patient.csv'; // satisfy "if" condition line 136
        String csvString3 = '"Test","Harness 1000","abcd"\n"Test","Harness 1000","abcd"';
        csvObject.fileBody = Blob.valueOf(csvString3);
        csvObject.uploadCSV(); 
        
        csvObject.fileName = 'Patient.csv';
        String csvString = '"001","Test" ,"Harness 1000", "last test","P","Female","12/2/1987","test add 1","test add 2","Test City","Test State","USA","12345","American Indian or Alaska Native","Hispanic or Latino","110022","India","12/12/2012","Approval Not Requied","abcd"\n"001","Test" ,"Harness 1000", "last test","P","Female","12/2/1987","test add 1","test add 2","Test City","Test State","USA","12345","American Indian or Alaska Native","Hispanic or Latino","110022","India","12/12/2012","Approval Not Requied","abcd"';
        csvObject.fileBody = Blob.valueOf(csvString);
        csvObject.uploadCSV(); 
        
        csvObject.fileName = 'PreEligibilityCRF.csv'; // satisfy "if" condition line 173 
        String csvString2 = '"true","true"\n"true","true"';
        csvObject.fileBody = Blob.valueOf(csvString2);
        csvObject.uploadCSV(); 
        
        csvObject.fileName = 'PreEligibilityCRF.csv';
        String csvString1 = '"true","true","true","true","true","true","true","true","true","true","true","true","true","true","true","true"\n"true","true","true","true","true","true","true","true","true","true","true","true","true","true","true","true"';
        csvObject.fileBody = Blob.valueOf(csvString1);
        csvObject.uploadCSV(); 
        
        }
    }
    @isTest static void myUnitTest1() {
        // TO DO: implement unit test
        
        List<User> lstSiteUser = [Select u.IsActive, u.Id From User u where Profile.Name = 'System Administrator' and IsActive = true];
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
        
        ErrorLog__c errorObject = new ErrorLog__c();
        errorObject.message__c = 'hello test';
        errorObject.IsSuccess__c = true;
        insert errorObject;
        
        Pre_Registration_Snomed_Codes__c pre = new Pre_Registration_Snomed_Codes__c();
        pre.Code_Master__c = snomedObject.Id;
        insert pre;
        
        RandomizationTestingDetail__c ranObj = new RandomizationTestingDetail__c();
        ranObj.IsRandomized__c = false;
        ranObj.Trial_Name__c = 'test trial';
        insert ranObj;
        
        TestHarnessHistory__c testObj = new TestHarnessHistory__c();
        testObj.TestHarnessType__c = 'Randomization';
        insert testObj;
        
        Apexpages.currentPage().getParameters().put('inst',inst1.Id);
        Apexpages.currentPage().getParameters().put('site',site1.Id);
        Apexpages.currentPage().getParameters().put('trial',trial1.Id);
        Apexpages.currentPage().getParameters().put('transId',errorObject.Id);
        
        TestHarnessCRFUploadController csvObject = new TestHarnessCRFUploadController();
        
        csvObject.fileName = 'Registration.csv'; // satisfy "if" condition line 208 MenopausalStatus
        String csvString4 = '"patientId","regDate","hasPatientParticipateInRepeatMRIScan"\n"patientId","regDate","hasPatientParticipateInRepeatMRIScan"';
        csvObject.fileBody = Blob.valueOf(csvString4);
        csvObject.uploadCSV(); 
        
        csvObject.fileName = 'Registration.csv'; 
        String csvString5 = '"patientId","regDate","hasPatientParticipateInRepeatMRIScan","IRBApprovalDate","ScreeningConsentDate","HIPPAConsentDate","CompletedDate","Status"\n"patientId","regDate","hasPatientParticipateInRepeatMRIScan","IRBApprovalDate","ScreeningConsentDate","HIPPAConsentDate","CompletedDate","Status"';
        csvObject.fileBody = Blob.valueOf(csvString5);
        csvObject.uploadCSV(); 
        
        csvObject.fileName = 'MenopausalStatusCRF.csv'; // satisfy "if" condition line 234 
        String csvString6 = '"patientId","DateOfLastMenstrualPeriod","UnknownDate"\n"patientId","DateOfLastMenstrualPeriod","UnknownDate"';
        csvObject.fileBody = Blob.valueOf(csvString6);
        csvObject.uploadCSV(); 
        
        csvObject.fileName = 'MenopausalStatusCRF.csv'; 
        String csvString7 = '"patientId","DateOfLastMenstrualPeriod","UnknownDate","UnknownDate12MonthsAgo","OnEstrogenReplacement","OnEstrogenReplacementMonths","OnEstrogenReplacementYears","BilateralOophorectomy","BilateralOophorectomyDate","Hysterectomy","HysterectomyDate","CompletedDate","Status","test"\n"patientId","DateOfLastMenstrualPeriod","UnknownDate","UnknownDate12MonthsAgo","OnEstrogenReplacement","OnEstrogenReplacementMonths","OnEstrogenReplacementYears","BilateralOophorectomy","BilateralOophorectomyDate","Hysterectomy","HysterectomyDate","CompletedDate","Status","test"';
        csvObject.fileBody = Blob.valueOf(csvString7);
        csvObject.uploadCSV(); 
        
        csvObject.testHarnessType = 'Randomization';
        csvObject.runTestHarness();
        
        }
    }
    @isTest static void myUnitTest2() {
        // TO DO: implement unit test
        
        List<User> lstSiteUser = [Select u.IsActive, u.Id From User u where Profile.Name = 'System Administrator' and IsActive = true];
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
        
        ErrorLog__c errorObject = new ErrorLog__c();
        errorObject.message__c = 'hello test';
        errorObject.IsSuccess__c = true;
        insert errorObject;
        
        Pre_Registration_Snomed_Codes__c pre = new Pre_Registration_Snomed_Codes__c();
        pre.Code_Master__c = snomedObject.Id;
        insert pre;
        
        TestHarnessHistory__c testObj = new TestHarnessHistory__c();
        testObj.TestHarnessType__c = 'Complete';
        insert testObj;
        
        Apexpages.currentPage().getParameters().put('inst',inst1.Id);
        Apexpages.currentPage().getParameters().put('site',site1.Id);
        Apexpages.currentPage().getParameters().put('trial',trial1.Id);
        Apexpages.currentPage().getParameters().put('transId',errorObject.Id);
        
        TestHarnessCRFUploadController csvObject = new TestHarnessCRFUploadController();
        
        csvObject.fileName = 'TissueSpecimenCRF.csv'; // satisfy "if" condition line 265  
        String csvString8 = '"patientId","ProcedureDate","GuidanceMethod"\n"patientId","ProcedureDate","GuidanceMethod"';
        csvObject.fileBody = Blob.valueOf(csvString8);
        csvObject.uploadCSV(); 
        
        csvObject.fileName = 'TissueSpecimenCRF.csv'; 
        String csvString9 = '"test11","test12","test13","patientId","ProcedureDate","GuidanceMethod","OtherGuidanceMethod","TimePoint","NumberOfCoreBiopsyCollected","ReasonAllSampleNotCollected","Other","CompletedDate","Status"\n"test11","test12","test13","patientId","ProcedureDate","GuidanceMethod","OtherGuidanceMethod","TimePoint","NumberOfCoreBiopsyCollected","ReasonAllSampleNotCollected","Other","CompletedDate","Status"';
        csvObject.fileBody = Blob.valueOf(csvString9);
        csvObject.uploadCSV(); 
        
        csvObject.fileName = 'MRIVolumeCRF.csv'; // satisfy "if" condition line 293  
        String csvString10 = '"patientId","WasMRIReadable","DataOfMRIScan"\n"patientId","ProcedureDate","GuidanceMethod"';
        csvObject.fileBody = Blob.valueOf(csvString10);
        csvObject.uploadCSV(); 
        
        csvObject.fileName = 'MRIVolumeCRF.csv'; 
        String csvString11 = '"patientId","WasMRIReadable","DataOfMRIScan","TimePoint","MRIVolumeInCM","Laterality","LongestDiameterOfIndexLesion","AreSeparateMassesOrEnhancementsReported","CompletedDate","Status"\n"patientId","WasMRIReadable","DataOfMRIScan","TimePoint","MRIVolumeInCM","Laterality","LongestDiameterOfIndexLesion","AreSeparateMassesOrEnhancementsReported","CompletedDate","Status"';
        csvObject.fileBody = Blob.valueOf(csvString11);
        csvObject.uploadCSV(); 
        
        csvObject.fileName = 'CoreBiopsySpecimen.csv'; // satisfy "if" condition size < 4  
        String csvString12 = '"TissueSpecimenCRFId","CoreSpecimen","Shipped"\n"TissueSpecimenCRFId","CoreSpecimen","Shipped"';
        csvObject.fileBody = Blob.valueOf(csvString12);
        csvObject.uploadCSV(); 
        
        csvObject.fileName = 'CoreBiopsySpecimen.csv'; 
        String csvString13 = '"TissueSpecimenCRFId","CoreSpecimen","Shipped","ReasonSamplesNotShipped","OtherReasonSamplesNotShipped"\n"TissueSpecimenCRFId","CoreSpecimen","Shipped","ReasonSamplesNotShipped","OtherReasonSamplesNotShipped"';
        csvObject.fileBody = Blob.valueOf(csvString13);
        csvObject.uploadCSV(); 
        
        csvObject.testHarnessType = 'Complete';
        csvObject.runTestHarness();
        
        }
    }
    @isTest static void myUnitTest3() {
        // TO DO: implement unit test
        
        List<User> lstSiteUser = [Select u.IsActive, u.Id From User u where Profile.Name = 'System Administrator' and IsActive = true];
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
        
        ErrorLog__c errorObject = new ErrorLog__c();
        errorObject.message__c = 'hello test';
        errorObject.IsSuccess__c = true;
        insert errorObject;
        
        Pre_Registration_Snomed_Codes__c pre = new Pre_Registration_Snomed_Codes__c();
        pre.Code_Master__c = snomedObject.Id;
        insert pre;
        
        Apexpages.currentPage().getParameters().put('inst',inst1.Id);
        Apexpages.currentPage().getParameters().put('site',site1.Id);
        Apexpages.currentPage().getParameters().put('trial',trial1.Id);
        Apexpages.currentPage().getParameters().put('transId',errorObject.Id);
        
        TestHarnessCRFUploadController csvObject = new TestHarnessCRFUploadController();
        
        csvObject.fileName = 'MammaPrintCRF.csv'; // satisfy "if" condition line 321  
        String csvString8 = '"patientId","ReportDate","SpecimenCollectionDates"\n"patientId","ReportDate","SpecimenCollectionDates"';
        csvObject.fileBody = Blob.valueOf(csvString8);
        csvObject.uploadCSV(); 
        
        csvObject.fileName = 'MammaPrintCRF.csv'; 
        String csvString9 = '"patientId","ReportDate","SpecimenCollectionDates","SpecimenUsed","MammaPrintRisk","MammaPrintIndex","TargetPrintHER2Index","CompletedDate","Status"\n"patientId","ReportDate","SpecimenCollectionDates","SpecimenUsed","MammaPrintRisk","MammaPrintIndex","TargetPrintHER2Index","CompletedDate","Status"';
        csvObject.fileBody = Blob.valueOf(csvString9);
        csvObject.uploadCSV(); 
        
        
        csvObject.fileName = 'OnStudyEligiblityCRF.csv'; // satisfy "if" condition line 348  
        String csvString10 = '"patientId","NoClinicalOrImagingEvidence","NoUncontrolledorCardiovascularDiseas"\n"patientId","NoClinicalOrImagingEvidence","NoUncontrolledorCardiovascularDiseas"';
        csvObject.fileBody = Blob.valueOf(csvString10);
        csvObject.uploadCSV(); 
        
        csvObject.fileName = 'OnStudyEligiblityCRF.csv'; 
        String csvString11 = '"patientId","NoClinicalOrImagingEvidence","NoUncontrolledorCardiovascularDiseas","NoHistoryOfAllergicReactions","NoUncontrolledIntercurrentIllness","NotHadASentinelLymphNode","LabValues","Leukocytes3000L","AbsoluteNeutrophilCount1500L","Platelets100000L","TotalBilirubinWithinInstitutional","ASTSGOTOrALTSGPT15xinsti","Creatinine15xInstitutionalULN","HowWasTheCancerFirstDetected","IsMassPalpable","OtherReasonForCancerFirstDetected","MassIdentificationDate","ScreeningMemogramPriorToMassDetect","MostRecentDate","CompletedDate","Status"\n"patientId","NoClinicalOrImagingEvidence","NoUncontrolledorCardiovascularDiseas","NoHistoryOfAllergicReactions","NoUncontrolledIntercurrentIllness","NotHadASentinelLymphNode","LabValues","Leukocytes3000L","AbsoluteNeutrophilCount1500L","Platelets100000L","TotalBilirubinWithinInstitutional","ASTSGOTOrALTSGPT15xinsti","Creatinine15xInstitutionalULN","HowWasTheCancerFirstDetected","IsMassPalpable","OtherReasonForCancerFirstDetected","MassIdentificationDate","ScreeningMemogramPriorToMassDetect","MostRecentDate","CompletedDate","Status"';
        csvObject.fileBody = Blob.valueOf(csvString11);
        csvObject.uploadCSV(); 
        
        }
    }
     @isTest static void myUnitTest4() {
        // TO DO: implement unit test
        
        List<User> lstSiteUser = [Select u.IsActive, u.Id From User u where Profile.Name = 'System Administrator' and IsActive = true];
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
        
        ErrorLog__c errorObject = new ErrorLog__c();
        errorObject.message__c = 'hello test';
        errorObject.IsSuccess__c = true;
        insert errorObject;
        
        Pre_Registration_Snomed_Codes__c pre = new Pre_Registration_Snomed_Codes__c();
        pre.Code_Master__c = snomedObject.Id;
        insert pre;
        
        Apexpages.currentPage().getParameters().put('inst',inst1.Id);
        Apexpages.currentPage().getParameters().put('site',site1.Id);
        Apexpages.currentPage().getParameters().put('trial',trial1.Id);
        Apexpages.currentPage().getParameters().put('transId',errorObject.Id);
        
        TestHarnessCRFUploadController csvObject = new TestHarnessCRFUploadController();
        
        csvObject.fileName = 'OnStudyPathologyCRF.csv'; // satisfy "if" condition line 387  
        String csvString8 = '"patientId","DoesThePatientHaveBilateralBreast","Tumorlaterality"\n"patientId","DoesThePatientHaveBilateralBreast","Tumorlaterality"';
        csvObject.fileBody = Blob.valueOf(csvString8);
        csvObject.uploadCSV(); 
        
        csvObject.fileName = 'OnStudyPathologyCRF.csv'; 
        String csvString9 = '"PatientId ","DoesThePatientHaveBilateralBreast ","Tumorlaterality ","CompletedDate ","Status ","CRFId","IsDCISPresent","IsLCISPresent","IsInvasiveTumorPresent"\n"PatientId ","DoesThePatientHaveBilateralBreast ","Tumorlaterality ","CompletedDate ","Status ","CRFId","IsDCISPresent","IsLCISPresent","IsInvasiveTumorPresent"';
        csvObject.fileBody = Blob.valueOf(csvString9);
        csvObject.uploadCSV(); 
        
        csvObject.fileName = 'Receptor.csv'; // satisfy "if" condition line 410  
        String csvString10 = '"OSPId","ERStatus","ERProporationScore"\n"OSPId","ERStatus","ERProporationScore"';
        csvObject.fileBody = Blob.valueOf(csvString10);
        csvObject.uploadCSV(); 
        
        csvObject.fileName = 'Receptor.csv'; 
        String csvString11 = '"OSPId","ERStatus","ERProporationScore","ERIntensityScore","PRStatus","PRProporationScore","PRIntensityScore","IHC","DAKOHerceptest","OtherIHCTest","OtherIHCResult","VentanaKit","CB11","IHCTestNotDone","FISH","VentanaOncoprobe","OtherFISHTest","OtherFISHResults","FISHTestNotDone"\n"OSPId","ERStatus","ERProporationScore","ERIntensityScore","PRStatus","PRProporationScore","PRIntensityScore","IHC","DAKOHerceptest","OtherIHCTest","OtherIHCResult","VentanaKit","CB11","IHCTestNotDone","FISH","VentanaOncoprobe","OtherFISHTest","OtherFISHResults","FISHTestNotDone"';
        csvObject.fileBody = Blob.valueOf(csvString11);
        csvObject.uploadCSV(); 
        csvObject.runTestHarness();
        
        }
    }
    @isTest static void myUnitTest5() {
        // TO DO: implement unit test
        
        List<User> lstSiteUser = [Select u.IsActive, u.Id From User u where Profile.Name = 'System Administrator' and IsActive = true];
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
        
        ErrorLog__c errorObject = new ErrorLog__c();
        errorObject.message__c = 'hello test';
        errorObject.IsSuccess__c = true;
        insert errorObject;
        
        Pre_Registration_Snomed_Codes__c pre = new Pre_Registration_Snomed_Codes__c();
        pre.Code_Master__c = snomedObject.Id;
        insert pre;
        
        Apexpages.currentPage().getParameters().put('inst',inst1.Id);
        Apexpages.currentPage().getParameters().put('site',site1.Id);
        Apexpages.currentPage().getParameters().put('trial',trial1.Id);
        Apexpages.currentPage().getParameters().put('transId',errorObject.Id);
        
        TestHarnessCRFUploadController csvObject = new TestHarnessCRFUploadController();
        
        csvObject.fileName = 'Procedure.csv'; // satisfy "if" condition  
        String csvString = '"CRFId","DateOfProcedure","ProcedureName"\n"CRFId","DateOfProcedure","ProcedureName"';
        csvObject.fileBody = Blob.valueOf(csvString);
        csvObject.uploadCSV(); 
        
        csvObject.fileName = 'Procedure.csv'; 
        String csvString1 = '"CRFId ","DateOfProcedure ","ProcedureName ","Ultrasound ","Palpationguided ","Mammography","MRI","Stereotactic","Laterality","Location","NodeResult","FormName","NodeType","TotalPositive","TotalExaminedNodes"\n"CRFId ","DateOfProcedure ","ProcedureName ","Ultrasound ","Palpationguided ","Mammography","MRI","Stereotactic","Laterality","Location","NodeResult","FormName","NodeType","TotalPositive","TotalExaminedNodes"';
        csvObject.fileBody = Blob.valueOf(csvString1);
        csvObject.uploadCSV(); 
        
        csvObject.fileName = 'DCIS.csv'; // satisfy "if" condition 
        String csvString2 = '"CRFId","PunctateNecrosis","Comedonecrosis"\n"CRFId","PunctateNecrosis","Comedonecrosis"';
        csvObject.fileBody = Blob.valueOf(csvString2);
        csvObject.uploadCSV(); 
        
        csvObject.fileName = 'DCIS.csv'; 
        String csvString3 = '"CRFId","PunctateNecrosis","Comedonecrosis","Papillary","Micropapillary","Necrosis","Cribiform","Cruciform","Clinging","Solid","Apocrine","IntraCysticEncystedPapillary","Other","Calcifications","CalcificationsPresent","NuclearGrade"\n"CRFId","PunctateNecrosis","Comedonecrosis","Papillary","Micropapillary","Necrosis","Cribiform","Cruciform","Clinging","Solid","Apocrine","IntraCysticEncystedPapillary","Other","Calcifications","CalcificationsPresent","NuclearGrade"';
        csvObject.fileBody = Blob.valueOf(csvString3);
        csvObject.uploadCSV(); 
        
        csvObject.fileName = 'LCIS.csv'; // satisfy "if" condition 
        String csvString4 = '"CRFId"\n"CRFId"';
        csvObject.fileBody = Blob.valueOf(csvString4);
        csvObject.uploadCSV(); 
        
        csvObject.fileName = 'LCIS.csv'; 
        String csvString5 = '"CRFId","LCISType"\n"CRFId","LCISType"';
        csvObject.fileBody = Blob.valueOf(csvString5);
        csvObject.uploadCSV(); 
        
        }
    }
    @isTest static void myUnitTest6() {
        // TO DO: implement unit test
        
        List<User> lstSiteUser = [Select u.IsActive, u.Id From User u where Profile.Name = 'System Administrator' and IsActive = true];
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
        
        ErrorLog__c errorObject = new ErrorLog__c();
        errorObject.message__c = 'hello test';
        errorObject.IsSuccess__c = true;
        insert errorObject;
        
        Pre_Registration_Snomed_Codes__c pre = new Pre_Registration_Snomed_Codes__c();
        pre.Code_Master__c = snomedObject.Id;
        insert pre;
        
        Apexpages.currentPage().getParameters().put('inst',inst1.Id);
        Apexpages.currentPage().getParameters().put('site',site1.Id);
        Apexpages.currentPage().getParameters().put('trial',trial1.Id);
        Apexpages.currentPage().getParameters().put('transId',errorObject.Id);
        
        TestHarnessCRFUploadController csvObject = new TestHarnessCRFUploadController();
        
        csvObject.fileName = 'InvasiveTumor.csv'; // satisfy "if" condition  
        String csvString = '"CRFId","InvasiveDuctalCarcinomaNos","InvasiveLobularCarcinomaClassicType"\n"CRFId","InvasiveDuctalCarcinomaNos","InvasiveLobularCarcinomaClassicType"';
        csvObject.fileBody = Blob.valueOf(csvString);
        csvObject.uploadCSV(); 
        
        csvObject.fileName = 'InvasiveTumor.csv'; 
        String csvString1 = '"CRFId","InvasiveDuctalCarcinomaNos","InvasiveLobularCarcinomaClassicType","InvasiveLobularCarcinomaAlveolarType ","PleomorphicLobularCarcinoma ","TubulolobularCarcinoma","InvasiveCarcinomaMixedDuctalAndLobularType","TubularCarcinoma","MucinousCarcinoma","MedullaryCarcinoma","InvasivePapillaryCarcinoma","InvasiveCribiformCarcinoma","Other","SignsOfTreatmentEffect","Calcifications","CalcificationsPresent","NuclearGrade","MitoticCount","TubulePapillaFormation","LympaticVascularInvasion","SkinInvolvement","PagetDisease","UlcerationByTumor","DermaLymphaticVascularInvasion"\n"CRFId","InvasiveDuctalCarcinomaNos","InvasiveLobularCarcinomaClassicType","InvasiveLobularCarcinomaAlveolarType ","PleomorphicLobularCarcinoma ","TubulolobularCarcinoma","InvasiveCarcinomaMixedDuctalAndLobularType","TubularCarcinoma","MucinousCarcinoma","MedullaryCarcinoma","InvasivePapillaryCarcinoma","InvasiveCribiformCarcinoma","Other","SignsOfTreatmentEffect","Calcifications","CalcificationsPresent","NuclearGrade","MitoticCount","TubulePapillaFormation","LympaticVascularInvasion","SkinInvolvement","PagetDisease","UlcerationByTumor","DermaLymphaticVascularInvasion"';
        csvObject.fileBody = Blob.valueOf(csvString1);
        csvObject.uploadCSV(); 
        
        csvObject.fileName = 'BloodSpecimenCRF.csv'; // satisfy "if" condition 
        String csvString2 = '"PatientId","CRFId","CollectionDate"\n"PatientId","CRFId","CollectionDate"';
        csvObject.fileBody = Blob.valueOf(csvString2);
        csvObject.uploadCSV(); 
        
        csvObject.fileName = 'BloodSpecimenCRF.csv'; 
        String csvString3 = '"PatientId","CRFId","CollectionDate","TimePoint","NoOfSampleCollected_Serum","NoOfSampleCollected_Plasma","NoOfSampleCollected_buffyCoat","ReasonAllSampleNotCollected","Other","PatientConsentedForThisStudy","PatientConsentedForOutSideStudy","CompletedDate","Status"\n"PatientId","CRFId","CollectionDate","TimePoint","NoOfSampleCollected_Serum","NoOfSampleCollected_Plasma","NoOfSampleCollected_buffyCoat","ReasonAllSampleNotCollected","Other","PatientConsentedForThisStudy","PatientConsentedForOutSideStudy","CompletedDate","Status"';
        csvObject.fileBody = Blob.valueOf(csvString3);
        csvObject.uploadCSV(); 
        
        csvObject.fileName = 'BloodSpecimenSample.csv'; // satisfy "if" condition 
        String csvString4 = '"CRFId","SpecimenType","SpecimenNumber"\n"CRFId","SpecimenType","SpecimenNumber"';
        csvObject.fileBody = Blob.valueOf(csvString4);
        csvObject.uploadCSV(); 
        
        csvObject.fileName = 'BloodSpecimenSample.csv'; 
        String csvString5 = '"CRFId","SpecimenType","SpecimenNumber","Shipped","ReasonSamplesNotShipped","OtherReasonSamplesNotShipped"\n"CRFId","SpecimenType","SpecimenNumber","Shipped","ReasonSamplesNotShipped","OtherReasonSamplesNotShipped"';
        csvObject.fileBody = Blob.valueOf(csvString5);
        csvObject.uploadCSV(); 
        
        }
    }
    @isTest static void myUnitTest7() {
        // TO DO: implement unit test
        
        List<User> lstSiteUser = [Select u.IsActive, u.Id From User u where Profile.Name = 'System Administrator' and IsActive = true];
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
        
        ErrorLog__c errorObject = new ErrorLog__c();
        errorObject.message__c = 'hello test';
        errorObject.IsSuccess__c = true;
        insert errorObject;
        
        Pre_Registration_Snomed_Codes__c pre = new Pre_Registration_Snomed_Codes__c();
        pre.Code_Master__c = snomedObject.Id;
        insert pre;
        
    Apexpages.currentPage().getParameters().put('inst',inst1.Id);
    Apexpages.currentPage().getParameters().put('site',site1.Id);
    Apexpages.currentPage().getParameters().put('trial',trial1.Id);
    Apexpages.currentPage().getParameters().put('transId',errorObject.Id);
    
    TestHarnessCRFUploadController csvObject = new TestHarnessCRFUploadController();
    
    csvObject.fileName = 'OffStudyCRF.csv'; 
        String csvString13 = '"patientId","Datepatientwentoffstudy","Patientcompletedstudyperprotocol"\n"patientId","Datepatientwentoffstudy","Patientcompletedstudyperprotocol"';
        csvObject.fileBody = Blob.valueOf(csvString13);
        csvObject.uploadCSV();
       
        csvObject.fileName = 'OffStudyCRF.csv';
        String csvString14 = '"patientId","Datepatientwentoffstudy","Patientcompletedstudyperprotocol","PatientdidnotwanttocompleteMRI","Patientdidntwanttocompletecorebio","Patientdidntcontinueontreatmentarm","Whypatientdidntcontinuetreatmentarm","Treatmentarmotherreason","Patientdidnothavesurgery","Patientdidnothavesurgeryreason","PatientDied","Didpatientwithdrawforsurvival","Patientwithdrewforspecimens","CompletedDate","Status"\n"patientId","Datepatientwentoffstudy","Patientcompletedstudyperprotocol","PatientdidnotwanttocompleteMRI","Patientdidntwanttocompletecorebio","Patientdidntcontinueontreatmentarm","Whypatientdidntcontinuetreatmentarm","Treatmentarmotherreason","Patientdidnothavesurgery","Patientdidnothavesurgeryreason","PatientDied","Didpatientwithdrawforsurvival","Patientwithdrewforspecimens","CompletedDate","Status"';
        csvObject.fileBody = Blob.valueOf(csvString14);
        csvObject.uploadCSV();  
    
    
    csvObject.fileName = 'NolongLosttoFollowupCRF.csv';
    String csvString15 = '"patientId","NewInformation","SurvialStatus"\n"patientId","NewInformation","SurvialStatus"';
    csvObject.fileBody = Blob.valueOf(csvString15);
    csvObject.uploadCSV(); 
    
    csvObject.fileName = 'NolongLosttoFollowupCRF.csv'; 
    String csvString16 = '"patientId","NewInformation","SurvialStatus","lastalivedeathdate","CompletedDate","Status"\n"patientId","NewInformation","SurvialStatus","lastalivedeathdate","CompletedDate","Status"';
    csvObject.fileBody = Blob.valueOf(csvString16);
    csvObject.uploadCSV(); 
    
        }
    }
     @isTest static void myUnitTest8() {
        // TO DO: implement unit test
        
        List<User> lstSiteUser = [Select u.IsActive, u.Id From User u where Profile.Name = 'System Administrator' and IsActive = true];
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
        
        ErrorLog__c errorObject = new ErrorLog__c();
        errorObject.message__c = 'hello test';
        errorObject.IsSuccess__c = true;
        insert errorObject;
        
        Pre_Registration_Snomed_Codes__c pre = new Pre_Registration_Snomed_Codes__c();
        pre.Code_Master__c = snomedObject.Id;
        insert pre;
        
        Apexpages.currentPage().getParameters().put('inst',inst1.Id);
        Apexpages.currentPage().getParameters().put('site',site1.Id);
        Apexpages.currentPage().getParameters().put('trial',trial1.Id);
        Apexpages.currentPage().getParameters().put('transId',errorObject.Id);
        
        TestHarnessCRFUploadController csvObject = new TestHarnessCRFUploadController();
        
        csvObject.fileName = 'LosttoFollowupCRF.csv'; 
        String csvString17 = '"patientId","Lastcontactbefore2yrs","Dateoflastcontact"\n"patientId","Lastcontactbefore2yrs","Dateoflastcontact"';
        csvObject.fileBody = Blob.valueOf(csvString17);
        csvObject.uploadCSV(); 
        
        csvObject.fileName = 'LosttoFollowupCRF.csv'; 
        String csvString18 = '"patientId","Lastcontactbefore2yrs","Dateoflastcontact","SocialSecDeathIndexResearch","SocialSecDeathIndexResearchDate","Sendcertifiedregisteredltrtoknown","SendcertifiedregisteredltrDATE","SendcertifiedregisteredltrResponse","CompletedDate","Status"\n"patientId","Lastcontactbefore2yrs","Dateoflastcontact","SocialSecDeathIndexResearch","SocialSecDeathIndexResearchDate","Sendcertifiedregisteredltrtoknown","SendcertifiedregisteredltrDATE","SendcertifiedregisteredltrResponse","CompletedDate","Status"';
        csvObject.fileBody = Blob.valueOf(csvString18);
        csvObject.uploadCSV(); 
        
        
        csvObject.fileName = 'LabandTestCRF.csv'; 
        String csvString19 = '"patientId","CollectionDate","Leukocytes"\n"patientId","CollectionDate","Leukocytes"';
        csvObject.fileBody = Blob.valueOf(csvString19);
        csvObject.uploadCSV(); 
        
        csvObject.fileName = 'LabandTestCRF.csv'; 
        String csvString20 = '"patientId","CollectionDate","Leukocytes","LeukocytesResult","LeukocytesInstitutionalReferenceRange","AbsoluteNeutrophilCountANC","AbsoluteNeutrophilCountANCResult","ANCIndustrialReferenceRange","Platelets","PlateletsResult","PlateletsInstitutionalReferenceRange","TotalBilirubin","TotalBilirubinResult","TotalBilirubinInstitutionalReference","AST","ASTResult","ASTInstitutionalReferenceRange","ALT","ALTResult","ALTInstitutionalReferenceRange","Creatinine","CreatinineResult","CreatinineInstitutionalReferenceRange","MUGAScan","MUGAScanDate","MUGAScanLVEF","MUGAInstitutionalLowerLimitofNormal","CardiacEcho","CardiacEchoDate","CardiacEchoLVEF","CardiacEchoInstitutionalLowerLimit","CollectionDate1","CompletedDate","Status"\n"patientId","CollectionDate","Leukocytes","LeukocytesResult","LeukocytesInstitutionalReferenceRange","AbsoluteNeutrophilCountANC","AbsoluteNeutrophilCountANCResult","ANCIndustrialReferenceRange","Platelets","PlateletsResult","PlateletsInstitutionalReferenceRange","TotalBilirubin","TotalBilirubinResult","TotalBilirubinInstitutionalReference","AST","ASTResult","ASTInstitutionalReferenceRange","ALT","ALTResult","ALTInstitutionalReferenceRange","Creatinine","CreatinineResult","CreatinineInstitutionalReferenceRange","MUGAScan","MUGAScanDate","MUGAScanLVEF","MUGAInstitutionalLowerLimitofNormal","CardiacEcho","CardiacEchoDate","CardiacEchoLVEF","CardiacEchoInstitutionalLowerLimit","CollectionDate1","CompletedDate","Status"';
        csvObject.fileBody = Blob.valueOf(csvString20);
        csvObject.uploadCSV(); 
        
        }
    }
    @isTest static void myUnitTest9() {
        // TO DO: implement unit test
        
        List<User> lstSiteUser = [Select u.IsActive, u.Id From User u where Profile.Name = 'System Administrator' and IsActive = true];
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
        
        ErrorLog__c errorObject = new ErrorLog__c();
        errorObject.message__c = 'hello test';
        errorObject.IsSuccess__c = true;
        insert errorObject;
        
        Pre_Registration_Snomed_Codes__c pre = new Pre_Registration_Snomed_Codes__c();
        pre.Code_Master__c = snomedObject.Id;
        insert pre;
        
      Apexpages.currentPage().getParameters().put('inst',inst1.Id);
      Apexpages.currentPage().getParameters().put('site',site1.Id);
      Apexpages.currentPage().getParameters().put('trial',trial1.Id);
      Apexpages.currentPage().getParameters().put('transId',errorObject.Id);
    
      TestHarnessCRFUploadController csvObject = new TestHarnessCRFUploadController();

      csvObject.fileName = 'ResponseEvaluationCRF.csv';   
      String csvString21 = '"patientId","CRFId","ReportingPeriod"\n"patientId","CRFId","ReportingPeriod"';
      csvObject.fileBody = Blob.valueOf(csvString21);
      csvObject.uploadCSV(); 
        
      csvObject.fileName = 'ResponseEvaluationCRF.csv'; 
      String csvString22 = '"patientId","CRFId","ReportingPeriod","Dateofclinicalassessment","DiseaseExtent","Palpablenodes","Mattednodes","Nodesfixedtochestwall","Typeoflymphnodeinvolvement","Sizeoflargestnode","ClinicalStagingPeriod","ClinicallystagingperiodT","ClinicallystagingperiodN","ClinicallystagingperiodM","CurrentStatusofT4Tumor","IsCandidateForConservationSurgery","ReasonNotConservationSurgeryCandidate","OtherReason","ResponseStatus","CompleteresponseCR","CompleteresponseCRDate","PartialresponsePR","PartialresponsePRDate","Newlocalregionalrecurrence","NewlocalregionalrecurrenceDate","Newdistantprogression","NewdistantprogressionDate","LocalRegional","Distant","OtherDistant","CompletedDate","Status"\n"patientId","CRFId","ReportingPeriod","Dateofclinicalassessment","DiseaseExtent","Palpablenodes","Mattednodes","Nodesfixedtochestwall","Typeoflymphnodeinvolvement","Sizeoflargestnode","ClinicalStagingPeriod","ClinicallystagingperiodT","ClinicallystagingperiodN","ClinicallystagingperiodM","CurrentStatusofT4Tumor","IsCandidateForConservationSurgery","ReasonNotConservationSurgeryCandidate","OtherReason","ResponseStatus","CompleteresponseCR","CompleteresponseCRDate","PartialresponsePR","PartialresponsePRDate","Newlocalregionalrecurrence","NewlocalregionalrecurrenceDate","Newdistantprogression","NewdistantprogressionDate","LocalRegional","Distant","OtherDistant","CompletedDate","Status"';
      csvObject.fileBody = Blob.valueOf(csvString22);
      csvObject.uploadCSV(); 

      csvObject.fileName = 'DiseaseAssessment.csv'; 
      String csvString23 = '"CRFId","OClockPositionFrom","OClockPositionTo"\n"CRFId","OClockPositionFrom","OClockPositionTo"';
      csvObject.fileBody = Blob.valueOf(csvString23);
      csvObject.uploadCSV(); 
        
      csvObject.fileName = 'DiseaseAssessment.csv'; 
      String csvString24 = '"CRFId","OClockPositionFrom","OClockPositionTo","Distancefromnipplecm","LongestDiameter","Clipplaced"\n"CRFId","OClockPositionFrom","OClockPositionTo","Distancefromnipplecm","LongestDiameter","Clipplaced"';
      csvObject.fileBody = Blob.valueOf(csvString24);
      csvObject.uploadCSV(); 
     }
   }
   @isTest static void myUnitTest10() {
        // TO DO: implement unit test
        
        List<User> lstSiteUser = [Select u.IsActive, u.Id From User u where Profile.Name = 'System Administrator' and IsActive = true];
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
        
        ErrorLog__c errorObject = new ErrorLog__c();
        errorObject.message__c = 'hello test';
        errorObject.IsSuccess__c = true;
        insert errorObject;
        
        Pre_Registration_Snomed_Codes__c pre = new Pre_Registration_Snomed_Codes__c();
        pre.Code_Master__c = snomedObject.Id;
        insert pre;
        
        Apexpages.currentPage().getParameters().put('inst',inst1.Id);
        Apexpages.currentPage().getParameters().put('site',site1.Id);
        Apexpages.currentPage().getParameters().put('trial',trial1.Id);
        Apexpages.currentPage().getParameters().put('transId',errorObject.Id);
    
        TestHarnessCRFUploadController csvObject = new TestHarnessCRFUploadController();

        csvObject.fileName = 'ChemoSummaryCRF.csv';   
        String csvString25 = '"patientId","CRFId","FirstDateofTaxaneTherapy"\n"patientId","CRFId","FirstDateofTaxaneTherapy"';
        csvObject.fileBody = Blob.valueOf(csvString25);
        csvObject.uploadCSV(); 
        
        csvObject.fileName = 'ChemoSummaryCRF.csv'; 
        String csvString26 = '"patientId","CRFId","FirstDateofTaxaneTherapy","LastDateofTaxaneTherapy","TaxaneRegimenTreatmentEndReasons","OtherReason","FirstDateofAnthracyclineTherapy","LastDateofAnthracyclineTherapy","AnthracyclineRegimenTreatmentEndReason","OtherReason1","FirstDateofInvestigationalTherapy","LastDateofInvestigationalTherapy","InvestigationalRegimenTreatmentEndReason","OtherReason2","CompletedDate","Status"\n"patientId","CRFId","FirstDateofTaxaneTherapy","LastDateofTaxaneTherapy","TaxaneRegimenTreatmentEndReasons","OtherReason","FirstDateofAnthracyclineTherapy","LastDateofAnthracyclineTherapy","AnthracyclineRegimenTreatmentEndReason","OtherReason1","FirstDateofInvestigationalTherapy","LastDateofInvestigationalTherapy","InvestigationalRegimenTreatmentEndReason","OtherReason2","CompletedDate","Status"';
        csvObject.fileBody = Blob.valueOf(csvString26);
        csvObject.uploadCSV(); 

        csvObject.fileName = 'ChemoSummaryRegimen_OSP_CRF.csv'; 
        String csvString27 = '"CRFId","FirstDateofTherapy","LastDateofTherapy"\n"CRFId","FirstDateofTherapy","LastDateofTherapy"';
        csvObject.fileBody = Blob.valueOf(csvString27);
        csvObject.uploadCSV(); 
        
        csvObject.fileName = 'ChemoSummaryRegimen_OSP_CRF.csv'; 
        String csvString28 = '"CRFId","FirstDateofTherapy","LastDateofTherapy","TreatmentEndReasons","OtherReason"\n"CRFId","FirstDateofTherapy","LastDateofTherapy","TreatmentEndReasons","OtherReason"';
        csvObject.fileBody = Blob.valueOf(csvString28);
        csvObject.uploadCSV(); 
       }
    }
    @isTest static void myUnitTest11() {
        // TO DO: implement unit test
        
        List<User> lstSiteUser = [Select u.IsActive, u.Id From User u where Profile.Name = 'System Administrator' and IsActive = true];
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
        
        ErrorLog__c errorObject = new ErrorLog__c();
        errorObject.message__c = 'hello test';
        errorObject.IsSuccess__c = true;
        insert errorObject;
        
        Pre_Registration_Snomed_Codes__c pre = new Pre_Registration_Snomed_Codes__c();
        pre.Code_Master__c = snomedObject.Id;
        insert pre;
        
        Apexpages.currentPage().getParameters().put('inst',inst1.Id);
        Apexpages.currentPage().getParameters().put('site',site1.Id);
        Apexpages.currentPage().getParameters().put('trial',trial1.Id);
        Apexpages.currentPage().getParameters().put('transId',errorObject.Id);
    
        TestHarnessCRFUploadController csvObject = new TestHarnessCRFUploadController();
    
        csvObject.fileName = 'ProtocolViolationCRF.csv'; 
        String csvString29 = '"patientId","DateOfProtocolViolation","Medicationnoncompliance"\n"patientId","DateOfProtocolViolation","Medicationnoncompliance"';
        csvObject.fileBody = Blob.valueOf(csvString29);
        csvObject.uploadCSV();
       
        csvObject.fileName = 'ProtocolViolationCRF.csv';
        String csvString30 = '"patientId","DateOfProtocolViolation","Medicationnoncompliance","Visitnoncomplicance","Onstudyprocedurerequiredbyprotocol","Incorrecttherapygiventopatient","Screeningandonstudytestlabdone","Screeningprocedurerequired","Eligibilitycriteriaexception","Enrollmentofineligeligibleiblepatient","Patientbecamepregnantpriortosurgery","OtherViolationCheckbox","OtherTypeofViolation","Narrativedescription","PatientRemainsonStudy","Patientwithdrawn","OtherActionCheckbox","OtherActionTaken","LocalIRBNotified","CompletedDate","Status"\n"patientId",,"DateOfProtocolViolation","Medicationnoncompliance","Visitnoncomplicance","Onstudyprocedurerequiredbyprotocol","Incorrecttherapygiventopatient","Screeningandonstudytestlabdone","Screeningprocedurerequired","Eligibilitycriteriaexception","Enrollmentofineligeligibleiblepatient","Patientbecamepregnantpriortosurgery","OtherViolationCheckbox","OtherTypeofViolation","Narrativedescription","PatientRemainsonStudy","Patientwithdrawn","OtherActionCheckbox","OtherActionTaken","LocalIRBNotified","CompletedDate","Status"';
        csvObject.fileBody = Blob.valueOf(csvString30);
        csvObject.uploadCSV();    
       
        }
    }
    @isTest static void myUnitTest12() {
        // TO DO: implement unit test
        
        List<User> lstSiteUser = [Select u.IsActive, u.Id From User u where Profile.Name = 'System Administrator' and IsActive = true];
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
        
        ErrorLog__c errorObject = new ErrorLog__c();
        errorObject.message__c = 'hello test';
        errorObject.IsSuccess__c = true;
        insert errorObject;
        
        Pre_Registration_Snomed_Codes__c pre = new Pre_Registration_Snomed_Codes__c();
        pre.Code_Master__c = snomedObject.Id;
        insert pre;
        
        Apexpages.currentPage().getParameters().put('inst',inst1.Id);
        Apexpages.currentPage().getParameters().put('site',site1.Id);
        Apexpages.currentPage().getParameters().put('trial',trial1.Id);
        Apexpages.currentPage().getParameters().put('transId',errorObject.Id);
    
        TestHarnessCRFUploadController csvObject = new TestHarnessCRFUploadController();

        csvObject.fileName = 'AEFormCRF.csv';   
        String csvString31 = '"patientId","CRFId","VisitDate"\n"patientId","CRFId","VisitDate"';
        csvObject.fileBody = Blob.valueOf(csvString31);
        csvObject.uploadCSV(); 
        
        csvObject.fileName = 'AEFormCRF.csv'; 
        String csvString32 = '"patientId","CRFId","VisitDate","PatientHospitalized","caAERSreportfiled","CompletedDate","Status"\n"patientId","CRFId","VisitDate","PatientHospitalized","caAERSreportfiled","CompletedDate","Status"';
        csvObject.fileBody = Blob.valueOf(csvString32);
        csvObject.uploadCSV(); 

        csvObject.fileName = 'Toxicity.csv'; 
        String csvString33 = '"CRFId","SymptomStatus","SymptomMasters"\n"CRFId","SymptomStatus","SymptomMasters"';
        csvObject.fileBody = Blob.valueOf(csvString33);
        csvObject.uploadCSV(); 
        
        csvObject.fileName = 'Toxicity.csv'; 
        String csvString34 = '"CRFId","SymptomStatus","SymptomMasters","ToxicityAgent","ToxicityOther","ToxicityStatus","Grade","Attribution","Waseventlifethreatning","Dideventrequiredhospitalization","Resultpersistentsignificantdisability","Resultconginentalabnormalitydefect","Didtheinvestigatorfindeventunusual","Dideventresultindeath","OnsetDate","SAE","Resolved","AEEndDate","PatientComplaint"\n"CRFId","SymptomStatus","SymptomMasters","ToxicityAgent","ToxicityOther","ToxicityStatus","Grade","Attribution","Waseventlifethreatning","Dideventrequiredhospitalization","Resultpersistentsignificantdisability","Resultconginentalabnormalitydefect","Didtheinvestigatorfindeventunusual","Dideventresultindeath","OnsetDate","SAE","Resolved","AEEndDate","PatientComplaint"';
        csvObject.fileBody = Blob.valueOf(csvString34);
        csvObject.uploadCSV(); 
       }
    }   
 
    @isTest static void myUnitTest13() {
        // TO DO: implement unit test
        
        List<User> lstSiteUser = [Select u.IsActive, u.Id From User u where Profile.Name = 'System Administrator' and IsActive = true];
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
        
        ErrorLog__c errorObject = new ErrorLog__c();
        errorObject.message__c = 'hello test';
        errorObject.IsSuccess__c = true;
        insert errorObject;
        
        Pre_Registration_Snomed_Codes__c pre = new Pre_Registration_Snomed_Codes__c();
        pre.Code_Master__c = snomedObject.Id;
        insert pre;
        
      Apexpages.currentPage().getParameters().put('inst',inst1.Id);
      Apexpages.currentPage().getParameters().put('site',site1.Id);
      Apexpages.currentPage().getParameters().put('trial',trial1.Id);
      Apexpages.currentPage().getParameters().put('transId',errorObject.Id);
    
      TestHarnessCRFUploadController csvObject = new TestHarnessCRFUploadController();

      csvObject.fileName = 'FollowupCRF.csv';   
      String csvString35 = '"patientId","CRFId","StartDate"\n"patientId","CRFId","StartDate"';
      csvObject.fileBody = Blob.valueOf(csvString35);
      csvObject.uploadCSV(); 
        
      csvObject.fileName = 'FollowupCRF.csv'; 
      String csvString36 = '"patientId","CRFId","StartDate","EndDate","Patientdocclinialassessment","ClinicalassessmentDate","SurvivalStatus","PatientDiagnoseWithNew","Dates","Surgery","SurgeryDetails","Chemotherapy","ChemotherapyDetails","RadiationTherapy","RadiationTherapyDetails","HormoneTherapy","HormoneTherapyDetails","CauseofDeath","DescribeCauseOfDeath","patientdiagnosedlocalprogression","LocalprogressionDate","patientdiagnoseddistantprogression","DistantprogressionDate","Recurrenceprogressioninformation","Local","Distant","Other","Patientreceivedadjuvanttherapy","RadiationTherapyStartDate","RadiationTherapyEndDate","LongTermTherapyforprimaryTrial","patienthaveamenstrualperiod","DateofLastMenstrualperiodUKData12M","DateofLastMenstrualperiod","OnEstrogenReplacement:","OnEstrogenReplacementMonths","OnEstrogenReplacementYears","Bilateraloophorectomy","BilateraloophorectomyDate","Hysterectomy","HysterectomyDate","Menopausalstatus","CompletedDate","Status"\n"patientId","CRFId","StartDate","EndDate","Patientdocclinialassessment","ClinicalassessmentDate","SurvivalStatus","PatientDiagnoseWithNew","Dates","Surgery","SurgeryDetails","Chemotherapy","ChemotherapyDetails","RadiationTherapy","RadiationTherapyDetails","HormoneTherapy","HormoneTherapyDetails","CauseofDeath","DescribeCauseOfDeath","patientdiagnosedlocalprogression","LocalprogressionDate","patientdiagnoseddistantprogression","DistantprogressionDate","Recurrenceprogressioninformation","Local","Distant","Other","Patientreceivedadjuvanttherapy","RadiationTherapyStartDate","RadiationTherapyEndDate","LongTermTherapyforprimaryTrial","patienthaveamenstrualperiod","DateofLastMenstrualperiodUKData12M","DateofLastMenstrualperiod","OnEstrogenReplacement:","OnEstrogenReplacementMonths","OnEstrogenReplacementYears","Bilateraloophorectomy","BilateraloophorectomyDate","Hysterectomy","HysterectomyDate","Menopausalstatus","CompletedDate","Status"';
      csvObject.fileBody = Blob.valueOf(csvString36);
      csvObject.uploadCSV(); 

      csvObject.fileName = 'TherapyReceived.csv'; 
      String csvString37 = '"CRFId","Therapy","Detail"\n"CRFId","Therapy","Detail"';
      csvObject.fileBody = Blob.valueOf(csvString37);
      csvObject.uploadCSV(); 
        
      csvObject.fileName = 'TherapyReceived.csv'; 
      String csvString38 = '"CRFId","Therapy","Detail","StartDateDatePerformed","EndDate"\n"CRFId","Therapy","Detail","StartDateDatePerformed","EndDate"';
      csvObject.fileBody = Blob.valueOf(csvString38);
      csvObject.uploadCSV(); 

      csvObject.fileName = 'IrradiatedSite.csv'; 
      String csvString39 = '"CRFId","Site","Laterality"\n"CRFId","Site","Laterality"';
      csvObject.fileBody = Blob.valueOf(csvString39);
      csvObject.uploadCSV(); 
        
      csvObject.fileName = 'IrradiatedSite.csv'; 
      String csvString40 = '"CRFId","Site","Laterality","DoseperFXcGy","TotalFX","TotaldosecGyAP"\n"CRFId","Site","Laterality","DoseperFXcGy","TotalFX","TotaldosecGyAP"';
      csvObject.fileBody = Blob.valueOf(csvString40);
      csvObject.uploadCSV(); 
     }
   }

      @isTest static void myUnitTest14() {
        // TO DO: implement unit test
        
        List<User> lstSiteUser = [Select u.IsActive, u.Id From User u where Profile.Name = 'System Administrator' and IsActive = true];
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
        
        ErrorLog__c errorObject = new ErrorLog__c();
        errorObject.message__c = 'hello test';
        errorObject.IsSuccess__c = true;
        insert errorObject;
        
        Pre_Registration_Snomed_Codes__c pre = new Pre_Registration_Snomed_Codes__c();
        pre.Code_Master__c = snomedObject.Id;
        insert pre;
        
      Apexpages.currentPage().getParameters().put('inst',inst1.Id);
      Apexpages.currentPage().getParameters().put('site',site1.Id);
      Apexpages.currentPage().getParameters().put('trial',trial1.Id);
      Apexpages.currentPage().getParameters().put('transId',errorObject.Id);
    
      TestHarnessCRFUploadController csvObject = new TestHarnessCRFUploadController();

      csvObject.fileName = 'BaselineSymptomsCRF.csv';   
      String csvString41 = '"patientId","CRFId","VisitDate"\n"patientId","CRFId","VisitDate"';
      csvObject.fileBody = Blob.valueOf(csvString41);
      csvObject.uploadCSV(); 
        
      csvObject.fileName = 'BaselineSymptomsCRF.csv'; 
      String csvString42 = '"patientId","CRFId","VisitDate","CompletedDate","Status"\n"patientId","CRFId","VisitDate","CompletedDate","Status"';
      csvObject.fileBody = Blob.valueOf(csvString42);
      csvObject.uploadCSV(); 

      csvObject.fileName = 'Allergy.csv'; 
      String csvString43 = '"CRFId","AllergyType","OtherAllergy"\n"CRFId","AllergyType","OtherAllergy"';
      csvObject.fileBody = Blob.valueOf(csvString43);
      csvObject.uploadCSV(); 
        
      csvObject.fileName = 'Allergy.csv'; 
      String csvString44 = '"CRFId","AllergyType","OtherAllergy","Allergies","Reactions","OtherReactions","Severity","Yearfirstseen","FormName"\n"CRFId","AllergyType","OtherAllergy","Allergies","Reactions","OtherReactions","Severity","Yearfirstseen","FormName"';
      csvObject.fileBody = Blob.valueOf(csvString44);
      csvObject.uploadCSV(); 

      csvObject.fileName = 'BaselineCondition.csv'; 
      String csvString45 = '"CRFId","DiagnosisType","OtherDaignosis"\n"CRFId","DiagnosisType","OtherDaignosis"';
      csvObject.fileBody = Blob.valueOf(csvString45);
      csvObject.uploadCSV(); 
        
      csvObject.fileName = 'BaselineCondition.csv'; 
      String csvString46 = '"CRFId","DiagnosisType","OtherDaignosis","Daignosis","SeverityGrade","Attribution","OnsetMonth","OnsetDay","OnsetYear","Resolved","EndMonth","EndDay"," EndYear"\n"CRFId","DiagnosisType","OtherDaignosis","Daignosis","SeverityGrade","Attribution","OnsetMonth","OnsetDay","OnsetYear","Resolved","EndMonth","EndDay"," EndYear"';
      csvObject.fileBody = Blob.valueOf(csvString46);
      csvObject.uploadCSV(); 

      csvObject.fileName = 'Toxicities.csv';   
      String csvString47 = '"CRFId","SymptomStatus","SymptomMasters"\n"CRFId","SymptomStatus","SymptomMasters"';
      csvObject.fileBody = Blob.valueOf(csvString47);
      csvObject.uploadCSV(); 
        
      csvObject.fileName = 'Toxicities.csv'; 
      String csvString48 = '"CRFId","SymptomStatus","SymptomMasters","ToxicityAgent","ToxicityOther","ToxicityStatus","Grade","Attribution","Waseventlifethreatning","Dideventrequiredhospitalization","Resultpersistentsignificantdisability","Resultconginentalabnormalitydefect","Didtheinvestigatorfindeventunusual","Dideventresultindeath","OnsetDate","SAE","Resolved","AEEndDate","PatientComplaint"\n"CRFId","SymptomStatus","SymptomMasters","ToxicityAgent","ToxicityOther","ToxicityStatus","Grade","Attribution","Waseventlifethreatning","Dideventrequiredhospitalization","Resultpersistentsignificantdisability","Resultconginentalabnormalitydefect","Didtheinvestigatorfindeventunusual","Dideventresultindeath","OnsetDate","SAE","Resolved","AEEndDate","PatientComplaint"';
      csvObject.fileBody = Blob.valueOf(csvString48);
      csvObject.uploadCSV(); 
     }
   }

      @isTest static void myUnitTest15() {
        // TO DO: implement unit test
        
        List<User> lstSiteUser = [Select u.IsActive, u.Id From User u where Profile.Name = 'System Administrator' and IsActive = true];
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
        
        ErrorLog__c errorObject = new ErrorLog__c();
        errorObject.message__c = 'hello test';
        errorObject.IsSuccess__c = true;
        insert errorObject;
        
        Pre_Registration_Snomed_Codes__c pre = new Pre_Registration_Snomed_Codes__c();
        pre.Code_Master__c = snomedObject.Id;
        insert pre;
        
      Apexpages.currentPage().getParameters().put('inst',inst1.Id);
      Apexpages.currentPage().getParameters().put('site',site1.Id);
      Apexpages.currentPage().getParameters().put('trial',trial1.Id);
      Apexpages.currentPage().getParameters().put('transId',errorObject.Id);
    
      TestHarnessCRFUploadController csvObject = new TestHarnessCRFUploadController();

      csvObject.fileName = 'PostSurgeryCRF.csv';   
      String csvString49 = '"patientId","CRFId","DateOfProcedure "\n"patientId","CRFId","DateOfProcedure "';
      csvObject.fileBody = Blob.valueOf(csvString49);
      csvObject.uploadCSV(); 
        
      csvObject.fileName = 'PostSurgeryCRF.csv'; 
      String csvString50 = '"patientId","CRFId","DateOfProcedure ","Surgeon","SurgeonOther","TypeOfTumor","SizeofGrossMassHeight","SizeofGrossMassWidth","GrossMassMeasurementUnit","SizeofLargestGrossMassHeight","SizeofLargestGrossMassWidth","LargestGrossMassMeasurementUnit","Totalspanmultifocalgrossmassheight","Totalspanmultifocalgrossmasswidth","TotalSpanMeasurementUnit","Spanofgrosschangesheight","Spanofgrosschangeswidth","GrossChangesMeasurementUnit","Lymphnodedissectiondone","AreCalcificationsPresent","CalcificationDetails","IsDCISPresent","IsLCISPresent","Isinvasivetumorpresent","separatelysubmittedmargins","InvasiveCAPresent","InvasiveCAattruemargin","InSituDiseasePresent","InSituDiseaseAtTrueMargin","OtherChangesPresent","OtherChanges","OtherChange","pcr","PrimaryTumorBedArea","OverallCenterCellularity","percentageofCAinSituDisease","Numberoflymphnodespositive","Diameteroflargestmet","RCBindex","RCBClass","CompletedDate","Status"\n"patientId","CRFId","DateOfProcedure ","Surgeon","SurgeonOther","TypeOfTumor","SizeofGrossMassHeight","SizeofGrossMassWidth","GrossMassMeasurementUnit","SizeofLargestGrossMassHeight","SizeofLargestGrossMassWidth","LargestGrossMassMeasurementUnit","Totalspanmultifocalgrossmassheight","Totalspanmultifocalgrossmasswidth","TotalSpanMeasurementUnit","Spanofgrosschangesheight","Spanofgrosschangeswidth","GrossChangesMeasurementUnit","Lymphnodedissectiondone","AreCalcificationsPresent","CalcificationDetails","IsDCISPresent","IsLCISPresent","Isinvasivetumorpresent","separatelysubmittedmargins","InvasiveCAPresent","InvasiveCAattruemargin","InSituDiseasePresent","InSituDiseaseAtTrueMargin","OtherChangesPresent","OtherChanges","OtherChange","pcr","PrimaryTumorBedArea","OverallCenterCellularity","percentageofCAinSituDisease","Numberoflymphnodespositive","Diameteroflargestmet","RCBindex","RCBClass","CompletedDate","Status"';
      csvObject.fileBody = Blob.valueOf(csvString50);
      csvObject.uploadCSV(); 

      csvObject.fileName = 'ProcedureSpecimen.csv'; 
      String csvString51 = '"CRFId","Procedure","Specimen"\n"CRFId","Procedure","Specimen"';
      csvObject.fileBody = Blob.valueOf(csvString51);
      csvObject.uploadCSV(); 
        
      csvObject.fileName = 'ProcedureSpecimen.csv'; 
      String csvString52 = '"CRFId","Procedure","Specimen","MainSpecimensubmittedforhistology","SingleSpecimentsubmittedforhistology","MediallateralGrossspecimensize","Mediallateralsizeunit","AnteriordeepGrossspecimensize","Anteriordeepsizeunit","SuperorinferiorGrossspecimensize","Superorinferiorsizeunit","TotalSlices","SlicingMethod","SlicePlane1","Slice1","Block1","SlicePlane2","Slice2","Block2","PerformingLab","Lymphnodetissuepresentinsample"\n"CRFId","Procedure","Specimen","MainSpecimensubmittedforhistology","SingleSpecimentsubmittedforhistology","MediallateralGrossspecimensize","Mediallateralsizeunit","AnteriordeepGrossspecimensize","Anteriordeepsizeunit","SuperorinferiorGrossspecimensize","Superorinferiorsizeunit","TotalSlices","SlicingMethod","SlicePlane1","Slice1","Block1","SlicePlane2","Slice2","Block2","PerformingLab","Lymphnodetissuepresentinsample"';
      csvObject.fileBody = Blob.valueOf(csvString52);
      csvObject.uploadCSV(); 

      csvObject.fileName = 'LymphNode.csv'; 
      String csvString53 = '"CRFId","Procedure","Letarality"\n"CRFId","Procedure","Letarality"';
      csvObject.fileBody = Blob.valueOf(csvString53);
      csvObject.uploadCSV(); 
        
      csvObject.fileName = 'LymphNode.csv'; 
      String csvString54 = '"CRFId","Procedure","Letarality","SentinelNodes","Location","Positive","Examined","MethodofDetection","SingleDetectionResult","ClusterDetectionResult","FocusDetectionResult","NotreportedDetectionResult","SizeofLargestTumor","SpecificSizeofLargestTumor","TumorSizeMeasurementUnit","ExtramodalExtension","AxillaryNodes","Positive1","Examined1","MethodofDetection1","SingleDetectionResult1","ClusterDetectionResult1","FocusDetectionResult1","NotreportedDetectionResult1","SizeofLargestTumor1","SpecificSizeofLargestTumor1","TumorSizeMeasurementUnit1","ExtramodalExtension1","AdditionalNodes","Location1","Positive2","Examined2","SizeofLargestTumor2","SpecificSizeofLargestTumor2:","TumorSizeMeasurementUnit2","ExtramodalExtension2"\n"CRFId","Procedure","Letarality","SentinelNodes","Location","Positive","Examined","MethodofDetection","SingleDetectionResult","ClusterDetectionResult","FocusDetectionResult","NotreportedDetectionResult","SizeofLargestTumor","SpecificSizeofLargestTumor","TumorSizeMeasurementUnit","ExtramodalExtension","AxillaryNodes","Positive1","Examined1","MethodofDetection1","SingleDetectionResult1","ClusterDetectionResult1","FocusDetectionResult1","NotreportedDetectionResult1","SizeofLargestTumor1","SpecificSizeofLargestTumor1","TumorSizeMeasurementUnit1","ExtramodalExtension1","AdditionalNodes","Location1","Positive2","Examined2","SizeofLargestTumor2","SpecificSizeofLargestTumor2:","TumorSizeMeasurementUnit2","ExtramodalExtension2"';
      csvObject.fileBody = Blob.valueOf(csvString54);
      csvObject.uploadCSV(); 

      csvObject.fileName = 'Receptors.csv';   
      String csvString55 = '"OSPId","ERStatus","ERProporationScore"\n"OSPId","ERStatus","ERProporationScore"';
      csvObject.fileBody = Blob.valueOf(csvString55);
      csvObject.uploadCSV(); 
        
      csvObject.fileName = 'Receptors.csv'; 
      String csvString56 = '"OSPId","ERStatus","ERProporationScore","ERIntensityScore","TotalScoreER","PRStatus","PRProporationScore","PRIntensityScore","TotalScorePR","HER2neuMarkerStatus","DAKOHerceptest","OtherIHCTest","OtherIHCResult","VentanaKit","CB11","IHCTestNotDone","VentanaOncoprobe","OtherFISHTest","OtherFISHResults","FISHTestNotDone","VysisPathVision","VysisPathVisionValue","Letarality"\n"OSPId","ERStatus","ERProporationScore","ERIntensityScore","TotalScoreER","PRStatus","PRProporationScore","PRIntensityScore","TotalScorePR","HER2neuMarkerStatus","DAKOHerceptest","OtherIHCTest","OtherIHCResult","VentanaKit","CB11","IHCTestNotDone","VentanaOncoprobe","OtherFISHTest","OtherFISHResults","FISHTestNotDone","VysisPathVision","VysisPathVisionValue","Letarality"';
      csvObject.fileBody = Blob.valueOf(csvString56);
      csvObject.uploadCSV(); 

      csvObject.fileName = 'StagingDetail.csv';   
      String csvString57 = '"CRFId","Letarality","StagingModifierType"\n"CRFId","Letarality","StagingModifierType"';
      csvObject.fileBody = Blob.valueOf(csvString57);
      csvObject.uploadCSV(); 
        
      csvObject.fileName = 'StagingDetail.csv'; 
      String csvString58 = '"CRFId","Letarality","StagingModifierType","Modifiermultipleprimary","Modifierclassificationdone","Modifierindicatesrecurrent","Modifierdesignates","TumorType","NodeType","Metastasis","CalculatedStage","CalculatedStageValue","AdjudicatedStage","AdjudicatedBy","T4Tumorfinalstatus"\n"CRFId","Letarality","StagingModifierType","Modifiermultipleprimary","Modifierclassificationdone","Modifierindicatesrecurrent","Modifierdesignates","TumorType","NodeType","Metastasis","CalculatedStage","CalculatedStageValue","AdjudicatedStage","AdjudicatedBy","T4Tumorfinalstatus"';
      csvObject.fileBody = Blob.valueOf(csvString58);
      csvObject.uploadCSV(); 

      csvObject.fileName = 'Procedures.csv';   
      String csvString59 = '"CRFId","ProcedureName","Laterality"\n"CRFId","ProcedureName","Laterality"';
      csvObject.fileBody = Blob.valueOf(csvString59);
      csvObject.uploadCSV(); 
        
      csvObject.fileName = 'Procedures.csv'; 
      String csvString60 = '"CRFId","ProcedureName","Laterality","Location"\n"CRFId","ProcedureName","Laterality","Location"';
      csvObject.fileBody = Blob.valueOf(csvString60);
      csvObject.uploadCSV();

      csvObject.fileName = 'DCISs.csv';   
      String csvString61 = '"CRFId","DCIS","UnknownNotReported"\n"CRFId","DCIS","UnknownNotReported"';
      csvObject.fileBody = Blob.valueOf(csvString61);
      csvObject.uploadCSV(); 
        
      csvObject.fileName = 'DCISs.csv'; 
      String csvString62 = '"CRFId","DCIS","UnknownNotReported","TotalHistologicalSpan","TotalHistologicalSpanMeasurementUnit","Margin","ClosestMargin","SpecificClosestMargin","SpecificClosestMarginMeasurementUnit","PunctateNecrosis","Comedonecrosis","Papillary","Micropapillary","Necrosis","Cribiform","Cruciform","Clinging","Solid","Apocrine","IntraCysticEncystedPapillary","Other","Otherifothermentiontypeintextbox","NuclearGrade"\n"CRFId","DCIS","UnknownNotReported","TotalHistologicalSpan","TotalHistologicalSpanMeasurementUnit","Margin","ClosestMargin","SpecificClosestMargin","SpecificClosestMarginMeasurementUnit","PunctateNecrosis","Comedonecrosis","Papillary","Micropapillary","Necrosis","Cribiform","Cruciform","Clinging","Solid","Apocrine","IntraCysticEncystedPapillary","Other","Otherifothermentiontypeintextbox","NuclearGrade"';
      csvObject.fileBody = Blob.valueOf(csvString62);
      csvObject.uploadCSV(); 

      csvObject.fileName = 'LCISs.csv';   
      String csvString63 = '"CRFId","LCIS","UnknownNotReported"\n"CRFId","LCIS","UnknownNotReported"';
      csvObject.fileBody = Blob.valueOf(csvString63);
      csvObject.uploadCSV(); 
        
      csvObject.fileName = 'LCISs.csv'; 
      String csvString64 = '"CRFId","LCIS","UnknownNotReported","Totalhistologicalspan","Totalhistologicalspanmeasurementunit","HistologicalType"\n"CRFId","LCIS","UnknownNotReported","Totalhistologicalspan","Totalhistologicalspanmeasurementunit","HistologicalType"';
      csvObject.fileBody = Blob.valueOf(csvString64);
      csvObject.uploadCSV(); 
         

      csvObject.fileName = 'InvasiveTumors.csv';   
      String csvString65 = '"CRFId","Overallcancercellularity","UnknownNotReported"\n"CRFId","Overallcancercellularity","UnknownNotReported"';
      csvObject.fileBody = Blob.valueOf(csvString65);
      csvObject.uploadCSV(); 
        
      csvObject.fileName = 'InvasiveTumors.csv'; 
      String csvString66 = '"CRFId","Overallcancercellularity","UnknownNotReported","TumorSizeHeight","TumorSizeWidth","TumorMeasurementUnit","MultifocalTumor","Invasivemargins","ClosestMargin","SpecifyNo","SpecifyUnits","InvasiveDuctalCarcinomaNos","InvasiveLobularCarcinomaClassicType","InvasiveLobularCarcinomaAlveolarType","PleomorphicLobularCarcinoma","TubulolobularCarcinoma","InvasiveCarcinomaMixedDuctalAndLobularType","TubularCarcinoma","MucinousCarcinoma","MedullaryCarcinoma","InvasivePapillaryCarcinoma","InvasiveCribiformCarcinoma","Other","Otherifothermentiontypeintextbox","NuclearGrade","MitoticCount","TubulePapillaFormation","TotalPoints","SBRGrade","LympaticVascularInvasion","DermalInvolvement","Muscleinvolvement","Evidenceoftherapeuticeffects","Otherchangespresent"\n"CRFId","Overallcancercellularity","UnknownNotReported","TumorSizeHeight","TumorSizeWidth","TumorMeasurementUnit","MultifocalTumor","Invasivemargins","ClosestMargin","SpecifyNo","SpecifyUnits","InvasiveDuctalCarcinomaNos","InvasiveLobularCarcinomaClassicType","InvasiveLobularCarcinomaAlveolarType","PleomorphicLobularCarcinoma","TubulolobularCarcinoma","InvasiveCarcinomaMixedDuctalAndLobularType","TubularCarcinoma","MucinousCarcinoma","MedullaryCarcinoma","InvasivePapillaryCarcinoma","InvasiveCribiformCarcinoma","Other","Otherifothermentiontypeintextbox","NuclearGrade","MitoticCount","TubulePapillaFormation","TotalPoints","SBRGrade","LympaticVascularInvasion","DermalInvolvement","Muscleinvolvement","Evidenceoftherapeuticeffects","Otherchangespresent"';
      csvObject.fileBody = Blob.valueOf(csvString66);
      csvObject.uploadCSV();  
     }
   }


      @isTest static void myUnitTest16() {
        // TO DO: implement unit test
        
        List<User> lstSiteUser = [Select u.IsActive, u.Id From User u where Profile.Name = 'System Administrator' and IsActive = true];
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
        
        ErrorLog__c errorObject = new ErrorLog__c();
        errorObject.message__c = 'hello test';
        errorObject.IsSuccess__c = true;
        insert errorObject;
        
        Pre_Registration_Snomed_Codes__c pre = new Pre_Registration_Snomed_Codes__c();
        pre.Code_Master__c = snomedObject.Id;
        insert pre;
        
      Apexpages.currentPage().getParameters().put('inst',inst1.Id);
      Apexpages.currentPage().getParameters().put('site',site1.Id);
      Apexpages.currentPage().getParameters().put('trial',trial1.Id);
      Apexpages.currentPage().getParameters().put('transId',errorObject.Id);
    
      TestHarnessCRFUploadController csvObject = new TestHarnessCRFUploadController();

      csvObject.fileName = 'ChemoTreatmentCRF.csv';   
      String csvString67 = '"patientId","CRFId","Dateoftherapy"\n"patientId","CRFId","Dateoftherapy"';
      csvObject.fileBody = Blob.valueOf(csvString67);
      csvObject.uploadCSV(); 
        
      csvObject.fileName = 'ChemoTreatmentCRF.csv'; 
      String csvString68 = '"patientId","CRFId","Dateoftherapy","Cyclenumber","Didpatientgooffstudytreatment","Patientweight","Patientheight","CompletedDate","Status"\n"patientId","CRFId","Dateoftherapy","Cyclenumber","Didpatientgooffstudytreatment","Patientweight","Patientheight","CompletedDate","Status"';
      csvObject.fileBody = Blob.valueOf(csvString68);
      csvObject.uploadCSV(); 

      csvObject.fileName = 'ChemoTherapyRegimen.csv'; 
      String csvString69 = '"CRFId","Agent","PrescribedDose"\n"CRFId","Agent","PrescribedDose"';
      csvObject.fileBody = Blob.valueOf(csvString69);
      csvObject.uploadCSV(); 
        
      csvObject.fileName = 'ChemoTherapyRegimen.csv'; 
      String csvString70 = '"CRFId","Agent","PrescribedDose","TotalDoseAdministered","Day","DoseDelay","DoseMod","Dosemodification","OtherDoseModReason","Didpatientstopreceiving","Reasonwhypatientstoppedreceiving","OtherReasonPatientStopReceiving","OtherAgent","PrescribeddoseUnits","AdministereddoseUnits"\n"CRFId","Agent","PrescribedDose","TotalDoseAdministered","Day","DoseDelay","DoseMod","Dosemodification","OtherDoseModReason","Didpatientstopreceiving","Reasonwhypatientstoppedreceiving","OtherReasonPatientStopReceiving","OtherAgent","PrescribeddoseUnits","AdministereddoseUnits"';
      csvObject.fileBody = Blob.valueOf(csvString70);
      csvObject.uploadCSV(); 

      csvObject.fileName = 'GrowthFactor.csv'; 
      String csvString71 = '"CRFId","Name","Dose"\n"CRFId","Name","Dose"';
      csvObject.fileBody = Blob.valueOf(csvString71);
      csvObject.uploadCSV(); 
        
      csvObject.fileName = 'GrowthFactor.csv'; 
      String csvString72 = '"CRFId","Name","Dose","TotalDose","Route","Notes","isReceive"\n"CRFId","Name","Dose","TotalDose","Route","Notes","isReceive"';
      csvObject.fileBody = Blob.valueOf(csvString72);
      csvObject.uploadCSV(); 

      csvObject.fileName = 'ConcomitantMedication.csv';   
      String csvString73 = '"CRFId","Type","OtherMadication"\n"CRFId","Type","OtherMadication"';
      csvObject.fileBody = Blob.valueOf(csvString73);
      csvObject.uploadCSV(); 
        
      csvObject.fileName = 'ConcomitantMedication.csv'; 
      String csvString74 = '"CRFId","Type","OtherMadication","Medication","StartYear","StartMonth","StartDay","EndYear","EndMonth","EndDay","DoseValue","Dose","Route","Frequency"\n"CRFId","Type","OtherMadication","Medication","StartYear","StartMonth","StartDay","EndYear","EndMonth","EndDay","DoseValue","Dose","Route","Frequency"';
      csvObject.fileBody = Blob.valueOf(csvString74);
      csvObject.uploadCSV(); 
     }
   }
}