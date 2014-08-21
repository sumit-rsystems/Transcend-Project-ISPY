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
private class TestTrialSummaryReport {
    
       @isTest  static void myUnitTest() { // also covering "InsertCRFonNolongerLosttoFollowup"
        // TO DO: implement unit test
        List<User> thisUser = [ select u.Id , u.IsActive from User u where profile.Name = 'System Administrator' and IsActive = true];
        System.runAs (thisUser[0]){
            
            Account inst = new Account();
        
            List<Account> lstAccount = [select Id from Account limit 1]; 
                    
            if(!lstAccount.isEmpty()){
                        
                inst = lstAccount[0];           // newly added logic to overcome the error of "setup and nonsetup" object
                    
                List<RecordType> reclst = [Select r.SobjectType, r.Name, r.Id From RecordType r where SobjectType = 'Site__c' and Name = 'Site'];
                    
                Site__c site1 = new Site__c();
                site1.Name = 'test site1';
                site1.Type__c = 'test type';
                site1.Institute__c = inst.Id;
                site1.RecordTypeId = reclst[0].id;
                insert site1;
                
                Trial__c t = new Trial__c();
                t.Start_Date__c = system.today();
                insert t;
                
                /*Patient_Custom__c p = new Patient_Custom__c();
                p.Birthdate__c = date.newInstance(1960, 8, 7);
                p.Signed_Screening__c = true;
                p.Ethnicity__c = 'Hispanic or latino';
                p.Gender__c = 'female';
                p.Race__c = 'asian';
                p.Last_Name__c = 'kumar';
                p.Institute_Text__c = 'test inst';
                p.Institution__c = inst.Id;
                insert p;
                    
                TrialPatient__c tpObject = new TrialPatient__c();
                tpObject.Patient_Id__c = p.Id;
                tpObject.Trial_Id__c = t.Id;
                insert tpObject;
                
                Registration__c reg = new Registration__c();
                reg.Patient__c = p.Id;
                reg.Registration_Date__c = System.today();
                reg.Trial__c = t.Id;
                reg.Institution__c = inst.Id;
                reg.Site__c = site1.Id;
                reg.IRB_Approval_Date__c = System.today();
                reg.Screening_Informed_Consent_Date__c = System.today();
                reg.HIPPA_Consent_Date__c = System.today();
              //  reg.ACRIN_6693_MRS_Participant__c = 'Yes';
                reg.TrialPatient__c = tpObject.Id;
                reg.Status__c = 'Approval Not Required';
                reg.Effective_Time__c = system.now();
                reg.ISPY2_Subject_Id__c = ''+123;
                insert reg;
                    
                //update reg;
                
                //List<Registration__c> regList = [select TrialPatient__c from Registration__c where Id =:reg.Id order by LastModifiedDate desc limit 1];
                
                Randomization_Form__c rfc = new Randomization_Form__c();
                rfc.TrialPatient__c = tpObject.Id;
                rfc.Did_Patient_Sign_Treatment_Consent_Form__c = true;
                rfc.Randomization_Result__c = 'Randomized';
                rfc.Status__c = 'Approval Not Required';
                insert rfc;
                
                //update rfc;
                
                PreEligibility_Checklist__c preObj = new PreEligibility_Checklist__c();
                preObj.Patient__c = p.Id;
                preObj.Cytotoxic_Regiments__c = false;
                preObj.ECOG_Score__c = '5-Death';
                preObj.Status__c = 'Approval Not Required';
                insert preObj;
                
                //update preObj;
                
                Post_Surgaory_Summary__c pss = new Post_Surgaory_Summary__c();
                pss.Date_Of_Procedure__c = system.today();
                pss.TrialPatient__c = tpObject.Id;
                insert pss;
                    
                Off_Study_Detail__c offObject = new Off_Study_Detail__c();
                offObject.TrialPatient__c = tpObject.Id;
                offObject.Patient_completed_study_per_protocol__c = true;
                insert offObject;
                
                Followup_Form__c followObject = new Followup_Form__c(); 
                followObject.TrialPatient__c = tpObject.Id;
                insert followObject;*/
                
                //No_Longer_lost_to_Followup__c nlObject = new No_Longer_lost_to_Followup__c();
                //nlObject.TrialPatient__c = tpObject.Id;
                //nlObject.Status__c = 'Accepted';
                //insert nlObject;
                //nlObject.Status__c = 'Completed';
                //update nlObject;
                
                //Lost_to_Follow_Up__c lostObject = new Lost_to_Follow_Up__c();
                ///lostObject.TrialPatient__c = tpObject.Id;
                //lostObject.Status__c = 'Accepted';
                //insert lostObject;
                //lostObject.Status__c = 'Accepted';
                //update lostObject;
                
                ApexPages.currentPage().getParameters().put('trialId', t.Id);
                ApexPages.currentPage().getParameters().put('asOfDate','2015-01-09');
                TrialSummaryReport tsr = new TrialSummaryReport();
                
                Site_Trial__c  pbj = new Site_Trial__c ();
                pbj.Trial__c=t.Id;
                pbj .Site__c=site1.Id;
                insert pbj ;
                
                
                
            }
        }
    }
  
