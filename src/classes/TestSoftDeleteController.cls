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
private class TestSoftDeleteController {

    @isTest static void myUnitTest() {
        // TO DO: implement unit test
        
        QuestionAnswer__c per_quesAns = new QuestionAnswer__c();
        per_quesAns.AnswerType__c = 'Boolean';
        per_quesAns.Question__c = 'test Question';
        per_quesAns.Type__c = 'Test';
        insert per_quesAns;
        
        Apexpages.currentPage().getParameters().put('keycode', String.valueOf(per_quesAns.Id).substring(0,3));
        Apexpages.currentPage().getParameters().put('object', 'QuestionAnswer__c');
        Apexpages.currentPage().getParameters().put('recId', per_quesAns.Id);
        
        SoftDeleteController sdc = new SoftDeleteController();
        sdc.deleteRecord();
    }
}