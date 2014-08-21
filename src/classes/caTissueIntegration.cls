public with sharing class caTissueIntegration {
	String END_POINT = 'http://50.57.24.111:8888';
	String userName = '';
	String password = '';
	String xmlSchemaDef = '';
	public String testXML {get;set;}
	public String resBody {get;set;}
	/*String caTISSUE_XML = '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" ' +
				'	xmlns:mes="http://caXchange.nci.nih.gov/messaging">' +
				'   <soapenv:Header/>' +
				'   <soapenv:Body>' +
				'      <mes:caXchangeRequestMessage>' +
				'         <mes:metadata>' +
				'            <mes:transactionControl>TRANS_CONTROL</mes:transactionControl>' +
				'            <mes:serviceType>SERVICE_TYPE</mes:serviceType>' +
				'            <mes:operationName>OPR_NAME</mes:operationName>' +
				'            <mes:externalIdentifier>EXT_ID</mes:externalIdentifier>' +
				'            <mes:caXchangeIdentifier>CA_EX_ID</mes:caXchangeIdentifier>' +
				'            <mes:credentials>' +
				'               <mes:userName>USER_NAME</mes:userName>' +
				'               <mes:password>PASSWORD</mes:password>' +
				'               <mes:delegatedCredentialReference>DEL_CRED_REF</mes:delegatedCredentialReference>' +
				'            </mes:credentials>' +
				'         </mes:metadata>' +
				'         <mes:request>' +
				'            <mes:businessMessagePayload>' +
				'               <mes:xmlSchemaDefinition>XML_SCHEMA_DEF</mes:xmlSchemaDefinition>' +
				'               BUSINESS_MESSAGE_PAYLOAD' +
				'            </mes:businessMessagePayload>' +
				'         </mes:request>' +
				'      </mes:caXchangeRequestMessage>' +
				'   </soapenv:Body>' +
				'</soapenv:Envelope>';
	*/
	String caTISSUE_XML = '';
	
	public static void processCaTissueRecords(Set<Id> tIds) {
		List<caTissueTempStorage__c> lstCaTissueTempStorage = new List<caTissueTempStorage__c>();
		for(Id tId : tIds) {
			caTissueTempStorage__c caTissueTempStorage = new caTissueTempStorage__c();
			caTissueTempStorage.TrialPatient__c = tId;
			caTissueTempStorage.IsProcessed__c = false;
			lstCaTissueTempStorage.add(caTissueTempStorage);
		}
		insert lstCaTissueTempStorage;
		
		caTissueSchedulerDetails__c caTissueSchedulDetails = new caTissueSchedulerDetails__c();
		caTissueSchedulDetails.IsJobCompleted__c = true;
		insert caTissueSchedulDetails;
		
	}
	@Future (callout = true)
	public static void createParticipant_FutureCall(Id trialPatientId, Id jobId) {
		system.debug('trialPatientId : '+trialPatientId);
		caTissueIntegration caTissueIntegration = new caTissueIntegration();
		caTissueIntegration.callcaTissueService(trialPatientId, 'createParticipant', jobId);
	}
	
	@Future (callout = true)
	public static void createSpecimen_FutureCall(Id trialPatientId, Id jobId) {
		caTissueIntegration caTissueIntegration = new caTissueIntegration();
		caTissueIntegration.callcaTissueService(trialPatientId, 'createSpecimen', jobId);
	}
	
	public void executeCreateParticipantFromTestingPage() {
		//caTissueIntegration caTissueIntegration = new caTissueIntegration();
		//caTissueIntegration.callcaTissueService('a0nc0000000QtibAAC', 'createParticipant');
	}
	public void callcaTissueService(Id trialPatientId, String operationName, Id jobId) {
		
		HttpRequest req = new HttpRequest();
		req.setEndpoint(END_POINT);
		req.setMethod('GET');	
		req.setTimeout(60000);
		req.setHeader('Content-Length','0');
		req.setHeader('Content-Type','text/xml;charset=UTF-8');
		req.setHeader('Host','50.57.24.111:8888');
				
		/*caTISSUE_XML = caTISSUE_XML.replaceAll('TRANS_CONTROL', ''); // ???
		caTISSUE_XML = caTISSUE_XML.replaceAll('SERVICE_TYPE', 'CATISSUE');
		caTISSUE_XML = caTISSUE_XML.replaceAll('OPR_NAME', operationName);
		caTISSUE_XML = caTISSUE_XML.replaceAll('EXT_ID', trialPatientId);
		caTISSUE_XML = caTISSUE_XML.replaceAll('CA_EX_ID', ''); // ???
		caTISSUE_XML = caTISSUE_XML.replaceAll('USER_NAME', userName);
		caTISSUE_XML = caTISSUE_XML.replaceAll('PASSWORD', password);
		caTISSUE_XML = caTISSUE_XML.replaceAll('DEL_CRED_REF', ''); // ???
		caTISSUE_XML = caTISSUE_XML.replaceAll('XML_SCHEMA_DEF', ''); // ???*/
		
		caTISSUE_XML += 'payload=';
		
		system.debug('caTISSUE_XML : '+caTISSUE_XML);
		system.debug('trialPatientId : '+trialPatientId);
		if(operationName == 'createParticipant') {
			List<Registration__c> lstRegistration = [Select r.TrialPatient__c, r.TrialPatient__r.Subject_Id__c, r.Patient__r.Race__c, r.Patient__r.Last_Name__c, r.Patient__r.Ethnicity__c, r.Patient__c From Registration__c r where TrialPatient__c = :trialPatientId order by LastModifiedDate desc limit 1];
			if(!lstRegistration.isEmpty()) {
				system.debug('trialPatientId : '+trialPatientId);
				Registration__c registration = lstRegistration[0];
				caTISSUE_XML += getBusinessMsgPayloadXML(registration);
				system.debug('caTISSUE_XML : '+caTISSUE_XML);
			}
		} else if(operationName == 'createSpecimen') {
			List<TissueSpecimenDetail__c> lstTissueSpecimen = [Select TrialPatient__c, TrialPatient__r.Subject_Id__c, (Select SpecimenID__c From Core_Biopsy_Specimens__r) From TissueSpecimenDetail__c t where TrialPatient__c = :trialPatientId ];
			if(!lstTissueSpecimen.isEmpty()) {
				TissueSpecimenDetail__c tissueSpecimen = lstTissueSpecimen[0];
				caTISSUE_XML += getBusinessMsgPayloadXML(tissueSpecimen);
				system.debug('caTISSUE_XML : '+caTISSUE_XML);
			}
		}
		
		caTISSUE_XML += '&operationName='+operationName;
		
		system.debug('caTISSUE_XML : '+caTISSUE_XML);
		
		req.setBody(caTISSUE_XML);
		
		Http http = new Http();
		if(!Test.isRunningTest()) {
			HTTPResponse res = http.send(req);
			system.debug('res');
			resBody = res.getBody();
			
			String result = null;
			if(resBody.contains('<result>'))
				result = resBody.split('</result>')[0].split('<result>')[1];
		
			postCaTissueProcess(trialPatientId, operationName, result, jobId);
			system.debug('resBody : '+resBody);
		}
	}
	
	public String getBusinessMsgPayloadXML(Registration__c registration) {
		String businessMsgPayload = '<?xml version="1.0" encoding="UTF-8" standalone="yes"?><ns1:trim xmlns:ns1="urn:tolven-org:trim:4.0" ' +
				'	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" ' +
				'	xmlns:xs="http://www.w3.org/2001/XMLSchema">' +
				'			    <ns1:act>' +
				'				<ns1:relationship name="raceCollection">' +
				'				    <ns1:act>' +
				'					<ns1:observation>' +
				'					    <ns1:value>' +
				'						<ns1:label>Race</ns1:label>' +
				'						<ns1:valueSet>race</ns1:valueSet>' +
				'						RACE_XML' +
				'						<ns1:CD>' +
				'							<ns1:code>103579009 | race |</ns1:code>' +
				'							<ns1:codeSystem>2.16.840.1.113883.6.5</ns1:codeSystem>' +
				'							<ns1:codeSystemName>SNOMED CT</ns1:codeSystemName>' +
				'							<ns1:codeSystemVersion>January 2009</ns1:codeSystemVersion>' +
				'							<ns1:translation>' +
				'								<ns1:code>TBD</ns1:code>' +
				'								<ns1:codeSystem>2.16.840.1.113883.3.26.2</ns1:codeSystem>' +
				'								<ns1:codeSystemName>caDSR</ns1:codeSystemName>' +
				'								<ns1:codeSystemVersion>2.1</ns1:codeSystemVersion>' +
				'							</ns1:translation>' +
				'						</ns1:CD>' +
				'					    </ns1:value>' +
				'					</ns1:observation>' +
				'				    </ns1:act>' +
				'				</ns1:relationship>' +
				'				<ns1:relationship name="ethnicity">' +
				'				    <ns1:act>' +
				'					<ns1:observation>' +
				'					    <ns1:value>' +
				'							<ns1:label>Ethnicity</ns1:label>' +
				'							<ns1:valueSet>ethnicity</ns1:valueSet>' +
				'							<ns1:CE>' +
				'						    	<ns1:displayName>ETHNICITY_DISPLAY_NAME</ns1:displayName>' +
				'						    	<ns1:code>ETH_CODE</ns1:code>' +
				'						    	<ns1:codeSystem>CODE_SYS</ns1:codeSystem>' +
				'						    	<ns1:codeSystemVersion>2007AA</ns1:codeSystemVersion>' +
				'							</ns1:CE>' +
				'					    </ns1:value>' +
				'					</ns1:observation>' +
				'				    </ns1:act>' +
				'				</ns1:relationship>' +
				'				<ns1:relationship name="activityStatus">' +
				'				    <ns1:act>' +
				'					<ns1:observation>' +
				'					    <ns1:value>' +
				'						<ns1:ST>Active</ns1:ST>' +
				'					    </ns1:value>' +
				'					</ns1:observation>' +
				'				    </ns1:act>' +
				'				</ns1:relationship>' +
				'				<ns1:relationship name="cdmsSubjectId">' +
				'				    <ns1:act>' +
				'					<ns1:observation>' +
				'					    <ns1:value>' +
				'						<ns1:label>Patient ID</ns1:label>' +
				'						<ns1:ST>CDMS_SUBJ_ID</ns1:ST>' +
				'					    </ns1:value>' +
				'					</ns1:observation>' +
				'				    </ns1:act>' +
				'				</ns1:relationship>' +
				'				<ns1:relationship name="collectionProtocol">' +
				'					<ns1:act>' +
				'						<ns1:observation>' +
				'							<ns1:value>' +
				'								<ns1:label>title</ns1:label>' +
				'								<ns1:ST>I-SPY 2 TRIAL</ns1:ST>' +
				'							</ns1:value>' +
				'							<ns1:value>' +
				'								<ns1:label>shortTitle</ns1:label>' +
				'								<ns1:ST>I-SPY 2 TRIAL</ns1:ST>' +
				'							</ns1:value>' +
				'						</ns1:observation>' +
				'					</ns1:act>' +
				'				</ns1:relationship>' +
				'			    </ns1:act>' +
				'			</ns1:trim>';
				
		String raceXML = '';
		List<Snomed_Code__c> lstSnomedCode = [Select s.Code_Master__r.Name, s.Code_Master__c, s.TrialPatient__c, s.Code_System__c From Snomed_Code__c s where TrialPatient__c = :registration.TrialPatient__c or Code_Master__r.Name = 'Race' or Code_Master__r.Name = 'Ethn'];
		Map<String,Snomed_Code__c> mapSnomedCode = new Map<String,Snomed_Code__c>();
		for(Snomed_Code__c sc : lstSnomedCode) {
			mapSnomedCode.put(sc.Code_Master__r.Name, sc);
		}
		
		Snomed_Code__c sCode = mapSnomedCode.get('Race');
		if(sCode == null) {
			sCode = new Snomed_Code__c();
		}
		system.debug('registration : '+registration);
		system.debug('registration.Patient__r : '+registration.Patient__r);
		system.debug('registration.Patient__r.Race__c : '+registration.Patient__r.Race__c);
		system.debug('Splitted Race : '+registration.Patient__r.Race__c.split('\\;'));
		
		for(String race : registration.Patient__r.Race__c.split('\\;')) {
				system.debug('race : '+race);
				raceXML +=  '	<ns1:SETCE>' +
							'		<ns1:displayName>'+race+'</ns1:displayName>' +
							//'		<ns1:code>'+(sCode.Value__c == null?'' : sCode.Value__c)+'</ns1:code>' +
							'		<ns1:codeSystem>2.16.840.1.113883.3.26.2</ns1:codeSystem>' +
							'		<ns1:codeSystemName>caDSR</ns1:codeSystemName>' +
							'		<ns1:codeSystemVersion>2.1</ns1:codeSystemVersion>' +
							'	</ns1:SETCE>';
		}
		businessMsgPayload = businessMsgPayload.replaceAll('RACE_XML', raceXML);
		businessMsgPayload = businessMsgPayload.replaceAll('ETHNICITY_DISPLAY_NAME', registration.Patient__r.Ethnicity__c);
		Snomed_Code__c sCodeEthn = mapSnomedCode.get('Ethn');
		if(sCodeEthn == null) {
			sCodeEthn = new Snomed_Code__c();
		}
		
		//businessMsgPayload = businessMsgPayload.replaceAll('ETH_CODE', sCodeEthn.Value__c == null?'' : sCodeEthn.Value__c);
		businessMsgPayload = businessMsgPayload.replaceAll('CODE_SYS', (sCodeEthn.Code_System__c == null?'' : sCodeEthn.Code_System__c));
		businessMsgPayload = businessMsgPayload.replaceAll('CDMS_SUBJ_ID', (registration.TrialPatient__r.Subject_Id__c == null)?'' : registration.TrialPatient__r.Subject_Id__c);
		return businessMsgPayload;
	}
	
	public String getBusinessMsgPayloadXML(TissueSpecimenDetail__c tissueSpecimen) {
		String businessMsgPayload = '<?xml version="1.0" encoding="UTF-8" standalone="yes"?><ns1:trim xmlns:ns1="urn:tolven-org:trim:4.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"' +
					'	xmlns:xs="http://www.w3.org/2001/XMLSchema">' +
					'	<ns1:act>' +
					'		<ns1:relationship name="cdmsSubjectId">' +
					'			<ns1:act>' +
					'				<ns1:observation>' +
					'					<ns1:value>' +
					'						<ns1:label>cdmsSubjectId</ns1:label>' +
					'						<ns1:ST>_SUBJECT_ID</ns1:ST>' +
					'					</ns1:value>' +
					'				</ns1:observation>' +
					'			</ns1:act>' +
					'		</ns1:relationship>' +
					'		<ns1:relationship name="activityStatus">' +
					'			<ns1:act>' +
					'				<ns1:observation>' +
					'					<ns1:value>' +
					'						<ns1:label>activityStatus</ns1:label>' +
					'						<ns1:ST>_OUTER_ACT_STATUS</ns1:ST>' +
					'					</ns1:value>' +
					'				</ns1:observation>' +
					'			</ns1:act>' +
					'		</ns1:relationship>' +
					'		<ns1:relationship name="specimenList">' +
					'			<ns1:act>' +
					'				<ns1:observation />' +
					'				_SPECIMEN_LIST' +
					'			</ns1:act>' +
					'		</ns1:relationship>' +
					'	</ns1:act>' +
					'</ns1:trim>';
		
		
		
		String specimenListXML = '';
		String specimenXML = '';
		List<Core_Biopsy_Specimens__c> lstCoreBiopsy = tissueSpecimen.Core_Biopsy_Specimens__r;
		if(lstCoreBiopsy != null) {
			for(Core_Biopsy_Specimens__c coreBio : lstCoreBiopsy) {
				specimenXML = getSpecimenXML();
				specimenXML = specimenXML.replaceAll('_SPECIMEN_ID', coreBio.SpecimenID__c);
				specimenXML = specimenXML.replaceAll('_BAR_CODE', ''); //??
				specimenXML = specimenXML.replaceAll('_INNER_ACT_STATUS', 'Active');
				specimenXML = specimenXML.replaceAll('_COLLECTION_PROTOCOL_TITLE', 'Tolven Tissue Protocol');
				specimenXML = specimenXML.replaceAll('_COLLECTION_PROTOCOL_SHORT_TITLE', 'ttp');
				specimenXML = specimenXML.replaceAll('_SPECIMEN_CLASS', ''); //??
				specimenXML = specimenXML.replaceAll('_SPECIMEN_TYPE', 'TISSUE'); 
				specimenXML = specimenXML.replaceAll('_PATH_STATUS', ''); //??
				specimenXML = specimenXML.replaceAll('_INIT_QUANTITY', '1');
				specimenXML = specimenXML.replaceAll('_AVAILABLE_QUANTITY', '1');
				specimenXML = specimenXML.replaceAll('_TISSUE_SITE', ''); //??
				specimenXML = specimenXML.replaceAll('_TISSUE_SIDE', ''); //??
				specimenListXML += specimenXML;
			}
		}
		businessMsgPayload = businessMsgPayload.replaceAll('_SUBJECT_ID', tissueSpecimen.TrialPatient__r.Subject_Id__c);
		businessMsgPayload = businessMsgPayload.replaceAll('_OUTER_ACT_STATUS', 'Active');
		businessMsgPayload = businessMsgPayload.replaceAll('_SPECIMEN_LIST', specimenListXML);
		
		
		return businessMsgPayload;
	}
	
	public void postCaTissueProcess(Id trialPatientId, String operationName, String result, Id jobId) {
		if(operationName == 'createParticipant') {
			List<Registration__c> lstRegistration = [Select r.TrialPatient__c, r.TrialPatient__r.Subject_Id__c, r.Patient__r.Race__c, r.Patient__r.Last_Name__c, r.Patient__r.Ethnicity__c, r.Patient__c From Registration__c r where TrialPatient__c = :trialPatientId order by LastModifiedDate desc limit 1];
			for(Registration__c reg : lstRegistration) {
				if(result == 'success') {
					reg.IsCaTissueDone__c = true;
				} else {
					reg.IsCaTissueDone__c = false;
				}	
			}
			update lstRegistration;
		} else if(operationName == 'createSpecimen') {
			List<TissueSpecimenDetail__c> lstTissueSpecimen = [Select TrialPatient__c, TrialPatient__r.Subject_Id__c, (Select SpecimenID__c From Core_Biopsy_Specimens__r) From TissueSpecimenDetail__c t where TrialPatient__c = :trialPatientId ];
			for(TissueSpecimenDetail__c tissueSpecimen : lstTissueSpecimen) {
				if(result == 'success') {
					tissueSpecimen.IsCaTissueDone__c = true;
				} else {
					tissueSpecimen.IsCaTissueDone__c = false;
				}
			}
			update lstTissueSpecimen;
		}
		
		List<caTissueTempStorage__c> lstcaTissueTempStore = [select TrialPatient__c, IsProcessed__c from caTissueTempStorage__c where TrialPatient__c = :trialPatientId];
		for(caTissueTempStorage__c caT : lstcaTissueTempStore) {
			caT.IsProcessed__c = true;
		}
		update lstcaTissueTempStore;
		caTissueIntegration.deleteJob(jobId);
		
	}
	
	@future
	public static void deleteJob(Id jobId) {
		List<CronTrigger> lstCronTrigger = [select Id from CronTrigger where Id = :jobId and State = 'DELETED'];
		for(CronTrigger ct : lstCronTrigger) {
			System.abortJob(ct.Id);
		}
	}
	String getSpecimenXML() {
		String specimenXML = '<ns1:relationship name="specimen">' +
					'					<ns1:act>' +
					'						<ns1:observation />' +
					'						<ns1:relationship name="cdmsSpecimenId">' +
					'							<ns1:act>' +
					'								<ns1:observation>' +
					'									<ns1:value>' +
					'										<ns1:label>cdmsSpecimenId</ns1:label>' +
					'										<ns1:ST>_SPECIMEN_ID</ns1:ST>' +
					'									</ns1:value>' +
					'								</ns1:observation>' +
					'							</ns1:act>' +
					'						</ns1:relationship>' +
					'						<ns1:relationship name="barCode">' +
					'							<ns1:act>' +
					'								<ns1:observation>' +
					'									<ns1:value>' +
					'										<ns1:label>barCode</ns1:label>' +
					'										<ns1:ST>_BAR_CODE</ns1:ST>' +
					'									</ns1:value>' +
					'								</ns1:observation>' +
					'							</ns1:act>' +
					'						</ns1:relationship>' +
					'						<ns1:relationship name="activityStatus">' +
					'							<ns1:act>' +
					'								<ns1:observation>' +
					'									<ns1:value>' +
					'										<ns1:label>activityStatus</ns1:label>' +
					'										<ns1:ST>_INNER_ACT_STATUS</ns1:ST>' +
					'									</ns1:value>' +
					'								</ns1:observation>' +
					'							</ns1:act>' +
					'						</ns1:relationship>' +
					'						<ns1:relationship name="collectionProtocol">' +
					'							<ns1:act>' +
					'								<ns1:observation>' +
					'									<ns1:value>' +
					'										<ns1:label>title</ns1:label>' +
					'										<ns1:ST>_COLLECTION_PROTOCOL_TITLE</ns1:ST>' +
					'									</ns1:value>' +
					'									<ns1:value>' +
					'										<ns1:label>shortTitle</ns1:label>' +
					'										<ns1:ST>_COLLECTION_PROTOCOL_SHORT_TITLE</ns1:ST>' +
					'									</ns1:value>' +
					'								</ns1:observation>' +
					'							</ns1:act>' +
					'						</ns1:relationship>' +
					'						<ns1:relationship name="specimenClass">' +
					'							<ns1:act>' +
					'								<ns1:observation>' +
					'									<ns1:value>' +
					'										<ns1:label>specimenClass</ns1:label>' +
					'										<ns1:ST>_SPECIMEN_CLASS</ns1:ST>' +
					'									</ns1:value>' +
					'								</ns1:observation>' +
					'							</ns1:act>' +
					'						</ns1:relationship>' +
					'						<ns1:relationship name="specimenType">' +
					'							<ns1:act>' +
					'								<ns1:observation>' +
					'									<ns1:value>' +
					'										<ns1:label>specimenType</ns1:label>' +
					'										<ns1:ST>_SPECIMEN_TYPE</ns1:ST>' +
					'									</ns1:value>' +
					'								</ns1:observation>' +
					'							</ns1:act>' +
					'						</ns1:relationship>' +
					'						<ns1:relationship name="pathologicalStatus">' +
					'							<ns1:act>' +
					'								<ns1:observation>' +
					'									<ns1:value>' +
					'										<ns1:label>pathologicalStatus</ns1:label>' +
					'										<ns1:ST>_PATH_STATUS</ns1:ST>' +
					'									</ns1:value>' +
					'								</ns1:observation>' +
					'							</ns1:act>' +
					'						</ns1:relationship>' +
					'						<ns1:relationship name="initialQuantity">' +
					'							<ns1:act>' +
					'								<ns1:observation>' +
					'									<ns1:value>' +
					'										<ns1:label>_INIT_QUANTITY</ns1:label>' +
					'										<ns1:ST>1</ns1:ST>' +
					'									</ns1:value>' +
					'								</ns1:observation>' +
					'							</ns1:act>' +
					'						</ns1:relationship>' +
					'						<ns1:relationship name="availableQuantity">' +
					'							<ns1:act>' +
					'								<ns1:observation>' +
					'									<ns1:value>' +
					'										<ns1:label>availableQuantity</ns1:label>' +
					'										<ns1:ST>_AVAILABLE_QUANTITY</ns1:ST>' +
					'									</ns1:value>' +
					'								</ns1:observation>' +
					'							</ns1:act>' +
					'						</ns1:relationship>' +
					'						<ns1:relationship name="specimenCharacteristics">' +
					'							<ns1:act>' +
					'								<ns1:observation>' +
					'									<ns1:value>' +
					'										<ns1:label>tissueSite</ns1:label>' +
					'										<ns1:ST>_TISSUE_SITE</ns1:ST>' +
					'									</ns1:value>' +
					'									<ns1:value>' +
					'										<ns1:label>tissueSide</ns1:label>' +
					'										<ns1:ST>_TISSUE_SIDE</ns1:ST>' +
					'									</ns1:value>' +
					'								</ns1:observation>' +
					'							</ns1:act>' +
					'						</ns1:relationship>' +
					'					</ns1:act>' +
					'				</ns1:relationship>';
		
		return specimenXML;
	} 
	
	@future (callout = true)
	public static void callCaTissue(String jobId, String operationType) {
		List<caTissueTempStorage__c> lstCaTissueTempStoreage =[select IsProcessed__c, TrialPatient__c from caTissueTempStorage__c where IsProcessed__c = false limit 1];
		if(!lstCaTissueTempStoreage.isEmpty()) {
			if(operationType == 'createParticipant') {
				caTissueIntegration.createParticipant_FutureCall(lstCaTissueTempStoreage[0].TrialPatient__c, jobId);
			} else if(operationType == 'createSpecimen') {
				caTissueIntegration.createSpecimen_FutureCall(lstCaTissueTempStoreage[0].TrialPatient__c, jobId);
			}
		}
	}
	
}