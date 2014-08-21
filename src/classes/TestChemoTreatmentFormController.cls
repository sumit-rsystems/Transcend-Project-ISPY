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
private class TestChemoTreatmentFormController {

   
       @isTest static void myUnitTest1() {
        // TO DO: implement unit test
        Profile SiteProp = [ Select p.UserType, p.Name, (Select u.IsActive, u.Id, SecurityCode__c From Users u where IsActive = true) From Profile p where Name = 'Site User'];
        List<User> lstSiteUser = SiteProp.Users;     
        System.runAs ( lstSiteUser[0] ) { 
            
        Account acc = new Account();

        List<Account> lstAccount = [select Id from Account limit 1]; 
            
        if(!lstAccount.isEmpty()){
                
        acc = lstAccount[0];           // newly added logic to overcome the error of "setup and nonsetup" object
            
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
            
        Chemo_Treatment__c chemo = new Chemo_Treatment__c();
        chemo.TrialPatient__c = tp.Id;
        chemo.Cycle_number__c = 2.0;
        chemo.Date_of_therapy__c = date.newInstance(2012, 6, 6);
        chemo.Status__c = 'Approval Pending';
        insert chemo;
        update chemo;
         
        Apexpages.currentPage().getParameters().put('trialPat',tp.Id); 
        Apexpages.StandardController std1 = new Apexpages.StandardController(chemo);
        ChemoTreatmentFormController ctfc1 = new ChemoTreatmentFormController(std1);
        ctfc1.saveMainCRF();
        
        Apexpages.currentPage().getParameters().put('trialPat',tp.Id); 
        Apexpages.currentPage().getParameters().put('formId',chemo.Id);
        
        Apexpages.StandardController std = new Apexpages.StandardController(chemo);
        ChemoTreatmentFormController ctfc = new ChemoTreatmentFormController(std);
        
        ctfc.getMedicationSNO();
        
        ctfc.saveMainCRF();
        ctfc.addOtherAgent();
        
        Apexpages.currentPage().getParameters().put('nextTab','saveAndClose');
        ctfc.nextTabName = 'saveAndClose';
        ctfc.next();
        
        ctfc.currentTab = 'chemoAdminTab';
        ctfc.next();
        
        ctfc.currentTab = 'growthFactorsTab';
        ctfc.next();
        
        ctfc.currentTab = 'growthFactorsTab';
        ctfc.previous();
        
        ctfc.currentTab = 'conMedTab';
        ctfc.next();
        
        ctfc.currentTab = 'conMedTab';
        ctfc.previous();
        
        ctfc.currentTab = 'attachmentTab';
        ctfc.next();
        
        ctfc.currentTab = 'attachmentTab';
        ctfc.previous();
        
        ctfc.currentTab = 'completeTab';
        ctfc.previous();
        
        ctfc.addMedication();
        
        ctfc.updateMedication();
        
        ctfc.saveMedication();
        
        ctfc.editMedication();
        
        Apexpages.currentPage().getParameters().put('agentName','Paclitaxel (Taxol)');
        Apexpages.currentPage().getParameters().put('isAgentChecked','true');
        ctfc.executeChemoTherapyRule();
        
        Apexpages.currentPage().getParameters().put('agentName','Paclitaxel (Taxol)');
        Apexpages.currentPage().getParameters().put('isAgentChecked','false');
        ctfc.executeChemoTherapyRule();
        
        Apexpages.currentPage().getParameters().put('agentName','Doxorubicin (Adriamycin)');
        Apexpages.currentPage().getParameters().put('isAgentChecked','true');
        ctfc.executeChemoTherapyRule();
        
        Apexpages.currentPage().getParameters().put('agentName','Doxorubicin (Adriamycin)');
        Apexpages.currentPage().getParameters().put('isAgentChecked','false');
        ctfc.executeChemoTherapyRule();
        
     }
   }
 }
    
