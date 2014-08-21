public with sharing class eventAcceptClass {
	
	public String propReschId {get;set;}
	public String refId{get;set;}
	
	public eventAcceptClass(){ 
		propReschId = ApexPages.currentPage().getParameters().get('propRecordId');
		refId = ApexPages.currentPage().getParameters().get('refId');
	}
	public Pagereference eventAccept(){
		String subject='';		
		List<Proposed_Rescheduling__c> propRechList = [Select p.studyStaff__c,p.subject__c, p.refId__c, p.WhatId__c, p.Type__c, p.Trial__c, p.SystemModstamp, p.StartDateTime__c, p.Reschedule_reason__c, p.Proposed_New_Date__c, p.PatientId__c, p.Owner.Email, p.OwnerId, p.Name, p.Minutes__c, p.LastModifiedDate, p.LastModifiedById, p.IsDeleted, p.Id, p.Hours__c, p.Eventid__c, p.EndDate__c, p.DurationInMinutes__c, p.Description__c, p.CreatedDate, p.CreatedById From Proposed_Rescheduling__c p where id =: propReschId];
		List<Proposed_Rescheduling__c> propRechListReschu = [Select p.studyStaff__c,p.subject__c, p.refId__c, p.WhatId__c, p.Type__c, p.Trial__c, p.SystemModstamp, p.StartDateTime__c, p.Reschedule_reason__c, p.Proposed_New_Date__c, p.PatientId__c, p.Owner.Email, p.OwnerId, p.Name, p.Minutes__c, p.LastModifiedDate, p.LastModifiedById, p.IsDeleted, p.Id, p.Hours__c, p.Eventid__c, p.EndDate__c, p.DurationInMinutes__c, p.Description__c, p.CreatedDate, p.CreatedById From Proposed_Rescheduling__c p where refId__c =: refId];
		
		List<Event> evntListInset = new List<Event>();		
	    List<Event> eventList = [Select e.Reschedule_reason__c,e.Owner.Username,e.WhatId, e.Minutes__c,e.Hours__c, e.OwnerId, e.Subject ,e.StartDateTime ,e.Id, e.EndDateTime, e.DurationInMinutes, e.Description, e.ActivityDateTime, e.ActivityDate From Event e ];
		if(propRechListReschu.size() > 0){
	    	update propRechListReschu;		
	  		
		}else if(propRechList.size() > 0){
			List<Messaging.Singleemailmessage> emails = new List<Messaging.Singleemailmessage>();
			List<String> mailIds = new List<string>();
			Messaging.Singleemailmessage mail = new Messaging.Singleemailmessage();
			
			for(Proposed_Rescheduling__c pro : propRechList){ 
				Event ev = new Event();
				ev.OwnerId = pro.OwnerId;
				ev.StartDateTime = pro.StartDateTime__c;
				ev.Type = pro.Type__c;
				ev.Trial__c = pro.Trial__c;
				ev.WhatId = pro.WhatId__c;
				ev.DurationInMinutes = Integer.valueOf(pro.DurationInMinutes__c);
				ev.Hours__c = pro.Hours__c;
				ev.Minutes__c = pro.Minutes__c;
				ev.subject__c = pro.subject__c;
				ev.Description = pro.Description__c;
				ev.status__c = 'Confirmed';
				
				evntListInset.add(ev);
				if(pro.studyStaff__c != null && pro.studyStaff__c != ''){
					Event ev1 = new Event();
					ev1.OwnerId = pro.studyStaff__c;
					ev1.StartDateTime = pro.StartDateTime__c;
					ev1.Type = pro.Type__c;
					ev1.Trial__c = pro.Trial__c;
					ev1.WhatId = pro.WhatId__c;
					ev1.DurationInMinutes = Integer.valueOf(pro.DurationInMinutes__c);
					ev1.Hours__c = pro.Hours__c;
					ev1.Minutes__c = pro.Minutes__c;
					ev1.subject__c = pro.subject__c;
					ev1.Description = pro.Description__c;
					ev.status__c = 'Confirmed';
					
					evntListInset.add(ev1);
				}
			}
		insert evntListInset;
		set<id> patientId = new Set<id>();
        for(Event ev : evntListInset){
        	patientId.add(ev.WhatId);
		}
		String strupdate = '';
		set<id> userId = new Set<id>();
        List<Patient_Custom__Share> patienShareing = [Select p.Parent.Last_Name__c, p.Parent.First_Name__c, p.UserOrGroupId, p.RowCause, p.ParentId, p.LastModifiedDate, p.LastModifiedById, p.IsDeleted, p.Id, p.AccessLevel From Patient_Custom__Share p where ParentId IN: patientId];
        for(Patient_Custom__Share patiens : patienShareing){
        	userId.add(patiens.UserOrGroupId);
            strupdate = '<span style="font-weight:bold"> '+patiens.Parent.Last_Name__c+ ' ' + patiens.Parent.First_Name__c+  '  has accepted scheduled visit</span><br/><br/></br>';
            subject = ''+patiens.Parent.Last_Name__c+  ' has accepted scheduled visit';
		}
        strupdate += '<table cellpadding="1" cellspacing="1"  id="tblReport" width="100%" >';
        strupdate += '<tr style="cursor: pointer; font-weight: bold; font-size: 12px; background-color: #2897EC; height: 20px; width: 50px; vertical-align: middle; border: none;"><td style="color: white; padding-left: 5px; width: 5%;">Purpose</td><td style="color: white; padding-left: 5px; width: 5%;">Current Schedule</td></tr>';
		Set<Id> userGroupId = new Set<id>();
        List<Group> groupId1 = [Select g.Type, g.SystemModstamp, g.RelatedId, g.OwnerId, g.Name, g.LastModifiedDate, g.LastModifiedById, g.Id, g.Email, g.DoesSendEmailToMembers, g.DoesIncludeBosses, g.CreatedDate, g.CreatedById, (Select Id, GroupId, UserOrGroupId, SystemModstamp From GroupMembers) From Group g where id IN:userId];
       	 for(Group gr : groupId1){
        	for (GroupMember gm : gr.groupMembers) {          
            	userGroupId.add(gm.userOrGroupId);    
			}
            List<User> userList = [Select u.Patient_Id__c, u.Id, u.Email From User u where id IN:userGroupId];
            	for(User us:  userList){
                	//mailIds.add(us.Email);
                	system.debug('----us.Email----: '+us.Email);
                	mailIds.add('thumarmitul@gmail.com');
                	//mailIds.add('patelb@opallios.com');
                } 
            }
            for(Proposed_Rescheduling__c propObj : propRechList){
                strupdate += '<tr style="border-right: 1px  solid #dce6f2; border-bottom: 1px  solid #dce6f2;"><td style=" border-left: 1px  solid #dce6f2; padding-left: 5px;border-right: 1px  solid #dce6f2; border-bottom: 1px  solid #dce6f2;">'+propObj.subject__c +'</td><td style=" border-left: 1px  solid #dce6f2; padding-left: 5px;border-right: 1px  solid #dce6f2; border-bottom: 1px  solid #dce6f2;">'+String.ValueOf(propObj.StartDateTime__c.format('MM/dd/yyyy HH:mm:ss'))+ '</td></tr>';
			}
            strupdate += '</table>';
            mail.setToAddresses(mailIds);
            mail.setHtmlBody(strupdate);
            mail.setSubject(subject);
            emails.add(mail);
            if(emails.size() > 0){
            	if(!Test.isRunningTest()){
            		Messaging.sendEmail(emails);   
            		//create email logs
					List<Email_Logs__c> lstEmailLogs = new List<Email_Logs__c>();
					for(Messaging.Singleemailmessage sEmail : emails) {
						//build string for email Address
						String emailIdString = '';
						for(String email : sEmail.getToAddresses()) {
							emailIdString+= email+',';
						}
						if(emailIdString != '') {
							emailIdString = emailIdString.substring(0, (emailIdString.length()-1));
						}
						
						/*Email_Logs__c emailLog = new Email_Logs__c();
						emailLog.Class_Name__c = 'eventAcceptClass.cls';
						emailLog.Email_Subject__c = sEmail.getSubject();
						emailLog.Recipient__c = emailIdString;
						emailLog.Remaining_Email_Invocation__c = (Limits.getLimitEmailInvocations() - Limits.getEmailInvocations())+' remaining out of total' +Limits.getLimitEmailInvocations();
						emailLog.Sender__c = Userinfo.getUserId();*/
						lstEmailLogs.add(EmailLogsManager.createEmailLog('eventAcceptClass.cls', sEmail.getSubject(), emailIdString));
					}
					
					//insert email log's records
					if(!lstEmailLogs.isEmpty()) {
						insert lstEmailLogs;
					}
            	}  
			}
		}
		delete propRechList;
		return null;
	}
}