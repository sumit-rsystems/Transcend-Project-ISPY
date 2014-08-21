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
private class TestPhaseMaster {
	
	@isTest static void myUnitTestNEW() { 

		List<User> thisUser = [Select u.IsActive, u.Id, SecurityCode__c ,u.Patient_Id__c, u.ProfileId, u.Username From User u where IsActive = true and Profile.Name = 'System Administrator'];     
		System.runAs ( thisUser[0] ) { 
		
	    Account acc = new Account();
	    
	    List<Account> lstAccount = [Select a.Id From Account a limit 1];
	    
	    if(!lstAccount.isEmpty()){
	    	
	    acc = lstAccount[0];
	    
	    Patient_Custom__c pcObject = new Patient_Custom__c();
	    pcObject.Birthdate__c = date.newInstance(1980, 08, 05);
	    pcObject.Institution__c = acc.Id;
	    pcObject.Last_Name__c = 'test'; 
		pcObject.Gender__c = 'Male';
		pcObject.Race__c = 'White';
		pcObject.Ethnicity__c = 'Not Hispanic or Latino';
		pcObject.Email__c = thisUser[0].Username;
		pcObject.isPortalEnable__c = true;
	    insert pcObject;
	    
	    Trial__c tr = new Trial__c();
	    tr.Name = 'test';
	    insert tr;
	    
	    TrialPatient__c tp = new TrialPatient__c();
	    tp.Patient_Id__c = pcObject.Id;
	    tp.Trial_Id__c = tr.Id;
	    insert tp;
	    
	    Event eventObject = new Event();
	    eventObject.Trial__c = tr.Id;
	    eventObject.ActivityDateTime = datetime.newInstance(2014, 12, 1, 12, 30, 2); // year,month,day,hr,min,sec
	    eventObject.WhatId = acc.Id;
	    eventObject.OwnerId = thisUser[0].Id;
	    eventObject.Subject = 'test';
	    eventObject.DurationInMinutes = 300;
	    eventObject.Hours__c = 2.0;
	    eventObject.Minutes__c = 30.0;
	    eventObject.StartDateTime = datetime.newInstance(2014, 12, 1, 12, 30, 2);
	    insert eventObject;
	    update eventObject;
	    
	    Task tskObject = new Task();
	    tskObject.Trial_Id__c = tr.Id;
	    tskObject.ActivityDate = date.newInstance(2012, 07, 07);
	    tskObject.Status = 'Completed';
	    tskObject.OwnerId = userinfo.getUserId();
	    tskObject.WhatId = pcObject.Id; 
	    tskObject.Subject = 'Call';
	    tskObject.Type = 'Schedule the patient for a blood sample';
	    tskObject.Schedule_Event_Date__c = datetime.newInstance(2014, 12, 1, 12, 30, 2);
	    insert tskObject;
	    
	    List<Task> lsttsk = new List<Task>();
	    lsttsk.add(tskObject);
	    
	    Apexpages.currentPage().getParameters().put('id',pcObject.Id);
	    Apexpages.currentPage().getParameters().put('TrialId',tr.Id);
	    Apexpages.StandardController std = new Apexpages.StandardController(pcObject);
	    PhaseMaster pmObject = new PhaseMaster(std);
	    pmObject.selectedTrial = tr.Id;
	    pmObject.selectredioButton = 'Upcoming Appointments';
	    pmObject.getWrapList();	
	    
	    pmObject.selectedTaskOption = 'Completed';
	    pmObject.getLstTask();
	    pmObject.setLstTask(lsttsk);
	    pmObject.getItems();
	    
	    Apexpages.currentPage().getParameters().put('taskId',tskObject.Id);
	    
	    Event eventObject1 = new Event();
	    eventObject1.Trial__c = tr.Id;
	    eventObject1.ActivityDateTime = datetime.newInstance(2010, 12, 1, 12, 30, 2); // year,month,day,hr,min,sec
	    eventObject1.WhatId = acc.Id;
	    eventObject1.OwnerId = thisUser[0].Id;
	    eventObject1.Subject = 'test';
	    eventObject1.DurationInMinutes = 300;
	    eventObject1.Hours__c = null;
	    eventObject1.Minutes__c = null;
	    eventObject1.StartDateTime = datetime.newInstance(2010, 12, 1, 12, 30, 2);
	    insert eventObject1;
	    pmObject.event = eventObject1;
	    
	    pmObject.completeTask();
	    
	    //==============================method "ScheduledEvent()" begins here=============================================
	    pmObject.event = eventObject;
	    pmObject.taskIdHidden = tskObject.Id;
	    pmObject.ScheduledEvent();
	  /*  pmObject.startDateValidationEventCreation();
	    pmObject.startDateValidationReschude(); */
	    
	    //=======================================================ENDS=====================================================
	    
	    //=====================method "EventRescheduleAction()" , "rescheduleEvent()","cancelEventSch()","updateEmail()"========
	    
	    pmObject.eventres = eventObject;
	    pmObject.eventId = eventObject.Id;
	  //  pmObject.rescheduleEvent();
	    
	    pmObject.cancelEventSch();   
	      
	    pmObject.allEvecheckboxre = true;
	   // pmObject.rescheduleEvent();
	    pmObject.updateEmail();
	    
	    //==================================================END ===========================================================
	  }
	}
  }
  @isTest static void myUnitTest1() { 

		List<User> thisUser = [Select u.IsActive, u.Id, SecurityCode__c ,u.Patient_Id__c, u.ProfileId, u.Username From User u where IsActive = true and Profile.Name = 'System Administrator'];     
		System.runAs ( thisUser[0] ) { 
		
	    Account acc = new Account();
	    
	    List<Account> lstAccount = [Select a.Id From Account a limit 1];
	    
	    if(!lstAccount.isEmpty()){
	    	
	    acc = lstAccount[0];
	    
	    Patient_Custom__c pcObject = new Patient_Custom__c();
	    pcObject.Birthdate__c = date.newInstance(1980, 08, 05);
	    pcObject.Institution__c = acc.Id;
	    pcObject.Last_Name__c = 'test'; 
		pcObject.Gender__c = 'Male';
		pcObject.Race__c = 'White';
		pcObject.Ethnicity__c = 'Not Hispanic or Latino';
		pcObject.Email__c = thisUser[0].Username;
		pcObject.isPortalEnable__c = true;
	    insert pcObject;
	    
	    Trial__c tr = new Trial__c();
	    tr.Name = 'test';
	    insert tr;
	    
	    TrialPatient__c tp = new TrialPatient__c();
	    tp.Patient_Id__c = pcObject.Id;
	    tp.Trial_Id__c = tr.Id;
	    insert tp;
	    
	    Event eventObject = new Event();
	    eventObject.Trial__c = tr.Id;
	    eventObject.ActivityDateTime = datetime.newInstance(2014, 12, 1, 12, 30, 2); // year,month,day,hr,min,sec
	    eventObject.WhatId = acc.Id;
	    eventObject.OwnerId = thisUser[0].Id;
	    eventObject.Subject = 'test';
	    eventObject.DurationInMinutes = 300;
	    eventObject.Hours__c = 2.0;
	    eventObject.Minutes__c = 30.0;
	    eventObject.StartDateTime = datetime.newInstance(2014, 12, 1, 12, 30, 2);
	    insert eventObject;
	    update eventObject;
	    
	    Task tskObject = new Task();
	    tskObject.Trial_Id__c = tr.Id;
	    tskObject.ActivityDate = date.newInstance(2012, 07, 07);
	    tskObject.Status = 'Completed';
	    tskObject.OwnerId = userinfo.getUserId();
	    tskObject.WhatId = pcObject.Id; 
	    tskObject.Subject = 'Call';
	    tskObject.Type = 'Schedule the patient for a MRI scan';
	    tskObject.Schedule_Event_Date__c = datetime.newInstance(2014, 12, 1, 12, 30, 2);
	    insert tskObject;
	    
	    Apexpages.currentPage().getParameters().put('id',pcObject.Id);
	    Apexpages.currentPage().getParameters().put('TrialId',tr.Id);
	    Apexpages.StandardController std = new Apexpages.StandardController(pcObject);
	    PhaseMaster pmObject1 = new PhaseMaster(std);
	    pmObject1.selectedTrial = tr.Id;
	    pmObject1.selectredioButton = 'Past Appointments';
	    pmObject1.getWrapList();	
	    
	    pmObject1.selectedTaskOption = 'Completed';
	    pmObject1.getLstTask();
	    
	    pmObject1.event = eventObject;
	    pmObject1.eventStatusHidden = 'Complete';
	    pmObject1.ScheduledEvent();
	    
	    pmObject1.eventStatusHidden = 'Schedule';
	    pmObject1.ScheduledEvent();
	    
	    Apexpages.currentPage().getParameters().put('taskId',tskObject.Id);
	    
	    Event eventObject2 = new Event();
	    eventObject2.Trial__c = tr.Id;
	    eventObject2.ActivityDateTime = datetime.newInstance(2010, 12, 1, 12, 30, 2); // year,month,day,hr,min,sec
	    eventObject2.WhatId = acc.Id;
	    eventObject2.OwnerId = thisUser[0].Id;
	    eventObject2.Subject = 'test';
	    eventObject2.DurationInMinutes = 300;
	    eventObject2.Hours__c = null;
	    eventObject2.Minutes__c = null;
	    eventObject2.StartDateTime = datetime.newInstance(2010, 12, 1, 12, 30, 2);
	    insert eventObject2;
	    pmObject1.event = eventObject2;
	    
	    pmObject1.completeTask();
	    
	    Patient_Custom__c pcObject1 = new Patient_Custom__c();
	    pcObject1.Birthdate__c = date.newInstance(1980, 08, 05);
	    pcObject1.Institution__c = acc.Id;
	    pcObject1.Last_Name__c = 'test'; 
		pcObject1.Gender__c = 'Male';
		pcObject1.Race__c = 'White';
		pcObject1.Ethnicity__c = 'Not Hispanic or Latino';
	    insert pcObject1;
	    
	    Event eventObject1 = new Event();
	    eventObject1.Trial__c = tr.Id;
	    eventObject1.ActivityDateTime = datetime.newInstance(2009, 12, 1, 12, 30, 2); 
	    eventObject1.WhatId = acc.Id;
	    eventObject1.OwnerId = thisUser[0].Id;
	    eventObject1.Subject = 'test';
	    eventObject1.DurationInMinutes = 300;
	    eventObject1.Hours__c = 2.0;
	    eventObject1.Minutes__c = 30.0;
	    eventObject1.StartDateTime = datetime.newInstance(2009, 12, 1, 12, 30, 2);
	    insert eventObject1;
	    update eventObject1;
	    
	    Apexpages.currentPage().getParameters().put('id',pcObject1.Id);
	    Apexpages.currentPage().getParameters().put('TrialId',tr.Id);
	    Apexpages.StandardController std1 = new Apexpages.StandardController(pcObject1);
	    PhaseMaster pmObject2 = new PhaseMaster(std1);
	    pmObject2.selectedTrial = tr.Id;	
	    
	    pmObject2.updateEmail();
	  }
	}
  }
  @isTest static void myUnitTest2() { 

		List<User> thisUser = [Select u.IsActive, u.Id, SecurityCode__c ,u.Patient_Id__c, u.ProfileId, u.Username From User u where IsActive = true and Profile.Name = 'System Administrator'];     
		System.runAs ( thisUser[0] ) { 
		
	    Account acc = new Account();
	    
	    List<Account> lstAccount = [Select a.Id From Account a limit 1];
	    
	    if(!lstAccount.isEmpty()){
	    	
	    acc = lstAccount[0];
	    
	    Patient_Custom__c pcObject = new Patient_Custom__c();
	    pcObject.Birthdate__c = date.newInstance(1980, 08, 05);
	    pcObject.Institution__c = acc.Id;
	    pcObject.Last_Name__c = 'test'; 
		pcObject.Gender__c = 'Male';
		pcObject.Race__c = 'White';
		pcObject.Ethnicity__c = 'Not Hispanic or Latino';
		pcObject.Email__c = thisUser[0].Username;
		pcObject.isPortalEnable__c = true;
	    insert pcObject;
	    
	    Trial__c tr = new Trial__c();
	    tr.Name = 'test';
	    insert tr;
	    
	    TrialPatient__c tp = new TrialPatient__c();
	    tp.Patient_Id__c = pcObject.Id;
	    tp.Trial_Id__c = tr.Id;
	    insert tp;
	    
	    Event eventObject = new Event();
	    eventObject.Trial__c = tr.Id;
	    eventObject.ActivityDateTime = datetime.newInstance(2014, 12, 1, 12, 30, 2); // year,month,day,hr,min,sec
	    eventObject.WhatId = acc.Id;
	    eventObject.OwnerId = thisUser[0].Id;
	    eventObject.Subject = 'test';
	    eventObject.DurationInMinutes = 300;
	    eventObject.Hours__c = 2.0;
	    eventObject.Minutes__c = 30.0;
	    eventObject.StartDateTime = datetime.newInstance(2014, 12, 1, 12, 30, 2);
	    insert eventObject;
	    update eventObject;
	    
	    Task tskObject = new Task();
	    tskObject.Trial_Id__c = tr.Id;
	    tskObject.WhatId = pcObject.Id;
	    tskObject.ActivityDate = date.newInstance(2012, 07, 07);
	    tskObject.Status = 'Completed';
	    tskObject.OwnerId = userinfo.getUserId();
	    tskObject.Subject = 'Call';
	    tskObject.Type = 'Schedule the patient for a core biopsy';
	    tskObject.Schedule_Event_Date__c = datetime.newInstance(2014, 12, 1, 12, 30, 2);
	    insert tskObject;
	    
	    Apexpages.currentPage().getParameters().put('id',pcObject.Id);
	    Apexpages.currentPage().getParameters().put('TrialId',tr.Id);
	    Apexpages.StandardController std = new Apexpages.StandardController(pcObject);
	    PhaseMaster pmObject = new PhaseMaster(std);
	    pmObject.selectedTrial = tr.Id;
	    pmObject.selectredioButton = 'All Appointments';
	    pmObject.getWrapList();	
	    
	    pmObject.selectedTaskOption = 'All';
	    pmObject.getLstTask();
	    
	    //======================method "completeTask()"begins here==================
	    
	    Apexpages.currentPage().getParameters().put('taskId',tskObject.Id);
	    
	    Event eventObject1 = new Event();
	    eventObject1.Trial__c = tr.Id;
	    eventObject1.ActivityDateTime = datetime.newInstance(2010, 12, 1, 12, 30, 2); // year,month,day,hr,min,sec
	    eventObject1.WhatId = acc.Id;
	    eventObject1.OwnerId = thisUser[0].Id;
	    eventObject1.Subject = 'test';
	    eventObject1.DurationInMinutes = 300;
	    eventObject1.Hours__c = null;
	    eventObject1.Minutes__c = null;
	    eventObject1.StartDateTime = datetime.newInstance(2010, 12, 1, 12, 30, 2);
	    insert eventObject1;
	    pmObject.event = eventObject1;
	    
	    pmObject.completeTask();
	    
	    pmObject.cancelCreateEvent();
	  }
	}
  }
  @isTest static void showCrf() {   //method "showCrf" begins here for "Screening".

		List<User> thisUser = [Select u.IsActive, u.Id, SecurityCode__c ,u.Patient_Id__c, u.ProfileId, u.Username From User u where IsActive = true and Profile.Name = 'System Administrator'];     
		System.runAs ( thisUser[0] ) { 
		
	    Account acc = new Account();
	    
	    List<Account> lstAccount = [Select a.Id From Account a limit 1];
	    
	    if(!lstAccount.isEmpty()){
	    	
	    acc = lstAccount[0];
	    
	    Patient_Custom__c pcObject = new Patient_Custom__c();
	    pcObject.Birthdate__c = date.newInstance(1980, 08, 05);
	    pcObject.Institution__c = acc.Id;
	    pcObject.Last_Name__c = 'test'; 
		pcObject.Gender__c = 'Male';
		pcObject.Race__c = 'White';
		pcObject.Ethnicity__c = 'Not Hispanic or Latino';
		pcObject.Email__c = thisUser[0].Username;
		pcObject.isPortalEnable__c = true;
	    insert pcObject;
	    
	    Trial__c tr = new Trial__c();
	    tr.Name = 'test';
	    insert tr;
	    
	    TrialPatient__c tp = new TrialPatient__c();
	    tp.Patient_Id__c = pcObject.Id;
	    tp.Trial_Id__c = tr.Id;
	    insert tp;
	    
	    Registration__c reg = new Registration__c();
        reg.Patient__c = pcObject.Id;
        reg.Registration_Date__c = System.today();
        reg.Trial__c = tr.Id;
        reg.TrialPatient__c = tp.Id;
        reg.Institution__c = acc.Id;
        reg.IRB_Approval_Date__c = System.today();
        reg.Screening_Informed_Consent_Date__c = System.today();
        reg.HIPPA_Consent_Date__c = System.today();
        reg.Effective_Time__c = system.now();
        reg.ISPY2_Subject_Id__c = ''+123;
        insert reg;
        
	    CRFMaster__c crf = new CRFMaster__c();
        crf.Object_Name__c = 'PreEligibility_Checklist__c';
        insert crf;
        
        Trial_CRF__c tc = new Trial_CRF__c();
        tc.Trial__c = tr.Id;
        tc.CRFMaster__c = crf.Id;
        insert tc;
	    
		Phase_Master__c pmc = new Phase_Master__c();
        pmc.Name = 'Screening';
        pmc.Order__c = 9.0;
        insert pmc;
        
        Phase_Cycle__c pcc = new Phase_Cycle__c();
        pcc.Phase__c = pmc.Id;
        pcc.Order__c = 9.0;
        insert pcc;
        
        Phase_CRFs__c pcrf = new Phase_CRFs__c();
        pcrf.Phase_Cycle__c = pcc.Id;
        pcrf.CRF__c = crf.Id;
        insert pcrf;	 
        
        Task tskObject = new Task();
	    tskObject.Trial_Id__c = tr.Id;
	    tskObject.Object_Name__c = crf.Object_Name__c;
	    tskObject.WhatId = pcObject.Id;
	    tskObject.ActivityDate = date.newInstance(2012, 07, 07);
	    tskObject.Status = 'Completed';
	    tskObject.OwnerId = userinfo.getUserId();
	    tskObject.Subject = 'Call';
	    tskObject.Type = 'Schedule the patient for a core biopsy';
	    tskObject.Schedule_Event_Date__c = datetime.newInstance(2014, 12, 1, 12, 30, 2);
	    insert tskObject;
           
	    Apexpages.currentPage().getParameters().put('id',pcObject.Id);
	    Apexpages.currentPage().getParameters().put('TrialId',tr.Id);
	    Apexpages.StandardController std = new Apexpages.StandardController(pcObject);
	    PhaseMaster pmObject = new PhaseMaster(std);
	    pmObject.selectedTrial = tr.Id;
	    
	    pmObject.showCrf();
	    
	    Apexpages.currentPage().getParameters().put('objectId',reg.Id);
        Apexpages.currentPage().getParameters().put('objectName','Registration__c');
	    pmObject.redirectTaskCRF();
	  }
    }
  }
  @isTest static void showCRF1() {   //method "showCrf" for "follow up".

		List<User> thisUser = [Select u.IsActive, u.Id, SecurityCode__c ,u.Patient_Id__c, u.ProfileId, u.Username From User u where IsActive = true and Profile.Name = 'System Administrator'];     
		System.runAs ( thisUser[0] ) { 
		
	    Account acc = new Account();
	    
	    List<Account> lstAccount = [Select a.Id From Account a limit 1];
	    
	    if(!lstAccount.isEmpty()){
	    	
	    acc = lstAccount[0];
	    
	    Patient_Custom__c pcObject = new Patient_Custom__c();
	    pcObject.Birthdate__c = date.newInstance(1980, 08, 05);
	    pcObject.Institution__c = acc.Id;
	    pcObject.Last_Name__c = 'test'; 
		pcObject.Gender__c = 'Male';
		pcObject.Race__c = 'White';
		pcObject.Ethnicity__c = 'Not Hispanic or Latino';
		pcObject.Email__c = thisUser[0].Username;
		pcObject.isPortalEnable__c = true;
	    insert pcObject;
	    
	    Trial__c tr = new Trial__c();
	    tr.Name = 'test';
	    insert tr;
	    
	    TrialPatient__c tp = new TrialPatient__c();
	    tp.Patient_Id__c = pcObject.Id;
	    tp.Trial_Id__c = tr.Id;
	    insert tp;
	    
	    Registration__c reg = new Registration__c();
        reg.Patient__c = pcObject.Id;
        reg.Registration_Date__c = System.today();
        reg.Trial__c = tr.Id;
        reg.TrialPatient__c = tp.Id;
        reg.Institution__c = acc.Id;
        reg.IRB_Approval_Date__c = System.today();
        reg.Screening_Informed_Consent_Date__c = System.today();
        reg.HIPPA_Consent_Date__c = System.today();
        reg.Effective_Time__c = system.now();
        reg.ISPY2_Subject_Id__c = ''+123;
        insert reg;
	    
	    CRFMaster__c crf = new CRFMaster__c();
        crf.Object_Name__c = 'MRI_Volume__c';
        insert crf;
        
        Trial_CRF__c tc = new Trial_CRF__c();
        tc.Trial__c = tr.Id;
        tc.CRFMaster__c = crf.Id;
        insert tc;
	    
		Phase_Master__c pmc = new Phase_Master__c();
        pmc.Name = 'Follow Up';
        pmc.Order__c = 9.0;
        insert pmc;
        
        Phase_Cycle__c pcc = new Phase_Cycle__c();
        pcc.Phase__c = pmc.Id;
        pcc.Order__c = 9.0;
        insert pcc;
        
        Phase_CRFs__c pcrf = new Phase_CRFs__c();
        pcrf.Phase_Cycle__c = pcc.Id;
        pcrf.CRF__c = crf.Id;
        insert pcrf;	 
        
        Task tskObject = new Task();
	    tskObject.Trial_Id__c = tr.Id;
	    tskObject.Object_Name__c = crf.Object_Name__c;
	    tskObject.WhatId = pcObject.Id;
	    tskObject.ActivityDate = date.newInstance(2012, 07, 07);
	    tskObject.Status = 'Completed';
	    tskObject.OwnerId = userinfo.getUserId();
	    tskObject.Subject = 'Call';
	    tskObject.Type = 'Schedule the patient for a core biopsy';
	    tskObject.Schedule_Event_Date__c = datetime.newInstance(2014, 12, 1, 12, 30, 2);
	    insert tskObject;
	    
	    On_Study_Pathology_Form__c osp = new On_Study_Pathology_Form__c();
        osp.TrialPatient__c = tp.Id;
        osp.Does_the_patient_have_bilateral_breast_c__c = 'Yes';
        osp.Tumor_laterality__c = 'Left';
        insert osp;
           
	    Apexpages.currentPage().getParameters().put('id',pcObject.Id);
	    Apexpages.currentPage().getParameters().put('TrialId',tr.Id);
	    Apexpages.StandardController std = new Apexpages.StandardController(pcObject);
	    PhaseMaster pmObject = new PhaseMaster(std);
	    pmObject.selectedTrial = tr.Id;
	    
	    pmObject.showCrf();
	    
	    Apexpages.currentPage().getParameters().put('objectId',osp.Id);
        Apexpages.currentPage().getParameters().put('objectName','On_Study_Pathology_Form__c');
	    pmObject.redirectTaskCRF();
	  }
    }
  }
  @isTest static void showCRF2() {   //method "showCrf" for "Treatment".

		List<User> thisUser = [Select u.IsActive, u.Id, SecurityCode__c ,u.Patient_Id__c, u.ProfileId, u.Username From User u where IsActive = true and Profile.Name = 'System Administrator'];     
		System.runAs ( thisUser[0] ) { 
		
	    Account acc = new Account();
	    
	    List<Account> lstAccount = [Select a.Id From Account a limit 1];
	    
	    if(!lstAccount.isEmpty()){
	    	
	    acc = lstAccount[0];
	    
	    Patient_Custom__c pcObject = new Patient_Custom__c();
	    pcObject.Birthdate__c = date.newInstance(1980, 08, 05);
	    pcObject.Institution__c = acc.Id;
	    pcObject.Last_Name__c = 'test'; 
		pcObject.Gender__c = 'Male';
		pcObject.Race__c = 'White';
		pcObject.Ethnicity__c = 'Not Hispanic or Latino';
		pcObject.Email__c = thisUser[0].Username;
		pcObject.isPortalEnable__c = true;
	    insert pcObject;
	    
	    Trial__c tr = new Trial__c();
	    tr.Name = 'test';
	    insert tr;
	    
	    TrialPatient__c tp = new TrialPatient__c();
	    tp.Patient_Id__c = pcObject.Id;
	    tp.Trial_Id__c = tr.Id;
	    insert tp;
	    
	    Registration__c reg = new Registration__c();
        reg.Patient__c = pcObject.Id;
        reg.Registration_Date__c = System.today();
        reg.Trial__c = tr.Id;
        reg.TrialPatient__c = tp.Id;
        reg.Institution__c = acc.Id;
        reg.IRB_Approval_Date__c = System.today();
        reg.Screening_Informed_Consent_Date__c = System.today();
        reg.HIPPA_Consent_Date__c = System.today();
        reg.Effective_Time__c = system.now();
        reg.ISPY2_Subject_Id__c = ''+123;
        insert reg;
	    
	    CRFMaster__c crf = new CRFMaster__c();
        crf.Object_Name__c = 'Registration__c';
        insert crf;
        
        Trial_CRF__c tc = new Trial_CRF__c();
        tc.Trial__c = tr.Id;
        tc.CRFMaster__c = crf.Id;
        insert tc;
	    
		Phase_Master__c pmc = new Phase_Master__c();
        pmc.Name = 'Treatment';
        pmc.Order__c = 9.0;
        insert pmc;
        
        Phase_Cycle__c pcc = new Phase_Cycle__c();
        pcc.Phase__c = pmc.Id;
        pcc.Order__c = 9.0;
        insert pcc;
        
        Phase_CRFs__c pcrf = new Phase_CRFs__c();
        pcrf.Phase_Cycle__c = pcc.Id;
        pcrf.CRF__c = crf.Id;
        insert pcrf;	 
        
        Task tskObject = new Task();
	    tskObject.Trial_Id__c = tr.Id;
	    tskObject.Object_Name__c = crf.Object_Name__c;
	    tskObject.WhatId = pcObject.Id;
	    tskObject.ActivityDate = date.newInstance(2012, 07, 07);
	    tskObject.Status = 'Completed';
	    tskObject.OwnerId = userinfo.getUserId();
	    tskObject.Subject = 'Call';
	    tskObject.Type = 'Schedule the patient for a core biopsy';
	    tskObject.Schedule_Event_Date__c = datetime.newInstance(2014, 12, 1, 12, 30, 2);
	    insert tskObject;
	    
	    PreEligibility_Checklist__c pec = new PreEligibility_Checklist__c();
        pec.Patient__c = pcObject.Id;
        insert pec; 
	    
	    Apexpages.currentPage().getParameters().put('id',pcObject.Id);
	    Apexpages.currentPage().getParameters().put('TrialId',tr.Id);
	    Apexpages.StandardController std = new Apexpages.StandardController(pcObject);
	    PhaseMaster pmObject = new PhaseMaster(std);
	    pmObject.selectedTrial = tr.Id;
	    
	    pmObject.showCrf();
	    
	    Apexpages.currentPage().getParameters().put('objectId',pec.Id);
        Apexpages.currentPage().getParameters().put('objectName','PreEligibility_Checklist__c');
	    pmObject.redirectTaskCRF();
	  }
    }
  }
  
