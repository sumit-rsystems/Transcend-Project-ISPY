trigger BeforeInsertUpdateOnLabAndTestForm on Lab_and_Test__c (before insert, before update) {
    
    set<Id> trialPatIds = new set<Id>();
    for(Lab_and_Test__c lat : Trigger.new){
        trialPatIds.add(lat.TrialPatient__c);
    }
    List<Site_Trial__c> siteTrials = [Select s.Trial__c, s.Site__c, s.Name From Site_Trial__c s];
    Map<CRF__c, String> crfGroupNameMap = new Map<CRF__c, String>();
        
    List<TrialPatient__c> lstTrialPat1 = [select id,Patient_Id__c,Site__c,Trial_Id__c from TrialPatient__c where Id IN : trialPatIds];
    
    if(Trigger.isInsert){
        List<CRF__c> lstCRF = new List<CRF__c>();
        for(Lab_and_Test__c lat : Trigger.new){
            for(TrialPatient__c trialPat : lstTrialPat1){
                if(lat.TrialPatient__c == trialPat.Id){
                    System.debug('----CRF------>');
                    CRF__c c = new CRF__c();
                    c.Patient__c = trialPat.Patient_Id__c;
                    if(lat.Status__c != null) {
                        c.Status__c = lat.Status__c;
                    } else {
                        c.Status__c = 'Not Completed';
                    }
                    if(!lstTrialPat1.isEmpty()){
                        c.Trial__c = lstTrialPat1[0].Trial_Id__c;
                    }
                    c.TrialPatient__c = lat.TrialPatient__c;
                    c.Complete_Date__c = System.today();
                    c.Type__c = 'Lab_and_Test__c';
                    c.Phase__c = 'Screening,Treatment';
                    lstCRF.add(c);
                    for(Site_Trial__c st : siteTrials) {
                        if(st.Trial__c == trialPat.Trial_Id__c && st.Site__c == trialPat.Site__c) {
                            crfGroupNameMap.put(c, st.Name);
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
        
        for(Lab_and_Test__c lat : Trigger.new){
            for(TrialPatient__c trialPat : lstTrialPat1){
                for(CRF__c c : lstCRF){
                    if(c.Patient__c == trialPat.Patient_Id__c){
                        lat.CRF__c = c.Id;
                    }
                }
            }
        }
    }
    if(Trigger.isUpdate){
        set<Id> setCrfIds = new set<Id>();
        for(Lab_and_Test__c lat : Trigger.new){
            setCrfIds.add(lat.CRF__c);
        }
        List<CRF__c> lstCrf = [select id,Status__c from CRF__c where id IN : setCrfIds];
        for(Lab_and_Test__c lat : Trigger.new){
            for(CRF__c crf : lstCrf){
                if(crf.Id == lat.CRF__c && lat.Status__c != Trigger.oldMap.get(lat.id).Status__c){
                    crf.Status__c = lat.Status__c;
                }
            }
        }
        if(!lstCrf.isEmpty()){
            update lstCrf;
        }
    }
}