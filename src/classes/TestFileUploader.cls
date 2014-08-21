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
private class TestFileUploader {

    @isTest static void myUnitTest() {
        // TO DO: implement unit test
        
        FileUploader fu = new FileUploader();
        RandomizationTestingDetail__c r = new RandomizationTestingDetail__c();           
            r.Trial_Name__c = 'TRIAL';            
            insert r;
        
        fu.fileBody = Blob.valueOf('1,2,3,4,5,6,7,8,9,10,11,12,13,14\n1,2,3,4,5,6,7,8,9,10,11,12,13,14\n1,2,3,4,5,6,7,8,9,10,11,12,13,14');
        fu.fileName = 'test.csv';
        fu.uploadCSV();
        
        fu.fileBody = Blob.valueOf('1,2,3,4,05/05/2012,6,7,8,9,10,11,12,13,14\n1,2,3,4,05/05/2012,6,7,8,9,10,11,12,13,14\n1,2,3,4,05/05/2012,6,7,8,9,10,11,12,13,14');
        fu.fileName = 'test.csv';
        fu.uploadCSV();
        
        fu.fileBody = Blob.valueOf('1,2,3,,,7,8,9,10,11,12,13,14\n1,2,3,,,,7,8,9,10,11,12,13,14\n1,2,3,,,,7,8,9,10,11,12,13,14');
        fu.fileName = 'test.csv';
        fu.uploadCSV();
        
        fu.fileBody = Blob.valueOf('1,2,3,4,5,6,7\n1,2,3,4,5,6,7\n1,2,3,4,5,6,7');
        fu.fileName = 'test.csv';
        fu.uploadCSV();
        
        fu.fileBody = Encodingutil.base64Decode('sdfhkdskj');
        fu.fileName = 'test.csv';
        fu.uploadCSV();
        
        fu.fileName = 'test.xls';
        fu.uploadCSV();
        
        fu.fileName = 'test';
        fu.uploadCSV();
        
        fu.fileBody = Blob.valueOf('a');
        fu.fileName = 'test.csv';
        fu.uploadCSV();
    }
}