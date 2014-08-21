trigger ReportRequestAfterTrigger on Report_Request__c (after insert, after update) {
    for(Report_Request__c rr : Trigger.new) {
        if(rr.Report_Type__c == 'Patient Summary' && rr.Future_Count__c == 9) {
            String sfdcBaseURL = URL.getSalesforceBaseUrl().toExternalForm();
            String emailBody = '<br />Report request has processed successfully.' + 
                                'You can download reports from below mentioned links:<br />' +
                                'HTML: <a href="'+sfdcBaseURL+'/apex/PatientSummaryReport_HTML?repReqId='+rr.Id+'" target="_blank">Download</a><br/>' +
                                'PDF: <a href="'+sfdcBaseURL+'/apex/PatientSummaryReport_PDF?repReqId='+rr.Id+'" target="_blank">Download</a><br/>' +
                                'CSV: <a href="'+sfdcBaseURL+'/apex/PatientSummaryReport_CSV?repReqId='+rr.Id+'" >Download</a><br /><br />' +
                                'Thanks, <br />Salesforce.com';
            PatientSummaryReport.sendReportRequestEmailNotification(rr.Id, emailBody);
            
        } else if(rr.Report_Type__c == 'Adverse Event' && rr.Future_Count__c == 2) {
            
        }
    }
}