    @isTest static void myUnitTest2() {
        List<User> thisUser = [ select u.Id , u.IsActive from User u where profile.Name = 'System Administrator' and IsActive = true];
        System.runAs (thisUser[0]){
            
            Account inst = new Account();
        
            List<Account> lstAccount = [select Id from Account limit 1]; 
                    
            if(!lstAccount.isEmpty()){
                        
                inst = lstAccount[0];           // newly added logic to overcome the error of "setup and nonsetup" object
                    
                List<RecordType> reclst = [Select r.SobjectType, r.Name, r.Id From RecordType r where SobjectType = 'Site__c' and Name = 'Site'];
                    
                Site__c site1 = new Site__c();
                site1.Name = 'test site1';
                site1.Type__c = 'test type';
                site1.Institute__c = inst.Id;
                site1.RecordTypeId = reclst[0].id;
                insert site1;
                
                Trial__c t = new Trial__c();
                t.Start_Date__c = system.today();
                insert t;
                
                Patient_Custom__c p = new Patient_Custom__c();
                p.Birthdate__c = date.newInstance(1960, 8, 7);
                p.Signed_Screening__c = true;
                p.Ethnicity__c = 'Hispanic or latino';
                p.Gender__c = 'female';
                p.Race__c = 'asian';
                p.Last_Name__c = 'kumar';
                p.Institute_Text__c = 'test inst';
                p.Institution__c = inst.Id;
                insert p;
                    
                TrialPatient__c tpObject = new TrialPatient__c();
                tpObject.Patient_Id__c = p.Id;
                tpObject.Trial_Id__c = t.Id;
                insert tpObject;
                
                Registration__c reg = new Registration__c();
                reg.Patient__c = p.Id;
                reg.Registration_Date__c = System.today();
                reg.Trial__c = t.Id;
                reg.Institution__c = inst.Id;
                reg.Site__c = site1.Id;
                reg.IRB_Approval_Date__c = System.today();
                reg.Screening_Informed_Consent_Date__c = System.today();
                reg.HIPPA_Consent_Date__c = System.today();
              //  reg.ACRIN_6693_MRS_Participant__c = 'Yes';
                reg.TrialPatient__c = tpObject.Id;
                reg.Status__c = 'Approval Not Required';
                reg.Effective_Time__c = system.now();
                reg.ISPY2_Subject_Id__c = ''+123;
                insert reg;
                    
                //update reg;
                
                //List<Registration__c> regList = [select TrialPatient__c from Registration__c where Id =:reg.Id order by LastModifiedDate desc limit 1];
                
                //Randomization_Form__c rfc = new Randomization_Form__c();
                //rfc.TrialPatient__c = tpObject.Id;
                //rfc.Did_Patient_Sign_Treatment_Consent_Form__c = true;
                //rfc.Randomization_Result__c = 'Randomized';
                //rfc.Status__c = 'Approval Not Required';
                //insert rfc;
                
                //update rfc;
                
                //PreEligibility_Checklist__c preObj = new PreEligibility_Checklist__c();
                //preObj.Patient__c = p.Id;
                //preObj.Cytotoxic_Regiments__c = false;
                //preObj.ECOG_Score__c = '5-Death';
                //preObj.Status__c = 'Approval Not Required';
                //insert preObj;
                
                //update preObj;
                
                //Post_Surgaory_Summary__c pss = new Post_Surgaory_Summary__c();
                //pss.Date_Of_Procedure__c = system.today();
                //pss.TrialPatient__c = tpObject.Id;
                //insert pss;
                    
                //Off_Study_Detail__c offObject = new Off_Study_Detail__c();
                //offObject.TrialPatient__c = tpObject.Id;
                //offObject.Patient_completed_study_per_protocol__c = true;
                //insert offObject;
                
                //Followup_Form__c followObject = new Followup_Form__c(); 
                //followObject.TrialPatient__c = tpObject.Id;
                //insert followObject;
                
                /*No_Longer_lost_to_Followup__c nlObject = new No_Longer_lost_to_Followup__c();
                nlObject.TrialPatient__c = tpObject.Id;
                nlObject.Status__c = 'Not Completed';
                insert nlObject;
                //nlObject.Status__c = 'Completed';
                //update nlObject;
                
                Lost_to_Follow_Up__c lostObject = new Lost_to_Follow_Up__c();
                lostObject.TrialPatient__c = tpObject.Id;
                lostObject.Status__c = 'Accepted';
                insert lostObject;
                /*lostObject.Status__c = 'Accepted';
                update lostObject;*/
                
                ApexPages.currentPage().getParameters().put('trialId', t.Id);
                ApexPages.currentPage().getParameters().put('asOfDate','2015-01-09');
                TrialSummaryReport tsr = new TrialSummaryReport();
                tsr.prepareAccrualSummaryForAll();
                tsr.viewHTML();
                tsr.viewPdf();
                tsr.viewCSV();
            }
        }
    }
    
    @isTest static void myUnitTest3() {
        List<User> thisUser = [ select u.Id ,u.IsActive from User u where profile.Name = 'System Administrator' and IsActive = true];
        System.runAs (thisUser[0]){
            
            Account inst = new Account();
        
            List<Account> lstAccount = [select Id from Account limit 1]; 
                    
            if(!lstAccount.isEmpty()){
                        
                inst = lstAccount[0];           // newly added logic to overcome the error of "setup and nonsetup" object
                    
                List<RecordType> reclst = [Select r.SobjectType, r.Name, r.Id From RecordType r where SobjectType = 'Site__c' and Name = 'Site'];
                    
                Site__c site1 = new Site__c();
                site1.Name = 'test site1';
                site1.Type__c = 'test type';
                site1.Institute__c = inst.Id;
                site1.RecordTypeId = reclst[0].id;
                insert site1;
                
                Trial__c t = new Trial__c();
                t.Start_Date__c = system.today();
                insert t;
                
                Patient_Custom__c p = new Patient_Custom__c();
                p.Birthdate__c = date.newInstance(1960, 8, 7);
                p.Signed_Screening__c = true;
                p.Ethnicity__c = 'Hispanic or latino';
                p.Gender__c = 'female';
                p.Race__c = 'asian';
                p.Last_Name__c = 'kumar';
                p.Institute_Text__c = 'test inst';
                p.Institution__c = inst.Id;
                insert p;
                    
                TrialPatient__c tpObject = new TrialPatient__c();
                tpObject.Patient_Id__c = p.Id;
                tpObject.Trial_Id__c = t.Id;
                insert tpObject;
                
                Registration__c reg = new Registration__c();
                reg.Patient__c = p.Id;
                reg.Registration_Date__c = System.today();
                reg.Trial__c = t.Id;
                reg.Institution__c = inst.Id;
                reg.Site__c = site1.Id;
                reg.IRB_Approval_Date__c = System.today();
                reg.Screening_Informed_Consent_Date__c = System.today();
                reg.HIPPA_Consent_Date__c = System.today();
              //  reg.ACRIN_6693_MRS_Participant__c = 'Yes';
                reg.TrialPatient__c = tpObject.Id;
                reg.Status__c = 'Approval Not Required';
                reg.Effective_Time__c = system.now();
                reg.ISPY2_Subject_Id__c = ''+123;
                insert reg;
                    
                //update reg;
                
                //List<Registration__c> regList = [select TrialPatient__c from Registration__c where Id =:reg.Id order by LastModifiedDate desc limit 1];
                
                Randomization_Form__c rfc = new Randomization_Form__c();
                rfc.TrialPatient__c = tpObject.Id;
                rfc.Did_Patient_Sign_Treatment_Consent_Form__c = true;
                rfc.Randomization_Result__c = 'Randomized';
                rfc.Status__c = 'Approval Not Required';
                insert rfc;
                
                //update rfc;
                
                PreEligibility_Checklist__c preObj = new PreEligibility_Checklist__c();
                preObj.Patient__c = p.Id;
                preObj.Cytotoxic_Regiments__c = false;
                preObj.ECOG_Score__c = '5-Death';
                preObj.Status__c = 'Approval Not Required';
                insert preObj;
                
                //update preObj;
                
                /*Post_Surgaory_Summary__c pss = new Post_Surgaory_Summary__c();
                pss.Date_Of_Procedure__c = system.today();
                pss.TrialPatient__c = tpObject.Id;
                insert pss;
                    
                Off_Study_Detail__c offObject = new Off_Study_Detail__c();
                offObject.TrialPatient__c = tpObject.Id;
                offObject.Patient_completed_study_per_protocol__c = true;
                insert offObject;
                
                Followup_Form__c followObject = new Followup_Form__c(); 
                followObject.TrialPatient__c = tpObject.Id;
                insert followObject;*/
                
                /*No_Longer_lost_to_Followup__c nlObject = new No_Longer_lost_to_Followup__c();
                nlObject.TrialPatient__c = tpObject.Id;
                nlObject.Status__c = 'Not Completed';
                insert nlObject;
                //nlObject.Status__c = 'Completed';
                //update nlObject;
                
                Lost_to_Follow_Up__c lostObject = new Lost_to_Follow_Up__c();
                lostObject.TrialPatient__c = tpObject.Id;
                lostObject.Status__c = 'Accepted';
                insert lostObject;
                /*lostObject.Status__c = 'Accepted';
                update lostObject;*/
                
                ApexPages.currentPage().getParameters().put('trialId', t.Id);
                ApexPages.currentPage().getParameters().put('asOfDate','2015-01-09');
                TrialSummaryReport tsr = new TrialSummaryReport();
                tsr.prepareDataEnrolledByMonthForAll();
            }
        }
    }
    
