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
private class TestLabAndTestController {

    @isTest static void myUnitTest() {
        // TO DO: implement unit test
        
        List<User> lstSiteUser = [Select u.IsActive, u.Id, SecurityCode__c From User u where IsActive = true and Profile.Name = 'Site User'];     
        System.runAs ( lstSiteUser[0] ) { 
        
        Account inst1 = new Account();
        
        List<Account> lstAccount = [Select a.Id From Account a limit 1];
        
        if(!lstAccount.isEmpty()){
            
        inst1 = lstAccount[0];
        
        Patient_Custom__c pc = new Patient_Custom__c();
        pc.First_Name__c = 'test';
        pc.Last_Name__c = 'test1';
        pc.Gender__c = 'Male';
        pc.Birthdate__c = date.newInstance(1998, 7, 7);
        pc.Race__c = 'White';
        pc.Ethnicity__c = 'Not Hispanic or Latino';
        pc.Institution__c = inst1.Id;
        pc.Medical_Record_Number__c = '3434';
        insert pc;
        
        Trial__c tri = new Trial__c();
        tri.Name = 'Test';
        insert tri;
    
        TrialPatient__c triPat = new TrialPatient__c();
        triPat.Trial_Id__c = tri.Id;
        triPat.Patient_Id__c = pc.Id;
        insert triPat;
        
        // for all "ELSE" condition starting from line 93 to 133 , since all booleans are False================STARTED HERE=======================
        
        Lab_and_Test__c lat = new Lab_and_Test__c();
        lat.TrialPatient__c = triPat.Id;
        lat.Leukocytes__c = false;
        lat.Absolute_Neutrophil_Count_ANC__c = false;
        lat.Platelets__c = false;
        lat.Total_Bilirubin__c = false;
        lat.AST__c = false;
        lat.ALT__c = false;
        lat.Creatinine__c = false;
        lat.MUGA_Scan__c = false;
        lat.Cardiac_Echo__c = false;
        lat.Leukocytes_Institutional_Reference_Range__c = '12.0-34';
        lat.ANC_Industrial_Reference_Range__c = '12.0-34';
        lat.Platelets_Institutional_Reference_Range__c = '12.0-34';
        lat.Total_Bilirubin_Institutional_Reference__c = '12.0-34';
        lat.AST_Institutional_Reference_Range__c = '12.0-34';
        lat.ALT_Institutional_Reference_Range__c = '12.0-34';
        lat.Creatinine_Institutional_Reference_Range__c = '12.0-34';
        
        lat.Collection_Date__c = date.newInstance(2009, 8, 8);
        lat.MUGA_Scan_Date__c = date.newInstance(2009, 8, 8);
        lat.Collection_Date_for_Investigative_Agent__c = date.newInstance(2013, 8, 8);
        lat.Cardiac_Echo_Date__c = date.newInstance(2009, 8, 8);
        lat.Status__c = 'Approval Pending';
        insert lat;
        /*lat.Status__c = 'Accepted';     
        update lat;*/
        
        Arm__c ar = new Arm__c();  // to satisfy else part line 155
        ar.Name = 'test arm';
        insert ar;
        
        ArmPatient__c arm = new ArmPatient__c();
        arm.assignedToPatient__c = false;      // to satisfy else part line 155 since , assignedToPatient__c = false (see where cond line 147)
        arm.TrialPatient__c = triPat.Id; 
        arm.Arm_Id__c = ar.Id;
        insert arm;
        
        Apexpages.currentPage().getParameters().put('trialPat',triPat.Id);
        Apexpages.currentPage().getParameters().put('labAndTestId',lat.Id);
        ApexPages.StandardController controller = new ApexPages.StandardController(lat);
        LabAndTestController labObj = new LabAndTestController(controller);
        
        // for all "ELSE" condition starting from line 93 to 133 , since all booleans are False=================ENDS here===========================
        Lab_and_Test__c lat1 = new Lab_and_Test__c();
        
        Apexpages.currentPage().getParameters().put('trialPat',triPat.Id); 
        Apexpages.currentPage().getParameters().put('labAndTestId',null); // to satisfy "else if" line 136
        ApexPages.StandardController controller1 = new ApexPages.StandardController(lat1);
        LabAndTestController labObj1 = new LabAndTestController(controller1);
        
        //========== method "insertCRF" begins here ================================
        labObj1.insertCRF();
        
        Apexpages.currentPage().getParameters().put('trialPat',triPat.Id);
        Apexpages.currentPage().getParameters().put('labAndTestId',lat.Id);
        labObj.insertCRF();
        
        //========== method "insertCRF" ends here ================================
        
        //========== method "next" begins here====================================
        
        labObj.next();
        Apexpages.currentPage().getParameters().put('tabNext','LabTests');
        labObj.currentTab = 'LabTests';
        labObj.next();
        
        Apexpages.currentPage().getParameters().put('tabNext','CardiacFunctionTest');
        labObj.currentTab = 'CardiacFunctionTest';
        labObj.next(); 
        
        //========== method "next" end here====================================
        
        //========== method "previous" begins here ===========================
        
        labObj.previous();
        Apexpages.currentPage().getParameters().put('trialPat',triPat.Id);
        Apexpages.currentPage().getParameters().put('tabPrevious','LabTests');
        labObj.previous();
        
        Apexpages.currentPage().getParameters().put('trialPat',triPat.Id);
        Apexpages.currentPage().getParameters().put('tabPrevious','InvestigativeAgentSpecificTests');
        labObj.previous();
        
        //========== method "previous" ends here ============================
        
        labObj.signAndSubmit();
        labObj.editCRF();
        }
    }
  }
  
