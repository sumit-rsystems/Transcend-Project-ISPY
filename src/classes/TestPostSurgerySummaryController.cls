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
private class TestPostSurgerySummaryController {

    @isTest static void myUnitTest() {
        // TO DO: implement unit test
        
        List<RecordType> recordT = [Select r.Name, r.Id From RecordType r where sObjectType='Contact' and Name='Doctor'];
        
        List<User> lstSiteUser = [Select u.IsActive, u.Id, SecurityCode__c From User u where IsActive = true and Profile.Name = 'System Administrator'];     
        System.runAs ( lstSiteUser[0] ) { 
            
        Account inst1 = new Account();

        List<Account> lstAccount = [select Id from Account where RecordType.Name = 'Institution']; 
            
        if(!lstAccount.isEmpty()){
                
        inst1 = lstAccount[0];           // newly added logic to overcome the error of "setup and nonsetup" object
        
        Site__c s = new Site__c();
        s.Institute__c = inst1.Id;
        insert s;
        
        Code_Master__c snomedObject = new Code_Master__c();
        snomedObject.Variable_Description__c = 'test';
        snomedObject.IsReportColumn__c = true;
        snomedObject.Display_Order__c = 1.0;
        snomedObject.Name = 'ERstatus_PS';
        insert snomedObject;
        
        Code_Master__c snomedObject1 = new Code_Master__c();
        snomedObject1.Variable_Description__c = 'test';
        snomedObject1.IsReportColumn__c = true;
        snomedObject1.Display_Order__c = 1.0;
        snomedObject1.Name = 'Surgery_Br';
        insert snomedObject1;
        
        Code_Master__c snomedObject2 = new Code_Master__c();
        snomedObject2.Variable_Description__c = 'test';
        snomedObject2.IsReportColumn__c = true;
        snomedObject2.Display_Order__c = 1.0;
        snomedObject2.Name = 'NumPosLN_PS';
        insert snomedObject2;
        
        Code_Master__c snomedObject3 = new Code_Master__c();
        snomedObject3.Variable_Description__c = 'test';
        snomedObject3.IsReportColumn__c = true;
        snomedObject3.Display_Order__c = 1.0;
        snomedObject3.Name = 'NumExLN_PS';
        insert snomedObject3;
        
        Code_Master__c snomedObject4 = new Code_Master__c();
        snomedObject4.Variable_Description__c = 'test';
        snomedObject4.IsReportColumn__c = true;
        snomedObject4.Display_Order__c = 1.0;
        snomedObject4.Name = 'ERstatus_OS';
        insert snomedObject4;
        
        Code_Master__c snomedObject5 = new Code_Master__c();
        snomedObject5.Variable_Description__c = 'test';
        snomedObject5.IsReportColumn__c = true;
        snomedObject5.Display_Order__c = 1.0;
        snomedObject5.Name = 'PRstatus_PS';
        insert snomedObject5;
        
        Code_Master__c snomedObject6 = new Code_Master__c();
        snomedObject6.Variable_Description__c = 'test';
        snomedObject6.IsReportColumn__c = true;
        snomedObject6.Display_Order__c = 1.0;
        snomedObject6.Name = 'ER_TS_OS';
        insert snomedObject6;
        
        Code_Master__c snomedObject7 = new Code_Master__c();
        snomedObject7.Variable_Description__c = 'test';
        snomedObject7.IsReportColumn__c = true;
        snomedObject7.Display_Order__c = 1.0;
        snomedObject7.Name = 'PgR_TS_OS';
        insert snomedObject7;
        
        Code_Master__c snomedObject8 = new Code_Master__c();
        snomedObject8.Variable_Description__c = 'test';
        snomedObject8.IsReportColumn__c = true;
        snomedObject8.Display_Order__c = 1.0;
        snomedObject8.Name = 'Her2IHCstatus_OS';
        insert snomedObject8;
        
        Code_Master__c snomedObject9 = new Code_Master__c();
        snomedObject9.Variable_Description__c = 'test';
        snomedObject9.IsReportColumn__c = true;
        snomedObject9.Display_Order__c = 1.0;
        snomedObject9.Name = 'Her2FISHstatus_OS';
        insert snomedObject9;
        
        Code_Master__c snomedObject10 = new Code_Master__c();
        snomedObject10.Variable_Description__c = 'test';
        snomedObject10.IsReportColumn__c = true;
        snomedObject10.Display_Order__c = 1.0;
        snomedObject10.Name = 'Her2IHCtest_OS';
        insert snomedObject10;
        
        Code_Master__c snomedObject11 = new Code_Master__c();
        snomedObject11.Variable_Description__c = 'test';
        snomedObject11.IsReportColumn__c = true;
        snomedObject11.Display_Order__c = 1.0;
        snomedObject11.Name = 'Her2FISHtest_OS';
        insert snomedObject11;
        
        Code_Master__c snomedObject12 = new Code_Master__c();
        snomedObject12.Variable_Description__c = 'test';
        snomedObject12.IsReportColumn__c = true;
        snomedObject12.Display_Order__c = 1.0;
        snomedObject12.Name = 'PRstatus_OS';
        insert snomedObject12;
        
        Contact con = new Contact();
        con.AccountId = inst1.Id;
        con.LastName = 'test';
        con.Site__c = s.Id;
        con.Type__c = 'Surgeon';
        con.RecordTypeId = recordT[0].Id;
        insert con;
        
        Patient_Custom__c p = new Patient_Custom__c();
        p.Birthdate__c = date.newInstance(1950, 08, 05);
        p.Institution__c = inst1.Id;
        p.Last_Name__c = 'test'; 
        p.Gender__c = 'Male';
        p.Race__c = 'White';
        p.Ethnicity__c = 'Not Hispanic or Latino';
        insert p;
        
        TrialPatient__c tp = new TrialPatient__c();
        tp.Patient_Id__c = p.Id;
        insert tp;
        
        InstitutionUser__c ins = new InstitutionUser__c();
        ins.Site__c = s.Id;
        ins.User__c = userinfo.getUserId();
        ins.Institution__c = inst1.Id;
        insert ins; 
        
        Post_Surgaory_Summary__c pss = new Post_Surgaory_Summary__c();
        pss.TrialPatient__c = tp.Id;
        pss.Surgeon__c = con.Id;
        pss.Date_Of_Procedure__c = date.newInstance(2012, 7, 7);
        pss.Type_Of_Tumor__c = 'Single Discrete Mass';
        pss.Status__c = 'Not Completed';
        insert pss;
        
        pss.Status__c = 'Accepted';
        update pss;
        
        Procedure__c pro = new Procedure__c();
        pro.TrialPatient__c = tp.Id;
        pro.Post_Surgery_Summary__c = pss.Id;
        pro.Laterality__c = 'Right';
        pro.Date_Of_Procedure__c = pss.Date_Of_Procedure__c;
        pro.Form_Name__c = 'Post Surgery Summary Form';
        pro.Procedure_Name__c = 'Sentinel lymph node dissection';
        insert pro;
        
        Lymph_Nodes__c lm = new Lymph_Nodes__c();
        lm.Positive__c = 2.0;
        lm.Examined__c = 3.0;
        lm.Procedure__c = pro.Id;
        lm.Node_Checkbox_Value__c = 'Sentinel Nodes';
        insert lm; 
        
        Procedure_Specimen_Detail__c psd = new Procedure_Specimen_Detail__c();
        psd.Specimen__c = 'Main specimen with separately submitted margins';
        psd.Procedure__c = pro.Id;
        insert psd; 
        
        Apexpages.currentPage().getParameters().put('trialPat',tp.Id);  // if part till next 3 lines
        Apexpages.currentPage().getParameters().put('postid',pss.Id);
        ApexPages.StandardController controller = new ApexPages.StandardController(pss);
        PostSurgerySummaryController postObject = new PostSurgerySummaryController(controller);
        
        ComponentControllerBase ccb = new ComponentControllerBase(); // VIRTUAL CLASS "ComponentControllerBase"
        ccb.key = '1';
        
        PageControllerBase pcb = new PageControllerBase(); // VIRTUAL CLASS "PageControllerBase" BEGINS HERE
        
        postObject.callDcisControllerMethod(pss.Id);
        postObject.callLcisControllerMethod(pss.Id);
        postObject.callIvtControllerMethod(pss.Id);
        //postObject.callReceptorsControllerMethodRight(pss.Id);
        postObject.callReceptorsControllerMethodLeft(pss.Id);
        //postObject.callStagingControllerMethodRight(pss.Id);
        postObject.callStagingControllerMethodLeft(pss.Id);
        
        //=============to satisfy "else if" condition , line 265 =======================================
        
        Procedure_Specimen_Detail__c psd1 = new Procedure_Specimen_Detail__c();
        psd1.Specimen__c = 'Single Specimen';
        psd1.Procedure__c = pro.Id;
        insert psd1;
        
        Apexpages.currentPage().getParameters().put('trialPat',tp.Id);  // if part till next 3 lines
        Apexpages.currentPage().getParameters().put('postid',pss.Id);
        ApexPages.StandardController controller1 = new ApexPages.StandardController(pss);
        PostSurgerySummaryController postObject1 = new PostSurgerySummaryController(controller1);
        
        //============finished satisfying "else if" condition , line 265 ==============================
        
        // ====== method "saveCrf()" begins here ======================================================
        
        postObject.saveCrf(); // line 361 
        Apexpages.currentPage().getParameters().put('postid',null); // line 344 ,352 since "postid=null"
        postObject.saveCrf();
        
        Apexpages.currentPage().getParameters().put('postid',null); // give it "null" so that it will go inside "if"cond line 344 and then satisfy "if" cond line 346
        Apexpages.currentPage().getParameters().put('id',pss.Id); // line 346 , since "postid!=null"
        postObject.saveCrf();
        
        //======== method "saveCrf()" ends here ======================================================
        
        //======== method "next()" begins here =======================================================
        
         Apexpages.currentPage().getParameters().put('nextTab','CompleteTab');
         postObject.next();
         
         Apexpages.currentPage().getParameters().put('nextTab','procedureTab');
         postObject.currentTab = 'procedureTab';
         postObject.next();
         
        //======== method "next()" ends here ======================================================= 
        
        //======== method "previous()" begins here =================================================
        
        Apexpages.currentPage().getParameters().put('prevTab','CompleteTab');
        postObject.previous();
        
        //======== method "previous()" ends here =================================================
        
         //postObject.signAndSubmit();
         postObject.showTumorOption();
        }
    }
 }
        @isTest static void myUnitTest1() {
        // TO DO: implement unit test
        
        List<RecordType> recordT = [Select r.Name, r.Id From RecordType r where sObjectType='Contact' and Name='Doctor'];
        
        List<User> lstSiteUser = [Select u.IsActive, u.Id, SecurityCode__c From User u where IsActive = true and Profile.Name = 'System Administrator'];     
        System.runAs ( lstSiteUser[0] ) { 
            
        Account inst1 = new Account();

        List<Account> lstAccount = [select Id from Account where RecordType.Name = 'Institution']; 
            
        if(!lstAccount.isEmpty()){
                
        inst1 = lstAccount[0];           // newly added logic to overcome the error of "setup and nonsetup" object
        
        Site__c s = new Site__c();
        s.Institute__c = inst1.Id;
        insert s;
        
        Contact con = new Contact();
        con.AccountId = inst1.Id;
        con.LastName = 'test';
        con.Site__c = s.Id;
        con.Type__c = 'Surgeon';
        con.RecordTypeId = recordT[0].Id;
        insert con;
        
        Patient_Custom__c p = new Patient_Custom__c();
        p.Birthdate__c = date.newInstance(1950, 08, 05);
        p.Institution__c = inst1.Id;
        p.Last_Name__c = 'test'; 
        p.Gender__c = 'Male';
        p.Race__c = 'White';
        p.Ethnicity__c = 'Not Hispanic or Latino';
        insert p;
        
        TrialPatient__c tp = new TrialPatient__c();
        tp.Patient_Id__c = p.Id;
        insert tp;
        
        InstitutionUser__c ins = new InstitutionUser__c();
        ins.Site__c = s.Id;
        ins.User__c = userinfo.getUserId();
        ins.Institution__c = inst1.Id;
        insert ins;
        
        Post_Surgaory_Summary__c pss = new Post_Surgaory_Summary__c();
        pss.TrialPatient__c = tp.Id;
        pss.Surgeon__c = con.Id;
        pss.Date_Of_Procedure__c = date.newInstance(2012, 7, 7);
        pss.Type_Of_Tumor__c = 'Single Discrete Mass';
        pss.Status__c = 'Not Completed';
        insert pss;
        
        Procedure__c pro = new Procedure__c();
        pro.TrialPatient__c = tp.Id;
        pro.Post_Surgery_Summary__c = pss.Id;
        pro.Laterality__c = 'Right';
        pro.Date_Of_Procedure__c = pss.Date_Of_Procedure__c;
        pro.Form_Name__c = 'Post Surgery Summary Form';
        pro.Procedure_Name__c = 'Sentinel lymph node dissection';
        insert pro;
        
        Lymph_Nodes__c lm = new Lymph_Nodes__c();
        lm.Positive__c = 2.0;
        lm.Examined__c = 3.0;
        lm.Procedure__c = pro.Id;
        lm.Node_Checkbox_Value__c = 'Sentinel Nodes';
        insert lm;
        
        Procedure_Specimen_Detail__c psd = new Procedure_Specimen_Detail__c();
        psd.Specimen__c = 'Main specimen with separately submitted margins';
        psd.Procedure__c = pro.Id;
        insert psd;
        
        Apexpages.currentPage().getParameters().put('trialPat',tp.Id);  // if part till next 3 lines
        Apexpages.currentPage().getParameters().put('postid',pss.Id);
        ApexPages.StandardController controller = new ApexPages.StandardController(pss);
        PostSurgerySummaryController postObject = new PostSurgerySummaryController(controller);
        
        ComponentControllerBase ccb = new ComponentControllerBase(); // VIRTUAL CLASS "ComponentControllerBase"
        ccb.key = '1';
        
        PageControllerBase pcb = new PageControllerBase(); // VIRTUAL CLASS "PageControllerBase" BEGINS HERE
        
        postObject.callReceptorsControllerMethodRight(pss.Id);
        postObject.callStagingControllerMethodRight(pss.Id);
        
        //=============to satisfy "else if" condition , line 265 =======================================
        
        Procedure_Specimen_Detail__c psd1 = new Procedure_Specimen_Detail__c();
        psd1.Specimen__c = 'Single Specimen';
        psd1.Procedure__c = pro.Id;
        insert psd1;
        
        Apexpages.currentPage().getParameters().put('trialPat',tp.Id);  // if part till next 3 lines
        Apexpages.currentPage().getParameters().put('postid',pss.Id);
        ApexPages.StandardController controller1 = new ApexPages.StandardController(pss);
        PostSurgerySummaryController postObject1 = new PostSurgerySummaryController(controller1);
        
        //============finished satisfying "else if" condition , line 265 ==============================
        
        // ====== method "saveCrf()" begins here ======================================================
        
        Apexpages.currentPage().getParameters().put('postid',null); // line 344 ,352 since "postid=null"
        postObject.saveCrf();
        
        Apexpages.currentPage().getParameters().put('postid',null); // give it "null" so that it will go inside "if"cond line 344 and then satisfy "if" cond line 346
        Apexpages.currentPage().getParameters().put('id',pss.Id); // line 346 , since "postid!=null"
        postObject.saveCrf();
        
        //======== method "saveCrf()" ends here ======================================================
        
        //======== method "next()" begins here =======================================================
         
         Apexpages.currentPage().getParameters().put('nextTab','procedureTab');
         postObject.currentTab = 'procedureTab';
         postObject.next();
         
        //======== method "next()" ends here ======================================================= 
        
        //======== method "previous()" begins here =================================================
        
        Apexpages.currentPage().getParameters().put('prevTab','CompleteTab');
        postObject.previous();
        
        //======== method "previous()" ends here =================================================
        
         postObject.signAndSubmit();
        }
      }
     }
        @isTest static void myUnitTest2() { // to satisfy flag = 0 , line 287 , by not specifying "Procedure_Specimen_Detail__c"
        // TO DO: implement unit test
        List<RecordType> recordT = [Select r.Name, r.Id From RecordType r where sObjectType='Contact' and Name='Doctor'];
        List<User> lstSiteUser = [Select u.IsActive, u.Id, SecurityCode__c From User u where IsActive = true and Profile.Name = 'System Administrator'];     
        System.runAs ( lstSiteUser[0] ) { 
            
        Account inst1 = new Account();

        List<Account> lstAccount = [select Id from Account where RecordType.Name = 'Institution']; 
            
        if(!lstAccount.isEmpty()){
                
        inst1 = lstAccount[0];           // newly added logic to overcome the error of "setup and nonsetup" object
        
        Site__c s = new Site__c();
        s.Institute__c = inst1.Id;
        insert s;
        
        Code_Master__c snomedObject1 = new Code_Master__c();
        snomedObject1.Variable_Description__c = 'test';
        snomedObject1.IsReportColumn__c = true;
        snomedObject1.Display_Order__c = 1.0;
        snomedObject1.Name = 'Surgery_Br';
        insert snomedObject1;
        
        Code_Master__c snomedObject2 = new Code_Master__c();
        snomedObject2.Variable_Description__c = 'test';
        snomedObject2.IsReportColumn__c = true;
        snomedObject2.Display_Order__c = 1.0;
        snomedObject2.Name = 'NumPosLN_PS';
        insert snomedObject2;
        
        Code_Master__c snomedObject3 = new Code_Master__c();
        snomedObject3.Variable_Description__c = 'test';
        snomedObject3.IsReportColumn__c = true;
        snomedObject3.Display_Order__c = 1.0;
        snomedObject3.Name = 'NumExLN_PS';
        insert snomedObject3;
        
        Contact con = new Contact();
        con.AccountId = inst1.Id;
        con.LastName = 'test';
        con.Site__c = s.Id;
        con.Type__c = 'Surgeon';
        con.RecordTypeId = recordT[0].Id;
        insert con;
        
        Patient_Custom__c p = new Patient_Custom__c();
        p.Birthdate__c = date.newInstance(1950, 08, 05);
        p.Institution__c = inst1.Id;
        p.Last_Name__c = 'test'; 
        p.Gender__c = 'Male';
        p.Race__c = 'White';
        p.Ethnicity__c = 'Not Hispanic or Latino';
        insert p;
        
        TrialPatient__c tp = new TrialPatient__c();
        tp.Patient_Id__c = p.Id;
        insert tp;
        
        InstitutionUser__c ins = new InstitutionUser__c();
        ins.Site__c = s.Id;
        ins.User__c = userinfo.getUserId();
        ins.Institution__c = inst1.Id;
        insert ins;
        
        Post_Surgaory_Summary__c pss = new Post_Surgaory_Summary__c();
        pss.TrialPatient__c = tp.Id;
        pss.Surgeon__c = con.Id;
        pss.Date_Of_Procedure__c = date.newInstance(2012, 7, 7);
        pss.Type_Of_Tumor__c = 'Multifocal Discrete Masses';    // else if condition line 940
        pss.Status__c = 'Not Completed';
        pss.Lymph_node_dissection_done__c = 'Yes';
        insert pss;
        
        pss.Status__c = 'Accepted';
        update pss;
        
        Procedure__c pro = new Procedure__c();
        pro.TrialPatient__c = tp.Id;
        pro.Post_Surgery_Summary__c = pss.Id;
        pro.Laterality__c = 'Left';
        pro.Date_Of_Procedure__c = pss.Date_Of_Procedure__c;
        insert pro;
        
        Apexpages.currentPage().getParameters().put('trialPat',tp.Id);  
        Apexpages.currentPage().getParameters().put('postid',pss.Id);
        ApexPages.StandardController controller = new ApexPages.StandardController(pss);
        PostSurgerySummaryController postObject = new PostSurgerySummaryController(controller);
        
        // ====== method "next" begins here ==================================================
        
        Apexpages.currentPage().getParameters().put('nextTab','specimensTab');
        postObject.postSurObj = pss;
        postObject.ProcedureIds = pro.Id;
        postObject.currentTab = 'specimensTab';
        postObject.next();
        
        Apexpages.currentPage().getParameters().put('nextTab','saveAndClose');
        postObject.next();
        
        //======= method "next" ends here =====================================================
        
        postObject.showTumorOption(); // else if condition line 940
        
        }
      }
     }
     
