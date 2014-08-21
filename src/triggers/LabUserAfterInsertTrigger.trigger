trigger LabUserAfterInsertTrigger on LabUser__c (after insert) {
	
	Set<Id> ids = new Set<Id>();
	for(LabUser__c lu : trigger.new) {
		ids.add(lu.Id);
	}
	
	Set<Id> labIds = new Set<Id>();
	List<LabUser__c> lstLabUser = [Select l.User__c, l.Lab__r.Institute__c, l.Lab__c From LabUser__c l where ID IN :ids];
	for(LabUser__c labUser : lstLabUser) {
		labIds.add(labUser.Lab__c);
	}
	
	Map<Id, Set<Id>> mapSiteTrials = new Map<Id, Set<Id>>();
	List<Site_Trial__c> lstSiteTrial = [select Site__c, Trial__c from Site_Trial__c where Site__c IN :labIds];
	for(Site_Trial__c st : lstSiteTrial) {
		if(mapSiteTrials.containsKey(st.Site__c)) {
			mapSiteTrials.get(st.Site__c).add(st.Trial__c);
		} else {
			mapSiteTrials.put(st.Site__c, new Set<Id>{st.Trial__c});
		}
	}
	List<InstitutionUser__c> lstInstUser = new List<InstitutionUser__c>();
	for(LabUser__c labUser : lstLabUser) {
		Set<Id> lstTrial = mapSiteTrials.get(labUser.Lab__c);
		if(lstTrial != null) {
			for(Id trial : lstTrial) {
				InstitutionUser__c instUser = new InstitutionUser__c();
				instUser.Institution__c = labUser.Lab__r.Institute__c;
				instUser.Site__c = labUser.Lab__c;
				instUser.Trial__c = trial;
				instUser.User__c = labUser.User__c;
				lstInstUser.add(instUser);
			}
		}
	}
	
	insert lstInstUser;
}