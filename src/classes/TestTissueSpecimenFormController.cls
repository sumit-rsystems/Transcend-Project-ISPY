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
private class TestTissueSpecimenFormController {

   
      @isTest static void myUnitTest(){
        // TO DO: implement unit test
        
        List<User> lstSiteUser = [Select u.IsActive, u.Id, SecurityCode__c From User u where IsActive = true and Profile.Name = 'Site User'];     
        System.runAs ( lstSiteUser[0] ) { 
        
        Account acc = new Account();
        
        List<Account> lstAccount = [Select a.Id From Account a limit 1];
        
        if(!lstAccount.isEmpty()){
            
        acc = lstAccount[0];
        
        Patient_Custom__c p = new Patient_Custom__c();
        p.Ethnicity__c = 'Hispanic or latino';
        p.Gender__c = 'Male';
        p.Race__c = 'asian;indian';
        p.Last_Name__c = 'kumar';
        p.Status__c = 'approval not required';
        p.Birthdate__c = date.newInstance(1950, 08, 05);
        p.Institution__c = acc.Id;
        insert p;
        
        List<Patient_Custom__c> lstPatient = [select Name from Patient_Custom__c where Id = :P.Id];
        
        TrialPatient__c tp = new TrialPatient__c();
        tp.Patient_Id__c = p.Id;
        tp.FirstName__c = 'a';
        tp.LastName__c = 'b';
        insert tp;
        
        CRF__c crf = new CRF__c();
        crf.Status__c = 'Accepted';
        crf.Patient__c = p.Id;
        insert crf;
    
        TissueSpecimenDetail__c ts = new TissueSpecimenDetail__c();
        ts.Status__c = 'Accepted';
        ts.Patient__c = p.Id;
        ts.TrialPatient__c = tp.Id;
        ts.ProcedureDate__c = date.newInstance(2012, 8, 10);
        ts.Time_Point__c = 'Pre-treatment';
        ts.CRFId__c = crf.Id;
        ts.NumberOfSamplesCollected__c = 1.0;
        insert ts;
        
        ts.Status__c = 'Accepted';
        update ts;
        
        Core_Biopsy_Specimens__c cb = new Core_Biopsy_Specimens__c();
        cb.SpecimenID__c = '1111';
        cb.TissueSpecimenDetail__c = ts.Id;
        cb.Core_Specimen__c = '3';
        insert cb;
        update cb;
        
        Apexpages.currentPage().getParameters().put('trialPat',tp.Id);
        Apexpages.currentPage().getParameters().put('tsId',ts.Id); 
        Apexpages.StandardController std = new Apexpages.StandardController(ts);
        TissueSpecimenFormController tsf = new TissueSpecimenFormController(std);
        
        tsf.getcoreBiopsyNumber(); // method "getcoreBiopsyNumber()"begins and end here 
        
        //============ method "next" begins here ======================================
        
        Apexpages.currentPage().getParameters().put('nextTab','saveAndClose');
        Apexpages.currentPage().getParameters().put('trialPat',tp.Id);
        tsf.currentTab = 'Core BiopsyTab';
        tsf.next();
        
        tsf.currentTab = 'AttachmentsTab';
        tsf.next();
        
        Apexpages.currentPage().getParameters().put('nextTab','CompleteTab');
        tsf.next();
        
        //============ method "next" ends here ======================================
        
        //============ method "previous" begins here ======================================
        Apexpages.currentPage().getParameters().put('prevTab','AttachmentsTab');
        tsf.previous();
        //============ method "previous" ends here ======================================
        
        tsf.saveCRF();
        tsf.submitTissueSpecimenRecord(ts.Id);
        tsf.editTissueSpecimenForm();
        
        Apexpages.currentPage().getParameters().put('row','1');
        tsf.addSpecimen();
        tsf.customCancel();
        tsf.editTissueSpecimenForm();
        
        tsf.resendCode();
        tsf.saveMainCRF();
        tsf.signAndSubmit();
        tsf.cancelCRF(); 
        tsf.redirect();
        tsf.viewXML();
        
    }
   }
 } 
   