    @isTest static void myUnitTest4() {
        List<User> thisUser = [ select u.Id , u.IsActive from User u where profile.Name = 'System Administrator' and IsActive = true];
        System.runAs (thisUser[0]){
            
            Account inst = new Account();
        
            List<Account> lstAccount = [select Id from Account limit 1]; 
                    
            if(!lstAccount.isEmpty()){
                        
                inst = lstAccount[0];           // newly added logic to overcome the error of "setup and nonsetup" object
                    
                List<RecordType> reclst = [Select r.SobjectType, r.Name, r.Id From RecordType r where SobjectType = 'Site__c' and Name = 'Site'];
                    
                Site__c site1 = new Site__c();
                site1.Name = 'test site1';
                site1.Type__c = 'test type';
                site1.Institute__c = inst.Id;
                site1.RecordTypeId = reclst[0].id;
                insert site1;
                
                Trial__c t = new Trial__c();
                t.Start_Date__c = system.today();
                insert t;
                
                Patient_Custom__c p = new Patient_Custom__c();
                p.Birthdate__c = date.newInstance(1960, 8, 7);
                p.Signed_Screening__c = true;
                p.Ethnicity__c = 'Hispanic or latino';
                p.Gender__c = 'female';
                p.Race__c = 'asian';
                p.Last_Name__c = 'kumar';
                p.Institute_Text__c = 'test inst';
                p.Institution__c = inst.Id;
                insert p;
                    
                TrialPatient__c tpObject = new TrialPatient__c();
                tpObject.Patient_Id__c = p.Id;
                tpObject.Trial_Id__c = t.Id;
                insert tpObject;
                
                Registration__c reg = new Registration__c();
                reg.Patient__c = p.Id;
                reg.Registration_Date__c = System.today();
                reg.Trial__c = t.Id;
                reg.Institution__c = inst.Id;
                reg.Site__c = site1.Id;
                reg.IRB_Approval_Date__c = System.today();
                reg.Screening_Informed_Consent_Date__c = System.today();
                reg.HIPPA_Consent_Date__c = System.today();
              //  reg.ACRIN_6693_MRS_Participant__c = 'Yes';
                reg.TrialPatient__c = tpObject.Id;
                reg.Status__c = 'Approval Not Required';
                reg.Effective_Time__c = system.now();
                reg.ISPY2_Subject_Id__c = ''+123;
                insert reg;
                    
                //update reg;
                
                //List<Registration__c> regList = [select TrialPatient__c from Registration__c where Id =:reg.Id order by LastModifiedDate desc limit 1];
                
                Randomization_Form__c rfc = new Randomization_Form__c();
                rfc.TrialPatient__c = tpObject.Id;
                rfc.Did_Patient_Sign_Treatment_Consent_Form__c = true;
                rfc.Randomization_Result__c = 'Randomized';
                rfc.Status__c = 'Approval Not Required';
                insert rfc;
                
                //update rfc;
                
                PreEligibility_Checklist__c preObj = new PreEligibility_Checklist__c();
                preObj.Patient__c = p.Id;
                preObj.Cytotoxic_Regiments__c = false;
                preObj.ECOG_Score__c = '5-Death';
                preObj.Status__c = 'Approval Not Required';
                insert preObj;
                
                //update preObj;
                
                /*Post_Surgaory_Summary__c pss = new Post_Surgaory_Summary__c();
                pss.Date_Of_Procedure__c = system.today();
                pss.TrialPatient__c = tpObject.Id;
                insert pss;
                    
                Off_Study_Detail__c offObject = new Off_Study_Detail__c();
                offObject.TrialPatient__c = tpObject.Id;
                offObject.Patient_completed_study_per_protocol__c = true;
                insert offObject;
                
                Followup_Form__c followObject = new Followup_Form__c(); 
                followObject.TrialPatient__c = tpObject.Id;
                insert followObject;*/
                
                /*No_Longer_lost_to_Followup__c nlObject = new No_Longer_lost_to_Followup__c();
                nlObject.TrialPatient__c = tpObject.Id;
                nlObject.Status__c = 'Not Completed';
                insert nlObject;
                //nlObject.Status__c = 'Completed';
                //update nlObject;
                
                Lost_to_Follow_Up__c lostObject = new Lost_to_Follow_Up__c();
                lostObject.TrialPatient__c = tpObject.Id;
                lostObject.Status__c = 'Accepted';
                insert lostObject;
                /*lostObject.Status__c = 'Accepted';
                update lostObject;*/
                
                ApexPages.currentPage().getParameters().put('trialId', t.Id);
                ApexPages.currentPage().getParameters().put('asOfDate','2015-01-09');
                TrialSummaryReport tsr = new TrialSummaryReport();
                tsr.prepareDataEnrolledByStudySiteForAll();
            }
        }
    } 
    
