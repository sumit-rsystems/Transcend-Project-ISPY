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
private class TestDeleteChildOnPostSurgery {

    @isTest static void myUnitTest() {
        // TO DO: implement unit test
        
        Post_Surgaory_Summary__c postObject = new Post_Surgaory_Summary__c();
        postObject.Type_Of_Tumor__c = 'Single Discrete Mass';
        insert postObject;
        
        DCIS__c dcisObject = new DCIS__c();
        dcisObject.Post_Surgery_Summary__c = postObject.Id;
        dcisObject.Punctate_necrosis__c = true;
        insert dcisObject;
        
        Invasive_Tumor_Detail__c objITD = new Invasive_Tumor_Detail__c();
        objITD.Post_Surgery_Summary__c = postObject.Id;
        insert objITD;
        
        Procedure__c proObj = new Procedure__c();
        proObj.Post_Surgery_Summary__c = postObject.Id;
        insert proObj;
        
        LCIS__c lcisObject = new LCIS__c();
        lcisObject.Post_Surgery_Summary__c = postObject.Id;
        insert lcisObject;
        
        Receptors__c recObject = new Receptors__c();
        recObject.Post_Surgery_Summary__c = postObject.Id;
        insert recObject;
        
        Staging_Detail__c stagObject = new Staging_Detail__c();
        stagObject.Post_Surgery_Summary__c = postObject.Id;
        insert stagObject;
        
        Lymph_Nodes__c lnObject = new Lymph_Nodes__c();
        lnObject.Procedure__c = proObj.Id;
        lnObject.Sentinel_Nodes__c = true;
        lnObject.Single_Detection_Result__c = true;
        lnObject.Positive__c = 2.0;
        lnObject.Examined__c = 3.0;
        insert lnObject;
        
        delete postObject;
        
        }
}