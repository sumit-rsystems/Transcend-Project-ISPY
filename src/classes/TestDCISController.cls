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
private class TestDCISController {

    @isTest static void myUnitTest() {
        // TO DO: implement unit test
        
        DCISController dcis1 = new DCISController(); //else part line 20
        
        On_Study_Pathology_Form__c osp = new On_Study_Pathology_Form__c();
        insert osp;
        
        Post_Surgaory_Summary__c pss = new Post_Surgaory_Summary__c();
        osp.Does_the_patient_have_bilateral_breast_c__c = 'Yes';
        insert pss;
        
        DCIS__c dc = new DCIS__c();
        dc.On_Study_Pathology_Form__c = osp.Id;
        dc.Punctate_necrosis__c = true;
        dc.Comedonecrosis__c = true;
        dc.Papillary__c = true;
        dc.Micropapillary__c = true;
        dc.Necrosis__c = true;
        dc.Cribiform__c = true;
        dc.Cruciform__c = true;
        dc.Clinging__c = true;
        dc.Solid__c = true;
        dc.Apocrine__c = true;
        dc.Intra_cystic_encysted_papillary__c = true;
        dc.Other__c = true;
        insert dc;
        
        DCIS__c dc1 = new DCIS__c();
        dc1.Post_Surgery_Summary__c = pss.Id;
        dc1.Punctate_necrosis__c = true;
        dc1.Comedonecrosis__c = true;
        dc1.Papillary__c = true;
        dc1.Micropapillary__c = true;
        dc1.Necrosis__c = true;
        dc1.Cribiform__c = true;
        dc1.Cruciform__c = true;
        dc1.Clinging__c = true;
        dc1.Solid__c = true;
        dc1.Apocrine__c = true;
        dc1.Intra_cystic_encysted_papillary__c = true;
        dc1.Other__c = true;
        insert dc1;
        
        ComponentControllerBase ccb = new ComponentControllerBase(); // VIRTUAL CLASS "ComponentControllerBase"
        ccb.key = '1';
        
        PageControllerBase pcb = new PageControllerBase(); // VIRTUAL CLASS "PageControllerBase" BEGINS HERE
        pcb.getComponentControllerMap();
        pcb.getDcisController();
        pcb.getThis();
        
        pcb.setComponentControllerMap('1', ccb);
        pcb.setDcisController(ccb); // VIRTUAL CLASS "PageControllerBase" ENDS HERE
        
        
        Apexpages.currentPage().getParameters().put('PathologyId',osp.Id);
        Apexpages.currentPage().getParameters().put('postid',pss.Id);
        DCISController dcis = new DCISController();
        
        dcis.getKey();
        dcis.setPageController(pcb);
        dcis.getPageController();
        dcis.setKey('1');
        
        dcis.dcisPostId = pss.Id;
        dcis.saveDCIS(osp.Id); // method "saveDCIS()" 
        
        
        dcis.dcisPostId = pss.Id;
        dcis.dcisObj = dc;
        dcis.savePostDCIS(pss.Id); // method "savePostDCIS()"
        dcis.setObjId(pss.Id); 
        
        
    }
    @isTest static void myUnitTest1() {
        // TO DO: implement unit test
        
        DCISController dcis1 = new DCISController(); //else part line 20
        
        On_Study_Pathology_Form__c osp = new On_Study_Pathology_Form__c();
        osp.Does_the_patient_have_bilateral_breast_c__c = 'Yes';
        insert osp;
        
        Post_Surgaory_Summary__c pss = new Post_Surgaory_Summary__c();
        insert pss;
        
        DCIS__c dc = new DCIS__c();
        dc.On_Study_Pathology_Form__c = osp.Id;
        dc.Punctate_necrosis__c = true;
        dc.Comedonecrosis__c = true;
        dc.Papillary__c = true;
        dc.Micropapillary__c = true;
        dc.Necrosis__c = true;
        dc.Cribiform__c = true;
        dc.Cruciform__c = true;
        dc.Clinging__c = true;
        dc.Solid__c = true;
        dc.Apocrine__c = true;
        dc.Intra_cystic_encysted_papillary__c = true;
        dc.Other__c = true;
        insert dc;
        
        DCIS__c dc1 = new DCIS__c();
        dc1.Post_Surgery_Summary__c = pss.Id;
        dc1.Punctate_necrosis__c = true;
        dc1.Comedonecrosis__c = true;
        dc1.Papillary__c = true;
        dc1.Micropapillary__c = true;
        dc1.Necrosis__c = true;
        dc1.Cribiform__c = true;
        dc1.Cruciform__c = true;
        dc1.Clinging__c = true;
        dc1.Solid__c = true;
        dc1.Apocrine__c = true;
        dc1.Intra_cystic_encysted_papillary__c = true;
        dc1.Other__c = true;
        insert dc1;
        
        Apexpages.currentPage().getParameters().put('PathologyId',osp.Id);
        DCISController dcis = new DCISController();
       // dcis.dcisId = osp.Id;
        dcis.dcisPostId = pss.Id;
        dcis.saveDCIS(osp.Id); // method "saveDCIS()" 
        
        dcis.dcisPostId = pss.Id;
        dcis.dcisObj = dc;
        dcis.savePostDCIS(pss.Id); // method "savePostDCIS()" 
        dcis.setObjId(osp.Id);
    }
}