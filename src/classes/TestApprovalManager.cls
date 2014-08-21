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
private class TestApprovalManager {

    @isTest static void myUnitTest() {
        // TO DO: implement unit test
        
         User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
         System.runAs ( thisUser ){
            List<RecordType> recordT = [Select r.Name, r.Id From RecordType r where sObjectType='Account' and (Name='Institution' or Name='DCC') order by Name desc];
            Test.startTest();
            Account inst1 = new Account();
            inst1.Name = 'test Institute 1';
            inst1.RecordTypeId = recordT[1].Id;
            insert inst1;
            
            Account dcc1 = new Account();
            dcc1.Name = 'test DCC 1';
            dcc1.RecordTypeId = recordT[0].Id;
            insert dcc1;
            
            List<Account> lstDccAccount = [select Inst_Group__c from Account where Id = :dcc1.Id];
            // Group
            
            Group g = new Group();
            g.Name = lstDccAccount[0].Inst_Group__c;
            g.Type='Queue';
            insert g;
            
            //system.debug('--lstDccAccount[0].Inst_Group__c-->'+lstDccAccount[0].Inst_Group__c);
            //Group g = [select Id from Group where Name =:lstDccAccount[0].Inst_Group__c and Type = 'Queue'];
            
            system.debug('-----Queue Created--------->');
            /*QueueSobject q6 = new QueueSobject();
            q6.QueueId = g.Id;
            q6.SobjectType = 'ProtocolViolationDetail__c';
            insert q6;*/
            
            //////////////////////
            Profile dccProp = [ Select p.UserType, p.Name, (Select Id From Users) From Profile p where Name = 'DCC User' ];
            List<User> lstDccUser = dccProp.Users;     
            User thisUser1 = lstDccUser[0];            
            
            DCC_User__c du = new DCC_User__c();
            du.DCC__c = inst1.Id;
            du.User__c = thisUser1.Id;
            insert du;
            
            GroupMember gm = new GroupMember();
            gm.GroupId = g.Id;
            gm.UserOrGroupId = thisUser1.Id;
            insert gm; 
            
            Patient_Custom__c p = new Patient_Custom__c();
            p.Ethnicity__c = 'Hispanic or latino';
            p.Gender__c = 'female';
            p.Race__c = 'asian;indian';
            p.Last_Name__c = 'kumar';
            p.Status__c = 'approval not required';
            p.Birthdate__c = date.newInstance(1950, 08, 05);
            p.Institution__c = inst1.Id;
            insert p;
            
            Trial__c t1 = new Trial__c();
            insert t1;
            
            InstitutionTrialDcc__c instTrialDcc = new InstitutionTrialDcc__c();
            instTrialDcc.DCC_Id__c = dcc1.Id;
            instTrialDcc.Institution_Id__c = inst1.Id;
            instTrialDcc.Trial_Id__c = t1.id;
            insert instTrialDcc;
            
            InstitutionTrialDcc__c inst = new InstitutionTrialDcc__c();
            inst.DCC_Id__c = dcc1.Id;
            inst.Institution_Id__c = inst1.Id;
            inst.Trial_Id__c = t1.id;
            insert inst;
            
            Site__c s = new Site__c();
            s.Institute__c = inst1.Id;
            insert s;
            
            Profile prop = [ Select p.UserType, p.Name, (Select Id From Users) From Profile p where Name = 'Site User' ];     
            List<User> lstUser = prop.Users;
            InstitutionUser__c instUser = new InstitutionUser__c ();
            instUser.Site__c = s.Id;
            instUser.Institution__c = inst1.Id;
            instUser.Trial__c = t1.Id;
            instUser.User__c = lstUser[0].Id;
            insert instUser;
            
            TrialPatient__c tp = new TrialPatient__c();
            tp.Patient_Id__c = p.Id;
            tp.FirstName__c = 'a';
            tp.LastName__c = 'b';
            tp.Site__c = s.Id;
            tp.Trial_Id__c = t1.Id;
            insert tp;
            
            CRF__c c = new CRF__c();
            c.Patient__c = p.Id;
            c.Site__c = s.Id;
            insert c;
            
            ProtocolViolationDetail__c pv = new ProtocolViolationDetail__c();
            pv.Status__c = 'Approval Pending';
            pv.Phase__c  = 'screening';
            pv.Patient__c = p.Id;
            pv.TrialPatient__c = tp.Id;
            pv.CRFId__c = c.Id;
            pv.Other_Action__c = 'test';
            insert pv;
            
            Account acc1 = [Select Inst_Group__c From Account Where Id = : inst1.Id];
            
            system.debug('acc1 : '+acc1);
            
            /*Group grp1 = new Group();
            grp1.Name = acc1.Inst_Group__c;
            grp1.type = 'Queue';
            insert grp1;*/
            
            Account acc2 = [Select Inst_Group__c From Account Where Id = : dcc1.Id];
             
            /*Group grp2 = new Group();
            grp2.name = dcc1.Inst_Group__c;
            grp2.type = 'regular';
            insert grp2;*/
            
            ApprovalManager am = new ApprovalManager();
            ApprovalManager.submitForApproval(pv.Id,'ProtocolViolationDetail__c');
            
            Test.stopTest();
        }
    }
}