  @isTest static void myUnitTest4() {
        // TO DO: implement unit test
        
        List<User> lstSiteUser = [Select u.IsActive, u.Id, SecurityCode__c From User u where IsActive = true and Profile.Name = 'Site User'];     
        System.runAs ( lstSiteUser[0] ) { 
        
        Account inst1 = new Account();
        
        List<Account> lstAccount = [Select a.Id From Account a limit 1];
        
        if(!lstAccount.isEmpty()){
            
        inst1 = lstAccount[0];
        
        Patient_Custom__c pc = new Patient_Custom__c();
        pc.First_Name__c = 'test';
        pc.Last_Name__c = 'test1';
        pc.Gender__c = 'Male';
        pc.Birthdate__c = date.newInstance(1998, 7, 7);
        pc.Race__c = 'White';
        pc.Ethnicity__c = 'Not Hispanic or Latino';
        pc.Institution__c = inst1.Id;
        pc.Medical_Record_Number__c = '3434';
        insert pc;
        
        Trial__c tri = new Trial__c();
        tri.Name = 'Test';
        insert tri;
    
        TrialPatient__c triPat = new TrialPatient__c();
        triPat.Trial_Id__c = tri.Id;
        triPat.Patient_Id__c = pc.Id;
        insert triPat;
        
        // for all "ELSE" condition starting from line 93 to 133 , since all booleans are False================STARTED HERE=======================
        
        Lab_and_Test__c lat = new Lab_and_Test__c();
        lat.TrialPatient__c = triPat.Id;
        lat.Leukocytes__c = false;
        lat.Absolute_Neutrophil_Count_ANC__c = false;
        lat.Platelets__c = false;
        lat.Total_Bilirubin__c = false;
        lat.AST__c = false;
        lat.ALT__c = false;
        lat.Creatinine__c = false;
        lat.MUGA_Scan__c = false;
        lat.Cardiac_Echo__c = false;
        lat.Leukocytes_Institutional_Reference_Range__c = '12.0-34';
        lat.ANC_Industrial_Reference_Range__c = '12.0-34';
        lat.Platelets_Institutional_Reference_Range__c = '12.0-34';
        lat.Total_Bilirubin_Institutional_Reference__c = '12.0-34';
        lat.AST_Institutional_Reference_Range__c = '12.0-34';
        lat.ALT_Institutional_Reference_Range__c = '12.0-34';
        lat.Creatinine_Institutional_Reference_Range__c = '12.0-34';
        
        lat.Collection_Date__c = date.newInstance(2009, 8, 8);
        lat.MUGA_Scan_Date__c = date.newInstance(2009, 8, 8);
        lat.Collection_Date_for_Investigative_Agent__c = date.newInstance(2013, 8, 8);
        lat.Cardiac_Echo_Date__c = date.newInstance(2009, 8, 8);
        lat.Status__c = 'Approval Pending';
        insert lat;
        /*lat.Status__c = 'Accepted';     
        update lat;*/
        
        Arm__c ar = new Arm__c();  // to satisfy else part line 155
        ar.Name = 'test arm';
        insert ar;
        
        ArmPatient__c arm = new ArmPatient__c();
        arm.assignedToPatient__c = false;      // to satisfy else part line 155 since , assignedToPatient__c = false (see where cond line 147)
        arm.TrialPatient__c = triPat.Id; 
        arm.Arm_Id__c = ar.Id;
        insert arm;
        
        Apexpages.currentPage().getParameters().put('trialPat',triPat.Id);
        Apexpages.currentPage().getParameters().put('labAndTestId',lat.Id);
        ApexPages.StandardController controller = new ApexPages.StandardController(lat);
        LabAndTestController labObj = new LabAndTestController(controller);
        
        // for all "ELSE" condition starting from line 93 to 133 , since all booleans are False=================ENDS here===========================
        Lab_and_Test__c lat1 = new Lab_and_Test__c();
        
        Apexpages.currentPage().getParameters().put('trialPat',triPat.Id); 
        Apexpages.currentPage().getParameters().put('labAndTestId',null); // to satisfy "else if" line 136
        ApexPages.StandardController controller1 = new ApexPages.StandardController(lat1);
        LabAndTestController labObj1 = new LabAndTestController(controller1);
        
        labObj.resendCode();
        
        Apexpages.currentPage().getParameters().put('trialPat',triPat.Id);
        Apexpages.currentPage().getParameters().put('labAndTestId',lat.Id);
        labObj.customCancel();
        
        Apexpages.currentPage().getParameters().put('trialPat',triPat.Id);
        Apexpages.currentPage().getParameters().put('labAndTestId',lat.Id);
        labObj1.customCancel();
        }
    }
  }
      @isTest static void myUnitTest1() { // to satisfy "if" cond line 149
        // TO DO: implement unit test
        
        List<User> lstSiteUser = [Select u.IsActive, u.Id, SecurityCode__c From User u where IsActive = true and Profile.Name = 'Site User'];     
        System.runAs ( lstSiteUser[0] ) { 
        
        Account inst1 = new Account();
        
        List<Account> lstAccount = [Select a.Id From Account a limit 1];
        
        if(!lstAccount.isEmpty()){
            
        inst1 = lstAccount[0];
        
        Patient_Custom__c pc = new Patient_Custom__c();
        pc.First_Name__c = 'test';
        pc.Last_Name__c = 'test1';
        pc.Gender__c = 'Male';
        pc.Birthdate__c = date.newInstance(1998, 7, 7);
        pc.Race__c = 'White';
        pc.Ethnicity__c = 'Not Hispanic or Latino';
        pc.Institution__c = inst1.Id;
        pc.Medical_Record_Number__c = '3434';
        insert pc;
        
        Trial__c tri = new Trial__c();
        tri.Name = 'Test';
        insert tri;
    
        TrialPatient__c triPat = new TrialPatient__c();
        triPat.Trial_Id__c = tri.Id;
        triPat.Patient_Id__c = pc.Id;
        insert triPat;
        
        Arm__c ar = new Arm__c(); // to satisfy if part line 149
        ar.Name = 'test arm';
        insert ar;
        
        ArmPatient__c arm = new ArmPatient__c();
        arm.assignedToPatient__c = true; // to satisfy if part line 149 since , assignedToPatient__c = true (see where cond line 147)
        arm.TrialPatient__c = triPat.Id; 
        arm.Arm_Id__c = ar.Id;
        insert arm;
        
        // for all "IF" condition starting from line 91 to 131 , since all booleans are TRUE======STARTED HERE======================================
        
        Lab_and_Test__c lat = new Lab_and_Test__c();
        lat.TrialPatient__c = triPat.Id;
        lat.Leukocytes__c = true;
        lat.Absolute_Neutrophil_Count_ANC__c = true;
        lat.Platelets__c = true;
        lat.Total_Bilirubin__c = true;
        lat.AST__c = true;
        lat.ALT__c = true;
        lat.Creatinine__c = true;
        lat.MUGA_Scan__c = true;
        lat.Cardiac_Echo__c = true;
        lat.Collection_Date__c = date.newInstance(2009, 8, 8);
        lat.MUGA_Scan_Date__c = date.newInstance(2009, 8, 8);
        lat.Collection_Date_for_Investigative_Agent__c = date.newInstance(2009, 8, 8);
        lat.Cardiac_Echo_Date__c = date.newInstance(2009, 8, 8);
        lat.Status__c = 'Approval Pending';
        insert lat;
        //lat.Status__c = 'Accepted';     
        //update lat;
        
        Apexpages.currentPage().getParameters().put('trialPat',triPat.Id);
        Apexpages.currentPage().getParameters().put('labAndTestId',lat.Id);
        ApexPages.StandardController controller = new ApexPages.StandardController(lat);
        LabAndTestController labObj = new LabAndTestController(controller); 
        
        // for all "IF" condition starting from line 91 to 131 , since all booleans are TRUE======END HERE===================
        
        //=================method "next" begins here======================
        
        labObj.next();
        Apexpages.currentPage().getParameters().put('tabNext','LabTests');
        labObj.currentTab = 'LabTests';
        labObj.next();
        
        Apexpages.currentPage().getParameters().put('tabNext','CardiacFunctionTest');
        labObj.currentTab = 'CardiacFunctionTest';
        labObj.next(); 
        
        labObj.currentTab = 'InvestigativeAgentSpecificTests';
        labObj.next();
        }
      }
   }
   
