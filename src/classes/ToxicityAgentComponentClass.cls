public with sharing class ToxicityAgentComponentClass {
	
	public List<WrapToxicity> lstWrapToxiAgent;
	public List<Selectoption> toxiStatusOptions{get;set;}
	public String aeid{get;set;}
	public String trialPatId{get;set;}
    public String TreatmentArmId;
    
    private boolean saveCalled = false;
    
    public void setTreatmentArmId(String tId) {
        system.debug('setting TreatmentArmId:'+TreatmentArmId);
        TreatmentArmId = tId;
        
        system.debug('lstWrapToxiAgent:'+lstWrapToxiAgent);
        if(lstWrapToxiAgent == null || lstWrapToxiAgent.isEmpty()) {
        	system.debug('calling getLstWrapToxiAgent');
        	lstWrapToxiAgent = getLstWrapToxiAgent();
        }
    } 
    public String getTreatmentArmId() {
       
        return TreatmentArmId;
    }
    
	private Boolean isFirstTime = true;
	
	public List<WrapToxicity> getLstWrapToxiAgent() {
        
		system.debug('__lstWrapToxiAgent__'+lstWrapToxiAgent);
		if(!isFirstTime) return lstWrapToxiAgent;
		 
		lstWrapToxiAgent = new List<WrapToxicity>();
		system.debug('__TreatmentArmId__'+TreatmentArmId);
        if(TreatmentArmId != null && TreatmentArmId != '') {
        	Arm__c armObj = [select Name from Arm__c where Id =:TreatmentArmId];
        	system.debug('__armObj__'+armObj);
        	List<String> agentNameList = armObj.Name.split(' \\+ ');
        	String toxicityAgentQuery = 'Select t.Toxicity_Master__r.Symptom_Master__c, t.Toxicity_Master__r.Toxicity_Name__c, t.Toxicity_Master__r.Symptom__c, t.Toxicity_Master__r.MedDRA_v12_0_Code__c, t.Toxicity_Master__r.Grade_5__c, t.Toxicity_Master__r.Grade_4__c, t.Toxicity_Master__r.Grade_3__c, t.Toxicity_Master__r.Grade_2__c, t.Toxicity_Master__r.Grade_1__c, t.Toxicity_Master__r.CTCAE_v4_0_AE_Term_Definition__c, t.Toxicity_Master__r.SystemModstamp, t.Toxicity_Master__r.LastModifiedById, t.Toxicity_Master__r.LastModifiedDate, t.Toxicity_Master__r.CreatedById, t.Toxicity_Master__r.CreatedDate, t.Toxicity_Master__r.Name, t.Toxicity_Master__r.IsDeleted, t.Toxicity_Master__r.OwnerId, t.Toxicity_Master__r.Id, t.Toxicity_Master__c, t.Agent__c From Toxicity_Agent__c t where ';
        	Integer counter = 0;
        	for(String agentName: agentNameList) {
        		counter++;
        		if(counter == 1) {
	        		toxicityAgentQuery+= ' Agent__r.Name like \'%'+agentName+'%\' ';
        		} else {
        			toxicityAgentQuery+= ' or Agent__r.Name like \'%'+agentName+'%\' ';
        		}
        	}
        	toxicityAgentQuery+= ' order by Toxicity_Master__r.Toxicity_Name__c';
        	system.debug('__toxicityAgentQuery__'+toxicityAgentQuery);
            List<Toxicity_Agent__c> lstToxicityAgent = Database.query(toxicityAgentQuery);
            List<Toxicity__c> lstToxicity = [select t.Was_event_life_threatning__c, Toxicity_Master__c, Symptom_Status__c, t.TrialPatient__c, t.Toxicity_Status__c, t.Toxicity_Other__c, t.SystemModstamp, t.Symptom_Masters__c, t.SAE__c, t.Result_persistent_significant_disability__c, t.Result_conginental_abnormality_defect__c, t.Resolved__c, t.Patient_Complaint__c, t.OwnerId, t.Onset_Date__c, t.Name, t.LastModifiedDate, t.LastModifiedById, t.IsDeleted, t.Id, t.Grade__c, t.Did_the_investigator_find_event_unusual__c, t.Did_event_result_in_death__c, t.Did_event_required_hospitalization__c, t.Effective_Time__c, t.CreatedById, t.Baseline_Symptoms_Form__c, t.Attribution__c, t.AE_ID__c, t.AE_End_Date__c, t.AE_Detail__c, Toxicity_Agent__c from Toxicity__c t where AE_Detail__c =:aeid and Toxicity_Agent__c != null];
            counter = 0;
            Set<string> toxicityNameSet = new Set<string>();
            for(Toxicity_Agent__c toxAgent : lstToxicityAgent) {
            	if(toxicityNameSet.contains(toxAgent.Toxicity_Master__r.Toxicity_Name__c))continue;
            	toxicityNameSet.add(toxAgent.Toxicity_Master__r.Toxicity_Name__c);
            	WrapToxicity wt = new WrapToxicity();
            	wt.toxicityAgentObj = toxAgent;
            	wt.toxAgentNum = ++counter;
            	//wt.isAddOnly = true;
            	for(Toxicity__c toxObj : lstToxicity) {
            		if(toxObj.Toxicity_Agent__c == toxAgent.Id) {
            			wt.toxicity = toxObj;
            			wt.toxicityStatus = toxObj.Toxicity_Status__c;
            			wt.selectedGrade = toxObj.Grade__c;
            			if(toxObj.Toxicity_Status__c != 'No') {
	            			wt.isToxicityAdded = true;
	            			wt.isReadOnly = true;
	            			wt.isAddOnly = false;
            			}
            		}
            	}
            	wt.gradeOptions.add(new Selectoption('','--None--'));
            	if(toxAgent.Toxicity_Master__r.Grade_1__c != null && toxAgent.Toxicity_Master__r.Grade_1__c != '-') {
                    wt.gradeOptions.add(new Selectoption('1 - '+toxAgent.Toxicity_Master__r.Grade_1__c,'1 - '+toxAgent.Toxicity_Master__r.Grade_1__c));
                }
                if(toxAgent.Toxicity_Master__r.Grade_2__c != null && toxAgent.Toxicity_Master__r.Grade_2__c != '-') {
                    wt.gradeOptions.add(new Selectoption('2 - '+toxAgent.Toxicity_Master__r.Grade_2__c,'2 - '+toxAgent.Toxicity_Master__r.Grade_2__c));
                }
                if(toxAgent.Toxicity_Master__r.Grade_3__c != null && toxAgent.Toxicity_Master__r.Grade_3__c != '-') {
                    wt.gradeOptions.add(new Selectoption('3 - '+toxAgent.Toxicity_Master__r.Grade_3__c,'3 - '+toxAgent.Toxicity_Master__r.Grade_3__c));
                }
                if(toxAgent.Toxicity_Master__r.Grade_4__c != null && toxAgent.Toxicity_Master__r.Grade_4__c != '-') {
                    wt.gradeOptions.add(new Selectoption('4 - '+toxAgent.Toxicity_Master__r.Grade_4__c,'4 - '+toxAgent.Toxicity_Master__r.Grade_4__c));
                }
                if(toxAgent.Toxicity_Master__r.Grade_5__c != null && toxAgent.Toxicity_Master__r.Grade_5__c != '-') {
                    wt.gradeOptions.add(new Selectoption('5 - '+toxAgent.Toxicity_Master__r.Grade_5__c,'5 - '+toxAgent.Toxicity_Master__r.Grade_5__c));
                }
            	lstWrapToxiAgent.add(wt);
            }
		}
		isFirstTime = false;
		return lstWrapToxiAgent;
	}
	
	public ToxicityAgentComponentClass() {
		aeid = Apexpages.currentPage().getParameters().get('aeid');
		system.debug('AE Id is here ToxicityAgentComponentClass.cls \t'+aeid);
		trialPatId = Apexpages.currentPage().getParameters().get('trialPat');
		system.debug('Trial Patient Id  is here ToxicityAgentComponentClass.cls \t'+trialPatId);
		
		String recordId = Apexpages.currentPage().getParameters().get('id');
		system.debug('Record Id   is here ToxicityAgentComponentClass.cls \t'+recordId);
		
		if(recordId != null) {
	    	String keyCode  = recordId.subString(0,3);
			for(Schema.SObjectType objectInstance : Schema.getGlobalDescribe().values()) {
				if(objectInstance.getDescribe().getKeyPrefix() == keyCode) {//do your processing with the API name what you want
					String objectName = objectInstance.getDescribe().getName();
					System.debug('Id is related to object: '+ objectName);
					if(objectName == 'AE_Detail__c') {
						//aeid = Apexpages.currentPage().getParameters().get('aeid');
						aeid = recordId;
						List<AE_Detail__c> lstAE = [select TrialPatient__c from AE_Detail__c where Id = :recordId];
						if(!lstAE.isEmpty()) {
							trialPatId = lstAE[0].TrialPatient__c;
						}
						break;
					}
				}
			}
		}
        system.debug('trialPatId: '+trialPatId);
	//create radio button options for toxicity status	
		toxiStatusOptions = new List<Selectoption>();
        toxiStatusOptions.add(new Selectoption('No','No'));
        toxiStatusOptions.add(new Selectoption('Yes','Yes'));
        toxiStatusOptions.add(new Selectoption('Not assessed','Not assessed'));
	}
	
	public void saveToxicity() {
		system.debug('now we r saving the toxicity after doing the changes line 133');
		String toxAgentIdValue = Apexpages.currentPage().getParameters().get('toxAgentId');
		system.debug('__toxAgentIdValue__'+toxAgentIdValue);
		List<Toxicity__c> lstInsertToxicity = new List<Toxicity__c>();
		List<Toxicity__c> lstDeleteToxicity = new List<Toxicity__c>();
		System.debug('lstWrapToxiAgent------------'+lstWrapToxiAgent);
		for(WrapToxicity wta : lstWrapToxiAgent) {
			wta.isShowError = false;
			wta.gradeErrorMsg = '';
			if(wta.toxicityAgentObj.Id == toxAgentIdValue) {
				if(wta.toxicityStatus == 'Yes') {
					system.debug('__wta.selectedGrade__'+wta.selectedGrade);
					if(wta.selectedGrade == null) {
						wta.gradeErrorMsg = 'Please select grades.';
						wta.isShowError = true;
                        break;
					}
					System.debug('Onset_Date__c------------------'+wta.toxicity.Onset_Date__c);
					if(wta.toxicity.Onset_Date__c > System.today()){
						wta.gradeErrorMsg = 'Start date cannot be future.';
						wta.isShowError = true;
                        break;
					}
					if(wta.toxicity.AE_End_Date__c > System.today()){
						wta.gradeErrorMsg = 'End date cannot be future.';
						wta.isShowError = true;
                        break;
					}
					if(wta.toxicity.Attribution__c == null) {
						wta.toxicity.Attribution__c.addError('Please select attribute');
                        break;
					}
					if(wta.toxicity.Onset_Date__c == null) {
						wta.toxicity.Onset_Date__c.addError('Please enter onset date');
                        break;
					}
					if(wta.toxicity.Patient_Complaint__c == null) {
						wta.toxicity.Patient_Complaint__c.addError('Please enter patient complaint');
                        break;
					}
					wta.toxicity.Grade__c = wta.selectedGrade;
					wta.toxicity.AE_Detail__c = aeid;
					wta.toxicity.Symptom_Masters__c = wta.toxicityAgentObj.Toxicity_Master__r.Symptom_Master__c;
					wta.toxicity.Symptom_Status__c = 'Yes';
					wta.toxicity.Toxicity_Status__c = wta.toxicityStatus;
					wta.toxicity.Toxicity_Agent__c = wta.toxicityAgentObj.Id;
					wta.toxicity.Toxicity_Master__c = wta.toxicityAgentObj.Toxicity_Master__c;
					wta.toxicity.TrialPatient__c = trialPatId;
					wta.toxicity.Name = wta.toxicityAgentObj.Toxicity_Master__r.Toxicity_Name__c;
					lstInsertToxicity.add(wta.toxicity);
					wta.isAddOnly = false;
					wta.isReadOnly = true;
					wta.isToxicityAdded = true;
					wta.isEditOnly = false;
				} else if(wta.toxicityStatus == 'No') {
					wta.toxicity.Grade__c = null;
					wta.selectedGrade = '';
					wta.toxicity.AE_Detail__c = aeid;
					wta.toxicity.Symptom_Masters__c = wta.toxicityAgentObj.Toxicity_Master__r.Symptom_Master__c;
					wta.toxicity.Symptom_Status__c = 'Yes';
					wta.toxicity.Toxicity_Status__c = wta.toxicityStatus;
					wta.toxicity.Toxicity_Agent__c = wta.toxicityAgentObj.Id;
					wta.toxicity.Toxicity_Master__c = wta.toxicityAgentObj.Toxicity_Master__c;
					wta.toxicity.TrialPatient__c = trialPatId;
					wta.toxicity.Name = wta.toxicityAgentObj.Toxicity_Master__r.Toxicity_Name__c;
					wta.toxicity.AE_End_Date__c = null;
					wta.toxicity.AE_ID__c = null;
					wta.toxicity.Attribution__c = null;
					wta.toxicity.Onset_Date__c = null;
					wta.toxicity.Patient_Complaint__c = null;
					wta.toxicity.SAE__c = null;
					wta.toxicity.Toxicity_Other__c = null;
					wta.toxicity.Resolved__c = false;
					wta.toxicity.Did_event_required_hospitalization__c = false;
					wta.toxicity.Did_event_result_in_death__c = false;
					wta.toxicity.Did_the_investigator_find_event_unusual__c = false;
					wta.toxicity.Result_conginental_abnormality_defect__c = false;
					wta.toxicity.Result_persistent_significant_disability__c = false;
					wta.toxicity.Was_event_life_threatning__c = false;
					lstInsertToxicity.add(wta.toxicity);
					wta.isAddOnly = false;
					wta.isReadOnly = true;
					wta.isToxicityAdded = false;
					wta.isEditOnly = false;
				} else if(wta.toxicityStatus == 'Not assessed') {
					wta.isAddOnly = false;
					if(wta.toxicity.Id != null) {
						lstDeleteToxicity.add(wta.toxicity);
					}
				}
			}
		}
		system.debug('__lstInsertToxicity__'+lstInsertToxicity);
		if(!lstInsertToxicity.isEmpty()) {
			upsert lstInsertToxicity;
			for(WrapToxicity wta : lstWrapToxiAgent) {
				for(Toxicity__c toxObj : lstInsertToxicity) {
					if(toxObj.Toxicity_Agent__c == wta.toxicityAgentObj.Id) {
						wta.toxicity = toxObj;
					}
				}
			}
		}
		
		system.debug('__lstDeleteToxicity__'+lstDeleteToxicity);
		if(!lstDeleteToxicity.isEmpty()) {
			delete lstDeleteToxicity;
			for(WrapToxicity wta : lstWrapToxiAgent) {
				if(wta.toxicityAgentObj.Id == toxAgentIdValue) {
					wta.toxicity = new Toxicity__c();
	    			wta.toxicityStatus = 'Not assessed';
	    			wta.selectedGrade = '';
	    			wta.isReadOnly = false;
        			wta.isToxicityAdded = false;
	    			wta.isAddOnly = false;
				}
			}
		}
	}
	
	/*public void cancelToxicity() {
		String toxAgentIdValue = Apexpages.currentPage().getParameters().get('toxAgentId');
		system.debug('__toxAgentIdValue__'+toxAgentIdValue);
		for(WrapToxicity wta : lstWrapToxiAgent) {
			if(wta.toxicityAgentObj.Id == toxAgentIdValue) {
				wta.toxicityStatus = 'Not assessed';
				wta.isReadOnly = false;
				wta.isAddOnly = true;
				wta.isEditOnly = false;
			}
		}
	}*/
	
	public void EditToxicity() {
		String toxAgentIdValue = Apexpages.currentPage().getParameters().get('toxAgentId');
		system.debug('__toxAgentIdValue__'+toxAgentIdValue);
		system.debug('Inside the Edit Toxicity function -------------------------ToxicityAgentComponentClass.cls');
		for(WrapToxicity wta : lstWrapToxiAgent) {
			if(wta.toxicityAgentObj.Id == toxAgentIdValue) {
				//wta.toxicityStatus = 'Not assessed';
				wta.isReadOnly = false;
				wta.isAddOnly = true;
				//wta.isToxicityAdded = false;
				wta.isEditOnly = true;
			}
		}
	}
	
	public void removeToxicity() {
		String toxAgentIdValue = Apexpages.currentPage().getParameters().get('toxAgentId');
		system.debug('__toxAgentIdValue__'+toxAgentIdValue);
		Boolean shouldDelete = false;
		List<Toxicity__c> lstDeleteToxicity = new List<Toxicity__c>();
		for(WrapToxicity wta : lstWrapToxiAgent) {
			if(wta.toxicityAgentObj.Id == toxAgentIdValue) {
				wta.isAddOnly = true;
				wta.isReadOnly = false;
				shouldDelete = true;
				//wta.isEditOnly = false;
				lstDeleteToxicity.add(wta.toxicity);
			}
		}
		
        /*if(shouldDelete) {
            lstWrapToxiAgent.remove(toxiNumValue-1);
            toxiNumber--;
        }*/
		
		system.debug('__lstDeleteToxicity__'+lstDeleteToxicity);
		if(!lstDeleteToxicity.isEmpty()) {
			delete lstDeleteToxicity;
			
			for(WrapToxicity wta : lstWrapToxiAgent) {
				if(wta.toxicityAgentObj.Id == toxAgentIdValue) {
					wta.toxicity = new Toxicity__c();
	    			wta.toxicityStatus = 'Not assessed';
	    			wta.selectedGrade = '';
	    			wta.isReadOnly = false;
        			wta.isToxicityAdded = false;
	    			wta.isAddOnly = false;
				}
			}
		}
		
	}
	
	/*public void updateToxicity() {
		
	}*/
	
	public void updateCancelToxicity() {
		String toxAgentIdValue = Apexpages.currentPage().getParameters().get('toxAgentId');
		system.debug('Inside the update cancel Toxicity ------------------------ToxicityAgentComponentClass.cls');
		if(toxAgentIdValue != null) {
			List<Toxicity__c> lstToxicity = [select t.Was_event_life_threatning__c, Toxicity_Master__c, Symptom_Status__c, t.TrialPatient__c, t.Toxicity_Status__c, t.Toxicity_Other__c, t.SystemModstamp, t.Symptom_Masters__c, t.SAE__c, t.Result_persistent_significant_disability__c, t.Result_conginental_abnormality_defect__c, t.Resolved__c, t.Patient_Complaint__c, t.OwnerId, t.Onset_Date__c, t.Name, t.LastModifiedDate, t.LastModifiedById, t.IsDeleted, t.Id, t.Grade__c, t.Did_the_investigator_find_event_unusual__c, t.Did_event_result_in_death__c, t.Did_event_required_hospitalization__c, t.Effective_Time__c, t.CreatedById, t.Baseline_Symptoms_Form__c, t.Attribution__c, t.AE_ID__c, t.AE_End_Date__c, t.AE_Detail__c, Toxicity_Agent__c from Toxicity__c t where AE_Detail__c =:aeid and Toxicity_Agent__c =:toxAgentIdValue];
			system.debug('__toxAgentIdValue__'+toxAgentIdValue);
			for(WrapToxicity wta : lstWrapToxiAgent) {
				if(wta.toxicityAgentObj.Id == toxAgentIdValue) {
					for(Toxicity__c toxObj : lstToxicity) {
	            		if(toxObj.Toxicity_Agent__c == wta.toxicityAgentObj.Id) {
	            			wta.toxicity = toxObj;
	            			wta.toxicityStatus = toxObj.Toxicity_Status__c;
	            			wta.selectedGrade = toxObj.Grade__c;
	            			wta.isReadOnly = true;
	            			wta.isAddOnly = false;
	            			
	            		}
	            	}
				}
			}
		}
	}
	
	public class WrapToxicity {
		public Toxicity_Agent__c toxicityAgentObj{get;set;}
		public Toxicity__c toxicity{get;set;}
		public List<Selectoption> gradeOptions {get;set;}
		public String selectedGrade{get;set;}
		public String toxicityStatus{get;set;}
		public String gradeErrorMsg{get;set;}
		public Boolean isShowError{get;set;}
		public Boolean isAddOnly{get;set;}
		public Boolean isReadOnly{get;set;}
		public Boolean isEditOnly{get;set;}
		public Boolean isToxicityAdded{get;set;}
		public Integer toxAgentNum{get;set;}
		public WrapToxicity() {
			toxicityStatus = 'Not assessed';
			toxicity = new Toxicity__c();
			gradeOptions = new List<Selectoption>();
			isAddOnly = false;
			isReadOnly = false;
			isToxicityAdded = false;
			isEditOnly = false;
			isShowError = false;
			//toxAgentNum = 0;
		}
 	}
}