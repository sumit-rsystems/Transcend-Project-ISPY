public with sharing class AdverseEventReport_Refactored {
    
    public void prepareTotalAdverseEvent() {
        
        //TODO: Report has to be executed for ALL or Selected patients. This is not handled yet.
        //TODO: CTCAEv4 Term, ascending
        
        //Selecct the baseline and ae forms which are approved.
        /*
        Date endDate = Date.valueOf(Apexpages.currentPage().getParameters().get('endDate'));
        Date startDate = Date.valueOf(Apexpages.currentPage().getParameters().get('startDate'));
        
        List<BaselineSymptomsForm__c> baseLineCRFList = [Select Id, Visit_Date__c,Status__c, (select id,Resolved__c,Toxicity_Master__c,Symptom_Masters__c,
        Symptom_Masters__r.Name, Onset_Date__c,AE_End_Date__c,SAE__c,Patient_Complaint__c from Toxicities__r 
                where AE_End_Date__c >= :startDate order by Onset_Date__c asc, AE_End_Date__c asc), 
                TrialPatient__c,TrialPatient__r.Subject_Id__c from BaselineSymptomsForm__c 
                where Visit_Date__c <= :endDate and Status__c = 'Accepted' order by Visit_Date__c asc];
                
        List<AE_Detail__c> aeCRFList = [Select Id, Visit_Date__c,Status__c, 
                    (select id,Resolved__c,Toxicity_Master__c,Symptom_Masters__c,Symptom_Masters__r.Name,Onset_Date__c,AE_End_Date__c,SAE__c, 
                    Patient_Complaint__c from Toxicities__r where (Onset_Date__c <= :endDate OR (AE_End_Date__c = null OR AE_End_Date__c >= :startDate)) 
                    order by Onset_Date__c asc, AE_End_Date__c asc), 
                    TrialPatient__c,TrialPatient__r.Subject_Id__c from AE_Detail__c where Status__c = 'Accepted' order by Visit_Date__c asc];
        
        //Collect trial patient ids for these baseline and ae forms
        Set<Id> trialPatientIds = new Set<Id>();
        for(BaselineSymptomsForm__c bsf : baseLineCRFList) {
            trialPatientIds.add(bsf.TrialPatient__c);
        }
        for(AE_Detail__c ae : aeCRFList) {
            trialPatientIds.add(ae.TrialPatient__c);
        }
        
        List<ArmPatient__c> armPatient = [Select a.TrialPatient__r.Resolved_AEs__c, a.TrialPatient__r.Unresolved_AEs__c, 
                    a.TrialPatient__r.Total_AEs__c, a.TrialPatient__r.Possible_SAEs__c, a.TrialPatient__r.Subject_Id__c, a.TrialPatient__c, 
                    a.Arm_Id__r.Name, a.Arm_Id__c From ArmPatient__c a where Id IN :trialPatientIds order by Arm_Id__r.Name asc];
        List<SummaryWrapper> lstSummaryWrapper = new List<SummaryWrapper>();
        Set<String> arms = new Set<String>();
        integer totalAEsForArm = 0;
        integer possibleSAEsForArm = 0;
        integer resolvedAEsForArm = 0;
        integer unresolvedAEsForArm = 0;
        SummaryWrapper tempSW = null;
        for(ArmPatient__c ap : armPatient) {
            SummaryWrapper sw = new SummaryWrapper();
            if(!arms.contains(ap.Arm_Id__r.Name)) {
                if(tempSW == null) tempSW = sw;
                arms.add(ap.Arm_Id__r.Name);
                
                sw.armOrSubject = ap.Arm_Id__r.Name;
                tempSW.totalAEs = totalAEsForArm;
                tempSW.possibleSAEs = possibleSAEsForArm;
                tempSW.resolvedAEs = resolvedAEsForArm; 
                tempSW.unresolvedAEs = unresolvedAEsForArm;
                
                tempSW = null;
                totalAEsForArm = 0;
                possibleSAEsForArm = 0;
                resolvedAEsForArm = 0;
                unresolvedAEsForArm = 0;
                
            } else {
                sw.armOrSubject = ap.TrialPatient__r.Subject_Id__c;
                sw.totalAEs = ap.TrialPatient__r.Total_AEs__c;
                sw.possibleSAEs = ap.TrialPatient__r.Possible_SAEs__c;
                sw.resolvedAEs = ap.TrialPatient__r.Resolved_AEs__c;
                sw.unresolvedAEs = ap.TrialPatient__r.Unresolved_AEs__c;
                
                totalAEsForArm += sw.totalAEs;
                possibleSAEsForArm += sw.possibleSAEs;
                resolvedAEsForArm += sw.resolvedAEs;
                unresolvedAEsForArm += sw.unresolvedAEs;
                
            }
            
            lstSummaryWrapper.add(sw);
        }*/
    }
    
    public class SummaryWrapper {
        public String armOrSubject {get;set;}
        public integer totalAEs {get;set;}
        public integer possibleSAEs {get;set;}
        public integer unresolvedAEs {get;set;}
        public integer resolvedAEs {get;set;}
        public boolean isArm {get;set;}
        public String rowColor {get;set;}
        
        public SummaryWrapper() {
            totalAEs = 0;
            possibleSAEs  = 0;
            unresolvedAEs = 0;
            resolvedAEs = 0;
            isArm = false;
        }
    }
}