public with sharing class PartnerPortalManager {

/*	@future    
    public static void createPartnerPortalUser(Id patientId){
    	Set<Id> patientIds = new Set<Id>();
    	patientIds.add(patientId);
    	createPartnerPortalUser(patientIds);
    }*/
    
	@future    
    public static void createPartnerPortalUser(set<Id> patientIds){
		Patient_Custom__c pat = new Patient_Custom__c();
		
		List<Patient_Custom__c> patientLst = [Select p.isUserStatus__c ,p.Email__c, p.Last_Name__c, p.Institution__c,  p.Id, p.First_Name__c From Patient_Custom__c p where Id IN :patientIds];
    	
		//We need site to create contact
		Set<Id> instIds = new Set<Id>();
		for(Patient_Custom__c p : patientLst) {
			instIds.add(p.Institution__c);
		}
		List<Account> accSiteList = [Select a.Id, (Select Id From Sites__r Limit 1) From Account a where a.Id in :instIds];
		system.debug('====accSiteList'+accSiteList);
		//First create cnotacts from patients
		List<Contact> contacts = new List<Contact>();
		for(Patient_Custom__c p : patientLst) {
			Contact c = new Contact();
			c.FirstName = p.First_Name__c;
			c.LastName = p.Last_Name__c;
			c.Email = p.Email__c;
			c.AccountId = p.Institution__c;
			c.Patient__c = p.Id;
			System.debug('===p==='+p);
			System.debug('===c.AccountId'+c.AccountId);
			//For now associate patient's contact with any site, it doesn't matter anyway
			boolean siteExists = false;
			for(Account a  : accSiteList) {
				if(a.Id == c.AccountId) {
					List<Site__c> sites = a.Sites__r;
					System.debug('sites===='+sites);
					if(!sites.isEmpty()) {
						c.Site__c = sites[0].Id;
						siteExists = true;
					}
					break;
				}
			}
			if(!siteExists)continue;
			
			contacts.add(c);
		}
		if(test.isRunningTest()){
			User thisUser = [Select u.IsActive, u.Id From User u where IsActive = true and id =: userinfo.getUserId()]; // newly added logic since it was causing error in test classes    
	        System.runAs (thisUser) { 
				insert contacts;
				system.debug('=====contacts===='+contacts);
       		}
		}
		else {
			    insert contacts;
		}
		List<Profile> lstProNew = [Select Id from Profile where name = 'Gold Partner User Clone'];  
        
        List<User> userlst = new List<User>();
        if(!Test.isRunningTest()) {
            for(Contact c : contacts){
                User user = new User(
					Username = c.Email,
					ContactId = c.Id,
					ProfileId = lstProNew[0].Id,
					Alias = patientLst[0].Last_Name__c,
					Email = c.Email,
					EmailEncodingKey = 'UTF-8',
					LastName = patientLst[0].Last_Name__c,
					FirstName = patientLst[0].First_Name__c,
					CommunityNickname = System.now().millisecond()+'',
					TimeZoneSidKey = 'America/Los_Angeles',
					LocaleSidKey = 'en_US',
					LanguageLocaleKey = 'en_US',
					ReceivesInfoEmails = true,
					Patient_Id__c = c.Patient__c 
				);
                userlst.add(user);
            }
          	insert userlst;  
          	system.debug('===userlst==='+userlst);
        }
        for(User u : userlst) {
        	System.resetPassword(u.Id, true);
        }
	  
    }
    
    @future
    public static void enableAccountsAsPartners(Set<Id> accountIds) {
    	List<Account> accList = [Select a.IsPartner From Account a where id in:accountIds];
    	for(Account a : accList) {
    		a.IsPartner = true;
    	}
    	if(test.isRunningTest()){
	    	User thisUser = [Select u.IsActive, u.Id From User u where IsActive = true and id =: userinfo.getUserId()]; // newly added logic since it was causing error in test classes    
	        System.runAs (thisUser) { 
		    	update accList;
		    	System.debug('==accList======'+accList);
		    }
    	} else {
    		update accList;
    	}
  }
}