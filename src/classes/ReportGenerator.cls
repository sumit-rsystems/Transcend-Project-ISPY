public with sharing class ReportGenerator {

	@future
	public static void generateTrialSummary(Date asOfDate, Id trialId, Id validRequestId, Id reportRequestId) {
		Valid_Request__c validReq = new Valid_Request__c();
		List<Valid_Request__c> lstValidReq = [select Id, Security_Token__c from Valid_Request__c where Id =:validRequestId];
		if(!lstValidReq.isEmpty()) {
			validReq = lstValidReq[0];
		}
		
	//******************************************For Sandbox******************************* 	
		//system.debug('URL: '+'http://theforcetest.ispydev.cs14.force.com/TrialSummaryReportPDF?trialId='+trialId+'&asOfDate='+asOfDate+'&token='+validReq.Security_Token__c);
		//Pagereference pageRefPDF = new Pagereference('http://theforcetest.ispydev.cs14.force.com/TrialSummaryReportPDF?trialId='+trialId+'&asOfDate='+asOfDate+'&token='+validReq.Security_Token__c);
		//Pagereference pageRefCSV = new Pagereference('http://theforcetest.ispydev.cs14.force.com/TrialSummaryReportCSV?trialId='+trialId+'&asOfDate='+asOfDate+'&token='+validReq.Security_Token__c);
		//Pagereference pageRefHTML = new Pagereference('http://theforcetest.ispydev.cs14.force.com/TrialSummaryReportHTML?trialId='+trialId+'&asOfDate='+asOfDate+'&token='+validReq.Security_Token__c);
		
	//******************************************For Production******************************* 	
		system.debug('URL: '+'http://theforce.secure.force.com/TrialSummaryReportPDF?trialId='+trialId+'&asOfDate='+asOfDate+'&token='+validReq.Security_Token__c);
		Pagereference pageRefPDF = new Pagereference('http://theforce.secure.force.com/TrialSummaryReportPDF?trialId='+trialId+'&asOfDate='+asOfDate+'&token='+validReq.Security_Token__c);
		Pagereference pageRefCSV = new Pagereference('http://theforce.secure.force.com/TrialSummaryReportCSV?trialId='+trialId+'&asOfDate='+asOfDate+'&token='+validReq.Security_Token__c);
		Pagereference pageRefHTML = new Pagereference('http://theforce.secure.force.com/TrialSummaryReportHTML?trialId='+trialId+'&asOfDate='+asOfDate+'&token='+validReq.Security_Token__c);
		
		Blob htmlContent = null;
		Blob pdfContent = null;
		Blob csvContent = null;
		if(!Test.isRunningTest()) {
			htmlContent = pageRefHTML.getContent();
			pdfContent = pageRefPDF.getContent();
			csvContent = pageRefCSV.getContent();
			system.debug('__pageRef.getContentAsPDF()__'+pageRefPDF.getContent());
		} else {
			htmlContent = Blob.valueOf('sd');
			pdfContent = Blob.valueOf('sd');
			csvContent = Blob.valueOf('sd');
		}	
		List<Attachment> lstInsertAttachment = new List<Attachment>();
	//for html attachment	
		Attachment attHTML = new Attachment();
		attHTML.Body = htmlContent;
		attHTML.Name='Trial Summary report in HTML format.html';
		attHTML.parentId=reportRequestId;
		lstInsertAttachment.add(attHTML);
		
	//for pdf attachment
		Attachment attPDF = new Attachment();
		attPDF.Body = pdfContent;
		attPDF.Name='Trial Summary report in PDF format.pdf';
		attPDF.parentId=reportRequestId;
		lstInsertAttachment.add(attPDF);
		
	//for csv attachment
		Attachment attCSV = new Attachment();
		attCSV.Body = csvContent;
		attCSV.Name='Trial Summary report in CSV format.csv';
		attCSV.parentId=reportRequestId;
		lstInsertAttachment.add(attCSV);
		
		insert lstInsertAttachment;
		List<Report_Request__c> lstReportReq = [select Id, Status__c from Report_Request__c where Id=:reportRequestId];
		if(!lstReportReq.isEmpty()) {
			Report_Request__c reportReq = new Report_Request__c();
			reportReq = lstReportReq[0];
			reportReq.Status__c = 'Completed';
			update reportReq;
		}
		ReportGenerator.sendMail(reportRequestId);
		delete validReq;
	}
	
	public static Id createValidRequest() {
		Valid_Request__c validReq = new Valid_Request__c();
		validReq.Security_Token__c = PasswordManager.generateSecurityToken();
		insert validReq;
		return validReq.Id;
	}
	
	public static Id createreportRequest(String reportType) {
		Report_Request__c reportReq = new Report_Request__c();
		reportReq.Report_Type__c = reportType;
		reportReq.Status__c = 'In Progress';
		insert reportReq;
		return reportReq.Id;
	}
	
	public static void sendMail(Id reportRequestId) {
		Messaging.Singleemailmessage mail = new Messaging.Singleemailmessage();
		User user = [select Id, Email, Name from User where Id=:Userinfo.getUserId()];
		system.debug('__user.Email__'+user.Email);
        List<String> lstEmailId = new List<String>();
        lstEmailId.add(user.Email);
        mail.setToAddresses(lstEmailId);
        mail.setReplyTo('patelb@opallios.com');
        mail.setSenderDisplayName('support@opallios.com');
        mail.setSubject('Report Request');
        mail.setPlainTextBody('');
        String reportRequestUrl = URL.getSalesforceBaseUrl().toExternalForm()+'/'+reportRequestId;
        mail.setHtmlBody('Dear '+user.Name+',<br />Your report has been generated successfully.<br/ >If you want to see those reports then <a href="'+reportRequestUrl+'">click here</a>');
        system.debug('__mail__'+mail);
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
		emailLog.Class_Name__c = 'ReportGenerator.cls';
		emailLog.Email_Subject__c = mail.getSubject();
		emailLog.Recipient__c = emailIdString;
		emailLog.Remaining_Email_Invocation__c = (Limits.getLimitEmailInvocations() - Limits.getEmailInvocations())+' remaining out of total' +Limits.getLimitEmailInvocations();
		emailLog.Sender__c = Userinfo.getUserId();
		insert emailLog;*/
		Email_Logs__c emailLog = EmailLogsManager.createEmailLog('ReportGenerator.cls', mail.getSubject(), emailIdString);
		insert emailLog;
	}
	
	/*@future
	public static void generatePatientSummary(Id validRequestId, Id reportRequestId) {
		Valid_Request__c validReq = new Valid_Request__c();
		List<Valid_Request__c> lstValidReq = [select Id, Security_Token__c from Valid_Request__c where Id =:validRequestId];
		if(!lstValidReq.isEmpty()) {
			validReq = lstValidReq[0];
		}
		
	//******************************************For Sandbox******************************* 	
		system.debug('URL: '+'http://theforcetest.ispydev.cs14.force.com/PatientSummaryReport_HTML?token='+validReq.Security_Token__c);
		Pagereference pageRefHTML = new Pagereference('http://theforcetest.ispydev.cs14.force.com/PatientSummaryReport_HTML?token='+validReq.Security_Token__c);
		Pagereference pageRefPDF = new Pagereference('http://theforcetest.ispydev.cs14.force.com/PatientSummaryReport_PDF?token='+validReq.Security_Token__c);
		Pagereference pageRefCSV = new Pagereference('http://theforcetest.ispydev.cs14.force.com/PatientSummaryReport_CSV?token='+validReq.Security_Token__c);
		
	//******************************************For Production******************************* 	
		//system.debug('URL: '+'http://theforce.secure.force.com/PatientSummaryReport_HTML?token='+validReq.Security_Token__c);
		//Pagereference pageRefHTML = new Pagereference('http://theforce.secure.force.com/PatientSummaryReport_HTML?token='+validReq.Security_Token__c);
		//Pagereference pageRefPDF = new Pagereference('http://theforce.secure.force.com/PatientSummaryReport_PDF?token='+validReq.Security_Token__c);
		//Pagereference pageRefCSV = new Pagereference('http://theforce.secure.force.com/PatientSummaryReport_CSV?token='+validReq.Security_Token__c);
		
		Blob htmlContent = null;
		Blob pdfContent = null;
		Blob csvContent = null;
		if(!Test.isRunningTest()) {
			htmlContent = pageRefHTML.getContent();
			pdfContent = pageRefPDF.getContent();
			csvContent = pageRefCSV.getContent();
			system.debug('__pageRef.getContentAsPDF()__'+pageRefPDF.getContent());
		} else {
			htmlContent = Blob.valueOf('sd');
			pdfContent = Blob.valueOf('sd');
			csvContent = Blob.valueOf('sd');
		}	
		List<Attachment> lstInsertAttachment = new List<Attachment>();
	//for html attachment	
		Attachment attHTML = new Attachment();
		attHTML.Body = htmlContent;
		attHTML.Name='Patient Summary report in HTML format.html';
		attHTML.parentId=reportRequestId;
		lstInsertAttachment.add(attHTML);
		
	//for pdf attachment
		Attachment attPDF = new Attachment();
		attPDF.Body = pdfContent;
		attPDF.Name='Patient Summary report in PDF format.pdf';
		attPDF.parentId=reportRequestId;
		lstInsertAttachment.add(attPDF);
		
	//for csv attachment
		Attachment attCSV = new Attachment();
		attCSV.Body = csvContent;
		attCSV.Name='Patient Summary report in CSV format.csv';
		attCSV.parentId=reportRequestId;
		lstInsertAttachment.add(attCSV);
		
		insert lstInsertAttachment;
		List<Report_Request__c> lstReportReq = [select Id, Status__c from Report_Request__c where Id=:reportRequestId];
		if(!lstReportReq.isEmpty()) {
			Report_Request__c reportReq = new Report_Request__c();
			reportReq = lstReportReq[0];
			reportReq.Status__c = 'Completed';
			update reportReq;
		}
		//ReportGenerator.sendMail(reportRequestId);
		delete validReq;
	}*/
}