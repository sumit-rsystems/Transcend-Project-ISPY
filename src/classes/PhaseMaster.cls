public with sharing class PhaseMaster {
    
    public List<Phase_CRFs__c> lstPhase {get;set;} //for the records of phase-crfs object
    public List<Phase_Master__c> lstPhaseMaster {get;set;} //for screening tab
    //public List<Phase_Master__c> lstPhase2 {get;set;} //for treatment tab
    //public List<Phase_Master__c> lstPhase3 {get;set;} //for follow up tab
    public List<CRFMaster__c> crfMaster{get;set;}
    //public List<String> screeningList{get;set;}
    //public List<String> treatmentList{get;set;}
    //public List<String> followUpList{get;set;}   
    public List<wrapScreen> screenWrapList{get;set;}
    public List<wrapTreatment> treatmentWrapList{get;set;}
    public List<wrapFollow> followWrapList{get;set;} 
    public List<SelectOption> trialOption{get;set;}
    public String selectedTrial{get;set;}
    
    
    public Patient_Custom__c patient {get;set;} 
    public Event event {get;set;}
    Public Event eventres {get;set;}
    public String patientId{get;set;}
    public String subjectId {get;set;}    
    public Boolean isShowTabValue{get;set;}
    public Boolean isRegisterError{get;set;}
    public Boolean eventButton{get;set;} 
    public Boolean allEvecheckbox {get;set;}
    public Boolean allEvecheckboxre {get;set;}
    
    public String displynone{get;set;}
    public String displynonere{get;set;}
    public String eventId{get;set;}
    
    public Long registrationDateTimeStamp{get;set;}
    
    public String isEventErrorMsg{get;set;}
    public Boolean isEventError{get;set;}
    
    public List<wrapperEvent> wrapList;
    public Boolean isWrapListSet = true;
    public void setWrapList(List<wrapperEvent> wrapList) {
        //return wrapList;
        this.wrapList = wrapList;
    }
    public List<Proposed_Rescheduling__c> propsedReschList {get;set;}
    
    public List<wrapperEvent> getWrapList() {
        system.debug('-----selectredioButton---'+selectredioButton);
        
        if(!isWrapListSet) return wrapList; 
        set<Id> userEventSetid = new Set<id>();
        for(User userEventset : userListemail){
            userEventSetid.add(userEventset.id);
        }
        DateTime todaydate = system.now();
        evetnList = [Select e.Status__c, e.subject__c,e.WhoId, e.WhatId, e.Type, e.Trial__c, e.SystemModstamp, e.Subject, e.StartDateTime, e.ShowAs, e.ReminderDateTime, e.RecurrenceType, e.RecurrenceTimeZoneSidKey, e.RecurrenceStartDateTime, e.RecurrenceMonthOfYear, e.RecurrenceInterval, e.RecurrenceInstance, e.RecurrenceEndDateOnly, e.RecurrenceDayOfWeekMask, e.RecurrenceDayOfMonth, e.RecurrenceActivityId, e.OwnerId, e.Minutes__c, e.Location, e.LastModifiedDate, e.LastModifiedById, e.IsReminderSet, e.IsRecurrence, e.IsPrivate, e.IsGroupEvent, e.IsDeleted, e.IsChild, e.IsArchived, e.IsAllDayEvent, e.Id, e.Hours__c, e.GroupEventType, e.EndDateTime, e.DurationInMinutes, e.Description, e.CreatedDate, e.CreatedById, e.ActivityDateTime, e.ActivityDate, e.AccountId From Event e where OwnerId IN: userEventSetid ];
        String query = 'Select e.Status__c,e.subject__c,e.WhoId, e.WhatId, e.Type, e.Trial__c, e.SystemModstamp, e.Subject, e.StartDateTime, e.ShowAs, e.ReminderDateTime, e.RecurrenceType, e.RecurrenceTimeZoneSidKey, e.RecurrenceStartDateTime, e.RecurrenceMonthOfYear, e.RecurrenceInterval, e.RecurrenceInstance, e.RecurrenceEndDateOnly, e.RecurrenceDayOfWeekMask, e.RecurrenceDayOfMonth, e.RecurrenceActivityId, e.OwnerId, e.Minutes__c, e.Location, e.LastModifiedDate, e.LastModifiedById, e.IsReminderSet, e.IsRecurrence, e.IsPrivate, e.IsGroupEvent, e.IsDeleted, e.IsChild, e.IsArchived, e.IsAllDayEvent, e.Id, e.Hours__c, e.GroupEventType, e.EndDateTime, e.DurationInMinutes, e.Description, e.CreatedDate, e.CreatedById, e.ActivityDateTime, e.ActivityDate, e.AccountId From Event e where OwnerId IN: userEventSetid ';
        String strQuery = '';
        if(selectredioButton == 'Upcoming Appointments'){
            strQuery = 'and StartDateTime >=: todaydate';
        }else if(selectredioButton == 'Past Appointments'){
            strQuery = 'and StartDateTime <=: todaydate';
        }else if(selectredioButton == 'All Appointments'){
            system.debug('------');
        }else{
            strQuery = 'and StartDateTime >=: todaydate';
        }
        query += strQuery;
        system.debug('----query :------'+query);
        evetnList = Database.query(query);
        system.debug('----query :------'+query);
        wrapList = new List<wrapperEvent>();
        for(Event eve : evetnList) {
            wrapperEvent we = new wrapperEvent();
            if(selectredioButton == 'Upcoming Appointments' || selectredioButton == null){
                we.isRescheduleButton = true;
            }else {
                we.isRescheduleButton = false;
            }
            if(eve.StartDateTime != null){
                if(eve.StartDateTime >= system.today()){
                    we.isStartDateGreater = true;
                    we.isRescheduleButton = true;
                }
                we.ev = eve;
            }else{
                we.ev = eve;
                we.isStartDateGreater = false;
                we.isRescheduleButton = false;
            } 
            wrapList.add(we); 
        }
        return wrapList;

    }
    public List<Event> evetnList{get;set;}
    public List<SelectOption> trialOptionEvent{get;set;}
    public TrialPatient__c trailObj{get;set;}
    
    public Boolean trailrecoed{get;set;}
    public Boolean trailList {get;set;}
    public Boolean isShowDelete{get;set;}
    public boolean singleTrial {get;set;}
    
    public List<User> userListemail{get;set;}
    public List<Task> lstTask;
    public List<Task> getLstTask() {
        lstTask = new List<Task>();
        
        if(selectedTaskOption == 'All') {
            lstTask = [select ActivityDate, IsCreateTask__c, Object_Label__c, Object_Name__c, CRF_Form_Id__c, Subject, Type, WhatId, Status, Schedule_Event_Date__c,Trial_Id__c from Task where Trial_Id__c =:selectedTrial and WhatId =:patientId and OwnerId =:Userinfo.getUserId() and Status IN ('Not Started', 'In Progress', 'Completed') order by ActivityDate ];
        } else if(selectedTaskOption == 'Completed') {
            lstTask = [select ActivityDate, Object_Label__c, IsCreateTask__c, Object_Name__c, CRF_Form_Id__c, Subject, Type, WhatId, Status, Schedule_Event_Date__c, Trial_Id__c from Task where Trial_Id__c =:selectedTrial and WhatId =:patientId and OwnerId =:Userinfo.getUserId() and Status = 'Completed' order by ActivityDate];
        } else {
            lstTask = [select ActivityDate, Object_Label__c, Object_Name__c, IsCreateTask__c, CRF_Form_Id__c, Subject, Type, Schedule_Event_Date__c, WhatId, Status from Task where WhatId =:patientId and Trial_Id__c =:selectedTrial and OwnerId =:Userinfo.getUserId() and Status IN ('Not Started', 'In Progress') order by ActivityDate];
        }
        return lstTask;
    }
    
    public void setLstTask(List<Task> lstTask) {
        this.lstTask = lstTask;
    }
    public String selectedTaskOption{get;set;}
    public String selectedTab{get;set;}
    public String trialName{get;set;}
    public String eventStatusHidden{get;set;}
    public String taskIdHidden{get;set;}
    public String selectedTrialEvent{get;set;}
    public String eventVisitTypeHidden{get;set;}
    public String errorMsg{get;set;}
    public String singleTrialName {get;set;} 
    public String eventCreationDivDisplay{get;set;}
    private String trialIdValue{get;set;}
    private Pagereference pageRef{get;set;}
    
    public boolean isScheduledEvent{get;set;}
    
    public List<SelectOption> redioButton {get;set;}
    public String selectredioButton {get;set;}
    
    public boolean siteUserCanCreateRandomizationForm {get;set;}
    private boolean useOldRandomizationCode {get;set;}
    
    public string item {get;set;}
    
    public List<SelectOption> getItems() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('','- - - -None- - - - '));
        options.add(new SelectOption('Clinic Visit','Clinic Visit'));
        options.add(new SelectOption('Lab Visit','Lab Visit'));
        options.add(new SelectOption('Radiology Visit','Radiology Visit'));
        options.add(new SelectOption('Pre-Surgery Visit','Pre-Surgery Visit'));
        options.add(new SelectOption('Clinic Visit','Clinic Visit'));
        options.add(new SelectOption('Surgery Visit','Surgery Visit'));
        
        return options;
    }
        
    
    public PhaseMaster(Apexpages.StandardController std) {
        selectredioButton = 'Upcoming Appointments';
        //propsedReschList.clear();
        propsedReschList = new List<Proposed_Rescheduling__c>();
        redioButton = new List<SelectOption>();
        redioButton.add(new SelectOption('Upcoming Appointments',' Upcoming Appointments'));    
        redioButton.add(new SelectOption('Past Appointments','Past Appointments'));
        redioButton.add(new SelectOption('All Appointments','All Appointments'));
        
        
        isScheduledEvent = true;
        eventres = new Event();
        isEventError = false;
        eventCreationDivDisplay = 'none';
        displynone = 'none';
        displynonere = 'none';
        selectedTab = 'Screening';
        //wrapList = new List<wrapperEvent>();
        evetnList = new List<Event>();
        userListemail = new List<User>();
        
        allEvecheckboxre = false;
        eventButton = false;
        isShowTabValue = false;
        isRegisterError = false; 
        isShowDelete = true;
        errorMsg = '';
        trialOption = new List<SelectOption>();
        trialOptionEvent = new List<SelectOption>();
        patientId = Apexpages.currentPage().getParameters().get('id');
        trialIdValue = Apexpages.currentPage().getParameters().get('TrialId');
        System.debug('trialIdValue'+trialIdValue);
        //lstTask = [select ActivityDate, Subject, Type, Schedule_Event_Date__c, Object_Name__c, WhatId, Status from Task where WhatId =:patientId and Status != 'Completed' order by ActivityDate];
        //List<Patient_Custom__c> lstPatient = [Select p.Zip__c, p.Surgeon__c, p.Study_Registration_Eligibility__c, p.State__c, p.Signed_Screening__c, p.Screen_Failure_Number__c, p.Race__c, p.Primary_MD__c, p.OwnerId, p.Medical_Record_Number__c, p.Last_Name__c, p.LastModifiedById, p.Gender__c, p.First_Name__c, p.Ethnicity__c, p.CreatedById, p.Country_of_Birth__c, p.Country__c, p.City__c, p.Birthdate__c, p.Age__c, p.Address_Line_2__c, p.Address_Line_1__c From Patient_Custom__c p where Id = :std.getId()];
        List<Patient_Custom__c> lstPatient = [Select p.Email__c,p.Zip__c, Middle_Name__c, Suffix__c, Initials__c, VIP__c, p.SystemModstamp, p.Surgeon__r.Name, p.Surgeon__c, p.Study_Registration_Eligibility__c, p.Status__c, p.State__c, p.Signed_Screening__c, p.Screen_Failure_Number__c, p.SSN__c, p.RecordTypeId, p.Race__c, p.Primary_MD__r.Name, p.Primary_MD__c, p.Owner.Name, p.OwnerId, p.Name, p.Medical_Record_Number__c, p.Last_Name__c, p.LastModifiedDate, p.LastModifiedBy.Name, p.LastModifiedById, p.LastActivityDate, p.IsDeleted, p.Institution__c, p.Institute_Text__c, p.Id, p.Gender__c, p.First_Name__c, p.Ethnicity__c, p.CreatedDate, p.CreatedBy.Name, p.CreatedById, p.Country_of_Birth__c, p.Country__c, p.City__c, p.Birthdate__c, p.Age__c, p.Address_Line_2__c, p.Address_Line_1__c, RecordType.Name,  (Select Subject_Id__c From TrialPatients__r order by LastModifiedDate desc), (Select Id From Registrations__r order by LastModifiedDate desc limit 1) From Patient_Custom__c p where Id = :patientId];
        
       propsedReschList = [Select p.subject__c, p.status__c, p.WhatId__c, p.Type__c, p.Trial__c, p.StartDateTime__c, p.Reschedule_reason__c, p.Proposed_New_Date__c, p.PatientId__c, p.OwnerId, p.Name, p.Id, p.Eventid__c, p.EndDate__c, p.Description__c From Proposed_Rescheduling__c p where status__c = 'Waiting' and patientId__c =: patientId];
        if(lstPatient.size() > 0 && lstPatient[0].Registrations__r.size() > 0){
            isShowDelete = false;
        }
        
        if(!lstPatient.isEmpty()) {
            patient = lstPatient[0];
            if(patient != null) {
                List<TrialPatient__c> lstTrialPatient = patient.TrialPatients__r;
                if(lstTrialPatient != null && lstTrialPatient.size() > 0) {
                    subjectId = lstTrialPatient[0].Subject_Id__c;
                }
            }
        }
        /*List<Profile> lstPro = [select id,Name from Profile where Name = 'Developers' or Name = 'System Administrator'];
        if(userInfo.getProfileId() == lstPro[0].Id || userInfo.getProfileId() == lstPro[1].Id){
            List<Trial__c> lstTrial = [select id,Name from Trial__c];
            SelectOption option = new SelectOption('','Please select Trial');
            trialOption.add(option);
            for(Trial__c trial : lstTrial){
                option = new SelectOption(trial.Id,trial.Name);
                trialOption.add(option);
            }
        } else {*/
            SelectOption option = new SelectOption('','Please select Trial');
            trialOption.add(option);
            User usr = [Select u.Profile.Name From User u where id =:UserInfo.getUserId()];
            if(usr.Profile.Name == 'Trial Administrator' || usr.Profile.Name == 'Institute Level Admin' || usr.Profile.Name == 'Custom Read Only User' || usr.Profile.Name == 'System Administrator'){
                List<Site_Trial__c> LstSteTrl = [Select s.Trial__c,Trial__r.Name, s.Site__r.Institute__c, s.Site__c From Site_Trial__c s where Site__r.Institute__c =:patient.Institution__c and (Site__r.RecordType.Name = 'Site')];
                system.debug('--LstSteTrl--'+LstSteTrl);
                system.debug('--LstSteTrl.size--'+LstSteTrl.size());
                for(Site_Trial__c tmpTrialPat : LstSteTrl) {
                    if(tmpTrialPat.Trial__r.Name!=null && tmpTrialPat.Trial__c!=null) {
                        option = new SelectOption(tmpTrialPat.Trial__c,tmpTrialPat.Trial__r.Name);
                        trialOption.add(option);
                    }
                }
            }else{
                if(usr.Profile.Name == 'Lab User') {
                    Set<Id> labIds = new Set<Id>();
                    List<LabUser__c> lstLabUser = [select User__c, Lab__c from LabUser__c where User__c = :userInfo.getUserId()];
                    for(LabUser__c labUser : lstLabUser) {
                        if(labUser.Lab__c != null) {
                            labIds.add(labUser.Lab__c);
                        }
                    }
                    List<Site_Trial__c> lstLabTrial = [select Trial__c, Trial__r.Name from Site_Trial__c where Site__c IN :labIds];
                    for(Site_Trial__c labTrial : lstLabTrial) {
                        if(labTrial.Trial__r.Name != null && labTrial.Trial__c != null) {
                            option = new SelectOption(labTrial.Trial__c, labTrial.Trial__r.Name);
                            trialOption.add(option);
                        }
                    }
                } else {
                    System.debug('patient.Institution__c : '+patient.Institution__c);
                    System.debug('userInfo.getUserId() : '+userInfo.getUserId());
                    List<InstitutionUser__c> isntUser = [select Trial__c, Trial__r.Name from InstitutionUser__c where User__c = :userInfo.getUserId() and Institution__c =:patient.Institution__c];
                    //SelectOption option = new SelectOption('','');
                    //trialOption.add(option);  
                    
                    for(InstitutionUser__c tmpTrialPat : isntUser) {
                        if(tmpTrialPat.Trial__r.Name!=null && tmpTrialPat.Trial__c!=null) {
                            option = new SelectOption(tmpTrialPat.Trial__c,tmpTrialPat.Trial__r.Name);
                            trialOption.add(option);
                        }
                    }
                }
             }
            singleTrial = false;
            if(trialOption.size() == 2) {
                singleTrial = true;
                selectedTrial = trialOption.get(1).getValue();
                singleTrialName = 'Trial: '+trialOption.get(1).getLabel();
                showCrf(); 
            } else if(trialIdValue != null) {
                system.debug('__trialIdValue__'+trialIdValue);
                for(Selectoption to : trialOption) {
                    system.debug('__to.getValue()__'+to.getValue());
                    if(to.getValue() == trialIdValue) {
                        selectedTrial = trialIdValue;
                        System.debug('selectedTrial  '+selectedTrial);
                        
                    }
                }
                showCrf();
            }
       // }
        List<Patient_Custom__c> lstPatient1 = [Select p.isPortalEnable__c ,p.Email__c,p.Zip__c, Middle_Name__c, Suffix__c, Initials__c, VIP__c, p.SystemModstamp, p.Surgeon__r.Name, p.Surgeon__c, p.Study_Registration_Eligibility__c, p.Status__c, p.State__c, p.Signed_Screening__c, p.Screen_Failure_Number__c, p.SSN__c, p.RecordTypeId, p.Race__c, p.Primary_MD__r.Name, p.Primary_MD__c, p.Owner.Name, p.OwnerId, p.Name, p.Medical_Record_Number__c, p.Last_Name__c, p.LastModifiedDate, p.LastModifiedBy.Name, p.LastModifiedById, p.LastActivityDate, p.IsDeleted, p.Institution__c, p.Institute_Text__c, p.Id, p.Gender__c, p.First_Name__c, p.Ethnicity__c, p.CreatedDate, p.CreatedBy.Name, p.CreatedById, p.Country_of_Birth__c, p.Country__c, p.City__c, p.Birthdate__c, p.Age__c, p.Address_Line_2__c, p.Address_Line_1__c, RecordType.Name From Patient_Custom__c p where Id = :patientId];
        userListemail = [Select u.Username, u.UserType, u.UserRoleId, u.Title, u.TimeZoneSidKey, u.SystemModstamp, u.Street, u.State, u.SecurityCode__c, u.ReceivesInfoEmails, u.ReceivesAdminInfoEmails, u.ProfileId, u.PostalCode, u.Phone, u.Patient_Id__c, u.OfflineTrialExpirationDate, u.OfflinePdaTrialExpirationDate, u.Name, u.MobilePhone, u.ManagerId, u.LocaleSidKey, u.LastName, u.LastModifiedDate, u.LastModifiedById, u.LastLoginDate, u.LanguageLocaleKey, u.IsPortalEnabled, u.IsActive, u.Id, u.ForecastEnabled, u.FirstName, u.FederationIdentifier, u.Fax, u.Extension, u.EmployeeNumber, u.EmailEncodingKey, u.Email, u.Division, u.Department, u.DelegatedApproverId, u.CurrentStatus, u.CreatedDate, u.CreatedById, u.Country, u.ContactId, u.CompanyName, u.CommunityNickname, u.City, u.CallCenterId, u.Alias, u.AccountId, u.AboutMe From User u where Username =:patient.Email__c];
        /*set<Id> userEventSetid = new Set<id>();
        for(User userEventset : userListemail){
            userEventSetid.add(userEventset.id);
        }*/
        for(Patient_Custom__c patientevent : lstPatient1){
            for(User usem : userListemail){ 
                if(patientevent.Email__c == usem.Username){
                    eventButton = true;
                    system.debug('---------------test-------sfds------');
                    system.debug('--------------eventButton---'+eventButton);
                }
            }
        }
        event = new Event();
        /*evetnList = [Select e.WhoId, e.WhatId, e.Type, e.Trial__c, e.SystemModstamp, e.Subject, e.StartDateTime, e.ShowAs, e.ReminderDateTime, e.RecurrenceType, e.RecurrenceTimeZoneSidKey, e.RecurrenceStartDateTime, e.RecurrenceMonthOfYear, e.RecurrenceInterval, e.RecurrenceInstance, e.RecurrenceEndDateOnly, e.RecurrenceDayOfWeekMask, e.RecurrenceDayOfMonth, e.RecurrenceActivityId, e.OwnerId, e.Minutes__c, e.Location, e.LastModifiedDate, e.LastModifiedById, e.IsReminderSet, e.IsRecurrence, e.IsPrivate, e.IsGroupEvent, e.IsDeleted, e.IsChild, e.IsArchived, e.IsAllDayEvent, e.Id, e.Hours__c, e.GroupEventType, e.EndDateTime, e.DurationInMinutes, e.Description, e.CreatedDate, e.CreatedById, e.ActivityDateTime, e.ActivityDate, e.AccountId From Event e where OwnerId IN: userEventSetid ];
        for(Event eve : evetnList) {
            wrapperEvent we = new wrapperEvent();
            if(eve.StartDateTime >= system.today()){
                we.isStartDateGreater = true;
                we.ev = eve;
            }else{
                we.ev = eve;
                we.isStartDateGreater = false;
            }
            wrapList.add(we);
        }*/
                
        trailrecoed = false;
        trailList = false;
        trailObj = new TrialPatient__c();
        List<TrialPatient__c> traiPatientList = [Select t.pg_patient_Id__c, t.Trial_Id__c,t.Trial_Id__r.Name, t.Patient_Id__c, t.Name, t.LastName__c, t.Id, t.FirstName__c From TrialPatient__c t where Patient_Id__c =: patientId limit 1];
        if(!traiPatientList.isEmpty()){
            trailObj = traiPatientList[0];
            trailrecoed = true;         
        }else{
            trailList = true;
            List<Trial__c> lstTrial = [select id,Name from Trial__c];
            SelectOption optioEve = new SelectOption('','------none-----');
            trialOptionEvent.add(optioEve);
            for(Trial__c trial : lstTrial){
                optioEve = new SelectOption(trial.Id,trial.Name);
                trialOptionEvent.add(optioEve);
            }
        }
        //List<TrialPatient__c> trialPat = [Select t.Trial_Id__r.Name, t.Trial_Id__c From TrialPatient__c t where Patient_Id__c =:patientId];
    
        List<RandomizationProperty__c> rProps = [Select Allow_Site_Users_To_Create_Randomization__c, Use_Old_Randomization_Flow__c  from RandomizationProperty__c order by LastModifiedDate desc limit 1];
        if(!rProps.isEmpty()) {
            RandomizationProperty__c rp = rProps[0];
            siteUserCanCreateRandomizationForm = rp.Allow_Site_Users_To_Create_Randomization__c;
            useOldRandomizationCode = rp.Use_Old_Randomization_Flow__c;
        } else {
            useOldRandomizationCode = false;
        }
    }
    public void ScheduledEvent(){
        Long milli = system.currenttimemillis();
        isWrapListSet = true;
        displynone = 'none';
        isEventErrorMsg = '';
        isEventError = false;
        if(event.StartDateTime == null){
            isEventErrorMsg = 'Please Provide Date';
            isEventError = true;
            displynone = '';
            return;
        } else {
            if(eventStatusHidden == 'Schedule') {
                if(event.StartDateTime < system.now()) {
                    isEventErrorMsg = 'Date can\'t be in Past.';
                    isEventError = true;
                    displynone = '';
                    return;
                }
                
            } else if(eventStatusHidden == 'Complete') {
                if(event.StartDateTime > system.now()) {
                    isEventErrorMsg = 'Future date is not allowed.';
                    isEventError = true;
                    displynone = '';
                    return;
                }
                
            }
            List<Task> lstUpdateTask = new List<Task>();
            system.debug('__taskIdHidden__'+taskIdHidden);
            if(taskIdHidden != null && taskIdHidden != '') {
                for(Task tsk : lstTask) {
                    if(taskIdHidden == tsk.Id) {
                        if(eventStatusHidden == 'Schedule') {
                            tsk.Status = 'In Progress';
                        }
                        tsk.Schedule_Event_Date__c = event.StartDateTime;
                        lstUpdateTask.add(tsk);
                    }
                }
                
                if(eventStatusHidden == 'Complete') {
                    Apexpages.currentPage().getParameters().put('taskId', taskIdHidden);
                    completeTask();
                    Apexpages.currentPage().getParameters().remove('taskId');
                } else if(!lstUpdateTask.isEmpty()) {
                    update lstUpdateTask;
                }
            }
        }
        
        if(event.Hours__c == null && eventStatusHidden != 'Complete'){
            isEventErrorMsg = 'Please Provide Hours';
            isEventError = true;
            displynone = '';
            return;
        }
        
        if(event.Minutes__c == null){
            event.Minutes__c = 00;
        }
        Integer totalminutes = 0;
        if(event.Hours__c != null) {
            totalminutes = Integer.valueOf((event.Hours__c * 60 ) + event.Minutes__c) ;
        }
        set<id> userId = new Set<id>();
        List<Patient_Custom__c> lstPatient = [Select p.Email__c,p.Zip__c, Middle_Name__c, Suffix__c, Initials__c, VIP__c, p.SystemModstamp, p.Surgeon__r.Name, p.Surgeon__c, p.Study_Registration_Eligibility__c, p.Status__c, p.State__c, p.Signed_Screening__c, p.Screen_Failure_Number__c, p.SSN__c, p.RecordTypeId, p.Race__c, p.Primary_MD__r.Name, p.Primary_MD__c, p.Owner.Name, p.OwnerId, p.Name, p.Medical_Record_Number__c, p.Last_Name__c, p.LastModifiedDate, p.LastModifiedBy.Name, p.LastModifiedById, p.LastActivityDate, p.IsDeleted, p.Institution__c, p.Institute_Text__c, p.Id, p.Gender__c, p.First_Name__c, p.Ethnicity__c, p.CreatedDate, p.CreatedBy.Name, p.CreatedById, p.Country_of_Birth__c, p.Country__c, p.City__c, p.Birthdate__c, p.Age__c, p.Address_Line_2__c, p.Address_Line_1__c, RecordType.Name From Patient_Custom__c p where Id = :patientId];
        List<User> userListemail = [Select u.Username, u.UserType, u.UserRoleId, u.UserPreferencesTaskRemindersCheckboxDefault, u.UserPreferencesReminderSoundOff, u.UserPreferencesOptOutOfTouch, u.UserPreferencesEventRemindersCheckboxDefault, u.UserPreferencesDisableAutoSubForFeeds, u.UserPreferencesApexPagesDeveloperMode, u.UserPreferencesActivityRemindersPopup, u.UserPermissionsSFContentUser, u.UserPermissionsOfflineUser, u.UserPermissionsMobileUser, u.UserPermissionsMarketingUser, u.UserPermissionsCallCenterAutoLogin, u.UserPermissionsAvantgoUser, u.Title, u.TimeZoneSidKey, u.SystemModstamp, u.Street, u.State, u.SecurityCode__c, u.ReceivesInfoEmails, u.ReceivesAdminInfoEmails, u.ProfileId, u.PostalCode, u.Phone, u.Patient_Id__c, u.OfflineTrialExpirationDate, u.OfflinePdaTrialExpirationDate, u.Name, u.MobilePhone, u.ManagerId, u.LocaleSidKey, u.LastName, u.LastModifiedDate, u.LastModifiedById, u.LastLoginDate, u.LanguageLocaleKey, u.IsPortalEnabled, u.IsActive, u.Id, u.ForecastEnabled, u.FirstName, u.FederationIdentifier, u.Fax, u.Extension, u.EmployeeNumber, u.EmailEncodingKey, u.Email, u.Division, u.Department, u.DelegatedApproverId, u.CurrentStatus, u.CreatedDate, u.CreatedById, u.Country, u.ContactId, u.CompanyName, u.CommunityNickname, u.City, u.CallCenterId, u.Alias, u.AccountId, u.AboutMe From User u where Username =:patient.Email__c];  
        if(eventStatusHidden != 'Complete') {
            List<Proposed_Rescheduling__c> propReshcList = new List<Proposed_Rescheduling__c>();
            for(Patient_Custom__c patientevent : lstPatient){ 
                for(User us : userListemail){
                    if(patientevent.Email__c == us.Username){ 
                        Proposed_Rescheduling__c propReschObj = new Proposed_Rescheduling__c();
                        propReschObj.refId__c = String.valueOf(milli);
                        propReschObj.OwnerId = us.Id;
                        propReschObj.studyStaff__c = patientevent.OwnerId;
                        propReschObj.subject__c = event.subject__c; 
                        propReschObj.StartDateTime__c = event.StartDateTime;
                        propReschObj.DurationInMinutes__c = totalminutes;
                        propReschObj.status__c = 'Waiting';
                        
                        propReschObj.Hours__c = event.Hours__c;
                        propReschObj.Minutes__c = event.Minutes__c;
                        system.debug('------event.Type--'+event.Type);
                        propReschObj.Type__c = event.Type; 
                        propReschObj.WhatId__c = patientId;
                        propReschObj.patientId__c = patientId;
                        if(trailrecoed){
                            propReschObj.Trial__c = trailObj.Trial_Id__r.Name;  
                        }else{
                            propReschObj.Trial__c = selectedTrialEvent;
                        }
                        //ev.EndDateTime = event.EndDateTime;
                        propReschObj.Description__c = event.Description;
                        
                        propReshcList.add(propReschObj);
                        system.debug('--eventList--------'+propReshcList);
                        propReschObj.EndDate__c = event.StartDateTime.addMinutes(totalminutes);
                        system.debug('--------propReschObj.EndDate__c--------'+propReschObj.EndDate__c);
                        
                    }
                }   
            }
            insert propReshcList;
            system.debug('--eventList--------'+propReshcList);
        } else {
            List<Event> lstInsertEvent = new List<Event>();
            for(Task tsk : lstTask) {
                if(taskIdHidden == tsk.Id) {
                    String visitType = '';
                    if(tsk.Type == 'Schedule the patient for a core biopsy' || tsk.Type == 'Schedule the patient for a blood sample') {
                        visitType = 'Lab Visit';
                    } else if(tsk.Type == 'Schedule the patient for a MRI scan') {
                        visitType = 'Radiology Visit';
                    } else if(tsk.Type == 'Schedule a clinic appointment') {
                        visitType = 'Clinic Visit';
                    }
                    Event ev = new Event();
                    ev.OwnerId = Userinfo.getUserId();
                    ev.Type = visitType;
                    ev.StartDateTime = event.StartDateTime;
                    ev.DurationInMinutes = 0;
                    /*ev.Hours__c = event.Hours__c;
                    ev.Minutes__c = event.Minutes__c;*/
                    ev.WhatId = patientId;
                   //ev.subject__c = event.subject__c;
                    //ev.Description = event.Description;
                    ev.Trial__c = trialName;
                    ev.Trial_Id__c = selectedTrial;
                    ev.Subject = 'Call';
                    lstInsertEvent.add(ev);
                    
                //Schedule events for patient
                    if(!userListemail.isEmpty()) {
                        Event ev1 = new Event();
                        ev1.OwnerId = userListemail[0].Id;
                        ev1.Type = visitType;
                        ev1.StartDateTime = event.StartDateTime;
                        ev1.DurationInMinutes = 0;
                        /*ev1.Hours__c = event.Hours__c;
                        ev1.Minutes__c = event.Minutes__c;
                        ev1.Description = event.Description;
                        ev1.subject__c = event.subject__c;*/
                        ev1.WhatId = patientId;
                        ev1.Subject = 'Call';
                        ev1.Trial__c = trialName;
                        ev1.Trial_Id__c = selectedTrial;
                        lstInsertEvent.add(ev1);
                    }
                }
            }
            if(!lstInsertEvent.isEmpty()) {
                insert lstInsertEvent;
            }
        }
        
        event.StartDateTime = null;
        event.Description = null;
        event.Hours__c = null;
        event.Minutes__c = null;
        event.subject__c = null;
        taskIdHidden = null;
        eventStatusHidden = null;
        //lstTask = [select ActivityDate, CRF_Form_Id__c, Subject, Type, WhatId, Schedule_Event_Date__c, Object_Name__c, Status, Trial_Id__c from Task where WhatId =:patientId and Trial_Id__c =:selectedTrial and Status != 'Completed' and Trial_Id__c =:selectedTrial order by ActivityDate];
        propsedReschList = [Select p.subject__c, p.status__c, p.WhatId__c, p.Type__c, p.Trial__c, p.StartDateTime__c, p.Reschedule_reason__c, p.Proposed_New_Date__c, p.PatientId__c, p.OwnerId, p.Name, p.Id, p.Eventid__c, p.EndDate__c, p.Description__c From Proposed_Rescheduling__c p where status__c = 'Waiting' and patientId__c =: patientId];
    }
    public void ScheduledEvent1(){
        propsedReschList = [Select p.subject__c, p.status__c, p.WhatId__c, p.Type__c, p.Trial__c, p.StartDateTime__c, p.Reschedule_reason__c, p.Proposed_New_Date__c, p.PatientId__c, p.OwnerId, p.Name, p.Id, p.Eventid__c, p.EndDate__c, p.Description__c From Proposed_Rescheduling__c p where status__c = 'Waiting' and patientId__c =: patientId];
    }
    public Pagereference rescheduleEvent(){
        displynonere = 'none';
        displynone = 'none';
        Patient_Custom__c patitenObj = new Patient_Custom__c(); 
        List<Patient_Custom__c> lstPatient = [Select p.Email__c,p.Zip__c, Middle_Name__c, Suffix__c, Initials__c, VIP__c, p.SystemModstamp, p.Surgeon__r.Name, p.Surgeon__c, p.Study_Registration_Eligibility__c, p.Status__c, p.State__c, p.Signed_Screening__c, p.Screen_Failure_Number__c, p.SSN__c, p.RecordTypeId, p.Race__c, p.Primary_MD__r.Name, p.Primary_MD__c, p.Owner.Name, p.OwnerId, p.Name, p.Medical_Record_Number__c, p.Last_Name__c, p.LastModifiedDate, p.LastModifiedBy.Name, p.LastModifiedById, p.LastActivityDate, p.IsDeleted, p.Institution__c, p.Institute_Text__c, p.Id, p.Gender__c, p.First_Name__c, p.Ethnicity__c, p.CreatedDate, p.CreatedBy.Name, p.CreatedById, p.Country_of_Birth__c, p.Country__c, p.City__c, p.Birthdate__c, p.Age__c, p.Address_Line_2__c, p.Address_Line_1__c, RecordType.Name From Patient_Custom__c p where Id = :patientId];
        if(lstPatient.size() > 0){
            patitenObj = lstPatient[0];
        }   
        List<Proposed_Rescheduling__c> propList = new List<Proposed_Rescheduling__c>();
        system.debug('-------------'+eventId);
        Long milli = system.currenttimemillis();
        set<Id> userEventSetid = new Set<id>();
        system.debug('-------wrapList-------'+wrapList.size());
        for(wrapperEvent wrap: wrapList){
            if(wrap.isStartDateGreater == true){
                userEventSetid.add(wrap.ev.id);
            }
        }
        Event evnL = [Select e.Status__c,e.subject__c,e.WhoId, e.WhatId, e.Type, e.Trial__c, e.SystemModstamp, e.Subject, e.StartDateTime, e.ShowAs, e.ReminderDateTime, e.RecurrenceType, e.RecurrenceTimeZoneSidKey, e.RecurrenceStartDateTime, e.RecurrenceMonthOfYear, e.RecurrenceInterval, e.RecurrenceInstance, e.RecurrenceEndDateOnly, e.RecurrenceDayOfWeekMask, e.RecurrenceDayOfMonth, e.RecurrenceActivityId, e.OwnerId, e.Minutes__c, e.Location, e.LastModifiedDate, e.LastModifiedById, e.IsReminderSet, e.IsRecurrence, e.IsPrivate, e.IsGroupEvent, e.IsDeleted, e.IsChild, e.IsArchived, e.IsAllDayEvent, e.Id, e.Hours__c, e.GroupEventType, e.EndDateTime, e.DurationInMinutes, e.Description, e.CreatedDate, e.CreatedById, e.ActivityDateTime, e.ActivityDate, e.AccountId From Event e where id =: eventId ];
        List<Event> evnListPro = [Select e.Status__c, e.subject__c,e.WhoId, e.WhatId, e.Type, e.Trial__c, e.SystemModstamp, e.Subject, e.StartDateTime, e.ShowAs, e.ReminderDateTime, e.RecurrenceType, e.RecurrenceTimeZoneSidKey, e.RecurrenceStartDateTime, e.RecurrenceMonthOfYear, e.RecurrenceInterval, e.RecurrenceInstance, e.RecurrenceEndDateOnly, e.RecurrenceDayOfWeekMask, e.RecurrenceDayOfMonth, e.RecurrenceActivityId, e.OwnerId, e.Minutes__c, e.Location, e.LastModifiedDate, e.LastModifiedById, e.IsReminderSet, e.IsRecurrence, e.IsPrivate, e.IsGroupEvent, e.IsDeleted, e.IsChild, e.IsArchived, e.IsAllDayEvent, e.Id, e.Hours__c, e.GroupEventType, e.EndDateTime, e.DurationInMinutes, e.Description, e.CreatedDate, e.CreatedById, e.ActivityDateTime, e.ActivityDate, e.AccountId From Event e where id =: userEventSetid and StartDateTime >=: evnL.StartDateTime];
        system.debug('------evnListPro------'+evnListPro.size());
        if(allEvecheckboxre == false){
            for(wrapperEvent wrap: wrapList){
                if(wrap.ev.Id == eventId){
                        isEventErrorMsg = '';
                        isEventError = false;
                        if(eventres.StartDateTime < system.today()){
                            isEventErrorMsg = 'Date can\'t be in Past.';
                            isEventError = true;
                            displynonere = '';
                             
                            return null;
                        }else{
                            Proposed_Rescheduling__c pro = new Proposed_Rescheduling__c();
                            pro.Description__c = wrap.ev.Description;
                            pro.DurationInMinutes__c = wrap.ev.DurationInMinutes;
                            pro.Hours__c = wrap.ev.Hours__c;
                            pro.Minutes__c = wrap.ev.Minutes__c;
                            pro.PatientId__c = patientId;
                            pro.Eventid__c = eventId;
                            pro.Proposed_New_Date__c = eventres.StartDateTime;
                            pro.Reschedule_reason__c = eventres.Reschedule_reason__c;
                            pro.OwnerId = wrap.ev.OwnerId;
                            //pro.status__c = 'Waiting';
                           // pro.studyStaff__c = patitenObj.OwnerId;
                          //  system.debug('---pro.studyStaff__c-----'+pro.studyStaff__c);
                            pro.StartDateTime__c = wrap.ev.StartDateTime;
                            pro.subject__c = wrap.ev.subject__c;
                            pro.Trial__c = wrap.ev.Trial__c;
                            pro.Type__c = wrap.ev.Type;
                            
                            pro.refId__c = String.valueOf(milli);     
    
                            wrap.isEditMode= false;  
                            wrap.isupdateMode = false;
                        
                            propList.add(pro);
                        } 
                   }
                }           
            
        }else if(allEvecheckboxre == true){
            Integer dayplush = 0;
            Integer dayminus = 0;
            for(wrapperEvent wrap: wrapList){
                if(wrap.isStartDateGreater == true){
                    if(eventres.StartDateTime < system.today()){
                        isEventErrorMsg = 'Date can\'t be in Past';
                        isEventError = true;
                        displynonere = '';
                        return null;
                    }else{
                        if(eventId == evnL.id){
                            if(eventres.StartDateTime < evnL.StartDateTime){
                                dayminus = ((evnL.StartDateTime).date()).daysBetween( (eventres.StartDateTime).date());
                            }
                            if(eventres.StartDateTime > evnL.StartDateTime){
                                dayplush = ((evnL.StartDateTime).date()).daysBetween( (eventres.StartDateTime).date());
                            }
                        }
                        for(Event ev : evnListPro){  
                                                        
                            if(wrap.ev.StartDateTime == ev.StartDateTime && wrap.ev.Id == ev.Id){
                                Proposed_Rescheduling__c pro = new Proposed_Rescheduling__c();
                                pro.PatientId__c = patientId;
                                pro.Eventid__c = wrap.ev.Id; 
                                
                                if(dayminus != null && dayminus != 0){
                                    if(ev.id == evnL.id){
                                        pro.Proposed_New_Date__c = eventres.StartDateTime;
                                    }else{
                                        pro.Proposed_New_Date__c = wrap.ev.StartDateTime + dayminus;
                                    }
                                }else if(dayplush != null && dayplush != 0){
                                    if(wrap.ev.Id == evnL.id){
                                        pro.Proposed_New_Date__c = eventres.StartDateTime;
                                    }else{
                                        pro.Proposed_New_Date__c = wrap.ev.StartDateTime + dayplush;
                                    }
                                }else{
                                    pro.Proposed_New_Date__c = eventres.StartDateTime;
                                }
                            
                                pro.Description__c = wrap.ev.Description;
                                pro.DurationInMinutes__c = wrap.ev.DurationInMinutes;
                                pro.Hours__c = wrap.ev.Hours__c;
                                pro.Minutes__c = wrap.ev.Minutes__c;
                                pro.Reschedule_reason__c = eventres.Reschedule_reason__c;
                                pro.OwnerId = wrap.ev.OwnerId;
                                pro.StartDateTime__c = wrap.ev.StartDateTime;
                                pro.subject__c = wrap.ev.subject__c;
                                pro.Trial__c = wrap.ev.Trial__c;
                                pro.Type__c = wrap.ev.Type;
                                
                               // pro.studyStaff__c = patitenObj.OwnerId;
                                //system.debug('---pro.studyStaff__c-----'+pro.studyStaff__c);
                                
                                pro.refId__c = String.valueOf(milli);
                                wrap.isEditMode= false;  
                                wrap.isupdateMode = false;
                                propList.add(pro); 
                                
                           /*     
                                Proposed_Rescheduling__c pro1 = new Proposed_Rescheduling__c();
                                pro1.PatientId__c = patientId;
                                pro1.Eventid__c = wrap.ev.Id; 
                                
                                if(dayminus != null && dayminus != 0){
                                    if(ev.id == evnL.id){
                                        pro1.Proposed_New_Date__c = eventres.StartDateTime;
                                    }else{
                                        pro1.Proposed_New_Date__c = wrap.ev.StartDateTime + dayminus;
                                    }
                                }else if(dayplush != null && dayplush != 0){
                                    if(wrap.ev.Id == evnL.id){
                                        pro1.Proposed_New_Date__c = eventres.StartDateTime;
                                    }else{
                                        pro1.Proposed_New_Date__c = wrap.ev.StartDateTime + dayplush;
                                    }
                                }else{
                                    pro1.Proposed_New_Date__c = eventres.StartDateTime;
                                }
                            
                                pro1.Description__c = wrap.ev.Description;
                                pro1.DurationInMinutes__c = wrap.ev.DurationInMinutes;
                                pro1.Hours__c = wrap.ev.Hours__c;
                                pro1.Minutes__c = wrap.ev.Minutes__c;
                                pro1.Reschedule_reason__c = eventres.Reschedule_reason__c;
                                pro1.OwnerId = wrap.ev.OwnerId;
                                pro1.StartDateTime__c = wrap.ev.StartDateTime;
                                pro1.subject__c = wrap.ev.subject__c;
                                pro1.Trial__c = wrap.ev.Trial__c;
                                pro1.Type__c = wrap.ev.Type;
                                
                                pro1.studyStaff__c = patitenObj.OwnerId;
                                system.debug('---pro1.studyStaff__c-----'+pro1.studyStaff__c);
                                
                                pro1.refId__c = String.valueOf(milli);
                                wrap.isEditMode= false;  
                                wrap.isupdateMode = false;
                                propList.add(pro1);  */
                            }
                        }
                    }
                }
            }
        }
        if(!propList.isEmpty()){
            insert propList; 
            allEvecheckboxre = false;
        }
        Set<String> eventIdSet = new Set<String>();
        for( Proposed_Rescheduling__c prp: propList){
            eventIdSet.add(prp.eventId__c);
            system.debug('-----prp.eventId__c-----'+prp.eventId__c);
        }
        List<Event> evListUpdate = new List<Event>();
        List<Event> evListEven = [Select e.Status__c,e.subject__c,e.WhoId, e.WhatId, e.Type, e.Trial__c, e.SystemModstamp, e.Subject, e.StartDateTime, e.ShowAs, e.ReminderDateTime, e.RecurrenceType, e.RecurrenceTimeZoneSidKey, e.RecurrenceStartDateTime, e.RecurrenceMonthOfYear, e.RecurrenceInterval, e.RecurrenceInstance, e.RecurrenceEndDateOnly, e.RecurrenceDayOfWeekMask, e.RecurrenceDayOfMonth, e.RecurrenceActivityId, e.OwnerId, e.Minutes__c, e.Location, e.LastModifiedDate, e.LastModifiedById, e.IsReminderSet, e.IsRecurrence, e.IsPrivate, e.IsGroupEvent, e.IsDeleted, e.IsChild, e.IsArchived, e.IsAllDayEvent, e.Id, e.Hours__c, e.GroupEventType, e.EndDateTime, e.DurationInMinutes, e.Description, e.CreatedDate, e.CreatedById, e.ActivityDateTime, e.ActivityDate, e.AccountId From Event e where id IN: eventIdSet ];
        system.debug('-------evListEven--------'+evListEven.size());
        for(Event ev : evListEven){
            ev.status__c = 'Waiting';
            system.debug('------id-------'+ev.id);
            //evListEven.add(ev);
        }
        system.debug('-----------evListEven-'+evListEven.size());
        update evListEven;
        system.debug('-----------evListEven-'+evListEven.size());
        
        eventres.Reschedule_reason__c = null;
        eventres.StartDateTime = null;
        
        return null;
    }
        
        /*  List<Event> eventSaveList = new List<Event>();
            string evidsave = Apexpages.currentPage().getParameters().get('ev');
        
            for(wrapperEvent wrap: wrapList){
                if(wrap.ev.Id == evidsave){
                    wrap.ev.ActivityDateTime = wrap.ev.StartDateTime;
                    wrap.ev.EndDateTime = null;
                    wrap.ev.DurationInMinutes = 480;
                    wrap.isEditMode= false;  
                    wrap.isupdateMode = false;
                    eventSaveList.add(wrap.ev);
                }  
            }
            if(!eventSaveList.isEmpty()){
                update eventSaveList;
            }
            */
    public Pagereference cancelEventSch(){
        Pagereference pr = new Pagereference('/apex/TranscendPage?id='+patientId);
        system.debug('------------pr----------'+pr);
        return pr;
    }
    public class wrapperEvent{
        public Event ev {get;set;}
        public Boolean isEditMode {get;set;}
        public Boolean isupdateMode {get;set;}
        public Boolean isStartDateGreater {get;set;}
        public Boolean isRescheduleButton{get;set;}
        public wrapperEvent(){
            isEditMode = false;
            isupdateMode = false;
            isStartDateGreater = false;
            isRescheduleButton = false;
            
        }
    }
    
     public void updateEmail(){
        Patient_Custom__c pat = new Patient_Custom__c();
        pat = [Select p.Email__c, p.Zip__c, Middle_Name__c, Suffix__c, Initials__c, VIP__c, p.SystemModstamp, p.Surgeon__r.Name, p.Surgeon__c, p.Study_Registration_Eligibility__c, p.Status__c, p.State__c, p.Signed_Screening__c, p.Screen_Failure_Number__c, p.SSN__c, p.RecordTypeId, p.Race__c, p.Primary_MD__r.Name, p.Primary_MD__c, p.Owner.Name, p.OwnerId, p.Name, p.Medical_Record_Number__c, p.Last_Name__c, p.LastModifiedDate, p.LastModifiedBy.Name, p.LastModifiedById, p.LastActivityDate, p.IsDeleted, p.Institution__c, p.Institute_Text__c, p.Id, p.Gender__c, p.First_Name__c, p.Ethnicity__c, p.CreatedDate, p.CreatedBy.Name, p.CreatedById, p.Country_of_Birth__c, p.Country__c, p.City__c, p.Birthdate__c, p.Age__c, p.Address_Line_2__c, p.Address_Line_1__c, RecordType.Name From Patient_Custom__c p where Id = :patientId];
        system.debug('--------pat--------'+pat.Id);
        List<User> userList = [Select u.Username, u.UserType, u.UserRoleId, u.UserPreferencesTaskRemindersCheckboxDefault, u.UserPreferencesReminderSoundOff, u.UserPreferencesOptOutOfTouch, u.UserPreferencesEventRemindersCheckboxDefault, u.UserPreferencesDisableAutoSubForFeeds, u.UserPreferencesApexPagesDeveloperMode, u.UserPreferencesActivityRemindersPopup, u.UserPermissionsSFContentUser, u.UserPermissionsOfflineUser, u.UserPermissionsMobileUser, u.UserPermissionsMarketingUser, u.UserPermissionsCallCenterAutoLogin, u.UserPermissionsAvantgoUser, u.Title, u.TimeZoneSidKey, u.SystemModstamp, u.Street, u.State, u.SecurityCode__c, u.ReceivesInfoEmails, u.ReceivesAdminInfoEmails, u.ProfileId, u.PostalCode, u.Phone, u.Patient_Id__c, u.OfflineTrialExpirationDate, u.OfflinePdaTrialExpirationDate, u.Name, u.MobilePhone, u.ManagerId, u.LocaleSidKey, u.LastName, u.LastModifiedDate, u.LastModifiedById, u.LastLoginDate, u.LanguageLocaleKey, u.IsPortalEnabled, u.IsActive, u.Id, u.ForecastEnabled, u.FirstName, u.FederationIdentifier, u.Fax, u.Extension, u.EmployeeNumber, u.EmailEncodingKey, u.Email, u.Division, u.Department, u.DelegatedApproverId, u.CurrentStatus, u.CreatedDate, u.CreatedById, u.Country, u.ContactId, u.CompanyName, u.CommunityNickname, u.City, u.CallCenterId, u.Alias, u.AccountId, u.AboutMe From User u where Username =:patient.Email__c];
        if(userList.size() > 0){
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'This Email Already ebabled in portal'));
                
        }else{
            pat.Email__c = patient.Email__c; 
            pat.isPortalEnable__c = true; 
             
            update pat;  
            system.debug('--------pat--------'+pat);
            Set<id> idset = new Set<Id>();
            idset.add(pat.Id);
            PartnerPortalManager.createPartnerPortalUser(idset);
        }
    }
    
    
    
    public void showCrf() {
        System.debug('-------selectedTrial------>'+selectedTrial);
        if(selectedTrial!=null && selectedTrial!='') {
            for(Selectoption to : trialOption) {
                system.debug('__to.getLabel()__'+to.getLabel());
                if(to.getValue() == selectedTrial) {
                    trialName = to.getLabel();
                }
            }
            List<Registration__c> regiList = [select Registration_Date__c, Status__c from Registration__c where Patient__c =:patientId and Trial__c =: selectedTrial order by LastModifiedDate desc limit 1];
            if(!regiList.isEmpty()) {
                system.debug('__regiList[0].Registration_Date__c__'+regiList[0].Registration_Date__c);
                Date regDate = regiList[0].Registration_Date__c;
                if(regDate != null) {
                    system.debug('__DateTime.valueOf(regiList[0].Registration_Date__c)__'+datetime.newInstance(regDate.year(), regDate.month(), regDate.day()));
                    registrationDateTimeStamp = datetime.newInstance(regDate.year(), regDate.month(), regDate.day()).getTime();
                    system.debug('__registrationDateTimeStamp__'+registrationDateTimeStamp);
                }
            }
            screenWrapList = new List<wrapScreen>();
            treatmentWrapList = new List<wrapTreatment>();
            followWrapList = new List<wrapFollow>();
            //lstTask = [select ActivityDate, CRF_Form_Id__c, Subject, Type, Schedule_Event_Date__c, Object_Name__c, WhatId, Status, Trial_Id__c from Task where WhatId =:patientId and Status != 'Completed' and Trial_Id__c =:selectedTrial order by ActivityDate];
            List<Task> lstTaskAll = [select ActivityDate, Subject, Type, Schedule_Event_Date__c, Object_Name__c, WhatId, Status from Task where WhatId =:patientId and Trial_Id__c =:selectedTrial and OwnerId =:Userinfo.getUserId() and Status!='Expired' order by ActivityDate];
            lstPhase = [Select p.Phase_Cycle__r.Phase__c, p.Phase_Cycle__c, p.CRF__r.CRFType__c, p.CRF__r.Object_Name__c, p.CRF__r.Id, p.CRF__c, Next_Due_on__c From Phase_CRFs__c p order by Order__c];
            List<Trial_CRF__c> associateCRFList = [Select a.Trial__c, a.SystemModstamp, a.OwnerId, a.Name, a.LastModifiedDate, a.LastModifiedById, a.IsDeleted, a.Id, a.CreatedDate, a.CreatedById, a.CRFMaster__c From Trial_CRF__c a where Trial__c =:selectedTrial];
            
            lstPhaseMaster = [Select p.Name, p.Id From Phase_Master__c p];
            //lstPhase2 = [Select p.Name, p.Id From Phase_Master__c p where Name='Treatment'];
            //lstPhase3 = [Select p.Name, p.Id From Phase_Master__c p where Name='Follow Up'];
            List<PreEligibility_Checklist__c> preEligList = [select Effective_Time__c, Id, Status__c, CompletedDate__c from PreEligibility_Checklist__c where Patient__c =:patientId];
            User usr= [ Select u.ProfileId, u.Profile.Name, u.Id From User u where id =: userinfo.getUserId() ];
            system.debug('__preEligList__'+preEligList);  
            for(Phase_CRFs__c phaseCrfObj : lstPhase) {
                List<Sobject> objectList = new List<Sobject>(); 
                try {
                    System.debug('Select Effective_Time__c, Id, Status__c, CompletedDate__c From '+phaseCrfObj.CRF__r.Object_Name__c+' where TrialPatient__r.Trial_Id__c = \''+selectedTrial+'\' and TrialPatient__r.Patient_Id__c = \''+patientId+'\'');
                    if(phaseCrfObj.CRF__r.Object_Name__c != null && phaseCrfObj.CRF__r.Object_Name__c != 'PreEligibility_Checklist__c'){  
                        /*objectList = Database.query('Select Effective_Time__c, Id, Status__c, CompletedDate__c, TrialPatient__c From '+phaseCrfObj.CRF__r.Object_Name__c+' where TrialPatient__r.Trial_Id__c = \''+selectedTrial+'\' and TrialPatient__r.Patient_Id__c = \''+patientId+'\' and Status__c != \'Cloned\' order by Effective_Time__c DESC');
                        system.debug('__phaseCrfObj.CRF__r.Object_Name__c__'+phaseCrfObj.CRF__r.Object_Name__c);
                        system.debug('__objectList__'+objectList);*/
                        List<Sobject> allCrfRecords = Database.query('Select Effective_Time__c, Id, Status__c, CompletedDate__c, TrialPatient__c, OriginalCRF__c From '+phaseCrfObj.CRF__r.Object_Name__c+' where TrialPatient__r.Trial_Id__c = \''+selectedTrial+'\' and TrialPatient__r.Patient_Id__c = \''+patientId+'\' and Status__c != \'Cloned\' and Effective_Time__c != null order by Effective_Time__c DESC');
                        set<Id> rejectedCrfsToBeIgnored = new set<Id>(); //these Id's records should not be visible on patient's detial page.
                        for(Sobject sobj: allCrfRecords) {
                            system.debug('__sobj.get(Status__c)__'+sobj.get('Status__c'));
                            system.debug('__sobj.get(OriginalCRF__c)__'+sobj.get('OriginalCRF__c'));
                            if(sobj.get('Status__c') != 'Cloned' && sobj.get('OriginalCRF__c') != null) {
                                rejectedCrfsToBeIgnored.add((Id)sobj.get('OriginalCRF__c'));
                            }
                        }
                        system.debug('__rejectedCrfsToBeIgnored__'+rejectedCrfsToBeIgnored);
                        for(Integer i = 0; i<allCrfRecords.size(); i++) {
                            system.debug('objectList.get(i).get(Status__c): '+allCrfRecords.get(i).get('Status__c'));
                            if(!rejectedCrfsToBeIgnored.contains((Id)allCrfRecords.get(i).get('Id'))) {
                                objectList.add(allCrfRecords.get(i));
                            }
                        }
                    }
                }
                catch(Exception e) {
                    system.debug('__error__'+e);
                }
                for(Trial_CRF__c associateCRFObj : associateCRFList) {
                    if(associateCRFObj.CRFMaster__c == phaseCrfObj.CRF__c) {
                        for(Phase_Master__c phaseMasterObj : lstPhaseMaster) {
                            System.debug('-------phaseMasterObj------>'+phaseMasterObj);
                            if(phaseMasterObj.Name == 'Screening' && phaseMasterObj.Id == phaseCrfObj.Phase_Cycle__r.Phase__c) {
                                System.debug('-------phaseMasterObj------>'+phaseMasterObj);
                                wrapScreen screenWrapObj = new wrapScreen();
                                screenWrapObj.screenForm = phaseCrfObj.CRF__r.CRFType__c;
                                screenWrapObj.formObjectName = phaseCrfObj.CRF__r.Object_Name__c;
                                screenWrapObj.nextDueOn = phaseCrfObj.Next_Due_on__c;
                                for(Task tsk : lstTaskAll) {
                                    system.debug('tsk.WhatId: '+tsk.WhatId+', patientId: '+patientId);
                                    system.debug('tsk.Object_Name__c: '+tsk.Object_Name__c+', phaseCrfObj.CRF__r.Object_Name__c: '+phaseCrfObj.CRF__r.Object_Name__c);
                                    if(tsk.WhatId == patientId && tsk.Object_Name__c == phaseCrfObj.CRF__r.Object_Name__c) {
                                        screenWrapObj.nextDueOn = tsk.ActivityDate.format();
                                        screenWrapObj.isTaskCreated = true;
                                        screenWrapObj.nextDueColumnColor = 'red';
                                        if(tsk.Status == 'Completed') {
                                            screenWrapObj.nextDueColumnColor = '#000';
                                        }
                                    }
                                    if(tsk.Status != 'Completed') {
                                        selectedTab = 'taskTab';
                                    }
                                }
                                screenWrapObj.isShowColumn = true;
                                screenWrapObj.isInserted = false;
                                
                                if(phaseCrfObj.CRF__r.Object_Name__c == 'PreEligibility_Checklist__c' || phaseCrfObj.CRF__r.Object_Name__c == 'Registration__c') {
                                    screenWrapObj.isShowColumn = false;
                                }
                                try {
                                    if(phaseCrfObj.CRF__r.Object_Name__c == 'PreEligibility_Checklist__c') {
                                        
                                        if(!preEligList.isEmpty()) {
                                            screenWrapObj.isInserted = true;
                                            screenWrapObj.CreatedDate = Datetime.valueOf(preEligList[0].get('Effective_Time__c')).format('MM/dd/yyyy', 'PST');
                                            //Datetime.valueOf(wrapCrfObj.createdDate).format('E MMM dd HH:mm:ss z yyyy', 'PST');
                                            screenWrapObj.CompletedDate = Date.valueOf(preEligList[0].get('CompletedDate__c'));
                                            screenWrapObj.status = String.valueOf(preEligList[0].get('Status__c'));
                                            system.debug('__rId__'+preEligList[0].get('Id'));
                                            screenWrapObj.rId = string.valueOf(preEligList[0].get('Id'));
                                        }
                                    } 
                                    else if(phaseCrfObj.CRF__r.Object_Name__c == 'MammaPrintDetail__c') { // newly added logic to hide submit button from site user
                                        system.debug('__mamma__'+phaseCrfObj.CRF__r.Object_Name__c);
                                        system.debug('__usr__'+usr);
                                        if(usr != null && usr.Profile.Name == 'Site User') {
                                            screenWrapObj.isInserted = true;
                                            if(!objectList.isEmpty()) {
                                                screenWrapObj.CreatedDate = Datetime.valueOf(objectList[0].get('Effective_Time__c')).format('MM/dd/yyyy', 'PST');
                                                screenWrapObj.CompletedDate = Date.valueOf(objectList[0].get('CompletedDate__c'));
                                                screenWrapObj.TrialPatId = String.valueOf(objectList[0].get('TrialPatient__c'));
                                                screenWrapObj.status = String.valueOf(objectList[0].get('Status__c'));
                                                system.debug('__rId__'+objectList[0].get('Id'));
                                                screenWrapObj.rId = string.valueOf(objectList[0].get('Id'));
                                            }
                                        } else {
                                            if(!objectList.isEmpty()) {
                                                screenWrapObj.isInserted = true;
                                                screenWrapObj.CreatedDate = Datetime.valueOf(objectList[0].get('Effective_Time__c')).format('MM/dd/yyyy', 'PST');
                                                //screenWrapObj.CreatedDate = Date.valueOf(Datetime.valueOf(objectList[0].get('CreatedDate')));
                                                screenWrapObj.CompletedDate = Date.valueOf(objectList[0].get('CompletedDate__c'));
                                                screenWrapObj.TrialPatId = String.valueOf(objectList[0].get('TrialPatient__c'));
                                                screenWrapObj.status = String.valueOf(objectList[0].get('Status__c'));
                                                system.debug('__rId__'+objectList[0].get('Id'));
                                                screenWrapObj.rId = string.valueOf(objectList[0].get('Id'));
                                            }
                                        }
                                    }   // end of newly added logic
                                    else if(phaseCrfObj.CRF__r.Object_Name__c == 'Registration__c' || phaseCrfObj.CRF__r.Object_Name__c == 'MRI_Volume__c' || phaseCrfObj.CRF__r.Object_Name__c == 'TissueSpecimenDetail__c' || phaseCrfObj.CRF__r.Object_Name__c == 'BloodSpecimenForm__c'){
                                        SelectOption option = new SelectOption('','- - View Past - -');
                                        screenWrapObj.crfCreatedDateOption.add(option);
                                        system.debug('__screeningId__'+objectList);
                                        if(!objectList.isEmpty()) {
                                           // screenWrapObj.CreatedDate = Date.valueOf(objectList[0].get('CreatedDate'));
                                            screenWrapObj.CreatedDate = Datetime.valueOf(objectList[0].get('Effective_Time__c')).format('MM/dd/yyyy', 'PST');
                                            /*if(phaseCrfObj.CRF__r.Object_Name__c == 'Registration__c') {
                                                screenWrapObj.CompletedDate = Date.valueOf(objectList[objectList.size() - 1].get('CompletedDate__c'));
                                                screenWrapObj.status = String.valueOf(objectList[objectList.size() - 1].get('Status__c'));
                                            }else{*/
                                                screenWrapObj.CompletedDate = Date.valueOf(objectList[0].get('CompletedDate__c'));
                                                screenWrapObj.status = String.valueOf(objectList[0].get('Status__c'));
                                            //}
                                            screenWrapObj.TrialPatId = String.valueOf(objectList[0].get('TrialPatient__c'));
                                            system.debug('__MRI_Volume__c Id__'+objectList[0].get('Id'));
                                            screenWrapObj.rId = string.valueOf(objectList[0].get('Id'));
                                            for(Sobject tmpObj : objectList) {
                                                option = new SelectOption(string.valueOf(tmpObj.get('Id')),Date.valueOf(tmpObj.get('Effective_Time__c')).format()+' - '+tmpObj.get('Status__c'));
                                                screenWrapObj.crfCreatedDateOption.add(option);
                                            }
                                        }
                                    } /*else if(phaseCrfObj.CRF__r.Object_Name__c == 'TissueSpecimenDetail__c'){
                                        SelectOption option = new SelectOption('','- - View Past - -');
                                        screenWrapObj.crfCreatedDateOption.add(option);
                                        system.debug('__TissueSpecimenDetail__c Id__'+objectList);
                                        if(!objectList.isEmpty()) {
                                            screenWrapObj.isInserted = false;
                                           // screenWrapObj.CreatedDate = Date.valueOf(objectList[0].get('CreatedDate'));
                                            screenWrapObj.CreatedDate = Datetime.valueOf(objectList[0].get('CreatedDate')).format('MM/dd/yyyy', 'PST');
                                            screenWrapObj.CompletedDate = Date.valueOf(objectList[0].get('CompletedDate__c'));
                                            screenWrapObj.TrialPatId = String.valueOf(objectList[0].get('TrialPatient__c'));
                                            screenWrapObj.status = String.valueOf(objectList[0].get('Status__c'));
                                            system.debug('__TissueSpecimenDetail__c Id__'+objectList[0].get('Id'));
                                            screenWrapObj.rId = string.valueOf(objectList[0].get('Id'));
                                            for(Sobject tmpObj : objectList) {
                                                option = new SelectOption(string.valueOf(tmpObj.get('Id')),Date.valueOf(tmpObj.get('CreatedDate')).format());
                                                screenWrapObj.crfCreatedDateOption.add(option);
                                            }
                                        }
                                    } else if(phaseCrfObj.CRF__r.Object_Name__c == 'BloodSpecimenForm__c'){
                                        SelectOption option = new SelectOption('','- - View Past - -');
                                        screenWrapObj.crfCreatedDateOption.add(option);
                                        system.debug('__BloodSpecimenForm__c Id__'+objectList);
                                        if(!objectList.isEmpty()) {
                                            screenWrapObj.isInserted = false;
                                           // screenWrapObj.CreatedDate = Date.valueOf(objectList[0].get('CreatedDate'));
                                            screenWrapObj.CreatedDate = Datetime.valueOf(objectList[0].get('CreatedDate')).format('MM/dd/yyyy', 'PST');
                                            screenWrapObj.CompletedDate = Date.valueOf(objectList[0].get('CompletedDate__c'));
                                            screenWrapObj.TrialPatId = String.valueOf(objectList[0].get('TrialPatient__c'));
                                            screenWrapObj.status = String.valueOf(objectList[0].get('Status__c'));
                                            system.debug('__BloodSpecimenForm__c Id__'+objectList[0].get('Id'));
                                            screenWrapObj.rId = string.valueOf(objectList[0].get('Id'));
                                            for(Sobject tmpObj : objectList) {
                                                option = new SelectOption(string.valueOf(tmpObj.get('Id')),Date.valueOf(tmpObj.get('CreatedDate')).format());
                                                screenWrapObj.crfCreatedDateOption.add(option);
                                            }
                                        }
                                    }*/ else {
                                        
                                        if(phaseCrfObj.CRF__r.Object_Name__c == 'Response_Evaluation_Form__c') {
                                            if(!objectList.isEmpty()) {
                                                screenWrapObj.isInserted = true;
                                                
                                                screenWrapObj.CreatedDate = Datetime.valueOf(objectList[objectList.size() - 1].get('Effective_Time__c')).format('MM/dd/yyyy', 'PST');
                                                //screenWrapObj.CreatedDate = Date.valueOf(objectList[0].get('CreatedDate'));
                                                system.debug('__screenWrapObj.CreatedDate__'+screenWrapObj.CreatedDate);
                                                screenWrapObj.CompletedDate = Date.valueOf(objectList[objectList.size() - 1].get('CompletedDate__c'));
                                                screenWrapObj.TrialPatId = String.valueOf(objectList[objectList.size() - 1].get('TrialPatient__c'));
                                                screenWrapObj.status = String.valueOf(objectList[objectList.size() - 1].get('Status__c'));
                                                system.debug('__rId__'+objectList[objectList.size() - 1].get('Id'));
                                                screenWrapObj.rId = string.valueOf(objectList[objectList.size() - 1].get('Id'));
                                            }
                                        } else {
                                            if(!objectList.isEmpty()) {
                                                screenWrapObj.isInserted = true;
                                                
                                                screenWrapObj.CreatedDate = Datetime.valueOf(objectList[0].get('Effective_Time__c')).format('MM/dd/yyyy', 'PST');
                                                //screenWrapObj.CreatedDate = Date.valueOf(objectList[0].get('CreatedDate'));
                                                system.debug('__screenWrapObj.CreatedDate__'+screenWrapObj.CreatedDate);
                                                screenWrapObj.CompletedDate = Date.valueOf(objectList[0].get('CompletedDate__c'));
                                                screenWrapObj.TrialPatId = String.valueOf(objectList[0].get('TrialPatient__c'));
                                                screenWrapObj.status = String.valueOf(objectList[0].get('Status__c'));
                                                system.debug('__rId__'+objectList[0].get('Id'));
                                                screenWrapObj.rId = string.valueOf(objectList[0].get('Id'));
                                            }
                                        }
                                    }
                                }
                                catch(Exception e) {
                                    system.debug('__error__'+e);
                                } 
                                System.debug('-------screenWrapObj------>'+screenWrapObj);
                                //if(screenWrapObj.screenForm == 'Patient Registration Form')screenWrapObj.isInserted = false;
                                screenWrapList.add(screenWrapObj);
                                System.debug('-------screenWrapList------>'+screenWrapList);
                            }
                            else if(phaseMasterObj.Name == 'Follow Up' && phaseMasterObj.Id == phaseCrfObj.Phase_Cycle__r.Phase__c) {
                                wrapFollow followWrapObj = new wrapFollow();
                                followWrapObj.followForm = phaseCrfObj.CRF__r.CRFType__c;
                                followWrapObj.formObjectName = phaseCrfObj.CRF__r.Object_Name__c;
                                followWrapObj.nextDueOn = phaseCrfObj.Next_Due_on__c;
                                for(Task tsk : lstTaskAll) {
                                    if(tsk.WhatId == patientId && tsk.Object_Name__c == phaseCrfObj.CRF__r.Object_Name__c) {
                                        followWrapObj.nextDueOn = tsk.ActivityDate.format();
                                        followWrapObj.isTaskCreated = true;
                                        followWrapObj.nextDueColumnColor = 'red';
                                        if(tsk.Status == 'Completed') {
                                            followWrapObj.nextDueColumnColor = '#000';
                                        }
                                    }
                                    if(tsk.Status != 'Completed') {
                                        selectedTab = 'taskTab';
                                    }
                                }
                                followWrapObj.isShowColumn = true;
                                followWrapObj.isInserted = false;
                                
                                if(phaseCrfObj.CRF__r.Object_Name__c == 'PreEligibility_Checklist__c' || phaseCrfObj.CRF__r.Object_Name__c == 'Registration__c') {
                                    followWrapObj.isShowColumn = false;
                                }
                                
                                //if(!phaseCrfObj.CRF__r.Object_Name__c.contains(' Form__c')) {
                                //}
                                try {
                                    /*if(phaseCrfObj.CRF__r.Object_Name__c == 'PreEligibility_Checklist__c') {
                                        if(!preEligList.isEmpty()) {
                                            followWrapObj.isInserted = true;
                                            followWrapObj.CreatedDate = Date.valueOf(preEligList[0].get('CreatedDate'));
                                            followWrapObj.CompletedDate = Date.valueOf(preEligList[0].get('CompletedDate__c'));
                                            followWrapObj.rId = string.valueOf(preEligList[0].get('Id'));
                                        }
                                    }
                                    else {*/
                                        SelectOption option = new SelectOption('','- - View Past - -');
                                        followWrapObj.crfCreatedDateOption.add(option);
                                        
                                        if(!objectList.isEmpty()) {
                                            followWrapObj.isInserted = false;
                                            //followWrapObj.CreatedDate = Date.valueOf(objectList[0].get('CreatedDate'));
                                            followWrapObj.CreatedDate = Datetime.valueOf(objectList[0].get('Effective_Time__c')).format('MM/dd/yyyy', 'PST');
                                            followWrapObj.CompletedDate = Date.valueOf(objectList[0].get('CompletedDate__c'));
                                            followWrapObj.TrialPatId = String.valueOf(objectList[0].get('TrialPatient__c'));
                                            followWrapObj.status = String.valueOf(objectList[0].get('Status__c'));
                                            system.debug('__rId__'+objectList[0].get('Id'));
                                            followWrapObj.rId = string.valueOf(objectList[0].get('Id'));
                                            for(Sobject tmpObj : objectList) {
                                                option = new SelectOption(string.valueOf(tmpObj.get('Id')),Datetime.valueOf(tmpObj.get('Effective_Time__c')).format('MM/dd/yyyy', 'PST')+' - '+String.valueOf(tmpObj.get('Status__c')));
                                                followWrapObj.crfCreatedDateOption.add(option);
                                            }
                                        }
                                    //}
                                }
                                catch(Exception e) {
                                    System.debug('Exception : '+e);
                                }
                                
                                followWrapList.add(followWrapObj);
                            }
                            else if(phaseMasterObj.Name == 'Treatment' && phaseMasterObj.Id == phaseCrfObj.Phase_Cycle__r.Phase__c ) {
                                wrapTreatment treatmentWrapObj = new wrapTreatment();
                                treatmentWrapObj.treatmentForm = phaseCrfObj.CRF__r.CRFType__c;
                                treatmentWrapObj.formObjectName = phaseCrfObj.CRF__r.Object_Name__c;
                                treatmentWrapObj.nextDueOn = phaseCrfObj.Next_Due_on__c;
                                for(Task tsk : lstTaskAll) {
                                    if(tsk.WhatId == patientId && tsk.Object_Name__c == phaseCrfObj.CRF__r.Object_Name__c) {
                                        treatmentWrapObj.nextDueOn = tsk.ActivityDate.format();
                                        treatmentWrapObj.isTaskCreated = true;
                                        treatmentWrapObj.nextDueColumnColor = 'red';
                                        if(tsk.Status == 'Completed') {
                                            treatmentWrapObj.nextDueColumnColor = '#333333';
                                        }
                                    }
                                    if(tsk.Status != 'Completed') {
                                        selectedTab = 'taskTab';
                                    }
                                }
                                treatmentWrapObj.isShowColumn = true;
                                treatmentWrapObj.isInserted = false;
                                
                                if(phaseCrfObj.CRF__r.Object_Name__c == 'PreEligibility_Checklist__c' || phaseCrfObj.CRF__r.Object_Name__c == 'Registration__c') {
                                    treatmentWrapObj.isShowColumn = false;
                                }
                                try {
                                    /*if(phaseCrfObj.CRF__r.Object_Name__c == 'PreEligibility_Checklist__c') {
                                        if(!preEligList.isEmpty()) {
                                            treatmentWrapObj.isInserted = true;
                                            treatmentWrapObj.CreatedDate = Date.valueOf(preEligList[0].get('CreatedDate'));
                                            treatmentWrapObj.CompletedDate = Date.valueOf(preEligList[0].get('CompletedDate__c'));
                                            treatmentWrapObj.rId = string.valueOf(preEligList[0].get('Id'));
                                        }
                                    }
                                    else {*/
                                        SelectOption option = new SelectOption('','- - View Past - -');
                                        treatmentWrapObj.crfCreatedDateOption.add(option);
                                        /*if(phaseCrfObj.CRF__r.Object_Name__c == 'Lab_and_Test__c') {
                                            system.debug('objectList[objectList.Size()-1].get(Status__c): '+objectList[objectList.Size()-1].get('Status__c'));
                                            system.debug('objectList[0].get(Status__c): '+objectList[0].get('Status__c'));
                                        }*/
                                        if(phaseCrfObj.CRF__r.Object_Name__c != 'Response_Evaluation_Form__c') {
                                        
                                            if(!objectList.isEmpty()) {
                                                treatmentWrapObj.isInserted = false;
                                                //treatmentWrapObj.CreatedDate = Date.valueOf(objectList[0].get('CreatedDate'));
                                                treatmentWrapObj.CreatedDate = Datetime.valueOf(objectList[0].get('Effective_Time__c')).format('MM/dd/yyyy', 'PST');
                                                treatmentWrapObj.CompletedDate = Date.valueOf(objectList[0].get('CompletedDate__c'));
                                                treatmentWrapObj.TrialPatId = String.valueOf(objectList[0].get('TrialPatient__c'));
                                                treatmentWrapObj.status = String.valueOf(objectList[0].get('Status__c'));
                                                system.debug('__rId__'+objectList[0].get('Id'));
                                                treatmentWrapObj.rId = string.valueOf(objectList[0].get('Id'));
                                                for(Sobject tmpObj : objectList) {
                                                    option = new SelectOption(string.valueOf(tmpObj.get('Id')),Datetime.valueOf(tmpObj.get('Effective_Time__c')).format('MM/dd/yyyy', 'PST')+' - '+String.valueOf(tmpObj.get('Status__c')));
                                                    treatmentWrapObj.crfCreatedDateOption.add(option);
                                                }
                                            }
                                        } else {
                                            if(!objectList.isEmpty() && objectList.size() > 1) {
                                                treatmentWrapObj.isInserted = false;
                                                //treatmentWrapObj.CreatedDate = Date.valueOf(objectList[0].get('CreatedDate'));
                                                 //if(objectList[0].get('Effective_Time__c') == null) continue;
                                                treatmentWrapObj.CreatedDate = Datetime.valueOf(objectList[0].get('Effective_Time__c')).format('MM/dd/yyyy', 'PST');
                                                treatmentWrapObj.CompletedDate = Date.valueOf(objectList[0].get('CompletedDate__c'));
                                                treatmentWrapObj.TrialPatId = String.valueOf(objectList[0].get('TrialPatient__c'));
                                                treatmentWrapObj.status = String.valueOf(objectList[0].get('Status__c'));
                                                system.debug('__rId__'+objectList[0].get('Id'));
                                                treatmentWrapObj.rId = string.valueOf(objectList[0].get('Id'));
                                                for(integer i=0;i<objectList.size()-1;i++) {
                                                    option = new SelectOption(string.valueOf(objectList[i].get('Id')),Datetime.valueOf(objectList[i].get('Effective_Time__c')).format('MM/dd/yyyy', 'PST')+' - '+String.valueOf(objectList[i].get('Status__c')));
                                                    treatmentWrapObj.crfCreatedDateOption.add(option);
                                                }
                                            }
                                        }
                                }
                                catch(Exception e) {
                                }
                                treatmentWrapList.add(treatmentWrapObj);
                            }
                        }
                    }
                }
            }
            
            if(screenWrapList != null && screenWrapList.size() > 0) {
                crfInScreening = false;
            } else {
                crfInScreening = true;
            }
            if(treatmentWrapList != null && treatmentWrapList.size() > 0) {
                crfInTreatment = false;
            } else {
                crfInTreatment = true;
            }
            if(followWrapList != null && followWrapList.size() > 0) {
                crfInFollowup = false;
            } else {
                crfInFollowup = true;
            }
            isShowTabValue = true;
        }
    }
    
    public Pagereference deleteRandomization() {
        String objectNameValue = Apexpages.currentPage().getParameters().get('objectName');
        String objectIdValue = Apexpages.currentPage().getParameters().get('objectId');
        system.debug('__objectNameValue__'+objectNameValue);
        system.debug('__objectIdValue__'+objectIdValue);
        system.debug('__patientId__'+patientId);
        system.debug('__selectedTrial__'+selectedTrial);
        List<TrialPatient__c> trailPatList = [Select (Select Id From Randomization_Forms__r) From TrialPatient__c t where Patient_Id__c =:patientId and Trial_Id__c =: selectedTrial];
        if(objectNameValue == 'Randomization_Form__c') {
            String usrProfileName = [select u.Profile.Name from User u where u.id = :Userinfo.getUserId()].Profile.Name;
            system.debug('usrProfileName : '+usrProfileName);
            if(usrProfileName == 'Site User') {
                errorMsg = 'The Site User don\'t have permission to access Randomization Form.';
                isRegisterError = true;
                return null;
            } else {
                if(!trailPatList.IsEmpty()) {
                    delete [select Id from Randomization_Form__c where TrialPatient__c = :trailPatList[0].Id];
                }
            }
            
        }
        pageRef = new Pagereference('/apex/TranscendPage?id='+patientId);
        pageRef.setRedirect(true);
        return pageRef; 
    }
    
    public boolean crfInScreening {get;set;}
    public boolean crfInTreatment {get;set;}
    public boolean crfInFollowup {get;set;}
    public Pagereference redirectNewPage() {
        String objectNameValue = Apexpages.currentPage().getParameters().get('objectName');
        String objectIdValue = Apexpages.currentPage().getParameters().get('objectId');
        String phaseName = Apexpages.currentPage().getParameters().get('phaseName');
        system.debug('__objectNameValue__'+objectNameValue);
        system.debug('__objectIdValue__'+objectIdValue);
        system.debug('__patientId__'+patientId);
        system.debug('__selectedTrial__'+selectedTrial);
        isRegisterError = false;
        
        String recordIdParam = '';
        List<TrialPatient__c> trailPatList = [Select t.Trial_Id__r.Name, t.Trial_Id__c, Id, Name, Patient_Id__r.Name, Patient_Id__r.Age__c, Patient_Id__r.Signed_Screening__c From TrialPatient__c t where Patient_Id__c =:patientId and Trial_Id__c =: selectedTrial];
        List<PreEligibility_Checklist__c> preEliList = [select Id from PreEligibility_Checklist__c where Patient__c =:patientId AND Status__c = 'Approval Not Required'];
        List<Registration__c> regiList = [select RecordTypeId, Status__c from Registration__c where Patient__c =:patientId and Trial__c =: selectedTrial order by LastModifiedDate desc limit 1];
        System.debug('__preEliList__'+preEliList);
        System.debug('__regiList__'+regiList);
        
        if(objectNameValue !='Registration__c' && objectNameValue !='PreEligibility_Checklist__c') {
            if(regiList.isEmpty()) {
                errorMsg = 'Please first register patient.';
                isRegisterError = true;
                return null;
            } else if(regiList[0].Status__c == 'Not Completed') {
                errorMsg = 'Please first complete the registration.';
                isRegisterError = true;
                return null;
            }
        }
        /*
        * Checking The All CRF Forms if the patient filled pre-EligibilityCRF Or Not 
        */
        if(objectNameValue == 'TissueSpecimenDetail__c') {
            //pageRef = new Pagereference('/a0x/e?CF00Nc0000000GsdL='+trailPatList[0].Name+'&CF00Nc0000000GsdL_lkid='+trailPatList[0].Id+'&retURL=%2Fapex%2FTranscendPage%3Fpid%3D'+trailPatList[0].Id);
            pageRef = new Pagereference('/apex/TissueSpecimenForm?trialPat='+trailPatList[0].Id);
        } else if(objectNameValue == 'BaselineSymptomsForm__c') {
           // pageRef = new Pagereference('/a0x/e?CF00Nc0000000GsdL='+trailPatList[0].Name+'&CF00Nc0000000GsdL_lkid='+trailPatList[0].Id+'&retURL=%2Fapex%2FTranscendPage%3Fpid%3D'+trailPatList[0].Id);
            pageRef = new Pagereference('/apex/BaselineSymptomsForm?trialPat='+trailPatList[0].Id);
        } else if(objectNameValue == 'Chemo_Treatment__c') {
            pageRef = new Pagereference('/apex/ChemoTreatmentForm?trialPat='+trailPatList[0].Id);
        } else if(objectNameValue == 'Chemo_Summary_Form__c') {
            pageRef = new Pagereference('/apex/ChemoSummaryForm?trialPat='+trailPatList[0].Id);
        } else if(objectNameValue == 'PreEligibility_Checklist__c') {
            Integer screenSign = 0;
            if(patient.Signed_Screening__c) {
                screenSign = 1;
            }
            pageRef = new Pagereference('/apex/PreEligibilityChecklist?PatientId='+patientId+'&trialId='+selectedTrial);
        }
        else if(objectNameValue == 'Registration__c') {
            if(preEliList.isEmpty()) {
                errorMsg = 'Please first fill Pre-Eligibility Checklist for this patient.';
                isRegisterError = true;
                return null;
            }
            system.debug('__patient__'+patient);
            //List<Trial__c> trialList = [select Name from Trial__c where Id =:selectedTrial];
            List<InstitutionUser__c> institutionUserList = [Select i.Site__c, i.Institution__c From InstitutionUser__c i where User__c =:Userinfo.getUserId() and Institution__c =:patient.Institution__c];
            system.debug('__institutionUserList__'+institutionUserList);
            if(institutionUserList.isEmpty() || institutionUserList[0].Institution__c == null || institutionUserList[0].Site__c == null) {
                errorMsg = 'This user not associate with either any institution or site.';
                isRegisterError = true;
                return null;
            }
            //pageRef = new Pagereference('/apex/RegistrationNew?CF00NE00000028FaJ='+patient.Name+'&CF00NE00000028FaJ_lkid='+patientId+'&scontrolCaching=1&retURL=%2Fapex%2FTranscendPage%3Fpid%3D'+patientId+'&sfdc.override=1');
            pageRef = new Pagereference('/apex/Registration?patientId='+patientId+'&trial='+selectedTrial);
            system.debug('__pageRef__'+pageRef);
        }
        else if(objectNameValue == 'Menopausal_Status_Detail__c') {
            pageRef = new Pagereference('/apex/MenopausalStatusDetailPage?trialPat='+trailPatList[0].Id);
            //pageRef = new Pagereference('/a0k/e?00Nc0000000GrUb='+trailPatList[0].Patient_Id__r.Age__c+'&CF00Nc0000000GqXy='+trailPatList[0].Name+'&CF00Nc0000000GqXy_lkid='+trailPatList[0].Id+'&nooverride=1&retURL=%2Fapex%2FTranscendPage%3Fid%3D'+patientId+'&00Nc0000000GxnK='+ageListvalue);
        }
        else if(objectNameValue == 'On_Study_Eligibility_Form__c') {
            //List<PreEligibility_Checklist__c> preEliList = [select Id from PreEligibility_Checklist__c where Patient__c =:patientId];
            //System.debug('__preEliList__'+preEliList);
            /*if(preEliList.isEmpty()) {
                errorMsg = 'Please first fill Pre-Eligibility Checklist for this patient.';
                isRegisterError = true;
                return null;
            }
            else {
                isRegisterError = false;
            }*/
            pageRef = new Pagereference('/apex/OnStudyEligibilityFormsNew?trialPat='+trailPatList[0].Id);
        }
        else if(objectNameValue == 'MammaPrintDetail__c') {
            String usrProfileName = [select u.Profile.Name from User u where u.id = :Userinfo.getUserId()].Profile.Name;
            system.debug('usrProfileName : '+usrProfileName);
            if(usrProfileName == 'Site User') {
                errorMsg = 'The Site User don\'t have permission to access MammaPrint Form.';
                isRegisterError = true;
                return null;
            } else {
                pageRef = new Pagereference('/apex/MammaPrintNewPage?trialPat='+trailPatList[0].Id);
            }
        }
        else if(objectNameValue == 'Randomization_Form__c') {
            /*String usrProfileName = [select u.Profile.Name from User u where u.id = :Userinfo.getUserId()].Profile.Name;
            system.debug('usrProfileName : '+usrProfileName);
            if(usrProfileName == 'Site User') {
                errorMsg = 'The Site User don\'t have permission to access Randomization Form.';
                isRegisterError = true;
                return null;
            } else {
             pageRef = new Pagereference('/apex/randomizationform?trialPat='+trailPatList[0].Id);
            }*/
            /*if(CRFStatusUtility.isRandomizationCRFSubmitted(trailPatList[0].Id)) {
                errorMsg = 'You can\'t submit Randomization CRF because It\'s already submitted by someone.';
                isRegisterError = true;
                return null;
            } else {
            
                pageRef = new Pagereference('/apex/randomizationform?trialPat='+trailPatList[0].Id);
            }
            */
            system.debug('trailPatList:'+trailPatList);
            if(useOldRandomizationCode) {
                pageRef = new Pagereference('/apex/RandomizationFormOld?trialPat='+trailPatList[0].Id);
            } else {
                pageRef = new Pagereference('/apex/RandomizationForm?trialPat='+trailPatList[0].Id);
            }
        }
        else if(objectNameValue == 'ProtocolViolationDetail__c') {
            pageRef = new Pagereference('/apex/ProtocolViolationForm?trialPat='+trailPatList[0].Id+'&phaseName='+phaseName);
        }
        else if(objectNameValue == 'MRI_Volume__c') {
            //pageRef = new Pagereference('/a0m/e?CF00Nc0000000Gtpv='+trailPatList[0].Name+'&CF00Nc0000000Gtpv_lkid='+trailPatList[0].Id+'&retURL=%2Fapex%2FTranscendPage%3Fid%3D'+patientId);
            pageRef = new Pagereference('/apex/MRIVolume?trialPat='+trailPatList[0].Id);
        } 
        else if(objectNameValue == 'On_Study_Pathology_Form__c') {
            pageRef = new Pagereference('/apex/OnStudyPathology?formName=OnStudy Pathology&trialPat='+trailPatList[0].Id);
        } 
        else if(objectNameValue == 'Post_Surgaory_Summary__c') {
            if(objectIdValue!=null && objectIdValue!='') {
                //recordIdParam = '&postid='+objectIdValue;
                pageRef = new Pagereference('/'+objectIdValue);
                system.debug('__recordIdParam__'+recordIdParam);
            } else {
                pageRef = new Pagereference('/apex/PostSurgerySummary?formName=Post Surgery Summary Form&trialPat='+trailPatList[0].Id+recordIdParam);
            }
        } else if(objectNameValue == 'AE_Detail__c') {
            /*List<Randomization_Form__c> lstRand = [select Id from Randomization_Form__c where TrialPatient__c =:trailPatList[0].Id and Status__c='Approval Not Required'];
            if(lstRand.isEmpty()) {
                errorMsg = 'Please first submit Randomization form.';
                isRegisterError = true;
                return null;
            }*/
            List<AE_Detail__c> lstAE = [select Id, Status__c from AE_Detail__c where TrialPatient__c =:trailPatList[0].Id];
            for(AE_Detail__c ae : lstAE) {
               if(ae.Status__c != 'Accepted' && ae.Status__c != 'Rejected') {
                    errorMsg = 'You have an unapproved adverse event form.';
                    isRegisterError = true;
                    return null;
                }
            }
            pageRef = new Pagereference('/apex/AdverseEvent?trialPat='+trailPatList[0].Id);
        }else if(objectNameValue == 'Response_Evaluation_Form__c') {
            pageRef = new Pagereference('/apex/ResponseEvaluationForm?trialPat='+trailPatList[0].Id+'&phaseName='+phaseName);
        } else if(objectNameValue == 'BloodSpecimenForm__c') {
            pageRef = new Pagereference('/apex/BloodSpecimenForm?trialPat='+trailPatList[0].Id);
        } else if(objectNameValue == 'Lab_and_Test__c'){
            pageRef = new Pagereference('/apex/LabAndTestDetails?trialPat='+trailPatList[0].Id);
        } else if(objectNameValue == 'Off_Study_Detail__c'){
            pageRef = new Pagereference('/apex/OffStudy?trialPat='+trailPatList[0].Id+'&phaseName='+phaseName);
        } else if(objectNameValue == 'Followup_Form__c'){
            pageRef = new Pagereference('/apex/FollowupForm?trialPat='+trailPatList[0].Id);
        } else if(objectNameValue == 'Lost_to_Follow_Up__c'){
            pageRef = new Pagereference('/apex/LosttoFollowupForm?trialPat='+trailPatList[0].Id);
        } else if(objectNameValue == 'No_Longer_lost_to_Followup__c'){
            pageRef = new Pagereference('/apex/NolongerLosttoFollowupForm?trialPat='+trailPatList[0].Id);
        } 
        
        return pageRef;
    }
    
    public Pagereference redirectPage() {
    
        String pageStr = Apexpages.currentPage().getParameters().get('paramAtt');
        String rId = Apexpages.currentPage().getParameters().get('objectId');
        String objectName = Apexpages.currentPage().getParameters().get('objectName');
        String createdTypeValue = Apexpages.currentPage().getParameters().get('createdType');
        String phaseName = Apexpages.currentPage().getParameters().get('phaseName');
        system.debug('__createdTypeValue__'+createdTypeValue);
        system.debug('__rId__'+rId);
        system.debug('__pageStr__'+pageStr);
        system.debug('__objectName__'+objectName);
        
        List<TrialPatient__c> lstTrailPat = [select Id from TrialPatient__c where Trial_Id__c =: selectedTrial and Patient_Id__c =:patientId];
        if(pageStr!=null && pageStr!='') {
            if(pageStr=='signSubmit') {
                pageRef = new Pagereference('/apex/SignAndSubmitPage?id='+patientId+'&form_code=00006&retURL=%2Fapex%2FTranscendPage%3Fid%3D'+patientId);
                pageRef.setRedirect(true);
            }
            else if(pageStr=='delete') {
                delete [select Id from Patient_Custom__c where Id =:patientId];
                //pageRef = new Pagereference('/apex/PatientList?sfdc.tabName=01rc00000000BfS');
                pageRef = new Pagereference('/apex/patientsViewTab');
                pageRef.setRedirect(true);
            }
            else if(pageStr=='edit') {
                pageRef = new Pagereference('/apex/PatientAdd?pid='+patientId);
                pageRef.setRedirect(true);
            }
            /*else if(pageStr=='complete') {
                pageRef = new Pagereference('/apex/ChangeAdhocToLive?rid='+patientId+'&type=submit&retURL=%2Fapex%2FTranscendPage%3Fid%3D'+patientId);
                pageRef.setRedirect(true);
            }*/
            else if(pageStr=='detail') {
                if(createdTypeValue == 'pickList') {
                    for(Phase_CRFs__c phaseCrfObj : lstPhase) {
                        for(Phase_Master__c phaseMasterObj : lstPhaseMaster) {
                            if(phaseMasterObj.Name == 'Screening') {
                                for(wrapScreen wrapScreenObj : screenWrapList) {
                                    if(wrapScreenObj.selectedCrfCreatedDate != null && wrapScreenObj.selectedCrfCreatedDate != '') {
                                        /*if(objectName == 'MRI_Volume__c'){
                                            //pageRef = new Pagereference('/apex/MRIVolume?trialPat='+lstTrailPat[0].Id+'&mriId='+wrapScreenObj.selectedCrfCreatedDate);
                                            pageRef = new Pagereference('/'+rId);
                                        } else if(objectName == 'TissueSpecimenDetail__c'){
                                            //pageRef = new Pagereference('/apex/TissueSpecimenForm?trialPat='+lstTrailPat[0].Id+'&tsId='+wrapScreenObj.selectedCrfCreatedDate);
                                            pageRef = new Pagereference('/'+rId);
                                        } else if(objectName == 'BloodSpecimenForm__c'){
                                            //pageRef = new Pagereference('/apex/BloodSpecimenForm?trialPat='+lstTrailPat[0].Id+'&bloodSpecimenId='+wrapScreenObj.selectedCrfCreatedDate);
                                            pageRef = new Pagereference('/'+rId);
                                        } else {*/
                                            pageRef = new Pagereference('/'+wrapScreenObj.selectedCrfCreatedDate);
                                            system.debug('__wrapScreenObj.selectedCrfCreatedDate__'+wrapScreenObj.selectedCrfCreatedDate);
                                        //}
                                    }
                                }
                            } else if(phaseMasterObj.Name == 'Treatment') {
                                for(wrapTreatment wrapTreatmentObj : treatmentWrapList) {
                                    if(wrapTreatmentObj.selectedCrfCreatedDate != null && wrapTreatmentObj.selectedCrfCreatedDate != '') {
                                        if(objectName == 'Off_Study_Detail__c') {
                                            Off_Study_Detail__c offStudy = [select TrialPatient__c from Off_Study_Detail__c where Id =:rId];
                                            pageRef = new Pagereference('/apex/OffStudy?trialPat='+lstTrailPat[0].Id+'&offStudyId='+wrapTreatmentObj.selectedCrfCreatedDate);
                                          //  pageRef = new Pagereference('/'+rId);
                                        } /*else if(objectName == 'Post_Surgaory_Summary__c'){
                                            //pageRef = new Pagereference('/apex/PostSurgerySummary?formName=Post Surgery Summary Form&trialPat='+lstTrailPat[0].Id+'&postid='+wrapTreatmentObj.selectedCrfCreatedDate);
                                            pageRef = new Pagereference('/'+rId);
                                        } else if(objectName == 'Chemo_Summary_Form__c'){
                                            //pageRef = new Pagereference('/apex/ChemoSummaryForm?trialPat='+lstTrailPat[0].Id+'&formId='+wrapTreatmentObj.selectedCrfCreatedDate);
                                            pageRef = new Pagereference('/'+rId);
                                        } else if(objectName == 'Chemo_Treatment__c'){ 
                                            //pageRef = new Pagereference('/apex/ChemoTreatmentForm?trialPat='+lstTrailPat[0].Id+'&formId='+wrapTreatmentObj.selectedCrfCreatedDate);
                                            pageRef = new Pagereference('/'+rId);
                                        } else if(objectName == 'AE_Detail__c'){
                                            //pageRef = new Pagereference('/apex/AdverseEvent?trialPat='+lstTrailPat[0].Id+'&aeid='+wrapTreatmentObj.selectedCrfCreatedDate);
                                            pageRef = new Pagereference('/'+rId);
                                        } else if(objectName == 'ProtocolViolationDetail__c'){
                                            //pageRef = new Pagereference('/apex/ProtocolViolationForm?trialPat='+lstTrailPat[0].Id+'&formId='+wrapTreatmentObj.selectedCrfCreatedDate);
                                            pageRef = new Pagereference('/'+rId);
                                        } else if(objectName == 'BaselineSymptomsForm__c'){
                                           // pageRef = new Pagereference('/apex/BaselineSymptomsForm?trialPat='+lstTrailPat[0].Id+'&baselineid='+wrapTreatmentObj.selectedCrfCreatedDate);
                                            pageRef = new Pagereference('/'+rId);
                                        } else if(objectName == 'Lab_and_Test__c'){
                                            //pageRef = new Pagereference('/apex/LabAndTestDetails?trialPat='+lstTrailPat[0].Id+'&labAndTestId='+wrapTreatmentObj.selectedCrfCreatedDate);
                                            //pageRef = new Pagereference('/'+rId);
                                            pageRef = new Pagereference('/'+wrapTreatmentObj.selectedCrfCreatedDate);
                                        } else if(objectName == 'Response_Evaluation_Form__c'){
                                            //pageRef = new Pagereference('/apex/ResponseEvaluationForm?trialPat='+lstTrailPat[0].Id+'&respEvalId='+wrapTreatmentObj.selectedCrfCreatedDate);
                                            pageRef = new Pagereference('/'+rId);
                                        }*/else { 
                                            pageRef = new Pagereference('/'+wrapTreatmentObj.selectedCrfCreatedDate);
                                            system.debug('__wrapScreenObj.selectedCrfCreatedDate__'+wrapTreatmentObj.selectedCrfCreatedDate);
                                        } 
                                    }
                                }
                            } else if(phaseMasterObj.Name == 'Follow Up') {
                                for(wrapFollow wrapFollowObj : followWrapList) {
                                    if(wrapFollowObj.selectedCrfCreatedDate != null && wrapFollowObj.selectedCrfCreatedDate != '') {
                                        /*if(objectName == 'Followup_Form__c'){
                                            //pageRef = new Pagereference('/apex/FollowupForm?fupformId='+wrapFollowObj.selectedCrfCreatedDate+'&trialPat='+lstTrailPat[0].Id);
                                            pageRef = new Pagereference('/'+rId);
                                        } else if(objectName == 'Lost_to_Follow_Up__c'){
                                            //pageRef = new Pagereference('/apex/LosttoFollowupForm?ltfupformId='+wrapFollowObj.selectedCrfCreatedDate+'&trialPat='+lstTrailPat[0].Id);
                                            pageRef = new Pagereference('/'+rId);
                                        } else if(objectName == 'No_Longer_lost_to_Followup__c'){
                                            //pageRef = new Pagereference('/apex/NolongerLosttoFollowupForm?NLLTFupFormId='+wrapFollowObj.selectedCrfCreatedDate+'&trialPat='+lstTrailPat[0].Id);
                                            pageRef = new Pagereference('/'+rId);
                                        } else*/ if(objectName == 'Off_Study_Detail__c') {
                                            pageRef = new Pagereference('/apex/OffStudy?trialPat='+lstTrailPat[0].Id+'&offStudyId='+wrapFollowObj.selectedCrfCreatedDate+'&phaseName='+phaseName);
                                          //  pageRef = new Pagereference('/'+rId);
                                        } else {
                                            pageRef = new Pagereference('/'+wrapFollowObj.selectedCrfCreatedDate);
                                            system.debug('__wrapScreenObj.selectedCrfCreatedDate__'+wrapFollowObj.selectedCrfCreatedDate);
                                        }
                                    }
                                }
                            }
                        }
                    }
                    if(pageRef != null) {
                        pageRef.setRedirect(true);
                    }
                } else {
                    if(objectName == 'PreEligibility_Checklist__c'){
                        //pageRef = new Pagereference('/apex/PreEligibilityChecklist?PatientId='+patientId+'&preEligibilityId='+rId+'&trialId='+selectedTrial);
                        pageRef = new Pagereference('/'+rId);
                    } else if(objectName == 'Registration__c'){
                        //pageRef = new Pagereference('/apex/Registration?patientId='+patientId+'&trial='+selectedTrial);
                        pageRef = new Pagereference('/'+rId);
                    } else if(objectName == 'On_Study_Pathology_Form__c'){
                       // pageRef = new Pagereference('/apex/OnStudyPathology?trialPat='+lstTrailPat[0].Id+'&formName=OnStudy+Pathology&PathologyId='+rId);
                         pageRef = new Pagereference('/'+rId);
                    } else if(objectName == 'Menopausal_Status_Detail__c'){
                        //pageRef = new Pagereference('/apex/MenopausalStatusDetailPage?trialPat='+lstTrailPat[0].Id+'&menopausalId='+rId);
                        pageRef = new Pagereference('/'+rId);
                    } /*else if(objectName == 'MRI_Volume__c'){
                        pageRef = new Pagereference('/apex/MRIVolume?trialPat='+lstTrailPat[0].Id);
                    }*/ else if(objectName == 'On_Study_Eligibility_Form__c'){
                        //pageRef = new Pagereference('/apex/OnStudyEligibilityFormsNew?trialPat='+lstTrailPat[0].Id+'&onStudyEleId='+rId);
                        pageRef = new Pagereference('/'+rId);
                    } else if(objectName == 'ProtocolViolationDetail__c'){
                        //pageRef = new Pagereference('/apex/ProtocolViolationForm?trialPat='+lstTrailPat[0].Id+'&formId='+rId);
                        pageRef = new Pagereference('/'+rId);
                    } /*else if(objectName == 'TissueSpecimenDetail__c'){ 
                        pageRef = new Pagereference('/apex/TissueSpecimenForm?trialPat='+lstTrailPat[0].Id);
                    }*/ else if(objectName == 'Response_Evaluation_Form__c'){
                        //pageRef = new Pagereference('/apex/ResponseEvaluationForm?trialPat='+lstTrailPat[0].Id+'&respEvalId='+rId);
                        pageRef = new Pagereference('/'+rId);
                    } /*else if(objectName == 'BloodSpecimenForm__c'){
                        pageRef = new Pagereference('/apex/BloodSpecimenForm?trialPat='+lstTrailPat[0].Id+'&id='+rId);
                    }*/else if(objectName == 'MammaPrintDetail__c'){
                        //pageRef = new Pagereference('/apex/MammaPrintNewPage?trialPat='+lstTrailPat[0].Id+'&formId='+rId);
                        pageRef = new Pagereference('/'+rId);
                    } else if(objectName == 'Randomization_Form__c'){
                        system.debug('lstTrailPat:'+lstTrailPat);
                        if(useOldRandomizationCode) {
                            pageRef = new Pagereference('/apex/RandomizationFormOld?trialPat='+lstTrailPat[0].Id+'&formId='+rId);
                        } else {
                            pageRef = new Pagereference('/apex/RandomizationForm?trialPat='+lstTrailPat[0].Id+'&formId='+rId);
                        }
                        //pageRef = new Pagereference('/apex/randomizationform?trialPat='+lstTrailPat[0].Id+'&formId='+rId);
                        //pageRef = new Pagereference('/'+rId);
                    } else {
                        pageRef = new Pagereference('/'+rId);
                    }
                    if(pageRef != null) {
                        pageRef.setRedirect(true);                  
                    }
                }
            }
        }
         return pageRef;
    }
    
    public Pagereference redirectTaskCRF() {
        String rId = Apexpages.currentPage().getParameters().get('objectId');
        String objectName = Apexpages.currentPage().getParameters().get('objectName');
        system.debug('__rId__'+rId);
        system.debug('__objectName__'+objectName);
        
        List<TrialPatient__c> lstTrailPat = [select Id from TrialPatient__c where Trial_Id__c =: selectedTrial and Patient_Id__c =:patientId];
        if(objectName == 'MRI_Volume__c'){
            pageRef = new Pagereference('/apex/MRIVolume?trialPat='+lstTrailPat[0].Id+'&mriId='+rId);
        } else if(objectName == 'TissueSpecimenDetail__c'){
            pageRef = new Pagereference('/apex/TissueSpecimenForm?trialPat='+lstTrailPat[0].Id+'&tsId='+rId);
        } else if(objectName == 'BloodSpecimenForm__c'){
            pageRef = new Pagereference('/apex/BloodSpecimenForm?trialPat='+lstTrailPat[0].Id+'&bloodSpecimenId='+rId);
        } else if(objectName == 'Off_Study_Detail__c') {
            pageRef = new Pagereference('/apex/OffStudy?trialPat='+lstTrailPat[0].Id+'&offStudyId='+rId);
        } else if(objectName == 'Post_Surgaory_Summary__c'){
            pageRef = new Pagereference('/apex/PostSurgerySummary?formName=Post Surgery Summary Form&trialPat='+lstTrailPat[0].Id+'&postid='+rId);
        } else if(objectName == 'Chemo_Summary_Form__c'){
            pageRef = new Pagereference('/apex/ChemoSummaryForm?trialPat='+lstTrailPat[0].Id+'&formId='+rId);
        } else if(objectName == 'Chemo_Treatment__c'){ 
            pageRef = new Pagereference('/apex/ChemoTreatmentForm?trialPat='+lstTrailPat[0].Id+'&formId='+rId);
        } else if(objectName == 'AE_Detail__c'){
            pageRef = new Pagereference('/apex/AdverseEvent?trialPat='+lstTrailPat[0].Id+'&aeid='+rId);
        } else if(objectName == 'ProtocolViolationDetail__c'){
            pageRef = new Pagereference('/apex/ProtocolViolationForm?trialPat='+lstTrailPat[0].Id+'&formId='+rId);
        } else if(objectName == 'BaselineSymptomsForm__c'){
            pageRef = new Pagereference('/apex/BaselineSymptomsForm?trialPat='+lstTrailPat[0].Id+'&baselineid='+rId);
        } else if(objectName == 'Lab_and_Test__c'){
            pageRef = new Pagereference('/apex/LabAndTestDetails?trialPat='+lstTrailPat[0].Id+'&labAndTestId='+rId);
        } else if(objectName == 'Followup_Form__c'){
            pageRef = new Pagereference('/apex/FollowupForm?fupformId='+rId+'&trialPat='+lstTrailPat[0].Id);
        } else if(objectName == 'Lost_to_Follow_Up__c'){
            pageRef = new Pagereference('/apex/LosttoFollowupForm?ltfupformId='+rId+'&trialPat='+lstTrailPat[0].Id);
        } else if(objectName == 'No_Longer_lost_to_Followup__c'){
            pageRef = new Pagereference('/apex/NolongerLosttoFollowupForm?NLLTFupFormId='+rId+'&trialPat='+lstTrailPat[0].Id);
        } else if(objectName == 'Off_Study_Detail__c') {
            pageRef = new Pagereference('/apex/OffStudy?trialPat='+lstTrailPat[0].Id+'&offStudyId='+rId);
        } else if(objectName == 'PreEligibility_Checklist__c'){
            pageRef = new Pagereference('/apex/PreEligibilityChecklist?PatientId='+patientId+'&preEligibilityId='+rId+'&trialId='+selectedTrial);
        } else if(objectName == 'Registration__c'){
            pageRef = new Pagereference('/apex/Registration?patientId='+patientId+'&trial='+selectedTrial);
        } else if(objectName == 'On_Study_Pathology_Form__c'){
            pageRef = new Pagereference('/apex/OnStudyPathology?trialPat='+lstTrailPat[0].Id+'&formName=OnStudy+Pathology&PathologyId='+rId);
        } else if(objectName == 'Menopausal_Status_Detail__c'){
            pageRef = new Pagereference('/apex/MenopausalStatusDetailPage?trialPat='+lstTrailPat[0].Id+'&menopausalId='+rId);
        } else if(objectName == 'On_Study_Eligibility_Form__c'){
            pageRef = new Pagereference('/apex/OnStudyEligibilityFormsNew?trialPat='+lstTrailPat[0].Id+'&onStudyEleId='+rId);
        } else if(objectName == 'ProtocolViolationDetail__c'){
            pageRef = new Pagereference('/apex/ProtocolViolationForm?trialPat='+lstTrailPat[0].Id+'&formId='+rId);
        } else if(objectName == 'Response_Evaluation_Form__c'){
            pageRef = new Pagereference('/apex/ResponseEvaluationForm?trialPat='+lstTrailPat[0].Id+'&respEvalId='+rId);
        } else if(objectName == 'MammaPrintDetail__c'){
            pageRef = new Pagereference('/apex/MammaPrintNewPage?trialPat='+lstTrailPat[0].Id);
        } else if(objectName == 'Randomization_Form__c'){
            pageRef = new Pagereference('/apex/randomizationform?trialPat='+lstTrailPat[0].Id);
        }
        if(pageRef != null) {
            pageRef.setRedirect(true);                  
        }
         return pageRef;
    }
    
    public void completeTask() {
        
    }
    
    /*public void changeTaskStatus() {
        if(selectedTaskOption == 'Pending') {
            lstTask = [select ActivityDate, CRF_Form_Id__c, Subject, Type, Schedule_Event_Date__c, WhatId, Status from Task where WhatId =:patientId and Trial_Id__c =:selectedTrial and Status != 'Completed' and Trial_Id__c =:selectedTrial order by ActivityDate];
        } else if(selectedTaskOption == 'All') {
            lstTask = [select ActivityDate, CRF_Form_Id__c, Subject, Type, WhatId, Status, Schedule_Event_Date__c,Trial_Id__c from Task where Trial_Id__c =:selectedTrial and WhatId =:patientId and Trial_Id__c =:selectedTrial order by ActivityDate];
        } else if(selectedTaskOption == 'Completed') {
            lstTask = [select ActivityDate, CRF_Form_Id__c, Subject, Type, WhatId, Status, Schedule_Event_Date__c, Trial_Id__c from Task where Trial_Id__c =:selectedTrial and WhatId =:patientId and Status = 'Completed' and Trial_Id__c =:selectedTrial order by ActivityDate];
        }
    }*/
    