   @isTest static void myUnitTest3() { // to satisfy "if" cond line 149
        // TO DO: implement unit test
        
        List<User> lstSiteUser = [Select u.IsActive, u.Id, SecurityCode__c From User u where IsActive = true and Profile.Name = 'Site User'];     
        System.runAs ( lstSiteUser[0] ) { 
        
        Account inst1 = new Account();
        
        List<Account> lstAccount = [Select a.Id From Account a limit 1];
        
        if(!lstAccount.isEmpty()){
            
        inst1 = lstAccount[0];
        
        Patient_Custom__c pc = new Patient_Custom__c();
        pc.First_Name__c = 'test';
        pc.Last_Name__c = 'test1';
        pc.Gender__c = 'Male';
        pc.Birthdate__c = date.newInstance(1998, 7, 7);
        pc.Race__c = 'White';
        pc.Ethnicity__c = 'Not Hispanic or Latino';
        pc.Institution__c = inst1.Id;
        pc.Medical_Record_Number__c = '3434';
        insert pc;
        
        Trial__c tri = new Trial__c();
        tri.Name = 'Test';
        insert tri;
    
        TrialPatient__c triPat = new TrialPatient__c();
        triPat.Trial_Id__c = tri.Id;
        triPat.Patient_Id__c = pc.Id;
        insert triPat;
        
        Arm__c ar = new Arm__c(); // to satisfy if part line 149
        ar.Name = 'test arm';
        insert ar;
        
        ArmPatient__c arm = new ArmPatient__c();
        arm.assignedToPatient__c = true; // to satisfy if part line 149 since , assignedToPatient__c = true (see where cond line 147)
        arm.TrialPatient__c = triPat.Id; 
        arm.Arm_Id__c = ar.Id;
        insert arm;
        
        // for all "IF" condition starting from line 91 to 131 , since all booleans are TRUE======STARTED HERE======================================
        
        Lab_and_Test__c lat = new Lab_and_Test__c();
        lat.TrialPatient__c = triPat.Id;
        lat.Leukocytes__c = true;
        lat.Absolute_Neutrophil_Count_ANC__c = true;
        lat.Platelets__c = true;
        lat.Total_Bilirubin__c = true;
        lat.AST__c = true;
        lat.ALT__c = true;
        lat.Creatinine__c = true;
        lat.MUGA_Scan__c = true;
        lat.Cardiac_Echo__c = true;
        lat.Collection_Date__c = date.newInstance(2009, 8, 8);
        lat.MUGA_Scan_Date__c = date.newInstance(2009, 8, 8);
        lat.Collection_Date_for_Investigative_Agent__c = date.newInstance(2009, 8, 8);
        lat.Cardiac_Echo_Date__c = date.newInstance(2009, 8, 8);
        lat.Status__c = 'Approval Pending';
        insert lat;
        //lat.Status__c = 'Accepted';     
        //update lat;
        
        Apexpages.currentPage().getParameters().put('trialPat',triPat.Id);
        Apexpages.currentPage().getParameters().put('labAndTestId',lat.Id);
        ApexPages.StandardController controller = new ApexPages.StandardController(lat);
        LabAndTestController labObj = new LabAndTestController(controller); 
        
        // for all "IF" condition starting from line 91 to 131 , since all booleans are TRUE======END HERE===================
        
        //=================method "next" begins here======================
        
        Apexpages.currentPage().getParameters().put('tabNext','InvestigativeAgentSpecificTests');
        labObj.nextTabName = 'InvestigativeAgentSpecificTests';
        labObj.next();
        
        Apexpages.currentPage().getParameters().put('tabNext','saveAndClose');
        labObj.nextTabName = 'saveAndClose';
        labObj.next();
        
        labObj.currentTab = 'CommentsandAttachments';
        labObj.next();
        
        //=================method "next" ends here========================
        
        //========== method "previous" begins here ===========================
        
        labObj.previous();
        Apexpages.currentPage().getParameters().put('trialPat',triPat.Id);
        Apexpages.currentPage().getParameters().put('tabPrevious','InvestigativeAgentSpecificTests');
        labObj.previous();
        
        //========== method "previous" ends here ============================
        }
      }
   }
   
