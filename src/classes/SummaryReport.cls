public with sharing class SummaryReport {
	
	public AE_Report__c aeRep{get;set;}
	public List<SelectOption> trialLst{get;set;}
	public String selectTrial{get;set;}
	
	public SummaryReport(){
	
		aeRep = new AE_Report__c();
		
		User usr = [Select u.Profile.Name From User u where id =:UserInfo.getUserId()];
		if(usr.Profile.Name != 'Trial Administrator'){ 
			List<DCC_User__c> lstDCCUser = [select id,DCC__c,DCC__r.Name,User__c from DCC_User__c where User__c = : Userinfo.getUserId()];
			set<Id> dccIds = new set<Id>();
			for(DCC_User__c dccUser : lstDCCUser){
				dccIds.add(dccUser.DCC__c);
			}
			List<InstitutionTrialDcc__c> lstInsTriDcc = new List<InstitutionTrialDcc__c>();
			if(!lstDCCUser.isEmpty()){
				lstInsTriDcc = [select id,DCC_Id__c,Trial_Id__c,Trial_Id__r.Name from InstitutionTrialDcc__c where DCC_Id__c IN : dccIds];
			}
			Map<Id,String> mspTrial = new Map<Id,String>();
			for(InstitutionTrialDcc__c insTriDcc : lstInsTriDcc){
				mspTrial.put(insTriDcc.Trial_Id__c,insTriDcc.Trial_Id__r.Name);
			}
			trialLst = new List<Selectoption>();
			Selectoption option = new Selectoption('','--None--'); 
			trialLst.add(option);
			
			for(Id insTriDcc : mspTrial.keySet()){ 
				if(insTriDcc != null && mspTrial.get(insTriDcc) != null) {
					option = new Selectoption(insTriDcc,mspTrial.get(insTriDcc));
					trialLst.add(option);
				}
			}
		}
		//List<Trial__c> LstTrl = [Select t.Name, t.Id From Trial__c t];
		List<Trial__c> LstTrl = [Select t.Name, t.Id, (Select Id From TrialPatients__r) From Trial__c t];
		trialLst = new List<Selectoption>();
		Selectoption option = new Selectoption('','--None--'); 
		trialLst.add(option);		
		for (Trial__c tr: LstTrl ) {
			if(tr.TrialPatients__r.isEmpty()) continue;
			option = new Selectoption(tr.Id, tr.Name); 
			trialLst.add(option);
		}
			
	}
	
	public Pagereference next(){
		if(aeRep.Start_Date__c != null){
			Pagereference pr = new Pagereference('/apex/TrialSummaryReport?trialId='+selectTrial+'&asOfDate='+aeRep.End_Date__c+'&startDate='+aeRep.Start_Date__c);
			return pr;
		} else {
			Pagereference pr = new Pagereference('/apex/TrialSummaryReport?trialId='+selectTrial);
			return pr;
		}
	}
	
	public Pagereference cancelForm(){
		Pagereference pr = new Pagereference('/home/home.jsp');
		return pr;
	}
}