  @isTest static void redirectNewPage1() {   //method "redirectNewPage" and "redirectTaskCRF"

		List<User> thisUser = [Select u.IsActive, u.Id, SecurityCode__c ,u.Patient_Id__c, u.ProfileId, u.Username From User u where IsActive = true and Profile.Name = 'System Administrator'];     
		System.runAs ( thisUser[0] ) { 
		
	    Account acc = new Account();
	    
	    List<Account> lstAccount = [Select a.Id From Account a limit 1];
	    
	    if(!lstAccount.isEmpty()){
	    	
	    acc = lstAccount[0];
	    
	    Patient_Custom__c pcObject = new Patient_Custom__c();
	    pcObject.Birthdate__c = date.newInstance(1980, 08, 05);
	    pcObject.Institution__c = acc.Id;
	    pcObject.Last_Name__c = 'test'; 
		pcObject.Gender__c = 'Male';
		pcObject.Race__c = 'White';
		pcObject.Ethnicity__c = 'Not Hispanic or Latino';
		pcObject.Email__c = thisUser[0].Username;
		pcObject.isPortalEnable__c = true;
	    insert pcObject;
	    
	    Trial__c tr = new Trial__c();
	    tr.Name = 'test';
	    insert tr;
	    
	    TrialPatient__c tp = new TrialPatient__c();
	    tp.Patient_Id__c = pcObject.Id;
	    tp.Trial_Id__c = tr.Id;
	    insert tp;
	    
	    Registration__c reg = new Registration__c();
        reg.Patient__c = pcObject.Id;
        reg.Registration_Date__c = System.today();
        reg.Trial__c = tr.Id;
        reg.TrialPatient__c = tp.Id;
        reg.Institution__c = acc.Id;
        reg.IRB_Approval_Date__c = System.today();
        reg.Screening_Informed_Consent_Date__c = System.today();
        reg.HIPPA_Consent_Date__c = System.today();
        reg.Status__c = 'Completed';
        reg.Effective_Time__c = system.now();
        reg.ISPY2_Subject_Id__c = ''+123;
        insert reg;
        
        InstitutionUser__c instuser = new InstitutionUser__c();
        instuser.User__c = userinfo.getUserId();
        instuser.Institution__c = pcObject.Institution__c;
        insert instuser; 
	    
        Task tskObject1 = new Task();
	    tskObject1.Trial_Id__c = tr.Id;
	    tskObject1.ActivityDate = date.newInstance(2012, 07, 07);
	    tskObject1.Status = 'Completed';
	    tskObject1.OwnerId = userinfo.getUserId();
	    tskObject1.WhatId = pcObject.Id; 
	    tskObject1.Subject = 'Call';
	    tskObject1.Type = 'Schedule a clinic appointment';
	    tskObject1.Schedule_Event_Date__c = datetime.newInstance(2014, 12, 1, 12, 30, 2);
	    insert tskObject1;
           
	    Apexpages.currentPage().getParameters().put('id',pcObject.Id);
	    Apexpages.currentPage().getParameters().put('TrialId',tr.Id);
	    Apexpages.StandardController std = new Apexpages.StandardController(pcObject);
	    PhaseMaster pmObject = new PhaseMaster(std);
	    pmObject.selectedTrial = tr.Id;
	    
	    pmObject.selectedTaskOption = 'Completed';
	    pmObject.getLstTask();
	    
	    Apexpages.currentPage().getParameters().put('taskId',tskObject1.Id);
	    
	    Event eventObject = new Event();
	    eventObject.Trial__c = tr.Id;
	    eventObject.ActivityDateTime = datetime.newInstance(2010, 12, 1, 12, 30, 2); // year,month,day,hr,min,sec
	    eventObject.WhatId = acc.Id;
	    eventObject.OwnerId = thisUser[0].Id;
	    eventObject.Subject = 'test';
	    eventObject.DurationInMinutes = 300;
	    eventObject.Hours__c = null;
	    eventObject.Minutes__c = null;
	    eventObject.StartDateTime = datetime.newInstance(2010, 12, 1, 12, 30, 2);
	    insert eventObject;
	    pmObject.event = eventObject;
	    
	    pmObject.completeTask();
	    
	    Apexpages.currentPage().getParameters().put('objectName','Registration__c');
        Apexpages.currentPage().getParameters().put('objectId',reg.Id);
        pmObject.selectedTrial = tr.Id;
        pmObject.redirectNewPage(); 
        
	    Apexpages.currentPage().getParameters().put('objectName', 'Menopausal_Status_Detail__c');
        pmObject.redirectNewPage();
        Apexpages.currentPage().getParameters().put('objectName', 'TissueSpecimenDetail__c');
        pmObject.redirectNewPage();
        pmObject.redirectTaskCRF();
        Apexpages.currentPage().getParameters().put('objectName', 'BaselineSymptomsForm__c');
        pmObject.redirectNewPage();
        pmObject.redirectTaskCRF();
        Apexpages.currentPage().getParameters().put('objectName', 'Chemo_Treatment__c');
        pmObject.redirectNewPage();
        pmObject.redirectTaskCRF();
        Apexpages.currentPage().getParameters().put('objectName', 'Chemo_Summary_Form__c');
        pmObject.redirectNewPage();
	    pmObject.redirectTaskCRF();
	    
	  }
    }
  }
  @isTest static void redirectNewPage2() {   //method "redirectNewPage" and "redirectTaskCRF"

		List<User> thisUser = [Select u.IsActive, u.Id, SecurityCode__c ,u.Patient_Id__c, u.ProfileId, u.Username From User u where IsActive = true and Profile.Name = 'System Administrator'];     
		System.runAs ( thisUser[0] ) { 
		
	    Account acc = new Account();
	    
	    List<Account> lstAccount = [Select a.Id From Account a limit 1];
	    
	    if(!lstAccount.isEmpty()){
	    	
	    acc = lstAccount[0];
	    
	    Patient_Custom__c pcObject = new Patient_Custom__c();
	    pcObject.Birthdate__c = date.newInstance(1980, 08, 05);
	    pcObject.Institution__c = acc.Id;
	    pcObject.Last_Name__c = 'test'; 
		pcObject.Gender__c = 'Male';
		pcObject.Race__c = 'White';
		pcObject.Ethnicity__c = 'Not Hispanic or Latino';
		pcObject.Email__c = thisUser[0].Username;
		pcObject.isPortalEnable__c = true;
	    insert pcObject;
	    
	    Trial__c tr = new Trial__c();
	    tr.Name = 'test';
	    insert tr;
	    
	    TrialPatient__c tp = new TrialPatient__c();
	    tp.Patient_Id__c = pcObject.Id;
	    tp.Trial_Id__c = tr.Id;
	    insert tp;
	    
	    Registration__c reg = new Registration__c();
        reg.Patient__c = pcObject.Id;
        reg.Registration_Date__c = System.today();
        reg.Trial__c = tr.Id;
        reg.TrialPatient__c = tp.Id;
        reg.Institution__c = acc.Id;
        reg.IRB_Approval_Date__c = System.today();
        reg.Screening_Informed_Consent_Date__c = System.today();
        reg.HIPPA_Consent_Date__c = System.today();
        reg.Status__c = 'Completed';
        reg.Effective_Time__c = system.now();
        reg.ISPY2_Subject_Id__c = ''+123;
        insert reg;
        
        InstitutionUser__c instuser = new InstitutionUser__c();
        instuser.User__c = userinfo.getUserId();
        instuser.Institution__c = pcObject.Institution__c;
        insert instuser; 
	    
        Task tskObject1 = new Task();
	    tskObject1.Trial_Id__c = tr.Id;
	    tskObject1.ActivityDate = date.newInstance(2012, 07, 07);
	    tskObject1.Status = 'Completed';
	    tskObject1.OwnerId = userinfo.getUserId();
	    tskObject1.WhatId = pcObject.Id; 
	    tskObject1.Subject = 'Call';
	    tskObject1.Type = 'Schedule a clinic appointment';
	    tskObject1.Schedule_Event_Date__c = datetime.newInstance(2014, 12, 1, 12, 30, 2);
	    insert tskObject1;
           
	    Apexpages.currentPage().getParameters().put('id',pcObject.Id);
	    Apexpages.currentPage().getParameters().put('TrialId',tr.Id);
	    Apexpages.StandardController std = new Apexpages.StandardController(pcObject);
	    PhaseMaster pmObject = new PhaseMaster(std);
	    pmObject.selectedTrial = tr.Id;
	    
	    pmObject.selectedTaskOption = 'Completed';
	    pmObject.getLstTask();
	    
	    Apexpages.currentPage().getParameters().put('taskId',tskObject1.Id);
	    
	    Event eventObject = new Event();
	    eventObject.Trial__c = tr.Id;
	    eventObject.ActivityDateTime = datetime.newInstance(2010, 12, 1, 12, 30, 2); // year,month,day,hr,min,sec
	    eventObject.WhatId = acc.Id;
	    eventObject.OwnerId = thisUser[0].Id;
	    eventObject.Subject = 'test';
	    eventObject.DurationInMinutes = 300;
	    eventObject.Hours__c = null;
	    eventObject.Minutes__c = null;
	    eventObject.StartDateTime = datetime.newInstance(2010, 12, 1, 12, 30, 2);
	    insert eventObject;
	    pmObject.event = eventObject;
	    
	    pmObject.completeTask();
	    
	    Apexpages.currentPage().getParameters().put('objectName','Registration__c');
        Apexpages.currentPage().getParameters().put('objectId',reg.Id);
        pmObject.selectedTrial = tr.Id;
        pmObject.redirectNewPage(); 
	    
	    Apexpages.currentPage().getParameters().put('objectName','Response_Evaluation_Form__c'); 
        pmObject.redirectNewPage();  
        
        Apexpages.currentPage().getParameters().put('objectName','BloodSpecimenForm__c'); 
        pmObject.redirectNewPage();  
        
        Apexpages.currentPage().getParameters().put('objectName','Lab_and_Test__c'); 
        pmObject.redirectNewPage();  
        
        Apexpages.currentPage().getParameters().put('objectName','Off_Study_Detail__c'); 
        pmObject.redirectNewPage();  
        
        Apexpages.currentPage().getParameters().put('objectName','Followup_Form__c'); 
        pmObject.redirectNewPage();  
        
        Apexpages.currentPage().getParameters().put('objectName','Lost_to_Follow_Up__c'); 
        pmObject.redirectNewPage();
        
        Apexpages.currentPage().getParameters().put('objectName','No_Longer_lost_to_Followup__c'); 
        pmObject.redirectNewPage();    
	  }
    }
  }
   @isTest static void redirectNewPage3() { //method "redirectNewPage" 
        // TO DO: implement unit test
        
        Profile SiteProp = [ Select p.UserType, p.Name, (Select u.IsActive, u.Id From Users u where IsActive = true) From Profile p where Name = 'System Administrator'];
        List<User> lstSiteUser = SiteProp.Users;     
        System.runAs ( lstSiteUser[0] ) { 
            
        Account accObj = new Account();
    	List<Site_Trial__c> lstSiteTrial = [Select s.Trial__c, s.Site__r.Institute__c, s.Site__c From Site_Trial__c s limit 1];
    
        if(!lstSiteTrial.isEmpty()){
	    	
        List<Account> lstAccount = [Select a.RecordType.Name, a.RecordTypeId, a.Id From Account a where Id =:lstSiteTrial[0].Site__r.Institute__c]; 
        accObj = lstAccount[0];                                 // newly added logic to overcome the error of "setup and nonsetup" object
        
        Patient_Custom__c p = new Patient_Custom__c();
        p.Birthdate__c = date.newInstance(1960, 8, 7);
        p.Signed_Screening__c = true;
        p.Ethnicity__c = 'Hispanic or latino';
        p.Gender__c = 'female';
        p.Race__c = 'asian';
        p.First_Name__c = 'test';
        p.Last_Name__c = 'kumar';
        p.Zip__c = '12';
        p.Middle_Name__c = 'testing';
        p.Institute_Text__c = 'asc';
        p.Institution__c = accObj.Id;
        p.Medical_Record_Number__c = '1234';
        insert p;
        
        TrialPatient__c tp = new TrialPatient__c();
        tp.FirstName__c = 'a';
        tp.LastName__c = 'b';
        tp.Patient_Id__c = p.Id;
        tp.Trial_Id__c = lstSiteTrial[0].Trial__c;
        insert tp;
        
        Registration__c reg = new Registration__c();
        reg.Patient__c = p.Id;
        reg.Registration_Date__c = System.today();
        reg.Trial__c = lstSiteTrial[0].Trial__c;
        reg.TrialPatient__c = tp.Id;
        reg.Institution__c = accObj.Id;
        reg.IRB_Approval_Date__c = System.today();
        reg.Screening_Informed_Consent_Date__c = System.today();
        reg.HIPPA_Consent_Date__c = System.today();
        reg.Status__c = 'Completed';
        reg.Effective_Time__c = system.now();
        reg.ISPY2_Subject_Id__c = ''+123;
        insert reg;
        
        PreEligibility_Checklist__c pec = new PreEligibility_Checklist__c();
        pec.Patient__c = p.Id;
        insert pec; 
        
        Apexpages.currentPage().getParameters().put('id',p.Id);
        Apexpages.currentPage().getParameters().put('TrialId',lstSiteTrial[0].Trial__c);
        Apexpages.StandardController std = new Apexpages.StandardController(p);
        PhaseMaster pm = new PhaseMaster(std);
        
        Apexpages.currentPage().getParameters().put('objectName','Registration__c');
        Apexpages.currentPage().getParameters().put('objectId',reg.Id);
        pm.selectedTrial = lstSiteTrial[0].Trial__c;
        pm.redirectNewPage();
      }
   }
 }
 
