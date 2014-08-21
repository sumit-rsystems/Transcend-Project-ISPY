public with sharing class EmailLogsManager {
	public EmailLogsManager() {
		
	}
	
	public static Email_Logs__c createEmailLog(String className, String emailSubject, String emailIdString) {
		Email_Logs__c emailLog = new Email_Logs__c();
		emailLog.Class_Name__c = className;
		emailLog.Email_Subject__c = emailSubject;
		emailLog.Recipient__c = emailIdString;
		emailLog.Remaining_Email_Invocation__c = (Limits.getLimitEmailInvocations() - Limits.getEmailInvocations())+' remaining out of total' +Limits.getLimitEmailInvocations();
		emailLog.Sender__c = Userinfo.getUserId();
		return emailLog;
	}
	
	@future
	public static void createEmailLogFutureCall(String className, String emailSubject, String emailIdString) {
		Email_Logs__c emailLog = new Email_Logs__c();
		emailLog.Class_Name__c = className;
		emailLog.Email_Subject__c = emailSubject;
		emailLog.Recipient__c = emailIdString;
		emailLog.Remaining_Email_Invocation__c = (Limits.getLimitEmailInvocations() - Limits.getEmailInvocations())+' remaining out of total' +Limits.getLimitEmailInvocations();
		emailLog.Sender__c = Userinfo.getUserId();
		insert emailLog;
	}
}