      @isTest static void myUnitTest1() { // to satisfy "else if"  condition of method "next" line 112 "Early Treatment"
        // TO DO: implement unit test
        
        List<User> lstSiteUser = [Select u.IsActive, u.Id, SecurityCode__c From User u where IsActive = true and Profile.Name = 'Site User'];     
        System.runAs ( lstSiteUser[0] ) { 
        
        Account acc = new Account();
        
        List<Account> lstAccount = [Select a.Id From Account a limit 1];
        
        if(!lstAccount.isEmpty()){
            
        acc = lstAccount[0];
        
        Patient_Custom__c p = new Patient_Custom__c();
        p.Ethnicity__c = 'Hispanic or latino';
        p.Gender__c = 'female';
        p.Race__c = 'asian;indian;White';
        p.Last_Name__c = 'kumar';
        p.Status__c = 'approval not required';
        p.Birthdate__c = date.newInstance(1950, 08, 05);
        p.Institution__c = acc.Id;
        insert p;
        
        List<Patient_Custom__c> lstPatient = [select Name from Patient_Custom__c where Id = :P.Id];
        
        TrialPatient__c tp = new TrialPatient__c();
        tp.Patient_Id__c = p.Id;
        tp.FirstName__c = 'a';
        tp.LastName__c = 'b';
        insert tp;
        
        CRF__c crf = new CRF__c();
        crf.Status__c = 'Accepted';
        crf.Patient__c = p.Id;
        insert crf;
    
        TissueSpecimenDetail__c ts = new TissueSpecimenDetail__c();
        ts.Status__c = 'Accepted';
        ts.Patient__c = p.Id;
        ts.TrialPatient__c = tp.Id;
        ts.ProcedureDate__c = date.newInstance(2012, 8, 10);
        ts.Time_Point__c = 'Early Treatment';
        ts.CRFId__c = crf.Id;
        ts.NumberOfSamplesCollected__c = 1.0;
        ts.Guidance_Method_s__c='XYZ';
        insert ts;
        
        ts.Status__c = 'Accepted';
        update ts;
        
        Core_Biopsy_Specimens__c cb = new Core_Biopsy_Specimens__c();
        cb.SpecimenID__c = '1111';
        cb.TissueSpecimenDetail__c = ts.Id;
        cb.Core_Specimen__c = '3';
        insert cb;
        update cb;
        
        
        Apexpages.currentPage().getParameters().put('trialPat',tp.Id);
        Apexpages.currentPage().getParameters().put('tsId',ts.Id); 
        Apexpages.StandardController std = new Apexpages.StandardController(ts);
        TissueSpecimenFormController tsf = new TissueSpecimenFormController(std);
        
        //============ method "next" begins here ======================================
        tsf.currentTab = 'Core BiopsyTab';
        tsf.next();
        //============ method "next" ends here ======================================
        
        tsf.saveCRF();
        tsf.submitTissueSpecimenRecord(ts.Id);
        
        Apexpages.currentPage().getParameters().put('row','2');
        tsf.addSpecimen();
        
        tsf.signAndSubmit();
        tsf.resendCode();
        
        Apexpages.currentPage().getParameters().put('id',ts.Id);
        tsf.cancelTissueSpecimenRecord(); 
        }
        }
	} 
   