    @isTest static void myUnitTest5() {
        List<User> thisUser = [ select u.Id , u.IsActive from User u where profile.Name = 'System Administrator' and IsActive = true];
        System.runAs (thisUser[0]){
            
            Account inst = new Account();
        
            List<Account> lstAccount = [select Id from Account limit 1]; 
                    
            if(!lstAccount.isEmpty()){
                        
                inst = lstAccount[0];           // newly added logic to overcome the error of "setup and nonsetup" object
                    
                List<RecordType> reclst = [Select r.SobjectType, r.Name, r.Id From RecordType r where SobjectType = 'Site__c' and Name = 'Site'];
                    
                Site__c site1 = new Site__c();
                site1.Name = 'test site1';
                site1.Type__c = 'test type';
                site1.Institute__c = inst.Id;
                site1.RecordTypeId = reclst[0].id;
                insert site1;
                
                Trial__c t = new Trial__c();
                t.Start_Date__c = system.today();
                insert t;
                
                Patient_Custom__c p = new Patient_Custom__c();
                p.Birthdate__c = date.newInstance(1960, 8, 7);
                p.Signed_Screening__c = true;
                p.Ethnicity__c = 'Hispanic or latino';
                p.Gender__c = 'female';
                p.Race__c = 'asian';
                p.Last_Name__c = 'kumar';
                p.Institute_Text__c = 'test inst';
                p.Institution__c = inst.Id;
                insert p;
                    
                TrialPatient__c tpObject = new TrialPatient__c();
                tpObject.Patient_Id__c = p.Id;
                tpObject.Trial_Id__c = t.Id;
                insert tpObject;
                
                Registration__c reg = new Registration__c();
                reg.Patient__c = p.Id;
                reg.Registration_Date__c = System.today();
                reg.Trial__c = t.Id;
                reg.Institution__c = inst.Id;
                reg.Site__c = site1.Id;
                reg.IRB_Approval_Date__c = System.today();
                reg.Screening_Informed_Consent_Date__c = System.today();
                reg.HIPPA_Consent_Date__c = System.today();
              //  reg.ACRIN_6693_MRS_Participant__c = 'Yes';
                reg.TrialPatient__c = tpObject.Id;
                reg.Status__c = 'Approval Not Required';
                reg.Effective_Time__c = system.now();
                reg.ISPY2_Subject_Id__c = ''+123;
                insert reg;
                    
                //update reg;
                
                //List<Registration__c> regList = [select TrialPatient__c from Registration__c where Id =:reg.Id order by LastModifiedDate desc limit 1];
                
                Randomization_Form__c rfc = new Randomization_Form__c();
                rfc.TrialPatient__c = tpObject.Id;
                rfc.Did_Patient_Sign_Treatment_Consent_Form__c = true;
                rfc.Randomization_Result__c = 'Randomized';
                rfc.Status__c = 'Approval Not Required';
                insert rfc;
                
                //update rfc;
                
                /*PreEligibility_Checklist__c preObj = new PreEligibility_Checklist__c();
                preObj.Patient__c = p.Id;
                preObj.Cytotoxic_Regiments__c = false;
                preObj.ECOG_Score__c = '5-Death';
                preObj.Status__c = 'Approval Not Required';
                insert preObj;
                
                //update preObj;
                
                Post_Surgaory_Summary__c pss = new Post_Surgaory_Summary__c();
                pss.Date_Of_Procedure__c = system.today();
                pss.TrialPatient__c = tpObject.Id;
                insert pss;
                    
                Off_Study_Detail__c offObject = new Off_Study_Detail__c();
                offObject.TrialPatient__c = tpObject.Id;
                offObject.Patient_completed_study_per_protocol__c = true;
                insert offObject;
                
                Followup_Form__c followObject = new Followup_Form__c(); 
                followObject.TrialPatient__c = tpObject.Id;
                insert followObject;*/
                
                /*No_Longer_lost_to_Followup__c nlObject = new No_Longer_lost_to_Followup__c();
                nlObject.TrialPatient__c = tpObject.Id;
                nlObject.Status__c = 'Not Completed';
                insert nlObject;
                //nlObject.Status__c = 'Completed';
                //update nlObject;
                
                Lost_to_Follow_Up__c lostObject = new Lost_to_Follow_Up__c();
                lostObject.TrialPatient__c = tpObject.Id;
                lostObject.Status__c = 'Accepted';
                insert lostObject;
                /*lostObject.Status__c = 'Accepted';
                update lostObject;*/
                
                ApexPages.currentPage().getParameters().put('trialId', t.Id);
                ApexPages.currentPage().getParameters().put('asOfDate','2015-01-09');
                TrialSummaryReport tsr = new TrialSummaryReport();
                tsr.prepareNotEnrolledPatientForAll();
            }
        }
    }
    
    @isTest static void myUnitTest6() {
        List<User> thisUser = [ select u.Id , u.IsActive from User u where profile.Name = 'System Administrator' and IsActive = true];
        System.runAs (thisUser[0]){
            
            Account inst = new Account();
        
            List<Account> lstAccount = [select Id from Account limit 1]; 
                    
            if(!lstAccount.isEmpty()){
                        
                inst = lstAccount[0];           // newly added logic to overcome the error of "setup and nonsetup" object
                    
                List<RecordType> reclst = [Select r.SobjectType, r.Name, r.Id From RecordType r where SobjectType = 'Site__c' and Name = 'Site'];
                    
                Site__c site1 = new Site__c();
                site1.Name = 'test site1';
                site1.Type__c = 'test type';
                site1.Institute__c = inst.Id;
                site1.RecordTypeId = reclst[0].id;
                insert site1;
                
                Trial__c t = new Trial__c();
                t.Start_Date__c = system.today();
                insert t;
                
                Patient_Custom__c p = new Patient_Custom__c();
                p.Birthdate__c = date.newInstance(1960, 8, 7);
                p.Signed_Screening__c = true;
                p.Ethnicity__c = 'Hispanic or latino';
                p.Gender__c = 'female';
                p.Race__c = 'asian';
                p.Last_Name__c = 'kumar';
                p.Institute_Text__c = 'test inst';
                p.Institution__c = inst.Id;
                insert p;
                    
                TrialPatient__c tpObject = new TrialPatient__c();
                tpObject.Patient_Id__c = p.Id;
                tpObject.Trial_Id__c = t.Id;
                insert tpObject;
                
                Registration__c reg = new Registration__c();
                reg.Patient__c = p.Id;
                reg.Registration_Date__c = System.today();
                reg.Trial__c = t.Id;
                reg.Institution__c = inst.Id;
                reg.Site__c = site1.Id;
                reg.IRB_Approval_Date__c = System.today();
                reg.Screening_Informed_Consent_Date__c = System.today();
                reg.HIPPA_Consent_Date__c = System.today();
              //  reg.ACRIN_6693_MRS_Participant__c = 'Yes';
                reg.TrialPatient__c = tpObject.Id;
                reg.Status__c = 'Approval Not Required';
                reg.Effective_Time__c = system.now();
                reg.ISPY2_Subject_Id__c = ''+123;
                insert reg;
                    
                //update reg;
                
                //List<Registration__c> regList = [select TrialPatient__c from Registration__c where Id =:reg.Id order by LastModifiedDate desc limit 1];
                
                Randomization_Form__c rfc = new Randomization_Form__c();
                rfc.TrialPatient__c = tpObject.Id;
                rfc.Did_Patient_Sign_Treatment_Consent_Form__c = true;
                rfc.Randomization_Result__c = 'Randomized';
                rfc.Status__c = 'Approval Not Required';
                insert rfc;
                
                //update rfc;
                
                PreEligibility_Checklist__c preObj = new PreEligibility_Checklist__c();
                preObj.Patient__c = p.Id;
                preObj.Cytotoxic_Regiments__c = false;
                preObj.ECOG_Score__c = '5-Death';
                preObj.Status__c = 'Approval Not Required';
                insert preObj;
                
                //update preObj;
                
                /*Post_Surgaory_Summary__c pss = new Post_Surgaory_Summary__c();
                pss.Date_Of_Procedure__c = system.today();
                pss.TrialPatient__c = tpObject.Id;
                insert pss;
                    
                Off_Study_Detail__c offObject = new Off_Study_Detail__c();
                offObject.TrialPatient__c = tpObject.Id;
                offObject.Patient_completed_study_per_protocol__c = true;
                insert offObject;
                
                Followup_Form__c followObject = new Followup_Form__c(); 
                followObject.TrialPatient__c = tpObject.Id;
                insert followObject;*/
                
                /*No_Longer_lost_to_Followup__c nlObject = new No_Longer_lost_to_Followup__c();
                nlObject.TrialPatient__c = tpObject.Id;
                nlObject.Status__c = 'Not Completed';
                insert nlObject;
                //nlObject.Status__c = 'Completed';
                //update nlObject;
                
                Lost_to_Follow_Up__c lostObject = new Lost_to_Follow_Up__c();
                lostObject.TrialPatient__c = tpObject.Id;
                lostObject.Status__c = 'Accepted';
                insert lostObject;
                /*lostObject.Status__c = 'Accepted';
                update lostObject;*/
                
                ApexPages.currentPage().getParameters().put('trialId', t.Id);
                ApexPages.currentPage().getParameters().put('asOfDate','2015-01-09');
                TrialSummaryReport tsr = new TrialSummaryReport();
                tsr.prepareDataNotProceedingTreatmentPhaseForAll();
            }
        }
    }
    
