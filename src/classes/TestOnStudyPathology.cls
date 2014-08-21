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
private class TestOnStudyPathology {

    @isTest static void myUnitTest() {
        // TO DO: implement unit test
        
        Profile SiteProp = [ Select p.UserType, p.Name, (Select u.IsActive, u.Id From Users u where IsActive = true) From Profile p where Name = 'Site User'];
        List<User> lstSiteUser = SiteProp.Users;     
        System.runAs ( lstSiteUser[0] ) { 
        
        Account inst1 = new Account();
        
        List<Account> lstAccount = [Select a.RecordType.Name, a.RecordTypeId, a.Id From Account a where RecordType.Name = 'DCC' or RecordType.Name = 'Institution']; 
        
        if(!lstAccount.isEmpty()){
                
        inst1 = lstAccount[0];           // newly added logic to overcome the error of "setup and nonsetup" object
        
        Code_Master__c snomedObject = new Code_Master__c();
        snomedObject.Variable_Description__c = 'test';
        snomedObject.IsReportColumn__c = true;
        snomedObject.Display_Order__c = 1.0;
        snomedObject.Name = 'FNA_Br_pretx';
        insert snomedObject;
        
        Code_Master__c snomedObject1 = new Code_Master__c();
        snomedObject1.Variable_Description__c = 'test';
        snomedObject1.IsReportColumn__c = true;
        snomedObject1.Display_Order__c = 1.0;
        snomedObject1.Name = 'CoreNeedle_Br__pretx';
        insert snomedObject1;
        
        Code_Master__c snomedObject2 = new Code_Master__c();
        snomedObject2.Variable_Description__c = 'test';
        snomedObject2.IsReportColumn__c = true;
        snomedObject2.Display_Order__c = 1.0;
        snomedObject2.Name = 'Excisional_Br_pretx';
        insert snomedObject2;
        
        Code_Master__c snomedObject3 = new Code_Master__c();
        snomedObject3.Variable_Description__c = 'test';
        snomedObject3.IsReportColumn__c = true;
        snomedObject3.Display_Order__c = 1.0;
        snomedObject3.Name = 'Surgery_Br';
        insert snomedObject3;
        
        Code_Master__c snomedObject4 = new Code_Master__c();
        snomedObject4.Variable_Description__c = 'test';
        snomedObject4.IsReportColumn__c = true;
        snomedObject4.Display_Order__c = 1.0;
        snomedObject4.Name = 'Excisional_Br_pretx';
        insert snomedObject4;
        
        Code_Master__c snomedObject5 = new Code_Master__c();
        snomedObject5.Variable_Description__c = 'test';
        snomedObject5.IsReportColumn__c = true;
        snomedObject5.Display_Order__c = 1.0;
        snomedObject5.Name = 'CoreNeedle_LN_Pretx';
        insert snomedObject5;
        
        Code_Master__c snomedObject6 = new Code_Master__c();
        snomedObject6.Variable_Description__c = 'test';
        snomedObject6.IsReportColumn__c = true;
        snomedObject6.Display_Order__c = 1.0;
        snomedObject6.Name = 'Bx_SN_Pretx';
        insert snomedObject6;
        
        Code_Master__c snomedObject7 = new Code_Master__c();
        snomedObject7.Variable_Description__c = 'test';
        snomedObject7.IsReportColumn__c = true;
        snomedObject7.Display_Order__c = 1.0;
        snomedObject7.Name = 'NumExLN_PS';
        insert snomedObject7;
        
        Code_Master__c snomedObject8 = new Code_Master__c();
        snomedObject8.Variable_Description__c = 'test';
        snomedObject8.IsReportColumn__c = true;
        snomedObject8.Display_Order__c = 1.0;
        snomedObject8.Name = 'NumPosLN_PS';
        insert snomedObject8;
        
        Patient_Custom__c pc = new Patient_Custom__c();
        pc.First_Name__c = 'test';
        pc.Last_Name__c = 'test1';
        pc.Gender__c = 'Male';
        pc.Birthdate__c = date.newInstance(1986, 8, 9);
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
        
        CRF__c crf = new CRF__c();
        crf.Status__c = 'Accepted';
        crf.Patient__c = pc.Id;
        insert crf;
        
        On_Study_Pathology_Form__c ospObj = new On_Study_Pathology_Form__c();
        ospObj.TrialPatient__c = triPat.Id;
        ospObj.Status__c = 'Accepted';
        ospObj.CRF__c = crf.Id;
        ospObj.Is_DCIS_Present__c='yes';
        ospObj.Is_invasive_tumor_present__c='yes';
        ospObj.Is_LCIS_Present__c='yes';
        ospObj.Does_the_patient_have_bilateral_breast_c__c = 'Yes';
        ospObj.Tumor_laterality__c = 'Left';
        insert ospObj;
          
        ospObj.Status__c = 'Accepted';
        update ospObj;
        
        DCIS__c dcis = new DCIS__c();
        dcis.On_Study_Pathology_Form__c = ospObj.Id;
        dcis.Punctate_necrosis__c = true;
        dcis.Calcifications__c='Yes';
        dcis.Nuclear_Grade__c='Grade I (low)';
        insert dcis; 
        
        LCIS__c lcis = new LCIS__c();
        lcis.Histological_Type__c='Classic'; 
        lcis.On_Study_Pathology_Form__c = ospObj.Id;
        insert lcis; 
        
        Invasive_Tumor_Detail__c itd = new Invasive_Tumor_Detail__c();
        itd.On_Study_Pathology_Form__c = ospObj.Id;
        itd.Invasive_ductal_carcinoma_nos__c=true; 
        itd.Calcifications__c ='yes';
        itd.Nuclear_Grade__c='Grade I (low)'; 
        itd.Mitotic_Count__c = '1pt';
        itd.Tubule_Papilla_formation__c = '1pt';
        itd.Lympatic_vascular_Invasion__c = 'Present';
        itd.Skin_Involvement__c = 'Yes';
        insert itd;
        
        Procedure__c p = new Procedure__c();
        p.On_Study_Pathology_Form__c = ospObj.Id;
        p.TrialPatient__c = triPat.Id;
        p.Form_Name__c = 'On-Study Pathology Form(Positive Breast Biopsies)';
        p.Procedure_Name__c = 'Core biopsy';
        p.Ultrasound__c = true;
        p.Palpation_guided__c = true;
        p.Mammography__c = true;
        p.MRI__c = true;
        p.Stereotactic__c = true;
        insert p;
        
        Procedure__c p1 = new Procedure__c();
        p1.On_Study_Pathology_Form__c = ospObj.Id;
        p1.TrialPatient__c = triPat.Id;
        p1.Form_Name__c = 'On-Study Pathology Form(Lymph Node Biopsies)';
        p1.Procedure_Name__c = 'Core biopsy (lymph node)';
        p1.Ultrasound__c = true;
        p1.Palpation_guided__c = true;
        p1.Mammography__c = true;
        p1.MRI__c = true;
        p1.Stereotactic__c = true;
        insert p1; 
        
        ComponentControllerBase ccb = new ComponentControllerBase(); // VIRTUAL CLASS "ComponentControllerBase"
        ccb.key = '1';
        
        PageControllerBase pcb = new PageControllerBase(); // VIRTUAL CLASS "PageControllerBase" BEGINS HERE
        
        pcb.setComponentControllerMap('1', ccb);
        pcb.getComponentControllerMap();
        
        pcb.setDcisController(ccb);
        pcb.getDcisController();
        
        pcb.setIvtComponentController(ccb);
        pcb.getIvtComponentController();
        
        pcb.setLcisComponentController(ccb);
        pcb.getLcisComponentController();
        
     //   pcb.setReceptorsComponentController(ccb);  
     //   pcb.getReceptorsComponentController();
        
        pcb.setAddQuesComponentController(ccb);
        pcb.getAddQuesComponentController();
        
        pcb.setStagingCompController(ccb);
        pcb.getStagingCompController();
        
        pcb.setRegimenAgentCompController(ccb);
        pcb.getRegimenAgentCompController();
        
        pcb.setAddToxicityCompController(ccb);
        pcb.getAddToxicityCompController();
        
        pcb.getThis(); // VIRTUAL CLASS "PageControllerBase" ENDS HERE
        
        Apexpages.currentPage().getParameters().put('PathologyId',ospObj.Id); // if part line 109
        
        ApexPages.StandardController cont = new ApexPages.StandardController(ospObj);
        OnStudyPathology ospClass = new OnStudyPathology(cont);
        
        ospClass.callIvtControllerMethod(ospObj.Id);
        ospClass.callDcisControllerMethod(ospObj.Id);
        ospClass.callLcisControllerMethod(ospObj.Id);
       // ospClass.callReceptorsControllerMethod(ospObj.Id);
        
      //===============method "insertPathology" begins here ============

        Apexpages.currentPage().getParameters().put('trialPat',triPat.Id);
        ospClass.insertPathology();
        
          }
       }
   }
   