      @isTest static void myUnitTest2() { // to satisfy method "saveMainCRF "and "else if"  condition of method "next" line 117 "Inter-Regimen" 
        // TO DO: implement unit test
        
        List<User> lstSiteUser = [Select u.IsActive, u.Id, SecurityCode__c From User u where IsActive = true and Profile.Name = 'Site User'];     
        System.runAs ( lstSiteUser[0] ) { 
        
        Account acc = new Account();
        
        List<Account> lstAccount = [Select a.Id From Account a limit 1];
        
        if(!lstAccount.isEmpty()){
            
        acc = lstAccount[0];
        
        Patient_Custom__c p = new Patient_Custom__c();
        p.Ethnicity__c = 'Hispanic or latino';
        p.Gender__c = 'female';
        p.Race__c = 'asian;indian;White';
        p.Last_Name__c = 'kumar';
        p.Status__c = 'approval not required';
        p.Birthdate__c = date.newInstance(1950, 08, 05);
        p.Institution__c = acc.Id;
        insert p;
        
        List<Patient_Custom__c> lstPatient = [select Name from Patient_Custom__c where Id = :P.Id];
        
        TrialPatient__c tp = new TrialPatient__c();
        tp.Patient_Id__c = p.Id;
        tp.FirstName__c = 'a';
        tp.LastName__c = 'b';
        insert tp;
        
        CRF__c crf = new CRF__c();
        crf.Status__c = 'Accepted';
        crf.Patient__c = p.Id;
        insert crf;
    
        TissueSpecimenDetail__c ts = new TissueSpecimenDetail__c();
        ts.Status__c = 'Accepted';
        ts.Patient__c = p.Id;
        ts.TrialPatient__c = tp.Id;
        ts.ProcedureDate__c = date.newInstance(2012, 8, 10);
        ts.Time_Point__c = 'Inter-Regimen';
        ts.CRFId__c = crf.Id;
        ts.Status__c = 'Accepted';
        
        Core_Biopsy_Specimens__c cb = new Core_Biopsy_Specimens__c();
        cb.SpecimenID__c = '1111';
        cb.TissueSpecimenDetail__c = ts.Id;
        cb.Core_Specimen__c = '2';
      //  insert cb;
      //  update cb;
        
        
        Apexpages.currentPage().getParameters().put('trialPat',tp.Id);
        Apexpages.StandardController std = new Apexpages.StandardController(ts);
        TissueSpecimenFormController tsf = new TissueSpecimenFormController(std);
        
        //=============== to satisfy method "saveMainCRF "======================================
        
        Apexpages.currentPage().getParameters().put('tsId',null);
        tsf.tsId = null;
        tsf.saveMainCRF();
        
        //============== to satisfy method "saveMainCRF "======================================
        
        TissueSpecimenDetail__c ts1 = new TissueSpecimenDetail__c();
        ts1.Status__c = 'Accepted';
        ts1.Patient__c = p.Id;
        ts1.TrialPatient__c = tp.Id;
        ts1.ProcedureDate__c = date.newInstance(2012, 8, 10);
        ts1.Time_Point__c = 'Inter-Regimen';
        ts1.CRFId__c = crf.Id;
        ts1.NumberOfSamplesCollected__c = 1.0;
        insert ts1;
        
        ts1.Status__c = 'Accepted';
        update ts1;
        
        Core_Biopsy_Specimens__c cb1 = new Core_Biopsy_Specimens__c();
        cb1.SpecimenID__c = '1111';
        cb1.TissueSpecimenDetail__c = ts1.Id;
        cb1.Core_Specimen__c = '3';
        insert cb1;
        update cb1;
        
        //=========== to satisfy "else if"  condition of method "next" line 117 "Inter-Regimen"
        
        Apexpages.currentPage().getParameters().put('trialPat',tp.Id);
        Apexpages.currentPage().getParameters().put('tsId',ts1.Id);
        Apexpages.StandardController std1 = new Apexpages.StandardController(ts1);
        TissueSpecimenFormController tsf1 = new TissueSpecimenFormController(std1);
        
         tsf1.currentTab = 'Core BiopsyTab';
        tsf1.next();
        
        //=========== to satisfy "else if"  condition of method "next" line 117 "Inter-Regimen"
        
        tsf1.saveCRF();
        tsf1.submitTissueSpecimenRecord(ts1.Id);
        
        Apexpages.currentPage().getParameters().put('row','4');
        tsf1.addSpecimen(); 
        
        TissueSpecimenDetail__c ts2 = new TissueSpecimenDetail__c();
        ts2.Status__c = 'Accepted';
        ts2.Patient__c = p.Id;
        ts2.TrialPatient__c = tp.Id;
        ts2.ProcedureDate__c = date.newInstance(2012, 8, 10);
        ts2.Time_Point__c = 'Surgery';
        ts2.CRFId__c = crf.Id;
        ts2.NumberOfSamplesCollected__c = 1.0;
        insert ts2;
        
        ts2.Status__c = 'Accepted';
        update ts2;
        
        Core_Biopsy_Specimens__c cb2 = new Core_Biopsy_Specimens__c();
        cb2.SpecimenID__c = '1111';
        cb2.TissueSpecimenDetail__c = ts2.Id;
        cb2.Core_Specimen__c = '3';
        insert cb2;
        update cb2;
        
        
        Apexpages.currentPage().getParameters().put('trialPat',tp.Id);
        Apexpages.currentPage().getParameters().put('tsId',ts2.Id); 
        Apexpages.StandardController std2 = new Apexpages.StandardController(ts2);
        //TissueSpecimenFormController tsf2 = new TissueSpecimenFormController(std2);
        
        //============ method "next" begins here ======================================
        //tsf2.currentTab = 'Core BiopsyTab';
        //tsf2.next();
        //============ method "next" ends here ======================================
        
        //tsf2.saveCRF();
        //tsf2.submitTissueSpecimenRecord(ts2.Id);
        
        //Apexpages.currentPage().getParameters().put('row','5');
        //tsf2.addSpecimen();
    }
   }
 }
  
