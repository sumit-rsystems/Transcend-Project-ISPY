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
private class TestProcedureBeforeInsert {

    @isTest static void myUnitTest() {
        Profile SiteProp = [ Select p.UserType, p.Name, (Select u.IsActive, u.Id From Users u where IsActive = true) From Profile p where Name = 'Site User'];
        List<User> lstSiteUser = SiteProp.Users;     
        System.runAs ( lstSiteUser[0] ) { 
        
        Account inst1 = new Account();
        
        List<Account> lstAccount = [Select a.RecordType.Name, a.RecordTypeId, a.Id From Account a where RecordType.Name = 'DCC' or RecordType.Name = 'Institution']; 
        
        if(!lstAccount.isEmpty()){
                
        inst1 = lstAccount[0];
        
        Code_Master__c snomedObject = new Code_Master__c();
        snomedObject.Variable_Description__c = 'test';
        snomedObject.IsReportColumn__c = true;
        snomedObject.Display_Order__c = 3.0;
        snomedObject.Name = 'FNA_Br_pretx';
        insert snomedObject;
        
        Code_Master__c snomedObject1 = new Code_Master__c();
        snomedObject1.Variable_Description__c = 'test';
        snomedObject1.IsReportColumn__c = true;
        snomedObject1.Display_Order__c = 3.0;
        snomedObject1.Name = 'CoreNeedle_Br__pretx';
        insert snomedObject1;
        
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
        
        On_Study_Pathology_Form__c ospObj = new On_Study_Pathology_Form__c();
        ospObj.TrialPatient__c = triPat.Id;
        ospObj.Does_the_patient_have_bilateral_breast_c__c = 'Yes';
        ospObj.Tumor_laterality__c = 'Left';
        insert ospObj;
        
        Post_Surgaory_Summary__c pss = new Post_Surgaory_Summary__c();
        pss.TrialPatient__c = triPat.Id;
        pss.Date_Of_Procedure__c = date.newInstance(2012, 7, 7);
        pss.Type_Of_Tumor__c = 'Single Discrete Mass';
        pss.Status__c = 'Not Completed';
        insert pss;
        
        pss.Status__c = 'Accepted';
        update pss;
        
      /*  Receptors__c rec = new Receptors__c();
        rec.On_Study_Pathology_Form__c = ospObj.Id;
        rec.Post_Surgery_Summary__c = pss.Id;
        insert rec;
        
        DCIS__c dcis = new DCIS__c();
        dcis.On_Study_Pathology_Form__c = ospObj.Id;
        insert dcis;
        
        LCIS__c lcis = new LCIS__c();
        lcis.On_Study_Pathology_Form__c = ospObj.Id;
        insert lcis;
        
        Invasive_Tumor_Detail__c itd = new Invasive_Tumor_Detail__c();
        itd.On_Study_Pathology_Form__c = ospObj.Id;
        insert itd; */
        
        Procedure__c p = new Procedure__c();
        p.On_Study_Pathology_Form__c = ospObj.Id;
        p.Procedure_Name__c = 'FNA';
        p.TrialPatient__c = triPat.Id;
        p.Form_Name__c = 'On-Study Pathology Form(Lymph Node Biopsies)';
        p.Node_Type__c = 'Axillary (Lymph node)';
        p.Node_Result__c = 'Positive';
        insert p;
        
        Procedure__c p1 = new Procedure__c();
        p1.On_Study_Pathology_Form__c = ospObj.Id;
        p1.Procedure_Name__c = 'FNA (lymph node)';
        p1.TrialPatient__c = triPat.Id;
        insert p1;
        
        Procedure__c p2 = new Procedure__c();
        p2.On_Study_Pathology_Form__c = ospObj.Id;
        p2.Procedure_Name__c = 'Core biopsy';
        p2.TrialPatient__c = triPat.Id;
        insert p2;
        }
      }
    }
     @isTest static void myUnitTest1() {
        Profile SiteProp = [ Select p.UserType, p.Name, (Select u.IsActive, u.Id From Users u where IsActive = true) From Profile p where Name = 'Site User'];
        List<User> lstSiteUser = SiteProp.Users;     
        System.runAs ( lstSiteUser[0] ) { 
        
        Account inst1 = new Account();
        
        List<Account> lstAccount = [Select a.RecordType.Name, a.RecordTypeId, a.Id From Account a where RecordType.Name = 'DCC' or RecordType.Name = 'Institution']; 
        
        if(!lstAccount.isEmpty()){
                
        inst1 = lstAccount[0];            // newly added logic to overcome the error of "setup and nonsetup" object
        
        Code_Master__c snomedObject = new Code_Master__c();
        snomedObject.Variable_Description__c = 'test';
        snomedObject.IsReportColumn__c = true;
        snomedObject.Display_Order__c = 3.0;
        snomedObject.Name = 'FNA_Br_pretx';
        insert snomedObject;
        
        Code_Master__c snomedObject1 = new Code_Master__c();
        snomedObject1.Variable_Description__c = 'test';
        snomedObject1.IsReportColumn__c = true;
        snomedObject1.Display_Order__c = 3.0;
        snomedObject1.Name = 'CoreNeedle_LN_Pretx';
        insert snomedObject1;
        
        Code_Master__c snomedObject2 = new Code_Master__c();
        snomedObject2.Variable_Description__c = 'test';
        snomedObject2.IsReportColumn__c = true;
        snomedObject2.Display_Order__c = 3.0;
        snomedObject2.Name = 'Excisional_Br_pretx';
        insert snomedObject2;
        
        Patient_Custom__c pc = new Patient_Custom__c();
        pc.First_Name__c = 'test';
        pc.Last_Name__c = 'test1';
        pc.Gender__c = 'Male';
        pc.Birthdate__c = system.today();
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
        
        On_Study_Pathology_Form__c ospObj = new On_Study_Pathology_Form__c();
        ospObj.TrialPatient__c = triPat.Id;
        ospObj.Does_the_patient_have_bilateral_breast_c__c = 'Yes';
        ospObj.Tumor_laterality__c = 'Left';
        insert ospObj;
        
        Post_Surgaory_Summary__c pss = new Post_Surgaory_Summary__c();
        pss.TrialPatient__c = triPat.Id;
        pss.Date_Of_Procedure__c = date.newInstance(2012, 7, 7);
        pss.Type_Of_Tumor__c = 'Single Discrete Mass';
        pss.Status__c = 'Not Completed';
        insert pss;
        
        pss.Status__c = 'Accepted';
        update pss;
        
      /*  Receptors__c rec = new Receptors__c();
        rec.On_Study_Pathology_Form__c = ospObj.Id;
        rec.Post_Surgery_Summary__c = pss.Id;
        insert rec;
        
        DCIS__c dcis = new DCIS__c();
        dcis.On_Study_Pathology_Form__c = ospObj.Id;
        insert dcis;
        
        LCIS__c lcis = new LCIS__c();
        lcis.On_Study_Pathology_Form__c = ospObj.Id;
        insert lcis;
        
        Invasive_Tumor_Detail__c itd = new Invasive_Tumor_Detail__c();
        itd.On_Study_Pathology_Form__c = ospObj.Id;
        insert itd;*/
        
        Procedure__c p = new Procedure__c();
        p.On_Study_Pathology_Form__c = ospObj.Id;
        p.Procedure_Name__c = 'Core biopsy (lymph node)';
        p.TrialPatient__c = triPat.Id;
        p.Form_Name__c = 'On-Study Pathology Form(Lymph Node Biopsies)';
        p.Node_Type__c = 'Axillary (Lymph node)';
        p.Node_Result__c = 'Positive';
        insert p;
        
        Procedure__c p1 = new Procedure__c();
        p1.On_Study_Pathology_Form__c = ospObj.Id;
        p1.Procedure_Name__c = 'Incisional biopsy';
        p1.TrialPatient__c = triPat.Id;
        insert p1;
        
        Procedure__c p2 = new Procedure__c();
        p2.On_Study_Pathology_Form__c = ospObj.Id;
        p2.Procedure_Name__c = 'Partial mastectomy';
        p2.TrialPatient__c = triPat.Id;
        insert p2;
        
      /*  Procedure__c p3 = new Procedure__c();
        p3.On_Study_Pathology_Form__c = ospObj.Id;
        p3.TrialPatient__c = triPat.Id;
        p3.Form_Name__c = 'On-Study Pathology Form(Lymph Node Biopsies)';
        p3.Node_Type__c = 'Sentinel (Lymph node)';
        p3.Node_Result__c = 'Positive';
        insert p3; */
        }
      }
   }
}