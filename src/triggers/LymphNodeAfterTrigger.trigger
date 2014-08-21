trigger LymphNodeAfterTrigger on Lymph_Nodes__c (after insert, after update) {
	/*if(Trigger.isUpdate) {
		List<Lymph_Nodes__c> lstLymph = [Select l.Procedure__c, Procedure__r.Post_Surgery_Summary__c From Lymph_Nodes__c l where Id IN:Trigger.newMap.keySet()];
		Set<Id> postIds = new Set<Id>();
		for(Lymph_Nodes__c ln : trigger.new) {
			postIds.add(ln.Procedure__r.Post_Surgery_Summary__c);
		}
		List<Post_Surgaory_Summary__c> lstPostSur = [select CRF__c, TrialPatient__c from Post_Surgaory_Summary__c where Id IN :postIds];
		Set<Id> CRFIds = new Set<Id>();
		for(Post_Surgaory_Summary__c pss : lstPostSur) {
			CRFIds.add(pss.CRF__c);
		}
		List<Snomed_Code__c> lstSnomedCode = [select id,CRF__c,Value__c,Name from Snomed_Code__c where CRF__c IN : CRFIds and snomed_Code_Name__c IN ('IHTSDO_4594')];
		if(!lstSnomedCode.isEmpty()) {
			delete lstSnomedCode;
		}
	}
	SnomedCTCode.insertLymphNodeRelatedCode(Trigger.newMap.keySet());*/
	Set<Id> postIds = new Set<Id>();
	for(Lymph_Nodes__c ln : trigger.new) {
		postIds.add(ln.Post_Surgery_Summary__c);
	}
	List<Lymph_Nodes__c> lstLymph = [Select Examined__c, Positive__c, Post_Surgery_Summary__c From Lymph_Nodes__c l where Post_Surgery_Summary__c IN:postIds];
	Map<Id, Double> mapPssPositiveNode = new Map<Id, Double>();
	Map<Id, Double> mapPssExaminedNode = new Map<Id, Double>();
	for(Lymph_Nodes__c ln : lstLymph) {
		if(mapPssPositiveNode.containsKey(ln.Post_Surgery_Summary__c)) {
			Double num = mapPssPositiveNode.get(ln.Post_Surgery_Summary__c);
			if(num != null){
				mapPssPositiveNode.put(ln.Post_Surgery_Summary__c, num+ln.Positive__c);
			} else {
				mapPssPositiveNode.put(ln.Post_Surgery_Summary__c, ln.Positive__c);
			}
		}
		
		if(mapPssExaminedNode.containsKey(ln.Post_Surgery_Summary__c)) {
			Double num = mapPssExaminedNode.get(ln.Post_Surgery_Summary__c);
			if(num != null){
				mapPssExaminedNode.put(ln.Post_Surgery_Summary__c, num+ln.Examined__c);			
			} else {
				mapPssExaminedNode.put(ln.Post_Surgery_Summary__c, ln.Examined__c);
			}
	  }	
	}
	List<Post_Surgaory_Summary__c> lstPss = [select Id, Total_Examined_Nodes__c, Total_Positive_Nodes__c from Post_Surgaory_Summary__c where Id IN :postIds];
	Boolean flag = false;
	for(Post_Surgaory_Summary__c pss : lstPss) {
		if(mapPssPositiveNode.containsKey(pss.Id)) {
			pss.Total_Positive_Nodes__c = mapPssPositiveNode.get(pss.Id);
			flag = true;
		}
		
		if(mapPssExaminedNode.containsKey(pss.Id)) {
			pss.Total_Examined_Nodes__c = mapPssExaminedNode.get(pss.Id);
			flag = true;
		}
	}
	
	if(flag) {
		update lstPss;
	}
}