     @isTest static void myUnitTest4() { // to satisfy method "saveMainCRF "and "else if"  condition of method "next" line 117 "Inter-Regimen"   
        // TO DO: implement unit test
        
        List<User> lstSiteUser = [Select u.IsActive, u.Id, SecurityCode__c From User u where IsActive = true and Profile.Name = 'Site User'];     
        System.runAs ( lstSiteUser[0] ) { 
        
        Account acc = new Account();
        
        List<Account> lstAccount = [Select a.Id From Account a limit 1];
        
        if(!lstAccount.isEmpty()){
            
        acc = lstAccount[0];
        
        Patient_Custom__c p = new Patient_Custom__c();
        p.Ethnicity__c = 'Hispanic or latino';
        p.Gender__c = 'female';
        p.Race__c = 'asian;indian;White';
        p.Last_Name__c = 'kumar';
        p.Status__c = 'approval not required';
        p.Birthdate__c = date.newInstance(1950, 08, 05);
        p.Institution__c = acc.Id;
        insert p;
        
        List<Patient_Custom__c> lstPatient = [select Name from Patient_Custom__c where Id = :P.Id];
        
        TrialPatient__c tp = new TrialPatient__c();
        tp.Patient_Id__c = p.Id;
        tp.FirstName__c = 'a';
        tp.LastName__c = 'b';
        insert tp;
        
        CRF__c crf = new CRF__c();
        crf.Status__c = 'Accepted';
        crf.Patient__c = p.Id;
        insert crf;
    
        TissueSpecimenDetail__c ts = new TissueSpecimenDetail__c();
        ts.Status__c = 'Accepted';
        ts.Patient__c = p.Id;
        ts.TrialPatient__c = tp.Id;
        ts.ProcedureDate__c = date.newInstance(2012, 8, 10);
        ts.Time_Point__c = 'Inter-Regimen';
        ts.CRFId__c = crf.Id;
        ts.Status__c = 'Accepted';
        
        Core_Biopsy_Specimens__c cb = new Core_Biopsy_Specimens__c();
        cb.SpecimenID__c = '1111';
        cb.TissueSpecimenDetail__c = ts.Id;
        cb.Core_Specimen__c = '2';
      //  insert cb;
      //  update cb;
        
        
        Apexpages.currentPage().getParameters().put('trialPat',tp.Id);
        Apexpages.StandardController std = new Apexpages.StandardController(ts);
        TissueSpecimenFormController tsf = new TissueSpecimenFormController(std);
        
        //=============== to satisfy method "saveMainCRF "======================================
        
        Apexpages.currentPage().getParameters().put('tsId',null);
        tsf.tsId = null;
        tsf.saveMainCRF();
        
        //============== to satisfy method "saveMainCRF "======================================
        
        TissueSpecimenDetail__c ts1 = new TissueSpecimenDetail__c();
        ts1.Status__c = 'Accepted';
        ts1.Patient__c = p.Id;
        ts1.TrialPatient__c = tp.Id;
        ts1.ProcedureDate__c = date.newInstance(2012, 8, 10);
        ts1.Time_Point__c = 'Inter-Regimen';
        ts1.CRFId__c = crf.Id;
        ts1.NumberOfSamplesCollected__c = 1.0;
        insert ts1;
        
        ts1.Status__c = 'Accepted';
        update ts1;
        
        Core_Biopsy_Specimens__c cb1 = new Core_Biopsy_Specimens__c();
        cb1.SpecimenID__c = '1111';
        cb1.TissueSpecimenDetail__c = ts1.Id;
        cb1.Core_Specimen__c = '3';
        insert cb1;
        update cb1;
        
        //=========== to satisfy "else if"  condition of method "next" line 117 "Inter-Regimen"
        
        Apexpages.currentPage().getParameters().put('trialPat',tp.Id);
        Apexpages.currentPage().getParameters().put('tsId',ts1.Id);
        Apexpages.StandardController std1 = new Apexpages.StandardController(ts1);
        //TissueSpecimenFormController tsf1 = new TissueSpecimenFormController(std1);
        
        // tsf1.currentTab = 'Core BiopsyTab';
        //tsf1.next();
        
        //=========== to satisfy "else if"  condition of method "next" line 117 "Inter-Regimen"
        
        //tsf1.saveCRF();
        //tsf1.submitTissueSpecimenRecord(ts1.Id);
        
        Apexpages.currentPage().getParameters().put('row','4');
        //tsf1.addSpecimen(); 
        
        TissueSpecimenDetail__c ts2 = new TissueSpecimenDetail__c();
        ts2.Status__c = 'Accepted';
        ts2.Patient__c = p.Id;
        ts2.TrialPatient__c = tp.Id;
        ts2.ProcedureDate__c = date.newInstance(2012, 8, 10);
        ts2.Time_Point__c = 'Surgery';
        ts2.CRFId__c = crf.Id;
        ts2.NumberOfSamplesCollected__c = 1.0;
        insert ts2;
        
        ts2.Status__c = 'Accepted';
        update ts2;
        
        Core_Biopsy_Specimens__c cb2 = new Core_Biopsy_Specimens__c();
        cb2.SpecimenID__c = '1111';
        cb2.TissueSpecimenDetail__c = ts2.Id;
        cb2.Core_Specimen__c = '3';
        insert cb2;
        update cb2;
        
        
        Apexpages.currentPage().getParameters().put('trialPat',tp.Id);
        Apexpages.currentPage().getParameters().put('tsId',ts2.Id); 
        Apexpages.StandardController std2 = new Apexpages.StandardController(ts2);
        TissueSpecimenFormController tsf2 = new TissueSpecimenFormController(std2);
        
        //============ method "next" begins here ======================================
        tsf2.currentTab = 'Core BiopsyTab';
        tsf2.next();
        //============ method "next" ends here ======================================
        
        tsf2.saveCRF();
        tsf2.submitTissueSpecimenRecord(ts2.Id);
        
        Apexpages.currentPage().getParameters().put('row','5');
        tsf2.addSpecimen();
    }
   }
 }
    
