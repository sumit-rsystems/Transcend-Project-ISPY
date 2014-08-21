public with sharing class EmailNotification {
    
    public static void sendEmail(String subjectId, String trialId, String siteId, String crfName, String dateAndTime, String createdBy, String errorCode, String errorDescription){
        
        
        String htmlBody='<body>'+
                        '<table><tr><td>Subject ID</td><td>'+subjectId+'</td></tr>'+
                        '<tr><td>Trial ID</td><td>'+trialId+'</td></tr>'+
                        '<tr><td>Site ID</td><td>'+siteId+'</td></tr>'+
                        '<tr><td>CRF Name</td><td>'+crfName+'</td></tr>'+
                        '<tr><td>Date/Time</td><td>'+dateAndTime+'</td></tr>'+
                        '<tr><td>CreatedBy</td><td>'+createdBy+'</td></tr>'+
                        '<tr><td>Error Code</td><td>'+errorCode+'</td></tr>'+
                        '<tr><td>Error Description</td><td>'+errorDescription+'</td></tr>'+
                        '</table></body>';
        
        
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        
        List<Notification_Email__c> emailList = Notification_Email__c.getall().values();
        if(Test.isRunningTest()) {
        	String[] toAddresses = new String[1];
        	toAddresses[0] = 'ispy2support@opallios.com';
        	mail.setToAddresses(toAddresses);
        } else {
	        String[] toAddresses = new String[emailList.size()];
	        for(Integer i=0; i<emailList.size();i++){
	            Notification_Email__c email = emailList[i];
	            toAddresses[i]=email.Email__c;
	        }
	        mail.setToAddresses(toAddresses);
        }
        
        mail.setReplyTo('ispy2support@opallios.com');
        mail.setSenderDisplayName('ispy2support@opallios.com');
        mail.setSubject('Transcend Integration Error Notification');
        mail.setHtmlBody(htmlBody);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        
        //create email logs
		//build string for email Address
		String emailIdString = '';
		for(String email : mail.getToAddresses()) {
			emailIdString+= email+',';
		}
		if(emailIdString != '') {
			emailIdString = emailIdString.substring(0, (emailIdString.length()-1));
		}
		
		Email_Logs__c emailLog = EmailLogsManager.createEmailLog('EmailNotification.cls', mail.getSubject(), emailIdString);
		insert emailLog;
    }

}