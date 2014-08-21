/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
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
private class TestMenopausalStatusDetailController {

	@isTest
    static void myUnitTest() {
        // TO DO: implement unit test
        	List<User> lstSiteUser = [Select u.IsActive, u.Id, SecurityCode__c From User u where IsActive = true and Profile.Name = 'Site User'];     
        	System.runAs ( lstSiteUser[0] ) { 
        	
		    Account acc = new Account();
		    
		    List<Account> lstAccount = [Select a.Id From Account a limit 1];
		    
		    if(!lstAccount.isEmpty()){
		    	
		    acc = lstAccount[0];
		    
	        Patient_Custom__c p = new Patient_Custom__c();
	        p.Birthdate__c = date.newInstance(1980, 08, 05);
	        p.Institution__c = acc.Id;
	        p.Last_Name__c = 'test'; 
			p.Gender__c = 'Male';
			p.Race__c = 'White';
			p.Ethnicity__c = 'Not Hispanic or Latino';
	        insert p;
	        
	        TrialPatient__c tp = new TrialPatient__c();
	        tp.Patient_Id__c = p.Id;
	        insert tp;
	        
	        Menopausal_Status_Detail__c msd1 = new Menopausal_Status_Detail__c(); // else part line 29
	        msd1.TrialPatient__c = tp.Id;
	        msd1.AgeVal__c = 'Age < 50';
	        msd1.Date_of_Last_Menstrual_Period__c = date.newInstance(2012, 01, 05);
	        msd1.On_Estrogen_Replacement__c = false;
	        msd1.Bilateral_oophorectomy__c = false;
	        msd1.Menopausal_Status__c = 'Above categories not applicable AND Age < 50';
	        //msd1.Menopausal_Status__c = '';
	        insert msd1;  
	        
	        Apexpages.currentPage().getParameters().put('trialPat',tp.Id);
	        Apexpages.standardcontroller controller1 = new Apexpages.standardcontroller(msd1);
	        MenopausalStatusDetailController msc1 = new MenopausalStatusDetailController(controller1); // else part finished here
	        system.debug('__msc1.trialPatient__'+msc1.trialPatient);
	        msc1.insertCRF();  
	        
	        system.debug('__msc1.trialPatient__'+msc1.trialPatient); 
	        msc1.insertCRF();
		    }
        }
    }
    
    @isTest
    static void myUnitTest2() {
        // TO DO: implement unit test
        	List<User> lstSiteUser = [Select u.IsActive, u.Id, SecurityCode__c From User u where IsActive = true and Profile.Name = 'Site User'];     
        	System.runAs ( lstSiteUser[0] ) { 
        	
		    Account acc = new Account();
		    
		    List<Account> lstAccount = [Select a.Id From Account a limit 1];
		    
		    if(!lstAccount.isEmpty()){
		    	
		    acc = lstAccount[0];
		    
	        Patient_Custom__c p = new Patient_Custom__c();
	        p.Birthdate__c = date.newInstance(1980, 08, 05);
	        p.Institution__c = acc.Id;
	        p.Last_Name__c = 'test'; 
			p.Gender__c = 'Male';
			p.Race__c = 'White';
			p.Ethnicity__c = 'Not Hispanic or Latino';
	        insert p;
	        
	        TrialPatient__c tp = new TrialPatient__c();
	        tp.Patient_Id__c = p.Id;
	        insert tp;
	        
	        Menopausal_Status_Detail__c msd = new Menopausal_Status_Detail__c();
	        msd.TrialPatient__c = tp.Id;
	        msd.On_Estrogen_Replacement__c = true;
	        msd.Bilateral_oophorectomy__c = true;
	        msd.Hysterectomy__c = true;  
	        msd.Menopausal_Status__c = 'Above categories not applicable AND Age < 50';
	        insert msd;  
	        
	        Apexpages.currentPage().getParameters().put('trialPat',tp.Id);
	        Apexpages.currentPage().getParameters().put('menopausalId',msd.Id); // if cond line 26
	        Apexpages.standardcontroller controller = new Apexpages.standardcontroller(msd);
	        MenopausalStatusDetailController msc = new MenopausalStatusDetailController(controller); 
	        msc.insertCRF(); // else part line 74
	        
	        msc.next(); // else part line 120
	        Apexpages.currentPage().getParameters().put('tabNext','Complete');
	        msc.next();
	        
		    }
        }
    }
    
