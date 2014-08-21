public without sharing class TrialSummaryReport {
	
	public String siteId {get;set;}
	public String siteName {get;set;}
	public Trial__c trial{get;set;}
	public Datetime asOfDate{get;set;}
	public integer remainingSites {get;set;}
	
	public Integer totalPreEligibility{get;set;} //submitted Pre-Eligibility Checklist CRF
	public Integer totalNotEnrolled{get;set;} //submitted Pre-Eligibility Checklist CRF, No submitted Registration CRF
	public Integer totalEnrolled{get;set;} //submitted Registration CRF
	public Integer totalPendingRandomization{get;set;} //submitted Registration CRF, No submitted Randomization CRF
	public Integer totalNotProceedingToTreatmentPhase{get;set;} //submitted Randomization CRF with ‘Did patient sign treatment consent form’ equal to ‘No’
	public Integer totalRandomizedWhoProceededToTreatmentPhase{get;set;} //submitted Randomization CRF with ‘Did patient sign treatment consent form’ equal to ‘Yes’
	//==========below variable is for submitted Randomization CRF with ‘Did patient sign treatment consent form’ equal to ‘Yes’, No DCC approved Post-Surgery Summary CRF, No DCC approved Follow-up CRF, No DCC approved Off-Study CRF	
	public Integer totalReceivingTreatment{get;set;} 
	//==========below variable is for submitted Randomization CRF with ‘Did patient sign treatment consent form’ equal to ‘Yes’, DCC approved Post-Surgery Summary CRF, No DCC approved Off-Study CRF	
	public Integer totalInFollowUp{get;set;} 
	//==========below variable is for submitted Randomization CRF with ‘Did patient sign treatment consent form’ equal to ‘Yes’, DCC approved Lost to Follow-up CRF, No DCC approved No longer lost to follow-up CRF	
	public Integer totalLostToFollowUp{get;set;}
	//==========below variable is for submitted Randomization CRF with ‘Did patient sign treatment consent form’ equal to ‘Yes’, DCC approved Off-Study CRF
	public Integer totalOffStudy{get;set;}
	//==========below variable is for submitted Randomization CRF with ‘Did patient sign treatment consent form’ equal to ‘Yes’, DCC approved Off-Study CRF with ‘Patient completed study per protocol’ selected
	public Integer totalCompletingStudyPerProtocol{get;set;}
	//==========below variable is for submitted Randomization CRF with ‘Did patient sign treatment consent form’ equal to ‘Yes’, DCC approved Off-Study CRF with ‘Patient completed study per protocol’ NOT selected
	public Integer totalNotCompletingStudyPerProtocol{get;set;}
	
	public List<WrapYear> wrapYearList{get;set;}
	
	public List<WrapStudySite> WrapSiteList{get;set;}
	
	public Integer totalEnrolledPatient {get;set;}	
	
	public Integer patientAvgAge{get;set;}
	public Integer patientMinAge{get;set;}
	public Integer patientMaxAge{get;set;}
	public Integer totalAmericanAlaskaRaceCount{get;set;}
	public Integer totalAsianRaceCount{get;set;}
	public Integer totalBlackAmericanRaceCount{get;set;}
	public Integer totalNativeOtherIslanderRaceCount{get;set;}
	public Integer totalWhiteRaceCount{get;set;}
	public Integer totalHispanicEthnicityCount{get;set;}
	public Integer totalNotHispanicEthnicityCount{get;set;}
	
	public Integer totalPatientNotEligible{get;set;}
	public Integer patientNotHistologicallyConfirmed{get;set;}
	public Integer patientNotRadiologicallyMeasurable{get;set;}
	public Integer totalPatientReceivedCytotoxicRegiments{get;set;}
	public Integer totalPatient30DaysInvestigationalAgents{get;set;} 
	public Integer totalPatientReceivedRadiationTherapy{get;set;} //===take value form field "Not had prior RT" in object
	public Integer totalPatientUnder18Years{get;set;}
	public Integer totalPatientPregnantOrLactating{get;set;}
	public Integer totalPatientFerromagneticProstheses{get;set;}
	public Integer totalPatientNotWillingCoreBiopsy{get;set;}
	public Integer totalPatientNotWillingStudyMRI{get;set;}
	public Integer totalPatientHasECOGScore2{get;set;}
	public Integer totalPatientHasECOGScore3{get;set;}
	public Integer totalPatientHasECOGScore4{get;set;}
	public Integer totalPatientHasECOGScore5{get;set;}
	public Integer totalPatientEligibleForTrialNotSign{get;set;} //Patients eligible for the trial but did not sign screening consent
	public Integer totalPatientNotParticipateInClinicalTrial{get;set;} //Patient did not want to participate in a clinical trial
	public Integer totalPatientNotWillingInInvestigationalAgent{get;set;} //Patient is not willing to be treated with an investigational agent
	public Integer totalPatientDecidedWithNeoadjuvantRegimen{get;set;} //Patient decided to be treated with a different neoadjuvant regimen
	public Integer totalPatientDecidedSurgeryBeforeTreatment{get;set;} //Patient decided to have surgery before treatment
	public Integer totalPatientDecidedAtAnotherClinic{get;set;} //Patient decided to be treated at another clinic
	public Integer totalPatientInsurance{get;set;} //Insurance will not cover standard of care
	
	public Integer novelAgentCount{get;set;}
	public Integer neoadjuvantCount{get;set;}
	public Integer mammaPrinttestCount{get;set;}
	public Integer coreBiopsyCount{get;set;}
	public Integer completeMRICount{get;set;}
	public Integer mPLowERPositiveCount{get;set;}
	public Integer eligibilityCriteriaCount{get;set;}
	public Integer otherCount{get;set;}
	public Integer totalCount{get;set;}
	
	public List<OtherWrapper> lstOtherWrapper{get;set;}
	
	public List<AccrualSiteWrapper> lstAccrualSiteWrapper {get;set;}
	public AccrualSiteWrapper accSiteWrap {get;set;}
	public Set<String> processedIds {get;set;}
	public boolean processAll {get;set;}
	
	public TrialSummaryReport() {
		
		totalPreEligibility = 0;
		totalNotEnrolled = 0;
		totalEnrolled = 0;
		totalPendingRandomization = 0;
		totalNotProceedingToTreatmentPhase = 0;
		totalRandomizedWhoProceededToTreatmentPhase = 0;
		totalReceivingTreatment = 0;
		totalInFollowUp = 0;
		totalLostToFollowUp = 0;
		totalOffStudy = 0;
		totalCompletingStudyPerProtocol = 0;
		totalNotCompletingStudyPerProtocol = 0;
		
		wrapYearList = new List<WrapYear>();
		
		totalEnrolledPatient = 0;
		WrapSiteList = new List<WrapStudySite>();
		
		patientAvgAge = 0;
		patientMinAge = 0;
		patientMaxAge = 0;
		totalAmericanAlaskaRaceCount = 0;
		totalAsianRaceCount = 0;
		totalBlackAmericanRaceCount = 0;
		totalNativeOtherIslanderRaceCount = 0;
		totalWhiteRaceCount = 0;
		totalHispanicEthnicityCount = 0;
		totalNotHispanicEthnicityCount = 0;
		
		novelAgentCount = 0;
		neoadjuvantCount = 0;
		mammaPrinttestCount = 0;
		coreBiopsyCount = 0;
		completeMRICount = 0;
		mPLowERPositiveCount = 0;
		eligibilityCriteriaCount = 0;
		otherCount = 0;
		totalCount = 0;
		
		processedIds = new Set<String>();
		processAll = true;
		lstAccrualSiteWrapper = new List<AccrualSiteWrapper>();
		
		String trialId = ApexPages.currentPage().getParameters().get('trialId');
		siteId = ApexPages.currentPage().getParameters().get('siteId');
		System.debug('trialId : '+trialId);
		trial = [select Name from Trial__c where Id =:trialId];
		
		if(ApexPages.currentPage().getParameters().get('asOfDate') != null) {
			asOfDate = Date.valueOf(ApexPages.currentPage().getParameters().get('asOfDate'));
		} else {
			asOfDate = system.now();
		}
		
	}
	public void prepareAccrualSummaryForAll() {
		StudyAccrualSummaryWrapper studyAccrualSummaryWrapper = populateStudyAccrualSummaryData(null, trial.Id, asOfDate);
		totalPreEligibility = studyAccrualSummaryWrapper.totalPreEligibility;
		totalNotEnrolled = studyAccrualSummaryWrapper.totalNotEnrolled;
		totalEnrolled = studyAccrualSummaryWrapper.totalEnrolled;
		totalPendingRandomization= studyAccrualSummaryWrapper.totalPendingRandomization;
		totalNotProceedingToTreatmentPhase = studyAccrualSummaryWrapper.totalNotProceedingToTreatmentPhase;
		totalRandomizedWhoProceededToTreatmentPhase = studyAccrualSummaryWrapper.totalRandomizedWhoProceededToTreatmentPhase;
		totalReceivingTreatment = studyAccrualSummaryWrapper.totalReceivingTreatment;
		totalInFollowUp = studyAccrualSummaryWrapper.totalInFollowUp;
		totalLostToFollowUp = studyAccrualSummaryWrapper.totalLostToFollowUp;
		totalOffStudy = studyAccrualSummaryWrapper.totalOffStudy;
		totalCompletingStudyPerProtocol = studyAccrualSummaryWrapper.totalCompletingStudyPerProtocol;
		totalNotCompletingStudyPerProtocol = studyAccrualSummaryWrapper.totalNotCompletingStudyPerProtocol;
		
	}
	
	public void prepareDataEnrolledByMonthForAll() {
		wrapYearList = populateDataEnrolledByMonth(null, trial.Id, asOfDate);
	}
	
	public void prepareDataEnrolledByStudySiteForAll() {
		EnrolledByStudySite enrolledByStudySite = populateDataEnrolledByStudySite(null, trial.Id, asOfDate);
		//wrapSiteList = enrolledByStudySite.wrapSiteList;
		//totalEnrolledPatient = enrolledByStudySite.totalEnrolledPatient;
	}
	
	public void prepareStudyParticipantDemographicsForAll() {
		StudyParticipantDemographicsWrapper studyPartDemoWrapper = populateStudyParticipantDemographics(null, trial.Id, asOfDate);
		patientAvgAge = studyPartDemoWrapper.patientAvgAge;
		patientMaxAge = studyPartDemoWrapper.patientMaxAge;
		patientMinAge = studyPartDemoWrapper.patientMinAge;
		totalAmericanAlaskaRaceCount = studyPartDemoWrapper.totalAmericanAlaskaRaceCount;
		totalAsianRaceCount = studyPartDemoWrapper.totalAsianRaceCount;
		totalBlackAmericanRaceCount = studyPartDemoWrapper.totalBlackAmericanRaceCount;
		totalEnrolledPatient = studyPartDemoWrapper.totalEnrolledPatient;
		totalHispanicEthnicityCount = studyPartDemoWrapper.totalHispanicEthnicityCount;
		totalNativeOtherIslanderRaceCount = studyPartDemoWrapper.totalNativeOtherIslanderRaceCount;
		totalNotHispanicEthnicityCount = studyPartDemoWrapper.totalNotHispanicEthnicityCount;
		totalWhiteRaceCount = studyPartDemoWrapper.totalWhiteRaceCount;
		wrapSiteList = studyPartDemoWrapper.wrapSiteList;
	}
	
	
	public void prepareNotEnrolledPatientForAll() {
		NotEnrolledPatientWrapper notEnrolledPatientWrapper = populateNotEnrolledPatient(null, trial.Id, asOfDate);
		totalPatientNotEligible = notEnrolledPatientWrapper.totalPatientNotEligible;
		patientNotHistologicallyConfirmed = notEnrolledPatientWrapper.patientNotHistologicallyConfirmed;
		patientNotRadiologicallyMeasurable = notEnrolledPatientWrapper.patientNotRadiologicallyMeasurable;
		totalPatientReceivedCytotoxicRegiments = notEnrolledPatientWrapper.totalPatientReceivedCytotoxicRegiments;
		totalPatient30DaysInvestigationalAgents = notEnrolledPatientWrapper.totalPatient30DaysInvestigationalAgents; 
		totalPatientReceivedRadiationTherapy = notEnrolledPatientWrapper.totalPatientReceivedRadiationTherapy;
		totalPatientUnder18Years = notEnrolledPatientWrapper.totalPatientUnder18Years;
		totalPatientPregnantOrLactating = notEnrolledPatientWrapper.totalPatientPregnantOrLactating;
		totalPatientFerromagneticProstheses = notEnrolledPatientWrapper.totalPatientFerromagneticProstheses;
		totalPatientNotWillingCoreBiopsy = notEnrolledPatientWrapper.totalPatientNotWillingCoreBiopsy;
		totalPatientNotWillingStudyMRI = notEnrolledPatientWrapper.totalPatientNotWillingStudyMRI;
		totalPatientHasECOGScore2 = notEnrolledPatientWrapper.totalPatientHasECOGScore2;
		totalPatientHasECOGScore3 = notEnrolledPatientWrapper.totalPatientHasECOGScore3;
		totalPatientHasECOGScore4 = notEnrolledPatientWrapper.totalPatientHasECOGScore4;
		totalPatientHasECOGScore5 = notEnrolledPatientWrapper.totalPatientHasECOGScore5;
		totalPatientEligibleForTrialNotSign = notEnrolledPatientWrapper.totalPatientEligibleForTrialNotSign;
		totalPatientNotParticipateInClinicalTrial = notEnrolledPatientWrapper.totalPatientNotParticipateInClinicalTrial;
		totalPatientNotWillingInInvestigationalAgent = notEnrolledPatientWrapper.totalPatientNotWillingInInvestigationalAgent;
		totalPatientDecidedWithNeoadjuvantRegimen = notEnrolledPatientWrapper.totalPatientDecidedWithNeoadjuvantRegimen;
		totalPatientDecidedSurgeryBeforeTreatment = notEnrolledPatientWrapper.totalPatientDecidedSurgeryBeforeTreatment;
		totalPatientDecidedAtAnotherClinic = notEnrolledPatientWrapper.totalPatientDecidedAtAnotherClinic;
		totalPatientInsurance = notEnrolledPatientWrapper.totalPatientInsurance;
	}
	
	public void prepareDataNotProceedingTreatmentPhaseForAll() {
		NotProceedingTreatmentPhase notProceedingTreatmentPhase = populateDataNotProceedingTreatmentPhase(null, trial.Id, asOfDate);
		novelAgentCount = notProceedingTreatmentPhase.novelAgentCount;
		neoadjuvantCount = notProceedingTreatmentPhase.neoadjuvantCount;
		mammaPrinttestCount = notProceedingTreatmentPhase.mammaPrinttestCount;
		coreBiopsyCount = notProceedingTreatmentPhase.coreBiopsyCount;
		completeMRICount = notProceedingTreatmentPhase.completeMRICount;
		mPLowERPositiveCount = notProceedingTreatmentPhase.mPLowERPositiveCount;
		eligibilityCriteriaCount = notProceedingTreatmentPhase.eligibilityCriteriaCount;
		otherCount = notProceedingTreatmentPhase.otherCount;
		totalCount = notProceedingTreatmentPhase.totalCount;
		lstOtherWrapper = notProceedingTreatmentPhase.lstOtherWrapper;
		processAll = false;
		remainingSites = 0;
	}
	
	public void prepareAccrualSummaryForSite() {
		processedIds.add(siteId);
		siteId = null;
		accSiteWrap = new AccrualSiteWrapper();
		Set<Id> sIds = new Set<Id>();
		List<Site_Trial__c> lstSiteTrial = [Select s.Trial__c, s.Site__c From Site_Trial__c s where Trial__c = :trial.Id and Site__c NOT IN :processedIds];
		for(Site_Trial__c st : lstSiteTrial) {
			sIds.add(st.Site__c);
		}
		List<Site__c> lstSite = [select Id, Name from Site__c where Id IN :sIds and RecordType.Name = 'Site' and IsTestSite__c = false order by Name asc];
		if(lstSite.isEmpty()) return;
		remainingSites = lstSite.size() - 1; 
		siteId = lstSite[0].Id;
		siteName = lstSite[0].Name;
		
		accSiteWrap.site = lstSite[0];
		lstAccrualSiteWrapper.add(accSiteWrap);
		
		StudyAccrualSummaryWrapper studyAccrualSummaryWrapper = populateStudyAccrualSummaryData(siteId, trial.Id, asOfDate);
		accSiteWrap.totalPreEligibilityforSite = studyAccrualSummaryWrapper.totalPreEligibility;
		accSiteWrap.totalNotEnrolledforSite = studyAccrualSummaryWrapper.totalNotEnrolled;
		accSiteWrap.totalEnrolledforSite = studyAccrualSummaryWrapper.totalEnrolled;
		accSiteWrap.totalPendingRandomizationforSite = studyAccrualSummaryWrapper.totalPendingRandomization;
		accSiteWrap.totalNotProceedingToTreatmentPhaseforSite = studyAccrualSummaryWrapper.totalNotProceedingToTreatmentPhase;
		accSiteWrap.totalRandomizedWhoProceededToTreatmentPhaseforSite = studyAccrualSummaryWrapper.totalRandomizedWhoProceededToTreatmentPhase;
		accSiteWrap.totalReceivingTreatment = studyAccrualSummaryWrapper.totalReceivingTreatment;
		accSiteWrap.totalInFollowUp = studyAccrualSummaryWrapper.totalInFollowUp;
		accSiteWrap.totalLostToFollowUpforSite = studyAccrualSummaryWrapper.totalLostToFollowUp;
		accSiteWrap.totalOffStudyforSite = studyAccrualSummaryWrapper.totalOffStudy;
		accSiteWrap.totalCompletingStudyPerProtocolforSite = studyAccrualSummaryWrapper.totalCompletingStudyPerProtocol;
		accSiteWrap.totalNotCompletingStudyPerProtocolforSite = studyAccrualSummaryWrapper.totalNotCompletingStudyPerProtocol;
	}
	
	public void prepareDataEnrolledByMonthForSite() {
		
		accSiteWrap.wrapYearListforSite = populateDataEnrolledByMonth(siteId, trial.Id, asOfDate);
	}
	
	public void prepareNotEnrolledPatientForSite() {
		
		NotEnrolledPatientWrapper notEnrolledPatientWrapper = populateNotEnrolledPatient(siteId, trial.Id, asOfDate);
		accSiteWrap.PatientIneligibleforTrial = notEnrolledPatientWrapper.totalPatientNotEligible;
		accSiteWrap.notHaveHistologicallyConfirmed = notEnrolledPatientWrapper.patientNotHistologicallyConfirmed;
		accSiteWrap.NotClinicallyRadiologicallyMeasurable = notEnrolledPatientWrapper.patientNotRadiologicallyMeasurable;
		accSiteWrap.notHadPriorCytotoxicRegimensantiCancer = notEnrolledPatientWrapper.totalPatientReceivedCytotoxicRegiments;
		accSiteWrap.notInvestigationalAgents = notEnrolledPatientWrapper.totalPatient30DaysInvestigationalAgents; 
		accSiteWrap.notHadpriorRT = notEnrolledPatientWrapper.totalPatientReceivedRadiationTherapy;
		accSiteWrap.notPatientis18yearsorolder = notEnrolledPatientWrapper.totalPatientUnder18Years;
		accSiteWrap.pregnantLactating = notEnrolledPatientWrapper.totalPatientPregnantOrLactating;
		accSiteWrap.notFerromegnaticProstheses = notEnrolledPatientWrapper.totalPatientFerromagneticProstheses;
		accSiteWrap.notPatientiswillingtohavecorebiospy = notEnrolledPatientWrapper.totalPatientNotWillingCoreBiopsy;
		accSiteWrap.notPatientiswillintohavestudyMRI = notEnrolledPatientWrapper.totalPatientNotWillingStudyMRI;
		accSiteWrap.not2Symplomaticbed = notEnrolledPatientWrapper.totalPatientHasECOGScore2;
		accSiteWrap.not3Symplomatic = notEnrolledPatientWrapper.totalPatientHasECOGScore3;
		accSiteWrap.not4Bedbound = notEnrolledPatientWrapper.totalPatientHasECOGScore4;
		accSiteWrap.not5Death = notEnrolledPatientWrapper.totalPatientHasECOGScore5;
		accSiteWrap.patienteligibleforTrial = notEnrolledPatientWrapper.totalPatientEligibleForTrialNotSign;
		accSiteWrap.patientDoesNotWantToParticipateClinicalTrial = notEnrolledPatientWrapper.totalPatientNotParticipateInClinicalTrial;
		accSiteWrap.patientNotWillingTreatedInvestigationalAgent = notEnrolledPatientWrapper.totalPatientNotWillingInInvestigationalAgent;
		accSiteWrap.patientTreatedNeoadjuvantRegimen = notEnrolledPatientWrapper.totalPatientDecidedWithNeoadjuvantRegimen;
		accSiteWrap.patientDecidedSurgeryTreatment = notEnrolledPatientWrapper.totalPatientDecidedSurgeryBeforeTreatment;
		accSiteWrap.patientTreatedAnotherClinic = notEnrolledPatientWrapper.totalPatientDecidedAtAnotherClinic;
		accSiteWrap.insuranceWillNotcoverStandardCare = notEnrolledPatientWrapper.totalPatientInsurance;
	}
	
	public void prepareDataNotProceedingTreatmentPhaseForSite() {
	
		NotProceedingTreatmentPhase notProceedingTreatmentPhase = populateDataNotProceedingTreatmentPhase(siteId, trial.Id, asOfDate);
		accSiteWrap.novelAgentCount = notProceedingTreatmentPhase.novelAgentCount;
		accSiteWrap.neoadjuvantCount = notProceedingTreatmentPhase.neoadjuvantCount;
		accSiteWrap.mammaPrinttestCount = notProceedingTreatmentPhase.mammaPrinttestCount;
		accSiteWrap.coreBiopsyCount = notProceedingTreatmentPhase.coreBiopsyCount;
		accSiteWrap.completeMRICount = notProceedingTreatmentPhase.completeMRICount;
		accSiteWrap.mPLowERPositiveCount = notProceedingTreatmentPhase.mPLowERPositiveCount;
		accSiteWrap.eligibilityCriteriaCount = notProceedingTreatmentPhase.eligibilityCriteriaCount;
		accSiteWrap.otherCount = notProceedingTreatmentPhase.otherCount;
		accSiteWrap.totalCount = notProceedingTreatmentPhase.totalCount;
		//accSiteWrap.lstOtherWrapper = notProceedingTreatmentPhase.lstOtherWrapper;
	}
	
	/*public Site__c getNewSiteId() {
		//processedIds.add(siteId);
		List<Site__c> lstSite = [select Id, Name from Site__c where Id NOT IN :processedIds order by CreatedDate asc limit 1];
		if(!lstSite.isEmpty()) {
			siteId = lstSite[0].Id;
			return lstSite[0];
		}
		siteId = null;
		return null;
	}*/
	
	public static StudyAccrualSummaryWrapper populateStudyAccrualSummaryData(Id siteId, Id trialId, Datetime asOfDate) {
		
		StudyAccrualSummaryWrapper studyAccSumWrapper = new StudyAccrualSummaryWrapper();
		
		Set<Id> patients = new Set<Id>();
		Set<Id> patientsSubmittedPreEle = new Set<Id>();
		List<PreEligibility_Checklist__c> lstPreEligiblity = [Select Id, Patient__c From PreEligibility_Checklist__c where Effective_Time__c <= :asOfDate.addDays(2) and Status__c = 'Approval Not Required'];
		for(PreEligibility_Checklist__c pe : lstPreEligiblity) {
			if(pe.Patient__c == null) continue;
			patientsSubmittedPreEle.add(pe.Patient__c);
		}
		
		studyAccSumWrapper.totalPreEligibility = patientsSubmittedPreEle.size();
		List<Registration__c> lstRegistration = [Select Id, Patient__c From Registration__c where Patient__c IN :patientsSubmittedPreEle and Status__c = 'Approval Not Required' and Trial__c =:trialId and Site__r.IsTestSite__c = false];
		if(siteId != null) {
			lstRegistration = [Select Id, Patient__c From Registration__c where Patient__c IN :patientsSubmittedPreEle and Status__c = 'Approval Not Required' and Trial__c =:trialId and Site__c = :siteId ];
		}
		
		for(Registration__c reg : lstRegistration) {
			if(reg.Patient__c == null) continue;
			patients.add(reg.Patient__c);
		}
		
		studyAccSumWrapper.totalEnrolled = patients.size();
		studyAccSumWrapper.totalNotEnrolled = patientsSubmittedPreEle.size() - patients.size();
		
		/*for(PreEligibility_Checklist__c pe : lstPreEligiblity) {
			if(pe.Patient__c != null && patients.contains(pe.Patient__c)) {
				studyAccSumWrapper.totalEnrolled++;
			} else {
				studyAccSumWrapper.totalNotEnrolled++;
			}
		}*/
		Set<Id> randomizedPatients = new Set<Id>();
		Set<Id> randomizedPatientsWithConsentSignYes = new Set<Id>();
		List<Randomization_Form__c> lstRandomization = [Select Id, Did_Patient_Sign_Treatment_Consent_Form__c, TrialPatient__c, TrialPatient__r.Patient_Id__c From Randomization_Form__c where Status__c = 'Approval Not Required' and TrialPatient__r.Patient_Id__c IN :patients and TrialPatient__r.Trial_Id__c =:trialId];
		for(Randomization_Form__c randomization : lstRandomization) {
			if(randomization.TrialPatient__r.Patient_Id__c == null) continue;
			randomizedPatients.add(randomization.TrialPatient__r.Patient_Id__c);
			if(randomization.Did_Patient_Sign_Treatment_Consent_Form__c) {
				studyAccSumWrapper.totalRandomizedWhoProceededToTreatmentPhase++;
				randomizedPatientsWithConsentSignYes.add(randomization.TrialPatient__r.Patient_Id__c);
			} else {
				studyAccSumWrapper.totalNotProceedingToTreatmentPhase++;
			}
		}
		studyAccSumWrapper.totalPendingRandomization = patients.size() - randomizedPatients.size(); 
		/*for(Registration__c reg : lstRegistration) {
			if(reg.Patient__c != null && mapRandomization.containsKey(reg.Patient__c)) {
				if(mapRandomization.get(reg.Patient__c).Did_Patient_Sign_Treatment_Consent_Form__c) {
					studyAccSumWrapper.totalRandomizedWhoProceededToTreatmentPhase++;
					patients.add(reg.Patient__c);
				} else {
					studyAccSumWrapper.totalNotProceedingToTreatmentPhase++;
				}
			} else {
				studyAccSumWrapper.totalPendingRandomization++;
			}
		}*/
		Set<Id> approvedPSSPatients = new Set<Id>();
		Set<Id> approvedOffStudyPatients = new Set<Id>();
		Set<Id> approvedFollowupPatients = new Set<Id>();
		Set<Id> approvedLostToFollowupPatients = new Set<Id>();
		Set<Id> approvedNoLongerLostFollowupPatients = new Set<Id>();
		Set<Id> approvedOffStudyWithStudyProtocolSelected = new Set<Id>();
		Set<Id> approvedOffStudyWithStudyProtocolNotSelected = new Set<Id>();
		
		List<Post_Surgaory_Summary__c> lstPostSurgery = [Select Id, TrialPatient__c, TrialPatient__r.Patient_Id__c From Post_Surgaory_Summary__c where Status__c = 'Accepted' and TrialPatient__r.Patient_Id__c IN :patients and TrialPatient__r.Trial_Id__c =:trialId];
		for(Post_Surgaory_Summary__c pss : lstPostSurgery) {
			approvedPSSPatients.add(pss.TrialPatient__r.Patient_Id__c);
		}
		
		List<Off_Study_Detail__c> lstOffStudy = [Select Id, CreatedDate, Effective_Time__c, TrialPatient__c, Status__c, Patient_completed_study_per_protocol__c, TrialPatient__r.Patient_Id__c From Off_Study_Detail__c where Status__c = 'Accepted' and TrialPatient__r.Patient_Id__c IN :patients and TrialPatient__r.Trial_Id__c =:trialId];
		for(Off_Study_Detail__c offStudy : lstOffStudy) {
			approvedOffStudyPatients.add(offStudy.TrialPatient__r.Patient_Id__c);
			if(offStudy.Patient_completed_study_per_protocol__c) {
				approvedOffStudyWithStudyProtocolSelected.add(offStudy.TrialPatient__r.Patient_Id__c);
			} else {
				approvedOffStudyWithStudyProtocolNotSelected.add(offStudy.TrialPatient__r.Patient_Id__c);
			}
		}
		
		List<Followup_Form__c> lstFollowup = [Select Id, TrialPatient__c, CreatedDate, Effective_Time__c, Status__c, TrialPatient__r.Patient_Id__c From Followup_Form__c where Status__c = 'Accepted' and TrialPatient__r.Patient_Id__c IN :patients and TrialPatient__r.Trial_Id__c =:trialId];
		for(Followup_Form__c followup : lstFollowup) {
			approvedFollowupPatients.add(followup.TrialPatient__r.Patient_Id__c);
		}
		
		List<No_Longer_lost_to_Followup__c> lstNoLongerLostToFollowup = [Select Id, TrialPatient__c, Status__c, TrialPatient__r.Patient_Id__c, Effective_Time__c, CreatedDate From No_Longer_lost_to_Followup__c where Status__c = 'Accepted' and TrialPatient__r.Patient_Id__c IN :patients and TrialPatient__r.Trial_Id__c =:trialId];
		for(No_Longer_lost_to_Followup__c noLongerLostFollowup : lstNoLongerLostToFollowup) {
			approvedNoLongerLostFollowupPatients.add(noLongerLostFollowup.TrialPatient__r.Patient_Id__c);
		}
		
		List<Lost_to_Follow_Up__c> lstLostToFollowup = [Select Id, TrialPatient__c, Status__c, TrialPatient__r.Patient_Id__c, Effective_Time__c, CreatedDate From Lost_to_Follow_Up__c where Status__c = 'Accepted' and TrialPatient__r.Patient_Id__c IN :patients and TrialPatient__r.Trial_Id__c =:trialId];
		for(Lost_to_Follow_Up__c lostToFollowup : lstLostToFollowup) {
			approvedLostToFollowupPatients.add(lostToFollowup.TrialPatient__r.Patient_Id__c);	
		}
		
		for(Id pId : randomizedPatientsWithConsentSignYes) {
			if(!approvedPSSPatients.contains(pId) && !approvedOffStudyPatients.contains(pId) && !approvedFollowupPatients.contains(pId)){
				studyAccSumWrapper.totalReceivingTreatment++;
			}
			
			if(approvedPSSPatients.contains(pId) && !approvedOffStudyPatients.contains(pId)) {
				studyAccSumWrapper.totalInFollowUp++;
			}
			
			if(approvedLostToFollowupPatients.contains(pId) && !approvedNoLongerLostFollowupPatients.contains(pId)) {
				studyAccSumWrapper.totalLostToFollowUp++;
			}
			
			if(approvedOffStudyPatients.contains(pId)) {
				studyAccSumWrapper.totalOffStudy++;
			}
			
			if(approvedOffStudyWithStudyProtocolSelected.contains(pId)) {
				studyAccSumWrapper.totalCompletingStudyPerProtocol++;
			}
			
			if(approvedOffStudyWithStudyProtocolNotSelected.contains(pId)) {
				studyAccSumWrapper.totalNotCompletingStudyPerProtocol++;
			}
			
		}
		return studyAccSumWrapper;
	}
	
	public static List<WrapYear> populateDataEnrolledByMonth(Id siteId, Id trialId, Datetime asOfDate) {
		
		List<WrapYear> wrapYearList = new List<WrapYear>();
		Map<Integer, String> monthMap = new Map<Integer, String>{1=>'Jan', 2=>'Feb', 3=>'Mar', 4=>'Apr', 5=>'May' ,6=>'Jun' ,7=>'Jul' ,8=>'Aug' ,9=>'Sep' ,10=>'Oct' ,11=>'Nov' ,12=>'Dec'};
		
		Set<Id> patients = new Set<Id>();
		List<PreEligibility_Checklist__c> lstPreEligiblity = [Select Id, Patient__c From PreEligibility_Checklist__c where Effective_Time__c <= :asOfDate.addDays(2) and Status__c = 'Approval Not Required'];
		for(PreEligibility_Checklist__c pe : lstPreEligiblity) {
			if(pe.Patient__c == null) continue;
			patients.add(pe.Patient__c);
		}
		
		List<Registration__c> lstRegistration = [Select Id, Patient__c, Screening_Informed_Consent_Date__c, Effective_Time__c From Registration__c where Patient__c IN :patients and Status__c = 'Approval Not Required' and Trial__c =:trialId and Site__r.IsTestSite__c = false];
		if(siteId != null) {
			lstRegistration = [Select Id, Patient__c ,Screening_Informed_Consent_Date__c, Effective_Time__c From Registration__c where Patient__c IN :patients and Status__c = 'Approval Not Required' and Trial__c =:trialId and Site__c = :siteId ];
		}
		patients.clear();
		Map<Integer, List<Map<Integer, Integer>>> patientYearMonth = new Map<Integer, List<Map<Integer, Integer>>>();
		for(Registration__c reg : lstRegistration) {
			if(reg.Screening_Informed_Consent_Date__c != null && reg.Effective_Time__c != null) {
				integer year = reg.Screening_Informed_Consent_Date__c.year();
				integer month = reg.Screening_Informed_Consent_Date__c.month();
				integer toDateYear = reg.Effective_Time__c.year();
				integer toDateMonth = reg.Effective_Time__c.month();
				if(!patientYearMonth.containsKey(toDateYear)) {
					patientYearMonth.put(toDateYear, new List<Map<Integer, Integer>>{new Map<Integer, Integer>(), new Map<Integer, Integer>()});
				}
				if(!patientYearMonth.containsKey(year)) {
					patientYearMonth.put(year, new List<Map<Integer, Integer>>{new Map<Integer, Integer>(), new Map<Integer, Integer>()});
				}
				
				if(patientYearMonth.containsKey(year)) {
					if(patientYearMonth.get(year)[0].containsKey(month)) {
						integer i = patientYearMonth.get(year)[0].get(month) + 1;
						system.debug('__i__'+i);
						patientYearMonth.get(year)[0].put(month, i);
					} else {
						system.debug('__First Time__');
						patientYearMonth.get(year)[0].put(month, 1);
					}
				}
				
				if(patientYearMonth.containsKey(toDateYear)) {
					if(patientYearMonth.get(toDateYear)[1].containsKey(toDateMonth)) {
						integer i = patientYearMonth.get(toDateYear)[1].get(toDateMonth) + 1;
						patientYearMonth.get(toDateYear)[1].put(toDateMonth, i);
					} else {
						patientYearMonth.get(toDateYear)[1].put(toDateMonth, 1);
					}
				} 
			}
		}
		
		for(Integer year : patientYearMonth.keySet()) {
			if(patientYearMonth.get(year)[1].isEmpty()) {
				patientYearMonth.get(year)[1].put(1, null);
			}
		}
		
		for(Integer year : patientYearMonth.keySet()) {
			WrapYear wrapYearObj = new WrapYear();
			wrapYearObj.year = year;
			system.debug('__patientYearMonth.get(year)[1].keySet()__'+patientYearMonth.get(year)[1].keySet());
			system.debug('__patientYearMonth.get(2012)__'+patientYearMonth.get(2012));
			for(Integer monthMapKey: monthMap.keySet()) {
	//===================for new patients=============================================
				WrapMonth wrapMonthObj = new WrapMonth();
				if(!patientYearMonth.get(year)[0].containsKey(monthMapKey)) {
					wrapMonthObj.month = monthMap.get(monthMapKey);
				} else {
					wrapMonthObj.month = monthMap.get(monthMapKey);
					wrapMonthObj.patientCount = patientYearMonth.get(year)[0].get(monthMapKey);
				}
				wrapYearObj.wrapMonthList.add(wrapMonthObj);
				
	//==================for toDate patients============================================
				WrapMonth wrapToDateMonthObj = new WrapMonth();
				system.debug('__monthMapKey__'+monthMapKey);
				if(!patientYearMonth.get(year)[1].containsKey(monthMapKey)) {
					wrapToDateMonthObj.month = monthMap.get(monthMapKey);
				} else {
					wrapToDateMonthObj.month = monthMap.get(monthMapKey);
					wrapToDateMonthObj.patientCount = patientYearMonth.get(year)[1].get(monthMapKey);
					system.debug('__ELSEwrapMonthObj.month__'+wrapToDateMonthObj.month);
				}
				wrapYearObj.wrapToDateMonthList.add(wrapToDateMonthObj);
			}
			wrapYearList.add(wrapYearObj);
		}
		return wrapYearList;
	}
	
	public static EnrolledByStudySite populateDataEnrolledByStudySite(Id siteId, Id trialId, Datetime asOfDate) {
		
		EnrolledByStudySite enrolledByStudySite = new EnrolledByStudySite();
		
		Set<Id> patients = new Set<Id>();
		List<PreEligibility_Checklist__c> lstPreEligiblity = [Select Id, Patient__c From PreEligibility_Checklist__c where Effective_Time__c <= :asOfDate.addDays(2) and Status__c = 'Approval Not Required'];
		for(PreEligibility_Checklist__c pe : lstPreEligiblity) {
			if(pe.Patient__c == null) continue;
			patients.add(pe.Patient__c);
		}
		
		List<Site__c> siteList = [Select s.Name, s.Id, (Select Id, CreatedDate, Patient__r.Race__c, Patient__r.Ethnicity__c, Patient__r.Age__c,Site__c, 
								Patient__c, Effective_Time__c From Registrations__r where Patient__c IN :patients and 
								Status__c = 'Approval Not Required' and Trial__c = :trialId order by Effective_Time__c) From Site__c s 
								where RecordType.Name = 'Site' and IsTestSite__c = false order by Name];
		
		if(siteId != null) {
			siteList = [Select s.Name, s.Id, (Select Id, CreatedDate, Patient__r.Race__c, Patient__r.Ethnicity__c, Patient__r.Age__c,Site__c, 
								Patient__c, Effective_Time__c From Registrations__r where Patient__c IN :patients and 
								Status__c = 'Approval Not Required' and Trial__c = :trialId order by Effective_Time__c) From Site__c s 
								where Id = :siteId and RecordType.Name = 'Site' and IsTestSite__c = false order by Name];
		}						
		
		for(Site__c siteObj : siteList) {
			enrolledByStudySite.totalEnrolledPatient += siteObj.Registrations__r.Size();
		}
								
		Integer counter = 1;
		for(Site__c siteObj : siteList) {
			WrapStudySite wrapSite = new WrapStudySite();
			wrapSite.site = siteObj;
			if(Math.mod(counter,2) != 0) {
				wrapSite.oddRowColor = '#ECECFF';
			}
			counter++;
			if(siteObj.Registrations__r != null && !siteObj.Registrations__r.isEmpty()) {
				wrapSite.enrolled = siteObj.Registrations__r.Size();
				wrapSite.firstPatientEnrolled = siteObj.Registrations__r[0].Effective_Time__c;
			}
			if(enrolledByStudySite.totalEnrolledPatient != 0){
				wrapSite.percent = (Decimal.valueOf(siteObj.Registrations__r.Size()).Divide(enrolledByStudySite.totalEnrolledPatient, 4))*100;
			}
			
			enrolledByStudySite.wrapSiteList.add(wrapSite);
		}
		return enrolledByStudySite;
	}
	
	public static StudyParticipantDemographicsWrapper populateStudyParticipantDemographics(Id siteId, Id trialId, Datetime asOfDate) {
		
		StudyParticipantDemographicsWrapper studyPartDemoWrapper = new StudyParticipantDemographicsWrapper();
		
		Set<Id> patients = new Set<Id>();
		List<PreEligibility_Checklist__c> lstPreEligiblity = [Select Id, Patient__c From PreEligibility_Checklist__c where Effective_Time__c <= :asOfDate.addDays(2) and Status__c = 'Approval Not Required'];
		for(PreEligibility_Checklist__c pe : lstPreEligiblity) {
			if(pe.Patient__c == null) continue;
			patients.add(pe.Patient__c);
		}
		
		List<Site__c> siteList = [Select s.Name, s.Id, (Select Id, CreatedDate, Patient__r.Race__c, Patient__r.Ethnicity__c, Patient__r.Age__c,Site__c, 
								Patient__c, Effective_Time__c From Registrations__r where Patient__c IN :patients and 
								Status__c = 'Approval Not Required' and Trial__c=:trialId order by Effective_Time__c) From Site__c s 
								where RecordType.Name = 'Site' and IsTestSite__c = false order by Name];
		
		if(siteId != null) {
			siteList = [Select s.Name, s.Id, (Select Id, CreatedDate, Patient__r.Race__c, Patient__r.Ethnicity__c, Patient__r.Age__c,Site__c, 
					Patient__c, Effective_Time__c From Registrations__r where Patient__c IN :patients and 
					Status__c = 'Approval Not Required' and Trial__c = :trialId order by Effective_Time__c) From Site__c s 
					where RecordType.Name = 'Site' and IsTestSite__c = false order by Name];
		}
		
		/*for(Site__c siteObj : siteList) {
			if(siteObj.Registrations__r != null) {
				studyPartDemoWrapper.totalEnrolledPatient += siteObj.Registrations__r.Size();
			}
		}*/
		
		List<Registration__c> lstRegistration = [Select Id, Patient__c From Registration__c where Patient__c IN :patients and Status__c = 'Approval Not Required' and Trial__c =:trialId ];
		if(siteId != null) {
			lstRegistration = [Select Id, Patient__c From Registration__c where Patient__c IN :patients and Status__c = 'Approval Not Required' and Trial__c =:trialId and Site__c = :siteId ];
		}
		patients.clear();
		for(Registration__c reg : lstRegistration) {
			if(reg.Patient__c == null) continue;
			patients.add(reg.Patient__c);
		}
		studyPartDemoWrapper.totalEnrolledPatient = patients.size();
		Integer totalNumberOfPatient = 0;
		Integer totalSumOfPatientAge = 0;
		List<Integer> lstPatientAge = new List<Integer>();
		integer counter = 1;
		
		for(Site__c siteObj : siteList) {
			//totalEnrolledPatient += siteObj.Registrations__r.Size();
			totalNumberOfPatient += siteObj.Registrations__r.Size();
			
			WrapStudySite wrapSite = new WrapStudySite();
			wrapSite.site = siteObj;
			
			if(Math.mod(counter,2) != 0) {
				wrapSite.oddRowColor = '#ECECFF';
			}
			counter++;
			
			/*if(studyPartDemoWrapper.totalEnrolledPatient != 0){
				wrapSite.percent = (Decimal.valueOf(siteObj.Registrations__r.Size()).Divide(studyPartDemoWrapper.totalEnrolledPatient, 4))*100;
			}*/
			/*wrapSite.enrolled = siteObj.Registrations__r.Size();
			if(studyPartDemoWrapper.totalEnrolledPatient  != 0){
				wrapSite.percent = (Decimal.valueOf(siteObj.Registrations__r.Size()).Divide(studyPartDemoWrapper.totalEnrolledPatient , 4))*100;
			}*/
			patients.clear();
			for(Registration__c RegObj : siteObj.Registrations__r) {
				patients.add(RegObj.Patient__c);
				lstPatientAge.add(Integer.valueOf(RegObj.Patient__r.Age__c));
				totalSumOfPatientAge += Integer.valueOf(RegObj.Patient__r.Age__c);
				//Setting patient count according to Race	
				if(RegObj.Patient__r.Race__c == 'American Indian or Alaska Native') {
					wrapSite.americanAlaskaRaceCount++;
				} else if(RegObj.Patient__r.Race__c == 'Asian') {
					wrapSite.asianRaceCount++;
				} else if(RegObj.Patient__r.Race__c == 'Black or African American') {
					wrapSite.blackAmericanRaceCount++;
				} else if(RegObj.Patient__r.Race__c == 'Native Hawaiian or Pacific Islander') {
					wrapSite.nativeOtherIslanderRaceCount++;
				} else if(RegObj.Patient__r.Race__c == 'White') {
					wrapSite.whiteRaceCount++;
				}
				
				//Setting patient count according to Ethnicity		
				if(RegObj.Patient__r.Ethnicity__c == 'Hispanic or Latino') {
					wrapSite.hispanicEthnicityCount++;
				} else if(RegObj.Patient__r.Ethnicity__c == 'Not Hispanic or Latino') {
					wrapSite.notHispanicEthnicityCount++;
				}
			}
			
			if(siteObj.Registrations__r != null && !siteObj.Registrations__r.isEmpty()) {
				wrapSite.enrolled = patients.Size();
				wrapSite.firstPatientEnrolled = siteObj.Registrations__r[0].Effective_Time__c;
			} else {
				wrapSite.enrolled = 0;
			}
			
			if(studyPartDemoWrapper.totalEnrolledPatient != 0){
				wrapSite.percent = (Decimal.valueOf(patients.Size()).Divide(studyPartDemoWrapper.totalEnrolledPatient, 4))*100;
			}
			
			studyPartDemoWrapper.totalAmericanAlaskaRaceCount += wrapSite.americanAlaskaRaceCount;
			studyPartDemoWrapper.totalAsianRaceCount += wrapSite.asianRaceCount;
			studyPartDemoWrapper.totalBlackAmericanRaceCount+= wrapSite.blackAmericanRaceCount;
			studyPartDemoWrapper.totalNativeOtherIslanderRaceCount += wrapSite.nativeOtherIslanderRaceCount;
			studyPartDemoWrapper.totalWhiteRaceCount += wrapSite.whiteRaceCount;
			studyPartDemoWrapper.totalHispanicEthnicityCount += wrapSite.hispanicEthnicityCount;
			studyPartDemoWrapper.totalNotHispanicEthnicityCount += wrapSite.notHispanicEthnicityCount;
			
			studyPartDemoWrapper.wrapSiteList.add(wrapSite);
		}
		
		if(totalNumberOfPatient != 0) {
			studyPartDemoWrapper.patientAvgAge = totalSumOfPatientAge/totalNumberOfPatient;
		}
		
		if(!lstPatientAge.isEmpty()) {
			lstPatientAge.sort();
			studyPartDemoWrapper.patientMinAge = lstPatientAge.get(0);
			studyPartDemoWrapper.patientMaxAge = lstPatientAge.get((lstPatientAge.Size()-1));
		}
		return studyPartDemoWrapper;
	}
	
	public static NotEnrolledPatientWrapper populateNotEnrolledPatient(Id siteId, Id trialId, Datetime asOfDate) {
		
		NotEnrolledPatientWrapper notEnrolledPatientWrapper = new NotEnrolledPatientWrapper();
		
		Set<Id> patients = new Set<Id>();
		List<PreEligibility_Checklist__c> lstPreEligiblity = [Select p.X30_Days_Investigational_Agents__c, p.SystemModstamp, p.Submitted_Date__c, p.Status__c, p.RecordTypeId, p.Reason_for_not_signing_screening_consent__c, p.Phase__c, p.Patient_signed_up_for_I_SPY2_screening__c, p.Patient_is_willing_to_have_core_biospy__c, p.Patient_is_willin_to_have_study_MRI__c, p.Patient_is_eligible_to_be_screened_for_t__c, p.Patient_is_18_years_or_older__c, p.Patient__c, p.OwnerId, p.Other_investigational_agents__c, p.Not_had_prior_RT__c, p.Non_Pregnant_Not_Lactating__c, p.Name, p.LastModifiedDate, p.LastModifiedById, p.IsDeleted, p.Id, p.Histologically_confirmed_invasive_cancer__c, p.Had_prior_cytotoxic_regimens_anticancer__c, p.Ferromegnatic_Prostheses__c,p.ECOG_Score__c, p.DCC_Comments__c, p.Cytotoxic_Regiments__c, p.Effective_Time__c, p.CreatedById, p.CompletedDate__c, p.Comments__c, p.Clinically_radiologically_measurable__c, p.CRF_Id__c, CreatedDate From PreEligibility_Checklist__c p where Effective_Time__c <= :asOfDate.addDays(2) and Status__c = 'Approval Not Required'];
		if(siteId != null) {
			List<Site__c> lstSite = [Select s.Institute__c From Site__c s where Id = :siteId];
			if(lstSite.isEmpty()) {
				lstPreEligiblity = [Select p.X30_Days_Investigational_Agents__c, p.SystemModstamp, p.Submitted_Date__c, p.Status__c, p.RecordTypeId, p.Reason_for_not_signing_screening_consent__c, p.Phase__c, p.Patient_signed_up_for_I_SPY2_screening__c, p.Patient_is_willing_to_have_core_biospy__c, p.Patient_is_willin_to_have_study_MRI__c, p.Patient_is_eligible_to_be_screened_for_t__c, p.Patient_is_18_years_or_older__c, p.Patient__c, p.OwnerId, p.Other_investigational_agents__c, p.Not_had_prior_RT__c, p.Non_Pregnant_Not_Lactating__c, p.Name, p.LastModifiedDate, p.LastModifiedById, p.IsDeleted, p.Id, p.Histologically_confirmed_invasive_cancer__c, p.Had_prior_cytotoxic_regimens_anticancer__c, p.Ferromegnatic_Prostheses__c,p.ECOG_Score__c, p.DCC_Comments__c, p.Cytotoxic_Regiments__c, p.Effective_Time__c, p.CreatedById, p.CompletedDate__c, p.Comments__c, p.Clinically_radiologically_measurable__c, p.CRF_Id__c, CreatedDate From PreEligibility_Checklist__c p where Effective_Time__c <= :asOfDate.addDays(2) and Status__c = 'Approval Not Required' and Patient__r.Institution__c = :lstSite[0].Institute__c];					
			}
		}
		for(PreEligibility_Checklist__c pe : lstPreEligiblity) {
			if(pe.Patient__c == null) continue;
			patients.add(pe.Patient__c);
		}
		
		notEnrolledPatientWrapper.totalPreEligibility = lstPreEligiblity.size();
		List<Registration__c> lstRegistration = [Select Id, Patient__c From Registration__c where Patient__c IN :patients and Status__c = 'Approval Not Required' and Trial__c =:trialId and Site__r.IsTestSite__c = false ];
		if(siteId != null) {
			lstRegistration = [Select Id, Patient__c From Registration__c where Patient__c IN :patients and Status__c = 'Approval Not Required' and Trial__c =:trialId and Site__c = :siteId ];
		}
		patients.clear();
		for(Registration__c reg : lstRegistration) {
			if(reg.Patient__c == null) continue;
			patients.add(reg.Patient__c);
		}
		
		for(PreEligibility_Checklist__c preEligibilityObj : lstPreEligiblity) {
			if(preEligibilityObj.Patient__c == null) continue;
			
			if(!patients.contains(preEligibilityObj.Patient__c)) {
				notEnrolledPatientWrapper.totalNotEnrolled++;
			}
			
			if(preEligibilityObj.Patient_is_eligible_to_be_screened_for_t__c == false) {
				notEnrolledPatientWrapper.totalPatientNotEligible++;
			}
			
			if(preEligibilityObj.Histologically_confirmed_invasive_cancer__c == false) {
				notEnrolledPatientWrapper.patientNotHistologicallyConfirmed++;
			}
			
			if(preEligibilityObj.Clinically_radiologically_measurable__c == false) {
				notEnrolledPatientWrapper.patientNotRadiologicallyMeasurable++;
			}
			
			if(preEligibilityObj.Cytotoxic_Regiments__c == false) {
				notEnrolledPatientWrapper.totalPatientReceivedCytotoxicRegiments++;
			}
			
			if(preEligibilityObj.X30_Days_Investigational_Agents__c == false) {
				notEnrolledPatientWrapper.totalPatient30DaysInvestigationalAgents++;
			}
			
			if(preEligibilityObj.Not_had_prior_RT__c == false) {
				notEnrolledPatientWrapper.totalPatientReceivedRadiationTherapy++;
			}
			
			if(preEligibilityObj.Patient_is_18_years_or_older__c == false) {
				notEnrolledPatientWrapper.totalPatientUnder18Years++;
			}
			
			if(preEligibilityObj.Non_Pregnant_Not_Lactating__c == false) {
				notEnrolledPatientWrapper.totalPatientPregnantOrLactating++;
			}
			
			if(preEligibilityObj.Ferromegnatic_Prostheses__c == false) {
				notEnrolledPatientWrapper.totalPatientFerromagneticProstheses++;
			}
			
			if(preEligibilityObj.Patient_is_willing_to_have_core_biospy__c == false) {
				notEnrolledPatientWrapper.totalPatientNotWillingCoreBiopsy++;
			}
			
			if(preEligibilityObj.Patient_is_willin_to_have_study_MRI__c == false) {
				notEnrolledPatientWrapper.totalPatientNotWillingStudyMRI++;
			}
			
			if(preEligibilityObj.ECOG_Score__c == '2-Symplomatic, <50% in bed') {
				notEnrolledPatientWrapper.totalPatientHasECOGScore2++;
			}
			
			if(preEligibilityObj.ECOG_Score__c == '3-Symplomatic, >= 50% in bed') {
				notEnrolledPatientWrapper.totalPatientHasECOGScore3++;
			}
			
			if(preEligibilityObj.ECOG_Score__c == '4-Bedbound') {
				notEnrolledPatientWrapper.totalPatientHasECOGScore4++;
			}
			
			if(preEligibilityObj.ECOG_Score__c == '5-Death') {
				notEnrolledPatientWrapper.totalPatientHasECOGScore5++;
			}
			
			if(preEligibilityObj.Patient_is_eligible_to_be_screened_for_t__c == true && preEligibilityObj.Patient_signed_up_for_I_SPY2_screening__c == false) {
				notEnrolledPatientWrapper.totalPatientEligibleForTrialNotSign++;
			}
			
			if(preEligibilityObj.Reason_for_not_signing_screening_consent__c == 'Patient does not want to participate in a clinical trial') {
				notEnrolledPatientWrapper.totalPatientNotParticipateInClinicalTrial++;
			}
			
			if(preEligibilityObj.Reason_for_not_signing_screening_consent__c == 'Patient is not willing to be treated with an investigational agent') {
				notEnrolledPatientWrapper.totalPatientNotWillingInInvestigationalAgent++;
			}
			
			if(preEligibilityObj.Reason_for_not_signing_screening_consent__c == 'Patient decided to be treated with a different neoadjuvant regimen') {
				notEnrolledPatientWrapper.totalPatientDecidedWithNeoadjuvantRegimen++;
			}
			
			if(preEligibilityObj.Reason_for_not_signing_screening_consent__c == 'Patient decided to have surgery before treatment') {
				notEnrolledPatientWrapper.totalPatientDecidedSurgeryBeforeTreatment++;
			}
			
			if(preEligibilityObj.Reason_for_not_signing_screening_consent__c == 'Patient decided to be treated at another clinic') {
				notEnrolledPatientWrapper.totalPatientDecidedAtAnotherClinic++;
			}
			
			if(preEligibilityObj.Reason_for_not_signing_screening_consent__c == 'Insurance will not cover cost of standard care') {
				notEnrolledPatientWrapper.totalPatientInsurance++;
			}
		}
		return notEnrolledPatientWrapper;
	}
	
	public static NotProceedingTreatmentPhase populateDataNotProceedingTreatmentPhase(Id siteId, Id trialId, Datetime asOfDate) {
		
		NotProceedingTreatmentPhase notProceedingTreatmentPhase = new NotProceedingTreatmentPhase();
		
		Set<Id> patients = new Set<Id>();
		List<PreEligibility_Checklist__c> lstPreEligiblity = [Select Id, Patient__c From PreEligibility_Checklist__c where Effective_Time__c <= :asOfDate.addDays(2) and Status__c = 'Approval Not Required'];
		for(PreEligibility_Checklist__c pe : lstPreEligiblity) {
			if(pe.Patient__c == null) continue;
			patients.add(pe.Patient__c);
		}
		
		List<Registration__c> lstRegistration = [Select Id, Patient__c From Registration__c where Patient__c IN :patients and Status__c = 'Approval Not Required' and Trial__c =:trialId and Site__r.IsTestSite__c = false ];
		if(siteId != null) {
			lstRegistration = [Select Id, Patient__c From Registration__c where Patient__c IN :patients and Status__c = 'Approval Not Required' and Trial__c =:trialId and Site__c = :siteId ];
		}
		patients.clear();
		for(Registration__c reg : lstRegistration) {
			if(reg.Patient__c == null) continue;
			patients.add(reg.Patient__c);
		}
		
		Map<Id, Randomization_Form__c> mapRandomization = new Map<Id, Randomization_Form__c>();
		List<Randomization_Form__c> lstRandomization = [Select Id, Did_Patient_Sign_Treatment_Consent_Form__c, TrialPatient__c, TrialPatient__r.Patient_Id__c, Other_Reason_Did_Not_Sign_Consent_Form__c, Why_Patient_Not_Signed_Consent_Form__c From Randomization_Form__c where Status__c = 'Approval Not Required' and TrialPatient__r.Patient_Id__c IN :patients and TrialPatient__r.Trial_Id__c =:trialId];
		
		Map<string,Integer> mapCount = new Map<string,Integer>();
		Set<Id> processedTrialPatients = new Set<Id>();
		for(Randomization_Form__c ran : lstRandomization){
			if(processedTrialPatients.contains(ran.TrialPatient__c)) continue;
			processedTrialPatients.add(ran.TrialPatient__c);
			if(ran.Why_Patient_Not_Signed_Consent_Form__c == 'Other' && ran.Other_Reason_Did_Not_Sign_Consent_Form__c != null){
				Integer i = mapCount.get(ran.Other_Reason_Did_Not_Sign_Consent_Form__c);
				if(mapCount.get(ran.Other_Reason_Did_Not_Sign_Consent_Form__c) != null){
					mapCount.put(ran.Other_Reason_Did_Not_Sign_Consent_Form__c,++i);
				} else { 
					mapCount.put(ran.Other_Reason_Did_Not_Sign_Consent_Form__c,1);
				}
			}
		}
		notProceedingTreatmentPhase.lstOtherWrapper = new List<OtherWrapper>();
		for(String otherMapVal : mapCount.keySet()){
			if(Math.mod(notProceedingTreatmentPhase.lstOtherWrapper.size(),2) == 0){
				OtherWrapper ow = new OtherWrapper();
				ow.otherReason = otherMapVal;
				ow.otherCount = mapCount.get(otherMapVal);
				ow.colorCode = '#ECECFF';
				notProceedingTreatmentPhase.lstOtherWrapper.add(ow);
			} else {
				OtherWrapper ow = new OtherWrapper();
				ow.otherReason = otherMapVal;
				ow.otherCount = mapCount.get(otherMapVal);
				ow.colorCode = '#FFFFFF';
				notProceedingTreatmentPhase.lstOtherWrapper.add(ow);
			}
		}
		for(Randomization_Form__c ran : lstRandomization){
			if(ran.Did_Patient_Sign_Treatment_Consent_Form__c) continue;
			
			notProceedingTreatmentPhase.totalCount++;		
			if(ran.Why_Patient_Not_Signed_Consent_Form__c == 'Decided not to have neoadjuvant chemotherapy'){
				notProceedingTreatmentPhase.neoadjuvantCount++;
			} else if(ran.Why_Patient_Not_Signed_Consent_Form__c == 'Decided not to be treated with a novel agent'){
				notProceedingTreatmentPhase.novelAgentCount++;
			} else if(ran.Why_Patient_Not_Signed_Consent_Form__c == 'Patient found to be ineligible because inability to complete MammaPrint Test'){
				notProceedingTreatmentPhase.mammaPrinttestCount++;
			} else if(ran.Why_Patient_Not_Signed_Consent_Form__c == 'Patient found to be ineligible because patient could not complete core biopsy'){
				notProceedingTreatmentPhase.coreBiopsyCount++;
			} else if(ran.Why_Patient_Not_Signed_Consent_Form__c == 'Patient found to be ineligible because patient could not complete MRI'){
				notProceedingTreatmentPhase.completeMRICount++;
			} else if(ran.Why_Patient_Not_Signed_Consent_Form__c == 'Patient found to be ineligible because they are MammaPrint Low, ER Positive, HER2 Negative'){
				notProceedingTreatmentPhase.mPLowERPositiveCount++;
			} else if(ran.Why_Patient_Not_Signed_Consent_Form__c == 'Patient found to be ineligible because they did not meet other eligibility criteria'){
				notProceedingTreatmentPhase.eligibilityCriteriaCount++;
			} else if(ran.Why_Patient_Not_Signed_Consent_Form__c == 'Other' && ran.Other_Reason_Did_Not_Sign_Consent_Form__c != null){
				notProceedingTreatmentPhase.otherCount++;
			}
		}
		return notProceedingTreatmentPhase;
	}
	
	public Pagereference viewHTML() {
		Pagereference ref = new Pagereference('/apex/TrialSummaryReportHTML');
		ref.setRedirect(false);
		return ref;	
	}
	
	public Pagereference viewPdf() {
		Pagereference ref = new Pagereference('/apex/TrialSummaryReportPDF');
		ref.setRedirect(false);
		return ref;	
	}
	
	public Pagereference viewCSV() {
		Pagereference ref = new Pagereference('/apex/TrialSummaryReportCSV');
		ref.setRedirect(false);
		return ref;	
	}
	
	class WrapYear {
		
		public Integer year{get;set;}
		public List<WrapMonth> wrapMonthList{get;set;}
		public List<WrapMonth> wrapToDateMonthList{get;set;}
		public WrapYear(){
			wrapMonthList = new List<WrapMonth>();
			wrapToDateMonthList = new List<WrapMonth>(); 
		}
	}
	
	class WrapMonth {
		
		public String month{get;set;}
		public Integer patientCount{get;set;}
		public WrapMonth() {
			patientCount = 0;
		}
	}
	
	class WrapStudySite {
		public Site__c site{get;set;}
		public Integer enrolled{get;set;}
		public Decimal percent{get;set;}
		public Datetime firstPatientEnrolled{get;set;}
		public Integer americanAlaskaRaceCount{get;set;}
		public Integer asianRaceCount{get;set;}
		public Integer blackAmericanRaceCount{get;set;}
		public Integer nativeOtherIslanderRaceCount{get;set;}
		public Integer whiteRaceCount{get;set;}
		public Integer hispanicEthnicityCount{get;set;}
		public Integer notHispanicEthnicityCount{get;set;}
		public String oddRowColor{get;set;}
		public WrapStudySite() {
			oddRowColor = '#fff';
			americanAlaskaRaceCount = 0;
			asianRaceCount = 0;
			blackAmericanRaceCount = 0;
			nativeOtherIslanderRaceCount = 0;
			hispanicEthnicityCount = 0;
			notHispanicEthnicityCount = 0;
			whiteRaceCount = 0;
			percent = 0;
			enrolled = 0;
		}
	}
	
	public class OtherWrapper{
		public String otherReason{get;set;}
		public Integer otherCount{get;set;}
		public String colorCode{get;set;}
	}
	
	public class NotProceedingTreatmentPhase {
		public Integer novelAgentCount{get;set;}
		public Integer neoadjuvantCount{get;set;}
		public Integer mammaPrinttestCount{get;set;}
		public Integer coreBiopsyCount{get;set;}
		public Integer completeMRICount{get;set;}
		public Integer mPLowERPositiveCount{get;set;}
		public Integer eligibilityCriteriaCount{get;set;}
		public Integer otherCount{get;set;}
		public Integer totalCount{get;set;}
		public List<OtherWrapper> lstOtherWrapper {get;set;}
		
		public NotProceedingTreatmentPhase() {
			novelAgentCount = 0;
			neoadjuvantCount = 0;
			mammaPrinttestCount = 0;
			coreBiopsyCount = 0;
			completeMRICount = 0;
			mPLowERPositiveCount = 0;
			eligibilityCriteriaCount = 0;
			otherCount = 0;
			totalCount = 0;
			lstOtherWrapper = new List<OtherWrapper>();
		}
	}
	
	public class EnrolledByStudySite {
		public List<WrapStudySite> wrapSiteList {get;set;}
		public Integer totalEnrolledPatient {get;set;}
		public EnrolledByStudySite() {
			wrapSiteList = new List<WrapStudySite>();  
			totalEnrolledPatient = 0;
		}
	}
	
	public class NotEnrolledPatientWrapper {
		public Integer totalPreEligibility {get;set;}
		public Integer totalNotEnrolled {get;set;}
		public Integer totalPatientNotEligible {get;set;}
		public Integer patientNotHistologicallyConfirmed{get;set;}
		public Integer patientNotRadiologicallyMeasurable{get;set;}
		public Integer totalPatientReceivedCytotoxicRegiments{get;set;}
		public Integer totalPatient30DaysInvestigationalAgents{get;set;} 
		public Integer totalPatientReceivedRadiationTherapy{get;set;} //===take value form field "Not had prior RT" in object
		public Integer totalPatientUnder18Years{get;set;}
		public Integer totalPatientPregnantOrLactating{get;set;}
		public Integer totalPatientFerromagneticProstheses{get;set;}
		public Integer totalPatientNotWillingCoreBiopsy{get;set;}
		public Integer totalPatientNotWillingStudyMRI{get;set;}
		public Integer totalPatientHasECOGScore2{get;set;}
		public Integer totalPatientHasECOGScore3{get;set;}
		public Integer totalPatientHasECOGScore4{get;set;}
		public Integer totalPatientHasECOGScore5{get;set;}
		public Integer totalPatientEligibleForTrialNotSign{get;set;} //Patients eligible for the trial but did not sign screening consent
		public Integer totalPatientNotParticipateInClinicalTrial{get;set;} //Patient did not want to participate in a clinical trial
		public Integer totalPatientNotWillingInInvestigationalAgent{get;set;} //Patient is not willing to be treated with an investigational agent
		public Integer totalPatientDecidedWithNeoadjuvantRegimen{get;set;} //Patient decided to be treated with a different neoadjuvant regimen
		public Integer totalPatientDecidedSurgeryBeforeTreatment{get;set;} //Patient decided to have surgery before treatment
		public Integer totalPatientDecidedAtAnotherClinic{get;set;} //Patient decided to be treated at another clinic
		public Integer totalPatientInsurance{get;set;} //Insurance will not cover standard of care
		public NotEnrolledPatientWrapper() {
			totalPatientNotEligible = 0;
			totalNotEnrolled = 0;
			patientNotHistologicallyConfirmed = 0;
			patientNotRadiologicallyMeasurable = 0;
			totalPatientReceivedCytotoxicRegiments = 0;
			totalPatient30DaysInvestigationalAgents = 0; 
			totalPatientReceivedRadiationTherapy = 0;
			totalPatientUnder18Years = 0;
			totalPatientPregnantOrLactating = 0;
			totalPatientFerromagneticProstheses = 0;
			totalPatientNotWillingCoreBiopsy = 0;
			totalPatientNotWillingStudyMRI = 0;
			totalPatientHasECOGScore2 = 0;
			totalPatientHasECOGScore3 = 0;
			totalPatientHasECOGScore4 = 0;
			totalPatientHasECOGScore5 = 0;
			totalPatientEligibleForTrialNotSign = 0;
			totalPatientNotParticipateInClinicalTrial = 0;
			totalPatientNotWillingInInvestigationalAgent = 0;
			totalPatientDecidedWithNeoadjuvantRegimen = 0;
			totalPatientDecidedSurgeryBeforeTreatment = 0;
			totalPatientDecidedAtAnotherClinic = 0;
			totalPatientInsurance = 0;
		}
	}
	
	public class StudyParticipantDemographicsWrapper {
		public List<WrapStudySite> wrapSiteList {get;set;}
		public Integer patientAvgAge {get;set;}
		public Integer patientMinAge {get;set;}
		public Integer patientMaxAge {get;set;}
		public Integer totalEnrolledPatient {get;set;} 
		public Integer totalAmericanAlaskaRaceCount {get;set;}
		public Integer totalAsianRaceCount {get;set;}
		public Integer totalBlackAmericanRaceCount {get;set;}
		public Integer totalNativeOtherIslanderRaceCount {get;set;}
		public Integer totalWhiteRaceCount {get;set;}
		public Integer totalHispanicEthnicityCount {get;set;}
		public Integer totalNotHispanicEthnicityCount {get;set;}
		public StudyParticipantDemographicsWrapper() {
			wrapSiteList = new List<WrapStudySite>();
			patientAvgAge = 0;
			patientMinAge = 0;
			patientMaxAge = 0;
			totalEnrolledPatient = 0; 
			totalAmericanAlaskaRaceCount = 0;
			totalAsianRaceCount = 0;
			totalBlackAmericanRaceCount = 0;
			totalNativeOtherIslanderRaceCount = 0;
			totalWhiteRaceCount = 0;
			totalHispanicEthnicityCount = 0;
			totalNotHispanicEthnicityCount = 0;
		} 
	}
	
	public class StudyAccrualSummaryWrapper {
		public Integer totalPreEligibility{get;set;} //submitted Pre-Eligibility Checklist CRF
		public Integer totalNotEnrolled{get;set;} //submitted Pre-Eligibility Checklist CRF, No submitted Registration CRF
		public Integer totalEnrolled{get;set;} //submitted Registration CRF
		public Integer totalPendingRandomization{get;set;} //submitted Registration CRF, No submitted Randomization CRF
		public Integer totalNotProceedingToTreatmentPhase{get;set;} //submitted Randomization CRF with ‘Did patient sign treatment consent form’ equal to ‘No’
		public Integer totalRandomizedWhoProceededToTreatmentPhase{get;set;} //submitted Randomization CRF with ‘Did patient sign treatment consent form’ equal to ‘Yes’
		//Below variable is for submitted Randomization CRF with ‘Did patient sign treatment consent form’ equal to ‘Yes’, No DCC approved Post-Surgery Summary CRF, No DCC approved Follow-up CRF, No DCC approved Off-Study CRF	
		public Integer totalReceivingTreatment{get;set;} 
		//Below variable is for submitted Randomization CRF with ‘Did patient sign treatment consent form’ equal to ‘Yes’, DCC approved Post-Surgery Summary CRF, No DCC approved Off-Study CRF	
		public Integer totalInFollowUp{get;set;} 
		//Below variable is for submitted Randomization CRF with ‘Did patient sign treatment consent form’ equal to ‘Yes’, DCC approved Lost to Follow-up CRF, No DCC approved No longer lost to follow-up CRF	
		public Integer totalLostToFollowUp{get;set;}
		//Below variable is for submitted Randomization CRF with ‘Did patient sign treatment consent form’ equal to ‘Yes’, DCC approved Off-Study CRF
		public Integer totalOffStudy{get;set;}
		//Below variable is for submitted Randomization CRF with ‘Did patient sign treatment consent form’ equal to ‘Yes’, DCC approved Off-Study CRF with ‘Patient completed study per protocol’ selected
		public Integer totalCompletingStudyPerProtocol{get;set;}
		//Below variable is for submitted Randomization CRF with ‘Did patient sign treatment consent form’ equal to ‘Yes’, DCC approved Off-Study CRF with ‘Patient completed study per protocol’ NOT selected
		public Integer totalNotCompletingStudyPerProtocol{get;set;}
		
		public StudyAccrualSummaryWrapper() {
			totalPreEligibility = 0;
			totalNotEnrolled = 0;
			totalEnrolled = 0;
			totalPendingRandomization = 0;
			totalNotProceedingToTreatmentPhase = 0;
			totalRandomizedWhoProceededToTreatmentPhase = 0;
			totalReceivingTreatment = 0;
			totalInFollowUp = 0;
			totalLostToFollowUp = 0;
			totalOffStudy = 0;
			totalCompletingStudyPerProtocol = 0;
			totalNotCompletingStudyPerProtocol = 0;
		}
	}
	
	public class AccrualSiteWrapper{
		public Site__c site{get;set;}
		public Integer totalPreEligibilityforSite{get;set;}
		public Integer totalNotEnrolledforSite{get;set;}
		public Integer totalEnrolledforSite{get;set;}
		public Integer totalPendingRandomizationforSite{get;set;}
		public Integer totalNotProceedingToTreatmentPhaseforSite{get;set;}
		public Integer totalRandomizedWhoProceededToTreatmentPhaseforSite{get;set;}
		public Integer totalReceivingTreatment{get;set;}
		public Integer totalInFollowUp{get;set;}
		public Integer totalLostToFollowUpforSite{get;set;}
		public Integer totalOffStudyforSite{get;set;}
		public Integer totalCompletingStudyPerProtocolforSite{get;set;}
		public Integer totalNotCompletingStudyPerProtocolforSite{get;set;}
		public List<WrapYear> wrapYearListforSite{get;set;}
		public Integer novelAgentCount{get;set;}
		public Integer neoadjuvantCount{get;set;}
		public Integer mammaPrinttestCount{get;set;}
		public Integer coreBiopsyCount{get;set;}
		public Integer completeMRICount{get;set;}
		public Integer mPLowERPositiveCount{get;set;}
		public Integer eligibilityCriteriaCount{get;set;}
		public Integer otherCount{get;set;}
		public Integer totalCount{get;set;}
		public Integer patientIneligibleforTrial{get;set;}
		public Integer notHaveHistologicallyConfirmed{get;set;}
		public Integer notClinicallyRadiologicallyMeasurable{get;set;}
		public Integer notHadPriorCytotoxicRegimensantiCancer{get;set;}
		public Integer notInvestigationalAgents{get;set;}
		public Integer pregnantLactating{get;set;}
		public Integer notFerromegnaticProstheses{get;set;}
		public Integer notHadpriorRT{get;set;}
		public Integer notPatientis18yearsorolder{get;set;}
		public Integer notPatientiswillingtohavecorebiospy{get;set;}
		public Integer notPatientiswillintohavestudyMRI{get;set;}
		public Integer not2Symplomaticbed{get;set;}
		public Integer not3Symplomatic{get;set;}
		public Integer not4Bedbound{get;set;}
		public Integer not5Death{get;set;}
		public Integer patienteligibleforTrial{get;set;}
		public Integer patientDoesNotWantToParticipateClinicalTrial{get;set;}
		public Integer patientNotWillingTreatedInvestigationalAgent{get;set;}
		public Integer patientTreatedNeoadjuvantRegimen{get;set;}
		public Integer patientDecidedSurgeryTreatment{get;set;}
		public Integer patientTreatedAnotherClinic{get;set;}
		public Integer insuranceWillNotcoverStandardCare{get;set;}
		public Integer reDir{get;set;}
		
		public AccrualSiteWrapper(){
			site = new Site__c();
			wrapYearListforSite = new List<WrapYear>();
			totalPreEligibilityforSite = 0;
			totalNotEnrolledforSite = 0;
			totalEnrolledforSite = 0;
			totalPendingRandomizationforSite = 0;
			totalNotProceedingToTreatmentPhaseforSite = 0;
			totalRandomizedWhoProceededToTreatmentPhaseforSite = 0;
			totalReceivingTreatment = 0;
			totalInFollowUp = 0;
			totalLostToFollowUpforSite = 0;
			totalOffStudyforSite = 0;
			totalCompletingStudyPerProtocolforSite = 0;
			totalNotCompletingStudyPerProtocolforSite = 0;
			
			novelAgentCount = 0;
			neoadjuvantCount = 0;
			mammaPrinttestCount = 0;
			coreBiopsyCount = 0;
			completeMRICount = 0;
			mPLowERPositiveCount = 0;
			eligibilityCriteriaCount = 0;
			otherCount = 0;
			totalCount = 0;
			
			patientIneligibleforTrial = 0;
			notHaveHistologicallyConfirmed = 0;
			notClinicallyRadiologicallyMeasurable = 0;
			notHadPriorCytotoxicRegimensantiCancer = 0;
			notInvestigationalAgents = 0;
			pregnantLactating = 0;
			notFerromegnaticProstheses = 0;
			notHadpriorRT = 0;
			notPatientis18yearsorolder = 0;
			notPatientiswillingtohavecorebiospy = 0;
			notPatientiswillintohavestudyMRI = 0;
			not2Symplomaticbed = 0;
			not3Symplomatic = 0;
			not4Bedbound = 0;
			not5Death = 0;
			patienteligibleforTrial = 0;
			patientDoesNotWantToParticipateClinicalTrial = 0;
			patientNotWillingTreatedInvestigationalAgent = 0;
			patientTreatedNeoadjuvantRegimen = 0;
			patientDecidedSurgeryTreatment = 0;
			patientTreatedAnotherClinic = 0;
			insuranceWillNotcoverStandardCare = 0;
			reDir = 0;
		}
	}
}