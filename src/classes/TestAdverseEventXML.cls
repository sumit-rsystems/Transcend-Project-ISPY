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
private class TestAdverseEventXML {

   
      @isTest static void myUnitTest() { 
        // TO DO: implement unit test
        
        AE_Detail__c aedObject = new AE_Detail__c();
        insert aedObject;
        
        BaselineSymptomsForm__c bsfObject = new BaselineSymptomsForm__c();
        insert bsfObject;
        
        BaselineCondition__c bcObject = new BaselineCondition__c();
        bcObject.BaselineSymptomsForm__c = bsfObject.Id;
        insert bcObject;
        
        Toxicity__c toxObject = new Toxicity__c();
        toxObject.AE_Detail__c = aedObject.Id;
        toxObject.Baseline_Symptoms_Form__c = bsfObject.Id;
        insert toxObject;
        
        CRFMaster__c crfobject = new CRFMaster__c();
        crfobject.Object_Name__c = 'AE_Detail__c';
        insert crfobject;
        
        CRFMaster__c crfobject1 = new CRFMaster__c();
        crfobject1.Object_Name__c = 'BaselineSymptomsForm__c';
        insert crfobject1;
        
        XML_Configuration__c xmlObject = new XML_Configuration__c();
        xmlObject.Object_API_Name__c = 'AE_Detail__c';
        xmlObject.Field_API_Name__c = 'Visit_Date__c';
        insert xmlObject;
        
        XML_Configuration__c xmlObject1 = new XML_Configuration__c();
        xmlObject1.Object_API_Name__c = 'BaselineSymptomsForm__c';
        xmlObject1.Field_API_Name__c = 'Patient_Hospitalized__c';
        insert xmlObject1;
        
        XML_Configuration__c xmlObject2 = new XML_Configuration__c();
        xmlObject2.Object_API_Name__c = 'Toxicity__c';
        xmlObject2.Field_API_Name__c = 'caAERS_report_filed__c';
        insert xmlObject2;
        
        XML_Configuration__c xmlObject3 = new XML_Configuration__c();
        xmlObject3.CRF_Type__c = crfobject1.Id;
        xmlObject3.Object_API_Name__c = 'BaselineSymptomsForm__c';
        xmlObject3.Field_API_Name__c = 'Symptom_Masters__c';
        insert xmlObject3;
        
        XML_Configuration__c xmlObject4 = new XML_Configuration__c();
        xmlObject4.CRF_Type__c = crfobject1.Id;
        xmlObject4.Object_API_Name__c = 'BaselineSymptomsForm__c';
        xmlObject4.Field_API_Name__c = 'Name,Toxicity_Other__c';
        insert xmlObject4;
        
        XML_Configuration__c xmlObject5 = new XML_Configuration__c();
        xmlObject5.CRF_Type__c = crfobject1.Id;
        xmlObject5.Object_API_Name__c = 'BaselineSymptomsForm__c';
        xmlObject5.Field_API_Name__c = 'Grade__c';
        insert xmlObject5;
        
        XML_Configuration__c xmlObject6 = new XML_Configuration__c();
        xmlObject6.CRF_Type__c = crfobject1.Id;
        xmlObject6.Object_API_Name__c = 'BaselineSymptomsForm__c';
        xmlObject6.Field_API_Name__c = 'Attribution__c';
        insert xmlObject6;
        
        XML_Configuration__c xmlObject7 = new XML_Configuration__c();
        xmlObject7.CRF_Type__c = crfobject1.Id;
        xmlObject7.Object_API_Name__c = 'BaselineSymptomsForm__c';
        xmlObject7.Field_API_Name__c = 'Symptom_Status__c';
        insert xmlObject7;
        
        XML_Configuration__c xmlObject8 = new XML_Configuration__c();
        xmlObject8.CRF_Type__c = crfobject1.Id;
        xmlObject8.Object_API_Name__c = 'BaselineSymptomsForm__c';
        xmlObject8.Field_API_Name__c = 'Was_event_life_threatning__c';
        insert xmlObject8;
        
        XML_Configuration__c xmlObject9 = new XML_Configuration__c();
        xmlObject9.CRF_Type__c = crfobject1.Id;
        xmlObject9.Object_API_Name__c = 'BaselineSymptomsForm__c';
        xmlObject9.Field_API_Name__c = 'Toxicity_Status__c';
        insert xmlObject9;
        
        XML_Configuration__c xmlObject10 = new XML_Configuration__c();
        xmlObject10.CRF_Type__c = crfobject1.Id;
        xmlObject10.Object_API_Name__c = 'BaselineSymptomsForm__c';
        xmlObject10.Field_API_Name__c = 'Result_conginental_abnormality_defect__c';
        insert xmlObject10;
        
        XML_Configuration__c xmlObject11 = new XML_Configuration__c();
        xmlObject11.CRF_Type__c = crfobject1.Id;
        xmlObject11.Object_API_Name__c = 'BaselineSymptomsForm__c';
        xmlObject11.Field_API_Name__c = 'Resolved__c';
        insert xmlObject11;
        
        XML_Configuration__c xmlObject12 = new XML_Configuration__c();
        xmlObject12.CRF_Type__c = crfobject1.Id;
        xmlObject12.Object_API_Name__c = 'BaselineSymptomsForm__c';
        xmlObject12.Field_API_Name__c = 'Patient_Complaint__c';
        insert xmlObject12;
        
        XML_Configuration__c xmlObject13 = new XML_Configuration__c();
        xmlObject13.CRF_Type__c = crfobject1.Id;
        xmlObject13.Object_API_Name__c = 'BaselineSymptomsForm__c';
        xmlObject13.Field_API_Name__c = 'Did_the_investigator_find_event_unusual__c';
        insert xmlObject13;
        
        XML_Configuration__c xmlObject14 = new XML_Configuration__c();
        xmlObject14.CRF_Type__c = crfobject1.Id;
        xmlObject14.Object_API_Name__c = 'BaselineSymptomsForm__c';
        xmlObject14.Field_API_Name__c = 'Did_event_result_in_death__c';
        insert xmlObject14;
        
        XML_Configuration__c xmlObject15 = new XML_Configuration__c();
        xmlObject15.CRF_Type__c = crfobject1.Id;
        xmlObject15.Object_API_Name__c = 'BaselineSymptomsForm__c';
        xmlObject15.Field_API_Name__c = 'Did_event_required_hospitalization__c';
        insert xmlObject15;
        
        XML_Configuration__c xmlObject16 = new XML_Configuration__c();
        xmlObject16.CRF_Type__c = crfobject1.Id;
        xmlObject16.Object_API_Name__c = 'BaselineSymptomsForm__c';
        xmlObject16.Field_API_Name__c = 'SAE__c';
        insert xmlObject16;
        
        XML_Configuration__c xmlObject17 = new XML_Configuration__c();
        xmlObject17.CRF_Type__c = crfobject1.Id;
        xmlObject17.Object_API_Name__c = 'BaselineSymptomsForm__c';
        xmlObject17.Field_API_Name__c = 'Onset_Date__c';
        insert xmlObject17;
        
        XML_Configuration__c xmlObject18 = new XML_Configuration__c();
        xmlObject18.CRF_Type__c = crfobject1.Id;
        xmlObject18.Object_API_Name__c = 'BaselineSymptomsForm__c';
        xmlObject18.Field_API_Name__c = 'AE_End_Date__c';
        insert xmlObject18;
        
        XML_Configuration__c xmlObject19 = new XML_Configuration__c();
        xmlObject19.CRF_Type__c = crfobject.Id;
        xmlObject19.Object_API_Name__c = 'AE_Detail__c';
        xmlObject19.Field_API_Name__c = 'Symptom_Masters__c';
        insert xmlObject19;
        
        XML_Configuration__c xmlObject20 = new XML_Configuration__c();
        xmlObject20.CRF_Type__c = crfobject.Id;
        xmlObject20.Object_API_Name__c = 'AE_Detail__c';
        xmlObject20.Field_API_Name__c = 'Name,Toxicity_Other__c';
        insert xmlObject20;
        
        XML_Configuration__c xmlObject21 = new XML_Configuration__c();
        xmlObject21.CRF_Type__c = crfobject.Id;
        xmlObject21.Object_API_Name__c = 'AE_Detail__c';
        xmlObject21.Field_API_Name__c = 'Grade__c';
        insert xmlObject21;
        
        XML_Configuration__c xmlObject22 = new XML_Configuration__c();
        xmlObject22.CRF_Type__c = crfobject.Id;
        xmlObject22.Object_API_Name__c = 'AE_Detail__c';
        xmlObject22.Field_API_Name__c = 'Attribution__c';
        insert xmlObject22;
        
        XML_Configuration__c xmlObject23 = new XML_Configuration__c();
        xmlObject23.CRF_Type__c = crfobject.Id;
        xmlObject23.Object_API_Name__c = 'AE_Detail__c';
        xmlObject23.Field_API_Name__c = 'Symptom_Status__c';
        insert xmlObject23;
        
        XML_Configuration__c xmlObject24 = new XML_Configuration__c();
        xmlObject24.CRF_Type__c = crfobject.Id;
        xmlObject24.Object_API_Name__c = 'AE_Detail__c';
        xmlObject24.Field_API_Name__c = 'Was_event_life_threatning__c';
        insert xmlObject24;
        
        XML_Configuration__c xmlObject25 = new XML_Configuration__c();
        xmlObject25.CRF_Type__c = crfobject.Id;
        xmlObject25.Object_API_Name__c = 'AE_Detail__c';
        xmlObject25.Field_API_Name__c = 'Toxicity_Status__c';
        insert xmlObject25;
        
        XML_Configuration__c xmlObject26 = new XML_Configuration__c();
        xmlObject26.CRF_Type__c = crfobject.Id;
        xmlObject26.Object_API_Name__c = 'AE_Detail__c';
        xmlObject26.Field_API_Name__c = 'Result_conginental_abnormality_defect__c';
        insert xmlObject26;
        
        XML_Configuration__c xmlObject27 = new XML_Configuration__c();
        xmlObject27.CRF_Type__c = crfobject.Id;
        xmlObject27.Object_API_Name__c = 'AE_Detail__c';
        xmlObject27.Field_API_Name__c = 'Resolved__c';
        insert xmlObject27;
        
        XML_Configuration__c xmlObject28 = new XML_Configuration__c();
        xmlObject28.CRF_Type__c = crfobject.Id;
        xmlObject28.Object_API_Name__c = 'AE_Detail__c';
        xmlObject28.Field_API_Name__c = 'Patient_Complaint__c';
        insert xmlObject28;
        
        XML_Configuration__c xmlObject29 = new XML_Configuration__c();
        xmlObject29.CRF_Type__c = crfobject.Id;
        xmlObject29.Object_API_Name__c = 'AE_Detail__c';
        xmlObject29.Field_API_Name__c = 'Did_the_investigator_find_event_unusual__c';
        insert xmlObject29;
        
        XML_Configuration__c xmlObject30 = new XML_Configuration__c();
        xmlObject30.CRF_Type__c = crfobject.Id;
        xmlObject30.Object_API_Name__c = 'AE_Detail__c';
        xmlObject30.Field_API_Name__c = 'Did_event_result_in_death__c';
        insert xmlObject30;
        
        XML_Configuration__c xmlObject31 = new XML_Configuration__c();
        xmlObject31.CRF_Type__c = crfobject.Id;
        xmlObject31.Object_API_Name__c = 'AE_Detail__c';
        xmlObject31.Field_API_Name__c = 'Did_event_required_hospitalization__c';
        insert xmlObject31;
        
        XML_Configuration__c xmlObject32 = new XML_Configuration__c();
        xmlObject32.CRF_Type__c = crfobject.Id;
        xmlObject32.Object_API_Name__c = 'AE_Detail__c';
        xmlObject32.Field_API_Name__c = 'SAE__c';
        insert xmlObject32;
        
        XML_Configuration__c xmlObject33 = new XML_Configuration__c();
        xmlObject33.CRF_Type__c = crfobject.Id;
        xmlObject33.Object_API_Name__c = 'AE_Detail__c';
        xmlObject33.Field_API_Name__c = 'Onset_Date__c';
        insert xmlObject33;
        
        XML_Configuration__c xmlObject34 = new XML_Configuration__c();
        xmlObject34.CRF_Type__c = crfobject.Id;
        xmlObject34.Object_API_Name__c = 'AE_Detail__c';
        xmlObject34.Field_API_Name__c = 'AE_End_Date__c';
        insert xmlObject34;
        
        AdverseEventXML aeObject = new AdverseEventXML();
        aeObject.editCRF();
        aeObject.saveConfiguration();
    }
}