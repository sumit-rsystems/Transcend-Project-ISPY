public With Sharing Class ExternalServiceConnector{

    private External_Connection_Settings__c iHubEndpoint = null;
    
    public cdapackage.CDAGeneratorPort ihub = null;

    //constructor
    public ExternalServiceConnector(string connectorType){
        External_Connection_Settings__c iHubEndpoint = External_Connection_Settings__c.getInstance(connectorType);
        if(connectorType == 'iHub'){
            ihub = new cdapackage.CDAGeneratorPort();
            if (iHubEndpoint != null){
                ihub.endpoint_x=iHubEndpoint.URL__c;
                ihub.timeout_x=iHubEndpoint.Timeout__c.intValue();
            }else{
                ihub.endpoint_x = 'http://ec2-23-20-103-202.compute-1.amazonaws.com:12020/services/CDAGenerator';
                ihub.timeout_x = 120000;
            }  
        }      
    }
    
    //action to be performed for failed registration.
    public static void populateFailedRegistration(String ObjectName,String crfId,Boolean isConsent,String patientId, String trialId, String siteId,String studyId, String errorCode, String errorMessage, String status,String systemName, String mrn,String caXchangeId, String returnId){
        String CRFName;
        List<CRFMaster__c> crfList = [Select c.CRFType__c From CRFMaster__c c where c.Object_Name__c=:ObjectName];
        if(crfList.size()>0){
            CRFName = crfList[0].CRFType__c;
        }
        Boolean autoRetry = false;
        List<Auto_Retry_Error_Codes__c> codeList = Auto_Retry_Error_Codes__c.getAll().values();
        for(Auto_Retry_Error_Codes__c code : codeList){
            if(code.Error_Code__c==errorCode){
                autoRetry = true;
                break;
            }
        }
        
        Failed_Registration__c fr = new Failed_Registration__c(CRF_Id__c=crfId,IsConsent__c=isConsent,Patient__c=patientId,Trial__c=trialId,Last_Error_Message__c=errorMessage,Last_Status__c=status,Retry__c=autoRetry,Site__c=siteId,Study_Id__c=studyId,Error_Code__c=errorCode,System_Name__c=systemName,MRN__c=mrn,CRF_Name__c=CRFName,CaXchangeId__c=caXchangeId,ReturnId__c=returnId);
                    
        insert fr;
    }
    
    
    public static void viewXML(String xml, Id parentId, string xmlName) {
        Attachment att = new Attachment();
        att.ContentType = 'application/xml';
        //att.Body = ref.getContent();
        //String xml = generateXML();
        if(xml == null) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Insufficient Data to Generate XML'));
            return;
        }
        //att.Body = Blob.valueOf(generateXML());
        att.Body = Blob.valueOf(xml);
        att.Name = xmlName + system.today();
        att.ParentId = parentId;
        insert att;
        system.debug('--att--'+att);
    }
}