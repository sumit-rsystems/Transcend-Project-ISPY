public with sharing class RandomizationXMLBuilder {
    
    private static final Date baseDate = Date.newInstance(1950,1,1);
    
    public String notRandomizedReason;
    
    public void executeUpdatePatient() {
        //RandomizationXMLBuilder.updatePatientXML('a0gc00000009xC9');
    }
    
    @future
    public static void updateRunCalculationXML() {
        List<TrialPatientXML__c> lstTPXML =  [Select t.pCR_Value__c, t.pCR_Time__c, t.TrialPatientId__c, t.Subject_Id__c, t.Start_Time__c, t.MRI3_Value__c, t.MRI3_Time__c, t.MRI2_Value__c, t.MRI2_Time__c, t.MRI1_Value__c, t.MRI1_Time__c, t.MP__c, t.Id, t.HR__c, t.HER2__c, t.Arm__c From TrialPatientXML__c t];
        Integer days = baseDate.daysBetween(system.today()) + 2;
        List<TrialPatientXML__c> toUpdate = new List<TrialPatientXML__c>();
        for(TrialPatientXML__c tpXML : lstTPXML) {
        	System.debug('Subject_Id__c:'+tpXML.Subject_Id__c);
        	System.debug('tpXML.pCR_Value__c:'+tpXML.pCR_Value__c);
        	System.debug('tpXML.MRI1_Value__c:'+tpXML.MRI1_Value__c);
        	System.debug('tpXML.MRI2_Value__c:'+tpXML.MRI2_Value__c);
        	System.debug('tpXML.MRI3_Value__c:'+tpXML.MRI3_Value__c);
        	boolean addForUpdate = false;
        	if(tpXML.pCR_Value__c != null && tpXML.pCR_Value__c == -1) {
        		tpXML.pCR_Time__c = days;
        		addForUpdate = true;
        	}
        	if(tpXML.MRI1_Value__c != null && tpXML.MRI1_Value__c == -1) {
        		tpXML.MRI1_Time__c = days;
        		addForUpdate = true;
        	}
        	if(tpXML.MRI2_Value__c != null && tpXML.MRI2_Value__c == -1) {
        		tpXML.MRI2_Time__c = days;
        		addForUpdate = true;
        	}
        	if(tpXML.MRI3_Value__c != null && tpXML.MRI3_Value__c == -1) {
        		tpXML.MRI3_Time__c = days;
        		addForUpdate = true;
        	}
        	if(addForUpdate) {
        		toUpdate.add(tpXML);
        	}
        }
        if(!toUpdate.isEmpty()) {
        	update toUpdate;
        }
    }
    
    @future
    public static void updatePatientXMLForPCR(Set<Id> pssIdSet) {
    	
    	List<Post_Surgaory_Summary__c> pssList = [Select Id, Date_Of_Procedure__c, TrialPatient__c, Is_invasive_tumor_present__c, (Select l.Positive__c, l.Examined__c From Lymph_Nodes__r l) from Post_Surgaory_Summary__c where id in :pssIdSet and Status__c = 'Accepted'];
    	Set<Id> trialPatientIdSet = new Set<Id>();
    	for(Post_Surgaory_Summary__c pss : pssList) {
    		trialPatientIdSet.add(pss.TrialPatient__c);
    	}
    	
    	Date todaysDate = Date.today();
        Long dCurrentTime = baseDate.daysBetween(todaysDate);
        
    	List<TrialPatientXML__c> tpXmlList = [Select t.TrialPatientId__c, t.pCR_Value__c, t.pCR_Time__c From TrialPatientXML__c t where t.TrialPatientId__c  in :trialPatientIdSet];
    	for(Post_Surgaory_Summary__c pss : pssList) {
    		for(TrialPatientXML__c tpXml : tpXmlList) {
    			if(pss.TrialPatient__c == tpXml.TrialPatientId__c) {
    				PCRData pcr = getPCROutcomeData(pss, dCurrentTime);
    				tpXml.pCR_Value__c = pcr.pcrOutcome;
    				tpXml.pCR_Time__c = pcr.pcrOutcomeTime;
    				break;
    			}
    		}
    	}
    	update tpXmlList;
    }
    
    @future
    public static void updatePatientXMLForMRI1(Set<Id> trialPatientIds) {
    	System.debug('trialPatientIds:'+trialPatientIds);
    	List<TrialPatient__c> mPrintList = [Select Id, (Select MRI_Volume_in_cm3__c,TrialPatient__c,Time_Point__c from MRI_Volumes__r where (Time_Point__c = 'Pre-Treatment' or Time_Point__c = 'Early Treatment') and status__c = 'Accepted') from TrialPatient__c where Id in :trialPatientIds];
    	System.debug('mPrintList:'+mPrintList.size());
    	List<TrialPatientXML__c> tpXmlList = [Select t.TrialPatientId__c, t.MRI1_Value__c, t.MRI1_Time__c From TrialPatientXML__c t where t.TrialPatientId__c  in :trialPatientIds];
    	System.debug('tpXmlList:'+tpXmlList.size());
    	List<TrialPatientXML__c> toUpdate = new List<TrialPatientXML__c>();
    	for(TrialPatient__c tp : mPrintList) {
    		for(TrialPatientXML__c tpXml : tpXmlList) {
    			System.debug('Matching ids:'+tp.Id+' '+tpXml.TrialPatientId__c);
    			if(tp.Id == tpXml.TrialPatientId__c) {
    				System.debug('Match found');
    				List<MRI_Volume__c> mriList = tp.MRI_Volumes__r;
    				if(mriList.size() == 2 && mriList[0].MRI_Volume_in_cm3__c != null && mriList[1].MRI_Volume_in_cm3__c != null) {
    					decimal baselineVolume = null;
    					decimal newVolume = null;
    					if(mriList[0].Time_Point__c == 'Pre-Treatment') {
    						baselineVolume = mriList[0].MRI_Volume_in_cm3__c;
    						newVolume = mriList[1].MRI_Volume_in_cm3__c;
    					} else if(mriList[0].Time_Point__c == 'Early Treatment') {
    						baselineVolume = mriList[1].MRI_Volume_in_cm3__c;
    						newVolume = mriList[0].MRI_Volume_in_cm3__c;
    					} 
    					tpXml.MRI1_Value__c = getMRIVolume(newVolume, baselineVolume);
    					toUpdate.add(tpXml);
    				}
    				break;
    			}
    		}
    	}
    	System.debug('toUpdate:'+toUpdate);
    	update toUpdate;
    }
    
    @future
    public static void updatePatientXMLForMRI2(Set<Id> trialPatientIds) {
    	List<TrialPatient__c> mPrintList = [Select Id, (Select MRI_Volume_in_cm3__c,TrialPatient__c,Time_Point__c from MRI_Volumes__r where (Time_Point__c = 'Pre-Treatment' or Time_Point__c = 'Inter-Regimen') and status__c = 'Accepted') from TrialPatient__c where Id in :trialPatientIds];
    	List<TrialPatientXML__c> tpXmlList = [Select t.TrialPatientId__c, t.MRI1_Value__c, t.MRI1_Time__c From TrialPatientXML__c t where t.TrialPatientId__c  in :trialPatientIds];
    	List<TrialPatientXML__c> toUpdate = new List<TrialPatientXML__c>();
    	for(TrialPatient__c tp : mPrintList) {
    		for(TrialPatientXML__c tpXml : tpXmlList) {
    			if(tp.Id == tpXml.TrialPatientId__c) {
    				List<MRI_Volume__c> mriList = tp.MRI_Volumes__r;
    				if(mriList.size() == 2 && mriList[0].MRI_Volume_in_cm3__c != null && mriList[1].MRI_Volume_in_cm3__c != null) {
    					decimal baselineVolume = null;
    					decimal newVolume = null;
    					if(mriList[0].Time_Point__c == 'Pre-Treatment') {
    						baselineVolume = mriList[0].MRI_Volume_in_cm3__c;
    						newVolume = mriList[1].MRI_Volume_in_cm3__c;
    					} else if(mriList[0].Time_Point__c == 'Inter-Regimen') {
    						baselineVolume = mriList[1].MRI_Volume_in_cm3__c;
    						newVolume = mriList[0].MRI_Volume_in_cm3__c;
    					} 
    					tpXml.MRI2_Value__c = getMRIVolume(newVolume, baselineVolume);
    					toUpdate.add(tpXml);
    				}
    				break;
    			}
    		}
    	}
    	update toUpdate;
    }
    
    @future
    public static void updatePatientXMLForMRI3(Set<Id> trialPatientIds) {
    	List<TrialPatient__c> mPrintList = [Select Id, (Select MRI_Volume_in_cm3__c,TrialPatient__c,Time_Point__c from MRI_Volumes__r where (Time_Point__c = 'Pre-Treatment' or Time_Point__c = 'Pre-Surgery') and status__c = 'Accepted') from TrialPatient__c where Id in :trialPatientIds];
    	List<TrialPatientXML__c> tpXmlList = [Select t.TrialPatientId__c, t.MRI1_Value__c, t.MRI1_Time__c From TrialPatientXML__c t where t.TrialPatientId__c  in :trialPatientIds];
    	List<TrialPatientXML__c> toUpdate = new List<TrialPatientXML__c>();
    	for(TrialPatient__c tp : mPrintList) {
    		for(TrialPatientXML__c tpXml : tpXmlList) {
    			if(tp.Id == tpXml.TrialPatientId__c) {
    				List<MRI_Volume__c> mriList = tp.MRI_Volumes__r;
    				if(mriList.size() == 2 && mriList[0].MRI_Volume_in_cm3__c != null && mriList[1].MRI_Volume_in_cm3__c != null) {
    					decimal baselineVolume = null;
    					decimal newVolume = null;
    					if(mriList[0].Time_Point__c == 'Pre-Treatment') {
    						baselineVolume = mriList[0].MRI_Volume_in_cm3__c;
    						newVolume = mriList[1].MRI_Volume_in_cm3__c;
    					} else if(mriList[0].Time_Point__c == 'Pre-Surgery') {
    						baselineVolume = mriList[1].MRI_Volume_in_cm3__c;
    						newVolume = mriList[0].MRI_Volume_in_cm3__c;
    					} 
    					tpXml.MRI3_Value__c = getMRIVolume(newVolume, baselineVolume);
    					toUpdate.add(tpXml);
    				}
    				break;
    			}
    		}
    	}
    	update toUpdate;
    }
    
    @future
    public static void updatePatientXMLForStartDate(Set<Id> trialPatients) {
    	Map<Id, Chemo_Treatment__c> mapCT = new Map<Id, Chemo_Treatment__c>();
       	List<Chemo_Treatment__c> lstChemoTreatment = [Select c.TrialPatient__c, c.Effective_Time__c, c.Date_of_therapy__c From Chemo_Treatment__c c where TrialPatient__c IN :trialPatients and Status__c = 'Accepted' order by Date_of_therapy__c ASC];
       	List<TrialPatientXML__c> tpXmlList = [Select t.Start_Time__c,t.TrialPatientId__c From TrialPatientXML__c t where t.TrialPatientId__c  in :trialPatients];
    	List<TrialPatientXML__c> toUpdate = new List<TrialPatientXML__c>();
       	for(Chemo_Treatment__c ct : lstChemoTreatment) {
       		for(TrialPatientXML__c tpXml : tpXmlList) {
    			if(ct.TrialPatient__c == tpXml.TrialPatientId__c) {
				    if(ct.Date_of_therapy__c != null) {
		        		tpXml.Start_Time__c = baseDate.daysBetween(ct.Date_of_therapy__c); // Previosly startTime was difference between "chemoTreatment.Date_of_therapy__c.daysBetween(dCurrentTime);"
		        		toUpdate.add(tpXml);
			        }
    			}
       		}
		}
		update toUpdate;
    }

	@future
    public static void updateStartDate(Set<Id> trialPatients) {
    	List<Chemo_Treatment__c> lstChemoTreatment = [Select c.TrialPatient__c, c.Effective_Time__c, c.Date_of_therapy__c From Chemo_Treatment__c c where TrialPatient__c IN :trialPatients and Status__c = 'Accepted' order by Date_of_therapy__c desc limit 1];
    	List<TrialPatientXML__c> tpXmlList = [Select t.TrialPatientId__c, t.MRI1_Value__c, t.MRI1_Time__c From TrialPatientXML__c t where t.TrialPatientId__c  in :trialPatients];
    	List<TrialPatientXML__c> toUpdate = new List<TrialPatientXML__c>();
    	for(Chemo_Treatment__c tp : lstChemoTreatment) {
    		for(TrialPatientXML__c tpXml : tpXmlList) {
    			if(tp.TrialPatient__c == tpXml.TrialPatientId__c) {
    				tpXml.Start_Time__c = baseDate.daysBetween(tp.Date_of_therapy__c);
					toUpdate.add(tpXml);
				}
				break;
    		}
    	}
    	update toUpdate;
    }
    
    @future
    public static void updatePatientXML(Set<String> trialPatients) {
        RandomizationXMLBuilder randomizationXMLBuilder = new RandomizationXMLBuilder();
        Map<String, String> mapPatientXML = randomizationXMLBuilder.prepareCurrentPatientXML(trialPatients);
        //system.debug('patientXML : '+patientXML);
        //testXML = patientXML;
        if(!mapPatientXML.isEmpty()) {
            //patientXML = '<![CDATA[<current_patients>'+patientXML+'</current_patients>]]>';
            randomizationXMLBuilder.updatePatientXMLRecord(mapPatientXML);
        }
    }
    
    /*public RandomizationData prepareRandomizationXML(String trialPatientId) {
        RandomizationData rd = null;
        List<TrialPatient__c> lstTrialPatient = [Select t.Subject_Id__c, 
            t.Patient_Id__c, (Select MammaPrint_Risk__c, TargetPrint_Her_2_Status__c, TargetPrint_Her_2_Index__c, Phase__c, Risk_Category__c 
            From MammaPrint_Details__r where Status__c = 'Approval Not Required'),
            (Select MRI_Scan_Date__c, MRI_Volume_in_cm3__c, Time_Point__c From MRI_Volumes__r where Status__c = 'Accepted' order by MRI_Scan_Date__c ASC)
            From TrialPatient__c t where Id = :trialPatientId];

       Map<String, List<Receptors__c>> mapReceptor = new Map<String, List<Receptors__c>>();
       List<Receptors__c> lstReceptors = [Select r.On_Study_Pathology_Form__r.TrialPatient__c, r.On_Study_Pathology_Form__c, r.IHC__c, r.Fish__c, Progesterone_Receptor_Status__c, Estrogen_Receptor_Status__c From Receptors__c r where On_Study_Pathology_Form__r.Status__c = 'Accepted' and On_Study_Pathology_Form__r.TrialPatient__c = :trialPatientId];
       for(Receptors__c rec : lstReceptors) {
       		if(mapReceptor.containsKey(rec.On_Study_Pathology_Form__r.TrialPatient__c)) {
       			mapReceptor.get(rec.On_Study_Pathology_Form__r.TrialPatient__c).add(rec);
       		} else {
       			mapReceptor.put(rec.On_Study_Pathology_Form__r.TrialPatient__c, new List<Receptors__c>{rec});
       		}
       }
       List<String> lstPatientXML = new List<String>();
       for(TrialPatient__c trialPatient : lstTrialPatient) {
           rd = collectRandomizationInputs('Randomize', trialPatient, mapReceptor.get(trialPatient.Id), null, null);
        }
        return rd;
    }*/
    
    /* This Method is used to build currentPatientXML for each trial patient that we  
    	are passing as parameter. 
	*	Return type of this method will be the map of trialPatient and corresponding xml    
    */
    
    public RandomizePatient.RandomizationResponseWrapper randomizePatient(RandomizePatient.RandomizationEligibilityData red, Id trialPatientId, boolean patientBelongsToTestSite, boolean testHarnessRun, String trialName) {
    	
    	RandomizePatient.RandomizationData rd = getRandomizationData(trialPatientId);
		RandomizePatient.RandomizationProperties randProps = null;
		RandomizePatient.RandomizationResponseWrapper randRespWrapper = null;
		List<RandomizationProperty__c> rList = [Select r.nSeed2__c, r.nSeed1__c, r.RunCalculationResult__c, r.End_Point_URL__c, r.CurrentPatientXML__c From RandomizationProperty__c r order by r.LastModifiedDate desc limit 1 ];
		if(rList.isEmpty()) {
			randRespWrapper = new RandomizePatient.RandomizationResponseWrapper();
			randRespWrapper.notRandomizedReason = 'Randomization Properties record does not exist. Without that randomziation cannot be done.';
			randRespWrapper.treatment = 'Not Randomized'; 
		} else {
			RandomizationProperty__c rp = rList[0];
			if(rp.nSeed2__c == null) {
				randRespWrapper = new RandomizePatient.RandomizationResponseWrapper();
				randRespWrapper.notRandomizedReason = 'nSeed2 has null value in Randomization Properties record';
				randRespWrapper.treatment = 'Not Randomized';
			} else if(rp.nSeed1__c == null) {
				randRespWrapper = new RandomizePatient.RandomizationResponseWrapper();
				randRespWrapper.notRandomizedReason = 'nSeed1 has null value in Randomization Properties record';
				randRespWrapper.treatment = 'Not Randomized';
			} else if(rp.RunCalculationResult__c == null) {
				randRespWrapper = new RandomizePatient.RandomizationResponseWrapper();
				randRespWrapper.notRandomizedReason = 'Run Calculation xml is null in Randomization Properties record';
				randRespWrapper.treatment = 'Not Randomized';
			} else if(rp.End_Point_URL__c == null) {
				randRespWrapper = new RandomizePatient.RandomizationResponseWrapper();
				randRespWrapper.notRandomizedReason = 'End point URL is null in Randomization Properties record';
				randRespWrapper.treatment = 'Not Randomized';
			} else if(rp.CurrentPatientXML__c == null) {
				randRespWrapper = new RandomizePatient.RandomizationResponseWrapper();
				randRespWrapper.notRandomizedReason = 'Current Patient XML is null in Randomization Properties record';
				randRespWrapper.treatment = 'Not Randomized';
			} else {
				randProps = new RandomizePatient.RandomizationProperties();
				randProps.currentPatientXML = rp.CurrentPatientXML__c;
				randProps.engineURL = rp.End_Point_URL__c;
				randProps.nSeed1 = (long)rp.nSeed1__c;
				randProps.nSeed2 = (long)rp.nSeed2__c;
				randProps.runCalcResult = rp.RunCalculationResult__c;
				
				randRespWrapper = RandomizePatient.randomize(red, patientBelongsToTestSite, randProps, rd, trialName);
				system.debug('randRespWrapper:'+randRespWrapper);
				
				if(randRespWrapper.isEligible) {
					saveRandomizationResponse(randRespWrapper, trialPatientId, testHarnessRun);
					if(randRespWrapper.treatment != null && randRespWrapper.treatment != '' && randRespWrapper.treatment != 'Not Randomized') {
						createArmPatient(trialPatientId, randRespWrapper.treatment);
					}
				}
			}
		}
		system.debug('randRespWrapper:'+randRespWrapper);
		return randRespWrapper;
    }
    
    private void saveRandomizationResponse(RandomizePatient.RandomizationResponseWrapper randRespWrapper, Id trialPatientId, boolean testHarnessRun) {
		
		//do not update live seed values when the run is through test harness
		if(!testHarnessRun) {
			List<RandomizationProperty__c> lstRandProp = [Select r.nSeed2__c, r.nSeed1__c, r.RunCalculationResult__c, r.PatientId__c, r.CurrentPatientXML__c From RandomizationProperty__c r];
			if(!lstRandProp.isEmpty()) {
				if(randRespWrapper.nSeed1 != null) {
					lstRandProp[0].nSeed1__c = Double.valueOf(randRespWrapper.nSeed1);
				}
				if(randRespWrapper.nSeed2 != null) {
					lstRandProp[0].nSeed2__c = Double.valueOf(randRespWrapper.nSeed2);
				}
				update lstRandProp[0];
			} else {
				RandomizationProperty__c randProp = new RandomizationProperty__c();
				if(randRespWrapper.nSeed1 != null) {
					randProp.nSeed1__c = Double.valueOf(randRespWrapper.nSeed1);
				}
				if(randRespWrapper.nSeed2 != null) {
					randProp.nSeed2__c = Double.valueOf(randRespWrapper.nSeed2);
				}
				if(randRespWrapper.treatment != null && randRespWrapper.treatment != 'Not Randomized') {
					insert randProp;
				}
			}
		}
		
		if(trialPatientId != null) {
			List<Randomization_Form__c> lstRandomizationForm = [Select r.Not_Randomized_Reason__c,r.Test_Case_Number__c, r.RecordTypeId, r.TrialPatient__r.Patient_Id__c, r.TrialPatient__c, r.Randomization_Result__c From Randomization_Form__c r where TrialPatient__c = :trialPatientId];
			if(!lstRandomizationForm.isEmpty()) {
				List<RecordType> lstRecordType_NotRandomized = [select Id from RecordType where SobjectType = 'Randomization_Form__c' and Name = 'NotRandomized'];
				List<RecordType> lstRecordType_Complete = [select Id from RecordType where SobjectType = 'Randomization_Form__c' and Name = 'Live'];
				if(randRespWrapper.treatment != null && randRespWrapper.treatment != '' && randRespWrapper.treatment != 'Not Randomized') {
					lstRandomizationForm[0].Randomization_Result__c = randRespWrapper.treatment;
					lstRandomizationForm[0].RecordTypeId = lstRecordType_Complete[0].Id;
				} else {
					lstRandomizationForm[0].Randomization_Result__c = 'Not Randomized';
					lstRandomizationForm[0].RecordTypeId = lstRecordType_NotRandomized[0].Id;
				}
				system.debug('randRespWrapper.testCaseNumber:'+randRespWrapper.testCaseNumber);
				lstRandomizationForm[0].Test_Case_Number__c = randRespWrapper.testCaseNumber;
				system.debug('lstRandomizationForm[0].Test_Case_Number__c:'+lstRandomizationForm[0].Test_Case_Number__c);
				lstRandomizationForm[0].Not_Randomized_Reason__c = randRespWrapper.notRandomizedReason;
				update lstRandomizationForm;
			}
		}
	}
	
	private void createArmPatient(String trialPatient, String randomzationResult) {
		
		List<ArmPatient__c> lstArmPatient = [select Name, TrialPatient__c, assignedToPatient__c from ArmPatient__c where TrialPatient__c = :trialPatient];
		delete lstArmPatient;
		
		List<Arm__c> lstArm = [select Id, Name from Arm__c where Name = :randomzationResult];
		if(!lstArm.isEmpty()) {
			lstArmPatient = [select Name, TrialPatient__c, assignedToPatient__c from ArmPatient__c where TrialPatient__c = :trialPatient and Arm_Id__c =:lstArm[0].Id];
			for(ArmPatient__c armPatient : lstArmPatient) {
				armPatient.assignedToPatient__c = true;
			}
			if(!lstArmPatient.isEmpty()) {
				update lstArmPatient;
				system.debug('lstArmPatient : '+lstArmPatient);
			} else {
				ArmPatient__c armPatient1 = new ArmPatient__c();
				armPatient1.assignedToPatient__c = true;
				armPatient1.Arm_Id__c = lstArm[0].Id;
				armPatient1.TrialPatient__c = trialPatient;
				insert armPatient1;
				
				system.debug('armPatient1 : '+armPatient1);
			}
		} else {
			Arm__c arm = new Arm__c();
			arm.Name = randomzationResult;
			insert arm;
			
			system.debug('arm : '+arm);
			
			ArmPatient__c armPatient2 = new ArmPatient__c();
			armPatient2.assignedToPatient__c = true;
			armPatient2.Arm_Id__c = arm.Id;
			armPatient2.TrialPatient__c = trialPatient;
			insert armPatient2;
			
			system.debug('armPatient2 : '+armPatient2);
		}
	}
    
    private RandomizePatient.RandomizationData getRandomizationData(Id trialPatientId) {
        
        List<TrialPatient__c> lstTrialPatient = [Select t.Subject_Id__c, 
            t.Patient_Id__c, (Select MammaPrint_Risk__c, TargetPrint_Her_2_Status__c, TargetPrint_Her_2_Index__c, Phase__c, Risk_Category__c 
            From MammaPrint_Details__r where Status__c = 'Approval Not Required'),
            (Select MRI_Scan_Date__c, MRI_Volume_in_cm3__c, Time_Point__c From MRI_Volumes__r where Status__c = 'Accepted' order by MRI_Scan_Date__c ASC)
            From TrialPatient__c t where Id = :trialPatientId];

		Map<String, List<Receptors__c>> mapReceptor = new Map<String, List<Receptors__c>>();
		List<Receptors__c> lstReceptors = [Select r.On_Study_Pathology_Form__r.TrialPatient__c, r.On_Study_Pathology_Form__c, r.IHC__c, r.Fish__c, Progesterone_Receptor_Status__c, Estrogen_Receptor_Status__c From Receptors__c r where On_Study_Pathology_Form__r.Status__c = 'Accepted' and On_Study_Pathology_Form__r.TrialPatient__c = :trialPatientId];
		for(Receptors__c rec : lstReceptors) {
	   		if(mapReceptor.containsKey(rec.On_Study_Pathology_Form__r.TrialPatient__c)) {
	   			mapReceptor.get(rec.On_Study_Pathology_Form__r.TrialPatient__c).add(rec);
	   		} else {
	   			mapReceptor.put(rec.On_Study_Pathology_Form__r.TrialPatient__c, new List<Receptors__c>{rec});
	   		}
   		}
   		List<String> lstPatientXML = new List<String>();
   		RandomizePatient.RandomizationData rd = null;
   		for(TrialPatient__c trialPatient : lstTrialPatient) {
       		rd = collectRandomizationInputs('Randomize', trialPatient, mapReceptor.get(trialPatient.Id), null, null);
  	 	}
   		return rd;
    }
    
    private Map<String, String> prepareCurrentPatientXML(Set<String> trialPatients) {
    	system.debug('trialPatients : '+trialPatients);
        String patientXML = '';
        List<TrialPatient__c> lstTrialPatient = [Select t.Subject_Id__c,
            t.Patient_Id__c, Site__r.IsTestSite__c, (Select MammaPrint_Risk__c, TargetPrint_Her_2_Status__c, TargetPrint_Her_2_Index__c, Phase__c, Risk_Category__c 
            From MammaPrint_Details__r where Status__c = 'Approval Not Required'), (Select Effective_Time__c, Did_Patient_Sign_Treatment_Consent_Form__c, Randomization_Result__c From Randomization_Forms__r  where Status__c = 'Approval Not Required' order by CreatedDate DESC),
            (Select MRI_Scan_Date__c, MRI_Volume_in_cm3__c, Time_Point__c From MRI_Volumes__r  where Status__c = 'Accepted' order by MRI_Scan_Date__c ASC),
            (Select Date_of_therapy__c From Chemo_Treatments__r where Status__c = 'Accepted' order by Date_of_therapy__c asc limit 1)
            From TrialPatient__c t where Id IN :trialPatients and Site__r.IsTestSite__c = false and Subject_Id__c != null];
            
       Map<String, List<Receptors__c>> mapReceptor = new Map<String, List<Receptors__c>>();
       List<Receptors__c> lstReceptors = [Select r.On_Study_Pathology_Form__r.TrialPatient__c, r.On_Study_Pathology_Form__c, r.IHC__c, r.Fish__c, Progesterone_Receptor_Status__c, Estrogen_Receptor_Status__c From Receptors__c r where On_Study_Pathology_Form__r.TrialPatient__c IN :trialPatients and On_Study_Pathology_Form__r.Status__c = 'Accepted'];
       for(Receptors__c rec : lstReceptors) {
       		if(mapReceptor.containsKey(rec.On_Study_Pathology_Form__r.TrialPatient__c)) {
       			mapReceptor.get(rec.On_Study_Pathology_Form__r.TrialPatient__c).add(rec);
       		} else {
       			mapReceptor.put(rec.On_Study_Pathology_Form__r.TrialPatient__c, new List<Receptors__c>{rec});
       		}
       }
       
       Map<Id, Post_Surgaory_Summary__c> mapPSS = new Map<Id, Post_Surgaory_Summary__c>();
	   List<Post_Surgaory_Summary__c> lstPostSurgery = [Select p.pcr__c, p.TrialPatient__c, p.Date_Of_Procedure__c, p.Is_invasive_tumor_present__c, (Select Total_Positive__c From Procedures__r), (Select l.Positive__c, l.Examined__c From Lymph_Nodes__r l) From Post_Surgaory_Summary__c p where TrialPatient__c IN :trialPatients and Status__c = 'Accepted' order by CreatedDate desc];
	   for(Post_Surgaory_Summary__c pss : lstPostSurgery) {
		    if(!mapPSS.containsKey(pss.TrialPatient__c)) {
		    	mapPSS.put(pss.TrialPatient__c, pss);
		    }
		}
       
       Map<Id, Chemo_Treatment__c> mapCT = new Map<Id, Chemo_Treatment__c>();
       List<Chemo_Treatment__c> lstChemoTreatment = [Select c.TrialPatient__c, c.Effective_Time__c, c.Date_of_therapy__c From Chemo_Treatment__c c where TrialPatient__c IN :trialPatients and Status__c = 'Accepted' order by Date_of_therapy__c ASC];
       for(Chemo_Treatment__c ct : lstChemoTreatment) {
		    if(!mapCT.containsKey(ct.TrialPatient__c)) {
		    	mapCT.put(ct.TrialPatient__c, ct);
		    }
		}
		
       Map<String, String> mapPatientXML = new Map<String, String>();
       for(TrialPatient__c trialPatient : lstTrialPatient) {
            List<Randomization_Form__c> lstRandomizationForm = trialPatient.Randomization_Forms__r;
            if(lstRandomizationForm != null && lstRandomizationForm.size() > 0) {
                if(lstRandomizationForm[0].Did_Patient_Sign_Treatment_Consent_Form__c) {
            		//patientXML = collectRandomizationInputs('RunCalculation', trialPatient, mapReceptor.get(trialPatient.Id), mapPSS.get(trialPatient.Id), mapCT.get(trialPatient.Id));
            		RandomizePatient.RandomizationData rd = collectRandomizationInputs('RunCalculation', trialPatient, mapReceptor.get(trialPatient.Id), mapPSS.get(trialPatient.Id), mapCT.get(trialPatient.Id));
                	if(patientXML != null) {
                		mapPatientXML.put(trialPatient.Id, buildPatientXML(rd, 'Randomize', trialPatient.Randomization_Forms__r[0].Randomization_Result__c));
                	}      
                }
            }
        }
        return mapPatientXML;
    }
    
    private void updatePatientXMLRecord(Map<String, String> mapPatientXML) {
    	
    	String currentPatientXML = '';
        for(String xml : mapPatientXML.values()) {
    		currentPatientXML += xml;
    	}
    	system.debug('currentPatientXML from updatePatientXMLRecord() : '+currentPatientXML);
    	RunCalculationXMLParser.updateCurrentPatientXMLFromScheduler('<current_patients>'+currentPatientXML+'</current_patients>');
    }
    
    /* This method is used to collect CRFs data which are required in randomization as well as runcalculation.
    *  Also this method is used to calculate runCalculation inputs.
    */
    
    private RandomizePatient.RandomizationData collectRandomizationInputs(String action, TrialPatient__c trialPatient, List<Receptors__c> lstReceptors, Post_Surgaory_Summary__c pss, Chemo_Treatment__c chemoTreatment) {

        Date todaysDate = Date.today();
        Long dCurrentTime = baseDate.daysBetween(todaysDate);
        
        boolean isMRIVolume=false;
        
        String treatmentArm = '';
        
        String reqXML = '';
        
        Decimal baselineMriVolume = 0.0;
        Decimal mriVolumeMonth2 = 0.0;
        Decimal mriVolumeMonth4 = 0.0;
        Decimal mriVolumeMonth6 = 0.0;
        
        Decimal changeimMRIVolumeMonth2 = -1.0;
        Decimal changeimMRIVolumeMonth4 = -1.0;
        Decimal changeimMRIVolumeMonth6 = -1.0;
        
        Date preTreatmentDate = null;
        Date earlyTreatmentDate = null;
        Date interRegimenDate = null;
        Date preSurgeryDate = null;
        
        long preTreatmentTime = dCurrentTime+1;
        long earlyTreatmentTime = preTreatmentTime;
        long interRegimenTime = preTreatmentTime;
        long preSurgeryTime = preTreatmentTime;
        long pcrOutcometime = preTreatmentTime;
        
        String subjectId = trialPatient.Subject_Id__c;
        if(action == 'RunCalculation') 
            treatmentArm = trialPatient.Randomization_Forms__r[0].Randomization_Result__c;
         
        List<MRI_Volume__c> lstMRIVolume = trialPatient.MRI_Volumes__r;
        for(MRI_Volume__c mri : lstMRIVolume) {
            isMRIVolume = true; 
            if(mri.Time_Point__c == 'Pre-Treatment') {
                system.debug('mri.MRI_Volume_in_cm3__c : '+mri.MRI_Volume_in_cm3__c);
                baselineMriVolume = mri.MRI_Volume_in_cm3__c;
                preTreatmentDate = mri.MRI_Scan_Date__c;
            } else if(mri.Time_Point__c == 'Early treatment') {
                mriVolumeMonth2 = mri.MRI_Volume_in_cm3__c != null?mri.MRI_Volume_in_cm3__c:mriVolumeMonth2;
                earlyTreatmentDate = mri.MRI_Scan_Date__c;
            } else if(mri.Time_Point__c == 'Inter-regimen') {
                mriVolumeMonth4 = mri.MRI_Volume_in_cm3__c != null?mri.MRI_Volume_in_cm3__c:mriVolumeMonth4;
                interRegimenDate = mri.MRI_Scan_Date__c;
            } else if(mri.Time_Point__c == 'Pre-surgery') {
                mriVolumeMonth6 = mri.MRI_Volume_in_cm3__c != null?mri.MRI_Volume_in_cm3__c:mriVolumeMonth6;
                preSurgeryDate = mri.MRI_Scan_Date__c;
            }
        }
            
        if (isMRIVolume == true) {
            system.debug('baselineMriVolume : '+baselineMriVolume+' mriVolumeMonth4 : '+mriVolumeMonth4);
            if (baselineMriVolume != 0.0) {
            	if(mriVolumeMonth2 != null) {
                	changeimMRIVolumeMonth2 = (mriVolumeMonth2-baselineMriVolume) / baselineMriVolume;
            	}
            	if(mriVolumeMonth4 != null) {
                	changeimMRIVolumeMonth4 = (mriVolumeMonth4-baselineMriVolume) / baselineMriVolume;
            	}
            	if(mriVolumeMonth6 != null) {
                	changeimMRIVolumeMonth6 = (mriVolumeMonth6-baselineMriVolume) / baselineMriVolume;
            	}
            }
            
            if (preTreatmentDate != null) {
                preTreatmentTime=baseDate.daysBetween(preTreatmentDate);
            }
            
            if (earlyTreatmentDate != null) {
                earlyTreatmentTime=baseDate.daysBetween(earlyTreatmentDate);
            }
            
            if (interRegimenDate != null) {
                interRegimenTime=baseDate.daysBetween(interRegimenDate);
            }
            
            if (preSurgeryDate != null) {
                preSurgeryTime=baseDate.daysBetween(preSurgeryDate);
            }   
        }
        
        // Calculate Pcr Outcome
        PCRData pcrData = getPCROutcomeData(pss, dCurrentTime);
        
        Integer her2TargrtPrint = 2; //-1-Negative, 1-Positive, 2-Other
        Integer her2 = 2;
        Integer hr = 2; //  ER(-ve), PR(-ve)=HR (0)
        //Integer mp = 4;  // 0-Low, 1-High,2- Quantity not sufficient,3-Quality not sufficient, 4-Not entered By the user
        Integer mpValue=-1; // MP value for Patient
            
        List<MammaPrintDetail__c> lstMammaPrint = trialPatient.MammaPrint_Details__r;
        system.debug('lstMammaPrint : '+lstMammaPrint);
        system.debug('trialPatient.MRI_Volumes__r : '+trialPatient.MRI_Volumes__r);
        MammaPrintDetail__c mammaPrint = new MammaPrintDetail__c();
        if(lstMammaPrint != null && lstMammaPrint.size() > 0) {
            mammaPrint = lstMammaPrint[0];
        }
            
        // mp is not required here : mp has been checked in RandomizationFormController for checking Randomization eligiblity 
        
        system.debug('mammaPrint.Risk_Category__c : '+mammaPrint.Risk_Category__c);
        if(mammaPrint.Risk_Category__c == 'MP High 1') {
            mpValue = 0;
        } else if(mammaPrint.Risk_Category__c == 'MP High 2') {
            mpValue = 1;
        }
            
        Decimal tpHer2 = 0;
        tpHer2 = mammaPrint.TargetPrint_Her_2_Index__c;
        if (tpHer2 <= 0.0) {
            her2TargrtPrint = -1;
        }else if (tpHer2 > 0.0 && tpHer2<=1) {
            her2TargrtPrint = 1;
        }else {
            her2TargrtPrint=2;
        }
            
            /********************** On Study details start ********************/
        String erStatus = ''; 
        String prStatus = ''; 
        String ICH_HER2_Status = '';
        String FISH_HER2_Status = '';
        
        if(lstReceptors != null && !lstReceptors.isEmpty()) {
            erStatus = lstReceptors[0].Estrogen_Receptor_Status__c;
            prStatus = lstReceptors[0].Progesterone_Receptor_Status__c;
            ICH_HER2_Status = lstReceptors[0].IHC__c;
            FISH_HER2_Status = lstReceptors[0].Fish__c;
        }
        
        //if erStatus and prStatus both are Not Reported or Indeterminate then do not do randomization
        /*if((erStatus == 'Not Reported' || erStatus == 'Indeterminate') &&  (prStatus == 'Not Reported' || prStatus == 'Indeterminate')) {
        	notRandomizedReason = 'Estrogen Receptor and Progestorene Receptor are either Not Reported or Indeterminate';
        	return null;
        }*/
        
        integer er = 2; //nither +ve nor -ve then er = 2
        
        System.debug('erStatus:'+erStatus);
        if (erStatus == 'Positive') {
            er = 1;
        } else if (erStatus == 'Negative') {
            er = 0;
        }
        System.debug('er:'+er);
        
        integer pr = 2; //nither +ve nor -ve then pr = 2
        
        System.debug('prStatus:'+prStatus);
        if (prStatus == 'Positive') {
            pr = 1;
        } else if (prStatus == 'Negative') {
            pr = 0;
        } else if (prStatus == 'Indeterminate') {
            pr = 0;
        } else if (prStatus == 'Not Reported') {
            pr = 0;
        }
        System.debug('pr:'+pr);
        
        if(er == 1 || pr == 1) {
            hr = 1;
        } else {
            hr = 0;
        }
        System.debug('hr:'+hr);
        
        /*if((ICH_HER2_Status == 'Not Reported' || ICH_HER2_Status == 'Indeterminate') &&  (FISH_HER2_Status == 'Not Reported' || FISH_HER2_Status == 'Indeterminate')) {
        	notRandomizedReason = 'ICH and FISH are either Not Reported or Indeterminate';
        	return null;
        }*/
        
        integer ichHer2 = 2; //nither +ve nor -ve then ichHer2 = 2
        integer fishHer2 = 2; //nither +ve nor -ve then fishHer2 = 2
        
        System.debug('ICH_HER2_Status:'+ICH_HER2_Status);
        if (ICH_HER2_Status == 'Positive') {
            ichHer2 = 1;
        } else if (ICH_HER2_Status == 'Negative') {
            ichHer2 = 0;
        }
        System.debug('ichHer2:'+ichHer2);
        
        System.debug('FISH_HER2_Status:'+FISH_HER2_Status);
        if (FISH_HER2_Status == 'Positive') {
            fishHer2 = 1;
        } else if (FISH_HER2_Status == 'Negative') {
            fishHer2 = 0;
        }
        System.debug('fishHer2:'+fishHer2);
        
        //A patient is deemed HER2– for the purposes of randomization if and only if none of the patient’s HER2 receptor assays have returned a positive result.
        if(her2TargrtPrint == 1 || ichHer2 == 1 || fishHer2 == 1) {
            her2 = 1;
        } else {
            her2 = 0;
        }
        System.debug('her2:'+her2);
        /********************** On Study details end ********************/
        long startTime = 0;
        
       	if(trialPatient.Randomization_Forms__r != null && !trialPatient.Randomization_Forms__r.isEmpty() && action == 'RunCalculation') {
	   		if(trialPatient.Randomization_Forms__r[0].Effective_Time__c != null) {
	        	startTime = baseDate.daysBetween(Date.valueOf(trialPatient.Randomization_Forms__r[0].Effective_Time__c)); //
	        } 
        }
        if(chemoTreatment != null && chemoTreatment.Date_of_therapy__c != null && action == 'RunCalculation') {
        	if(chemoTreatment.Date_of_therapy__c != null) {
        		startTime = baseDate.daysBetween(chemoTreatment.Date_of_therapy__c); // Previosly startTime was difference between "chemoTreatment.Date_of_therapy__c.daysBetween(dCurrentTime);"
        	}
        }
         
       	String excludedArmsXML = '';
       	RandomizePatient.RandomizationData rd = new RandomizePatient.RandomizationData();
       	rd.subjectId = subjectId;
       	rd.startTime = startTime;
    	rd.hr = hr;
    	rd.her2 = her2;
    	rd.mpValue = mpValue;
    	rd.pcrOutcometime = pcrData.pcrOutcometime;
    	rd.pcrOutcome = pcrData.pcrOutcome;
    	rd.earlyTreatmentTime = earlyTreatmentTime;
    	rd.interRegimenTime = interRegimenTime;
    	rd.preSurgeryTime = preSurgeryTime;
    	rd.changeimMRIVolumeMonth2= changeimMRIVolumeMonth2;
    	rd.changeimMRIVolumeMonth4 = changeimMRIVolumeMonth4;
    	rd.changeimMRIVolumeMonth6 = changeimMRIVolumeMonth6;
        //return RandomizationXMLBuilder.buildPatientXML(action, subjectId, treatmentArm, startTime, excludedArmsXML, hr, her2, mpValue, pcrData.pcrOutcomeTime, pcrData.pcrOutcome, earlyTreatmentTime, interRegimenTime, preSurgeryTime, changeimMRIVolumeMonth2, changeimMRIVolumeMonth4, changeimMRIVolumeMonth6);
        return rd;
    }
    
    //Method that will return patient xml for randomization
    /*public static String buildPatientXML(String action, String subjectId, String treatmentArm, Long startTime, String excludedArmsXML, Integer hr, Integer her2, Integer mpValue, Long pcrOutcometime, Long pcrOutcome, Long earlyTreatmentTime, Long interRegimenTime, Long preSurgeryTime, Decimal changeimMRIVolumeMonth2, Decimal changeimMRIVolumeMonth4, Decimal changeimMRIVolumeMonth6) {
    	 String reqXML = '';
    	 if(action == 'RunCalculation') {
            reqXML = '<patient patient_id ="' + subjectId + '" arm ="' + treatmentArm + '" start_time="' + startTime+'">' +
                          '<patient_covariate name="HR"   Value="' + hr + '"></patient_covariate>' +
                          '<patient_covariate name="HER2"   Value="' + her2 + '"></patient_covariate>' +
                          '<patient_covariate name="MP"   Value="' + mpValue + '"></patient_covariate>'+
                          '<patient_outcome name="pCR" type="double" time="' + pcrOutcometime + '" value="' + pcrOutcome+'"></patient_outcome>' +
                          '<patient_outcome name="MRI1" type="double" time="' + earlyTreatmentTime + '" value="' + changeimMRIVolumeMonth2 + '"></patient_outcome>' +
                          '<patient_outcome name="MRI2" type="double" time="' + interRegimenTime + '" value="' + changeimMRIVolumeMonth4 + '"></patient_outcome>' +
                          '<patient_outcome name="MRI3" type="double" time="' + preSurgeryTime + '" value="' + changeimMRIVolumeMonth6 + '"></patient_outcome>' +
                          '</patient>';
        } else if(action == 'Randomize') {
            
            reqXML = '<new_patient patient_id ="' + subjectId + '" start_time="' + startTime+'">';
            if(excludedArmsXML != '') {
                //reqXML += '<exclude_arm name ="'+excludedArmsXML+'" />';
            }
            reqXML += '<patient_covariate name="HR"   Value="' + hr + '"></patient_covariate>' +
                      '<patient_covariate name="HER2"   Value="' + her2 + '"></patient_covariate>' +
                      '<patient_covariate name="MP"   Value="' + mpValue + '"></patient_covariate>' +
                     '</new_patient>';
        }
        return reqXML;
    }*/
    
    private static String buildPatientXML(RandomizePatient.RandomizationData rd, String action, String treatmentArm) {
    	 String reqXML = '';
    	 if(action == 'RunCalculation') {
            reqXML = '<patient patient_id ="' + rd.subjectId + '" arm ="' + treatmentArm + '" start_time="' + rd.startTime+'">' +
                          '<patient_covariate name="HR"   Value="' + rd.hr + '"></patient_covariate>' +
                          '<patient_covariate name="HER2"   Value="' + rd.her2 + '"></patient_covariate>' +
                          '<patient_covariate name="MP"   Value="' + rd.mpValue + '"></patient_covariate>'+
                          '<patient_outcome name="pCR" type="double" time="' + rd.pcrOutcometime + '" value="' + rd.pcrOutcome+'"></patient_outcome>' +
                          '<patient_outcome name="MRI1" type="double" time="' + rd.earlyTreatmentTime + '" value="' + rd.changeimMRIVolumeMonth2 + '"></patient_outcome>' +
                          '<patient_outcome name="MRI2" type="double" time="' + rd.interRegimenTime + '" value="' + rd.changeimMRIVolumeMonth4 + '"></patient_outcome>' +
                          '<patient_outcome name="MRI3" type="double" time="' + rd.preSurgeryTime + '" value="' + rd.changeimMRIVolumeMonth6 + '"></patient_outcome>' +
                          '</patient>';
        } else if(action == 'Randomize') {
            
            reqXML = '<new_patient patient_id ="' + rd.subjectId + '" start_time="' + rd.startTime+'">';
            //if(excludedArmsXML != '') {
                //reqXML += '<exclude_arm name ="'+excludedArmsXML+'" />';
            //}
            reqXML += '<patient_covariate name="HR"   Value="' + rd.hr + '"></patient_covariate>' +
                      '<patient_covariate name="HER2"   Value="' + rd.her2 + '"></patient_covariate>' +
                      '<patient_covariate name="MP"   Value="' + rd.mpValue + '"></patient_covariate>' +
                     '</new_patient>';
        }
        return reqXML;
    }
    
    private String getExcludedArms(Id patientId) {
        system.debug('patientId : '+patientId);
        String arms = '';
        Set<Id> armIds = new Set<Id>();
        List<ArmPatient__c> lstArmPatient = [Select a.Patient_Id__c, a.Arm_Id__r.Name, a.Arm_Id__c From ArmPatient__c a where Patient_Id__c = :patientId];
        for(ArmPatient__c armPatient : lstArmPatient) {
            armIds.add(armPatient.Arm_Id__c);
        }
        system.debug('armIds : '+armIds);
        List<Arm__c> lstArm = [Select Name from Arm__c where Id NOT IN :armIds];
        for(Arm__c arm : lstArm) {
            arms += arm.Name + ' + ';
        }
        if(arms != '')
            arms = arms.substring(0, arms.length() - 3);
        return arms;
    }
    
    /*private static RandomizationResponseWrapper parseRandomizationResponse(String responseXML) {
		
		responseXML = responseXML.replaceAll('&lt;','<');
		responseXML = responseXML.replaceAll('&gt;','>');
		
		system.debug('responseXML : '+responseXML);
		
		RandomizationResponseWrapper randRespWrapper = new RandomizationResponseWrapper();
		if(responseXML.contains('<treatment'))
			randRespWrapper.treatment = responseXML.split('</treatment>')[0].split('<treatment>')[1];
		if(randRespWrapper.treatment == null && responseXML.contains('<description'))
			randRespWrapper.treatment = responseXML.split('</description>')[0].split('<description>')[1];
		if(responseXML != null && responseXML.contains('<RandomizeResult'))
			randRespWrapper.RandomizeResult =  responseXML.split('</RandomizeResult>')[0].split('<RandomizeResult>')[1];
		if(responseXML != null && responseXML.contains('<nSeed1'))
			randRespWrapper.nSeed1 =  responseXML.split('</nSeed1>')[0].split('<nSeed1>')[1];
		if(responseXML != null && responseXML.contains('<nSeed2'))
			randRespWrapper.nSeed2 =  responseXML.split('</nSeed2>')[0].split('<nSeed2>')[1];
		if(responseXML != null && responseXML.contains('<strRandomizationResultsXML'))
			randRespWrapper.strRandomizationResultsXML =  '<![CDATA[' + responseXML.split('</strRandomizationResultsXML>')[0].split('<strRandomizationResultsXML>')[1] +']]>';
		return randRespWrapper;
	}*/
    
    private static PCRData getPCROutcomeData(Post_Surgaory_Summary__c pss, long dCurrentTime) {
    	PCRData pcrData = new PCRData();
        Date prodDate = null;
        Boolean isInvTumorPresent = false;
        double totalPositiveNode = 0;
        //List<Post_Surgaory_Summary__c> lstPostSurgery = [Select p.pcr__c, p.TrialPatient__c, p.Date_Of_Procedure__c From Post_Surgaory_Summary__c p where TrialPatient__c = :trialPatient.Id];
        if(pss != null) {
            prodDate = pss.Date_Of_Procedure__c;
            isInvTumorPresent = (pss.Is_invasive_tumor_present__c != null && pss.Is_invasive_tumor_present__c == 'No')?false:true;
            system.debug('isInvTumorPresent : '+isInvTumorPresent);
            
            List<Lymph_Nodes__c> lnList = pss.lymph_nodes__r;
            if(lnList != null) {
            	for(Lymph_Nodes__c ln : lnList) {
            		if(ln.Positive__c != null) {
            			totalPositiveNode += ln.Positive__c;
            		}
            	}
            }
            
            system.debug('totalPositiveNode : '+totalPositiveNode);
            if(prodDate != null) {
            	pcrData.pcrOutcomeTime = baseDate.daysBetween(prodDate);
            }
            pcrData.pcrOutcome = (totalPositiveNode == 0 && isInvTumorPresent == false)? 1 : 0;
            //pcrOutcome = pss.pcr__c != false? 1 : 0;
            
        }
        
        if (pcrData.pcrOutcome == -1 || pcrData.pcrOutcomeTime == 0) {
        	pcrData.pcrOutcomeTime = Integer.valueOf(dCurrentTime + 1);
    	}
        system.debug('pcrData.pcrOutcome : '+pcrData.pcrOutcome);
        return pcrData;
    }
    
    public class PCRData {
    	public integer pcrOutcome;
    	public integer pcrOutcomeTime;
    	public PCRData() {
    		pcrOutcome = -1;
    		pcrOutcomeTime = 0;
    	}
    }
    
    private static decimal getMRIVolume(decimal mriVolNew, decimal mriVolBaseLine) {
    	if(mriVolBaseLine == 0) {
    		return -1;
    	}
    	return ((mriVolNew - mriVolBaseLine) / mriVolBaseLine);
    }
    
    /*public class RandomizationResponseWrapper {
		public String RandomizeResult;
		public String nSeed1;
		public String nSeed2;
		public String strRandomizationResultsXML;
		public String treatment;
		public String notRandomizedReason;
	}*/
}