trigger ChemoTreatmentBeforeTrigger on Chemo_Treatment__c (before insert, before update) {
    
    if(Trigger.isInsert){
        List<Chemo_Treatment__c> lstCSF = Trigger.new;
        List<CRF__c> lstCRF = new List<CRF__c>();
        Set<Id> ids = new Set<Id>();
        for(Chemo_Treatment__c csf : lstCSF){
            ids.add(csf.TrialPatient__c);
            if(csf.Status__c == null) {
                csf.Status__c = 'Not Completed'; 
            }
        }
        List<Site_Trial__c> siteTrials = [Select s.Trial__c, s.Site__c, s.Name From Site_Trial__c s];
        Map<CRF__c, String> crfGroupNameMap = new Map<CRF__c, String>();
        
        List<TrialPatient__c> lstTrialPatient = [Select t.Patient_Id__c,Trial_Id__c, Site__c From TrialPatient__c t where Id IN :ids];
        for(Chemo_Treatment__c csf : lstCSF){
            for(TrialPatient__c tp : lstTrialPatient) {
                if(tp.Id != csf.TrialPatient__c) continue;
                CRF__c crf = new CRF__c();
                //crf.Name = 'TSD';
                crf.Type__c = 'Type1'; 
                crf.Detail__c = 'Details';
                crf.Status__c = csf.Status__c;
                crf.Patient__c = tp.Patient_Id__c;
                if(!lstTrialPatient.isEmpty()){
                    crf.Trial__c = lstTrialPatient[0].Trial_Id__c;
                } 
                crf.TrialPatient__c = csf.TrialPatient__c;
                crf.Complete_Date__c = System.today();
                crf.Type__c = 'Chemo_Treatment__c';
                crf.Phase__c = 'Treatment';
                lstCRF.add(crf);
                for(Site_Trial__c st : siteTrials) {
                    if(st.Trial__c == tp.Trial_Id__c && st.Site__c == tp.Site__c) {
                        crfGroupNameMap.put(crf, st.Name);
                        break;
                    }
                }
            }
            
        }
        if(lstCRF != null && lstCRF.size() > 0) {
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
        
        for(CRF__c crf : lstCRF) {
            for(TrialPatient__c tp : lstTrialPatient) {
                for(Chemo_Treatment__c csf : lstCSF){
                    if(tp.Patient_Id__c == crf.Patient__c) {
                        csf.CRF__c = crf.Id;
                    }
                }
            }
        }
    }
    if(Trigger.isUpdate){
        set<Id> setCrfIds = new set<Id>();
        for(Chemo_Treatment__c csf : Trigger.new){
            setCrfIds.add(csf.CRF__c);
        }
        List<CRF__c> lstCrf = [select id,Status__c from CRF__c where id IN : setCrfIds];
        for(Chemo_Treatment__c csf : Trigger.new){
            for(CRF__c crf : lstCrf){
                if(crf.id == csf.CRF__c && csf.Status__c != Trigger.oldMap.get(csf.id).Status__c){
                    crf.Status__c = csf.Status__c;
                }
            }
        }
        update lstCrf;
    }
}