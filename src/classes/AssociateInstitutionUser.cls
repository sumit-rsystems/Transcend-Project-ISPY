public with sharing class AssociateInstitutionUser {
	
	public String selectInstitutions{get;set;}
	public String selectSite{get;set;}
	public String selectusers{get;set;}
	
	public List<SelectOption> Institution{get;set;}
	public List<SelectOption> site{get;set;}
	
	public Boolean toShowTable{get;set;}
	public Boolean toShowTrial{get;set;}
	
	public List<User> lstUser{get;set;}
	public List<Site_Trial__c> lstSiteTrial{get;set;}
	public List<TrialWrapper> lstTrialWrapper{get;set;}
	public List<wrapperUsers> lstwrapperUsers{get;set;}
	public Boolean isUserTrialError{get;set;}
	public Boolean isNull{get;set;}
	public List<String> userLstWithoutTrial{get;set;}
	public Boolean IsUserAssociated {get;set;}
	public Boolean forInst {get;set;}
	public Boolean forSite {get;set;}
	public String associationMsg {get;set;}
	public boolean showUser {get;set;}
	public String errorMsg {get;set;}
	public String InsName{get; set;}
	public String InsId{get; set;}
	public String SitName{get; set;}
	public String siteId{get; set;}
	public boolean isSingleSite {get;set;}
	public String singleSiteName{get; set;}
	public AssociateInstitutionUser(){
		isSingleSite = false;
		toShowTable = false;
		toShowTrial = false;
		isUserTrialError = false;
		isNull = false;
		//forInst = false;
		InsName = ApexPages.currentPage().getParameters().get('InstName');
		if(InsName != null) {
			selectInstitutions = InsName;
		}
		InsId = ApexPages.currentPage().getParameters().get('InstId');
		if(InsId != null) {
			selectInstitutions = InsId;
		}
		SitName = ApexPages.currentPage().getParameters().get('SiteName');
		siteId = ApexPages.currentPage().getParameters().get('siteId');
		Institution = new List<SelectOption>();
		site = new List<SelectOption>();
		List<RecordType> lstRecType = [select Id,Name,SobjectType from RecordType where SobjectType = 'Account' and Name = 'Institution'];
		List<Account> lstInstitution = [select id,Name,RecordTypeId from Account where RecordTypeId = :lstRecType[0].Id];
		List<Site__c> lstSite = [select Id,Name,Institute__c,RecordType.Name from Site__c where Institute__c =: selectInstitutions];
		if(lstSite.size() > 0){
			forInst = false;
		} else {
			forInst = true;
		}
		if(SitName != null && SitName != ''){
			forSite = false;
			showUser = true;
			//getUserRec();
		} else {
			forSite = true;
		}
		SelectOption option1 = new SelectOption('','--None--');
		site.add(option1);
		for(Site__c st : lstSite){
			option1 = new SelectOption(st.Id,st.Name+'('+st.RecordType.Name+')');
			site.add(option1);
		}
		
		SelectOption option = new SelectOption('','--None--');
		//SelectOption option1 = new SelectOption('','--None--');
		Institution.add(option);
		//site.add(option1);
		for(Account ins : lstInstitution){
			 option = new SelectOption(ins.Id,ins.Name);
			 Institution.add(option);
		}
		if(siteId != null && siteId != ''){
			selectSite = siteId;
			getSiteRec();
		}
		showUser = true;
		system.debug('showUser :'+showUser);
		system.debug('lstSite.size() : '+lstSite.size());
		if(lstSite.size() == 1) {
			singleSiteName = lstSite[0].Name;
			isSingleSite = true;
			selectSite = lstSite[0].Id;
			getSiteRec();
		} else {
			isSingleSite = false;
		}
		
	}
	
	public void getSiteRec(){
		
		site = new List<Selectoption>();
		set<Id> setSite = new set<Id>();
		SelectOption option1 = new SelectOption('','--None--');
		site.add(option1);
		List<RecordType> lstRecType = [select Id,Name,SobjectType from RecordType where SobjectType = 'Site__c' and (Name = 'Site' or Name = 'Lab')];
		List<Site__c> lstSite = [select RecordType.Name, RecordTypeId, id,Institute__c,Name from Site__c where Institute__c = : selectInstitutions and (RecordTypeId = :lstRecType[0].Id or RecordTypeId = :lstRecType[1].Id)];
		for(Site__c st : lstSite){
			option1 = new SelectOption(st.Id,st.Name+'('+st.RecordType.Name+')');
			site.add(option1);
		}
		showUser = true;
		system.debug('showUser :'+showUser);
		if(siteId != null && siteId != ''){
			selectSite = siteId;
		}
		getUserRec();
	}
	
	
	public void getUserRec(){ 
		IsUserAssociated = false;
		showUser = true;
		system.debug('showUser :'+showUser);
		//List<User> lstUser1 = [select Id from User];
		set<Id> lstUserId = new set<Id>();
		set<Id> lstUserId1 = new set<Id>();
		Map<Id,List<Id>> userTrialMap = new Map<Id,List<Id>>();
		List<InstitutionUser__c> lstInstUser = [select id,Institution__c,User__c,Trial__c from InstitutionUser__c];
		List<InstitutionUser__c> lstInstUser1 = [select id,Institution__c,User__c,Trial__c from InstitutionUser__c where Institution__c = :selectInstitutions and Site__c =: selectSite];
		for(InstitutionUser__c insUser : lstInstUser){
			lstUserId.add(insUser.User__c);
			if(userTrialMap.containsKey(insUser.User__c)) {
				userTrialMap.get(insUser.User__c).add(insUser.Trial__c);
			} else {
				List<Id> trials = new List<Id>();
				trials.add(insUser.Trial__c);
				userTrialMap.put(insUser.User__c,trials);
			}
		}
		
		for(InstitutionUser__c insUser1 : lstInstUser1){
			lstUserId1.add(insUser1.User__c);
			
		}
		system.debug('selectInstitutions  :'+selectInstitutions);
		system.debug('userTrialMap : '+userTrialMap);
		lstwrapperUsers = new List<wrapperUsers>();
		System.debug('------lstUserId------>'+lstUserId.size());
		System.debug('------lstUserId------>'+lstUserId);
		
		List<Profile> lstProfId = new List<Profile>();
		if(selectSite == null || selectSite == '') { 
			showUser = false;
			return;
		}
		List<Site__c> lstSite = [select id,RecordTypeId,Institute__c,Name from Site__c where Id = : selectSite];
		
		List<RecordType> lstRecType = [select Id,Name,SobjectType from RecordType where Id = :lstSite[0].RecordTypeId];
		if(lstRecType[0].Name == 'Site') {
			lstProfId = [Select p.Name, p.Id From Profile p where Name = 'Site User' or Name = 'New User'];
		} else if(lstRecType[0].Name == 'Lab') {
			lstProfId = [Select p.Name, p.Id From Profile p where Name = 'Lab User' or Name = 'Lab Technician' or Name = 'Lab Supervisor' or Name = 'New User'];
		}
		Set<Id> proSet = new Set<Id>();
		for(Profile pro : lstProfId) {
			proSet.add(pro.Id);
		}
		system.debug('__lstUserId__'+lstUserId);
		system.debug('__lstUserId1__'+lstUserId1);
		system.debug('__proSet__'+proSet);
		lstUser = [select Id,Name,FirstName,Lastname,Email,IsActive,ProfileId from User where Id NOT IN :lstUserId and IsActive = true and ProfileId IN :proSet Order by CreatedDate desc];
		List<User> lstUser1 = [select Id,Name,FirstName,Lastname,Email,IsActive,ProfileId from User where Id IN :lstUserId1 and IsActive = true and ProfileId IN :proSet Order by CreatedDate desc];
		system.debug('__lstUser__'+lstUser);
		system.debug('__lstUser1__'+lstUser1);
		if(lstUser != null && lstUser1 != null) {
			lstUser.addAll(lstUser1);
		} else if(lstUser == null && lstUser1 != null) {
			lstUser = lstUser1;
		}
		lstSiteTrial = [select id,Site__c,Trial__c from Site_Trial__c where Site__c = : selectSite];
		set<Id> setTrial = new set<Id>();
		for(Site_Trial__c stTr : lstSiteTrial){
			setTrial.add(stTr.Trial__c);
		}
		lstTrialWrapper = new List<TrialWrapper>();
		List<Trial__c> lstTrial = [select id,Name from Trial__c where Id IN : setTrial];
		for(Trial__c tr : lstTrial){
			TrialWrapper trialWrapper = new TrialWrapper();
			trialWrapper.trialLabel = tr.Name;
			trialWrapper.trialId = tr.Id;
			lstTrialWrapper.add(trialWrapper);
		}
		system.debug('__lstUser__'+lstUser);
		for(User u : lstUser){
			wrapperUsers lstwrapUsers = new wrapperUsers();
			system.debug('__lstUserId.contains(u.Id)__'+lstUserId.contains(u.Id));
			if(lstUserId != null && lstUserId.contains(u.Id)) {
				lstwrapUsers.ischecked = true;	
			} else {
				lstwrapUsers.ischecked = false;
			}
			lstwrapUsers.wrapUser = u;
			System.debug('----userLstWithoutTrial-after--:'+userLstWithoutTrial);
			if(userLstWithoutTrial!=null) {
				for(String tmpLstObj : userLstWithoutTrial) {
					
					System.debug('--tmpLstObj-:'+tmpLstObj+'--u.Id---:'+u.Id);
					if(tmpLstObj == u.Id) {
						lstwrapUsers.ischecked = true;
						lstwrapUsers.isTrErrorShow = true;
					}
				}
			}
			
			//lstwrapUsers.wrapTrial = lstTrialWrapper;
			system.debug('lstTrialWrapper : '+lstTrialWrapper);
			lstwrapUsers.wrapTrial = new List<TrialWrapper>();
			for(TrialWrapper tw : lstTrialWrapper) {
				TrialWrapper tw1 = new TrialWrapper();
				tw1.trialId = tw.trialId;
				tw1.isTrail = tw.isTrail;
				tw1.trialLabel = tw.trialLabel;
				lstwrapUsers.wrapTrial.add(tw1);
			}
			
			lstwrapperUsers.add(lstwrapUsers);
			
				
			}
			for(wrapperUsers wu : lstwrapperUsers) {
				List<Id> tIds1 = userTrialMap.get(wu.wrapUser.Id);
				system.debug('tIds1 : '+tIds1);
				wu.ischecked = false;
				if(tIds1 != null && tIds1.size() > 0) {
					List<TrialWrapper> lstTW = wu.wrapTrial;
					system.debug('lstTW : '+lstTW);
					for(Id tId : tIds1) {
						if(lstTW != null) {
							for(TrialWrapper tw : lstTW) {
								if(tw.trialId == tId) {
									system.debug('tId : '+tId+'tw.trialId : '+tw.trialId);
									wu.ischecked = true;
									tw.isTrail = true;
								} 
							}
							system.debug('lstwrapperUsers : '+lstwrapperUsers);
						}
					}
				}
		}
		if(lstUser != null && lstUser.size() > 0){
			toShowTable = true;
			System.debug('------toShowTable---->'+toShowTable);
		} else {
			toShowTable = false;
			IsUserAssociated = true;
			associationMsg = 'There is no user(s) for association. user(s) are already assigned to other institutions.';
		}
		
	}
	
	public class wrapperUsers{
		public User wrapUser{get;set;}
		public List<TrialWrapper> wrapTrial{get;set;}
		public Boolean ischecked{get;set;}
		public Boolean isInstituteAdmin{get;set;}
		public Boolean isInstituteCalender{get;set;}
		public Boolean isTrErrorShow {get;set;}
		
		public wrapperUsers() {
			isInstituteAdmin = false;
			isInstituteCalender = false;
		}
	}
	
	public class TrialWrapper {
		public Boolean isTrail {get;set;}
		public String trialLabel {get;set;}
		public Id trialId {get;set;}
	}
	
	public void CustomeSave(){
		Integer trialflag;
		Integer userflag;
		isUserTrialError = false;
		Set<Id> setUserIds = new Set<Id>();
		for(wrapperUsers wu : lstwrapperUsers){
			//if(wu.ischecked == true){
				setUserIds.add(wu.wrapUser.Id);
			//}
		}
		delete [Select Id from InstitutionUser__c where User__c IN :setUserIds and Site__c = :selectSite];
		
		List<InstitutionUser__c> lstInstUser = new List<InstitutionUser__c>();
		System.debug('--------lstwrapperUsers-----:'+lstwrapperUsers);
		if(lstwrapperUsers != null){
			for(wrapperUsers wu : lstwrapperUsers){
				userflag = 0;
				System.debug('--------selectInstitutions-----:'+selectInstitutions);
				trialflag = 0;
				for(TrialWrapper tw : wu.wrapTrial){
					if(wu.ischecked == true){
						System.debug('------True-------:');
						userflag = 1;
						if(tw.isTrail == true){
							System.debug('------False-------:');
							InstitutionUser__c IntUser = new InstitutionUser__c();
							IntUser.Trial__c = tw.trialId;
							IntUser.User__c = wu.wrapUser.Id;
							IntUser.Institution__c = selectInstitutions;
							IntUser.Site__c = selectSite;
							IntUser.IsInstituteAdmin__c = false;
							IntUser.isInstituteCalender__c = false;
							if(wu.isInstituteAdmin) {
								IntUser.IsInstituteAdmin__c = true;
							}
							if(wu.isInstituteCalender){
								IntUser.isInstituteCalender__c = true;
								system.debug('------------IntUser.isInstituteCalender__c-----'+IntUser.isInstituteCalender__c);
								system.debug('------------IntUser.isInstituteCalender__c-----'+IntUser.id);
								
							}
							lstInstUser.add(IntUser);
							trialflag = 1;
						}
					}
				}
				
				if(userflag == 1) {
					
					if(trialflag == 0) {
					
						wu.isTrErrorShow = true;
						userLstWithoutTrial = new List<Id>();
						userLstWithoutTrial.add(wu.wrapUser.Id);
						isUserTrialError = true;
						errorMsg = 'Please select Trial for highlighted user.';
					}
					else {
						
						wu.isTrErrorShow = false;
					}
				}
				else {
					wu.isTrErrorShow = false;
				}
			}
			System.debug('----userLstWithoutTrial-before--:'+userLstWithoutTrial);
			if(!lstInstUser.isEmpty() && isUserTrialError == false){
				upsert lstInstUser;
				System.debug('------lstInstUser-------:'+lstInstUser);
				IsUserAssociated = true;
				associationMsg = 'User(s) are associted with the selected institution.';
			}
		} else {
			isNull = true;
			System.debug('------isNull-------:'+isNull);
		}
	}
}