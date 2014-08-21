trigger CoreBiopsyInsertTrigger on Core_Biopsy_Specimens__c (before insert, before update) {
	if(Trigger.isInsert || Trigger.isUpdate){
		Set<Id> tissueSpecimenIdSet = new Set<Id>();
		for(Core_Biopsy_Specimens__c cbs : Trigger.new) {
			tissueSpecimenIdSet.add(cbs.TissueSpecimenDetail__c);
		}
		if(tissueSpecimenIdSet.isEmpty()){
			List<TissueSpecimenDetail__c> tissueSpecimenList = [select Id, Status__c from TissueSpecimenDetail__c where Id IN :tissueSpecimenIdSet];
			for(Core_Biopsy_Specimens__c cbs : Trigger.new) {
				for(TissueSpecimenDetail__c t : tissueSpecimenList){
					if(cbs.TissueSpecimenDetail__c == t.id){
					}
				}
			}
		}
	}
	
	List<Core_Biopsy_Specimens__c> lstCoreBiopsy = Trigger.new;
	Boolean isBulkified = true;
	Integer numberOfEntries = 0;
	
	Set<Id> tissueSpecimenIds = new Set<Id>();
	for(Core_Biopsy_Specimens__c cbs : Trigger.new) {
		tissueSpecimenIds.add(cbs.TissueSpecimenDetail__c);
	}
	
	//List<AggregateResult> agrResult = [Select TissueSpecimenDetail__c tsid,count(Id) specimens from Core_Biopsy_Specimens__c where TissueSpecimenDetail__c in :tissueSpecimenIds GROUP BY TissueSpecimenDetail__c];
	Map<String, integer> tissueSpecimenIdAndSpecimentCount = new Map<String, integer>();
	//for (AggregateResult ar : agrResult)  {
	//	tissueSpecimenIdAndSpecimentCount.put(String.valueOf(ar.get('tsid')), (integer)ar.get('specimens'));
	//}
	
	Map<Id, TissueSpecimenDetail__c> mapTSD = new Map<Id, TissueSpecimenDetail__c>([select Id, Time_Point__c, TrialPatient__c, TrialPatient__r.Subject_Id__c from TissueSpecimenDetail__c where Id IN :tissueSpecimenIds and TrialPatient__r.Subject_Id__c != null]);
	Set<Id> tpIds = new Set<Id>();
	for(Id id : mapTSD.keySet()) {
		tpIds.add(mapTSD.get(id).TrialPatient__c);
	}
	List<TissueSpecimenDetail__c> lstTSD = [Select TrialPatient__c, (Select Id From Core_Biopsy_Specimens__r where Shipped__c = 'Yes') From TissueSpecimenDetail__c t where TrialPatient__c IN :tpIds and Time_Point__c = 'Pre-Treatment'];
	Map<Id, List<Core_Biopsy_Specimens__c>> mapCoreBiopsies = new Map<Id, List<Core_Biopsy_Specimens__c>>();
	for(TissueSpecimenDetail__c ts : lstTSD) {
		mapCoreBiopsies.put(ts.TrialPatient__c, ts.Core_Biopsy_Specimens__r);
	}
	system.debug('mapCoreBiopsies : '+mapCoreBiopsies);
	for(Core_Biopsy_Specimens__c coreBiopsy : lstCoreBiopsy) {
		Integer numberOfPreTxCBS = 0;
		if(mapTSD.get(coreBiopsy.TissueSpecimenDetail__c) == null) continue;
		system.debug('mapTSD.get(coreBiopsy.TissueSpecimenDetail__c).Time_Point__c : '+mapTSD.get(coreBiopsy.TissueSpecimenDetail__c).Time_Point__c);
		if(mapTSD.get(coreBiopsy.TissueSpecimenDetail__c).Time_Point__c == 'Pre-Treatment Re-Biopsy') {
			List<Core_Biopsy_Specimens__c> lstPreTxCBS = mapCoreBiopsies.get(mapTSD.get(coreBiopsy.TissueSpecimenDetail__c).TrialPatient__c);
			system.debug('lstPreTxCBS : '+lstPreTxCBS);
			if(lstPreTxCBS != null) {
				numberOfPreTxCBS = lstPreTxCBS.size();
			}
		}
		if(tissueSpecimenIdAndSpecimentCount.containsKey(coreBiopsy.TissueSpecimenDetail__c)) {
			numberOfEntries = tissueSpecimenIdAndSpecimentCount.get(coreBiopsy.TissueSpecimenDetail__c);
			numberOfEntries++;
			coreBiopsy.Core_Specimen__c = String.valueOf(numberOfEntries);
			tissueSpecimenIdAndSpecimentCount.put(coreBiopsy.TissueSpecimenDetail__c, numberOfEntries);
		} else {
			coreBiopsy.Core_Specimen__c = '1';
			tissueSpecimenIdAndSpecimentCount.put(coreBiopsy.TissueSpecimenDetail__c, 1);
		}
		system.debug('mapTSD.get(coreBiopsy.TissueSpecimenDetail__c) : '+mapTSD.get(coreBiopsy.TissueSpecimenDetail__c));
		system.debug('mapTSD.get(coreBiopsy.TissueSpecimenDetail__c).TrialPatient__c : '+mapTSD.get(coreBiopsy.TissueSpecimenDetail__c).TrialPatient__c);
		coreBiopsy.SpecimenID__c = TissueSpecimenFormController.calculateSID(String.valueOf(coreBiopsy.Core_Specimen__c), mapTSD.get(coreBiopsy.TissueSpecimenDetail__c).Time_Point__c, mapTSD.get(coreBiopsy.TissueSpecimenDetail__c).TrialPatient__r.Subject_Id__c, numberOfPreTxCBS);
	}
}