    @isTest static void myUnitTest7() {
        List<User> thisUser = [ select u.Id , u.IsActive from User u where profile.Name = 'System Administrator' and IsActive = true];
        System.runAs (thisUser[0]){
            
            Account inst = new Account();
        
            List<Account> lstAccount = [select Id from Account limit 1]; 
                    
            if(!lstAccount.isEmpty()){
                        
                inst = lstAccount[0];           // newly added logic to overcome the error of "setup and nonsetup" object
                    
                List<RecordType> reclst = [Select r.SobjectType, r.Name, r.Id From RecordType r where SobjectType = 'Site__c' and Name = 'Site'];
                    
                Site__c site1 = new Site__c();
                site1.Name = 'test site1';
                site1.Type__c = 'test type';
                site1.Institute__c = inst.Id;
                site1.RecordTypeId = reclst[0].id;
                insert site1;
                
                Trial__c t = new Trial__c();
                t.Start_Date__c = system.today();
                insert t;
                
                Patient_Custom__c p = new Patient_Custom__c();
                p.Birthdate__c = date.newInstance(1960, 8, 7);
                p.Signed_Screening__c = true;
                p.Ethnicity__c = 'Hispanic or latino';
                p.Gender__c = 'female';
                p.Race__c = 'asian';
                p.Last_Name__c = 'kumar';
                p.Institute_Text__c = 'test inst';
                p.Institution__c = inst.Id;
                insert p;
                    
                TrialPatient__c tpObject = new TrialPatient__c();
                tpObject.Patient_Id__c = p.Id;
                tpObject.Trial_Id__c = t.Id;
                insert tpObject;
                
                Registration__c reg = new Registration__c();
                reg.Patient__c = p.Id;
                reg.Registration_Date__c = System.today();
                reg.Trial__c = t.Id;
                reg.Institution__c = inst.Id;
                reg.Site__c = site1.Id;
                reg.IRB_Approval_Date__c = System.today();
                reg.Screening_Informed_Consent_Date__c = System.today();
                reg.HIPPA_Consent_Date__c = System.today();
              //  reg.ACRIN_6693_MRS_Participant__c = 'Yes';
                reg.TrialPatient__c = tpObject.Id;
                reg.Status__c = 'Approval Not Required';
                reg.Effective_Time__c = system.now();
                reg.ISPY2_Subject_Id__c = ''+123;
                insert reg;
                    
                //update reg;
                
                //List<Registration__c> regList = [select TrialPatient__c from Registration__c where Id =:reg.Id order by LastModifiedDate desc limit 1];
                
                Randomization_Form__c rfc = new Randomization_Form__c();
                rfc.TrialPatient__c = tpObject.Id;
                rfc.Did_Patient_Sign_Treatment_Consent_Form__c = true;
                rfc.Randomization_Result__c = 'Randomized';
                rfc.Status__c = 'Approval Not Required';
                insert rfc;
                
                //update rfc;
                
                PreEligibility_Checklist__c preObj = new PreEligibility_Checklist__c();
                preObj.Patient__c = p.Id;
                preObj.Cytotoxic_Regiments__c = false;
                preObj.ECOG_Score__c = '5-Death';
                preObj.Status__c = 'Approval Not Required';
                insert preObj;
                
                //update preObj;
                
                /*Post_Surgaory_Summary__c pss = new Post_Surgaory_Summary__c();
                pss.Date_Of_Procedure__c = system.today();
                pss.TrialPatient__c = tpObject.Id;
                insert pss;
                    
                Off_Study_Detail__c offObject = new Off_Study_Detail__c();
                offObject.TrialPatient__c = tpObject.Id;
                offObject.Patient_completed_study_per_protocol__c = true;
                insert offObject;
                
                Followup_Form__c followObject = new Followup_Form__c(); 
                followObject.TrialPatient__c = tpObject.Id;
                insert followObject;*/
                
                /*No_Longer_lost_to_Followup__c nlObject = new No_Longer_lost_to_Followup__c();
                nlObject.TrialPatient__c = tpObject.Id;
                nlObject.Status__c = 'Not Completed';
                insert nlObject;
                //nlObject.Status__c = 'Completed';
                //update nlObject;
                
                Lost_to_Follow_Up__c lostObject = new Lost_to_Follow_Up__c();
                lostObject.TrialPatient__c = tpObject.Id;
                lostObject.Status__c = 'Accepted';
                insert lostObject;
                /*lostObject.Status__c = 'Accepted';
                update lostObject;*/
                
                ApexPages.currentPage().getParameters().put('trialId', t.Id);
                ApexPages.currentPage().getParameters().put('asOfDate','2015-01-09');
                TrialSummaryReport tsr = new TrialSummaryReport();
                tsr.prepareStudyParticipantDemographicsForAll();
            }
        }
    }
    
