public with sharing class IntegrationXMLGenerator {

	/*public Id generateXMLFromCRF(Id masterCRFId, Id crfInstanceId) {
		//Query on CRFMaster__c in wher condition put masterCRFId
		List<CRFMaster__c> crfMstlist = [Select c.Object_Name__c, c.Id From CRFMaster__c c where Id = :masterCRFId];
		if(crfMstlist.isEmpty()) {
			return null;
		}
		
		//Get value of Object_Name__c this gives api name of the crf object
		String objName = crfMstlist[0].Object_Name__c;
		
		//Get fields from configuration xml object
		List<XML_Configuration__c> xmlConfigList = [Select x.XML_Node__c, x.Object_API_Name__c, x.Id, x.Field_API_Name__c, x.CRF_Type__c From XML_Configuration__c x  where CRF_Type__c = :masterCRFId];
		
		//Get the fields
		SObjectType objFields = Schema.getGlobalDescribe().get('CRFMaster__c');
        DescribeSObjectResult objDef = objFields.getDescribe();
        Map<String, SObjectField> fields = objDef.fields.getMap(); 
        Set<String> fieldSet = fields.keySet();
        System.debug('fieldSet:'+fieldSet);
        
        //Build XML
        XmlStreamWriter xsw = new XmlStreamWriter();
		w.writeStartDocument(null, '1.0');
		w.writeStartElement(null, 'patient', null);
        for(String s:fieldSet) {
        	for(XML_Configuration__c config : xmlConfigList) {
        		if(config.Field_API_Name__c == s) {
        			
        		}
        	}
            SObjectField objFields = fields.get(s);
            DescribeFieldResult selectedField = objFields.getDescribe();
            System.debug(selectedField.getName());
        }
		
		//store the fields in string (coma seperated) which are selected in configiration xml
		String xmlFields = '';   
		//query on that object using this string
		//build XML using XML_Node__c values for each field
		//Save XML as attachment record with ParentId = crfInstance
		 
		return null;
	}
	
	public class InstituteInfo {
		String id,name,siteId,siteName;
		
		public InstituteInfo(String id, String name, String siteId, String siteName) {
			this.id = id;
			this.name = name;
			this.siteId = siteId;
			this.siteName = siteName;
		}
		
	}
	
	public class PatientInfo {
		String firstName, initial, lastName, ssn, subjectId, race, ethnicity;
		public PatientInfo(String firstName, String lastName, String initial, String ssn, String subjectId, String race, String ethnicity) {
		  this.firstName = firstName;
		  this.initial = initial;
		  this.lastName = lastName; 
		  this.ssn = ssn;
		  this.subjectId = subjectId;
		  this.race = race;
		  this.ethnicity = ethnicity;
		}
	}*/
}