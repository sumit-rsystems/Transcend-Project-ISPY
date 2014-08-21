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
private class TestProcedureComponentController {

    @isTest static void myUnitTest() {
        // TO DO: implement unit test
        Profile SiteProp = [ Select p.UserType, p.Name, (Select u.IsActive, u.Id, SecurityCode__c From Users u where IsActive = true) From Profile p where Name = 'Site User'];
        List<User> lstSiteUser = SiteProp.Users;     
        System.runAs ( lstSiteUser[0] ) { 
            
            Account acc = new Account();

            List<Account> lstAccount = [select Id from Account limit 1]; 
            
            if(!lstAccount.isEmpty()){
                
            acc = lstAccount[0];           // newly added logic to overcome the error of "setup and nonsetup" object
            
            Code_Master__c snomedObject = new Code_Master__c();
            snomedObject.Variable_Description__c = 'test';
            snomedObject.IsReportColumn__c = true;
            snomedObject.Display_Order__c = 3.0;
            snomedObject.Name = 'CoreNeedle_LN_Pretx';
            insert snomedObject;
            
            Patient_Custom__c p1 = new Patient_Custom__c();
            p1.Birthdate__c = date.newInstance(2012, 8, 10);
            p1.Institution__c = acc.Id;
            p1.Last_Name__c = 'test'; // patient
            p1.Gender__c = 'Male';
            p1.Race__c = 'White';
            p1.Ethnicity__c = 'Not Hispanic or Latino';
            insert p1;
            
            TrialPatient__c tp = new TrialPatient__c();
            tp.FirstName__c = 'a';
            tp.LastName__c = 'b';
            tp.Patient_Id__c = p1.Id;
            insert tp;
            
            Post_Surgaory_Summary__c pos = new Post_Surgaory_Summary__c();
            pos.TrialPatient__c = tp.Id;
            insert pos;
            
            On_Study_Pathology_Form__c osp = new On_Study_Pathology_Form__c();
            osp.TrialPatient__c = tp.Id;
            osp.Does_the_patient_have_bilateral_breast_c__c = 'Yes'; //on study path
            osp.Tumor_laterality__c = 'Left';
            insert osp;
            
            /*Procedure__c proObj1 = new Procedure__c();
            proObj1.TrialPatient__c = tp.Id;
            proObj1.On_Study_Pathology_Form__c = osp.Id;
            proObj1.Post_Surgery_Summary__c = pos.Id;
            proObj1.Form_Name__c = 'Breast Surgical Procedure Collection';
            proObj1.Procedure_Name__c = 'Partial mastectomy';
            insert proObj1;*/
            
            Procedure__c p = new Procedure__c();
            p.On_Study_Pathology_Form__c = osp.Id;
            p.Post_Surgery_Summary__c = pos.Id;
            p.TrialPatient__c = tp.Id;
            p.Form_Name__c = 'On-Study Pathology Form(Positive Breast Biopsies)';
            p.Procedure_Name__c = 'Core biopsy (lymph node)';
            p.Ultrasound__c = true;
            p.Palpation_guided__c = true;
            p.Mammography__c = true;
            p.MRI__c = true;
            p.Stereotactic__c = true;
            insert p;
            
            Procedure__c proObj = new Procedure__c();
            proObj.TrialPatient__c = tp.Id;
            proObj.On_Study_Pathology_Form__c = osp.Id;
            proObj.Post_Surgery_Summary__c = pos.Id;
            proObj.Form_Name__c = 'Breast Surgical Procedure Collection';
            proObj.Ultrasound__c = true;
            proObj.Palpation_guided__c = true;
            proObj.Mammography__c = true;
            proObj.MRI__c = true;
            proObj.Stereotactic__c = true;
            proObj.Procedure_Name__c = 'Core biopsy';
            upsert proObj;
           
            Apexpages.currentPage().getParameters().put('PathologyId', osp.Id);
            ProcedureComponentController pcc1 = new ProcedureComponentController(); //satisfy else condition
            ProcedureComponentController.WrapForSrno wrapSrNo = new ProcedureComponentController.WrapForSrno(); 
            wrapSrNo.pro = proObj;
            
            wrapSrNo.srno = 1;
            pcc1.wrapList.add(wrapSrNo);
            Apexpages.currentPage().getParameters().put('formName','Breast Surgical Procedure Collection'); // satisfy if condition
            Apexpages.currentPage().getParameters().put('trialPat',tp.Id);
            Apexpages.currentPage().getParameters().put('postid',pos.Id);
            Apexpages.currentPage().getParameters().put('PathologyId',osp.Id);
            pcc1.saveNewProcedure();
            Apexpages.currentPage().getParameters().put('procedureId',proObj.Id);
            pcc1.updateProcedure();
            
            ProcedureComponentController pcc = new ProcedureComponentController();
            pcc.wrapList.add(wrapSrNo);
            
            ProcedureComponentController pcc2 = new ProcedureComponentController(); //satisfy else condition
            ProcedureComponentController.WrapForSrno wrapSrNo2 = new ProcedureComponentController.WrapForSrno(); 
            wrapSrNo2.pro = p;
            upsert p;
            
            wrapSrNo2.srno = 1;
            pcc2.wrapList.add(wrapSrNo2);
            Apexpages.currentPage().getParameters().put('formName','Breast Surgical Procedure Collection'); // satisfy if condition
            Apexpages.currentPage().getParameters().put('trialPat',tp.Id);
            Apexpages.currentPage().getParameters().put('postid',pos.Id);
            Apexpages.currentPage().getParameters().put('PathologyId',osp.Id);
            pcc2.saveNewProcedure();
            
            
            ProcedureComponentController pcc3 = new ProcedureComponentController();
            pcc3.wrapList.add(wrapSrNo2);
            
            pcc.addNewProcedure();
            Apexpages.currentPage().getParameters().put('subForm','On-Study Pathology Form(Positive Breast Biopsies)'); // satisfy if condition
            Apexpages.currentPage().getParameters().put('procedureId',proObj.Id);
            pcc.addNewProcedure();
            
            Apexpages.currentPage().getParameters().put('serial','1');
            Apexpages.currentPage().getParameters().put('procedureId',proObj.Id);
            pcc.editProcedure();
            
            Apexpages.currentPage().getParameters().put('procedureId',p.Id);
            pcc.updateProcedure();
           
            Apexpages.currentPage().getParameters().put('serial','1');
            pcc.updateCancelProcedure();
            
            Apexpages.currentPage().getParameters().put('serial','1');
            Apexpages.currentPage().getParameters().put('procedureId',proObj.Id);
            pcc.cancelNewProcedure();
        }
      }
    }
    