    @isTest static void myUnitTest2() { // to satisfy error condition of "next" method
        // TO DO: implement unit test
        
        List<User> lstSiteUser = [Select u.IsActive, u.Id, SecurityCode__c From User u where IsActive = true and Profile.Name = 'Site User'];     
        System.runAs ( lstSiteUser[0] ) { 
        
        Account inst1 = new Account();
        
        List<Account> lstAccount = [Select a.Id From Account a limit 1];
        
        if(!lstAccount.isEmpty()){
            
        inst1 = lstAccount[0];
        
        Patient_Custom__c pc = new Patient_Custom__c();
        pc.First_Name__c = 'test';
        pc.Last_Name__c = 'test1';
        pc.Gender__c = 'Male';
        pc.Birthdate__c = date.newInstance(1998, 8, 9);
        pc.Race__c = 'White';
        pc.Ethnicity__c = 'Not Hispanic or Latino';
        pc.Institution__c = inst1.Id;
        pc.Medical_Record_Number__c = '3434';
        insert pc;
    
        TrialPatient__c triPat = new TrialPatient__c();
        triPat.Patient_Id__c = pc.Id;
        insert triPat;
        
        Lab_and_Test__c lat = new Lab_and_Test__c();
        lat.TrialPatient__c = triPat.Id;
        lat.Leukocytes__c = true;
        lat.Absolute_Neutrophil_Count_ANC__c = true;
        lat.Platelets__c = true;
        lat.Total_Bilirubin__c = true;
        lat.AST__c = true;
        lat.ALT__c = true;
        lat.Creatinine__c = true;
        lat.MUGA_Scan__c = true;
        lat.Cardiac_Echo__c = true;
        lat.Collection_Date__c = date.newInstance(2012, 8, 8);
        lat.MUGA_Scan_Date__c = date.newInstance(2012, 8, 8);
        lat.Collection_Date_for_Investigative_Agent__c = date.newInstance(2012, 8, 8);
        lat.Cardiac_Echo_Date__c = date.newInstance(2012, 8, 8);
        lat.Status__c = 'Approval Pending';
        insert lat;
        lat.Status__c = 'Accepted';     
        update lat;
        
        Apexpages.currentPage().getParameters().put('trialPat',triPat.Id);
        Apexpages.currentPage().getParameters().put('labAndTestId',lat.Id);
        ApexPages.StandardController controller = new ApexPages.StandardController(lat);
        LabAndTestController labObj = new LabAndTestController(controller); 
        
        labObj.next();
        Apexpages.currentPage().getParameters().put('tabNext','LabTests');
        labObj.currentTab = 'LabTests';
        labObj.next();
        
        Apexpages.currentPage().getParameters().put('tabNext','CardiacFunctionTest');
        labObj.currentTab = 'CardiacFunctionTest';
        labObj.next(); 
        
        labObj.currentTab = 'InvestigativeAgentSpecificTests';
        labObj.next();
        
            }
        }
    }
    
