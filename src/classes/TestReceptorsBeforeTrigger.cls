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
private class TestReceptorsBeforeTrigger {

    @isTest static void myUnitTest() {
        // TO DO: implement unit test
            
            Code_Master__c snomedObject = new Code_Master__c();
            snomedObject.Variable_Description__c = 'test';
            snomedObject.IsReportColumn__c = true;
            snomedObject.Display_Order__c = 3.0;
            snomedObject.Name = 'ERstatus_PS';
            insert snomedObject;
            
            Code_Master__c snomedObject1 = new Code_Master__c();
            snomedObject1.Variable_Description__c = 'test';
            snomedObject1.IsReportColumn__c = true;
            snomedObject1.Display_Order__c = 3.0;
            snomedObject1.Name = 'ER_TS_OS';
            insert snomedObject1;
            
            Code_Master__c snomedObject2 = new Code_Master__c();
            snomedObject2.Variable_Description__c = 'test';
            snomedObject2.IsReportColumn__c = true;
            snomedObject2.Display_Order__c = 3.0;
            snomedObject2.Name = 'PgR_TS_OS';
            insert snomedObject2;
            
            Snomed_Code__c snomed = new Snomed_Code__c();
            snomed.Code_Master__c = snomedObject.Id;
            insert snomed;
            
            Post_Surgaory_Summary__c postObject = new Post_Surgaory_Summary__c();
            postObject.Type_Of_Tumor__c = 'Single Discrete Mass';
            insert postObject;
            
            On_Study_Pathology_Form__c studyObject = new On_Study_Pathology_Form__c();
            studyObject.Tumor_laterality__c = 'Left';
            insert studyObject;
                
            Receptors__c recObject = new Receptors__c();
            recObject.On_Study_Pathology_Form__c = studyObject.Id;
            recObject.Post_Surgery_Summary__c = postObject.Id;
            insert recObject;
            update recObject;
        
    }
}