public with sharing class ReportRequestListingController {
    
    public List<Report_Request__c> lstReportRequest {get;set;} 
    public ReportRequestListingController() {
        lstReportRequest = [Select r.Status__c, r.Selected_Trial_Name__c, r.Selected_Institution_Name__c, r.Report_Type__c, r.CreatedDate From Report_Request__c r order by CreatedDate DESC];
    }
    
    @isTest public static void unitTest() {
        Report_Request__c rr = new Report_Request__c();
        insert rr;
        ReportRequestListingController repReq = new ReportRequestListingController();
    } 
}