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
private class TestInvasiveTumorDetailBeforeTrigger {

    @isTest static void myUnitTest() {
        // TO DO: implement unit test
        
        Code_Master__c snomedObject = new Code_Master__c();
        snomedObject.Variable_Description__c = 'test';
        snomedObject.IsReportColumn__c = true;
        snomedObject.Display_Order__c = 3.0;
        snomedObject.Name = 'LVI_PS';
        insert snomedObject;
        
        Snomed_Code__c snomed = new Snomed_Code__c();
        snomed.Code_Master__c = snomedObject.Id; 
        snomed.snomed_Code_Name__c = 'IHTSDO_4572';
        insert snomed;
        
        Post_Surgaory_Summary__c postObject = new Post_Surgaory_Summary__c();
        postObject.Type_Of_Tumor__c = 'Single Discrete Mass';
        insert postObject;
        
        On_Study_Pathology_Form__c studyObject = new On_Study_Pathology_Form__c();
        studyObject.Tumor_laterality__c = 'Left';
        insert studyObject;
        
        Invasive_Tumor_Detail__c objITD = new Invasive_Tumor_Detail__c();
        objITD.Post_Surgery_Summary__c = postObject.Id;
        objITD.On_Study_Pathology_Form__c = studyObject.Id;
        objITD.Multi_focal_Tumor__c = 'Yes';
        insert objITD;
        update objITD;
        
    }
    
    @isTest static void myUnitTest1() {
        //=====================if condition line 98 and 212=============================
        
        Code_Master__c snomedObject1 = new Code_Master__c();
        snomedObject1.Variable_Description__c = 'test';
        snomedObject1.IsReportColumn__c = true;
        snomedObject1.Display_Order__c = 3.0;
        snomedObject1.Name = 'InvMultifocal_PS';
        insert snomedObject1;
        
        Snomed_Code__c snomed1 = new Snomed_Code__c();
        snomed1.Code_Master__c = snomedObject1.Id; 
        snomed1.snomed_Code_Name__c = 'IHTSDO_4570';
        insert snomed1;
        
        Post_Surgaory_Summary__c postObject1 = new Post_Surgaory_Summary__c();
        postObject1.Type_Of_Tumor__c = 'Single Discrete Mass';
        insert postObject1;
        
        On_Study_Pathology_Form__c studyObject1 = new On_Study_Pathology_Form__c();
        studyObject1.Tumor_laterality__c = 'Left';
        insert studyObject1;
        
        Invasive_Tumor_Detail__c objITD1 = new Invasive_Tumor_Detail__c();
        objITD1.Post_Surgery_Summary__c = postObject1.Id;
        objITD1.On_Study_Pathology_Form__c = studyObject1.Id;
        objITD1.Multi_focal_Tumor__c = 'Yes';
        insert objITD1;
        update objITD1;
    }
    
    @isTest static void myUnitTest2() {
        //=======================if condition line 110 and 218 ==========================
        
        Code_Master__c snomedObject2 = new Code_Master__c();
        snomedObject2.Variable_Description__c = 'test';
        snomedObject2.IsReportColumn__c = true;
        snomedObject2.Display_Order__c = 3.0;
        snomedObject2.Name = 'Surgery_Br';                       // was causing error so had to chnage the name 
        insert snomedObject2;
        
        Snomed_Code__c snomed2 = new Snomed_Code__c();
        snomed2.Code_Master__c = snomedObject2.Id; 
        snomed2.snomed_Code_Name__c = '396631001';
        insert snomed2;
        
        Post_Surgaory_Summary__c postObject2 = new Post_Surgaory_Summary__c();
        postObject2.Type_Of_Tumor__c = 'Single Discrete Mass';
        insert postObject2;
        
        On_Study_Pathology_Form__c studyObject2 = new On_Study_Pathology_Form__c();
        studyObject2.Tumor_laterality__c = 'Left';
        insert studyObject2;
        
        DCIS__c dcisObject = new DCIS__c();
        dcisObject.Post_Surgery_Summary__c = postObject2.Id;
        insert dcisObject;
        
        Procedure__c proObj = new Procedure__c();
        proObj.Post_Surgery_Summary__c = postObject2.Id;
        insert proObj;
        
        Invasive_Tumor_Detail__c objITD2 = new Invasive_Tumor_Detail__c();
        objITD2.Post_Surgery_Summary__c = postObject2.Id;
        objITD2.On_Study_Pathology_Form__c = studyObject2.Id;
        objITD2.Multi_focal_Tumor__c = 'Yes';
        insert objITD2;
        update objITD2;
    }
    
