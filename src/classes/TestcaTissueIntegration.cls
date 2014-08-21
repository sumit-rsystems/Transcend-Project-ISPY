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
private class TestcaTissueIntegration {

    @isTest static void myUnitTest() {
        // TO DO: implement unit test
        
        Account inst1 = new Account();
        inst1.Name = 'test';
        insert inst1;
        
        Trial__c tri = new Trial__c();
        tri.Name = 'testing test'; 
        insert tri;
        
        Patient_Custom__c p = new Patient_Custom__c();
        p.Birthdate__c = date.newInstance(1960, 8, 7);
        p.Institution__c = inst1.Id;
        p.Last_Name__c = 'test'; 
        p.Gender__c = 'Male';
        p.Race__c = 'White';
        p.Ethnicity__c = 'Not Hispanic or Latino';
        insert p;
        
        TrialPatient__c tp = new TrialPatient__c();
        tp.Patient_Id__c = p.Id;
        tp.Subject_Id__c = 'test';
        insert tp;
        
        TissueSpecimenDetail__c ts = new TissueSpecimenDetail__c();
        ts.Patient__c = p.Id;
        ts.TrialPatient__c = tp.Id;
        ts.ProcedureDate__c = date.newInstance(2012, 8, 10);
        ts.Time_Point__c = 'Pre-treatment';
        ts.NumberOfSamplesCollected__c = 1.0;
        insert ts;
        
        Core_Biopsy_Specimens__c cb = new Core_Biopsy_Specimens__c();
        cb.SpecimenID__c = '1111';
        cb.TissueSpecimenDetail__c = ts.Id;
        insert cb;
        
        caTissueTempStorage__c tempObj = new caTissueTempStorage__c();
        tempObj.IsProcessed__c = false;
        tempObj.TrialPatient__c = tp.Id;
        insert tempObj;
        
        List<CronTrigger> lstCronTrigger = [select Id from CronTrigger ];
        
        Set<Id> tIds = new Set<Id>();
        tIds.add(tp.Id);
        
        caTissueIntegration caObject = new caTissueIntegration();
        
        caTissueIntegration.deleteJob(lstCronTrigger[0].Id);
        
        caObject.callcaTissueService(tp.Id, 'createSpecimen',lstCronTrigger[0].Id);
        caTissueIntegration.createSpecimen_FutureCall(tp.Id,lstCronTrigger[0].Id);
       // caTissueIntegration.callCaTissue(lstCronTrigger[0].Id, 'createParticipant'); //Future method cannot be called from a future method
        caTissueIntegration.processCaTissueRecords(tIds);
        
        caObject.postCaTissueProcess(tp.Id, 'createSpecimen', 'success', lstCronTrigger[0].Id);
        caObject.executeCreateParticipantFromTestingPage();
        
    }
    @isTest static void myUnitTest1() {
        // TO DO: implement unit test
        
        Account inst1 = new Account();
        inst1.Name = 'test';
        insert inst1;
        
        Code_Master__c snomedObject = new Code_Master__c();
        snomedObject.Variable_Description__c = 'test';
        snomedObject.IsReportColumn__c = true;
        snomedObject.Display_Order__c = 3.0;
        snomedObject.Name = 'Race';
        insert snomedObject;
        
        Trial__c tri = new Trial__c();
        tri.Name = 'testing test'; 
        insert tri;
        
        Patient_Custom__c p = new Patient_Custom__c();
        p.Birthdate__c = date.newInstance(1960, 8, 7);
        p.Institution__c = inst1.Id;
        p.Last_Name__c = 'test'; 
        p.Gender__c = 'Male';
        p.Race__c = 'White/Asian';    
        p.Ethnicity__c = 'Not Hispanic or Latino';
        insert p;
        
        TrialPatient__c tp = new TrialPatient__c();
        tp.Patient_Id__c = p.Id;
        tp.Subject_Id__c = 'test';
        insert tp;
        
        Registration__c reg = new Registration__c(); 
        reg.Patient__c = p.Id;
        reg.Trial__c = tri.Id;
        reg.Registration_Date__c = system.today();
        reg.TrialPatient__c = tp.Id;
        reg.Institution__c = inst1.Id;
        reg.IRB_Approval_Date__c = system.today();
        reg.HIPPA_Consent_Date__c = system.today();
        reg.Screening_Informed_Consent_Date__c = system.today();
        reg.Effective_Time__c = system.now();
        reg.ISPY2_Subject_Id__c = ''+123;  
        insert reg; 
        
        Snomed_Code__c snomed = new Snomed_Code__c();
        snomed.TrialPatient__c = reg.TrialPatient__c;
        snomed.Code_Master__c = snomedObject.Id;
        insert snomed;   
        
        caTissueTempStorage__c tempObj = new caTissueTempStorage__c();
        tempObj.IsProcessed__c = false;
        tempObj.TrialPatient__c = tp.Id;
        insert tempObj; 
        
        List<CronTrigger> lstCronTrigger = [select Id from CronTrigger ];    
        
        caTissueIntegration caObject = new caTissueIntegration(); 
        
        caObject.callcaTissueService(tp.Id, 'createParticipant',lstCronTrigger[0].Id);
        system.debug('reg.TrialPatient__c : '+reg.TrialPatient__c);
        caTissueIntegration.createParticipant_FutureCall(reg.TrialPatient__c,lstCronTrigger[0].Id); 
       // caTissueIntegration.callCaTissue(lstCronTrigger[0].Id, 'createSpecimen'); // Future method cannot be called from a future method
        caObject.postCaTissueProcess(tp.Id, 'createParticipant', 'success', lstCronTrigger[0].Id); 
        
        List<Registration__c> lstRegistration = [Select r.TrialPatient__c, r.TrialPatient__r.Subject_Id__c, r.Patient__r.Race__c, r.Patient__r.Last_Name__c, r.Patient__r.Ethnicity__c, r.Patient__c From Registration__c r order by LastModifiedDate desc limit 1];
        if(!lstRegistration.isEmpty()) {
            caObject.getBusinessMsgPayloadXML(lstRegistration[0]);
            
        } 
    }
}