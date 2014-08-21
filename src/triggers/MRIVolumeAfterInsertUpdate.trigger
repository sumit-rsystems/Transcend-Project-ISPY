trigger MRIVolumeAfterInsertUpdate on MRI_Volume__c (after insert, after update) {
    if(Trigger.isInsert) {
        Set<Id> newCreatedCrfIds = new Set<Id>();
        for(MRI_Volume__c mri : Trigger.new){
            if(mri.Status__c == 'Not Completed' && mri.OriginalCRF__c == null) {
                newCreatedCrfIds.add(mri.Id);
            }
        }
        if(!newCreatedCrfIds.isEmpty()) {
            /*commented to get characters for other coding
            TaskManager.updateTaskStatusToInProgress('MRI_Volume__c', newCreatedCrfIds);
            */
        }
    }
    if(Trigger.isUpdate){
        set<Id> crfIds = new set<Id>();
        set<Id> mriIds = new set<Id>();
        set<Id> approvalPendingMriIds = new set<Id>();
        set<Id> originalIds = new set<Id>();
        Set<Id> trialPatientsForMRI1 = new Set<Id>();
        Set<Id> trialPatientsForMRI2 = new Set<Id>();
        Set<Id> trialPatientsForMRI3 = new Set<Id>();
        for(MRI_Volume__c mri : Trigger.new){
            if(mri.Status__c == 'Approval Pending' && Trigger.oldMap.get(mri.Id).Status__c != 'Approval Pending') {
                if(mri.OriginalCRF__c != null) {
                    originalIds.add(mri.OriginalCRF__c);
                } else {
                    approvalPendingMriIds.add(mri.Id);
                }
            }
            
            if(mri.Status__c != 'Accepted') continue;
            crfIds.add(mri.CRF__c);
            mriIds.add(mri.Id);
            if(mri.Time_Point__c == 'Early Treatment') {
                trialPatientsForMRI1.add(mri.TrialPatient__c);
            } else if(mri.Time_Point__c == 'Inter-Regimen') {
                trialPatientsForMRI2.add(mri.TrialPatient__c);
            } else if(mri.Time_Point__c == 'Pre-Surgery') {
                trialPatientsForMRI3.add(mri.TrialPatient__c);
            }
        }
        List<Snomed_Code__c> lstSnomed = [select id,CRF__c,Name from Snomed_Code__c where CRF__c IN : crfIds];
        if(!lstSnomed.isEmpty()) {
            //first delete existing snomed codes
            delete lstSnomed;
        }
        //Now insert them again
        if(!mriIds.isEmpty()) {
            SnomedCTCode.insertSnomedCodesForMRI(mriIds);
        }
        /*commented to get characters for other coding
        if(!approvalPendingMriIds.isEmpty()) {
            TaskManager.updateTask(approvalPendingMriIds, 'MRI_Volume__c');
        }
        
        if(!originalIds.isEmpty()) {
            TaskManager.completeTaskOfRejectedCRF(originalIds);
        }
        */
        
        if(!Test.isRunningTest() && !trialPatientsForMRI1.isEmpty()) {
        	for(MRI_Volume__c currentValue : trigger.new){
        		for(MRI_Volume__c previousValue : trigger.old){
        			if (currentValue.MRI_Volume_in_cm3__c != previousValue.MRI_Volume_in_cm3__c){
        				RandomizationXMLBuilder.updatePatientXMLForMRI1(trialPatientsForMRI1);
        			}
        		}
        	}
        }
        
        if(!Test.isRunningTest() && !trialPatientsForMRI2.isEmpty()) {
        	for(MRI_Volume__c currentValue : trigger.new){
        		for(MRI_Volume__c previousValue : trigger.old){
        			if (currentValue.MRI_Volume_in_cm3__c != previousValue.MRI_Volume_in_cm3__c){
            			RandomizationXMLBuilder.updatePatientXMLForMRI2(trialPatientsForMRI2);
        			}
        		}
        	}
        }
        
        if(!Test.isRunningTest() && !trialPatientsForMRI3.isEmpty()) {
        	for(MRI_Volume__c currentValue : trigger.new){
        		for(MRI_Volume__c previousValue : trigger.old){
        			if (currentValue.MRI_Volume_in_cm3__c != previousValue.MRI_Volume_in_cm3__c){
            			RandomizationXMLBuilder.updatePatientXMLForMRI3(trialPatientsForMRI3);
        			}
        		}
        	}
        }
    }
}