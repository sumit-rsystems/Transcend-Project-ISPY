public with sharing class TrialSummaryReportNew {
	
	public String trialId{get;set;}	
	public Trial__c trial{get;set;}
	public Datetime startDate{get;set;}
	public Datetime asOfDate{get;set;}
	
	public TrialSummaryReportNew(){
		trialId = ApexPages.currentPage().getParameters().get('trialId');
		if(ApexPages.currentPage().getParameters().get('asOfDate') != null) {
			asOfDate = Date.valueOf(ApexPages.currentPage().getParameters().get('asOfDate'));
		} else {
			asOfDate = system.now();
		}
		
		if(ApexPages.currentPage().getParameters().get('startDate') != null) {
			startDate = Date.valueOf(ApexPages.currentPage().getParameters().get('startDate'));
		} else {
			startDate = system.now();
		}
		
		trial = [select Name from Trial__c where Id =:trialId];
		system.debug('--trialId--'+trialId);
	}
	
	public Pagereference redirectNewPage(){
		String format = Apexpages.currentPage().getParameters().get('format');
		if(format == 'PDF'){
			if(asOfDate != null){
				Pagereference pr = new Pagereference('/apex/TrialSummaryReportPDF?trialId='+trialId+'&asOfDate='+asOfDate);
				pr.setRedirect(true);
				return pr;
			} else {
				Pagereference pr = new Pagereference('/apex/TrialSummaryReportPDF?trialId='+trialId);
				pr.setRedirect(true);
				return pr;
			}	
		} else if(format == 'HTML'){
			if(asOfDate != null){
				Pagereference pr = new Pagereference('/apex/TrialSummaryReportHTML?trialId='+trialId+'&asOfDate='+asOfDate);
				pr.setRedirect(true);
				return pr;
			} else {
				Pagereference pr = new Pagereference('/apex/TrialSummaryReportHTML?trialId='+trialId);
				pr.setRedirect(true);
				return pr;
			}
		} else if(format == 'CSV'){
			if(asOfDate != null){
				Pagereference pr = new Pagereference('/apex/TrialSummaryReportCSV?trialId='+trialId+'&asOfDate='+asOfDate);
				pr.setRedirect(true);
				return pr;
			} else {
				Pagereference pr = new Pagereference('/apex/TrialSummaryReportCSV?trialId='+trialId);
				pr.setRedirect(true);
				return pr;
			}
		} else {
			return null;
		}
	}
}