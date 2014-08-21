public with sharing class ApprovalManager {
    
    public Enum ApprovalRequestOutcome {SUCCESS, NO_DCC_USER, ALREADY_UNDER_APPROVAL} 

    
    public static ApprovalRequestOutcome submitForApproval(String recordId, String recordObjectName) {
    	
    	//Added by Bakul for SAE updated
        List<DCC_Form__c> dccForms = [select account__c,Id from DCC_Form__c where CRFMaster__r.Object_Name__c = :recordObjectName];
        if(dccForms.isEmpty()) {
        	throw new NoDccForFormException('No DCC assigned to approve '+recordObjectName+' forms');
        }
        if(dccForms.size() > 1) {
        	throw new MultipleApproverDccException('More than 1 approver DCC for this form. Must only be one approver DCC for each type of form.');
        }
        system.debug('dccForms:'+dccForms[0]);
        //Added by Bakul for SAE updated
                
        String trialPatientId = null;
        String trialId = null;
        String siteId = null;
        String patientId = null;
        String institutionId = null;
        List<Sobject> lstSObject = Database.query('select TrialPatient__c, OriginalCRF__c, ApprovalURL__c, Submitter__c from '+recordObjectName+' where Id = \''+recordId+'\'');
        if(lstSObject != null && lstSObject.size() > 0) {
            trialPatientId = String.valueOf(lstSObject[0].get('TrialPatient__c'));
            system.debug('trialPatientId : '+trialPatientId);
            List<TrialPatient__c> lstTrialPatient = [select Trial_Id__c, Trial_Id__r.Name, Site__c, Site__r.Name, Patient_Id__c, Subject_Id__c, Patient_Id__r.Institution__c from TrialPatient__c where Id = :trialPatientId];
            system.debug('lstTrialPatient : '+lstTrialPatient);
            if(lstTrialPatient != null && lstTrialPatient.size() > 0) {
                  
                trialId = lstTrialPatient[0].Trial_Id__c;
                siteId = lstTrialPatient[0].Site__c;
                patientId = lstTrialPatient[0].Patient_Id__c;
                institutionId = lstTrialPatient[0].Patient_Id__r.Institution__c;
                system.debug('trialId : '+trialId+'    siteId : '+siteId+'     patientId : '+patientId+'    institutionId : '+institutionId);
                Set<Id> instDccIds = new Set<Id>();
                Set<String> instDccNames = new Set<String>();
                //List<InstitutionDcc__c> lstInstitutionDcc = [Select i.Institution_Id__c, i.DCC_Id__c, i.DCC_Id__r.Name From InstitutionDcc__c i where Institution_Id__c = :institutionId];
                List<InstitutionTrialDcc__c> lstInstitutionDcc = [select DCC_Id__c,DCC_Id__r.Inst_Group__c,Institution_Id__c,Trial_Id__c from InstitutionTrialDcc__c where Trial_Id__c = :trialId and DCC_Id__c = :dccForms[0].account__c];
                system.debug('lstInstitutionDcc : '+lstInstitutionDcc);
                for(InstitutionTrialDcc__c instDcc : lstInstitutionDcc) {
                    instDccIds.add(instDcc.DCC_Id__c);
                    instDccNames.add(instDcc.DCC_Id__r.Inst_Group__c);
                }
                system.debug('instDccIds : '+instDccIds);
                system.debug('instDccNames : '+instDccNames);
                
                List<Id> queueIds = new List<Id>();
                List<Account> lstAccount = [Select a.Name,a.Inst_Group__c From Account a where Id IN :instDccIds];
                system.debug('instDccNames : '+instDccNames);
                List<GroupMember> grpMemberList = new List<GroupMember>();
                if(lstAccount != null && lstAccount.size() > 0) {
                   List<Group> lstGroup = [Select Id, Name, Email from Group where Name = :lstAccount[0].Inst_Group__c and Type = 'Queue'];
                    system.debug('lstGroup : '+lstGroup);
                    List<Group> lstGroup1 = [Select Id, Name, Email from Group where Name IN :instDccNames and Type = 'Regular'];
                    system.debug('lstGroup1 : '+lstGroup1);
                    for(Group g : lstGroup) {
                        queueIds.add(g.Id);
                    }
                    
        //================code end for get Queue's User's Email IDs==========================================================================
        
                    String sharedObjectName = '';
                    if(recordObjectName.endsWith('__c')) {
                        sharedObjectName = recordObjectName.replaceAll('__c', '__Share');
                    } else {
                        sharedObjectName = recordObjectName + 'Share';
                    }
                    SharingManager.shareObject(lstGroup1, lstSObject, sharedObjectName);
                }
                system.debug('queueIds : '+queueIds);
               
				if(queueIds.isEmpty()) {
					return ApprovalRequestOutcome.NO_DCC_USER;
				}
                //String approvalURL = raiseApproval(recordObjectName, recordId, queueIds, lstSObject[0]);
                /*for(Sobject sobj : lstSObject) {
					sobj.put('Submitter__c', Userinfo.getUserId());
					sobj.put('ApprovalURL__c', approvalURL);
				}
				update lstSObject;*/
                raiseApproval(recordObjectName, recordId, queueIds, lstSObject[0]);
                String approvalURL = (String) lstSObject[0].get('ApprovalURL__c');
                createApprovalRequest(recordObjectName, approvalURL, recordId, queueIds[0], lstTrialPatient[0].Site__c, lstTrialPatient[0].Trial_Id__c, lstTrialPatient[0].Subject_Id__c, institutionId, lstTrialPatient[0].Id);
                
                grpMemberList = [select UserOrGroupId from GroupMember where GroupId IN :queueIds];
                
                shareDocuments(grpMemberList, recordId);
                
                //sendEmail(grpMemberList, approvalURL);
            }
        }
        return ApprovalRequestOutcome.SUCCESS;
    }
    
    private static void raiseApproval(String recordObjectName, Id recordId, List<Id> queueIds, SObject sobj) {
        Approval.ProcessSubmitRequest CRFReq = new Approval.ProcessSubmitRequest();
        CRFReq.setComments('Submitting request for '+recordObjectName.replaceAll('__c', '')+' approval.');
        CRFReq.setObjectId(recordId);
        CRFReq.setNextApproverIds(queueIds);
        system.debug('^^^--^^' + queueIds);
        system.debug('^^^--^^' + CRFReq);
         system.debug('^^^--^^' + recordId);
        Approval.ProcessResult result = Approval.process(CRFReq);
        system.debug('result : '+result);
        string[] NewWorkitemIds = result.getNewWorkitemIds();
        //return URL.getSalesforceBaseUrl().toExternalForm()+'/apex/DCCApproval?recId='+recordId+'&object='+recordObjectName+'&trialPat='+sobj.get('TrialPatient__c')+'&workItemId='+NewWorkitemIds[0];
    }
    
    
    private static void createApprovalRequest(String recordObjectName, String approvalURL, Id recordId, Id queueId, Id siteId, Id trialId, String subjectId, Id instId, Id tpId) {
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Schema.SObjectType leadSchema = schemaMap.get(recordObjectName);
        String objectLabel = leadSchema.getDescribe().getLabel();
        
        Approval_Request__c appRequest = new Approval_Request__c();
        appRequest.Approval_URL__c = approvalURL;
        appRequest.Object_Label__c = objectLabel;
        appRequest.Record_Id__c = recordId;
        appRequest.Group_Id__c = queueId;
        appRequest.Site__c = siteId;
        appRequest.Study__c = trialId;
        appRequest.Subject_Id__c = subjectId;
        appRequest.Status__c = 'Pending';
        appRequest.Institution__c = instId;
        appRequest.TrialPatient__c = tpId;
        insert appRequest;
    }
    
    private static void shareDocuments(List<GroupMember> grpMemberList, Id recordId) {
        List<ContentVersion> contVersionList = [Select ContentDocumentId From ContentVersion c where FirstPublishLocationId =:recordId];
        system.debug('__contVersionList__'+contVersionList);
        List<ContentDocumentLink> insertContentDocLink = new List<ContentDocumentLink>();
        for(ContentVersion contVersionObj : contVersionList) {
            for(GroupMember grpMem: grpMemberList) {
                ContentDocumentLink contentDocLink = new ContentDocumentLink();
                contentDocLink.ContentDocumentId = contVersionObj.ContentDocumentId;
                contentDocLink.ShareType = 'V';
                contentDocLink.LinkedEntityId = grpMem.UserOrGroupId;
                insertContentDocLink.add(contentDocLink);
            }
        }
        system.debug('__insertContentDocLink__'+insertContentDocLink);
        insert insertContentDocLink;
    }
    
    private static ApprovalRequestOutcome sendEmail(List<GroupMember> grpMemberList, String approvalURL) {
        Set<Id> userIdSet = new Set<Id>(); 
        for(GroupMember grpMem: grpMemberList) {
            userIdSet.add(grpMem.UserOrGroupId);
        }
        
        Map<Id, User> mapUser = new Map<Id, User>([select Email from User where Id IN :userIdSet and IsActive = true]);
        System.debug('mapUser:'+mapUser);
        System.debug('mapUser.size():'+mapUser.size());
        
        if(mapUser.isEmpty()) {
            return ApprovalRequestOutcome.NO_DCC_USER;
                         //   return null;
        }
        List<Id> lstUserIds = new List<Id>();
        lstUserIds.addAll(mapUser.keySet());

        User userObj = [select Email, Name from User where Id =:Userinfo.getUserId()];
        //single email code
        List<String> userEmailId = new List<String>();
        for(User user : mapUser.values()) {
            userEmailId.add(user.Email);
        }
        Messaging.Singleemailmessage mail = new Messaging.Singleemailmessage();
        mail.setToAddresses(userEmailId);
        mail.setReplyTo(userObj.Email);
        mail.setBccSender(true);
        mail.setSenderDisplayName(userObj.Name);
        mail.setSubject('Approval Request');
        
        mail.setHtmlBody('<br/><br/> '+userObj.Name+' has requested your approval for the following item: <a href="'+approvalURL+'" >Click Here</a> <br/><br/> Please click this link to approve or reject this record. <br/><br/>Thank you, <br/><a href="http://www.salesforce.com" >salesforce.com</a>');
        System.debug('__mail__'+mail);
        Messaging.sendEmail(new Messaging.Singleemailmessage[] { mail });
        /*List<EmailTemplate> lstEmailTemplate = [SELECT Id FROM EmailTemplate WHERE Name = 'Menopausal DCC Template1'];
		system.debug('lstEmailTemplate: '+lstEmailTemplate);

        Messaging.Massemailmessage mail = new Messaging.Massemailmessage();
        mail.setSaveAsActivity(false);
		mail.setTargetObjectIds(lstUserIds);
		if(!lstEmailTemplate.isEmpty()) {
		    system.debug('lstEmailTemplate[0].Id: '+lstEmailTemplate[0].Id);
		 	mail.setTemplateId(lstEmailTemplate[0].Id);
		}
        mail.setReplyTo(userObj.Email);
        mail.setBccSender(true);
        mail.setSenderDisplayName(userObj.Name);
        mail.setWhatIds(new List<Id>{crfrecordId});
        //mail.setSubject('Approval Request');
        
        System.debug('__mail__'+mail);
        Messaging.sendEmail(new Messaging.Massemailmessage[] { mail });*/
        
        return ApprovalRequestOutcome.SUCCESS;
    }
    
    public static void approveCRF(String recordId, String workItemId, String comments) {
        Approval.ProcessWorkitemRequest req2 = new Approval.ProcessWorkitemRequest();
        req2.setComments(comments);
        req2.setAction('Approve');
        req2.setNextApproverIds(new Id[] {recordId});
        
        // Use the ID from the newly created item to specify the item to be worked 
        req2.setWorkitemId(workItemId);
        
        // Submit the request for approval 
        Approval.ProcessResult result2 =  Approval.process(req2);
        
        // Verify the results 
        System.assert(result2.isSuccess(), 'Result Status:'+result2.isSuccess());
        
        System.assertEquals(
            'Approved', result2.getInstanceStatus(), 
            'Instance Status'+result2.getInstanceStatus()
        );
        List<Approval_Request__c> lstApprovalReq = [select Id from Approval_Request__c where Record_Id__c =:recordId];
        for(Approval_Request__c appReq : lstApprovalReq) {
            appReq.Status__c = 'Approved';
        }
        if(!lstApprovalReq.isEmpty()) {
            update lstApprovalReq;
        }
    } 
    
    public static void rejectCRF(String recordId, String workItemId, String comments) {
    	system.debug('Inside the REJECT method -------------->232'+recordId);
    	system.debug('Inside the REJECT method -------------->232'+workItemId);
    	system.debug('Inside the REJECT method -------------->232'+comments);
        Approval.ProcessWorkitemRequest req2 = new Approval.ProcessWorkitemRequest();
        req2.setComments(comments);
        req2.setAction('Reject');
        req2.setNextApproverIds(new Id[] {recordId});
        
        // Use the ID from the newly created item to specify the item to be worked 
        req2.setWorkitemId(workItemId);
        
        // Submit the request for approval 
        Approval.ProcessResult result2 =  Approval.process(req2);
        
        // Verify the results 
        System.assert(result2.isSuccess(), 'Result Status:'+result2.isSuccess());
        
        System.assertEquals(
            'Rejected', result2.getInstanceStatus(), 
            'Instance Status'+result2.getInstanceStatus()
        );
        List<Approval_Request__c> lstApprovalReq = [select Id from Approval_Request__c where Record_Id__c =:recordId];
        for(Approval_Request__c appReq : lstApprovalReq) {
            appReq.Status__c = 'Rejected';
        }
        if(!lstApprovalReq.isEmpty()) {
            update lstApprovalReq;
        }
    }
}