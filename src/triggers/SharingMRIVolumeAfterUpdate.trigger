trigger SharingMRIVolumeAfterUpdate on MRI_Volume__c (after update) {
    
    List<RecordType> recTypeLive = [select id,Name from RecordType where sObjectType = 'MRI_Volume__c' and Name = 'Live' ];
    
    Set<Id> trialPatientIds = new Set<Id>(); 
    for(MRI_Volume__c mriTmp : Trigger.new) {
        trialPatientIds.add(mriTmp.TrialPatient__c);
    }
    
    List<TrialPatient__c> trialPatientLst = [select Id, Patient_Id__c, Trial_Id__c from TrialPatient__c where Id IN :trialPatientIds];
    set<Id> trialIds = new set<Id>();
    set<Id> patientIds = new set<Id>();
    for(TrialPatient__c tmpListObj : trialPatientLst) {
        trialIds.add(tmpListObj.Trial_Id__c);
        patientIds.add(tmpListObj.Patient_Id__c);
    }
    
    List<Patient_Custom__c> patientList = [select Id, Institution__c from Patient_Custom__c where Id IN :patientIds];
    Set<Id> instituteIds = new Set<Id>(); 
    for(Patient_Custom__c patientObj : patientList) {
        instituteIds.add(patientObj.Institution__c);
    }
    
    List<InstitutionUser__c> instUserList = [select Institution__c, Trial__c, Site__c from InstitutionUser__c where Institution__c IN :instituteIds and Trial__c IN :trialIds];
    Set<Id> siteIds = new Set<Id>();
    for(InstitutionUser__c tmpListObj : instUserList) {
        siteIds.add(tmpListObj.Site__c);
    } 
    List<Site_Trial__c> lstSiteTrial = [select id, Name, Site__c, Trial__c from Site_Trial__c where Trial__c IN :trialIds and Site__c IN :siteIds];
    SET<String> setGrpNames = new SET<String>();
    for(Site_Trial__c st : lstSiteTrial){
      setGrpNames.add(st.Name);
    }
    List<Group> lstSiteGrp = [select Id,Name,Type from Group where Name IN :setGrpNames and Type = 'Regular'];
    List<MRI_Volume__Share> mriShare = new List<MRI_Volume__Share>(); 
        for(MRI_Volume__c mriTmp : Trigger.new) {
            //No need to share record until it is Live
            if(mriTmp.RecordTypeId != recTypeLive[0].Id)continue;
            if(mriTmp.RecordTypeId != Trigger.oldMap.get(mriTmp.Id).RecordTypeId) {
                for(Patient_Custom__c patientObj : patientList) {
                    for(InstitutionUser__c insUser : instUserList){
                        if(patientObj.Institution__c == insUser.Institution__c) {
                            for(Site_Trial__c st : lstSiteTrial){
                                if(st.Trial__c == insUser.Trial__c && st.Site__c == insUser.Site__c) {
                                    for(Group grp : lstSiteGrp){
                                        if(grp.Name == st.Name){
                                            MRI_Volume__Share mriShareObj = new MRI_Volume__Share();
                                            mriShareObj.AccessLevel = 'Edit';
                                            mriShareObj.ParentId = mriTmp.Id;
                                            mriShareObj.UserOrGroupId = grp.Id; 
                                            mriShare.add(mriShareObj);
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                
            }
        }
        if(!mriShare.isEmpty()){
            insert mriShare;
        }
}