 @isTest static void redirectNewPage7() { //method "redirectNewPage" 
        // TO DO: implement unit test
        
        Profile SiteProp = [ Select p.UserType, p.Name, (Select u.IsActive, u.Id From Users u where IsActive = true) From Profile p where Name = 'System Administrator'];
        List<User> lstSiteUser = SiteProp.Users;     
        System.runAs ( lstSiteUser[0] ) { 
            
        Account accObj = new Account();
    	List<Site_Trial__c> lstSiteTrial = [Select s.Trial__c, s.Site__r.Institute__c, s.Site__c From Site_Trial__c s limit 1];
    
        if(!lstSiteTrial.isEmpty()){
	    	
        List<Account> lstAccount = [Select a.RecordType.Name, a.RecordTypeId, a.Id From Account a where Id =:lstSiteTrial[0].Site__r.Institute__c]; 
        accObj = lstAccount[0];                                 // newly added logic to overcome the error of "setup and nonsetup" object
        
        Patient_Custom__c p = new Patient_Custom__c();
        p.Birthdate__c = date.newInstance(1960, 8, 7);
        p.Signed_Screening__c = true;
        p.Ethnicity__c = 'Hispanic or latino';
        p.Gender__c = 'female';
        p.Race__c = 'asian';
        p.First_Name__c = 'test';
        p.Last_Name__c = 'kumar';
        p.Zip__c = '12';
        p.Middle_Name__c = 'testing';
        p.Institute_Text__c = 'asc';
        p.Institution__c = accObj.Id;
        p.Medical_Record_Number__c = '1234';
        insert p;
        
        TrialPatient__c tp = new TrialPatient__c();
        tp.FirstName__c = 'a';
        tp.LastName__c = 'b';
        tp.Patient_Id__c = p.Id;
        tp.Trial_Id__c = lstSiteTrial[0].Trial__c;
        insert tp;
        
        Registration__c reg = new Registration__c();
        reg.Patient__c = p.Id;
        reg.Registration_Date__c = System.today();
        reg.Trial__c = lstSiteTrial[0].Trial__c;
        reg.TrialPatient__c = tp.Id;
        reg.Institution__c = accObj.Id;
        reg.IRB_Approval_Date__c = System.today();
        reg.Screening_Informed_Consent_Date__c = System.today();
        reg.HIPPA_Consent_Date__c = System.today();
        reg.Status__c = 'Completed';
        reg.Effective_Time__c = system.now();
        reg.ISPY2_Subject_Id__c = ''+123;
        insert reg;
        
        PreEligibility_Checklist__c pec = new PreEligibility_Checklist__c();
        pec.Patient__c = p.Id;
        insert pec; 
        
        Apexpages.currentPage().getParameters().put('id',p.Id);
        Apexpages.currentPage().getParameters().put('TrialId',lstSiteTrial[0].Trial__c);
        Apexpages.StandardController std = new Apexpages.StandardController(p);
        PhaseMaster pm = new PhaseMaster(std);

        Apexpages.currentPage().getParameters().put('objectName','TissueSpecimenDetail__c'); 
        pm.selectedTrial = lstSiteTrial[0].Trial__c;
        pm.redirectNewPage();  
      }
   }
 }
 