   @isTest static void myUnitTest1() {
        // TO DO: implement unit test
        
        Profile SiteProp = [ Select p.UserType, p.Name, (Select u.IsActive, u.Id From Users u where IsActive = true) From Profile p where Name = 'Site User'];
        List<User> lstSiteUser = SiteProp.Users;     
        System.runAs ( lstSiteUser[0] ) { 
            
        Account inst1 = new Account();
        
        List<Account> lstAccount = [Select a.RecordType.Name, a.RecordTypeId, a.Id From Account a where RecordType.Name = 'DCC' or RecordType.Name = 'Institution']; 
        
        if(!lstAccount.isEmpty()){
                
        inst1 = lstAccount[0];              // newly added logic to overcome the error of "setup and nonsetup" object
        
        Code_Master__c snomedObject = new Code_Master__c();
        snomedObject.Variable_Description__c = 'test';
        snomedObject.IsReportColumn__c = true;
        snomedObject.Display_Order__c = 1.0;
        snomedObject.Name = 'FNA_Br_pretx';
        insert snomedObject;
        
        Code_Master__c snomedObject1 = new Code_Master__c();
        snomedObject1.Variable_Description__c = 'test';
        snomedObject1.IsReportColumn__c = true;
        snomedObject1.Display_Order__c = 1.0;
        snomedObject1.Name = 'CoreNeedle_Br__pretx';
        insert snomedObject1;
        
        Code_Master__c snomedObject2 = new Code_Master__c();
        snomedObject2.Variable_Description__c = 'test';
        snomedObject2.IsReportColumn__c = true;
        snomedObject2.Display_Order__c = 1.0;
        snomedObject2.Name = 'Excisional_Br_pretx';
        insert snomedObject2;
        
        Code_Master__c snomedObject3 = new Code_Master__c();
        snomedObject3.Variable_Description__c = 'test';
        snomedObject3.IsReportColumn__c = true;
        snomedObject3.Display_Order__c = 1.0;
        snomedObject3.Name = 'Surgery_Br';
        insert snomedObject3;
        
        Code_Master__c snomedObject4 = new Code_Master__c();
        snomedObject4.Variable_Description__c = 'test';
        snomedObject4.IsReportColumn__c = true;
        snomedObject4.Display_Order__c = 1.0;
        snomedObject4.Name = 'Excisional_Br_pretx';
        insert snomedObject4;
        
        Code_Master__c snomedObject5 = new Code_Master__c();
        snomedObject5.Variable_Description__c = 'test';
        snomedObject5.IsReportColumn__c = true;
        snomedObject5.Display_Order__c = 1.0;
        snomedObject5.Name = 'CoreNeedle_LN_Pretx';
        insert snomedObject5;
        
        Code_Master__c snomedObject6 = new Code_Master__c();
        snomedObject6.Variable_Description__c = 'test';
        snomedObject6.IsReportColumn__c = true;
        snomedObject6.Display_Order__c = 1.0;
        snomedObject6.Name = 'Bx_SN_Pretx';
        insert snomedObject6;
        
        Code_Master__c snomedObject7 = new Code_Master__c();
        snomedObject7.Variable_Description__c = 'test';
        snomedObject7.IsReportColumn__c = true;
        snomedObject7.Display_Order__c = 1.0;
        snomedObject7.Name = 'NumExLN_PS';
        insert snomedObject7;
        
        Code_Master__c snomedObject8 = new Code_Master__c();
        snomedObject8.Variable_Description__c = 'test';
        snomedObject8.IsReportColumn__c = true;
        snomedObject8.Display_Order__c = 1.0;
        snomedObject8.Name = 'NumPosLN_PS';
        insert snomedObject8;
        
        Patient_Custom__c pc = new Patient_Custom__c();
        pc.First_Name__c = 'test';
        pc.Last_Name__c = 'test1';
        pc.Gender__c = 'Male';
        pc.Birthdate__c = date.newInstance(1986, 8, 9);
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
        
        CRF__c crf = new CRF__c();
        crf.Status__c = 'Accepted';
        crf.Patient__c = pc.Id;
        insert crf;
        
        On_Study_Pathology_Form__c ospObj = new On_Study_Pathology_Form__c();
        ospObj.TrialPatient__c = triPat.Id;
        ospObj.Status__c = 'Accepted';
        ospObj.CRF__c = crf.Id;
        ospObj.Is_DCIS_Present__c='yes';
        ospObj.Is_invasive_tumor_present__c='yes';
        ospObj.Is_LCIS_Present__c='yes';
        ospObj.Does_the_patient_have_bilateral_breast_c__c = 'Yes';
        ospObj.Tumor_laterality__c = 'Left';
        insert ospObj;
          
        ospObj.Status__c = 'Accepted';
        update ospObj;
        
        DCIS__c dcis = new DCIS__c();
        dcis.On_Study_Pathology_Form__c = ospObj.Id;
        dcis.Punctate_necrosis__c = true;
        dcis.Calcifications__c='Yes';
        dcis.Nuclear_Grade__c='Grade I (low)';
        insert dcis; 
        
        LCIS__c lcis = new LCIS__c();
        lcis.Histological_Type__c='Classic'; 
        lcis.On_Study_Pathology_Form__c = ospObj.Id;
        insert lcis; 
        
        Invasive_Tumor_Detail__c itd = new Invasive_Tumor_Detail__c();
        itd.On_Study_Pathology_Form__c = ospObj.Id;
        itd.Invasive_ductal_carcinoma_nos__c=true; 
        itd.Calcifications__c ='yes';
        itd.Nuclear_Grade__c='Grade I (low)'; 
        itd.Mitotic_Count__c = '1pt';
        itd.Tubule_Papilla_formation__c = '1pt';
        itd.Lympatic_vascular_Invasion__c = 'Present';
        itd.Skin_Involvement__c = 'Yes';
        insert itd;
        
        Procedure__c p = new Procedure__c();
        p.On_Study_Pathology_Form__c = ospObj.Id;
        p.TrialPatient__c = triPat.Id;
        p.Form_Name__c = 'On-Study Pathology Form(Positive Breast Biopsies)';
        p.Procedure_Name__c = 'Core biopsy';
        p.Ultrasound__c = true;
        p.Palpation_guided__c = true;
        p.Mammography__c = true;
        p.MRI__c = true;
        p.Stereotactic__c = true;
        insert p;
        
        Procedure__c p1 = new Procedure__c();
        p1.On_Study_Pathology_Form__c = ospObj.Id;
        p1.TrialPatient__c = triPat.Id;
        p1.Form_Name__c = 'On-Study Pathology Form(Lymph Node Biopsies)';
        p1.Procedure_Name__c = 'Core biopsy (lymph node)';
        p1.Ultrasound__c = true;
        p1.Palpation_guided__c = true;
        p1.Mammography__c = true;
        p1.MRI__c = true;
        p1.Stereotactic__c = true;
        insert p1; 
        
        Apexpages.currentPage().getParameters().put('trialPat',triPat.Id);
        Apexpages.currentPage().getParameters().put('PathologyId',null);
        ApexPages.StandardController cont = new ApexPages.StandardController(ospObj);
        OnStudyPathology ospClass1 = new OnStudyPathology(cont);
        ospClass1.insertPathology(); 
        }
      }
   }
    @isTest static void myUnitTest2() {
        // TO DO: implement unit test
        
        Profile SiteProp = [ Select p.UserType, p.Name, (Select u.IsActive, u.Id From Users u where IsActive = true) From Profile p where Name = 'Site User'];
        List<User> lstSiteUser = SiteProp.Users;     
        System.runAs ( lstSiteUser[0] ) { 
        
        Account inst1 = new Account();
        
        List<Account> lstAccount = [Select a.RecordType.Name, a.RecordTypeId, a.Id From Account a where RecordType.Name = 'DCC' or RecordType.Name = 'Institution']; 
        
        if(!lstAccount.isEmpty()){
                
        inst1 = lstAccount[0];                     // newly added logic to overcome the error of "setup and nonsetup" object
        
        Code_Master__c snomedObject = new Code_Master__c();
        snomedObject.Variable_Description__c = 'test';
        snomedObject.IsReportColumn__c = true;
        snomedObject.Display_Order__c = 1.0;
        snomedObject.Name = 'FNA_Br_pretx';
        insert snomedObject;
        
        Code_Master__c snomedObject1 = new Code_Master__c();
        snomedObject1.Variable_Description__c = 'test';
        snomedObject1.IsReportColumn__c = true;
        snomedObject1.Display_Order__c = 1.0;
        snomedObject1.Name = 'CoreNeedle_Br__pretx';
        insert snomedObject1;
        
        Code_Master__c snomedObject2 = new Code_Master__c();
        snomedObject2.Variable_Description__c = 'test';
        snomedObject2.IsReportColumn__c = true;
        snomedObject2.Display_Order__c = 1.0;
        snomedObject2.Name = 'Excisional_Br_pretx';
        insert snomedObject2;
        
        Code_Master__c snomedObject3 = new Code_Master__c();
        snomedObject3.Variable_Description__c = 'test';
        snomedObject3.IsReportColumn__c = true;
        snomedObject3.Display_Order__c = 1.0;
        snomedObject3.Name = 'Surgery_Br';
        insert snomedObject3;
        
        Code_Master__c snomedObject4 = new Code_Master__c();
        snomedObject4.Variable_Description__c = 'test';
        snomedObject4.IsReportColumn__c = true;
        snomedObject4.Display_Order__c = 1.0;
        snomedObject4.Name = 'Excisional_Br_pretx';
        insert snomedObject4;
        
        Code_Master__c snomedObject5 = new Code_Master__c();
        snomedObject5.Variable_Description__c = 'test';
        snomedObject5.IsReportColumn__c = true;
        snomedObject5.Display_Order__c = 1.0;
        snomedObject5.Name = 'CoreNeedle_LN_Pretx';
        insert snomedObject5;
        
        Code_Master__c snomedObject6 = new Code_Master__c();
        snomedObject6.Variable_Description__c = 'test';
        snomedObject6.IsReportColumn__c = true;
        snomedObject6.Display_Order__c = 1.0;
        snomedObject6.Name = 'Bx_SN_Pretx';
        insert snomedObject6;
        
        Code_Master__c snomedObject7 = new Code_Master__c();
        snomedObject7.Variable_Description__c = 'test';
        snomedObject7.IsReportColumn__c = true;
        snomedObject7.Display_Order__c = 1.0;
        snomedObject7.Name = 'NumExLN_PS';
        insert snomedObject7;
        
        Code_Master__c snomedObject8 = new Code_Master__c();
        snomedObject8.Variable_Description__c = 'test';
        snomedObject8.IsReportColumn__c = true;
        snomedObject8.Display_Order__c = 1.0;
        snomedObject8.Name = 'NumPosLN_PS';
        insert snomedObject8;
        
        Patient_Custom__c pc = new Patient_Custom__c();
        pc.First_Name__c = 'test';
        pc.Last_Name__c = 'test1';
        pc.Gender__c = 'Male';
        pc.Birthdate__c = date.newInstance(1986, 8, 9);
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
        
        CRF__c crf = new CRF__c();
        crf.Status__c = 'Accepted';
        crf.Patient__c = pc.Id;
        insert crf;
        
        On_Study_Pathology_Form__c ospObj = new On_Study_Pathology_Form__c();
        ospObj.TrialPatient__c = triPat.Id;
        ospObj.Status__c = 'Accepted';
        ospObj.CRF__c = crf.Id;
        ospObj.Is_DCIS_Present__c='yes';
        ospObj.Is_invasive_tumor_present__c='yes';
        ospObj.Is_LCIS_Present__c='yes';
        ospObj.Does_the_patient_have_bilateral_breast_c__c = 'Yes';
        ospObj.Tumor_laterality__c = 'Left';
        insert ospObj;
          
        ospObj.Status__c = 'Accepted';
        update ospObj;
        
        DCIS__c dcis = new DCIS__c();
        dcis.On_Study_Pathology_Form__c = ospObj.Id;
        dcis.Punctate_necrosis__c = true;
        dcis.Calcifications__c='Yes';
        dcis.Nuclear_Grade__c='Grade I (low)';
        insert dcis; 
        
        LCIS__c lcis = new LCIS__c();
        lcis.Histological_Type__c='Classic'; 
        lcis.On_Study_Pathology_Form__c = ospObj.Id;
        insert lcis; 
        
        Invasive_Tumor_Detail__c itd = new Invasive_Tumor_Detail__c();
        itd.On_Study_Pathology_Form__c = ospObj.Id;
        itd.Invasive_ductal_carcinoma_nos__c=true; 
        itd.Calcifications__c ='yes';
        itd.Nuclear_Grade__c='Grade I (low)'; 
        itd.Mitotic_Count__c = '1pt';
        itd.Tubule_Papilla_formation__c = '1pt';
        itd.Lympatic_vascular_Invasion__c = 'Present';
        itd.Skin_Involvement__c = 'Yes';
        insert itd;
        
        Procedure__c p = new Procedure__c();
        p.On_Study_Pathology_Form__c = ospObj.Id;
        p.TrialPatient__c = triPat.Id;
        p.Form_Name__c = 'On-Study Pathology Form(Positive Breast Biopsies)';
        p.Procedure_Name__c = 'Core biopsy';
        p.Ultrasound__c = true;
        p.Palpation_guided__c = true;
        p.Mammography__c = true;
        p.MRI__c = true;
        p.Stereotactic__c = true;
        insert p;
        
        Procedure__c p1 = new Procedure__c();
        p1.On_Study_Pathology_Form__c = ospObj.Id;
        p1.TrialPatient__c = triPat.Id;
        p1.Form_Name__c = 'On-Study Pathology Form(Lymph Node Biopsies)';
        p1.Procedure_Name__c = 'Core biopsy (lymph node)';
        p1.Ultrasound__c = true;
        p1.Palpation_guided__c = true;
        p1.Mammography__c = true;
        p1.MRI__c = true;
        p1.Stereotactic__c = true;
        insert p1; 
        
        Apexpages.currentPage().getParameters().put('trialPat',triPat.Id);
        Apexpages.currentPage().getParameters().put('PathologyId',null);
        ApexPages.StandardController cont = new ApexPages.StandardController(ospObj);
        OnStudyPathology ospClass1 = new OnStudyPathology(cont);
        
        ospClass1.insertPathology();  
        }
      }
   }
   @isTest static void myUnitTest3() {
        // TO DO: implement unit test
        
        Profile SiteProp = [ Select p.UserType, p.Name, (Select u.IsActive, u.Id From Users u where IsActive = true) From Profile p where Name = 'Site User'];
        List<User> lstSiteUser = SiteProp.Users;     
        System.runAs ( lstSiteUser[0] ) { 
        
        Account inst1 = new Account();
        
        List<Account> lstAccount = [Select a.RecordType.Name, a.RecordTypeId, a.Id From Account a where RecordType.Name = 'DCC' or RecordType.Name = 'Institution']; 
        
        if(!lstAccount.isEmpty()){
                
        inst1 = lstAccount[0];                      // newly added logic to overcome the error of "setup and nonsetup" object
        
        Code_Master__c snomedObject = new Code_Master__c();
        snomedObject.Variable_Description__c = 'test';
        snomedObject.IsReportColumn__c = true;
        snomedObject.Display_Order__c = 1.0;
        snomedObject.Name = 'FNA_Br_pretx';
        insert snomedObject;
        
        Code_Master__c snomedObject1 = new Code_Master__c();
        snomedObject1.Variable_Description__c = 'test';
        snomedObject1.IsReportColumn__c = true;
        snomedObject1.Display_Order__c = 1.0;
        snomedObject1.Name = 'CoreNeedle_Br__pretx';
        insert snomedObject1;
        
        Code_Master__c snomedObject2 = new Code_Master__c();
        snomedObject2.Variable_Description__c = 'test';
        snomedObject2.IsReportColumn__c = true;
        snomedObject2.Display_Order__c = 1.0;
        snomedObject2.Name = 'Excisional_Br_pretx';
        insert snomedObject2;
        
        Code_Master__c snomedObject3 = new Code_Master__c();
        snomedObject3.Variable_Description__c = 'test';
        snomedObject3.IsReportColumn__c = true;
        snomedObject3.Display_Order__c = 1.0;
        snomedObject3.Name = 'Surgery_Br';
        insert snomedObject3;
        
        Code_Master__c snomedObject4 = new Code_Master__c();
        snomedObject4.Variable_Description__c = 'test';
        snomedObject4.IsReportColumn__c = true;
        snomedObject4.Display_Order__c = 1.0;
        snomedObject4.Name = 'Excisional_Br_pretx';
        insert snomedObject4;
        
        Code_Master__c snomedObject5 = new Code_Master__c();
        snomedObject5.Variable_Description__c = 'test';
        snomedObject5.IsReportColumn__c = true;
        snomedObject5.Display_Order__c = 1.0;
        snomedObject5.Name = 'CoreNeedle_LN_Pretx';
        insert snomedObject5;
        
        Code_Master__c snomedObject6 = new Code_Master__c();
        snomedObject6.Variable_Description__c = 'test';
        snomedObject6.IsReportColumn__c = true;
        snomedObject6.Display_Order__c = 1.0;
        snomedObject6.Name = 'Bx_SN_Pretx';
        insert snomedObject6;
        
        Code_Master__c snomedObject7 = new Code_Master__c();
        snomedObject7.Variable_Description__c = 'test';
        snomedObject7.IsReportColumn__c = true;
        snomedObject7.Display_Order__c = 1.0;
        snomedObject7.Name = 'NumExLN_PS';
        insert snomedObject7;
        
        Code_Master__c snomedObject8 = new Code_Master__c();
        snomedObject8.Variable_Description__c = 'test';
        snomedObject8.IsReportColumn__c = true;
        snomedObject8.Display_Order__c = 1.0;
        snomedObject8.Name = 'NumPosLN_PS';
        insert snomedObject8;
        
        Patient_Custom__c pc = new Patient_Custom__c();
        pc.First_Name__c = 'test';
        pc.Last_Name__c = 'test1';
        pc.Gender__c = 'Male';
        pc.Birthdate__c = date.newInstance(1986, 8, 9);
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
        
        CRF__c crf = new CRF__c();
        crf.Status__c = 'Accepted';
        crf.Patient__c = pc.Id;
        insert crf;
        
        On_Study_Pathology_Form__c ospObj = new On_Study_Pathology_Form__c();
        ospObj.TrialPatient__c = triPat.Id;
        ospObj.Status__c = 'Accepted';
        ospObj.CRF__c = crf.Id;
        ospObj.Is_DCIS_Present__c='yes';
        ospObj.Is_invasive_tumor_present__c='yes';
        ospObj.Is_LCIS_Present__c='yes';
        ospObj.Does_the_patient_have_bilateral_breast_c__c = 'Yes';
        ospObj.Tumor_laterality__c = 'Left';
        insert ospObj;
          
        ospObj.Status__c = 'Accepted';
        update ospObj;
        
        DCIS__c dcis = new DCIS__c();
        dcis.On_Study_Pathology_Form__c = ospObj.Id;
        dcis.Punctate_necrosis__c = true;
        dcis.Calcifications__c='Yes';
        dcis.Nuclear_Grade__c='Grade I (low)';
        insert dcis; 
        
        LCIS__c lcis = new LCIS__c();
        lcis.On_Study_Pathology_Form__c = ospObj.Id;
        lcis.Histological_Type__c='Classic'; 
        insert lcis; 
        
        Invasive_Tumor_Detail__c itd = new Invasive_Tumor_Detail__c();
        itd.On_Study_Pathology_Form__c = ospObj.Id;
        itd.Invasive_ductal_carcinoma_nos__c=true; 
        itd.Calcifications__c ='yes';
        itd.Nuclear_Grade__c='Grade I (low)'; 
        itd.Mitotic_Count__c = '1pt';
        itd.Tubule_Papilla_formation__c = '1pt';
        itd.Lympatic_vascular_Invasion__c = 'Present';
        itd.Skin_Involvement__c = 'Yes';
        insert itd;
        
        Procedure__c p = new Procedure__c();
        p.On_Study_Pathology_Form__c = ospObj.Id;
        p.TrialPatient__c = triPat.Id;
        p.Form_Name__c = 'On-Study Pathology Form(Positive Breast Biopsies)';
        p.Procedure_Name__c = 'Core biopsy';
        p.Ultrasound__c = true;
        p.Palpation_guided__c = true;
        p.Mammography__c = true;
        p.MRI__c = true;
        p.Stereotactic__c = true;
        insert p;
        
        Procedure__c p1 = new Procedure__c();
        p1.On_Study_Pathology_Form__c = ospObj.Id;
        p1.TrialPatient__c = triPat.Id;
        p1.Form_Name__c = 'On-Study Pathology Form(Lymph Node Biopsies)';
        p1.Procedure_Name__c = 'Core biopsy (lymph node)';
        p1.Ultrasound__c = true;
        p1.Palpation_guided__c = true;
        p1.Mammography__c = true;
        p1.MRI__c = true;
        p1.Stereotactic__c = true;
        insert p1; 
        
        Apexpages.currentPage().getParameters().put('PathologyId',ospObj.Id); 
        ApexPages.StandardController cont = new ApexPages.StandardController(ospObj);
        OnStudyPathology ospClass = new OnStudyPathology(cont);
        
        //==============method "next" begins here ===========================
      
        Apexpages.currentPage().getParameters().put('trialPat',triPat.Id); // method 'next' begins
        Apexpages.currentPage().getParameters().put('tabNext','DiseaseDescription');
        
        ospClass.currentTab = 'procedureTab';
        ospClass.nextTabName = 'DiseaseDescription';
        ospClass.isDCIS = 'Yes';
        ospClass.isInasive = 'Yes';
        ospClass.isLCIS = 'Yes';
        ospClass.next();
        
        ospClass.currentTab = 'procedureTab';
        ospClass.next();
        
        //=====================method "next" ends here ===========================
        
        Apexpages.currentPage().getParameters().put('tabPrevious','Disease Description');
        ospClass.previous();
        
        ospClass.onChangeVal();
        
        Apexpages.currentPage().getParameters().put('trialPat',triPat.Id);
        ospClass.submit();
        }
     }
  }
  @isTest static void myUnitTest4() {
        // TO DO: implement unit test
        
        Profile SiteProp = [ Select p.UserType, p.Name, (Select u.IsActive, u.Id From Users u where IsActive = true) From Profile p where Name = 'Site User'];
        List<User> lstSiteUser = SiteProp.Users;     
        System.runAs ( lstSiteUser[0] ) { 
        
        Account inst1 = new Account();
        
        List<Account> lstAccount = [Select a.RecordType.Name, a.RecordTypeId, a.Id From Account a where RecordType.Name = 'DCC' or RecordType.Name = 'Institution']; 
        
        if(!lstAccount.isEmpty()){
                
        inst1 = lstAccount[0];                  // newly added logic to overcome the error of "setup and nonsetup" object
        
        Code_Master__c snomedObject = new Code_Master__c();
        snomedObject.Variable_Description__c = 'test';
        snomedObject.IsReportColumn__c = true;
        snomedObject.Display_Order__c = 1.0;
        snomedObject.Name = 'FNA_Br_pretx';
        insert snomedObject;
        
        Code_Master__c snomedObject1 = new Code_Master__c();
        snomedObject1.Variable_Description__c = 'test';
        snomedObject1.IsReportColumn__c = true;
        snomedObject1.Display_Order__c = 1.0;
        snomedObject1.Name = 'CoreNeedle_Br__pretx';
        insert snomedObject1;
        
        Code_Master__c snomedObject2 = new Code_Master__c();
        snomedObject2.Variable_Description__c = 'test';
        snomedObject2.IsReportColumn__c = true;
        snomedObject2.Display_Order__c = 1.0;
        snomedObject2.Name = 'Excisional_Br_pretx';
        insert snomedObject2;
        
        Code_Master__c snomedObject3 = new Code_Master__c();
        snomedObject3.Variable_Description__c = 'test';
        snomedObject3.IsReportColumn__c = true;
        snomedObject3.Display_Order__c = 1.0;
        snomedObject3.Name = 'Surgery_Br';
        insert snomedObject3;
        
        Code_Master__c snomedObject4 = new Code_Master__c();
        snomedObject4.Variable_Description__c = 'test';
        snomedObject4.IsReportColumn__c = true;
        snomedObject4.Display_Order__c = 1.0;
        snomedObject4.Name = 'Excisional_Br_pretx';
        insert snomedObject4;
        
        Code_Master__c snomedObject5 = new Code_Master__c();
        snomedObject5.Variable_Description__c = 'test';
        snomedObject5.IsReportColumn__c = true;
        snomedObject5.Display_Order__c = 1.0;
        snomedObject5.Name = 'CoreNeedle_LN_Pretx';
        insert snomedObject5;
        
        Code_Master__c snomedObject6 = new Code_Master__c();
        snomedObject6.Variable_Description__c = 'test';
        snomedObject6.IsReportColumn__c = true;
        snomedObject6.Display_Order__c = 1.0;
        snomedObject6.Name = 'Bx_SN_Pretx';
        insert snomedObject6;
        
        Code_Master__c snomedObject7 = new Code_Master__c();
        snomedObject7.Variable_Description__c = 'test';
        snomedObject7.IsReportColumn__c = true;
        snomedObject7.Display_Order__c = 1.0;
        snomedObject7.Name = 'NumExLN_PS';
        insert snomedObject7;
        
        Code_Master__c snomedObject8 = new Code_Master__c();
        snomedObject8.Variable_Description__c = 'test';
        snomedObject8.IsReportColumn__c = true;
        snomedObject8.Display_Order__c = 1.0;
        snomedObject8.Name = 'NumPosLN_PS';
        insert snomedObject8;
        
        Patient_Custom__c pc = new Patient_Custom__c();
        pc.First_Name__c = 'test';
        pc.Last_Name__c = 'test1';
        pc.Gender__c = 'Male';
        pc.Birthdate__c = date.newInstance(1986, 8, 9);
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
        
        CRF__c crf = new CRF__c();
        crf.Status__c = 'Accepted';
        crf.Patient__c = pc.Id;
        insert crf;
        
        On_Study_Pathology_Form__c ospObj = new On_Study_Pathology_Form__c();
        ospObj.TrialPatient__c = triPat.Id;
        ospObj.Status__c = 'Accepted';
        ospObj.CRF__c = crf.Id;
        ospObj.Is_DCIS_Present__c='yes';
        ospObj.Is_invasive_tumor_present__c='yes';
        ospObj.Is_LCIS_Present__c='yes';
        ospObj.Does_the_patient_have_bilateral_breast_c__c = 'Yes';
        ospObj.Tumor_laterality__c = 'Left';
        insert ospObj;
          
        ospObj.Status__c = 'Accepted';
        update ospObj;
        
        DCIS__c dcis = new DCIS__c();
        dcis.On_Study_Pathology_Form__c = ospObj.Id;
        dcis.Punctate_necrosis__c = true;
        dcis.Calcifications__c='Yes';
        dcis.Nuclear_Grade__c='Grade I (low)';
        insert dcis; 
        
        LCIS__c lcis = new LCIS__c();
        lcis.On_Study_Pathology_Form__c = ospObj.Id;
        lcis.Histological_Type__c='Classic'; 
        insert lcis; 
        
        Invasive_Tumor_Detail__c itd = new Invasive_Tumor_Detail__c();
        itd.On_Study_Pathology_Form__c = ospObj.Id;
        itd.Invasive_ductal_carcinoma_nos__c=true; 
        itd.Calcifications__c ='yes';
        itd.Nuclear_Grade__c='Grade I (low)'; 
        itd.Mitotic_Count__c = '1pt';
        itd.Tubule_Papilla_formation__c = '1pt';
        itd.Lympatic_vascular_Invasion__c = 'Present';
        itd.Skin_Involvement__c = 'Yes';
        insert itd;
        
        Procedure__c p = new Procedure__c();
        p.On_Study_Pathology_Form__c = ospObj.Id;
        p.TrialPatient__c = triPat.Id;
        p.Form_Name__c = 'On-Study Pathology Form(Positive Breast Biopsies)';
        p.Procedure_Name__c = 'Core biopsy';
        p.Ultrasound__c = true;
        p.Palpation_guided__c = true;
        p.Mammography__c = true;
        p.MRI__c = true;
        p.Stereotactic__c = true;
        insert p;
        
        Procedure__c p1 = new Procedure__c();
        p1.On_Study_Pathology_Form__c = ospObj.Id;
        p1.TrialPatient__c = triPat.Id;
        p1.Form_Name__c = 'On-Study Pathology Form(Lymph Node Biopsies)';
        p1.Procedure_Name__c = 'Core biopsy (lymph node)';
        p1.Ultrasound__c = true;
        p1.Palpation_guided__c = true;
        p1.Mammography__c = true;
        p1.MRI__c = true;
        p1.Stereotactic__c = true;
        insert p1; 
        
        Apexpages.currentPage().getParameters().put('PathologyId',ospObj.Id); 
        ApexPages.StandardController cont = new ApexPages.StandardController(ospObj);
        OnStudyPathology ospClass = new OnStudyPathology(cont);
        
        //==============method "next" begins here ===========================
        Apexpages.currentPage().getParameters().put('trialPat',triPat.Id);
        Apexpages.currentPage().getParameters().put('tabNext','Receptors');
        ospClass.nextTabName = 'Receptors';
        ospClass.isDCIS = 'Yes';
        ospClass.isInasive = 'Yes';
        ospClass.isLCIS = 'Yes';
        ospClass.next(); 
        
        ospClass.dcisController.dcisObj = dcis;
        ospClass.lcisController.lcisObj = lcis;
        ospClass.ivtController.objITD = itd;
        ospClass.next(); 
        
        Apexpages.currentPage().getParameters().put('trialPat',triPat.Id);
        Apexpages.currentPage().getParameters().put('tabNext','CommentsAndAttachments');
        ospClass.nextTabName = 'CommentsAndAttachments';
        ospClass.next(); // method 'next' completed here
        
        Apexpages.currentPage().getParameters().put('trialPat',triPat.Id);
        Apexpages.currentPage().getParameters().put('tabNext','Complete'); 
        ospClass.next(); // method 'next' completed here
        
        //=====================method "next" ends here ===========================
        }
     }
  }
      @isTest static void myUnitTest5() {
        // TO DO: implement unit test
        
        Profile SiteProp = [ Select p.UserType, p.Name, (Select u.IsActive, u.Id From Users u where IsActive = true) From Profile p where Name = 'Site User'];
        List<User> lstSiteUser = SiteProp.Users;     
        System.runAs ( lstSiteUser[0] ) { 
        
        Account inst1 = new Account();
        
        List<Account> lstAccount = [Select a.RecordType.Name, a.RecordTypeId, a.Id From Account a where RecordType.Name = 'DCC' or RecordType.Name = 'Institution']; 
        
        if(!lstAccount.isEmpty()){
                
        inst1 = lstAccount[0];                              // newly added logic to overcome the error of "setup and nonsetup" object
        
        Code_Master__c snomedObject = new Code_Master__c();
        snomedObject.Variable_Description__c = 'test';
        snomedObject.IsReportColumn__c = true;
        snomedObject.Display_Order__c = 1.0;
        snomedObject.Name = 'FNA_Br_pretx';
        insert snomedObject;
        
        Code_Master__c snomedObject1 = new Code_Master__c();
        snomedObject1.Variable_Description__c = 'test';
        snomedObject1.IsReportColumn__c = true;
        snomedObject1.Display_Order__c = 1.0;
        snomedObject1.Name = 'CoreNeedle_Br__pretx';
        insert snomedObject1;
        
        Code_Master__c snomedObject2 = new Code_Master__c();
        snomedObject2.Variable_Description__c = 'test';
        snomedObject2.IsReportColumn__c = true;
        snomedObject2.Display_Order__c = 1.0;
        snomedObject2.Name = 'Excisional_Br_pretx';
        insert snomedObject2;
        
        Code_Master__c snomedObject3 = new Code_Master__c();
        snomedObject3.Variable_Description__c = 'test';
        snomedObject3.IsReportColumn__c = true;
        snomedObject3.Display_Order__c = 1.0;
        snomedObject3.Name = 'Surgery_Br';
        insert snomedObject3;
        
        Code_Master__c snomedObject4 = new Code_Master__c();
        snomedObject4.Variable_Description__c = 'test';
        snomedObject4.IsReportColumn__c = true;
        snomedObject4.Display_Order__c = 1.0;
        snomedObject4.Name = 'Excisional_Br_pretx';
        insert snomedObject4;
        
        Code_Master__c snomedObject5 = new Code_Master__c();
        snomedObject5.Variable_Description__c = 'test';
        snomedObject5.IsReportColumn__c = true;
        snomedObject5.Display_Order__c = 1.0;
        snomedObject5.Name = 'CoreNeedle_LN_Pretx';
        insert snomedObject5;
        
        Code_Master__c snomedObject6 = new Code_Master__c();
        snomedObject6.Variable_Description__c = 'test';
        snomedObject6.IsReportColumn__c = true;
        snomedObject6.Display_Order__c = 1.0;
        snomedObject6.Name = 'Bx_SN_Pretx';
        insert snomedObject6;
        
        Code_Master__c snomedObject7 = new Code_Master__c();
        snomedObject7.Variable_Description__c = 'test';
        snomedObject7.IsReportColumn__c = true;
        snomedObject7.Display_Order__c = 1.0;
        snomedObject7.Name = 'NumExLN_PS';
        insert snomedObject7;
        
        Code_Master__c snomedObject8 = new Code_Master__c();
        snomedObject8.Variable_Description__c = 'test';
        snomedObject8.IsReportColumn__c = true;
        snomedObject8.Display_Order__c = 1.0;
        snomedObject8.Name = 'NumPosLN_PS';
        insert snomedObject8;
        
        Patient_Custom__c pc = new Patient_Custom__c();
        pc.First_Name__c = 'test';
        pc.Last_Name__c = 'test1';
        pc.Gender__c = 'Male';
        pc.Birthdate__c = date.newInstance(1986, 8, 9);
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
        
        CRF__c crf = new CRF__c();
        crf.Status__c = 'Accepted';
        crf.Patient__c = pc.Id;
        insert crf;
        
        On_Study_Pathology_Form__c ospObj = new On_Study_Pathology_Form__c();
        ospObj.TrialPatient__c = triPat.Id;
        ospObj.Status__c = 'Accepted';
        ospObj.CRF__c = crf.Id;
        ospObj.Is_DCIS_Present__c='yes';
        ospObj.Is_invasive_tumor_present__c='yes';
        ospObj.Is_LCIS_Present__c='yes';
        ospObj.Does_the_patient_have_bilateral_breast_c__c = 'Yes';
        ospObj.Tumor_laterality__c = 'Left';
        insert ospObj;
          
        ospObj.Status__c = 'Accepted';
        update ospObj;
        
        DCIS__c dcis = new DCIS__c();
        dcis.On_Study_Pathology_Form__c = ospObj.Id;
        dcis.Punctate_necrosis__c = true;
        dcis.Calcifications__c='Yes';
        dcis.Nuclear_Grade__c='Grade I (low)';
        insert dcis; 
        
        LCIS__c lcis = new LCIS__c();
        lcis.On_Study_Pathology_Form__c = ospObj.Id;
        lcis.Histological_Type__c='Classic'; 
        insert lcis; 
        
        Invasive_Tumor_Detail__c itd = new Invasive_Tumor_Detail__c();
        itd.On_Study_Pathology_Form__c = ospObj.Id;
        itd.Invasive_ductal_carcinoma_nos__c=true; 
        itd.Calcifications__c ='yes';
        itd.Nuclear_Grade__c='Grade I (low)'; 
        itd.Mitotic_Count__c = '1pt';
        itd.Tubule_Papilla_formation__c = '1pt';
        itd.Lympatic_vascular_Invasion__c = 'Present';
        itd.Skin_Involvement__c = 'Yes';
        insert itd;
        
        Procedure__c p = new Procedure__c();
        p.On_Study_Pathology_Form__c = ospObj.Id;
        p.TrialPatient__c = triPat.Id;
        p.Form_Name__c = 'On-Study Pathology Form(Positive Breast Biopsies)';
        p.Procedure_Name__c = 'Core biopsy';
        p.Ultrasound__c = true;
        p.Palpation_guided__c = true;
        p.Mammography__c = true;
        p.MRI__c = true;
        p.Stereotactic__c = true;
        insert p;
        
        Procedure__c p1 = new Procedure__c();
        p1.On_Study_Pathology_Form__c = ospObj.Id;
        p1.TrialPatient__c = triPat.Id;
        p1.Form_Name__c = 'On-Study Pathology Form(Lymph Node Biopsies)';
        p1.Procedure_Name__c = 'Core biopsy (lymph node)';
        p1.Ultrasound__c = true;
        p1.Palpation_guided__c = true;
        p1.Mammography__c = true;
        p1.MRI__c = true;
        p1.Stereotactic__c = true;
        insert p1; 
        
        Apexpages.currentPage().getParameters().put('PathologyId',ospObj.Id); 
        ApexPages.StandardController cont = new ApexPages.StandardController(ospObj);
        OnStudyPathology ospClass = new OnStudyPathology(cont);
        
        Apexpages.currentPage().getParameters().put('trialPat',triPat.Id);
        Apexpages.currentPage().getParameters().put('tabNext','saveAndClose');
        ospClass.nextTabName = 'saveAndClose';
        ospClass.next();
        
        ospClass.signAndSubmit();
        ospClass.resendCode();
        //ospClass.cloneCRF();
        ospClass.editCRF(); 
        
        Apexpages.currentPage().getParameters().put('PathologyId',ospObj.Id); // method "customcancel" begins here
        ospClass.customCancel();
        Apexpages.currentPage().getParameters().put('PathologyId',null);
        ospClass.customCancel();
        }
     }
  }
  
