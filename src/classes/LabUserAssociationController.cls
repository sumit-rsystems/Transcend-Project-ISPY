public with sharing class LabUserAssociationController {
	public String selectedLab {get;set;}
	public List<Selectoption> lstLabValues {get;set;}
	
	public List<UserWrapper> lstUserWrapper {get;set;}
	public boolean isUserAvl {get;set;}
	public String pageMsg {get;set;}
	public boolean pageMsgFlag {get;set;}
	public String pageMagSer {get;set;}
	
	public LabUserAssociationController() {
		lstUserWrapper = new List<UserWrapper>();
		lstLabValues = new List<Selectoption>{new Selectoption('','----None----')};
		List<Site__c> lstLabs = [Select s.Id, s.Name, s.RecordType.Name, s.RecordTypeId From Site__c s where RecordType.Name = 'Lab'];
		for(Site__c lab : lstLabs) {
			lstLabValues.add(new Selectoption(lab.Id, lab.Name));
		}
		pageMsgFlag = true;
		pageMsg = 'Please select Lab.';
		pageMagSer = 'info';
	}
	
	public void save() {
		delete [select Lab__c, User__c from LabUser__c where Lab__c = :selectedLab];
		List<LabUser__c> lstLabUser = new List<LabUser__c>();
		for(UserWrapper userWrapper : lstUserWrapper) {
			if(userWrapper.ischecked) {
				LabUser__c labUser = new LabUser__c();
				labUser.Lab__c = selectedLab;
				labUser.User__c = userWrapper.user.Id;
				lstLabUser.add(labUser);
			}
		}
		insert lstLabUser;
		if(!lstLabUser.isEmpty()) {
			pageMsgFlag = true;
			pageMsg = 'User successfully associated.';
			pageMagSer = 'confirm';
		}
	}
	
	public void getLabUsers() {
		
		lstUserWrapper.clear();
		
		system.debug('selectedLab : '+selectedLab);
		if(selectedLab == null || selectedLab == '') {
			isUserAvl = false;
			pageMsgFlag = true;
			pageMsg = 'Please select Lab.';
			pageMagSer = 'info';
			return;
		}
		
		Set<Id> associatedLabUsers = new Set<Id>();
		List<LabUser__c> lstLabUser = [select Lab__c, User__c from LabUser__c];
		for(LabUser__c labUser : lstLabUser) {
			associatedLabUsers.add(labUser.User__c);
		}
		List<User> lstUser = [Select u.LastName, u.FirstName, u.Username, u.UserRole.Name, u.UserRoleId, u.Profile.Name, u.ProfileId, u.IsActive, u.Id, u.Email From User u 
						where Profile.Name = 'Lab User' and IsActive = true];
		for(User user : lstUser) {
			UserWrapper userWrapper = new UserWrapper();
			userWrapper.user = user;
			for(LabUser__c labUser : lstLabUser) {
				if(labUser.Lab__c == selectedLab && labUser.User__c == user.Id) {
					userWrapper.ischecked = true;
					lstUserWrapper.add(userWrapper);
					//flag = true;
					break;
				}
			}
			if(!associatedLabUsers.contains(user.Id)) {
				userWrapper.ischecked = false;
				lstUserWrapper.add(userWrapper);
			}
			
		}
		
		if(!lstUserWrapper.isEmpty()) {
			isUserAvl = true;
			pageMsgFlag = false;
		} else {
			isUserAvl = false;
			pageMsgFlag = true;
			pageMsg = 'No user found. (All Lab users are associated with other labs.)';
			pageMagSer = 'info';				
		}
		
	}
	
	public class UserWrapper{
		public User user{get;set;}
		public Boolean ischecked{get;set;}
	}
}