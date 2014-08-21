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
private class TestAdditionalQuestionControllerReadOnly {

    @isTest static void AddQuesUnitTest() {
        
        Account acc = new Account();
        
        List<Account> lstAccount = [Select a.Id From Account a limit 1];
        
        if(lstAccount.isEmpty()) return;
            
        acc = lstAccount[0];
        
        Patient_Custom__c p = new Patient_Custom__c();
        p.Ethnicity__c = 'Hispanic or latino';
        p.Gender__c = 'female';
        p.Race__c = 'asian;indian';
        p.Last_Name__c = 'kumar';
        p.Status__c = 'approval not required';
        p.Birthdate__c = date.newInstance(1950, 08, 05);
        p.Institution__c = acc.Id;
        insert p;
        
        List<Patient_Custom__c> lstPatient = [select Name from Patient_Custom__c where Id = :P.Id];
        
        TrialPatient__c tp = new TrialPatient__c();
        tp.Patient_Id__c = p.Id;
        tp.FirstName__c = 'a';
        tp.LastName__c = 'b';
        insert tp;
        
        On_Study_Eligibility_Form__c ose = new On_Study_Eligibility_Form__c();
        ose.TrialPatient__c = tp.Id;
        ose.How_was_the_cancer_first_detected__c = 'Clinical exam'; 
        ose.Status__c = 'Accepted';
        insert ose;
         
        
        Lab_and_Test__c labAndTest1 = new Lab_and_Test__c();
        labAndTest1.TrialPatient__c = tp.Id;
        insert labAndTest1;
        
        Lab_and_Test__c labAndTest = new Lab_and_Test__c();
        labAndTest.TrialPatient__c = tp.Id;
        insert labAndTest;
        System.debug('labAndTest.CreatedDate : '+labAndTest.CreatedDate);
        
        Arm__c arm = new Arm__c();
        arm.Name = 'Test Arm';
        insert arm;
        
        Agent__c agent = new Agent__c();
        agent.Name = 'Test Arm';
        insert agent;
        
        QuestionAnswer__c per_quesAns = new QuestionAnswer__c();
        per_quesAns.AnswerType__c = 'Boolean';
        per_quesAns.Agent__c = agent.Id; 
        per_quesAns.Question__c = 'test Question';
        per_quesAns.Type__c = 'Test';
        insert per_quesAns;
        
        QuestionAnswer__c per_quesAns1 = new QuestionAnswer__c();
        per_quesAns1.AnswerType__c = 'Boolean';
        per_quesAns1.Agent__c = agent.Id; 
        per_quesAns1.Question__c = 'test Question';
        per_quesAns1.Type__c = 'Test';
        insert per_quesAns1;
        
        AnswerOption__c ansOpt1 = new AnswerOption__c();
        ansOpt1.ContextDataUnit__c = 'test';
        //ansOpt1.Contextdata__c = 12;
        ansOpt1.QuestionId__c = per_quesAns.Id;
        insert ansOpt1;
        
        QuestionAnswer__c quesAnsc1 = new QuestionAnswer__c();
        quesAnsc1.AnswerType__c = 'Boolean';
        quesAnsc1.Agent__c = agent.Id; 
        quesAnsc1.Question__c = 'test Question';
        quesAnsc1.Type__c = 'Test';
        quesAnsc1.Parent_Question_Answer__c = per_quesAns.Id;
        insert quesAnsc1;
        
        QuestionAnswer__c quesAnsch1 = new QuestionAnswer__c();
        quesAnsch1.AnswerType__c = 'Picklist';
        quesAnsch1.Agent__c = agent.Id; 
        quesAnsch1.Question__c = 'test Question';
        quesAnsch1.Type__c = 'Test';
        quesAnsch1.PickList_Values__c = '345,345,43,543';
        quesAnsch1.Parent_Question_Answer__c = per_quesAns.Id;
        insert quesAnsch1;
        
        QuestionAnswer__c quesAnsch2 = new QuestionAnswer__c();
        quesAnsch2.AnswerType__c = 'Picklist (Multi-Select)';
        quesAnsch2.Agent__c = agent.Id; 
        quesAnsch2.Question__c = 'test Question';
        quesAnsch2.Type__c = 'Test';
        quesAnsch2.Parent_Question_Answer__c = per_quesAns.Id;
        quesAnsch2.PickList_Values__c = '345,345,43,543';
        insert quesAnsch2;
        
        QuestionAnswer__c quesAnsch3 = new QuestionAnswer__c();
        quesAnsch3.AnswerType__c = 'Text';
        quesAnsch3.Agent__c = agent.Id; 
        quesAnsch3.Question__c = 'test Question';
        quesAnsch3.Type__c = 'Test';
        quesAnsch3.Parent_Question_Answer__c = per_quesAns.Id;
        insert quesAnsch3;
        
        QuestionAnswer__c quesAnsch4 = new QuestionAnswer__c();
        quesAnsch4.AnswerType__c = 'TextArea';
        quesAnsch4.Agent__c = agent.Id; 
        quesAnsch4.Question__c = 'test Question';
        quesAnsch4.Type__c = 'Test';
        quesAnsch4.Parent_Question_Answer__c = per_quesAns.Id;
        insert quesAnsch4;
        
        QuestionAnswer__c quesAnsch5 = new QuestionAnswer__c();
        quesAnsch5.AnswerType__c = 'Date';
        quesAnsch5.Arm__c = arm.Id;
        quesAnsch5.Question__c = 'test Question';
        quesAnsch5.Type__c = 'Test';
        quesAnsch5.Parent_Question_Answer__c = per_quesAns.Id;
        quesAnsch5.Agent__c = agent.Id; 
        insert quesAnsch5;
        
        AnswerOption__c ansOptCh = new AnswerOption__c();
        ansOptCh.ContextDataUnit__c = 'test';
        //ansOptCh.Contextdata__c = 2;
        ansOptCh.QuestionId__c = quesAnsc1.Id;
        insert ansOptCh;
        
        QuestionAnswer__c quesAnsp2 = new QuestionAnswer__c();
        quesAnsp2.AnswerType__c = 'Text';
        quesAnsp2.Arm__c = arm.Id;
        quesAnsp2.Question__c = 'test Question';
        quesAnsp2.Type__c = 'Test';
        quesAnsp2.Agent__c = agent.Id; 
        insert quesAnsp2;
        
        QuestionAnswer__c quesAnsp3 = new QuestionAnswer__c();
        quesAnsp3.AnswerType__c = 'TextArea';
        quesAnsp3.Arm__c = arm.Id;
        quesAnsp3.Question__c = 'test Question';
        quesAnsp3.Type__c = 'Test';
        quesAnsp3.Agent__c = agent.Id; 
        insert quesAnsp3;
        
        QuestionAnswer__c quesAnsp4 = new QuestionAnswer__c();
        quesAnsp4.AnswerType__c = 'Picklist';
        quesAnsp4.Arm__c = arm.Id;
        quesAnsp4.Question__c = 'test';
        quesAnsp4.PickList_Values__c = '123,123,123,123';
        quesAnsp4.Type__c = 'Test';
        quesAnsp4.Agent__c = agent.Id; 
        insert quesAnsp4;
        
        AnswerOption__c ansOptCh4 = new AnswerOption__c();
        ansOptCh4.ContextDataUnit__c = 'test';
        //ansOptCh.Contextdata__c = 2;
        ansOptCh4.QuestionId__c = quesAnsp4.Id;
        insert ansOptCh4;
        
        QuestionAnswer__c quesAnsp5 = new QuestionAnswer__c();
        quesAnsp5.AnswerType__c = 'Picklist (Multi-Select)';
        quesAnsp5.Arm__c = arm.Id;
        quesAnsp5.Question__c = 'test';
        quesAnsp5.PickList_Values__c = '123,123,123,123';
        quesAnsp5.Type__c = 'Test';
        quesAnsp5.Agent__c = agent.Id;      
        insert quesAnsp5;
        
        AnswerOption__c ansOptCh5 = new AnswerOption__c();
        ansOptCh5.ContextDataUnit__c = 'test';
        //ansOptCh.Contextdata__c = 2;
        ansOptCh5.QuestionId__c = quesAnsp5.Id;
        insert ansOptCh5;
        
        System.debug('quesAnsp5.CreatedDate : '+quesAnsp5.CreatedDate);
        
        QuestionAnswer__c quesAnsp6 = new QuestionAnswer__c();
        quesAnsp6.AnswerType__c = 'Date';
        quesAnsp6.Arm__c = arm.Id;
        quesAnsp6.Question__c = 'test Question';
        quesAnsp6.Type__c = 'Test';
        quesAnsp6.Agent__c = agent.Id; 
        insert quesAnsp6;
        
        CRFAdditionalQuestion__c crfAddQues = new CRFAdditionalQuestion__c();
        crfAddQues.CRFId__c = labAndTest.Id;
        crfAddQues.QuestionAnswer__c = quesAnsp6.Id;
        crfAddQues.Answer__c = String.valueOf(System.today());
        insert crfAddQues;
        
        AnswerOption__c CRFansOpt = new AnswerOption__c();
        CRFansOpt.ContextDataUnit__c = 'test';
        CRFansOpt.CRFAdditionalQuestion__c = crfAddQues.Id;
        insert CRFansOpt;
        
        CRFAdditionalQuestion__c crfAddQues1 = new CRFAdditionalQuestion__c();
        crfAddQues1.CRFId__c = labAndTest.Id;
        crfAddQues1.QuestionAnswer__c = quesAnsp4.Id;
        crfAddQues1.Answer__c = 'Test';
        insert crfAddQues1;
        
        CRFAdditionalQuestion__c crfAddQues5 = new CRFAdditionalQuestion__c();
        crfAddQues5.CRFId__c = labAndTest.Id;
        crfAddQues5.QuestionAnswer__c = quesAnsp5.Id;
        crfAddQues5.Answer__c = 'Test';
        insert crfAddQues5;
        
        CRFAdditionalQuestion__c crfAddQues2 = new CRFAdditionalQuestion__c();
        crfAddQues2.CRFId__c = labAndTest.Id;
        crfAddQues2.QuestionAnswer__c = quesAnsp2.Id;
        crfAddQues2.Answer__c = 'Test';
        insert crfAddQues2;
        
        CRFAdditionalQuestion__c crfAddQues3 = new CRFAdditionalQuestion__c();
        crfAddQues3.CRFId__c = labAndTest.Id;
        crfAddQues3.QuestionAnswer__c = quesAnsp3.Id;
        crfAddQues3.Answer__c = 'Test';
        insert crfAddQues3;
        
        CRFAdditionalQuestion__c crfAddQues7 = new CRFAdditionalQuestion__c();
        crfAddQues7.CRFId__c = labAndTest.Id;
        crfAddQues7.QuestionAnswer__c = per_quesAns.Id;
        crfAddQues7.Answer__c = 'Test';
        insert crfAddQues7;
        
        
        AdditionalQuestionControllerReadOnly addQuesCon2 = new AdditionalQuestionControllerReadOnly();
        addQuesCon2.getlstQuesAnsWrapper();
        
        /*addQuesCon2.Questiontype = 'Test';
        addQuesCon2.CRFType = '00055';
        addQuesCon2.isReadOnly = true;
        addQuesCon2.CRFId = labAndTest.Id;
        addQuesCon2.armId = arm.Id;
        addQuesCon2.Questiontype = 'Test'; 
        addQuesCon2.lstQuesAnsWrapper = addQuesCon2.getlstQuesAnsWrapper();
        
        addQuesCon2.saveComponent(labAndTest.Id);
        addQuesCon2.CRFId = labAndTest.Id;
        addQuesCon2.lstQuesAnsWrapper = addQuesCon2.getlstQuesAnsWrapper();
        addQuesCon2.setlstQuesAnsWrapper(addQuesCon2.lstQuesAnsWrapper);
        addQuesCon2.saveComponent(labAndTest.Id);
        
        AdditionalQuestionControllerReadOnly addQuesCon3 = new AdditionalQuestionControllerReadOnly();
        addQuesCon2.lstQuesAnsWrapper = addQuesCon2.getlstQuesAnsWrapper();
        addQuesCon3.Questiontype = 'Test';
        addQuesCon3.CRFType = '00055';
        addQuesCon3.CRFId = ose.Id;
        addQuesCon3.armId = arm.Id;
        addQuesCon3.Questiontype = 'Test'; 
        addQuesCon3.lstQuesAnsWrapper = addQuesCon2.getlstQuesAnsWrapper();*/
        
    }
    