 @isTest static void redirectNewPage5() { //method "redirectNewPage" 
        // TO DO: implement unit test
        
        Profile SiteProp = [ Select p.UserType, p.Name, (Select u.IsActive, u.Id From Users u where IsActive = true) From Profile p where Name = 'System Administrator'];
        List<User> lstSiteUser = SiteProp.Users;     
        System.runAs ( lstSiteUser[0] ) { 
            
        Account accObj = new Account();
    	List<Site_Trial__c> lstSiteTrial = [Select s.Trial__c, s.Site__r.Institute__c, s.Site__c From Site_Trial__c s limit 1];
    
        if(!lstSiteTrial.isEmpty()){
	    	
        List<Account> lstAccount = [Select a.RecordType.Name, a.RecordTypeId, a.Id From Account a where Id =:lstSiteTrial[0].Site__r.Institute__c]; 
        accObj = lstAccount[0];                                 // newly added logic to overcome the error of "setup and nonsetup" object
        
        Patient_Custom__c p = new Patient_Custom__c();
        p.Birthdate__c = date.newInstance(1960, 8, 7);
        p.Ethnicity__c = 'Hispanic or latino';
        p.Gender__c = 'female';
        p.Race__c = 'asian';
        p.Last_Name__c = 'kumar';
        p.Institution__c = accObj.Id;
        insert p;
        
        TrialPatient__c tp = new TrialPatient__c();
        tp.Patient_Id__c = p.Id;
        tp.Trial_Id__c = lstSiteTrial[0].Trial__c;
        insert tp;
        
        Registration__c reg = new Registration__c();
        reg.Patient__c = p.Id;
        reg.Registration_Date__c = System.today();
        reg.Trial__c = lstSiteTrial[0].Trial__c;
        reg.TrialPatient__c = tp.Id;
        reg.Institution__c = accObj.Id;
        reg.IRB_Approval_Date__c = System.today();
        reg.Screening_Informed_Consent_Date__c = System.today();
        reg.HIPPA_Consent_Date__c = System.today();
        reg.Status__c = 'Completed';
        reg.Effective_Time__c = system.now();
        reg.ISPY2_Subject_Id__c = ''+123;
        insert reg;
        
        Apexpages.currentPage().getParameters().put('id',p.Id);
        Apexpages.currentPage().getParameters().put('TrialId',lstSiteTrial[0].Trial__c);
        Apexpages.StandardController std = new Apexpages.StandardController(p);
        PhaseMaster pm = new PhaseMaster(std);
        
        Apexpages.currentPage().getParameters().put('objectId',reg.Id);
        Apexpages.currentPage().getParameters().put('objectName','PreEligibility_Checklist__c'); 
        pm.redirectNewPage();
      }
   }
 }
 
  @isTest static void redirectNewPage10() { //method "redirectNewPage" 
        // TO DO: implement unit test
        
        Profile SiteProp = [ Select p.UserType, p.Name, (Select u.IsActive, u.Id From Users u where IsActive = true) From Profile p where Name = 'System Administrator'];
        List<User> lstSiteUser = SiteProp.Users;     
        System.runAs ( lstSiteUser[0] ) { 
            
        Account accObj = new Account();
    	List<Site_Trial__c> lstSiteTrial = [Select s.Trial__c, s.Site__r.Institute__c, s.Site__c From Site_Trial__c s limit 1];
    
        if(!lstSiteTrial.isEmpty()){
	    	
        List<Account> lstAccount = [Select a.RecordType.Name, a.RecordTypeId, a.Id From Account a where Id =:lstSiteTrial[0].Site__r.Institute__c]; 
        accObj = lstAccount[0];                                 // newly added logic to overcome the error of "setup and nonsetup" object
        
        Patient_Custom__c p = new Patient_Custom__c();
        p.Birthdate__c = date.newInstance(1960, 8, 7);
        p.Signed_Screening__c = true;
        p.Ethnicity__c = 'Hispanic or latino';
        p.Gender__c = 'female';
        p.Race__c = 'asian';
        p.First_Name__c = 'test';
        p.Last_Name__c = 'kumar';
        p.Zip__c = '12';
        p.Middle_Name__c = 'testing';
        p.Institute_Text__c = 'asc';
        p.Institution__c = accObj.Id;
        p.Medical_Record_Number__c = '1234';
        insert p;
        
        TrialPatient__c tp = new TrialPatient__c();
        tp.FirstName__c = 'a';
        tp.LastName__c = 'b';
        tp.Patient_Id__c = p.Id;
        tp.Trial_Id__c = lstSiteTrial[0].Trial__c;
        insert tp;
        
        Registration__c reg = new Registration__c();
        reg.Patient__c = p.Id;
        reg.Registration_Date__c = System.today();
        reg.Trial__c = lstSiteTrial[0].Trial__c;
        reg.TrialPatient__c = tp.Id;
        reg.Institution__c = accObj.Id;
        reg.IRB_Approval_Date__c = System.today();
        reg.Screening_Informed_Consent_Date__c = System.today();
        reg.HIPPA_Consent_Date__c = System.today();
        reg.Status__c = 'Completed';
        reg.Effective_Time__c = system.now();
        reg.ISPY2_Subject_Id__c = ''+123;
        insert reg;
        
        PreEligibility_Checklist__c pec = new PreEligibility_Checklist__c();
        pec.Patient__c = p.Id;
        insert pec; 
        
        Apexpages.currentPage().getParameters().put('id',p.Id);
        Apexpages.currentPage().getParameters().put('TrialId',lstSiteTrial[0].Trial__c);
        Apexpages.StandardController std = new Apexpages.StandardController(p);
        PhaseMaster pm = new PhaseMaster(std);
        
        Apexpages.currentPage().getParameters().put('objectId',reg.Id);
        Apexpages.currentPage().getParameters().put('objectName','PreEligibility_Checklist__c'); 
        pm.redirectNewPage();
      }
   }
 }
 
