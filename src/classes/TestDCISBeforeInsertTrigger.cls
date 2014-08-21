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
private class TestDCISBeforeInsertTrigger {

    @isTest static void myUnitTest() {
        // TO DO: implement unit test
        
        Code_Master__c snomedObject = new Code_Master__c();
        snomedObject.Variable_Description__c = 'test';
        snomedObject.IsReportColumn__c = true;
        snomedObject.Display_Order__c = 3.0;
        snomedObject.Name = 'DCISGrade_PS';
        insert snomedObject;
        
        Snomed_Code__c snomed = new Snomed_Code__c();
        snomed.Code_Master__c = snomedObject.Id;
        snomed.snomed_Code_Name__c = '396984004';
        insert snomed;
        
        Post_Surgaory_Summary__c postObject = new Post_Surgaory_Summary__c();
        postObject.Type_Of_Tumor__c = 'Single Discrete Mass';
        insert postObject;
        
        DCIS__c dcisObject = new DCIS__c();
        dcisObject.Post_Surgery_Summary__c = postObject.Id;
        dcisObject.Punctate_necrosis__c = true;
        insert dcisObject;
        update dcisObject;
        
    }
    
    @isTest static void myUnitTest1() {
        //============================IF CONDITION" line 88 and 230 providing NAME of snomed-master and snomed-code=========================
        
        Code_Master__c snomedObject1 = new Code_Master__c();
        snomedObject1.Variable_Description__c = 'test';
        snomedObject1.IsReportColumn__c = true;
        snomedObject1.Display_Order__c = 3.0;
        snomedObject1.Name = 'InvHistology_PS';
        insert snomedObject1;
        
        Snomed_Code__c snomed1 = new Snomed_Code__c();
        snomed1.Code_Master__c = snomedObject1.Id;
        snomed1.snomed_Code_Name__c = 'IHTSDO_4678';
        insert snomed1;
        
        Post_Surgaory_Summary__c postObject1 = new Post_Surgaory_Summary__c();
        postObject1.Type_Of_Tumor__c = 'Single Discrete Mass';
        insert postObject1;
        
        DCIS__c dcisObject1 = new DCIS__c();
        dcisObject1.Post_Surgery_Summary__c = postObject1.Id;
        dcisObject1.Punctate_necrosis__c = true;
        insert dcisObject1;
        update dcisObject1;
    }
    
    @isTest static void myUnitTest2() {
        //============================IF CONDITION" line 100 and 236 and 239 providing NAME of snomed-master and snomed-code=========================
         
        Code_Master__c snomedObject2 = new Code_Master__c();
        snomedObject2.Variable_Description__c = 'test';
        snomedObject2.IsReportColumn__c = true;
        snomedObject2.Display_Order__c = 3.0;
        snomedObject2.Name = 'Surgery_Br';
        insert snomedObject2;
        
        Snomed_Code__c snomed2 = new Snomed_Code__c();
        snomed2.Code_Master__c = snomedObject2.Id;
        snomed2.snomed_Code_Name__c = '396631001';
        insert snomed2;
        
        Post_Surgaory_Summary__c postObject2 = new Post_Surgaory_Summary__c();
        postObject2.Type_Of_Tumor__c = 'Single Discrete Mass';
        insert postObject2;
        
        Invasive_Tumor_Detail__c objITD = new Invasive_Tumor_Detail__c();
        objITD.Post_Surgery_Summary__c = postObject2.Id;
        insert objITD;
        
        Procedure__c proObj = new Procedure__c();
        proObj.Post_Surgery_Summary__c = postObject2.Id;
        insert proObj;
        
        DCIS__c dcisObject2 = new DCIS__c();
        dcisObject2.Post_Surgery_Summary__c = postObject2.Id;
        dcisObject2.Punctate_necrosis__c = true;
        dcisObject2.Comedonecrosis__c = true;
        dcisObject2.Papillary__c = true;
        dcisObject2.Micropapillary__c = true;
        dcisObject2.Necrosis__c = true;
        dcisObject2.Cribiform__c = true;
        dcisObject2.Cruciform__c = true;
        dcisObject2.Clinging__c = true;
        dcisObject2.Solid__c = true;
        dcisObject2.Apocrine__c = true;
        dcisObject2.Intra_cystic_encysted_papillary__c = true;
        dcisObject2.Other__c = true;
        insert dcisObject2;
        update dcisObject2;
    }
    
    @isTest static void myUnitTest3() {
        //============================IF CONDITION" line 173 providing NAME of snomed-master and snomed-code=========================
         
        Code_Master__c snomedObject3 = new Code_Master__c();
        snomedObject3.Variable_Description__c = 'test';
        snomedObject3.IsReportColumn__c = true;
        snomedObject3.Display_Order__c = 3.0;
        snomedObject3.Name = 'InvMargin_PS';
        insert snomedObject3;
        
        Code_Master__c snomedObject2 = new Code_Master__c();
        snomedObject2.Variable_Description__c = 'test';
        snomedObject2.IsReportColumn__c = true;
        snomedObject2.Display_Order__c = 3.0;
        snomedObject2.Name = 'Surgery_Br';
        insert snomedObject2;
        
        Snomed_Code__c snomed3 = new Snomed_Code__c();
        snomed3.Code_Master__c = snomedObject3.Id;
        snomed3.snomed_Code_Name__c = '396631001';
        insert snomed3;
        
        Post_Surgaory_Summary__c postObject3 = new Post_Surgaory_Summary__c();
        postObject3.Type_Of_Tumor__c = 'Single Discrete Mass';
        insert postObject3;
        
        Invasive_Tumor_Detail__c objITD1 = new Invasive_Tumor_Detail__c();
        objITD1.Post_Surgery_Summary__c = postObject3.Id;
        insert objITD1;
        
        Procedure__c proObj1 = new Procedure__c();
        proObj1.Post_Surgery_Summary__c = postObject3.Id;
        insert proObj1;
        
        DCIS__c dcisObject3 = new DCIS__c();
        dcisObject3.Post_Surgery_Summary__c = postObject3.Id;
        insert dcisObject3;
        update dcisObject3;
    }
    
    @isTest static void myUnitTest4() {
        //===================IF CONDITION LINE 161========================================================
        
        Code_Master__c snomedObject4 = new Code_Master__c();
        snomedObject4.Variable_Description__c = 'test';
        snomedObject4.IsReportColumn__c = true;
        snomedObject4.Display_Order__c = 3.0;
        snomedObject4.Name = 'DCISspan_PS';
        insert snomedObject4;
        
        Snomed_Code__c snomed4 = new Snomed_Code__c();
        snomed4.Code_Master__c = snomedObject4.Id;
        snomed4.snomed_Code_Name__c = '396631001';
        insert snomed4;
        
        Post_Surgaory_Summary__c postObject4 = new Post_Surgaory_Summary__c();
        postObject4.Type_Of_Tumor__c = 'Single Discrete Mass';
        insert postObject4;
        
        DCIS__c dcisObject4 = new DCIS__c();
        dcisObject4.Post_Surgery_Summary__c = postObject4.Id;
        insert dcisObject4;
        update dcisObject4;
    }
}