    @isTest static void myUnitTest8() {
        List<User> thisUser = [ select u.Id , u.IsActive from User u where profile.Name = 'System Administrator' and IsActive = true];
        System.runAs (thisUser[0]){
            
            Account inst = new Account();
        
            List<Account> lstAccount = [select Id from Account limit 1]; 
                    
            if(!lstAccount.isEmpty()){
                        
                inst = lstAccount[0];           // newly added logic to overcome the error of "setup and nonsetup" object
                    
                List<RecordType> reclst = [Select r.SobjectType, r.Name, r.Id From RecordType r where SobjectType = 'Site__c' and Name = 'Site'];
                    
                Site__c site1 = new Site__c();
                site1.Name = 'test site1';
                site1.Type__c = 'test type';
                site1.Institute__c = inst.Id;
                site1.RecordTypeId = reclst[0].id;
                insert site1;
                
                Trial__c t = new Trial__c();
                t.Start_Date__c = system.today();
                insert t;
                
                Patient_Custom__c p = new Patient_Custom__c();
                p.Birthdate__c = date.newInstance(1960, 8, 7);
                p.Signed_Screening__c = true;
                p.Ethnicity__c = 'Hispanic or latino';
                p.Gender__c = 'female';
                p.Race__c = 'asian';
                p.Last_Name__c = 'kumar';
                p.Institute_Text__c = 'test inst';
                p.Institution__c = inst.Id;
                insert p;
                    
                TrialPatient__c tpObject = new TrialPatient__c();
                tpObject.Patient_Id__c = p.Id;
                tpObject.Trial_Id__c = t.Id;
                insert tpObject;
                
                Registration__c reg = new Registration__c();
                reg.Patient__c = p.Id;
                reg.Registration_Date__c = System.today();
                reg.Trial__c = t.Id;
                reg.Institution__c = inst.Id;
                reg.Site__c = site1.Id;
                reg.IRB_Approval_Date__c = System.today();
                reg.Screening_Informed_Consent_Date__c = System.today();
                reg.HIPPA_Consent_Date__c = System.today();
              //  reg.ACRIN_6693_MRS_Participant__c = 'Yes';
                reg.TrialPatient__c = tpObject.Id;
                reg.Status__c = 'Approval Not Required';
                reg.Effective_Time__c = system.now();
                reg.ISPY2_Subject_Id__c = ''+123;
                insert reg;
                    
                //update reg;
                
                //List<Registration__c> regList = [select TrialPatient__c from Registration__c where Id =:reg.Id order by LastModifiedDate desc limit 1];
                
                Randomization_Form__c rfc = new Randomization_Form__c();
                rfc.TrialPatient__c = tpObject.Id;
                rfc.Did_Patient_Sign_Treatment_Consent_Form__c = true;
                rfc.Randomization_Result__c = 'Randomized';
                rfc.Status__c = 'Approval Not Required';
                insert rfc;
                
                //update rfc;
                
                PreEligibility_Checklist__c preObj = new PreEligibility_Checklist__c();
                preObj.Patient__c = p.Id;
                preObj.Cytotoxic_Regiments__c = false;
                preObj.ECOG_Score__c = '5-Death';
                preObj.Status__c = 'Approval Not Required';
                insert preObj;
                
                //update preObj;
                
                //Post_Surgaory_Summary__c pss = new Post_Surgaory_Summary__c();
                //pss.Date_Of_Procedure__c = system.today();
               // pss.TrialPatient__c = tpObject.Id;
               // insert pss;
                    
               // Off_Study_Detail__c offObject = new Off_Study_Detail__c();
               // offObject.TrialPatient__c = tpObject.Id;
               // offObject.Patient_completed_study_per_protocol__c = true;
               // insert offObject;
                
              //  Followup_Form__c followObject = new Followup_Form__c(); 
               // followObject.TrialPatient__c = tpObject.Id;
              //  insert followObject;
                
                /*No_Longer_lost_to_Followup__c nlObject = new No_Longer_lost_to_Followup__c();
              /  nlObject.TrialPatient__c = tpObject.Id;
                nlObject.Status__c = 'Not Completed';
                insert nlObject;
                //nlObject.Status__c = 'Completed';
                //update nlObject;
                
                Lost_to_Follow_Up__c lostObject = new Lost_to_Follow_Up__c();
                lostObject.TrialPatient__c = tpObject.Id;
                lostObject.Status__c = 'Accepted';
                insert lostObject;
                /*lostObject.Status__c = 'Accepted';
                update lostObject;*/
                
                ApexPages.currentPage().getParameters().put('trialId', t.Id);
                ApexPages.currentPage().getParameters().put('asOfDate','2015-01-09');
                TrialSummaryReport tsr = new TrialSummaryReport();
                tsr.accSiteWrap = new TrialSummaryReport.AccrualSiteWrapper();
                tsr.accSiteWrap.site = site1;
                tsr.lstAccrualSiteWrapper.add(tsr.accSiteWrap);
                list<Site__C> lstSite = new list<Site__C>();
                
                insert lstsite;
                tsr.prepareAccrualSummaryForSite();
            }
        }
    }
    
