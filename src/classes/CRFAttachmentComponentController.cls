public with sharing class CRFAttachmentComponentController {

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
					wrapFeedObj.fileLink = URL.getSalesforceBaseUrl().toExternalForm() +'/' + 'sfc/servlet.shepherd/version/download/'+wrapFeedObj.fileContentId;
					System.debug('fileLink:'+wrapFeedObj.fileLink);
					lstWrapFeed.add(wrapFeedObj);
				}
			}
		}
		return lstWrapFeed;
	}
	public CRFAttachmentComponentController() {
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

		Sobject crf1 = Database.query('select Effective_Time__c, CreatedById, OriginalCRF__c,Root_CRF_Id__c from '+objectName+' where Id = \''+crfId+'\'');
		List<Sobject> crf = Database.query('select Effective_Time__c, CreatedById, OriginalCRF__c,Root_CRF_Id__c from '+objectName+' where Root_CRF_Id__c = \''+crf1.get('Root_CRF_Id__c')+'\'');
		system.debug('CrfPrint'+crf);
		system.debug('CrfPrintsize'+crf.size());
		for(Sobject lt : crf ){
			system.debug('ForLoop entered');
			allCloneCrfIds.add((ID)lt.get('OriginalCRF__c'));  
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