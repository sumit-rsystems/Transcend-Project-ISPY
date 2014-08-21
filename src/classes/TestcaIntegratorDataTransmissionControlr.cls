/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the 
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest(SeeAllData=true)
private class TestcaIntegratorDataTransmissionControlr {

    @isTest static void myUnitTest() {
    	List<TrialPatient__c> tpList = [Select subject_id__c, (Select Id From Response_Evaluation_Forms__r where status__c = 'Accepted'), (Select Id From Post_Surgery_Summaries__r where status__c = 'Accepted'), (Select Id From On_Study_Pathology_Forms__r where status__c = 'Accepted'), (Select Id From On_Study_Eligibility_Forms__r where status__c = 'Accepted'), (Select Id From Off_Study_Details__r where status__c = 'Accepted'), (Select Id From MammaPrint_Details__r where status__c = 'Approval Not Required'), (Select Id From MRI_Volumes__r where status__c = 'Accepted'), (Select Id From Lab_and_Tests__r where status__c = 'Accepted'), (Select Id From Followup_Forms__r where status__c = 'Accepted'), (Select Id From Chemo_Treatments__r where status__c = 'Accepted'), (Select Id From Chemo_Summary_Forms__r where status__c = 'Accepted') From TrialPatient__c t where site__r.isTestSite__c = false];
    	Set<String> subjectIds = new Set<String>();
    	for(TrialPatient__c tp : tpList) {
    		if((!subjectIds.contains(tp.subject_id__c)) && tp.Response_Evaluation_Forms__r.size() > 0 && tp.Post_Surgery_Summaries__r.size() > 0 &&
    			tp.On_Study_Pathology_Forms__r.size() > 0 && tp.On_Study_Eligibility_Forms__r.size() > 0
    			&& tp.MammaPrint_Details__r.size() > 0 && tp.MRI_Volumes__r.size() > 0 && 
    				tp.Chemo_Summary_Forms__r.size() > 0 
    				&& tp.Followup_Forms__r.size() > 0 && tp.Chemo_Treatments__r.size() > 0) {
    					caIntegratorDataTransmissionController caObject1 = new caIntegratorDataTransmissionController();
        				caObject1.generateCaIntegratorDataForPatient(tp.Id);
        				subjectIds.add(tp.subject_id__c);
        				break;
    				}
    	}
    	
    	List<Patient_Custom__c> lstPatient = [select Id ,Age__c, Race__c, Ethnicity__c,Institution__r.Name,Institution__r.Short_Name__c, Country_of_Birth__c, (Select caIntegratorValue__c, Code_Master__c, Value__c, Code_Master__r.Display_Order__c From Pre_Registration_Snomed_Codes__r order by Code_Master__r.Display_Order__c ASC), (Select Id From TrialPatients__r) from Patient_Custom__c limit 100];
    	for(Patient_Custom__c pc : lstPatient) {
    		if(pc.Pre_Registration_Snomed_Codes__r.size() > 0 && pc.TrialPatients__r.size() > 0) {
    			caIntegratorDataTransmissionController caObject1 = new caIntegratorDataTransmissionController();
				caObject1.generateCaIntegratorDataForPatient(pc.TrialPatients__r[0].Id);
				break;
    		}
    	}
	}
}