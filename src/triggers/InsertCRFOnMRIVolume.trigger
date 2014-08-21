trigger InsertCRFOnMRIVolume on MRI_Volume__c (before insert, before update) {
    
    /*if(TransactionTracker.TRANSACTION_NUM == 0) {
        TransactionTracker.TRANSACTION_NUM = 1;
    } else {
        TransactionTracker.TRANSACTION_NUM = 0;
        return;
    }*/
    //List<RecordType> recTypeAdHoc = [select id,Name from RecordType where sObjectType = 'MRI_Volume__c' and Name = 'AdHoc' ];
    Set<Id> ids = new Set<Id>();
    for(MRI_Volume__c mv : Trigger.new){
        ids.add(mv.TrialPatient__c);
    }
    
    List<TrialPatient__c> trialPatientList = [select Id, Site__c, Patient_Id__c,Trial_Id__c from TrialPatient__c where Id IN :ids];
    if(Trigger.isInsert) {
        List<Site_Trial__c> siteTrials = [Select s.Trial__c, s.Site__c, s.Name From Site_Trial__c s];
        Map<CRF__c, String> crfGroupNameMap = new Map<CRF__c, String>();
        
        List<CRF__c> lstCRF = new List<CRF__c>();
        for(MRI_Volume__c mv : Trigger.new){
            for(TrialPatient__c tmpListObj : trialPatientList) {
                if(mv.TrialPatient__c == tmpListObj.Id) {
                    CRF__c crfObj = new CRF__c();
                    //crfObj.Name = 'MRI Volume';
                    crfObj.Patient__c = tmpListObj.Patient_Id__c; 
                    crfObj.Type__c = 'MRI Volume - '+mv.Time_Point__c;
                    if(mv.Status__c != null) {
                        crfObj.Status__c = mv.Status__c;
                    } else {
                        crfObj.Status__c = 'Not Completed';
                    }
                    if(!trialPatientList.isEmpty()){
                        crfObj.Trial__c = trialPatientList[0].Trial_Id__c;
                    }
                    crfObj.TrialPatient__c = mv.TrialPatient__c;
                    crfObj.Complete_Date__c = System.today();
                    crfObj.Type__c = 'MRI_Volume__c';
                    crfObj.Phase__c = 'Screening';
                    lstCRF.add(crfObj); 
                    for(Site_Trial__c st : siteTrials) {
                        if(st.Trial__c == tmpListObj.Trial_Id__c && st.Site__c == tmpListObj.Site__c) {
                            crfGroupNameMap.put(crfObj, st.Name);
                            break;
                        }
                    }
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
        for(CRF__c crf : lstCRF){
            CRF__Share shareRec = new CRF__Share();
            System.debug('crfGroupNameMap.get(crf)---------'+crfGroupNameMap.get(crf));
            if(crfGroupNameMap.get(crf) != null && gNameIdMap.get(crfGroupNameMap.get(crf)) != null){
                shareRec.UserOrGroupId = gNameIdMap.get(crfGroupNameMap.get(crf));
                shareRec.AccessLevel = 'Edit';
                shareRec.ParentId =  crf.Id;
                lstCRFShare.add(shareRec);
            }
        }
        insert lstCRFShare;
        
        for(MRI_Volume__c mv : Trigger.new){
            for(TrialPatient__c tmpListObj : trialPatientList) {
                for(CRF__c crfObj : lstCRF){
                    if(crfObj.Patient__c == tmpListObj.Patient_Id__c){
                        if(!RequiredFieldHandler.fromDataLoader) {
                            if(mv.MRI_Scan_Date__c == null) {
                                throw new RequiredFieldException('Required field missing - Please provide Date of MRI scan.');
                            } else if(mv.Time_Point__c == null || mv.Time_Point__c == '') {
                                throw new RequiredFieldException('Required field missing - Please provide time point.');
                            } else if(mv.Longest_Diameter_Of_Index_Lesion_in_cm__c == null) {
                                throw new RequiredFieldException('Required field missing - Please provide Longest Diameter Of Index Lesion (in cm).');
                            } else if(mv.MRI_Volume_in_cm3__c == null && mv.Time_Point__c == 'Pre-Treatment') {
                                throw new RequiredFieldException('Required field missing - Please provide MRI Volume (in cm3).');
                            }
                        }
                        mv.CRF__c = crfObj.Id;
                        if(mv.Status__c == null) {
                            mv.Status__c = 'Not Completed';
                        }
                                    
                    }
                }
            }
        }
    }
    
    if(Trigger.isUpdate) {
        Set<String> trialPatients = new Set<String>();
        Set<Id> crfIds = new Set<Id>();
        for(MRI_Volume__c mv : Trigger.new){
            crfIds.add(mv.CRF__c);
            trialPatients.add(mv.TrialPatient__c);
        } 
        
        List<CRF__c> crfList = [select Id, Status__c from CRF__c where Id IN :crfIds];
        for(MRI_Volume__c mv : Trigger.new){
            for(CRF__c crf : crfList){
                system.debug('mv.Status__c'+mv.Status__c);
                if(crf.id == mv.CRF__c && mv.Status__c != Trigger.oldMap.get(mv.Id).Status__c){
                    crf.Status__c = mv.Status__c;
                }
                system.debug('crf.Status__c'+crf.Status__c);
            }
        }
        update crfList;
        
    }
    
//===============check for Time-Point=====================================
    /*List<MRI_Volume__c> mriList = [select TrialPatient__c,Time_Point__c from MRI_Volume__c where TrialPatient__c IN :ids];
    system.debug('__mriListSize__'+mriList.size());
    system.debug('__mriList__'+mriList);
    
    for(MRI_Volume__c mv : Trigger.new){
        if(mv.RecordTypeId != recTypeAdHoc[0].Id) continue;
        
        Integer earlyTreatmentFlag = 0;
        Integer InterRegimenFlag = 0;
        Integer PreSurgeryFlag = 0;
        for(MRI_Volume__c mv1 : mriList) {
            if(mv.TrialPatient__c == mv1.TrialPatient__c) {
                //if(mv1.Time_Point__c == mv.Time_Point__c) {
                //  mv.addError('You have already registered MRI Volume with '+mv.Time_Point__c+' Time Point. Please select another Time Point.');
                //  return;
                //}
                if(mv1.Time_Point__c == 'Early Treatment') {
                    earlyTreatmentFlag = 1;
                }
                if(mv1.Time_Point__c == 'Inter-Regimen') {
                    InterRegimenFlag = 1;
                }
                if(mv1.Time_Point__c == 'Pre-Surgery') {
                    PreSurgeryFlag = 1;
                }
            }
        }
        system.debug('__earlyTreatmentFlag__'+earlyTreatmentFlag);
        system.debug('__InterRegimenFlag__'+InterRegimenFlag);
        system.debug('__PreSurgeryFlag__'+PreSurgeryFlag);
            if(mriList.isEmpty() && mv.Time_Point__c!='Pre-Treatment') {
                mv.addError('Please first register MRI Volume with Pre-Treatment.');
            }
            else if(!mriList.isEmpty()) {
                if(earlyTreatmentFlag == 0 && mv.Time_Point__c!='Early Treatment') {
                        mv.addError('Please first register MRI Volume with Early Treatment.');
                        return;
                }
                else if(earlyTreatmentFlag != 0 && InterRegimenFlag == 0 && mv.Time_Point__c!='Inter-Regimen') {
                        mv.addError('Please first register MRI Volume with Inter-Regimen.');
                        return;
                }
                else if(earlyTreatmentFlag != 0 && InterRegimenFlag != 0 && PreSurgeryFlag == 0 && mv.Time_Point__c!='Pre-Surgery') {
                        mv.addError('Please first register MRI Volume with Pre-Surgery.');
                        return;
                }
            }
        }*/
        /*for(MRI_Volume__c mv : Trigger.new){
            mv.Time_Point_Snomed__c = SnomedCTCode.SnomedCode('MRI_Volume__c','Time_Point__c',mv.Time_Point__c);
            mv.MRI_Longest_Diameter_time_point_1_Snomed__c = SnomedCTCode.SnomedCode('MRI_Volume__c','Longest_Diameter_Of_Index_Lesion_in_cm__c',mv.Time_Point__c);
        }*/
}