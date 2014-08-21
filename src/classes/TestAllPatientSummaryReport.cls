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
@isTest
private class TestAllPatientSummaryReport {

    @isTest static void myUnitTest() {
        
        //Test.startTest();
        List<User> lstSiteUser = [Select u.IsActive, u.Id, SecurityCode__c From User u where IsActive = true and Profile.Name = 'Site User'];     
            
        Account acc = null;

        List<Account> lstAccount = [select Id, (Select Id From Sites__r)  from Account];
            
        if(lstAccount.isEmpty())return;
        Site__c site1 = null;
        Id testTrialId = null;
        for(Account acc1 : lstAccount) {
        	if(acc.Sites__r.size() != 0) {
        		acc = acc1;
        		site1 = acc.Sites__r[0];
        		break;
        	}
	        if(site1 != null) {
	        
		        List<Site_Trial__c> stList = [Select s.Trial__c, s.Site__c From Site_Trial__c s where Trial__c != null and Site__c = :site1.Id];
		        if(!stList.isEmpty()){
		        	testTrialId = stList[0].Trial__c;
		        	break;
		        }
	        }
        }
        
        if(testTrialId == null)return;
        
        InstitutionUser__c instUser = new InstitutionUser__c();
        instUser.Site__c = site1.Id;
        instUser.Trial__c = testTrialId;
        instUser.User__c = lstSiteUser[0].Id;
        instUser.Institution__c = acc.Id;
        insert instUser;
        
        Test.startTest();
        
        Patient_Custom__c p = new Patient_Custom__c();
        p.Birthdate__c = date.newInstance(1960, 8, 7);
        p.Institution__c = acc.Id;
        p.Last_Name__c = 'test'; 
        p.Gender__c = 'Male';
        p.Race__c = 'White';
        p.Ethnicity__c = 'Not Hispanic or Latino';
        insert p;
        
        TrialPatient__c tp = new TrialPatient__c();
        tp.FirstName__c = 'a';
        tp.LastName__c = 'b';
        tp.Patient_Id__c = p.Id;
        tp.Trial_Id__c = testTrialId;
        tp.Site__c = site1.Id;
        insert tp;
        
        Registration__c reg = new Registration__c(); 
        reg.Patient__c = p.Id;
        reg.Registration_Date__c = system.today();
        reg.Trial__c = testTrialId;
        reg.Institution__c = acc.Id;
        reg.Site__c = site1.Id;
        reg.IRB_Approval_Date__c = system.today();
        reg.HIPPA_Consent_Date__c = system.today();
        reg.Screening_Informed_Consent_Date__c = system.today();
        reg.Effective_Time__c = system.now();
        reg.ISPY2_Subject_Id__c = ''+123;
        reg.TrialPatient__c = tp.Id;
        reg.Status__c = 'Approval Not Required';
        insert reg;
        
        Randomization_Form__c rfc = new Randomization_Form__c();
        rfc.TrialPatient__c = tp.Id;
        rfc.Why_Patient_Not_Signed_Consent_Form__c = 'Patient found to be ineligible for the study';
        rfc.Status__c = 'Approval Not Required';
        insert rfc;
        
        
        AllPatientSummaryReport allPSummaryReport = null;
        System.runAs ( lstSiteUser[0] ) {
            allPSummaryReport = new AllPatientSummaryReport();
            List<Selectoption> sites = allPSummaryReport.getSites();
            allPSummaryReport.setSites(sites);
        
            allPSummaryReport.selectedSites = new List<String>();
            allPSummaryReport.selectedSites.add(site1.Id);
            List<Selectoption> trials = allPSummaryReport.getTrials();
            allPSummaryReport.setTrials(trials);
            allPSummaryReport.selectedTrials = new List<String>();
            allPSummaryReport.selectedTrials.add(testTrialId);
            allPSummaryReport.generateReport();
            
            System.debug('tp : '+[select id, Subject_Id__c from TrialPatient__c where id = :tp.Id]);
        }
        
        rfc.Did_Patient_Sign_Treatment_Consent_Form__c = true;
        update rfc;
        allPSummaryReport.generateReport();
        
        delete rfc;
        allPSummaryReport.generateReport();
        
        Apexpages.currentPage().getParameters().put('format','PDF');
        allPSummaryReport.redirectNewPage();
        
        Apexpages.currentPage().getParameters().put('format','HTML');
        allPSummaryReport.redirectNewPage();
        
        Apexpages.currentPage().getParameters().put('format','CSV');
        allPSummaryReport.redirectNewPage();
        Test.stopTest();
    }
    
