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
private class TestFollowupFormController {

    	@isTest
    	static void myUnitTest1() 
    	{ 
        List<User> lstSiteUser = [Select u.IsActive, u.Id From User u where IsActive = true];
        System.runAs ( lstSiteUser[0] ) { 
            
        Account acc = new Account();
        acc.Name = 'test';
        insert acc;
            
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
        
        //============================== "Followup_Form__c" = NULL to satisfy "saveMainCRF()"==============
            
        Followup_Form__c followObject1 = new Followup_Form__c(); 
        followObject1.TrialPatient__c = tp.Id;
        followObject1.Survival_Status__c = 'Dead';
        followObject1.Start_Date__c = date.newInstance(2012, 7, 7);
        followObject1.End_Date__c = date.newInstance(2012, 8, 8);
        followObject1.patient_diagnosed_local_progression__c = true;
        followObject1.patient_diagnosed_distant_progression__c = false;
        followObject1.Menopausal_status__c = 'Menopaus';
        
        Apexpages.currentPage().getParameters().put('trialPat',tp.Id);
        Apexpages.currentPage().getParameters().put('fupformId',null);
            
        ApexPages.StandardController std1 = new ApexPages.StandardController(followObject1);
        FollowupFormController ffObject1 = new FollowupFormController(std1);
            
        ffObject1.saveMainCRF();
            
        ffObject1.next();
            
        ffObject1.previous();
        ffObject1.currentTab = 'completeTab';
        ffObject1.previous();
        ffObject1.currentTab = 'attachmentTab';
        ffObject1.previous();
        ffObject1.cloneCRF(); 
            
        //=============================finished=========================================================
            
        Followup_Form__c followObject = new Followup_Form__c(); 
        followObject.TrialPatient__c = tp.Id;
        followObject.Survival_Status__c = 'Alive';
        followObject.Start_Date__c = date.newInstance(2012, 7, 7);
        followObject.End_Date__c = date.newInstance(2012, 8, 8);
        followObject.patient_diagnosed_local_progression__c = true;
        followObject.patient_diagnosed_distant_progression__c = true;
        followObject.Status__c = 'Approval Pending';
        insert followObject;
        update followObject;
            
        Therapy_Received__c tr = new Therapy_Received__c();
        tr.Followup_Form__c = followObject.Id;
        insert tr;
        
        Irradiated_Site__c ir = new Irradiated_Site__c();
        ir.Followup_Form__c  = followObject.Id;
        ir.Total_dose_cGy_AP__c = 1.0;
        ir.Dose_per_FX_cGy__c = 2.0;
        ir.Total_FX__c = 5.0;
        insert ir; 
         
        Apexpages.currentPage().getParameters().put('trialPat',tp.Id);
        Apexpages.currentPage().getParameters().put('fupformId',followObject.Id);
            
        ApexPages.StandardController std = new ApexPages.StandardController(followObject);
        FollowupFormController ffObject = new FollowupFormController(std);
            
        Apexpages.currentPage().getParameters().put('nextTab','saveAndClose');
        ffObject.next();
        
            
        //==========================method "TherapyReceived()" begins here =============================
        ffObject.addTherapyReceived();
        ffObject.editTherapyReceived();
        ffObject.updateTherapyReceived();
        ffObject.saveTherapyReceived();
        Apexpages.currentPage().getParameters().put('recordId',tr.Id);
        ffObject.cancelTherapyReceived();
        Apexpages.currentPage().getParameters().put('recordId',tr.Id);
        ffObject.removeTherapyReceived();
        //==========================method "TherapyReceived()" ends here ===============================
            
        //==========================method "addIrradiatedSite()" begins here ===========================
            
        ffObject.addIrradiatedSite();
        ffObject.editIrradiatedSite();
        ffObject.updateIrradiatedSite();
        ffObject.saveIrradiatedSite();
        Apexpages.currentPage().getParameters().put('recordId',null);
        ffObject.cancelIrradiatedSite();
        Apexpages.currentPage().getParameters().put('recordId',ir.Id);
        ffObject.cancelIrradiatedSite();
        Apexpages.currentPage().getParameters().put('recordId',ir.Id);
        ffObject.removeIrradiatedSite(); 
            
        //==========================method "addIrradiatedSite()" ends here =============================
            
        //ffObject.attachPdf();
   }
 }
    @isTest static void myUnitTest2() { 
        List<User> lstSiteUser = [Select u.IsActive, u.Id From User u where IsActive = true];
        System.runAs ( lstSiteUser[0] ) { 
            
        Account acc = new Account();
        acc.Name = 'test';
        insert acc;
            
        Trial__c trial = new Trial__c();
        trial.Name = 'test';
        insert trial;
        
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
        
        Registration__c reg = new Registration__c(); 
        reg.Patient__c = p.Id;
        reg.TrialPatient__c = tp.Id;
        reg.Trial__c = trial.Id;
        reg.Last_Name__c = p.Last_Name__c;
        reg.Gender__c = p.Gender__c;
        reg.Registration_Date__c = system.today();
        reg.Ethnicity__c = p.Ethnicity__c;
        reg.Race__c =  p.Race__c;
        reg.Institution__c = acc.Id;
        reg.IRB_Approval_Date__c = system.today();
        reg.HIPPA_Consent_Date__c = system.today();
        reg.Screening_Informed_Consent_Date__c = system.today();
        reg.Effective_Time__c = system.now();
        reg.ISPY2_Subject_Id__c = ''+123; 
        insert reg;
        
        Followup_Form__c followObject = new Followup_Form__c(); 
        followObject.TrialPatient__c = tp.Id;
        followObject.Survival_Status__c = 'Dead';
        followObject.Start_Date__c = date.newInstance(2012, 7, 7);
        followObject.End_Date__c = date.newInstance(2012, 8, 8);
        followObject.patient_diagnosed_local_progression__c = true;
        followObject.patient_diagnosed_distant_progression__c = false;
        followObject.Menopausal_status__c = 'Menopaus';
        followObject.Status__c = 'Accepted';
        insert followObject;
        update followObject;
            
        Therapy_Received__c tr = new Therapy_Received__c();
        tr.Followup_Form__c = followObject.Id;
        insert tr;
        
        Irradiated_Site__c ir = new Irradiated_Site__c();
        ir.Followup_Form__c  = followObject.Id;
        ir.Total_dose_cGy_AP__c = 1.0;
        ir.Dose_per_FX_cGy__c = 2.0;
        ir.Total_FX__c = 5.0;
        insert ir; 
     
        Apexpages.currentPage().getParameters().put('trialPat',tp.Id);  
        Apexpages.currentPage().getParameters().put('fupformId',followObject.Id);
            
        ApexPages.StandardController std = new ApexPages.StandardController(followObject);
        FollowupFormController ffObject = new FollowupFormController(std);
        
        ffObject.currentTab = 'MPStatusTab';    
        ffObject.next();
        
        ffObject.editCRF();
        
        Apexpages.currentPage().getParameters().put('recordId',null);
        ffObject.cancelTherapyReceived();
            
        ffObject.recurrenceProgressChoice = new List<String>{'Test'};
        ffObject.progressionLocalChoice = new List<String>{'Test1'};
        ffObject.progressionDistantChoice = new List<String>{'Test2'};
        ffObject.menopausalStatusChoice = new List<String>{'Test3'};
        
        ffObject.resendCode();
        ffObject.signAndSubmit();
        Apexpages.currentPage().getParameters().put('trialPat',tp.Id);
        ffObject.cancelCRF();
    } 
  }
}