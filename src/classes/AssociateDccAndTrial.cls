public with sharing class AssociateDccAndTrial {
	
	public String selectInstitutions{get;set;}
	public Id institutionId;
	public List<TrialWrapper> lstTrialWrapper{get;set;}
	public List<wrapperClass> wrapClass{get; set;}
	public String pageInfoMsg {get;set;}
	public boolean isError {get;set;}
	public boolean isInfo {get;set;}
	public String pageErrorMsg {get;set;}
	Map<Id,List<Id>> dccTrialMap = new Map<Id,List<Id>>();
	public AssociateDccAndTrial(){
		isInfo = false;
		isError = false;
		institutionId = Apexpages.currentPage().getParameters().get('institutionId');
		List<RecordType> recTypeList = [select id,Name,sObjectType from RecordType where sObjectType = 'Account' and Name in ('DCC','DCC Safety Group')];
		Set<Id> recTypeIds = new Set<Id>();
		for(RecordType rt : recTypeList) {
			recTypeIds.add(rt.Id);
		}
		List<Account> lstDCC = [select id,Name,RecordTypeId from Account where RecordTypeId IN :recTypeIds];
		List<InstitutionTrial__c> lstInsTrial = [select id, Trial_Id__c from InstitutionTrial__c where Institution_Id__c = : institutionId];
		Set<Id> trialIdSet  = new Set<Id>();
		for(InstitutionTrial__c tmpListObj : lstInsTrial) {
			trialIdSet.add(tmpListObj.Trial_Id__c);
		}
		
		List<Trial__c> lstTrial = [select id,Name from Trial__c where Id IN :trialIdSet];
		lstTrialWrapper = new List<TrialWrapper>();
		for(Trial__c tr : lstTrial){
			TrialWrapper trialWrapper = new TrialWrapper();
			trialWrapper.trialLabel = tr.Name;
			trialWrapper.trialId = tr.Id;
			lstTrialWrapper.add(trialWrapper);
		}
		wrapClass = new List<wrapperClass>();
		for(Account dcc : lstDCC){
			wrapperClass wc = new wrapperClass();
			wc.wrapDCC = dcc;
			wc.wrapTrial = new List<TrialWrapper>();
			for(TrialWrapper tw : lstTrialWrapper) {
				TrialWrapper tw1 = new TrialWrapper();
				tw1.isTrail = tw.isTrail;
				tw1.trialLabel = tw.trialLabel;
				tw1.trialId = tw.trialId;
				wc.wrapTrial.add(tw1);
			}
			wrapClass.add(wc);
		}
		dccTrialMap = new Map<Id,List<Id>>();
		List<InstitutionTrialDcc__c> lstInstTrailDcc = [Select i.Trial_Id__c, i.Institution_Id__c, i.DCC_Id__c From InstitutionTrialDcc__c i where Institution_Id__c = :institutionId];
		for(InstitutionTrialDcc__c itd : lstInstTrailDcc) {
			if(dccTrialMap.containsKey(itd.DCC_Id__c)) {
				dccTrialMap.get(itd.DCC_Id__c).add(itd.Trial_Id__c);
			} else {
				List<Id> trials = new List<Id>();
				trials.add(itd.Trial_Id__c);
				dccTrialMap.put(itd.DCC_Id__c,trials);
			}
		}
		system.debug('dccTrialMap : '+dccTrialMap);
		for(wrapperClass wc1 : wrapClass) {
			List<Id> tIds = dccTrialMap.get(wc1.wrapDCC.Id);
			wc1.ischecked = false;
			if(tIds != null && tIds.size() > 0) {
				wc1.ischecked = true;
				List<TrialWrapper> lstTW = wc1.wrapTrial;
				for(Id tId : tIds) {
					if(lstTW != null) {
						for(TrialWrapper tw : lstTW) {
							if(tw.trialId == tId) {
								system.debug('tId : '+tId+'tw.trialId : '+tw.trialId);
								tw.isTrail = true;
							} 
						}
					}
				}
			}
		}
	}
	
	public class wrapperClass{
		public Account wrapDCC{get;set;}
		public List<TrialWrapper> wrapTrial{get;set;}
		public Boolean ischecked{get; set;}
	}
	
	public class TrialWrapper {
		public Boolean isTrail {get;set;}
		public String trialLabel {get;set;}
		public Id trialId {get;set;}
	}
	
	public Pagereference submit(){
		institutionId = Apexpages.currentPage().getParameters().get('institutionId');
		delete [Select i.Trial_Id__c, i.Institution_Id__c, i.DCC_Id__c From InstitutionTrialDcc__c i where Institution_Id__c = :institutionId];
		if(institutionId != null){
			List<InstitutionTrialDcc__c> lstInsTriDcc = new List<InstitutionTrialDcc__c>();
			List<InstitutionTrial__c> lstInsTri = new List<InstitutionTrial__c>();
			List<InstitutionDcc__c> lstInsDcc = new List<InstitutionDcc__c>();
			for(wrapperClass wc : wrapClass){
				for(TrialWrapper tw : wc.wrapTrial){
					if(wc.ischecked == true){
						if(tw.isTrail == true){
							InstitutionTrialDcc__c insTriDcc = new InstitutionTrialDcc__c();
							insTriDcc.DCC_Id__c = wc.wrapDCC.Id;
							insTriDcc.Institution_Id__c = institutionId;
							insTriDcc.Trial_Id__c = tw.trialId;
							lstInsTriDcc.add(insTriDcc);
							InstitutionTrial__c insTrial = new InstitutionTrial__c();
							insTrial.Institution_Id__c = institutionId;
							insTrial.Trial_Id__c = tw.trialId;
							lstInsTri.add(insTrial);
							InstitutionDcc__c insDcc = new InstitutionDcc__c();
							insDcc.DCC_Id__c = wc.wrapDCC.Id;
							insDcc.Institution_Id__c = institutionId;
							lstInsDcc.add(insDcc);
						}
					}
				}
			}
			if(!lstInsTriDcc.isEmpty()){
				insert lstInsTriDcc;
				isInfo = true;
			}
			if(!lstInsTri.isEmpty()){
				insert lstInsTri;
			}
			if(!lstInsDcc.isEmpty()){
				insert lstInsDcc;
			}
		}
		Pagereference pr = new Pagereference('/'+institutionId);
		return pr;
	}
}