     @isTest static void myUnitTest1() {
        // TO DO: implement unit test
        
        Profile SiteProp = [ Select p.UserType, p.Name, (Select u.IsActive, u.Id, SecurityCode__c From Users u where IsActive = true) From Profile p where Name = 'Site User'];
        List<User> lstSiteUser = SiteProp.Users;     
        System.runAs ( lstSiteUser[0] ) { 
            
            Account acc = new Account();

            List<Account> lstAccount = [select Id from Account limit 1]; 
            
            if(!lstAccount.isEmpty()){
                
            acc = lstAccount[0];           // newly added logic to overcome the error of "setup and nonsetup" object
            
            Code_Master__c snomedObject = new Code_Master__c();
            snomedObject.Variable_Description__c = 'test';
            snomedObject.IsReportColumn__c = true;
            snomedObject.Display_Order__c = 3.0;
            snomedObject.Name = 'CoreNeedle_LN_Pretx';
            insert snomedObject;
            
            Patient_Custom__c p = new Patient_Custom__c();
            p.Birthdate__c = date.newInstance(2012, 8, 10);
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
            
            Post_Surgaory_Summary__c pos = new Post_Surgaory_Summary__c();
            pos.TrialPatient__c = tp.Id;
            insert pos;
            
            On_Study_Pathology_Form__c osp = new On_Study_Pathology_Form__c();
            osp.TrialPatient__c = tp.Id;
            osp.Does_the_patient_have_bilateral_breast_c__c = 'Yes'; //on study path
            osp.Tumor_laterality__c = 'Left';
            insert osp;
            
            Procedure__c proObj1 = new Procedure__c();
            proObj1.TrialPatient__c = tp.Id;
            proObj1.On_Study_Pathology_Form__c = osp.Id;
            proObj1.Post_Surgery_Summary__c = pos.Id;
            proObj1.Form_Name__c = 'Breast Surgical Procedure Collection';
            proObj1.Procedure_Name__c = 'Partial mastectomy';
            insert proObj1; 
            
            Procedure__c proObj = new Procedure__c();
            proObj.TrialPatient__c = tp.Id;
            proObj.On_Study_Pathology_Form__c = osp.Id;
            proObj.Post_Surgery_Summary__c = pos.Id;
            proObj.Form_Name__c = 'Breast Surgical Procedure Collection';
            proObj.Procedure_Name__c = 'Partial mastectomy';
            proObj.Ultrasound__c = true;
            proObj.Palpation_guided__c = true;
            proObj.Mammography__c = true;
            proObj.MRI__c = true;
            proObj.Stereotactic__c = true;
            proObj.Procedure_Name__c = 'Core biopsy (lymph node)';
            
            Apexpages.currentPage().getParameters().put('PathologyId',osp.Id);
            ProcedureComponentController pcc = new ProcedureComponentController();
            pcc.pathologyId = osp.Id;
            pcc.saveNewProcedure();
            
            ProcedureComponentController pcc1 = new ProcedureComponentController(); //satisfy else condition
            ProcedureComponentController.WrapForSrno wrapSrNo = new ProcedureComponentController.WrapForSrno(); 
            wrapSrNo.pro = proObj;
            upsert proObj;
            
            wrapSrNo.srno = 1;
            pcc1.wrapList.add(wrapSrNo);
            Apexpages.currentPage().getParameters().put('formName','Breast Surgical Procedure Collection'); // satisfy if condition
            Apexpages.currentPage().getParameters().put('trialPat',tp.Id);
            Apexpages.currentPage().getParameters().put('postid',pos.Id);
            Apexpages.currentPage().getParameters().put('PathologyId',osp.Id);
            pcc1.saveNewProcedure();
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
            p.Birthdate__c = date.newInstance(2012, 8, 10);
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
            
            Post_Surgaory_Summary__c pos = new Post_Surgaory_Summary__c();
            pos.TrialPatient__c = tp.Id;
            insert pos;
            
            On_Study_Pathology_Form__c osp = new On_Study_Pathology_Form__c();
            osp.TrialPatient__c = tp.Id;
            osp.Does_the_patient_have_bilateral_breast_c__c = 'Yes'; //on study path
            osp.Tumor_laterality__c = 'Left';
            insert osp;
            
            Procedure__c proObj1 = new Procedure__c();
            proObj1.TrialPatient__c = tp.Id;
            proObj1.On_Study_Pathology_Form__c = osp.Id;
            proObj1.Post_Surgery_Summary__c = pos.Id;
            proObj1.Form_Name__c = 'Breast Surgical Procedure Collection';
            proObj1.Procedure_Name__c = 'Partial mastectomy';
            insert proObj1; 
            
            Procedure__c proObj = new Procedure__c();
            proObj.TrialPatient__c = tp.Id;
            proObj.On_Study_Pathology_Form__c = osp.Id;
            proObj.Post_Surgery_Summary__c = pos.Id;
            proObj.Form_Name__c = 'Breast Surgical Procedure Collection';
            proObj.Procedure_Name__c = 'Partial mastectomy';
            
            Apexpages.currentPage().getParameters().put('postid',pos.Id);
            Apexpages.currentPage().getParameters().put('PathologyId',osp.Id);
            ProcedureComponentController pcc = new ProcedureComponentController();
            pcc.pathologyId = osp.Id;
            pcc.postId = pos.Id;
            pcc.saveNewProcedure();
        }
      }
    }
}