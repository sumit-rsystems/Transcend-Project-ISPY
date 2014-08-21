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
private class TestRescheduleEvent {

    @isTest static void myUnitTest() {
        
        List<User> thisUser = [Select u.IsActive, u.Id ,u.Patient_Id__c,u.ProfileId,u.Username From User u where IsActive = true];   
        System.runAs (thisUser[0]) { 
              
        Proposed_Rescheduling__c prObject = new Proposed_Rescheduling__c();
        prObject.studyStaff__c = thisUser[0].Id;
        prObject.DurationInMinutes__c = 300;
        prObject.StartDateTime__c = system.now();
        prObject.EndDate__c = system.now().addDays(2);
        prObject.Reschedule_reason__c = 'test';
        prObject.Proposed_New_Date__c = system.now();
        insert prObject; 
        
        Apexpages.currentPage().getParameters().put('propRecordId',prObject.Id);    
        RescheduleEvent resched = new RescheduleEvent();
        
        resched.propObj = prObject;
        resched.propReschId = prObject.Id;
        resched.reschuldeEvent();
        resched.rescheduleEventCreation();
    }
  }
  @isTest static void myUnitTest1() {
        
        List<User> thisUser = [Select u.IsActive, u.Id ,u.Patient_Id__c,u.ProfileId,u.Username From User u where IsActive = true];   
        System.runAs (thisUser[0]) { 
              
        Proposed_Rescheduling__c prObject = new Proposed_Rescheduling__c();
        prObject.studyStaff__c = thisUser[0].Id;
        prObject.DurationInMinutes__c = 300;
        prObject.StartDateTime__c = system.now();
        prObject.EndDate__c = system.now().addDays(2);
        prObject.Reschedule_reason__c = 'test';
        prObject.Proposed_New_Date__c = system.now();
        insert prObject; 
        
        Proposed_Rescheduling__c prObject1 = new Proposed_Rescheduling__c();
        prObject1.studyStaff__c = thisUser[0].Id;
        prObject1.DurationInMinutes__c = 300;
        prObject1.StartDateTime__c = system.now();
        prObject1.EndDate__c = system.now().addDays(2);
        prObject1.Reschedule_reason__c = 'test';
        prObject1.Proposed_New_Date__c = system.now();
        insert prObject1; 
        
        Apexpages.currentPage().getParameters().put('propRecordId',prObject.Id);    
        ApexPages.currentPage().getParameters().put('refId',prObject1.Id);      
        RescheduleEvent resched = new RescheduleEvent();
        
        resched.propObj = prObject;
        resched.propReschId = prObject.Id;
        resched.refId = prObject1.Id;
        resched.reschuldeEvent();
        resched.rescheduleEventCreation();
        
    }
  }
}