        @isTest static void AddQuesUnitTest1() {
        
	        Account acc = new Account();
	        
	        List<Account> lstAccount = [Select a.Id From Account a limit 1];
	        
	        if(lstAccount.isEmpty()) return;
	            
	        acc = lstAccount[0];
	        
	        Patient_Custom__c p = new Patient_Custom__c();
	        p.Ethnicity__c = 'Hispanic or latino';
	        p.Gender__c = 'female';
	        p.Race__c = 'asian;indian';
	        p.Last_Name__c = 'kumar';
	        p.Status__c = 'approval not required';
	        p.Birthdate__c = date.newInstance(1950, 08, 05);
	        p.Institution__c = acc.Id;
	        insert p;
	        
	        List<Patient_Custom__c> lstPatient = [select Name from Patient_Custom__c where Id = :P.Id];
	        
	        TrialPatient__c tp = new TrialPatient__c();
	        tp.Patient_Id__c = p.Id;
	        tp.FirstName__c = 'a';
	        tp.LastName__c = 'b';
	        insert tp;
	        
	        On_Study_Eligibility_Form__c ose = new On_Study_Eligibility_Form__c();
	        ose.TrialPatient__c = tp.Id;
	        ose.How_was_the_cancer_first_detected__c = 'Clinical exam'; 
	        ose.Status__c = 'Accepted';
	        insert ose;
	         
	        
	        Lab_and_Test__c labAndTest1 = new Lab_and_Test__c();
	        labAndTest1.TrialPatient__c = tp.Id;
	        insert labAndTest1;
	        
	        Lab_and_Test__c labAndTest = new Lab_and_Test__c();
	        labAndTest.TrialPatient__c = tp.Id;
	        insert labAndTest;
	        System.debug('labAndTest.CreatedDate : '+labAndTest.CreatedDate);
	        
	        Arm__c arm = new Arm__c();
	        arm.Name = 'Test Arm';
	        insert arm;
	        
	        Agent__c agent = new Agent__c();
	        agent.Name = 'Test Arm';
	        insert agent;
	        
	        QuestionAnswer__c per_quesAns = new QuestionAnswer__c();
	        per_quesAns.AnswerType__c = 'Boolean';
	        per_quesAns.Agent__c = agent.Id; 
	        per_quesAns.Question__c = 'test Question';
	        per_quesAns.Type__c = 'Test';
	        insert per_quesAns;
	        
	        QuestionAnswer__c per_quesAns1 = new QuestionAnswer__c();
	        per_quesAns1.AnswerType__c = 'Boolean';
	        per_quesAns1.Agent__c = agent.Id; 
	        per_quesAns1.Question__c = 'test Question';
	        per_quesAns1.Type__c = 'Test';
	        insert per_quesAns1;
	        
	        AnswerOption__c ansOpt1 = new AnswerOption__c();
	        ansOpt1.ContextDataUnit__c = 'test';
	        //ansOpt1.Contextdata__c = 12;
	        ansOpt1.QuestionId__c = per_quesAns.Id;
	        insert ansOpt1;
	        
	        QuestionAnswer__c quesAnsc1 = new QuestionAnswer__c();
	        quesAnsc1.AnswerType__c = 'Boolean';
	        quesAnsc1.Agent__c = agent.Id; 
	        quesAnsc1.Question__c = 'test Question';
	        quesAnsc1.Type__c = 'Test';
	        quesAnsc1.Parent_Question_Answer__c = per_quesAns.Id;
	        insert quesAnsc1;
	        
	        QuestionAnswer__c quesAnsch1 = new QuestionAnswer__c();
	        quesAnsch1.AnswerType__c = 'Picklist';
	        quesAnsch1.Agent__c = agent.Id; 
	        quesAnsch1.Question__c = 'test Question';
	        quesAnsch1.Type__c = 'Test';
	        quesAnsch1.PickList_Values__c = '345,345,43,543';
	        quesAnsch1.Parent_Question_Answer__c = per_quesAns.Id;
	        insert quesAnsch1;
	        
	        QuestionAnswer__c quesAnsch2 = new QuestionAnswer__c();
	        quesAnsch2.AnswerType__c = 'Picklist (Multi-Select)';
	        quesAnsch2.Agent__c = agent.Id; 
	        quesAnsch2.Question__c = 'test Question';
	        quesAnsch2.Type__c = 'Test';
	        quesAnsch2.Parent_Question_Answer__c = per_quesAns.Id;
	        quesAnsch2.PickList_Values__c = '345,345,43,543';
	        insert quesAnsch2;
	        
	        QuestionAnswer__c quesAnsch3 = new QuestionAnswer__c();
	        quesAnsch3.AnswerType__c = 'Text';
	        quesAnsch3.Agent__c = agent.Id; 
	        quesAnsch3.Question__c = 'test Question';
	        quesAnsch3.Type__c = 'Test';
	        quesAnsch3.Parent_Question_Answer__c = per_quesAns.Id;
	        insert quesAnsch3;
	        
	        QuestionAnswer__c quesAnsch4 = new QuestionAnswer__c();
	        quesAnsch4.AnswerType__c = 'TextArea';
	        quesAnsch4.Agent__c = agent.Id; 
	        quesAnsch4.Question__c = 'test Question';
	        quesAnsch4.Type__c = 'Test';
	        quesAnsch4.Parent_Question_Answer__c = per_quesAns.Id;
	        insert quesAnsch4;
	        
	        QuestionAnswer__c quesAnsch5 = new QuestionAnswer__c();
	        quesAnsch5.AnswerType__c = 'Date';
	        quesAnsch5.Arm__c = arm.Id;
	        quesAnsch5.Question__c = 'test Question';
	        quesAnsch5.Type__c = 'Test';
	        quesAnsch5.Parent_Question_Answer__c = per_quesAns.Id;
	        quesAnsch5.Agent__c = agent.Id; 
	        insert quesAnsch5;
	        
	        AnswerOption__c ansOptCh = new AnswerOption__c();
	        ansOptCh.ContextDataUnit__c = 'test';
	        //ansOptCh.Contextdata__c = 2;
	        ansOptCh.QuestionId__c = quesAnsc1.Id;
	        insert ansOptCh;
	        
	        QuestionAnswer__c quesAnsp2 = new QuestionAnswer__c();
	        quesAnsp2.AnswerType__c = 'Text';
	        quesAnsp2.Arm__c = arm.Id;
	        quesAnsp2.Question__c = 'test Question';
	        quesAnsp2.Type__c = 'Test';
	        quesAnsp2.Agent__c = agent.Id; 
	        insert quesAnsp2;
	        
	        QuestionAnswer__c quesAnsp3 = new QuestionAnswer__c();
	        quesAnsp3.AnswerType__c = 'TextArea';
	        quesAnsp3.Arm__c = arm.Id;
	        quesAnsp3.Question__c = 'test Question';
	        quesAnsp3.Type__c = 'Test';
	        quesAnsp3.Agent__c = agent.Id; 
	        insert quesAnsp3;
	        
	        QuestionAnswer__c quesAnsp4 = new QuestionAnswer__c();
	        quesAnsp4.AnswerType__c = 'Picklist';
	        quesAnsp4.Arm__c = arm.Id;
	        quesAnsp4.Question__c = 'test';
	        quesAnsp4.PickList_Values__c = '123,123,123,123';
	        quesAnsp4.Type__c = 'Test';
	        quesAnsp4.Agent__c = agent.Id; 
	        insert quesAnsp4;
	        
	        AnswerOption__c ansOptCh4 = new AnswerOption__c();
	        ansOptCh4.ContextDataUnit__c = 'test';
	        //ansOptCh.Contextdata__c = 2;
	        ansOptCh4.QuestionId__c = quesAnsp4.Id;
	        insert ansOptCh4;
	        
	        QuestionAnswer__c quesAnsp5 = new QuestionAnswer__c();
	        quesAnsp5.AnswerType__c = 'Picklist (Multi-Select)';
	        quesAnsp5.Arm__c = arm.Id;
	        quesAnsp5.Question__c = 'test';
	        quesAnsp5.PickList_Values__c = '123,123,123,123';
	        quesAnsp5.Type__c = 'Test';
	        quesAnsp5.Agent__c = agent.Id;      
	        insert quesAnsp5;
	        
	        AnswerOption__c ansOptCh5 = new AnswerOption__c();
	        ansOptCh5.ContextDataUnit__c = 'test';
	        //ansOptCh.Contextdata__c = 2;
	        ansOptCh5.QuestionId__c = quesAnsp5.Id;
	        insert ansOptCh5;
	        
	        System.debug('quesAnsp5.CreatedDate : '+quesAnsp5.CreatedDate);
	        
	        QuestionAnswer__c quesAnsp6 = new QuestionAnswer__c();
	        quesAnsp6.AnswerType__c = 'Date';
	        quesAnsp6.Arm__c = arm.Id;
	        quesAnsp6.Question__c = 'test Question';
	        quesAnsp6.Type__c = 'Test';
	        quesAnsp6.Agent__c = agent.Id; 
	        insert quesAnsp6;
	        
	        CRFAdditionalQuestion__c crfAddQues = new CRFAdditionalQuestion__c();
	        crfAddQues.CRFId__c = labAndTest.Id;
	        crfAddQues.QuestionAnswer__c = quesAnsp6.Id;
	        crfAddQues.Answer__c = String.valueOf(System.today());
	        insert crfAddQues;
	        
	        AnswerOption__c CRFansOpt = new AnswerOption__c();
	        CRFansOpt.ContextDataUnit__c = 'test';
	        CRFansOpt.CRFAdditionalQuestion__c = crfAddQues.Id;
	        insert CRFansOpt;
	        
	        CRFAdditionalQuestion__c crfAddQues1 = new CRFAdditionalQuestion__c();
	        crfAddQues1.CRFId__c = labAndTest.Id;
	        crfAddQues1.QuestionAnswer__c = quesAnsp4.Id;
	        crfAddQues1.Answer__c = 'Test';
	        insert crfAddQues1;
	        
	        CRFAdditionalQuestion__c crfAddQues5 = new CRFAdditionalQuestion__c();
	        crfAddQues5.CRFId__c = labAndTest.Id;
	        crfAddQues5.QuestionAnswer__c = quesAnsp5.Id;
	        crfAddQues5.Answer__c = 'Test';
	        insert crfAddQues5;
	        
	        CRFAdditionalQuestion__c crfAddQues2 = new CRFAdditionalQuestion__c();
	        crfAddQues2.CRFId__c = labAndTest.Id;
	        crfAddQues2.QuestionAnswer__c = quesAnsp2.Id;
	        crfAddQues2.Answer__c = 'Test';
	        insert crfAddQues2;
	        
	        CRFAdditionalQuestion__c crfAddQues3 = new CRFAdditionalQuestion__c();
	        crfAddQues3.CRFId__c = labAndTest.Id;
	        crfAddQues3.QuestionAnswer__c = quesAnsp3.Id;
	        crfAddQues3.Answer__c = 'Test';
	        insert crfAddQues3;
	        
	        CRFAdditionalQuestion__c crfAddQues7 = new CRFAdditionalQuestion__c();
	        crfAddQues7.CRFId__c = labAndTest.Id;
	        crfAddQues7.QuestionAnswer__c = per_quesAns.Id;
	        crfAddQues7.Answer__c = 'Test';
	        insert crfAddQues7;
	        
	        
	        AdditionalQuestionControllerReadOnly addQuesCon2 = new AdditionalQuestionControllerReadOnly();
	        addQuesCon2.Questiontype = 'Test';
	        addQuesCon2.CRFType = '00055';
	        addQuesCon2.isReadOnly = true;
	        addQuesCon2.CRFId = labAndTest.Id;
	        addQuesCon2.armId = arm.Id;
	        addQuesCon2.Questiontype = 'Test'; 
	        addQuesCon2.lstQuesAnsWrapper = addQuesCon2.getlstQuesAnsWrapper();
	        
	        /*addQuesCon2.saveComponent(labAndTest.Id);
	        addQuesCon2.CRFId = labAndTest.Id;
	        addQuesCon2.lstQuesAnsWrapper = addQuesCon2.getlstQuesAnsWrapper();
	        addQuesCon2.setlstQuesAnsWrapper(addQuesCon2.lstQuesAnsWrapper);
	        addQuesCon2.saveComponent(labAndTest.Id);
	        
	        AdditionalQuestionControllerReadOnly addQuesCon3 = new AdditionalQuestionControllerReadOnly();
	        addQuesCon2.lstQuesAnsWrapper = addQuesCon2.getlstQuesAnsWrapper();
	        addQuesCon3.Questiontype = 'Test';
	        addQuesCon3.CRFType = '00055';
	        addQuesCon3.CRFId = ose.Id;
	        addQuesCon3.armId = arm.Id;
	        addQuesCon3.Questiontype = 'Test'; 
	        addQuesCon3.lstQuesAnsWrapper = addQuesCon2.getlstQuesAnsWrapper();*/
        
    	}
    	
