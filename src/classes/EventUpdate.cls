global class EventUpdate implements Messaging.InboundEmailHandler {
  global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.InboundEnvelope envelope) {
 
    Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();
    
    Boolean acceptedReschedule = email.plainTextBody.startsWith('Accept');
    Boolean acceptedReschedule1 = email.plainTextBody.startsWith('Reject');  
    
    String emailid = email.fromAddress; 
    String s2 = email.subject;
    String subjectId = s2.removeStart('Re: Sandbox: ');
    
    List<Event> updateEventList = new List<Event>();
    List<Event> eventList = [Select e.Reschedule_reason__c,e.Owner.Username,e.WhatId, e.Minutes__c,e.Hours__c, e.OwnerId, e.Subject ,e.StartDateTime ,e.Id, e.EndDateTime, e.DurationInMinutes, e.Description, e.ActivityDateTime, e.ActivityDate From Event e ];
    Map<Id,string> eventMap = new Map<Id,string>(); 
    List<Event> eventList2 = new List<Event>();
    if(!eventList.isEmpty()){  
      for(Event ev : eventList){
        eventMap.put(ev.id,String.valueOf(ev.StartDateTime));  
      }
    }
    System.debug('eventMap--------'+eventMap); 
    List<Proposed_Rescheduling__c> proList = [Select p.Reschedule_reason__c,p.Proposed_New_Date__c, p.PatientId__c, p.OwnerId, p.Id, p.Eventid__c, p.refId__c From Proposed_Rescheduling__c p where refId__c =: +subjectId];
   
    if(acceptedReschedule){
      Integer totalminutes = 0;
        List<Proposed_Rescheduling__c> propList = new List<Proposed_Rescheduling__c>(); 
        for(Event ev : eventList){
            for(Proposed_Rescheduling__c pro : proList){
                if(ev.id == pro.Eventid__c){
                    if(ev.OwnerId == pro.OwnerId){
                      if(ev.Minutes__c == null && ev.Hours__c == null ){
                        ev.Minutes__c = 05;
                        ev.Hours__c = 00;
                         totalminutes = Integer.valueOf((ev.Hours__c * 60 ) + ev.Minutes__c) ;
                      }else{
                          totalminutes = Integer.valueOf((ev.Hours__c * 60 ) + ev.Minutes__c) ;
                      }
                        ev.ActivityDateTime = pro.Proposed_New_Date__c;
                        ev.Reschedule_reason__c = pro.Reschedule_reason__c;
                        ev.StartDateTime = pro.Proposed_New_Date__c;
                        ev.EndDateTime = null;
                        ev.DurationInMinutes = totalminutes;
                        ev.WhatId = pro.PatientId__c;
                        
                        propList.add(pro);
                        system.debug('--------propList-------'+propList);
                        updateEventList.add(ev);
                    }
                }
            }   
        }  
        set<id> patientId = new Set<id>();
        for(Event ev : updateEventList){
          patientId.add(ev.WhatId);
    }
    String str = '';
    set<id> userId = new Set<id>();
        List<Patient_Custom__Share> patienShareing = [Select p.Parent.Last_Name__c, p.Parent.First_Name__c, p.UserOrGroupId, p.RowCause, p.ParentId, p.LastModifiedDate, p.LastModifiedById, p.IsDeleted, p.Id, p.AccessLevel From Patient_Custom__Share p where ParentId IN: patientId];
        for(Patient_Custom__Share patiens : patienShareing){
          userId.add(patiens.UserOrGroupId);
            str = '<span style="font-weight:bold"> '+patiens.Parent.Last_Name__c+ ' ' + patiens.Parent.First_Name__c+  '  has accepted reschedule event </span><br/><br/></br>';
    }
    String subject = '';
        str += '<table cellpadding="1" cellspacing="1" border="1" id="tblReport" width="100%" >';
        str += '<tr style="cursor: pointer; font-weight: bold; font-size: 12px; background-color: #2897EC; height: 20px; width: 50px; vertical-align: middle; border: none;"><td style="color: white; padding-left: 5px; width: 5%;">Purpose</td><td style="color: white; padding-left: 5px; width: 5%;">Current Schedule</td><td style="color: white; padding-left: 5px; width: 5%;">Proposed Schedule</td></tr>';
        List<Messaging.Singleemailmessage> emails = new List<Messaging.Singleemailmessage>();
    List<String> mailIds = new List<string>();
        Messaging.Singleemailmessage mail = new Messaging.Singleemailmessage(); 
    Set<Id> userGroupId = new Set<id>();
        List<Group> groupId1 = [Select g.Type, g.SystemModstamp, g.RelatedId, g.OwnerId, g.Name, g.LastModifiedDate, g.LastModifiedById, g.Id, g.Email, g.DoesSendEmailToMembers, g.DoesIncludeBosses, g.CreatedDate, g.CreatedById, (Select Id, GroupId, UserOrGroupId, SystemModstamp From GroupMembers) From Group g where id IN:userId];
        for(Group gr : groupId1){
          for (GroupMember gm : gr.groupMembers) {          
              userGroupId.add(gm.userOrGroupId);    
      }
            List<User> userList = [Select u.Patient_Id__c, u.Id, u.Email From User u where id IN:userGroupId];
              for(User us:  userList){
                  //mailIds.add(us.Email);
                  mailIds.add('asc.sfdc.tester@gmail.com');
                } 
            }
            for(Event ev : eventList){
              for(Proposed_Rescheduling__c pro : proList){
                  if(ev.id == pro.Eventid__c){
                        system.debug('-----------eventMap.get(ev)---------'+eventMap.get(ev.id));
                        str += '<tr><td style="padding-left: 5px;">'+pro.Reschedule_reason__c +'</td><td style="padding-left: 5px;">'+eventMap.get(ev.id) + '</td><td style="padding-left: 5px;">'+pro.Proposed_New_Date__c + '</td></tr>';
          }
        }
      }
            str += '</table>';
            mail.setToAddresses(mailIds);
            mail.setHtmlBody(str);
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
            emailIdString = emailIdString.substring(0, (emailIdString.length()-1));
            
            /*Email_Logs__c emailLog = new Email_Logs__c();
            emailLog.Class_Name__c = 'EventUpdate.cls';
            emailLog.Email_Subject__c = sEmail.getSubject();
            emailLog.Recipient__c = emailIdString;
            emailLog.Remaining_Email_Invocation__c = (Limits.getLimitEmailInvocations() - Limits.getEmailInvocations())+' remaining out of total' +Limits.getLimitEmailInvocations();
            emailLog.Sender__c = Userinfo.getUserId();*/
            lstEmailLogs.add(EmailLogsManager.createEmailLog('EventUpdate.cls', sEmail.getSubject(), emailIdString));
          }
          
          //insert email log's records
          if(!lstEmailLogs.isEmpty()) {
            insert lstEmailLogs;
          }
              } 
      }
    update updateEventList;
        delete propList;
            system.debug('--------propList-------'+propList.size());
      }else{
          List<Event> updateEventList1 = new List<Event>();
          List<Proposed_Rescheduling__c> propList1 = new List<Proposed_Rescheduling__c>(); 
          for(Event ev : eventList){
              for(Proposed_Rescheduling__c pro : proList){
                  if(ev.id == pro.Eventid__c){
                      propList1.add(pro);
                      updateEventList1.add(ev);
                  }
              }
          }
        
          String str = '';
          set<id> patientId = new Set<id>();
          for(Event ev : updateEventList1){
              patientId.add(ev.WhatId);
          }
          set<id> userId = new Set<id>();
          List<Patient_Custom__Share> patienShareing = [Select p.Parent.Last_Name__c, p.Parent.First_Name__c,p.UserOrGroupId, p.RowCause, p.ParentId, p.LastModifiedDate, p.LastModifiedById, p.IsDeleted, p.Id, p.AccessLevel From Patient_Custom__Share p where ParentId IN: patientId];
          for(Patient_Custom__Share patiens : patienShareing){
              userId.add(patiens.UserOrGroupId);
              str = '<span style="font-weight:bold"> '+patiens.Parent.Last_Name__c+ ' ' + patiens.Parent.First_Name__c+  '  has rejected reschedule event </span><br/><br/></br>';
          }
          String subject = '';
          str += '<table cellpadding="1" cellspacing="1" border="1" id="tblReport" width="100%" >';
          str += '<tr style="cursor: pointer; font-weight: bold; font-size: 12px; background-color: #2897EC; height: 20px; width: 50px; vertical-align: middle; border: none;"><td style="color: white; padding-left: 5px; width: 5%;">Purpose</td><td style="color: white; padding-left: 5px; width: 5%;">Current Schedule</td><td style="color: white; padding-left: 5px; width: 5%;">Proposed Schedule</td></tr>';
          List<Messaging.Singleemailmessage> emails = new List<Messaging.Singleemailmessage>();
              List<String> mailIds = new List<string>();
              Messaging.Singleemailmessage mail = new Messaging.Singleemailmessage(); 
              
          Set<Id> userGroupId = new Set<id>();
          List<Group> groupId1 = [Select g.Type, g.SystemModstamp, g.RelatedId, g.OwnerId, g.Name, g.LastModifiedDate, g.LastModifiedById, g.Id, g.Email, g.DoesSendEmailToMembers, g.DoesIncludeBosses, g.CreatedDate, g.CreatedById, (Select Id, GroupId, UserOrGroupId, SystemModstamp From GroupMembers) From Group g where id IN:userId];
          for(Group gr : groupId1){
              for (GroupMember gm : gr.groupMembers) {        
                 userGroupId.add(gm.userOrGroupId);    
               }
              List<User> userList = [Select u.Patient_Id__c, u.Id, u.Email From User u where id IN:userGroupId];
              for(User us:  userList){
                //mailIds.add(us.Email);
                  mailIds.add('asc.sfdc.tester@gmail.com');
                  system.debug('-----------mailIds-------'+mailIds);  
              }    
      }
          for(Event ev : eventList){
              for(Proposed_Rescheduling__c pro : proList){
                  if(ev.id == pro.Eventid__c){
                        system.debug('-----------eventMap.get(ev)---------'+eventMap.get(ev.id));
                        str += '<tr><td style="padding-left: 5px;">'+ev.Description +'</td><td style="padding-left: 5px;">'+eventMap.get(ev.id) + '</td><td style="padding-left: 5px;">'+pro.Proposed_New_Date__c + '</td></tr>';
          }
        }
      }  
          str += '</table>';
          mail.setToAddresses(mailIds);
          mail.setHtmlBody(str);
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
            emailLog.Class_Name__c = 'EventUpdate.cls';
            emailLog.Email_Subject__c = sEmail.getSubject();
            emailLog.Recipient__c = emailIdString;
            emailLog.Remaining_Email_Invocation__c = (Limits.getLimitEmailInvocations() - Limits.getEmailInvocations())+' remaining out of total' +Limits.getLimitEmailInvocations();
            emailLog.Sender__c = Userinfo.getUserId();*/
            lstEmailLogs.add(EmailLogsManager.createEmailLog('EventUpdate.cls', sEmail.getSubject(), emailIdString));
          }
          
          //insert email log's records
          if(!lstEmailLogs.isEmpty()) {
            insert lstEmailLogs;
          }  
            }   
      }
      delete propList1;
    }
    return result;
  }
}