    @isTest
    static void myUnitTest22() {
        // TO DO: implement unit test
        	List<User> lstSiteUser = [Select u.IsActive, u.Id, SecurityCode__c From User u where IsActive = true and Profile.Name = 'Site User'];     
        	System.runAs ( lstSiteUser[0] ) { 
        	
		    Account acc = new Account();
		    
		    List<Account> lstAccount = [Select a.Id From Account a limit 1];
		    
		    if(!lstAccount.isEmpty()){
		    	
		    acc = lstAccount[0];
		    
	        Patient_Custom__c p = new Patient_Custom__c();
	        p.Birthdate__c = date.newInstance(1980, 08, 05);
	        p.Institution__c = acc.Id;
	        p.Last_Name__c = 'test'; 
			p.Gender__c = 'Male';
			p.Race__c = 'White';
			p.Ethnicity__c = 'Not Hispanic or Latino';
	        insert p;
	        
	        TrialPatient__c tp = new TrialPatient__c();
	        tp.Patient_Id__c = p.Id;
	        insert tp;
	        
	        Menopausal_Status_Detail__c msd = new Menopausal_Status_Detail__c();
	        msd.TrialPatient__c = tp.Id;
	        msd.On_Estrogen_Replacement__c = true;
	        msd.Bilateral_oophorectomy__c = true;
	        msd.Hysterectomy__c = true;  
	        msd.Menopausal_Status__c = 'Above categories not applicable AND Age < 50';
	        insert msd;  
	        
	        Apexpages.currentPage().getParameters().put('trialPat',tp.Id);
	        Apexpages.currentPage().getParameters().put('menopausalId',msd.Id); // if cond line 26
	        Apexpages.standardcontroller controller = new Apexpages.standardcontroller(msd);
	        MenopausalStatusDetailController msc = new MenopausalStatusDetailController(controller); 
	        msc.insertCRF(); // else part line 74
	        
	        Apexpages.currentPage().getParameters().put('tabPrevious','Complete');
	        msc.previous();
		    }
        }
    }
    
    @isTest
    static void myUnitTest21() {
        // TO DO: implement unit test
        	List<User> lstSiteUser = [Select u.IsActive, u.Id, SecurityCode__c From User u where IsActive = true and Profile.Name = 'Site User'];     
        	System.runAs ( lstSiteUser[0] ) { 
        	
		    Account acc = new Account();
		    
		    List<Account> lstAccount = [Select a.Id From Account a limit 1];
		    
		    if(!lstAccount.isEmpty()){
		    	
		    acc = lstAccount[0];
		    
	        Patient_Custom__c p = new Patient_Custom__c();
	        p.Birthdate__c = date.newInstance(1980, 08, 05);
	        p.Institution__c = acc.Id;
	        p.Last_Name__c = 'test'; 
			p.Gender__c = 'Male';
			p.Race__c = 'White';
			p.Ethnicity__c = 'Not Hispanic or Latino';
	        insert p;
	        
	        TrialPatient__c tp = new TrialPatient__c();
	        tp.Patient_Id__c = p.Id;
	        insert tp;
	        
	        Menopausal_Status_Detail__c msd = new Menopausal_Status_Detail__c();
	        msd.TrialPatient__c = tp.Id;
	        msd.On_Estrogen_Replacement__c = true;
	        msd.Bilateral_oophorectomy__c = true;
	        msd.Hysterectomy__c = true;  
	        msd.Menopausal_Status__c = 'Above categories not applicable AND Age < 50';
	        insert msd;  
	        
	        Apexpages.currentPage().getParameters().put('trialPat',tp.Id);
	        Apexpages.currentPage().getParameters().put('menopausalId',msd.Id); // if cond line 26
	        Apexpages.standardcontroller controller = new Apexpages.standardcontroller(msd);
	        MenopausalStatusDetailController msc = new MenopausalStatusDetailController(controller); 
	        msc.insertCRF(); // else part line 74
	        
	        msc.signAndSubmit();  
	        
	        Apexpages.currentPage().getParameters().put('menopausalId',msd.Id);
	        Apexpages.currentPage().getParameters().put('trialPat',tp.Id);
	        msc.resendCode();
	        msc.editCRF();
	        msc.customCancel();
		    }
        }
    }
    
