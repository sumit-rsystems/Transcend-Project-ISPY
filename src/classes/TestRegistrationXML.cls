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
private class TestRegistrationXML {

    @isTest static void myUnitTest() {
        // TO DO: implement unit test
        
        CRFMaster__c crfobject = new CRFMaster__c();
        crfobject.Object_Name__c = 'Registration__c';
        insert crfobject;
        
        XML_Configuration__c xmlObject = new XML_Configuration__c();
        xmlObject.CRF_Type__c = crfobject.Id;
        xmlObject.Object_API_Name__c = 'Patient_Custom__c';
        xmlObject.Field_API_Name__c = 'First_Name__c';
        insert xmlObject;
        
        XML_Configuration__c xmlObject1 = new XML_Configuration__c();
        xmlObject1.CRF_Type__c = crfobject.Id;
        xmlObject1.Object_API_Name__c = 'Patient_Custom__c';
        xmlObject1.Field_API_Name__c = 'Race__c';
        insert xmlObject1;
        
        XML_Configuration__c xmlObject2 = new XML_Configuration__c();
        xmlObject2.CRF_Type__c = crfobject.Id;
        xmlObject2.Object_API_Name__c = 'Patient_Custom__c';
        xmlObject2.Field_API_Name__c = 'SSN__c';
        insert xmlObject2;
        
        XML_Configuration__c xmlObject3 = new XML_Configuration__c();
        xmlObject3.CRF_Type__c = crfobject.Id;
        xmlObject3.Object_API_Name__c = 'Registration__c';
        xmlObject3.Field_API_Name__c = 'ISPY2_Subject_Id__c';
        insert xmlObject3;
        
        RegistrationXML regObject = new RegistrationXML();
        regObject.saveConfiguration(); 
        }
      }