    @isTest static void myUnitTest3() {
        //==========================if condition line 132 and 233===========================================
        
        Code_Master__c snomedObject3 = new Code_Master__c();
        snomedObject3.Variable_Description__c = 'test';
        snomedObject3.IsReportColumn__c = true;
        snomedObject3.Display_Order__c = 3.0;
        snomedObject3.Name = 'InvHistology_PS';
        insert snomedObject3;
        
        Snomed_Code__c snomed3 = new Snomed_Code__c();
        snomed3.Code_Master__c = snomedObject3.Id; 
        snomed3.snomed_Code_Name__c = '396984004';
        insert snomed3;
        
        Post_Surgaory_Summary__c postObject3 = new Post_Surgaory_Summary__c();
        postObject3.Type_Of_Tumor__c = 'Single Discrete Mass';
        insert postObject3;
        
        On_Study_Pathology_Form__c studyObject3 = new On_Study_Pathology_Form__c();
        studyObject3.Tumor_laterality__c = 'Left';
        insert studyObject3;
        
        Invasive_Tumor_Detail__c objITD3 = new Invasive_Tumor_Detail__c();
        objITD3.Post_Surgery_Summary__c = postObject3.Id;
        objITD3.On_Study_Pathology_Form__c = studyObject3.Id;
        objITD3.Multi_focal_Tumor__c = 'Yes';
        insert objITD3;
        update objITD3;
    }
    
    @isTest static void myUnitTest4() {
        //==========================if condition line 159 and 252 =============================================
        
        Code_Master__c snomedObject4 = new Code_Master__c();
        snomedObject4.Variable_Description__c = 'test';
        snomedObject4.IsReportColumn__c = true;
        snomedObject4.Display_Order__c = 3.0;
        snomedObject4.Name = 'InvHistology_OSInvasive';
        insert snomedObject4;
        
        Snomed_Code__c snomed4 = new Snomed_Code__c();
        snomed4.Code_Master__c = snomedObject4.Id; 
        snomed4.snomed_Code_Name__c = '396785008';
        insert snomed4;
        
        Post_Surgaory_Summary__c postObject4 = new Post_Surgaory_Summary__c();
        postObject4.Type_Of_Tumor__c = 'Single Discrete Mass';
        insert postObject4;
        
        On_Study_Pathology_Form__c studyObject4 = new On_Study_Pathology_Form__c();
        studyObject4.Tumor_laterality__c = 'Left';
        insert studyObject4;
        
        Invasive_Tumor_Detail__c objITD4 = new Invasive_Tumor_Detail__c();
        objITD4.Post_Surgery_Summary__c = postObject4.Id;
        objITD4.On_Study_Pathology_Form__c = studyObject4.Id;
        objITD4.Multi_focal_Tumor__c = 'Yes';
        insert objITD4;
        update objITD4;
    }
    
    @isTest static void myUnitTest5() {
        //============================if condition line 171 and 258==============================================
        
        Code_Master__c snomedObject5 = new Code_Master__c();
        snomedObject5.Variable_Description__c = 'test';
        snomedObject5.IsReportColumn__c = true;
        snomedObject5.Display_Order__c = 3.0;
        snomedObject5.Name = 'InvSBR_OS';
        insert snomedObject5;
        
        Snomed_Code__c snomed5 = new Snomed_Code__c();
        snomed5.Code_Master__c = snomedObject5.Id; 
        snomed5.snomed_Code_Name__c = '371469007';
        insert snomed5;
        
        Post_Surgaory_Summary__c postObject5 = new Post_Surgaory_Summary__c();
        postObject5.Type_Of_Tumor__c = 'Single Discrete Mass';
        insert postObject5;
        
        On_Study_Pathology_Form__c studyObject5 = new On_Study_Pathology_Form__c();
        studyObject5.Tumor_laterality__c = 'Left';
        insert studyObject5;
        
        Invasive_Tumor_Detail__c objITD5 = new Invasive_Tumor_Detail__c();
        objITD5.Post_Surgery_Summary__c = postObject5.Id;
        objITD5.On_Study_Pathology_Form__c = studyObject5.Id;
        objITD5.Multi_focal_Tumor__c = 'Yes';
        insert objITD5;
        update objITD5;
    }
}