public with sharing class AddToxicityComponent extends ComponentControllerBase{
    
    public String aeid{get;set;}
    public String baselineid{get;set;}
    public List<Toxicity_Master__c> ToxicityMasterList{get;set;}
    private List<Toxicity__c> toxicityListWithTrialPatient{get;set;}
    private boolean isFirstTime = true;
    private String trialPatientId{get;set;}
    private   List<SymptomsWrapper> lstSymptomsWrapper;
    
    public List<SymptomsWrapper> getLstSymptomsWrapper() {
        system.debug('___lstSymptomsWrapperBefore____'+lstSymptomsWrapper);
        if(!isFirstTime) return lstSymptomsWrapper;
        system.debug('==sau1==');
        
        lstSymptomsWrapper = new List<SymptomsWrapper>();
        List<Toxicity__c> toxicityList = new List<Toxicity__c>();
        List<SymptomMaster__c> symptomList = [Select Name, Id From SymptomMaster__c s order by Name];
        system.debug('==sau2=='+symptomList );
        
        system.debug('__symptomList__'+symptomList);
        if(aeid != null) {
            toxicityList = [Select t.Was_event_life_threatning__c, Toxicity_Master__c, Symptom_Status__c, t.TrialPatient__c, t.Toxicity_Status__c, t.Toxicity_Other__c, t.SystemModstamp, t.Symptom_Masters__c, t.SAE__c, t.Result_persistent_significant_disability__c, t.Result_conginental_abnormality_defect__c, t.Resolved__c, t.Patient_Complaint__c, t.OwnerId, t.Onset_Date__c, t.Name, t.LastModifiedDate, t.LastModifiedById, t.IsDeleted, t.Id, t.Grade__c, t.Did_the_investigator_find_event_unusual__c, t.Did_event_result_in_death__c, t.Did_event_required_hospitalization__c, t.Effective_Time__c, t.CreatedById, t.Baseline_Symptoms_Form__c, t.Attribution__c, t.AE_ID__c, t.AE_End_Date__c, t.AE_Detail__c From Toxicity__c t where AE_Detail__c =:aeid and Toxicity_Agent__c = null  ];
            system.debug('==sau2=='+toxicityList );
        } else if(baselineid != null) {
            toxicityList = [Select t.Was_event_life_threatning__c, Toxicity_Master__c, Symptom_Status__c, t.TrialPatient__c, t.Toxicity_Status__c, t.Toxicity_Other__c, t.SystemModstamp, t.Symptom_Masters__c, t.SAE__c, t.Result_persistent_significant_disability__c, t.Result_conginental_abnormality_defect__c, t.Resolved__c, t.Patient_Complaint__c, t.OwnerId, t.Onset_Date__c, t.Name, t.LastModifiedDate, t.LastModifiedById, t.IsDeleted, t.Id, t.Grade__c, t.Did_the_investigator_find_event_unusual__c, t.Did_event_result_in_death__c, t.Did_event_required_hospitalization__c, t.Effective_Time__c, t.CreatedById, t.Baseline_Symptoms_Form__c, t.Attribution__c, t.AE_ID__c, t.AE_End_Date__c, t.AE_Detail__c From Toxicity__c t where Baseline_Symptoms_Form__c =:baselineid  and Toxicity_Agent__c = null  ];
            system.debug('==sau3=='+toxicityList );
        }
        
        Integer counter = 0;
        for(SymptomMaster__c symptomObj : symptomList) {
            system.debug('==sau4=='+symptomList);
            SymptomsWrapper sWrapper = new SymptomsWrapper();
            sWrapper.symptomMaster = symptomObj;
            sWrapper.displayAddLink = 'none';
            for(Toxicity__c toxicityObj : toxicityList) {
                system.debug('==sau5=='+toxicityList);
                if(toxicityObj.Symptom_Masters__c == symptomObj.Id) {
                    sWrapper.displayAddLink = '';
                    //sWrapper.symptomStatus = 'Yes';
                    sWrapper.symptomStatus = toxicityObj.Symptom_Status__c;
                    if(toxicityObj.Symptom_Status__c == 'Yes') {
                      sWrapper.isShowLink = true;
                    } else {
                      sWrapper.isShowLink = false;
                    }
                    ToxicityWrapper ToxicityWrapObj = new ToxicityWrapper();
                    ToxicityWrapObj.toxicity = toxicityObj;
                    ToxicityWrapObj.isReadOnly = true;
                    ToxicityWrapObj.toxiNumber = sWrapper.lstToxicityWrapper.Size()+1;
                    system.debug('__ToxicityWrapObj.toxiNumber__'+ToxicityWrapObj.toxiNumber);
                    ToxicityWrapObj.toxicityStatusOptions.add(new Selectoption('No','No'));
                    ToxicityWrapObj.toxicityStatusOptions.add(new Selectoption('Yes','Yes'));
                    ToxicityWrapObj.toxicityStatusOptions.add(new Selectoption('Not assessed','Not assessed'));
                    ToxicityWrapObj.selectedToxicityStatus = ToxicityWrapObj.toxicity.Toxicity_Status__c;
                    //ToxicityWrapObj.selectedtoxicityName = ToxicityWrapObj.toxicity.Name;
                    ToxicityWrapObj.selectedtoxicityName = ToxicityWrapObj.toxicity.Toxicity_Master__c;
                    ToxicityWrapObj.selectedGrade = ToxicityWrapObj.toxicity.Grade__c;
                    sWrapper.lstToxicityWrapper.add(ToxicityWrapObj);
                }
            }
            lstSymptomsWrapper.add(sWrapper);
            system.debug('==sau6=='+sWrapper);
            system.debug('===sau7=='+lstSymptomsWrapper);
        }
        isFirstTime = false;
        system.debug('___lstSymptomsWrapperAfter____'+lstSymptomsWrapper);
        return lstSymptomsWrapper;
    }
    
   
    
    public void setLstSymptomsWrapper(List<SymptomsWrapper> lstSymptomsWrapper) {
        this.lstSymptomsWrapper = lstSymptomsWrapper;
    }
    
     public List<Selectoption> symptomStatusOptions {get;set;}
    
    
    public AddToxicityComponent() {
        String recordId = Apexpages.currentPage().getParameters().get('id');
      aeid = Apexpages.currentPage().getParameters().get('aeid');
        baselineid = Apexpages.currentPage().getParameters().get('baselineid');
        trialPatientId = Apexpages.currentPage().getParameters().get('trialPat');
        system.debug('==sau7==');
      
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
              trialPatientId = lstAE[0].TrialPatient__c;
            }
            break;
          } else if(objectName == 'BaselineSymptomsForm__c') {
            //baselineid = Apexpages.currentPage().getParameters().get('baselineid');
            baselineid = recordId;
            List<BaselineSymptomsForm__c> lstBaseline = [select TrialPatient__c from BaselineSymptomsForm__c where Id = :recordId];
            if(!lstBaseline.isEmpty()) {
              trialPatientId = lstBaseline[0].TrialPatient__c;
            }  
            break;    
          }
        }
      }
    }
        system.debug('trialPatientId: '+trialPatientId);
        
        ToxicityMasterList = new List<Toxicity_Master__c>();
        toxicityListWithTrialPatient = new List<Toxicity__c>();
    toxicityListWithTrialPatient = [Select t.Name, t.Resolved__c, Toxicity_Master__c, Effective_Time__c, Toxicity_Other__c From Toxicity__c t where TrialPatient__c =:trialPatientId and AE_Detail__r.Status__c != 'Rejected'  and Baseline_Symptoms_Form__r.Status__c != 'Rejected' and (Baseline_Symptoms_Form__c!= null or AE_Detail__c!=null)];
        /*if(aeid != null) {
          toxicityListWithTrialPatient = [Select t.Name, t.Resolved__c, Toxicity_Master__c, Effective_Time__c, Toxicity_Other__c From Toxicity__c t where Toxicity__c.TrialPatient__c =:trialPatientId and Toxicity__c.AE_Detail__r.Status__c != 'Rejected'];
        } else if(baselineid != null){
          toxicityListWithTrialPatient = [Select t.Name, t.Resolved__c, Toxicity_Master__c, Effective_Time__c, Toxicity_Other__c From Toxicity__c t where Toxicity__c.TrialPatient__c =:trialPatientId and Toxicity__c.Baseline_Symptoms_Form__r.Status__c != 'Rejected'];
        }*/
        
        symptomStatusOptions = new List<Selectoption>();
        symptomStatusOptions.add(new Selectoption('No','No'));
        symptomStatusOptions.add(new Selectoption('Yes','Yes'));
        symptomStatusOptions.add(new Selectoption('Not assessed','Not assessed'));
        system.debug('==sau8==');
        
    }
    
    
   public void addToxicity() {
        String symptomIdValue = Apexpages.currentPage().getParameters().get('symptomId');
        system.debug('symptomIdValue: '+symptomIdValue);
        //ToxicityMasterList = [Select t.Toxicity_Name__c, t.Symptom__c, t.Name, t.MedDRA_v12_0_Code__c, t.Id, t.Grade_5__c, t.Grade_4__c, t.Grade_3__c, t.Grade_2__c, t.Grade_1__c From Toxicity_Master__c t where Symptom__c =:symptomName];
        ToxicityMasterList = [Select t.Toxicity_Name__c, Symptom_Master__c, t.Symptom__c, t.Name, t.MedDRA_v12_0_Code__c, t.Id, t.Grade_5__c, t.Grade_4__c, t.Grade_3__c, t.Grade_2__c, t.Grade_1__c From Toxicity_Master__c t where Symptom_Master__c =:symptomIdValue];
        
        for(SymptomsWrapper sWrapper : lstSymptomsWrapper) {
            system.debug('symptoms Name : '+sWrapper.symptomMaster.Name);
            system.debug('symptomIdValue : '+symptomIdValue);
            //if(sWrapper.symptomArm.Symptom_Master__r.Name == symptomName) {
            if(sWrapper.symptomMaster.Id == symptomIdValue) {
                system.debug('start:'+sWrapper.lstToxicityWrapper.size());
                sWrapper.displayAddLink = 'block';
                sWrapper.isShowLink = true;
                ToxicityWrapper toxiWrapper = new ToxicityWrapper();
                //toxiWrapper.toxiNumber = sWrapper.lstToxicityWrapper.Size()+1;
                toxiWrapper.toxicity = new Toxicity__c();
                
                toxiWrapper.selectedToxicityStatus = 'Yes';
                toxiWrapper.toxicityStatusOptions.add(new Selectoption('No','No'));
                toxiWrapper.toxicityStatusOptions.add(new Selectoption('Yes','Yes'));
                toxiWrapper.toxicityStatusOptions.add(new Selectoption('Not assessed','Not assessed'));
                system.debug('__toxiWrapper.toxiNumber_before__'+toxiWrapper.toxiNumber);
                toxiWrapper.toxiNumber = sWrapper.lstToxicityWrapper.Size()+1;
                system.debug('__toxiWrapper.toxiNumber_after__'+toxiWrapper.toxiNumber);
                toxiWrapper.toxicityNameOptions.add(new Selectoption('','--None--'));
                toxiWrapper.gradeOptions.add(new Selectoption('','--None--'));
                toxiWrapper.isAddOnly = true;
                //Set<String> gradeNameSet = new Set<String>(); 
                for(Toxicity_Master__c ToxicityMasterObj : ToxicityMasterList) {
                    //toxiWrapper.toxicityNameOptions.add(new Selectoption(ToxicityMasterObj.Toxicity_Name__c,ToxicityMasterObj.Toxicity_Name__c));
                    toxiWrapper.toxicityNameOptions.add(new Selectoption(ToxicityMasterObj.Id,ToxicityMasterObj.Toxicity_Name__c));
                    //toxiWrapper.toxicityNameOptions.add(new Selectoption(ToxicityMasterObj.Id,ToxicityMasterObj.Name));
                }
                system.debug('Before:'+sWrapper.lstToxicityWrapper.size());
                sWrapper.lstToxicityWrapper.add(toxiWrapper);
                system.debug('sWrapper.lstToxicityWrapper.size: '+sWrapper.lstToxicityWrapper.size());
                system.debug('sWrapper.lstToxicityWrapper: '+sWrapper.lstToxicityWrapper);
            }
        }   
    }
    
    public void addGrade() {
        //String symptomName = Apexpages.currentPage().getParameters().get('symptomName');
        String symptomIdValue = Apexpages.currentPage().getParameters().get('symptomId');
        Integer toxiNumValue = Integer.valueOf(Apexpages.currentPage().getParameters().get('toxiNum'));
        system.debug('__toxiNumValue__'+toxiNumValue);
        system.debug('symptomIdValue: '+symptomIdValue);

    //toxicityListWithTrialPatient = [Select t.Name, t.Resolved__c, Toxicity_Master__c, Effective_Time__c, Toxicity_Other__c From Toxicity__c t where Toxicity__c.TrialPatient__c =:trialPatientId];
    toxicityListWithTrialPatient = [Select t.Name, t.Resolved__c, Toxicity_Master__c, Effective_Time__c, Toxicity_Other__c From Toxicity__c t where TrialPatient__c =:trialPatientId and AE_Detail__r.Status__c != 'Rejected'  and Baseline_Symptoms_Form__r.Status__c != 'Rejected' and (Baseline_Symptoms_Form__c!= null or AE_Detail__c!=null)];
        /*if(aeid != null) {
          toxicityListWithTrialPatient = [Select t.Name, t.Resolved__c, Toxicity_Master__c, Effective_Time__c, Toxicity_Other__c From Toxicity__c t where Toxicity__c.TrialPatient__c =:trialPatientId and Toxicity__c.AE_Detail__r.Status__c != 'Rejected'];
        } else if(baselineid != null){
          toxicityListWithTrialPatient = [Select t.Name, t.Resolved__c, Toxicity_Master__c, Effective_Time__c, Toxicity_Other__c From Toxicity__c t where Toxicity__c.TrialPatient__c =:trialPatientId and Toxicity__c.Baseline_Symptoms_Form__r.Status__c != 'Rejected'];
        }*/
    
        for(SymptomsWrapper sWrapper : lstSymptomsWrapper) {
            //if(sWrapper.symptomArm.Symptom_Master__r.Name == symptomName) {
            if(sWrapper.symptomMaster.Id == symptomIdValue) {
                for(ToxicityWrapper toxicityWrapObj : sWrapper.lstToxicityWrapper) {
                    system.debug('toxicityWrapObj.selectedtoxicityName: '+toxicityWrapObj.selectedtoxicityName);
                    if(toxicityWrapObj.selectedtoxicityName != null && toxicityWrapObj.toxiNumber == toxiNumValue) {
                        toxicityWrapObj.isToxiError = false;
                        for(Toxicity__c toxicityTmpObj : toxicityListWithTrialPatient) {
                          system.debug('toxicityTmpObj.Toxicity_Master__c: '+toxicityTmpObj.Toxicity_Master__c+', toxicityWrapObj.selectedtoxicityName: '+toxicityWrapObj.selectedtoxicityName);
                          system.debug('toxicityTmpObj.Resolved__c: '+toxicityTmpObj.Resolved__c);
                          system.debug('toxicityTmpObj.Toxicity_Other__c: '+toxicityTmpObj.Toxicity_Other__c+', toxicityWrapObj.toxicity.Toxicity_Other__c: '+toxicityWrapObj.toxicity.Toxicity_Other__c);
                            if(toxicityTmpObj.Toxicity_Master__c == toxicityWrapObj.selectedtoxicityName && toxicityTmpObj.Resolved__c == false) {
                              for(Selectoption toxiOption: toxicityWrapObj.toxicityNameOptions) {
                              if(toxiOption.getValue() == toxicityWrapObj.selectedtoxicityName && !toxiOption.getLabel().contains('Other, specify')) {
                                    toxicityWrapObj.isToxiErrorMsg = 'This toxicity is not resolved yet (Added on '+toxicityTmpObj.Effective_Time__c.format()+'). Please select another.';
                                    toxicityWrapObj.isToxiError = true;
                                    return;
                              }
                            }
                            }
                        }
                        toxicityWrapObj.isOtherSelected = false;
                        for(Selectoption toxiOption: toxicityWrapObj.toxicityNameOptions) {
                          system.debug('toxiOption.getLabel().contains: '+toxiOption.getLabel().contains('Other, specify'));
                          if(toxiOption.getValue() == toxicityWrapObj.selectedtoxicityName && toxiOption.getLabel().contains('Other, specify')) {
                            if(toxiOption.getLabel().contains('Other, specify')) {
                                toxicityWrapObj.isOtherSelected = true;
                            }
                          }
                        }
                        system.debug('toxicityWrapObj.isOtherSelected'+toxicityWrapObj.isOtherSelected);
                        toxicityWrapObj.gradeOptions.clear();
                        toxicityWrapObj.gradeOptions.add(new Selectoption('','--None--'));
                        for(Toxicity_Master__c ToxicityMasterObj : ToxicityMasterList) {
                            system.debug(' ToxicityMasterObj.Symptom__c: '+ToxicityMasterObj.Symptom__c+', symptomIdValue: '+symptomIdValue);
                            system.debug(' ToxicityMasterObj.Id: '+ToxicityMasterObj.Id+', toxicityWrapObj.selectedtoxicityName: '+toxicityWrapObj.selectedtoxicityName);
                            
                            //if(ToxicityMasterObj.Symptom__c == symptomName && ToxicityMasterObj.Toxicity_Name__c == toxicityWrapObj.selectedtoxicityName) {
                            if(ToxicityMasterObj.Symptom_Master__c == symptomIdValue && ToxicityMasterObj.Id == toxicityWrapObj.selectedtoxicityName) {
                                if(ToxicityMasterObj.Grade_1__c != null && ToxicityMasterObj.Grade_1__c != '-') {
                                    toxicityWrapObj.gradeOptions.add(new Selectoption('1 - '+ToxicityMasterObj.Grade_1__c,'1 - '+ToxicityMasterObj.Grade_1__c));
                                }
                                if(ToxicityMasterObj.Grade_2__c != null && ToxicityMasterObj.Grade_2__c != '-') {
                                    
                                    toxicityWrapObj.gradeOptions.add(new Selectoption('2 - '+ToxicityMasterObj.Grade_2__c,'2 - '+ToxicityMasterObj.Grade_2__c));
                                }
                                if(ToxicityMasterObj.Grade_3__c != null && ToxicityMasterObj.Grade_3__c != '-') {
                                    
                                    toxicityWrapObj.gradeOptions.add(new Selectoption('3 - '+ToxicityMasterObj.Grade_3__c,'3 - '+ToxicityMasterObj.Grade_3__c));
                                }
                                if(ToxicityMasterObj.Grade_4__c != null && ToxicityMasterObj.Grade_4__c != '-') {
                                    
                                    toxicityWrapObj.gradeOptions.add(new Selectoption('4 - '+ToxicityMasterObj.Grade_4__c,'4 - '+ToxicityMasterObj.Grade_4__c));
                                }
                                if(ToxicityMasterObj.Grade_5__c != null && ToxicityMasterObj.Grade_5__c != '-') {
                                    
                                    toxicityWrapObj.gradeOptions.add(new Selectoption('5 - '+ToxicityMasterObj.Grade_5__c,'5 - '+ToxicityMasterObj.Grade_5__c));
                                }
                            }
                        }
                        system.debug('toxicityWrapObj.gradeOptions: '+toxicityWrapObj.gradeOptions);
                    }
                }
                system.debug('__sWrapper.lstToxicityWrapper__'+sWrapper.lstToxicityWrapper);
            }
        }
        
    }
    
    public void saveToxicity() {
    	System.debug('Inside the Save toxicity Function in AddToxicityComponent.cls');
        Integer toxiNumValue = Integer.valueOf(Apexpages.currentPage().getParameters().get('toxiNum'));
       System.debug('Toxicity Number from AddToxicityComponent.cls'+toxiNumValue);
       
        String symptomIdValue = Apexpages.currentPage().getParameters().get('symptomId');
          System.debug('Symptom Id Value from AddToxicityComponent.cls'+symptomIdValue);
       
     
        system.debug('__toxiNumValue__'+toxiNumValue);
        toxicityListWithTrialPatient = [Select t.Name, t.Resolved__c, Toxicity_Master__c, Effective_Time__c, Toxicity_Other__c From Toxicity__c t where TrialPatient__c =:trialPatientId and AE_Detail__r.Status__c != 'Rejected'  and Baseline_Symptoms_Form__r.Status__c != 'Rejected' and (Baseline_Symptoms_Form__c!= null or AE_Detail__c!=null)];
         System.debug('toxicityListWithTrialPatient Value from AddToxicityComponent.cls'+toxicityListWithTrialPatient);
       
        List<Toxicity__c> insertToxicityList = new List<Toxicity__c>();
        Toxicity__c insertToxicity;
        for(SymptomsWrapper sWrapper : lstSymptomsWrapper) {
          if(sWrapper.symptomMaster.Id != symptomIdValue) continue;
            for(ToxicityWrapper toxicityWrapObj : sWrapper.lstToxicityWrapper) {
                toxicityWrapObj.isToxiError = false;
                system.debug('toxicityWrapObj.selectedtoxicityName: '+toxicityWrapObj.selectedtoxicityName+', toxicityWrapObj.selectedToxicityStatus: '+toxicityWrapObj.selectedToxicityStatus);
                if(toxicityWrapObj.selectedtoxicityName != null && toxicityWrapObj.selectedToxicityStatus == 'Yes') {
                    if(toxicityWrapObj.toxiNumber == toxiNumValue) {
                      system.debug('__toxicityWrapObj.toxiNumber__'+toxicityWrapObj.toxiNumber);
                        for(Toxicity__c toxicityTmpObj : toxicityListWithTrialPatient) {
                          system.debug('toxicityTmpObj.Toxicity_Master__c: '+toxicityTmpObj.Toxicity_Master__c+', toxicityWrapObj.selectedtoxicityName: '+toxicityWrapObj.selectedtoxicityName);
                          system.debug('toxicityTmpObj.Resolved__c: '+toxicityTmpObj.Resolved__c);
                          system.debug('toxicityTmpObj.Toxicity_Other__c: '+toxicityTmpObj.Toxicity_Other__c+', toxicityWrapObj.toxicity.Toxicity_Other__c: '+toxicityWrapObj.toxicity.Toxicity_Other__c);
                            if(toxicityTmpObj.Toxicity_Master__c == toxicityWrapObj.selectedtoxicityName && toxicityTmpObj.Resolved__c == false) {
                              for(Selectoption toxiOption: toxicityWrapObj.toxicityNameOptions) {
                                if(toxiOption.getValue() == toxicityWrapObj.selectedtoxicityName) {
                                if(!toxiOption.getLabel().contains('Other, specify')) {
                                      toxicityWrapObj.isToxiErrorMsg = 'This toxicity is not resolved yet (Added on '+toxicityTmpObj.Effective_Time__c.format()+'). Please select another.';
                                      toxicityWrapObj.isToxiError = true;
                                      return;
                                } else if(toxiOption.getLabel().contains('Other, specify') && toxicityTmpObj.Toxicity_Other__c == toxicityWrapObj.toxicity.Toxicity_Other__c){
                                  system.debug('else: ');
                                    toxicityWrapObj.isToxiErrorMsg = 'This toxicity is not resolved yet (Added on '+toxicityTmpObj.Effective_Time__c.format()+'). Please select another.';
                                      toxicityWrapObj.isToxiError = true;
                                      return;
                                }
                                }
                            }
                            }
                        }
            
            if(toxicityWrapObj.toxicity.Attribution__c == null) {
                            //toxicityWrapObj.isToxiErrorMsg = 'Please select Attribute.';
                            toxicityWrapObj.toxicity.Attribution__c.addError('Please select Attribute.');
                            //toxicityWrapObj.isToxiError = true;
                            return;
                        }
                        
                        if(toxicityWrapObj.toxicity.Onset_Date__c == null) {
                            toxicityWrapObj.isToxiErrorMsg = 'Please enter Onset Date.';
                            toxicityWrapObj.isToxiError = true;
                            return;
                        }
                        
                        
                        if(toxicityWrapObj.toxicity.Onset_Date__c > System.today()){
                      toxicityWrapObj.isToxiErrorMsg = 'Onset date cannot be future date.';
                        toxicityWrapObj.isToxiError = true;
                        return;
                    }
                        
                        if(toxicityWrapObj.toxicity.Resolved__c == true && toxicityWrapObj.toxicity.AE_End_Date__c == null) {
                            toxicityWrapObj.isToxiErrorMsg = 'Please enter End Date if you want to resolve this.';
                            toxicityWrapObj.isToxiError = true;
                            return;
                        }
                        if(toxicityWrapObj.toxicity.AE_End_Date__c > System.today()){
                      toxicityWrapObj.isToxiErrorMsg = 'End date cannot be future date.';
                        toxicityWrapObj.isToxiError = true;
                        return;
                    }
                        
                        toxicityWrapObj.isAddOnly = false;
                        toxicityWrapObj.isReadOnly = true;
                        toxicityWrapObj.toxicity.Symptom_Masters__c = sWrapper.symptomMaster.Id;
                        toxicityWrapObj.toxicity.Toxicity_Master__c = toxicityWrapObj.selectedtoxicityName;
                        for(Selectoption toxiOption : toxicityWrapObj.toxicityNameOptions) {
                          if(toxiOption.getValue() == toxicityWrapObj.selectedtoxicityName) {
                            if(toxiOption.getLabel().length()>80) {
                              toxicityWrapObj.toxicity.Name = toxiOption.getLabel().substring(0,77)+'...';
                            } else {
                              toxicityWrapObj.toxicity.Name = toxiOption.getLabel();
                            }
                            if(!toxiOption.getLabel().contains('Other, specify')) {
                              toxicityWrapObj.toxicity.Toxicity_Other__c = null;
                            }
                            break;
                          }
                        }
                        toxicityWrapObj.toxicity.Grade__c = toxicityWrapObj.selectedGrade;
                        toxicityWrapObj.toxicity.Toxicity_Status__c = toxicityWrapObj.selectedToxicityStatus;
                        toxicityWrapObj.toxicity.Symptom_Status__c = 'Yes';
                        System.debug('aeid: '+aeid+', baselineid: '+baselineid);
                        if(aeid != null) {
                            //toxicityObj.AE_Detail__c = aeid;
                            toxicityWrapObj.toxicity.AE_Detail__c = aeid;
                        } else if(baselineid != null) {
                            //toxicityObj.Baseline_Symptoms_Form__c = baselineid;
                            toxicityWrapObj.toxicity.Baseline_Symptoms_Form__c = baselineid;
                        }
                        System.debug('__toxicityWrapObj.toxicity__'+toxicityWrapObj.toxicity);
                        //insertToxicityList.add(toxicityWrapObj.toxicity);
                        insertToxicity = toxicityWrapObj.toxicity;
                    }
                } else if(toxicityWrapObj.selectedtoxicityName == null) {
                    toxicityWrapObj.isToxiErrorMsg = 'Please select Toxicity.';
                    toxicityWrapObj.isToxiError = true;
                    return;
                }
            }
        }
        
        if(insertToxicity != null) { 
          try {
          	insertToxicity.AE_Detail__c=Apexpages.currentPage().getParameters().get('id');
          	system.debug('Toxicity added object at line 378'+insertToxicity.AE_Detail__c);
            insert insertToxicity;
            }catch (Exception e) {
                Apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.ERROR, e.getMessage());
                System.debug('msg-------'+msg);
                Apexpages.addMessage(msg);
                return ;
            }
            
            Toxicity__c insertedToxicity = [select Id, AE_ID__c from Toxicity__c where Id =:insertToxicity.Id];
            system.debug('the toxicity object that is inserted is at line 387'+insertedToxicity);
            for(SymptomsWrapper sWrapper : lstSymptomsWrapper) {
              if(sWrapper.symptomMaster.Id != symptomIdValue) continue;
                for(ToxicityWrapper toxicityWrapObj : sWrapper.lstToxicityWrapper) {
                    if(toxicityWrapObj.toxiNumber == toxiNumValue) {
                        toxicityWrapObj.toxicity.AE_Id__c = insertedToxicity.AE_Id__c;
                    }   
                }               
            }
        }
    }
    
    public void removeToxicity() {
        Integer toxiNumValue = Integer.valueOf(Apexpages.currentPage().getParameters().get('toxiNum'));
        String symptomIdValue = Apexpages.currentPage().getParameters().get('symptomId');
        system.debug('__toxiNumValue__'+toxiNumValue);
        
        Boolean shouldDelete;
        List<Toxicity__c> deleteToxicityList = new List<Toxicity__c>();
        for(SymptomsWrapper sWrapper : lstSymptomsWrapper) {
            shouldDelete = false;
            if(sWrapper.symptomMaster.Id != symptomIdValue) continue;
            for(ToxicityWrapper toxicityWrapObj : sWrapper.lstToxicityWrapper) {
                if(toxicityWrapObj.toxiNumber == toxiNumValue) {
                    deleteToxicityList.add(toxicityWrapObj.toxicity);
                    shouldDelete = true;
                }
            }
            system.debug('__sWrapper.lstToxicityWrapper.size__'+sWrapper.lstToxicityWrapper.size());
            if(shouldDelete) {
                sWrapper.lstToxicityWrapper.remove(toxiNumValue-1);
            }
        }
        
        if(!deleteToxicityList.isEmpty()) {
            delete deleteToxicityList;
        }
    
    Map<Id, Toxicity__c> mapTox = new Map<Id, Toxicity__c>();
        if(symptomIdValue != null) {
          mapTox = new Map<Id, Toxicity__c>([Select t.Was_event_life_threatning__c, Toxicity_Master__c, Symptom_Status__c, t.TrialPatient__c, t.Toxicity_Status__c, t.Toxicity_Other__c, t.SystemModstamp, t.Symptom_Masters__c, t.SAE__c, t.Result_persistent_significant_disability__c, t.Result_conginental_abnormality_defect__c, t.Resolved__c, t.Patient_Complaint__c, t.OwnerId, t.Onset_Date__c, t.Name, t.LastModifiedDate, t.LastModifiedById, t.IsDeleted, t.Id, t.Grade__c, t.Did_the_investigator_find_event_unusual__c, t.Did_event_result_in_death__c, t.Did_event_required_hospitalization__c, t.Effective_Time__c, t.CreatedById, t.Baseline_Symptoms_Form__c, t.Attribution__c, t.AE_ID__c, t.AE_End_Date__c, t.AE_Detail__c From Toxicity__c t where AE_Detail__c =:aeid and Symptom_Masters__c =:symptomIdValue and Toxicity_Agent__c = null]); 
        }
        system.debug('mapTox.keySet(): '+mapTox.keySet());
        
        for(SymptomsWrapper sWrapper : lstSymptomsWrapper) {
          if(sWrapper.symptomMaster.Id != symptomIdValue) continue;
          Integer counter = 0;
            for(ToxicityWrapper toxicityWrapObj : sWrapper.lstToxicityWrapper) {
        if(mapTox.containsKey(toxicityWrapObj.toxicity.Id)) {
                toxicityWrapObj.toxicity = mapTox.get(toxicityWrapObj.toxicity.Id);
              }
                toxicityWrapObj.toxiNumber = (++counter);
            }
        }
    }
    
    public void cancelToxicity() {
        //String symptomNameValue = Apexpages.currentPage().getParameters().get('symptomName');
         String symptomIdValue = Apexpages.currentPage().getParameters().get('symptomId');
        Integer toxiNumValue = Integer.valueOf(Apexpages.currentPage().getParameters().get('toxiNum'));
        system.debug('__toxiNumValue__'+toxiNumValue);
        system.debug('__symptomIdValue__'+symptomIdValue);
        for(SymptomsWrapper sWrapper : lstSymptomsWrapper) {
            if(sWrapper.symptomMaster.Id == symptomIdValue) {
                if(!sWrapper.lstToxicityWrapper.isEmpty()) {
                  system.debug('__sWrapper.lstToxicityWrapper.Size()__'+sWrapper.lstToxicityWrapper.Size());
                    sWrapper.lstToxicityWrapper.remove(toxiNumValue-1);
                    break;
                }
            }
        }
        for(SymptomsWrapper sWrapper : lstSymptomsWrapper) {
          if(sWrapper.symptomMaster.Id != symptomIdValue) continue;
          Integer counter = 0;
            for(ToxicityWrapper toxicityWrapObj : sWrapper.lstToxicityWrapper) {
                toxicityWrapObj.toxiNumber = (++counter);
            }
        }
    }
    
    public void EditToxicity() {
        Integer toxiNumValue = Integer.valueOf(Apexpages.currentPage().getParameters().get('toxiNum'));
        //String symptomNameValue = Apexpages.currentPage().getParameters().get('symptomName');
        String symptomIdValue = Apexpages.currentPage().getParameters().get('symptomId');
        system.debug('__symptomIdValue__'+symptomIdValue);
        system.debug('__toxiNumValue__'+toxiNumValue);
        ToxicityMasterList = [Select t.Toxicity_Name__c, Symptom_Master__c, t.Symptom__c, t.Name, t.MedDRA_v12_0_Code__c, t.Id, t.Grade_5__c, t.Grade_4__c, t.Grade_3__c, t.Grade_2__c, t.Grade_1__c From Toxicity_Master__c t where Symptom_Master__c =:symptomIdValue];
        
        for(SymptomsWrapper sWrapper : lstSymptomsWrapper) {
          if(sWrapper.symptomMaster.Id != symptomIdValue) continue;
            for(ToxicityWrapper toxicityWrapObj : sWrapper.lstToxicityWrapper) {
                if(toxicityWrapObj.toxiNumber == toxiNumValue) {
                  system.debug('__toxicityWrapObj.toxicity.Name__'+toxicityWrapObj.toxicity.Name);
                  toxicityWrapObj.toxicityNameOptions.clear();
                  toxicityWrapObj.gradeOptions.clear();
                    toxicityWrapObj.toxicityNameOptions.add(new Selectoption('','--None--'));
                    toxicityWrapObj.gradeOptions.add(new Selectoption('','--None--'));
                    for(Toxicity_Master__c ToxicityMasterObj : ToxicityMasterList) {
                        toxicityWrapObj.toxicityNameOptions.add(new Selectoption(ToxicityMasterObj.Id,ToxicityMasterObj.Toxicity_Name__c));
                        if(ToxicityMasterObj.Id == toxicityWrapObj.toxicity.Toxicity_Master__c) {
                            if(ToxicityMasterObj.Grade_1__c != null && ToxicityMasterObj.Grade_1__c != '-') {
                                toxicityWrapObj.gradeOptions.add(new Selectoption('1 - '+ToxicityMasterObj.Grade_1__c,'1 - '+ToxicityMasterObj.Grade_1__c));
                            }
                            if(ToxicityMasterObj.Grade_2__c != null && ToxicityMasterObj.Grade_2__c != '-') {
                                toxicityWrapObj.gradeOptions.add(new Selectoption('2 - '+ToxicityMasterObj.Grade_2__c,'2 - '+ToxicityMasterObj.Grade_2__c));
                            }
                            if(ToxicityMasterObj.Grade_3__c != null && ToxicityMasterObj.Grade_3__c != '-') {
                                toxicityWrapObj.gradeOptions.add(new Selectoption('3 - '+ToxicityMasterObj.Grade_3__c,'3 - '+ToxicityMasterObj.Grade_3__c));
                            }
                            if(ToxicityMasterObj.Grade_4__c != null && ToxicityMasterObj.Grade_4__c != '-') {
                                toxicityWrapObj.gradeOptions.add(new Selectoption('4 - '+ToxicityMasterObj.Grade_4__c,'4 - '+ToxicityMasterObj.Grade_4__c));
                            }
                            if(ToxicityMasterObj.Grade_5__c != null && ToxicityMasterObj.Grade_5__c != '-') {
                                toxicityWrapObj.gradeOptions.add(new Selectoption('5 - '+ToxicityMasterObj.Grade_5__c,'5 - '+ToxicityMasterObj.Grade_5__c));
                            }
                        }
                    }
                    system.debug('__toxicityWrapObj.toxicity.Toxicity_Master__c__'+toxicityWrapObj.toxicity.Toxicity_Master__c);
                    toxicityWrapObj.selectedtoxicityName = toxicityWrapObj.toxicity.Toxicity_Master__c;
                    toxicityWrapObj.selectedToxicityBeforeEdit = toxicityWrapObj.toxicity.Toxicity_Master__c;
                    for(Selectoption toxiOption: toxicityWrapObj.toxicityNameOptions) {
                        system.debug('toxiOption.getLabel().contains: '+toxiOption.getLabel().contains('Other, specify'));
                      if(toxiOption.getValue() == toxicityWrapObj.selectedtoxicityName && toxiOption.getLabel().contains('Other, specify')) {
                          if(toxiOption.getLabel().contains('Other, specify')) {
                              toxicityWrapObj.isOtherSelected = true;
                          }
                      }
                    }
                    toxicityWrapObj.isReadOnly = false;
                    toxicityWrapObj.isEditOnly = true;
                }
            }
        }
    }
    
    public void updateToxicity() {
        Integer toxiNumValue = Integer.valueOf(Apexpages.currentPage().getParameters().get('toxiNum'));
        String symptomIdValue = Apexpages.currentPage().getParameters().get('symptomId');
        system.debug('__toxiNumValue__'+toxiNumValue);
        //toxicityListWithTrialPatient = [Select t.Name, t.Resolved__c, Toxicity_Master__c, Effective_Time__c, Toxicity_Other__c From Toxicity__c t where Toxicity__c.TrialPatient__c =:trialPatientId];
        toxicityListWithTrialPatient = new List<Toxicity__c>();
    toxicityListWithTrialPatient = [Select t.Name, t.Resolved__c, Toxicity_Master__c, Effective_Time__c, Toxicity_Other__c From Toxicity__c t where TrialPatient__c =:trialPatientId and AE_Detail__r.Status__c != 'Rejected'  and Baseline_Symptoms_Form__r.Status__c != 'Rejected' and (Baseline_Symptoms_Form__c!= null or AE_Detail__c!=null)];
        /*if(aeid != null) {
          toxicityListWithTrialPatient = [Select t.Name, t.Resolved__c, Toxicity_Master__c, Effective_Time__c, Toxicity_Other__c From Toxicity__c t where Toxicity__c.TrialPatient__c =:trialPatientId and Toxicity__c.AE_Detail__r.Status__c != 'Rejected'];
        } else if(baselineid != null){
          toxicityListWithTrialPatient = [Select t.Name, t.Resolved__c, Toxicity_Master__c, Effective_Time__c, Toxicity_Other__c From Toxicity__c t where Toxicity__c.TrialPatient__c =:trialPatientId and Toxicity__c.Baseline_Symptoms_Form__r.Status__c != 'Rejected'];
        }*/
      
        List<Toxicity__c> updateToxicityList = new List<Toxicity__c>();
        for(SymptomsWrapper sWrapper : lstSymptomsWrapper) {
          if(sWrapper.symptomMaster.Id != symptomIdValue) continue;
            for(ToxicityWrapper toxicityWrapObj : sWrapper.lstToxicityWrapper) {
                toxicityWrapObj.isToxiError = false;
                if(toxicityWrapObj.selectedtoxicityName != null && toxicityWrapObj.selectedToxicityStatus == 'Yes') {
                    if(toxicityWrapObj.toxiNumber == toxiNumValue) {
                        for(Toxicity__c toxicityTmpObj : toxicityListWithTrialPatient) {
                          system.debug('toxicityTmpObj.Toxicity_Master__c: '+toxicityTmpObj.Toxicity_Master__c+', toxicityWrapObj.selectedtoxicityName: '+toxicityWrapObj.selectedtoxicityName);
                            if(toxicityTmpObj.Toxicity_Master__c == toxicityWrapObj.selectedtoxicityName && toxicityTmpObj.Resolved__c == false && toxicityWrapObj.toxicity.Resolved__c == false) {
                            for(Selectoption toxiOption: toxicityWrapObj.toxicityNameOptions) {
                                if(toxiOption.getValue() == toxicityWrapObj.selectedtoxicityName && toxicityTmpObj.Id != toxicityWrapObj.toxicity.Id) {
                                if(!toxiOption.getLabel().contains('Other, specify')) {
                                      toxicityWrapObj.isToxiErrorMsg = 'This toxicity is not resolved yet (Added on '+toxicityTmpObj.Effective_Time__c.format()+'). Please select another.';
                                      toxicityWrapObj.isToxiError = true;
                                      return;
                                } else if(toxiOption.getLabel().contains('Other, specify') && toxicityTmpObj.Toxicity_Other__c == toxicityWrapObj.toxicity.Toxicity_Other__c){
                                  system.debug('else: ');
                                    toxicityWrapObj.isToxiErrorMsg = 'This toxicity is not resolved yet (Added on '+toxicityTmpObj.Effective_Time__c.format()+'). Please select another.';
                                      toxicityWrapObj.isToxiError = true;
                                      return;
                                }
                                }
                            }
                            }
                        }
            
            if(toxicityWrapObj.toxicity.Attribution__c == null) {
                            //toxicityWrapObj.isToxiErrorMsg = 'Please select Attribute.';
                            toxicityWrapObj.toxicity.Attribution__c.addError('Please select Attribute.');
                            //toxicityWrapObj.isToxiError = true;
                            return;
                        }
                        
                        if(toxicityWrapObj.toxicity.Onset_Date__c == null) {
                            toxicityWrapObj.isToxiErrorMsg = 'Please enter Onset Date.';
                            toxicityWrapObj.isToxiError = true;
                            return;
                        }
                        
                        if(toxicityWrapObj.toxicity.Resolved__c == true && toxicityWrapObj.toxicity.AE_End_Date__c == null) {
                            toxicityWrapObj.isToxiErrorMsg = 'Please enter End Date if you want to resolve this.';
                            toxicityWrapObj.isToxiError = true;
                            return;
                        }
                        toxicityWrapObj.isEditOnly = false;
                        toxicityWrapObj.isReadOnly = true;
                        toxicityWrapObj.toxicity.Symptom_Masters__c = sWrapper.symptomMaster.Id;
                        for(Selectoption toxiOption : toxicityWrapObj.toxicityNameOptions) {
                          if(toxiOption.getValue() == toxicityWrapObj.selectedtoxicityName) {
                            if(toxiOption.getLabel().length()>80) {
                              toxicityWrapObj.toxicity.Name = toxiOption.getLabel().substring(0,77)+'...';
                            } else {
                              toxicityWrapObj.toxicity.Name = toxiOption.getLabel();
                            }
                            if(!toxiOption.getLabel().contains('Other, specify')) {
                              toxicityWrapObj.toxicity.Toxicity_Other__c = null;
                            }
                            break;
                          }
                        }
                        //toxicityWrapObj.toxicity.Name = toxicityWrapObj.selectedtoxicityName;
                        toxicityWrapObj.toxicity.Toxicity_Master__c = toxicityWrapObj.selectedtoxicityName;
                        system.debug('__toxicityWrapObj.selectedGrade__'+toxicityWrapObj.selectedGrade);
                        toxicityWrapObj.toxicity.Grade__c = toxicityWrapObj.selectedGrade;
                        
                        if(aeid != null) {
                            //toxicityObj.AE_Detail__c = aeid;
                            toxicityWrapObj.toxicity.AE_Detail__c = aeid;
                        } else if(baselineid != null) {
                            //toxicityObj.Baseline_Symptoms_Form__c = baselineid;
                            toxicityWrapObj.toxicity.Baseline_Symptoms_Form__c = baselineid;
                        }
                        updateToxicityList.add(toxicityWrapObj.toxicity);
                    }
                } else if(toxicityWrapObj.selectedtoxicityName == null) {
                    toxicityWrapObj.isToxiErrorMsg = 'Please select Toxicity.';
                    toxicityWrapObj.isToxiError = true;
                    return;
                }
            }
        }
        
        System.debug('updateToxicityList-----------'+updateToxicityList);
        if(!updateToxicityList.isEmpty()) {
            try {
            update updateToxicityList;
            }catch (Exception e) {
                Apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.ERROR, e.getMessage());
                Apexpages.addMessage(msg);
                return ;
            }
        }
    }
    
    public void updateCancelToxicity() {
        Integer toxiNumValue = Integer.valueOf(Apexpages.currentPage().getParameters().get('toxiNum'));
        String symptomIdValue = Apexpages.currentPage().getParameters().get('symptomId');
        system.debug('__toxiNumValue__'+toxiNumValue);
        system.debug('__symptomIdValue__'+symptomIdValue);
        String toxicityId = '';
        for(SymptomsWrapper sWrapper : lstSymptomsWrapper) {
          if(sWrapper.symptomMaster.Id != symptomIdValue) continue;
            for(ToxicityWrapper toxicityWrapObj : sWrapper.lstToxicityWrapper) {
                if(toxicityWrapObj.toxiNumber == toxiNumValue) {
                    toxicityId = toxicityWrapObj.toxicity.Id;
                    toxicityWrapObj.isReadOnly = true;
                    toxicityWrapObj.isEditOnly = false;
                }
            }
        }
        
        List<Toxicity__c> toxicityTmpList = [Select t.Was_event_life_threatning__c, Toxicity_Master__c, t.TrialPatient__c, t.Toxicity_Status__c, t.Toxicity_Other__c, t.SystemModstamp, t.Symptom_Masters__c, t.SAE__c, t.Result_persistent_significant_disability__c, t.Result_conginental_abnormality_defect__c, t.Resolved__c, t.Patient_Complaint__c, t.OwnerId, t.Onset_Date__c, t.Name, t.LastModifiedDate, t.LastModifiedById, t.IsDeleted, t.Id, t.Grade__c, t.Did_the_investigator_find_event_unusual__c, t.Did_event_result_in_death__c, t.Did_event_required_hospitalization__c, t.Effective_Time__c, t.CreatedById, t.Baseline_Symptoms_Form__c, t.Attribution__c, t.AE_ID__c, t.AE_End_Date__c, t.AE_Detail__c From Toxicity__c t where Id =:toxicityId];
        for(SymptomsWrapper sWrapper : lstSymptomsWrapper) {
          if(sWrapper.symptomMaster.Id != symptomIdValue) continue;
            for(ToxicityWrapper toxicityWrapObj : sWrapper.lstToxicityWrapper) {
                if(toxicityWrapObj.toxicity.Id == toxicityId) {
                    for(Toxicity__c toxicityTmpObj : toxicityTmpList) {
                        toxicityWrapObj.selectedGrade = toxicityTmpObj.Grade__c;
                        //toxicityWrapObj.selectedtoxicityName = toxicityTmpObj.Name;
                        toxicityWrapObj.selectedtoxicityName = toxicityTmpObj.Toxicity_Master__c;
                        toxicityWrapObj.selectedToxicityStatus = toxicityTmpObj.Toxicity_Status__c;
                        toxicityWrapObj.toxicity = toxicityTmpObj;
                    }
                }
            }
        }
    }
    
    public void changeToxicitySymptomStatus() {
      String symptomIdValue = Apexpages.currentPage().getParameters().get('symptomId');
      System.debug('symptomIdValue-----------'+symptomIdValue);
      List<Toxicity__c> updateToxicityList = new List<Toxicity__c>();
      for(SymptomsWrapper sWrapper : lstSymptomsWrapper) {
        if(sWrapper.symptomMaster.Id != symptomIdValue) continue;
        if(sWrapper.symptomStatus == 'Yes') {
          sWrapper.isShowLink = true;
        } else {
          sWrapper.isShowLink = false;
        }
        for(ToxicityWrapper toxicityWrapObj : sWrapper.lstToxicityWrapper) {
          toxicityWrapObj.toxicity.Symptom_Status__c = sWrapper.symptomStatus;
          if(toxicityWrapObj.toxicity.Id != null) {
            updateToxicityList.add(toxicityWrapObj.toxicity);
          }
        }
      }
      
      if(!updateToxicityList.isEmpty()) {
            try {
            update updateToxicityList;
            }catch (Exception e) {
                Apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.ERROR, e.getMessage());
                Apexpages.addMessage(msg);
                return ;
            }
        }
    }
    
    public class SymptomsWrapper {
        public SymptomMaster__c symptomMaster {get;set;}
        public List<ToxicityWrapper> lstToxicityWrapper {get;set;}
        public String symptomStatus {get;set;}
        public Boolean isShowLink {get;set;}
        public String displayAddLink {get;set;}
        public SymptomsWrapper() {
            lstToxicityWrapper = new List<ToxicityWrapper>(); 
            symptomStatus = 'Not assessed';
            isShowLink = false;
        }
        
    }
    
    public class ToxicityWrapper {
        public integer toxiNumber {get;set;}
        public Toxicity__c toxicity {get;set;}
        public  List<Selectoption> toxicityStatusOptions {get;set;}
        public String selectedToxicityStatus{get;set;}
        public  List<Selectoption> toxicityNameOptions {get;set;}
        public String selectedtoxicityName{get;set;}
        public String selectedGrade{get;set;}
        public List<Selectoption> gradeOptions {get;set;}
        public Boolean isReadOnly{get;set;}
        public Boolean isEditOnly{get;set;}
        public Boolean isAddOnly{get;set;}
        public Boolean isToxiError{get;set;}
        public String isToxiErrorMsg{get;set;}
        public Boolean isOtherSelected{get;set;}
        public String selectedToxicityBeforeEdit{get;set;}
        public ToxicityWrapper() {
            toxiNumber = 0;
            isEditOnly = false;
            isReadOnly = false;
            isAddOnly = false;
            isToxiError = false;
            isOtherSelected = false;
            gradeOptions = new List<Selectoption>();
            toxicityNameOptions = new List<Selectoption>();
            toxicityStatusOptions = new List<Selectoption>();
        }
    }
}