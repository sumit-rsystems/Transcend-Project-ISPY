public with sharing class OnStudyPathologyNew {
	
	public OnStudyPathologyNew(ApexPages.StandardController controller){
		
	}
	
	public Pagereference customeNew(){
		Id trailPat = Apexpages.currentPage().getParameters().get('CF00Nc0000000GxI7_lkid');
		Pagereference pr = new Pagereference('/apex/OnStudyPathology?formName=OnStudy Pathology&trialPat='+trailPat);
		pr.getParameters().put('nooverride', '1');
		return pr;
	}
}