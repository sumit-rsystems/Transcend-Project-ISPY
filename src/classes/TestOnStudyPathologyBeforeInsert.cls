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
private class TestOnStudyPathologyBeforeInsert {

    @isTest static void myUnitTest() {
        // TO DO: implement unit test
        
        Profile SiteProp = [ Select p.UserType, p.Name, (Select u.IsActive, u.Id, SecurityCode__c From Users u where IsActive = true) From Profile p where Name = 'Site User'];
        List<User> lstSiteUser = SiteProp.Users;     
        System.runAs ( lstSiteUser[0] ) { 
            
            Code_Master__c snomedObject = new Code_Master__c();
            snomedObject.Variable_Description__c = 'test';
            snomedObject.IsReportColumn__c = true;
            snomedObject.Display_Order__c = 3.0;
            snomedObject.Name = 'DCISGrade_PS';
            insert snomedObject;
            
            Account acc = new Account();

            List<Account> lstAccount = [select Id from Account limit 1]; 
            
            if(!lstAccount.isEmpty()){
                
            acc = lstAccount[0];           // newly added logic to overcome the error of "setup and nonsetup" object
            
            Patient_Custom__c p = new Patient_Custom__c();
            p.Birthdate__c = date.newInstance(1950, 08, 05);
            p.Institution__c = acc.Id;
            p.Last_Name__c = 'test'; // patient
            p.Gender__c = 'Male';
            p.Race__c = 'White';
            p.Ethnicity__c = 'Not Hispanic or Latino';
            insert p;
        
            TrialPatient__c tp = new TrialPatient__c();
            tp.FirstName__c = 'a';
            tp.LastName__c = 'b';
            tp.Patient_Id__c = p.Id;
            insert tp;
            
            CRF__c crf = new CRF__c();
            crf.Patient__c = tp.Patient_Id__c;
            crf.Status__c = 'Not Completed';
            insert crf;
            
            crf.Status__c = 'Completed';
            update crf;
            
            Snomed_Code__c snomed = new Snomed_Code__c();
            snomed.Code_Master__c = snomedObject.Id;
            snomed.snomed_Code_Name__c = '384727002';
            snomed.CRF__c = crf.Id;
            insert snomed;
            
            Post_Surgaory_Summary__c postObject1 = new Post_Surgaory_Summary__c();
            postObject1.Type_Of_Tumor__c = 'Single Discrete Mass';
            postObject1.CRF__c = crf.Id;
            insert postObject1;
            
            Procedure__c proObj = new Procedure__c();
            proObj.Post_Surgery_Summary__c = postObject1.Id;
            insert proObj;
            
            Lymph_Nodes__c lnObject = new Lymph_Nodes__c();
            lnObject.Sentinel_Nodes__c = true;
            lnObject.Single_Detection_Result__c = true;
            lnObject.Procedure__c = proObj.Id;
            lnObject.Positive__c = 2.0;
            lnObject.Examined__c = 3.0;
            insert lnObject;
            
            On_Study_Pathology_Form__c osp = new On_Study_Pathology_Form__c();
            osp.TrialPatient__c = tp.Id;
            osp.CRF__c = crf.Id;
            osp.Status__c = crf.Status__c;
            osp.Phase__c = 'Screening';
            osp.Does_the_patient_have_bilateral_breast_c__c = 'Yes'; 
            osp.Tumor_laterality__c = 'Left';
            //osp.Procedure__c = proObj.Id;
            insert osp;
            
            Procedure__c proObj1 = new Procedure__c();
            proObj1.On_Study_Pathology_Form__c = osp.Id;
            insert proObj1;
            
            
            update osp;
            }
        }
    }
}