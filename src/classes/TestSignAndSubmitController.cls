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
private class TestSignAndSubmitController {

    @isTest static void myUnitTest() {
        
        User thisUser = [ select Id,SecurityCode__c,Email,FirstName,LastName,Username from User where Id = :UserInfo.getUserId()];
        System.runAs ( thisUser ){
        
        Account acc = new Account();
            
            List<Account> lstAccount = [Select a.Id From Account a limit 1];
            
            if(!lstAccount.isEmpty()){
                
                acc = lstAccount[0];
                
                Patient_Custom__c pat = new Patient_Custom__c();
                pat.Race__c = 'Asian';
                pat.Institution__c = acc.Id;
                pat.First_Name__c = 'test3';
                pat.Last_Name__c = 'Test';
                pat.Gender__c = 'Female';
                pat.Ethnicity__c = 'Not Hispanic or Latino';
                pat.Birthdate__c = date.newInstance(1950, 7, 7); // this satisfy 'else' part , age>50
                insert pat;
                
                Trial__c tr = new Trial__c();
                tr.Name = 'test trial new';
                insert tr;
                
                TrialPatient__c tp = new TrialPatient__c();
                tp.Patient_Id__c = pat.Id;
                tp.Trial_Id__c = tr.Id;
                insert tp;
                
                CRFMaster__c crf = new CRFMaster__c();
                crf.CRFType__c = 'MammaPrint Form';
                crf.IsApprovalRequired__c = true ;
                crf.Object_Name__c = 'Registration__c';
            
                insert crf;
                update crf;
                system.debug('crf.Name : '+crf.Name);
                
                List<RecordType> lstRecordType = Database.query('select Id, Name from RecordType where sObjectType = \'Menopausal_Status_Detail__c\' and Name = \'Approval Pending\'');
                
                Menopausal_Status_Detail__c mono = new Menopausal_Status_Detail__c();
                mono.Status__c = 'Accepted';
                mono.Menopausal_Status__c = 'premenopausal';
                mono.Phase__c = 'screening';
                mono.RecordTypeId = lstRecordType[0].Id; 
                mono.TrialPatient__c = tp.Id;
                insert mono;
                
                PasswordManager pwm = new PasswordManager();
                String password =  PasswordManager.generatePassword();
                boolean isValidUser = PasswordManager.verifyPassword(Userinfo.getUserId(), thisUser.SecurityCode__c);
                
               
                blob blobKey = Encodingutil.base64Decode(thisUser.SecurityCode__c);
                String securityCode = EncodingUtil.convertToHex(blobKey);
                securityCode = securityCode.substring(0,8);
                
                
            /*  Account objAcc = new Account();
                objAcc.Name = 'test Acc';
                insert objAcc; */
                
                List<CRFMaster__c> lstCRFMaster = Database.query('select IsApprovalRequired__c,Name from CRFMaster__c where id = \''+ crf.id+'\' and IsApprovalRequired__c = false');
                String crfName = '';
                if(!lstCRFMaster.isEmpty()) {
                    crfName = lstCRFMaster[0].Name;
                
                }
                
                //system.debug('lstCRFMaster[0].Name : '+lstCRFMaster[0].Name);
                
                SignAndSubmitController signsubmit = new SignAndSubmitController();
                Apexpages.currentPage().getParameters().put('form_code',crfName);
                Apexpages.currentPage().getParameters().put('id',mono.Id);
                Apexpages.currentPage().getParameters().put('retURL','%2F'+mono.Id);
                signsubmit.password = securityCode;
                
                signsubmit.signAndSubmit(crfName, '%2F'+mono.Id, mono.Id,'Site');
                
                signsubmit.signAndSubmit();
                signsubmit.resendCode();
                signsubmit.errorMsg = 'Provide Msg';
                signsubmit.isErrorMsg = true;
                signsubmit.isCodeSent = false;
                
                Apexpages.currentPage().getParameters().put('retURL','');
                signsubmit.signAndSubmit();
            }
        }
    }
        @isTest static void myUnitTest1() {
        
        List<User> lstSiteUser = [Select u.IsActive, u.Id, u.SecurityCode__c From User u where IsActive = true and id =: userinfo.getUserId()];
        System.runAs ( lstSiteUser[0] ) { 
        
        Account acc = new Account();
            
            List<Account> lstAccount = [Select a.Id From Account a limit 1];
            
            if(!lstAccount.isEmpty()){
                
                acc = lstAccount[0];
                
                Patient_Custom__c pat = new Patient_Custom__c();
                pat.Race__c = 'Asian';
                pat.Institution__c = acc.Id;
                pat.First_Name__c = 'test3';
                pat.Last_Name__c = 'Test';
                pat.Gender__c = 'Female';
                pat.Ethnicity__c = 'Not Hispanic or Latino';
                pat.Birthdate__c = date.newInstance(1950, 7, 7); // this satisfy 'else' part , age>50
                insert pat;
                
                Trial__c tr = new Trial__c();
                tr.Name = 'test trial new';
                insert tr;
                
                TrialPatient__c tp = new TrialPatient__c();
                tp.Patient_Id__c = pat.Id;
                tp.Trial_Id__c = tr.Id;
                insert tp;  
                
                CRFMaster__c crf = new CRFMaster__c();
                crf.CRFType__c = 'MammaPrint Form';
                crf.IsApprovalRequired__c = true ;
                crf.Object_Name__c = 'Registration__c';
                insert crf;
                update crf;
                
                Menopausal_Status_Detail__c mono = new Menopausal_Status_Detail__c();
                mono.Status__c = 'Accepted';
                mono.Menopausal_Status__c = 'premenopausal';
                mono.Phase__c = 'screening';
                mono.TrialPatient__c = tp.Id;
                insert mono;
                
                PasswordManager pwm = new PasswordManager();
                String password =  PasswordManager.generatePassword();
                boolean isValidUser = PasswordManager.verifyPassword(Userinfo.getUserId(), lstSiteUser[0].SecurityCode__c);
                
               
                blob blobKey = Encodingutil.base64Decode(lstSiteUser[0].SecurityCode__c);
                String securityCode = EncodingUtil.convertToHex(blobKey);
                securityCode = securityCode.substring(0,8);
                
                List<CRFMaster__c> lstCRFMaster = Database.query('select IsApprovalRequired__c,Name from CRFMaster__c where id = \''+ crf.id+'\' and IsApprovalRequired__c = true');
                String crfName = '';
                if(!lstCRFMaster.isEmpty()) {
                    crfName = lstCRFMaster[0].Name;
                
                }
                
                SignAndSubmitController signsubmit = new SignAndSubmitController();
                Apexpages.currentPage().getParameters().put('form_code',crfName);
                Apexpages.currentPage().getParameters().put('id',mono.Id);
                Apexpages.currentPage().getParameters().put('retURL','%2F'+mono.Id);
                signsubmit.password = securityCode;
                
                signsubmit.signAndSubmit();
                signsubmit.signAndSubmit(crfName, '%2F'+mono.Id, mono.Id,'Site');
            }   
        }
     }
     @isTest static void myUnitTest2() {
        
        List<User> lstSiteUser = [Select u.IsActive, u.Id, u.SecurityCode__c From User u where IsActive = true and id =: userinfo.getUserId()];
        System.runAs ( lstSiteUser[0] ) { 
            
        Account inst1 = new Account();
        inst1.Name = 'test Institute 1';
        insert inst1; 
        
        Patient_Custom__c pc = new Patient_Custom__c();
        pc.First_Name__c = 'test';
        pc.Last_Name__c = 'test1';
        pc.Gender__c = 'Male';
        pc.Birthdate__c = date.newInstance(2000, 7, 7);
        pc.Race__c = 'White';
        pc.Ethnicity__c = 'Not Hispanic or Latino';
        pc.Medical_Record_Number__c = '3434';
        pc.Institution__c = inst1.Id;
        insert pc;
        
        TrialPatient__c triPat = new TrialPatient__c();
        triPat.Patient_Id__c = pc.Id;
        insert triPat;  
        
        CRFMaster__c crf = new CRFMaster__c();
        crf.CRFType__c = 'MammaPrint Form';
        crf.IsApprovalRequired__c = true ;
        crf.Object_Name__c = 'Registration__c';
        insert crf;
        update crf;
        
        SignAndSubmitController signsubmit = new SignAndSubmitController();
        Apexpages.currentPage().getParameters().put('form_code','00006');
        Apexpages.currentPage().getParameters().put('id',pc.Id);
        Apexpages.currentPage().getParameters().put('retURL','%2F'+pc.Id);
        
        signsubmit.signAndSubmit();
        signsubmit.signAndSubmit('00006', '%2F'+pc.Id, pc.Id,'Site');
        }
     }
  }