trigger PrelElAfterInsert on PreEligibility_Checklist__c (after insert) {

	Set<id> patientIdset = new Set<id>();
	for(PreEligibility_Checklist__c pre : Trigger.new){
		patientIdset.add(pre.Patient__c);
	}
	Map<id,string> patientIdGroupNameMap = new Map<id,string>(); 
	if(!patientIdset.isEmpty()){
		List<Patient_Custom__c> patientList = [Select p.Institution__r.Inst_Group__c, p.Institution__c From Patient_Custom__c p where id IN :patientIdset];
		if(!patientList.isEmpty()){
			for(Patient_Custom__c p : patientList){
				if(p.Institution__c == null || p.Institution__r.Inst_Group__c == null)continue;
				patientIdGroupNameMap.put(p.id,p.Institution__r.Inst_Group__c);
			}
		}
	}
	List<Group> gList = [Select g.Name, g.Id From Group g where name in :patientIdGroupNameMap.values() and Type = 'Regular'];
    Map<String, Id> gNameIdMap = new Map<String, Id>();
    for(Group g :gList) {
    	gNameIdMap.put(g.Name, g.Id);
    }
    
	List<PreEligibility_Checklist__share> preElShareList = new List<PreEligibility_Checklist__share>();
	for(PreEligibility_Checklist__c pre : Trigger.new){
		if(pre.Patient__c != null){
			PreEligibility_Checklist__share shareRec = new PreEligibility_Checklist__share();
			shareRec.UserOrGroupId = gNameIdMap.get(patientIdGroupNameMap.get(pre.Patient__c));
			shareRec.AccessLevel = 'Edit';
			shareRec.ParentId = pre.Id;
			preElShareList.add(shareRec);
		}
	}
	insert preElShareList;
}