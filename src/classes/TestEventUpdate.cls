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
private class TestEventUpdate {

    @isTest static void myUnitTest() { 
        
        List<User> thisUser = [Select u.IsActive, u.Id ,u.Patient_Id__c,u.ProfileId,u.Username From User u where IsActive = true and Username != null];   
        
        System.runAs (thisUser[0]) {   
            
        List<RecordType> recordT = [Select r.Name, r.Id From RecordType r where sObjectType = 'Account' and Name='Institution' order by Name];
        
        Account accObj = new Account();
        accObj.Name = 'test Institute 1';
        accObj.RecordTypeId = recordT[0].Id;
        insert accObj; 
        
        Trial__c tr = new Trial__c();
        tr.Name = 'test';
        insert tr;
        
        Patient_Custom__c patObj = new Patient_Custom__c();
        patObj.Birthdate__c = date.newInstance(1960, 8, 7);
        patObj.Ethnicity__c = 'Hispanic or latino';
        patObj.Gender__c = 'female';
        patObj.Race__c = 'asian';
        patObj.First_Name__c = 'test';
        patObj.Last_Name__c = 'kumar';
        patObj.Institution__c = accObj.Id;
        patObj.Email__c = thisUser[0].Username;
        insert patObj;
            
        Messaging.InboundEmail email = new Messaging.InboundEmail();
        Messaging.InboundEnvelope envelope = new Messaging.InboundEnvelope();
        
        system.debug('patObj.Email__c : '+patObj.Email__c);
        envelope.toAddress = patObj.Email__c;
        email.subject = 'test';
        email.plainTextBody = 'Accept';
        envelope.fromAddress = '7.bhupesh@gmail.com';
        
        
        Event eventObject = new Event();
        eventObject.Trial__c = tr.Id;
        eventObject.ActivityDateTime = system.now();
        eventObject.WhatId = accObj.Id;
        eventObject.OwnerId = thisUser[0].Id;
        eventObject.Subject = 'test';
        eventObject.DurationInMinutes = 300;
        eventObject.Hours__c = null;
        eventObject.Minutes__c = null;
        eventObject.StartDateTime = eventObject.ActivityDateTime;
        insert eventObject;
        update eventObject;
        
        Proposed_Rescheduling__c prObject = new Proposed_Rescheduling__c();
        prObject.Eventid__c = eventObject.Id;
        prObject.Proposed_New_Date__c = eventObject.ActivityDateTime;
        prObject.OwnerId = thisUser[0].Id;
        prObject.PatientId__c = patObj.Id;
        prObject.studyStaff__c = thisUser[0].Id;
        prObject.DurationInMinutes__c = 300;
        prObject.StartDateTime__c = eventObject.ActivityDateTime;
        prObject.refId__c = email.subject;
        insert prObject;
        
        EventUpdate euObject = new EventUpdate();
        euObject.handleInboundEmail(email, envelope); 
      }
   }
   @isTest static void myUnitTest1() { // SATISFY "ELSE" CONDITION LINE 102
        
        List<User> thisUser = [Select u.IsActive, u.Id ,u.Patient_Id__c,u.ProfileId,u.Username From User u where IsActive = true and Username != null];   
        
        System.runAs (thisUser[0]) {   
            
        List<RecordType> recordT = [Select r.Name, r.Id From RecordType r where sObjectType = 'Account' and Name='Institution' order by Name];
        
        Account accObj = new Account();
        accObj.Name = 'test Institute 1';
        accObj.RecordTypeId = recordT[0].Id;
        insert accObj; 
        
        Trial__c tr = new Trial__c();
        tr.Name = 'test';
        insert tr;
        
        Patient_Custom__c patObj = new Patient_Custom__c();
        patObj.Birthdate__c = date.newInstance(1960, 8, 7);
        patObj.Ethnicity__c = 'Hispanic or latino';
        patObj.Gender__c = 'female';
        patObj.Race__c = 'asian';
        patObj.First_Name__c = 'test';
        patObj.Last_Name__c = 'kumar';
        patObj.Institution__c = accObj.Id;
        patObj.Email__c = thisUser[0].Username;
        insert patObj;
            
        Event eventObject = new Event();
        eventObject.Trial__c = tr.Id;
        eventObject.WhatId = accObj.Id;
        eventObject.OwnerId = thisUser[0].Id;
        eventObject.Subject = 'test';
        eventObject.DurationInMinutes = 300;
        eventObject.Hours__c = 2.0;
        eventObject.Minutes__c = 30.0;
        eventObject.StartDateTime = system.now();
        insert eventObject;
        update eventObject;
        
        system.debug('eventObject.Owner.UserName : '+eventObject.Owner.UserName);
        
        Messaging.InboundEmail email = new Messaging.InboundEmail();
        Messaging.InboundEnvelope envelope = new Messaging.InboundEnvelope();
        
        system.debug('patObj.Email__c : '+patObj.Email__c);
        envelope.toAddress = patObj.Email__c;
        email.subject = 'test';
        email.plainTextBody = 'Reject';                                                             // satisfy "else" part 
        envelope.fromAddress = '7.bhupesh@gmail.com';
        
        Proposed_Rescheduling__c prObject = new Proposed_Rescheduling__c();
        prObject.Eventid__c = eventObject.Id;
        prObject.OwnerId = thisUser[0].Id;
        prObject.PatientId__c = patObj.Id;
        prObject.studyStaff__c = thisUser[0].Id;
        prObject.DurationInMinutes__c = 300;
        prObject.StartDateTime__c = system.now();
        prObject.refId__c = email.subject;
        insert prObject;
        
        EventUpdate euObject = new EventUpdate();
        euObject.handleInboundEmail(email, envelope); 
      }
   }
}