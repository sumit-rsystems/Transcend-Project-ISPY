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
private class TestReceptors {

    @isTest static void myUnitTest() {
        // TO DO: implement unit test
        /*
        LCIS__c lc = new LCIS__c();
        insert lc;*/
        Code_Master__c snomedObject = new Code_Master__c();
        snomedObject.Variable_Description__c = 'test';
        snomedObject.IsReportColumn__c = true;
        snomedObject.Display_Order__c = 3.0;
        snomedObject.Name = 'ER_TS_OS';
        insert snomedObject;
        
        Code_Master__c snomedObject1 = new Code_Master__c();
        snomedObject1.Variable_Description__c = 'test';
        snomedObject1.IsReportColumn__c = true;
        snomedObject1.Display_Order__c = 3.0;
        snomedObject1.Name = 'PgR_TS_OS';
        insert snomedObject1;
        
        Receptors recp1 = new Receptors(); // else part line 16
        
        On_Study_Pathology_Form__c osp = new On_Study_Pathology_Form__c();
        //osp.LCIS__c = lc.Id;
        //osp.Receptors__c = recObj.Id;
        osp.Does_the_patient_have_bilateral_breast_c__c = 'Yes';
        insert osp;
        
        Post_Surgaory_Summary__c pos = new Post_Surgaory_Summary__c();
        //pos.LCIS__c = lc.Id;
        //pos.Receptors_Left__c = recObj.Id;
        insert pos;
        
        Receptors__c recObj = new Receptors__c();
        recObj.Estrogen_Receptor_Proportion_Score__c = '0';
        recObj.Estrogen_Intensity_Score__c = '0(Negative)';
        recObj.Progesterone_Receptor_Proportion_Score__c = '0';
        recObj.Progesterone_Intensity_Score__c = '0(Negative)';
        recObj.Post_Surgery_Summary__c = pos.Id;
        recObj.On_Study_Pathology_Form__c = osp.Id;
        recObj.Letarality__c = 'Left';
        insert recObj;
        
        ComponentControllerBase ccb = new ComponentControllerBase(); // VIRTUAL CLASS "ComponentControllerBase"
        ccb.key = '1';
        
        PageControllerBase pcb = new PageControllerBase();   // VIRTUAL CLASS "PageControllerBase" BEGINS HERE
        pcb.getComponentControllerMap(); // "get"
        pcb.getReceptorsComponentController(); // "get"
        pcb.getThis();
        
        pcb.setComponentControllerMap('1', ccb);        // "set"
        pcb.setReceptorsComponentController(ccb);           // "set" and VIRTUAL CLASS "PageControllerBase" ENDS HERE
        
        Apexpages.currentPage().getParameters().put('PathologyId',osp.Id);
        //Apexpages.currentPage().getParameters().put('postid',pos.Id);
        Receptors recp = new Receptors(); //class
        
        recp.getKey();
        recp.setPageController(pcb);
        recp.getPageController();
        recp.setKey('1');
        recp.setObjId(osp.Id);
        
        recp.recId = osp.Id;
        recp.recObj = recObj;
        recp.insertRec(osp.Id); // method "insertrec"
        
        recp.recId = pos.Id;
        recp.insertRecPostLeft(pos.Id); // method "left"
        
        recp.recId = pos.Id;
        recp.insertRecPostRight(pos.Id); // method "right"
       
    }
    @isTest static void myUnitTest1() {
        // TO DO: implement unit test
        /*
        LCIS__c lc = new LCIS__c();
        insert lc;
        */
        Code_Master__c snomedObject = new Code_Master__c();
        snomedObject.Variable_Description__c = 'test';
        snomedObject.IsReportColumn__c = true;
        snomedObject.Display_Order__c = 3.0;
        snomedObject.Name = 'ER_TS_OS';
        insert snomedObject;
        
        Code_Master__c snomedObject1 = new Code_Master__c();
        snomedObject1.Variable_Description__c = 'test';
        snomedObject1.IsReportColumn__c = true;
        snomedObject1.Display_Order__c = 3.0;
        snomedObject1.Name = 'PgR_TS_OS';
        insert snomedObject1;
        
        Receptors recp1 = new Receptors(); // else part line 16
        
        On_Study_Pathology_Form__c osp = new On_Study_Pathology_Form__c();
        //osp.LCIS__c = lc.Id;
        //osp.Receptors__c = recObj.Id;
        osp.Does_the_patient_have_bilateral_breast_c__c = 'Yes';
        insert osp;
        
        Post_Surgaory_Summary__c pos = new Post_Surgaory_Summary__c();
        //pos.LCIS__c = lc.Id;
        //pos.Receptors_Right__c = recObj.Id;
        insert pos;
        
        Receptors__c recObj = new Receptors__c();
        recObj.Estrogen_Receptor_Proportion_Score__c = '0';
        recObj.Estrogen_Intensity_Score__c = '0(Negative)';
        recObj.Progesterone_Receptor_Proportion_Score__c = '0';
        recObj.Progesterone_Intensity_Score__c = '0(Negative)';
        recObj.Post_Surgery_Summary__c = pos.Id;
        recObj.On_Study_Pathology_Form__c = osp.Id;
        recObj.Letarality__c = 'Left';
        insert recObj;
        
        Receptors__c recObj1 = new Receptors__c();
        recObj1.Estrogen_Receptor_Proportion_Score__c = '0';
        recObj1.Estrogen_Intensity_Score__c = '0(Negative)';
        recObj1.Progesterone_Receptor_Proportion_Score__c = '0';
        recObj1.Progesterone_Intensity_Score__c = '0(Negative)';
        recObj1.Post_Surgery_Summary__c = pos.Id;
        recObj1.On_Study_Pathology_Form__c = osp.Id;
        recObj1.Letarality__c = 'Right';
        insert recObj1;
        
        Apexpages.currentPage().getParameters().put('postid',pos.Id);
        Receptors recp = new Receptors(); //class
        
        recp.setObjId(pos.Id);
        recp.recId = osp.Id;
        recp.recObj = recObj;
        recp.insertRec(osp.Id); // method "insertrec"
        
        recp.recId = pos.Id;
        recp.insertRecPostLeft(pos.Id); // method "left"
        
        recp.recId = pos.Id;
        recp.insertRecPostRight(pos.Id); // method "right"
       
    }
    @isTest static void myUnitTest2() {
        // TO DO: implement unit test
        /*
        LCIS__c lc = new LCIS__c();
        insert lc;
        */
        Code_Master__c snomedObject = new Code_Master__c();
        snomedObject.Variable_Description__c = 'test';
        snomedObject.IsReportColumn__c = true;
        snomedObject.Display_Order__c = 3.0;
        snomedObject.Name = 'ER_TS_OS';
        insert snomedObject;
        
        Code_Master__c snomedObject1 = new Code_Master__c();
        snomedObject1.Variable_Description__c = 'test';
        snomedObject1.IsReportColumn__c = true;
        snomedObject1.Display_Order__c = 3.0;
        snomedObject1.Name = 'PgR_TS_OS';
        insert snomedObject1;
        
        Receptors recp1 = new Receptors(); // else part line 16
        
        On_Study_Pathology_Form__c osp = new On_Study_Pathology_Form__c();
        //osp.LCIS__c = lc.Id;
        //osp.Receptors__c = recObj.Id;
        osp.Does_the_patient_have_bilateral_breast_c__c = 'Yes';
        insert osp;
        
        Post_Surgaory_Summary__c pos = new Post_Surgaory_Summary__c();
        //pos.LCIS__c = lc.Id;
        //pos.Receptors_Left__c = recObj.Id;
        insert pos;
        
        Receptors__c recObj = new Receptors__c();
        recObj.Estrogen_Receptor_Proportion_Score__c = '0';
        recObj.Estrogen_Intensity_Score__c = '0(Negative)';
        recObj.Progesterone_Receptor_Proportion_Score__c = '0';
        recObj.Progesterone_Intensity_Score__c = '0(Negative)';
        recObj.Post_Surgery_Summary__c = pos.Id;
        recObj.On_Study_Pathology_Form__c = osp.Id;
        insert recObj;
        
        Apexpages.currentPage().getParameters().put('PathologyId',osp.Id);
        Receptors recp = new Receptors(); //class
        
        recp.recId = osp.Id;
        recp.recObj = recObj;
        recp.insertRec(osp.Id); // method "insertrec"
        
    }
}