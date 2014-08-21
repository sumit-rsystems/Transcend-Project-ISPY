public with sharing class EnablePatientInPortal {

	public List<Patient_Custom__c> trialpat{get;set;}

	public List<patieWrapp> wrapList{get;set;} 	
	public Set<Id> setPatientId{get;set;}
   	public string ascDesc{get;set;}
	public string orderBy{get;set;} 
   	public String strSearch{get;set;} 
	public Map<Integer,Set<Id>> mapPageNumberSetId {get;set;}
	public Integer lastInsertPageNumber{get;set;}
	public Integer currentPageNumber{get;set;}
	public List<SelectOption> lstPageNumber{get;set;}
	public Boolean isPreviousDisable{get;set;}  
	public Boolean isNextDisable{get;set;}
	public Integer fromRecord{get;set;}  
	public Integer toRecord{get;set;}  
	public Integer numberco{get;set;}   
	public Integer totalRecord{get;set;}
	public List<Patient_Custom__c> lstCurrentpatien{get;set;}
	public Boolean hasRecords{get;set;}
	public String strSearchName{get;set;}
	public String patientId{get;set;}
	public String userDesId{get;set;} 
	public Patient_Custom__c patientEmail {get;set;} 
	Patient_Custom__c pat = new Patient_Custom__c();
	
	
	public String institution {get;set;}
	public List<SelectOption> lstInstitution {get;set;}
	public String site {get;set;}
	public String redioButtn {get;set;}
	public List<SelectOption> lstSite {get;set;}
	public List<SelectOption> redioButton {get;set;}
	public String trial {get;set;}
	public List<SelectOption> lstTrial {get;set;} 
	public boolean tableshow {get;set;}
	public String disyplay{get;set;}
	
	public Boolean isNeedAcces{get;set;}
	public Boolean isRevoke{get;set;}
	
	public EnablePatientInPortal(){
		
		isNeedAcces = true;
		isRevoke = true;
		
		tableshow = false;
		disyplay = 'none';
		lstInstitution = new List<SelectOption>();
		lstSite = new List<SelectOption>();
		redioButton = new List<SelectOption>();
		lstTrial = new List<SelectOption>();
		
		lstInstitution.add(new SelectOption('','------None------'));
		lstSite.add(new SelectOption('','------None------'));
		lstTrial.add(new SelectOption('','------None------'));
		patientEmail = new Patient_Custom__c();
		ascDesc = 'desc';
		orderBy = 'Effective_Time__c';
		loadInstitution();
	}
	public void loadInstitution() {
		List<Account> lstInst = [select Name from Account order by Name asc];
		for(Account acc : lstInst) {
			lstInstitution.add(new SelectOption(acc.Id,acc.Name));
		}
	}
	public void loadSite() {
    	
		redioButton.clear();
		redioButtn = '';
		lstSite.clear();
		lstTrial.clear();
		
		redioButton.add(new SelectOption('Need Access',' Need Access'));    
		redioButton.add(new SelectOption('Revoke','Revoke'));
		
		lstSite.add(new SelectOption('','------None------'));
		lstTrial.add(new SelectOption('','------None------'));
		List<Site__c> lstOfSite = [select Name from Site__c where Institute__c = :institution order by Name asc];
		for(Site__c site : lstOfSite) {
			lstSite.add(new SelectOption(site.Id,site.Name));
		}
		Pagination();
		tableshow = true;
		
	}
	
	public void loadTrial() {
		redioButton.clear();
		redioButton.add(new SelectOption('Need Access',' Need Access'));    
		redioButton.add(new SelectOption('Revoke','Revoke'));
		
		lstTrial.add(new SelectOption('','------None------'));
		List<Site_Trial__c> lstSiteTrial = [select Site__c, Trial__c, Trial__r.Name from Site_Trial__c where Site__c = :site order by Trial__r.Name asc];
		for(Site_Trial__c siteTrial : lstSiteTrial) {
			if(siteTrial.Trial__r.Name != null) {
				lstTrial.add(new SelectOption(siteTrial.Trial__c,siteTrial.Trial__r.Name));
			}
		}
		Pagination();
		tableshow = true;
	}
	public void loadRedioButton(){
		if(redioButtn == 'Need Access'){
			isNeedAcces = true;
			isRevoke = false;
		}else if(redioButtn == 'Revoke'){
			isNeedAcces = false;
			isRevoke = true;
		}
		Pagination();
		
	}
	public void Pagination(){
		String strQuery = 'Select isPortalEnable__c, isUserStatus__c,Last_Name__c,First_Name__c';
		String strRegQue = '';
		if(site == null && trial == null){
			strRegQue =',(Select ISPY2_Subject_Id__c,Patient__c,Trial__c,Trial__r.Name, Site__c From Registrations__r )';
		}else{
			if(site != null && site != '' || trial != null && trial != ''){
			strRegQue =',(Select ISPY2_Subject_Id__c,Patient__c,Trial__c,Trial__r.Name, Site__c From Registrations__r where ';
				if(site != null){
					strRegQue += 'Site__c = \''+site+'\'';	
				}
				if(trial != null){
					strRegQue += 'and Trial__c = \''+trial+'\'';
				}
				strRegQue += ')';
			}	
		}
		
		strQuery += strRegQue;
		strQuery += 'From Patient_Custom__c ';
		if(institution != null && institution != ''){
				strQuery += 'where Institution__c = \''+institution+'\'';
		}
		if(redioButtn == 'Need Access'){
			strQuery += 'and isPortalEnable__c = false'; 
		} 
		if(redioButtn == 'Revoke'){
			strQuery += 'and isPortalEnable__c = true';
		}
		strQuery += ' order by '+orderBy+' '+ascDesc;
		strQuery = strQuery;
		List<Patient_Custom__c> lstpatient = Database.query(strQuery);

		wrapList = new List<patieWrapp>();
			
		for(Patient_Custom__c pat : lstpatient){
			
			patieWrapp wrap = new patieWrapp();
			if(site != null || trial!= null){
				List<Registration__c> reList = pat.Registrations__r;
				if(!reList.isEmpty()){
					Registration__c re = reList[0];
					if(pat.Id == re.Patient__c){
						wrap.subjectid = re.ISPY2_Subject_Id__c;
						wrap.trialname = re.Trial__r.Name;
						wrap.patwr = pat; 
						wrapList.add(wrap);
					}
				}	
			}else{
				List<Registration__c> reList = pat.Registrations__r;
				if(!reList.isEmpty()){
					Registration__c re = reList[0];
					wrap.subjectid = re.ISPY2_Subject_Id__c;
					wrap.trialname = re.Trial__r.Name;
					
					wrap.patwr = pat; 
					wrapList.add(wrap);
				}
			}
			
		}
		system.debug('------wrapList------'+wrapList.size());
		
		if(wrapList.size() > 0){
			//BuildPagination(wrapList);
			disyplay = '';
		//	hasRecords = true;
		}
		/*
		else{
			lstCurrentpatien = new List<Patient_Custom__c>(); 
			hasRecords = false;
			isPreviousDisable = false;
			isNextDisable = false;
		}
		*/
	}
	public class patieWrapp{
		public Patient_Custom__c patwr {get;set;}
		
		public String trialname{get;set;} 
		public String subjectid{get;set;}
		public String c3{get;set;}
		
	}
/*	public void BuildPagination(List<patieWrapp> wrapList){
		setPatientId = new Set<Id>();
		mapPageNumberSetId = new Map<Integer,Set<Id>>();
		lstPageNumber = new List<SelectOption>();
		
		lastInsertPageNumber = 1;
		currentPageNumber = 1;
		isNextDisable = false;
		isPreviousDisable = false;	
		
		fromRecord = 0;
		toRecord = 0;
		numberco = wrapList.size();	
		
		for(patieWrapp wrap : wrapList){
			if(setPatientId.size() < 24){
				setPatientId.add(wrap.patwr.id);	
			}
			else{
				setPatientId.add(wrap.patwr.id);
				mapPageNumberSetId.put(lastInsertPageNumber,setPatientId);
				lastInsertPageNumber++;
				setPatientId = new Set<Id>();
			}						
		}
		if(setPatientId.size() != 0 && setPatientId.size() < 25){
			mapPageNumberSetId.put(lastInsertPageNumber,setPatientId);
		}		
		PreparePageNumberList();
		GetCurrentPatientList();
	}
	public void GetCurrentPatientList(){		
		Set<Id> setCurrentPropIds = mapPageNumberSetId.get(currentPageNumber);
		String strPropId = '(';
		for(Id id : setCurrentPropIds){
			if(strPropId == '('){
				strPropId += '\''+id+'\'';
			}
			else{
				strPropId += ','+'\''+id+'\'';
			}
		}
		strPropId += ')';
		
		String query = 'Select p.isPortalEnable__c, p.LastActivityDate, p.First_Name__c, (Select FirstName__c, LastName__c,Trial_Id__c,Trial_Id__r.Name From TrialPatients__r), (Select ISPY2_Subject_Id__c From Registrations__r) From Patient_Custom__c p';
		query += ' where Id In '+strPropId;
		query += ' order by '+orderBy+' '+ascDesc;
		lstCurrentpatien = Database.query(query);
		system.debug('-----query--'+query);
		
		/*wrapList = new List<patieWrapp>();
			
		for(Patient_Custom__c pat : lstCurrentpatien){
			patieWrapp wrap = new patieWrapp();
			system.debug('----------');
			Registration__c re = pat.Registrations__r[0];
			system.debug('---re-------'+re);
			TrialPatient__c tr = pat.TrialPatients__r[0];
			system.debug('---tr------'+tr);
			
			wrap.trialname = tr.Name;
			wrap.patwr = pat;
			wrap.subjectid = re.ISPY2_Subject_Id__c;
			wrapList.add(wrap);
		}
*/
/*		
		checkPreviousDisable();
		checkNextDisable();	
		PrintPageRecordDetail();	
	}
	*/
	
	
/*	public void PreparePageNumberList(){
		for(Integer i=1;i<=mapPageNumberSetId.size();i++){
			lstPageNumber.add(new SelectOption(string.valueof(i),string.valueof(i)));	 
		}		
	}
	public void GoToPageNumber(){
		GetCurrentPatientList();
	}
	public void GoToFirstPage(){
		currentPageNumber = 1;
		GetCurrentPatientList();	
	}
	public void GoToNextPage(){
		currentPageNumber++;
		GetCurrentPatientList();
	}
	public void GoToPreviousPage(){ 
		currentPageNumber--;
		GetCurrentPatientList();	
	}
	public void GoToLastPage(){
		currentPageNumber = mapPageNumberSetId.size();
		GetCurrentPatientList();
	}
	public void checkPreviousDisable(){
		if(currentPageNumber == 1){
			isPreviousDisable = false;	
		}			
		else{
			isPreviousDisable = true;
		}
	}
	public void checkNextDisable(){
		if(currentPageNumber == mapPageNumberSetId.size()){
			isNextDisable = false;
		}
		else{
			isNextDisable = true;
		}
	}
	public void PrintPageRecordDetail(){	
		if(currentPageNumber == mapPageNumberSetId.size() && currentPageNumber != 1){
			toRecord = numberco;
			fromRecord = ((mapPageNumberSetId.size() -1)*25) + 1; 			
		}
		else if(currentPageNumber == mapPageNumberSetId.size() && currentPageNumber == 1){
			fromRecord = 1;
			toRecord = ((mapPageNumberSetId.size() -1)*25) + mapPageNumberSetId.get(mapPageNumberSetId.size()).size();			
		}	
		else{
			fromRecord = (currentPageNumber * mapPageNumberSetId.get(currentPageNumber).size()) - 24;
			toRecord = (currentPageNumber * mapPageNumberSetId.get(currentPageNumber).size());			
		}		
	}
	*/
	public void enablePartalAccess(){
		system.debug('--------------patientId---'+patientId);
    	
    	List<Patient_Custom__c> patientList = [Select p.isUserStatus__c ,p.isPortalEnable__c,p.isUserDeActive__c,p.Email__c, p.Zip__c, Middle_Name__c, Suffix__c, Initials__c, VIP__c, p.SystemModstamp, p.Surgeon__r.Name, p.Surgeon__c, p.Study_Registration_Eligibility__c, p.Status__c, p.State__c, p.Signed_Screening__c, p.Screen_Failure_Number__c, p.SSN__c, p.RecordTypeId, p.Race__c, p.Primary_MD__r.Name, p.Primary_MD__c, p.Owner.Name, p.OwnerId, p.Name, p.Medical_Record_Number__c, p.Last_Name__c, p.LastModifiedDate, p.LastModifiedBy.Name, p.LastModifiedById, p.LastActivityDate, p.IsDeleted, p.Institution__r.Name,p.Institution__c, p.Institute_Text__c, p.Id, p.Gender__c, p.First_Name__c, p.Ethnicity__c, p.CreatedDate, p.CreatedBy.Name, p.CreatedById, p.Country_of_Birth__c, p.Country__c, p.City__c, p.Birthdate__c, p.Age__c, p.Address_Line_2__c, p.Address_Line_1__c, RecordType.Name From Patient_Custom__c p where Id = :patientId];
    	if(!patientList.isEmpty()){
    		pat = patientList[0];
    	}
    	system.debug('--------pat--------'+pat.Id);
    	system.debug('------patient.Email__c---'+patientEmail.Email__c);
    	List<User> userList = [Select u.Username,u.Email  From User u where Username =:patientEmail.Email__c];
    	system.debug('------userList---'+userList.size());
    	if(userList.size() > 0){
    			ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'This Email Already enabled in portal'));
    			
    	}else{
	    	pat.Email__c = patientEmail.Email__c;
	    	//pat.isPortalEnable__c = true;
	    	pat.isUserStatus__c = '1'; 
	    	//pat.isUserDeActive__c = false;
	    	 
	    	update pat;	 
	    	system.debug('--------pat--------'+pat);
	    	Set<id> idset = new Set<Id>();
	    	idset.add(pat.Id);
	    	PartnerPortalManager.createPartnerPortalUser(idset);
	    	ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Patient portal user creation for this patient is scheduled'));
    	}
    }
    public void DeactiviteUSer(){
    	String patienId = Apexpages.currentPage().getParameters().get('patient');
    	system.debug('--------patienId---------'+patienId);
    	set<String> idset = new set<String>();
    	List<Patient_Custom__c> patientList = [Select p.isUserStatus__c ,p.isUserDeActive__c,p.Email__c, p.Zip__c, Middle_Name__c, Suffix__c, Initials__c, VIP__c, p.SystemModstamp, p.Surgeon__r.Name, p.Surgeon__c, p.Study_Registration_Eligibility__c, p.Status__c, p.State__c, p.Signed_Screening__c, p.Screen_Failure_Number__c, p.SSN__c, p.RecordTypeId, p.Race__c, p.Primary_MD__r.Name, p.Primary_MD__c, p.Owner.Name, p.OwnerId, p.Name, p.Medical_Record_Number__c, p.Last_Name__c, p.LastModifiedDate, p.LastModifiedBy.Name, p.LastModifiedById, p.LastActivityDate, p.IsDeleted, p.Institution__r.Name,p.Institution__c, p.Institute_Text__c, p.Id, p.Gender__c, p.First_Name__c, p.Ethnicity__c, p.CreatedDate, p.CreatedBy.Name, p.CreatedById, p.Country_of_Birth__c, p.Country__c, p.City__c, p.Birthdate__c, p.Age__c, p.Address_Line_2__c, p.Address_Line_1__c, RecordType.Name,isPortalEnable__c From Patient_Custom__c p where Id = :patienId];
    	for(Patient_Custom__c patiten : patientList){
    		system.debug('-------patiten.Email__c--------'+patiten.Email__c);
    		idset.add(patiten.Email__c);
    	}
    	
    	List<User> updateUserList = new List<User>();
    	List<User> userList = [Select u.Username, u.UserType, u.UserRoleId, u.UserPreferencesTaskRemindersCheckboxDefault, u.UserPreferencesReminderSoundOff, u.UserPreferencesOptOutOfTouch, u.UserPreferencesEventRemindersCheckboxDefault, u.UserPreferencesDisableAutoSubForFeeds, u.UserPreferencesApexPagesDeveloperMode, u.UserPreferencesActivityRemindersPopup, u.UserPermissionsSFContentUser, u.UserPermissionsOfflineUser, u.UserPermissionsMobileUser, u.UserPermissionsMarketingUser, u.UserPermissionsCallCenterAutoLogin, u.UserPermissionsAvantgoUser, u.Title, u.TimeZoneSidKey, u.SystemModstamp, u.Street, u.State, u.SecurityCode__c, u.ReceivesInfoEmails, u.ReceivesAdminInfoEmails, u.ProfileId, u.PostalCode, u.Phone, u.Patient_Id__c, u.OfflineTrialExpirationDate, u.OfflinePdaTrialExpirationDate, u.Name, u.MobilePhone, u.ManagerId, u.LocaleSidKey, u.LastName, u.LastModifiedDate, u.LastModifiedById, u.LastLoginDate, u.LanguageLocaleKey, u.IsPortalEnabled, u.IsActive, u.Id, u.ForecastEnabled, u.FirstName, u.FederationIdentifier, u.Fax, u.Extension, u.EmployeeNumber, u.EmailEncodingKey, u.Email, u.Division, u.Department, u.DelegatedApproverId, u.CurrentStatus, u.CreatedDate, u.CreatedById, u.Country, u.ContactId, u.CompanyName, u.CommunityNickname, u.City, u.CallCenterId, u.Alias, u.AccountId, u.AboutMe From User u where Username IN:idset];
    	system.debug('---------userList--------'+userList.size());
    	
    	for(User us: userList){   
    		us.IsActive = false;
    		updateUserList.add(us);
    	}
    	system.debug('------updateUserList---------------'+updateUserList);
    	if(!updateUserList.isEmpty()){
    		update updateUserList;
    	}
    /*	List<Patient_Custom__c> patientListUpdate = new List<Patient_Custom__c>();
    	for(Patient_Custom__c patiten : patientList){
    		patiten.isPortalEnable__c = false;
    		patientListUpdate.add(patiten);
    	}
    	update patientListUpdate;
    	
    	system.debug('------updateUserList---------------'+updateUserList);
    	
    	*/
    	ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'User is DeActive'));
    }
}