     @isTest static void myUnitTest3() { // to satisfy flag = 0 , line 287 , by not specifying "Procedure_Specimen_Detail__c"
        // TO DO: implement unit test
        List<RecordType> recordT = [Select r.Name, r.Id From RecordType r where sObjectType='Contact' and Name='Doctor'];
        List<User> lstSiteUser = [Select u.IsActive, u.Id, SecurityCode__c From User u where IsActive = true and Profile.Name = 'System Administrator'];     
        System.runAs ( lstSiteUser[0] ) { 
            
        Account inst1 = new Account();

        List<Account> lstAccount = [select Id from Account where RecordType.Name = 'Institution']; 
            
        if(!lstAccount.isEmpty()){
                
        inst1 = lstAccount[0];           // newly added logic to overcome the error of "setup and nonsetup" object
        
        Site__c s = new Site__c();
        s.Institute__c = inst1.Id;
        insert s;
        
        Code_Master__c snomedObject1 = new Code_Master__c();
        snomedObject1.Variable_Description__c = 'test';
        snomedObject1.IsReportColumn__c = true;
        snomedObject1.Display_Order__c = 1.0;
        snomedObject1.Name = 'Surgery_Br';
        insert snomedObject1;
        
        Code_Master__c snomedObject2 = new Code_Master__c();
        snomedObject2.Variable_Description__c = 'test';
        snomedObject2.IsReportColumn__c = true;
        snomedObject2.Display_Order__c = 1.0;
        snomedObject2.Name = 'NumPosLN_PS';
        insert snomedObject2;
        
        Code_Master__c snomedObject3 = new Code_Master__c();
        snomedObject3.Variable_Description__c = 'test';
        snomedObject3.IsReportColumn__c = true;
        snomedObject3.Display_Order__c = 1.0;
        snomedObject3.Name = 'NumExLN_PS';
        insert snomedObject3;
        
        Contact con = new Contact();
        con.AccountId = inst1.Id;
        con.LastName = 'test';
        con.Site__c = s.Id;
        con.Type__c = 'Surgeon';
        con.RecordTypeId = recordT[0].Id;
        insert con;
        
        Patient_Custom__c p = new Patient_Custom__c();
        p.Birthdate__c = date.newInstance(1950, 08, 05);
        p.Institution__c = inst1.Id;
        p.Last_Name__c = 'test'; 
        p.Gender__c = 'Male';
        p.Race__c = 'White';
        p.Ethnicity__c = 'Not Hispanic or Latino';
        insert p;
        
        TrialPatient__c tp = new TrialPatient__c();
        tp.Patient_Id__c = p.Id;
        insert tp;
        
        InstitutionUser__c ins = new InstitutionUser__c();
        ins.Site__c = s.Id;
        ins.User__c = userinfo.getUserId();
        ins.Institution__c = inst1.Id;
        insert ins;
        
        // ====== to satisfy "else" condition , line 269.
        
        Post_Surgaory_Summary__c pss1 = new Post_Surgaory_Summary__c();
        pss1.TrialPatient__c = tp.Id;
        pss1.Surgeon__c = con.Id;
        pss1.Date_Of_Procedure__c = date.newInstance(2012, 7, 7);
        pss1.Type_Of_Tumor__c = 'Gross Stromal Alterations/Fibrosis'; // else if condition line 945
        pss1.Status__c = 'Not Completed';
        insert pss1;
        
        pss1.Status__c = 'Accepted';
        update pss1;
        
        Procedure__c pro = new Procedure__c();
        pro.TrialPatient__c = tp.Id;
        pro.Post_Surgery_Summary__c = pss1.Id;
        pro.Laterality__c = 'Left';
        pro.Date_Of_Procedure__c = pss1.Date_Of_Procedure__c;
        insert pro;
        
        Procedure_Specimen_Detail__c psd = new Procedure_Specimen_Detail__c();
        psd.Procedure__c = pro.Id;
        insert psd;
        
        Apexpages.currentPage().getParameters().put('trialPat',tp.Id);  
        Apexpages.currentPage().getParameters().put('postid',pss1.Id);
        ApexPages.StandardController controller1 = new ApexPages.StandardController(pss1);
        PostSurgerySummaryController postObject1 = new PostSurgerySummaryController(controller1);    
        
        //============finished satisfying "else" condition , line 269.   
        
        // ====== method "next" begins here ==================================================
        
        Apexpages.currentPage().getParameters().put('nextTab','marginTab');
        postObject1.currentTab = 'marginTab';
        postObject1.next();
        
        Apexpages.currentPage().getParameters().put('nextTab','rcbTab'); // we can use this rcbtab in another new method 
        postObject1.currentTab = 'rcbTab';
        postObject1.next();
        
        // ====== method "next" ends here ==================================================
         
        postObject1.showTumorOption(); // else if condition line 945
        }
      }
     }
        @isTest static void myUnitTest4() { // 
        // TO DO: implement unit test
        List<RecordType> recordT = [Select r.Name, r.Id From RecordType r where sObjectType='Contact' and Name='Doctor'];
        List<User> lstSiteUser = [Select u.IsActive, u.Id, SecurityCode__c From User u where IsActive = true and Profile.Name = 'System Administrator'];     
        System.runAs ( lstSiteUser[0] ) { 
            
        Account inst1 = new Account();

        List<Account> lstAccount = [select Id from Account where RecordType.Name = 'Institution']; 
            
        if(!lstAccount.isEmpty()){
                
        inst1 = lstAccount[0];           // newly added logic to overcome the error of "setup and nonsetup" object
        
        Site__c s = new Site__c();
        s.Institute__c = inst1.Id;
        insert s;
        
        Contact con = new Contact();
        con.AccountId = inst1.Id;
        con.LastName = 'test';
        con.Site__c = s.Id;
        con.Type__c = 'Surgeon';
        con.RecordTypeId = recordT[0].Id;
        insert con;
        
        Patient_Custom__c p = new Patient_Custom__c();
        p.Birthdate__c = date.newInstance(1950, 08, 05);
        p.Institution__c = inst1.Id;
        p.Last_Name__c = 'test'; 
        p.Gender__c = 'Male';
        p.Race__c = 'White';
        p.Ethnicity__c = 'Not Hispanic or Latino';
        insert p;
        
        TrialPatient__c tp = new TrialPatient__c();
        tp.Patient_Id__c = p.Id;
        insert tp;
        
        InstitutionUser__c ins = new InstitutionUser__c();
        ins.Site__c = s.Id;
        ins.User__c = userinfo.getUserId();
        ins.Institution__c = inst1.Id;
        insert ins;
        
        Post_Surgaory_Summary__c pss = new Post_Surgaory_Summary__c();
        pss.TrialPatient__c = tp.Id;
        pss.Surgeon__c = con.Id;
        pss.Date_Of_Procedure__c = date.newInstance(2012, 7, 7);
        pss.Status__c = 'Not Completed';
        pss.Lymph_node_dissection_done__c = 'Yes';
        insert pss;
        
        pss.Status__c = 'Accepted';
        update pss;
        
        Procedure__c pro = new Procedure__c();
        pro.TrialPatient__c = tp.Id;
        pro.Post_Surgery_Summary__c = pss.Id;
        pro.Laterality__c = 'Left';
        pro.Date_Of_Procedure__c = pss.Date_Of_Procedure__c;
        insert pro;
        
        Apexpages.currentPage().getParameters().put('trialPat',tp.Id);  
        Apexpages.currentPage().getParameters().put('postid',pss.Id);
        ApexPages.StandardController controller = new ApexPages.StandardController(pss);
        PostSurgerySummaryController postObject = new PostSurgerySummaryController(controller);
        
        //======= method "next" begins here ===================================================
        
        Apexpages.currentPage().getParameters().put('nextTab','stagingTab'); 
        postObject.currentTab = 'stagingTab';
        postObject.next();
        
        Apexpages.currentPage().getParameters().put('nextTab','histologyTab');
        postObject.currentTab = 'histologyTab';
        postObject.isCalci = 'Yes';
        postObject.isDCIS = 'Yes';
        postObject.isInasive = 'Yes';
        postObject.isLCIS = 'Yes';
        postObject.next();
        //======= method "next" ends here ===================================================
        
        postObject.showTumorOption();
        
        postObject.resendCode();
        
        //======= method "addSpecimen()" begins here ======================================
        
        Apexpages.currentPage().getParameters().put('procedureId',pro.Id);
        postObject.addSpecimen();
        
        //======= method "addSpecimen()" ends here ======================================
        
        //======= method "removeSpecimen()" begins here ======================================
        
        Apexpages.currentPage().getParameters().put('serial','2'); 
        Apexpages.currentPage().getParameters().put('procedureId',pro.Id);
        postObject.removeSpecimen();
        
        //======= method "removeSpecimen()" ends here ======================================
        
        postObject.showProcedure(); 
        postObject.editCRF();
        postObject.customCancel(); 
        }
   }
 }
    @isTest static void myUnitTest5() {  // to satisfy "next" method for "rcbTab"
        // TO DO: implement unit test
        List<RecordType> recordT = [Select r.Name, r.Id From RecordType r where sObjectType='Contact' and Name='Doctor'];
        List<User> lstSiteUser = [Select u.IsActive, u.Id, SecurityCode__c From User u where IsActive = true and Profile.Name = 'System Administrator'];     
        System.runAs ( lstSiteUser[0] ) { 
            
        Account inst1 = new Account();

        List<Account> lstAccount = [select Id from Account where RecordType.Name = 'Institution']; 
            
        if(!lstAccount.isEmpty()){
                
        inst1 = lstAccount[0];           // newly added logic to overcome the error of "setup and nonsetup" object
        
        Site__c s = new Site__c();
        s.Institute__c = inst1.Id;
        insert s;
        
        Code_Master__c snomedObject1 = new Code_Master__c();
        snomedObject1.Variable_Description__c = 'test';
        snomedObject1.IsReportColumn__c = true;
        snomedObject1.Display_Order__c = 1.0;
        snomedObject1.Name = 'Surgery_Br';
        insert snomedObject1;
        
        Code_Master__c snomedObject2 = new Code_Master__c();
        snomedObject2.Variable_Description__c = 'test';
        snomedObject2.IsReportColumn__c = true;
        snomedObject2.Display_Order__c = 1.0;
        snomedObject2.Name = 'NumPosLN_PS';
        insert snomedObject2;
        
        Code_Master__c snomedObject3 = new Code_Master__c();
        snomedObject3.Variable_Description__c = 'test';
        snomedObject3.IsReportColumn__c = true;
        snomedObject3.Display_Order__c = 1.0;
        snomedObject3.Name = 'NumExLN_PS';
        insert snomedObject3;
        
        Contact con = new Contact();
        con.AccountId = inst1.Id;
        con.LastName = 'test';
        con.Site__c = s.Id;
        con.Type__c = 'Surgeon';
        con.RecordTypeId = recordT[0].Id;
        insert con;
        
        Patient_Custom__c p = new Patient_Custom__c();
        p.Birthdate__c = date.newInstance(1950, 08, 05);
        p.Institution__c = inst1.Id;
        p.Last_Name__c = 'test'; 
        p.Gender__c = 'Male';
        p.Race__c = 'White';
        p.Ethnicity__c = 'Not Hispanic or Latino';
        insert p;
        
        TrialPatient__c tp = new TrialPatient__c();
        tp.Patient_Id__c = p.Id;
        insert tp;
        
        InstitutionUser__c ins = new InstitutionUser__c();
        ins.Site__c = s.Id;
        ins.User__c = userinfo.getUserId();
        ins.Institution__c = inst1.Id;
        insert ins;
        
        Post_Surgaory_Summary__c pss = new Post_Surgaory_Summary__c();
        pss.TrialPatient__c = tp.Id;
        pss.Surgeon__c = con.Id;
        pss.Date_Of_Procedure__c = date.newInstance(2012, 7, 7);
        pss.Status__c = 'Not Completed';
        pss.Is_invasive_tumor_present__c = 'No';
        pss.Type_Of_Tumor__c = 'Single Discrete Mass';
        pss.Gross_Mass_Measurement_Unit__c = 'MM';
        pss.Total_Span_Measurement_Unit__c = 'MM';
        pss.Is_DCIS_Present__c = 'Yes';
        pss.Is_LCIS_Present__c = 'Yes';
        pss.Lymph_node_dissection_done__c = 'Yes';
        pss.Size_of_Gross_Mass_Width__c = 23.0;
        pss.Size_of_Gross_Mass_Height__c = 32.0;
        pss.Total_span_multifocal_gross_mass_width__c = 32.0;
        pss.Total_span_multifocal_gross_mass_height__c = 33.0;
        pss.Span_of_gross_changes_width__c = 23.0;
        pss.Span_of_gross_changes_height__c = 25.0;
        insert pss;
        
        Invasive_Tumor_Detail__c itd = new Invasive_Tumor_Detail__c();
        itd.Post_Surgery_Summary__c = pss.Id;
        itd.Tumor_Measurement_Unit__c = 'MM';
        itd.Tumor_Size_Width__c = 2.3;
        itd.Tumor_Size_Height__c = 3.1;
        itd.Overall_cancer_cellularity__c = 45.0;
        insert itd;
        
        DCIS__c dc = new DCIS__c();
        dc.Post_Surgery_Summary__c = pss.Id;
        dc.DCIS__c = 45.0;
        insert dc;
        
        LCIS__c lc = new LCIS__c();
        lc.Post_Surgery_Summary__c = pss.Id;
        lc.LCIS__c = 36.0;
        insert lc;
        
        pss.Status__c = 'Accepted';
        update pss;
        
        Procedure__c pro = new Procedure__c();
        pro.TrialPatient__c = tp.Id;
        pro.Post_Surgery_Summary__c = pss.Id;
        pro.Laterality__c = 'Left';
        pro.Date_Of_Procedure__c = pss.Date_Of_Procedure__c;
        pro.Form_Name__c = 'Post Surgery Summary Form';
        pro.Procedure_Name__c = 'Sentinel lymph node dissection';
        insert pro;
        
        Lymph_Nodes__c lm = new Lymph_Nodes__c();
        lm.Procedure__c = pro.Id;
        lm.Post_Surgery_Summary__c = pss.Id;
        lm.Letarality__c = 'Left';
        lm.Sentinel_Nodes__c = true;
        lm.Node_Checkbox_Value__c = 'Sentinel Nodes';
        lm.Specific_Size_of_Largest_Tumor__c = 1;
        lm.Tumor_Size_Measurement_Unit__c = 'MM';
        lm.Positive__c = 2.0;
        lm.Examined__c = 3.0;
        insert lm;
        
        Lymph_Nodes__c lm1 = new Lymph_Nodes__c();
        lm1.Procedure__c = pro.Id;
        lm1.Post_Surgery_Summary__c = pss.Id;
        lm1.Letarality__c = 'Left';
        lm1.Axillary_Nodes__c = true;
        lm1.Node_Checkbox_Value__c = 'Sentinel Nodes';
        lm1.Specific_Size_of_Largest_Tumor__c = 1;
        lm1.Tumor_Size_Measurement_Unit__c = 'MM';
        lm1.Positive__c = 2.0;
        lm1.Examined__c = 3.0;
        insert lm1;
        
        Lymph_Nodes__c lm2 = new Lymph_Nodes__c();
        lm2.Procedure__c = pro.Id;
        lm2.Post_Surgery_Summary__c = pss.Id;
        lm2.Letarality__c = 'Left';
        lm2.Additional_Nodes__c = true;
        lm2.Node_Checkbox_Value__c = 'Sentinel Nodes';
        lm2.Specific_Size_of_Largest_Tumor__c = 1;
        lm2.Tumor_Size_Measurement_Unit__c = 'MM';
        lm2.Positive__c = 2.0;
        lm2.Examined__c = 3.0;
        insert lm2;
        
        Procedure_Specimen_Detail__c psd1 = new Procedure_Specimen_Detail__c();
        psd1.Specimen__c = 'Main specimen with separately submitted margins';
        psd1.Procedure__c = pro.Id;
        insert psd1;
        
        Apexpages.currentPage().getParameters().put('trialPat',tp.Id);  
        Apexpages.currentPage().getParameters().put('postid',pss.Id);
        ApexPages.StandardController controller = new ApexPages.StandardController(pss);
        PostSurgerySummaryController postObject = new PostSurgerySummaryController(controller);
        
        Apexpages.currentPage().getParameters().put('nextTab','rcbTab'); 
        postObject.postsurObj = pss;
        postObject.next();
        
        //======= method "showSpecimenOption()" begins here ======================================
        
        Apexpages.currentPage().getParameters().put('specimenNum','1'); // method 'showspecimenoption' begins
        Apexpages.currentPage().getParameters().put('procedureId',pro.Id);
        postObject.showSpecimenOption();
        
        //======= method "showSpecimenOption()" ends here ======================================
        
      //  postObject.cloneCRF();
        }
        }
    }
    @isTest static void myUnitTest6() {  // to satisfy "next" method for "rcbTab"
        // TO DO: implement unit test
        List<RecordType> recordT = [Select r.Name, r.Id From RecordType r where sObjectType='Contact' and Name='Doctor'];
        List<User> lstSiteUser = [Select u.IsActive, u.Id, SecurityCode__c From User u where IsActive = true and Profile.Name = 'System Administrator'];     
        System.runAs ( lstSiteUser[0] ) { 
            
        Account inst1 = new Account();

        List<Account> lstAccount = [select Id from Account where RecordType.Name = 'Institution']; 
            
        if(!lstAccount.isEmpty()){
                
        inst1 = lstAccount[0];           // newly added logic to overcome the error of "setup and nonsetup" object
        
        Site__c s = new Site__c();
        s.Institute__c = inst1.Id;
        insert s;
        
        Code_Master__c snomedObject1 = new Code_Master__c();
        snomedObject1.Variable_Description__c = 'test';
        snomedObject1.IsReportColumn__c = true;
        snomedObject1.Display_Order__c = 1.0;
        snomedObject1.Name = 'Surgery_Br';
        insert snomedObject1;
        
        Code_Master__c snomedObject2 = new Code_Master__c();
        snomedObject2.Variable_Description__c = 'test';
        snomedObject2.IsReportColumn__c = true;
        snomedObject2.Display_Order__c = 1.0;
        snomedObject2.Name = 'NumPosLN_PS';
        insert snomedObject2;
        
        Code_Master__c snomedObject3 = new Code_Master__c();
        snomedObject3.Variable_Description__c = 'test';
        snomedObject3.IsReportColumn__c = true;
        snomedObject3.Display_Order__c = 1.0;
        snomedObject3.Name = 'NumExLN_PS';
        insert snomedObject3;
        
        Contact con = new Contact();
        con.AccountId = inst1.Id;
        con.LastName = 'test';
        con.Site__c = s.Id;
        con.Type__c = 'Surgeon';
        con.RecordTypeId = recordT[0].Id;
        insert con;
        
        Patient_Custom__c p = new Patient_Custom__c();
        p.Birthdate__c = date.newInstance(1950, 08, 05);
        p.Institution__c = inst1.Id;
        p.Last_Name__c = 'test'; 
        p.Gender__c = 'Male';
        p.Race__c = 'White';
        p.Ethnicity__c = 'Not Hispanic or Latino';
        insert p;
        
        TrialPatient__c tp = new TrialPatient__c();
        tp.Patient_Id__c = p.Id;
        insert tp;
        
        InstitutionUser__c ins = new InstitutionUser__c();
        ins.Site__c = s.Id;
        ins.User__c = userinfo.getUserId();
        ins.Institution__c = inst1.Id;
        insert ins;
        
        Post_Surgaory_Summary__c pss1 = new Post_Surgaory_Summary__c();
        pss1.TrialPatient__c = tp.Id;
        pss1.Surgeon__c = con.Id;
        pss1.Date_Of_Procedure__c = date.newInstance(2012, 7, 7);
        pss1.Status__c = 'Not Completed';
        pss1.Is_invasive_tumor_present__c = 'No';
        pss1.Type_Of_Tumor__c = 'Multifocal Discrete Masses';
        pss1.Total_Span_Measurement_Unit__c = 'MM';
        pss1.Is_DCIS_Present__c = 'Yes';
        pss1.Is_LCIS_Present__c = 'Yes';
        pss1.Lymph_node_dissection_done__c = 'Yes';
        pss1.Size_of_Gross_Mass_Width__c = 23.0;
        pss1.Size_of_Gross_Mass_Height__c = 32.0;
        pss1.Total_span_multifocal_gross_mass_width__c = 32.0;
        pss1.Total_span_multifocal_gross_mass_height__c = 33.0;
        pss1.Span_of_gross_changes_width__c = 23.0;
        pss1.Span_of_gross_changes_height__c = 25.0;
        insert pss1;
        
        Invasive_Tumor_Detail__c itd = new Invasive_Tumor_Detail__c();
        itd.Post_Surgery_Summary__c = pss1.Id;
        itd.Tumor_Measurement_Unit__c = 'MM';
        itd.Tumor_Size_Width__c = 2.3;
        itd.Tumor_Size_Height__c = 3.1;
        itd.Overall_cancer_cellularity__c = 45.0;
        insert itd;
        
        DCIS__c dc = new DCIS__c();
        dc.Post_Surgery_Summary__c = pss1.Id;
        dc.DCIS__c = 45.0;
        insert dc;
        
        LCIS__c lc = new LCIS__c();
        lc.Post_Surgery_Summary__c = pss1.Id;
        lc.LCIS__c = 36.0;
        insert lc;
        
        pss1.Status__c = 'Accepted';
        update pss1;
        
        Procedure__c pro1 = new Procedure__c();
        pro1.TrialPatient__c = tp.Id;
        pro1.Post_Surgery_Summary__c = pss1.Id;
        pro1.Laterality__c = 'Left';
        pro1.Date_Of_Procedure__c = pss1.Date_Of_Procedure__c;
        pro1.Form_Name__c = 'Post Surgery Summary Form';
        pro1.Procedure_Name__c = 'Sentinel lymph node dissection';
        insert pro1;
        
        Lymph_Nodes__c lm1 = new Lymph_Nodes__c();
        lm1.Procedure__c = pro1.Id;
        lm1.Letarality__c = 'Left';
        lm1.Axillary_Nodes__c = true;
        lm1.Node_Checkbox_Value__c = 'Axillary Nodes';
        lm1.Specific_Size_of_Largest_Tumor__c = 1;
        lm1.Tumor_Size_Measurement_Unit__c = 'MM';
        lm1.Positive__c = 2.0;
        lm1.Examined__c = 3.0;
        lm1.Post_Surgery_Summary__c = pss1.Id;
        insert lm1;
        
        Lymph_Nodes__c lm2 = new Lymph_Nodes__c();
        lm2.Procedure__c = pro1.Id;
        lm2.Letarality__c = 'Left';
        lm2.Sentinel_Nodes__c = true;
        lm2.Node_Checkbox_Value__c = 'Axillary Nodes';
        lm2.Specific_Size_of_Largest_Tumor__c = 1;
        lm2.Tumor_Size_Measurement_Unit__c = 'MM';
        lm2.Positive__c = 2.0;
        lm2.Examined__c = 3.0;
        lm2.Post_Surgery_Summary__c = pss1.Id;
        insert lm2;
        
        Lymph_Nodes__c lm3 = new Lymph_Nodes__c();
        lm3.Procedure__c = pro1.Id;
        lm3.Letarality__c = 'Left';
        lm3.Additional_Nodes__c = true;
        lm3.Node_Checkbox_Value__c = 'Axillary Nodes';
        lm3.Specific_Size_of_Largest_Tumor__c = 1;
        lm3.Tumor_Size_Measurement_Unit__c = 'MM';
        lm3.Positive__c = 2.0;
        lm3.Examined__c = 3.0;
        lm3.Post_Surgery_Summary__c = pss1.Id;
        insert lm3;
        
        Procedure_Specimen_Detail__c psd1 = new Procedure_Specimen_Detail__c();
        psd1.Specimen__c = 'Single Specimen';
        psd1.Procedure__c = pro1.Id;
        insert psd1;
        
        Apexpages.currentPage().getParameters().put('trialPat',tp.Id);  
        Apexpages.currentPage().getParameters().put('postid',pss1.Id);
        ApexPages.StandardController controller1 = new ApexPages.StandardController(pss1);
        PostSurgerySummaryController postObject1 = new PostSurgerySummaryController(controller1);
        
        Apexpages.currentPage().getParameters().put('nextTab','rcbTab'); 
        postObject1.postsurObj = pss1;
        postObject1.next(); 
        
        //======= method "showSpecimenOption()" begins here ======================================
        
        Apexpages.currentPage().getParameters().put('specimenNum','1'); // method 'showspecimenoption' begins
        Apexpages.currentPage().getParameters().put('procedureId',pro1.Id);
        postObject1.showSpecimenOption();
        
        //======= method "showSpecimenOption()" ends here ======================================
        
        }
        }
    }
    
