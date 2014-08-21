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
private class TestCRFRecCreationOnMenopausalStatus {

    @isTest static void myUnitTest() {
        // TO DO: implement unit test
        
        List<User> thisUser = [ select u.Id , u.IsActive from User u where profile.Name = 'System Administrator' and IsActive = true];
        System.runAs (thisUser[0]){
            
        Account inst1 = new Account(); //inst
        
        List<Account> lstAccount1 = [Select a.RecordType.Name, a.RecordTypeId, a.Id From Account a where RecordType.Name = 'Institution'];
        
        Account dcc1 = new Account(); // inst or dcc
        
        List<Account> lstAccount2 = [Select a.Name ,a.RecordType.Name, a.RecordTypeId, a.Id From Account a where RecordType.Name = 'DCC'];
        
        if(!(lstAccount1.isEmpty() && lstAccount2.isEmpty())){
            
        inst1 = lstAccount1[0];
        dcc1 =  lstAccount2[0];
        
        Trial__c t1 = new Trial__c();
        insert t1;
        
        Patient_Custom__c p = new Patient_Custom__c();
        p.Ethnicity__c = 'Hispanic or latino';
        p.Gender__c = 'female';
        p.Race__c = 'asian;indian';
        p.First_Name__c = 'test';
        p.Last_Name__c = 'kumar';
        p.Status__c = 'approval not required';
        p.Birthdate__c = date.newInstance(1940, 08, 05);
        p.Institution__c = inst1.Id;
        insert p;
        update p;
        
        List<Patient_Custom__c> lstPatient = [Select p.Age__c From Patient_Custom__c p where Id = : p.Id];
        
        List<RecordType> lstRecordType = Database.query('select Id, Name from RecordType where sObjectType = \'Site__c\' and Name = \'Site\'');
        
        Site__c sit = new Site__c();
        sit.Name = 'test123';
        sit.Institute__c = inst1.Id;
        sit.RecordTypeId = lstRecordType[0].Id;
        insert sit;
        
        TrialPatient__c tp = new TrialPatient__c();
        tp.Patient_Id__c = p.Id;
        tp.Site__c = sit.Id;
        tp.Trial_Id__c = t1.Id;
        insert tp;
        update tp;
        
        List<RecordType> lstRecType = [Select r.SobjectType, r.Name, r.Id From RecordType r where r.SobjectType = 'Menopausal_Status_Detail__c' and r.Name = 'Approval Pending'];
        
       Menopausal_Status_Detail__c msd = new Menopausal_Status_Detail__c();
        msd.AgeVal__c = 'Age > 50';
        msd.Status__c = 'Completed';
        msd.Phase__c = 'Screening';
        msd.Patient__c = p.Id;
        msd.TrialPatient__c = tp.Id;
      //  msd.age__c = lstPatient[0].Age__c;
        msd.RecordTypeId = lstRecType[0].Id;
        msd.Enstrogent_Replacement_Duration_Months__c = 5.0;
        msd.On_Estrogen_Replacement__c = true; 
        msd.Bilateral_Oophorectomy_Date__c = date.newInstance(2012, 8, 8);
        msd.Bilateral_oophorectomy__c = true;
        msd.Hysterectomy_Date__c = date.newInstance(2012, 7, 7);
        msd.Hysterectomy__c = true;
        msd.Menopausal_Status__c = 'Above categories not applicable AND Age < 50';
        insert msd;
        msd.Status__c = 'Approval Pending';
        update msd;
        
        /*CRF__c c = new CRF__c();
        c.Patient__c = msd.Patient__c;
        c.Status__c = msd.Status__c;
        c.Site__c = sit.Id;
        InstitutionTrialDcc__c instTrialDcc = new InstitutionTrialDcc__c();
        instTrialDcc.Institution_Id__c = p.Institution__c;
        instTrialDcc.Trial_Id__c = t1.Id;
        instTrialDcc.DCC_Id__c = dcc1.Id;
        
        */
        
     /*   InstitutionUser__c ins = new InstitutionUser__c();
        ins.Site__c = sit.Id;
        ins.Trial__c = t1.Id;
        ins.Institution__c = inst1.Id;
        ins.User__c = userinfo.getUserId();
        ins.Trial__c = t1.Id;
        insert ins;
        update ins; */
        
       Site_Trial__c st = new Site_Trial__c();
        st.Trial__c = t1.Id;
        st.Site__c = sit.Id;
        insert st;
        
        List<Site_Trial__c> lstSite = [Select s.Name From Site_Trial__c s where id = : st.Id];
        
        Group grp = new Group();
        grp.Name = lstSite[0].Name;
        grp.Type='Regular';
        insert grp;
        
        Group grp1 = new Group();
        grp1.Name = dcc1.Name;
        insert grp1;
        
        Menopausal_Status_Detail__Share msds = new Menopausal_Status_Detail__Share();
        msds.ParentId = msd.Id;
        msds.AccessLevel = 'Edit';
        msds.UserOrGroupId = grp.Id;
        insert msds;
        
        msds.AccessLevel = 'Read';
        update msds;
        
        
        } 
    }
  }
  @isTest static void myUnitTest2() {
        // TO DO: implement unit test
        
        
			List<User> thisUser1 = [ select u.Id , u.IsActive from User u where profile.Name = 'System Administrator' and IsActive = true];
        System.runAs (thisUser1[0]){
            
        Account inst1 = new Account(); //inst
        
        List<Account> lstAccount1 = [Select a.RecordType.Name, a.RecordTypeId, a.Id From Account a where RecordType.Name = 'Institution'];
        
        Account dcc1 = new Account(); // inst or dcc
        
        List<Account> lstAccount2 = [Select a.Name ,a.RecordType.Name, a.RecordTypeId, a.Id From Account a where RecordType.Name = 'DCC'];
        
        if(!(lstAccount1.isEmpty() && lstAccount2.isEmpty())){
            
        inst1 = lstAccount1[0];
        dcc1 =  lstAccount2[0];
        
        Trial__c t1 = new Trial__c();
        insert t1;
        
        Patient_Custom__c p = new Patient_Custom__c();
        p.Ethnicity__c = 'Hispanic or latino';
        p.Gender__c = 'female';
        p.Race__c = 'asian;indian';
        p.First_Name__c = 'test';
        p.Last_Name__c = 'kumar';
        p.Status__c = 'approval not required';
        p.Birthdate__c = date.newInstance(1940, 08, 05);
        p.Institution__c = inst1.Id;
        insert p;
        update p;
        
        List<Patient_Custom__c> lstPatient = [Select p.Age__c From Patient_Custom__c p where Id = : p.Id];
        
        List<RecordType> lstRecordType = Database.query('select Id, Name from RecordType where sObjectType = \'Site__c\' and Name = \'Site\'');
        
        Site__c sit = new Site__c();
        sit.Name = 'test123';
        sit.Institute__c = inst1.Id;
        sit.RecordTypeId = lstRecordType[0].Id;
        insert sit;
        
        TrialPatient__c tp = new TrialPatient__c();
        tp.Patient_Id__c = p.Id;
        tp.Site__c = sit.Id;
        tp.Trial_Id__c = t1.Id;
        insert tp;
        update tp;
		
		 InstitutionTrialDcc__c instTrialDcc = new InstitutionTrialDcc__c();
        instTrialDcc.Institution_Id__c = p.Institution__c;
        instTrialDcc.Trial_Id__c = t1.Id;
        instTrialDcc.DCC_Id__c = dcc1.Id;
        
        insert instTrialDcc;
        update instTrialDcc;
		}
	}
	}
	@isTest static void myUnitTest3() {
        // TO DO: implement unit test
        
        
			List<User> thisUser1 = [ select u.Id , u.IsActive from User u where profile.Name = 'System Administrator' and IsActive = true];
        System.runAs (thisUser1[0]){
            
        Account inst1 = new Account(); //inst
        
        List<Account> lstAccount1 = [Select a.RecordType.Name, a.RecordTypeId, a.Id From Account a where RecordType.Name = 'Institution'];
        
        Account dcc1 = new Account(); // inst or dcc
        
        List<Account> lstAccount2 = [Select a.Name ,a.RecordType.Name, a.RecordTypeId, a.Id From Account a where RecordType.Name = 'DCC'];
        
        if(!(lstAccount1.isEmpty() && lstAccount2.isEmpty())){
            
        inst1 = lstAccount1[0];
        dcc1 =  lstAccount2[0];
        
        Trial__c t1 = new Trial__c();
        insert t1;
        
        Patient_Custom__c p = new Patient_Custom__c();
        p.Ethnicity__c = 'Hispanic or latino';
        p.Gender__c = 'female';
        p.Race__c = 'asian;indian';
        p.First_Name__c = 'test';
        p.Last_Name__c = 'kumar';
        p.Status__c = 'approval not required';
        p.Birthdate__c = date.newInstance(1940, 08, 05);
        p.Institution__c = inst1.Id;
        insert p;
        update p;
        
        List<Patient_Custom__c> lstPatient = [Select p.Age__c From Patient_Custom__c p where Id = : p.Id];
        
        List<RecordType> lstRecordType = Database.query('select Id, Name from RecordType where sObjectType = \'Site__c\' and Name = \'Site\' limit 1');
        
        Site__c sit = new Site__c();
        sit.Name = 'test123';
        sit.Institute__c = inst1.Id;
        sit.RecordTypeId = lstRecordType[0].Id;
        insert sit;
        
        TrialPatient__c tp = new TrialPatient__c();
        tp.Patient_Id__c = p.Id;
        tp.Site__c = sit.Id;
        tp.Trial_Id__c = t1.Id;
        insert tp;
        update tp;
        
        List<RecordType> lstRecType = [Select r.SobjectType, r.Name, r.Id From RecordType r where r.SobjectType = 'Menopausal_Status_Detail__c' and r.Name = 'Approval Pending'];
        
        Menopausal_Status_Detail__c msd = new Menopausal_Status_Detail__c();
        msd.AgeVal__c = 'Age > 50';
        msd.Status__c = 'Completed';
        msd.Phase__c = 'Screening';
        msd.Patient__c = p.Id;
        msd.TrialPatient__c = tp.Id;
      //  msd.age__c = lstPatient[0].Age__c;
        msd.RecordTypeId = lstRecType[0].Id;
        msd.Enstrogent_Replacement_Duration_Months__c = 5.0;
        msd.On_Estrogen_Replacement__c = true; 
        msd.Bilateral_Oophorectomy_Date__c = date.newInstance(2012, 8, 8);
        msd.Bilateral_oophorectomy__c = true;
        msd.Hysterectomy_Date__c = date.newInstance(2012, 7, 7);
        msd.Hysterectomy__c = true;
        msd.Menopausal_Status__c = 'Above categories not applicable AND Age < 50';
        insert msd;
        msd.Status__c = 'Approval Pending';
        update msd;
        
        
		CRF__c c = new CRF__c();
        c.Patient__c = msd.Patient__c;
        c.Status__c = msd.Status__c;
        c.Site__c = sit.Id;
        insert c;
        update c;
        
       
		 
		}
	}
	}
	