      @isTest static void myUnitTest2() {
        // TO DO: implement unit test
        Profile SiteProp = [ Select p.UserType, p.Name, (Select u.IsActive, u.Id, SecurityCode__c From Users u where IsActive = true) From Profile p where Name = 'Site User'];
        List<User> lstSiteUser = SiteProp.Users;     
        System.runAs ( lstSiteUser[0] ) { 
            
        Account acc = new Account();

        List<Account> lstAccount = [select Id from Account limit 1]; 
            
        if(!lstAccount.isEmpty()){
                
        acc = lstAccount[0];           // newly added logic to overcome the error of "setup and nonsetup" object
        
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
            
        Chemo_Treatment__c chemo = new Chemo_Treatment__c();
        chemo.TrialPatient__c = tp.Id;
        chemo.Cycle_number__c = 2.0;
        chemo.Date_of_therapy__c = date.newInstance(2012, 6, 6);
        chemo.Status__c = 'Accepted';
        insert chemo;
        update chemo;
            
        Arm__c arm = new Arm__c();
        arm.Name = 'test';
        insert arm;
        
        ArmPatient__c armPat = new ArmPatient__c();
        armPat.Patient_Id__c = p.Id;
        armPat.TrialPatient__c = tp.Id;
        armPat.Arm_Id__c = arm.Id;
        insert armPat;
        
        Growth_Factor__c gro = new Growth_Factor__c();
        gro.Chemo_Treatment__c = chemo.Id;
        insert gro;
        
        Concomitant_Medication__c conc = new Concomitant_Medication__c();
        conc.Chemo_Treatment__c = chemo.Id;
        insert conc;
        
        Agent__c agent = new Agent__c();
        agent.Total_Dose_Unit__c = 'mg';
        agent.Display_Order__c = 100.0;
        agent.Name = 'Paclitaxel (Taxol)';
        insert agent;
        
        Chemo_Therapy_Regimen__c ctrc = new Chemo_Therapy_Regimen__c();
        ctrc.Chemo_Treatment__c = chemo.Id;
        ctrc.Agent__c = agent.Id;
        insert ctrc;
        update ctrc; 
        
        Apexpages.currentPage().getParameters().put('trialPat',tp.Id); 
        Apexpages.currentPage().getParameters().put('formId',chemo.Id);
        
        Apexpages.StandardController std = new Apexpages.StandardController(chemo);
        ChemoTreatmentFormController ctfc = new ChemoTreatmentFormController(std);
        
        ctfc.resendCode();
        ctfc.cloneCRF();
        ctfc.editCRF();
        ctfc.signAndSubmit();
        
        Apexpages.currentPage().getParameters().put('agentName','Neratinib'); 
        Apexpages.currentPage().getParameters().put('isAgentChecked','true');
        ctfc.executeChemoTherapyRule();
        
        Apexpages.currentPage().getParameters().put('agentName','Neratinib');
        Apexpages.currentPage().getParameters().put('isAgentChecked','false');
        ctfc.executeChemoTherapyRule();
        
        Apexpages.currentPage().getParameters().put('agentName','ABT-888');
        Apexpages.currentPage().getParameters().put('isAgentChecked','true');
        ctfc.executeChemoTherapyRule();
        
        Apexpages.currentPage().getParameters().put('agentName','ABT-888');
        Apexpages.currentPage().getParameters().put('isAgentChecked','false');
        ctfc.executeChemoTherapyRule();
        
        ctfc.cancelCRF();
        
        Apexpages.currentPage().getParameters().put('recordId',chemo.Id);
        ctfc.cancelMedication();
        
        Apexpages.currentPage().getParameters().put('recordId',chemo.Id);
        ctfc.removeMedication();
       }
    }
 }
    @isTest static void myUnitTestforTriggerChemoRegimen3() {
        // TO DO: implement unit test
        Profile SiteProp = [ Select p.UserType, p.Name, (Select u.IsActive, u.Id, SecurityCode__c From Users u where IsActive = true) From Profile p where Name = 'Site User'];
        List<User> lstSiteUser = SiteProp.Users;     
        System.runAs ( lstSiteUser[0] ) { 
            
        Account acc = new Account();

        List<Account> lstAccount = [select Id from Account limit 1]; 
            
        if(!lstAccount.isEmpty()){
                
        acc = lstAccount[0];           // newly added logic to overcome the error of "setup and nonsetup" object
        
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
        
        Chemo_Treatment__c chemo = new Chemo_Treatment__c();
        chemo.TrialPatient__c = tp.Id;
        chemo.Cycle_number__c = 2.0;
        chemo.Date_of_therapy__c = date.newInstance(2012, 6, 6);
        insert chemo;
            
        Arm__c arm = new Arm__c();
        arm.Name = 'test';
        insert arm;
        
        ArmPatient__c armPat = new ArmPatient__c();
        armPat.Patient_Id__c = p.Id;
        armPat.TrialPatient__c = tp.Id;
        armPat.Arm_Id__c = arm.Id;
        insert armPat;
            
        Growth_Factor__c gro = new Growth_Factor__c();
        gro.Chemo_Treatment__c = chemo.Id;
        insert gro;
        
        Concomitant_Medication__c conc = new Concomitant_Medication__c();
        conc.Chemo_Treatment__c = chemo.Id;
        insert conc;
        
        Agent__c agent = new Agent__c();
        agent.Total_Dose_Unit__c = 'mg';
        agent.Display_Order__c = 100.0;
        agent.Name = 'Cyclophosphamide (Cytoxan)';
        insert agent;
        
        Chemo_Therapy_Regimen__c ctrc = new Chemo_Therapy_Regimen__c();
        ctrc.Chemo_Treatment__c = chemo.Id;
        ctrc.Agent__c = agent.Id;
        insert ctrc;
        update ctrc;
      }
    }
  }
  @isTest static void myUnitTest4() {
        // TO DO: implement unit test
        Profile SiteProp = [ Select p.UserType, p.Name, (Select u.IsActive, u.Id, SecurityCode__c From Users u where IsActive = true) From Profile p where Name = 'Site User'];
        List<User> lstSiteUser = SiteProp.Users;     
        System.runAs ( lstSiteUser[0] ) { 
            
        Account acc = new Account();

        List<Account> lstAccount = [select Id from Account limit 1]; 
            
        if(!lstAccount.isEmpty()){
                
        acc = lstAccount[0];           // newly added logic to overcome the error of "setup and nonsetup" object
            
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
            
        Chemo_Treatment__c chemo = new Chemo_Treatment__c();
        chemo.TrialPatient__c = tp.Id;
        chemo.Cycle_number__c = 2.0;
        chemo.Date_of_therapy__c = date.newInstance(2012, 6, 6);
        chemo.Status__c = 'Approval Pending';
        insert chemo;
        update chemo;
         
        Growth_Factor__c gro = new Growth_Factor__c();
        gro.Chemo_Treatment__c = chemo.Id;
        insert gro;
        
        Concomitant_Medication__c conc = new Concomitant_Medication__c();
        conc.Chemo_Treatment__c = chemo.Id;
        insert conc;
        
        Chemo_Therapy_Regimen__c ctrc = new Chemo_Therapy_Regimen__c();
        ctrc.Chemo_Treatment__c = chemo.Id;
        //ctrc.Agent__c = agent.Id;
        insert ctrc;
        update ctrc; 
        
        
        
     }
   }
 }
}