 @isTest static void redirectNewPage4() { //method "redirectNewPage" 
        // TO DO: implement unit test
        
        Profile SiteProp = [ Select p.UserType, p.Name, (Select u.IsActive, u.Id From Users u where IsActive = true) From Profile p where Name = 'System Administrator'];
        List<User> lstSiteUser = SiteProp.Users;     
        System.runAs ( lstSiteUser[0] ) { 
            
        Account accObj = new Account();
    	List<Site_Trial__c> lstSiteTrial = [Select s.Trial__c, s.Site__r.Institute__c, s.Site__c From Site_Trial__c s limit 1];
    
        if(!lstSiteTrial.isEmpty()){
	    	
        List<Account> lstAccount = [Select a.RecordType.Name, a.RecordTypeId, a.Id From Account a where Id =:lstSiteTrial[0].Site__r.Institute__c]; 
        accObj = lstAccount[0];                                 // newly added logic to overcome the error of "setup and nonsetup" object
        
        Patient_Custom__c p = new Patient_Custom__c();
        p.Birthdate__c = date.newInstance(1960, 8, 7);
        p.Signed_Screening__c = true;
        p.Ethnicity__c = 'Hispanic or latino';
        p.Gender__c = 'female';
        p.Race__c = 'asian';
        p.First_Name__c = 'test';
        p.Last_Name__c = 'kumar';
        p.Zip__c = '12';
        p.Middle_Name__c = 'testing';
        p.Institute_Text__c = 'asc';
        p.Institution__c = accObj.Id;
        p.Medical_Record_Number__c = '1234';
        insert p;
        
        TrialPatient__c tp = new TrialPatient__c();
        tp.FirstName__c = 'a';
        tp.LastName__c = 'b';
        tp.Patient_Id__c = p.Id;
        tp.Trial_Id__c = lstSiteTrial[0].Trial__c;
        insert tp;
        
        Registration__c reg = new Registration__c();
        reg.Patient__c = p.Id;
        reg.Registration_Date__c = System.today();
        reg.Trial__c = lstSiteTrial[0].Trial__c;
        reg.TrialPatient__c = tp.Id;
        reg.Institution__c = accObj.Id;
        reg.IRB_Approval_Date__c = System.today();
        reg.Screening_Informed_Consent_Date__c = System.today();
        reg.HIPPA_Consent_Date__c = System.today();
        reg.Status__c = 'Completed';
        reg.Effective_Time__c = system.now();
        reg.ISPY2_Subject_Id__c = ''+123;
        insert reg;
        
        PreEligibility_Checklist__c pec = new PreEligibility_Checklist__c();
        pec.Patient__c = p.Id;
        insert pec; 
        
        Apexpages.currentPage().getParameters().put('id',p.Id);
        Apexpages.currentPage().getParameters().put('TrialId',lstSiteTrial[0].Trial__c);
        Apexpages.StandardController std = new Apexpages.StandardController(p);
        PhaseMaster pm = new PhaseMaster(std);
        
        Apexpages.currentPage().getParameters().put('objectName','MammaPrintDetail__c'); 
        pm.selectedTrial = lstSiteTrial[0].Trial__c;
        pm.redirectNewPage();  
        
      }
   }
 }
  @isTest static void redirectNewPage4New() { //method "redirectNewPage" 
        // TO DO: implement unit test
        
        Profile SiteProp = [ Select p.UserType, p.Name, (Select u.IsActive, u.Id From Users u where IsActive = true) From Profile p where Name = 'System Administrator'];
        List<User> lstSiteUser = SiteProp.Users;     
        System.runAs ( lstSiteUser[0] ) { 
            
        Account accObj = new Account();
    	List<Site_Trial__c> lstSiteTrial = [Select s.Trial__c, s.Site__r.Institute__c, s.Site__c From Site_Trial__c s limit 1];
    
        if(!lstSiteTrial.isEmpty()){
	    	
        List<Account> lstAccount = [Select a.RecordType.Name, a.RecordTypeId, a.Id From Account a where Id =:lstSiteTrial[0].Site__r.Institute__c]; 
        accObj = lstAccount[0];                                 // newly added logic to overcome the error of "setup and nonsetup" object
        
        Patient_Custom__c p = new Patient_Custom__c();
        p.Birthdate__c = date.newInstance(1960, 8, 7);
        p.Signed_Screening__c = true;
        p.Ethnicity__c = 'Hispanic or latino';
        p.Gender__c = 'female';
        p.Race__c = 'asian';
        p.First_Name__c = 'test';
        p.Last_Name__c = 'kumar';
        p.Zip__c = '12';
        p.Middle_Name__c = 'testing';
        p.Institute_Text__c = 'asc';
        p.Institution__c = accObj.Id;
        p.Medical_Record_Number__c = '1234';
        insert p;
        
        TrialPatient__c tp = new TrialPatient__c();
        tp.FirstName__c = 'a';
        tp.LastName__c = 'b';
        tp.Patient_Id__c = p.Id;
        tp.Trial_Id__c = lstSiteTrial[0].Trial__c;
        insert tp;
        
        Registration__c reg = new Registration__c();
        reg.Patient__c = p.Id;
        reg.Registration_Date__c = System.today();
        reg.Trial__c = lstSiteTrial[0].Trial__c;
        reg.TrialPatient__c = tp.Id;
        reg.Institution__c = accObj.Id;
        reg.IRB_Approval_Date__c = System.today();
        reg.Screening_Informed_Consent_Date__c = System.today();
        reg.HIPPA_Consent_Date__c = System.today();
        reg.Status__c = 'Completed';
        reg.Effective_Time__c = system.now();
        reg.ISPY2_Subject_Id__c = ''+123;
        insert reg;
        
        PreEligibility_Checklist__c pec = new PreEligibility_Checklist__c();
        pec.Patient__c = p.Id;
        insert pec; 
        
        Apexpages.currentPage().getParameters().put('id',p.Id);
        Apexpages.currentPage().getParameters().put('TrialId',lstSiteTrial[0].Trial__c);
        Apexpages.StandardController std = new Apexpages.StandardController(p);
        PhaseMaster pm = new PhaseMaster(std);
        
        pm.selectedTrial = lstSiteTrial[0].Trial__c;
        
        Apexpages.currentPage().getParameters().put('objectName','ProtocolViolationDetail__c'); 
        pm.redirectNewPage();  
      }
   }
 }
 
  @isTest static void redirectNewPage9() { //method "redirectNewPage" 
        // TO DO: implement unit test
        
        Profile SiteProp = [ Select p.UserType, p.Name, (Select u.IsActive, u.Id From Users u where IsActive = true) From Profile p where Name = 'System Administrator'];
        List<User> lstSiteUser = SiteProp.Users;     
        System.runAs ( lstSiteUser[0] ) { 
            
        Account accObj = new Account();
    	List<Site_Trial__c> lstSiteTrial = [Select s.Trial__c, s.Site__r.Institute__c, s.Site__c From Site_Trial__c s limit 1];
    
        if(!lstSiteTrial.isEmpty()){
	    	
        List<Account> lstAccount = [Select a.RecordType.Name, a.RecordTypeId, a.Id From Account a where Id =:lstSiteTrial[0].Site__r.Institute__c]; 
        accObj = lstAccount[0];                                 // newly added logic to overcome the error of "setup and nonsetup" object
        
        Patient_Custom__c p = new Patient_Custom__c();
        p.Birthdate__c = date.newInstance(1960, 8, 7);
        p.Signed_Screening__c = true;
        p.Ethnicity__c = 'Hispanic or latino';
        p.Gender__c = 'female';
        p.Race__c = 'asian';
        p.First_Name__c = 'test';
        p.Last_Name__c = 'kumar';
        p.Zip__c = '12';
        p.Middle_Name__c = 'testing';
        p.Institute_Text__c = 'asc';
        p.Institution__c = accObj.Id;
        p.Medical_Record_Number__c = '1234';
        insert p;
        
        TrialPatient__c tp = new TrialPatient__c();
        tp.FirstName__c = 'a';
        tp.LastName__c = 'b';
        tp.Patient_Id__c = p.Id;
        tp.Trial_Id__c = lstSiteTrial[0].Trial__c;
        insert tp;
        
        Registration__c reg = new Registration__c();
        reg.Patient__c = p.Id;
        reg.Registration_Date__c = System.today();
        reg.Trial__c = lstSiteTrial[0].Trial__c;
        reg.TrialPatient__c = tp.Id;
        reg.Institution__c = accObj.Id;
        reg.IRB_Approval_Date__c = System.today();
        reg.Screening_Informed_Consent_Date__c = System.today();
        reg.HIPPA_Consent_Date__c = System.today();
        reg.Status__c = 'Completed';
        reg.Effective_Time__c = system.now();
        reg.ISPY2_Subject_Id__c = ''+123;
        insert reg;
        
        PreEligibility_Checklist__c pec = new PreEligibility_Checklist__c();
        pec.Patient__c = p.Id;
        insert pec; 
        
        Apexpages.currentPage().getParameters().put('id',p.Id);
        Apexpages.currentPage().getParameters().put('TrialId',lstSiteTrial[0].Trial__c);
        Apexpages.StandardController std = new Apexpages.StandardController(p);
        PhaseMaster pm = new PhaseMaster(std);

        Apexpages.currentPage().getParameters().put('objectName','MammaPrintDetail__c'); 
        pm.selectedTrial = lstSiteTrial[0].Trial__c;
        pm.redirectNewPage();  
        
      }
   }
 }
 @isTest static void redirectNewPage9New() { //method "redirectNewPage" 
        // TO DO: implement unit test
        
        Profile SiteProp = [ Select p.UserType, p.Name, (Select u.IsActive, u.Id From Users u where IsActive = true) From Profile p where Name = 'System Administrator'];
        List<User> lstSiteUser = SiteProp.Users;     
        System.runAs ( lstSiteUser[0] ) { 
            
        Account accObj = new Account();
    	List<Site_Trial__c> lstSiteTrial = [Select s.Trial__c, s.Site__r.Institute__c, s.Site__c From Site_Trial__c s limit 1];
    
        if(!lstSiteTrial.isEmpty()){
	    	
        List<Account> lstAccount = [Select a.RecordType.Name, a.RecordTypeId, a.Id From Account a where Id =:lstSiteTrial[0].Site__r.Institute__c]; 
        accObj = lstAccount[0];                                 // newly added logic to overcome the error of "setup and nonsetup" object
        
        Patient_Custom__c p = new Patient_Custom__c();
        p.Birthdate__c = date.newInstance(1960, 8, 7);
        p.Signed_Screening__c = true;
        p.Ethnicity__c = 'Hispanic or latino';
        p.Gender__c = 'female';
        p.Race__c = 'asian';
        p.First_Name__c = 'test';
        p.Last_Name__c = 'kumar';
        p.Zip__c = '12';
        p.Middle_Name__c = 'testing';
        p.Institute_Text__c = 'asc';
        p.Institution__c = accObj.Id;
        p.Medical_Record_Number__c = '1234';
        insert p;
        
        TrialPatient__c tp = new TrialPatient__c();
        tp.FirstName__c = 'a';
        tp.LastName__c = 'b';
        tp.Patient_Id__c = p.Id;
        tp.Trial_Id__c = lstSiteTrial[0].Trial__c;
        insert tp;
        
        Registration__c reg = new Registration__c();
        reg.Patient__c = p.Id;
        reg.Registration_Date__c = System.today();
        reg.Trial__c = lstSiteTrial[0].Trial__c;
        reg.TrialPatient__c = tp.Id;
        reg.Institution__c = accObj.Id;
        reg.IRB_Approval_Date__c = System.today();
        reg.Screening_Informed_Consent_Date__c = System.today();
        reg.HIPPA_Consent_Date__c = System.today();
        reg.Status__c = 'Completed';
        reg.Effective_Time__c = system.now();
        reg.ISPY2_Subject_Id__c = ''+123;
        insert reg;
        
        PreEligibility_Checklist__c pec = new PreEligibility_Checklist__c();
        pec.Patient__c = p.Id;
        insert pec; 
        
        Apexpages.currentPage().getParameters().put('id',p.Id);
        Apexpages.currentPage().getParameters().put('TrialId',lstSiteTrial[0].Trial__c);
        Apexpages.StandardController std = new Apexpages.StandardController(p);
        PhaseMaster pm = new PhaseMaster(std);

        pm.selectedTrial = lstSiteTrial[0].Trial__c;
        Apexpages.currentPage().getParameters().put('objectName','ProtocolViolationDetail__c'); 
        pm.redirectNewPage();  
      }
   }
 }
 
 @isTest static void redirectNewPage6() { //method "redirectNewPage" 
        // TO DO: implement unit test
        
        Profile SiteProp = [ Select p.UserType, p.Name, (Select u.IsActive, u.Id From Users u where IsActive = true) From Profile p where Name = 'System Administrator'];
        List<User> lstSiteUser = SiteProp.Users;     
        System.runAs ( lstSiteUser[0] ) { 
            
        Account accObj = new Account();
    	List<Site_Trial__c> lstSiteTrial = [Select s.Trial__c, s.Site__r.Institute__c, s.Site__c From Site_Trial__c s limit 1];
    
        if(!lstSiteTrial.isEmpty()){
	    	
        List<Account> lstAccount = [Select a.RecordType.Name, a.RecordTypeId, a.Id From Account a where Id =:lstSiteTrial[0].Site__r.Institute__c]; 
        accObj = lstAccount[0];                                 // newly added logic to overcome the error of "setup and nonsetup" object
        
        Patient_Custom__c p = new Patient_Custom__c();
        p.Birthdate__c = date.newInstance(1960, 8, 7);
        p.Signed_Screening__c = true;
        p.Ethnicity__c = 'Hispanic or latino';
        p.Gender__c = 'female';
        p.Race__c = 'asian';
        p.First_Name__c = 'test';
        p.Last_Name__c = 'kumar';
        p.Zip__c = '12';
        p.Middle_Name__c = 'testing';
        p.Institute_Text__c = 'asc';
        p.Institution__c = accObj.Id;
        p.Medical_Record_Number__c = '1234';
        insert p;
        
        TrialPatient__c tp = new TrialPatient__c();
        tp.FirstName__c = 'a';
        tp.LastName__c = 'b';
        tp.Patient_Id__c = p.Id;
        tp.Trial_Id__c = lstSiteTrial[0].Trial__c;
        insert tp;
        
        Registration__c reg = new Registration__c();
        reg.Patient__c = p.Id;
        reg.Registration_Date__c = System.today();
        reg.Trial__c = lstSiteTrial[0].Trial__c;
        reg.TrialPatient__c = tp.Id;
        reg.Institution__c = accObj.Id;
        reg.IRB_Approval_Date__c = System.today();
        reg.Screening_Informed_Consent_Date__c = System.today();
        reg.HIPPA_Consent_Date__c = System.today();
        reg.Status__c = 'Completed';
        reg.Effective_Time__c = system.now();
        reg.ISPY2_Subject_Id__c = ''+123;
        insert reg;
        
        Apexpages.currentPage().getParameters().put('id',p.Id);
        Apexpages.currentPage().getParameters().put('TrialId',lstSiteTrial[0].Trial__c);
        Apexpages.StandardController std = new Apexpages.StandardController(p);
        PhaseMaster pm = new PhaseMaster(std);
        
        pm.selectedTrial = lstSiteTrial[0].Trial__c;
        Apexpages.currentPage().getParameters().put('objectName','MRI_Volume__c'); 
        pm.redirectNewPage();  
        
        Apexpages.currentPage().getParameters().put('objectName','On_Study_Pathology_Form__c'); 
        pm.redirectNewPage();
      }
   }
 }
 
