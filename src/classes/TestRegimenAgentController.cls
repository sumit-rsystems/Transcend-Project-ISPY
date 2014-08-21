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
private class TestRegimenAgentController {

    @isTest static void myUnitTest() {
        
        Profile SiteProp = [ Select p.UserType, p.Name, (Select u.IsActive, u.Id From Users u where IsActive = true) From Profile p where Name = 'Site User'];
        List<User> lstSiteUser = SiteProp.Users;     
        System.runAs ( lstSiteUser[0] ) {
            
            Account insAcc = new Account();

            List<Account> lstAccount = [select Id from Account limit 1]; 
            
            if(!lstAccount.isEmpty()){
                
            insAcc = lstAccount[0];           // newly added logic to overcome the error of "setup and nonsetup" object
            
            Agent__c agent = new Agent__c();
            agent.Display_Order__c = 100;
            agent.Dose_Unit__c = 'mg';
            agent.Frequency__c = 'weekly';
            agent.Name = 'Paclitaxcel';
            agent.Total_Dose_Unit__c = 'mg';
            insert agent;
            
            Chemo_Regimen__c chemoRegimen = new Chemo_Regimen__c();
            chemoRegimen.Name = 'Taxane';
            insert chemoRegimen;
            
            Chemo_Regimen_Agent__c chemoRegimenAgent = new Chemo_Regimen_Agent__c();
            chemoRegimenAgent.Agent__c = agent.Id;
            chemoRegimenAgent.Chemo_Regimen__c = chemoRegimen.Id;
            insert chemoRegimenAgent;
            
            Patient_Custom__c p = new Patient_Custom__c();
            p.Birthdate__c = date.newInstance(1950, 08, 05);
            p.Institution__c = insAcc.Id;
            p.Last_Name__c = 'test'; // patient
            p.Gender__c = 'Male';
            p.Race__c = 'White';
            p.Ethnicity__c = 'Not Hispanic or Latino';
            insert p;
            
            Trial__c trial1 = new Trial__c();
            trial1.Name='test Trial 1';
            insert trial1;  
                
            TrialPatient__c tp = new TrialPatient__c();
            tp.Patient_Id__c = p.Id;
            tp.Trial_Id__c = trial1.Id;
            insert tp;
            
            Chemo_Treatment__c chemoTreatment_cycle1 = new Chemo_Treatment__c();
            chemoTreatment_cycle1.TrialPatient__c = tp.Id;
            chemoTreatment_cycle1.Cycle_number__c = 1;
            chemoTreatment_cycle1.Date_of_therapy__c = system.today();
            chemoTreatment_cycle1.Did_patient_go_off_study_treatment__c = true;
            chemoTreatment_cycle1.Patient_height__c = 12;
            chemoTreatment_cycle1.Patient_weight__c = 12;
            chemoTreatment_cycle1.Status__c = 'Completed';
            insert chemoTreatment_cycle1;
            
            Chemo_Treatment__c chemoTreatment_cycle2 = new Chemo_Treatment__c();
            chemoTreatment_cycle2.TrialPatient__c = tp.Id;
            chemoTreatment_cycle2.Cycle_number__c = 1;
            chemoTreatment_cycle2.Date_of_therapy__c = system.today();
            chemoTreatment_cycle2.Did_patient_go_off_study_treatment__c = true;
            chemoTreatment_cycle2.Patient_height__c = 12;
            chemoTreatment_cycle2.Patient_weight__c = 12;
            chemoTreatment_cycle2.Status__c = 'Completed';
            insert chemoTreatment_cycle2;
            
            Chemo_Therapy_Regimen__c chemoTherapy_cycle1 = new Chemo_Therapy_Regimen__c();
            chemoTherapy_cycle1.Agent__c = agent.Id;
            chemoTherapy_cycle1.Chemo_Treatment__c = chemoTreatment_cycle1.Id;
            chemoTherapy_cycle1.Day__c = 2;
            chemoTherapy_cycle1.Did_patient_stop_receiving__c = false;
            chemoTherapy_cycle1.Dose_Delay__c = 'Yes';
            //chemoTherapy_cycle1.Dose_Mod__c = 12;
            //chemoTherapy_cycle1.Prescribed_Dose__c = 12;
            chemoTherapy_cycle1.Total_Dose__c = 24;
            insert chemoTherapy_cycle1;
            
            Chemo_Therapy_Regimen__c chemoTherapy_cycle2 = new Chemo_Therapy_Regimen__c();
            chemoTherapy_cycle2.Agent__c = agent.Id;
            chemoTherapy_cycle2.Chemo_Treatment__c = chemoTreatment_cycle2.Id;
            chemoTherapy_cycle2.Day__c = 2;
            chemoTherapy_cycle2.Did_patient_stop_receiving__c = false;
            chemoTherapy_cycle2.Dose_Delay__c = 'Yes';
            //chemoTherapy_cycle2.Dose_Mod__c = 12;
            //chemoTherapy_cycle2.Prescribed_Dose__c = 12;
            chemoTherapy_cycle2.Total_Dose__c = 24;
            insert chemoTherapy_cycle2;
            
            Chemo_Therapy_Regimen__c chemoTherapy_cycle3 = new Chemo_Therapy_Regimen__c();
            chemoTherapy_cycle3.Chemo_Treatment__c = chemoTreatment_cycle2.Id;
            chemoTherapy_cycle3.Other_Agent__c = 'test';
            chemoTherapy_cycle3.Day__c = 2;
            chemoTherapy_cycle3.Did_patient_stop_receiving__c = false;
            chemoTherapy_cycle3.Dose_Delay__c = 'Yes';
            //chemoTherapy_cycle2.Dose_Mod__c = 12;
            //chemoTherapy_cycle2.Prescribed_Dose__c = 12;
            chemoTherapy_cycle3.Total_Dose__c = 24;
            insert chemoTherapy_cycle3;
            
            Chemo_Therapy_Regimen__c chemoTherapy_cycle4 = new Chemo_Therapy_Regimen__c();
            chemoTherapy_cycle4.Chemo_Treatment__c = chemoTreatment_cycle2.Id;
            chemoTherapy_cycle4.Other_Agent__c = 'test';
            chemoTherapy_cycle4.Day__c = 2;
            chemoTherapy_cycle4.Did_patient_stop_receiving__c = false;
            chemoTherapy_cycle4.Dose_Delay__c = 'Yes';
            //chemoTherapy_cycle2.Dose_Mod__c = 12;
            //chemoTherapy_cycle2.Prescribed_Dose__c = 12;
            chemoTherapy_cycle4.Total_Dose__c = 24;
            insert chemoTherapy_cycle4;
            
            Chemo_Summary_Form__c chemoSummaryForm = new Chemo_Summary_Form__c ();
            chemoSummaryForm.TrialPatient__c = tp.Id;
            chemoSummaryForm.Status__c = 'Not Completed';
            insert chemoSummaryForm;
            
            Chemo_Regimen__c chemoRegimen1 = new Chemo_Regimen__c();
            chemoRegimen1.Name = 'Taxane';
            insert chemoRegimen1;
            
            Chemo_Regimen__c chemoRegimen2 = new Chemo_Regimen__c();
            chemoRegimen2.Name = 'Anthracycline';
            insert chemoRegimen2;
            
            Chemo_Regimen__c chemoRegimen3 = new Chemo_Regimen__c();
            chemoRegimen3.Name = 'Investigational';
            insert chemoRegimen3;
            
            ChemoSummaryRegimenDetail__c chemoSummaryRegimenDetail = new ChemoSummaryRegimenDetail__c();
            chemoSummaryRegimenDetail.First_Date_of_Therapy__c = system.today();
            chemoSummaryRegimenDetail.Last_Date_of_Therapy__c = system.today();
            chemoSummaryRegimenDetail.Treatment_End_Reasons__c = 'Treatment completed per protocol criteria';
            chemoSummaryRegimenDetail.Chemo_Regimen__c = chemoRegimen1.Id;
            chemoSummaryRegimenDetail.Chemo_Summary_Form__c = chemoSummaryForm.Id;
            insert chemoSummaryRegimenDetail;
            
            ChemoSummaryRegimenDetail__c chemoSummaryRegimenDetail1 = new ChemoSummaryRegimenDetail__c();
            chemoSummaryRegimenDetail1.First_Date_of_Therapy__c = system.today();
            chemoSummaryRegimenDetail1.Last_Date_of_Therapy__c = system.today();
            chemoSummaryRegimenDetail1.Treatment_End_Reasons__c = 'Treatment completed per protocol criteria';
            chemoSummaryRegimenDetail1.Chemo_Summary_Form__c = chemoSummaryForm.Id;
            insert chemoSummaryRegimenDetail1;
            
            ChemoSummaryRegimenDetail__c chemoSummaryRegimenDetail2 = new ChemoSummaryRegimenDetail__c();
            chemoSummaryRegimenDetail2.First_Date_of_Therapy__c = system.today();
            chemoSummaryRegimenDetail2.Last_Date_of_Therapy__c = system.today();
            chemoSummaryRegimenDetail2.Treatment_End_Reasons__c = 'Treatment completed per protocol criteria';
            chemoSummaryRegimenDetail2.Chemo_Regimen__c = chemoRegimen2.Id;
            chemoSummaryRegimenDetail2.Chemo_Summary_Form__c = chemoSummaryForm.Id;
            insert chemoSummaryRegimenDetail2;
            
            ChemoSummaryRegimenDetail__c chemoSummaryRegimenDetail3 = new ChemoSummaryRegimenDetail__c();
            chemoSummaryRegimenDetail3.First_Date_of_Therapy__c = system.today();
            chemoSummaryRegimenDetail3.Last_Date_of_Therapy__c = system.today();
            chemoSummaryRegimenDetail3.Treatment_End_Reasons__c = 'Treatment completed per protocol criteria';
            chemoSummaryRegimenDetail3.Chemo_Regimen__c = chemoRegimen3.Id;
            chemoSummaryRegimenDetail3.Chemo_Summary_Form__c = chemoSummaryForm.Id;
            insert chemoSummaryRegimenDetail3;
        
            RegimenAgentController regAgentController = new RegimenAgentController();
            regAgentController.chemoSummaryId = chemoSummaryForm.Id;
            regAgentController.trialPatientId = tp.Id;
            regAgentController.regimenName = chemoRegimen.Name;
            regAgentController.getRegimenDetailWrapper();
            
            RegimenAgentController regAgentController1 = new RegimenAgentController();
            regAgentController1.chemoSummaryId = chemoSummaryForm.Id;
            regAgentController1.trialPatientId = tp.Id;
            regAgentController1.regimenName = 'Other';
            regAgentController1.getRegimenDetailWrapper();
            regAgentController1.saveComponent(chemoSummaryForm.Id, 'Taxane');
            regAgentController1.saveComponent(chemoSummaryForm.Id, 'Anthracycline');
            regAgentController1.saveComponent(chemoSummaryForm.Id, 'Investigational');
            regAgentController1.saveComponent(chemoSummaryForm.Id, 'test');
            }
        }
    }
}