    @isTest static void myUnitTest7() {  // to satisfy "next" method for "lymphnode"
        // TO DO: implement unit test
        List<RecordType> recordT = [Select r.Name, r.Id From RecordType r where sObjectType='Contact' and Name='Doctor'];
        List<User> lstSiteUser = [Select u.IsActive, u.Id, SecurityCode__c From User u where IsActive = true and Profile.Name = 'System Administrator'];     
        System.runAs ( lstSiteUser[0] ) { 
            
        Account inst1 = new Account();

        List<Account> lstAccount = [select Id from Account where RecordType.Name = 'Institution']; 
            
        if(!lstAccount.isEmpty()){
                
        inst1 = lstAccount[0];           // newly added logic to overcome the error of "setup and nonsetup" object
        
        Site__c s = new Site__c();
        s.Institute__c = inst1.Id;
        insert s;
        
        Code_Master__c snomedObject1 = new Code_Master__c();
        snomedObject1.Variable_Description__c = 'test';
        snomedObject1.IsReportColumn__c = true;
        snomedObject1.Display_Order__c = 1.0;
        snomedObject1.Name = 'Surgery_Br';
        insert snomedObject1;
        
        Code_Master__c snomedObject2 = new Code_Master__c();
        snomedObject2.Variable_Description__c = 'test';
        snomedObject2.IsReportColumn__c = true;
        snomedObject2.Display_Order__c = 1.0;
        snomedObject2.Name = 'NumPosLN_PS';
        insert snomedObject2;
        
        Code_Master__c snomedObject3 = new Code_Master__c();
        snomedObject3.Variable_Description__c = 'test';
        snomedObject3.IsReportColumn__c = true;
        snomedObject3.Display_Order__c = 1.0;
        snomedObject3.Name = 'NumExLN_PS';
        insert snomedObject3;
        
        Contact con = new Contact();
        con.AccountId = inst1.Id;
        con.LastName = 'test';
        con.Site__c = s.Id;
        con.Type__c = 'Surgeon';
        con.RecordTypeId = recordT[0].Id;
        insert con;
        
        Patient_Custom__c p = new Patient_Custom__c();
        p.Birthdate__c = date.newInstance(1950, 08, 05);
        p.Institution__c = inst1.Id;
        p.Last_Name__c = 'test'; 
        p.Gender__c = 'Male';
        p.Race__c = 'White';
        p.Ethnicity__c = 'Not Hispanic or Latino';
        insert p;
        
        TrialPatient__c tp = new TrialPatient__c();
        tp.Patient_Id__c = p.Id;
        insert tp;
        
        InstitutionUser__c ins = new InstitutionUser__c();
        ins.Site__c = s.Id;
        ins.User__c = userinfo.getUserId();
        ins.Institution__c = inst1.Id;
        insert ins; 
        
        Post_Surgaory_Summary__c pss = new Post_Surgaory_Summary__c();
        pss.TrialPatient__c = tp.Id;
        pss.Surgeon__c = con.Id;
        pss.Date_Of_Procedure__c = date.newInstance(2012, 7, 7);
        pss.Status__c = 'Not Completed';
        pss.Is_invasive_tumor_present__c = 'No';
        pss.Type_Of_Tumor__c = 'Gross Stromal Alterations/Fibrosis';
        pss.Gross_Changes_Measurement_Unit__c = 'MM';
        pss.Total_Span_Measurement_Unit__c = 'MM';
        pss.Is_DCIS_Present__c = 'Yes';
        pss.Is_LCIS_Present__c = 'Yes';
        pss.Lymph_node_dissection_done__c = 'Yes';
        pss.Size_of_Gross_Mass_Width__c = 23.0;
        pss.Size_of_Gross_Mass_Height__c = 32.0;
        pss.Total_span_multifocal_gross_mass_width__c = 32.0;
        pss.Total_span_multifocal_gross_mass_height__c = 33.0;
        pss.Span_of_gross_changes_width__c = 23.0;
        pss.Span_of_gross_changes_height__c = 25.0;
        insert pss;
        
        pss.Status__c = 'Accepted';
        update pss;
        
        Invasive_Tumor_Detail__c itd = new Invasive_Tumor_Detail__c();
        itd.Post_Surgery_Summary__c = pss.Id;
        itd.Tumor_Measurement_Unit__c = 'MM';
        itd.Tumor_Size_Width__c = 2.3;
        itd.Tumor_Size_Height__c = 3.1;
        itd.Overall_cancer_cellularity__c = 45.0;
        insert itd;
        
        DCIS__c dc = new DCIS__c();
        dc.Post_Surgery_Summary__c = pss.Id;
        dc.DCIS__c = 45.0;
        insert dc;
        
        LCIS__c lc = new LCIS__c();
        lc.Post_Surgery_Summary__c = pss.Id;
        lc.LCIS__c = 36.0;
        insert lc; 
        
        Procedure__c pro = new Procedure__c();
        pro.TrialPatient__c = tp.Id;
        pro.Post_Surgery_Summary__c = pss.Id;
        pro.Laterality__c = 'Left';
        pro.Date_Of_Procedure__c = pss.Date_Of_Procedure__c;
        pro.Form_Name__c = 'Post Surgery Summary Form';
        pro.Procedure_Name__c = 'Sentinel lymph node dissection';
        insert pro;
        
        Lymph_Nodes__c lm = new Lymph_Nodes__c();
        lm.Procedure__c = pro.Id;
        lm.Additional_Nodes__c = true;
        lm.Node_Checkbox_Value__c = 'Additional Nodes';
        lm.Specific_Size_of_Largest_Tumor__c = 1;
        lm.Tumor_Size_Measurement_Unit__c = 'MM';
        lm.Positive__c = 2.0;
        lm.Examined__c = 3.0;
        insert lm;
        
        Procedure_Specimen_Detail__c psd1 = new Procedure_Specimen_Detail__c();
        psd1.Procedure__c = pro.Id;
        insert psd1; 
        
        Apexpages.currentPage().getParameters().put('trialPat',tp.Id);  
        Apexpages.currentPage().getParameters().put('postid',pss.Id);
        ApexPages.StandardController controller = new ApexPages.StandardController(pss);
        PostSurgerySummaryController postObject = new PostSurgerySummaryController(controller);
        
        postObject.currentTab = 'lymphTab';
        postObject.next(); 
        
        //======= method "showSpecimenOption()" begins here ======================================
        
        Apexpages.currentPage().getParameters().put('specimenNum','1'); // method 'showspecimenoption' begins
        Apexpages.currentPage().getParameters().put('procedureId',pro.Id);
        postObject.showSpecimenOption();
        
        //======= method "showSpecimenOption()" ends here ======================================
        
        }
      }
    }
    