    @isTest static void myUnitTest5() { // to satisfy error condition of "next" method
        // TO DO: implement unit test
        
        List<User> lstSiteUser = [Select u.IsActive, u.Id, SecurityCode__c From User u where IsActive = true and Profile.Name = 'Site User'];     
        System.runAs ( lstSiteUser[0] ) { 
        
        Account inst1 = new Account();
        
        List<Account> lstAccount = [Select a.Id From Account a limit 1];
        
        if(!lstAccount.isEmpty()){
            
        inst1 = lstAccount[0];
        
        Patient_Custom__c pc = new Patient_Custom__c();
        pc.First_Name__c = 'test';
        pc.Last_Name__c = 'test1';
        pc.Gender__c = 'Male';
        pc.Birthdate__c = date.newInstance(1998, 8, 9);
        pc.Race__c = 'White';
        pc.Ethnicity__c = 'Not Hispanic or Latino';
        pc.Institution__c = inst1.Id;
        pc.Medical_Record_Number__c = '3434';
        insert pc;
    
        TrialPatient__c triPat = new TrialPatient__c();
        triPat.Patient_Id__c = pc.Id;
        insert triPat;
        
        Lab_and_Test__c lat1 = new Lab_and_Test__c();
        lat1.TrialPatient__c = triPat.Id;
        lat1.Cardiac_Echo_Date__c = date.newInstance(2012, 8, 8);
        lat1.Status__c = 'Approval Pending';
        insert lat1;
        lat1.Status__c = 'Accepted';     
        update lat1;
        
        Apexpages.currentPage().getParameters().put('trialPat',triPat.Id);
        Apexpages.currentPage().getParameters().put('labAndTestId',lat1.Id);
        ApexPages.StandardController controller1 = new ApexPages.StandardController(lat1);
        LabAndTestController labObj1 = new LabAndTestController(controller1); 
        
        Apexpages.currentPage().getParameters().put('tabNext','CardiacFunctionTest');
        labObj1.currentTab = 'CardiacFunctionTest';
        labObj1.next(); 
            }
        }
    }
    
