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
private class TestLabandTestCRFEventComponent {

    @isTest static void myUnitTest() {
        // TO DO: implement unit test
        List<User> thisUser = [Select u.IsActive, u.Id From User u where id =: userinfo.getUserId() and IsActive = true ];
        system.runAs(thisUser[0]) {
        
        Account acc = new Account(); 
        acc.Name = 'test';
        insert acc;
        
        Patient_Custom__c p = new Patient_Custom__c();
        p.Ethnicity__c = 'Hispanic or latino';
        p.Gender__c = 'female';
        p.Race__c = 'asian;indian';
        p.Last_Name__c = 'kumar';
        p.Status__c = 'approval not required';
        p.Birthdate__c = date.newInstance(1950, 08, 05);
        p.Institution__c = acc.Id;
        insert p;
        
        Trial__c t1 = new Trial__c();
        t1.Name = 'tets';
        insert t1;
        
        TrialPatient__c tp = new TrialPatient__c();
        tp.Patient_Id__c = p.Id;
        tp.Trial_Id__c = t1.Id;
        insert tp;
        
        Lab_and_Test__c lt=new Lab_and_Test__c();
        lt.TrialPatient__c=tp.Id;
        insert lt;
        
        List<Sobject> list1 = [Select Id, CreatedById, originalCRF__c From Lab_and_Test__c ];
        
        List<ProcessInstance> approvalHistory = [Select p.TargetObjectId, p.Status, (Select Id,StepStatus From StepsAndWorkitems where StepStatus != 'Started' order by CreatedDate ) From ProcessInstance p where TargetObjectId =:lt.Id];
            
        LabandTestCRFEventComponentController crfevent = new LabandTestCRFEventComponentController();                
        
        crfevent.objectName = 'Lab_and_Test__c';
        crfevent.recordId = lt.Id;
        crfevent.setWrapCrfList(crfevent.getWrapCrfList());
        
      }
   }
}