trigger ProposedReschedulingAfterInsert on Proposed_Rescheduling__c (after insert,after update) {
	
	List<Proposed_Rescheduling__c> propRechList = [Select p.subject__c, p.refId__c, p.WhatId__c, p.Type__c, p.Trial__c, p.SystemModstamp, p.StartDateTime__c, p.Reschedule_reason__c, p.Proposed_New_Date__c, p.PatientId__c, p.Owner.Email, p.OwnerId, p.Name, p.Minutes__c, p.LastModifiedDate, p.LastModifiedById, p.IsDeleted, p.Id, p.Hours__c, p.Eventid__c, p.EndDate__c, p.DurationInMinutes__c, p.Description__c, p.CreatedDate, p.CreatedById From Proposed_Rescheduling__c p where id IN : Trigger.newMap.keySet()];
	List<Messaging.Singleemailmessage> emails = new List<Messaging.Singleemailmessage>();
	
	List<String> mailIds = new List<string>();
	Messaging.Singleemailmessage mail = new Messaging.Singleemailmessage();
	
	set<String> eventSetId = new Set<String>();
	for(Proposed_Rescheduling__c prop : propRechList){
		eventSetId.add(prop.Eventid__c);
	}
	List<Event> eveList = [Select e.WhatId,e.OwnerId,e.Owner.Username, e.Owner.Email, e.Subject ,e.Reschedule_reason__c,e.StartDateTime ,e.Id, e.EndDateTime, e.DurationInMinutes, e.Description, e.ActivityDateTime, e.ActivityDate From Event e ];

	String refId = '';
	String subject = '';
	String str = '';
	String strelse = '';
	String temp = '';
	temp += '<br/><br/>';
	temp += '<table cellpadding="1" cellspacing="1"  id="tblReport" width="100%" >';
	temp += '<tr style="cursor: pointer; font-weight: bold; font-size: 12px; background-color: #2897EC; height: 20px; width: 50px; vertical-align: middle; border: none;"><td style="color: white; padding-left: 5px; width: 5%;">Purpose</td><td style="color: white; padding-left: 5px; width: 5%;">Current Schedule</td><td style="color: white; padding-left: 5px; width: 5%;">Proposed Schedule</td></tr>';
		if(Trigger.isInsert){
			for(Proposed_Rescheduling__c propObj : propRechList){
				if(propObj.Eventid__c == null){
					if(propObj.Owner.Email != null) {
						str += '<table cellpadding="1" cellspacing="1"; width="100%" >';
						str += '<tr style=" border-right: 1px  solid #dce6f2; border-left: 1px  solid #dce6f2; border-bottom: 1px  solid #dce6f2; font-weight: bold; font-size: 12px; background-color: #2897EC; height: 20px; width: 50px; vertical-align: middle; border: none;"><td style="color: white; padding-left: 5px; width: 5%;">Start Date</td><td style="color: white; padding-left: 5px; width: 5%;">End Date</td><td style="color: white; padding-left: 5px; width: 5%;">Description</td></tr>';
		
						mailIds.add(propObj.Owner.Email);
						//mailIds.add('ispytesting1@gmail.com');
						str += '<tr style="border-right: 1px  solid #dce6f2; border-bottom: 1px  solid #dce6f2;"><td style=" border-left: 1px  solid #dce6f2; padding-left: 5px;border-right: 1px  solid #dce6f2; border-bottom: 1px  solid #dce6f2;">'+String.valueOf(propObj.StartDateTime__c.format('MM/dd/yyyy HH:mm:ss'))+'</td><td style=" border-right: 1px  solid #dce6f2; border-bottom: 1px  solid #dce6f2; padding-left: 5px;">'+String.valueOf(propObj.EndDate__c.format('MM/dd/yyyy HH:mm:ss'))+ '</td><td style="padding-left: 5px; border-right: 1px  solid #dce6f2; border-bottom: 1px  solid #dce6f2;">'+propObj.Description__c +'</td></td>';
						str += '</table>';
						str += '<br/><br/>';
						
						//***********sandbox link**********
						
						//str += '<a href ="https://cs14.salesforce.com/secur/login_portal.jsp?orgId=00Dc0000001JUC6&portalId=060E0000000PkCG&startURL=%2Fvisualforce%2Fsession%3Furl%3Dhttps%253A%252F%252Fc.cs14.visual.force.com%252Fapex%252FRescheduleEvent?propRecordId='+propObj.id+'" style=" margin-right: 10px; cursor: hand; cursor: pointer;  font-weight: bold; font-size: 12px; width:100px; height:20px; padding:3px 10px 3px 10px; text-align:center; border:1px solid #e8edf1; -moz-border-radius: 4px; -webkit-border-radius:4px; -khtml-border-radius: 4px; border-radius:4px; color:#fff; background:#2897EC url({!$Resource.Tabmenubg}) left top repeat-x; -moz-box-shadow: 0px 0px 21px #4d4d4d; -webkit-box-shadow: 0px 0px 2px #4d4d4d; box-shadow: 0px 0px 2px #4d4d4d; ">Request Reschedule</a>';
						//str += '<a href="http://theforcetest.ispydev.cs14.force.com/eventAcceptPage?propRecordId='+propObj.id+'" style=" cursor: hand; cursor: pointer;  font-weight: bold; font-size: 12px; width:100px; height:20px; padding:3px 10px 3px 10px; text-align:center; border:1px solid #e8edf1; -moz-border-radius: 4px; -webkit-border-radius:4px; -khtml-border-radius: 4px; border-radius:4px; color:#fff; background:#2897EC url({!$Resource.Tabmenubg}) left top repeat-x; -moz-box-shadow: 0px 0px 21px #4d4d4d; -webkit-box-shadow: 0px 0px 2px #4d4d4d; box-shadow: 0px 0px 2px #4d4d4d; ">Accept</a>';
						
						// ****************produciton link*************
						
						str += '<a href ="https://na9.salesforce.com/secur/login_portal.jsp?orgId=00DE0000000Y8hr&portalId=060E0000000PkCG&startURL=%2Fvisualforce%2Fsession%3Furl%3Dhttps%253A%252F%252Fc.na9.visual.force.com%252Fapex%252FRescheduleEvent?propRecordId='+propObj.id+'" style=" margin-right: 10px; cursor: hand; cursor: pointer;  font-weight: bold; font-size: 12px; width:100px; height:20px; padding:3px 10px 3px 10px; text-align:center; border:1px solid #e8edf1; -moz-border-radius: 4px; -webkit-border-radius:4px; -khtml-border-radius: 4px; border-radius:4px; color:#fff; background:#2897EC url({!$Resource.Tabmenubg}) left top repeat-x; -moz-box-shadow: 0px 0px 21px #4d4d4d; -webkit-box-shadow: 0px 0px 2px #4d4d4d; box-shadow: 0px 0px 2px #4d4d4d; ">Request Reschedule</a>';
						str += '<a href="https://theforce.secure.force.com/eventAcceptPage?propRecordId='+propObj.id+'" style=" cursor: hand; cursor: pointer;  font-weight: bold; font-size: 12px; width:100px; height:20px; padding:3px 10px 3px 10px; text-align:center; border:1px solid #e8edf1; -moz-border-radius: 4px; -webkit-border-radius:4px; -khtml-border-radius: 4px; border-radius:4px; color:#fff; background:#2897EC url({!$Resource.Tabmenubg}) left top repeat-x; -moz-box-shadow: 0px 0px 21px #4d4d4d; -webkit-box-shadow: 0px 0px 2px #4d4d4d; box-shadow: 0px 0px 2px #4d4d4d; ">Accept</a>';
						
						str += '<br/><br/><br/>';
						subject = 'Please accept or reschedule your '+propObj.Type__c;
					}			
				}else{
					for(Event ev : eveList){
						if(propObj.Eventid__c == ev.id){
							if(ev.Owner.Email != null) {
								mailIds.add(ev.Owner.Email);
								//mailIds.add('ispytesting1@gmail.com');
								strelse += '<tr style="border-right: 1px  solid #dce6f2; border-bottom: 1px  solid #dce6f2;"><td style=" border-left: 1px  solid #dce6f2; padding-left: 5px;border-right: 1px  solid #dce6f2; border-bottom: 1px  solid #dce6f2;">'+propObj.Reschedule_reason__c+'</td><td style=" border-right: 1px  solid #dce6f2; border-bottom: 1px  solid #dce6f2; padding-left: 5px;">'+String.valueOf(propObj.StartDateTime__c.format('MM/dd/yyyy HH:mm:ss'))+ '</td><td style="padding-left: 5px; border-right: 1px  solid #dce6f2; border-bottom: 1px  solid #dce6f2;">'+String.valueOf(propObj.Proposed_New_Date__c.format('MM/dd/yyyy HH:mm:ss'))+'</td></td></tr>';
								
								refId = ''+propObj.refId__c+'';
								subject = 'Please accept or reschedule your visit';
							}
						}
					}
				}
			}
			if(strelse !=  null && strelse != ''){
			strelse += '</table>';
			strelse += '<br/><br/>';
			
			// **********sandbox link ****************
		//	strelse += '<a href ="https://cs14.salesforce.com/secur/login_portal.jsp?orgId=00Dc0000001JUC6&portalId=060E0000000PkCG&startURL=%2Fvisualforce%2Fsession%3Furl%3Dhttps%253A%252F%252Fc.cs14.visual.force.com%252Fapex%252FRescheduleEvent?refId='+refId+'" style=" margin-right: 10px; cursor: hand; cursor: pointer;  font-weight: bold; font-size: 12px; width:100px; height:20px; padding:3px 10px 3px 10px; text-align:center; border:1px solid #e8edf1; -moz-border-radius: 4px; -webkit-border-radius:4px; -khtml-border-radius: 4px; border-radius:4px; color:#fff; background:#2897EC url({!$Resource.Tabmenubg}) left top repeat-x; -moz-box-shadow: 0px 0px 21px #4d4d4d; -webkit-box-shadow: 0px 0px 2px #4d4d4d; box-shadow: 0px 0px 2px #4d4d4d; ">Request Reschedule</a>';
		//	strelse += '<a href="http://theforcetest.ispydev.cs14.force.com/eventAcceptPage?refId='+refId+'" style=" cursor: hand; cursor: pointer;  font-weight: bold; font-size: 12px; width:100px; height:20px; padding:3px 10px 3px 10px; text-align:center; border:1px solid #e8edf1; -moz-border-radius: 4px; -webkit-border-radius:4px; -khtml-border-radius: 4px; border-radius:4px; color:#fff; background:#2897EC url({!$Resource.Tabmenubg}) left top repeat-x; -moz-box-shadow: 0px 0px 21px #4d4d4d; -webkit-box-shadow: 0px 0px 2px #4d4d4d; box-shadow: 0px 0px 2px #4d4d4d; ">Accept</a>';
			
			// ****************produciton link*************
			
			strelse += '<a href ="https://na9.salesforce.com/secur/login_portal.jsp?orgId=00DE0000000Y8hr&portalId=060E0000000PkCG&portalId=060E0000000PkCG&startURL=%2Fvisualforce%2Fsession%3Furl%3Dhttps%253A%252F%252Fc.na9.visual.force.com%252Fapex%252FRescheduleEvent?refId='+refId+'" style=" margin-right: 10px;  cursor: hand; cursor: pointer;  font-weight: bold; font-size: 12px; width:100px; height:20px; padding:3px 10px 3px 10px; text-align:center; border:1px solid #e8edf1; -moz-border-radius: 4px; -webkit-border-radius:4px; -khtml-border-radius: 4px; border-radius:4px; color:#fff; background:#2897EC url({!$Resource.Tabmenubg}) left top repeat-x; -moz-box-shadow: 0px 0px 21px #4d4d4d; -webkit-box-shadow: 0px 0px 2px #4d4d4d; box-shadow: 0px 0px 2px #4d4d4d; ">Request Reschedule</a>';
			strelse += '<a href="https://theforce.secure.force.com/eventAcceptPage?refId='+refId+'" style=" cursor: hand; cursor: pointer;  font-weight: bold; font-size: 12px; width:100px; height:20px; padding:3px 10px 3px 10px; text-align:center; border:1px solid #e8edf1; -moz-border-radius: 4px; -webkit-border-radius:4px; -khtml-border-radius: 4px; border-radius:4px; color:#fff; background:#2897EC url({!$Resource.Tabmenubg}) left top repeat-x; -moz-box-shadow: 0px 0px 21px #4d4d4d; -webkit-box-shadow: 0px 0px 2px #4d4d4d; box-shadow: 0px 0px 2px #4d4d4d; ">Accept</a>';
			
			strelse += '<br/><br/><br/>';
			str += temp+ '' +strelse;
		}
		OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = 'ispytest1@gmail.com '];
		mail.setToAddresses(mailIds);
		if( owea.size() > 0 ) {
 		   mail.setOrgWideEmailAddressId(owea.get(0).Id);
		}
	    mail.setHtmlBody(str);
	    mail.setSubject(subject);
	    system.debug('---str-------'+str);    
		emails.add(mail);
		if(emails.size() > 0){ 
			if(!Test.isRunningTest()){
				Messaging.sendEmail(emails);
				//create email logs
				List<Email_Logs__c> lstEmailLogs = new List<Email_Logs__c>();
				for(Messaging.Singleemailmessage sEmail : emails) {
					//build string for email Address
					String emailIdString = '';
					for(String emailStr : sEmail.getToAddresses()) {
						emailIdString+= emailStr+',';
					}
					if(emailIdString != '') {
						emailIdString = emailIdString.substring(0, (emailIdString.length()-1));
					}
					
					/*Email_Logs__c emailLog = new Email_Logs__c();
					emailLog.Class_Name__c = 'ProposedReschedulingAfterInsert.trigger';
					emailLog.Email_Subject__c = sEmail.getSubject();
					emailLog.Recipient__c = emailIdString;
					emailLog.Remaining_Email_Invocation__c = (Limits.getLimitEmailInvocations() - Limits.getEmailInvocations())+' remaining out of total' +Limits.getLimitEmailInvocations();
					emailLog.Sender__c = Userinfo.getUserId();*/
					lstEmailLogs.add(EmailLogsManager.createEmailLog('ProposedReschedulingAfterInsert.trigger', sEmail.getSubject(), emailIdString));
				}
				
				//insert email log's records
				if(!lstEmailLogs.isEmpty()) {
					insert lstEmailLogs;
				}   
			}
		}
	}
	
	if(Trigger.isUpdate){
		String subject1 = '';
		List<Event> eveListupdate = [Select e.WhatId,e.OwnerId,e.Owner.Username, e.Owner.Email, e.Subject ,e.Reschedule_reason__c,e.StartDateTime ,e.Id, e.EndDateTime, e.DurationInMinutes, e.Description, e.ActivityDateTime, e.ActivityDate From Event e ];
		Set<Event> evList = new Set<Event>();
		
		for(Proposed_Rescheduling__c propObj : propRechList){
			system.debug('-------propRechList-----'+propRechList.size());
			for(Event evn : eveListupdate){
				if(evn.id == propObj.EventId__c ){
					evn.StartDateTime = propObj.Proposed_New_Date__c;
					evn.ActivityDateTime = propObj.Proposed_New_Date__c; 
					evn.WhatId = propObj.PatientId__c;
					evn.status__c ='Confirmed';
					evn.EndDateTime = null;
					evn.DurationInMinutes = Integer.valueOf(propObj.DurationInMinutes__c);
					evList.add(evn);
				}
			}
		}
		List<Event> evenList = new List<Event>();
		for(Event ev : evList){
			evenList.add(ev);
		} 
		update evenList;
		
		set<id> patientId = new Set<id>();
        for(Event ev : evenList){
        	patientId.add(ev.WhatId);
		}
		String strupdate = '';
		set<id> userId = new Set<id>();
        List<Patient_Custom__Share> patienShareing = [Select p.Parent.Last_Name__c, p.Parent.First_Name__c, p.UserOrGroupId, p.RowCause, p.ParentId, p.LastModifiedDate, p.LastModifiedById, p.IsDeleted, p.Id, p.AccessLevel From Patient_Custom__Share p where ParentId IN: patientId];
        
        for(Patient_Custom__Share patiens : patienShareing){
        	userId.add(patiens.UserOrGroupId);
        	
            strupdate = '<span style="font-weight:bold"> '+patiens.Parent.Last_Name__c+ ' ' + patiens.Parent.First_Name__c+  '  has accepted reschedule visit</span><br/><br/></br>';
            subject1 = ' '+patiens.Parent.Last_Name__c+ 'has accepted reschedule visit';
		}
        strupdate += '<table cellpadding="1" cellspacing="1"; width="100%">';
        strupdate += '<tr style="border-right: 1px  solid #dce6f2; border-left: 1px  solid #dce6f2; border-bottom: 1px  solid #dce6f2; font-weight: bold; font-size: 12px; background-color: #2897EC; height: 20px; width: 50px; vertical-align: middle; border: none;"><td style="color: white; padding-left: 5px; width: 5%;">Purpose</td><td style="color: white; padding-left: 5px; width: 5%;">Current Schedule</td><td style="color: white; padding-left: 5px; width: 5%;">Proposed Schedule</td></tr>';
        
		Set<Id> userGroupId = new Set<id>();
        List<Group> groupId1 = [Select g.Type, g.SystemModstamp, g.RelatedId, g.OwnerId, g.Name, g.LastModifiedDate, g.LastModifiedById, g.Id, g.Email, g.DoesSendEmailToMembers, g.DoesIncludeBosses, g.CreatedDate, g.CreatedById, (Select Id, GroupId, UserOrGroupId, SystemModstamp From GroupMembers) From Group g where id IN:userId];
        for(Group gr : groupId1){
        	for (GroupMember gm : gr.groupMembers) {
            	userGroupId.add(gm.userOrGroupId);    
			}
            List<User> userList = [Select u.Patient_Id__c, u.Id, u.Email From User u where id IN:userGroupId];
            	for(User us:  userList){
            		system.debug('-----us---'+us);
                	//mailIds.add(us.Email);
                	system.debug('----us.Email--'+us.Email);
                	mailIds.add('patelb@opallios.com');
                	//mailIds.add('thumarmitul@gmail.com');
                } 
            }
            for(Proposed_Rescheduling__c propObj : propRechList){
                strupdate += '<tr style="border-right: 1px  solid #dce6f2; border-bottom: 1px  solid #dce6f2;"><td style=" border-left: 1px  solid #dce6f2; padding-left: 5px;border-right: 1px  solid #dce6f2; border-bottom: 1px  solid #dce6f2;">'+propObj.Reschedule_reason__c+'</td><td style=" border-right: 1px  solid #dce6f2; border-bottom: 1px  solid #dce6f2; padding-left: 5px;">'+String.ValueOf(propObj.StartDateTime__c.format('MM/dd/yyyy HH:mm:ss'))+  '</td><td style="padding-left: 5px; border-right: 1px  solid #dce6f2; border-bottom: 1px  solid #dce6f2;">'+String.ValueOf(propObj.Proposed_New_Date__c.format('MM/dd/yyyy HH:mm:ss'))+'</td></td></tr>';
			}
			OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = 'ispytest1@gmail.com'];
            strupdate += '</table>';
            mail.setToAddresses(mailIds);
            if ( owea.size() > 0 ) {
 			   mail.setOrgWideEmailAddressId(owea.get(0).Id);
			}
            mail.setHtmlBody(strupdate);
            mail.setSubject(subject1);
            emails.add(mail);
            if(emails.size() > 0){
            	if(!Test.isRunningTest()){
            		Messaging.sendEmail(emails);
            		//create email logs
					List<Email_Logs__c> lstEmailLogs = new List<Email_Logs__c>();
					for(Messaging.Singleemailmessage sEmail : emails) {
						//build string for email Address
						String emailIdString = '';
						for(String emailStr : sEmail.getToAddresses()) {
							emailIdString+= emailStr+',';
						}
						if(emailIdString != '') {
							emailIdString = emailIdString.substring(0, (emailIdString.length()-1));
						}
						
						/*Email_Logs__c emailLog = new Email_Logs__c();
						emailLog.Class_Name__c = 'ProposedReschedulingAfterInsert.trigger';
						emailLog.Email_Subject__c = sEmail.getSubject();
						emailLog.Recipient__c = emailIdString;
						emailLog.Remaining_Email_Invocation__c = (Limits.getLimitEmailInvocations() - Limits.getEmailInvocations())+' remaining out of total' +Limits.getLimitEmailInvocations();
						emailLog.Sender__c = Userinfo.getUserId();*/
						lstEmailLogs.add(EmailLogsManager.createEmailLog('ProposedReschedulingAfterInsert.cls', sEmail.getSubject(), emailIdString));
					}
					
					//insert email log's records
					if(!lstEmailLogs.isEmpty()) {
						insert lstEmailLogs;
					}     
            	}   
			}
			delete propRechList;
	}
}