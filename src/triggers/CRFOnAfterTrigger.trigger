trigger CRFOnAfterTrigger on CRF__c (after insert, after update) {
    system.debug('inside the trigger');
    List<Trigger_Execute_Setting__c> tesList = [select Execute__c,Event__c from Trigger_Execute_Setting__c where Trigger_Name__c = 'CRFOnAfterTrigger' ];
    
    boolean exeAfterInsert = true;
    boolean exeAfterUpdate = true;
    
    for(Trigger_Execute_Setting__c tes : tesList) {
        if(tes.Event__c == 'After Update' && !tes.Execute__c) {
            exeAfterUpdate = false;
        } else if (tes.Event__c == 'After Insert' && !tes.Execute__c) {
            exeAfterInsert = false;
        }
    }
    
    if(!exeAfterInsert && !exeAfterUpdate)return;
    
    Set<Id> rejectedCRFIds = new Set<Id>();
    //Set<Id> approvalPendingCRFIds = new Set<Id>();
    
    if(Trigger.isUpdate && Trigger.old[0].Status__c == 'Approval Pending' && Trigger.new[0].Status__c == 'Rejected') {
        List<CRF__c> lstCRF = [Select c.Id, (Select Id, Status__c From Response_Evaluation_Forms__r), 
                            (Select Id, Status__c From Protocol_Violation_Details__r), 
                            (Select Id, Status__c From On_Study_Pathology_Forms__r), 
                            (Select Id, Status__c From On_Study_Eligibility_Forms__r), 
                            (Select Id, Status__c From Off_Study_Details__r), 
                            (Select Id, Status__c From No_Longer_lost_to_Followups__r), 
                            (Select Id, Status__c From Menopausal_Status_Details__r), 
                            (Select Id, Status__c From MRI_Volumes__r), 
                            (Select Id, Status__c From Lost_to_Follow_Ups__r), 
                            (Select Id, Status__c From Lab_and_Tests__r), 
                            (Select Id, Status__c From Followup_Forms__r), 
                            (Select Id, Status__c From Chemo_Treatments__r),
                            (Select Id, Status__c From Post_Surgery_Summaries__r),  
                            (Select Id, Status__c From Chemo_Summary_Forms__r), 
                            (Select Id, Status__c From Baseline_Symptoms_Forms__r), 
                            (Select Id, Status__c From AE_Details__r) From CRF__c c where Id = :Trigger.new[0].Id];
        String objectId = null;
        
        for(CRF__c crf : lstCRF) {
            if(crf.Response_Evaluation_Forms__r != null && !crf.Response_Evaluation_Forms__r.IsEmpty()) {
                objectId = crf.Response_Evaluation_Forms__r[0].Id;
            } else if(crf.Protocol_Violation_Details__r != null && !crf.Protocol_Violation_Details__r.IsEmpty()) {
                objectId = crf.Protocol_Violation_Details__r[0].Id;
            } else if(crf.Post_Surgery_Summaries__r != null && !crf.Post_Surgery_Summaries__r.IsEmpty()) {
                objectId = crf.Post_Surgery_Summaries__r[0].Id;
            } else if(crf.On_Study_Pathology_Forms__r != null && !crf.On_Study_Pathology_Forms__r.IsEmpty()) {
                objectId = crf.On_Study_Pathology_Forms__r[0].Id;
                
            } else if(crf.On_Study_Eligibility_Forms__r != null && !crf.On_Study_Eligibility_Forms__r.IsEmpty()) {
                objectId = crf.On_Study_Eligibility_Forms__r[0].Id;
                
            } else if(crf.Off_Study_Details__r != null && !crf.Off_Study_Details__r.IsEmpty()) {
                objectId = crf.Off_Study_Details__r[0].Id;
                
            } else if(crf.No_Longer_lost_to_Followups__r != null && !crf.No_Longer_lost_to_Followups__r.IsEmpty()) {
                objectId = crf.No_Longer_lost_to_Followups__r[0].Id;
                
            } else if(crf.Menopausal_Status_Details__r != null && !crf.Menopausal_Status_Details__r.IsEmpty()) {
                objectId = crf.Menopausal_Status_Details__r[0].Id;
                
            } else if(crf.MRI_Volumes__r != null && !crf.MRI_Volumes__r.IsEmpty()) {
                objectId = crf.MRI_Volumes__r[0].Id;
                
            } else if(crf.Lost_to_Follow_Ups__r != null && !crf.Lost_to_Follow_Ups__r.IsEmpty()) {
                objectId = crf.Lost_to_Follow_Ups__r[0].Id;
                
            } else if(crf.Lab_and_Tests__r != null && !crf.Lab_and_Tests__r.IsEmpty()) {
                objectId = crf.Lab_and_Tests__r[0].Id;
                
            } else if(crf.Followup_Forms__r != null && !crf.Followup_Forms__r.IsEmpty()) {
                objectId = crf.Followup_Forms__r[0].Id;
                
            } else if(crf.Chemo_Treatments__r != null && !crf.Chemo_Treatments__r.IsEmpty()) {
                objectId = crf.Chemo_Treatments__r[0].Id;
                
            } else if(crf.Chemo_Summary_Forms__r != null && !crf.Chemo_Summary_Forms__r.IsEmpty()) {
                objectId = crf.Chemo_Summary_Forms__r[0].Id;
                
            } else if(crf.Baseline_Symptoms_Forms__r != null && !crf.Baseline_Symptoms_Forms__r.IsEmpty()) {
                objectId = crf.Baseline_Symptoms_Forms__r[0].Id;
                
            } else if(crf.AE_Details__r != null && !crf.AE_Details__r.IsEmpty()) {
                objectId = crf.AE_Details__r[0].Id;
                
            }
        }
        
        CloneBuilder.cloneMeFutureCall(objectId, '0', '');
        //String crfId = CloneBuilder.cloneMe(objectId, '0', '');
        //CloneBuilder.cloneMe(objectId, '0', '');
        //CloneBuilder.cloneAttahmentFutureCall(objectId, crfId);
    }
    for(CRF__c crf : Trigger.new) {
       /* if(crf.Status__c == 'Rejected' && Trigger.oldMap.get(crf.Id).Status__c != 'Rejected') {
          
          rejectedCRFIds.add(crf.Id);
        }*/
        /*if(Trigger.isUpdate && crf.Status__c == 'Approval Pending' && Trigger.oldMap.get(crf.Id).Status__c == 'Completed') {
          approvalPendingCRFIds.add(crf.Id);
        }*/
    }
    if(!rejectedCRFIds.isEmpty() && Trigger.isUpdate) {
        /*commented to get characters for other coding
        TaskManager.createTaskAfterRejection(rejectedCRFIds);
        */
    }
    /*if(!approvalPendingCRFIds.isEmpty()) {
        TaskManager.completeTaskOfRejectedCRF(approvalPendingCRFIds);
    }*/
}