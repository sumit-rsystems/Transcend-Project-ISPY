public with sharing class CTCAECodeLoader {
	public Blob fileBody {get;set;}
	public String fileName {get;set;}
	public void storeCSVRecords() {
		String xlsFile = fileBody.toString();
		List<List<String>> parsedContent = CSVParser.parseCSV(xlsFile, true);
		system.debug('parsedContent : '+parsedContent);
		if(fileName.contains('symptoms')) {
			system.debug('Symptoms uploaded : '+uploadSymptoms(parsedContent));
		} else if(fileName.contains('toxicity')) {
			system.debug('Toxicity uploaded : '+uploadToxicity(parsedContent));
		} else if(fileName.contains('ctcCodes')) {
			system.debug('ctcCodes uploaded : '+uploadCTCCodes(parsedContent));
		}
	}
	
	
	public integer uploadSymptoms(List<List<String>> parsedContent) {
		
		Map<String, SymptomMaster__c> mapSymptoms = new Map<String, SymptomMaster__c>();
		List<SymptomMaster__c> lstSymptom = [select Id, Name from SymptomMaster__c];
		for(SymptomMaster__c sm : lstSymptom) {
			mapSymptoms.put(sm.Name, sm);
		}
		
		for(List<String> lstData : parsedContent) {
			system.debug('lstData : '+lstData);
			if(!(lstData != null && !lstData.isEmpty())) continue;
			String sympName = lstData[0];
			
			if(mapSymptoms.containsKey(sympName)) {
				SymptomMaster__c symptoms = mapSymptoms.get(sympName);
				symptoms.Name = sympName;
			} else {
				SymptomMaster__c symptoms = new SymptomMaster__c();
				symptoms.Name = sympName;
				mapSymptoms.put(sympName, symptoms);
			}
			
		}
		List<SymptomMaster__c> lstSymptoms = mapSymptoms.values();
		upsert lstSymptoms;
		return lstSymptoms.size();
	}
	
	public integer uploadToxicity(List<List<String>> parsedContent) {
		Map<String, Toxicity_Master__c> mapToxicity = new Map<String, Toxicity_Master__c>();
		Map<String, SymptomMaster__c> mapSymptoms = new Map<String, SymptomMaster__c>();
		List<Toxicity_Master__c> lstToxicity = [Select t.Toxicity_Name__c, t.Symptom__c, t.Symptom_Master__c, t.Name, t.Grade_5__c, t.Grade_4__c, 
												t.Grade_3__c, t.Grade_2__c, t.Grade_1__c From Toxicity_Master__c t];
		for(Toxicity_Master__c tm : lstToxicity) {
			mapToxicity.put(tm.Toxicity_Name__c, tm);
		}
		List<SymptomMaster__c> lstSymptom = [select Id, Name from SymptomMaster__c];
		for(SymptomMaster__c sm : lstSymptom) {
			mapSymptoms.put(sm.Name, sm);
		}
		
		for(List<String> lstData : parsedContent) {
			system.debug('lstData : '+lstData);
			
			if(lstData.size() < 4) continue;
			String symp = lstData[0];
			symp = symp.trim();
			symp = symp.replaceAll('"', '');
			
			String tox = lstData[1];
			tox = tox.trim();
			tox = tox.replaceAll('"', '');
			
			String gradeNo = lstData[3];
			gradeNo = gradeNo.trim();
			gradeNo = gradeNo.replaceAll('"', '');
			
			String gdesc = lstData[4];
			gdesc = gdesc.trim();
			gdesc = gdesc.replaceAll('"', '');
			
			if(mapToxicity.containsKey(tox)) {
				system.debug('contains toxicity : '+mapToxicity.containsKey(tox));
				Toxicity_Master__c tempToxi = mapToxicity.get(tox);
				if(gradeNo == '1') {
					tempToxi.Grade_1__c = gdesc;
				} else if(gradeNo == '2') {
					tempToxi.Grade_2__c = gdesc;
				} else if(gradeNo == '3') {
					tempToxi.Grade_3__c = gdesc;
				} else if(gradeNo == '4') {
					tempToxi.Grade_4__c = gdesc;
				} else if(gradeNo == '5') {
					tempToxi.Grade_5__c = gdesc;
				}
			} else {
				system.debug('new toxicity : '+tox);
				if(mapSymptoms.get(symp) == null) continue;
				Toxicity_Master__c toxi = new Toxicity_Master__c();
				toxi.Toxicity_Name__c = tox;
				toxi.Symptom_Master__c = mapSymptoms.get(symp).Id;
				
				if(gradeNo == '1') {
					toxi.Grade_1__c = gdesc;
				} else if(gradeNo == '2') {
					toxi.Grade_2__c = gdesc;
				} else if(gradeNo == '3') {
					toxi.Grade_3__c = gdesc;
				} else if(gradeNo == '4') {
					toxi.Grade_4__c = gdesc;
				} else if(gradeNo == '5') {
					toxi.Grade_5__c = gdesc;
				}
				mapToxicity.put(tox, toxi);
			}
		}
		List<Toxicity_Master__c> lstToxicityMaster = mapToxicity.values();
		system.debug('lstToxicityMaster : '+lstToxicityMaster);
		upsert lstToxicityMaster;
		return lstToxicityMaster.size();
	}
	
	public integer uploadCTCCodes(List<List<String>> parsedContent) {
		
		Map<String, Toxicity_Master__c> mapToxicity = new Map<String, Toxicity_Master__c>();
		Map<String, SymptomMaster__c> mapSymptoms = new Map<String, SymptomMaster__c>();
		Map<String, CTCAECodeMaster__c> mapCTCCodes = new Map<String, CTCAECodeMaster__c>();
		
		List<Toxicity_Master__c> lstToxicity = [Select t.Toxicity_Name__c, t.Symptom__c, t.Symptom_Master__c, t.Name, t.Grade_5__c, t.Grade_4__c, t.Grade_3__c, t.Grade_2__c, t.Grade_1__c From Toxicity_Master__c t];
		for(Toxicity_Master__c tm : lstToxicity) {
			mapToxicity.put(tm.Toxicity_Name__c, tm);
		}
		
		List<SymptomMaster__c> lstSymptom = [select Id, Name from SymptomMaster__c];
		for(SymptomMaster__c sm : lstSymptom) {
			mapSymptoms.put(sm.Name, sm);
		}
		
		List<CTCAECodeMaster__c> lstCTCCodeMaster = [Select c.Toxicity_Master__c, c.Symptom_Master__c, c.Code__c From CTCAECodeMaster__c c];
		for(CTCAECodeMaster__c ctcCodes : lstCTCCodeMaster) {
			mapCTCCodes.put(ctcCodes.Code__c, ctcCodes);
		}
		
		for(List<String> lstData : parsedContent) {
			system.debug('lstData : '+lstData);
			String symp = lstData[0];
			symp = symp.trim();
			symp = symp.replaceAll('"', '');
			symp = symp.replaceAll('__COMMA__', ',');
			
			String tox = lstData[1];
			tox = tox.trim();
			tox = tox.replaceAll('"', '');
			tox = tox.replaceAll('__COMMA__', ',');
			
			String code = lstData[2];
			code = code.trim();
			code = code.replaceAll('"', '');
			
			if(mapToxicity.get(tox) != null && mapSymptoms.get(symp) != null) {
				if(mapCTCCodes.containsKey(code)) {
					CTCAECodeMaster__c codeMaster = mapCTCCodes.get(code);
					codeMaster.Code__c = code;
					codeMaster.Toxicity_Master__c = mapToxicity.get(tox).Id;
					codeMaster.Symptom_Master__c = mapSymptoms.get(symp).Id;
				} else {
					CTCAECodeMaster__c newCodeMaster = new CTCAECodeMaster__c();
					newCodeMaster.Code__c = code;
					newCodeMaster.Toxicity_Master__c = mapToxicity.get(tox).Id;
					newCodeMaster.Symptom_Master__c = mapSymptoms.get(symp).Id;
					mapCTCCodes.put(code, newCodeMaster);
				}
			}
		}
		List<CTCAECodeMaster__c> lstCodeMaster = mapCTCCodes.values();
		system.debug('lstCodeMaster : '+lstCodeMaster);
		upsert lstCodeMaster;
		return lstCodeMaster.size();
	}
	
	
}