public with sharing class AdverseEventReportController {
	public AE_Report__c aeRep {get;set;} 
	public String ispyId1 {get;set;}
	public String ispyId2 {get;set;}
	public String ispyId3 {get;set;}
	public String ispyId4 {get;set;}
	public String ispyId5 {get;set;}
	public String ispyId6 {get;set;}
	public String ispyId7 {get;set;}
	public String ispyId8 {get;set;}
	public String ispyId9 {get;set;}
	public String ispyId10 {get;set;}
	public Boolean dataPanel {get;set;}	
	public String trialName {get;set;}
	
	//for report
	public List<SummaryWrapper> summaryList {get;set;}
	public List<AdverseEventsByPartcipantAndArm> aeList {get;set;}
	public List<Chemo_Therapy_Regimen__c> chemoRegimentList {get;set;}
	
	public List<WeeklyReportDetail> lstWeeklyReportDetails {get;set;}
	
	public Date startDate {get;set;}
	public Date endDate {get;set;}	
	
	public Boolean isReportGenerated {get;set;}
	
	public AdverseEventReportController(){
		
		//TODO: I think user has to select trial if this DCC user (running this report) is allocated to multiple trials
		
		dataPanel = true;
		aeRep = new AE_Report__c();
		trialName = 'MO-I-SPY 2 TRIAL';
		isReportGenerated = false;
		
		if(!Test.isRunningTest()) {
			if(!(getSelectSubjectIds() != null && !getSelectSubjectIds().isEmpty())) {
				if(Apexpages.currentPage().getParameters().get('sDate') != null && Apexpages.currentPage().getParameters().get('lDate') != null) {
					List<String> sDateParam = Apexpages.currentPage().getParameters().get('sDate').split('/');
					startDate = Date.newInstance(Integer.valueOf(sDateParam[2]), Integer.valueOf(sDateParam[0]), Integer.valueOf(sDateParam[1]));
					List<String> eDateParam = Apexpages.currentPage().getParameters().get('lDate').split('/');
					endDate = Date.newInstance(Integer.valueOf(eDateParam[2]), Integer.valueOf(eDateParam[0]), Integer.valueOf(eDateParam[1]));
					prepareData();
				}
			}
		}
		
	}
	
	public void prepareLinksToGenerateReport() {
		List<Trial__c> lstTrial = [select id, Name, Start_Date__c from Trial__c where Name = :trialName order by CreatedDate asc];
		if(lstTrial.isEmpty()) return;
		lstWeeklyReportDetails = new List<WeeklyReportDetail>();
		WeeklyReportDetail wrd = new WeeklyReportDetail();
		Date trialStartDate = lstTrial[0].Start_Date__c;
		System.debug('trialStartDate : '+trialStartDate);
		Date startDate = system.today().addDays(-7);
		Date endDate = system.today();
		wrd.startDate = startDate.month()+'/'+startDate.day()+'/'+startDate.year();
		wrd.endDate = endDate.month()+'/'+endDate.day()+'/'+endDate.year();
		lstWeeklyReportDetails.add(wrd);
		while(startDate > trialStartDate) {
			startDate = startDate.addDays(-7);
			endDate = endDate.addDays(-7);
			wrd = new WeeklyReportDetail();
			wrd.startDate = startDate.month()+'/'+startDate.day()+'/'+startDate.year();
			wrd.endDate = endDate.month()+'/'+endDate.day()+'/'+endDate.year();
			lstWeeklyReportDetails.add(wrd);			
		}
		
		
	}
	
	/*public static void generateReport() {
		Pagereference htmlRef = AdverseEventReportController.getHTMLFile(system.today().addDays(-7), system.today());
		Blob htmlContent = htmlRef.getContent();
		System.debug('htmlContent : '+htmlContent.toString());
	}
	
	public static Pagereference getHTMLFile(Date startDate, Date endDate) {

		Pagereference pr = new Pagereference('/apex/AdverseEventReportForHTML?sDate='+startDate+'&lDate='+endDate);
		pr.setRedirect(false);
		return pr;
	}*/
	
	public void generateReport() {
		isReportGenerated = false;
		List<Trial__c> lstTrial = [select id, Name, Start_Date__c from Trial__c where Name = :trialName order by CreatedDate asc];
		if(lstTrial.isEmpty()) return;
		startDate = lstTrial[0].Start_Date__c;
		endDate = system.today();
		
		if(!Test.isRunningTest()){
			prepareData();
			if((summaryList != null &&  summaryList.isEmpty()) 
					|| (aeList != null && !aeList.isEmpty()) 
					|| (chemoRegimentList != null && !chemoRegimentList.isEmpty())) {
				isReportGenerated = true;
			} else {
				isReportGenerated = false;
			}
		}
	}
	
	public Pagereference viewHTML(){
		
		/*if(Apexpages.currentPage().getParameters().get('sDate') != null) {
			List<String> sDateParam = Apexpages.currentPage().getParameters().get('sDate').split('/');
			startDate = Date.newInstance(Integer.valueOf(sDateParam[2]), Integer.valueOf(sDateParam[0]), Integer.valueOf(sDateParam[1]));
		} else {
			startDate = system.today().addDays(-7);
		}
		
		if(Apexpages.currentPage().getParameters().get('lDate') != null) {
			List<String> eDateParam = Apexpages.currentPage().getParameters().get('lDate').split('/');
			endDate = Date.newInstance(Integer.valueOf(eDateParam[2]), Integer.valueOf(eDateParam[0]), Integer.valueOf(eDateParam[1]));
		} else {
			endDate = system.today();
		}
		
		if(!Test.isRunningTest()) {
			prepareData();
		}
		Pagereference pr = new Pagereference('/apex/AdverseEventReportForHTML?sDate='+startDate+'&lDate='+endDate);
		//if(getSelectSubjectIds() != null && !getSelectSubjectIds().isEmpty()) {
		//	pr.setRedirect(false);
		//} else {
			pr.setRedirect(false);
		//}
		return pr;*/
		String sDate = Apexpages.currentPage().getParameters().get('sDate');
		String lDate = Apexpages.currentPage().getParameters().get('lDate');
		
		Pagereference pr = new Pagereference('/apex/AdverseEventReportForHTML?sDate='+sDate+'&lDate='+lDate);
		if(getSelectSubjectIds() != null && !getSelectSubjectIds().isEmpty()) {
			pr.setRedirect(false);
		} else {
			pr.setRedirect(true);
		}
		return pr;
	}

	public Pagereference viewPDF(){
		
		/*if(Apexpages.currentPage().getParameters().get('sDate') != null) {
			List<String> sDateParam = Apexpages.currentPage().getParameters().get('sDate').split('/');
			if(sDateParam.size() == 3)
				startDate = Date.newInstance(Integer.valueOf(sDateParam[2]), Integer.valueOf(sDateParam[0]), Integer.valueOf(sDateParam[1]));
		} else {
			startDate = system.today().addDays(-7);
		}
		
		if(Apexpages.currentPage().getParameters().get('lDate') != null) {
			List<String> eDateParam = Apexpages.currentPage().getParameters().get('lDate').split('/');
			if(eDateParam.size() == 3)
				endDate = Date.newInstance(Integer.valueOf(eDateParam[2]), Integer.valueOf(eDateParam[0]), Integer.valueOf(eDateParam[1]));
		} else {
			endDate = system.today();
		}
		
		if(!Test.isRunningTest()) {
			prepareData();
		}
		*/
		
		String sDate = Apexpages.currentPage().getParameters().get('sDate');
		String lDate = Apexpages.currentPage().getParameters().get('lDate');
		
		Pagereference pr = new Pagereference('/apex/AdverseEventReportForPDF?sDate='+sDate+'&lDate='+lDate);
		if(getSelectSubjectIds() != null && !getSelectSubjectIds().isEmpty()) {
			pr.setRedirect(false);
		} else {
			pr.setRedirect(true);
		}
		return pr;
		
	}
	
	public Pagereference viewCSV(){
		
		/*if(Apexpages.currentPage().getParameters().get('sDate') != null) {
			List<String> sDateParam = Apexpages.currentPage().getParameters().get('sDate').split('/');
			startDate = Date.newInstance(Integer.valueOf(sDateParam[2]), Integer.valueOf(sDateParam[0]), Integer.valueOf(sDateParam[1]));
		} else {
			startDate = system.today().addDays(-7);
		}
		
		if(Apexpages.currentPage().getParameters().get('lDate') != null) {
			List<String> eDateParam = Apexpages.currentPage().getParameters().get('lDate').split('/');
			endDate = Date.newInstance(Integer.valueOf(eDateParam[2]), Integer.valueOf(eDateParam[0]), Integer.valueOf(eDateParam[1]));
		} else {
			endDate = system.today();
		}
		
		if(!Test.isRunningTest()) {
			prepareData();
		}
		Pagereference pr = new Pagereference('/apex/AdverseEventReportForCSV?sDate='+startDate+'&lDate='+endDate);
		//if(getSelectSubjectIds() != null && !getSelectSubjectIds().isEmpty()) {
		//	pr.setRedirect(false);
		//} else {
			pr.setRedirect(false);
		//}
		return pr;*/
		
		String sDate = Apexpages.currentPage().getParameters().get('sDate');
		String lDate = Apexpages.currentPage().getParameters().get('lDate');
		
		Pagereference pr = new Pagereference('/apex/AdverseEventReportForCSV?sDate='+sDate+'&lDate='+lDate);
		if(getSelectSubjectIds() != null && !getSelectSubjectIds().isEmpty()) {
			pr.setRedirect(false);
		} else {
			pr.setRedirect(true);
		}
		return pr;
	}
	
	public void prepareData(){
		
		summaryList = new List<SummaryWrapper>();
		aeList = new List<AdverseEventsByPartcipantAndArm>();
		chemoRegimentList = new List<Chemo_Therapy_Regimen__c>();
		
		//TODO: Report has to be executed for ALL or Selected patients. This is not handled yet.
		//TODO: CTCAEv4 Term, ascending
		
		//Selecct the baseline and ae forms which are approved.
/*		List<BaselineSymptomsForm__c> baseLineCRFList = [Select Id, Visit_Date__c,Status__c, (select id,Resolved__c,Toxicity_Master__c,Symptom_Masters__c,Symptom_Masters__r.Name,
				Onset_Date__c,AE_End_Date__c,SAE__c,Patient_Complaint__c from Toxicities__r 
				where AE_End_Date__c >= :startDate order by Onset_Date__c asc, AE_End_Date__c asc), 
				TrialPatient__c,TrialPatient__r.Subject_Id__c from BaselineSymptomsForm__c 
				where Visit_Date__c <= :endDate and Status__c = 'Accepted' and CreatedDate >= :startDate and CreatedDate <= :endDate
				order by Visit_Date__c asc];
				
		List<AE_Detail__c> aeCRFList = [Select Id, Visit_Date__c,Status__c, 
					(select id,Resolved__c,Toxicity_Master__c,Symptom_Masters__c,Symptom_Masters__r.Name,Onset_Date__c,AE_End_Date__c,SAE__c,Patient_Complaint__c from Toxicities__r 
					where (Onset_Date__c <= :endDate OR (AE_End_Date__c = null OR AE_End_Date__c >= :startDate)) 
					order by Onset_Date__c asc, AE_End_Date__c asc), 
					TrialPatient__c,TrialPatient__r.Subject_Id__c from AE_Detail__c where Status__c = 'Accepted' and CreatedDate >= :startDate 
					and CreatedDate <= :endDate order by Visit_Date__c asc];
	*/	
		
		Set<String> subjIds = getSelectSubjectIds();
		System.debug('subjIds : '+subjIds);
		system.debug('startDate : '+startDate);
		system.debug('endDate : '+endDate);
		//Collect trial patient ids for these baseline and ae forms
		Set<Id> trialPatientIds = new Set<Id>();
		if(subjIds != null && !subjIds.isEmpty()) {
			for(BaselineSymptomsForm__c bsf : [Select Id, Visit_Date__c,Status__c, (select id,Resolved__c,Toxicity_Master__c, Toxicity_Master__r.Toxicity_Name__c, Symptom_Masters__c,Symptom_Masters__r.Name,
					Onset_Date__c,AE_End_Date__c,SAE__c,Patient_Complaint__c from Toxicities__r order by Onset_Date__c asc, AE_End_Date__c asc), 
					TrialPatient__c,TrialPatient__r.Subject_Id__c from BaselineSymptomsForm__c 
					where TrialPatient__r.Trial_Id__r.Name = :trialName and TrialPatient__r.Subject_Id__c != null and TrialPatient__r.Subject_Id__c IN :subjIds and TrialPatient__r.Site__r.IsTestSite__c = false and Status__c = 'Accepted'
					order by Visit_Date__c asc]) {
				trialPatientIds.add(bsf.TrialPatient__c);
			}
			for(AE_Detail__c ae : [Select Id, Visit_Date__c,Status__c, 
						(select id,Resolved__c,Toxicity_Master__c, Toxicity_Master__r.Toxicity_Name__c, Symptom_Masters__c,Symptom_Masters__r.Name,Onset_Date__c,AE_End_Date__c,SAE__c,Patient_Complaint__c from Toxicities__r 
						order by Onset_Date__c asc, AE_End_Date__c asc), TrialPatient__c,TrialPatient__r.Subject_Id__c from AE_Detail__c 
						where TrialPatient__r.Trial_Id__r.Name = :trialName and TrialPatient__r.Subject_Id__c != null and TrialPatient__r.Subject_Id__c IN :subjIds and TrialPatient__r.Site__r.IsTestSite__c = false and Status__c = 'Accepted' 
						order by Visit_Date__c asc]) {
				trialPatientIds.add(ae.TrialPatient__c);
			}
		} else {
			for(BaselineSymptomsForm__c bsf : [Select Id, Visit_Date__c,Status__c, (select id,Resolved__c,Toxicity_Master__c, Toxicity_Master__r.Toxicity_Name__c, Symptom_Masters__c,Symptom_Masters__r.Name,
					Onset_Date__c,AE_End_Date__c,SAE__c,Patient_Complaint__c from Toxicities__r order by Onset_Date__c asc, AE_End_Date__c asc), 
					TrialPatient__c,TrialPatient__r.Subject_Id__c from BaselineSymptomsForm__c 
					where TrialPatient__r.Trial_Id__r.Name = :trialName and TrialPatient__r.Subject_Id__c != null and TrialPatient__r.Site__r.IsTestSite__c = false and Status__c = 'Accepted' and Effective_Time__c >= :startDate and Effective_Time__c <= :endDate
					order by Visit_Date__c asc]) {
				trialPatientIds.add(bsf.TrialPatient__c);
			}
			for(AE_Detail__c ae : [Select Id, Visit_Date__c,Status__c, 
						(select id,Resolved__c,Toxicity_Master__c, Toxicity_Master__r.Toxicity_Name__c, Symptom_Masters__c,Symptom_Masters__r.Name,Onset_Date__c,AE_End_Date__c,SAE__c,Patient_Complaint__c from Toxicities__r 
						order by Onset_Date__c asc, AE_End_Date__c asc), TrialPatient__c,TrialPatient__r.Subject_Id__c from AE_Detail__c 
						where TrialPatient__r.Trial_Id__r.Name = :trialName and TrialPatient__r.Subject_Id__c !=null and TrialPatient__r.Site__r.IsTestSite__c = false and Status__c = 'Accepted' and Effective_Time__c >= :startDate 
						and Effective_Time__c <= :endDate order by Visit_Date__c asc]) {
				trialPatientIds.add(ae.TrialPatient__c);
			}
		}
		
		//baseLineCRFList.clear();
		//aeCRFList.clear();
		
		//List<Registration>
		system.debug('trialPatientIds : '+trialPatientIds);
		//Now select all baseline and ae forms for these trial patients
		//This is done to implement the requirement that to include patient in this report at least one baseline crf
		//and at least one ae form should have been accepted for that patient.
		List<BaselineSymptomsForm__c> baseLineCRFList = [Select Id, Visit_Date__c,Status__c, (select id,Resolved__c, Toxicity_Master__c, Toxicity_Master__r.Toxicity_Name__c, Symptom_Masters__c,Symptom_Masters__r.Name,Onset_Date__c,AE_End_Date__c,SAE__c,AE_ID__c,
							Patient_Complaint__c,Grade__c, Attribution__c  from Toxicities__r where (AE_End_Date__c = null or AE_End_Date__c >= :startDate) 
							order by Onset_Date__c asc, AE_End_Date__c asc), TrialPatient__c,TrialPatient__r.Subject_Id__c from BaselineSymptomsForm__c 
							where TrialPatient__c in :trialPatientIds and Effective_Time__c >= :startDate and 
							Effective_Time__c <= :endDate order by Visit_Date__c asc];
		List<AE_Detail__c> aeCRFList = [Select Id, Visit_Date__c,Status__c, (select id,Resolved__c,Toxicity_Master__c, Toxicity_Master__r.Toxicity_Name__c, Symptom_Masters__c,Symptom_Masters__r.Name,Onset_Date__c,AE_End_Date__c,SAE__c,AE_ID__c,
						Patient_Complaint__c,Grade__c, Attribution__c  from Toxicities__r where (Onset_Date__c <= :endDate and 
						(AE_End_Date__c = null OR AE_End_Date__c >= :startDate )) order by Onset_Date__c asc, AE_End_Date__c asc), TrialPatient__c,
						TrialPatient__r.Subject_Id__c from AE_Detail__c where TrialPatient__c in :trialPatientIds  and Effective_Time__c >= :startDate and 
						Effective_Time__c <= :endDate order by Visit_Date__c asc];
		
		
		//Get Randomization CRF and check that patient has “Did patient sign treatment consent?” = “Yes”."
		List<Randomization_Form__c> randomizationForms = [Select r.TrialPatient__c, r.Did_Patient_Sign_Treatment_Consent_Form__c From Randomization_Form__c r where r.TrialPatient__c in :trialPatientIds and r.Did_Patient_Sign_Treatment_Consent_Form__c = true];
		
		
		//Clearing trialPatientIds set. Because we need to consider only the patients
		//having “Did patient sign treatment consent?” = “Yes”."
		trialPatientIds.clear();
		
		//Now adding trial patient ids from Randomziation CRFs queries above.
		for(Randomization_Form__c rf : randomizationForms) {
			trialPatientIds.add(rf.TrialPatient__c);
		}
		System.debug('trialPatientIds:'+trialPatientIds);
		//List<ArmPatient__c> armPatientsList = [Select a.TrialPatient__c, a.TrialPatient__r.Subject_Id__c, a.Patient_Id__c, a.Arm_Id__r.Name, a.Arm_Id__c From ArmPatient__c a where a.TrialPatient__c in :trialPatientIds order by a.Arm_Id__r.Name asc, a.TrialPatient__r.Subject_Id__c asc];
		
		//Stores patients' subject ids for each arm
		Map<String, Set<String>> armPatients = new Map<String, Set<String>>();
		
		for(ArmPatient__c ap : [Select a.TrialPatient__c, a.TrialPatient__r.Subject_Id__c, a.Patient_Id__c, a.Arm_Id__r.Name, a.Arm_Id__c From ArmPatient__c a where a.TrialPatient__c in :trialPatientIds order by a.Arm_Id__r.Name asc, a.TrialPatient__r.Subject_Id__c asc]) {
			Set<String> subjects = null;
			if(armPatients.containsKey(ap.Arm_Id__r.Name)) {
				subjects = armPatients.get(ap.Arm_Id__r.Name);
			} else {
				subjects = new Set<String>();
				armPatients.put(ap.Arm_Id__r.Name, subjects);
			}
			subjects.add(ap.TrialPatient__r.Subject_Id__c);
		}
		
		
		///////////////////
		//In the following summary table preparation, Baseline Symptomes are not considered yet
		//////////////////
		
		Map<String, SummaryWrapper> subIdSumWrapper = new Map<String, SummaryWrapper>();
		
		SummaryWrapper grandTotal = new SummaryWrapper();
		grandTotal.armOrSubject = 'Grant Total';
		
		//TODO: sort arms based alphabatically and store them in list.
		//then iterate on that list below instead of the armPatients.keySet()  
		system.debug('armPatients : '+armPatients);
		//system.debug('armPatientsList : '+armPatientsList);
		integer index  = 1;

		//used to keep track of ae ids which are already processed		
		Set<String> uniqueAeIds = new Set<String>();			
			
		for(String arm : armPatients.keySet()) {
			
			//Following line ensures the sorting order
			boolean processArm = false;
			for(ArmPatient__c ap : [Select a.TrialPatient__c, a.TrialPatient__r.Subject_Id__c, a.Patient_Id__c, a.Arm_Id__r.Name, a.Arm_Id__c From ArmPatient__c a where a.TrialPatient__c in :trialPatientIds order by a.Arm_Id__r.Name asc, a.TrialPatient__r.Subject_Id__c asc]) {
				
				if(ap.Arm_Id__r.Name == arm) {
					processArm = true;
					break;
				}
			}
			//If you do not find any arm patient for given arm, igonre that arm processing
			if(!processArm)continue;
			
			
			SummaryWrapper sw = new SummaryWrapper();
			sw.armOrSubject = arm;
			sw.isArm = true;
			sw.rowColor = '#DBE4F0';
			summaryList.add(sw);
			
			Set<String> subjectIds = armPatients.get(arm);
			
			//create a common class instances that will store information about both baseline and AE
			List<AeBaselineCombination> allToxicitiesList = new List<AeBaselineCombination>();
			for(AE_Detail__c ae : aeCRFList) {
				AeBaselineCombination aeb = new AeBaselineCombination(ae.TrialPatient__r.Subject_Id__c, ae.Toxicities__r, ae.Visit_Date__c, 'AE');
				allToxicitiesList.add(aeb);
			}
			for(BaselineSymptomsForm__c baseline : baseLineCRFList) {
				AeBaselineCombination aeb = new AeBaselineCombination(baseline.TrialPatient__r.Subject_Id__c, baseline.Toxicities__r, baseline.Visit_Date__c, 'baseline');
				allToxicitiesList.add(aeb);
			}

			for(AeBaselineCombination ae : allToxicitiesList) {
				system.debug('armPatients.get(arm) : '+armPatients.get(arm)+'    ae.getSubjectId() : '+ae.getSubjectId());
				if(!armPatients.get(arm).contains(ae.getSubjectId())) continue;
				//for subject rows
				SummaryWrapper forSubject = null;
				if(subIdSumWrapper.containsKey(ae.getSubjectId())) {
					forSubject = subIdSumWrapper.get(ae.getSubjectId());
				} else {
					forSubject = new SummaryWrapper();
					forSubject.rowColor = '#FFFFFF';
					subIdSumWrapper.put(ae.getSubjectId(),forSubject);
					summaryList.add(forSubject);
				}
				forSubject.armOrSubject = ae.getSubjectId();
				for(Toxicity__c t: ae.getToxicities()) {
					System.debug(ae.subjectId+':'+t.AE_ID__c);
					//if(!uniqueAeIds.add(ae.subjectId+':'+t.AE_ID__c))continue;
					System.debug(ae.subjectId+':'+t.AE_ID__c+' adding');
					//process toxicity only if it wasn't processed earlier
					forSubject.totalAEs++;
					if(t.Resolved__c) {
						forSubject.resolvedAEs++;
					} else {
						forSubject.unresolvedAEs++;
					}
					if(t.SAE__c == 'Yes') {
						forSubject.possibleSAEs++;
					}
				}
				
				system.debug('forSubject : '+forSubject);
				system.debug('summaryList : '+summaryList);
				system.debug('subIdSumWrapper : '+subIdSumWrapper);
				//for arm rows
				
				if(subjectIds.contains(ae.getSubjectId())) {
					for(Toxicity__c t: ae.getToxicities()) {
						
						//if(!uniqueAeIds.add(ae.subjectId+':'+t.AE_ID__c))continue;
					
						//process toxicity only if it wasn't processed earlier
						sw.totalAEs++;
						if(t.Resolved__c) {
							sw.resolvedAEs++;
						} else {
							sw.unresolvedAEs++;
						}
						
						if(t.SAE__c == 'Yes') {
							sw.possibleSAEs++;
						}
						//For the table : Adverse Events by Participant and Treatment Arm
						AdverseEventsByPartcipantAndArm aeRow = new AdverseEventsByPartcipantAndArm();
						if(math.mod(index++, 2) == 1) {
							aeRow.rowColor = '#D2DFED';
						} else {
							aeRow.rowColor = '#FFFFFF';
						}
						aeRow.arm = arm;
						aeRow.subjectId = ae.getSubjectId();
						aeRow.ctcae = t.Toxicity_Master__r.Toxicity_Name__c;
						if(!Test.isRunningTest()) {
							aeRow.ctcaeCode = CTCAECodeManager.getCodeForSymptomAndToxicity(t.Symptom_Masters__c, t.Toxicity_Master__c);
						}
						system.debug('forSubject.armOrSubject : '+forSubject.armOrSubject);
						System.debug('t.Symptom_Masters__c : '+t.Symptom_Masters__c);
						System.debug('t.Toxicity_Master__c : '+t.Toxicity_Master__c);
						System.debug('aeRow.ctcae : '+aeRow.ctcae);
						aeRow.visitDate = ae.getVisitDate();
						aeRow.baselineSymptom = (ae.getCrfType() == 'AE')?'No' : 'Yes';
						aeRow.eventOnsetDate = t.Onset_Date__c;
						aeRow.resolved = t.Resolved__c ? 'Yes' : 'No';
						aeRow.eventEndDate = t.AE_End_Date__c;
						aeRow.eventGrade = t.Grade__c; //Commented because it is text area in object, it should be picklist
						aeRow.attribution = t.Attribution__c; //Asked to create a field called Attribution Number in toxicities object
						aeRow.sae = t.SAE__c;
						aeRow.patientComplaint = t.Patient_Complaint__c;
						
						aeList.add(aeRow);
					}
				}
			}
			
			grandTotal.totalAEs += sw.totalAEs;
			grandTotal.possibleSAEs += sw.possibleSAEs;
			grandTotal.unresolvedAEs += sw.unresolvedAEs;
			grandTotal.resolvedAEs += sw.resolvedAEs;
			
			/*Treatments Received by Participant*/
			//TODO: Add Dose modification reason number field
			System.debug('subjIds : '+subjIds);
			if(!Test.isRunningTest()) {
				if(subjIds != null && !subjIds.isEmpty()) {
					chemoRegimentList = [Select c.Dose_Mod__c, c.Total_Dose__c, c.Dose_Mod_Reason_Number__c, c.SystemModstamp, 
						c.Reason_why_patient_stopped_receiving__c, c.Prescribed_Dose__c, c.OwnerId, c.Name, c.LastModifiedDate, c.LastModifiedById, 
						c.LastActivityDate, c.IsDeleted, c.Id, c.Dose_modification__c, c.Dose_Delay__c, c.Did_patient_stop_receiving__c, c.Day__c, 
						c.CreatedDate, c.CreatedById, c.Chemo_Treatment__r.Status__c, c.Chemo_Treatment__r.Did_patient_go_off_study_treatment__c, 
						c.Chemo_Treatment__r.TrialPatient__c, c.Chemo_Treatment__r.TrialPatient__r.Subject_Id__c, c.Chemo_Treatment__r.Patient_height__c, 
						c.Chemo_Treatment__r.Patient_weight__c, c.Chemo_Treatment__r.Cycle_number__c, c.Chemo_Treatment__r.Date_of_therapy__c, 
						c.Chemo_Treatment__r.LastActivityDate, c.Chemo_Treatment__r.SystemModstamp, c.Chemo_Treatment__r.LastModifiedById, 
						c.Chemo_Treatment__r.LastModifiedDate, c.Chemo_Treatment__r.CreatedById, c.Chemo_Treatment__r.CreatedDate, c.Chemo_Treatment__r.Name, 
						c.Chemo_Treatment__r.IsDeleted, c.Chemo_Treatment__r.OwnerId, c.Chemo_Treatment__r.Id, c.Chemo_Treatment__c, c.Agent__r.Name, 
						c.Row_Color__c From Chemo_Therapy_Regimen__c c where c.Chemo_Treatment__r.TrialPatient__r.Subject_Id__c = :subjIds and c.Chemo_Treatment__r.Status__c = 'Accepted' 
						order by c.Chemo_Treatment__r.TrialPatient__r.Subject_Id__c asc, c.Chemo_Treatment__r.Date_of_therapy__c asc, c.Agent__c asc ];
				} else {
					chemoRegimentList = [Select c.Dose_Mod__c, c.Total_Dose__c, c.Dose_Mod_Reason_Number__c, c.SystemModstamp, 
						c.Reason_why_patient_stopped_receiving__c, c.Prescribed_Dose__c, c.OwnerId, c.Name, c.LastModifiedDate, c.LastModifiedById, 
						c.LastActivityDate, c.IsDeleted, c.Id, c.Dose_modification__c, c.Dose_Delay__c, c.Did_patient_stop_receiving__c, c.Day__c, 
						c.CreatedDate, c.CreatedById, c.Chemo_Treatment__r.Status__c, c.Chemo_Treatment__r.Did_patient_go_off_study_treatment__c, 
						c.Chemo_Treatment__r.TrialPatient__c, c.Chemo_Treatment__r.TrialPatient__r.Subject_Id__c, c.Chemo_Treatment__r.Patient_height__c, 
						c.Chemo_Treatment__r.Patient_weight__c, c.Chemo_Treatment__r.Cycle_number__c, c.Chemo_Treatment__r.Date_of_therapy__c, 
						c.Chemo_Treatment__r.LastActivityDate, c.Chemo_Treatment__r.SystemModstamp, c.Chemo_Treatment__r.LastModifiedById, 
						c.Chemo_Treatment__r.LastModifiedDate, c.Chemo_Treatment__r.CreatedById, c.Chemo_Treatment__r.CreatedDate, c.Chemo_Treatment__r.Name, 
						c.Chemo_Treatment__r.IsDeleted, c.Chemo_Treatment__r.OwnerId, c.Chemo_Treatment__r.Id, c.Chemo_Treatment__c, c.Agent__r.Name, 
						c.Row_Color__c From Chemo_Therapy_Regimen__c c where c.Chemo_Treatment__r.Status__c = 'Accepted' and 
						c.Chemo_Treatment__r.Effective_Time__c >= :startDate and c.Chemo_Treatment__r.Effective_Time__c <= :endDate
						order by c.Chemo_Treatment__r.TrialPatient__r.Subject_Id__c asc, c.Chemo_Treatment__r.Date_of_therapy__c asc, c.Agent__c asc ];
				}
			} else {
				chemoRegimentList = [Select c.Dose_Mod__c, c.Total_Dose__c, c.Dose_Mod_Reason_Number__c, c.SystemModstamp, 
				c.Reason_why_patient_stopped_receiving__c, c.Prescribed_Dose__c, c.OwnerId, c.Name, c.LastModifiedDate, c.LastModifiedById, 
				c.LastActivityDate, c.IsDeleted, c.Id, c.Dose_modification__c, c.Dose_Delay__c, c.Did_patient_stop_receiving__c, c.Day__c, 
				c.CreatedDate, c.CreatedById, c.Chemo_Treatment__r.Status__c, c.Chemo_Treatment__r.Did_patient_go_off_study_treatment__c, 
				c.Chemo_Treatment__r.TrialPatient__c, c.Chemo_Treatment__r.TrialPatient__r.Subject_Id__c, c.Chemo_Treatment__r.Patient_height__c, 
				c.Chemo_Treatment__r.Patient_weight__c, c.Chemo_Treatment__r.Cycle_number__c, c.Chemo_Treatment__r.Date_of_therapy__c, 
				c.Chemo_Treatment__r.LastActivityDate, c.Chemo_Treatment__r.SystemModstamp, c.Chemo_Treatment__r.LastModifiedById, 
				c.Chemo_Treatment__r.LastModifiedDate, c.Chemo_Treatment__r.CreatedById, c.Chemo_Treatment__r.CreatedDate, c.Chemo_Treatment__r.Name, 
				c.Chemo_Treatment__r.IsDeleted, c.Chemo_Treatment__r.OwnerId, c.Chemo_Treatment__r.Id, c.Chemo_Treatment__c, c.Agent__r.Name, 
				c.Row_Color__c From Chemo_Therapy_Regimen__c c where c.Chemo_Treatment__r.Status__c = 'Accepted' and 
				c.Chemo_Treatment__r.Effective_Time__c >= :startDate and c.Chemo_Treatment__r.Effective_Time__c <= :endDate
				order by c.Chemo_Treatment__r.TrialPatient__r.Subject_Id__c asc, c.Chemo_Treatment__r.Date_of_therapy__c asc, c.Agent__c asc limit 1];
			}
			String rowColor = '#D2DFED';
			for(Chemo_Therapy_Regimen__c ctr : chemoRegimentList) {
				ctr.Row_Color__c = rowColor;
				if(ctr.Row_Color__c == '#D2DFED') {
					rowColor = '#FFFFFF';
				} else {
					rowColor = '#D2DFED';
				}
			}
		}
		//now adding grand total summary so that it will appear last in the table
		summaryList.add(grandTotal);
	}
	
	public Set<String> getSelectSubjectIds() {
    	Set<String> subjIds = new Set<String>();
        if(ispyId1 != null && ispyId1 != '')
        	subjIds.add(ispyId1);
        if(ispyId2 != null && ispyId2 != '')
        	subjIds.add(ispyId2);
        if(ispyId3 != null && ispyId3 != '')
        	subjIds.add(ispyId3);
        if(ispyId4 != null && ispyId4 != '')
        	subjIds.add(ispyId4);
        if(ispyId5 != null && ispyId5 != '')
        	subjIds.add(ispyId5);
        if(ispyId6 != null && ispyId6 != '')
        	subjIds.add(ispyId6);
        if(ispyId7 != null && ispyId7 != '')
        	subjIds.add(ispyId7);
        if(ispyId8 != null && ispyId8 != '')
        	subjIds.add(ispyId8);
        if(ispyId9 != null && ispyId9 != '')
        	subjIds.add(ispyId9);
        if(ispyId10 != null && ispyId10 != '')
        	subjIds.add(ispyId10);
        return subjIds;
    }
	
	private class AeBaselineCombination {
		private String subjectId;
		private List<Toxicity__c> toxicities;
		private Date visitDate;
		private String crfType;
		
		public AeBaselineCombination(String subjectId, List<Toxicity__c> toxicities, Date visitDate, String crfType) {
			this.subjectId = subjectId;
			this.toxicities = toxicities;
			this.visitDate = visitDate;
			this.crfType = crfType;
		}
		
		public String getSubjectId() {
			return subjectId;
		}
		
		public List<Toxicity__c> getToxicities() {
			return toxicities;
		}
		
		public Date getVisitDate() {
			return visitDate;
		}
		
		public String getCrfType() {
			return crfType;	
		}
	}
	
	public class SummaryWrapper {
		public String armOrSubject {get;set;}
		public integer totalAEs {get;set;}
		public integer possibleSAEs {get;set;}
		public integer unresolvedAEs {get;set;}
		public integer resolvedAEs {get;set;}
		public boolean isArm {get;set;}
		public String rowColor {get;set;}
		
		public SummaryWrapper() {
			totalAEs = 0;
			possibleSAEs  = 0;
			unresolvedAEs = 0;
			resolvedAEs = 0;
			isArm = false;
		}
	}
	
	public class AdverseEventsByPartcipantAndArm {
		public String arm {get;set;}
		public String subjectId {get;set;}
		public String ctcae {get;set;}
		public String ctcaeCode {get;set;}
		public Date visitDate {get;set;}
		public String baselineSymptom {get;set;}
		public Date eventOnsetDate {get;set;}
		public String resolved {get;set;}
		public Date eventEndDate {get;set;}
		public String eventGrade {get;set;}
		public String attribution {get;set;}
		public String sae {get;set;}
		public String patientComplaint {get;set;}
		public String rowColor {get;set;}
	}
	
	public class TherapyWrapper {
		public String subjectId {get;set;}
		public Date dateOfTherapy {get;set;}
		public integer cycle {get;set;}
		public integer day {get;set;}
		public String agentName {get;set;}
		public double prescribedDose {get;set;}
		public double actualDose {get;set;}
		public String doseDelay {get;set;}
		public integer doseModificationPerc {get;set;}
		public String docseModReason {get;set;}
		public String offStudyTreatmentReason {get;set;}
	}
	
	public class WeeklyReportDetail {
		public String startDate {get;set;}
		public String endDate {get;set;}
	}
}