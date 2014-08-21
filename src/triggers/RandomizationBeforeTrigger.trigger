trigger RandomizationBeforeTrigger on Randomization_Form__c (before insert, before update) {

    //Create CRF Records
    if(Trigger.isInsert) {
        
        List<Randomization_Form__c> lstRandomization = Trigger.new;
        List<CRF__c> lstCRF = new List<CRF__c>();
        
        Set<Id> ids = new Set<Id>();
        for(Randomization_Form__c random : lstRandomization){
            ids.add(random.TrialPatient__c);
        }
        List<Site_Trial__c> siteTrials = [Select s.Trial__c, s.Site__c, s.Name From Site_Trial__c s];
		Map<CRF__c, String> crfGroupNameMap = new Map<CRF__c, String>();
	
        List<TrialPatient__c> lstTrialPatient1 = [Select Site__c, t.Patient_Id__c,Trial_Id__c From TrialPatient__c t where Id IN :ids];
        for(Randomization_Form__c random : lstRandomization){
            for(TrialPatient__c tp : lstTrialPatient1) {
                if(tp.Id != random.TrialPatient__c) continue;
                CRF__c crf = new CRF__c();
                //crf.Name = 'TSD';
                crf.Type__c = 'Type1'; 
                crf.Detail__c = 'Details';
                if(random.Status__c == null)
                    random.Status__c = 'Not Completed';
               	crf.Status__c = random.Status__c;
                crf.Patient__c = tp.Patient_Id__c;
                if(!lstTrialPatient1.isEmpty()){
                    crf.Trial__c = lstTrialPatient1[0].Trial_Id__c;
                }
                crf.TrialPatient__c = random.TrialPatient__c;
                crf.Complete_Date__c = System.today();
                crf.Type__c = 'Randomization_Form__c';
                crf.Phase__c = 'Screening';
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
			//System.debug('crfGroupNameMap.get(crf)---------'+crfGroupNameMap.get(crf));
			if(crfGroupNameMap.get(crf) != null && gNameIdMap.get(crfGroupNameMap.get(crf)) != null){
				shareRec.UserOrGroupId = gNameIdMap.get(crfGroupNameMap.get(crf));
				shareRec.AccessLevel = 'Edit';
				shareRec.ParentId =  crf.Id;
				lstCRFShare.add(shareRec);
			}
		}
		insert lstCRFShare;
		
        for(CRF__c crf : lstCRF) {
            for(TrialPatient__c tp : lstTrialPatient1) {
                for(Randomization_Form__c random : lstRandomization){
                    if(tp.Patient_Id__c == crf.Patient__c) {
                        random.CRF__c = crf.Id;
                    }
                }
            }
        }
    }
    
    /////////////////////////
    
    if(Trigger.isUpdate) {
        
        List<Randomization_Form__c> lstRandToShare = new List<Randomization_Form__c>(); 
        set<Id> setCrfIds = new set<Id>();
        for(Randomization_Form__c random : Trigger.new){
            if(!Trigger.oldMap.get(random.Id).First_Save_and_Close__c && random.First_Save_and_Close__c) {
                lstRandToShare.add(random);
                //signSubmit.signAndSubmit('00005','',random.Id+'', 'Site');
            }
            setCrfIds.add(random.CRF__c);
        }
        
        //SharingManager.shareObjectWithSite(lstRandToShare, 'Randomization_Form__c', 'Site');
        
        
        /// Comment code to update previous loaded crf with shared object -- Start
        
        List<CRF__c> lstCrf = [select id,Status__c from CRF__c where id IN : setCrfIds];
        for(Randomization_Form__c random : Trigger.new){
            for(CRF__c crf : lstCrf){
                if(crf.id == random.CRF__c && random.Status__c != Trigger.oldMap.get(random.id).Status__c){
                    crf.Status__c = random.Status__c;
                }
            }
        }
        if(!lstCrf.isEmpty()){  
            update lstCrf;
        }
        
        List<Randomization_Form__c> lstRandomizationFrom = Trigger.new;
        
        //system.debug('lstRandomizationFrom[0].Randomization_Result__c : '+lstRandomizationFrom[0].Randomization_Result__c);
        Set<Id> tpIds = new Set<Id>();
        Set<String> arms = new Set<String>();
        Set<Id> avlArmIds = new Set<Id>();
        Set<String> unAvlArms = new Set<String>();
        Map<String, String> mapArms = new Map<String, String>();
        for(Randomization_Form__c rForm : lstRandomizationFrom) {
            if(rForm.Randomization_Result__c != null && rForm.Randomization_Result__c != 'Not Randomized') {
                arms.add(rForm.Randomization_Result__c);
                tpIds.add(rForm.TrialPatient__c);
            }
        }
        List<Arm__c> lstArm = [select Id, Name from Arm__c where Name IN :arms];
        for(Arm__c arm : lstArm) {
            mapArms.put(arm.Id, arm.Name);
        }
        
        for(String armFromSet : arms) {
            boolean foundArm = false;
            for(Arm__c arm : lstArm) {
                if(arm.Name == armFromSet) {
                    avlArmIds.add(arm.Id);
                    foundArm = true;
                    break;
                }
            }
            if(!foundArm) {
                unAvlArms.add(armFromSet);
            }
        }
        system.debug('tpIds : '+tpIds);
        //system.debug('avlArmIds : '+avlArmIds);
        List<ArmPatient__c> lstArmPatient = [select Name, TrialPatient__c, assignedToPatient__c, Arm_Id__c from ArmPatient__c 
                                                where TrialPatient__c IN :tpIds and Arm_Id__c IN :avlArmIds];
        for(ArmPatient__c armPatient : lstArmPatient) {
            for(Randomization_Form__c rForm : lstRandomizationFrom) {
                if(armPatient.TrialPatient__c == rForm.TrialPatient__c && rForm.Randomization_Result__c == mapArms.get(armPatient.Arm_Id__c)) {
                    armPatient.assignedToPatient__c = true;
                }
            }
        }
        
        List<Arm__c> lstUnAvlArm = new List<Arm__c>();
        for(String unAvlArm : unAvlArms) {
            Arm__c arm1 = new Arm__c();
            arm1.Name = unAvlArm;
            lstUnAvlArm.add(arm1);
        }
        insert lstUnAvlArm;
        
        for(Arm__c unAvlArm : lstUnAvlArm) {
            for(Randomization_Form__c rf : lstRandomizationFrom) {
                if(rf.Randomization_Result__c == unAvlArm.Name) {
                    ArmPatient__c armPatient2 = new ArmPatient__c();
                    armPatient2.assignedToPatient__c = true;
                    armPatient2.Arm_Id__c = unAvlArm.Id;
                    armPatient2.TrialPatient__c = rf.TrialPatient__c;
                    lstArmPatient.add(armPatient2);
                }
            }
        }
        //system.debug('lstArmPatient : '+lstArmPatient.size());
        //In case, if Randomization result is avialable in Arm__c but related record is not available in ArmPatient__c
        List<ArmPatient__c> lstNewArmPat = new List<ArmPatient__c>();
        for(Id armId : avlArmIds) {
            for(Randomization_Form__c rf : lstRandomizationFrom) {
                if(rf.Randomization_Result__c == mapArms.get(armId)) {
                    if(rf.Randomization_Result__c == 'Not Randomized')continue;
                    if(!lstArmPatient.isEmpty()) {
                        for(ArmPatient__c armPat :  lstArmPatient) {
                            if(armPat.Arm_Id__c != armId) {
                                ArmPatient__c armPatient2 = new ArmPatient__c();
                                armPatient2.assignedToPatient__c = true;
                                armPatient2.Arm_Id__c = armId;
                                armPatient2.TrialPatient__c = rf.TrialPatient__c;
                                lstNewArmPat.add(armPatient2);
                            }
                        }
                    } else {
                        ArmPatient__c armPatient2 = new ArmPatient__c();
                        armPatient2.assignedToPatient__c = true;
                        armPatient2.Arm_Id__c = armId;
                        armPatient2.TrialPatient__c = rf.TrialPatient__c;
                        lstNewArmPat.add(armPatient2);
                    }
                }
            }
        }
        
        lstArmPatient.addAll(lstNewArmPat);
        //system.debug('lstArmPatient : '+lstArmPatient.size());
        upsert lstArmPatient;
        
        
        // Comment code to update previous loaded crf with shared object - End
    }
}