	@isTest static void myUnitTest4() {
        // TO DO: implement unit test
        
        
			List<User> thisUser1 = [ select u.Id , u.IsActive from User u where profile.Name = 'System Administrator' and IsActive = true];
        System.runAs (thisUser1[0]){
            
        Account inst1 = new Account(); //inst
        
        List<Account> lstAccount1 = [Select a.RecordType.Name, a.RecordTypeId, a.Id From Account a where RecordType.Name = 'Institution'];
        
        Account dcc1 = new Account(); // inst or dcc
        
        List<Account> lstAccount2 = [Select a.Name ,a.RecordType.Name, a.RecordTypeId, a.Id From Account a where RecordType.Name = 'DCC'];
        
        if(!(lstAccount1.isEmpty() && lstAccount2.isEmpty())){
            
        inst1 = lstAccount1[0];
        dcc1 =  lstAccount2[0];
        
        Trial__c t1 = new Trial__c();
        insert t1;
        
        Patient_Custom__c p = new Patient_Custom__c();
        p.Ethnicity__c = 'Hispanic or latino';
        p.Gender__c = 'female';
        p.Race__c = 'asian;indian';
        p.First_Name__c = 'test';
        p.Last_Name__c = 'kumar';
        p.Status__c = 'approval not required';
        p.Birthdate__c = date.newInstance(1940, 08, 05);
        p.Institution__c = inst1.Id;
        insert p;
        update p;
        
        List<Patient_Custom__c> lstPatient = [Select p.Age__c From Patient_Custom__c p where Id = : p.Id];
        
        List<RecordType> lstRecordType = Database.query('select Id, Name from RecordType where sObjectType = \'Site__c\' and Name = \'Site\'');
        
        Site__c sit = new Site__c();
        sit.Name = 'test123';
        sit.Institute__c = inst1.Id;
        sit.RecordTypeId = lstRecordType[0].Id;
        insert sit;
        
        TrialPatient__c tp = new TrialPatient__c();
        tp.Patient_Id__c = p.Id;
        tp.Site__c = sit.Id;
        tp.Trial_Id__c = t1.Id;
        insert tp;
        update tp;
        
        List<RecordType> lstRecType = [Select r.SobjectType, r.Name, r.Id From RecordType r where r.SobjectType = 'Menopausal_Status_Detail__c' and r.Name = 'Approval Pending'];
        
        
        
		
        
        Menopausal_Status_Detail__c msd1 = new Menopausal_Status_Detail__c(); // else part line 152
        msd1.AgeVal__c = 'Age > 50';
        msd1.Status__c = 'Completed';
        msd1.Phase__c = 'Screening';
        msd1.Patient__c = p.Id;
        msd1.TrialPatient__c = tp.Id;
       // msd1.age__c = lstPatient[0].Age__c;
        msd1.RecordTypeId = lstRecType[0].Id;
        msd1.Menopausal_Status__c = 'Above categories not applicable AND Age < 50';
        insert msd1;
        msd1.Status__c = 'Approval Pending';
        update msd1;
		 
		}
	}
	}
	