  @isTest static void redirectNewPage8() { //method "redirectNewPage" 
        // TO DO: implement unit test
        
        Profile SiteProp = [ Select p.UserType, p.Name, (Select u.IsActive, u.Id From Users u where IsActive = true) From Profile p where Name = 'System Administrator'];
        List<User> lstSiteUser = SiteProp.Users;     
        System.runAs ( lstSiteUser[0] ) { 
            
        Account accObj = new Account();
    	List<Site_Trial__c> lstSiteTrial = [Select s.Trial__c, s.Site__r.Institute__c, s.Site__c From Site_Trial__c s limit 1];
    
        if(!lstSiteTrial.isEmpty()){
	    	
        List<Account> lstAccount = [Select a.RecordType.Name, a.RecordTypeId, a.Id From Account a where Id =:lstSiteTrial[0].Site__r.Institute__c]; 
        accObj = lstAccount[0];                                 // newly added logic to overcome the error of "setup and nonsetup" object
        
        Patient_Custom__c p = new Patient_Custom__c();
        p.Birthdate__c = date.newInstance(1960, 8, 7);
        p.Signed_Screening__c = true;
        p.Ethnicity__c = 'Hispanic or latino';
        p.Gender__c = 'female';
        p.Race__c = 'asian';
        p.First_Name__c = 'test';
        p.Last_Name__c = 'kumar';
        p.Zip__c = '12';
        p.Middle_Name__c = 'testing';
        p.Institute_Text__c = 'asc';
        p.Institution__c = accObj.Id;
        p.Medical_Record_Number__c = '1234';
        insert p;
        
        TrialPatient__c tp = new TrialPatient__c();
        tp.FirstName__c = 'a';
        tp.LastName__c = 'b';
        tp.Patient_Id__c = p.Id;
        tp.Trial_Id__c = lstSiteTrial[0].Trial__c;
        insert tp;
        
        Registration__c reg = new Registration__c();
        reg.Patient__c = p.Id;
        reg.Registration_Date__c = System.today();
        reg.Trial__c = lstSiteTrial[0].Trial__c;
        reg.TrialPatient__c = tp.Id;
        reg.Institution__c = accObj.Id;
        reg.IRB_Approval_Date__c = System.today();
        reg.Screening_Informed_Consent_Date__c = System.today();
        reg.HIPPA_Consent_Date__c = System.today();
        reg.Status__c = 'Completed';
        reg.Effective_Time__c = system.now();
        reg.ISPY2_Subject_Id__c = ''+123;
        insert reg;
        
        PreEligibility_Checklist__c pec = new PreEligibility_Checklist__c();
        pec.Patient__c = p.Id;
        insert pec; 
        
        Apexpages.currentPage().getParameters().put('id',p.Id);
        Apexpages.currentPage().getParameters().put('TrialId',lstSiteTrial[0].Trial__c);
        Apexpages.StandardController std = new Apexpages.StandardController(p);
        PhaseMaster pm = new PhaseMaster(std);
        
        pm.selectedTrial = lstSiteTrial[0].Trial__c;
        Apexpages.currentPage().getParameters().put('objectName','Post_Surgaory_Summary__c'); 
        pm.redirectNewPage();  
        
      }
   }
 }
 @isTest static void redirectNewPage8New() { //method "redirectNewPage" 
        // TO DO: implement unit test
        
        Profile SiteProp = [ Select p.UserType, p.Name, (Select u.IsActive, u.Id From Users u where IsActive = true) From Profile p where Name = 'System Administrator'];
        List<User> lstSiteUser = SiteProp.Users;     
        System.runAs ( lstSiteUser[0] ) { 
            
        Account accObj = new Account();
    	List<Site_Trial__c> lstSiteTrial = [Select s.Trial__c, s.Site__r.Institute__c, s.Site__c From Site_Trial__c s limit 1];
    
        if(!lstSiteTrial.isEmpty()){
	    	
        List<Account> lstAccount = [Select a.RecordType.Name, a.RecordTypeId, a.Id From Account a where Id =:lstSiteTrial[0].Site__r.Institute__c]; 
        accObj = lstAccount[0];                                 // newly added logic to overcome the error of "setup and nonsetup" object
        
        Patient_Custom__c p = new Patient_Custom__c();
        p.Birthdate__c = date.newInstance(1960, 8, 7);
        p.Signed_Screening__c = true;
        p.Ethnicity__c = 'Hispanic or latino';
        p.Gender__c = 'female';
        p.Race__c = 'asian';
        p.First_Name__c = 'test';
        p.Last_Name__c = 'kumar';
        p.Zip__c = '12';
        p.Middle_Name__c = 'testing';
        p.Institute_Text__c = 'asc';
        p.Institution__c = accObj.Id;
        p.Medical_Record_Number__c = '1234';
        insert p;
        
        TrialPatient__c tp = new TrialPatient__c();
        tp.FirstName__c = 'a';
        tp.LastName__c = 'b';
        tp.Patient_Id__c = p.Id;
        tp.Trial_Id__c = lstSiteTrial[0].Trial__c;
        insert tp;
        
        Registration__c reg = new Registration__c();
        reg.Patient__c = p.Id;
        reg.Registration_Date__c = System.today();
        reg.Trial__c = lstSiteTrial[0].Trial__c;
        reg.TrialPatient__c = tp.Id;
        reg.Institution__c = accObj.Id;
        reg.IRB_Approval_Date__c = System.today();
        reg.Screening_Informed_Consent_Date__c = System.today();
        reg.HIPPA_Consent_Date__c = System.today();
        reg.Status__c = 'Completed';
        reg.Effective_Time__c = system.now();
        reg.ISPY2_Subject_Id__c = ''+123;
        insert reg;
        
        PreEligibility_Checklist__c pec = new PreEligibility_Checklist__c();
        pec.Patient__c = p.Id;
        insert pec; 
        
        Apexpages.currentPage().getParameters().put('id',p.Id);
        Apexpages.currentPage().getParameters().put('TrialId',lstSiteTrial[0].Trial__c);
        Apexpages.StandardController std = new Apexpages.StandardController(p);
        PhaseMaster pm = new PhaseMaster(std);
        
        pm.selectedTrial = lstSiteTrial[0].Trial__c;
        Apexpages.currentPage().getParameters().put('objectName','AE_Detail__c'); 
        pm.redirectNewPage();  
        
      }
   }
 }
 
   @isTest static void redirectPage1() { //method "redirectPage" and "redirectTaskCRF"
        // TO DO: implement unit test
        
        Profile SiteProp = [ Select p.UserType, p.Name, (Select u.IsActive, u.Id From Users u where IsActive = true) From Profile p where Name = 'System Administrator'];
        List<User> lstSiteUser = SiteProp.Users;     
        System.runAs ( lstSiteUser[0] ) { 
            
        Account accObj = new Account();
    	List<Site_Trial__c> lstSiteTrial = [Select s.Trial__c, s.Site__r.Institute__c, s.Site__c From Site_Trial__c s limit 1];
    
        if(!lstSiteTrial.isEmpty()){
	    	
        List<Account> lstAccount = [Select a.RecordType.Name, a.RecordTypeId, a.Id From Account a where Id =:lstSiteTrial[0].Site__r.Institute__c]; 
        accObj = lstAccount[0];                                 // newly added logic to overcome the error of "setup and nonsetup" object
        
        Patient_Custom__c p = new Patient_Custom__c();
        p.Birthdate__c = date.newInstance(1960, 8, 7);
        p.Signed_Screening__c = true;
        p.Ethnicity__c = 'Hispanic or latino';
        p.Gender__c = 'female';
        p.Race__c = 'asian';
        p.First_Name__c = 'test';
        p.Last_Name__c = 'kumar';
        p.Institution__c = accObj.Id;
        insert p;
        
        TrialPatient__c tp = new TrialPatient__c();
        tp.Patient_Id__c = p.Id;
        tp.Trial_Id__c = lstSiteTrial[0].Trial__c;
        insert tp;
        
        Registration__c reg = new Registration__c();
        reg.Patient__c = p.Id;
        reg.Registration_Date__c = System.today();
        reg.Trial__c = lstSiteTrial[0].Trial__c;
        reg.TrialPatient__c = tp.Id;
        reg.Institution__c = accObj.Id;
        reg.IRB_Approval_Date__c = System.today();
        reg.Screening_Informed_Consent_Date__c = System.today();
        reg.HIPPA_Consent_Date__c = System.today();
        reg.Status__c = 'Completed';
        reg.Effective_Time__c = system.now();
        reg.ISPY2_Subject_Id__c = ''+123;
        insert reg;
        
        Response_Evaluation_Form__c rev = new Response_Evaluation_Form__c();
        rev.TrialPatient__c = tp.Id;
        insert rev;
        
        Apexpages.currentPage().getParameters().put('id',p.Id);
        Apexpages.currentPage().getParameters().put('TrialId',lstSiteTrial[0].Trial__c);
        Apexpages.StandardController std = new Apexpages.StandardController(p);
        PhaseMaster pm = new PhaseMaster(std);
        Apexpages.currentPage().getParameters().put('objectName','Response_Evaluation_Form__c');
        Apexpages.currentPage().getParameters().put('paramAtt','signSubmit');
        Apexpages.currentPage().getParameters().put('objectId',p.Id);
        pm.redirectPage();
        
      }
    }
  }
  @isTest static void redirectPage1New() { //method "redirectPage" and "redirectTaskCRF"
        // TO DO: implement unit test
        
        Profile SiteProp = [ Select p.UserType, p.Name, (Select u.IsActive, u.Id From Users u where IsActive = true) From Profile p where Name = 'System Administrator'];
        List<User> lstSiteUser = SiteProp.Users;     
        System.runAs ( lstSiteUser[0] ) { 
            
        Account accObj = new Account();
    	List<Site_Trial__c> lstSiteTrial = [Select s.Trial__c, s.Site__r.Institute__c, s.Site__c From Site_Trial__c s limit 1];
    
        if(!lstSiteTrial.isEmpty()){
	    	
        List<Account> lstAccount = [Select a.RecordType.Name, a.RecordTypeId, a.Id From Account a where Id =:lstSiteTrial[0].Site__r.Institute__c]; 
        accObj = lstAccount[0];                                 // newly added logic to overcome the error of "setup and nonsetup" object
        
        Patient_Custom__c p = new Patient_Custom__c();
        p.Birthdate__c = date.newInstance(1960, 8, 7);
        p.Signed_Screening__c = true;
        p.Ethnicity__c = 'Hispanic or latino';
        p.Gender__c = 'female';
        p.Race__c = 'asian';
        p.First_Name__c = 'test';
        p.Last_Name__c = 'kumar';
        p.Institution__c = accObj.Id;
        insert p;
        
        TrialPatient__c tp = new TrialPatient__c();
        tp.Patient_Id__c = p.Id;
        tp.Trial_Id__c = lstSiteTrial[0].Trial__c;
        insert tp;
        
        Registration__c reg = new Registration__c();
        reg.Patient__c = p.Id;
        reg.Registration_Date__c = System.today();
        reg.Trial__c = lstSiteTrial[0].Trial__c;
        reg.TrialPatient__c = tp.Id;
        reg.Institution__c = accObj.Id;
        reg.IRB_Approval_Date__c = System.today();
        reg.Screening_Informed_Consent_Date__c = System.today();
        reg.HIPPA_Consent_Date__c = System.today();
        reg.Status__c = 'Completed';
        reg.Effective_Time__c = system.now();
        reg.ISPY2_Subject_Id__c = ''+123;
        insert reg;
        
        Response_Evaluation_Form__c rev = new Response_Evaluation_Form__c();
        rev.TrialPatient__c = tp.Id;
        insert rev;
        
        Apexpages.currentPage().getParameters().put('id',p.Id);
        Apexpages.currentPage().getParameters().put('TrialId',lstSiteTrial[0].Trial__c);
        Apexpages.StandardController std = new Apexpages.StandardController(p);
        PhaseMaster pm = new PhaseMaster(std);
        
        Apexpages.currentPage().getParameters().put('paramAtt','edit');
        Apexpages.currentPage().getParameters().put('objectId',p.Id);
        pm.redirectPage();
        
      }
    }
  }
  