    @isTest
    static void myUnitTest3() {
        // TO DO: implement unit test
        	List<User> lstSiteUser = [Select u.IsActive, u.Id, SecurityCode__c From User u where IsActive = true and Profile.Name = 'Site User'];     
        	System.runAs ( lstSiteUser[0] ) { 
        	
		    Account acc = new Account();
		    
		    List<Account> lstAccount = [Select a.Id From Account a limit 1];
		    
		    if(!lstAccount.isEmpty()){
		    	
		    acc = lstAccount[0];
		    
	        Patient_Custom__c p = new Patient_Custom__c();
	        p.Birthdate__c = date.newInstance(1980, 08, 05);
	        p.Institution__c = acc.Id;
	        p.Last_Name__c = 'test'; 
			p.Gender__c = 'Male';
			p.Race__c = 'White';
			p.Ethnicity__c = 'Not Hispanic or Latino';
	        insert p;
	        
	        TrialPatient__c tp = new TrialPatient__c();
	        tp.Patient_Id__c = p.Id;
	        insert tp;
	        
	        Menopausal_Status_Detail__c msd1 = new Menopausal_Status_Detail__c(); // else part line 29
	        msd1.TrialPatient__c = tp.Id;
	        msd1.Unknown_Date__c = true;
	        msd1.Unknown_Date_but_12_Months_Ago__c = true;
	        msd1.Menopausal_Status__c = 'Above categories not applicable AND Age < 50';
	        insert msd1;  
	        
	        Apexpages.currentPage().getParameters().put('trialPat',tp.Id);
	        Apexpages.standardcontroller controller = new Apexpages.standardcontroller(msd1);
	        MenopausalStatusDetailController msc = new MenopausalStatusDetailController(controller);
	        
	        Apexpages.currentPage().getParameters().put('tabNext','saveAndClose');
	        msc.nextTabName = 'saveAndClose';
	        msc.next();
	        
	        msc.cloneCRF();
	        
	        /*Menopausal_Status_Detail__c msd = new Menopausal_Status_Detail__c(); // else part line 29
	        msd.TrialPatient__c = tp.Id;
	        msd.Unknown_Date__c = false;
	        msd.Unknown_Date_but_12_Months_Ago__c = false;
	        msd.Bilateral_Oophorectomy_Date__c = date.newInstance(2018, 8, 8);
	        msd.Menopausal_Status__c = 'Above categories not applicable AND Age < 50';
	        insert msd;  
	        
	        Apexpages.currentPage().getParameters().put('trialPat',tp.Id);
	        Apexpages.standardcontroller controller1 = new Apexpages.standardcontroller(msd);
	        MenopausalStatusDetailController msc1 = new MenopausalStatusDetailController(controller1);
	        
	        Apexpages.currentPage().getParameters().put('tabNext','saveAndClose');
	        msc1.nextTabName = 'saveAndClose';
	        msc1.next();*/
		    }
        }
    }
    
    @isTest
    static void afterTrigger() {
        // TO DO: implement unit test
        	List<User> lstSiteUser = [Select u.IsActive, u.Id, SecurityCode__c From User u where IsActive = true and Profile.Name = 'Site User'];     
        	System.runAs ( lstSiteUser[0] ) { 
        	
		    Account acc = new Account();
		    
		    List<Account> lstAccount = [Select a.Id From Account a limit 1];
		    
		    if(!lstAccount.isEmpty()){
		    	
			    acc = lstAccount[0];
			    
		        Patient_Custom__c p = new Patient_Custom__c();
		        p.Birthdate__c = date.newInstance(1980, 08, 05);
		        p.Institution__c = acc.Id;
		        p.Last_Name__c = 'test'; 
				p.Gender__c = 'Male';
				p.Race__c = 'White';
				p.Ethnicity__c = 'Not Hispanic or Latino';
		        insert p;
		        
		        TrialPatient__c tp = new TrialPatient__c();
		        tp.Patient_Id__c = p.Id;
		        insert tp;
		        
		        Menopausal_Status_Detail__c msd = new Menopausal_Status_Detail__c(); // else part line 29
		        msd.TrialPatient__c = tp.Id;
		        msd.Unknown_Date__c = false;
		        msd.Unknown_Date_but_12_Months_Ago__c = false;
		        msd.Bilateral_Oophorectomy_Date__c = date.newInstance(2018, 8, 8);
		        msd.Menopausal_Status__c = 'Above categories not applicable AND Age < 50';
		        insert msd;  
		        
		        msd.Status__c = 'Approval Pending';
		        update msd;
		        msd.Status__c = 'Accepted';
		        update msd;
		    }
        }
    }
}