    @isTest static void myUnitTest9() {
        List<User> thisUser = [ select u.Id , u.IsActive from User u where profile.Name = 'System Administrator' and IsActive = true];
        System.runAs (thisUser[0]){
            
            Account inst = new Account();
        
            List<Account> lstAccount = [select Id from Account limit 1]; 
                    
            if(!lstAccount.isEmpty()){
                        
                inst = lstAccount[0];           // newly added logic to overcome the error of "setup and nonsetup" object
                    
                List<RecordType> reclst = [Select r.SobjectType, r.Name, r.Id From RecordType r where SobjectType = 'Site__c' and Name = 'Site'];
                    
                Site__c site1 = new Site__c();
                site1.Name = 'test site1';
                site1.Type__c = 'test type';
                site1.Institute__c = inst.Id;
                site1.RecordTypeId = reclst[0].id;
                insert site1;
                
                Trial__c t = new Trial__c();
                t.Start_Date__c = system.today();
                insert t;
                
                Patient_Custom__c p = new Patient_Custom__c();
                p.Birthdate__c = date.newInstance(1960, 8, 7);
                p.Signed_Screening__c = true;
                p.Ethnicity__c = 'Hispanic or latino';
                p.Gender__c = 'female';
                p.Race__c = 'asian';
                p.Last_Name__c = 'kumar';
                p.Institute_Text__c = 'test inst';
                p.Institution__c = inst.Id;
                insert p;
                    
                TrialPatient__c tpObject = new TrialPatient__c();
                tpObject.Patient_Id__c = p.Id;
                tpObject.Trial_Id__c = t.Id;
                insert tpObject;
                
                Registration__c reg = new Registration__c();
                reg.Patient__c = p.Id;
                reg.Registration_Date__c = System.today();
                reg.Trial__c = t.Id;
                reg.Institution__c = inst.Id;
                reg.Site__c = site1.Id;
                reg.IRB_Approval_Date__c = System.today();
                reg.Screening_Informed_Consent_Date__c = System.today();
                reg.HIPPA_Consent_Date__c = System.today();
              //  reg.ACRIN_6693_MRS_Participant__c = 'Yes';
                reg.TrialPatient__c = tpObject.Id;
                reg.Status__c = 'Approval Not Required';
                reg.Effective_Time__c = system.now();
                reg.ISPY2_Subject_Id__c = ''+123;
                insert reg;
                    
                //update reg;
                
                //List<Registration__c> regList = [select TrialPatient__c from Registration__c where Id =:reg.Id order by LastModifiedDate desc limit 1];
                
                Randomization_Form__c rfc = new Randomization_Form__c();
                rfc.TrialPatient__c = tpObject.Id;
                rfc.Did_Patient_Sign_Treatment_Consent_Form__c = true;
                rfc.Randomization_Result__c = 'Randomized';
                rfc.Status__c = 'Approval Not Required';
                insert rfc;
                
                //update rfc;
                
                PreEligibility_Checklist__c preObj = new PreEligibility_Checklist__c();
                preObj.Patient__c = p.Id;
                preObj.Cytotoxic_Regiments__c = false;
                preObj.ECOG_Score__c = '5-Death';
                preObj.Status__c = 'Approval Not Required';
                insert preObj;
                
                //update preObj;
                
                /*Post_Surgaory_Summary__c pss = new Post_Surgaory_Summary__c();
                pss.Date_Of_Procedure__c = system.today();
                pss.TrialPatient__c = tpObject.Id;
                insert pss;
                    
                Off_Study_Detail__c offObject = new Off_Study_Detail__c();
                offObject.TrialPatient__c = tpObject.Id;
                offObject.Patient_completed_study_per_protocol__c = true;
                insert offObject;
                
                Followup_Form__c followObject = new Followup_Form__c(); 
                followObject.TrialPatient__c = tpObject.Id;
                insert followObject;*/
                
                /*No_Longer_lost_to_Followup__c nlObject = new No_Longer_lost_to_Followup__c();
                nlObject.TrialPatient__c = tpObject.Id;
                nlObject.Status__c = 'Completed';
                insert nlObject;
                //nlObject.Status__c = 'Completed';
                //update nlObject;
                
                Lost_to_Follow_Up__c lostObject = new Lost_to_Follow_Up__c();
                lostObject.TrialPatient__c = tpObject.Id;
                lostObject.Status__c = 'Accepted';
                insert lostObject;
                /*lostObject.Status__c = 'Accepted';
                update lostObject;*/
                
                ApexPages.currentPage().getParameters().put('trialId', t.Id);
                ApexPages.currentPage().getParameters().put('asOfDate','2015-01-09');
                TrialSummaryReport tsr = new TrialSummaryReport();
                tsr.accSiteWrap = new TrialSummaryReport.AccrualSiteWrapper();
                tsr.accSiteWrap.site = site1;
                tsr.lstAccrualSiteWrapper.add(tsr.accSiteWrap);
                tsr.prepareDataEnrolledByMonthForSite();
            }
        }
    }
    
    @isTest static void myUnitTest10() {
        List<User> thisUser = [ select u.Id , u.IsActive from User u where profile.Name = 'System Administrator' and IsActive = true];
        System.runAs (thisUser[0]){
            
            Account inst = new Account();
        
            List<Account> lstAccount = [select Id from Account limit 1]; 
                    
            if(!lstAccount.isEmpty()){
                        
                inst = lstAccount[0];           // newly added logic to overcome the error of "setup and nonsetup" object
                    
                List<RecordType> reclst = [Select r.SobjectType, r.Name, r.Id From RecordType r where SobjectType = 'Site__c' and Name = 'Site'];
                    
                Site__c site1 = new Site__c();
                site1.Name = 'test site1';
                site1.Type__c = 'test type';
                site1.Institute__c = inst.Id;
                site1.RecordTypeId = reclst[0].id;
                insert site1;
                
                Trial__c t = new Trial__c();
                t.Start_Date__c = system.today();
                insert t;
                
                Patient_Custom__c p = new Patient_Custom__c();
                p.Birthdate__c = date.newInstance(1960, 8, 7);
                p.Signed_Screening__c = true;
                p.Ethnicity__c = 'Hispanic or latino';
                p.Gender__c = 'female';
                p.Race__c = 'asian';
                p.Last_Name__c = 'kumar';
                p.Institute_Text__c = 'test inst';
                p.Institution__c = inst.Id;
                insert p;
                    
                TrialPatient__c tpObject = new TrialPatient__c();
                tpObject.Patient_Id__c = p.Id;
                tpObject.Trial_Id__c = t.Id;
                insert tpObject;
                
                Registration__c reg = new Registration__c();
                reg.Patient__c = p.Id;
                reg.Registration_Date__c = System.today();
                reg.Trial__c = t.Id;
                reg.Institution__c = inst.Id;
                reg.Site__c = site1.Id;
                reg.IRB_Approval_Date__c = System.today();
                reg.Screening_Informed_Consent_Date__c = System.today();
                reg.HIPPA_Consent_Date__c = System.today();
              //  reg.ACRIN_6693_MRS_Participant__c = 'Yes';
                reg.TrialPatient__c = tpObject.Id;
                reg.Status__c = 'Approval Not Required';
                reg.Effective_Time__c = system.now();
                reg.ISPY2_Subject_Id__c = ''+123;
                insert reg;
                    
                //update reg;
                
                //List<Registration__c> regList = [select TrialPatient__c from Registration__c where Id =:reg.Id order by LastModifiedDate desc limit 1];
                
                Randomization_Form__c rfc = new Randomization_Form__c();
                rfc.TrialPatient__c = tpObject.Id;
                rfc.Did_Patient_Sign_Treatment_Consent_Form__c = true;
                rfc.Randomization_Result__c = 'Randomized';
                rfc.Status__c = 'Approval Not Required';
                insert rfc;
                
                //update rfc;
                
                PreEligibility_Checklist__c preObj = new PreEligibility_Checklist__c();
                preObj.Patient__c = p.Id;
                preObj.Cytotoxic_Regiments__c = false;
                preObj.ECOG_Score__c = '5-Death';
                preObj.Status__c = 'Approval Not Required';
                insert preObj;
                
                //update preObj;
                
                /*Post_Surgaory_Summary__c pss = new Post_Surgaory_Summary__c();
                pss.Date_Of_Procedure__c = system.today();
                pss.TrialPatient__c = tpObject.Id;
                insert pss;
                    
                Off_Study_Detail__c offObject = new Off_Study_Detail__c();
                offObject.TrialPatient__c = tpObject.Id;
                offObject.Patient_completed_study_per_protocol__c = true;
                insert offObject;
                
                Followup_Form__c followObject = new Followup_Form__c(); 
                followObject.TrialPatient__c = tpObject.Id;
                insert followObject;*/
                
                /*No_Longer_lost_to_Followup__c nlObject = new No_Longer_lost_to_Followup__c();
                nlObject.TrialPatient__c = tpObject.Id;
                nlObject.Status__c = 'Not Completed';
                insert nlObject;
                //nlObject.Status__c = 'Completed';
                //update nlObject;
                
                Lost_to_Follow_Up__c lostObject = new Lost_to_Follow_Up__c();
                lostObject.TrialPatient__c = tpObject.Id;
                lostObject.Status__c = 'Accepted';
                insert lostObject;
                /*lostObject.Status__c = 'Accepted';
                update lostObject;*/
                
                ApexPages.currentPage().getParameters().put('trialId', t.Id);
                ApexPages.currentPage().getParameters().put('asOfDate','2015-01-09');
                TrialSummaryReport tsr = new TrialSummaryReport();
                tsr.accSiteWrap = new TrialSummaryReport.AccrualSiteWrapper();
                tsr.accSiteWrap.site = site1;
                tsr.lstAccrualSiteWrapper.add(tsr.accSiteWrap);
                tsr.prepareNotEnrolledPatientForSite();
            }
        }
    }
    
