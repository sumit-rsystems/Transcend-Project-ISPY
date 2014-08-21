trigger UserAfterInsertTrigger on User (after insert, after update) {
    List<User> lstUser = [Select u.Username, u.SecurityCode__c, u.ProfileId, u.Patient_Id__c, u.Name, u.LastName, u.IsActive, u.Id, u.FirstName, u.Email From User u where id IN : Trigger.newMap.keySet()];
    Set<String> patitnId = new Set<String>();
    for(User us : lstUser){
    	patitnId.add(us.Patient_Id__c);
    	system.debug('--------us-----------'+us.Username);
    }
    List<Patient_Custom__c> patientLst = [Select p.isUserStatus__c ,p.Email__c, p.Last_Name__c, p.Institution__c,  p.Id, p.First_Name__c From Patient_Custom__c p where Id IN :patitnId];
    system.debug('----patientLst---'+patientLst.size());
    List<Patient_Custom__c> patientLstupdate = new List<Patient_Custom__c>(); 
    if(Trigger.isInsert){
	    for(Patient_Custom__c pat : patientLst){
	    	pat.isUserStatus__c = '2';
	    	patientLstupdate.add(pat);
	    	system.debug('-----pat.isUserStatus__c---'+pat.isUserStatus__c);
	    }
	    system.debug('----patientLstupdate---'+patientLstupdate);
	    update patientLstupdate;
	    system.debug('----patientLstupdate---'+patientLstupdate);
    }
    system.debug('-----patientLstupdate--'+patientLstupdate);
    
    for(User user : lstUser) {  
        system.debug('==user.Id===='+user.Id );
        boolean profileMatches = false;
        User oldUser = null;
        if(Trigger.isUpdate) { 
            oldUser = Trigger.oldMap.get(user.Id);
        }
        system.debug('===oldUser.SecurityCode__c======'+oldUser);
        system.debug('==ouser.SecurityCode__c======'+user);
        if(Trigger.isUpdate && oldUser.SecurityCode__c == user.SecurityCode__c) continue;
        Messaging.Singleemailmessage mail = new Messaging.Singleemailmessage();
        List<String> lstEmailId = new List<String>();
        //lstEmailId.add('barangev@opallios.com');
        //lstEmailId.add('bansalc@opallios.com');
        //lstEmailId.add('kumark@opallios.com');
        //lstEmailId.add('dadhwals@opallios.com');
        lstEmailId.add(user.Email);
        mail.setToAddresses(lstEmailId);
        mail.setReplyTo('patelb@opallios.com');
        //mail.setBccSender(true);
        mail.setSenderDisplayName('support@opallios.com');
        mail.setSubject('opallios.com secure code');
        mail.setPlainTextBody('');
        blob blobKey = Encodingutil.base64Decode(user.SecurityCode__c);
        String securityCode = EncodingUtil.convertToHex(blobKey);
        securityCode = securityCode.substring(0,8);
        mail.setHtmlBody('Dear '+user.FirstName+',<br />Your Secure Code has been created by your administrator.<br/ >UserName : '+user.Username+'<br />Secure Code : '+securityCode);
        system.debug('__Mail__'+mail);
        Messaging.sendEmail(new Messaging.Singleemailmessage[] { mail });
        
        //create email logs
		//build string for email Address
		String emailIdString = '';
		for(String emailStr : mail.getToAddresses()) {
			emailIdString+= emailStr+',';
		}
		if(emailIdString != '') {
			emailIdString = emailIdString.substring(0, (emailIdString.length()-1));
		}
		
		/*Email_Logs__c emailLog = new Email_Logs__c();
		emailLog.Class_Name__c = 'UserAfterInsertTrigger.trigger';
		emailLog.Email_Subject__c = mail.getSubject();
		emailLog.Recipient__c = emailIdString;
		emailLog.Remaining_Email_Invocation__c = (Limits.getLimitEmailInvocations() - Limits.getEmailInvocations())+' remaining out of total' +Limits.getLimitEmailInvocations();
		emailLog.Sender__c = Userinfo.getUserId();
		insert emailLog;*/
		EmailLogsManager.createEmailLogFutureCall('UserAfterInsertTrigger.trigger', mail.getSubject(), emailIdString);
        //break;
    }
}