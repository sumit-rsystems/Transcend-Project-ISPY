public with sharing class LabTestCRFAttachmentComponentController {



	public String recordId{get;set;}
	public String rootId{get;set;}
	public String feedCRFName{get;set;}
	private Set<Id> allCloneCrfIds{get;set;}
	public List<WrapFeed> lstWrapFeed;
	
	public List<WrapFeed> getLstWrapFeed() {
		lstWrapFeed = new List<WrapFeed>();
		system.debug('feedCRFName: '+feedCRFName);
		system.debug('recordId: '+recordId);
		
		if(feedCRFName != null && recordId != null) {
			allCloneCrfIds.add(recordId);
			allRejectedCRF(recordId);
			system.debug('__allCloneCrfIds__'+allCloneCrfIds);
			List<Sobject> lstFeed = database.query('Select o.Title, o.RelatedRecordId, o.ParentId, o.ContentFileName, o.Body From '+feedCRFName+' o where ParentId IN :allCloneCrfIds');
			for(Sobject f : lstFeed) {
				if(f.get('ContentFileName') != null) {
					WrapFeed wrapFeedObj = new WrapFeed();
					wrapFeedObj.fileContentId = (Id)f.get('RelatedRecordId');
					wrapFeedObj.fileName = String.valueOf(f.get('ContentFileName'));
					wrapFeedObj.description = String.valueOf(f.get('Body'));
					wrapFeedObj.fileLink = 'https://c.na9.content.force.com/sfc/servlet.shepherd/version/download/'+wrapFeedObj.fileContentId+'?asPdf=false&operationContext=CHATTER';
					System.debug('fileLink:'+wrapFeedObj.fileLink);
					lstWrapFeed.add(wrapFeedObj);
				}
			}
		}
		return lstWrapFeed;
	}
	public LabTestCRFAttachmentComponentController() {
		allCloneCrfIds = new Set<Id>();
	}
	
	public void allRejectedCRF(Id crfId) {
		String objectName = '';
		system.debug('allRejectedCRFfeedCRFName: '+feedCRFName);
		if(feedCRFName.endsWith('__Feed')) {
			objectName = feedCRFName.replaceAll('__Feed', '__c');
		} else {
			objectName = feedCRFName.replace('Feed','');
		}
		system.debug('__query__select Effective_Time__c, CreatedById, OriginalCRF__c from '+objectName+' where Id = \''+crfId+'\'');
		/*for(Sobject crf : Database.query('select Effective_Time__c, CreatedById, OriginalCRF__c from '+objectName+' where Id = \''+crfId+'\'')) {
			//system.debug('crf.get(OriginalCRF__c): '+crf.get('OriginalCRF__c'));
			//system.debug('crf.get(Id): '+crf.get('Id'));
			if(crf.get('OriginalCRF__c') != null) {	//if crf is cloned
				allCloneCrfIds.add((Id)crf.get('OriginalCRF__c'));
				allRejectedCRF((Id)crf.get('OriginalCRF__c'));
			} else {	//if crf is original 
				allCloneCrfIds.add((Id)crf.get('Id'));
				return;
			}
		}*/
		Sobject crf1 = Database.query('select Effective_Time__c, CreatedById, OriginalCRF__c,Root_CRF_Id__c from '+objectName+' where Id = \''+crfId+'\'');
		if(crf1.get('Root_CRF_Id__c')!=null) {
			List<Sobject> crf = Database.query('select Effective_Time__c, CreatedById, OriginalCRF__c,Root_CRF_Id__c from '+objectName+' where Root_CRF_Id__c = \''+crf1.get('Root_CRF_Id__c')+'\'');
			system.debug('CrfPrint'+crf);
			system.debug('CrfPrintsize'+crf.size());
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
					allRejectedCRF((Id)crf.get('OriginalCRF__c'));
				} else {	//if crf is original 
					allCloneCrfIds.add((Id)crf.get('Id'));
					return;
				}
			}
		}
	}
	
	public class WrapFeed {
		public Id fileContentId{get;set;}
		public String fileName{get;set;}
		public String description{get;set;}
		public String fileLink {get;set;}
		
		public WrapFeed(){}
	}
}