//Create cancel function. Occur when user cancel schedule event form. It is required for reset form. With javascript we can't do this efficiantly
    public Pagereference cancelCreateEvent() {
        pageRef = new Pagereference('/apex/TranscendPage?id='+patientId+'&TrialId='+selectedTrial);
        pageRef.setRedirect(true);
        return pageRef;
    }
    
    public class wrapScreen {
        public String screenForm{get;set;}
        public String formObjectName{get;set;}
        public String status {get;set;}
        public String TrialPatId{get;set;}
        public String nextDueOn{get;set;}
        public String CreatedDate{get;set;}
        public String rId{get;set;}
        public String selectedCrfCreatedDate{get;set;}
        public String nextDueColumnColor{get;set;}
        public Boolean isTaskCreated{get;set;}
        public Boolean isShowColumn{get;set;}
        public Boolean isInserted{get;set;}
        public Date CompletedDate{get;set;}
        public List<SelectOption> crfCreatedDateOption{get;set;}
        public wrapScreen() {
            crfCreatedDateOption = new List<SelectOption>();
        }
    }
    
    public class wrapTreatment {
        public String treatmentForm{get;set;}
        public String formObjectName{get;set;}
        public String status {get;set;}
        public String TrialPatId{get;set;}
        public String nextDueOn{get;set;}
        public String nextDueColumnColor{get;set;}
        public Boolean isTaskCreated{get;set;}
        public Boolean isShowColumn{get;set;}
        public Boolean isInserted{get;set;}
        public String CreatedDate{get;set;}
        public Date CompletedDate{get;set;}
        public String rId{get;set;}
        public List<SelectOption> crfCreatedDateOption{get;set;}
        public String selectedCrfCreatedDate{get;set;}
        
        public wrapTreatment() {
            crfCreatedDateOption = new List<SelectOption>();
        }
    }
    
    public class wrapFollow {
        public String followForm{get;set;}
        public String formObjectName{get;set;}
        public String TrialPatId{get;set;}
        public String status {get;set;}
        public String nextDueOn{get;set;}
        public String nextDueColumnColor{get;set;}
        public Boolean isTaskCreated{get;set;}
        public Boolean isShowColumn{get;set;}
        public Boolean isInserted{get;set;}
        public Date CompletedDate{get;set;}
        public String CreatedDate{get;set;}
        public String rId{get;set;}
        public List<SelectOption> crfCreatedDateOption{get;set;}
        public String selectedCrfCreatedDate{get;set;}
        
        public wrapFollow() {
            crfCreatedDateOption = new List<SelectOption>();
        }
    }
}