  @isTest static void myUnitTest6() {
        // TO DO: implement unit test
        
        Profile SiteProp = [ Select p.UserType, p.Name, (Select u.IsActive, u.Id From Users u where IsActive = true) From Profile p where Name = 'Site User'];
        List<User> lstSiteUser = SiteProp.Users;     
        System.runAs ( lstSiteUser[0] ) { 
        
        Account inst1 = new Account();
        
        List<Account> lstAccount = [Select a.RecordType.Name, a.RecordTypeId, a.Id From Account a where RecordType.Name = 'DCC' or RecordType.Name = 'Institution']; 
        
        if(!lstAccount.isEmpty()){
                
        inst1 = lstAccount[0];                              // newly added logic to overcome the error of "setup and nonsetup" object
        
        Code_Master__c snomedObject = new Code_Master__c();
        snomedObject.Variable_Description__c = 'test';
        snomedObject.IsReportColumn__c = true;
        snomedObject.Display_Order__c = 1.0;
        snomedObject.Name = 'FNA_Br_pretx';
        insert snomedObject;
        
        Code_Master__c snomedObject1 = new Code_Master__c();
        snomedObject1.Variable_Description__c = 'test';
        snomedObject1.IsReportColumn__c = true;
        snomedObject1.Display_Order__c = 1.0;
        snomedObject1.Name = 'CoreNeedle_Br__pretx';
        insert snomedObject1;
        
        Code_Master__c snomedObject2 = new Code_Master__c();
        snomedObject2.Variable_Description__c = 'test';
        snomedObject2.IsReportColumn__c = true;
        snomedObject2.Display_Order__c = 1.0;
        snomedObject2.Name = 'Excisional_Br_pretx';
        insert snomedObject2;
        
        Code_Master__c snomedObject3 = new Code_Master__c();
        snomedObject3.Variable_Description__c = 'test';
        snomedObject3.IsReportColumn__c = true;
        snomedObject3.Display_Order__c = 1.0;
        snomedObject3.Name = 'Surgery_Br';
        insert snomedObject3;
        
        Code_Master__c snomedObject4 = new Code_Master__c();
        snomedObject4.Variable_Description__c = 'test';
        snomedObject4.IsReportColumn__c = true;
        snomedObject4.Display_Order__c = 1.0;
        snomedObject4.Name = 'Excisional_Br_pretx';
        insert snomedObject4;
        
        Code_Master__c snomedObject5 = new Code_Master__c();
        snomedObject5.Variable_Description__c = 'test';
        snomedObject5.IsReportColumn__c = true;
        snomedObject5.Display_Order__c = 1.0;
        snomedObject5.Name = 'CoreNeedle_LN_Pretx';
        insert snomedObject5;
        
        Code_Master__c snomedObject6 = new Code_Master__c();
        snomedObject6.Variable_Description__c = 'test';
        snomedObject6.IsReportColumn__c = true;
        snomedObject6.Display_Order__c = 1.0;
        snomedObject6.Name = 'Bx_SN_Pretx';
        insert snomedObject6;
        
        Code_Master__c snomedObject7 = new Code_Master__c();
        snomedObject7.Variable_Description__c = 'test';
        snomedObject7.IsReportColumn__c = true;
        snomedObject7.Display_Order__c = 1.0;
        snomedObject7.Name = 'NumExLN_PS';
        insert snomedObject7;
        
        Code_Master__c snomedObject8 = new Code_Master__c();
        snomedObject8.Variable_Description__c = 'test';
        snomedObject8.IsReportColumn__c = true;
        snomedObject8.Display_Order__c = 1.0;
        snomedObject8.Name = 'NumPosLN_PS';
        insert snomedObject8;
        
        Patient_Custom__c pc = new Patient_Custom__c();
        pc.First_Name__c = 'test';
        pc.Last_Name__c = 'test1';
        pc.Gender__c = 'Male';
        pc.Birthdate__c = date.newInstance(1986, 8, 9);
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
        
        CRF__c crf = new CRF__c();
        crf.Status__c = 'Accepted';
        crf.Patient__c = pc.Id;
        insert crf;
        
        On_Study_Pathology_Form__c ospObj = new On_Study_Pathology_Form__c();
        ospObj.TrialPatient__c = triPat.Id;
        ospObj.Status__c = 'Accepted';
        ospObj.CRF__c = crf.Id;
        ospObj.Is_DCIS_Present__c='yes';
        ospObj.Is_invasive_tumor_present__c='yes';
        ospObj.Is_LCIS_Present__c='yes';
        ospObj.Does_the_patient_have_bilateral_breast_c__c = 'Yes';
        ospObj.Tumor_laterality__c = 'Left';
        insert ospObj;
          
        ospObj.Status__c = 'Accepted';
        update ospObj;
        
        DCIS__c dcis = new DCIS__c();
        dcis.On_Study_Pathology_Form__c = ospObj.Id;
        dcis.Punctate_necrosis__c = true;
        dcis.Calcifications__c='Yes';
        dcis.Nuclear_Grade__c='Grade I (low)';
        insert dcis; 
        
        LCIS__c lcis = new LCIS__c();
        lcis.On_Study_Pathology_Form__c = ospObj.Id;
        lcis.Histological_Type__c='Classic'; 
        insert lcis; 
        
        Invasive_Tumor_Detail__c itd = new Invasive_Tumor_Detail__c();
        itd.On_Study_Pathology_Form__c = ospObj.Id;
        itd.Invasive_ductal_carcinoma_nos__c=true; 
        itd.Calcifications__c ='yes';
        itd.Nuclear_Grade__c='Grade I (low)'; 
        itd.Mitotic_Count__c = '1pt';
        itd.Tubule_Papilla_formation__c = '1pt';
        itd.Lympatic_vascular_Invasion__c = 'Present';
        itd.Skin_Involvement__c = 'Yes';
        insert itd;
        
        Procedure__c p = new Procedure__c();
        p.On_Study_Pathology_Form__c = ospObj.Id;
        p.TrialPatient__c = triPat.Id;
        p.Form_Name__c = 'On-Study Pathology Form(Positive Breast Biopsies)';
        p.Procedure_Name__c = 'Core biopsy';
        p.Ultrasound__c = true;
        p.Palpation_guided__c = true;
        p.Mammography__c = true;
        p.MRI__c = true;
        p.Stereotactic__c = true;
        insert p;
        
        Procedure__c p1 = new Procedure__c();
        p1.On_Study_Pathology_Form__c = ospObj.Id;
        p1.TrialPatient__c = triPat.Id;
        p1.Form_Name__c = 'On-Study Pathology Form(Lymph Node Biopsies)';
        p1.Procedure_Name__c = 'Core biopsy (lymph node)';
        p1.Ultrasound__c = true;
        p1.Palpation_guided__c = true;
        p1.Mammography__c = true;
        p1.MRI__c = true;
        p1.Stereotactic__c = true;
        insert p1; 
        
        Apexpages.currentPage().getParameters().put('PathologyId',ospObj.Id); 
        ApexPages.StandardController cont = new ApexPages.StandardController(ospObj);
        OnStudyPathology ospClass = new OnStudyPathology(cont);
        
        Apexpages.currentPage().getParameters().put('trialPat',triPat.Id);
        Apexpages.currentPage().getParameters().put('tabNext','saveAndClose');
       //   ospClass.cloneCRF();
        }
     }
  }
}