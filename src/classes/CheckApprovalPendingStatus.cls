global class CheckApprovalPendingStatus implements Schedulable {

	//Run on 0th second of every minute
	public static String CRON_EXP = '0 5 * * * ?';
	 
	global void execute(SchedulableContext sc) {
		Map<Id, AE_Detail__c> aeMap = new Map<Id, AE_Detail__c>([Select a.Visit_Date__c, a.Status__c,a.TrialPatient__r.Subject_id__c From AE_Detail__c a where Status__c = 'Not Completed']);
		system.debug('Total AE forms with Not Completed status:'+aeMap.keySet().size());
      	List<ProcessInstance> piList = [Select p.TargetObjectId, p.Status, p.CreatedDate From ProcessInstance p where p.TargetObjectId in :aeMap.keySet() and Status = 'Pending'];
      	system.debug('Total AE records pending in approval process : '+piList.size());
      	String aeMessage = '<br/>AE forms having Not Completed status instead of Approval Pending<br/>';
      	boolean aeFound = false;
      	if(piList.size() != 0) {
      		List<AE_Detail__c> changeStatusList = new List<AE_Detail__c>();
      		for(ProcessInstance pi : piList) {
      			if(aeMap.containsKey(pi.TargetObjectId)) {
      				aeFound = true;
      				aeMessage += aeMap.get(pi.TargetObjectId).TrialPatient__r.Subject_id__c + ' - ' + aeMap.get(pi.TargetObjectId).Status__c + ' - ' + pi.TargetObjectId+'<br/>';
      				system.debug('aeMessage:'+aeMessage);
      				aeMap.get(pi.TargetObjectId).Status__c  = 'Approval Pending';
      				changeStatusList.add(aeMap.get(pi.TargetObjectId));
      			}
      		}
      		if(!changeStatusList.isEmpty()) {
      			update changeStatusList;
      		}
		}
		
		piList.clear();
		
		Map<Id, On_Study_Eligibility_Form__c> oseMap = new Map<Id, On_Study_Eligibility_Form__c>([Select Id, a.Status__c, a.TrialPatient__r.Subject_id__c From On_Study_Eligibility_Form__c a where Status__c = 'Not Completed']);
		system.debug('Total OSE forms with Not Completed status:'+oseMap.keySet().size());
      	piList = [Select p.TargetObjectId, p.Status, p.CreatedDate From ProcessInstance p where p.TargetObjectId in :oseMap.keySet() and Status = 'Pending'];
      	system.debug('Total OSE records pending in approval process : '+piList.size());
      	String oseMessage = '<br/>OSE forms having Not Completed status instead of Approval Pending<br/>';
      	boolean oseFound = false;
      	if(piList.size() != 0) {
      		List<On_Study_Eligibility_Form__c> changeStatusList = new List<On_Study_Eligibility_Form__c>();
      		for(ProcessInstance pi : piList) {
      			if(oseMap.containsKey(pi.TargetObjectId)) {
      				oseFound = true;
      				oseMessage += oseMap.get(pi.TargetObjectId).TrialPatient__r.Subject_id__c + ' - ' + oseMap.get(pi.TargetObjectId).Status__c + ' - ' + pi.TargetObjectId+'<br/>';
      				system.debug('oseMessage:'+oseMessage);
      				oseMap.get(pi.TargetObjectId).Status__c  = 'Approval Pending';
      				changeStatusList.add(oseMap.get(pi.TargetObjectId));
      			}
      		}
      		if(!changeStatusList.isEmpty()) {
      			update changeStatusList;
      		}
		}
		if(aeFound || oseFound) {
			Messaging.Singleemailmessage mail = new Messaging.Singleemailmessage();
	    	mail.setToAddresses(new List<String>{'patelb@opallios.com', 'ddumitru@blueoctave.com', 'zp@opallios.com', 'arorav@opallios.com'});
	    	mail.setReplyTo(Userinfo.getUserEmail());
	    	mail.setSenderDisplayName(Userinfo.getName());
		    mail.setSubject('Approval Request');
			
			mail.setHtmlBody(aeMessage + '<br/>' + oseMessage);
			System.debug('__mail__'+mail);
			Messaging.sendEmail(new Messaging.Singleemailmessage[] { mail });
		}
	}
}