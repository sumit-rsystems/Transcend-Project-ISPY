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
private class TestInvasiveTumor {

    @isTest static void myUnitTest() {
        // TO DO: implement unit test
        
        
        InvasiveTumor invTum1 = new InvasiveTumor(); // else part line 23
        
        On_Study_Pathology_Form__c osp = new On_Study_Pathology_Form__c();
        osp.Does_the_patient_have_bilateral_breast_c__c = 'Yes';
        insert osp;
        
        Invasive_Tumor_Detail__c objITD = new Invasive_Tumor_Detail__c();
        objITD.Nuclear_Grade__c = 'Grade II (Intermediate)';
        objITD.Mitotic_Count__c = '1pt';
        objITD.Tubule_Papilla_formation__c = '1pt'; 
        objITD.On_Study_Pathology_Form__c = osp.Id;
        insert objITD;
        
        Post_Surgaory_Summary__c pss = new Post_Surgaory_Summary__c();
        insert pss;
        
        LCIS__c lc = new LCIS__c();
        lc.Post_Surgery_Summary__c = pss.Id;
        insert lc;
        
        ComponentControllerBase ccb = new ComponentControllerBase(); // VIRTUAL CLASS "ComponentControllerBase"
        ccb.key = '1';
        
        PageControllerBase pcb = new PageControllerBase();   // VIRTUAL CLASS "PageControllerBase" BEGINS HERE
        pcb.getComponentControllerMap(); // "get"
        pcb.getIvtComponentController(); // "get"
        pcb.getThis();
        
        pcb.setComponentControllerMap('1', ccb);        // "set"
        pcb.setIvtComponentController(ccb);           // "set" and VIRTUAL CLASS "PageControllerBase" ENDS HERE
        
        Apexpages.currentPage().getParameters().put('PathologyId',osp.Id);
        Apexpages.currentPage().getParameters().put('postid',pss.Id);
        InvasiveTumor invTum = new InvasiveTumor();
        
        invTum.getKey();
        invTum.setPageController(pcb);
        invTum.getPageController();
        invTum.setKey('1');
        
        
        invTum.objITD = objITD;
       // invTum.invasiveId = osp.Id;
        invTum.invasivePostId = pss.Id;
        invTum.saveInvasiveTumor(osp.Id);
        //invTum.sumGrade();
        invTum.savePostInvasiveTumor(pss.Id);
        invTum.setObjId(pss.Id);
    }
    @isTest static void myUnitTest1() {
        // TO DO: implement unit test
        
        InvasiveTumor invTum1 = new InvasiveTumor(); // else part line 23
        
        On_Study_Pathology_Form__c osp = new On_Study_Pathology_Form__c();
        osp.Does_the_patient_have_bilateral_breast_c__c = 'Yes';
        insert osp;
        
        Post_Surgaory_Summary__c pss = new Post_Surgaory_Summary__c();
        insert pss;
        
        Invasive_Tumor_Detail__c objITD = new Invasive_Tumor_Detail__c();
        objITD.Nuclear_Grade__c = 'Grade II (Intermediate)';
        objITD.Mitotic_Count__c = '1pt';
        objITD.Tubule_Papilla_formation__c = '1pt'; 
        objITD.On_Study_Pathology_Form__c = osp.Id;
        insert objITD;
        
        Invasive_Tumor_Detail__c objITD1 = new Invasive_Tumor_Detail__c();
        objITD1.Nuclear_Grade__c = 'Grade II (Intermediate)';
        objITD1.Mitotic_Count__c = '1pt';
        objITD1.Tubule_Papilla_formation__c = '1pt'; 
        objITD1.Post_Surgery_Summary__c = pss.Id;
        insert objITD1;
        
        LCIS__c lc = new LCIS__c();
        lc.Post_Surgery_Summary__c = pss.Id;
        insert lc;
        
       Apexpages.currentPage().getParameters().put('PathologyId',osp.Id);
        InvasiveTumor invTum = new InvasiveTumor();
        invTum.objITD = objITD;
       // invTum.invasiveId = osp.Id;
        invTum.invasivePostId = pss.Id;
        invTum.saveInvasiveTumor(osp.Id);
        //invTum.sumGrade();
        invTum.savePostInvasiveTumor(pss.Id);
        invTum.setObjId(osp.Id);
    }
}