	@isTest static void myUnitTest3() { // to satisfy  method "next" line 138 also coverage for "TissueSpecimenAfterTrigger " 
        // TO DO: implement unit test
        
        List<User> lstSiteUser = [Select u.IsActive, u.Id, SecurityCode__c From User u where IsActive = true and Profile.Name = 'Site User'];     
        System.runAs ( lstSiteUser[0] ) { 
        
        Account acc = new Account();
        
        List<Account> lstAccount = [Select a.Id From Account a limit 1];
        
        if(!lstAccount.isEmpty()){
            
        acc = lstAccount[0];
            
        Patient_Custom__c p = new Patient_Custom__c();
        p.Ethnicity__c = 'Hispanic or latino';
        p.Gender__c = 'female';
        p.Race__c = 'asian;indian;White';
        p.Last_Name__c = 'kumar';
        p.Status__c = 'approval not required';
        p.Birthdate__c = date.newInstance(1950, 08, 05);
        p.Institution__c = acc.Id;
        insert p;
        
        List<Patient_Custom__c> lstPatient = [select Name from Patient_Custom__c where Id = :P.Id];
        
        TrialPatient__c tp = new TrialPatient__c();
        tp.Patient_Id__c = p.Id;
        tp.FirstName__c = 'a';
        tp.LastName__c = 'b';
        insert tp;
        
        CRF__c crf = new CRF__c();
        crf.Status__c = 'Accepted';
        crf.Patient__c = p.Id;
        insert crf;
    
        TissueSpecimenDetail__c ts = new TissueSpecimenDetail__c();
        ts.Status__c = 'Accepted';
        ts.Patient__c = p.Id;
        ts.TrialPatient__c = tp.Id;
        ts.ProcedureDate__c = date.newInstance(2012, 8, 10);
        ts.Time_Point__c = 'Early Treatment';
        ts.Reason_all_samples_not_collected__c = 'Patient Refused';
        ts.CRFId__c = crf.Id;
        ts.NumberOfSamplesCollected__c = 1.0;
        insert ts;
        
        ts.Status__c = 'Accepted';
        update ts;
        
        Apexpages.currentPage().getParameters().put('trialPat',tp.Id);
        Apexpages.currentPage().getParameters().put('tsId',ts.Id); 
        Apexpages.StandardController std = new Apexpages.StandardController(ts);
        TissueSpecimenFormController tsf = new TissueSpecimenFormController(std);
        
        //============ method "next" begins here ======================================
        tsf.currentTab = 'Core BiopsyTab';
        tsf.next();
        //============ method "next" ends here ======================================
    }
   }
  }
  
