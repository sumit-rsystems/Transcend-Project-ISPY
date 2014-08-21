public without sharing class AllPatientSummaryReport {
	
	private List<Selectoption> trials;
	private List<Selectoption> sites;
	public List<Selectoption> selectedSiteOptions {get;set;}
	public List<Selectoption> selectedTrialOptions {get;set;}
	public List<String> selectedTrials {get;set;}
	public String trialName {get;set;}
	public List<String> selectedSites {get;set;}
	public String siteName {get;set;}
	public List<ReportWrapper> lstReportWrapper {get;set;}
	public String trialLabel {get;set;}
	public Date asOfDate {get;set;}
	public Contact contact {get;set;}
	public String currentUser {get;set;}
	public boolean isErrorMsg {get;set;}
	
	public AllPatientSummaryReport() {
		selectedSiteOptions = new List<Selectoption>();
		selectedTrialOptions = new List<Selectoption>();
		selectedSites = new List<String>();
		lstReportWrapper = new List<ReportWrapper>();
		isErrorMsg = false;
		contact = new Contact();
		if(!Test.isRunningTest()) {
			contact.Birthdate = system.today();
		}
		List<Profile> lstProfile = [select Id, Name from Profile where Id = :Userinfo.getProfileId()];
		if(!lstProfile.isEmpty()) {
			currentUser = lstProfile[0].Name;
		}
	}
	
	public List<Selectoption> getSites() {
		//siteId = '';
		List<Site__c> lstSite = [select id, Name from Site__c where RecordType.Name != 'Lab' and IsTestSite__c = false order by Name asc];
		
		Set<Id> siteIds = new Set<Id>();
		if(currentUser == 'Site User') {
			List<InstitutionUser__c> lstInstUser = [Select i.User__c, i.Site__c From InstitutionUser__c i where User__c = :Userinfo.getUserId()];
			for(InstitutionUser__c instUser : lstInstUser) {
				siteIds.add(instUser.Site__c);
			}
			lstSite = [select id, Name from Site__c where Id IN :siteIds and RecordType.Name != 'Lab' and IsTestSite__c = false order by Name asc];
			if(lstSite.size() == 1) {
				selectedSites.add(lstSite[0].Id);
				siteName = lstSite[0].Name;
			}
		}
		
		List<Selectoption> sitePickList = new List<Selectoption>();
		//sitePickList.add(new Selectoption('', '----None----'));
		for(Site__c site : lstSite) {
			sitePickList.add(new Selectoption(site.Id, site.Name));
		}
		return sitePickList;
	}
	
	public void setSites(List<Selectoption> sites) {
		this.sites = sites;		
	}
	
	public List<Selectoption> getTrials() {
		
		trials = new List<Selectoption>();
		selectedTrials = new List<String>();
		selectedSites = new List<String>();
		if(selectedSiteOptions.isEmpty()) {
			selectedTrialOptions.clear();
		} else {
			for(Selectoption so : selectedSiteOptions) {
				selectedSites.add(so.getValue());	
			}
			for(Selectoption so : selectedTrialOptions) {
				selectedTrials.add(so.getValue());	
			}
		}
		
		Set<String> selectedTrialSet = new Set<String>();
		selectedTrialSet.addAll(selectedTrials);
		
		system.debug('selectedSites : '+selectedSites);
		List<Site_Trial__c> lstSiteTrails = [Select s.Trial__c, s.Trial__r.Name, s.Site__c From Site_Trial__c s where Site__c IN :selectedSites and Site__r.IsTestSite__c = false];
		selectedTrials.clear();
		//List<Site_Trial__c> lstSiteTrails = [Select s.Trial__c, s.Trial__r.Name, s.Site__c From Site_Trial__c s];
		Set<Id> trialIds = new Set<Id>();
		if(currentUser == 'Institute Level Admin') {
			List<InstitutionUser__c> lstInstUser = [Select i.User__c, i.Site__c, i.Institution__c, i.Trial__c From InstitutionUser__c i where User__c = :Userinfo.getUserId()];
			for(InstitutionUser__c instUser : lstInstUser) {
				trialIds.add(instUser.Trial__c);
			}
			lstSiteTrails = [Select s.Trial__c, s.Trial__r.Name, s.Site__c From Site_Trial__c s where Trial__c IN :trialIds];
		}
		
		List<Selectoption> trialPickList = new List<Selectoption>();
		//trialPickList.add(new Selectoption('', '----None----'));
		Set<Id> duplicateTrials = new Set<Id>();
		Set<Id> allTrials = new Set<Id>();
		for(Site_Trial__c st : lstSiteTrails) {
			allTrials.add(st.Trial__c);
			if(selectedTrialSet.contains(st.Trial__c)) continue;
			if(!duplicateTrials.contains(st.Trial__c)) {
				trialPickList.add(new Selectoption(st.Trial__c, st.Trial__r.Name));
				duplicateTrials.add(st.Trial__c);
			}
		}
		
		if(duplicateTrials.size() == 1) {
			trialLabel = lstSiteTrails[0].Trial__r.Name;
			selectedTrials.add(lstSiteTrails[0].Trial__c);
		}
		List<Selectoption> lstSOP = new List<Selectoption>();
		for(Selectoption so : selectedTrialOptions) {
			if(allTrials.contains(so.getValue())) {
				lstSOP.add(so);
			}
		}
		selectedTrialOptions.clear();
		selectedTrialOptions.addAll(lstSOP);
		return trialPickList;
	}
	
	public void setTrials(List<Selectoption> trials) {
		this.trials = trials;		
	}
	
	public Pagereference generateReport() {
		
		//selectedSiteOptions
		//selectedTrialOptions
		if(selectedTrialOptions.isEmpty()) {
			ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Please select Trials.');
            ApexPages.addMessage(myMsg);
			return null;
		}
		selectedSites = new List<String>();
		selectedTrials = new List<String>();
		
		for(Selectoption so : selectedSiteOptions) {
			selectedSites.add(so.getValue());	
		}
		
		for(Selectoption so : selectedTrialOptions) {
			selectedTrials.add(so.getValue());	
		}
		
		System.debug('contact.Birthdate : '+contact.Birthdate);
		List<Trial__c> lstTrial = [select id, Name from Trial__c where id IN :selectedTrials];
		if(lstTrial.isEmpty()) return null;
		trialName = '';
		for(Trial__c t : lstTrial) {
			trialName += t.Name+', ';
		}
		if(trialName != null) {
			trialName = trialName.substring(0,trialName.length()-2);
		}
		if(contact.Birthdate == null) contact.Birthdate = System.today();
		asOfDate = contact.Birthdate;
		lstReportWrapper = new List<ReportWrapper>();
		System.debug('selectedTrials : '+selectedTrials);
		System.debug('selectedSites : '+selectedSites);
		System.debug('asOfDate : '+asOfDate.addDays(2));
		List<TrialPatient__c> lstTrialPatient = [Select t.Trial_Id__r.Name, t.Subject_Id__c, t.Site__r.Short_Name__c, t.Patient_Id__r.Zip__c, t.Patient_Id__r.Race__c, 
												t.Patient_Id__r.Gender__c, t.Patient_Id__r.Ethnicity__c, t.Patient_Id__r.Birthdate__c, t.Patient_Id__c, 
												(Select Registration_Date__c, Screening_Informed_Consent_Date__c From Registrations__r where Status__c = 'Approval Not Required' order by LastModifiedDate desc limit 1), 
												(Select Consent_Signed_Date__c, Other_Reason_Did_Not_Sign_Consent_Form__c, Did_Patient_Sign_Treatment_Consent_Form__c, 
												Why_Patient_Not_Signed_Consent_Form__c From Randomization_Forms__r where Status__c = 'Approval Not Required') From TrialPatient__c t 
												where Site__r.IsTestSite__c = false and Trial_Id__c IN :selectedTrials and Site__c IN :selectedSites and CreatedDate <= :asOfDate.addDays(2) and Subject_Id__c != null
												order by Trial_Id__r.Name asc, Subject_Id__c asc];
		
		if(currentUser == 'Institute Level Admin') {
			lstTrialPatient = [Select t.Trial_Id__r.Name, t.Subject_Id__c, t.Site__r.Short_Name__c, t.Patient_Id__r.Zip__c, t.Patient_Id__r.Race__c, 
							t.Patient_Id__r.Gender__c, t.Patient_Id__r.Ethnicity__c, t.Patient_Id__r.Birthdate__c, t.Patient_Id__c, 
							(Select Registration_Date__c, Screening_Informed_Consent_Date__c From Registrations__r where Status__c = 'Approval Not Required' order by LastModifiedDate desc limit 1), 
							(Select Consent_Signed_Date__c, Other_Reason_Did_Not_Sign_Consent_Form__c, Did_Patient_Sign_Treatment_Consent_Form__c, 
							Why_Patient_Not_Signed_Consent_Form__c From Randomization_Forms__r where Status__c = 'Approval Not Required') From TrialPatient__c t 
							where Site__r.IsTestSite__c = false and Trial_Id__c IN :selectedTrials and CreatedDate <= :asOfDate.addDays(2) and Subject_Id__c != null
							order by Trial_Id__r.Name asc, Subject_Id__c asc];
		}
		
		for(TrialPatient__c tp : lstTrialPatient) {
			
			if(tp.Registrations__r.isEmpty()) continue;			
			ReportWrapper rw = new ReportWrapper();
			rw.trial = tp.Trial_Id__r.Name; 
			rw.ispy2_id = tp.Subject_Id__c;
			rw.trial_site = tp.Site__r.Short_Name__c; 
			rw.screening_consent_date = tp.Registrations__r[0].Screening_Informed_Consent_Date__c;
			rw.reg_date = tp.Registrations__r[0].Registration_Date__c;
			if(!tp.Randomization_Forms__r.isEmpty()) {
				if(tp.Randomization_Forms__r[0].Did_Patient_Sign_Treatment_Consent_Form__c) {
					if(tp.Randomization_Forms__r[0].Consent_Signed_Date__c != null) {
						Date csd = tp.Randomization_Forms__r[0].Consent_Signed_Date__c;
						rw.treatment_consent_date = String.valueOf(csd.month())+'/'+String.valueOf(csd.day())+'/'+String.valueOf(csd.year());
					} else {
						rw.treatment_consent_date = '';
					}
					//rw.treatment_consent_date = tp.Randomization_Forms__r[0].Consent_Signed_Date__c!=null?String.valueOf(tp.Randomization_Forms__r[0].Consent_Signed_Date__c):'';
					rw.reason_not_signed_consent = 'NA';		
				} else {
					rw.treatment_consent_date = 'No';
					rw.reason_not_signed_consent = tp.Randomization_Forms__r[0].Why_Patient_Not_Signed_Consent_Form__c=='Other'?'Other Reason - '+tp.Randomization_Forms__r[0].Other_Reason_Did_Not_Sign_Consent_Form__c:tp.Randomization_Forms__r[0].Why_Patient_Not_Signed_Consent_Form__c;
				}
			} else {
				rw.treatment_consent_date = 'Screening';
				rw.reason_not_signed_consent = 'NA';
			}
			rw.gender = tp.Patient_Id__r.Gender__c;
			rw.race = tp.Patient_Id__r.Race__c;
			rw.ethnicity = tp.Patient_Id__r.Ethnicity__c; 
			rw.zip = tp.Patient_Id__r.Zip__c;
			rw.dob = tp.Patient_Id__r.Birthdate__c;
			lstReportWrapper.add(rw);
		}
		if(lstReportWrapper.isEmpty()) {
			isErrorMsg = true;
		} else {
			isErrorMsg = false;
		}
		return null;	
	}
	
	public Pagereference redirectNewPage() {
		String format = Apexpages.currentPage().getParameters().get('format');
		Pagereference ref = null;
		if(format == 'HTML') {
			ref = new Pagereference('/apex/AllPatientSummaryReportHTML');
		} else if(format == 'PDF') {
			ref = new Pagereference('/apex/AllPatientSummaryReportPDF');
		} else if(format == 'CSV') {
			ref = new Pagereference('/apex/AllPatientSummaryReportCSV');
		}
		ref.setRedirect(false);
		return ref;	
	}
	
	public class ReportWrapper {
		public String trial {get;set;}
		public String ispy2_id {get;set;}
		public String trial_site {get;set;}
		public Date screening_consent_date {get;set;}
		public Date reg_date {get;set;}
		public String treatment_consent_date {get;set;}
		public String reason_not_signed_consent {get;set;}
		public String gender {get;set;}
		public String race {get;set;}
		public String ethnicity {get;set;}
		public String zip {get;set;}
		public Date dob {get;set;}
		
	}
}