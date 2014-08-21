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
private class TestAssociateDccAndTrial {

    @isTest static void myUnitTest() {
        // TO DO: implement unit test
        
        List<RecordType> recInst = [select id,Name from RecordType where Name = 'DCC'];
        List<RecordType> recInst1 = [select id,Name from RecordType where Name = 'Institution'];
        User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
        System.runAs ( thisUser ) {
            Account acc = new Account();
            acc.Name = 'TestDCC';
            acc.RecordTypeId = recInst[0].Id;
            insert acc;
            
            Account acc1 = new Account();
            acc1.Name = 'TestIns';
            acc1.RecordTypeId = recInst1[0].Id;
            insert acc1;
            
            Account dcc = new Account();
            dcc.Name = 'TestIns';
            dcc.RecordTypeId = recInst[0].Id;
            insert dcc;
            
            Trial__c tri = new Trial__c();
            tri.Name = 'Test';
            insert tri;
            
            InstitutionTrial__c it = new InstitutionTrial__c();
            it.Institution_Id__c = acc1.Id;
            it.Trial_Id__c = tri.Id;
            insert it;
            
            InstitutionTrialDcc__c itd = new InstitutionTrialDcc__c();
            itd.Trial_Id__c = tri.Id;
            itd.Institution_Id__c = acc1.Id;
            itd.DCC_Id__c = dcc.Id;
            insert itd;
            
            Apexpages.currentPage().getParameters().put('institutionId',acc1.Id);
            AssociateDccAndTrial assDT = new AssociateDccAndTrial();
            AssociateDccAndTrial.wrapperClass wc = new AssociateDccAndTrial.wrapperClass();
            AssociateDccAndTrial.TrialWrapper tw = new AssociateDccAndTrial.TrialWrapper();
            wc.ischecked = true;
            //assDT.trialIdSet = tri.Id;
            Pagereference pr = assDT.submit();
        }
    }
}