	@isTest static void myUnitTest5() { // to satisfy  method "next" line 138 also coverage for "TissueSpecimenAfterTrigger " 
        // TO DO: implement unit test
        
        List<User> lstSiteUser = [Select u.IsActive, u.Id, SecurityCode__c From User u where IsActive = true and Profile.Name = 'Site User'];     
        System.runAs ( lstSiteUser[0] ) { 
        
        Account acc = new Account();
        
        List<Account> lstAccount = [Select a.Id From Account a limit 1];
        
        if(!lstAccount.isEmpty()){
            
        acc = lstAccount[0];
            
        Patient_Custom__c p = new Patient_Custom__c();
        p.Ethnicity__c = 'Hispanic or latino';
        p.Gender__c = 'female';
        p.Race__c = 'asian;indian;White';
        p.Last_Name__c = 'kumar';
        p.Status__c = 'approval not required';
        p.Birthdate__c = date.newInstance(1950, 08, 05);
        p.Institution__c = acc.Id;
        insert p;
        
        List<Patient_Custom__c> lstPatient = [select Name from Patient_Custom__c where Id = :P.Id];
        
        TrialPatient__c tp = new TrialPatient__c();
        tp.Patient_Id__c = p.Id;
        tp.FirstName__c = 'a';
        tp.LastName__c = 'b';
        insert tp;
        
        CRF__c crf = new CRF__c();
        crf.Status__c = 'Accepted';
        crf.Patient__c = p.Id;
        insert crf;
    
        TissueSpecimenDetail__c ts1 = new TissueSpecimenDetail__c();
        ts1.Status__c = 'Accepted';
        ts1.Patient__c = p.Id;
        ts1.TrialPatient__c = tp.Id;
        ts1.ProcedureDate__c = date.newInstance(2012, 8, 10);
        ts1.Time_Point__c = 'Early Treatment';
        ts1.Reason_all_samples_not_collected__c = 'Patient Refused';
        ts1.CRFId__c = crf.Id;
        ts1.NumberOfSamplesCollected__c = 1.0;
        insert ts1;
        
        ts1.Status__c = 'Approval Not Required';    //coverage for "TissueSpecimenAfterTrigger "
        update ts1;
        
        Core_Biopsy_Specimens__c cb = new Core_Biopsy_Specimens__c();
        cb.SpecimenID__c = '1111';
        cb.TissueSpecimenDetail__c = ts1.Id;
        cb.Core_Specimen__c = '3';
        cb.Shipped__c = 'No';
        insert cb;
        update cb;
        
        
        Apexpages.currentPage().getParameters().put('trialPat',tp.Id);
        Apexpages.currentPage().getParameters().put('tsId',ts1.Id); 
        Apexpages.StandardController std1 = new Apexpages.StandardController(ts1);
        TissueSpecimenFormController tsf1 = new TissueSpecimenFormController(std1);
        
        //============ method "next" begins here ======================================
        tsf1.currentTab = 'Core BiopsyTab';
        tsf1.next();
        //============ method "next" ends here ======================================
        
        //tsf1.saveCRF();
        tsf1.submitTissueSpecimenRecord(ts1.Id);
        
        Apexpages.currentPage().getParameters().put('row','6');
        tsf1.addSpecimen();
    }
   }
  }
  
