public with sharing class AssociateTrialCRFController {
	
	public List<wrapTrial> wrapTrialList{get;set;}
	public Boolean isSuccessMsg{get;set;}
	
	public AssociateTrialCRFController(ApexPages.StandardController controller) {
		wrapTrialList = new List<wrapTrial>();
		isSuccessMsg = false;
		List<CRFMaster__c>  CRFMasterList = [Select c.SystemModstamp, c.OwnerId, c.Object_Name__c, c.Name, c.LastModifiedDate, c.LastModifiedById, c.IsDeleted, c.IsApprovalRequired__c, c.Id, c.CreatedDate, c.CreatedById, c.CRFType__c From CRFMaster__c c where CRFType__c != 'Patient Creation form' order by CRFType__c];
		List<Trial__c> trialList = [Select t.SystemModstamp, t.Start_Date__c, t.OwnerId, t.Name, t.LastModifiedDate, t.LastModifiedById, t.LastActivityDate, t.IsDeleted, t.Id, t.CreatedDate, t.CreatedById From Trial__c t];
		List<Trial_CRF__c> associateCRFList = [Select a.Trial__c, a.SystemModstamp, a.OwnerId, a.Name, a.LastModifiedDate, a.LastModifiedById, a.IsDeleted, a.Id, a.CreatedDate, a.CreatedById, a.CRFMaster__c From Trial_CRF__c a];
		
		Map<Id, Set<Id>> mapTrialCrfMaster = new Map<Id, Set<Id>>();
		for(Trial_CRF__c associateCRFObj : associateCRFList) {
			if(mapTrialCrfMaster.containsKey(associateCRFObj.Trial__c)) {
				Set<Id> crfMasterId = mapTrialCrfMaster.get(associateCRFObj.Trial__c);
				crfMasterId.add(associateCRFObj.CRFMaster__c);
				mapTrialCrfMaster.put(associateCRFObj.Trial__c, crfMasterId);
			} else {
				mapTrialCrfMaster.put(associateCRFObj.Trial__c, new Set<Id>{associateCRFObj.CRFMaster__c});
			}
		}
		
		for(Trial__c trialObj: trialList) {
			wrapTrial wrapTrialObj = new wrapTrial();
			wrapTrialObj.trialObj = trialObj;
			/*for(Trial_CRF__c associateCRFObj : associateCRFList) {
				if(associateCRFObj.Trial__c == wrapTrialObj.trialObj.Id) {
					wrapTrialObj.isChecked = true;
				}
			}*/
			if(mapTrialCrfMaster.containsKey(trialObj.Id)) {
				wrapTrialObj.isChecked = true;
			}
			for(CRFMaster__c CRFMasterObj : CRFMasterList) {
				wrapCRF wrapCRFObj = new wrapCRF();
				wrapCRFObj.CRFObj = CRFMasterObj;
				/*for(Trial_CRF__c associateCRFObj : associateCRFList) {
					if(associateCRFObj.Trial__c == wrapTrialObj.trialObj.Id) {
						wrapTrialObj.isChecked = true;
						if(associateCRFObj.CRFMaster__c == CRFMasterObj.Id) {
							wrapCRFObj.isChecked = true;
						}
					}
				}*/
				if(mapTrialCrfMaster.containsKey(trialObj.Id)) {
					wrapTrialObj.isChecked = true;
					if(mapTrialCrfMaster.get(trialObj.Id).contains(CRFMasterObj.Id)) {
						wrapCRFObj.isChecked = true;
					}
				}
				wrapTrialObj.wrapCRFList.add(wrapCRFObj);
			}
			wrapTrialList.add(wrapTrialObj);
		}
	}
	
	public void createAssociation() {
		Set<Id> deleteTrialIdSet = new Set<Id>();
		List<Trial_CRF__c> insertAssociateCRFList = new List<Trial_CRF__c>();
		
		//List<Trial_CRF__c> associateCRFList = [Select a.Trial__c, a.SystemModstamp, a.OwnerId, a.Name, a.LastModifiedDate, a.LastModifiedById, a.IsDeleted, a.Id, a.CreatedDate, a.CreatedById, a.CRFMaster__c From Trial_CRF__c a];
		
		for(wrapTrial wrapTrialObj : wrapTrialList) {
			if(wrapTrialObj.isChecked) {
				for(wrapCRF wrapCRFObj : wrapTrialObj.wrapCRFList) {
					if(wrapCRFObj.isChecked) {
						Trial_CRF__c insertAssociateCRFObj = new Trial_CRF__c();
						insertAssociateCRFObj.Trial__c = wrapTrialObj.trialObj.Id;
						insertAssociateCRFObj.CRFMaster__c = wrapCRFObj.CRFObj.Id;
						insertAssociateCRFList.add(insertAssociateCRFObj);
					}
				}
			}
		}
		
		if(!insertAssociateCRFList.isEmpty()) {
			delete [select Id from Trial_CRF__c];
			isSuccessMsg = true;
			insert insertAssociateCRFList;
		}
	}
	
	public class wrapTrial {
		public Trial__c trialObj{get;set;}
		public Boolean isChecked{get;set;}
		public List<wrapCRF> wrapCRFList{get;set;}
		
		public wrapTrial() {
			wrapCRFList = new List<wrapCRF>();
			isChecked = false;
		}
	}
	
	public class wrapCRF {
		public CRFMaster__c CRFObj{get;set;}
		public Boolean isChecked{get;set;}
		
		public wrapCRF() {
			isChecked = false;
		}
	}
	
}