    @isTest static void myUnitTest11() {
        List<User> thisUser = [ select u.Id , u.IsActive from User u where profile.Name = 'System Administrator' and IsActive = true];
        System.runAs (thisUser[0]){
            
            Account inst = new Account();
        
            List<Account> lstAccount = [select Id from Account limit 1]; 
                    
            if(!lstAccount.isEmpty()){
                        
                inst = lstAccount[0];           // newly added logic to overcome the error of "setup and nonsetup" object
                    
                List<RecordType> reclst = [Select r.SobjectType, r.Name, r.Id From RecordType r where SobjectType = 'Site__c' and Name = 'Site'];
                    
                Site__c site1 = new Site__c();
                site1.Name = 'test site1';
                site1.Type__c = 'test type';
                site1.Institute__c = inst.Id;
                site1.RecordTypeId = reclst[0].id;
                insert site1;
                
                Trial__c t = new Trial__c();
                t.Start_Date__c = system.today();
                insert t;
                
                Patient_Custom__c p = new Patient_Custom__c();
                p.Birthdate__c = date.newInstance(1960, 8, 7);
                p.Signed_Screening__c = true;
                p.Ethnicity__c = 'Hispanic or latino';
                p.Gender__c = 'female';
                p.Race__c = 'asian';
                p.Last_Name__c = 'kumar';
                p.Institute_Text__c = 'test inst';
                p.Institution__c = inst.Id;
                insert p;
                    
                TrialPatient__c tpObject = new TrialPatient__c();
                tpObject.Patient_Id__c = p.Id;
                tpObject.Trial_Id__c = t.Id;
                insert tpObject;
                
                Registration__c reg = new Registration__c();
                reg.Patient__c = p.Id;
                reg.Registration_Date__c = System.today();
                reg.Trial__c = t.Id;
                reg.Institution__c = inst.Id;
                reg.Site__c = site1.Id;
                reg.IRB_Approval_Date__c = System.today();
                reg.Screening_Informed_Consent_Date__c = System.today();
                reg.HIPPA_Consent_Date__c = System.today();
              //  reg.ACRIN_6693_MRS_Participant__c = 'Yes';
                reg.TrialPatient__c = tpObject.Id;
                reg.Status__c = 'Approval Not Required';
                reg.Effective_Time__c = system.now();
                reg.ISPY2_Subject_Id__c = ''+123;
                insert reg;
                    
                //update reg;
                
                //List<Registration__c> regList = [select TrialPatient__c from Registration__c where Id =:reg.Id order by LastModifiedDate desc limit 1];
                
                Randomization_Form__c rfc = new Randomization_Form__c();
                rfc.TrialPatient__c = tpObject.Id;
                rfc.Did_Patient_Sign_Treatment_Consent_Form__c = true;
                rfc.Randomization_Result__c = 'Randomized';
                rfc.Status__c = 'Approval Not Required';
                insert rfc;
                
                //update rfc;
                
                PreEligibility_Checklist__c preObj = new PreEligibility_Checklist__c();
                preObj.Patient__c = p.Id;
                preObj.Cytotoxic_Regiments__c = false;
                preObj.ECOG_Score__c = '5-Death';
                preObj.Status__c = 'Approval Not Required';
                insert preObj;
                
                //update preObj;
                
                /*Post_Surgaory_Summary__c pss = new Post_Surgaory_Summary__c();
                pss.Date_Of_Procedure__c = system.today();
                pss.TrialPatient__c = tpObject.Id;
                insert pss;
                    
                Off_Study_Detail__c offObject = new Off_Study_Detail__c();
                offObject.TrialPatient__c = tpObject.Id;
                offObject.Patient_completed_study_per_protocol__c = true;
                insert offObject;
                
                Followup_Form__c followObject = new Followup_Form__c(); 
                followObject.TrialPatient__c = tpObject.Id;
                insert followObject;*/
                
                /*No_Longer_lost_to_Followup__c nlObject = new No_Longer_lost_to_Followup__c();
                nlObject.TrialPatient__c = tpObject.Id;
                nlObject.Status__c = 'Not Completed';
                insert nlObject;
                //nlObject.Status__c = 'Completed';
                //update nlObject;
                
                Lost_to_Follow_Up__c lostObject = new Lost_to_Follow_Up__c();
                lostObject.TrialPatient__c = tpObject.Id;
                lostObject.Status__c = 'Accepted';
                insert lostObject;
                /*lostObject.Status__c = 'Accepted';
                update lostObject;*/
                
                ApexPages.currentPage().getParameters().put('trialId', t.Id);
                ApexPages.currentPage().getParameters().put('asOfDate','2015-01-09');
                TrialSummaryReport tsr = new TrialSummaryReport();
                tsr.accSiteWrap = new TrialSummaryReport.AccrualSiteWrapper();
                tsr.accSiteWrap.site = site1;
                tsr.lstAccrualSiteWrapper.add(tsr.accSiteWrap);
                tsr.prepareDataNotProceedingTreatmentPhaseForSite();
            }
        }
    }
}