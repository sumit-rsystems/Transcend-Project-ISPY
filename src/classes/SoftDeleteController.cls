public with sharing class SoftDeleteController {
	
	private String keycode{get;set;}
	private String objectName{get;set;}
	private String recId{get;set;}
	
	public SoftDeleteController() {
		keycode = Apexpages.currentPage().getParameters().get('keycode');
		objectName = Apexpages.currentPage().getParameters().get('object');
		recId = Apexpages.currentPage().getParameters().get('recId');
		system.debug('__keycode__'+keycode);
		system.debug('__objectName__'+objectName);
		system.debug('__recId__'+recId);
	}
	
	public Pagereference deleteRecord() {
		system.debug('Query: select Id, DeletedDateTime__c, Is_Deleted__c from '+objectName+' where Id = \''+recId+'\'');
		List<Sobject> lstobj = Database.query('select Id, DeletedDateTime__c, Is_Deleted__c from '+objectName+' where Id = \''+recId+'\'');
		if(!lstobj.isEmpty()) {
			lstobj[0].put('DeletedDateTime__c',system.now());
			lstobj[0].put('Is_Deleted__c',true);
			update lstobj[0]; 
		}
		Pagereference pRef = new Pagereference('/'+keycode);
		pRef.setRedirect(true);
		return pRef;
	}
}