  @isTest static void redirectPage6() { //method "redirectPage" and "redirectTaskCRF"
        // TO DO: implement unit test
        
        Profile SiteProp = [ Select p.UserType, p.Name, (Select u.IsActive, u.Id From Users u where IsActive = true) From Profile p where Name = 'System Administrator'];
        List<User> lstSiteUser = SiteProp.Users;     
        System.runAs ( lstSiteUser[0] ) { 
            
        Account accObj = new Account();
    	List<Site_Trial__c> lstSiteTrial = [Select s.Trial__c, s.Site__r.Institute__c, s.Site__c From Site_Trial__c s limit 1];
    
        if(!lstSiteTrial.isEmpty()){
	    	
        List<Account> lstAccount = [Select a.RecordType.Name, a.RecordTypeId, a.Id From Account a where Id =:lstSiteTrial[0].Site__r.Institute__c]; 
        accObj = lstAccount[0];                                 // newly added logic to overcome the error of "setup and nonsetup" object
        
        Patient_Custom__c p = new Patient_Custom__c();
        p.Birthdate__c = date.newInstance(1960, 8, 7);
        p.Signed_Screening__c = true;
        p.Ethnicity__c = 'Hispanic or latino';
        p.Gender__c = 'female';
        p.Race__c = 'asian';
        p.First_Name__c = 'test';
        p.Last_Name__c = 'kumar';
        p.Institution__c = accObj.Id;
        insert p;
        
        TrialPatient__c tp = new TrialPatient__c();
        tp.Patient_Id__c = p.Id;
        tp.Trial_Id__c = lstSiteTrial[0].Trial__c;
        insert tp;
        
        Registration__c reg = new Registration__c();
        reg.Patient__c = p.Id;
        reg.Registration_Date__c = System.today();
        reg.Trial__c = lstSiteTrial[0].Trial__c;
        reg.TrialPatient__c = tp.Id;
        reg.Institution__c = accObj.Id;
        reg.IRB_Approval_Date__c = System.today();
        reg.Screening_Informed_Consent_Date__c = System.today();
        reg.HIPPA_Consent_Date__c = System.today();
        reg.Status__c = 'Completed';
        reg.Effective_Time__c = system.now();
        reg.ISPY2_Subject_Id__c = ''+123;
        insert reg;
        
        Response_Evaluation_Form__c rev = new Response_Evaluation_Form__c();
        rev.TrialPatient__c = tp.Id;
        insert rev;
        
        Apexpages.currentPage().getParameters().put('id',p.Id);
        Apexpages.currentPage().getParameters().put('TrialId',lstSiteTrial[0].Trial__c);
        Apexpages.StandardController std = new Apexpages.StandardController(p);
        PhaseMaster pm = new PhaseMaster(std);
        
        Apexpages.currentPage().getParameters().put('paramAtt','detail');
        Apexpages.currentPage().getParameters().put('objectId',rev.Id);
        Apexpages.currentPage().getParameters().put('objectName','Response_Evaluation_Form__c');
        pm.redirectPage(); 
        
      }
    }
  }
  @isTest static void redirectPage6New1() { //method "redirectPage" and "redirectTaskCRF"
        // TO DO: implement unit test
        
        Profile SiteProp = [ Select p.UserType, p.Name, (Select u.IsActive, u.Id From Users u where IsActive = true) From Profile p where Name = 'System Administrator'];
        List<User> lstSiteUser = SiteProp.Users;     
        System.runAs ( lstSiteUser[0] ) { 
            
        Account accObj = new Account();
    	List<Site_Trial__c> lstSiteTrial = [Select s.Trial__c, s.Site__r.Institute__c, s.Site__c From Site_Trial__c s limit 1];
    
        if(!lstSiteTrial.isEmpty()){
	    	
        List<Account> lstAccount = [Select a.RecordType.Name, a.RecordTypeId, a.Id From Account a where Id =:lstSiteTrial[0].Site__r.Institute__c]; 
        accObj = lstAccount[0];                                 // newly added logic to overcome the error of "setup and nonsetup" object
        
        Patient_Custom__c p = new Patient_Custom__c();
        p.Birthdate__c = date.newInstance(1960, 8, 7);
        p.Signed_Screening__c = true;
        p.Ethnicity__c = 'Hispanic or latino';
        p.Gender__c = 'female';
        p.Race__c = 'asian';
        p.First_Name__c = 'test';
        p.Last_Name__c = 'kumar';
        p.Institution__c = accObj.Id;
        insert p;
        
        TrialPatient__c tp = new TrialPatient__c();
        tp.Patient_Id__c = p.Id;
        tp.Trial_Id__c = lstSiteTrial[0].Trial__c;
        insert tp;
        
        Registration__c reg = new Registration__c();
        reg.Patient__c = p.Id;
        reg.Registration_Date__c = System.today();
        reg.Trial__c = lstSiteTrial[0].Trial__c;
        reg.TrialPatient__c = tp.Id;
        reg.Institution__c = accObj.Id;
        reg.IRB_Approval_Date__c = System.today();
        reg.Screening_Informed_Consent_Date__c = System.today();
        reg.HIPPA_Consent_Date__c = System.today();
        reg.Status__c = 'Completed';
        reg.Effective_Time__c = system.now();
        reg.ISPY2_Subject_Id__c = ''+123;
        insert reg;
        
        Response_Evaluation_Form__c rev = new Response_Evaluation_Form__c();
        rev.TrialPatient__c = tp.Id;
        insert rev;
        
        Apexpages.currentPage().getParameters().put('id',p.Id);
        Apexpages.currentPage().getParameters().put('TrialId',lstSiteTrial[0].Trial__c);
        Apexpages.StandardController std = new Apexpages.StandardController(p);
        PhaseMaster pm = new PhaseMaster(std);
        
        Apexpages.currentPage().getParameters().put('paramAtt','detail');
        Apexpages.currentPage().getParameters().put('objectId',rev.Id);
        Apexpages.currentPage().getParameters().put('objectName','Response_Evaluation_Form__c');
        pm.redirectTaskCRF();
        
      }
    }
  }
  @isTest static void redirectPage6New() { //method "redirectPage" and "redirectTaskCRF"
        // TO DO: implement unit test
        
        Profile SiteProp = [ Select p.UserType, p.Name, (Select u.IsActive, u.Id From Users u where IsActive = true) From Profile p where Name = 'System Administrator'];
        List<User> lstSiteUser = SiteProp.Users;     
        System.runAs ( lstSiteUser[0] ) { 
            
        Account accObj = new Account();
    	List<Site_Trial__c> lstSiteTrial = [Select s.Trial__c, s.Site__r.Institute__c, s.Site__c From Site_Trial__c s limit 1];
    
        if(!lstSiteTrial.isEmpty()){
	    	
        List<Account> lstAccount = [Select a.RecordType.Name, a.RecordTypeId, a.Id From Account a where Id =:lstSiteTrial[0].Site__r.Institute__c]; 
        accObj = lstAccount[0];                                 // newly added logic to overcome the error of "setup and nonsetup" object
        
        Patient_Custom__c p = new Patient_Custom__c();
        p.Birthdate__c = date.newInstance(1960, 8, 7);
        p.Signed_Screening__c = true;
        p.Ethnicity__c = 'Hispanic or latino';
        p.Gender__c = 'female';
        p.Race__c = 'asian';
        p.First_Name__c = 'test';
        p.Last_Name__c = 'kumar';
        p.Institution__c = accObj.Id;
        insert p;
        
        TrialPatient__c tp = new TrialPatient__c();
        tp.Patient_Id__c = p.Id;
        tp.Trial_Id__c = lstSiteTrial[0].Trial__c;
        insert tp;
        
        Registration__c reg = new Registration__c();
        reg.Patient__c = p.Id;
        reg.Registration_Date__c = System.today();
        reg.Trial__c = lstSiteTrial[0].Trial__c;
        reg.TrialPatient__c = tp.Id;
        reg.Institution__c = accObj.Id;
        reg.IRB_Approval_Date__c = System.today();
        reg.Screening_Informed_Consent_Date__c = System.today();
        reg.HIPPA_Consent_Date__c = System.today();
        reg.Status__c = 'Completed';
        reg.Effective_Time__c = system.now();
        reg.ISPY2_Subject_Id__c = ''+123;
        insert reg;
        
        PreEligibility_Checklist__c pec = new PreEligibility_Checklist__c();
        pec.Patient__c = p.Id;
        insert pec; 
        
        Apexpages.currentPage().getParameters().put('id',p.Id);
        Apexpages.currentPage().getParameters().put('TrialId',lstSiteTrial[0].Trial__c);
        Apexpages.StandardController std = new Apexpages.StandardController(p);
        PhaseMaster pm = new PhaseMaster(std);
        
        Apexpages.currentPage().getParameters().put('objectId',pec.Id);
        Apexpages.currentPage().getParameters().put('objectName','PreEligibility_Checklist__c');
        pm.redirectPage(); 
      }
    }
  }
  
    @isTest static void redirectPage4() { //method "redirectPage" and "redirectTaskCRF"
        // TO DO: implement unit test
        
        Profile SiteProp = [ Select p.UserType, p.Name, (Select u.IsActive, u.Id From Users u where IsActive = true) From Profile p where Name = 'System Administrator'];
        List<User> lstSiteUser = SiteProp.Users;     
        System.runAs ( lstSiteUser[0] ) { 
            
        Account accObj = new Account();
    	List<Site_Trial__c> lstSiteTrial = [Select s.Trial__c, s.Site__r.Institute__c, s.Site__c From Site_Trial__c s limit 1];
    
        if(!lstSiteTrial.isEmpty()){
	    	
        List<Account> lstAccount = [Select a.RecordType.Name, a.RecordTypeId, a.Id From Account a where Id =:lstSiteTrial[0].Site__r.Institute__c]; 
        accObj = lstAccount[0];                                 // newly added logic to overcome the error of "setup and nonsetup" object
        
        Patient_Custom__c p = new Patient_Custom__c();
        p.Birthdate__c = date.newInstance(1960, 8, 7);
        p.Signed_Screening__c = true;
        p.Ethnicity__c = 'Hispanic or latino';
        p.Gender__c = 'female';
        p.Race__c = 'asian';
        p.First_Name__c = 'test';
        p.Last_Name__c = 'kumar';
        p.Institution__c = accObj.Id;
        insert p;
        
        TrialPatient__c tp = new TrialPatient__c();
        tp.Patient_Id__c = p.Id;
        tp.Trial_Id__c = lstSiteTrial[0].Trial__c;
        insert tp;
        
        Registration__c reg = new Registration__c();
        reg.Patient__c = p.Id;
        reg.Registration_Date__c = System.today();
        reg.Trial__c = lstSiteTrial[0].Trial__c;
        reg.TrialPatient__c = tp.Id;
        reg.Institution__c = accObj.Id;
        reg.IRB_Approval_Date__c = System.today();
        reg.Screening_Informed_Consent_Date__c = System.today();
        reg.HIPPA_Consent_Date__c = System.today();
        reg.Status__c = 'Completed';
        reg.Effective_Time__c = system.now();
        reg.ISPY2_Subject_Id__c = ''+123;
        insert reg;
        
        Apexpages.currentPage().getParameters().put('id',p.Id);
        Apexpages.currentPage().getParameters().put('TrialId',lstSiteTrial[0].Trial__c);
        Apexpages.StandardController std = new Apexpages.StandardController(p);
        PhaseMaster pm = new PhaseMaster(std);
        
        Apexpages.currentPage().getParameters().put('objectId',reg.Id);
        Apexpages.currentPage().getParameters().put('objectName','Registration__c');
        pm.redirectPage(); 
      }
    }
  }
  
  @isTest static void redirectPage5() { //method "redirectPage" and "redirectTaskCRF"
        // TO DO: implement unit test
        
        Profile SiteProp = [ Select p.UserType, p.Name, (Select u.IsActive, u.Id From Users u where IsActive = true) From Profile p where Name = 'System Administrator'];
        List<User> lstSiteUser = SiteProp.Users;     
        System.runAs ( lstSiteUser[0] ) { 
            
        Account accObj = new Account();
    	List<Site_Trial__c> lstSiteTrial = [Select s.Trial__c, s.Site__r.Institute__c, s.Site__c From Site_Trial__c s limit 1];
    
        if(!lstSiteTrial.isEmpty()){
	    	
        List<Account> lstAccount = [Select a.RecordType.Name, a.RecordTypeId, a.Id From Account a where Id =:lstSiteTrial[0].Site__r.Institute__c]; 
        accObj = lstAccount[0];                                 // newly added logic to overcome the error of "setup and nonsetup" object
        
        Patient_Custom__c p = new Patient_Custom__c();
        p.Birthdate__c = date.newInstance(1960, 8, 7);
        p.Signed_Screening__c = true;
        p.Ethnicity__c = 'Hispanic or latino';
        p.Gender__c = 'female';
        p.Race__c = 'asian';
        p.First_Name__c = 'test';
        p.Last_Name__c = 'kumar';
        p.Institution__c = accObj.Id;
        insert p;
        
        TrialPatient__c tp = new TrialPatient__c();
        tp.Patient_Id__c = p.Id;
        tp.Trial_Id__c = lstSiteTrial[0].Trial__c;
        insert tp;
        
        Apexpages.currentPage().getParameters().put('id',p.Id);
        Apexpages.currentPage().getParameters().put('TrialId',lstSiteTrial[0].Trial__c);
        Apexpages.StandardController std = new Apexpages.StandardController(p);
        PhaseMaster pm = new PhaseMaster(std);
      
        Apexpages.currentPage().getParameters().put('objectName','Menopausal_Status_Detail__c');
        pm.redirectPage(); 
        pm.redirectTaskCRF();
        
        Apexpages.currentPage().getParameters().put('objectName','MRI_Volume__c');
        pm.redirectPage(); 
        pm.redirectTaskCRF();
        
      }
    }
  }
  
