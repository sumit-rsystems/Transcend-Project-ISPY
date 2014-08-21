public with sharing class SignAndSubmitController {
  public String errorMsg {get;set;}
  public String password {get;set;}
  public Boolean isErrorMsg {get;set;}
  public Boolean isCodeSent {get;set;}
  public String patientId{get;set;}
  public String trialId{get;set;}
  public Boolean msgdisplay{get;set;}
  public Pagereference signAndSubmit() {
    isErrorMsg = false;
    msgdisplay=false;
    Pagereference ref = null;
    patientId = '';
    String CRFCode = Apexpages.currentPage().getParameters().get('form_code');
    String retURLValue = Apexpages.currentPage().getParameters().get('retURL');
    system.debug('CRFCode : '+CRFCode);
    String id = Apexpages.currentPage().getParameters().get('id');
    boolean isValidUser = PasswordManager.verifyPassword(Userinfo.getUserId(), password);
    String keyCode  = id.subString(0,3);
    if(isValidUser) {
      String recordObjectName = '';
      Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe();
      for(Schema.SObjectType objectInstance : gd.values()) {
        if(objectInstance.getDescribe().getKeyPrefix() == keyCode) {//do your processing with the API name what you want
          System.debug('Id is related to object: '+ objectInstance.getDescribe().getName());
          String objectName = objectInstance.getDescribe().getName();
          List<Sobject> recordData = Database.query('select Id from '+objectName+' where Id = \''+id+'\'');
          System.debug('data of '+objectName+' : '+recordData);
          if(!recordData.isEmpty()) {
            recordObjectName = objectName;
            break;
          }
        }
      }
      Boolean isApprovalRequired = false;
      system.debug('Query : '+'select IsApprovalRequired__c from CRFMaster__c where Name = \''+CRFCode+'\'');
      List<CRFMaster__c> lstCRFMaster = Database.query('select IsApprovalRequired__c from CRFMaster__c where Name = \''+CRFCode+'\'');
      if(lstCRFMaster != null && lstCRFMaster.size() > 0) {
        isApprovalRequired = lstCRFMaster[0].IsApprovalRequired__c;
      }
      system.debug('isApprovalRequired : '+isApprovalRequired);
      List<RecordType> lstRecordType = Database.query('select Id, Name from RecordType where sObjectType = \''+recordObjectName+'\' and Name = \'Approval Pending\'');
      List<Sobject> lstSObject = new List<Sobject>();
       
      if(recordObjectName == 'Patient_Custom__c') {
        lstSObject = Database.query('select RecordTypeId, Status__c from '+recordObjectName+' where Id = \''+id+'\'');
        patientId = id;
      } else if(recordObjectName == 'PreEligibility_Checklist__c') {
        lstSObject = Database.query('select RecordTypeId, Status__c, Patient__c from '+recordObjectName+' where Id = \''+id+'\'');
        patientId = (String)lstSObject[0].get('Patient__c');
      } else {
        lstSObject = Database.query('select RecordTypeId, Status__c, TrialPatient__c from '+recordObjectName+' where Id = \''+id+'\'');
      }
      
      if(lstSObject != null && lstSObject.size() > 0 && lstRecordType != null && lstRecordType.size() > 0) {
        if(recordObjectName != 'Patient_Custom__c' && recordObjectName != 'PreEligibility_Checklist__c' && lstSObject[0].get('TrialPatient__c') != null) {
          Id trialPatId = (Id)lstSObject[0].get('TrialPatient__c');
          List<TrialPatient__c> trialPat = [select Patient_Id__r.Id from TrialPatient__c where Id =:trialPatId];
          if(!trialPat.isEmpty()) {
            patientId = trialPat[0].Patient_Id__r.Id;
          }
        }
        
        lstSObject[0].put('RecordTypeId', lstRecordType[0].Id);
        if(isApprovalRequired) {
          //lstSObject[0].put('Status__c', 'Approval Pending');
        } else {
          lstSObject[0].put('Status__c', 'Approval Not Required');
          system.debug('lstSObject : '+lstSObject);
          update lstSObject;
          system.debug('lstSObject.get(Status__c) : '+lstSObject[0].get('Status__c'));
        }
      }
      
     if(isApprovalRequired) {
        try{
          ApprovalManager.ApprovalRequestOutcome approvalRequest = ApprovalManager.submitForApproval(id, recordObjectName);
          system.debug('***---***' + approvalRequest);
          if(approvalRequest == ApprovalManager.ApprovalRequestOutcome.NO_DCC_USER) {
          	msgdisplay=true;
            Apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.INFO, 'There is no DCC user allocated to this trial for your institute');
            Apexpages.addMessage(msg);
            return null;
          } 
        } catch (Dmlexception e) {
          errorMsg = 'This CRF seems to be already under approval';
          system.debug('This CRF seems to be already under approval : '+e);
          isErrorMsg = true;
          isCodeSent = false;
          return null; 
        } 
      }  
     //  ApprovalManager.ApprovalRequestOutcome approvalRequest = ApprovalManager.submitForApproval(id, recordObjectName);
      
      ref = new Pagereference('/'+lstSObject[0].Id);
      if(patientId != '') {
        ref = new PageReference('/'+patientId);
      }
      ref.setRedirect(true);  
      
    } else {
      errorMsg = 'Error : Invalid Secure Code - Please provide a valid "Secure Code".';
      isErrorMsg = true;
      isCodeSent = false;
      //ref = new Pagereference('/apex/SignAndSubmitPage?id='+id+'&form_code='+CRFCode);
      //ref.setRedirect(true);
    }
    
    return ref;
  }
  
  public Pagereference signAndSubmit(String CRFCode, String retURLValue, String id, String sharingwith) {
    system.debug('sharingwith : '+sharingwith);
    isErrorMsg = false;
    Pagereference ref = null;
    patientId = '';
    //String CRFCode = Apexpages.currentPage().getParameters().get('form_code');
    //String retURLValue = Apexpages.currentPage().getParameters().get('retURL');
    system.debug('CRFCode : '+CRFCode);
    //String id = Apexpages.currentPage().getParameters().get('id');
    boolean isValidUser = PasswordManager.verifyPassword(Userinfo.getUserId(), password);
    String keyCode  = id.subString(0,3);
    if(isValidUser) {
      String recordObjectName = '';
      Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe();
      for(Schema.SObjectType objectInstance : gd.values()) {
        if(objectInstance.getDescribe().getKeyPrefix() == keyCode) {//do your processing with the API name what you want
          System.debug('Id is related to object: '+ objectInstance.getDescribe().getName());
          String objectName = objectInstance.getDescribe().getName();
          List<Sobject> recordData = Database.query('select Id from '+objectName+' where Id = \''+id+'\'');
          System.debug('data of '+objectName+' : '+recordData);
          if(!recordData.isEmpty()) {
            recordObjectName = objectName;
            break;
          }
        }
      }
      Boolean isApprovalRequired = false;
      system.debug('Query : '+'select IsApprovalRequired__c from CRFMaster__c where Name = \''+CRFCode+'\'');
      List<CRFMaster__c> lstCRFMaster = Database.query('select IsApprovalRequired__c from CRFMaster__c where Name = \''+CRFCode+'\'');
      if(lstCRFMaster != null && lstCRFMaster.size() > 0) {
        isApprovalRequired = lstCRFMaster[0].IsApprovalRequired__c;
      }
      system.debug('isApprovalRequired : '+isApprovalRequired);
      List<RecordType> lstRecordType = Database.query('select Id, Name from RecordType where sObjectType = \''+recordObjectName+'\' and Name = \'Approval Pending\'');
      List<Sobject> lstSObject = new List<Sobject>();
      if(recordObjectName == 'Patient_Custom__c') {
        lstSObject = Database.query('select RecordTypeId, Status__c, CompletedDate__c from '+recordObjectName+' where Id = \''+id+'\'');
        patientId = id;
      } else if(recordObjectName == 'PreEligibility_Checklist__c') {
        lstSObject = Database.query('select TrialPatient__c,RecordTypeId, Status__c, Patient__c, CompletedDate__c,First_Save_and_Close__c from '+recordObjectName+' where Id = \''+id+'\'');
        patientId = (String)lstSObject[0].get('Patient__c');
      } else {
            lstSObject = Database.query('select RecordTypeId, Status__c, TrialPatient__c, CompletedDate__c,First_Save_and_Close__c, OriginalCRF__c from '+recordObjectName+' where Id = \''+id+'\'');
      }     
      if(lstSObject != null && lstSObject.size() > 0 && lstRecordType != null && lstRecordType.size() > 0) {
        if(recordObjectName != 'Patient_Custom__c'  && lstSObject[0].get('TrialPatient__c') != null) {
          Id trialPatId = (Id)lstSObject[0].get('TrialPatient__c');
          List<TrialPatient__c> trialPat = [select Patient_Id__r.Id, Trial_Id__c from TrialPatient__c where Id =:trialPatId];
          if(!trialPat.isEmpty()) {
            patientId = trialPat[0].Patient_Id__r.Id;
            trialId = trialPat[0].Trial_Id__c;
          }
        }
        
        lstSObject[0].put('RecordTypeId', lstRecordType[0].Id);
        system.debug('Date.today() : '+Date.today());
        lstSObject[0].put('CompletedDate__c', Date.today());
        system.debug('lstSObject : '+lstSObject);
      	System.debug('sharingwith---------'+sharingwith);
      	System.debug('pppppp---------'+lstSObject[0].get('First_Save_and_Close__c'));
        if(lstSObject[0].get('First_Save_and_Close__c') == null) lstSObject[0].put('First_Save_and_Close__c', false); 
         if(sharingwith!=null && sharingwith!='' && !Boolean.valueOf(lstSObject[0].get('First_Save_and_Close__c'))){
          List<String> shareRtype = sharingwith.split('\\,');
          for(String tmpStr : shareRtype) {
            	SharingManager.shareObjectWithSite(lstSObject, recordObjectName, tmpStr);
           }
        }
        
        
        if(isApprovalRequired) {
          //lstSObject[0].put('Status__c', 'Approval Pending');
          String approvalURL = URL.getSalesforceBaseUrl().toExternalForm()+'/apex/DCCApproval?recId='+id+'&object='+recordObjectName+'&trialPat='+lstSObject[0].get('TrialPatient__c');
          lstSObject[0].put('Submitter__c', Userinfo.getUserId());
          lstSObject[0].put('ApprovalURL__c', approvalURL);
        } else {
          lstSObject[0].put('Status__c', 'Approval Not Required');
          system.debug('lstSObject : '+lstSObject);
          //update lstSObject;
        }
        update lstSObject;
        system.debug('lstSObject.get(Status__c) : '+lstSObject[0].get('Status__c'));
      }
      
      if(isApprovalRequired) {
        try{
          ApprovalManager.ApprovalRequestOutcome approvalRequest = ApprovalManager.submitForApproval(id, recordObjectName);
          if(approvalRequest == ApprovalManager.ApprovalRequestOutcome.NO_DCC_USER) {
          	msgdisplay=true;
          	system.debug('no_dcc_user'+approvalRequest);
          	system.debug('msgdisplay'+msgdisplay);
            	Apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.INFO, 'There is no DCC user allocated to this trial for your institute');
            	Apexpages.addMessage(msg);
				
				errorMsg = 'There is no DCC user allocated to this trial for your institute.';
	          	system.debug('There is no DCC user allocated to this trial for your institute');
	          	isErrorMsg = true;
	          	isCodeSent = false;
            	return null;
          } 
        } catch (Dmlexception e) {
          errorMsg = 'Access Denied : The CRF is already under dcc approval.==='+e.getMessage();
          system.debug('Access Denied : The CRF is already under dcc approval. Error : '+e);
          isErrorMsg = true;
          isCodeSent = false;
          return null; 
        } 
      } 
     
    
      ref = new Pagereference('/'+lstSObject[0].Id);
      if(patientId != '') {
        if(trialId != null) {
          ref = new PageReference('/apex/TranscendPage?id='+patientId+'&TrialId='+trialId);
         // ref = new PageReference('/apex/TranscendPage?id='+patientId);
        } else {
          ref = new PageReference('/'+patientId);
        }
      }
      ref.setRedirect(true);  
      
    } else {
      errorMsg = 'Error : Invalid Secure Code - Please provide a valid "Secure Code".';
      isErrorMsg = true;
      isCodeSent = false;
      //ref = new Pagereference('/apex/SignAndSubmitPage?id='+id+'&form_code='+CRFCode);
      //ref.setRedirect(true);
    }
    system.debug('ref:'+ref);
    return ref;
  }
  
  public Boolean signAndSubmitForDCC() {
    isErrorMsg = false;
    boolean isValidUser = PasswordManager.verifyPassword(Userinfo.getUserId(), password);
    if(!isValidUser) {
      errorMsg = 'Error : Invalid Secure Code - Please provide a valid "Secure Code".';
      isErrorMsg = true;
      isCodeSent = false;
    }
    return isValidUser;
  }
  
  public void resendCode() {
    isCodeSent = true;
    isErrorMsg = false;
    password = '';
    String CRFCode = Apexpages.currentPage().getParameters().get('form_code');
    String id = Apexpages.currentPage().getParameters().get('id');
    String password = PasswordManager.generatePassword();
    Id userId = Userinfo.getUserId();
    List<User> lstUser = [select Email,FirstName,LastName,Username from User where Id = :userId];
    if(!lstUser.isEmpty()) {
      lstUser[0].SecurityCode__c = password;
    }
    update lstUser;
  }
}