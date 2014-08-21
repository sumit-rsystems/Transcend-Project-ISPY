public without sharing class PatientSummaryReport {
	public List<PatientSummaryWrapper> lstActivePatientSummary {get;set;}
	public List<PatientSummaryWrapper> lstCompletePatientSummary {get;set;} 
	public List<PatientTreatmentPhaseWrapper> lstTreatmentPhaseSummary {get;set;}
	public List<ScreeningCrfWrapper> lstSCWrapper {get;set;}
	public ProtocolViolationWrapper protocolViolationWrapper {get;set;}
	
	public List<TreatmentCRFReportsWrapper1> lstTreatmentCRFReportsWrapper1 {get;set;}
	public List<TreatmentCRFReportsWrapper2> lstTreatmentCRFReportsWrapper2 {get;set;}
	public List<TreatmentCRFReportsWrapper3> lstTreatmentCRFReportsWrapper3 {get;set;}
	public List<TreatmentCRFReportsWrapper4> lstTreatmentCRFReportsWrapper4 {get;set;}
	
	public date dateOfReport  {get;set;}
	public String studyName {get;set;}
	
	public List<Selectoption> lstSelectedInstituteOption{get;set;}
	public List<Selectoption> lstSelectedTrialOption{get;set;}
	
	public List<Selectoption> lstInstituteOption{get;set;}
	public List<Selectoption> lstTrialOption{get;set;}
	public List<String> selectedInstitute{get;set;}
	public List<String> selectedTrial{get;set;}
	public Boolean isShowConfirmation{get;set;}
	 
	public PatientSummaryReport() {
		studyName = 'I-SPY 2';
		dateOfReport = system.today();
		
		lstActivePatientSummary = new List<PatientSummaryWrapper>();
		lstCompletePatientSummary = new List<PatientSummaryWrapper>();
		lstTreatmentPhaseSummary = new List<PatientTreatmentPhaseWrapper>();
		lstSCWrapper = new List<ScreeningCrfWrapper>();
		protocolViolationWrapper = new ProtocolViolationWrapper();
		
		lstSelectedInstituteOption = new List<Selectoption>();
		lstSelectedTrialOption = new List<Selectoption>();
		
		lstTreatmentCRFReportsWrapper1 = new List<TreatmentCRFReportsWrapper1>();
		lstTreatmentCRFReportsWrapper2 = new List<TreatmentCRFReportsWrapper2>();
		lstTreatmentCRFReportsWrapper3 = new List<TreatmentCRFReportsWrapper3>();
		lstTreatmentCRFReportsWrapper4 = new List<TreatmentCRFReportsWrapper4>();
		
		isShowConfirmation = false;
		
		/*List<Report_Request__c> lstReportReq = [select Id, Selected_Institution_Id__c, Selected_Trial_Id__c from Report_Request__c where Report_Type__c = 'Patient Summary' order by createdDate desc limit 1];
		if(!lstReportReq.isEmpty()) {
			if(lstReportReq[0].Selected_Institution_Id__c != null) {
				for(String recInstId : lstReportReq[0].Selected_Institution_Id__c.split('\\,')) {
					recInstId = recInstId.replace('[','');
					recInstId = recInstId.replace(']','');
					recInstId = recInstId.trim();
					selectedInstitute.add(recInstId);
				}
			}
			
			if(lstReportReq[0].Selected_Trial_Id__c != null) {
				for(String recTrialId : lstReportReq[0].Selected_Trial_Id__c.split('\\,')) {
					recTrialId = recTrialId.replace('[','');
					recTrialId = recTrialId.replace(']','');
					recTrialId = recTrialId.trim();
					selectedTrial.add(recTrialId);
				}
			}
		}*/
		system.debug('__selectedInstitute__'+selectedInstitute);
		system.debug('__selectedTrial__'+selectedTrial);
		
		List<Account> lstInst = [select Id, Name from Account where RecordType.Name = 'Institution'];
		lstInstituteOption = new List<Selectoption>();
		Selectoption accountOption;
		for(Account acc : lstInst) {
			accountOption = new Selectoption(acc.Id,acc.Name);
			lstInstituteOption.add(accountOption);
		}
		List<Trial__c> lstTrial = [select Id, Name from Trial__c];
		lstTrialOption = new List<Selectoption>();
		Selectoption trialOption;
		for(Trial__c trial : lstTrial) {
			trialOption = new Selectoption(trial.Id,trial.Name);
			lstTrialOption.add(trialOption);
		}
	}
	
	public void reportRequestAction() {
		
		system.debug('lstSelectedInstituteOption : '+lstSelectedInstituteOption);
		
		system.debug('__selectedInstitute__'+selectedInstitute);
		system.debug('__selectedTrial__'+selectedTrial);
	
	//======make institution name string comma seperated	
	
		selectedInstitute = new List<String>();
		selectedTrial = new List<String>();
		
		String SelectedInstName = '';
		String SelectedInstIds = '';
		for(Selectoption inst : lstSelectedInstituteOption) {
			SelectedInstName+= inst.getLabel()+', ';
			SelectedInstIds+= inst.getValue()+', ';
			selectedInstitute.add(inst.getValue());
		}
		if(SelectedInstName != '') {
			SelectedInstName = SelectedInstName.substring(0, SelectedInstName.length()-2);
			SelectedInstIds = SelectedInstIds.substring(0, SelectedInstIds.length()-2);
		}
		
	//======make trial name string comma seperated	
		String SelectedTrialName = '';
		String SelectedTrialIds = '';
		for(Selectoption trials : lstSelectedTrialOption) {
			SelectedTrialName+= trials.getLabel()+', ';
			SelectedTrialIds+= trials.getValue()+', ';
			selectedTrial.add(trials.getValue());
		}
		if(SelectedTrialName != '') {
			SelectedTrialName = SelectedTrialName.substring(0, SelectedTrialName.length()-2);
			SelectedTrialIds = SelectedTrialIds.substring(0, SelectedTrialIds.length()-2);
		}
		system.debug('__SelectedInstName__'+SelectedInstName);
		system.debug('__SelectedTrialName__'+SelectedTrialName);
		
		system.debug('__SelectedTrialIds__'+SelectedTrialIds);
		system.debug('__SelectedInstIds__'+SelectedInstIds);
		
		Report_Request__c reportReq = new Report_Request__c();
		reportReq.Selected_Institution_Id__c = SelectedInstIds; //Institute Id
		reportReq.Selected_Trial_Id__c = SelectedTrialIds;	//Trial Id
		reportReq.Selected_Institution_Name__c = SelectedInstName;	//Institute Name
		reportReq.Selected_Trial_Name__c = SelectedTrialName;	//Trial Name
		reportReq.Report_Type__c = 'Patient Summary';
		reportReq.Status__c = 'In Progress';
		reportReq.AsOfDate__c = dateOfReport;
		insert reportReq;
		
		if(!Test.isRunningTest()) {
			String emailBody = '<br />Report request has submitted successfully.<br />' + 
								'When your report is ready for download, an email will be sent to you.<br />' +
								'Thanks, <br />Salesforce.com';
			
			PatientSummaryReport.sendReportRequestEmailNotification(reportReq.Id, emailBody);
			storePatientSummaryReport(reportReq.Id, selectedTrial, selectedInstitute);
		}
		
		isShowConfirmation = true;
	}
	
	public void storePatientSummaryReport(String repReqid, List<String> lstTrial, List<String> lstInst) {
		
		prepareActivePatientReport(repReqid, lstTrial, lstInst);
		prepareCompletePatientReport(repReqid, lstTrial, lstInst);
		prepareInTreatmenReport(repReqid, lstTrial, lstInst);
		prepareScreeningCrfReport(repReqid, lstTrial, lstInst);
		prepareProtocolViolation(repReqid, lstTrial, lstInst);
		prepareTreatmentPhaseTable1(repReqid, lstTrial, lstInst);
		prepareTreatmentPhaseTable2(repReqid, lstTrial, lstInst);
		prepareTreatmentPhaseTable3(repReqid, lstTrial, lstInst);
		prepareTreatmentPhaseTable4(repReqid, lstTrial, lstInst);
	}
	
	public void generatePatientSummaryReport() {
		
		String repReqId = Apexpages.currentPage().getParameters().get('repReqId');
		
		generateActivePatientReport(repReqId);
		generateCompletePatientReport(repReqId);
		generateTreatmentPhaseReport(repReqId);
		generateScreeningCRFReport(repReqId);
		generateProtcolVioloatonReport(repReqId);
		generateTreatmentPhaseTable1(repReqId);
		generateTreatmentPhaseTable2(repReqId);
		generateTreatmentPhaseTable3(repReqId);
		generateTreatmentPhaseTable4(repReqId);
		
		/*Pagereference refHtml = new Pagereference('/apex/PatientSummaryReport_HTML');
		Pagereference refPDF = new Pagereference('/apex/PatientSummaryReport_PDF');
		Pagereference refCSV = new Pagereference('/apex/PatientSummaryReport_CSV');
		Blob htmlContent = refHTML.getContent();
		Attachment att = new Attachment();
		att.Body = htmlContent;
		att.Name = 'PSR_Test_1';
		insert att;*/
	}
	
	public void generateActivePatientReport(String repReqId) {
		List<Patient_Active_Screening_Report__c> lstActivePatientReport = [Select p.Zip__c, p.Trial_Site_Name__c, p.Reg_Date__c, p.Race__c, p.OSP_Status__c, p.OSE_Status__c, p.Name, p.Menopausal_Status__c, p.MRI_Volume_Status__c, p.ISPY2ID__c, p.Gender__c, p.Ethnicity__c, p.Consent_Date__c from Patient_Active_Screening_Report__c p where Report_Request__c = :repReqId];
		for(Patient_Active_Screening_Report__c asr : lstActivePatientReport) {
			PatientSummaryWrapper patientSummary = new PatientSummaryWrapper();
			patientSummary.ISPY2ID = asr.ISPY2ID__c;
			patientSummary.trialSiteName = asr.Trial_Site_Name__c;
			patientSummary.consentDate = asr.Consent_Date__c;
			patientSummary.regDate = asr.Reg_Date__c;
			patientSummary.gender = asr.Gender__c;
			patientSummary.race = asr.Race__c;
			patientSummary.ethnicity = asr.Ethnicity__c;
			patientSummary.menopausalStatus = asr.Menopausal_Status__c;
			patientSummary.mriVolumeStatus = asr.MRI_Volume_Status__c;
			patientSummary.oseStatus = asr.OSE_Status__c;
			patientSummary.ospStatus= asr.OSP_Status__c;
			patientSummary.zip = asr.Zip__c;
			lstActivePatientSummary.add(patientSummary);
		}
	}
	
	public void generateCompletePatientReport(String repReqId) {
		List<Patient_Completed_Screening_Report__c> lstCompletePatReport = [Select p.Zip__c, p.Trial_Site_Name__c, p.Reg_Date__c, p.Race__c, p.OSP_Status__c, p.OSE_Status__c, p.Name, p.Menopausal_Status__c, p.MRI_Volume_Status__c, p.Is_Consent_Signed__c, p.ISPY2ID__c, p.Gender__c, p.Ethnicity__c, p.Consent_Date__c From Patient_Completed_Screening_Report__c p where Report_Request__c = :repReqId];
		for(Patient_Completed_Screening_Report__c asr : lstCompletePatReport) {
			PatientSummaryWrapper patientSummary = new PatientSummaryWrapper();
			patientSummary.ISPY2ID = asr.ISPY2ID__c;
			patientSummary.trialSiteName = asr.Trial_Site_Name__c;
			patientSummary.consentDate = asr.Consent_Date__c;
			patientSummary.regDate = asr.Reg_Date__c;
			patientSummary.gender = asr.Gender__c;
			patientSummary.race = asr.Race__c;
			patientSummary.ethnicity = asr.Ethnicity__c;
			patientSummary.menopausalStatus = asr.Menopausal_Status__c;
			patientSummary.mriVolumeStatus = asr.MRI_Volume_Status__c;
			patientSummary.oseStatus = asr.OSE_Status__c;
			patientSummary.ospStatus= asr.OSP_Status__c;
			patientSummary.zip = asr.Zip__c;
			patientSummary.isConsentSigned = asr.Is_Consent_Signed__c?'Yes':'No';
			
			lstCompletePatientSummary.add(patientSummary);
		}
	}
	
	public void generateScreeningCRFReport(String repReqId) {
		List<Screening_Phase_CRF_Report__c> lstScreenCRFReport = [Select s.TrialSite__c, s.Tissue_Pre_Tx_Submitted__c, s.Response_Eval_Submitted__c, s.Response_Eval_Approved__c, s.Report_Request__c, s.Name, s.Mamma_Print_Submitted__c, s.Blood_Pre_Tx_Submitted__c, s.Baseline_symptom_submitted__c, s.Baseline_symptom_Approved__c From Screening_Phase_CRF_Report__c s where Report_Request__c = :repReqId];
		for(Screening_Phase_CRF_Report__c screenCRFReport : lstScreenCRFReport) {
			ScreeningCrfWrapper screenCRFWrapper = new ScreeningCrfWrapper();
			screenCRFWrapper.trialSiteName = screenCRFReport.TrialSite__c;
			if(screenCRFReport.Baseline_symptom_Approved__c != null)
				screenCRFWrapper.baselineApproved = Integer.valueOf(screenCRFReport.Baseline_symptom_Approved__c);
			if(screenCRFReport.Baseline_symptom_submitted__c != null)
				screenCRFWrapper.baselineSubmitted = Integer.valueOf(screenCRFReport.Baseline_symptom_submitted__c);
			if(screenCRFReport.Blood_Pre_Tx_Submitted__c != null)
				screenCRFWrapper.bloodPreTxSubmitted = Integer.valueOf(screenCRFReport.Blood_Pre_Tx_Submitted__c);
			if(screenCRFReport.Mamma_Print_Submitted__c != null)
				screenCRFWrapper.mammaPrintSubmitted = Integer.valueOf(screenCRFReport.Mamma_Print_Submitted__c);
			if(screenCRFReport.Response_Eval_Approved__c != null)
				screenCRFWrapper.responseEvalApproved = Integer.valueOf(screenCRFReport.Response_Eval_Approved__c);
			if(screenCRFReport.Response_Eval_Submitted__c != null)
				screenCRFWrapper.responseEvalSubmitted = Integer.valueOf(screenCRFReport.Response_Eval_Submitted__c);
			if(screenCRFReport.Tissue_Pre_Tx_Submitted__c != null)
				screenCRFWrapper.tissuePreTxSubmitted = Integer.valueOf(screenCRFReport.Tissue_Pre_Tx_Submitted__c);
			lstSCWrapper.add(screenCRFWrapper);
		}	
	}
	
	public void generateTreatmentPhaseReport(String repReqId) {
		List<Patient_Treatment_Phase_Report__c> lstTreatmentPhaseReport = [Select p.TreatmentConsentDate__c, p.ISPY2ID__c, p.Trial_Site_Name__c, p.Surgery_Date__c, p.Report_Request__c, p.Off_Study_Reason__c, p.OffStudy__c, p.Most_Recent_Followup__c, p.Lost_To_Followup__c, p.Last_Paclit_Treatment_Date__c, p.Last_Paclit_Treatment_Cycle__c, p.Last_AC_Treatment_Date__c, p.Last_AC_Treatment_Cycle__c, p.First_Paclit_Treatment_Date__c, p.First_AC_Treatment_Date__c From Patient_Treatment_Phase_Report__c p where Report_Request__c = :repReqId];
		for(Patient_Treatment_Phase_Report__c tpr : lstTreatmentPhaseReport) {
			PatientTreatmentPhaseWrapper treatmentPhaseWrapper = new PatientTreatmentPhaseWrapper();
			treatmentPhaseWrapper.ISPY2ID = tpr.ISPY2ID__c;
			treatmentPhaseWrapper.trialSiteName = tpr.Trial_Site_Name__c;
			treatmentPhaseWrapper.treatmentConsentDate = tpr.TreatmentConsentDate__c;
			treatmentPhaseWrapper.firstPaclitTreatmentDate = tpr.First_Paclit_Treatment_Date__c;
			treatmentPhaseWrapper.lastPaclitTreatmentDate = tpr.Last_Paclit_Treatment_Date__c;
			treatmentPhaseWrapper.lastPaclitTreatmentCycle = tpr.Last_Paclit_Treatment_Cycle__c;
			treatmentPhaseWrapper.firstACTreatmentDate = tpr.First_AC_Treatment_Date__c;
			treatmentPhaseWrapper.lastACTreatmentDate = tpr.Last_AC_Treatment_Date__c;
			treatmentPhaseWrapper.lastACTreatmentCycle = tpr.Last_AC_Treatment_Cycle__c;
			treatmentPhaseWrapper.surgeryDate = tpr.Surgery_Date__c;
			treatmentPhaseWrapper.mostRecentFollowup = tpr.Most_Recent_Followup__c;
			treatmentPhaseWrapper.lostToFollowup = tpr.Lost_To_Followup__c;
			treatmentPhaseWrapper.offStudyDate = tpr.OffStudy__c;
			treatmentPhaseWrapper.offStudyReason = tpr.Off_Study_Reason__c;
			lstTreatmentPhaseSummary.add(treatmentPhaseWrapper);
		}
	}
	
	public void generateProtcolVioloatonReport(String repReqId) {
		List<Protocol_Violation_Report__c> lstProtocolViolationReport = [Select p.Visit_Non_Compliance__c, p.Total__c, p.Screening_Procedure_Required__c, p.Screening_On_Study__c, p.Patient_Became_Pregnant__c, p.Other__c, p.On_Study_Procedure__c, p.Name, p.Medication_Non_Compliance__c, p.Incorrect_Therapy_Given__c, p.Id, p.Enrollment_Ineligible_Patient__c, p.Eligiblity_Critertia__c, (Select Counter__c, Protocol_Violation_Report__c, Protocol_Name__c From Other_Protocol_Report__r) From Protocol_Violation_Report__c p where Report_Request__c = :repReqId];
		//protocolViolationWrapper = new ProtocolViolationWrapper();
		if(!lstProtocolViolationReport.isEmpty()) {
			Protocol_Violation_Report__c protocolVioReport = lstProtocolViolationReport[0];
			if(protocolVioReport.Medication_Non_Compliance__c != null)
				protocolViolationWrapper.medicationNonCompliance = Integer.valueOf(protocolVioReport.Medication_Non_Compliance__c);
			if(protocolVioReport.Visit_Non_Compliance__c != null)
				protocolViolationWrapper.visitNonCompliance = Integer.valueOf(protocolVioReport.Visit_Non_Compliance__c);
			if(protocolVioReport.On_Study_Procedure__c != null)
				protocolViolationWrapper.onStudyProcedure = Integer.valueOf(protocolVioReport.On_Study_Procedure__c);
			if(protocolVioReport.Incorrect_Therapy_Given__c != null)
				protocolViolationWrapper.incorrectTherapyGiven = Integer.valueOf(protocolVioReport.Incorrect_Therapy_Given__c);
			if(protocolVioReport.Screening_On_Study__c != null)
				protocolViolationWrapper.screeningOnStudy = Integer.valueOf(protocolVioReport.Screening_On_Study__c);
			if(protocolVioReport.Screening_On_Study__c != null)
				protocolViolationWrapper.screeningProcedureRequired = Integer.valueOf(protocolVioReport.Screening_On_Study__c);
			if(protocolVioReport.Eligiblity_Critertia__c != null)
				protocolViolationWrapper.eligiblityCritertia = Integer.valueOf(protocolVioReport.Eligiblity_Critertia__c);
			if(protocolVioReport.Enrollment_Ineligible_Patient__c != null)
				protocolViolationWrapper.enrollmentIneligiblePatient = Integer.valueOf(protocolVioReport.Enrollment_Ineligible_Patient__c);
			if(protocolVioReport.Patient_Became_Pregnant__c != null)
				protocolViolationWrapper.patientBecamePregnant = Integer.valueOf(protocolVioReport.Patient_Became_Pregnant__c);
			if(protocolVioReport.Other__c != null)
				protocolViolationWrapper.other = Integer.valueOf(protocolVioReport.Other__c);
			if(protocolVioReport.Total__c != null)
				protocolViolationWrapper.total = Integer.valueOf(protocolVioReport.Total__c);
			List<Other_Protocol_Report__c> lstOPR = protocolVioReport.Other_Protocol_Report__r;
			List<OtherProtoViolationWrapper> lstOPWrapper = new List<OtherProtoViolationWrapper>();
			integer counter = 1;
			for(Other_Protocol_Report__c opr : lstOPR) {
				OtherProtoViolationWrapper opWrapper = new OtherProtoViolationWrapper();
				opWrapper.otherViolation = opr.Protocol_Name__c;
				opWrapper.numberOfOtherViolation = Integer.valueOf(opr.Counter__c);
				if(Math.mod(counter, 2) == 0) {
					opWrapper.rowColor = '#DBE4F0';
				} else {
					opWrapper.rowColor = '#FFFFFF';
				}
				lstOPWrapper.add(opWrapper);
			}
			
			protocolViolationWrapper.lstOtherProtoViolation = lstOPWrapper;
			
		}
		
	}
	
	public void generateTreatmentPhaseTable1(String repReqId) {
		List<Treatment_CRF_Report_Table_1__c> lstTreatmentPhaseTable1 = [Select t.Trial_Site_Name__c, t.Post_Surgery_Submitted__c, t.Post_Surgery_Approved__c, t.Name, t.Mri_Volume_Pre_Surgery_Submitted__c, t.Mri_Volume_Pre_Surgery_Approved__c, t.Mri_Volume_Inter_Submitted__c, t.Mri_Volume_Inter_Approved__c, t.Mri_Volume_Early_Submitted__c, t.Mri_Volume_Early_Approved__c, t.Id, t.Chemo_Treatment_Submitted__c, t.Chemo_Treatment_Approved__c, t.AE_Submitted__c, t.AE_Approved__c From Treatment_CRF_Report_Table_1__c t where Report_Request__c = :repReqId];
		for(Treatment_CRF_Report_Table_1__c table1 : lstTreatmentPhaseTable1) {
			TreatmentCRFReportsWrapper1 treatmentCRFReportWrapper = new TreatmentCRFReportsWrapper1();
			treatmentCRFReportWrapper.trialSiteName = table1.Trial_Site_Name__c;
			if(table1.Chemo_Treatment_Submitted__c != null) treatmentCRFReportWrapper.chemoTreatmentSubmitted = Integer.valueOf(table1.Chemo_Treatment_Submitted__c);
			if(table1.Chemo_Treatment_Approved__c != null) treatmentCRFReportWrapper.chemoTreatmentApproved = Integer.valueOf(table1.Chemo_Treatment_Approved__c);
			if(table1.Mri_Volume_Early_Submitted__c != null) treatmentCRFReportWrapper.mriVolumeEarlySubmitted = Integer.valueOf(table1.Mri_Volume_Early_Submitted__c);
			if(table1.Mri_Volume_Early_Approved__c != null) treatmentCRFReportWrapper.mriVolumeEarlyApproved = Integer.valueOf(table1.Mri_Volume_Early_Approved__c);
			if(table1.Mri_Volume_Inter_Submitted__c != null) treatmentCRFReportWrapper.mriVolumeInterSubmitted = Integer.valueOf(table1.Mri_Volume_Inter_Submitted__c);
			if(table1.Mri_Volume_Inter_Approved__c != null) treatmentCRFReportWrapper.mriVolumeInterApproved = Integer.valueOf(table1.Mri_Volume_Inter_Approved__c);
			if(table1.Mri_Volume_Pre_Surgery_Submitted__c != null) treatmentCRFReportWrapper.mriVolumePreSurgerySubmitted = Integer.valueOf(table1.Mri_Volume_Pre_Surgery_Submitted__c);
			if(table1.Mri_Volume_Pre_Surgery_Approved__c != null) treatmentCRFReportWrapper.mriVolumePreSurgeryApproved = Integer.valueOf(table1.Mri_Volume_Pre_Surgery_Approved__c);
			if(table1.AE_Submitted__c != null) treatmentCRFReportWrapper.aeSubmitted = Integer.valueOf(table1.AE_Submitted__c);
			if(table1.AE_Approved__c != null) treatmentCRFReportWrapper.aeApproved = Integer.valueOf(table1.AE_Approved__c);
			if(table1.Post_Surgery_Approved__c != null) treatmentCRFReportWrapper.postSurgeryApproved = Integer.valueOf(table1.Post_Surgery_Approved__c);
			if(table1.Post_Surgery_Submitted__c != null) treatmentCRFReportWrapper.postSurgerySubmitted = Integer.valueOf(table1.Post_Surgery_Submitted__c);
			lstTreatmentCRFReportsWrapper1.add(treatmentCRFReportWrapper);
		}
	}
	
	public void generateTreatmentPhaseTable2(String repReqId) {
		List<Treatment_CRF_Report_Table_2__c> lstTreatmentPhaseTable1 = [Select t.Trial_Site_Name__c, t.Response_Eval_Pre_Surg_Submitted__c, t.Response_Eval_Pre_Surg_Approved__c, t.Response_Eval_Inter_Reg_Submitted__c, t.Response_Eval_Inter_Reg_Approved__c, t.No_Longer_Lost_F_U_Submitted__c, t.No_Longer_Lost_F_U_Approved__c, t.Name, t.Lost_To_Follow_Up_Submitted__c, t.Lost_To_Follow_Up_Approved__c, t.Id, t.Follow_Up_Submitted__c, t.Follow_Up_Approved__c, t.Chemo_Summary_Submitted__c, t.Chemo_Summary_Approved__c From Treatment_CRF_Report_Table_2__c t where Report_Request__c = :repReqId];
		for(Treatment_CRF_Report_Table_2__c table1 : lstTreatmentPhaseTable1) {
			TreatmentCRFReportsWrapper2 treatmentCRFReportWrapper = new TreatmentCRFReportsWrapper2();
			treatmentCRFReportWrapper.trialSiteName = table1.Trial_Site_Name__c;
			if(table1.Chemo_Summary_Submitted__c != null) treatmentCRFReportWrapper.chemoSummarySubmitted = Integer.valueOf(table1.Chemo_Summary_Submitted__c);
			if(table1.Chemo_Summary_Approved__c != null) treatmentCRFReportWrapper.chemoSummaryApproved = Integer.valueOf(table1.Chemo_Summary_Approved__c);
			if(table1.Response_Eval_Inter_Reg_Submitted__c != null) treatmentCRFReportWrapper.responseEvalInterRegSubmitted = Integer.valueOf(table1.Response_Eval_Inter_Reg_Submitted__c);
			if(table1.Response_Eval_Inter_Reg_Approved__c != null) treatmentCRFReportWrapper.responseEvalInterRegApproved = Integer.valueOf(table1.Response_Eval_Inter_Reg_Approved__c);
			if(table1.Response_Eval_Pre_Surg_Submitted__c != null) treatmentCRFReportWrapper.responseEvalPreSurgSubmitted = Integer.valueOf(table1.Response_Eval_Pre_Surg_Submitted__c);
			if(table1.Response_Eval_Pre_Surg_Approved__c != null) treatmentCRFReportWrapper.responseEvalPreSurgApproved = Integer.valueOf(table1.Response_Eval_Pre_Surg_Approved__c);
			if(table1.Follow_Up_Submitted__c != null) treatmentCRFReportWrapper.followUpSubmitted = Integer.valueOf(table1.Follow_Up_Submitted__c);
			if(table1.Follow_Up_Approved__c != null) treatmentCRFReportWrapper.followUpApproved = Integer.valueOf(table1.Follow_Up_Approved__c);
			if(table1.Lost_To_Follow_Up_Submitted__c != null) treatmentCRFReportWrapper.losttoFollowUpSubmitted = Integer.valueOf(table1.Lost_To_Follow_Up_Submitted__c);
			if(table1.Lost_To_Follow_Up_Approved__c != null) treatmentCRFReportWrapper.losttoFollowUpApproved = Integer.valueOf(table1.Lost_To_Follow_Up_Approved__c);
			if(table1.No_Longer_Lost_F_U_Approved__c != null) treatmentCRFReportWrapper.noLongerLostFUApproved = Integer.valueOf(table1.No_Longer_Lost_F_U_Approved__c);
			if(table1.No_Longer_Lost_F_U_Submitted__c != null) treatmentCRFReportWrapper.noLongerLostFUSubmitted = Integer.valueOf(table1.No_Longer_Lost_F_U_Submitted__c);
			lstTreatmentCRFReportsWrapper2.add(treatmentCRFReportWrapper);
		}
	}
	
	public void generateTreatmentPhaseTable3(String repReqId) {
		List<Treatment_CRF_Report_Table_3__c> lstTreatmentPhaseTable1 = [Select t.Trial_Site_Name__c, t.Tissue_Surgery_Submitted__c, t.Tissue_Inter_Reg_Submitted__c, t.Tissue_Early_Tx_Submitted__c, t.Protocol_Violation_Submitted__c, t.Protocol_Violation_Approved__c, t.Off_study_Submitted__c, t.Off_study_Approved__c From Treatment_CRF_Report_Table_3__c t where Report_Request__c = :repReqId];
		for(Treatment_CRF_Report_Table_3__c table1 : lstTreatmentPhaseTable1) {
			TreatmentCRFReportsWrapper3 treatmentCRFReportWrapper = new TreatmentCRFReportsWrapper3();
			treatmentCRFReportWrapper.trialSiteName = table1.Trial_Site_Name__c;
			if(table1.Off_study_Approved__c != null) treatmentCRFReportWrapper.offStudyApproved = Integer.valueOf(table1.Off_study_Approved__c);
			if(table1.Off_study_Submitted__c != null) treatmentCRFReportWrapper.offStudySubmitted = Integer.valueOf(table1.Off_study_Submitted__c);
			if(table1.Tissue_Early_Tx_Submitted__c != null) treatmentCRFReportWrapper.tissueEarlyTxSubmitted = Integer.valueOf(table1.Tissue_Early_Tx_Submitted__c);
			if(table1.Tissue_Inter_Reg_Submitted__c != null) treatmentCRFReportWrapper.tissueInterRegSubmitted = Integer.valueOf(table1.Tissue_Inter_Reg_Submitted__c);
			if(table1.Tissue_Surgery_Submitted__c != null) treatmentCRFReportWrapper.tissueSurgerySubmitted = Integer.valueOf(table1.Tissue_Surgery_Submitted__c);
			if(table1.Protocol_Violation_Approved__c != null) treatmentCRFReportWrapper.protocolViolationApproved = Integer.valueOf(table1.Protocol_Violation_Approved__c);
			if(table1.Protocol_Violation_Submitted__c != null) treatmentCRFReportWrapper.protocolViolationSubmitted = Integer.valueOf(table1.Protocol_Violation_Submitted__c);
			lstTreatmentCRFReportsWrapper3.add(treatmentCRFReportWrapper);
		}
	}
	
	public void generateTreatmentPhaseTable4(String repReqId) {
		List<Treatment_CRF_Report_Table_4__c> lstTreatmentPhaseTable1 = [Select t.Trial_Site_Name__c, t.Blood_Pre_Surg_Submitted__c, t.Blood_Inter_Reg_Submitted__c, t.Blood_Early_Tx_Submitted__c From Treatment_CRF_Report_Table_4__c t where Report_Request__c = :repReqId];
		for(Treatment_CRF_Report_Table_4__c table1 : lstTreatmentPhaseTable1) {
			TreatmentCRFReportsWrapper4 treatmentCRFReportWrapper = new TreatmentCRFReportsWrapper4();
			treatmentCRFReportWrapper.trialSiteName = table1.Trial_Site_Name__c;
			if(table1.Blood_Early_Tx_Submitted__c != null) treatmentCRFReportWrapper.bloodEarlyTxSubmitted = Integer.valueOf(table1.Blood_Early_Tx_Submitted__c);
			if(table1.Blood_Inter_Reg_Submitted__c != null) treatmentCRFReportWrapper.bloodInterTxSubmitted = Integer.valueOf(table1.Blood_Inter_Reg_Submitted__c);
			if(table1.Blood_Pre_Surg_Submitted__c != null) treatmentCRFReportWrapper.bloodSurgerySubmitted = Integer.valueOf(table1.Blood_Pre_Surg_Submitted__c);
			lstTreatmentCRFReportsWrapper4.add(treatmentCRFReportWrapper);
		}
	}
	
	public static List<Registration__c> getValidRegistrations(List<String> lstTrial, List<String> lstInst) {
		List<Registration__c> lstActiveRegistration = [Select r.Site__r.Short_Name__c,r.Site__r.Name, r.Site__c, r.Screening_Informed_Consent_Date__c, 
													r.Registration_Date__c, r.Patient__r.Race__c, r.ISPY2_Subject_Id__c, r.Patient__r.Gender__c, 
													r.Patient__r.Zip__c, r.Patient__r.Ethnicity__c, r.TrialPatient__c,  r.Trial__c, r.Institution__c,  
													Effective_Time__c, CreatedDate From Registration__c r  where Status__c != 'Not Completed' and 
													Trial__c IN :lstTrial and Institution__c IN :lstInst and ISPY2_Subject_Id__c != null 
													order by Effective_Time__c];
		Set<Id> pIds = new Set<Id>();  
		List<Registration__c> regList = new List<Registration__c>();
		for(Registration__c reg : lstActiveRegistration) {
			//if(reg.CreatedDate != reg.Effective_Time__c) continue;
			if(pIds.contains(reg.Patient__c)) continue;
			regList.add(reg);
			pIds.add(reg.Patient__c);
		}
		return regList;
	}
	
	/*INFO : Preparing active phase patient summary report by patient (when patient is not randomized.)*/
	@future 
	public static void prepareActivePatientReport(String id, List<String> lstTrial, List<String> lstInst) {
		
		system.debug('--Active Patient Report---');
		system.debug('Id : ' + id);
		system.debug('lstTrial : ' + lstTrial);
		system.debug('lstInst : ' + lstInst);
		List<Registration__c> lstActiveRegistration = getValidRegistrations(lstTrial, lstInst);
		Set<Id> regIds = new Set<Id>();
		Map<Id, Registration__c> mapRegTrialPatient = new Map<Id, Registration__c>();		
		for(Registration__c reg : lstActiveRegistration) {
			//if(reg.CreatedDate != reg.Effective_Time__c) continue;
			if(reg.TrialPatient__c != null) {
				regIds.add(reg.TrialPatient__c);
				mapRegTrialPatient.put(reg.TrialPatient__c, reg);
			}
		}
		List<Patient_Active_Screening_Report__c> lstActPatRep = new List<Patient_Active_Screening_Report__c>();
		//query for Registration PatientActiveScreeningPhaseReport
		
		//query for crf	PatientActiveScreeningPhaseReport	
		List<TrialPatient__c> lstActiveTp = [Select t.Id, t.Site__r.IsTestSite__c, (Select Randomization_Result__c, Effective_Time__c, Status__c, CreatedDate From Randomization_Forms__r order by Effective_Time__c DESC limit 1), 
										(Select Status__c, Effective_Time__c, CreatedDate From On_Study_Pathology_Forms__r order by Effective_Time__c DESC limit 1), (Select Status__c, Effective_Time__c, CreatedDate From On_Study_Eligibility_Forms__r order by Effective_Time__c DESC limit 1), 
										(Select Status__c, Effective_Time__c, CreatedDate From Menopausal_Status_Details__r order by Effective_Time__c DESC limit 1), (Select Time_Point__c, Status__c, Effective_Time__c, CreatedDate From MRI_Volumes__r 
										 where Time_Point__c = 'Pre-Treatment' order by Effective_Time__c DESC limit 1) From TrialPatient__c t where Id IN :regIds and Trial_Id__c IN :lstTrial and Site__r.Institute__c IN :lstInst and Site__r.IsTestSite__c = false and Subject_Id__c != null];
		
		Registration__c activeReg = null;								
		//for(Registration__c activeReg : lstActiveRegistration) {
			//if(activeReg.CreatedDate != activeReg.Effective_Time__c) continue;
			for(TrialPatient__c activeTp : lstActiveTp) {
				//system.debug(activeReg.TrialPatient__c +' = '+ activeTp.Id+'        '+(activeReg.TrialPatient__c != activeTp.Id));
				//if(activeReg.TrialPatient__c != activeTp.Id) continue;
				if(mapRegTrialPatient.containsKey(activeTp.Id)) {
					activeReg = mapRegTrialPatient.get(activeTp.Id);
				} else {
					continue;
				}
				
				/* INFO: Checking that patient has randomized or not. */
				List<Randomization_Form__c> lstRandomization = activeTp.Randomization_Forms__r;
				if(activeTp.Randomization_Forms__r != null && !activeTp.Randomization_Forms__r.IsEmpty()) {
					if(activeTp.Randomization_Forms__r[0].Status__c != 'Not Completed') {
						continue;
					}
				}
				
				Patient_Active_Screening_Report__c actPatRep = new Patient_Active_Screening_Report__c();
				actPatRep.ISPY2ID__c = activeReg.ISPY2_Subject_Id__c;
				actPatRep.Trial_Site_Name__c = activeReg.Site__r.Short_Name__c;
				actPatRep.Consent_Date__c = activeReg.Screening_Informed_Consent_Date__c;
				actPatRep.Reg_Date__c = activeReg.Registration_Date__c;
				actPatRep.Gender__c = activeReg.Patient__r.Gender__c;
				actPatRep.Race__c = activeReg.Patient__r.Race__c;
				actPatRep.Ethnicity__c = activeReg.Patient__r.Ethnicity__c;
				actPatRep.Zip__c = activeReg.Patient__r.Zip__c;
				
				List<Menopausal_Status_Detail__c> lstMenoStatus = activeTp.Menopausal_Status_Details__r;
				if(lstMenoStatus != null && lstMenoStatus.size() > 0) {
					//if(lstMenoStatus[0].Status__c != 'Not Completed' && lstMenoStatus[0].Status__c != 'Completed') {
					//	patientSummary.menopausalStatus = lstMenoStatus[0].Status__c;
					//}
					if(lstMenoStatus[0].Status__c == 'Not Completed') actPatRep.Menopausal_Status__c = '';
					else if(lstMenoStatus[0].Status__c == 'Approval Pending') actPatRep.Menopausal_Status__c = 'Pending';
					else if(lstMenoStatus[0].Status__c == 'Rejected') actPatRep.Menopausal_Status__c = 'Rejected';
					else if(lstMenoStatus[0].Status__c == 'Accepted') actPatRep.Menopausal_Status__c = 'Approved';
				}
				
				List<MRI_Volume__c> lstMRIVolume = activeTp.MRI_Volumes__r;
				if(lstMRIVolume != null && lstMRIVolume.size() > 0) {
					//if(lstMRIVolume[0].Status__c != 'Not Completed' && lstMRIVolume[0].Status__c != 'Completed') {
					//	patientSummary.mriVolumeStatus = lstMRIVolume[0].Status__c;
					//}
					if(lstMRIVolume[0].Status__c == 'Not Completed') actPatRep.MRI_Volume_Status__c = '';
					else if(lstMRIVolume[0].Status__c == 'Approval Pending') actPatRep.MRI_Volume_Status__c = 'Pending';
					else if(lstMRIVolume[0].Status__c == 'Rejected') actPatRep.MRI_Volume_Status__c = 'Rejected';
					else if(lstMRIVolume[0].Status__c == 'Accepted') actPatRep.MRI_Volume_Status__c = 'Approved';
				}
				
				List<On_Study_Eligibility_Form__c> lstOSE = activeTp.On_Study_Eligibility_Forms__r;
				if(lstOSE != null && lstOSE.size() > 0) {
					//if(lstOSE[0].Status__c != 'Not Completed' && lstOSE[0].Status__c != 'Completed') {
					//	patientSummary.oseStatus = lstOSE[0].Status__c;
  					//}
  					if(lstOSE[0].Status__c == 'Not Completed') actPatRep.OSE_Status__c = '';
					else if(lstOSE[0].Status__c == 'Approval Pending') actPatRep.OSE_Status__c = 'Pending';
					else if(lstOSE[0].Status__c == 'Rejected') actPatRep.OSE_Status__c = 'Rejected';
					else if(lstOSE[0].Status__c == 'Accepted') actPatRep.OSE_Status__c = 'Approved';
				}  
				
				List<On_Study_Pathology_Form__c> lstOSP = activeTp.On_Study_Pathology_Forms__r;
				if(lstOSP != null && lstOSP.size() > 0) {
					/*if(lstOSP[0].Status__c != 'Not Completed' && lstOSP[0].Status__c != 'Completed') {
						patientSummary.ospStatus = lstOSP[0].Status__c;
					}*/
					if(lstOSP[0].Status__c == 'Not Completed') actPatRep.OSP_Status__c = '';
					else if(lstOSP[0].Status__c == 'Approval Pending') actPatRep.OSP_Status__c = 'Pending';
					else if(lstOSP[0].Status__c == 'Rejected') actPatRep.OSP_Status__c = 'Rejected';
					else if(lstOSP[0].Status__c == 'Accepted') actPatRep.OSP_Status__c = 'Approved';
				}
				actPatRep.Report_Request__c = id;
				lstActPatRep.add(actPatRep);
			}
		//}
		
		insert lstActPatRep;
		
		Report_Request_Child__c rrc = new Report_Request_Child__c();
		rrc.Report_Request__c = id;
		insert rrc;
		
	}
	/**************************************Preparing Complete phase patient summary report **********/
	@future 
	public static void prepareCompletePatientReport(String id, List<String> lstTrial, List<String> lstInst) {
		
		system.debug('--Complete Patient Report---');
		system.debug('Id : ' + id);
		system.debug('lstTrial : ' + lstTrial);
		system.debug('lstInst : ' + lstInst);
		
		Map<Id, Registration__c> mapRegTrialPatient = new Map<Id, Registration__c>();		
		List<Registration__c> lstCompleteRegistration = getValidRegistrations(lstTrial, lstInst);
		Set<Id> regIds = new Set<Id>();
		for(Registration__c reg : lstCompleteRegistration) {
			if(reg.TrialPatient__c != null) {
				regIds.add(reg.TrialPatient__c);
				mapRegTrialPatient.put(reg.TrialPatient__c, reg);
			}
		}
		
		
		
		List<Patient_Completed_Screening_Report__c> lstCompScreenRep = new List<Patient_Completed_Screening_Report__c>();
		//query for Registration PatientCompleteScreeningPhaseReport
		/*List<Registration__c> lstCompleteRegistration = [Select r.Site__r.Short_Name__c,r.Site__r.Name, r.Site__c, r.Screening_Informed_Consent_Date__c, r.Registration_Date__c, 
										r.Race__c, r.ISPY2_Subject_Id__c, r.Gender__c, r.Ethnicity__c, r.Patient__c, r.TrialPatient__c, Effective_Time__c, CreatedDate From Registration__c r where Status__c != 'Not Completed' and CreatedDate > 2013-02-18T23:59:59Z order by Effective_Time__c desc];
		Set<Id> regIds = new Set<Id>();
		for(Registration__c reg : lstCompleteRegistration) {
			if(reg.CreatedDate != reg.Effective_Time__c) continue;
			regIds.add(reg.TrialPatient__c);
		}*/
		system.debug('regIds : '+regIds);
		//query for crf	PatientCompleteScreeningPhaseReport	
		List<TrialPatient__c> lstCompleteTp = [Select t.Id,  (Select Randomization_Result__c, Did_Patient_Sign_Treatment_Consent_Form__c, Status__c, Effective_Time__c, CreatedDate  From Randomization_Forms__r order by Effective_Time__c desc)
													, (Select Status__c, Effective_Time__c, CreatedDate From On_Study_Pathology_Forms__r  order by Effective_Time__c desc), (Select Time_Point__c, Status__c, Effective_Time__c, CreatedDate From MRI_Volumes__r where Time_Point__c = 'Pre-Treatment' order by Effective_Time__c desc)
													, (Select Status__c, Effective_Time__c, CreatedDate From On_Study_Eligibility_Forms__r order by Effective_Time__c desc), (Select Status__c, Effective_Time__c, CreatedDate From Menopausal_Status_Details__r order by Effective_Time__c desc) 
													From TrialPatient__c t where Id IN :regIds and Trial_Id__c IN :lstTrial and Site__r.Institute__c IN :lstInst and Site__r.IsTestSite__c = false];
		Registration__c completeReg = null;
		//for(Registration__c completeReg : lstCompleteRegistration){	
			//if(completeReg.CreatedDate != completeReg.Effective_Time__c) continue;
			for(TrialPatient__c completeTp : lstCompleteTp)	{
				
				if(mapRegTrialPatient.containsKey(completeTp.Id)) {
					completeReg = mapRegTrialPatient.get(completeTp.Id);
				} else {
					continue;
				}
				Patient_Completed_Screening_Report__c patCompRep = new Patient_Completed_Screening_Report__c();
				patCompRep.ISPY2ID__c = completeReg.ISPY2_Subject_Id__c;
				patCompRep.Trial_Site_Name__c = completeReg.Site__r.Short_Name__c;
				patCompRep.Consent_Date__c = completeReg.Screening_Informed_Consent_Date__c;
				patCompRep.Reg_Date__c = completeReg.Registration_Date__c; 
				patCompRep.Gender__c = completeReg.Patient__r.Gender__c;
				patCompRep.Race__c = completeReg.Patient__r.Race__c;
				patCompRep.Ethnicity__c = completeReg.Patient__r.Ethnicity__c;
				patCompRep.Zip__c = completeReg.Patient__r.Zip__c; 
				
				List<Randomization_Form__c> lstRandomization = completeTp.Randomization_Forms__r;
				system.debug('TrialPatient : '+completeTP+'     completeTp.Randomization_Forms__r : '+completeTp.Randomization_Forms__r);
				if(lstRandomization != null && lstRandomization.size() > 0 && lstRandomization[0].Status__c == 'Approval Not Required') {
					patCompRep.Is_Consent_Signed__c = lstRandomization[0].Did_Patient_Sign_Treatment_Consent_Form__c;
				} else {
					continue;
				}
				
				List<Menopausal_Status_Detail__c> lstMenoStatus = completeTp.Menopausal_Status_Details__r;
				if(lstMenoStatus != null && lstMenoStatus.size() > 0) {
					/*if(lstMenoStatus[0].Status__c != 'Not Completed' && lstMenoStatus[0].Status__c != 'Completed') {
						patientCompleteWrapper.menopausalStatus = lstMenoStatus[0].Status__c;
					}*/
					if(lstMenoStatus[0].Status__c == 'Not Completed') patCompRep.Menopausal_Status__c = '';
					else if(lstMenoStatus[0].Status__c == 'Approval Pending') patCompRep.Menopausal_Status__c = 'Pending';
					else if(lstMenoStatus[0].Status__c == 'Rejected') patCompRep.Menopausal_Status__c = 'Rejected';
					else if(lstMenoStatus[0].Status__c == 'Accepted') patCompRep.Menopausal_Status__c = 'Approved';
					
				}
				
				List<MRI_Volume__c> lstMRIVolume = completeTp.MRI_Volumes__r;
				if(lstMRIVolume != null && lstMRIVolume.size() > 0) {
					/*if(lstMRIVolume[0].Status__c != 'Not Completed' && lstMRIVolume[0].Status__c != 'Completed') {
						patientCompleteWrapper.mriVolumeStatus = lstMRIVolume[0].Status__c;
					}*/
					if(lstMRIVolume[0].Status__c == 'Not Completed') patCompRep.MRI_Volume_Status__c = '';
					else if(lstMRIVolume[0].Status__c == 'Approval Pending') patCompRep.MRI_Volume_Status__c = 'Pending';
					else if(lstMRIVolume[0].Status__c == 'Rejected') patCompRep.MRI_Volume_Status__c = 'Rejected';
					else if(lstMRIVolume[0].Status__c == 'Accepted') patCompRep.MRI_Volume_Status__c = 'Approved';
				}
				
				List<On_Study_Eligibility_Form__c> lstOSE = completeTp.On_Study_Eligibility_Forms__r;
				if(lstOSE != null && lstOSE.size() > 0) {
					/*if(lstOSE[0].Status__c != 'Not Completed' && lstOSE[0].Status__c != 'Completed') {
						patientCompleteWrapper.oseStatus = lstOSE[0].Status__c;
  					}*/
  					if(lstOSE[0].Status__c == 'Not Completed') patCompRep.OSE_Status__c = '';
					else if(lstOSE[0].Status__c == 'Approval Pending') patCompRep.OSE_Status__c = 'Pending';
					else if(lstOSE[0].Status__c == 'Rejected') patCompRep.OSE_Status__c = 'Rejected';
					else if(lstOSE[0].Status__c == 'Accepted') patCompRep.OSE_Status__c = 'Approved';
				}
				
				List<On_Study_Pathology_Form__c> lstOSP = completeTp.On_Study_Pathology_Forms__r;
				if(lstOSP != null && lstOSP.size() > 0) {
					/*if(lstOSP[0].Status__c != 'Not Completed' && lstOSP[0].Status__c != 'Completed') {
						patientCompleteWrapper.ospStatus = lstOSP[0].Status__c;
					}*/
					if(lstOSP[0].Status__c == 'Not Completed') patCompRep.OSP_Status__c = '';
					else if(lstOSP[0].Status__c == 'Approval Pending') patCompRep.OSP_Status__c = 'Pending';
					else if(lstOSP[0].Status__c == 'Rejected') patCompRep.OSP_Status__c = 'Rejected';
					else if(lstOSP[0].Status__c == 'Accepted') patCompRep.OSP_Status__c = 'Approved';
				}
				patCompRep.Report_Request__c = id;
				lstCompScreenRep.add(patCompRep);
			}															
		//}
		
		insert lstCompScreenRep;
		
		Report_Request_Child__c rrc = new Report_Request_Child__c();
		rrc.Report_Request__c = id;
		insert rrc;
	}
		/**************************************prepareInTreatmenReport********************* **********/
	@future 
	public static void prepareInTreatmenReport(String id, List<String> lstTrial, List<String> lstInst) {
			
			system.debug('Id : ' + id);
			
			List<Patient_Treatment_Phase_Report__c> lstPatTreatmentRep = new List<Patient_Treatment_Phase_Report__c>();

			List<Registration__c> lstRegistration = getValidRegistrations(lstTrial, lstInst);
			Map<Id, TrialPatient__c> mapTrialPatientList = new Map<Id, TrialPatient__c>([Select t.Id, t.Site__r.Short_Name__c, t.Site__c, t.Subject_Id__c, 
					(Select Did_Patient_Sign_Treatment_Consent_Form__c, Consent_Signed_Date__c, Status__c, Effective_Time__c, CreatedDate From Randomization_Forms__r order by Effective_Time__c desc), 
					(Select Id, Effective_Time__c, CreatedDate From Chemo_Summary_Forms__r), (Select Status__c, Effective_Time__c, CreatedDate From Chemo_Treatments__r where Status__c = 'Accepted'), 
					(Select Date_Of_Procedure__c, Effective_Time__c, CreatedDate From Post_Surgery_Summaries__r where Status__c = 'Accepted' order by Effective_Time__c desc), 
					(Select Date_patient_went_off_study__c, Patient_completed_study_per_protocol__c, Patient_did_not_want_to_complete_MRI__c, Patient_did_nt_want_to_complete_core_bio__c, 
					Patient_did_nt_continue_on_treatment_arm__c, Why_patient_didnt_continue_treatment_arm__c, Patient_did_not_have_surgery__c, Patient_did_not_have_surgery_reason__c, Patient_Died__c, Effective_Time__c, CreatedDate 
					From Off_Study_Details__r where Status__c = 'Accepted' order by Effective_Time__c desc), (Select LastModifiedDate, Effective_Time__c, CreatedDate From Lost_to_Follow_Ups__r where Status__c = 'Accepted' order by LastModifiedDate DESC), 
					 (Select LastModifiedDate, Effective_Time__c, CreatedDate From Followup_Forms__r where Status__c = 'Accepted' order by LastModifiedDate DESC) From TrialPatient__c t where Trial_Id__c IN :lstTrial and Site__r.Institute__c IN :lstInst and Site__r.IsTestSite__c = false and Subject_Id__c != null]);
			
			List<TrialPatient__c> lstTrialPatient = mapTrialPatientList.values();
					 
			/*List<Chemo_Therapy_Regimen__c> lstChemoTherapyRegimen = [Select c.Chemo_Treatment__r.TrialPatient__c, c.Chemo_Treatment__r.Cycle_number__c, c.Chemo_Treatment__r.Date_of_therapy__c, c.Chemo_Treatment__c, c.Agent__r.Name, c.Agent__c, Effective_Time__c, CreatedDate From Chemo_Therapy_Regimen__c c where Chemo_Treatment__r.TrialPatient__c IN :mapTrialPatientList.keySet() order by Chemo_Treatment__r.Date_of_therapy__c asc];
			Map<Id, List<Chemo_Therapy_Regimen__c>> mapChemoTherapy = new Map<Id, List<Chemo_Therapy_Regimen__c>>();
			for(TrialPatient__c trialPatient : lstTrialPatient) {
				for(Chemo_Therapy_Regimen__c ct : lstChemoTherapyRegimen) {
					if(ct.CreatedDate != ct.Effective_Time__c) continue;
					if(trialPatient.Id != ct.Chemo_Treatment__r.TrialPatient__c) continue;
					if(mapChemoTherapy.containsKey(trialPatient.Id)) {
						mapChemoTherapy.get(trialPatient.Id).add(ct);
					} else {
						List<Chemo_Therapy_Regimen__c> lstCT = new List<Chemo_Therapy_Regimen__c>();
						lstCT.add(ct);
						mapChemoTherapy.put(trialPatient.Id, lstCT);
					}
				}	
			}*/
			
			List<Chemo_Therapy_Regimen__c> lstChemoTherapyRegimen = [Select c.Chemo_Treatment__r.Effective_Time__c, c.Chemo_Treatment__r.CreatedDate, c.Chemo_Treatment__r.TrialPatient__c, c.Chemo_Treatment__r.Cycle_number__c, c.Chemo_Treatment__r.Date_of_therapy__c, c.Chemo_Treatment__c, c.Agent__r.Name, c.Agent__c, Effective_Time__c, CreatedDate From Chemo_Therapy_Regimen__c c where Chemo_Treatment__r.TrialPatient__c IN :mapTrialPatientList.keySet() and Chemo_Treatment__r.Status__c = 'Accepted' order by Chemo_Treatment__r.Date_of_therapy__c asc];
			Map<Id, List<Chemo_Therapy_Regimen__c>> mapChemoTherapy = new Map<Id, List<Chemo_Therapy_Regimen__c>>();
			//for(TrialPatient__c trialPatient : lstTrialPatient) {
				for(Chemo_Therapy_Regimen__c ct : lstChemoTherapyRegimen) {
					//if(ct.Chemo_Treatment__r.CreatedDate != ct.Chemo_Treatment__r.Effective_Time__c) continue;
					//if(trialPatient.Id != ct.Chemo_Treatment__r.TrialPatient__c) continue;
					if(mapChemoTherapy.containsKey(ct.Chemo_Treatment__r.TrialPatient__c)) {
						mapChemoTherapy.get(ct.Chemo_Treatment__r.TrialPatient__c).add(ct);
					} else {
						List<Chemo_Therapy_Regimen__c> lstCT = new List<Chemo_Therapy_Regimen__c>();
						lstCT.add(ct);
						mapChemoTherapy.put(ct.Chemo_Treatment__r.TrialPatient__c, lstCT);
					}
				}	
			//}
			
			System.debug('mapChemoTherapy : '+mapChemoTherapy);
			
			Set<Id> chemoSummaryIds = new Set<Id>();
			//for(Registration__c completeReg : lstRegistration){	
				//if(completeReg.CreatedDate != completeReg.Effective_Time__c) continue;
				for(TrialPatient__c completeTp : lstTrialPatient)	{
					//if(completeReg.TrialPatient__c != completeTp.Id ) continue;
					List<Chemo_Treatment__c> lstChemoTreatment = completeTp.Chemo_Treatments__r;
					if(lstChemoTreatment == null || lstChemoTreatment.size() <= 0) continue;
						
					Patient_Treatment_Phase_Report__c patTreatmentRep = new Patient_Treatment_Phase_Report__c();
					patTreatmentRep.ISPY2ID__c = completeTp.Subject_Id__c;
					patTreatmentRep.Trial_Site_Name__c = completeTp.Site__r.Short_Name__c;
					System.debug('=====ShortName====='+completeTp.Site__r.Short_Name__c);
					List<Randomization_Form__c> lstRandomization = completeTp.Randomization_Forms__r;
					if(lstRandomization != null && lstRandomization.size() > 0 && lstRandomization[0].Status__c == 'Approval Not Required' && lstRandomization[0].Did_Patient_Sign_Treatment_Consent_Form__c) {
						patTreatmentRep.TreatmentConsentDate__c = lstRandomization[0].Consent_Signed_Date__c;
					} else {
						continue;
					}
					
					List<Post_Surgaory_Summary__c> lstPostSurgery = completeTp.Post_Surgery_Summaries__r;
					if(lstPostSurgery != null && lstPostSurgery.size() > 0) {
						patTreatmentRep.Surgery_Date__c = lstPostSurgery[0].Date_Of_Procedure__c;
					}
					
					List<Off_Study_Detail__c> lstStudyDetail = completeTp.Off_Study_Details__r;
					if(lstStudyDetail != null && lstStudyDetail.size() > 0) {
						patTreatmentRep.OffStudy__c = lstStudyDetail[0].Date_patient_went_off_study__c;
						String offStdRes = '';
						if(lstStudyDetail[0].Patient_completed_study_per_protocol__c) {
							offStdRes += 'Completed study per protocol, ';
						} 
						if(lstStudyDetail[0].Patient_did_not_want_to_complete_MRI__c) {
							offStdRes += 'Did not want to complete study MRI, ';
						} 
						if(lstStudyDetail[0].Patient_did_nt_want_to_complete_core_bio__c) {
							offStdRes += 'Did not want to complete study core biopsy, ';
						} 
						if(lstStudyDetail[0].Patient_did_nt_continue_on_treatment_arm__c) {
							offStdRes += 'Did not continue on treatment arm, ';
						} 
						if(lstStudyDetail[0].Patient_did_not_have_surgery__c) {
							offStdRes += 'Did not have surgery, ';
						} 
						if(lstStudyDetail[0].Patient_Died__c) {
							offStdRes += 'Died Check boxes, ';
						}
						patTreatmentRep.Off_Study_Reason__c = offStdRes;
						
					}
					
					List<Followup_Form__c> lstFollowup = completeTp.Followup_Forms__r;
					if(lstFollowup != null && lstFollowup.size() > 0) {
						patTreatmentRep.Most_Recent_Followup__c = Date.valueOf(lstFollowup[0].LastModifiedDate);
					}
					
					List<Lost_to_Follow_Up__c> lstLostFollowUp = completeTp.Lost_to_Follow_Ups__r;
					if(lstLostFollowUp != null && lstLostFollowUp.size() > 0) {
						patTreatmentRep.Lost_To_Followup__c = Date.valueOf(lstLostFollowUp[0].LastModifiedDate);
					}
					//for(Chemo_Therapy_Regimen__c chemoTherapy : lstChemoTherapyRegimen) {
						//if(chemoTherapy.CreatedDate != chemoTherapy.Effective_Time__c) continue;
						//if(completeReg.TrialPatient__c == chemoTherapy.Chemo_Treatment__r.TrialPatient__c) {
							List<Chemo_Therapy_Regimen__c> lstChemoTherapyASC = mapChemoTherapy.get(completeTp.Id);
							if(lstChemoTherapyASC == null) continue;
							sortList(lstChemoTherapyASC, 'Effective_Time__c', 'asc');
							for(Chemo_Therapy_Regimen__c ct1 : lstChemoTherapyASC) {
								//if(ct1.CreatedDate != ct1.Effective_Time__c) continue;
								System.debug('ct1.Agent__r.Name : '+ct1.Agent__r.Name);
								if(ct1.Agent__r.Name == 'Paclitaxel (Taxol)') {
									patTreatmentRep.First_Paclit_Treatment_Date__c = ct1.Chemo_Treatment__r.Date_of_therapy__c;
									break;
								}
							}
							for(Chemo_Therapy_Regimen__c ct1 : lstChemoTherapyASC) {
								//if(ct1.CreatedDate != ct1.Effective_Time__c) continue;
								if(ct1.Agent__r.Name == 'Doxorubicin (Adriamycin)' && ct1.Chemo_Treatment__r.Cycle_number__c == 13) {
									patTreatmentRep.First_AC_Treatment_Date__c = ct1.Chemo_Treatment__r.Date_of_therapy__c;
									break;
								}
							}
							
							List<Chemo_Therapy_Regimen__c> lstChemoTherapyDESC = mapChemoTherapy.get(completeTp.Id);
							if(lstChemoTherapyDESC == null) continue;
							sortList(lstChemoTherapyDESC, 'Effective_Time__c', 'desc');
							for(Chemo_Therapy_Regimen__c ct2 : lstChemoTherapyDESC) {
								//if(ct2.CreatedDate != ct2.Effective_Time__c) continue;
								if(ct2.Agent__r.Name == 'Paclitaxel (Taxol)') {
									patTreatmentRep.First_Paclit_Treatment_Date__c = ct2.Chemo_Treatment__r.Date_of_therapy__c;
									patTreatmentRep.Last_Paclit_Treatment_Cycle__c = String.valueOf(ct2.Chemo_Treatment__r.Cycle_number__c);
									break;
								}
							}
							for(Chemo_Therapy_Regimen__c ct2 : lstChemoTherapyDESC) {
								//if(ct2.CreatedDate != ct2.Effective_Time__c) continue;
								if(ct2.Agent__r.Name == 'Doxorubicin (Adriamycin)' && ct2.Chemo_Treatment__r.Cycle_number__c == 13) {
									patTreatmentRep.Last_AC_Treatment_Date__c = ct2.Chemo_Treatment__r.Date_of_therapy__c;
									patTreatmentRep.Last_AC_Treatment_Cycle__c = String.valueOf(ct2.Chemo_Treatment__r.Cycle_number__c);
									break;
								}
							}
							
						//}
					//}
					patTreatmentRep.Report_Request__c = id;
					lstPatTreatmentRep.add(patTreatmentRep);
				}
			//}	
			insert lstPatTreatmentRep;
			
			Report_Request_Child__c rrc = new Report_Request_Child__c();
			rrc.Report_Request__c = id;
			insert rrc;
		}
		
		public static void sortList(List<Sobject> items, String sortField, String order){
	       List<Sobject> resultList = new List<Sobject>();
	   
	        //Create a map that can be used for sorting 
	       Map<object, List<Sobject>> objectMap = new Map<object, List<Sobject>>();
	       
	       if(items == null) return; 
	       for(Sobject ob : items){
	                if(objectMap.get(ob.get(sortField)) == null){  // For non Sobject use obj.ProperyName
	                    objectMap.put(ob.get(sortField), new List<Sobject>()); 
	                }
	                objectMap.get(ob.get(sortField)).add(ob);
	        }       
	        //Sort the keys
	        List<object> keys = new List<object>(objectMap.keySet());
	        keys.sort();
	       
	        for(object key : keys){ 
	            resultList.addAll(objectMap.get(key)); 
	        }
	       
	        //Apply the sorted values to the source list
	        items.clear();
	        if(order.toLowerCase() == 'asc'){
	            for(Sobject ob : resultList){
	                items.add(ob); 
	            }
	        }else if(order.toLowerCase() == 'desc'){
	            for(integer i = resultList.size()-1; i >= 0; i--){
	                items.add(resultList[i]);  
	            }
	        } 
	    }
	    
		/**************************************Screening Crfs Submitted Report********************* **********/
		@future 
		public static void prepareScreeningCrfReport(String id, List<String> lstTrial, List<String> lstInst) {
			
			system.debug('Id : ' + id);
			
			List<Screening_Phase_CRF_Report__c> lstScPhaseReport = new List<Screening_Phase_CRF_Report__c>();
			
			Map<Id, Site__c> lstSite = new Map<Id, Site__c>([Select s.Short_Name__c, s.Name From Site__c s where RecordType.Name != 'Lab' and IsTestSite__c = false and Institute__c IN :lstInst]);
		
			List<TrialPatient__c> lstTrialPatient = [ Select Site__c, (Select Time_Point__c, Status__c, OwnerId, Effective_Time__c, CreatedDate From TissueSpecimenDetail__r where (Time_Point__c = 'Pre-Treatment' or Time_Point__c = 'Pre-Treatment Re-Biopsy') and Status__c ='Approval Not Required'), 
											(Select Status__c, OwnerId, Effective_Time__c, CreatedDate From Response_Evaluation_Forms__r  where Status__c IN ('Accepted', 'Approval Pending')), (Select Status__c, OwnerId, Effective_Time__c, CreatedDate From MammaPrint_Details__r where Status__c = 'Approval Not Required'), 
											(Select Status__c, Time_Point__c, OwnerId, Effective_Time__c, CreatedDate From BloodSpecimenForms__r where Time_Point__c = 'Pre-Treatment' and Status__c ='Approval Not Required'), (Select Status__c, OwnerId, Effective_Time__c, CreatedDate From Baseline_Symptoms_Forms__r where Status__c IN ('Accepted', 'Approval Pending')) 
											 From TrialPatient__c t where Trial_Id__c IN :lstTrial and Site__r.Institute__c IN :lstInst];
											 
			Map<Id, Set<TrialPatient__c>> siteTPIdsSet = new Map<Id, Set<TrialPatient__c>>();
			for(TrialPatient__c tp : lstTrialPatient) {
				if(tp.Site__c == null)continue;
				if(siteTPIdsSet.containsKey(tp.Site__c)) {
					siteTPIdsSet.get(tp.Site__c).add(tp);
				} else {
					siteTPIdsSet.put(tp.Site__c, new Set<TrialPatient__c>{tp});
				}
			}								 
			//system.debug('siteUserMap : '+siteUserMap);
			for(Id siteIds : siteTPIdsSet.keySet()) {
				Screening_Phase_CRF_Report__c scPhaseRep = new Screening_Phase_CRF_Report__c();
				scPhaseRep.Blood_Pre_Tx_Submitted__c = 0; 
				scPhaseRep.Mamma_Print_Submitted__c = 0;
				scPhaseRep.Tissue_Pre_Tx_Submitted__c = 0;
				scPhaseRep.Baseline_symptom_Approved__c = 0;
				scPhaseRep.Baseline_symptom_submitted__c = 0;
				scPhaseRep.Response_Eval_Approved__c = 0;
				scPhaseRep.Response_Eval_Submitted__c = 0;
				
				if(lstSite.get(siteIds) == null) continue; 
				scPhaseRep.TrialSite__c = lstSite.get(siteIds).Short_Name__c;
				//List<Registration__c> lstRegistration = site.Registrations__r;
				//List<Id> userIds = siteUserMap.get(site.Id);
				//if(userIds == null) {
				//	continue;
				//}
				//for(Id userId : userIds) {
					for(TrialPatient__c trialPatient : siteTPIdsSet.get(siteIds)) {
						//if(trialPatient.Site__c != site.Id) continue;
						//if(reg.TrialPatient__c == trialPatient.Id) {
							List<TissueSpecimenDetail__c> lstTissueSpecimen = trialPatient.TissueSpecimenDetail__r;
							if(lstTissueSpecimen != null) {
								for(TissueSpecimenDetail__c tissueSpecimen : lstTissueSpecimen) {
									//if(tissueSpecimen.CreatedDate != tissueSpecimen.Effective_Time__c) continue;
									//if(tissueSpecimen.Status__c == 'Approval Not Required' && tissueSpecimen.OwnerId == userId) {
										scPhaseRep.Tissue_Pre_Tx_Submitted__c += 1;
									//}
								}
							}
							
							List<BloodSpecimenForm__c> lstBloodSpecimen = trialPatient.BloodSpecimenForms__r;    
							//system.debug('lstBloodSpecimen : '+lstBloodSpecimen);
							if(lstBloodSpecimen != null) {
								for(BloodSpecimenForm__c bloodSpecimen : lstBloodSpecimen) {
									//if(bloodSpecimen.CreatedDate != bloodSpecimen.Effective_Time__c) continue;
									//if(bloodSpecimen.Status__c == 'Approval Not Required'&& bloodSpecimen.OwnerId == userId) {
										scPhaseRep.Blood_Pre_Tx_Submitted__c += 1;
									//}
								}
							}  
							
							List<MammaPrintDetail__c> lstMamaPrint = trialPatient.MammaPrint_Details__r;
							if(lstMamaPrint != null) {
								for(MammaPrintDetail__c mammaPrint : lstMamaPrint) {
									//if(mammaPrint.CreatedDate != mammaPrint.Effective_Time__c) continue;
									//if(mammaPrint.Status__c == 'Approval Not Required' && mammaPrint.OwnerId == userId) {
										scPhaseRep.Mamma_Print_Submitted__c += 1;
									//}
								}
							}
							List<BaselineSymptomsForm__c> lstBaseline = trialPatient.Baseline_Symptoms_Forms__r;
							if(lstBaseline != null) {
								for(BaselineSymptomsForm__c baseline : lstBaseline) {
									//if(baseline.CreatedDate != baseline.Effective_Time__c) continue;
									if(baseline.Status__c == 'Approval Pending') {
										scPhaseRep.Baseline_symptom_submitted__c += 1;
									} else if(baseline.Status__c == 'Accepted') {
										scPhaseRep.Baseline_symptom_Approved__c += 1;
									}
								}
							}
							List<Response_Evaluation_Form__c> lstResponseEval = trialPatient.Response_Evaluation_Forms__r;
							if(lstResponseEval != null) {
								for(Response_Evaluation_Form__c responseEval : lstResponseEval) {
									//if(responseEval.CreatedDate != responseEval.Effective_Time__c) continue;
									if(responseEval.Status__c == 'Approval Pending' ) {
										scPhaseRep.Response_Eval_Submitted__c += 1;
									} else if(responseEval.Status__c == 'Accepted') {
										scPhaseRep.Response_Eval_Approved__c += 1;
									}
								}
							} 
						//}
					}
				//}
				scPhaseRep.Report_Request__c = id; 
				lstScPhaseReport.add(scPhaseRep);
			}
			//system.debug('lstSCWrapper : '+lstSCWrapper);
			insert lstScPhaseReport;
			
			Report_Request_Child__c rrc = new Report_Request_Child__c();
			rrc.Report_Request__c = id;
			insert rrc;
		}
		
	
	/***********************************************PROTOCOL VIOLATION********************************************/
		@future
		public static void prepareProtocolViolation(String id, List<String> lstTrial, List<String> lstInst) {
			
			system.debug('Id : ' + id);
			
			List<ProtocolViolationDetail__c> lstProtocolViolation = [Select p.Status__c, p.Visit_non_complicance__c, p.Screening_and_on_study_test_lab_done__c, 
										p.Patient_became_pregnant_prior_to_surgery__c, p.Other_Violation_Checkbox__c, p.Other_Type_of_Violation__c, 
										p.On_study_procedure_required_by_protocol__c, p.Medication_non_complicance__c, p.Incorrect_therapy_given_to_patient__c, 
										p.Enrollment_of_ineligeligibleible_patient__c, p.Eligibility_criteria_exception__c,p.Screening_procedure_required__c From ProtocolViolationDetail__c p where Status__c = 'Accepted' and TrialPatient__r.Trial_Id__c IN :lstTrial and TrialPatient__r.Site__r.Institute__c IN :lstInst];
				
			Protocol_Violation_Report__c protocolVioReport = new Protocol_Violation_Report__c();
			
			protocolVioReport.Eligiblity_Critertia__c = 0;
			protocolVioReport.Enrollment_Ineligible_Patient__c = 0;
			protocolVioReport.Incorrect_Therapy_Given__c = 0;
			protocolVioReport.Medication_Non_Compliance__c = 0;
			protocolVioReport.On_Study_Procedure__c = 0;
			protocolVioReport.Other__c = 0;
			protocolVioReport.Screening_On_Study__c = 0;
			protocolVioReport.Screening_Procedure_Required__c = 0;
			protocolVioReport.Total__c = 0;
			protocolVioReport.Visit_Non_Compliance__c = 0;
			protocolVioReport.Patient_Became_Pregnant__c = 0;
			
			Map<String, integer> mapOtherProtocols = new Map<String, integer>();
			
			for(ProtocolViolationDetail__c protocolViolation : lstProtocolViolation){
				
				if(protocolViolation.Medication_non_complicance__c) {
					protocolVioReport.Total__c = protocolVioReport.Total__c + 1;
					protocolVioReport.Medication_Non_Compliance__c += 1;
				}
				if(protocolViolation.Visit_non_complicance__c){
					protocolVioReport.Total__c = protocolVioReport.Total__c + 1;
					protocolVioReport.Visit_Non_Compliance__c += 1;
				}
				if(protocolViolation.On_study_procedure_required_by_protocol__c){
					protocolVioReport.Total__c = protocolVioReport.Total__c + 1;
					protocolVioReport.On_Study_Procedure__c += 1;
				}
				if(protocolViolation.Incorrect_therapy_given_to_patient__c){
					protocolVioReport.Total__c = protocolVioReport.Total__c + 1;
					protocolVioReport.Incorrect_Therapy_Given__c += 1;
				}
				if(protocolViolation.Screening_and_on_study_test_lab_done__c){
					protocolVioReport.Total__c = protocolVioReport.Total__c + 1;
					protocolVioReport.Screening_On_Study__c += 1;
				}
				if(protocolViolation.Screening_procedure_required__c){
					protocolVioReport.Total__c = protocolVioReport.Total__c + 1;
					protocolVioReport.Screening_Procedure_Required__c += 1;
				}
				if(protocolViolation.Eligibility_criteria_exception__c){  
					protocolVioReport.Total__c = protocolVioReport.Total__c + 1;
					protocolVioReport.Eligiblity_Critertia__c += 1; 
				}
				if(protocolViolation.Enrollment_of_ineligeligibleible_patient__c){
					protocolVioReport.Total__c = protocolVioReport.Total__c + 1;
					protocolVioReport.Enrollment_Ineligible_Patient__c += 1;
				}
				if(protocolViolation.Patient_became_pregnant_prior_to_surgery__c){
					protocolVioReport.Total__c = protocolVioReport.Total__c + 1;
					protocolVioReport.Patient_Became_Pregnant__c += 1;
				}
				if(protocolViolation.Other_Violation_Checkbox__c){
					protocolVioReport.Total__c = protocolVioReport.Total__c + 1;
					protocolVioReport.Other__c += 1;
					if(mapOtherProtocols.containsKey(protocolViolation.Other_Type_of_Violation__c)) {
						integer counter = mapOtherProtocols.get(protocolViolation.Other_Type_of_Violation__c);
						++counter;
						mapOtherProtocols.put(protocolViolation.Other_Type_of_Violation__c, counter);
					} else {
						mapOtherProtocols.put(protocolViolation.Other_Type_of_Violation__c, 1);
					}
					
				}
			}
			protocolVioReport.Report_Request__c = id;
			insert protocolVioReport;
			
			List<Other_Protocol_Report__c> lstOtherProto = new List<Other_Protocol_Report__c>();
			for(String otherProto : mapOtherProtocols.keySet()) {
				Other_Protocol_Report__c opr = new Other_Protocol_Report__c();
				opr.Protocol_Name__c = otherProto;
				opr.Counter__c = mapOtherProtocols.get(otherProto);
				opr.Protocol_Violation_Report__c = protocolVioReport.Id;
				lstOtherProto.add(opr);
			}
			
			insert lstOtherProto;
			
			Report_Request_Child__c rrc = new Report_Request_Child__c();
			rrc.Report_Request__c = id;
			insert rrc;
			
		}
		
		
	//------------------------------------Method for TreamentPhase CRF Report Table 1-------------------------------------//
	
	@future 
	public static void prepareTreatmentPhaseTable1(String id, List<String> lstTrial, List<String> lstInst) {
		
		system.debug('Id : ' + id);
		
			
		List<Treatment_CRF_Report_Table_1__c> lstTreatmentCRFReport = new List<Treatment_CRF_Report_Table_1__c>();
		/* querying on site object to get record where record type is site*/
		Map<Id, Site__c> lstSite = new Map<Id, Site__c>([Select s.Short_Name__c, s.Name From Site__c s where RecordType.Name != 'Lab' and IsTestSite__c = false and Institute__c IN :lstInst]);
		
		/*Set<Id> siteIds = new Set<Id>();
		for(Site__c site : lstSite) {
			siteIds.add(site.Id);
		}
		
		List<InstitutionUser__c> lstInstitutionUser = [ Select i.User__c, i.Site__c From InstitutionUser__c i where Site__c in : siteIds];
		Map<Id, List<Id>>  siteUserMap = new  Map< Id, List<Id>>();
		for(InstitutionUser__c instUser : lstInstitutionUser){
			if(siteUserMap.containsKey(instUser.Site__c))
			{
				siteUserMap.get(instUser.Site__c).add(instUser.User__c);
			} else {
				List<Id> userIds = new List<Id>();
				userIds.add(instUser.User__c);
				siteUserMap.put(instUser.Site__c, userIds);
			}
		}*/
		
		List<TrialPatient__c> lstTrialPatient = [Select Site__c, (Select Status__c,OwnerId, Effective_Time__c, CreatedDate From Post_Surgery_Summaries__r where Status__c IN ('Approval Pending', 'Accepted') ), 
												(Select Time_Point__c, Status__c,OwnerId, Effective_Time__c, CreatedDate  From MRI_Volumes__r where Status__c IN ('Approval Pending', 'Accepted')), 
												(Select Status__c,OwnerId, Effective_Time__c, CreatedDate  From Chemo_Treatments__r where  Status__c IN ('Approval Pending', 'Accepted')), 
												(Select Status__c,OwnerId, Effective_Time__c, CreatedDate From AE_Details__r where Status__c IN ('Approval Pending', 'Accepted')) From TrialPatient__c t where Trial_Id__c IN :lstTrial and Site__r.Institute__c IN :lstInst];
		
		Map<Id, Set<TrialPatient__c>> siteTPIdsSet = new Map<Id, Set<TrialPatient__c>>();
		for(TrialPatient__c tp : lstTrialPatient) {
			if(tp.Site__c == null)continue;
			if(siteTPIdsSet.containsKey(tp.Site__c)) {
				siteTPIdsSet.get(tp.Site__c).add(tp);
			} else {
				siteTPIdsSet.put(tp.Site__c, new Set<TrialPatient__c>{tp});
			}
		}
		
		/*List<AggregateResult> arList = [select TrialPatient__r.Site__r.Name sitename, count(Id) num from Chemo_Treatment__c where status__c = 'Accepted' group by TrialPatient__r.Site__r.Name ];
		for(AggregateResult ar : arList) {
		    System.debug('sitename: '+ar.get('sitename')+':'+ar.get('num'));
		}	*/									
		for(Id siteIds : siteTPIdsSet.keySet()) {
			Treatment_CRF_Report_Table_1__c treatmentCrfRep = new Treatment_CRF_Report_Table_1__c();
			treatmentCrfRep.AE_Approved__c = 0;
			treatmentCrfRep.AE_Submitted__c = 0;
			treatmentCrfRep.Chemo_Treatment_Approved__c = 0;
			treatmentCrfRep.Chemo_Treatment_Submitted__c = 0;
			treatmentCrfRep.Mri_Volume_Early_Approved__c = 0;
			treatmentCrfRep.Mri_Volume_Early_Submitted__c = 0;
			treatmentCrfRep.Mri_Volume_Inter_Approved__c = 0;
			treatmentCrfRep.Mri_Volume_Inter_Submitted__c = 0;
			treatmentCrfRep.Mri_Volume_Pre_Surgery_Approved__c = 0;
			treatmentCrfRep.Mri_Volume_Pre_Surgery_Submitted__c = 0;
			treatmentCrfRep.Post_Surgery_Approved__c = 0;
			treatmentCrfRep.Post_Surgery_Submitted__c = 0;
			if(lstSite.get(siteIds) == null) continue; 
			treatmentCrfRep.Trial_Site_Name__c =  lstSite.get(siteIds).Short_Name__c;
			//List<Id> userIds = siteUserMap.get(site.Id);
			//if(userIds == null) {  
			//	continue;
			//}
			//for(Id userId : userIds) {
				for(TrialPatient__c trialPatient : siteTPIdsSet.get(siteIds)) {
					//if(trialPatient.Site__c != site.Id) continue;
					
					List<Chemo_Treatment__c> lstChemoTreatment = trialPatient.Chemo_Treatments__r;
					if(lstChemoTreatment != null) {
						for(Chemo_Treatment__c chemoTreatment : lstChemoTreatment) {
							//if(chemoTreatment.CreatedDate != chemoTreatment.Effective_Time__c) continue;
							if(chemoTreatment.Status__c == 'Approval Pending' ) {
								treatmentCrfRep.Chemo_Treatment_Submitted__c += 1;  
							} else if(chemoTreatment.Status__c == 'Accepted') {
								treatmentCrfRep.Chemo_Treatment_Approved__c += 1;
							}
						}
					} 
					List<MRI_Volume__c> lstMri = trialPatient.MRI_Volumes__r;
					if(lstMri != null) {
						for(MRI_Volume__c mri : lstMri) {
							//if(mri.CreatedDate != mri.Effective_Time__c) continue;
							System.debug('lstMri======='+lstMri);
							System.debug('mri.Status__c===='+mri.Status__c);
							if(mri.Time_Point__c == 'Early Treatment' && mri.Status__c == 'Approval Pending' ) {
								treatmentCrfRep.Mri_Volume_Early_Submitted__c += 1;  
							}
							else if(mri.Time_Point__c == 'Early Treatment' && mri.Status__c == 'Accepted' ) {
								treatmentCrfRep.Mri_Volume_Early_Approved__c += 1;  
							} 
						    if(mri.Time_Point__c == 'Inter-Regimen' && mri.Status__c == 'Approval Pending' ) {
								treatmentCrfRep.Mri_Volume_Inter_Submitted__c += 1;  
						    }
							else if(mri.Time_Point__c == 'Inter-Regimen' && mri.Status__c == 'Accepted' ) {
								treatmentCrfRep.Mri_Volume_Inter_Approved__c += 1;  
						    } 
						  	if(mri.Time_Point__c == 'Pre-Treatment' && mri.Status__c == 'Approval Pending' ) {
						  		treatmentCrfRep.Mri_Volume_Pre_Surgery_Submitted__c += 1;  
							}
							else if(mri.Time_Point__c == 'Pre-Treatment' && mri.Status__c == 'Accepted' ) {
								treatmentCrfRep.Mri_Volume_Pre_Surgery_Approved__c += 1;  
							} 
						}		
					} 	
				 	List<AE_Detail__c> lstAEDetail = trialPatient.AE_Details__r;
					if(lstAEDetail != null) {
						for(AE_Detail__c AEDetail : lstAEDetail) { 
							//if(AEDetail.CreatedDate != AEDetail.Effective_Time__c) continue;
							if(AEDetail.Status__c == 'Approval Pending' ) {
								treatmentCrfRep.AE_Submitted__c += 1;  
							} else if(AEDetail.Status__c == 'Accepted') {
								treatmentCrfRep.AE_Approved__c += 1;
							}
						}
					}	
					List<Post_Surgaory_Summary__c> lstPostSurgery = trialPatient.Post_Surgery_Summaries__r;
					if(lstPostSurgery != null) {
						for(Post_Surgaory_Summary__c PostSurgery : lstPostSurgery) { 
							//if(PostSurgery.CreatedDate != PostSurgery.Effective_Time__c) continue;
							if(PostSurgery.Status__c == 'Approval Pending' ) {
								treatmentCrfRep.Post_Surgery_Submitted__c += 1;  
							} else if(PostSurgery.Status__c == 'Accepted') {
								treatmentCrfRep.Post_Surgery_Approved__c += 1;
							}
						}
					}	
			   }
			//}
			treatmentCrfRep.Report_Request__c = id;
			lstTreatmentCRFReport.add(treatmentCrfRep);   
		}
		insert lstTreatmentCRFReport;
		
		Report_Request_Child__c rrc = new Report_Request_Child__c();
		rrc.Report_Request__c = id;
		insert rrc;
	}
	
	//------------------------------------Method for TreamentPhase CRF Report Table 2-------------------------------------//
	
	@future 
	public static void prepareTreatmentPhaseTable2(String id, List<String> lstTrial, List<String> lstInst) {
		
		system.debug('Id : ' + id);
		
		List<Treatment_CRF_Report_Table_2__c> lstTreatmentCRFReport = new List<Treatment_CRF_Report_Table_2__c>();
		/* querying on site object to get record where record type is site*/
		Map<Id, Site__c> lstSite = new Map<Id, Site__c>([Select s.Short_Name__c, s.Name From Site__c s where RecordType.Name != 'Lab' and IsTestSite__c = false and Institute__c IN :lstInst]);
		
		/*Set<Id> siteIds = new Set<Id>();
		for(Site__c site : lstSite) {
			siteIds.add(site.Id);
		}
		
		List<InstitutionUser__c> lstInstitutionUser = [ Select i.User__c, i.Site__c From InstitutionUser__c i where Site__c in : siteIds];
		Map<Id, List<Id>>  siteUserMap = new  Map< Id, List<Id>>();
		for(InstitutionUser__c instUser : lstInstitutionUser){
			if(siteUserMap.containsKey(instUser.Site__c))
			{
				siteUserMap.get(instUser.Site__c).add(instUser.User__c);
			} else {
				List<Id> userIds = new List<Id>();
				userIds.add(instUser.User__c);
				siteUserMap.put(instUser.Site__c, userIds);
			}
		}*/
		
		List<TrialPatient__c> lstTrialPatient = [Select Site__c, (Select Status__c,OwnerId,Reporting__c, Effective_Time__c, CreatedDate From Response_Evaluation_Forms__r  where Status__c IN('Approval Pending', 'Accepted')), 
												(Select Status__c ,OwnerId, Effective_Time__c, CreatedDate From No_Longer_lost_to_Followups__r where Status__c IN('Approval Pending', 'Accepted')), 
												(Select Status__c,OwnerId, Effective_Time__c, CreatedDate  From Lost_to_Follow_Ups__r where Status__c IN('Approval Pending', 'Accepted')), 
												(Select Status__c,OwnerId, Effective_Time__c, CreatedDate  From Followup_Forms__r where Status__c IN('Approval Pending', 'Accepted')), 
												(Select Status__c,OwnerId, Effective_Time__c, CreatedDate From Chemo_Summary_Forms__r where Status__c IN('Approval Pending', 'Accepted')) 
												 From TrialPatient__c t where Trial_Id__c IN :lstTrial and Site__r.Institute__c IN :lstInst];
		Map<Id, Set<TrialPatient__c>> siteTPIdsSet = new Map<Id, Set<TrialPatient__c>>();
		for(TrialPatient__c tp : lstTrialPatient) {
			if(tp.Site__c == null)continue;
			if(siteTPIdsSet.containsKey(tp.Site__c)) {
				siteTPIdsSet.get(tp.Site__c).add(tp);
			} else {
				siteTPIdsSet.put(tp.Site__c, new Set<TrialPatient__c>{tp});
			}
		}
		
		for(Id siteIds : siteTPIdsSet.keySet()) {
			Treatment_CRF_Report_Table_2__c treatmentCrfRep = new Treatment_CRF_Report_Table_2__c();
			treatmentCrfRep.Chemo_Summary_Approved__c = 0;
			treatmentCrfRep.Chemo_Summary_Submitted__c = 0;
			treatmentCrfRep.Follow_Up_Approved__c = 0;
			treatmentCrfRep.Follow_Up_Submitted__c = 0;
			treatmentCrfRep.Lost_To_Follow_Up_Approved__c = 0;
			treatmentCrfRep.Lost_To_Follow_Up_Submitted__c = 0;
			treatmentCrfRep.No_Longer_Lost_F_U_Approved__c = 0;
			treatmentCrfRep.No_Longer_Lost_F_U_Submitted__c = 0;
			treatmentCrfRep.Response_Eval_Inter_Reg_Approved__c = 0;
			treatmentCrfRep.Response_Eval_Inter_Reg_Submitted__c = 0;
			treatmentCrfRep.Response_Eval_Pre_Surg_Approved__c = 0;
			treatmentCrfRep.Response_Eval_Pre_Surg_Submitted__c = 0;
			
			if(lstSite.get(siteIds) == null) continue; 
			treatmentCrfRep.Trial_Site_Name__c = lstSite.get(siteIds).Short_Name__c;
			//List<Registration__c> lstRegistration = site.Registrations__r;
			//List<Id> userIds = siteUserMap.get(site.Id);
			//if(userIds == null) {  
			//	continue;
			//}
			//for(Id userId : userIds) {
				for(TrialPatient__c trialPatient : siteTPIdsSet.get(siteIds)) {
					//if(trialPatient.Site__c != site.Id) continue;
					
					////////////////Treatment CRF s Submitted (table2)///////////////////////////////////
					List<Chemo_Summary_Form__c> lstChemoSummary = trialPatient.Chemo_Summary_Forms__r;
					if(lstChemoSummary != null) {
						for(Chemo_Summary_Form__c chemoSummary : lstChemoSummary) {
							//if(chemoSummary.CreatedDate != chemoSummary.Effective_Time__c) continue;
							if(chemoSummary.Status__c == 'Approval Pending') {
								treatmentCrfRep.Chemo_Summary_Submitted__c += 1;  
							} else if(chemoSummary.Status__c == 'Accepted') {
								treatmentCrfRep.Chemo_Summary_Approved__c += 1;
							}
						}
					}
						
					List<Response_Evaluation_Form__c> lstResEval = trialPatient.Response_Evaluation_Forms__r;
					if(lstResEval != null) {	
						for(Response_Evaluation_Form__c responseEval : lstResEval) {
							//if(responseEval.CreatedDate != responseEval.Effective_Time__c) continue;
							if(responseEval.Reporting__c == 'Inter-regimen' && responseEval.Status__c == 'Approval Pending') {
								treatmentCrfRep.Response_Eval_Inter_Reg_Submitted__c += 1;  
							} else if(responseEval.Reporting__c == 'Inter-regimen' && responseEval.Status__c == 'Accepted') {
								treatmentCrfRep.Response_Eval_Inter_Reg_Approved__c += 1; 	
							} else if(responseEval.Reporting__c == 'Pre-surgery' && responseEval.Status__c == 'Approval Pending') {
								treatmentCrfRep.Response_Eval_Pre_Surg_Submitted__c += 1;  
							} else if(responseEval.Reporting__c == 'Pre-surgery' && responseEval.Status__c == 'Accepted') {
								treatmentCrfRep.Response_Eval_Pre_Surg_Approved__c += 1; 	
							} 
						}
					}
					
					List<Followup_Form__c> lstfollowUp = trialPatient.Followup_Forms__r;    
					if(lstfollowUp != null){
						for(Followup_Form__c followUp : lstfollowUp){
							//if(followUp.CreatedDate != followUp.Effective_Time__c) continue;
							if(followUp.Status__c == 'Approval Pending') {
								treatmentCrfRep.Follow_Up_Submitted__c += 1;  
							} 
							else if(followUp.Status__c == 'Accepted' ) {
								treatmentCrfRep.Follow_Up_Approved__c += 1; 	
							}
						}
					}
					
					List<Lost_to_Follow_Up__c> lstlostfollowUp = trialPatient.Lost_to_Follow_Ups__r;    
					if(lstlostfollowUp != null){
						for(Lost_to_Follow_Up__c lostfollowUp : lstlostfollowUp){
							//if(lostfollowUp.CreatedDate != lostfollowUp.Effective_Time__c) continue;
							if(lostfollowUp.Status__c == 'Approval Pending' ) {
							treatmentCrfRep.Lost_To_Follow_Up_Submitted__c += 1;  
							} 
							else if(lostfollowUp.Status__c == 'Accepted') {
								treatmentCrfRep.Lost_To_Follow_Up_Approved__c += 1; 	
							}
						}
					}
					
					List<No_Longer_lost_to_Followup__c> lstNoLonglostfollowUp = trialPatient.No_Longer_lost_to_Followups__r;    
					if(lstNoLonglostfollowUp != null){
						for(No_Longer_lost_to_Followup__c noLonglostfollowUp : lstNoLonglostfollowUp){
							//if(noLonglostfollowUp.CreatedDate != noLonglostfollowUp.Effective_Time__c) continue;
							if(noLonglostfollowUp.Status__c == 'Approval Pending') {
								treatmentCrfRep.No_Longer_Lost_F_U_Submitted__c += 1;  
							} 
							else if(noLonglostfollowUp.Status__c == 'Accepted') {
								treatmentCrfRep.No_Longer_Lost_F_U_Approved__c += 1;   	
							}
						}
					}
				}
			//}  
			
			treatmentCrfRep.Report_Request__c = id;  
			lstTreatmentCRFReport.add(treatmentCrfRep);   
		}
		insert lstTreatmentCRFReport;
		
		Report_Request_Child__c rrc = new Report_Request_Child__c();
		rrc.Report_Request__c = id;
		insert rrc;
	}
	
	//------------------------------------Method for TreamentPhase CRF Report Table 3-------------------------------------//
	
	@future 
	public static void prepareTreatmentPhaseTable3(String id, List<String> lstTrial, List<String> lstInst) {
		
		system.debug('Id : ' + id);
		
		List<Treatment_CRF_Report_Table_3__c> lstTreatmentCRFReport = new List<Treatment_CRF_Report_Table_3__c>();
		/* querying on site object to get record where record type is site*/
		Map<Id, Site__c> lstSite = new Map<Id, Site__c>([Select s.Short_Name__c, s.Name From Site__c s where RecordType.Name != 'Lab' and IsTestSite__c = false and Institute__c IN :lstInst]);
		
		/*Set<Id> siteIds = new Set<Id>();
		for(Site__c site : lstSite) {
			siteIds.add(site.Id);
		}
		
		List<InstitutionUser__c> lstInstitutionUser = [ Select i.User__c, i.Site__c From InstitutionUser__c i where Site__c in : siteIds];
		Map<Id, List<Id>>  siteUserMap = new  Map< Id, List<Id>>();
		for(InstitutionUser__c instUser : lstInstitutionUser){
			if(siteUserMap.containsKey(instUser.Site__c))
			{
				siteUserMap.get(instUser.Site__c).add(instUser.User__c);
			} else {
				List<Id> userIds = new List<Id>();
				userIds.add(instUser.User__c);
				siteUserMap.put(instUser.Site__c, userIds);
			}
		}*/
		
		List<TrialPatient__c> lstTrialPatient = [Select Site__c, (Select Time_Point__c, Status__c,OwnerId, Effective_Time__c, CreatedDate From TissueSpecimenDetail__r where Status__c = 'Approval Not Required'), 
												(Select Status__c,OwnerId, Effective_Time__c, CreatedDate  From Protocol_Violation_Details__r where Status__c IN('Approval Pending', 'Accepted')),
												(Select Status__c,OwnerId, Effective_Time__c, CreatedDate  From Off_Study_Details__r where Status__c IN('Approval Pending', 'Accepted'))
												 From TrialPatient__c t where Trial_Id__c IN :lstTrial and Site__r.Institute__c IN :lstInst];
		
		Map<Id, Set<TrialPatient__c>> siteTPIdsSet = new Map<Id, Set<TrialPatient__c>>();
		for(TrialPatient__c tp : lstTrialPatient) {
			if(tp.Site__c == null)continue;
			if(siteTPIdsSet.containsKey(tp.Site__c)) {
				siteTPIdsSet.get(tp.Site__c).add(tp);
			} else {
				siteTPIdsSet.put(tp.Site__c, new Set<TrialPatient__c>{tp});
			}
		}
		
		for(Id siteIds : siteTPIdsSet.keySet()) {
			Treatment_CRF_Report_Table_3__c treatmentCrfRep = new Treatment_CRF_Report_Table_3__c();
			treatmentCrfRep.Off_study_Approved__c = 0;
			treatmentCrfRep.Off_study_Submitted__c = 0;
			treatmentCrfRep.Protocol_Violation_Approved__c = 0;
			treatmentCrfRep.Protocol_Violation_Submitted__c = 0;
			treatmentCrfRep.Tissue_Early_Tx_Submitted__c = 0;
			treatmentCrfRep.Tissue_Inter_Reg_Submitted__c = 0;
			treatmentCrfRep.Tissue_Surgery_Submitted__c = 0;
			
			if(lstSite.get(siteIds) == null) continue; 
			treatmentCrfRep.Trial_Site_Name__c = lstSite.get(siteIds).Short_Name__c;
			//List<Registration__c> lstRegistration = site.Registrations__r;
			/*List<Id> userIds = siteUserMap.get(site.Id);
			if(userIds == null) {  
				continue;
			}*/
			//for(Id userId : userIds) {
				for(TrialPatient__c trialPatient : siteTPIdsSet.get(siteIds)) {
					//if(trialPatient.Site__c != site.Id) continue;
					List<Off_Study_Detail__c> lstOffStudyDetail = trialPatient.Off_Study_Details__r;    
					if(lstOffStudyDetail != null){
						for(Off_Study_Detail__c offStudyDetail : lstOffStudyDetail){
							//if(offStudyDetail.CreatedDate != offStudyDetail.Effective_Time__c) continue;
							if(offStudyDetail.Status__c == 'Approval Pending') {
								treatmentCrfRep.Off_study_Submitted__c += 1;  
							} 
							else if(offStudyDetail.Status__c == 'Accepted') {
								treatmentCrfRep.Off_study_Approved__c += 1;   	
							}
						}
					}		
					List<TissueSpecimenDetail__c> lstTissueSpecimenDetail = trialPatient.TissueSpecimenDetail__r;
					if(lstTissueSpecimenDetail != null) {
						for(TissueSpecimenDetail__c tissueSpecimenDetail : lstTissueSpecimenDetail) {
							//if(tissueSpecimenDetail.CreatedDate != tissueSpecimenDetail.Effective_Time__c) continue;
							if(tissueSpecimenDetail.Time_Point__c == 'Early Treatment' && tissueSpecimenDetail.Status__c == 'Approval Not Required') {
								treatmentCrfRep.Tissue_Early_Tx_Submitted__c += 1;  
							} else if(tissueSpecimenDetail.Time_Point__c == 'Inter-Regimen' && tissueSpecimenDetail.Status__c == 'Approval Not Required') {
								treatmentCrfRep.Tissue_Inter_Reg_Submitted__c += 1;  
						    } else if(tissueSpecimenDetail.Time_Point__c == 'Surgery' && tissueSpecimenDetail.Status__c == 'Approval Not Required') {
						  		treatmentCrfRep.Tissue_Surgery_Submitted__c += 1;  
						 	}
						}	
					}	
					List<ProtocolViolationDetail__c> lstProtocolViolation = trialPatient.Protocol_Violation_Details__r;    
					if(lstProtocolViolation != null){
						for(ProtocolViolationDetail__c protocolViolation :lstProtocolViolation){
							//if(protocolViolation.CreatedDate != protocolViolation.Effective_Time__c) continue;
							if(protocolViolation.Status__c == 'Approval Pending') {
								treatmentCrfRep.Protocol_Violation_Submitted__c += 1;  
							} 
							else if(protocolViolation.Status__c == 'Accepted') {
								treatmentCrfRep.Protocol_Violation_Approved__c += 1;   	
							}
						}
					}		
				}
			//}    
			treatmentCrfRep.Report_Request__c = id;
			lstTreatmentCRFReport.add(treatmentCrfRep);   
		}
		insert lstTreatmentCRFReport;
		
		Report_Request_Child__c rrc = new Report_Request_Child__c();
		rrc.Report_Request__c = id;
		insert rrc;
	}
	
	//------------------------------------Method for TreamentPhase CRF Report Table 4-------------------------------------//
	
	@future 
	public static void prepareTreatmentPhaseTable4(String id, List<String> lstTrial, List<String> lstInst) {
		
		system.debug('Id : ' + id);
		
		List<Treatment_CRF_Report_Table_4__c> lstTreatmentCRFReportTable4 = new List<Treatment_CRF_Report_Table_4__c>();
		/* querying on site object to get record where record type is site*/
		Map<Id, Site__c> lstSite = new Map<Id, Site__c>([Select s.Short_Name__c, s.Name From Site__c s where RecordType.Name != 'Lab' and IsTestSite__c = false and Institute__c IN :lstInst]);
				
		List<TrialPatient__c> lstTrialPatient = [Select Site__c, (Select Time_Point__c ,Status__c ,OwnerId, Effective_Time__c, CreatedDate From BloodSpecimenForms__r where Status__c  = 'Approval Not Required') From TrialPatient__c t where Trial_Id__c IN :lstTrial and Site__r.Institute__c IN :lstInst];
		
		Map<Id, Set<TrialPatient__c>> siteTPIdsSet = new Map<Id, Set<TrialPatient__c>>();
		for(TrialPatient__c tp : lstTrialPatient) {
			if(tp.Site__c == null)continue;
			if(siteTPIdsSet.containsKey(tp.Site__c)) {
				siteTPIdsSet.get(tp.Site__c).add(tp);
			} else {
				siteTPIdsSet.put(tp.Site__c, new Set<TrialPatient__c>{tp});
			}
		}
		
		//system.debug('siteUserMap : '+siteUserMap);
		for(Id siteIds : siteTPIdsSet.keySet()) {
			Treatment_CRF_Report_Table_4__c treatmentCrfRep = new Treatment_CRF_Report_Table_4__c();
			treatmentCrfRep.Blood_Early_Tx_Submitted__c = 0;
			treatmentCrfRep.Blood_Inter_Reg_Submitted__c = 0;
			treatmentCrfRep.Blood_Pre_Surg_Submitted__c = 0;
			
			if(lstSite.get(siteIds) == null) continue; 
			treatmentCrfRep.Trial_Site_Name__c = lstSite.get(siteIds).Short_Name__c;
			//List<Registration__c> lstRegistration = site.Registrations__r;
			/*List<Id> userIds = siteUserMap.get(site.Id);
			if(userIds == null) {  
				continue;
			}*/
			//for(Id userId : userIds) {
				for(TrialPatient__c trialPatient : siteTPIdsSet.get(siteIds)) {
					//if(trialPatient.Site__c != site.Id) continue;
					List<BloodSpecimenForm__c> lstBloodSpecimen = trialPatient.BloodSpecimenForms__r;
					if(lstBloodSpecimen != null) {
						for(BloodSpecimenForm__c bloodSpecimen : lstBloodSpecimen) {
							//if(bloodSpecimen.CreatedDate != bloodSpecimen.Effective_Time__c) continue;
							if(bloodSpecimen.Time_Point__c == 'Early Treatment' && bloodSpecimen.Status__c == 'Approval Not Required') {
								treatmentCrfRep.Blood_Early_Tx_Submitted__c += 1;  
							} else if(bloodSpecimen.Time_Point__c == 'Inter-Regimen' && bloodSpecimen.Status__c == 'Approval Not Required') {
								treatmentCrfRep.Blood_Inter_Reg_Submitted__c += 1;  
						    } else if(bloodSpecimen.Time_Point__c == 'Pre-Surgery' && bloodSpecimen.Status__c == 'Approval Not Required') {
								treatmentCrfRep.Blood_Pre_Surg_Submitted__c += 1;  
							} 	
						}
					}	   	
			   	}
			//}    
			treatmentCrfRep.Report_Request__c = id;
			lstTreatmentCRFReportTable4.add(treatmentCrfRep);   
		}
		insert lstTreatmentCRFReportTable4;
		
		Report_Request_Child__c rrc = new Report_Request_Child__c();
		rrc.Report_Request__c = id;
		insert rrc;
	}
	
	public static void sendReportRequestEmailNotification(Id repReqId, String emailBody) {
		List<Report_Request__c> lstRepReq = [select Id, CreatedById from Report_Request__c where Id = :repReqId];
		if(!lstRepReq.isEmpty()) {
			Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
				
			String emailId = '';
			String name = '';
			System.debug('rr.CreatedById : '+lstRepReq[0].CreatedById);
			List<User> lstUser = [select Email, Name from User where Id = :lstRepReq[0].CreatedById];
			if(!lstUser.IsEmpty()) {
				emailId = lstUser[0].Email;
				name = lstUser[0].Name;
			}
			String[] toAddresses = new String[] {emailId};
			mail.setToAddresses(toAddresses);
			
			mail.setSubject('Patient Summary Report');
			
			//mail.setPlainTextBody('Report request has processed successfully. You can download report from mentioned links:'); 
			mail.setHtmlBody('Hi '+name+','+emailBody);
			
			Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
			
			//create email logs
			//build string for email Address
			String emailIdString = '';
			for(String emailStr : mail.getToAddresses()) {
				emailIdString+= emailStr+',';
			}
			if(emailIdString != '') {
				emailIdString = emailIdString.substring(0, (emailIdString.length()-1));
			}
			
			/*Email_Logs__c emailLog = new Email_Logs__c();
			emailLog.Class_Name__c = 'PatientSummaryReport.cls';
			emailLog.Email_Subject__c = mail.getSubject();
			emailLog.Recipient__c = emailIdString;
			emailLog.Remaining_Email_Invocation__c = (Limits.getLimitEmailInvocations() - Limits.getEmailInvocations())+' remaining out of total' +Limits.getLimitEmailInvocations();
			emailLog.Sender__c = Userinfo.getUserId();
			insert emailLog;*/
			Email_Logs__c emailLog = EmailLogsManager.createEmailLog('PatientSummaryReport.cls', mail.getSubject(), emailIdString);
			insert emailLog;
		}	
	}
	
	//PatientComplete Screening wrapper class
	public class PatientSummaryWrapper {
		public String ISPY2ID {get;set;}
		public String trialSiteName {get;set;}
		public date consentDate {get;set;} 
		public date regDate {get;set;}
		public String gender {get;set;} 
		public String race {get;set;}
		public String ethnicity {get;set;}
		public String menopausalStatus {get;set;}
		public String mriVolumeStatus {get;set;}
		public String oseStatus {get;set;}
		public String ospStatus {get;set;}
		public String zip {get;set;}
		public String isConsentSigned {get;set;}
		
		
	}
	//Treatment Phase patient report
	public class PatientTreatmentPhaseWrapper {
		public String ISPY2ID {get;set;}
		public String trialSiteName {get;set;}
		public date treatmentConsentDate {get;set;}
		public date firstPaclitTreatmentDate {get;set;}
		public date lastPaclitTreatmentDate {get;set;}
		public String lastPaclitTreatmentCycle {get;set;}
		public date firstACTreatmentDate {get;set;}
		public date lastACTreatmentDate {get;set;}
		public String lastACTreatmentCycle {get;set;} 
		public date surgeryDate {get;set;}
		public Date mostRecentFollowup {get;set;}
		public Date lostToFollowup {get;set;}
		public Date offStudyDate {get;set;}
		public String offStudyReason {get;set;}
		public String chemoSummaryId {get;set;}
	}
	
	public class ScreeningCrfWrapper{
		public ScreeningCrfWrapper() {
			tissuePreTxSubmitted = 0;
			bloodPreTxSubmitted = 0;
			mammaPrintSubmitted = 0;
			baselineSubmitted = 0;
			responseEvalSubmitted = 0;
			baselineApproved = 0;
			responseEvalApproved = 0;
		}
		public String trialSiteName {get;set;}
		public integer tissuePreTxSubmitted {get;set;}
		public integer bloodPreTxSubmitted {get;set;}
		public integer mammaPrintSubmitted {get;set;}
		public integer baselineSubmitted {get;set;}
		public integer baselineApproved {get;set;}
		public integer responseEvalSubmitted {get;set;}
		public integer responseEvalApproved {get;set;}
	}
	
	public class ProtocolViolationWrapper {
		public Integer medicationNonCompliance {get;set;}
		public Integer visitNonCompliance {get;set;}
		public Integer onStudyProcedure {get;set;}
		public Integer incorrectTherapyGiven {get;set;}
		public Integer screeningOnStudy {get;set;}
		public Integer screeningProcedureRequired {get;set;}
		public Integer eligiblityCritertia {get;set;}
		public Integer enrollmentIneligiblePatient {get;set;}
		public Integer patientBecamePregnant {get;set;}
		public Integer other {get;set;}
		public Integer total {get;set;}
		public List<OtherProtoViolationWrapper> lstOtherProtoViolation {get;set;}
		public ProtocolViolationWrapper() {
			
			medicationNonCompliance = 0;
			visitNonCompliance = 0;
			onStudyProcedure = 0;
			incorrectTherapyGiven = 0;
			screeningOnStudy = 0;
			screeningProcedureRequired = 0;
			eligiblityCritertia = 0;
			enrollmentIneligiblePatient = 0;
			patientBecamePregnant = 0;
			other = 0;
			total = 0;
			lstOtherProtoViolation = new List<OtherProtoViolationWrapper>();
		}
	}
	
	public class OtherProtoViolationWrapper {
		public String otherViolation {get;set;}
		public integer numberOfOtherViolation {get;set;}
		public String rowColor {get;set;}
		public OtherProtoViolationWrapper() {
			rowColor = '#DBE4F0';
			numberOfOtherViolation = 1;
		}
	}
	
	public class SiteTrialPatientWrapper {
		public String site;
		public String trialPatient;
	}
	
	public class TreatmentCRFReportsWrapper1 {
		public String trialSiteName {get;set;}
		public integer chemoTreatmentSubmitted {get;set;}
		public integer chemoTreatmentApproved {get;set;}
		public integer mriVolumeEarlySubmitted {get;set;}
		public integer mriVolumeEarlyApproved {get;set;}
		public integer mriVolumeInterSubmitted {get;set;}
		public integer mriVolumeInterApproved {get;set;}
		public integer mriVolumePreSurgerySubmitted {get;set;}
		public integer mriVolumePreSurgeryApproved {get;set;}
		public integer aeSubmitted {get;set;}
		public integer aeApproved {get;set;}
		public integer postSurgerySubmitted {get;set;}
		public integer postSurgeryApproved {get;set;}
		
		public TreatmentCRFReportsWrapper1() {
			chemoTreatmentSubmitted = 0;
			chemoTreatmentApproved = 0;
			mriVolumeEarlySubmitted = 0;
			mriVolumeEarlyApproved = 0;
			mriVolumeInterSubmitted = 0;
			mriVolumeInterApproved = 0;
			mriVolumePreSurgerySubmitted = 0; 
			mriVolumePreSurgeryApproved =0;
			aeSubmitted = 0;
			aeApproved = 0;
			postSurgerySubmitted = 0;
			postSurgeryApproved = 0;
		}
	}
	
	public class TreatmentCRFReportsWrapper2 {
		public String trialSiteName {get;set;}
		public integer chemoSummarySubmitted {get;set;}
		public integer chemoSummaryApproved {get;set;}
		public integer responseEvalInterRegSubmitted {get;set;}
		public integer responseEvalInterRegApproved {get;set;}
		public integer responseEvalPreSurgSubmitted {get;set;}
		public integer responseEvalPreSurgApproved {get;set;}
		public integer followUpSubmitted {get;set;}
		public integer followUpApproved {get;set;}
		public integer losttoFollowUpSubmitted {get;set;}
		public integer losttoFollowUpApproved {get;set;}
		public integer noLongerLostFUSubmitted {get;set;}
		public integer noLongerLostFUApproved {get;set;}
		
		public TreatmentCRFReportsWrapper2() {
			chemoSummarySubmitted = 0;
			chemoSummaryApproved = 0;
			responseEvalInterRegSubmitted = 0;
			responseEvalInterRegApproved = 0;
			responseEvalPreSurgSubmitted = 0;
			responseEvalPreSurgApproved = 0;
			followUpSubmitted = 0;
			followUpApproved = 0;
			losttoFollowUpSubmitted = 0;
			losttoFollowUpApproved = 0;
			noLongerLostFUSubmitted = 0;
			noLongerLostFUApproved = 0;
		}
	}
	
	public class TreatmentCRFReportsWrapper3 {
		public String trialSiteName {get;set;}
		public integer offStudySubmitted {get;set;}
		public integer offStudyApproved {get;set;}
		public integer tissueEarlyTxSubmitted {get;set;}
		public integer tissueInterRegSubmitted {get;set;}
		public integer tissueSurgerySubmitted {get;set;}
		public integer protocolViolationSubmitted {get;set;}
		public integer protocolViolationApproved {get;set;}
		
		public TreatmentCRFReportsWrapper3() {
			offStudySubmitted = 0;
			offStudyApproved = 0;
			tissueEarlyTxSubmitted = 0;
			tissueInterRegSubmitted = 0;
			tissueSurgerySubmitted = 0;
			protocolViolationSubmitted = 0;
			protocolViolationApproved = 0;
		}
	}
	
	public class TreatmentCRFReportsWrapper4 {
		public String trialSiteName {get;set;}
		public integer bloodEarlyTxSubmitted  {get;set;}
		public integer bloodInterTxSubmitted  {get;set;}
		public integer bloodSurgerySubmitted {get;set;}
		
		public TreatmentCRFReportsWrapper4() {
			bloodEarlyTxSubmitted = 0;
			bloodInterTxSubmitted = 0;
			bloodSurgerySubmitted = 0;
		}
	}
}