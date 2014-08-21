public with sharing class RandomizePatient {

	private static final Date baseDate = Date.newInstance(1950,1,1);
		
	private static final String randomizeXMLFormat = '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:mdan="http://www.MDAnderson.org">' +
					'  <soapenv:Header/>' +
					'   <soapenv:Body>' +
					'      <mdan:Randomize>' +
					'         <mdan:strUserName>_USER_NAME</mdan:strUserName>' +
					'         <mdan:strPassword>_PASSWORD</mdan:strPassword>' +
					'         <mdan:strTrialName>_TRIAL_NAME</mdan:strTrialName>' +
					'         <mdan:dCurrentTime>_CURRENT_TIME</mdan:dCurrentTime>' +
					'         <mdan:strXMLForCurrentPatients>_CURRENT_PATIENT_XML</mdan:strXMLForCurrentPatients>' +
					'         <mdan:strXMLForNewPatient>_NEW_PATIENT_XML</mdan:strXMLForNewPatient>' +
					'         <mdan:strPreviouslyReturnedXML>_PREVIOUS_RETURNED_XML</mdan:strPreviouslyReturnedXML>' +
					'         <mdan:nSeed1>_N_SEED_1</mdan:nSeed1>' +
					'         <mdan:nSeed2>_N_SEED_2</mdan:nSeed2>' +
					'         <mdan:strRandomizationResultsXML>_RESULT_XML</mdan:strRandomizationResultsXML>' +
					'      </mdan:Randomize>' +
					'   </soapenv:Body>' +
					'</soapenv:Envelope>';
					
	
	/*
	* Checks randomization eligibility of given trial patient
	* The input <code>RandomizationEligibilityData red</code> must have all the values based on crf data
	*/
	private static RandomizationResponseWrapper checkPatientEligibilityForRandomization(RandomizationEligibilityData red) {
		
		system.debug('red : '+red);
		
		List<CRFStatusWrapper> lstCRFStatusWrapper = red.crfStatusList;
		String response = '';
		for(CRFStatusWrapper crfStatus : lstCRFStatusWrapper) {
			
			if(crfStatus.CRFType == 'MRI Volume Form') {
				if(crfStatus.IsSubmitted == 'No') {
					if(response != '') {
						response = response + ', MRI Volume is not submitted';
					} else {
						response = 'MRI Volume is not submitted';
					}
				}
				if(crfStatus.IsApproved == 'No') {
					if(response != '') {
						response = response + 'MRI Volume is not approved';
					} else {
						response = 'MRI Volume is not approved';
					}
				}
			}
			
			if(crfStatus.CRFType == 'On Study Eligibility Form') {
				if(crfStatus.IsSubmitted == 'No') {
					if(response != '') {
						response = response + ', On Study Eligibility Form is not submitted';
					} else {
						response = 'On Study Eligibility Form is not submitted';
					}
				}
				if(crfStatus.IsApproved == 'No') {
					if(response != '') {
						response = response + ', On Study Eligibility Form is not approved';
					} else {
						response = 'On Study Eligibility Form is not approved';
					}
				}
			}
			
			if(crfStatus.CRFType == 'On Study Pathology Form') {
				if(crfStatus.IsSubmitted == 'No') {
					if(response != '') {
						response = response + ', On Study Pathology Form is not submitted';
					} else {
						response = 'On Study Pathology Form is not submitted';
					}
				}
				if(crfStatus.IsApproved == 'No') {
					if(response != '') {
						response = response + ', On Study Pathology Form is not approved';
					} else {
						response = 'On Study Pathology Form is not approved';
					}
				}
			}
			
			if(crfStatus.CRFType == 'MammaPrint Form') {
				if(crfStatus.IsSubmitted == 'No') {
					if(response != '') {
						response = response + ', MammaPrint Form is not submitted';
					} else {
						response = 'MammaPrint Form is not submitted';
					}
				}
			}
			
			system.debug('erStatus : '+red.erStatus);
			system.debug('HER2Status : '+red.HER2Status);
			system.debug('MammaPrintRisk : '+red.MammaPrintRisk);
		}
		
		if(red.isAllOSECheckboxesChecked != null && !red.isAllOSECheckboxesChecked) {
			response = '(All Eligibility checklist checkboxes are not checked)';
		}
		
		/*if(red.h1h2Status == 'Undetermined') {
			return 'H1 H2 status is Undetermined';
		}
		
		if((red.ICH_HER2_Status == 'Not Reported' || red.ICH_HER2_Status == 'Indeterminate') &&  (red.FISH_HER2_Status == 'Not Reported' || red.FISH_HER2_Status == 'Indeterminate')) {
        	return 'ICH and FISH are either Not Reported or Indeterminate';
        }
		
		red.HER2Status = getHer2Status(red.targetPrintHer2Status, red.ICH_HER2_Status, red.FISH_HER2_Status);
		
		if(red.erStatus == 'Positive' && red.HER2Status == 'Negative' && (red.MammaPrintRisk == 'Low risk' || red.MammaPrintRisk == 'Quantity not sufficient' || red.MammaPrintRisk == 'Quality not sufficient')) {
			// Not eligible randomize due to MammaPrint Low, ER+ and Her2-
			return '(Because ER Status-'+red.erStatus+',   HER2 Status-'+red.HER2Status+',   MammaPrintRisk-'+red.MammaPrintRisk+')';
		} else if(red.isAllOSECheckboxesChecked != null && !red.isAllOSECheckboxesChecked) {
			return '(All Eligibility checklist checkboxes are not checked)';
		}*/
		//RandomizationDataValidationOutcome rdv = null;
		RandomizationResponseWrapper rrw = null;
		if(response == '') {
			rrw = checkRandomizationData(red.targetPrintHer2Status, red.prStatus, red.MammaPrintRisk, red.ICH_HER2_Status, red.FISH_HER2_Status, red.erStatus);
		} else {
			rrw = new RandomizationResponseWrapper();
			rrw.isEligible = false;
			rrw.notRandomizedReason = response;
		}
		
		return rrw;
	}
	
	/*
	* Check data based eligibility
	*/
	private static RandomizationResponseWrapper checkRandomizationData(String targetPrintHer2Status, String prStatus, String mp,
		String ICH_HER2_Status, String FISH_HER2_Status, String erStatus) {
		
		System.debug('prStatus:'+prStatus);
		System.debug('mp:'+mp);
		System.debug('ICH_HER2_Status:'+ICH_HER2_Status);
		System.debug('FISH_HER2_Status:'+FISH_HER2_Status);
		System.debug('erStatus:'+erStatus);
		System.debug('targetPrintHer2Status:'+targetPrintHer2Status);
		
		List<Randomization_Condition__c> rcList = [Select r.Test_Case_Number__c, r.TP__c, r.PR__c, r.MP__c, r.IHC__c, r.FISH__c, 
				r.Eligble__c, r.ER__c From Randomization_Condition__c r where r.TP__c = :targetPrintHer2Status and r.PR__c = :prStatus 
				and r.MP__c = :mp and r.IHC__c = :ICH_HER2_Status and r.FISH__c = :FISH_HER2_Status and r.ER__c = :erStatus];
		system.debug('Did not find any case related to given data');
		
		RandomizationResponseWrapper rrw = new RandomizationResponseWrapper(); 
		
		if(rcList.isEmpty()) {
			rrw.testCaseNumber = -1;
			rrw.isEligible = false;
			rrw.notRandomizedReason = 'No test case found for give data, hence not performing randomization';
		} else {
			rrw.testCaseNumber = Integer.valueOf(rcList[0].Test_Case_Number__c);
			integer eligible = Integer.valueOf(rcList[0].Eligble__c); 
			if(eligible == 1) {
				rrw.isEligible = true;
			} else {
				rrw.isEligible = false;
			}
		}
		system.debug('rdv:'+rrw);
		return rrw;
	}
	
	//private static String getHer2Status(String targetPrintHer2status, String ich, String fish) {
	//	return ((targetPrintHer2status == 'Positive' || ich == 'Positive' || fish == 'Positive') ? 'Positive' : 'Negative');
	//}
	
	public static RandomizationResponseWrapper randomize(RandomizationEligibilityData red, boolean patientBelongsToTestSite, RandomizationProperties randProps, RandomizationData rd, String trialName) {
		
		RandomizationResponseWrapper rrw = checkPatientEligibilityForRandomization(red);
		
		if(!rrw.isEligible) {
			return rrw;
		}
		
		RandomizationResponseWrapper rrwNew = randomize(rd.subjectId, rd.startTime, rd.hr, rd.her2, rd.mpValue, rd.pcrOutcometime, rd.pcrOutcome, rd.earlyTreatmentTime, rd.interRegimenTime, rd.preSurgeryTime, rd.changeimMRIVolumeMonth2, rd.changeimMRIVolumeMonth4, rd.changeimMRIVolumeMonth6, randProps, trialName);
		rrwNew.testCaseNumber = rrw.testCaseNumber;
 
 		system.debug('rrwNew:'+rrwNew);
		return rrwNew;
	}
	
	//Method that will send request to randomization engine and return arm the patient is randomized to
    private static RandomizationResponseWrapper randomize(String subjectId, Long startTime, 
    	Integer hr, Integer her2, Integer mpValue, Long pcrOutcometime, Long pcrOutcome, 
    	Long earlyTreatmentTime, Long interRegimenTime, Long preSurgeryTime, 
    	Decimal changeimMRIVolumeMonth2, Decimal changeimMRIVolumeMonth4, Decimal changeimMRIVolumeMonth6, 
    	RandomizationProperties randProps, String trialName) {

		RandomizationResponseWrapper randRespWrapper = new RandomizationResponseWrapper();
		randRespWrapper.isEligible = true;
		
		String newPatientXML = '<new_patient patient_id ="' + subjectId + '" start_time="' + startTime+'">';
        newPatientXML += '<patient_covariate name="HR"   Value="' + hr + '"></patient_covariate>' +
                  '<patient_covariate name="HER2"   Value="' + her2 + '"></patient_covariate>' +
                  '<patient_covariate name="MP"   Value="' + mpValue + '"></patient_covariate>' +
                 '</new_patient>';
		system.debug('currPatientXML: '+newPatientXML);

		if(randProps == null || randProps.currentPatientXML == null || randProps.runCalcResult == null || randProps.engineURL == null) {
			randRespWrapper = new RandomizationResponseWrapper();
			randRespWrapper.notRandomizedReason = 'Randomization Properties details is missing';
			randRespWrapper.treatment = 'Not Randomized';
			randRespWrapper.isEligible = false;
			return randRespWrapper;
		}
	
		String currentPatientXML = randProps.currentPatientXML;
		String runCalculationResult = randProps.runCalcResult;
		Decimal nSeed1 = randProps.nSeed1;
		Decimal nSeed2 = randProps.nSeed2;
		String endPointURL = randProps.engineURL;
		long dCurrentTime = baseDate.daysBetween(Date.today());
		
		system.debug('currentPatientXML : '+currentPatientXML);
		system.debug('runCalculationResult : '+runCalculationResult);
		system.debug('dCurrentTime :'+dCurrentTime);
		system.debug('currentPatientXML :'+currentPatientXML);
		system.debug('nSeed1 :'+nSeed1);
		system.debug('nSeed2 :'+nSeed2);
		
		String randomizeXML = String.valueOf(randomizeXMLFormat);
		randomizeXML = randomizeXML.replaceAll('_USER_NAME', '');
		randomizeXML = randomizeXML.replaceAll('_PASSWORD', '');
		randomizeXML = randomizeXML.replaceAll('_TRIAL_NAME', trialName);
		randomizeXML = randomizeXML.replaceAll('_CURRENT_TIME', String.valueOf(dCurrentTime));
		randomizeXML = randomizeXML.replaceAll('_CURRENT_PATIENT_XML', currentPatientXML);
		randomizeXML = randomizeXML.replaceAll('_NEW_PATIENT_XML', '<![CDATA['+newPatientXML+']]>');
		randomizeXML = randomizeXML.replaceAll('_PREVIOUS_RETURNED_XML', runCalculationResult);
		randomizeXML = randomizeXML.replaceAll('_N_SEED_1', String.valueOf(nSeed1));
		randomizeXML = randomizeXML.replaceAll('_N_SEED_2', String.valueOf(nSeed2));
		randomizeXML = randomizeXML.replaceAll('_RESULT_XML', '');
		system.debug('randomizeXML : '+randomizeXML);
		
		String resBody = webServiceCallout(randomizeXML, endPointURL);
		integer counter = 1;
		 
		if(resBody != null) {
			randRespWrapper = parseRandomizationResponse(resBody, randRespWrapper);
			while(stoppedArmAssigned(randRespWrapper.treatment)) {
				if(counter == 10) {
					randRespWrapper.treatment = 'Not Randomized';
					randRespWrapper.notRandomizedReason = 'Randomization exited as patient assigned stopped arm consecutively for 10 times.';
					break;
				} else {
					counter++;
				}
				resBody = webServiceCallout(randomizeXML, endPointURL);
				if(resBody != null) {
					randRespWrapper = parseRandomizationResponse(resBody, randRespWrapper);
				}
			}
			if(stoppedArmAssigned(randRespWrapper.treatment)) {
				randRespWrapper.treatment = 'Not Randomized';
			}
		} else {
			randRespWrapper.notRandomizedReason = 'Error connecting to randomization engine';
			randRespWrapper.treatment = 'Not Randomized';
			return randRespWrapper;
		}
		
        return randRespWrapper;
    }
    
    private static boolean stoppedArmAssigned(String treatment) {
    	return treatment != null && (treatment.contains('Neratinib') || treatment.contains('ABT-888'));
    }
    
    private static String webServiceCallout(String requestXML, String endPointURL) {
		
		String resBody = null;
		
		HttpRequest req = new HttpRequest();
		req.setEndpoint(endPointURL);
		req.setMethod('GET');	
		req.setTimeout(120000);
		req.setHeader('Content-Length','0');
		req.setHeader('Accept-Encoding','gzip,deflate');
		req.setHeader('Content-Type','text/xml;charset=UTF-8');
		req.setHeader('SOAPAction','"http://www.MDAnderson.org/Randomize"');
		req.setHeader('User-Agent','Jakarta Commons-HttpClient/3.1');
		req.setHeader('Content-Length','50000');
		req.setBody(requestXML);
		Http http = new Http();
		if(!Test.isRunningTest()) {
			HTTPResponse res = http.send(req);
			resBody = res.getBody();
		} else {
			resBody = '<S:Envelope xmlns:S="http://schemas.xmlsoap.org/soap/envelope/">' +
				'   <S:Body>' +
				'      <RandomizeResponse xmlns="http://www.MDAnderson.org">' +
				'         <RandomizeResult>0</RandomizeResult>' +
				'         <nSeed1>100</nSeed1>' +
				'         <nSeed2>100</nSeed2>' +
				'         <strRandomizationResultsXML>' +
				'				<![CDATA[<treatment>TEST TREATMENT 1 + TEST TREATMENT 2</treatment>]]>' +
				'		  </strRandomizationResultsXML>' +
				'      </RandomizeResponse>' +
				'   </S:Body>' +
				'</S:Envelope>';
		}
		
		return resBody;
	}
	
	private static RandomizationResponseWrapper parseRandomizationResponse(String responseXML, RandomizationResponseWrapper randRespWrapper) {
		
		responseXML = responseXML.replaceAll('&lt;','<');
		responseXML = responseXML.replaceAll('&gt;','>');
		
		system.debug('responseXML : '+responseXML);
		
		if(responseXML.contains('<treatment')) {
			randRespWrapper.treatment = responseXML.split('</treatment>')[0].split('<treatment>')[1];
			system.debug('randRespWrapper.treatment:'+randRespWrapper.treatment);
		}
		if(randRespWrapper.treatment == null && responseXML.contains('<description')) {
			randRespWrapper.treatment = responseXML.split('</description>')[0].split('<description>')[1];
			system.debug('randRespWrapper.treatment:'+randRespWrapper.treatment);
		}
		if(responseXML != null && responseXML.contains('<RandomizeResult')) {
			randRespWrapper.RandomizeResult =  responseXML.split('</RandomizeResult>')[0].split('<RandomizeResult>')[1];
			system.debug('randRespWrapper.RandomizeResult:'+randRespWrapper.RandomizeResult);
		}
		if(responseXML != null && responseXML.contains('<nSeed1'))
			randRespWrapper.nSeed1 =  responseXML.split('</nSeed1>')[0].split('<nSeed1>')[1];
		if(responseXML != null && responseXML.contains('<nSeed2'))
			randRespWrapper.nSeed2 =  responseXML.split('</nSeed2>')[0].split('<nSeed2>')[1];
		if(responseXML != null && responseXML.contains('<strRandomizationResultsXML'))
			randRespWrapper.strRandomizationResultsXML =  '<![CDATA[' + responseXML.split('</strRandomizationResultsXML>')[0].split('<strRandomizationResultsXML>')[1] +']]>';
		return randRespWrapper;
	}
	
	public static void saveRunCalculationResponse(String responseXML) {
		
		responseXML = responseXML.replaceAll('&lt;','<');
		responseXML = responseXML.replaceAll('&gt;','>');
		
		system.debug('responseXML : '+responseXML);
		
		String nSeed1;
		String nSeed2;
		String strReturnXML;
		
		if(responseXML != null && responseXML.contains('<nSeed1'))
			nSeed1 =  responseXML.split('</nSeed1>')[0].split('<nSeed1>')[1];
		if(responseXML != null && responseXML.contains('<nSeed2'))
			nSeed2 =  responseXML.split('</nSeed2>')[0].split('<nSeed2>')[1];
		if(responseXML != null && responseXML.contains('<strReturnXML'))
			strReturnXML =  '<![CDATA[' + responseXML.split('</strReturnXML>')[0].split('<strReturnXML>')[1] +']]>';
		
		List<RandomizationProperty__c> lstRandProp = [Select r.nSeed2__c, r.nSeed1__c, r.RunCalculationResult__c, r.PatientId__c, r.CurrentPatientXML__c From RandomizationProperty__c r];
		if(!lstRandProp.isEmpty()) {
			lstRandProp[0].RunCalculationResult__c = strReturnXML;
			lstRandProp[0].nSeed1__c = Double.valueOf(nSeed1);
			lstRandProp[0].nSeed2__c = Double.valueOf(nSeed2);
			//system.debug('currentPatientXML : '+currentPatientXML);
			//lstRandProp[0].CurrentPatientXML__c = currentPatientXML;
		}
		upsert lstRandProp;
	}
	
	public static String getRunCalculationXML(String trialName, String instName) {
		String runCalcXML = '      <mdan:RunCalculations>' +
							'         <mdan:strUserName>_USER_NAME</mdan:strUserName>' +
							'         <mdan:strPassword>_PASSWORD</mdan:strPassword>' +
							'         <mdan:dCurrentTime>_CURRENT_TIME</mdan:dCurrentTime>' +
							'		  <mdan:strXMLCurrentPatients>_CURRENT_PATIENT_XML</mdan:strXMLCurrentPatients>' +
							'         <mdan:strPreviouslyReturnedXML>_PREVIOUS_RETURNED_XML</mdan:strPreviouslyReturnedXML>' +
							'         <mdan:nSeed1>_N_SEED_1</mdan:nSeed1>' +
							'         <mdan:nSeed2>_N_SEED_2</mdan:nSeed2>' +
							'         <mdan:strReturnXML>_RESULT_XML</mdan:strReturnXML>' +
							'      </mdan:RunCalculations>';
							
		List<RandomizationProperty__c> lstProperty = [Select r.End_Point_URL__c, r.nSeed2__c, r.nSeed1__c, r.RunCalculationResult__c, r.CurrentPatientXML__c From RandomizationProperty__c r];

		String runCalculationResult = null;
		decimal nSeed1 = -1;
		decimal nSeed2 = -1;
		String endPointURL = null;
		if(!lstProperty.isEmpty()) {
			if(lstProperty[0].RunCalculationResult__c != null) {
				runCalculationResult = lstProperty[0].RunCalculationResult__c;
			}
			nSeed1 = lstProperty[0].nSeed1__c;
			nSeed2 = lstProperty[0].nSeed2__c;
			endPointURL = lstProperty[0].End_Point_URL__c;
			system.debug('runCalculationResult : '+runCalculationResult);
		} else {
			System.debug('Randomization properties values missing');
			return null;
		}
		
		long dCurrentTime = baseDate.daysBetween(System.today());
		
		String currentPatient = getCurrentPatientXMLAsString(trialName, instName);
		
		System.debug('runCalculationResult : '+runCalculationResult);
		System.debug('dCurrentTime : '+dCurrentTime);
		System.debug('currentPatient : '+currentPatient);
		
		runCalcXML = runCalcXML.replaceAll('_USER_NAME', '');
		runCalcXML = runCalcXML.replaceAll('_PASSWORD', '');
		runCalcXML = runCalcXML.replaceAll('_CURRENT_TIME', String.valueOf(dCurrentTime));
		runCalcXML = runCalcXML.replaceAll('_CURRENT_PATIENT_XML', '<![CDATA[<current_patients>'+currentPatient+'</current_patients>]]>');
		runCalcXML = runCalcXML.replaceAll('_PREVIOUS_RETURNED_XML', runCalculationResult);
		runCalcXML = runCalcXML.replaceAll('_N_SEED_1', String.valueOf(nSeed1));
		runCalcXML = runCalcXML.replaceAll('_N_SEED_2', String.valueOf(nSeed2));
		runCalcXML = runCalcXML.replaceAll('_RESULT_XML', '');
		system.debug('runCalcXML : '+runCalcXML);
		return runCalcXML;
	}
	
	private static String getCurrentPatientXMLAsString(String trialName, String instName) {
    	String currentPatientXML = '';
    	List<String> lstCurrentXML = getCurrentPatientXML(trialName, instName);
    	for(String xml : lstCurrentXML) {
    		currentPatientXML += xml;
    	}
    	
    	return currentPatientXML;
    }
    
    private static List<String> getCurrentPatientXML(String trialName, String instName) {
    	
    	Set<String> tpIds = new Set<String>(); 
    	
    	String qryString = 'Select t.Trial_Id__r.Name, t.Trial_Id__c, t.Institution__c, t.Id From TrialPatient__c t';
    	if(trialName != null && trialName != '' && instName != null && instName != '') {
    		qryString += ' where Trial_Id__r.Name = \''+trialName+'\' and Institution__c = \''+instName+'\'';
    	}
    	
    	if(trialName != null && trialName != '' && (instName == null || instName == '')) {
    		qryString += ' where Trial_Id__r.Name = \''+trialName+'\'';
    	}
    	
    	if((trialName == null || trialName == '') && (instName != null && instName != '')) {
    		qryString += ' where Institution__c = \''+instName+'\'';
    	}
    	
    	System.debug('qryString : '+qryString);
    	
    	List<TrialPatient__c> lstTrialPatient = Database.query(qryString);
    	//List<TrialPatient__c> lstTrialPatient = [Select t.Trial_Id__r.Name, t.Trial_Id__c, t.Institution__c, t.Id From TrialPatient__c t where Trial_Id__r.Name = :trialName and Institution__c = :instName];
    	for(TrialPatient__c tp : lstTrialPatient) {
    		tpIds.add(tp.Id);
    	}
    	
    	List<String> lstTrialPatXML = new List<String>();
    	List<TrialPatientXML__c> lstTrialPatientXML = [Select t.TrialPatientId__c, t.TrialPatientId__r.Subject_Id__c, t.Current_Patient_XML__c From TrialPatientXML__c t where TrialPatientId__c IN :tpIds and TrialPatientId__r.Subject_Id__c != null order by LastModifiedDate ASC];
		for(TrialPatientXML__c tpXML : lstTrialPatientXML) {
			String cpXML = tpXML.Current_Patient_XML__c;
			if(cpXML != null) {
				cpXML = cpXML.replaceAll('&lt;', '<').replaceAll('&gt;', '>');
				lstTrialPatXML.add(cpXML);
			}
		}
    	return lstTrialPatXML;
    }
    
	/*public String getPatientXMLForRunCalculation() {
		String currentPatient = '';
		List<TrialPatientXML__c> lstTrialPatientXML = [Select t.TrialPatientId__c, t.Current_Patient_XML__c From TrialPatientXML__c t];
		for(TrialPatientXML__c tpXML : lstTrialPatientXML) {
			currentPatient += tpXML.Current_Patient_XML__c;
		}
		if(currentPatient != null) {
			currentPatient = currentPatient.replaceAll('&lt;', '<').replaceAll('&gt;', '>');
		}
		return '<![CDATA[<current_patients>'+currentPatient+'</current_patients>]]>';
	}*/
	
	public class RandomizationResponseWrapper {
		public String randomizeResult;
		public String nSeed1;
		public String nSeed2;
		public String strRandomizationResultsXML;
		public String treatment;
		public String notRandomizedReason;
		public integer testCaseNumber;
		public boolean isEligible;
	}
	
	/*public class RandomizationDataValidationOutcome {
		public integer testCaseNumber;
		public boolean isEligible;
		public String message;
	}*/
	
	public class RandomizationEligibilityData {
		public List<CRFStatusWrapper> crfStatusList;
		public String h1h2Status = null;
		public String erStatus = null; //Assigned in line 65
		public String prStatus = null; //Assigned in line 65
		public String HER2Status = null; // Assigned in line 86 and 88 
		public String MammaPrintRisk = null; // Assigned in line 119
		public String ICH_HER2_Status = null;
		public String FISH_HER2_Status = null;
		public String targetPrintHer2Status = null;
		public boolean isAllOSECheckboxesChecked;
	}
	
	public class CRFStatusWrapper {
		public CRFStatusWrapper() {
			IsSubmitted = 'No';
			IsApproved = 'No';
		}
		public String CRFType {get;set;}
		public String IsSubmitted {get;set;}
		public String IsApproved {get;set;}
	}
	
	public class RandomizationProperties {
		
		public long nSeed1;
		public long nSeed2;
		public String engineURL;
		public String runCalcResult;
		public String currentPatientXML;
	}
	
	public class RandomizationData {
    	public String subjectId;
    	public Long startTime;
    	public Integer hr;
    	public Integer her2;
    	public Integer mpValue;
    	public Long pcrOutcometime;
    	public Long pcrOutcome;
    	public Long earlyTreatmentTime;
    	public Long interRegimenTime;
    	public Long preSurgeryTime;
    	public Decimal changeimMRIVolumeMonth2;
    	public Decimal changeimMRIVolumeMonth4;
    	public Decimal changeimMRIVolumeMonth6;
    	
    	public RandomizationData() {
    		startTime = -1;
    		hr = -1;
    		her2 = -1;
    		mpValue = -1;
    		pcrOutcometime = 1;
    		pcrOutcome = -1;
    		earlyTreatmentTime = -1;
    		interRegimenTime = -1;
    		preSurgeryTime = -1;
    		changeimMRIVolumeMonth2= 0;
    		changeimMRIVolumeMonth4 = 0;
    		changeimMRIVolumeMonth6 = 0;
    	}
    }
}