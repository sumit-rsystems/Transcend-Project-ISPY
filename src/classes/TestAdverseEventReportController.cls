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
private class TestAdverseEventReportController {

 
      @isTest static void myUnitTest() {
        // TO DO: implement unit test
       
        List<User> thisUser = [ select u.Id , u.IsActive from User u where IsActive = true and id =: userinfo.getUserId()];
        System.runAs (thisUser[0]){
            
            Account acc = new Account();

            List<Account> lstAccount = [select Id from Account limit 1]; 
            
            if(!lstAccount.isEmpty()){
                
            acc = lstAccount[0];           // newly added logic to overcome the error of "setup and nonsetup" object
        
            Patient_Custom__c p = new Patient_Custom__c();
            p.Birthdate__c = date.newInstance(1980, 08, 05);
            p.Institution__c = acc.Id;
            p.Last_Name__c = 'test'; // patient
            p.Gender__c = 'Male';
            p.Race__c = 'White';
            p.Ethnicity__c = 'Not Hispanic or Latino';
            insert p;
            
            List<Patient_Custom__c> lstPat = [Select p.Id From Patient_Custom__c p where id =: p.Id];
            
            Trial__c tObj = new Trial__c();
            tObj.Name = 'ISPY 2 Trial';
            tObj.Start_Date__c = date.newInstance(2012, 7, 7);
            insert tObj;
            
            TrialPatient__c tp = new TrialPatient__c();
            tp.Patient_Id__c = lstPat[0].Id;
            tp.Trial_Id__c = tObj.Id;
            tp.Subject_Id__c = '1234';
            insert tp;
            
            BaselineSymptomsForm__c base = new BaselineSymptomsForm__c();
            base.TrialPatient__c = tp.Id;
            base.Visit_Date__c = date.newInstance(2011, 8, 8);
            insert base;
            base.Status__c = 'Accepted';
            update base;
            
            AE_Report__c aObj = new AE_Report__c();
            aObj.Start_Date__c = tObj.Start_Date__c;
            aObj.End_Date__c = system.today();
            insert aObj;
            
            AE_Detail__c ae = new AE_Detail__c();
            ae.TrialPatient__c = tp.Id;
            ae.Status__c = 'Accepted';
            insert ae;
            
            Toxicity__c t = new Toxicity__c();
            t.AE_Detail__c = ae.Id;
            t.Resolved__c = true;
            insert t;
            
            Randomization_Form__c rf = new Randomization_Form__c();
            rf.TrialPatient__c = tp.Id;
            rf.Did_Patient_Sign_Treatment_Consent_Form__c = true;
            insert rf;
            
            Arm__c arm = new Arm__c();
            arm.Name = 'test arm';
            insert arm;
            
            ArmPatient__c armPat = new ArmPatient__c();
            armPat.Arm_Id__c = arm.Id;
            armPat.TrialPatient__c = tp.Id;
            insert armPat;
            
            Chemo_Treatment__c chemo = new Chemo_Treatment__c();
            chemo.Status__c = 'Accepted';
            chemo.TrialPatient__c = tp.Id;
            chemo.Cycle_number__c = 1.0;
            chemo.Date_of_therapy__c = date.newInstance(2011, 7, 7);
            insert chemo;
            
            Chemo_Therapy_Regimen__c chem = new Chemo_Therapy_Regimen__c();
            chem.Chemo_Treatment__c = chemo.Id;
          //  chem.Agent__c = 'test';
            chem.Prescribed_Dose__c = 1.0;
            chem.Total_Dose__c = 2.0;
            chem.Day__c = 2;
            insert chem;
            
            AdverseEventReportController aerObj = new AdverseEventReportController();
            aerObj.prepareData();
            aerObj.viewHTML(); // method "viewHTML()" begins and end here
            aerObj.viewCSV(); // method "viewCSV()" begins and end here
            
            AdverseEventReportController.AdverseEventsByPartcipantAndArm ad = new AdverseEventReportController.AdverseEventsByPartcipantAndArm();
            ad.arm = arm.Id;
            ad.subjectId = ae.Id;
            
            AdverseEventReportController.TherapyWrapper tw = new AdverseEventReportController.TherapyWrapper();
            tw.subjectId =  ae.Id;
            
            aerObj.viewPDF(); // method "viewPDF()" begins and end here
            
            
            }
        }
    }
}