trigger BeforeDeleteOnStudyPathology on On_Study_Pathology_Form__c (before delete) {
	
	/*set<Id> dcisIds = new set<Id>();
	set<Id> lcisIds = new set<Id>();
	set<Id> invasiveIds = new set<Id>();
	set<Id> receptorsIds = new set<Id>();*/
	set<Id> crfIds = new set<Id>();
	set<Id> ospIds = new set<Id>();
	
	for(On_Study_Pathology_Form__c ose : Trigger.old){
		ospIds.add(ose.Id);
		crfIds.add(ose.CRF__c);
		/*dcisIds.add(ose.DCIS__c);
		lcisIds.add(ose.LCIS__c);
		invasiveIds.add(ose.Invasive_Tumor_Detail__c);
		receptorsIds.add(ose.Receptors__c);*/
	}
	
	List<Procedure__c> lstPro = [select id,On_Study_Pathology_Form__c from Procedure__c where On_Study_Pathology_Form__c IN : Trigger.oldMap.keyset()];
	/*List<DCIS__c> lstDCIS = [select id from DCIS__c where Id IN : dcisIds];
	List<LCIS__c> lstLCIS = [select id from LCIS__c where Id IN : lcisIds];
	List<Invasive_Tumor_Detail__c> lstITD = [select id from Invasive_Tumor_Detail__c where Id IN : invasiveIds];
	List<Receptors__c> lstReceptors = [select id from Receptors__c where Id IN : receptorsIds];*/
	List<DCIS__c> lstDCIS = [select id from DCIS__c where On_Study_Pathology_Form__c IN : ospIds];
	List<LCIS__c> lstLCIS = [select id from LCIS__c where On_Study_Pathology_Form__c IN : ospIds];
	List<Invasive_Tumor_Detail__c> lstITD = [select id from Invasive_Tumor_Detail__c where On_Study_Pathology_Form__c IN : ospIds];
	List<Receptors__c> lstReceptors = [select id from Receptors__c where On_Study_Pathology_Form__c IN : ospIds];
	List<CRF__c> lstCRF = [select id from CRF__c where id IN : crfIds];
	
	delete lstPro;
	delete lstDCIS;
	delete lstLCIS;
	delete lstITD;
	delete lstReceptors;
	delete lstCRF;
}