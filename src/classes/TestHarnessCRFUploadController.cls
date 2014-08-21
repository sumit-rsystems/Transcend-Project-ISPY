public with sharing class TestHarnessCRFUploadController extends PageControllerBase {
    public String institution {get;set;}
    public List<SelectOption> lstInstitution {get;set;}
    public String site {get;set;}
    public List<SelectOption> lstSite {get;set;}
    public String trial {get;set;}
    public List<SelectOption> lstTrial {get;set;} 
    
    public String instLbl {get;set;}
    public String siteLbl {get;set;}
    public String trialLbl {get;set;}
    
    public String crfName {get;set;}
    public Blob fileBody {get;set;}
    public String fileName {get;set;}
    
    public String csvContent {get;set;} 
    public String msg {get;set;} 
    public boolean showMsg {get;set;}
    public String severity {get;set;}
    
    public String patientMsg {get;set;}
    public String transId {get;set;}
    public String currentTab {get;set;}
    public String csvResult {get;set;}
    public String csvResultLink {get;set;}
    public boolean associationSelected {get;set;}
    public boolean showRunButton1 {get;set;}
    public boolean showRunButton2 {get;set;}
    public List<List<RandomizationResultWrapper>> lstRandResultWrapperList {get;set;}
    public List<Selectoption> lstTestHarnessType {get;set;}
    public String testHarnessType {get;set;}
    public TestHarnessHistory__c randomizationRunHistory {get;set;}
    public TestHarnessHistory__c completeRunHistory {get;set;}
    
    private String sortDirection = 'ASC';
    private String sortExp = 'name';

    public String sortExpression
    {
        get
        {
            return sortExp;
        }
        set
        {
            //if the column is clicked on then switch between Ascending and Descending modes
            if (value == sortExp)
                sortDirection = (sortDirection == 'ASC')? 'DESC' : 'ASC';
            else
            sortDirection = 'ASC';
            sortExp = value;
        }
   }

    public String getSortDirection()
    {
        //if not column is selected 
        if (sortExpression == null || sortExpression == '')
            return 'ASC';
        else
            return sortDirection;
    }

    public void setSortDirection(String value)
    {  
        sortDirection = value;
    }
    
    public void displayRandomizationResult() {
        TestHarnessService service = new TestHarnessService();
        lstRandResultWrapperList = service.getRandomizationResult(sortExpression  + ' ' + sortDirection);
    }
    
    public TestHarnessCRFUploadController() {
        system.debug('Constructor called : ');
        
        lstTestHarnessType = new List<Selectoption>();
        lstTestHarnessType.add(new Selectoption('','None'));
        lstTestHarnessType.add(new Selectoption('Randomization','Randomization Test Harness'));
        lstTestHarnessType.add(new Selectoption('Complete','Complete Test Harness'));
        
        List<TestHarnessHistory__c> lstRandomizationTestHist = [select Status__c, CreatedDate, CreatedById, CreatedBy.Name, TestHarnessType__c from TestHarnessHistory__c where TestHarnessType__c = 'Randomization' order by CreatedDate DESC];
        if(!lstRandomizationTestHist.isEmpty()) {
            randomizationRunHistory = lstRandomizationTestHist[0];
            system.debug('randomizationRunHistory : '+randomizationRunHistory);
        }
        
        List<TestHarnessHistory__c> lstCompleteTestHist = [select Status__c, CreatedDate, CreatedById, CreatedBy.Name, TestHarnessType__c from TestHarnessHistory__c where TestHarnessType__c = 'Complete' order by CreatedDate DESC];
        if(!lstCompleteTestHist.isEmpty()) {
            completeRunHistory = lstCompleteTestHist[0];
        }
        
        List<RandomizationTestingDetail__c> lstRTD = [Select r.IsRandomized__c From RandomizationTestingDetail__c r where IsRandomized__c = false];
        if(!lstRTD.isEmpty()) {
            showRunButton1 = true;
        } else {
            showRunButton1 = false;
        }
        
        showRunButton2 = false;
        List<TrialPatient__c> lstTrialPatient = [Select t.Patient_Id__r.IsTestHarnessPatient__c, t.Patient_Id__c, t.IsRandomized__c From TrialPatient__c t where Patient_Id__r.IsTestHarnessPatient__c = true and IsRandomized__c = false];
        for(TrialPatient__c tp : lstTrialPatient) {
            RandomizationFormController rfc = new RandomizationFormController();
            rfc.trialPatientId = tp.Id;
            boolean eligibleForRandomize = true;//rfc.checkPatientEligibilityForRandomization();
            if(eligibleForRandomize) {
                showRunButton2 = true;
                break;  
            }
        }
        
        institution = Apexpages.currentPage().getParameters().get('inst');
        site = Apexpages.currentPage().getParameters().get('site');
        trial = Apexpages.currentPage().getParameters().get('trial');
        transId = Apexpages.currentPage().getParameters().get('transId');
        
        system.debug('institution : '+institution);
        system.debug('site : '+site);
        system.debug('trial : '+trial);
        system.debug('transId : '+transId);
        
        if(transId != null) {
            List<ErrorLog__c> errorLog = [select Result__c, message__c,IsSuccess__c from ErrorLog__c where Id = :transId];
            if(!errorLog.isEmpty()) { 
                patientMsg = errorLog[0].message__c;
                if(errorLog[0].IsSuccess__c) {
                    severity = 'info';
                    if(errorLog[0].Result__c != null) {
                        csvResult = errorLog[0].Result__c;
                        if(csvResult != null) {
                            csvResult = csvResult.replace('##NEXT_LINE##', '\n');
                        }
                        csvResultLink = '/apex/CSVDownloadPage?transId='+transId;
                    }
                } else {
                    severity = 'error';
                }
                showMsg = true;
            } else {
                showMsg = false;
            }
        }
        
        if(institution != null && site != null && trial != null) {
            Account acc = [select Name from Account where Id = :institution];
            Site__c st = [select Name from Site__c where Id = :site];
            Trial__c tr = [select Name from Trial__c where Id = :trial];
            instLbl = acc.Name;
            siteLbl = st.Name;
            trialLbl = tr.Name;
        }
        
        lstInstitution = new List<SelectOption>();
        lstSite = new List<SelectOption>();
        lstTrial = new List<SelectOption>();
        
        lstInstitution.add(new SelectOption('','------None------'));
        lstSite.add(new SelectOption('','------None------'));
        lstTrial.add(new SelectOption('','------None------'));
        
        loadInstitution();
        loadTrial();
    }
    
    public void sortResult() {
        TestHarnessService service = new TestHarnessService();
        lstRandResultWrapperList = service.getRandomizationResult(sortExpression  + ' ' + sortDirection);
        system.debug('lstRandResultWrapperList.size() : '+lstRandResultWrapperList.size());
        
        for(List<RandomizationResultWrapper> lstRR : lstRandResultWrapperList) {
            system.debug('lstRR.size() : '+lstRR.size());
        }
    }
    public void loadInstitution() {
        institution = null;
        site = null;
        trial = null;
        List<Account> lstInst = [select Name from Account where RecordType.Name = 'Institution' order by createdDate desc];
        for(Account acc : lstInst) {
            lstInstitution.add(new SelectOption(acc.Id,acc.Name));
        }
        if(institution != null && site != null && trial != null) {
            associationSelected = true;
        } else {
            associationSelected = false;
        }
    }
    
    public void loadSite() {
        site = null;
        trial = null;
        lstSite.clear();
        lstTrial.clear();
        lstSite.add(new SelectOption('','------None------'));
        lstTrial.add(new SelectOption('','------None------'));
        List<Site__c> lstOfSite = [select Name from Site__c where Institute__c = :institution];
        for(Site__c site : lstOfSite) {
            lstSite.add(new SelectOption(site.Id,site.Name));
        }
        
        if(institution != null && site != null && trial != null) {
            associationSelected = true;
        } else {
            associationSelected = false;
        }
    }
    
    public void loadTrial() {
        lstTrial.clear();
        lstTrial.add(new SelectOption('','------None------'));
        List<Site_Trial__c> lstSiteTrial = [select Site__c, Trial__c, Trial__r.Name from Site_Trial__c where Site__c = :site order by createdDate desc];
        for(Site_Trial__c siteTrial : lstSiteTrial) {
            if(siteTrial.Trial__r.Name != null) {
                lstTrial.add(new SelectOption(siteTrial.Trial__c,siteTrial.Trial__r.Name));
            }
        }
        
        if(institution != null && site != null && trial != null) {
            associationSelected = true;
        } else {
            associationSelected = false;
        }
        testHarnessType = '';
    }
    
    integer nextform = 1;
    
    public Pagereference uploadCSV() {
        Pagereference ref = null;
        string s= Apexpages.currentPage().getParameters().get('check');
        system.debug('s:============ '+s);
        institution = Apexpages.currentPage().getParameters().get('inst');
        site = Apexpages.currentPage().getParameters().get('site');
        trial = Apexpages.currentPage().getParameters().get('trial');
        transId = Apexpages.currentPage().getParameters().get('transId');
        
        system.debug('institution : '+institution);
        system.debug('site : '+site);
        system.debug('trial : '+trial);
        //fileName = fileUploaderController.fileName;
        //fileBody = fileUploaderController.fileBody;
        system.debug('file Name : '+fileName);
        system.debug('file Body : '+fileBody);
        if(fileBody == null || fileName == null) {
            msg = 'No file found. Please upload csv file.';
            severity = 'error';
            ref = new Pagereference('/apex/uploadCRFForTestHarness?inst='+institution+'&site='+site+'&trial='+trial+'&nextForm='+nextform+'&transId='+transId);
            ref.setRedirect(true);
            return ref;
        }
        showMsg = true;
        List<String> fileNameSplit = fileName.split('\\.');
        if(fileNameSplit != null && fileNameSplit.size() > 1) {
            if(fileNameSplit[1] != 'csv') {
                msg = 'Please upload file with ".csv" extension only.';
                severity = 'error';
                ref = new Pagereference('/apex/uploadCRFForTestHarness?inst='+institution+'&site='+site+'&trial='+trial+'&nextForm='+nextform+'&transId='+transId);
                ref.setRedirect(true);
                return ref;
            }
        } else {
            msg = 'Please upload file with ".csv" extension only.';
            severity = 'error';
            ref = new Pagereference('/apex/uploadCRFForTestHarness?inst='+institution+'&site='+site+'&trial='+trial+'&nextForm='+nextform+'&transId='+transId);
            ref.setRedirect(true);
            return ref;
        }
        TestHarnessService service = new TestHarnessService();
        
        system.debug('so=========='+ s);
        if( s != null && s != '' && s!=fileNameSplit[0]){
            system.debug('s=========='+ s);
            transId = service.insertErrorLog('Failure : '+'Please upload file ' + s + '.csv.');
            ref = new Pagereference('/apex/uploadCRFForTestHarness?inst='+institution+'&site='+site+'&trial='+trial+'&nextForm='+nextform+'&transId='+transId);
            ref.setRedirect(true);
            return ref;
        }
        try {
            system.debug('csvContent================='+fileBody);
            csvContent = fileBody.toString();
            system.debug('csvContent============'+csvContent);  
        } catch (Exception e) {
            msg = 'There is some problem with csv data. Please ensure that the file you have uploaded is in correct format.';
            
            system.debug('erro=r==========='+e.getMessage()); 
            severity = 'error';
            ref = new Pagereference('/apex/uploadCRFForTestHarness?inst='+institution+'&site='+site+'&trial='+trial+'&nextForm='+nextform+'&transId='+transId);
            ref.setRedirect(true);
            return ref;
        }
        
        
        List<List<String>> lstCSVData = CSVParser.parseCSV(csvContent, true);
        if(fileNameSplit[0] == 'Patient') {
            
            List<Patient> lstPatient = new List<Patient>();
            for(List<String> lstStr : lstCSVData) {
            system.debug('======sau12111===='+ lstCSVData);
        system.debug('======sau12111111===='+ lstCSVData.size());
        system.debug('======sau12111111111111===='+ lstStr.size());
        system.debug('======sau121111111111===='+ lstStr != null);
        system.debug('======sau12111111111111111===='+ lstStr);
                if(!(lstStr != null && lstStr.size() == 19)) {
                    system.debug('======sau121===='+ lstCSVData);
                    transId = service.insertErrorLog('Failure : '+'Number of column headers should be 19. Please ensure that the file you have uploaded has sufficient number of column.');
                    ref = new Pagereference('/apex/uploadCRFForTestHarness?inst='+institution+'&site='+site+'&trial='+trial+'&nextForm='+nextform+'&transId='+transId);
                    ref.setRedirect(true);
                    return ref;
                }
                Patient patient = new Patient();
                patient.TestHarnessId = lstStr[0];
                patient.FirstName = lstStr[1];
                patient.MiddleName = lstStr[2];
                patient.LastName = lstStr[3];
                patient.Suffix = lstStr[4];
                patient.Gender = lstStr[5];
                patient.Birthdate = lstStr[6];
                patient.AddressLine1 = lstStr[7];
                patient.AddressLine2 = lstStr[8];
                patient.City = lstStr[9];
                patient.State = lstStr[10];
                patient.Country = lstStr[11];
                patient.Zip = lstStr[12];
                patient.Race = lstStr[13];
                patient.Ethnicity = lstStr[14];
                patient.MedicalRecordNumber = lstStr[15];
                patient.CountryOfBirth = lstStr[16];
                patient.CompletedDate = lstStr[17];
                patient.Status = lstStr[18];
                lstPatient.add(patient);
            }
            
            if(!Test.isRunningTest()) { 
                transId = service.createPatient(institution,site,trial,lstPatient);
            }
            nextform = 2;
        } else if(fileNameSplit[0] == 'PreEligibilityCRF') {
            List<PreEligibilityCRF> lstPreEligibilityCRF = new List<PreEligibilityCRF>();
            for(List<String> lstStr : lstCSVData) {
                system.debug('lstStr : '+lstStr+'   lstStr.size() : '+lstStr.size());
                if(!(lstStr != null && lstStr.size() == 16)) {
                    transId = service.insertErrorLog('Failure : '+'Number of column headers should be 16. Please ensure that the file you have uploaded has sufficient number of column.');
                    ref = new Pagereference('/apex/uploadCRFForTestHarness?inst='+institution+'&site='+site+'&trial='+trial+'&nextForm='+nextform+'&transId='+transId);
                    ref.setRedirect(true);
                    return ref;
                }
                PreEligibilityCRF preEligiblityCRF = new PreEligibilityCRF();
                preEligiblityCRF.PatientId = lstStr[0]; 
                preEligiblityCRF.HistologicallyConfirmedInvasiveCancer = lstStr[1];
                preEligiblityCRF.ClinicallyRadiologicallyMeasurable = lstStr[2];
                preEligiblityCRF.CytotoxicRegiments = lstStr[3];
                preEligiblityCRF.X30DaysInvestigationalAgents = lstStr[4];
                preEligiblityCRF.NotHadPriorRT = lstStr[5];
                preEligiblityCRF.PatientIs18yearsOrOlder = lstStr[6];
                preEligiblityCRF.NonPregnantNotLactating = lstStr[7];   
                preEligiblityCRF.NoFerromegnaticProstheses = lstStr[8];
                preEligiblityCRF.WillingToHaveCoreBiospy = lstStr[9];
                preEligiblityCRF.WillinToHaveStudyMRI = lstStr[10];
                preEligiblityCRF.ECOGScore = lstStr[11];
                preEligiblityCRF.PatientSignedUpISPY2Screening = lstStr[12];
                preEligiblityCRF.ReasonNotSigningScreeningConsent = lstStr[13];
                preEligiblityCRF.CompletedDate = lstStr[14];
                preEligiblityCRF.Status = lstStr[15];
                lstPreEligibilityCRF.add(preEligiblityCRF);
            }
            if(!Test.isRunningTest()) { 
                transId = service.createPreEligibilityCheckList(institution,site,trial,lstPreEligibilityCRF);
            }
            nextform = 3;
        } else if(fileNameSplit[0] == 'Registration') {
            List<PatientRegistration> lstPatientReg = new List<PatientRegistration>();
            for(List<String> lstStr : lstCSVData) {
                system.debug('lstStr : '+lstStr+'   lstStr.size() : '+lstStr.size());
                if(!(lstStr != null && lstStr.size() == 8)) {
                    transId = service.insertErrorLog('Failure : '+'Number of column headers should be 8. Please ensure that the file you have uploaded has sufficient number of column.');
                    ref = new Pagereference('/apex/uploadCRFForTestHarness?inst='+institution+'&site='+site+'&trial='+trial+'&nextForm='+nextform+'&transId='+transId);
                    ref.setRedirect(true);
                    return ref;
                }
                PatientRegistration patReg = new PatientRegistration();
                patReg.patientId = lstStr[0];
                patReg.regDate = lstStr[1];
                patReg.hasPatientParticipateInRepeatMRIScan = lstStr[2];
                patReg.IRBApprovalDate = lstStr[3];
                patReg.ScreeningConsentDate = lstStr[4];
                patReg.HIPPAConsentDate = lstStr[5];
                patReg.CompletedDate = lstStr[6];
                patReg.Status = lstStr[7];
                lstPatientReg.add(patReg);
            }
            if(!Test.isRunningTest()) {
                transId = service.createRegistration(institution,site,trial,lstPatientReg);
            }
            nextform = 4;
        } else if(fileNameSplit[0] == 'MenopausalStatusCRF') {
            List<MenopausalStatus> lstMenopausalStatus = new List<MenopausalStatus>();
            for(List<String> lstStr : lstCSVData) {
                system.debug('lstStr : '+lstStr+'   lstStr.size() : '+lstStr.size());
                if(!(lstStr != null && lstStr.size() == 14)) {
                    transId = service.insertErrorLog('Failure : '+'Number of column headers should be 14. Please ensure that the file you have uploaded has sufficient number of column.');
                    ref = new Pagereference('/apex/uploadCRFForTestHarness?inst='+institution+'&site='+site+'&trial='+trial+'&nextForm='+nextform+'&transId='+transId);
                    ref.setRedirect(true);
                    return ref;
                }
                MenopausalStatus ms = new MenopausalStatus();
                ms.PatientId = lstStr[0];
                ms.DateOfLastMenstrualPeriod = lstStr[1];
                ms.UnknownDate = lstStr[2];
                ms.UnknownDate12MonthsAgo = lstStr[3];
                ms.OnEstrogenReplacement = lstStr[4];
                ms.OnEstrogenReplacementMonths = lstStr[5];
                ms.OnEstrogenReplacementYears = lstStr[6];
                ms.BilateralOophorectomy = lstStr[7];
                ms.BilateralOophorectomyDate = lstStr[8];
                ms.Hysterectomy = lstStr[9];
                ms.HysterectomyDate = lstStr[10];
                ms.MenopausalStatus = lstStr[11];
                ms.CompletedDate = lstStr[12];
                ms.Status = lstStr[13];
                lstMenopausalStatus.add(ms);
            }
            if(!Test.isRunningTest()) {
                transId = service.createMenopausalStatus(institution,site,trial,lstMenopausalStatus);
            }
            nextform = 5;
        } else if(fileNameSplit[0] == 'TissueSpecimenCRF') {
            List<TissueSpecimenCRF> lstTissueSpecimen = new List<TissueSpecimenCRF>();
            for(List<String> lstStr : lstCSVData) {
                system.debug('lstStr : '+lstStr+'   lstStr.size() : '+lstStr.size());
                if(!(lstStr != null && lstStr.size() == 13)) {
                    transId = service.insertErrorLog('Failure : '+'Number of column headers should be 13. Please ensure that the file you have uploaded has sufficient number of column.');
                    ref = new Pagereference('/apex/uploadCRFForTestHarness?inst='+institution+'&site='+site+'&trial='+trial+'&nextForm='+nextform+'&transId='+transId);
                    ref.setRedirect(true);
                    return ref;
                }
                TissueSpecimenCRF ts = new TissueSpecimenCRF();
                ts.PatientId = lstStr[0];
                ts.CRFId = lstStr[1];
                ts.ProcedureDate = lstStr[2];
                ts.GuidanceMethod = lstStr[3];
                ts.OtherGuidanceMethod = lstStr[4];
                ts.TimePoint = lstStr[5];
                ts.NumberOfCoreBiopsyCollected = lstStr[6];
                ts.ReasonAllSampleNotCollected = lstStr[7];
                ts.Other = lstStr[8];
                ts.PatientConsentedForThisStudy = lstStr[9];
                ts.PatientConsentedForOutSideStudy = lstStr[10]; 
                ts.CompletedDate = lstStr[11];
                ts.Status = lstStr[12]; 
                
                lstTissueSpecimen.add(ts);
            }
            if(!Test.isRunningTest()) {
                transId = service.createTissueSpecimen(institution,site,trial,lstTissueSpecimen);
            }
            nextform = 6;
        } else if(fileNameSplit[0] == 'CoreBiopsySpecimen') {
            List<CoreBiopsySpecimen_TSF> lstCoreBiopsy_TSF = new List<CoreBiopsySpecimen_TSF>();
            for(List<String> lstStr : lstCSVData) {
                system.debug('lstStr : '+lstStr+'   lstStr.size() : '+lstStr.size());
                if(!(lstStr != null && lstStr.size() == 5)) {
                    transId = service.insertErrorLog('Failure : '+'Number of column headers should be 5. Please ensure that the file you have uploaded has sufficient number of column.');
                    ref = new Pagereference('/apex/uploadCRFForTestHarness?inst='+institution+'&site='+site+'&trial='+trial+'&nextForm='+nextform+'&transId='+transId);
                    ref.setRedirect(true);
                    return ref;
                }
                CoreBiopsySpecimen_TSF coreBiopsy_TSF = new CoreBiopsySpecimen_TSF();
                coreBiopsy_TSF.TissueSpecimenCRFId = lstStr[0];
                coreBiopsy_TSF.CoreSpecimen = lstStr[1];
                coreBiopsy_TSF.Shipped = lstStr[2];
                coreBiopsy_TSF.ReasonSamplesNotShipped = lstStr[3];
                coreBiopsy_TSF.OtherReasonSamplesNotShipped = lstStr[4];
                lstCoreBiopsy_TSF.add(coreBiopsy_TSF);
            }
            
            if(!Test.isRunningTest()) {
                transId = service.createCoreBiopsyForTissueSpecimenCRF(institution,site,trial,lstCoreBiopsy_TSF);
            }
            nextform = 7;
            
        } else if(fileNameSplit[0] == 'MammaPrintCRF') {
            List<MammaprintCRF> lstMammaPrintCRF = new List<MammaprintCRF>();
            for(List<String> lstStr : lstCSVData) {
                system.debug('lstStr : '+lstStr+'   lstStr.size() : '+lstStr.size());
                if(!(lstStr != null && lstStr.size() == 9)) {
                    transId = service.insertErrorLog('Failure : '+'Number of column headers should be 9. Please ensure that the file you have uploaded has sufficient number of column.');
                    ref = new Pagereference('/apex/uploadCRFForTestHarness?inst='+institution+'&site='+site+'&trial='+trial+'&nextForm='+nextform+'&transId='+transId);
                    ref.setRedirect(true);
                    return ref;
                }
                MammaprintCRF mammaPrintCRF = new MammaprintCRF();
                mammaPrintCRF.PatientId = lstStr[0];
                mammaPrintCRF.ReportDate = lstStr[1];
                mammaPrintCRF.SpecimenCollectionDates = lstStr[2];
                mammaPrintCRF.SpecimenUsed = lstStr[3];
                mammaPrintCRF.MammaPrintRisk = lstStr[4];
                mammaPrintCRF.MammaPrintIndex = lstStr[5];
                mammaPrintCRF.TargetPrintHER2Index = lstStr[6];
                mammaPrintCRF.CompletedDate = lstStr[7];
                mammaPrintCRF.Status = lstStr[8];               
                lstMammaPrintCRF.add(mammaPrintCRF);
            }
            
            if(!Test.isRunningTest()) {
                transId = service.createMammaprint(institution,site,trial,lstMammaPrintCRF);
            }
            nextform = 8;
            
        } else if(fileNameSplit[0] == 'MRIVolumeCRF') {
            List<MRIVolumeCRF> lstMRIVolumeCRF = new List<MRIVolumeCRF>();
            for(List<String> lstStr : lstCSVData) {
                system.debug('lstStr : '+lstStr+'   lstStr.size() : '+lstStr.size());
                if(!(lstStr != null && lstStr.size() == 10)) {
                    transId = service.insertErrorLog('Failure : '+'Number of column headers should be 10. Please ensure that the file you have uploaded has sufficient number of column.');
                    ref = new Pagereference('/apex/uploadCRFForTestHarness?inst='+institution+'&site='+site+'&trial='+trial+'&nextForm='+nextform+'&transId='+transId);
                    ref.setRedirect(true);
                    return ref;
                }
                MRIVolumeCRF mri = new MRIVolumeCRF();
                mri.PatientId = lstStr[0];
                mri.WasMRIReadable = lstStr[1];
                mri.DataOfMRIScan = lstStr[2];
                mri.TimePoint = lstStr[3];
                mri.MRIVolumeInCM = lstStr[4];
                mri.Laterality = lstStr[5];
                mri.LongestDiameterOfIndexLesion = lstStr[6];
                mri.AreSeparateMassesOrEnhancementsReported = lstStr[7];
                mri.CompletedDate = lstStr[8];
                mri.Status = lstStr[9];
                lstMRIVolumeCRF.add(mri);
            }
            
            if(!Test.isRunningTest()) {
                transId = service.createMRIVolume(institution,site,trial,lstMRIVolumeCRF);
            }
            nextform = 9;
        } else if(fileNameSplit[0] == 'OnStudyEligiblityCRF') {
            List<OnStudyEligibilityCRF> lstOnStudyEligibilityCRF = new List<OnStudyEligibilityCRF>();
            for(List<String> lstStr : lstCSVData) {
                system.debug('lstStr : '+lstStr+'   lstStr.size() : '+lstStr.size());
                if(!(lstStr != null && lstStr.size() == 21)) {
                    transId = service.insertErrorLog('Failure : '+'Number of column headers should be 21. Please ensure that the file you have uploaded has sufficient number of column.');
                    ref = new Pagereference('/apex/uploadCRFForTestHarness?inst='+institution+'&site='+site+'&trial='+trial+'&nextForm='+nextform+'&transId='+transId);
                    ref.setRedirect(true);
                    return ref; 
                }
                OnStudyEligibilityCRF oseCRF = new OnStudyEligibilityCRF();
                oseCRF.PatientId = lstStr[0];
                oseCRF.NoClinicalOrImagingEvidence = lstStr[1];
                oseCRF.NoUncontrolledorCardiovascularDiseas = lstStr[2];
                oseCRF.NoHistoryOfAllergicReactions = lstStr[3];
                oseCRF.NoUncontrolledIntercurrentIllness = lstStr[4];
                oseCRF.NotHadASentinelLymphNode = lstStr[5];
                oseCRF.LabValues = lstStr[6];
                oseCRF.Leukocytes3000L = lstStr[7];
                oseCRF.AbsoluteNeutrophilCount1500L = lstStr[8];
                oseCRF.Platelets100000L = lstStr[9];
                oseCRF.TotalBilirubinWithinInstitutional = lstStr[10];
                oseCRF.ASTSGOTOrALTSGPT15xinsti = lstStr[11];
                oseCRF.Creatinine15xInstitutionalULN = lstStr[12];
                oseCRF.HowWasTheCancerFirstDetected = lstStr[13];
                oseCRF.IsMassPalpable = lstStr[14];
                oseCRF.OtherReasonForCancerFirstDetected = lstStr[15]; 
                oseCRF.MassIdentificationDate = lstStr[16];
                oseCRF.ScreeningMemogramPriorToMassDetect = lstStr[17];
                oseCRF.MostRecentDate = lstStr[18];
                oseCRF.CompletedDate = lstStr[19];
                oseCRF.Status = lstStr[20];
                lstOnStudyEligibilityCRF.add(oseCRF);
            }
            
            if(!Test.isRunningTest()) {
                transId = service.createOnStudyEligibility(institution,site,trial,lstOnStudyEligibilityCRF);
            }
            nextform = 10;
        } else if(fileNameSplit[0] == 'OnStudyPathologyCRF') {
            List<OnStudyPathologyCRF> lstOnStudyPathologyCRF = new List<OnStudyPathologyCRF>();
            for(List<String> lstStr : lstCSVData) {
                system.debug('lstStr : '+lstStr+'   lstStr.size() : '+lstStr.size());
                if(!(lstStr != null && lstStr.size() == 9)) {
                    transId = service.insertErrorLog('Failure : '+'Number of column headers should be 9. Please ensure that the file you have uploaded has sufficient number of column.');
                    ref = new Pagereference('/apex/uploadCRFForTestHarness?inst='+institution+'&site='+site+'&trial='+trial+'&nextForm='+nextform+'&transId='+transId);
                    ref.setRedirect(true);
                    return ref;
                }
                OnStudyPathologyCRF ospCRF = new OnStudyPathologyCRF();
                ospCRF.PatientId = lstStr[0];
                ospCRF.CRFId = lstStr[1];
                ospCRF.DoesThePatientHaveBilateralBreast = lstStr[2];
                ospCRF.Tumorlaterality = lstStr[3];
                ospCRF.IsDCISPresent = lstStr[4];
                ospCRF.IsLCISPresent = lstStr[5];
                ospCRF.IsInvasiveTumorPresent = lstStr[6];
                ospCRF.CompletedDate = lstStr[7];
                ospCRF.Status = lstStr[8];
                lstOnStudyPathologyCRF.add(ospCRF);
            }
            
            if(!Test.isRunningTest()) {
                transId = service.createOnStudyPathology(institution,site,trial,lstOnStudyPathologyCRF);
            }
            nextform = 11;
        } else if(fileNameSplit[0] == 'Receptor') {
            List<Receptors_OSP_CRF> lstReceptors_OSP_CRF = new List<Receptors_OSP_CRF>();
            for(List<String> lstStr : lstCSVData) {
                system.debug('lstStr : '+lstStr+'   lstStr.size() : '+lstStr.size());
                if(!(lstStr != null && lstStr.size() == 19)) {
                    transId = service.insertErrorLog('Failure : '+'Number of column headers should be 19. Please ensure that the file you have uploaded has sufficient number of column.');
                    ref = new Pagereference('/apex/uploadCRFForTestHarness?inst='+institution+'&site='+site+'&trial='+trial+'&nextForm='+nextform+'&transId='+transId);
                    ref.setRedirect(true);
                    return ref;
                }
                Receptors_OSP_CRF receptor = new Receptors_OSP_CRF();
                receptor.OSPId = lstStr[0];
                receptor.ERStatus = lstStr[1];
                receptor.ERProporationScore = lstStr[2];
                receptor.ERIntensityScore = lstStr[3];
                receptor.PRStatus = lstStr[4];
                receptor.PRProporationScore = lstStr[5];
                receptor.PRIntensityScore = lstStr[6];
                receptor.IHC = lstStr[7];
                receptor.DAKOHerceptest = lstStr[8];
                receptor.OtherIHCTest = lstStr[9];
                receptor.OtherIHCResult = lstStr[10];
                receptor.VentanaKit = lstStr[11];
                receptor.CB11 = lstStr[12];
                receptor.IHCTestNotDone = lstStr[13];
                receptor.FISH = lstStr[14];
                receptor.VentanaOncoprobe = lstStr[15];
                receptor.OtherFISHTest = lstStr[16];
                receptor.OtherFISHResults = lstStr[17];
                receptor.FISHTestNotDone = lstStr[18];
                lstReceptors_OSP_CRF.add(receptor);
            }
            
            if(!Test.isRunningTest()) {
                transId = service.createReceptors(institution, site, trial, lstReceptors_OSP_CRF);
            }
            nextform = 12;
        } else if(fileNameSplit[0] == 'Procedure') {
            system.debug('Procedure.csv CSV Found.');
            List<Procedure_OSP_PSS> lstPro_OSP_CRF = new List<Procedure_OSP_PSS>();
            for(List<String> lstStr : lstCSVData) {
                system.debug('lstStr : '+lstStr+'   lstStr.size() : '+lstStr.size());
                if(!(lstStr != null && lstStr.size() == 15)) {
                    transId = service.insertErrorLog('Failure : '+'Number of column headers should be 15. Please ensure that the file you have uploaded has sufficient number of column.');
                    ref = new Pagereference('/apex/uploadCRFForTestHarness?inst='+institution+'&site='+site+'&trial='+trial+'&nextForm='+nextform+'&transId='+transId);
                    ref.setRedirect(true);
                    return ref;
                }
                Procedure_OSP_PSS procedure = new Procedure_OSP_PSS();
                procedure.CRFId = lstStr[0];
                procedure.DateOfProcedure = lstStr[1];
                procedure.ProcedureName = lstStr[2];
                procedure.Ultrasound = lstStr[3];
                procedure.Palpationguided = lstStr[4];
                procedure.Mammography = lstStr[5];
                procedure.MRI = lstStr[6];
                procedure.Stereotactic = lstStr[7];
                procedure.Laterality = lstStr[8];
                procedure.Location = lstStr[9];
                procedure.NodeResult = lstStr[10];
                procedure.FormName = lstStr[11];
                procedure.NodeType = lstStr[12];
                procedure.TotalPositive = lstStr[13];
                procedure.TotalExaminedNodes = lstStr[14];
                lstPro_OSP_CRF.add(procedure);
            }
            
            if(!Test.isRunningTest()) {
                transId = service.createProcedure(institution, site, trial, lstPro_OSP_CRF);
            }
            nextform = 12;
        } else if(fileNameSplit[0] == 'DCIS') {
            List<DCIS_OSP_CRF> lstDCIS = new List<DCIS_OSP_CRF>();
            for(List<String> lstStr : lstCSVData) {
                system.debug('lstStr : '+lstStr+'   lstStr.size() : '+lstStr.size());
                if(!(lstStr != null && lstStr.size() == 16)) {
                    transId = service.insertErrorLog('Failure : '+'Number of column headers should be 16. Please ensure that the file you have uploaded has sufficient number of column.');
                    ref = new Pagereference('/apex/uploadCRFForTestHarness?inst='+institution+'&site='+site+'&trial='+trial+'&nextForm='+nextform+'&transId='+transId);
                    ref.setRedirect(true);
                    return ref;
                }
                DCIS_OSP_CRF dcis = new DCIS_OSP_CRF();
                dcis.CRFId = lstStr[0];
                dcis.PunctateNecrosis = lstStr[1];
                dcis.Comedonecrosis = lstStr[2];
                dcis.Papillary = lstStr[3];
                dcis.Micropapillary = lstStr[4];
                dcis.Necrosis = lstStr[5];
                dcis.Cribiform = lstStr[6];
                dcis.Cruciform = lstStr[7];
                dcis.Clinging = lstStr[8];
                dcis.Solid = lstStr[9];
                dcis.Apocrine = lstStr[10];
                dcis.IntraCysticEncystedPapillary = lstStr[11];
                dcis.Other = lstStr[12];
                dcis.Calcifications = lstStr[13];
                dcis.CalcificationsPresent = lstStr[14];
                dcis.NuclearGrade = lstStr[15];
                lstDCIS.add(dcis);
            }
            
            if(!Test.isRunningTest()) {
                transId = service.createDCIS(institution, site, trial, lstDCIS);
            }
            nextform = 13;
        } else if(fileNameSplit[0] == 'LCIS') {
            List<LCIS_OSP_CRF> lstLCIS = new List<LCIS_OSP_CRF>();
            for(List<String> lstStr : lstCSVData) {
                system.debug('lstStr : '+lstStr+'   lstStr.size() : '+lstStr.size());
                if(!(lstStr != null && lstStr.size() == 2)) {
                    transId = service.insertErrorLog('Failure : '+'Number of column headers should be 2. Please ensure that the file you have uploaded has sufficient number of column.');
                    ref = new Pagereference('/apex/uploadCRFForTestHarness?inst='+institution+'&site='+site+'&trial='+trial+'&nextForm='+nextform+'&transId='+transId);
                    ref.setRedirect(true);
                    return ref;
                }
                LCIS_OSP_CRF lcis = new LCIS_OSP_CRF();
                lcis.CRFId = lstStr[0];
                lcis.LCISType = lstStr[1];
                lstLCIS.add(lcis);
            }
            
            if(!Test.isRunningTest()) {
                transId = service.createLCIS(institution, site, trial, lstLCIS);
            }
            nextform = 13;
        } else if(fileNameSplit[0] == 'InvasiveTumor') {
            List<InvasiveTumor_OSP_PSS> lstInvTumor = new List<InvasiveTumor_OSP_PSS>();
            for(List<String> lstStr : lstCSVData) {
                system.debug('lstStr : '+lstStr+'   lstStr.size() : '+lstStr.size());
                if(!(lstStr != null && lstStr.size() == 24)) {
                    transId = service.insertErrorLog('Failure : '+'Number of column headers should be 24. Please ensure that the file you have uploaded has sufficient number of column.');
                    ref = new Pagereference('/apex/uploadCRFForTestHarness?inst='+institution+'&site='+site+'&trial='+trial+'&nextForm='+nextform+'&transId='+transId);
                    ref.setRedirect(true);
                    return ref;
                }
                InvasiveTumor_OSP_PSS invTumor = new InvasiveTumor_OSP_PSS();
                invTumor.CRFId = lstStr[0];
                invTumor.InvasiveDuctalCarcinomaNos = lstStr[1];
                invTumor.InvasiveLobularCarcinomaClassicType = lstStr[2];
                invTumor.InvasiveLobularCarcinomaAlveolarType = lstStr[3];
                invTumor.PleomorphicLobularCarcinoma = lstStr[4];
                invTumor.TubulolobularCarcinoma = lstStr[5];
                invTumor.InvasiveCarcinomaMixedDuctalAndLobularType = lstStr[6];
                invTumor.TubularCarcinoma = lstStr[7];
                invTumor.MucinousCarcinoma = lstStr[8];
                invTumor.MedullaryCarcinoma = lstStr[9];
                invTumor.InvasivePapillaryCarcinoma = lstStr[10];
                invTumor.InvasiveCribiformCarcinoma = lstStr[11];
                invTumor.Other = lstStr[12];
                invTumor.SignsOfTreatmentEffect = lstStr[13];
                invTumor.Calcifications = lstStr[14];
                invTumor.CalcificationsPresent = lstStr[15];
                invTumor.NuclearGrade = lstStr[16];
                invTumor.MitoticCount = lstStr[17];
                invTumor.TubulePapillaFormation = lstStr[18];
                invTumor.LympaticVascularInvasion = lstStr[19];
                invTumor.SkinInvolvement = lstStr[20];
                invTumor.PagetDisease = lstStr[21];
                invTumor.UlcerationByTumor = lstStr[22];
                invTumor.DermaLymphaticVascularInvasion = lstStr[23];   
                lstInvTumor.add(invTumor);
            }
            
            if(!Test.isRunningTest()) {
                transId = service.createInvasiveTumor(institution, site, trial, lstInvTumor);
            }
            nextform = 14;
        } else if(fileNameSplit[0] == 'BloodSpecimenCRF') {
            List<BloodSpecimenCRF> lstBloodSpecimenCRF = new List<BloodSpecimenCRF>();
            for(List<String> lstStr : lstCSVData) {
                system.debug('lstStr : '+lstStr+'   lstStr.size() : '+lstStr.size());
                if(!(lstStr != null && lstStr.size() == 13)) {
                    transId = service.insertErrorLog('Failure : '+'Number of column headers should be 13. Please ensure that the file you have uploaded has sufficient number of column.');
                    ref = new Pagereference('/apex/uploadCRFForTestHarness?inst='+institution+'&site='+site+'&trial='+trial+'&nextForm='+nextform+'&transId='+transId);
                    ref.setRedirect(true);
                    return ref;
                }
                BloodSpecimenCRF bs = new BloodSpecimenCRF();
                bs.PatientId = lstStr[0];
                bs.CRFId = lstStr[1];
                bs.CollectionDate = lstStr[2];
                bs.TimePoint = lstStr[3];
                bs.NoOfSampleCollected_Serum = lstStr[4];
                bs.NoOfSampleCollected_Plasma = lstStr[5];
                bs.NoOfSampleCollected_buffyCoat = lstStr[6];
                bs.ReasonAllSampleNotCollected = lstStr[7];
                bs.Other = lstStr[8];
                bs.PatientConsentedForThisStudy = lstStr[9];
                bs.PatientConsentedForOutSideStudy = lstStr[10]; 
                bs.CompletedDate = lstStr[11];
                bs.Status = lstStr[12]; 
                lstBloodSpecimenCRF.add(bs);
            }
            if(!Test.isRunningTest()) {
                transId = service.createBloodSpecimen(institution,site,trial,lstBloodSpecimenCRF); 
            }
            nextform = 15;
        } else if(fileNameSplit[0] == 'BloodSpecimenSample') {
            List<BloodSpecimen_BSF> lstBloodSpecimen_BSF = new List<BloodSpecimen_BSF>();
            for(List<String> lstStr : lstCSVData) {
                system.debug('lstStr : '+lstStr+'   lstStr.size() : '+lstStr.size());
                if(!(lstStr != null && lstStr.size() == 6)) {
                    transId = service.insertErrorLog('Failure : '+'Number of column headers should be 6. Please ensure that the file you have uploaded has sufficient number of column.');
                    ref = new Pagereference('/apex/uploadCRFForTestHarness?inst='+institution+'&site='+site+'&trial='+trial+'&nextForm='+nextform+'&transId='+transId);
                    ref.setRedirect(true);
                    return ref;
                }
                BloodSpecimen_BSF bloodSpecimen = new BloodSpecimen_BSF();
                bloodSpecimen.CRFId = lstStr[0];
                bloodSpecimen.SpecimenType = lstStr[1];
                bloodSpecimen.SpecimenNumber = lstStr[2];
                bloodSpecimen.Shipped = lstStr[3];
                bloodSpecimen.ReasonSamplesNotShipped = lstStr[4];
                bloodSpecimen.OtherReasonSamplesNotShipped = lstStr[5];
                lstBloodSpecimen_BSF.add(bloodSpecimen);
            }
            
            if(!Test.isRunningTest()) {
                transId = service.createBloodSpecimenSamples(institution,site,trial,lstBloodSpecimen_BSF); 
            }
            nextform = 16;
            //for randomisez form

            nextform = 17;            
           
          } else if(fileNameSplit[0] == 'AEFormCRF') {
            List<AEFormCRF> lstAEFormCRF = new List<AEFormCRF>();
            for(List<String> lstStr : lstCSVData) {
                system.debug('lstStr : '+lstStr+'   lstStr.size() : '+lstStr.size());
                if(!(lstStr != null && lstStr.size() == 7)) {
                    transId = service.insertErrorLog('Failure : '+'Number of column headers should be 7. Please ensure that the file you have uploaded has sufficient number of column.');
                    ref = new Pagereference('/apex/uploadCRFForTestHarness?inst='+institution+'&site='+site+'&trial='+trial+'&nextForm='+nextform+'&transId='+transId);
                    ref.setRedirect(true);
                    return ref;
                }
                AEFormCRF aeForm = new AEFormCRF();
                aeForm.PatientId = lstStr[0];
                aeForm.CRFId = lstStr[1];
                aeForm.VisitDate = lstStr[2];
                aeForm.PatientHospitalized = lstStr[3];
                aeForm.caAERSreportfiled = lstStr[4];
                aeForm.CompletedDate = lstStr[5];                
                aeForm.Status = lstStr[6];                        
                lstAEFormCRF.add(aeForm);
            }
            
            if(!Test.isRunningTest()) {
                transId = service.createAEForm(institution,site,trial,lstAEFormCRF); 
            }
            nextform = 18;
              } else if(fileNameSplit[0] == 'Toxicity') {
            List<Toxicity_OSP_CRF> lstToxicity = new List<Toxicity_OSP_CRF>();
            for(List<String> lstStr : lstCSVData) {
                system.debug('lstStr : '+lstStr+'   lstStr.size() : '+lstStr.size());
                if(!(lstStr != null && lstStr.size() == 19)) {
                    transId = service.insertErrorLog('Failure : '+'Number of column headers should be 19. Please ensure that the file you have uploaded has sufficient number of column.');
                    ref = new Pagereference('/apex/uploadCRFForTestHarness?inst='+institution+'&site='+site+'&trial='+trial+'&nextForm='+nextform+'&transId='+transId);
                    ref.setRedirect(true);
                    return ref;
                }
              Toxicity_OSP_CRF toc_CRF = new Toxicity_OSP_CRF();
             toc_CRF.CRFId = lstStr[0];
             toc_CRF.SymptomStatus = lstStr[1];
             toc_CRF.SymptomMasters = lstStr[2];
             toc_CRF.ToxicityAgent = lstStr[3];
             toc_CRF.ToxicityOther = lstStr[4];
             toc_CRF.ToxicityStatus = lstStr[5];
             toc_CRF.Grade = lstStr[6];
             toc_CRF.Attribution = lstStr[7];
             toc_CRF.Waseventlifethreatning = lstStr[8];
             toc_CRF.Dideventrequiredhospitalization = lstStr[9];
             toc_CRF.Resultpersistentsignificantdisability = lstStr[10];
             toc_CRF.Resultconginentalabnormalitydefect = lstStr[11];
             toc_CRF.Didtheinvestigatorfindeventunusual = lstStr[12];
             toc_CRF.Dideventresultindeath = lstStr[13];
             toc_CRF.OnsetDate = lstStr[14];
             toc_CRF.SAE = lstStr[15];
             toc_CRF.Resolved = lstStr[16];
             toc_CRF.AEEndDate = lstStr[17];
             toc_CRF.PatientComplaint = lstStr[18];
              lstToxicity.add(toc_CRF);
            }
            
            if(!Test.isRunningTest()) {
                transId = service.createToxicity(institution,site,trial,lstToxicity);
            }
            nextform = 19;    
                      
          } else if(fileNameSplit[0] == 'ProtocolViolationCRF') {
            List<ProtocolViolationCRF> lstProtocolViolationCRF = new List<ProtocolViolationCRF>();
            for(List<String> lstStr : lstCSVData) {
                system.debug('lstStr : '+lstStr+'   lstStr.size() : '+lstStr.size());
                if(!(lstStr != null && lstStr.size() == 21)) {
                    transId = service.insertErrorLog('Failure : '+'Number of column headers should be 21. Please ensure that the file you have uploaded has sufficient number of column.');
                    ref = new Pagereference('/apex/uploadCRFForTestHarness?inst='+institution+'&site='+site+'&trial='+trial+'&nextForm='+nextform+'&transId='+transId);
                    ref.setRedirect(true);
                    return ref; 
                }
                ProtocolViolationCRF pvCRF = new ProtocolViolationCRF();
                pvCRF.PatientId = lstStr[0];
                pvCRF.DateOfProtocolViolation= lstStr[1];
                pvCRF.Medicationnoncompliance = lstStr[2];
                pvCRF.Visitnoncomplicance= lstStr[3];
                pvCRF.Onstudyprocedurerequiredbyprotocol= lstStr[4];
                pvCRF.Incorrecttherapygiventopatient= lstStr[5];
                pvCRF.Screeningandonstudytestlabdone= lstStr[6];
                pvCRF.Screeningprocedurerequired= lstStr[7];
                pvCRF.Eligibilitycriteriaexception= lstStr[8];
                pvCRF.Enrollmentofineligeligibleiblepatient= lstStr[9];
                pvCRF.Patientbecamepregnantpriortosurgery= lstStr[10];
                pvCRF.OtherViolationCheckbox= lstStr[11];
                pvCRF.OtherTypeofViolation= lstStr[12];
                pvCRF.Narrativedescription= lstStr[13];
                pvCRF.PatientRemainsonStudy= lstStr[14];
                pvCRF.Patientwithdrawn= lstStr[15];
                pvCRF.OtherActionCheckbox= lstStr[16]; 
                pvCRF.OtherActionTaken= lstStr[17];
                pvCRF.LocalIRBNotified= lstStr[18];
                pvCRF.CompletedDate = lstStr[19];
                pvCRF.Status = lstStr[20];
                lstProtocolViolationCRF.add(pvCRF);
            }
            
            if(!Test.isRunningTest()) {
                transId = service.createProtocolViolation(institution,site,trial,lstProtocolViolationCRF);
      }
      nextform = 20;
     } else if(fileNameSplit[0] == 'OffStudyCRF') {
            List<OffStudyCRF> lstOffStudyCRF = new List<OffStudyCRF>();
            for(List<String> lstStr : lstCSVData) {
                system.debug('lstStr : '+lstStr+'   lstStr.size() : '+lstStr.size());
                if(!(lstStr != null && lstStr.size() == 15)) {
                    transId = service.insertErrorLog('Failure : '+'Number of column headers should be 15. Please ensure that the file you have uploaded has sufficient number of column.');
                    ref = new Pagereference('/apex/uploadCRFForTestHarness?inst='+institution+'&site='+site+'&trial='+trial+'&nextForm='+nextform+'&transId='+transId);
                    ref.setRedirect(true);
                    return ref; 
                }
                OffStudyCRF offStudyObjCRF = new OffStudyCRF();
               offStudyObjCRF.PatientId = lstStr[0];
               offStudyObjCRF.Datepatientwentoffstudy= lstStr[1];
               offStudyObjCRF.Patientcompletedstudyperprotocol= lstStr[2];
               offStudyObjCRF.PatientdidnotwanttocompleteMRI= lstStr[3];
               offStudyObjCRF.Patientdidntwanttocompletecorebio= lstStr[4];
               offStudyObjCRF.Patientdidntcontinueontreatmentarm= lstStr[5];
               offStudyObjCRF.Whypatientdidntcontinuetreatmentarm= lstStr[6];
               offStudyObjCRF.Treatmentarmotherreason= lstStr[7];
               offStudyObjCRF.Patientdidnothavesurgery= lstStr[8];
               offStudyObjCRF.Patientdidnothavesurgeryreason= lstStr[9];
               offStudyObjCRF.PatientDied= lstStr[10];
               offStudyObjCRF.Didpatientwithdrawforsurvival= lstStr[11];
               offStudyObjCRF.Patientwithdrewforspecimens= lstStr[12];
               offStudyObjCRF.CompletedDate= lstStr[13];
               offStudyObjCRF.Status= lstStr[14];
               lstOffStudyCRF.add(offStudyObjCRF);
            }
            
            if(!Test.isRunningTest()) {
                transId = service.createOffStudy(institution,site,trial,lstOffStudyCRF);
            }
            nextform = 21; 
    } else if(fileNameSplit[0] == 'NolongLosttoFollowupCRF') {
            List<NolongLosttoFollowupCRF> lstNolongLosttoFollowupCRF = new List<NolongLosttoFollowupCRF>();
            for(List<String> lstStr : lstCSVData) {
                system.debug('lstStr : '+lstStr+'   lstStr.size() : '+lstStr.size());
                if(!(lstStr != null && lstStr.size() == 6)) {
                    transId = service.insertErrorLog('Failure : '+'Number of column headers should be 6. Please ensure that the file you have uploaded has sufficient number of column.');
                    ref = new Pagereference('/apex/uploadCRFForTestHarness?inst='+institution+'&site='+site+'&trial='+trial+'&nextForm='+nextform+'&transId='+transId);
                    ref.setRedirect(true);
                    return ref; 
                }
                NolongLosttoFollowupCRF  NLLFFCRF = new NolongLosttoFollowupCRF();
                NLLFFCRF.PatientId = lstStr[0];
                NLLFFCRF.NewInformation= lstStr[1];
                NLLFFCRF.SurvialStatus= lstStr[2];
                NLLFFCRF.lastalivedeathdate= lstStr[3];
                NLLFFCRF.CompletedDate= lstStr[4];
                NLLFFCRF.Status= lstStr[5];
                lstNolongLosttoFollowupCRF.add(NLLFFCRF);
            }
            
            if(!Test.isRunningTest()) {
                transId = service.createNolongLosttoFollowup(institution,site,trial,lstNolongLosttoFollowupCRF);
            }
            nextform = 21;
            
       } else if(fileNameSplit[0] == 'LosttoFollowupCRF') {
            List<LosttoFollowupCRF> lstLosttoFollowupCRF = new List<LosttoFollowupCRF>();
            for(List<String> lstStr : lstCSVData) {
                system.debug('lstStr : '+lstStr+'   lstStr.size() : '+lstStr.size());
                if(!(lstStr != null && lstStr.size() == 10)) {
                    transId = service.insertErrorLog('Failure : '+'Number of column headers should be 10. Please ensure that the file you have uploaded has sufficient number of column.');
                    ref = new Pagereference('/apex/uploadCRFForTestHarness?inst='+institution+'&site='+site+'&trial='+trial+'&nextForm='+nextform+'&transId='+transId);
                    ref.setRedirect(true);
                    return ref; 
                }
                LosttoFollowupCRF LFFCRF = new LosttoFollowupCRF();
               LFFCRF.PatientId = lstStr[0];
               LFFCRF.Lastcontactbefore2yrs= lstStr[1];
               LFFCRF.Dateoflastcontact= lstStr[2];
               LFFCRF.SocialSecDeathIndexResearch = lstStr[3];
               LFFCRF.SocialSecDeathIndexResearchDate = lstStr[4];
               LFFCRF.Sendcertifiedregisteredltrtoknown = lstStr[5];
               LFFCRF.SendcertifiedregisteredltrDATE = lstStr[6];
               LFFCRF.SendcertifiedregisteredltrResponse = lstStr[7];
               LFFCRF.CompletedDate= lstStr[8];
               LFFCRF.Status = lstStr[9];
               lstLosttoFollowupCRF.add(LFFCRF);
            }
            
            if(!Test.isRunningTest()) {
                transId = service.createLosttoFollowup(institution,site,trial,lstLosttoFollowupCRF);
            }
            nextform = 22;
           } else if(fileNameSplit[0] == 'FollowupCRF') {
            List<FollowupCRF> lstFollowupCRF = new List<FollowupCRF>();
            for(List<String> lstStr : lstCSVData) {
                system.debug('lstStr : '+lstStr+'   lstStr.size() : '+lstStr.size());
                if(!(lstStr != null && lstStr.size() == 44)) {
                    transId = service.insertErrorLog('Failure : '+'Number of column headers should be 48. Please ensure that the file you have uploaded has sufficient number of column.');
                    ref = new Pagereference('/apex/uploadCRFForTestHarness?inst='+institution+'&site='+site+'&trial='+trial+'&nextForm='+nextform+'&transId='+transId);
                    ref.setRedirect(true);
                    return ref; 
                }
            FollowupCRF FFCRF = new FollowupCRF();
            FFCRF.PatientId = lstStr[0];
            FFCRF.CRFId = lstStr[1];
            FFCRF.StartDate = lstStr[2];
            FFCRF.EndDate = lstStr[3];
            FFCRF.Patientdocclinialassessment = lstStr[4];
            FFCRF.ClinicalassessmentDate = lstStr[5];
            FFCRF.SurvivalStatus = lstStr[6];
            FFCRF.PatientDiagnoseWithNew = lstStr[7];
            FFCRF.Dates = lstStr[8];
            FFCRF.Surgery = lstStr[9];
            FFCRF.SurgeryDetails = lstStr[10];
            FFCRF.Chemotherapy = lstStr[11];
            FFCRF.ChemotherapyDetails = lstStr[12];
            FFCRF.RadiationTherapy = lstStr[13];
            FFCRF.RadiationTherapyDetails = lstStr[14];
            FFCRF.HormoneTherapy = lstStr[15]; 
            FFCRF.HormoneTherapyDetails = lstStr[16];
            FFCRF.CauseofDeath = lstStr[17];
            FFCRF.DescribeCauseOfDeath = lstStr[18];
            FFCRF.patientdiagnosedlocalprogression= lstStr[19];
            FFCRF.LocalprogressionDate = lstStr[20];
            FFCRF.patientdiagnoseddistantprogression = lstStr[21];
            FFCRF.DistantprogressionDate = lstStr[22];
            FFCRF.Recurrenceprogressioninformation = lstStr[23];
            FFCRF.Local = lstStr[24];
            FFCRF.Distant = lstStr[25];
            FFCRF.Other = lstStr[26];
            FFCRF.Patientreceivedadjuvanttherapy = lstStr[27];
            FFCRF.RadiationTherapyStartDate = lstStr[28];
            FFCRF.RadiationTherapyEndDate = lstStr[29];
            FFCRF.LongTermTherapyforprimaryTrial = lstStr[30];
            FFCRF.patienthaveamenstrualperiod = lstStr[31];
            FFCRF.DateofLastMenstrualperiodUKData12M = lstStr[32];
            FFCRF.DateofLastMenstrualperiod = lstStr[33];
            FFCRF.OnEstrogenReplacement = lstStr[34];
            FFCRF.OnEstrogenReplacementMonths = lstStr[35];
            FFCRF.OnEstrogenReplacementYears = lstStr[36];
            FFCRF.Bilateraloophorectomy = lstStr[37];
            FFCRF.BilateraloophorectomyDate = lstStr[38];
            FFCRF.Hysterectomy = lstStr[39];
            FFCRF.HysterectomyDate = lstStr[40];
            FFCRF.Menopausalstatus = lstStr[41];
            FFCRF.CompletedDate = lstStr[42];
            FFCRF.Status = lstStr[43];

            lstFollowupCRF.add(FFCRF);
            }
            
            if(!Test.isRunningTest()) {
                transId = service.createFollowupForm(institution,site,trial,lstFollowupCRF);
            }
            nextform = 23;
            
           } else if(fileNameSplit[0] == 'TherapyReceived') {
            List<TherapyReceivedCRF> lstTR_CRF = new List<TherapyReceivedCRF>();
            for(List<String> lstStr : lstCSVData) {
                system.debug('lstStr : '+lstStr+'   lstStr.size() : '+lstStr.size());
                if(!(lstStr != null && lstStr.size() == 5)) {
                    transId = service.insertErrorLog('Failure : '+'Number of column headers should be 5. Please ensure that the file you have uploaded has sufficient number of column.');
                    ref = new Pagereference('/apex/uploadCRFForTestHarness?inst='+institution+'&site='+site+'&trial='+trial+'&nextForm='+nextform+'&transId='+transId);
                    ref.setRedirect(true);
                    return ref;
                }
              TherapyReceivedCRF tr_CRF = new TherapyReceivedCRF();
             tr_CRF.CRFId = lstStr[0];
             tr_CRF.Therapy = lstStr[1];
             tr_CRF.Detail = lstStr[2];
             tr_CRF.StartDateDatePerformed = lstStr[3];
             tr_CRF.EndDate = lstStr[4];
             lstTR_CRF.add(tr_CRF);
            }
            
            if(!Test.isRunningTest()) {
                transId = service.createTherapyReceived(institution,site,trial,lstTR_CRF);
            }
            nextform = 24;    


 } else if(fileNameSplit[0] == 'IrradiatedSite') {
            List<IrradiatedSiteCRF> lstIS_CRF = new List<IrradiatedSiteCRF>();
            for(List<String> lstStr : lstCSVData) {
                system.debug('lstStr : '+lstStr+'   lstStr.size() : '+lstStr.size());
                if(!(lstStr != null && lstStr.size() == 6)) {
                    transId = service.insertErrorLog('Failure : '+'Number of column headers should be 5. Please ensure that the file you have uploaded has sufficient number of column.');
                    ref = new Pagereference('/apex/uploadCRFForTestHarness?inst='+institution+'&site='+site+'&trial='+trial+'&nextForm='+nextform+'&transId='+transId);
                    ref.setRedirect(true);
                    return ref;
                }
              IrradiatedSiteCRF ir_CRF = new IrradiatedSiteCRF();
             ir_CRF.CRFId = lstStr[0];
             ir_CRF.Site = lstStr[1];
             ir_CRF.Laterality = lstStr[2];
             ir_CRF.DoseperFXcGy = lstStr[3];
             ir_CRF.TotalFX= lstStr[4];
             ir_CRF.TotaldosecGyAP = lstStr[5];          
             lstIS_CRF.add(ir_CRF);
            }
            
            if(!Test.isRunningTest()) {
                transId = service.createIrradiatedSite(institution,site,trial,lstIS_CRF);
            }
            nextform = 25;  
  

          } else if(fileNameSplit[0] == 'ResponseEvaluationCRF') {
            List<ResponseEvaluationCRF> lstResponseEvaluationCRF = new List<ResponseEvaluationCRF>();
            for(List<String> lstStr : lstCSVData) {
                system.debug('lstStr : '+lstStr+'   lstStr.size() : '+lstStr.size());
                if(!(lstStr != null && lstStr.size() == 32)) {
                    transId = service.insertErrorLog('Failure : '+'Number of column headers should be 32. Please ensure that the file you have uploaded has sufficient number of column.');
                    ref = new Pagereference('/apex/uploadCRFForTestHarness?inst='+institution+'&site='+site+'&trial='+trial+'&nextForm='+nextform+'&transId='+transId);
                    ref.setRedirect(true);
                    return ref; 
                }
               ResponseEvaluationCRF responseEvalCRF = new ResponseEvaluationCRF();
               responseEvalCRF.PatientId = lstStr[0];
               responseEvalCRF.CRFId = lstStr[1];
               responseEvalCRF.ReportingPeriod = lstStr[2];
               responseEvalCRF.Dateofclinicalassessment = lstStr[3];
               responseEvalCRF.DiseaseExtent = lstStr[4];
               responseEvalCRF.Palpablenodes = lstStr[5];
               responseEvalCRF.Mattednodes = lstStr[6];
               responseEvalCRF.Nodesfixedtochestwall = lstStr[7];
               responseEvalCRF.Typeoflymphnodeinvolvement = lstStr[8];
               responseEvalCRF.Sizeoflargestnode = lstStr[9];
               responseEvalCRF.ClinicalStagingPeriod = lstStr[10];
               responseEvalCRF.ClinicallystagingperiodT = lstStr[11];
               responseEvalCRF.ClinicallystagingperiodN = lstStr[12];
               responseEvalCRF.ClinicallystagingperiodM = lstStr[13];
               responseEvalCRF.CurrentStatusofT4Tumor = lstStr[14];
               responseEvalCRF.IsCandidateForConservationSurgery = lstStr[15];
               responseEvalCRF.ReasonNotConservationSurgeryCandidate = lstStr[16]; 
               responseEvalCRF.OtherReason = lstStr[17];
               responseEvalCRF.ResponseStatus = lstStr[18];
               responseEvalCRF.CompleteresponseCR = lstStr[19];
               responseEvalCRF.CompleteresponseCRDate = lstStr[20];
               responseEvalCRF.PartialresponsePR = lstStr[21];
               responseEvalCRF.PartialresponsePRDate = lstStr[22];
               responseEvalCRF.Newlocalregionalrecurrence = lstStr[23];
               responseEvalCRF.NewlocalregionalrecurrenceDate = lstStr[24];
               responseEvalCRF.Newdistantprogression = lstStr[25];
               responseEvalCRF.NewdistantprogressionDate = lstStr[26];
               responseEvalCRF.LocalRegional = lstStr[27];
               responseEvalCRF.Distant = lstStr[28];
               responseEvalCRF.OtherDistant = lstStr[29];
               responseEvalCRF.CompletedDate = lstStr[30];
               responseEvalCRF.Status = lstStr[31];
               lstResponseEvaluationCRF.add(responseEvalCRF);
            }
            
            if(!Test.isRunningTest()) {
                transId = service.createResponseEvaluation(institution,site,trial,lstResponseEvaluationCRF);
            }
            nextform = 26;
            } else if(fileNameSplit[0] == 'DiseaseAssessment') {
            List<Disease_Assessment_CRF_REF>  lstDS_CRF_REF = new List<Disease_Assessment_CRF_REF>();
            for(List<String> lstStr : lstCSVData) {
                system.debug('lstStr : '+lstStr+'   lstStr.size() : '+lstStr.size());
                if(!(lstStr != null && lstStr.size() == 6)) {
                    transId = service.insertErrorLog('Failure : '+'Number of column headers should be 6. Please ensure that the file you have uploaded has sufficient number of column.');
                    ref = new Pagereference('/apex/uploadCRFForTestHarness?inst='+institution+'&site='+site+'&trial='+trial+'&nextForm='+nextform+'&transId='+transId);
                    ref.setRedirect(true);
                    return ref;
                }
              Disease_Assessment_CRF_REF da_CRF = new Disease_Assessment_CRF_REF();
              da_CRF.CRFId = lstStr[0];
              da_CRF.OClockPositionFrom = lstStr[1];
              da_CRF.OClockPositionTo = lstStr[2];
              da_CRF.Distancefromnipplecm = lstStr[3];
              da_CRF.LongestDiameter = lstStr[4];
              da_CRF.Clipplaced = lstStr[5];          
              lstDS_CRF_REF.add(da_CRF);
            }
            
            if(!Test.isRunningTest()) {
                transId = service.createDiseaseAssessment(institution,site,trial,lstDS_CRF_REF);
            }
            nextform = 27;    
         
         } else if(fileNameSplit[0] == 'ChemoSummaryCRF') {
            List<ChemoSummaryCRF> lstChemoSummary = new List<ChemoSummaryCRF>();
            for(List<String> lstStr : lstCSVData) {
                system.debug('lstStr : '+lstStr+'   lstStr.size() : '+lstStr.size());
                if(!(lstStr != null && lstStr.size() == 16)) {
                    transId = service.insertErrorLog('Failure : '+'Number of column headers should be 16. Please ensure that the file you have uploaded has sufficient number of column.');
                    ref = new Pagereference('/apex/uploadCRFForTestHarness?inst='+institution+'&site='+site+'&trial='+trial+'&nextForm='+nextform+'&transId='+transId);
                    ref.setRedirect(true);
                    return ref;
                }
               ChemoSummaryCRF csf = new ChemoSummaryCRF();
               csf.PatientId = lstStr[0];
               csf.CRFId = lstStr[1];
               csf.FirstDateofTaxaneTherapy = lstStr[2];
               csf.LastDateofTaxaneTherapy = lstStr[3];
               csf.TaxaneRegimenTreatmentEndReasons = lstStr[4];
               csf.OtherReason = lstStr[5];
               csf.FirstDateofAnthracyclineTherapy = lstStr[6];
               csf.LastDateofAnthracyclineTherapy = lstStr[7];
               csf.AnthracyclineRegimenTreatmentEndReason = lstStr[8];
               csf.OtherReason1= lstStr[9];
               csf.FirstDateofInvestigationalTherapy = lstStr[10];
               csf.LastDateofInvestigationalTherapy = lstStr[11];
               csf.InvestigationalRegimenTreatmentEndReason = lstStr[12];
               csf.OtherReason2 = lstStr[13];
               csf.CompletedDate = lstStr[14];
               csf.Status = lstStr[15]; 
                
               lstChemoSummary.add(csf);
            }
            if(!Test.isRunningTest()) {
                transId = service.createChemoSummary(institution,site,trial,lstChemoSummary);
            }
            nextform = 26;
        } else if(fileNameSplit[0] == 'ChemoSummaryRegimen_OSP_CRF') {
            List<ChemoSummaryRegimen_OSP_CRF> lstChemoSummaryRegimen_OSP_CRF = new List<ChemoSummaryRegimen_OSP_CRF>();
            for(List<String> lstStr : lstCSVData) {
                system.debug('lstStr : '+lstStr+'   lstStr.size() : '+lstStr.size());
                if(!(lstStr != null && lstStr.size() == 5)) {
                    transId = service.insertErrorLog('Failure : '+'Number of column headers should be 5. Please ensure that the file you have uploaded has sufficient number of column.');
                    ref = new Pagereference('/apex/uploadCRFForTestHarness?inst='+institution+'&site='+site+'&trial='+trial+'&nextForm='+nextform+'&transId='+transId);
                    ref.setRedirect(true);
                    return ref;
                }
               ChemoSummaryRegimen_OSP_CRF CSR = new ChemoSummaryRegimen_OSP_CRF();
               CSR.CRFId = lstStr[0];
               CSR.FirstDateofTherapy = lstStr[1];
               CSR.LastDateofTherapy  = lstStr[2];
               CSR.TreatmentEndReasons = lstStr[3];
               CSR.OtherReason = lstStr[4];
               lstChemoSummaryRegimen_OSP_CRF.add(CSR);
            }
            
            if(!Test.isRunningTest()) {
                transId = service.createChemoSummaryRegimen(institution,site,trial,lstChemoSummaryRegimen_OSP_CRF);
            }
            nextform = 27;
            } else if(fileNameSplit[0] == 'BaselineSymptomsCRF') {
            List<BaselineSymptomsCRF> lsBaselineSymptoms = new List<BaselineSymptomsCRF>();
            for(List<String> lstStr : lstCSVData) {
                system.debug('lstStr : '+lstStr+'   lstStr.size() : '+lstStr.size());
                if(!(lstStr != null && lstStr.size() ==5)) {
                    transId = service.insertErrorLog('Failure : '+'Number of column headers should be 5. Please ensure that the file you have uploaded has sufficient number of column.');
                    ref = new Pagereference('/apex/uploadCRFForTestHarness?inst='+institution+'&site='+site+'&trial='+trial+'&nextForm='+nextform+'&transId='+transId);
                    ref.setRedirect(true);
                    return ref;
                }
              BaselineSymptomsCRF baselineSymptoms = new BaselineSymptomsCRF();
              baselineSymptoms.PatientId = lstStr[0];
              baselineSymptoms.CRFId = lstStr[1];
              baselineSymptoms.VisitDate = lstStr[2];               
              baselineSymptoms.CompletedDate = lstStr[3];
              baselineSymptoms.Status = lstStr[4]; 
                
              lsBaselineSymptoms.add(baselineSymptoms);
            }
            if(!Test.isRunningTest()) {
                transId = service.createBaselineSymptoms(institution,site,trial,lsBaselineSymptoms);
            }
            nextform = 28;
         } else if(fileNameSplit[0] == 'Allergy') {
            List<Allergy_CRF_BSF> lstA_CRF_BSF = new List<Allergy_CRF_BSF>();
            for(List<String> lstStr : lstCSVData) {
                system.debug('lstStr : '+lstStr+'   lstStr.size() : '+lstStr.size());
                if(!(lstStr != null && lstStr.size() == 9)) {
                    transId = service.insertErrorLog('Failure : '+'Number of column headers should be 9. Please ensure that the file you have uploaded has sufficient number of column.');
                    ref = new Pagereference('/apex/uploadCRFForTestHarness?inst='+institution+'&site='+site+'&trial='+trial+'&nextForm='+nextform+'&transId='+transId);
                    ref.setRedirect(true);
                    return ref;
                }
              Allergy_CRF_BSF aoc_CRF = new Allergy_CRF_BSF();
             aoc_CRF.CRFId = lstStr[0];
             aoc_CRF.AllergyType = lstStr[1];
             aoc_CRF.OtherAllergy = lstStr[2];
             aoc_CRF.Allergies = lstStr[3];
             aoc_CRF.Reactions = lstStr[4];
             aoc_CRF.OtherReactions = lstStr[5];
             aoc_CRF.Severity = lstStr[6];
             aoc_CRF.Yearfirstseen = lstStr[7];   
             aoc_CRF.FormName = lstStr[8];        
             lstA_CRF_BSF.add(aoc_CRF);
            }
            
            if(!Test.isRunningTest()) {
                transId = service.createAllergy(institution,site,trial,lstA_CRF_BSF);
            }
            nextform = 29;    
    
         } else if(fileNameSplit[0] == 'BaselineCondition') {
            List<BaselineCondition_OSP_CRF> lstBaselineCondition_OSP_CRF = new List<BaselineCondition_OSP_CRF>();
            for(List<String> lstStr : lstCSVData) {
                system.debug('lstStr : '+lstStr+'   lstStr.size() : '+lstStr.size());
                if(!(lstStr != null && lstStr.size() == 13)) {
                    transId = service.insertErrorLog('Failure : '+'Number of column headers should be 13. Please ensure that the file you have uploaded has sufficient number of column.');
                    ref = new Pagereference('/apex/uploadCRFForTestHarness?inst='+institution+'&site='+site+'&trial='+trial+'&nextForm='+nextform+'&transId='+transId);
                    ref.setRedirect(true);
                    return ref;
                }
              BaselineCondition_OSP_CRF BC= new BaselineCondition_OSP_CRF();
              BC.CRFId = lstStr[0];
              BC.DiagnosisType = lstStr[1];
              BC.OtherDaignosis = lstStr[2];
              BC.Daignosis = lstStr[3];              
              BC.SeverityGrade = lstStr[4];
              BC.Attribution = lstStr[5];
              BC.OnsetMonth = lstStr[6];
              BC.OnsetDay = lstStr[7];
              BC.OnsetYear = lstStr[8];
              BC.Resolved = lstStr[9];
              BC.EndMonth = lstStr[10];
              BC.EndDay = lstStr[11];
              BC.EndYear = lstStr[12];
              lstBaselineCondition_OSP_CRF.add(BC);
            }
            
            if(!Test.isRunningTest()) {
                transId = service.createBaselineCondition(institution,site,trial,lstBaselineCondition_OSP_CRF);
            }
            nextform = 29;    
           
       } else if(fileNameSplit[0] == 'Toxicities') {
            List<Toxicity_OSP_CRF> lstToxicity = new List<Toxicity_OSP_CRF>();
            for(List<String> lstStr : lstCSVData) {
                system.debug('lstStr : '+lstStr+'   lstStr.size() : '+lstStr.size());
                if(!(lstStr != null && lstStr.size() == 19)) {
                    transId = service.insertErrorLog('Failure : '+'Number of column headers should be 19. Please ensure that the file you have uploaded has sufficient number of column.');
                    ref = new Pagereference('/apex/uploadCRFForTestHarness?inst='+institution+'&site='+site+'&trial='+trial+'&nextForm='+nextform+'&transId='+transId);
                    ref.setRedirect(true);
                    return ref;
                }
              Toxicity_OSP_CRF toc = new Toxicity_OSP_CRF();
              toc.CRFId = lstStr[0];
              toc.SymptomStatus = lstStr[1];
              toc.SymptomMasters = lstStr[2];
              toc.ToxicityAgent = lstStr[3];
              toc.ToxicityOther = lstStr[4];
              toc.ToxicityStatus = lstStr[5];
              toc.Grade = lstStr[6];
              toc.Attribution = lstStr[7];
              toc.Waseventlifethreatning = lstStr[8];
              toc.Dideventrequiredhospitalization = lstStr[9];
              toc.Resultpersistentsignificantdisability = lstStr[10];
              toc.Resultconginentalabnormalitydefect = lstStr[11];
              toc.Didtheinvestigatorfindeventunusual = lstStr[12];
              toc.Dideventresultindeath = lstStr[13];
              toc.OnsetDate = lstStr[14];
              toc.SAE = lstStr[15];
              toc.Resolved = lstStr[16];
              toc.AEEndDate = lstStr[17];
              toc.PatientComplaint = lstStr[18];
              lstToxicity.add(toc);
            }
            
            if(!Test.isRunningTest()) {
                transId = service.createToxicities(institution,site,trial,lstToxicity);
            }
            nextform = 30;    
         } else if(fileNameSplit[0] == 'LabandTestCRF') {
            List<LabandTestCRF> lstLabandTestCRF = new List<LabandTestCRF>();
            for(List<String> lstStr : lstCSVData) {
                system.debug('lstStr : '+lstStr+'   lstStr.size() : '+lstStr.size());
                if(!(lstStr != null && lstStr.size() == 34)) {
                    transId = service.insertErrorLog('Failure : '+'Number of column headers should be 34. Please ensure that the file you have uploaded has sufficient number of column.');
                    ref = new Pagereference('/apex/uploadCRFForTestHarness?inst='+institution+'&site='+site+'&trial='+trial+'&nextForm='+nextform+'&transId='+transId);
                    ref.setRedirect(true);
                    return ref; 
                }
               LabandTestCRF latCRF = new LabandTestCRF();
               latCRF.PatientId = lstStr[0];
               latCRF.CollectionDate = lstStr[1];
               latCRF.Leukocytes = lstStr[2];
               latCRF.LeukocytesResult = lstStr[3];
               latCRF.LeukocytesInstitutionalReferenceRange = lstStr[4];
               latCRF.AbsoluteNeutrophilCountANC = lstStr[5];
               latCRF.AbsoluteNeutrophilCountANCResult = lstStr[6];
               latCRF.ANCIndustrialReferenceRange = lstStr[7];
               latCRF.Platelets = lstStr[8];
               latCRF.PlateletsResult = lstStr[9];
               latCRF.PlateletsInstitutionalReferenceRange = lstStr[10];
               latCRF.TotalBilirubin = lstStr[11];
               latCRF.TotalBilirubinResult = lstStr[12];
               latCRF.TotalBilirubinInstitutionalReference = lstStr[13];
               latCRF.AST = lstStr[14];
               latCRF.ASTResult = lstStr[15]; 
               latCRF.ASTInstitutionalReferenceRange = lstStr[16];
               latCRF.ALT = lstStr[17];
               latCRF.ALTResult = lstStr[18];
               latCRF.ALTInstitutionalReferenceRange = lstStr[19];
               latCRF.Creatinine = lstStr[20];
               latCRF.CreatinineResult = lstStr[21];
               latCRF.CreatinineInstitutionalReferenceRange = lstStr[22];
               latCRF.MUGAScan = lstStr[23];
               latCRF.MUGAScanDate = lstStr[24];
               latCRF.MUGAScanLVEF = lstStr[25];
               latCRF.MUGAInstitutionalLowerLimitofNormal = lstStr[26];
               latCRF.CardiacEcho = lstStr[27];
               latCRF.CardiacEchoDate = lstStr[28];
               latCRF.CardiacEchoLVEF = lstStr[29];
               latCRF.CardiacEchoInstitutionalLowerLimit = lstStr[30];
               latCRF.CollectionDate1 = lstStr[31];
               latCRF.CompletedDate = lstStr[32];
               latCRF.Status = lstStr[33];
               lstLabandTestCRF.add(latCRF);
            }
            
            if(!Test.isRunningTest()) {
                transId = service.createLabandTest(institution,site,trial,lstLabandTestCRF);            
            }
            nextform = 31;
         } else if(fileNameSplit[0] == 'PostSurgeryCRF') {
            List<PostSurgeryCRF> lstPostSurgeryCRF = new List<PostSurgeryCRF>();
            for(List<String> lstStr : lstCSVData) {
                system.debug('lstStr : '+lstStr+'   lstStr.size() : '+lstStr.size());
                if(!(lstStr != null && lstStr.size() == 42)) {
                    transId = service.insertErrorLog('Failure : '+'Number of column headers should be 42. Please ensure that the file you have uploaded has sufficient number of column.');
                    ref = new Pagereference('/apex/uploadCRFForTestHarness?inst='+institution+'&site='+site+'&trial='+trial+'&nextForm='+nextform+'&transId='+transId);
                    ref.setRedirect(true);
                    return ref;
                }
           PostSurgeryCRF postSurObjCRF = new PostSurgeryCRF();
           postSurObjCRF.PatientId = lstStr[0];
           postSurObjCRF.CRFId = lstStr[1];
           postSurObjCRF.DateOfProcedure = lstStr[2];
           postSurObjCRF.Surgeon = lstStr[3];
           postSurObjCRF.SurgeonOther = lstStr[4];
           postSurObjCRF.TypeOfTumor = lstStr[5];
           postSurObjCRF.SizeofGrossMassHeight = lstStr[6];
           postSurObjCRF.SizeofGrossMassWidth = lstStr[7];
           postSurObjCRF.GrossMassMeasurementUnit = lstStr[8];
           postSurObjCRF.SizeofLargestGrossMassHeight = lstStr[9];
           postSurObjCRF.SizeofLargestGrossMassWidth = lstStr[10];
           postSurObjCRF.LargestGrossMassMeasurementUnit = lstStr[11];
           postSurObjCRF.Totalspanmultifocalgrossmassheight = lstStr[12];
           postSurObjCRF.Totalspanmultifocalgrossmasswidth = lstStr[13];
           postSurObjCRF.TotalSpanMeasurementUnit = lstStr[14];
           postSurObjCRF.Spanofgrosschangesheight = lstStr[15];
           postSurObjCRF.Spanofgrosschangeswidth = lstStr[16];
           postSurObjCRF.GrossChangesMeasurementUnit = lstStr[17];
           postSurObjCRF.Lymphnodedissectiondone = lstStr[18];
           postSurObjCRF.AreCalcificationsPresent = lstStr[19];
           postSurObjCRF.CalcificationDetails = lstStr[20];
           postSurObjCRF.IsDCISPresent = lstStr[21];
           postSurObjCRF.IsLCISPresent = lstStr[22];
           postSurObjCRF.Isinvasivetumorpresent = lstStr[23];
           postSurObjCRF.separatelysubmittedmargins = lstStr[24];
           postSurObjCRF.InvasiveCAPresent = lstStr[25];
           postSurObjCRF.InvasiveCAattruemargin = lstStr[26];
           postSurObjCRF.InSituDiseasePresent = lstStr[27];
           postSurObjCRF.InSituDiseaseAtTrueMargin = lstStr[28];
           postSurObjCRF.OtherChangesPresent = lstStr[29];
           postSurObjCRF.OtherChanges = lstStr[30];
           postSurObjCRF.OtherChange = lstStr[31];
           postSurObjCRF.pcr = lstStr[32];
           postSurObjCRF.PrimaryTumorBedArea = lstStr[33];
           postSurObjCRF.OverallCenterCellularity = lstStr[34];
           postSurObjCRF.percentageofCAinSituDisease = lstStr[35];
           postSurObjCRF.Numberoflymphnodespositive = lstStr[36];
           postSurObjCRF.Diameteroflargestmet = lstStr[37];
           postSurObjCRF.RCBindex = lstStr[38];
           postSurObjCRF.RCBClass = lstStr[39];
           postSurObjCRF.CompletedDate = lstStr[40];
           postSurObjCRF.Status = lstStr[41];     
           lstPostSurgeryCRF.add(postSurObjCRF);
            }
            
            if(!Test.isRunningTest()) {
                transId = service.createPostSurgery(institution,site,trial,lstPostSurgeryCRF);
            }
            nextform = 32;
        } else if(fileNameSplit[0] == 'ProcedureSpecimen') {
            List<Procedure_Specimen_Detail_OSP_PSS> lstProcedure_Specimen_Detail_OSP_PSS = new List<Procedure_Specimen_Detail_OSP_PSS>();
            for(List<String> lstStr : lstCSVData) {
                system.debug('lstStr : '+lstStr+'   lstStr.size() : '+lstStr.size());
                if(!(lstStr != null && lstStr.size() == 21)) {
                    transId = service.insertErrorLog('Failure : '+'Number of column headers should be 21. Please ensure that the file you have uploaded has sufficient number of column.');
                    ref = new Pagereference('/apex/uploadCRFForTestHarness?inst='+institution+'&site='+site+'&trial='+trial+'&nextForm='+nextform+'&transId='+transId);
                    ref.setRedirect(true);
                    return ref;
                }
              Procedure_Specimen_Detail_OSP_PSS procedurespecimen = new Procedure_Specimen_Detail_OSP_PSS();
              procedurespecimen.CRFId = lstStr[0];
              procedurespecimen.Procedure = lstStr[1];
              procedurespecimen.Specimen = lstStr[2];
              procedurespecimen.MainSpecimensubmittedforhistology = lstStr[3];
              procedurespecimen.SingleSpecimentsubmittedforhistology = lstStr[4];
              procedurespecimen.MediallateralGrossspecimensize = lstStr[5];
              procedurespecimen.Mediallateralsizeunit = lstStr[6];
              procedurespecimen.AnteriordeepGrossspecimensize = lstStr[7];
              procedurespecimen.Anteriordeepsizeunit = lstStr[8];
              procedurespecimen.SuperorinferiorGrossspecimensize = lstStr[9];
              procedurespecimen.Superorinferiorsizeunit = lstStr[10];
              procedurespecimen.TotalSlices = lstStr[11];
              procedurespecimen.SlicingMethod = lstStr[12];
              procedurespecimen.SlicePlane1 = lstStr[13];
              procedurespecimen.Slice1 = lstStr[14];
              procedurespecimen.Block1 = lstStr[15];
              procedurespecimen.SlicePlane2 = lstStr[16];
              procedurespecimen.Slice2 = lstStr[17];
              procedurespecimen.Block2 = lstStr[18];
              procedurespecimen.PerformingLab = lstStr[19];
              procedurespecimen.Lymphnodetissuepresentinsample = lstStr[20];
              lstProcedure_Specimen_Detail_OSP_PSS.add(procedurespecimen);
            }
            
            if(!Test.isRunningTest()) {
                transId = service.createProcedureSpecimen(institution, site, trial,lstProcedure_Specimen_Detail_OSP_PSS);
            }
            nextform = 33;
        } else if(fileNameSplit[0] == 'LymphNode') {
            List<Lymph_Nodes_OSP_CRF>lstLymphNode = new List<Lymph_Nodes_OSP_CRF>();
            for(List<String> lstStr : lstCSVData) {
                system.debug('lstStr : '+lstStr+'   lstStr.size() : '+lstStr.size());
                if(!(lstStr != null && lstStr.size() == 36)) {
                    transId = service.insertErrorLog('Failure : '+'Number of column headers should be 36. Please ensure that the file you have uploaded has sufficient number of column.');
                    ref = new Pagereference('/apex/uploadCRFForTestHarness?inst='+institution+'&site='+site+'&trial='+trial+'&nextForm='+nextform+'&transId='+transId);
                    ref.setRedirect(true);
                    return ref;
                }
             Lymph_Nodes_OSP_CRF lymphnode = new Lymph_Nodes_OSP_CRF();
             lymphnode.CRFId = lstStr[0];
             lymphnode.Procedure = lstStr[1];
             lymphnode.Letarality = lstStr[2];
             lymphnode.SentinelNodes = lstStr[3];             
             //lymphnode.NodeCheckboxValue = lstStr[3];
             lymphnode.Location = lstStr[4];
             lymphnode.Positive = lstStr[5];
             lymphnode.Examined = lstStr[6];
             lymphnode.MethodofDetection = lstStr[7];
             lymphnode.SingleDetectionResult = lstStr[8];
             lymphnode.ClusterDetectionResult = lstStr[9];
             lymphnode.FocusDetectionResult = lstStr[10];
             lymphnode.NotreportedDetectionResult = lstStr[11];
             lymphnode.SizeofLargestTumor = lstStr[12];
             lymphnode.SpecificSizeofLargestTumor = lstStr[13];
             lymphnode.TumorSizeMeasurementUnit = lstStr[14];
             lymphnode.ExtramodalExtension = lstStr[15];
             lymphnode.AxillaryNodes = lstStr[16];
             //lymphnode.NodeCheckboxValue1 = lstStr[16];
             lymphnode.Positive1 = lstStr[17];
             lymphnode.Examined1 = lstStr[18];
             lymphnode.MethodofDetection1 = lstStr[19];
             lymphnode.SingleDetectionResult1 = lstStr[20];
             lymphnode.ClusterDetectionResult1 = lstStr[21];
             lymphnode.FocusDetectionResult1 = lstStr[22];
             lymphnode.NotreportedDetectionResult1 = lstStr[23];
             lymphnode.SizeofLargestTumor1 = lstStr[24];
             lymphnode.SpecificSizeofLargestTumor1 = lstStr[25];
             lymphnode.TumorSizeMeasurementUnit1 = lstStr[26];
             lymphnode.ExtramodalExtension1 = lstStr[27];
             lymphnode.AdditionalNodes = lstStr[28];
             //lymphnode.NodeCheckboxValue2 = lstStr[28];
             lymphnode.Location1 = lstStr[29];
             lymphnode.Positive2 = lstStr[30];
             lymphnode.Examined2 = lstStr[31];
             lymphnode.SizeofLargestTumor2 = lstStr[32];
             lymphnode.SpecificSizeofLargestTumor2 = lstStr[33];
             lymphnode.TumorSizeMeasurementUnit2 = lstStr[34];
             lymphnode.ExtramodalExtension2 = lstStr[35];

             lstLymphNode.add(lymphnode);
            }
            
            if(!Test.isRunningTest()) {
                transId = service.createLymphNode(institution, site, trial, lstLymphNode);
            }
            nextform = 34;
          } else if(fileNameSplit[0] == 'Receptors') {
            List<Receptors_OSP_CRF> lstReceptors_OSP_CRF = new List<Receptors_OSP_CRF>();
            for(List<String> lstStr : lstCSVData) {
                system.debug('lstStr : '+lstStr+'   lstStr.size() : '+lstStr.size());
                if(!(lstStr != null && lstStr.size() == 23)) {
                    transId = service.insertErrorLog('Failure : '+'Number of column headers should be 23. Please ensure that the file you have uploaded has sufficient number of column.');
                    ref = new Pagereference('/apex/uploadCRFForTestHarness?inst='+institution+'&site='+site+'&trial='+trial+'&nextForm='+nextform+'&transId='+transId);
                    ref.setRedirect(true);
                    return ref;
                }
                Receptors_OSP_CRF receptor = new Receptors_OSP_CRF();
                receptor.OSPId = lstStr[0];
                receptor.ERStatus = lstStr[1];
                receptor.ERProporationScore = lstStr[2];
                receptor.ERIntensityScore = lstStr[3];
                receptor.TotalScoreER = lstStr[4];
                receptor.PRStatus = lstStr[5];
                receptor.PRProporationScore = lstStr[6];
                receptor.PRIntensityScore = lstStr[7];
                receptor.TotalScorePR = lstStr[8];
                receptor.HER2neuMarkerStatus = lstStr[9];
                receptor.DAKOHerceptest = lstStr[10];
                //receptor.DAKOHerceptestValue = lstStr[11];
                receptor.OtherIHCTest = lstStr[11];
                //receptor.OtherIHCTestValue = lstStr[13];
                receptor.OtherIHCResult = lstStr[12];
                receptor.VentanaKit = lstStr[13];
                //receptor.VentanakitValue = lstStr[16];
                receptor.CB11 = lstStr[14];
                //receptor.CB11Value = lstStr[18];
                receptor.IHCTestNotDone = lstStr[15];
                receptor.VentanaOncoprobe = lstStr[16];
                //receptor.VentanaOncoprobeValue = lstStr[21];
                receptor.OtherFISHTest = lstStr[17];
                //receptor.OtherFISHTestValue = lstStr[23];
                receptor.OtherFISHResults = lstStr[18];
                receptor.FISHTestNotDone = lstStr[19];
                receptor.VysisPathVision = lstStr[20];
                receptor.VysisPathVisionValue = lstStr[21];
                receptor.Letarality = lstStr[22];
                lstReceptors_OSP_CRF.add(receptor);
            }
            
            if(!Test.isRunningTest()) {
                transId = service.createReceptor(institution, site, trial, lstReceptors_OSP_CRF);
            }
            nextform = 35;  

        } else if(fileNameSplit[0] == 'StagingDetail') {
            List<Staging_OSP_CRF> lstStaging_OSP_CRF = new List<Staging_OSP_CRF>();
            for(List<String> lstStr : lstCSVData) {
                system.debug('lstStr : '+lstStr+'   lstStr.size() : '+lstStr.size());
                if(!(lstStr != null && lstStr.size() == 15)) {
                    transId = service.insertErrorLog('Failure : '+'Number of column headers should be 15. Please ensure that the file you have uploaded has sufficient number of column.');
                    ref = new Pagereference('/apex/uploadCRFForTestHarness?inst='+institution+'&site='+site+'&trial='+trial+'&nextForm='+nextform+'&transId='+transId);
                    ref.setRedirect(true);
                    return ref;
                }
               Staging_OSP_CRF staging = new Staging_OSP_CRF();
               staging.CRFId = lstStr[0];
               staging.Letarality = lstStr[1];
               staging.StagingModifierType = lstStr[2];
               staging.Modifiermultipleprimary = lstStr[3];
               staging.Modifierclassificationdone = lstStr[4];
               staging.Modifierindicatesrecurrent = lstStr[5];
               staging.Modifierdesignates = lstStr[6];
               staging.TumorType = lstStr[7];
               staging.NodeType = lstStr[8];
               staging.Metastasis = lstStr[9];
               staging.CalculatedStage = lstStr[10];
               staging.CalculatedStageValue = lstStr[11];
               staging.AdjudicatedStage = lstStr[12];
               staging.AdjudicatedBy = lstStr[13];
               staging.T4Tumorfinalstatus = lstStr[14];
               lstStaging_OSP_CRF.add(staging);
            }
            
            if(!Test.isRunningTest()) {
                transId = service.createStagingDetail(institution, site, trial,lstStaging_OSP_CRF);
            }
            nextform = 36;  
      } else if(fileNameSplit[0] == 'Procedures') {
            system.debug('Procedure.csv CSV Found.');
            List<Procedure_OSP_PSS> lstPro_OSP_CRF = new List<Procedure_OSP_PSS>();
            for(List<String> lstStr : lstCSVData) {
                system.debug('lstStr : '+lstStr+'   lstStr.size() : '+lstStr.size());
                if(!(lstStr != null && lstStr.size() == 4)) {
                    transId = service.insertErrorLog('Failure : '+'Number of column headers should be 4. Please ensure that the file you have uploaded has sufficient number of column.');
                    ref = new Pagereference('/apex/uploadCRFForTestHarness?inst='+institution+'&site='+site+'&trial='+trial+'&nextForm='+nextform+'&transId='+transId);
                    ref.setRedirect(true);
                    return ref;
                }
                Procedure_OSP_PSS procedure = new Procedure_OSP_PSS();
                procedure.CRFId = lstStr[0];
                procedure.ProcedureName = lstStr[1];
                procedure.Laterality = lstStr[2];
                procedure.Location = lstStr[3];                
                lstPro_OSP_CRF.add(procedure);
            }
            
            if(!Test.isRunningTest()) {
                transId = service.createProcedures(institution, site, trial, lstPro_OSP_CRF);
            }
            nextform = 37;
        } else if(fileNameSplit[0] == 'DCISs') {
            List<DCIS_OSP_CRF> lstDCIS = new List<DCIS_OSP_CRF>();
            for(List<String> lstStr : lstCSVData) {
                system.debug('lstStr : '+lstStr+'   lstStr.size() : '+lstStr.size());
                if(!(lstStr != null && lstStr.size() == 23)) {
                    transId = service.insertErrorLog('Failure : '+'Number of column headers should be 23. Please ensure that the file you have uploaded has sufficient number of column.');
                    ref = new Pagereference('/apex/uploadCRFForTestHarness?inst='+institution+'&site='+site+'&trial='+trial+'&nextForm='+nextform+'&transId='+transId);
                    ref.setRedirect(true);
                    return ref;
                }
                DCIS_OSP_CRF dcis = new DCIS_OSP_CRF();
                dcis.CRFId = lstStr[0];
                dcis.DCIS = lstStr[1];
                dcis.UnknownNotReported = lstStr[2];
                dcis.TotalHistologicalSpan = lstStr[3];
                dcis.TotalHistologicalSpanMeasurementUnit = lstStr[4];
                dcis.Margin = lstStr[5];
                dcis.ClosestMargin = lstStr[6];
                dcis.SpecificClosestMargin = lstStr[7];
                dcis.SpecificClosestMarginMeasurementUnit = lstStr[8];
                dcis.PunctateNecrosis = lstStr[9];
                dcis.Comedonecrosis = lstStr[10];
                dcis.Papillary = lstStr[11];
                dcis.Micropapillary = lstStr[12];
                dcis.Necrosis = lstStr[13];
                dcis.Cribiform = lstStr[14];
                dcis.Cruciform = lstStr[15];
                dcis.Clinging = lstStr[16];
                dcis.Solid = lstStr[17];
                dcis.Apocrine = lstStr[18];
                dcis.IntraCysticEncystedPapillary = lstStr[19];
                dcis.Other = lstStr[20];
                dcis.Otherifothermentiontypeintextbox = lstStr[21];
                dcis.NuclearGrade = lstStr[22];
                lstDCIS.add(dcis);
            }
            
            if(!Test.isRunningTest()) {
                transId = service.createDCISs(institution, site, trial, lstDCIS);
            }
            nextform = 38;
        } else if(fileNameSplit[0] == 'LCISs') {
            List<LCIS_OSP_CRF> lstLCIS = new List<LCIS_OSP_CRF>();
            for(List<String> lstStr : lstCSVData) {
                system.debug('lstStr : '+lstStr+'   lstStr.size() : '+lstStr.size());
                if(!(lstStr != null && lstStr.size() == 6)) {
                    transId = service.insertErrorLog('Failure : '+'Number of column headers should be 6. Please ensure that the file you have uploaded has sufficient number of column.');
                    ref = new Pagereference('/apex/uploadCRFForTestHarness?inst='+institution+'&site='+site+'&trial='+trial+'&nextForm='+nextform+'&transId='+transId);
                    ref.setRedirect(true);
                    return ref;
                }
                LCIS_OSP_CRF lcis = new LCIS_OSP_CRF();
                lcis.CRFId = lstStr[0];
                lcis.LCIS = lstStr[1];
                lcis.UnknownNotReported = lstStr[2];
                lcis.Totalhistologicalspan = lstStr[3];
                lcis.Totalhistologicalspanmeasurementunit = lstStr[4];
                lcis.HistologicalType = lstStr[5];
                lstLCIS.add(lcis);
            }
            
            if(!Test.isRunningTest()) {
                transId = service.createLCISs(institution, site, trial, lstLCIS);
            }
            nextform = 39;
        } else if(fileNameSplit[0] == 'InvasiveTumors') {
            List<InvasiveTumor_OSP_PSS> lstInvTumor = new List<InvasiveTumor_OSP_PSS>();
            for(List<String> lstStr : lstCSVData) {
                system.debug('lstStr : '+lstStr+'   lstStr.size() : '+lstStr.size());
                if(!(lstStr != null && lstStr.size() == 34)) {
                    transId = service.insertErrorLog('Failure : '+'Number of column headers should be 34. Please ensure that the file you have uploaded has sufficient number of column.');
                    ref = new Pagereference('/apex/uploadCRFForTestHarness?inst='+institution+'&site='+site+'&trial='+trial+'&nextForm='+nextform+'&transId='+transId);
                    ref.setRedirect(true);
                    return ref;
                }
                InvasiveTumor_OSP_PSS invTumor = new InvasiveTumor_OSP_PSS();
                invTumor.CRFId = lstStr[0];
                invTumor.Overallcancercellularity = lstStr[1];
                invTumor.UnknownNotReported = lstStr[2];
                invTumor.TumorSizeHeight = lstStr[3];
                invTumor.TumorSizeWidth = lstStr[4];
                invTumor.TumorMeasurementUnit = lstStr[5];
                invTumor.MultifocalTumor = lstStr[6];
                invTumor.Invasivemargins = lstStr[7];
                invTumor.ClosestMargin = lstStr[8];
                invTumor.SpecifyNo = lstStr[9];
                invTumor.SpecifyUnits = lstStr[10];
                invTumor.InvasiveDuctalCarcinomaNos = lstStr[11];
                invTumor.InvasiveLobularCarcinomaClassicType = lstStr[12];
                invTumor.InvasiveLobularCarcinomaAlveolarType = lstStr[13];
                invTumor.PleomorphicLobularCarcinoma = lstStr[14];
                invTumor.TubulolobularCarcinoma = lstStr[15];
                invTumor.InvasiveCarcinomaMixedDuctalAndLobularType = lstStr[16];
                invTumor.TubularCarcinoma = lstStr[17];
                invTumor.MucinousCarcinoma = lstStr[18];
                invTumor.MedullaryCarcinoma = lstStr[19];
                invTumor.InvasivePapillaryCarcinoma = lstStr[20];
                invTumor.InvasiveCribiformCarcinoma = lstStr[21];
                invTumor.Other = lstStr[22];
                invTumor.Otherifothermentiontypeintextbox = lstStr[23];
                invTumor.NuclearGrade = lstStr[24];
                invTumor.MitoticCount = lstStr[25];
                invTumor.TubulePapillaFormation = lstStr[26];
                invTumor.TotalPoints = lstStr[27];
                invTumor.SBRGrade = lstStr[28];
                invTumor.LympaticVascularInvasion = lstStr[29];
                invTumor.DermalInvolvement = lstStr[23];
                invTumor.Muscleinvolvement = lstStr[31];
                invTumor.Evidenceoftherapeuticeffects = lstStr[32];
                invTumor.Otherchangespresent  = lstStr[33];               
                lstInvTumor.add(invTumor);
            }
            
            if(!Test.isRunningTest()) {
                transId = service.createInvasiveTumors(institution, site, trial, lstInvTumor);
            }
            nextform = 40; 
      
            } else if(fileNameSplit[0] == 'ChemoTreatmentCRF') {
        List<ChemoTreatmentCRF> lstChemoTreatmentCRF = new List<ChemoTreatmentCRF>();
            
            for(List<String> lstStr : lstCSVData) {
                system.debug('lstStr : '+lstStr+'   lstStr.size() : '+lstStr.size());
                
                if(!(lstStr != null && lstStr.size() == 9)) {
                
                    transId = service.insertErrorLog('Failure : '+'Number of column headers should be 9. Please ensure that the file you have uploaded has sufficient number of column.');
                    
                    ref = new Pagereference('/apex/uploadCRFForTestHarness?inst='+institution+'&site='+site+'&trial='+trial+'&nextForm='+nextform+'&transId='+transId);

                     
                    ref.setRedirect(true);
                    return ref; 
                }
              ChemoTreatmentCRF chemoTreatCRF = new ChemoTreatmentCRF();
              chemoTreatCRF.PatientId = lstStr[0];
              chemoTreatCRF.CRFId = lstStr[1];
              chemoTreatCRF.Dateoftherapy = lstStr[2];
              chemoTreatCRF.Cyclenumber = lstStr[3];
              chemoTreatCRF.Didpatientgooffstudytreatment = lstStr[4];
              chemoTreatCRF.Patientweight = lstStr[5];
              chemoTreatCRF.Patientheight = lstStr[6];                          
              chemoTreatCRF.CompletedDate = lstStr[7];
              chemoTreatCRF.Status = lstStr[8];
              lstChemoTreatmentCRF.add(chemoTreatCRF);
            }
            
              
            
            if(!Test.isRunningTest()) {
                transId = service.createChemoTreatment(institution,site,trial,lstChemoTreatmentCRF);
            }
             nextform = 41;
            
            } else if(fileNameSplit[0] == 'ChemoTherapyRegimen') {
            List<ChemoTherapyRegimen_CRF_CTF>  lstCTR_CRF_CTF = new List<ChemoTherapyRegimen_CRF_CTF>();
            for(List<String> lstStr : lstCSVData) {
                system.debug('lstStr : '+lstStr+'   lstStr.size() : '+lstStr.size());
                if(!(lstStr != null && lstStr.size() == 15)) {
                    transId = service.insertErrorLog('Failure : '+'Number of column headers should be 19. Please ensure that the file you have uploaded has sufficient number of column.');
                    ref = new Pagereference('/apex/uploadCRFForTestHarness?inst='+institution+'&site='+site+'&trial='+trial+'&nextForm='+nextform+'&transId='+transId);
                    ref.setRedirect(true);
                    return ref;
                }
              ChemoTherapyRegimen_CRF_CTF ctr_CRF = new ChemoTherapyRegimen_CRF_CTF();
             ctr_CRF.CRFId = lstStr[0];
             ctr_CRF.Agent = lstStr[1];
             ctr_CRF.PrescribedDose = lstStr[2];
             ctr_CRF.TotalDoseAdministered = lstStr[3];
             ctr_CRF.Day = lstStr[4];
             ctr_CRF.DoseDelay = lstStr[5];
             ctr_CRF.DoseMod = lstStr[6];
             ctr_CRF.Dosemodification = lstStr[7];
             ctr_CRF.OtherDoseModReason = lstStr[8];
             ctr_CRF.Didpatientstopreceiving = lstStr[9];
             ctr_CRF.Reasonwhypatientstoppedreceiving = lstStr[10];
             ctr_CRF.OtherReasonPatientStopReceiving = lstStr[11];
             ctr_CRF.OtherAgent = lstStr[12];
             //ctr_CRF.PrescribedDose1 = lstStr[13];
             ctr_CRF.PrescribeddoseUnits = lstStr[13];
             //ctr_CRF.TotalDoseAdministered1 = lstStr[15];
             ctr_CRF.AdministereddoseUnits = lstStr[14];
             //ctr_CRF.Day1 = lstStr[17]; 
             //ctr_CRF.DoseDelay1 = lstStr[18];         
             lstCTR_CRF_CTF.add(ctr_CRF);
            }
            
            if(!Test.isRunningTest()) {
                transId = service.createChemoTherapyRegimen(institution,site,trial,lstCTR_CRF_CTF);
            }
            nextform = 42;    
         } else if(fileNameSplit[0] == 'GrowthFactor') {
            List<GrowthFactor_CRF_CTF>  lstGF_CRF_CTF = new List<GrowthFactor_CRF_CTF>();
            for(List<String> lstStr : lstCSVData) {
                system.debug('lstStr : '+lstStr+'   lstStr.size() : '+lstStr.size());
                if(!(lstStr != null && lstStr.size() == 7)) {
                    transId = service.insertErrorLog('Failure : '+'Number of column headers should be 6. Please ensure that the file you have uploaded has sufficient number of column.');
                    ref = new Pagereference('/apex/uploadCRFForTestHarness?inst='+institution+'&site='+site+'&trial='+trial+'&nextForm='+nextform+'&transId='+transId);
                    ref.setRedirect(true);
                    return ref;
                }
             GrowthFactor_CRF_CTF gf_CRF = new GrowthFactor_CRF_CTF();
             gf_CRF.CRFId = lstStr[0];
             gf_CRF.Name = lstStr[1];
             gf_CRF.Dose = lstStr[2];
             gf_CRF.TotalDose = lstStr[3];
             gf_CRF.Route = lstStr[4];
             gf_CRF.Notes = lstStr[5];
             gf_CRF.isReceived= lstStr[6];  
             system.debug('gf_CRF.isReceived====='+gf_CRF.isReceived);        
             lstGF_CRF_CTF.add(gf_CRF);
            }
            
            if(!Test.isRunningTest()) {
                transId = service.createGrowthFactor(institution,site,trial,lstGF_CRF_CTF);
            }
            nextform = 43;    
         } else if(fileNameSplit[0] == 'ConcomitantMedication') {
            List<ConcomitantMedication_CRF_CTF>  lstCM_CRF_CTF = new List<ConcomitantMedication_CRF_CTF>();
            for(List<String> lstStr : lstCSVData) {
                system.debug('lstStr : '+lstStr+'   lstStr.size() : '+lstStr.size());
                if(!(lstStr != null && lstStr.size() == 14)) {
                    transId = service.insertErrorLog('Failure : '+'Number of column headers should be 14. Please ensure that the file you have uploaded has sufficient number of column.');
                    ref = new Pagereference('/apex/uploadCRFForTestHarness?inst='+institution+'&site='+site+'&trial='+trial+'&nextForm='+nextform+'&transId='+transId);
                    ref.setRedirect(true);
                    return ref;
                }
              ConcomitantMedication_CRF_CTF cm_CRF = new ConcomitantMedication_CRF_CTF();
             cm_CRF.CRFId = lstStr[0];
             cm_CRF.Type = lstStr[1];
             cm_CRF.OtherMadication = lstStr[2];
             cm_CRF.Medication = lstStr[3];
             cm_CRF.StartYear = lstStr[4];
             cm_CRF.StartMonth = lstStr[5];    
             cm_CRF.StartDay = lstStr[6]; 
          cm_CRF.EndYear = lstStr[7]; 
          cm_CRF.EndMonth = lstStr[8]; 
          cm_CRF.EndDay = lstStr[9]; 
          cm_CRF.DoseValue = lstStr[10]; 
          cm_CRF.Dose = lstStr[11]; 
          cm_CRF.Route = lstStr[12]; 
          cm_CRF.Frequency = lstStr[13];       
             lstCM_CRF_CTF.add(cm_CRF);
            }
            
            if(!Test.isRunningTest()) {
                transId = service.createConcomitantMedication(institution,site,trial,lstCM_CRF_CTF);
            }
            nextform = 44;   
        
    
           } 
        ref = new Pagereference('/apex/uploadCRFForTestHarness?inst='+institution+'&site='+site+'&trial='+trial+'&nextForm='+nextform+'&transId='+transId);
        ref.setRedirect(true);
        return ref;
    }
    
    public Pagereference submitDetails() {
        
        Pagereference ref = new Pagereference('/apex/uploadCRFForTestHarness?inst='+institution+'&site='+site+'&trial='+trial+'&nextForm=1');
        ref.setRedirect(true);
        return ref;
    }
    
    public void runTestHarness() {
        RandomizationSchedulerJobDetail__c rsjd = new RandomizationSchedulerJobDetail__c();
        if(testHarnessType == null || testHarnessType == '') {
            return;
        } else {
            rsjd.Test_Harness_Type__c = testHarnessType;
        }
        rsjd.IsDeleted__c = true;
        insert rsjd;
        
        TestHarnessHistory__c testHarnessHistory = new TestHarnessHistory__c();
        testHarnessHistory.TestHarnessType__c = testHarnessType;
        testHarnessHistory.Status__c = 'In Progress';
        insert testHarnessHistory;
        
        List<TestHarnessHistory__c> lstRandomizationTestHist = [select Status__c, CreatedDate, CreatedById, CreatedBy.Name, TestHarnessType__c from TestHarnessHistory__c where TestHarnessType__c = 'Randomization' order by CreatedDate DESC];
        if(!lstRandomizationTestHist.isEmpty()) {
            randomizationRunHistory = lstRandomizationTestHist[0];
        }
        
        List<TestHarnessHistory__c> lstCompleteTestHist = [select Status__c, CreatedDate, CreatedById, CreatedBy.Name, TestHarnessType__c from TestHarnessHistory__c where TestHarnessType__c = 'Complete' order by CreatedDate DESC];
        if(!lstCompleteTestHist.isEmpty()) {
            completeRunHistory = lstCompleteTestHist[0];
        }
        
    }
}