	@isTest static void myUnitTest5() {
        // TO DO: implement unit test
        
        
			List<User> thisUser1 = [ select u.Id , u.IsActive from User u where profile.Name = 'System Administrator' and IsActive = true];
        System.runAs (thisUser1[0]){
            
        Account inst1 = new Account(); //inst
        
        List<Account> lstAccount1 = [Select a.RecordType.Name, a.RecordTypeId, a.Id From Account a where RecordType.Name = 'Institution'];
        
        Account dcc1 = new Account(); // inst or dcc
        
        List<Account> lstAccount2 = [Select a.Name ,a.RecordType.Name, a.RecordTypeId, a.Id From Account a where RecordType.Name = 'DCC'];
        
        if(!(lstAccount1.isEmpty() && lstAccount2.isEmpty())){
            
        inst1 = lstAccount1[0];
        dcc1 =  lstAccount2[0];
        
        Trial__c t1 = new Trial__c();
        insert t1;
        
        Patient_Custom__c p = new Patient_Custom__c();
        p.Ethnicity__c = 'Hispanic or latino';
        p.Gender__c = 'female';
        p.Race__c = 'asian;indian';
        p.First_Name__c = 'test';
        p.Last_Name__c = 'kumar';
        p.Status__c = 'approval not required';
        p.Birthdate__c = date.newInstance(1940, 08, 05);
        p.Institution__c = inst1.Id;
        insert p;
        update p;
        
        List<Patient_Custom__c> lstPatient = [Select p.Age__c From Patient_Custom__c p where Id = : p.Id];
        
        List<RecordType> lstRecordType = Database.query('select Id, Name from RecordType where sObjectType = \'Site__c\' and Name = \'Site\' limit 1');
        
        Site__c sit = new Site__c();
        sit.Name = 'test123';
        sit.Institute__c = inst1.Id;
        sit.RecordTypeId = lstRecordType[0].Id;
        insert sit;
        
        TrialPatient__c tp = new TrialPatient__c();
        tp.Patient_Id__c = p.Id;
        tp.Site__c = sit.Id;
        tp.Trial_Id__c = t1.Id;
        insert tp;
        update tp;
        
        
        
        Menopausal_Status_Detail__c msd1 = new Menopausal_Status_Detail__c(); // else part line 152
        msd1.AgeVal__c = 'Age > 50';
        msd1.Status__c = 'Completed';
        msd1.Phase__c = 'Screening';
        msd1.Patient__c = p.Id;
        msd1.TrialPatient__c = tp.Id;
       // msd1.age__c = lstPatient[0].Age__c;
        //msd1.RecordTypeId = lstRecType[0].Id;
        msd1.Menopausal_Status__c = 'Above categories not applicable AND Age < 50';
        insert msd1;
        msd1.Status__c = 'Approval Pending';
        update msd1;
		 
		}
	}
	}
}