  @isTest static void myUnitTest6() { // to satisfy "else if"  condition of method "next" line 112 "Early Treatment"
        // TO DO: implement unit test
        
        List<User> lstSiteUser = [Select u.IsActive, u.Id, SecurityCode__c From User u where IsActive = true and Profile.Name = 'Site User'];     
        System.runAs ( lstSiteUser[0] ) { 
        
        Account acc = new Account();
        
        List<Account> lstAccount = [Select a.Id From Account a limit 1];
        
        if(!lstAccount.isEmpty()){
            
        acc = lstAccount[0];
        
        Patient_Custom__c p = new Patient_Custom__c();
        p.Ethnicity__c = 'Hispanic or latino';
        p.Gender__c = 'female';
        p.Race__c = 'asian;indian;White';
        p.Last_Name__c = 'kumar';
        p.Status__c = 'approval not required';
        p.Birthdate__c = date.newInstance(1950, 08, 05);
        p.Institution__c = acc.Id;
        insert p;
        
        List<Patient_Custom__c> lstPatient = [select Name from Patient_Custom__c where Id = :P.Id];
        
        TrialPatient__c tp = new TrialPatient__c();
        tp.Patient_Id__c = p.Id;
        tp.FirstName__c = 'a';
        tp.LastName__c = 'b';
        insert tp;
        
        CRF__c crf = new CRF__c();
        crf.Status__c = 'Accepted';
        crf.Patient__c = p.Id;
        insert crf;
    
        TissueSpecimenDetail__c ts1 = new TissueSpecimenDetail__c();
        ts1.Status__c = 'Accepted';
        ts1.Patient__c = p.Id;
        ts1.TrialPatient__c = tp.Id;
        ts1.ProcedureDate__c = date.newInstance(2012, 8, 10);
        ts1.Time_Point__c = 'Pre-Treatment Re-Biopsy';
        ts1.CRFId__c = crf.Id;
        ts1.NumberOfSamplesCollected__c = 1.0;
        insert ts1;
        
        ts1.Status__c = 'Accepted';
        update ts1;
        
        Core_Biopsy_Specimens__c cb1 = new Core_Biopsy_Specimens__c();
        cb1.SpecimenID__c = '1111';
        cb1.TissueSpecimenDetail__c = ts1.Id;
        cb1.Core_Specimen__c = '3';
        insert cb1;
        update cb1;
        
        
        Apexpages.currentPage().getParameters().put('trialPat',tp.Id);
        Apexpages.currentPage().getParameters().put('tsId',ts1.Id); 
        Apexpages.StandardController std1 = new Apexpages.StandardController(ts1);
        TissueSpecimenFormController tsf1 = new TissueSpecimenFormController(std1);
        
        //============ method "next" begins here ======================================
        tsf1.currentTab = 'Core BiopsyTab';
        tsf1.next();
        //============ method "next" ends here ======================================
        
        tsf1.saveCRF();
        tsf1.submitTissueSpecimenRecord(ts1.Id);
        
        Apexpages.currentPage().getParameters().put('row','3');
        tsf1.addSpecimen();
        
		Apexpages.currentPage().getParameters().put('id',ts1.Id);
        tsf1.cancelTissueSpecimenRecord(); 
        
    }
   }
 } 
}