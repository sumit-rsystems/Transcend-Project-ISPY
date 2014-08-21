/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testethod
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
private class TestMammaPrintView {

    @isTest static void myUnitTest() {
        List<User> thisUser = [Select u.IsActive, u.Id ,u.Patient_Id__c,u.ProfileId,u.Username From User u where IsActive = true and Profile.Name = 'System Administrator'];   
        System.runAs (thisUser[0]) {
            Account inst1 = new Account(); 
            inst1.Name = 'test';
            insert inst1;
            
            Site__c site1 = new Site__c();
            site1.Name = 'test site1';
            site1.Type__c = 'test type';
            site1.Institute__c = inst1.Id;
            insert site1;
            
            Trial__c tri = new Trial__c();
            tri.Name = 'test';
            insert tri;
            
            Site_Trial__c sitetrial = new Site_Trial__c();
            sitetrial.Site__c = site1.Id;
            sitetrial.Trial__c = tri.Id;
            insert sitetrial;
            
            Patient_Custom__c pc = new Patient_Custom__c();
            pc.First_Name__c = 'test';
            pc.Last_Name__c = 'test2';
            pc.Gender__c = 'Male';
            pc.Birthdate__c = date.newInstance(1988, 7, 7);
            pc.Race__c = 'White';
            pc.Ethnicity__c = 'Not Hispanic or Latino';
            pc.Institution__c = inst1.Id;
            pc.Email__c = thisUser[0].Username;
            insert pc;
            
            TrialPatient__c tp = new TrialPatient__c();
            tp.Patient_Id__c = pc.Id;
            tp.Trial_Id__c = tri.Id;
            insert tp;
                
            LabUser__c lab = new LabUser__c();
            lab.Name = 'test';
            lab.User__c = thisUser[0].id;
            lab.Lab__c = site1.id; 
            
            insert lab;
            
            TissueSpecimenDetail__c ts = new TissueSpecimenDetail__c();
            ts.Status__c = 'Approval Not Required';
            ts.Patient__c = pc.Id;
            ts.TrialPatient__c = tp.Id;
            ts.ProcedureDate__c = date.newInstance(2012, 8, 10);
            ts.Time_Point__c = 'Pre-treatment';
            ts.NumberOfSamplesCollected__c = 1.0;
            
            insert ts;
            
            MammaPrintDetail__c mpd = new MammaPrintDetail__c();
            mpd.TrialPatient__c = tp.Id;
            mpd.Tissue_Specimen_Detail__c = ts.Id;
            mpd.Report_Date__c = date.newInstance(2011, 7, 7);
            mpd.MammaPrint_Index__c = 0.5;
            mpd.MammaPrint_Risk__c = 'Low risk';
            mpd.Status__c = 'Approval Pending';
            
            insert mpd;
            mammaPrintView mmaprintClass = new mammaPrintView();
        }
    }
    @isTest static void myUnitTest1() {
        List<User> thisUser = [Select u.IsActive, u.Id ,u.Patient_Id__c,u.ProfileId,u.Username From User u where IsActive = true and Profile.Name = 'System Administrator'];   
        System.runAs (thisUser[0]) {
            Account inst1 = new Account(); 
            inst1.Name = 'test';
            insert inst1;
            
            Site__c site1 = new Site__c();
            site1.Name = 'test site1';
            site1.Type__c = 'test type';
            site1.Institute__c = inst1.Id;
            insert site1;
            
            Trial__c tri = new Trial__c();
            tri.Name = 'test';
            insert tri;
            
            Site_Trial__c sitetrial = new Site_Trial__c();
            sitetrial.Site__c = site1.Id;
            sitetrial.Trial__c = tri.Id;
            insert sitetrial;
            
            Patient_Custom__c pc = new Patient_Custom__c();
            pc.First_Name__c = 'test';
            pc.Last_Name__c = 'test2';
            pc.Gender__c = 'Male';
            pc.Birthdate__c = date.newInstance(1988, 7, 7);
            pc.Race__c = 'White';
            pc.Ethnicity__c = 'Not Hispanic or Latino';
            pc.Institution__c = inst1.Id;
            pc.Email__c = thisUser[0].Username;
            insert pc;
            
            TrialPatient__c tp = new TrialPatient__c();
            tp.Patient_Id__c = pc.Id;
            tp.Trial_Id__c = tri.Id;
            insert tp;
                
            LabUser__c lab = new LabUser__c();
            lab.Name = 'test';
            lab.User__c = thisUser[0].id;
            lab.Lab__c = site1.id; 
            
            insert lab;
            
            TissueSpecimenDetail__c ts = new TissueSpecimenDetail__c();
            ts.Status__c = 'Approval Not Required';
            ts.Patient__c = pc.Id;
            ts.TrialPatient__c = tp.Id;
            ts.ProcedureDate__c = date.newInstance(2012, 8, 10);
            ts.Time_Point__c = 'Pre-treatment';
            ts.NumberOfSamplesCollected__c = 1.0;
            
            insert ts;
            mammaPrintView mmaprintClass = new mammaPrintView();
        }
    }
}