  @isTest static void redirectPage2() { //method "redirectPage" and "redirectTaskCRF"
        // TO DO: implement unit test
        
        Profile SiteProp = [ Select p.UserType, p.Name, (Select u.IsActive, u.Id From Users u where IsActive = true) From Profile p where Name = 'System Administrator'];
        List<User> lstSiteUser = SiteProp.Users;     
        System.runAs ( lstSiteUser[0] ) { 
            
        Account accObj = new Account();
    	List<Site_Trial__c> lstSiteTrial = [Select s.Trial__c, s.Site__r.Institute__c, s.Site__c From Site_Trial__c s limit 1];
    
        if(!lstSiteTrial.isEmpty()){
	    	
        List<Account> lstAccount = [Select a.RecordType.Name, a.RecordTypeId, a.Id From Account a where Id =:lstSiteTrial[0].Site__r.Institute__c]; 
        accObj = lstAccount[0];                                 // newly added logic to overcome the error of "setup and nonsetup" object
        
        Patient_Custom__c p = new Patient_Custom__c();
        p.Birthdate__c = date.newInstance(1960, 8, 7);
        p.Signed_Screening__c = true;
        p.Ethnicity__c = 'Hispanic or latino';
        p.Gender__c = 'female';
        p.Race__c = 'asian';
        p.First_Name__c = 'test';
        p.Last_Name__c = 'kumar';
        p.Institution__c = accObj.Id;
        insert p;
        
        TrialPatient__c tp = new TrialPatient__c();
        tp.Patient_Id__c = p.Id;
        tp.Trial_Id__c = lstSiteTrial[0].Trial__c;
        insert tp;
        
        Apexpages.currentPage().getParameters().put('id',p.Id);
        Apexpages.currentPage().getParameters().put('TrialId',lstSiteTrial[0].Trial__c);
        Apexpages.StandardController std = new Apexpages.StandardController(p);
        PhaseMaster pm = new PhaseMaster(std);
        
        Apexpages.currentPage().getParameters().put('objectName','On_Study_Eligibility_Form__c');
        pm.redirectPage();
        pm.redirectTaskCRF();
        
        Apexpages.currentPage().getParameters().put('objectName','ProtocolViolationDetail__c');
        pm.redirectPage();
        pm.redirectTaskCRF();
        
        Apexpages.currentPage().getParameters().put('objectName','TissueSpecimenDetail__c');
        pm.redirectPage();
        pm.redirectTaskCRF();
        
        Apexpages.currentPage().getParameters().put('objectName','BloodSpecimenForm__c');
        pm.redirectPage();
        pm.redirectTaskCRF();
        
        Apexpages.currentPage().getParameters().put('objectName','MammaPrintDetail__c');
        pm.redirectPage();
        pm.redirectTaskCRF();
        
        Apexpages.currentPage().getParameters().put('objectName','Randomization_Form__c');
        pm.redirectPage(); 
        pm.redirectTaskCRF();
        
        Apexpages.currentPage().getParameters().put('objectName','Off_Study_Detail__c');
        pm.redirectTaskCRF();
        
        Apexpages.currentPage().getParameters().put('objectName','Post_Surgaory_Summary__c');
        pm.redirectTaskCRF();
        
        Apexpages.currentPage().getParameters().put('objectName','AE_Detail__c');
        pm.redirectTaskCRF();
        
        Apexpages.currentPage().getParameters().put('objectName','Lab_and_Test__c');
        pm.redirectTaskCRF();
        
        Apexpages.currentPage().getParameters().put('objectName','Followup_Form__c');
        pm.redirectTaskCRF();
        
        Apexpages.currentPage().getParameters().put('objectName','Lost_to_Follow_Up__c');
        pm.redirectTaskCRF();
        
        Apexpages.currentPage().getParameters().put('objectName','No_Longer_lost_to_Followup__c');
        pm.redirectTaskCRF();
        
      }
    }
  }
  @isTest static void redirectPage3() { //method "redirectPage" 
        // TO DO: implement unit test
        
        Profile SiteProp = [ Select p.UserType, p.Name, (Select u.IsActive, u.Id From Users u where IsActive = true) From Profile p where Name = 'System Administrator'];
        List<User> lstSiteUser = SiteProp.Users;     
        System.runAs ( lstSiteUser[0] ) { 
            
        Account accObj = new Account();
    	List<Site_Trial__c> lstSiteTrial = [Select s.Trial__c, s.Site__r.Institute__c, s.Site__c From Site_Trial__c s limit 1];
    
        if(!lstSiteTrial.isEmpty()){
	    	
        List<Account> lstAccount = [Select a.RecordType.Name, a.RecordTypeId, a.Id From Account a where Id =:lstSiteTrial[0].Site__r.Institute__c]; 
        accObj = lstAccount[0];                                 // newly added logic to overcome the error of "setup and nonsetup" object
        
        Trial__c tr = new Trial__c();
	    tr.Name = 'test';
	    insert tr;
	    
        Patient_Custom__c p = new Patient_Custom__c();
        p.Birthdate__c = date.newInstance(1960, 8, 7);
        p.Signed_Screening__c = true;
        p.Ethnicity__c = 'Hispanic or latino';
        p.Gender__c = 'female';
        p.Race__c = 'asian';
        p.First_Name__c = 'test';
        p.Last_Name__c = 'kumar';
        p.Institution__c = accObj.Id;
        insert p;
        
        TrialPatient__c tp = new TrialPatient__c();
        tp.Patient_Id__c = p.Id;
        tp.Trial_Id__c = lstSiteTrial[0].Trial__c;
        insert tp;
        
        Registration__c reg = new Registration__c();
        reg.Patient__c = p.Id;
        reg.Registration_Date__c = System.today();
        reg.Trial__c = lstSiteTrial[0].Trial__c;
        reg.TrialPatient__c = tp.Id;
        reg.Institution__c = accObj.Id;
        reg.IRB_Approval_Date__c = System.today();
        reg.Screening_Informed_Consent_Date__c = System.today();
        reg.HIPPA_Consent_Date__c = System.today();
        reg.Status__c = 'Completed';
        reg.Effective_Time__c = system.now();
        reg.ISPY2_Subject_Id__c = ''+123;
        insert reg;
        
        CRFMaster__c crf = new CRFMaster__c();
        crf.Object_Name__c = 'Registration__c';
        insert crf;
        
        Trial_CRF__c tc = new Trial_CRF__c();
        tc.Trial__c = tr.Id;
        tc.CRFMaster__c = crf.Id;
        insert tc;
	    
		Phase_Master__c pmc = new Phase_Master__c();
        pmc.Name = 'Treatment';
        pmc.Order__c = 9.0;
        insert pmc;
        
        Phase_Cycle__c pcc = new Phase_Cycle__c();
        pcc.Phase__c = pmc.Id;
        pcc.Order__c = 9.0;
        insert pcc;
        
        Phase_CRFs__c pcrf = new Phase_CRFs__c();
        pcrf.Phase_Cycle__c = pcc.Id;
        pcrf.CRF__c = crf.Id;
        insert pcrf;	
        
        Apexpages.currentPage().getParameters().put('id',p.Id);
        Apexpages.currentPage().getParameters().put('TrialId',lstSiteTrial[0].Trial__c);
        Apexpages.StandardController std = new Apexpages.StandardController(p);
        PhaseMaster pm = new PhaseMaster(std);
        
        PhaseMaster.wrapScreen wrapObj = new PhaseMaster.wrapScreen();
        wrapObj.selectedCrfCreatedDate = string.valueOf(system.today());
        
        List<PhaseMaster.wrapScreen> screenWrapList = new List<PhaseMaster.wrapScreen>();
        screenWrapList.add(wrapObj);
        
        Apexpages.currentPage().getParameters().put('paramAtt','detail');
        Apexpages.currentPage().getParameters().put('createdType','pickList');
        Apexpages.currentPage().getParameters().put('objectId',reg.Id);
        Apexpages.currentPage().getParameters().put('objectName','Registration__c');
        pm.redirectPage(); 
      }
    }
  }
  @isTest static void validationError() { // also cover "TaskOnAfterTrigger" trigger

		List<User> thisUser = [Select u.IsActive, u.Id, SecurityCode__c ,u.Patient_Id__c, u.ProfileId, u.Username From User u where IsActive = true and Profile.Name = 'System Administrator'];     
		System.runAs ( thisUser[0] ) { 
		
	    Account acc = new Account();
	    
	    List<Account> lstAccount = [Select a.Id From Account a limit 1];
	    
	    if(!lstAccount.isEmpty()){
	    	
	    acc = lstAccount[0];
	    
	    Patient_Custom__c pcObject = new Patient_Custom__c();
	    pcObject.Birthdate__c = date.newInstance(1980, 08, 05);
	    pcObject.Institution__c = acc.Id;
	    pcObject.Last_Name__c = 'test'; 
		pcObject.Gender__c = 'Male';
		pcObject.Race__c = 'White';
		pcObject.Ethnicity__c = 'Not Hispanic or Latino';
		pcObject.Email__c = thisUser[0].Username;
		pcObject.isPortalEnable__c = true;
	    insert pcObject;
	    
	    Trial__c tr = new Trial__c();
	    tr.Name = 'test';
	    insert tr;
	    
	    TrialPatient__c tp = new TrialPatient__c();
	    tp.Patient_Id__c = pcObject.Id;
	    tp.Trial_Id__c = tr.Id;
	    insert tp;
	    
	    Event eventObject = new Event();
	    eventObject.Trial__c = tr.Id;
	    eventObject.ActivityDateTime = datetime.newInstance(2010, 12, 1, 12, 30, 2); // year,month,day,hr,min,sec
	    eventObject.WhatId = acc.Id;
	    eventObject.OwnerId = thisUser[0].Id;
	    eventObject.Subject = 'test';
	    eventObject.DurationInMinutes = 300;
	    eventObject.Hours__c = null;
	    eventObject.Minutes__c = null;
	    eventObject.StartDateTime = datetime.newInstance(2010, 12, 1, 12, 30, 2);
	    insert eventObject;
	    update eventObject;
	    
	    Task tskObject = new Task();
	    tskObject.Trial_Id__c = tr.Id;
	    tskObject.ActivityDate = date.newInstance(2010, 07, 07);
	    tskObject.Status = 'In Progress';
	    tskObject.OwnerId = userinfo.getUserId();
	    tskObject.WhatId = pcObject.Id; 
	    tskObject.Subject = 'Call';
	    tskObject.Type = 'Schedule the patient for a blood sample';
	    tskObject.Schedule_Event_Date__c = datetime.newInstance(2010, 12, 1, 12, 30, 2);
	    tskObject.Group_Id__c = system.currentTimeMillis()+'';
	    insert tskObject;
	    update tskObject;
	    
	    Task tskObject1 = new Task();
	    tskObject1.Trial_Id__c = tr.Id;
	    tskObject1.ActivityDate = date.newInstance(2010, 07, 07);
	    tskObject1.Status = 'In Progress';
	    tskObject1.OwnerId = userinfo.getUserId();
	    tskObject1.WhatId = pcObject.Id; 
	    tskObject1.Subject = 'Call';
	    tskObject1.Type = 'Schedule the patient for a blood sample';
	    tskObject1.Schedule_Event_Date__c = datetime.newInstance(2010, 12, 1, 12, 30, 2);
	    tskObject1.Group_Id__c = tskObject.Group_Id__c;
	    insert tskObject1;
	    tskObject1.Status = 'Completed';
	    update tskObject1;
	    
	    Apexpages.currentPage().getParameters().put('id',pcObject.Id);
	    Apexpages.currentPage().getParameters().put('TrialId',tr.Id);
	    Apexpages.StandardController std = new Apexpages.StandardController(pcObject);
	    PhaseMaster pmObject = new PhaseMaster(std);
	    pmObject.selectedTrial = tr.Id;
	    pmObject.selectredioButton = '';
	    pmObject.getWrapList();	
	    pmObject.selectedTaskOption = 'Completed';
	    pmObject.getLstTask();
	    
	  /*  pmObject.event = eventObject;
	    pmObject.startDateValidationEventCreation();
	    pmObject.event = eventObject;
	    pmObject.startDateValidationReschude(); */
	    
	    pmObject.event = eventObject;
	    pmObject.taskIdHidden = tskObject.Id;
	    pmObject.ScheduledEvent();
	    
	    pmObject.eventres = eventObject;
	    pmObject.eventId = eventObject.Id;
	  //  pmObject.rescheduleEvent();
	    
	    Apexpages.currentPage().getParameters().put('paramAtt','delete');
        Apexpages.currentPage().getParameters().put('objectId',pcObject.Id);
        Apexpages.currentPage().getParameters().put('objectName','Patient_Custom__c');
        pmObject.redirectPage(); 
	  }
    }
  }
}