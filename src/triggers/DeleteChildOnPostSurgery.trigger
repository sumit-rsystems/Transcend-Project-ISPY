trigger DeleteChildOnPostSurgery on Post_Surgaory_Summary__c (before delete) {
	Set<Id> postIdSet = new Set<Id>();
	set<Id> crfIds = new set<Id>();
	 
	for(Post_Surgaory_Summary__c pss : Trigger.old) {
		postIdSet.add(pss.Id);
		crfIds.add(pss.CRF__c);
		/*DCISIdSet.add(pss.DCIS__c);
		LCISIdSet.add(pss.LCIS__c);
		InvasiveIdSet.add(pss.Invasive_Tumor_Detail__c);
		receptorIdSet.add(pss.Receptors_Left__c);
		receptorIdSet.add(pss.Receptors_Right__c);*/
	}
	
	List<Procedure__c> procedureList = [select Id from Procedure__c where Post_Surgery_Summary__c IN :postIdSet];
	
	Set<Id> procedureIdSet = new Set<Id>();
	for(Procedure__c procObj : procedureList) {
		procedureIdSet.add(procObj.Id);
	}
	
	List<Procedure_Specimen_Detail__c> specimenList = [select Id from Procedure_Specimen_Detail__c where Procedure__c IN :procedureIdSet];
	List<Lymph_Nodes__c> lymphList = [select Id from Lymph_Nodes__c where Procedure__c IN :procedureIdSet];
	/*List<DCIS__c> DCISList = [select Id from DCIS__c where Id IN :DCISIdSet];
	List<LCIS__c> LCISList = [select Id from LCIS__c where Id IN :LCISIdSet];
	List<Invasive_Tumor_Detail__c> Invasive_TumorList = [select Id from Invasive_Tumor_Detail__c where Id IN :InvasiveIdSet];
	List<Receptors__c> ReceptorsList = [select Id from Receptors__c where Id IN :receptorIdSet];*/
	List<DCIS__c> DCISList = [select Id from DCIS__c where Post_Surgery_Summary__c IN :postIdSet];
	List<LCIS__c> LCISList = [select Id from LCIS__c where Post_Surgery_Summary__c IN :postIdSet];
	List<Invasive_Tumor_Detail__c> Invasive_TumorList = [select Id from Invasive_Tumor_Detail__c where Post_Surgery_Summary__c IN :postIdSet];
	List<Receptors__c> ReceptorsList = [select Id from Receptors__c where Post_Surgery_Summary__c IN :postIdSet];
	List<Staging_Detail__c> stagingList = [select Id from Staging_Detail__c where Post_Surgery_Summary__c IN :postIdSet];
	List<CRF__c> lstCRF = [select id from CRF__c where id IN : crfIds];
	
	delete procedureList;
	delete specimenList;
	delete lymphList;
	delete DCISList;
	delete LCISList;
	delete Invasive_TumorList;
	delete ReceptorsList;
	delete stagingList;
	delete lstCRF;
}