    @isTest static void myUnitTest8() {  // to satisfy "next" method for "rcbtab" 
        // TO DO: implement unit test
        List<RecordType> recordT = [Select r.Name, r.Id From RecordType r where sObjectType='Contact' and Name='Doctor'];
        List<User> lstSiteUser = [Select u.IsActive, u.Id, SecurityCode__c From User u where IsActive = true and Profile.Name = 'System Administrator'];     
        System.runAs ( lstSiteUser[0] ) { 
            
        Account inst1 = new Account();

        List<Account> lstAccount = [select Id from Account where RecordType.Name = 'Institution']; 
            
        if(!lstAccount.isEmpty()){
                
        inst1 = lstAccount[0];           // newly added logic to overcome the error of "setup and nonsetup" object
        
        Site__c s = new Site__c();
        s.Institute__c = inst1.Id;
        insert s;
        
        Code_Master__c snomedObject1 = new Code_Master__c();
        snomedObject1.Variable_Description__c = 'test';
        snomedObject1.IsReportColumn__c = true;
        snomedObject1.Display_Order__c = 1.0;
        snomedObject1.Name = 'Surgery_Br';
        insert snomedObject1;
        
        Code_Master__c snomedObject2 = new Code_Master__c();
        snomedObject2.Variable_Description__c = 'test';
        snomedObject2.IsReportColumn__c = true;
        snomedObject2.Display_Order__c = 1.0;
        snomedObject2.Name = 'NumPosLN_PS';
        insert snomedObject2;
        
        Code_Master__c snomedObject3 = new Code_Master__c();
        snomedObject3.Variable_Description__c = 'test';
        snomedObject3.IsReportColumn__c = true;
        snomedObject3.Display_Order__c = 1.0;
        snomedObject3.Name = 'NumExLN_PS';
        insert snomedObject3;
        
        Contact con = new Contact();
        con.AccountId = inst1.Id;
        con.LastName = 'test';
        con.Site__c = s.Id;
        con.Type__c = 'Surgeon';
        con.RecordTypeId = recordT[0].Id;
        insert con;
        
        Patient_Custom__c p = new Patient_Custom__c();
        p.Birthdate__c = date.newInstance(1950, 08, 05);
        p.Institution__c = inst1.Id;
        p.Last_Name__c = 'test'; 
        p.Gender__c = 'Male';
        p.Race__c = 'White';
        p.Ethnicity__c = 'Not Hispanic or Latino';
        insert p;
        
        TrialPatient__c tp = new TrialPatient__c();
        tp.Patient_Id__c = p.Id;
        insert tp;
        
        InstitutionUser__c ins = new InstitutionUser__c();
        ins.Site__c = s.Id;
        ins.User__c = userinfo.getUserId();
        ins.Institution__c = inst1.Id;
        insert ins;
        
        Post_Surgaory_Summary__c pss = new Post_Surgaory_Summary__c();
        pss.TrialPatient__c = tp.Id;
        pss.Surgeon__c = con.Id;
        pss.Date_Of_Procedure__c = date.newInstance(2012, 7, 7);
        pss.Status__c = 'Not Completed';
        pss.Is_invasive_tumor_present__c = 'No';
        pss.Type_Of_Tumor__c = 'Gross Stromal Alterations/Fibrosis';
        pss.Gross_Changes_Measurement_Unit__c = 'MM';
        pss.Total_Span_Measurement_Unit__c = 'MM';
        pss.Is_DCIS_Present__c = 'Yes';
        pss.Is_LCIS_Present__c = 'Yes';
        pss.Lymph_node_dissection_done__c = 'Yes';
        pss.Size_of_Gross_Mass_Width__c = 23.0;
        pss.Size_of_Gross_Mass_Height__c = 32.0;
        pss.Total_span_multifocal_gross_mass_width__c = 32.0;
        pss.Total_span_multifocal_gross_mass_height__c = 33.0;
        pss.Span_of_gross_changes_width__c = 23.0;
        pss.Span_of_gross_changes_height__c = 25.0;
        insert pss;
        
        Invasive_Tumor_Detail__c itd = new Invasive_Tumor_Detail__c();
        itd.Post_Surgery_Summary__c = pss.Id;
        itd.Tumor_Measurement_Unit__c = 'MM';
        itd.Tumor_Size_Width__c = 2.3;
        itd.Tumor_Size_Height__c = 3.1;
        itd.Overall_cancer_cellularity__c = 45.0;
        insert itd;
        
        DCIS__c dc = new DCIS__c();
        dc.Post_Surgery_Summary__c = pss.Id;
        dc.DCIS__c = 45.0;
        insert dc;
        
        LCIS__c lc = new LCIS__c();
        lc.Post_Surgery_Summary__c = pss.Id;
        lc.LCIS__c = 36.0;
        insert lc;
        
        pss.Status__c = 'Accepted';
        update pss;
        
        Procedure__c pro = new Procedure__c();
        pro.TrialPatient__c = tp.Id;
        pro.Post_Surgery_Summary__c = pss.Id;
        pro.Laterality__c = 'Left';
        pro.Date_Of_Procedure__c = pss.Date_Of_Procedure__c;
        pro.Form_Name__c = 'Post Surgery Summary Form';
        pro.Procedure_Name__c = 'Sentinel lymph node dissection';
        insert pro;
        
        Lymph_Nodes__c lm = new Lymph_Nodes__c();
        lm.Letarality__c = 'Left';
        lm.Procedure__c = pro.Id;
        lm.Additional_Nodes__c = true;
        lm.Node_Checkbox_Value__c = 'Additional Nodes';
        lm.Specific_Size_of_Largest_Tumor__c = 1;
        lm.Tumor_Size_Measurement_Unit__c = 'MM';
        lm.Positive__c = 2.0;
        lm.Examined__c = 3.0;
        lm.Post_Surgery_Summary__c = pss.Id;
        insert lm;
        
        Lymph_Nodes__c lm1 = new Lymph_Nodes__c();
        lm1.Letarality__c = 'Left';
        lm1.Procedure__c = pro.Id;
        lm1.Sentinel_Nodes__c = true;
        lm1.Node_Checkbox_Value__c = 'Additional Nodes';
        lm1.Specific_Size_of_Largest_Tumor__c = 1;
        lm1.Tumor_Size_Measurement_Unit__c = 'MM';
        lm1.Positive__c = 2.0;
        lm1.Examined__c = 3.0;
        lm1.Post_Surgery_Summary__c = pss.Id;
        insert lm1;
        
        Lymph_Nodes__c lm2 = new Lymph_Nodes__c();
        lm2.Letarality__c = 'Left';
        lm2.Procedure__c = pro.Id;
        lm2.Axillary_Nodes__c = true;
        lm2.Node_Checkbox_Value__c = 'Additional Nodes';
        lm2.Specific_Size_of_Largest_Tumor__c = 1;
        lm2.Tumor_Size_Measurement_Unit__c = 'MM';
        lm2.Positive__c = 2.0;
        lm2.Examined__c = 3.0;
        lm2.Post_Surgery_Summary__c = pss.Id;
        insert lm2;
        
        
        Apexpages.currentPage().getParameters().put('trialPat',tp.Id);  
        Apexpages.currentPage().getParameters().put('postid',pss.Id);
        ApexPages.StandardController controller = new ApexPages.StandardController(pss);
        PostSurgerySummaryController postObject = new PostSurgerySummaryController(controller);
        
        Apexpages.currentPage().getParameters().put('nextTab','rcbTab'); 
        postObject.postsurObj = pss;
        postObject.next(); 
        
        postObject.cloneCRF();
      }
    }
  }
}