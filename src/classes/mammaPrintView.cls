public with sharing class mammaPrintView {
	public List<WrapperList> wrapList{get;set;}
	public List<TrialPatient__c> trailPatientList{get;set;}
	public String mmaprintid{get;set;}
	public String trailPatiId{get;set;}
	
	public mammaPrintView(){
		
		String userId = Userinfo.getUserId();
		system.debug('-----userId------'+userId);
		List<LabUser__c> labUserList = [Select l.User__c, l.SystemModstamp, l.OwnerId, l.Name, l.LastModifiedDate, l.LastModifiedById, l.Lab__c, l.IsDeleted, l.Id, l.CreatedDate, l.CreatedById From LabUser__c l where User__c =:userId];
		system.debug('----labUserList--'+labUserList);
		set<id> labIds = new Set<id>();
		for(LabUser__c labU : labUserList){
			labIds.add(labU.Lab__c);
		}
		List<Site_Trial__c> siteTrialList = [Select s.User__c, s.Trial__c, s.SystemModstamp, s.Site__c, s.Name, s.LastModifiedDate, s.LastModifiedById, s.IsDeleted, s.Id, s.CreatedDate, s.CreatedById From Site_Trial__c s where Site__c IN :labIds];
		set<Id> trialId = new Set<id>();
		for(Site_Trial__c siteTra: siteTrialList){
			trialId.add(siteTra.Trial__c);
		}
		
		List<TrialPatient__c> trailPatientList = [Select t.pg_patient_Id__c, t.Trial_Id__c,t.Trial_Id__r.Name, t.SystemModstamp, t.Subject_Id__c, t.Stage__c, t.Site__c,t.Site__r.Name, t.Patient_Id__c, t.Patient_Id__r.Last_Name__c, t.Name, t.Medical_Record_Number__c, t.LastName__c, t.LastModifiedDate, t.LastModifiedById, t.LastActivityDate, t.IsRandomized__c, t.IsDeleted, t.Institution__c, t.Id, t.FirstName__c, t.CreatedDate, t.CreatedById, (Select Id, Status__c From TissueSpecimenDetail__r where Status__c = 'Approval Not Required'),(Select Id, Name, Status__c From MammaPrint_Details__r) From TrialPatient__c t where Trial_Id__c IN :trialId];
		wrapList = new List<WrapperList>();
		
		for(TrialPatient__c trailp : trailPatientList){
			WrapperList wrap = new WrapperList();
			List<MammaPrintDetail__c> mamaprintList = trailp.MammaPrint_Details__r;
			List<TissueSpecimenDetail__c> tissueSpeaci = trailp.TissueSpecimenDetail__r;
			system.debug('-----tissueSpeaci-----'+tissueSpeaci.size());
			if(tissueSpeaci.size() > 0){
				system.debug('-----tissueSpeaci-----'+tissueSpeaci);
				wrap.trailpationId = trailp.id;
				wrap.patientName = trailp.Patient_Id__r.Last_Name__c; 
				wrap.subjectid = trailp.Subject_Id__c;
				wrap.instituteName = trailp.Institution__c;
				wrap.trialname = trailp.Trial_Id__r.Name;
				wrap.siteName = trailp.Site__r.Name;
			
				if(mamaprintList.size() > 0){
					wrap.mamaPrintId = mamaprintList[0].Id;
					wrap.issubmitTrue = true;	
				}else{
					wrap.issubmitTrue = false;
				}
				wrapList.add(wrap);
			} 
		}
	}
	public class WrapperList{
		public String trailpationId{get;set;}
		public String mamaPrintId{get;set;}
		public String subjectid{get;set;}
		public String trialname{get;set;}
		public String siteName{get;set;}
		public String instituteName{get;set;}
		public String patientName{get;set;} 
		public boolean issubmitTrue{get;set;}
		
		public WrapperList(){
			issubmitTrue = false;
		}
		
	}

}