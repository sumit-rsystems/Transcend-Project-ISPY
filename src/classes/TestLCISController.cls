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
private class TestLCISController {

    @isTest static void myUnitTest() {
        // TO DO: implement unit test
        
        LCISController lcis1 = new LCISController(); //else part line 19
        
        On_Study_Pathology_Form__c osp = new On_Study_Pathology_Form__c();
        //osp.LCIS__c = lc.Id;
        osp.Does_the_patient_have_bilateral_breast_c__c = 'Yes';
        insert osp;
        
        Post_Surgaory_Summary__c pss = new Post_Surgaory_Summary__c();
        //pss.LCIS__c = lc.Id;
        insert pss;
        
        LCIS__c lc = new LCIS__c();
        lc.On_Study_Pathology_Form__c = osp.Id;
        insert lc;
        
        LCIS__c lc1 = new LCIS__c();
        lc1.Post_Surgery_Summary__c = pss.Id;
        insert lc1;
        
        ComponentControllerBase ccb = new ComponentControllerBase(); // VIRTUAL CLASS "ComponentControllerBase"
        ccb.key = '1';
        
        PageControllerBase pcb = new PageControllerBase();   // VIRTUAL CLASS "PageControllerBase" BEGINS HERE
        pcb.getComponentControllerMap(); // "get"
        pcb.getLcisComponentController(); // "get"
        pcb.getThis();
        
        pcb.setComponentControllerMap('1', ccb);        // "set"
        pcb.setLcisComponentController(ccb);           // "set" and VIRTUAL CLASS "PageControllerBase" ENDS HERE
        
        Apexpages.currentPage().getParameters().put('PathologyId',osp.Id);
        Apexpages.currentPage().getParameters().put('postid',pss.Id);
        LCISController lcis = new LCISController();
        
        lcis.getKey();
        lcis.setPageController(pcb);
        lcis.getPageController();
        lcis.setKey('1');
        
        //lcis.lcisId = osp.Id;
        lcis.lcisPostId = pss.Id;
        lcis.saveLCIS(osp.Id);
        lcis.savePostLCIS(pss.Id);
        lcis.setObjId(pss.Id);
    }
    @isTest static void myUnitTest1() {
        // TO DO: implement unit test
        
        LCISController lcis1 = new LCISController(); //else part line 19
        
        On_Study_Pathology_Form__c osp = new On_Study_Pathology_Form__c();
        //osp.LCIS__c = lc.Id;
        osp.Does_the_patient_have_bilateral_breast_c__c = 'Yes';
        insert osp;
        
        Post_Surgaory_Summary__c pss = new Post_Surgaory_Summary__c();
        //pss.LCIS__c = lc.Id;
        insert pss;
        
        LCIS__c lc1 = new LCIS__c();
        lc1.On_Study_Pathology_Form__c = osp.Id;
        insert lc1;
        
        LCIS__c lc = new LCIS__c();
        lc.Post_Surgery_Summary__c = pss.Id;
        insert lc;
        
        Apexpages.currentPage().getParameters().put('PathologyId',osp.Id); // else if condition line 19
        LCISController lcis = new LCISController();
       // lcis.lcisId = osp.Id;
        lcis.lcisPostId = pss.Id;
        lcis.saveLCIS(osp.Id);
        lcis.savePostLCIS(pss.Id);
        lcis.setObjId(osp.Id);
    }
}