    @isTest static void LabAndTestAfterTrigger() { 
        // TO DO: implement unit test
        
        List<RecordType> lstDCC = [select id,Name,SobjectType from RecordType where SobjectType = 'Account' and Name = 'DCC'];
        List<RecordType> lstInst = [select id,Name,SobjectType from RecordType where SobjectType = 'Account' and Name = 'Institution'];
        
        Account inst1 = new Account();
        inst1.Name = 'test';
        inst1.RecordTypeId = lstInst[0].Id;
        insert inst1;
        
        inst1.RecordTypeId = lstDCC[0].Id;
        update inst1;
        
        Patient_Custom__c pc = new Patient_Custom__c();
        pc.Last_Name__c = 'test1';
        pc.Gender__c = 'Male';
        pc.Birthdate__c = date.newInstance(1998, 8, 9);
        pc.Race__c = 'White';
        pc.Ethnicity__c = 'Not Hispanic or Latino';
        pc.Institution__c = inst1.Id;
        insert pc;
    
        TrialPatient__c triPat = new TrialPatient__c();
        triPat.Patient_Id__c = pc.Id;
        insert triPat;
        
        Lab_and_Test__c lat = new Lab_and_Test__c();
        lat.TrialPatient__c = triPat.Id;
        lat.Leukocytes__c = true;
        lat.Absolute_Neutrophil_Count_ANC__c = true;
        lat.Platelets__c = true;
        lat.Total_Bilirubin__c = true;
        lat.AST__c = true;
        lat.ALT__c = true;
        lat.Creatinine__c = true;
        lat.MUGA_Scan__c = true;
        lat.Cardiac_Echo__c = true;
        lat.Collection_Date__c = date.newInstance(2012, 8, 8);
        lat.MUGA_Scan_Date__c = date.newInstance(2012, 8, 8);
        lat.Collection_Date_for_Investigative_Agent__c = date.newInstance(2012, 8, 8);
        lat.Cardiac_Echo_Date__c = date.newInstance(2012, 8, 8);
        lat.Status__c = 'Approval Pending';
        insert lat;
        update lat;
    }
}