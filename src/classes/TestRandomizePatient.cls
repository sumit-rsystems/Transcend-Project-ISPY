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
private class TestRandomizePatient {

    @isTest static void myUnitTest() {
        List<RandomizePatient.CRFStatusWrapper> lstCRFStatusWrapper = new List<RandomizePatient.CRFStatusWrapper>();
        RandomizePatient.CRFStatusWrapper crfStatusWrapper = new RandomizePatient.CRFStatusWrapper();
        crfStatusWrapper.CRFType = 'MRI Volume Form';
        crfStatusWrapper.IsSubmitted = 'Yes';
        crfStatusWrapper.IsApproved = 'Yes';
        lstCRFStatusWrapper.add(crfStatusWrapper);
        
        crfStatusWrapper = new RandomizePatient.CRFStatusWrapper();
        crfStatusWrapper.CRFType = 'On Study Pathology Form';
        crfStatusWrapper.IsSubmitted = 'Yes';
        crfStatusWrapper.IsApproved = 'Yes';
        lstCRFStatusWrapper.add(crfStatusWrapper);
        
        crfStatusWrapper = new RandomizePatient.CRFStatusWrapper();
        crfStatusWrapper.CRFType = 'On Study Eligibility Form';
        crfStatusWrapper.IsSubmitted = 'Yes';
        crfStatusWrapper.IsApproved = 'Yes';
        lstCRFStatusWrapper.add(crfStatusWrapper);
        
        crfStatusWrapper = new RandomizePatient.CRFStatusWrapper();
        crfStatusWrapper.CRFType = 'MammaPrint Form';
        crfStatusWrapper.IsSubmitted = 'Yes';
        crfStatusWrapper.IsApproved = 'Yes';
        lstCRFStatusWrapper.add(crfStatusWrapper);
        
        RandomizePatient.RandomizationEligibilityData red = new RandomizePatient.RandomizationEligibilityData();
        
        red.crfStatusList = lstCRFStatusWrapper;
        red.h1h2Status = 'H1';
        red.erStatus = 'Positive';
        red.prStatus = 'Positive';
        red.HER2Status = 'Positive';
        red.MammaPrintRisk = 'High Risk';
        red.ICH_HER2_Status = 'Positive';
        red.FISH_HER2_Status = 'Positive';
        red.targetPrintHer2Status = 'Negative';
        red.isAllOSECheckboxesChecked = true; 
        
        ///String str = RandomizePatient.checkPatientEligibilityForRandomization(red);
        //system.assert(str == 'SUCCESS');
        
        red.crfStatusList = lstCRFStatusWrapper;
        red.h1h2Status = 'H1';
        red.erStatus = 'Negative';
        red.prStatus = 'Negative';
        red.HER2Status = 'Negative';
        red.MammaPrintRisk = 'Low Risk';
        red.ICH_HER2_Status = 'Negative';
        red.FISH_HER2_Status = 'Positive';
        red.targetPrintHer2Status = 'Negative';
        red.isAllOSECheckboxesChecked = false;
        
        //str = RandomizePatient.checkPatientEligibilityForRandomization(red);
        
        lstCRFStatusWrapper.clear();
        
        RandomizePatient.CRFStatusWrapper crfStatusWrapper1 = new RandomizePatient.CRFStatusWrapper();
        crfStatusWrapper1.CRFType = 'MRI Volume Form';
        crfStatusWrapper1.IsSubmitted = 'No';
        crfStatusWrapper1.IsApproved = 'No';
        lstCRFStatusWrapper.add(crfStatusWrapper1);
        
        crfStatusWrapper1 = new RandomizePatient.CRFStatusWrapper();
        crfStatusWrapper1.CRFType = 'On Study Pathology Form';
        crfStatusWrapper1.IsSubmitted = 'No';
        crfStatusWrapper1.IsApproved = 'No';
        lstCRFStatusWrapper.add(crfStatusWrapper1);
        
        crfStatusWrapper1 = new RandomizePatient.CRFStatusWrapper();
        crfStatusWrapper1.CRFType = 'On Study Eligibility Form';
        crfStatusWrapper1.IsSubmitted = 'No';
        crfStatusWrapper1.IsApproved = 'No';
        lstCRFStatusWrapper.add(crfStatusWrapper1);
        
        crfStatusWrapper1 = new RandomizePatient.CRFStatusWrapper();
        crfStatusWrapper1.CRFType = 'MammaPrint Form';
        crfStatusWrapper1.IsSubmitted = 'No';
        crfStatusWrapper1.IsApproved = 'No';
        lstCRFStatusWrapper.add(crfStatusWrapper1);
        
        red.crfStatusList.clear();
        red.crfStatusList = lstCRFStatusWrapper;
        for(RandomizePatient.CRFStatusWrapper rcrf: red.crfStatusList) {
            system.debug('rcrf:'+rcrf);
        }
        //str = RandomizePatient.checkPatientEligibilityForRandomization(red);
        //system.assert(str != 'SUCCESS');
        
        red.crfStatusList = lstCRFStatusWrapper;
        red.h1h2Status = 'Undetermined';
        red.erStatus = 'Negative';
        red.prStatus = 'Negative';
        red.HER2Status = 'Negative';
        red.MammaPrintRisk = 'Low Risk';
        red.ICH_HER2_Status = 'Not Reported';
        red.FISH_HER2_Status = 'Not Reported';
        red.targetPrintHer2Status = 'Not Reported';
        red.isAllOSECheckboxesChecked = false;
        
        //str = RandomizePatient.checkPatientEligibilityForRandomization(red);
        
        
        RandomizePatient.RandomizationProperties rp = new RandomizePatient.RandomizationProperties();
        rp.nSeed1 = 100;
        rp.nSeed2 = 200;
        rp.engineURL = 'http://11.1.1.1:8989';
        rp.runCalcResult = '';
        rp.currentPatientXML = '';
        
        RandomizePatient.RandomizationData rd = new RandomizePatient.RandomizationData();
        rd.subjectId = '23352';
        rd.startTime = 21324;
        rd.hr = 0;
        rd.her2 = 1;
        rd.mpValue = 1;
        rd.pcrOutcometime = 23211;
        rd.pcrOutcome = 1;
        rd.earlyTreatmentTime = 23211;
        rd.changeimMRIVolumeMonth2 = 0.3434;
        rd.interRegimenTime = 23211;
        rd.changeimMRIVolumeMonth4 = 0.3434;
        rd.preSurgeryTime = 23211;
        rd.changeimMRIVolumeMonth6 = 0.3434;
        
        //RandomizePatient.randomize(false, rp, rd);
        
        rp = new RandomizePatient.RandomizationProperties();
        rp.nSeed1 = -1;
        rp.nSeed2 = -1;
        rp.engineURL = null;
        rp.runCalcResult = '';
        rp.currentPatientXML = '';
        //RandomizePatient.randomize(false, rp, rd);
        
        //RandomizePatient.randomize(false, rp, rd);
        
        RandomizePatient.getRunCalculationXML(null, null);
        
        RandomizationProperty__c rprop = new RandomizationProperty__c ();
        rprop.CurrentPatientXML__c  = 'currpatxml';
        rprop.End_Point_URL__c = 'http://232.23.3.2';
        rprop.nSeed1__c = 100;
        rprop.nSeed2__c  =200;
        rprop.RunCalculationResult__c = 'runcalcresult';
        insert rprop;
        
        RandomizePatient.getRunCalculationXML('ISPY 2', 'abc');
    }
    
