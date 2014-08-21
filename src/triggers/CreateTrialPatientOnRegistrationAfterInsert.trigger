trigger CreateTrialPatientOnRegistrationAfterInsert on Registration__c (after insert, before insert, after update, before update) {

    Id currentUserId = Userinfo.getUserId();
    User u = [select Contact.Site__c, ContactId from User where id = :Userinfo.getUserId()];
    
    //==========loop for creating patient Id set===========================================
    Set<Id> patientIdSet = new Set<Id>();
    Set<Id> regTrialId = new Set<Id>();
    Set<Id> patientInstituteId = new Set<Id>();
    for(Registration__c regTmp : Trigger.new) {
        patientIdSet.add(regTmp.Patient__c);
        regTrialId.add(regTmp.Trial__c);
        patientInstituteId.add(regTmp.Institution__c);
    }

//=======================get patient for set of IDs=====================================================================    
    List<Patient_Custom__c> patientList = [select p.Zip__c, p.VIP__c, p.Unsigned_Patient_Last_Name__c, p.Unsigned_Patient_First_Name__c, p.Surgeon__c, p.Suffix__c, p.Study_Registration_Eligibility__c, p.Status__c, p.State__c, p.Signed_Screening__c, p.Screen_Failure_Number__c, p.SSN__c, p.RecordTypeId, p.Race__c, p.Primary_MD__c, p.OwnerId, p.Name, p.Middle_Name__c, p.Medical_Record_Number__c, p.Last_Name__c, p.Institution__c, p.Institute_Text__c, p.Initials__c, p.Id, p.Gender__c, p.First_Name__c, p.Ethnicity__c, p.Country_of_Birth__c, p.Country__c, p.City__c, p.Birthdate__c, p.Age__c, p.Address_Line_2__c, p.Address_Line_1__c From Patient_Custom__c p where Id IN :patientIdSet];
    
    List<RecordType> regRecTypeList = [select id,Name from RecordType where sObjectType = 'Registration__c' order by Name];
    List<RecordType> recTypeAdHoc = new List<RecordType>{regRecTypeList[0]};
    List<RecordType> recTypeAppPending = new List<RecordType>{regRecTypeList[1]};
    List<RecordType> recTypeLive = new List<RecordType>{regRecTypeList[2]};
     
    
    if(Trigger.isAfter) {
        
        system.debug('__userId__'+Userinfo.getUserId());
    //=======================get DCC name from InstitutionTrialDcc object by matching institutes and trials=======================================
        List<InstitutionTrialDcc__c> instTrialDcc = [select DCC_Id__c, DCC_Id__r.Inst_Group__c, Institution_Id__c, Trial_Id__c from InstitutionTrialDcc__c where Institution_Id__c IN :patientInstituteId and Trial_Id__c IN :regTrialId];
        
        system.debug('__instTrialDcc__'+instTrialDcc);
        
        Set<String> dccNameSet = new Set<String>(); 
        for (InstitutionTrialDcc__c tmpInstTrailList : instTrialDcc) {
            for (Registration__c tmpRegList : Trigger.new) {
                if(tmpInstTrailList.Institution_Id__c == tmpRegList.Institution__c && tmpInstTrailList.Trial_Id__c == tmpRegList.Trial__c){
                    dccNameSet.add(tmpInstTrailList.DCC_Id__r.Inst_Group__c);
                }
            }
        }
        
        system.debug('__dccNameSet__'+dccNameSet);
        
    //============================get Group Member's Id from GroupMember=============================================================
        List<GroupMember> groupMemList = [select UserOrGroupId, Group.Name, GroupId from GroupMember where Group.Name IN :dccNameSet and Group.Type!='Queue'];
        List<Group> lstGrp = [select Id,Name,Type from Group where Name IN : dccNameSet and Type != 'Queue'];
        Set<Id> groupUserIdSet = new Set<Id>(); 
        for(GroupMember tmpList : groupMemList) {
        
            groupUserIdSet.add(tmpList.UserOrGroupId);
        }
        
        system.debug('__groupUserIdSet__'+groupUserIdSet);
        
        List<User> groupUserList = [select Email, Id from User where Id IN :groupUserIdSet and IsActive = true];
        //List<String> recEmail = new List<String>();
        Map<Id, String> userEmailMap = new Map<Id, String>(); 
        for (User tmpList : groupUserList) {
        
            //recEmail.add(tmpList.Email);
            userEmailMap.put(tmpList.Id, tmpList.Email);
        }
        
        system.debug('__userEmailMap__'+userEmailMap);
        if(Trigger.isUpdate) {
            //List<Patient_Custom__c> updatePatientList = new List<Patient_Custom__c>();
            for(Registration__c regTmp : Trigger.new) {
                //No need to send email until registration is Live
                system.debug('__RecordTypeId__'+regTmp.RecordTypeId);
                if(regTmp.RecordTypeId != recTypeAppPending[0].Id)continue;
                if(regTmp.RecordTypeId != Trigger.oldMap.get(regTmp.Id).RecordTypeId) {
                    system.debug('--------kkk--------------------->');
                    List<String> recEmail = new List<String>();
                    for (InstitutionTrialDcc__c tmpInstTrailList : instTrialDcc) {
                        for(GroupMember tmpList : groupMemList) {
                            if(tmpInstTrailList.Institution_Id__c == regTmp.Institution__c && tmpInstTrailList.Trial_Id__c == regTmp.Trial__c && tmpInstTrailList.DCC_Id__r.Inst_Group__c == tmpList.Group.Name) {
                                if(userEmailMap.containsKey(tmpList.UserOrGroupId)) {
                                    recEmail.add(userEmailMap.get(tmpList.UserOrGroupId));
                                }
                            }
                        }
                    }
                    
                    if (!recEmail.isEmpty()) {
                        
                        Messaging.Singleemailmessage mail = new Messaging.Singleemailmessage();
                        mail.setToAddresses(recEmail);
                        mail.setReplyTo('patelb@opallios.com');
                        //mail.setBccSender(true);
                        mail.setSenderDisplayName('ISPY2');
                        mail.setSubject('One patient has been registered');
                        mail.setPlainTextBody('One patient has been registered.');
                        mail.setHtmlBody('One patient has been registered. <a href="'+URL.getSalesforceBaseUrl().toExternalForm()+'/'+regTmp.Id+'">Click here</a> to see registration details.');
                        system.debug('__Mail__'+mail);
                        Messaging.sendEmail(new Messaging.Singleemailmessage[] { mail });
                        
                        //create email logs
						//build string for email Address
						String emailIdString = '';
						for(String emailStr : mail.getToAddresses()) {
							emailIdString+= emailStr+',';
						}
						if(emailIdString != '') {
							emailIdString = emailIdString.substring(0, (emailIdString.length()-1));
						}
						
						/*Email_Logs__c emailLog = new Email_Logs__c();
						emailLog.Class_Name__c = 'CreateTrialPatientOnRegistrationAfterInsert.trigger';
						emailLog.Email_Subject__c = mail.getSubject();
						emailLog.Recipient__c = emailIdString;
						emailLog.Remaining_Email_Invocation__c = (Limits.getLimitEmailInvocations() - Limits.getEmailInvocations())+' remaining out of total' +Limits.getLimitEmailInvocations();
						emailLog.Sender__c = Userinfo.getUserId();
						insert emailLog;*/
						Email_Logs__c emailLog = EmailLogsManager.createEmailLog('CreateTrialPatientOnRegistrationAfterInsert.trigger', mail.getSubject(), emailIdString);
						insert emailLog;
                    }
                }
            }
        }
        List<Registration__Share> lstRegShare = new List<Registration__Share>();
        for(Registration__c regTmp : Trigger.new) {
            
            //if(regTmp.RecordTypeId == recTypeAdHoc[0].Id)continue;
            if(regTmp.RecordTypeId != recTypeAppPending[0].Id)continue;
            if(Trigger.oldMap == null) continue;
            system.debug('regTmp : '+regTmp);
            system.debug('Trigger.oldMap : '+Trigger.oldMap);
            system.debug('Trigger.oldMap.get(regTmp.Id) : '+Trigger.oldMap.get(regTmp.Id));
            if(regTmp.RecordTypeId != Trigger.oldMap.get(regTmp.Id).RecordTypeId) {
                for (InstitutionTrialDcc__c tmpInstTrailList : instTrialDcc) {
                    for(Group tmpList : lstGrp) {
                        if(tmpInstTrailList.Institution_Id__c == regTmp.Institution__c && tmpInstTrailList.Trial_Id__c == regTmp.Trial__c && tmpInstTrailList.DCC_Id__r.Inst_Group__c == tmpList.Name) {
                            System.debug('---------tmpList.Id--------->'+tmpList.Id);
                            Registration__Share regShare = new Registration__Share();
                            regShare.AccessLevel = 'Read';
                            regShare.ParentId = regTmp.Id;
                            regShare.UserOrGroupId = tmpList.Id; 
                            lstRegShare.add(regShare);
                        }
                    }
                }
            }
        }
        set<Id> setTrial = new set<Id>();
        set<Id> setSite = new set<Id>();
        set<String> setGrpNames = new set<String>();
        List<InstitutionUser__c> lstInstUser = [select id,Institution__c,Site__c,Trial__c,User__c from InstitutionUser__c where Institution__c IN :patientInstituteId and Trial__c IN : regTrialId];
        for(InstitutionUser__c tr : lstInstUser){
            setTrial.add(tr.Trial__c);
            setSite.add(tr.Site__c);
        }
        List<Site_Trial__c> lstSiteTrial = [select id,Site__c,Trial__c,Name from Site_Trial__c where Trial__c IN : setTrial and Site__c IN : setSite];
        for(Site_Trial__c st : lstSiteTrial){
            setGrpNames.add(st.Name);
        }
        
        List<Group> lstSiteGrp = [select Id,Name,Type from Group where Name IN : setGrpNames and Type = 'Regular'];
        for(Registration__c regTmp : Trigger.new) {
            
            //No need to share record until it is Live
            if(regTmp.RecordTypeId == recTypeAdHoc[0].Id)continue;
            
            for(InstitutionUser__c insUser : lstInstUser){
                for(Site_Trial__c st : lstSiteTrial){
                    for(Group grp : lstSiteGrp){
                        if(grp.Name == st.Name && st.Trial__c == insUser.Trial__c && st.Site__c == insUser.Site__c && regTmp.Institution__c == insUser.Institution__c){
                            Registration__Share regShare = new Registration__Share();
                            regShare.AccessLevel = 'Edit';
                            regShare.ParentId = regTmp.Id;
                            regShare.UserOrGroupId = grp.Id; 
                            lstRegShare.add(regShare);
                        }
                    }
                }
            }
        }
        if(!lstRegShare.isEmpty()){
            insert lstRegShare;
        }
        
    }
//==========loop for creating Trial-Patient record===========================================   
    if(Trigger.isBefore) {
        //List<TrialPatient__c> trialPatList = new List<TrialPatient__c>();
        List<InstitutionUser__c> lstInstUserSite = [select id,Institution__c,Site__c from InstitutionUser__c where User__c =:u.Id];
        List<RecordType> lstRecordType = [select Name from RecordType where Name = 'Lab'];
        Map<Id, Id> mapSiteTrials = new Map<Id, Id>();
        List<Site_Trial__c> lstSiteTrial = [Select s.Trial__c, s.Site__r.RecordTypeId, s.Site__c From Site_Trial__c s where Site__r.RecordTypeId = :lstRecordType[0].Id];
        for(Site_Trial__c st : lstSiteTrial) {
            mapSiteTrials.put(st.Trial__c, st.Site__c);
        }
        List<Site__c> labList = [Select s.RecordType.Name, s.RecordTypeId, s.Id From Site__c s where RecordType.Name = 'Lab'];
        Set<Id> contactIdSet = new Set<Id>();
        
        List<TrialPatient__c> trialPatientList = [select Name, Patient_Id__c, Patient_Id__r.Institution__c, Site__c, Trial_Id__c, (Select CreatedDate, IRB_Approval_Date__c, Status__c, CompletedDate__c, ISPY2_Subject_Id__c From Registrations__r order by LastModifiedDate desc limit 1) from TrialPatient__c where Patient_Id__c in :patientIdSet];
        Map<id,TrialPatient__c> patientIdTPMap;
        Map<id,List<Registration__c>> trialPatientIdRegistrationMap ;
        if(!trialPatientList.isEmpty()){
            patientIdTPMap = new Map<id,TrialPatient__c>();
            trialPatientIdRegistrationMap = new Map<id,List<Registration__c>>();
            for(TrialPatient__c tp : trialPatientList){
                patientIdTPMap.put(tp.Patient_Id__c,tp);
                trialPatientIdRegistrationMap.put(tp.id,tp.Registrations__r);
            }
        }
             
        if(!lstInstUserSite.isEmpty()){
                    
            for(Registration__c regTmp : Trigger.new) {
                if(!RequiredFieldHandler.fromDataLoader) {
                    if(regTmp.IRB_Approval_Date__c == null) {
                        throw new RequiredFieldException('Required field missing - Please provide IRB Approval Date.');
                    } else if(regTmp.Screening_Informed_Consent_Date__c == null) {
                        throw new RequiredFieldException('Required field missing - Please provide Screening Informed Consent Date.');
                    } else if(regTmp.HIPPA_Consent_Date__c == null) {
                        throw new RequiredFieldException('Required field missing - Please provide HIPPA Consent Date.');
                    } 
                }
                if(!mapSiteTrials.isEmpty()) {
                    regTmp.Lab__c = mapSiteTrials.get(regTmp.Trial__c);
                }
                for(Patient_Custom__c patientObj: patientList) {
                    if(regTmp.Patient__c == patientObj.Id) {
                        List<String> raceStrList = patientObj.Race__c.split('\\;');
                        system.debug('__raceStrList__'+raceStrList);
                        for(String tmpRaceStr: raceStrList) {
                            system.debug('patientObj.Race__c: '+patientObj.Race__c+', tmpRaceStr: '+tmpRaceStr+', regTmp.Race__c: '+regTmp.Race__c);
                            if(regTmp.Race__c == null) {
                                regTmp.Race__c = '';
                            }
                        }
                    }
                }
                if(regTmp.Oncologist__c != null || regTmp.Oncologist__c != '') {
                    contactIdSet.add(regTmp.Oncologist__c);
                }
                
                if(regTmp.Surgeon__c != null || regTmp.Surgeon__c != '') {
                    contactIdSet.add(regTmp.Surgeon__c);
                }
                
                if(regTmp.Clinical_Coordinator__c != null || regTmp.Clinical_Coordinator__c != '') {
                    contactIdSet.add(regTmp.Clinical_Coordinator__c);
                }
                
                if(regTmp.Radiology_Coordinator__c != null || regTmp.Radiology_Coordinator__c != '') {
                    contactIdSet.add(regTmp.Radiology_Coordinator__c);
                }
                /*if(Trigger.isInsert) {
                    System.debug('patientIdTPMap-------'+patientIdTPMap);
                    TrialPatient__c trialPatient;
                    if(patientIdTPMap != null) trialPatient = patientIdTPMap.get(regTmp.Patient__c);
                    System.debug('trialPatient-------'+trialPatient);
                    if(trialPatient == null) {
                        trialPatient = new TrialPatient__c();
                    }
                    if(trialPatient.Patient_Id__c == null)trialPatient.Patient_Id__c = regTmp.Patient__c;
                    
                    trialPatient.Trial_Id__c = regTmp.Trial__c;
                    trialPatient.Site__c = regTmp.Site__c;
                    trialPatient.Name = regTmp.ISPY2_Subject_Id__c;
                    for(Patient_Custom__c tmpPat : patientList) {
                        
                        if(regTmp.Patient__c == tmpPat.Id) {
                        
                            trialPatient.FirstName__c = tmpPat.First_Name__c;
                            trialPatient.LastName__c = tmpPat.Last_Name__c;
                            break;
                        }
                    }
                    trialPatList.add(trialPatient);
                }*/
            }
        }
        //set subject id
        for(Registration__c regTmp : Trigger.new) {
            TrialPatient__c trialPatient;
            if(patientIdTPMap != null) trialPatient = patientIdTPMap.get(regTmp.Patient__c);
            if(trialPatient != null && trialPatientIdRegistrationMap != null && !trialPatientIdRegistrationMap.isEmpty()){
                if(trialPatientIdRegistrationMap.get(trialPatient.id) != null && !trialPatientIdRegistrationMap.get(trialPatient.id).isEmpty()){
                    regTmp.ISPY2_Subject_Id__c = trialPatientIdRegistrationMap.get(trialPatient.id)[0].ISPY2_Subject_Id__c;
                }
            }
        }
        /*if(!trialPatList.isEmpty()) {
            //insert trialPatList;
            System.debug('trialPatList----------'+trialPatList);
            upsert trialPatList;
        }*/
        
        List<Contact> contactList = [select Type__c, Site__c, AccountId, Id from Contact where Id IN :contactIdSet];
        List<Patient_Custom__c> lstUpdatePatient = new List<Patient_Custom__c>();
        for(Registration__c regTmp : Trigger.new) {
            if(Trigger.isInsert) {
                for (TrialPatient__c tmpObj : trialPatientList) {
                    if(tmpObj.Patient_Id__c == regTmp.Patient__c && tmpObj.Trial_Id__c == regTmp.Trial__c) {
                        regTmp.Institution__c = tmpObj.Patient_Id__r.Institution__c;
                        regTmp.Site__c = tmpObj.Site__c;
                    }
                }
                if(regTmp.Status__c == null) {
                    regTmp.Status__c = 'Not Completed';
                }
                if(regTmp.ISPY2_Subject_Id__c == null) {
                    regTmp.ISPY2_Subject_Id__c = SubjectIdGenerator.generateISPYSubjectId();
                }
                for(Patient_Custom__c tmpPat : patientList) {
                    if(tmpPat.Id == regTmp.Patient__c) {
                        tmpPat.Name = regTmp.ISPY2_Subject_Id__c;
                        lstUpdatePatient.add(tmpPat);
                    }
                }
            }
            
            for(Contact tmpContact : contactList) {
                tmpContact.AccountId = lstInstUserSite[0].Institution__c;
                tmpContact.Site__c = lstInstUserSite[0].Site__c;
                
                if(regTmp.Oncologist__c == tmpContact.Id && tmpContact.Type__c != 'Oncologist') {
                    tmpContact.Type__c = 'Oncologist';
                } else if(regTmp.Surgeon__c == tmpContact.Id && tmpContact.Type__c != 'Surgeon') {
                    tmpContact.Type__c = 'Surgeon';
                } else if(regTmp.Clinical_Coordinator__c == tmpContact.Id && tmpContact.Type__c != 'Clinical Coordinator') {
                    tmpContact.Type__c = 'Clinical Coordinator';
                } else if(regTmp.Radiology_Coordinator__c == tmpContact.Id && tmpContact.Type__c != 'Radiology Coordinator') {
                    tmpContact.Type__c = 'Radiology Coordinator';
                }
            }
        }
        
        if(!contactList.isEmpty()) {
            update contactList;
        }
        
        if(!lstUpdatePatient.isEmpty()) {
            update lstUpdatePatient;
        }
        
    }
    if(Trigger.isAfter){
        set<String> setDccIds = new set<String>();
        List<InstitutionTrialDcc__c> lstInsTriDcc = [select id,DCC_Id__c,DCC_Id__r.Inst_Group__c,Institution_Id__c,Trial_Id__c from InstitutionTrialDcc__c where Trial_Id__c IN : regTrialId];
        for(InstitutionTrialDcc__c i : lstInsTriDcc){
            setDccIds.add(i.DCC_Id__r.Inst_Group__c);
        }
        List<Group> lstGrp2 = [select Id,Name,Type from Group where Name IN : setDccIds and Type != 'Queue'];
        List<Patient_Custom__Share> lstPatShare = new List<Patient_Custom__Share>();
        for(Registration__c reg : Trigger.new){
            if(reg.RecordTypeId == recTypeAdHoc[0].Id)continue;
            for(Patient_Custom__c pc : patientList){
                if(pc.Id == reg.Patient__c){
                    for(InstitutionTrialDcc__c insTriDcc : lstInsTriDcc){
                        if(reg.Trial__c == insTriDcc.Trial_Id__c){
                            for(Group grp1 : lstGrp2){
                                if(grp1.Name == insTriDcc.DCC_Id__r.Inst_Group__c){
                                    Patient_Custom__Share patShare = new Patient_Custom__Share();
                                    patShare.AccessLevel = 'Read';
                                    patShare.UserOrGroupId = grp1.Id;
                                    patShare.ParentId = pc.Id;
                                    lstPatShare.add(patShare);
                                }
                            }
                        }
                    }
                }
            }
        }
        if(!lstPatShare.isEmpty()){
            insert lstPatShare;
        }
    }
    
    // insert CRF__Share (6/25/2013)
    List<Site_Trial__c> siteTrials = [Select s.Trial__c, s.Site__c, s.Name From Site_Trial__c s];
    Map<CRF__c, String> crfGroupNameMap = new Map<CRF__c, String>();
    if(Trigger.isBefore){
        if(Trigger.isInsert){
            List<CRF__c> lstCRF = new List<CRF__c>();
            for(Registration__c reg : Trigger.new){
                CRF__c crf = new CRF__c();
                crf.Patient__c = reg.Patient__c;
                crf.Trial__c = reg.Trial__c;
                crf.TrialPatient__c = reg.TrialPatient__c;
                crf.Complete_Date__c = System.today();
                crf.Status__c = reg.Status__c;
                crf.Type__c = 'Registration__c';
                crf.Phase__c = 'Screening';
                lstCRF.add(crf);
                for(Site_Trial__c st : siteTrials) {
                    if(st.Trial__c == reg.Trial__c && st.Site__c == reg.Site__c) {
                        crfGroupNameMap.put(crf, st.Name);
                        break;
                    }
                }
            }
            if(!lstCRF.isEmpty()){
                insert lstCRF;
            }
            List<Group> gList = [Select g.Name, g.Id From Group g where name in :crfGroupNameMap.values()];
            Map<String, Id> gNameIdMap = new Map<String, Id>();
            for(Group g :gList) {
                gNameIdMap.put(g.Name, g.Id);
            }
            
            List<CRF__Share> lstCRFShare = new List<CRF__Share>();
            for(CRF__c reg : lstCRF){
                CRF__Share shareRec = new CRF__Share();
                System.debug('crfGroupNameMap.get(reg)---------'+crfGroupNameMap.get(reg));
                if(crfGroupNameMap.get(reg) != null && gNameIdMap.get(crfGroupNameMap.get(reg)) != null){
                    shareRec.UserOrGroupId = gNameIdMap.get(crfGroupNameMap.get(reg));
                    shareRec.AccessLevel = 'Edit';
                    shareRec.ParentId =  reg.Id;
                    lstCRFShare.add(shareRec);
                }
            }
            insert lstCRFShare;
            
            
            for(Registration__c reg : Trigger.new){
                for(CRF__c c : lstCRF){
                    if(c.Patient__c == reg.Patient__c){
                        reg.CRF__c = c.Id;
                    }
                }
            }
        }
        if(Trigger.isUpdate){
            set<Id> setCrfIds = new set<Id>();
            for(Registration__c reg : Trigger.new){
                setCrfIds.add(reg.CRF__c);
            }
            List<CRF__c> lstCrf = [select id,Status__c from CRF__c where id IN : setCrfIds];
            for(Registration__c reg : Trigger.new){
                for(CRF__c crf : lstCrf){
                    if(crf.id == reg.CRF__c && reg.Status__c != Trigger.oldMap.get(reg.id).Status__c){
                        crf.Status__c = reg.Status__c;
                    }
                }
            }
            update lstCrf;
        }
    }
    if(Trigger.isInsert){
        if(Trigger.isAfter){
            System.debug('-------Snomed--------->');
            //set<Id> regIdsForTask = new set<Id>(); //Id set for create related tasks
            set<Id> trialPatientIds = new set<Id>();
            for(Registration__c reg : Trigger.new){
                trialPatientIds.add(reg.TrialPatient__c);
                //regIdsForTask.add(reg.Id);
            }
            
            List<TrialPatient__c> lstTrialPatient = [select Subject_Id__c from TrialPatient__c where Id IN :trialPatientIds];
            
            /* ISPY2_Subject_Id__c will create when registration form will be filledup. Here we are coping Registration's 
            *  Subject Id to TrialPatient's Subject ID field. because in most of the places we are using trialPatient and getting subject from 
            *  TrialPatient Object is convenient then getting from registration thats why we had to copy Subject id from registration to trialpatient.
            */
            for(Registration__c reg : Trigger.new){
                if(reg.TrialPatient__c != null) {
                    for(TrialPatient__c trialPatient : lstTrialPatient) {
                        if(reg.TrialPatient__c == trialPatient.Id) {
                            trialPatient.Subject_Id__c = reg.ISPY2_Subject_Id__c;
                            trialPatient.Name = reg.ISPY2_Subject_Id__c;
                        }
                    }
                }
            }
            if(!lstTrialPatient.isEmpty()) {
                update lstTrialPatient;
            }
            /*commented to get characters for other coding
            TaskManager.updateTaskStatusToInProgress('Registration__c', trigger.newMap.keySet());
            */
        }
    }
    if(Trigger.isUpdate && Trigger.isAfter){
        set<Id> setIds = new set<Id>();
        set<Id> regIds = new set<Id>();
        set<Id> trialPatientIds = new set<Id>();
        for(Registration__c reg : Trigger.new){
            if(reg.Status__c != 'Approval Not Required') continue;
            if(Trigger.oldMap.get(reg.Id).Status__c != 'Approval Not Required') {
                setIds.add(reg.CRF__c);
                regIds.add(reg.Id);
                trialPatientIds.add(reg.TrialPatient__c);
            }
        }
        
        
        List<TrialPatient__c> lstTrialPatient = [select Subject_Id__c from TrialPatient__c where Id IN :trialPatientIds];
        
        /* ISPY2_Subject_Id__c will create when registration form will be filledup. Here we are coping Registration's 
        *  Subject Id to TrialPatient's Subject ID field. because in most of the places we are using trialPatient and getting subject from 
        *  TrialPatient Object is convenient then getting from registration thats why we had to copy Subject id from registration to trialpatient.
        */
        for(Registration__c reg : Trigger.new){
            if(reg.TrialPatient__c != null) {
                for(TrialPatient__c trialPatient : lstTrialPatient) {
                    if(reg.TrialPatient__c == trialPatient.Id) {
                        trialPatient.Subject_Id__c = reg.ISPY2_Subject_Id__c;
                        trialPatient.Name = reg.ISPY2_Subject_Id__c;
                    }
                }
            }
        }
        if(!lstTrialPatient.isEmpty()) {
            update lstTrialPatient;
        }
            
        List<Snomed_Code__c> lstSnomed = [select id,CRF__c,Name from Snomed_Code__c where CRF__c IN : setIds];
        if(!lstSnomed.isEmpty()) {
            delete lstSnomed;
        }
        if(!regIds.isEmpty()) {
            SnomedCTCode.insertRegistrationRelatedCode(regIds);
            /*commented to get characters for other coding
            TaskManager.updateTask(regIds, 'Registration__c');
            TaskManager.createTaskAfterRegistration(regIds);
            */
        }
    }
}