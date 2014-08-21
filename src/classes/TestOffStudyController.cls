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
private class TestOffStudyController {

    @isTest static void myUnitTest() {
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
            p.Last_Name__c = 'test'; // patient
            p.Gender__c = 'Male';
            p.Race__c = 'White';
            p.Ethnicity__c = 'Not Hispanic or Latino';
            insert p;
            
            Code_Master__c snomedObject = new Code_Master__c();
            snomedObject.Variable_Description__c = 'test';
            snomedObject.IsReportColumn__c = true;
            snomedObject.Display_Order__c = 3.0;
            snomedObject.Name = 'OffStudy';
            insert snomedObject;
            
            TrialPatient__c tp = new TrialPatient__c();
            tp.Patient_Id__c = p.Id;
            insert tp;
            
            Off_Study_Detail__c offStudy1 = new Off_Study_Detail__c(); // if condition line 43
            offStudy1.TrialPatient__c = tp.Id;
            insert offStudy1;
            
            Apexpages.currentPage().getParameters().put('trialPat',tp.Id);
            ApexPages.StandardController controller1 = new ApexPages.StandardController(offStudy1);
            OffStudyController osc1 = new OffStudyController(controller1);  // if condition line 43
            osc1.saveCrf(); // else line 50
            Apexpages.currentPage().getParameters().put('id',offStudy1.Id); // if line 45
            osc1.saveCrf();
            
            Off_Study_Detail__c offStudy = new Off_Study_Detail__c();
            offStudy.TrialPatient__c = tp.Id;
            insert offStudy;
            
            Apexpages.currentPage().getParameters().put('trialPat',tp.Id);
            Apexpages.currentPage().getParameters().put('offStudyId',offStudy.Id);
            ApexPages.StandardController controller = new ApexPages.StandardController(offStudy);
            OffStudyController osc = new OffStudyController(controller);
            
            Apexpages.currentPage().getParameters().put('nextTab','attachmentTab');
            osc.next();
            
            Apexpages.currentPage().getParameters().put('nextTab','saveAndClose');
            osc.next();
            
            Apexpages.currentPage().getParameters().put('prevTab','attachmentTab');
            osc.previous();
            
            osc.saveCrf();
            osc.password = '3c47d9ff';
            osc.signAndSubmit();
            osc.resendCode();
            osc.cloneCRF();
            osc.editCRF();
            
            Apexpages.currentPage().getParameters().put('trialPat',tp.Id);
            osc.customCancel();
            }
        }
    }
    
    @isTest static void myUnitTest1() {
        List<User> lstSiteUser = [Select u.IsActive, u.Id, SecurityCode__c From User u where IsActive = true and Profile.Name = 'Site User'];     
            System.runAs ( lstSiteUser[0] ) { 
            
            Account acc = new Account();
            
            List<Account> lstAccount = [Select a.Id From Account a limit 1];
            
            if(!lstAccount.isEmpty()){
                acc = lstAccount[0];
                
                Patient_Custom__c p = new Patient_Custom__c();
                p.Birthdate__c = date.newInstance(1980, 08, 05);
                p.Institution__c = acc.Id;
                p.Last_Name__c = 'test'; // patient
                p.Gender__c = 'Male';
                p.Race__c = 'White';
                p.Ethnicity__c = 'Not Hispanic or Latino';
                insert p;
                
                Code_Master__c snomedObject = new Code_Master__c();
                snomedObject.Variable_Description__c = 'test';
                snomedObject.IsReportColumn__c = true;
                snomedObject.Display_Order__c = 3.0;
                snomedObject.Name = 'OffStudy';
                insert snomedObject;
                
                TrialPatient__c tp = new TrialPatient__c();
                tp.Patient_Id__c = p.Id;
                insert tp;
                
                Off_Study_Detail__c offStudy2 = new Off_Study_Detail__c();
                offStudy2.TrialPatient__c = tp.Id;
                offStudy2.Patient_completed_study_per_protocol__c = true;
                insert offStudy2;
                
                offStudy2.Status__c = 'Accepted';
                update offStudy2;
                
                Off_Study_Detail__c offStudy3 = new Off_Study_Detail__c();
                offStudy3.TrialPatient__c = tp.Id;
                //Patient_Died__c, Patient_did_not_have_surgery__c, Why_patient_didnt_continue_treatment_arm__c, Patient_did_nt_continue_on_treatment_arm__c, 
                //Patient_did_nt_want_to_complete_core_bio__c, Patient_did_not_want_to_complete_MRI__c
                offStudy3.Patient_Died__c = true;
                offStudy3.Patient_did_not_have_surgery__c = true;
                offStudy3.Patient_did_nt_continue_on_treatment_arm__c = true;
                offStudy3.Why_patient_didnt_continue_treatment_arm__c = 'Due to (S)AE';
                offStudy3.Patient_did_nt_want_to_complete_core_bio__c = true;
                offStudy3.Patient_did_not_want_to_complete_MRI__c = true;
                insert offStudy3;
                
                offStudy3.Status__c = 'Accepted';
                update offStudy3;
            }
        }
    }
    
    @isTest static void myUnitTest2() {
        List<User> lstSiteUser = [Select u.IsActive, u.Id, SecurityCode__c From User u where IsActive = true and Profile.Name = 'Site User'];     
            System.runAs ( lstSiteUser[0] ) { 
            
            Account acc = new Account();
            
            List<Account> lstAccount = [Select a.Id From Account a limit 1];
            
            if(!lstAccount.isEmpty()){
                acc = lstAccount[0];
                
                Patient_Custom__c p = new Patient_Custom__c();
                p.Birthdate__c = date.newInstance(1980, 08, 05);
                p.Institution__c = acc.Id;
                p.Last_Name__c = 'test'; // patient
                p.Gender__c = 'Male';
                p.Race__c = 'White';
                p.Ethnicity__c = 'Not Hispanic or Latino';
                insert p;
                
                Code_Master__c snomedObject = new Code_Master__c();
                snomedObject.Variable_Description__c = 'test';
                snomedObject.IsReportColumn__c = true;
                snomedObject.Display_Order__c = 3.0;
                snomedObject.Name = 'OffStudy';
                insert snomedObject;
                
                TrialPatient__c tp = new TrialPatient__c();
                tp.Patient_Id__c = p.Id;
                insert tp;
                
                Off_Study_Detail__c offStudy3 = new Off_Study_Detail__c();
                offStudy3.TrialPatient__c = tp.Id;
                //Patient_Died__c, Patient_did_not_have_surgery__c, Why_patient_didnt_continue_treatment_arm__c, Patient_did_nt_continue_on_treatment_arm__c, 
                //Patient_did_nt_want_to_complete_core_bio__c, Patient_did_not_want_to_complete_MRI__c
                offStudy3.Patient_Died__c = true;
                offStudy3.Patient_did_not_have_surgery__c = true;
                offStudy3.Patient_did_nt_continue_on_treatment_arm__c = true;
                offStudy3.Why_patient_didnt_continue_treatment_arm__c = 'Personal Preference';
                offStudy3.Patient_did_nt_want_to_complete_core_bio__c = true;
                offStudy3.Patient_did_not_want_to_complete_MRI__c = true;
                insert offStudy3;
                
                offStudy3.Status__c = 'Accepted';
                update offStudy3;
                
                Off_Study_Detail__c offStudy2 = new Off_Study_Detail__c();
                offStudy2.TrialPatient__c = tp.Id;
                //Patient_Died__c, Patient_did_not_have_surgery__c, Why_patient_didnt_continue_treatment_arm__c, Patient_did_nt_continue_on_treatment_arm__c, 
                //Patient_did_nt_want_to_complete_core_bio__c, Patient_did_not_want_to_complete_MRI__c
                offStudy2.Patient_Died__c = true;
                offStudy2.Patient_did_not_have_surgery__c = true;
                offStudy2.Patient_did_nt_continue_on_treatment_arm__c = true;
                offStudy2.Why_patient_didnt_continue_treatment_arm__c = 'Other';
                offStudy2.Patient_did_nt_want_to_complete_core_bio__c = true;
                offStudy2.Patient_did_not_want_to_complete_MRI__c = true;
                insert offStudy2;
                
                offStudy2.Status__c = 'Accepted';
                update offStudy2;
            }
        }
    }
}