    	@isTest static void AddQuesUnitTest2() {
        
	        Account acc = new Account();
	        
	        List<Account> lstAccount = [Select a.Id From Account a limit 1];
	        
	        if(lstAccount.isEmpty()) return;
	            
	        acc = lstAccount[0];
	        
	        Patient_Custom__c p = new Patient_Custom__c();
	        p.Ethnicity__c = 'Hispanic or latino';
	        p.Gender__c = 'female';
	        p.Race__c = 'asian;indian';
	        p.Last_Name__c = 'kumar';
	        p.Status__c = 'approval not required';
	        p.Birthdate__c = date.newInstance(1950, 08, 05);
	        p.Institution__c = acc.Id;
	        insert p;
	        
	        List<Patient_Custom__c> lstPatient = [select Name from Patient_Custom__c where Id = :P.Id];
	        
	        TrialPatient__c tp = new TrialPatient__c();
	        tp.Patient_Id__c = p.Id;
	        tp.FirstName__c = 'a';
	        tp.LastName__c = 'b';
	        insert tp;
	        
	        On_Study_Eligibility_Form__c ose = new On_Study_Eligibility_Form__c();
	        ose.TrialPatient__c = tp.Id;
	        ose.How_was_the_cancer_first_detected__c = 'Clinical exam'; 
	        ose.Status__c = 'Accepted';
	        insert ose;
	         
	        
	        Lab_and_Test__c labAndTest1 = new Lab_and_Test__c();
	        labAndTest1.TrialPatient__c = tp.Id;
	        insert labAndTest1;
	        
	        Lab_and_Test__c labAndTest = new Lab_and_Test__c();
	        labAndTest.TrialPatient__c = tp.Id;
	        insert labAndTest;
	        System.debug('labAndTest.CreatedDate : '+labAndTest.CreatedDate);
	        
	        Arm__c arm = new Arm__c();
	        arm.Name = 'Test Arm';
	        insert arm;
	        
	        Agent__c agent = new Agent__c();
	        agent.Name = 'Test Arm';
	        insert agent;
	        
	        QuestionAnswer__c per_quesAns = new QuestionAnswer__c();
	        per_quesAns.AnswerType__c = 'Boolean';
	        per_quesAns.Agent__c = agent.Id; 
	        per_quesAns.Question__c = 'test Question';
	        per_quesAns.Type__c = 'Test';
	        insert per_quesAns;
	        
	        QuestionAnswer__c per_quesAns1 = new QuestionAnswer__c();
	        per_quesAns1.AnswerType__c = 'Boolean';
	        per_quesAns1.Agent__c = agent.Id; 
	        per_quesAns1.Question__c = 'test Question';
	        per_quesAns1.Type__c = 'Test';
	        insert per_quesAns1;
	        
	        AnswerOption__c ansOpt1 = new AnswerOption__c();
	        ansOpt1.ContextDataUnit__c = 'test';
	        //ansOpt1.Contextdata__c = 12;
	        ansOpt1.QuestionId__c = per_quesAns.Id;
	        insert ansOpt1;
	        
	        QuestionAnswer__c quesAnsc1 = new QuestionAnswer__c();
	        quesAnsc1.AnswerType__c = 'Boolean';
	        quesAnsc1.Agent__c = agent.Id; 
	        quesAnsc1.Question__c = 'test Question';
	        quesAnsc1.Type__c = 'Test';
	        quesAnsc1.Parent_Question_Answer__c = per_quesAns.Id;
	        insert quesAnsc1;
	        
	        QuestionAnswer__c quesAnsch1 = new QuestionAnswer__c();
	        quesAnsch1.AnswerType__c = 'Picklist';
	        quesAnsch1.Agent__c = agent.Id; 
	        quesAnsch1.Question__c = 'test Question';
	        quesAnsch1.Type__c = 'Test';
	        quesAnsch1.PickList_Values__c = '345,345,43,543';
	        quesAnsch1.Parent_Question_Answer__c = per_quesAns.Id;
	        insert quesAnsch1;
	        
	        QuestionAnswer__c quesAnsch2 = new QuestionAnswer__c();
	        quesAnsch2.AnswerType__c = 'Picklist (Multi-Select)';
	        quesAnsch2.Agent__c = agent.Id; 
	        quesAnsch2.Question__c = 'test Question';
	        quesAnsch2.Type__c = 'Test';
	        quesAnsch2.Parent_Question_Answer__c = per_quesAns.Id;
	        quesAnsch2.PickList_Values__c = '345,345,43,543';
	        insert quesAnsch2;
	        
	        QuestionAnswer__c quesAnsch3 = new QuestionAnswer__c();
	        quesAnsch3.AnswerType__c = 'Text';
	        quesAnsch3.Agent__c = agent.Id; 
	        quesAnsch3.Question__c = 'test Question';
	        quesAnsch3.Type__c = 'Test';
	        quesAnsch3.Parent_Question_Answer__c = per_quesAns.Id;
	        insert quesAnsch3;
	        
	        QuestionAnswer__c quesAnsch4 = new QuestionAnswer__c();
	        quesAnsch4.AnswerType__c = 'TextArea';
	        quesAnsch4.Agent__c = agent.Id; 
	        quesAnsch4.Question__c = 'test Question';
	        quesAnsch4.Type__c = 'Test';
	        quesAnsch4.Parent_Question_Answer__c = per_quesAns.Id;
	        insert quesAnsch4;
	        
	        QuestionAnswer__c quesAnsch5 = new QuestionAnswer__c();
	        quesAnsch5.AnswerType__c = 'Date';
	        quesAnsch5.Arm__c = arm.Id;
	        quesAnsch5.Question__c = 'test Question';
	        quesAnsch5.Type__c = 'Test';
	        quesAnsch5.Parent_Question_Answer__c = per_quesAns.Id;
	        quesAnsch5.Agent__c = agent.Id; 
	        insert quesAnsch5;
	        
	        AnswerOption__c ansOptCh = new AnswerOption__c();
	        ansOptCh.ContextDataUnit__c = 'test';
	        //ansOptCh.Contextdata__c = 2;
	        ansOptCh.QuestionId__c = quesAnsc1.Id;
	        insert ansOptCh;
	        
	        QuestionAnswer__c quesAnsp2 = new QuestionAnswer__c();
	        quesAnsp2.AnswerType__c = 'Text';
	        quesAnsp2.Arm__c = arm.Id;
	        quesAnsp2.Question__c = 'test Question';
	        quesAnsp2.Type__c = 'Test';
	        quesAnsp2.Agent__c = agent.Id; 
	        insert quesAnsp2;
	        
	        QuestionAnswer__c quesAnsp3 = new QuestionAnswer__c();
	        quesAnsp3.AnswerType__c = 'TextArea';
	        quesAnsp3.Arm__c = arm.Id;
	        quesAnsp3.Question__c = 'test Question';
	        quesAnsp3.Type__c = 'Test';
	        quesAnsp3.Agent__c = agent.Id; 
	        insert quesAnsp3;
	        
	        QuestionAnswer__c quesAnsp4 = new QuestionAnswer__c();
	        quesAnsp4.AnswerType__c = 'Picklist';
	        quesAnsp4.Arm__c = arm.Id;
	        quesAnsp4.Question__c = 'test';
	        quesAnsp4.PickList_Values__c = '123,123,123,123';
	        quesAnsp4.Type__c = 'Test';
	        quesAnsp4.Agent__c = agent.Id; 
	        insert quesAnsp4;
	        
	        AnswerOption__c ansOptCh4 = new AnswerOption__c();
	        ansOptCh4.ContextDataUnit__c = 'test';
	        //ansOptCh.Contextdata__c = 2;
	        ansOptCh4.QuestionId__c = quesAnsp4.Id;
	        insert ansOptCh4;
	        
	        QuestionAnswer__c quesAnsp5 = new QuestionAnswer__c();
	        quesAnsp5.AnswerType__c = 'Picklist (Multi-Select)';
	        quesAnsp5.Arm__c = arm.Id;
	        quesAnsp5.Question__c = 'test';
	        quesAnsp5.PickList_Values__c = '123,123,123,123';
	        quesAnsp5.Type__c = 'Test';
	        quesAnsp5.Agent__c = agent.Id;      
	        insert quesAnsp5;
	        
	        AnswerOption__c ansOptCh5 = new AnswerOption__c();
	        ansOptCh5.ContextDataUnit__c = 'test';
	        //ansOptCh.Contextdata__c = 2;
	        ansOptCh5.QuestionId__c = quesAnsp5.Id;
	        insert ansOptCh5;
	        
	        System.debug('quesAnsp5.CreatedDate : '+quesAnsp5.CreatedDate);
	        
	        QuestionAnswer__c quesAnsp6 = new QuestionAnswer__c();
	        quesAnsp6.AnswerType__c = 'Date';
	        quesAnsp6.Arm__c = arm.Id;
	        quesAnsp6.Question__c = 'test Question';
	        quesAnsp6.Type__c = 'Test';
	        quesAnsp6.Agent__c = agent.Id; 
	        insert quesAnsp6;
	        
	        CRFAdditionalQuestion__c crfAddQues = new CRFAdditionalQuestion__c();
	        crfAddQues.CRFId__c = labAndTest.Id;
	        crfAddQues.QuestionAnswer__c = quesAnsp6.Id;
	        crfAddQues.Answer__c = String.valueOf(System.today());
	        insert crfAddQues;
	        
	        AnswerOption__c CRFansOpt = new AnswerOption__c();
	        CRFansOpt.ContextDataUnit__c = 'test';
	        CRFansOpt.CRFAdditionalQuestion__c = crfAddQues.Id;
	        insert CRFansOpt;
	        
	        CRFAdditionalQuestion__c crfAddQues1 = new CRFAdditionalQuestion__c();
	        crfAddQues1.CRFId__c = labAndTest.Id;
	        crfAddQues1.QuestionAnswer__c = quesAnsp4.Id;
	        crfAddQues1.Answer__c = 'Test';
	        insert crfAddQues1;
	        
	        CRFAdditionalQuestion__c crfAddQues5 = new CRFAdditionalQuestion__c();
	        crfAddQues5.CRFId__c = labAndTest.Id;
	        crfAddQues5.QuestionAnswer__c = quesAnsp5.Id;
	        crfAddQues5.Answer__c = 'Test';
	        insert crfAddQues5;
	        
	        CRFAdditionalQuestion__c crfAddQues2 = new CRFAdditionalQuestion__c();
	        crfAddQues2.CRFId__c = labAndTest.Id;
	        crfAddQues2.QuestionAnswer__c = quesAnsp2.Id;
	        crfAddQues2.Answer__c = 'Test';
	        insert crfAddQues2;
	        
	        CRFAdditionalQuestion__c crfAddQues3 = new CRFAdditionalQuestion__c();
	        crfAddQues3.CRFId__c = labAndTest.Id;
	        crfAddQues3.QuestionAnswer__c = quesAnsp3.Id;
	        crfAddQues3.Answer__c = 'Test';
	        insert crfAddQues3;
	        
	        CRFAdditionalQuestion__c crfAddQues7 = new CRFAdditionalQuestion__c();
	        crfAddQues7.CRFId__c = labAndTest.Id;
	        crfAddQues7.QuestionAnswer__c = per_quesAns.Id;
	        crfAddQues7.Answer__c = 'Test';
	        insert crfAddQues7;
	        
	        
	        AdditionalQuestionControllerReadOnly addQuesCon2 = new AdditionalQuestionControllerReadOnly();
	        addQuesCon2.saveComponent(labAndTest.Id);
	        addQuesCon2.CRFId = labAndTest.Id;
	        addQuesCon2.lstQuesAnsWrapper = addQuesCon2.getlstQuesAnsWrapper();
	        addQuesCon2.setlstQuesAnsWrapper(addQuesCon2.lstQuesAnsWrapper);
	        addQuesCon2.saveComponent(labAndTest.Id);
	        
	        /*AdditionalQuestionControllerReadOnly addQuesCon3 = new AdditionalQuestionControllerReadOnly();
	        addQuesCon2.lstQuesAnsWrapper = addQuesCon2.getlstQuesAnsWrapper();
	        addQuesCon3.Questiontype = 'Test';
	        addQuesCon3.CRFType = '00055';
	        addQuesCon3.CRFId = ose.Id;
	        addQuesCon3.armId = arm.Id;
	        addQuesCon3.Questiontype = 'Test'; 
	        addQuesCon3.lstQuesAnsWrapper = addQuesCon2.getlstQuesAnsWrapper();*/
        
    	}
}