    @isTest static void myUnitTest1() {
        // TO DO: implement unit test
        
        List<User> thisUser = [ select u.Id , u.IsActive from User u where profile.Name = 'System Administrator' and IsActive = true];
        System.runAs (thisUser[0]){
            
        Account acc1 = new Account();

        List<Account> lstAccount = [select Id from Account where RecordType.Name = 'Institution']; 
            
        if(!lstAccount.isEmpty()){
                
        acc1 = lstAccount[0];           // newly added logic to overcome the error of "setup and nonsetup" object
        
        Site__c site1 = new Site__c();
        site1.Name = 'test site1';
        site1.Type__c = 'test type';
        site1.Institute__c = acc1.Id;
        insert site1;
        
        Trial__c trial1 = new Trial__c();
        trial1.Name='test Trial 1';
        insert trial1; 
        
        Patient_Custom__c pc = new Patient_Custom__c();
        pc.Last_Name__c = 'test';
        pc.Gender__c = 'Male';
        pc.Birthdate__c = date.newInstance(1984, 6, 7);
        pc.Race__c = 'White';
        pc.Ethnicity__c = 'Not Hispanic or Latino';
        pc.Institution__c = acc1.Id;
        insert pc;
        
        TrialPatient__c tp = new TrialPatient__c();
        tp.Patient_Id__c = pc.Id;
        tp.Trial_Id__c = trial1.Id;
        insert tp;
        
        Registration__c reg1 = new Registration__c();
        reg1.Patient__c = pc.Id;
        reg1.TrialPatient__c = tp.Id;
        reg1.Registration_Date__c = system.today();
        reg1.Trial__c = trial1.Id;
        reg1.Institution__c = acc1.Id;
        reg1.Site__c = site1.Id;
        reg1.IRB_Approval_Date__c = system.today();
        reg1.Screening_Informed_Consent_Date__c = system.today();
        reg1.HIPPA_Consent_Date__c = system.today();
        insert reg1; 
        
        RandomizationProperty__c rpc = new RandomizationProperty__c();
        rpc.nSeed1__c = 0.00;
        rpc.nSeed2__c = 0.00;
        insert rpc;
        
        Randomization_Form__c rfcObj = new Randomization_Form__c();
        rfcObj.TrialPatient__c = tp.Id;
        insert rfcObj;
        
        system.debug('___regList__'+reg1.TrialPatient__c);
        
        /*RandomizePatient rp = new RandomizePatient();
        
        rp.getRunCalcXML();
        rp.getdCurrentTime();
        rp.getRunCalculationResult();
        rp.getNSeed1();
        rp.getNSeed2();
        rp.getUserName();
        rp.getPassword();
        rp.getEndPointURL();
        
        rp.resBody = '<S:Envelope xmlns:S="http://schemas.xmlsoap.org/soap/envelope/">' +
                            '   <S:Body>' +
                            '      <RandomizeResponse xmlns="http://www.MDAnderson.org">' +
                            '         <RandomizeResult>0</RandomizeResult>' +
                            '         <nSeed1>100</nSeed1>' +
                            '         <nSeed2>100</nSeed2>' +
                            '         <strRandomizationResultsXML>' +
                            '               <![CDATA[<treatment>TEST TREATMENT 1 + TEST TREATMENT 2</treatment>]]>' +
                            '         </strRandomizationResultsXML>' +
                            '      </RandomizeResponse>' +
                            '   </S:Body>' +
                            '</S:Envelope>';
        
        rp.saveRandomizationResponse(rp.parseRandomizationResponse(rp.resBody),reg1.TrialPatient__c);*/
        
     }
    }
  }
}