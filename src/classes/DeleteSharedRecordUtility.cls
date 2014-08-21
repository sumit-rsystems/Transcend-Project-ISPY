public without sharing class DeleteSharedRecordUtility {

    public static void deleteToxicities(List<Toxicity__c> delToxicities) {
        delete delToxicities;
    }
    
    public static void deleteChemoTherapyRegimen(List<Chemo_Therapy_Regimen__c> delChempRegiment) {
        delete delChempRegiment;
    }
    
     public static void deleteProcedurePss(List<Procedure__c> delProcedurelist) {
        delete delProcedurelist;
    }
}