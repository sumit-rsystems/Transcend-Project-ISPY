public with sharing class InvestigationalAgentController extends PageControllerBase {
	
	public Id iacId{get;set;}
	public InvestigationalAgentController(Apexpages.standardcontroller iac){
		iacId = iac.getId();
	}
}