     @isTest static void myUnitTest1() {
        
        //Test.startTest();
        List<User> lstInstUser = [Select u.IsActive, u.Id, SecurityCode__c From User u where IsActive = true and Profile.Name = 'Institute Level Admin'];     
            
        Account acc = null;

        List<Account> lstAccount = [select Id, (Select Id From Sites__r)  from Account];
            
        if(lstAccount.isEmpty())return;
        Site__c site1 = null;
        Id testTrialId = null;
        for(Account acc1 : lstAccount) {
        	if(acc.Sites__r.size() != 0) {
        		acc = acc1;
        		site1 = acc.Sites__r[0];
        		break;
        	}
	        if(site1 != null) {
	        
		        List<Site_Trial__c> stList = [Select s.Trial__c, s.Site__c From Site_Trial__c s where Trial__c != null and Site__c = :site1.Id];
		        if(!stList.isEmpty()){
		        	testTrialId = stList[0].Trial__c;
		        	break;
		        }
	        }
        }
        
        if(testTrialId == null)return;
        
        InstitutionUser__c instUser = new InstitutionUser__c();
        instUser.Site__c = site1.Id;
        instUser.Trial__c = testTrialId;
        instUser.User__c = lstInstUser[0].Id;
        instUser.Institution__c = acc.Id;
        insert instUser;
        
        Test.startTest();
        
        Patient_Custom__c p = new Patient_Custom__c();
        p.Birthdate__c = date.newInstance(1960, 8, 7);
        p.Institution__c = acc.Id;
        p.Last_Name__c = 'test'; 
        p.Gender__c = 'Male';
        p.Race__c = 'White';
        p.Ethnicity__c = 'Not Hispanic or Latino';
        insert p;
        
        TrialPatient__c tp = new TrialPatient__c();
        tp.FirstName__c = 'a';
        tp.LastName__c = 'b';
        tp.Patient_Id__c = p.Id;
        tp.Trial_Id__c = testTrialId;
        tp.Site__c = site1.Id;
        insert tp;
        
        Registration__c reg = new Registration__c(); 
        reg.Patient__c = p.Id;
        reg.Registration_Date__c = system.today();
        reg.Trial__c = testTrialId;
        reg.Institution__c = acc.Id;
        reg.Site__c = site1.Id;
        reg.IRB_Approval_Date__c = system.today();
        reg.HIPPA_Consent_Date__c = system.today();
        reg.Screening_Informed_Consent_Date__c = system.today();
        reg.Effective_Time__c = system.now();
        reg.ISPY2_Subject_Id__c = ''+123;
        reg.TrialPatient__c = tp.Id;
        reg.Status__c = 'Approval Not Required';
        insert reg; 
        
        Randomization_Form__c rfc = new Randomization_Form__c();
        rfc.TrialPatient__c = tp.Id;
        rfc.Why_Patient_Not_Signed_Consent_Form__c = 'Patient found to be ineligible for the study';
        rfc.Status__c = 'Approval Not Required';
        insert rfc;
        
        
        AllPatientSummaryReport allPSummaryReport = null;
        System.runAs ( lstInstUser[0] ) {
            allPSummaryReport = new AllPatientSummaryReport();
            List<Selectoption> sites = allPSummaryReport.getSites();
            allPSummaryReport.setSites(sites);
        
            allPSummaryReport.selectedSites = new List<String>();
            allPSummaryReport.selectedSites.add(site1.Id);
            List<Selectoption> trials = allPSummaryReport.getTrials();
            allPSummaryReport.setTrials(trials);
            allPSummaryReport.selectedTrials = new List<String>();
            allPSummaryReport.selectedTrials.add(testTrialId);
            
            allPSummaryReport.selectedSiteOptions = new List<Selectoption>();
            allPSummaryReport.selectedSiteOptions.add(new Selectoption(site1.Id, site1.Id));
            
            allPSummaryReport.selectedTrialOptions = new List<Selectoption>();
            allPSummaryReport.selectedTrialOptions.add(new Selectoption(testTrialId, testTrialId));
            
            allPSummaryReport.generateReport();
            
            System.debug('tp : '+[select id, Subject_Id__c from TrialPatient__c where id = :tp.Id]);
        }
        
        rfc.Did_Patient_Sign_Treatment_Consent_Form__c = true;
        rfc.Consent_Signed_Date__c = system.today(); 
        update rfc;
        allPSummaryReport.generateReport();
        
        delete rfc;
        allPSummaryReport.generateReport();
        
        Apexpages.currentPage().getParameters().put('format','PDF');
        allPSummaryReport.redirectNewPage();
        
        Apexpages.currentPage().getParameters().put('format','HTML');
        allPSummaryReport.redirectNewPage();
        
        Apexpages.currentPage().getParameters().put('format','CSV');
        allPSummaryReport.redirectNewPage();
        Test.stopTest();
    }
}