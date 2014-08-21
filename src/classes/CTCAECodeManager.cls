public with sharing class CTCAECodeManager {
	static Map<String, String> mapCTCCode = new Map<String, String>();
	static {
		List<CTCAECodeMaster__c> lstCTCAECodeMaster = [Select c.Toxicity_Master__c, c.Symptom_Master__c, c.Code__c From CTCAECodeMaster__c c];
		for(CTCAECodeMaster__c ctcAe : lstCTCAECodeMaster) {
			mapCTCCode.put(ctcAe.Symptom_Master__c+'-'+ctcAe.Toxicity_Master__c, ctcAe.Code__c);
		}
	}
	
	public static String getCodeForSymptomAndToxicity(Id symptomId, Id toxicityId) {
		return mapCTCCode.get(symptomId+'-'+toxicityId);
	}
	
	public static void createCTCAECode(Set<Id> crfIds, String objectName) {
    	List<CTCAE_Code__c> lstCTCAECode = new List<CTCAE_Code__c>();
    	List<Sobject> lstSObject = Database.query('Select Status__c, Id, (Select Id, Toxicity_Master__c, Symptom_Masters__c, AE_Detail__c, Baseline_Symptoms_Form__c From Toxicities__r) From '+objectName+' where Id IN :crfIds and Status__c = \'Accepted\'');
    	for(Sobject sobj : lstSObject) {
    		List<Toxicity__c> lstToxicity = sobj.getSObjects('Toxicities__r');
    		if(lstToxicity == null) continue;
    		for(Toxicity__c t : lstToxicity) {
    			CTCAE_Code__c code = new CTCAE_Code__c();
    			if(objectName == 'BaselineSymptomsForm__c') {
					code.Baseline_Symptoms_Form__c = t.Baseline_Symptoms_Form__c;
    			}
    			if(objectName == 'AE_Detail__c') {
					code.AE_Detail__c = t.AE_Detail__c;
    			}
    			system.debug('t.Toxicity_Master__c: '+t.Toxicity_Master__c+', t.Symptom_Masters__c: '+t.Symptom_Masters__c);
				code.Code__c = CTCAECodeManager.getCodeForSymptomAndToxicity(t.Symptom_Masters__c, t.Toxicity_Master__c);
				code.Toxicity__c = t.Id;
				lstCTCAECode.add(code);
    		}
    	}
    	insert lstCTCAECode;
    }
	
}