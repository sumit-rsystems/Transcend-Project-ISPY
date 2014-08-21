public with sharing class LabandTestCRFEventComponentController {
	

	public String recordId{get;set;}
	public String rootId{get;set;}
	public String objectName{get;set;}
	public List<WrapCrfEvent> wrapCrfList;
	private Map<Id,Sobject> mapIdSobject = new Map<Id,Sobject>();
	private List<Datetime> dateTimeList;
	private Set<Id> allCloneCrfIds{get;set;}
    
//============build wrapCrfList============================================== 
	public List<WrapCrfEvent> getWrapCrfList() {
		wrapCrfList = new List<WrapCrfEvent>();
		dateTimeList = new List<Datetime>();
		List<WrapTmpCrfEvent> wraptmpCrfList = new List<WrapTmpCrfEvent>();
		if(objectName != null && recordId != null) {
			Set<Id> recIds = new Set<Id>();
			allCloneCrfIds.add(recordId);
			searchClonedCrf(recordId);
			system.debug('__allCloneCrfIds__'+allCloneCrfIds);
			system.debug('__query__select Effective_Time__c, CreatedById, CreatedBy.Name, OriginalCRF__c from '+objectName+' where Id IN \''+allCloneCrfIds+'\'');
			List<Sobject> crfList = Database.query('select Effective_Time__c, CreatedById, OriginalCRF__c, Status__c from '+objectName+' where Id IN :allCloneCrfIds order by Effective_Time__c');
			system.debug('__crfList__'+crfList);
			
			/*Set<Id> uIds = new Set<Id>();
			for(Sobject crf : crfList) {
				uIds.add((Id)crf.get('CreatedById'));
			}
			List<User> lstUser = [select Name from User where Id IN :uIds];
			for(Sobject crf : crfList) {
				for(User u : lstUser) {
					if(u.Id == (Id)crf.get('CreatedById')) {
						WrapTmpCrfEvent wrapCrfObj = new WrapTmpCrfEvent();
						wrapCrfObj.createdDate = Datetime.valueOf(crf.get('Effective_Time__c'));
						wrapCrfObj.eventOwnerName = u.Name;
						wrapCrfObj.isSiteUserComment = true;
						wraptmpCrfList.add(wrapCrfObj);
						dateTimeList.add(Datetime.valueOf(crf.get('Effective_Time__c')));
					}
				}
			}*/
			if(!crfList.isEmpty()) {
				for(Sobject crfObj : crfList) {
					mapIdSobject.put((Id)crfObj.get('Id'), crfObj);
				}
				Sobject crf = crfList[0];
				User u = [select Name from User where Id=:String.valueOf(crf.get('CreatedById'))];
				WrapTmpCrfEvent wrapCrfObj = new WrapTmpCrfEvent();
				wrapCrfObj.createdDate = Datetime.valueOf(crf.get('Effective_Time__c'));
				wrapCrfObj.eventOwnerName = u.Name;
				wrapCrfObj.isSiteUserComment = true;
				wraptmpCrfList.add(wrapCrfObj);
				dateTimeList.add(Datetime.valueOf(crf.get('Effective_Time__c')));
			}
			
			wraptmpCrfList = buildWrapperForFeedObject(wraptmpCrfList);
			system.debug('wraptmpCrfList after feed: '+wraptmpCrfList);
			wraptmpCrfList = buildWrapperForDCC(wraptmpCrfList);
			system.debug('wraptmpCrfList after DCC: '+wraptmpCrfList);
			dateTimeList.sort();
		}
		sortWrapListAccToDate(wraptmpCrfList);
		system.debug('final wrapCrfList: '+wrapCrfList);
		system.debug('final wrapCrfList.size(): '+wrapCrfList.size());
		return wrapCrfList;
	}
	
	public void setWrapCrfList(List<WrapCrfEvent> wrapCrfList) {
		system.debug('final set wrapCrfList.size(): '+wrapCrfList.size());
		this.wrapCrfList = wrapCrfList;
	}

	public LabandTestCRFEventComponentController(){
		allCloneCrfIds = new Set<Id>();
	}
	
	/*private void searchClonedCrf(Id crfId) {
		for(Sobject crf : Database.query('select Effective_Time__c, CreatedById, OriginalCRF__c from '+objectName+' where Id = \''+crfId+'\'')){
			system.debug('crfsize '+crf.size()); 
			system.debug('crfsize '+crf); 
			system.debug('crf.get(OriginalCRF__c): '+crf.get('OriginalCRF__c'));
			system.debug('crf.get(Id): '+crf.get('Id'));
			if(crf.get('OriginalCRF__c') != null) {	//if crf is cloned
				allCloneCrfIds.add((Id)crf.get('OriginalCRF__c'));
				searchClonedCrf((Id)crf.get('OriginalCRF__c'));
			} else {	//if crf is original 
				allCloneCrfIds.add((Id)crf.get('Id'));
				return;
			}
		}
	}*/ 
	private void searchClonedCrf(Id crfId) {
		Sobject crf1 = Database.query('select Effective_Time__c, CreatedById, OriginalCRF__c,Root_CRF_Id__c from '+objectName+' where Id = \''+crfId+'\'');
		
		if(crf1.get('Root_CRF_Id__c') != null) {
			List<Sobject> crf = Database.query('select Effective_Time__c, CreatedById, OriginalCRF__c,Root_CRF_Id__c from '+objectName+' where Root_CRF_Id__c = \''+crf1.get('Root_CRF_Id__c')+'\'');
			system.debug('CrfPrint'+crf);
			system.debug('CrfPrintsize'+crf.size());
		//	List<Lab_and_Test__c> ltRoot1 = [Select Id,OriginalCRF__c,Root_CRF_Id__c from Lab_and_Test__c where Id =: crfId];
		//	List<Lab_and_Test__c> ltRoot = [Select Id,OriginalCRF__c,Root_CRF_Id__c from Lab_and_Test__c where Id =: ltRoot1[0].Root_CRF_Id__c];
			//system.debug('ltRootPrint'+ltRoot);
		//	system.debug('ltRootSize'+ltRoot.size());
			for(Sobject lt : crf ){
				system.debug('ForLoop entered');
				allCloneCrfIds.add((ID)lt.get('OriginalCRF__c'));  
			}
		} else {
			for(Sobject crf : Database.query('select Effective_Time__c, CreatedById, OriginalCRF__c from '+objectName+' where Id = \''+crfId+'\'')) {
				//system.debug('crf.get(OriginalCRF__c): '+crf.get('OriginalCRF__c'));
				//system.debug('crf.get(Id): '+crf.get('Id'));
				if(crf.get('OriginalCRF__c') != null) {	//if crf is cloned
					allCloneCrfIds.add((Id)crf.get('OriginalCRF__c'));
					searchClonedCrf((Id)crf.get('OriginalCRF__c'));
				} else {	//if crf is original 
					allCloneCrfIds.add((Id)crf.get('Id'));
					return;
				}
			}
		}
	}
	
	
	private List<WrapTmpCrfEvent> buildWrapperForFeedObject(List<WrapTmpCrfEvent> wraptmpCrfList) {
		String feedObjectName = '';
		if(objectName.endsWith('__c')) {
			feedObjectName = objectName.replaceAll('__c', '__Feed');
		} else {
			feedObjectName = objectName + 'Feed';
		}
		system.debug('__feedQuery__Select ParentId, CreatedById, CreatedDate, Body From '+feedObjectName+' order by CreatedDate');
		List<Sobject> crfFeedList = Database.query('Select ParentId, CreatedById, CreatedDate, Body From '+feedObjectName+' where ParentId IN :allCloneCrfIds and Type = \'TextPost\' order by CreatedDate');
		system.debug('__crfFeedList__'+crfFeedList);
			
		Set<String> userIdSet = new Set<String>();
		for(Sobject crfFeedObj : crfFeedList) {
			userIdSet.add(String.valueOf(crfFeedObj.get('CreatedById')));
		}
		List<User> userList = [select Name from User where Id IN :userIdSet];
		for(Sobject crfFeedObj : crfFeedList) {
			for(User u: userList) {
				if(u.Id == String.valueOf(crfFeedObj.get('CreatedById'))) {
					WrapTmpCrfEvent wrapCrfObj1 = new WrapTmpCrfEvent();
					wrapCrfObj1.createdDate = Datetime.valueOf(crfFeedObj.get('CreatedDate'));
					wrapCrfObj1.eventOwnerName = u.Name;
					wrapCrfObj1.Comment = String.valueOf(crfFeedObj.get('Body'));
					wrapCrfObj1.isSiteUserComment = true;
					if(String.valueOf(crfFeedObj.get('Body')) != null) {
						wrapCrfObj1.isCommentShow = true;
					}
					wraptmpCrfList.add(wrapCrfObj1);
					dateTimeList.add(Datetime.valueOf(crfFeedObj.get('CreatedDate')));
				}
			}
		}
		return wraptmpCrfList;
	}
	
	private List<WrapTmpCrfEvent> buildWrapperForDCC(List<WrapTmpCrfEvent> wraptmpCrfList) {
		List<ProcessInstance> approvalHistory = [Select p.TargetObjectId, p.Status, p.CreatedDate, (Select Id, IsPending, ProcessInstanceId, TargetObjectId, StepStatus, OriginalActorId, ActorId, RemindersSent, Comments, IsDeleted, CreatedDate, CreatedById, CreatedBy.Name, SystemModstamp From StepsAndWorkitems where StepStatus != 'Started' order by CreatedDate) From ProcessInstance p where TargetObjectId IN :allCloneCrfIds];
		system.debug('__approvalHistory__'+approvalHistory);
		for(ProcessInstance pi : approvalHistory) {
			for(ProcessInstanceHistory pih : pi.StepsAndWorkitems) {
				WrapTmpCrfEvent wrapCrfObj2 = new WrapTmpCrfEvent();
				wrapCrfObj2.createdDate = pih.CreatedDate;
				wrapCrfObj2.eventOwnerName = pih.CreatedBy.Name;
				//wrapCrfObj2.dccVerdict = pih.StepStatus;
				wrapCrfObj2.dccVerdict = (String)mapIdSobject.get(pi.TargetObjectId).get('Status__c');
				wrapCrfObj2.Comment = pih.Comments;
				wrapCrfObj2.isDccComment = true;
				if(pih.Comments != null) {
					wrapCrfObj2.isCommentShow = true;
				}
				wraptmpCrfList.add(wrapCrfObj2);
				dateTimeList.add(pih.CreatedDate);
			}
		}
		return wraptmpCrfList;
	}
	
	private void sortWrapListAccToDate(List<WrapTmpCrfEvent> wraptmpCrfList) {
		system.debug('sort before wraptmpCrfList: '+wraptmpCrfList);
		system.debug('sort before wraptmpCrfList.size(): '+wraptmpCrfList.size());
		system.debug('dateTimeList.size: '+dateTimeList.size());
		
		List<Datetime> tmpDateTimeList = new List<Datetime>();
		for(Integer i = dateTimeList.Size()-1; i >= 0; i--) {
			tmpDateTimeList.add(dateTimeList.get(i));
		}
		system.debug('tmpDateTimeList.size: '+tmpDateTimeList.size());
		for(Datetime cdate : tmpDateTimeList) {
			for(WrapTmpCrfEvent wrapCrfObj : wraptmpCrfList) {
				if(wrapCrfObj.createdDate == cdate) {
					WrapCrfEvent wrapCrfObj3 = new WrapCrfEvent();
					
					system.debug('wrapCrfObj : '+wrapCrfObj);
					system.debug('wrapCrfObj.createdDate : '+wrapCrfObj.createdDate);
					if(wrapCrfObj.createdDate != null) {
						wrapCrfObj3.createdDate = Datetime.valueOf(wrapCrfObj.createdDate).format('E MMM dd HH:mm:ss z yyyy', 'PST');
						wrapCrfObj3.eventOwnerName = wrapCrfObj.eventOwnerName;
						wrapCrfObj3.dccVerdict = wrapCrfObj.dccVerdict;
						wrapCrfObj3.Comment = wrapCrfObj.Comment;
						wrapCrfObj3.isDccComment = wrapCrfObj.isDccComment;
						wrapCrfObj3.isSiteUserComment = wrapCrfObj.isSiteUserComment;
						wrapCrfObj3.isCommentShow = wrapCrfObj.isCommentShow;
						wrapCrfList.add(wrapCrfObj3);
					}
				}
			}
		}
		system.debug('sort after wrapCrfList: '+wrapCrfList);
		system.debug('sort after wrapCrfList.size(): '+wrapCrfList.size());
		//return wrapCrfList;
	}
	
	class WrapTmpCrfEvent {
		public Datetime createdDate{get;set;}
		public String eventOwnerName{get;set;}
		public String Comment{get;set;}
		public String dccVerdict{get;set;}
		public Boolean isDccComment{get;set;}
		public Boolean isSiteUserComment{get;set;}
		public Boolean isCommentShow{get;set;}
		
		public WrapTmpCrfEvent(){
			isDccComment = false;
			isSiteUserComment = false;
			isCommentShow = false;
		}
	}
	
	class WrapCrfEvent {
		public String createdDate{get;set;}
		public String eventOwnerName{get;set;}
		public String Comment{get;set;}
		public String dccVerdict{get;set;}
		public Boolean isDccComment{get;set;}
		public Boolean isSiteUserComment{get;set;}
		public Boolean isCommentShow{get;set;}
		
		public WrapCrfEvent(){
			isDccComment = false;
			isSiteUserComment = false;
			isCommentShow = false;
		}
	}
}