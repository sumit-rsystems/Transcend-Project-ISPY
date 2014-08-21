Public with sharing class ProtocolViolationsController{
    public String data{get;set;}
    Map<String,ActionWrapper> mapActionWrapper = new Map<String,ActionWrapper >();
    ActionWrapper aw = new ActionWrapper();
    public ProtocolViolationsController(){
       data = '[\'Type\',\' Patient Withdrawn\',\' Patient Remain on Study\',\' Other\'],';
       getData();
       Integer i =1;
       if(mapActionWrapper.keyset().size() == 0)
           data += '[\'No Data\',0,0,0]';    
       else{
           
           for(String type : mapActionWrapper.keyset()){
               data += '[\''+type +'\','; 
               ActionWrapper  aw = mapActionWrapper.get(type);
               data += aw.patientWithDrawn+',';
               data += aw.patientRemainOnStudy+',';
               if(i == mapActionWrapper.keyset().size())
                   data += aw.otherAction+']';
               else
                   data += aw.otherAction+'],';    
                   
               i++ ;
           }//System.assert(false,mapActionWrapper+'******'+data);
       }    
    }
    public void getData() {
        List<ProtocolViolationDetail__c> protocolv ;
        String instituteId = ApexPages.CurrentPage().getParameters().get('institute');
        String siteId = ApexPages.CurrentPage().getParameters().get('site');
        String trialId = ApexPages.CurrentPage().getParameters().get('trial');
        System.debug('****'+InstituteId+'****'+siteId+'******'+trialId);
        if((siteId != '' && siteId != null) || (instituteId != '' && instituteId != null) || (trialId != '' && trialId != null)){    
            String condition ='';
            if(instituteId != '' && instituteId != null){
                condition ='CRFId__r.Patient__r.Institution__c=\''+instituteId+'\'' ;
            }
            if(siteId != '' && siteId != null){
                 condition +='TrialPatient__r.Site__c IN ('+siteId+')';
            }
            if(trialId != '' && trialId != null){
               condition +='and CRFId__r.Trial__c=\''+trialId+'\'';
             } 
             System.debug('==========Select id, Incorrect_therapy_given_to_patient__c, Patient_withdrawn__c, Patient_Remains_on_Study__c, Other_Action_Checkbox__c, Other_Violation_Checkbox__c, Eligibility_criteria_exception__c, Enrollment_of_ineligeligibleible_patient__c, Medication_non_complicance__c, On_study_procedure_required_by_protocol__c, Patient_became_pregnant_prior_to_surgery__c, Screening_and_on_study_test_lab_done__c, Screening_procedure_required__c, Visit_non_complicance__c from ProtocolViolationDetail__c where '+condition);
          protocolv = database.query('Select id, Incorrect_therapy_given_to_patient__c, Patient_withdrawn__c, Patient_Remains_on_Study__c, Other_Action_Checkbox__c, Other_Violation_Checkbox__c, Eligibility_criteria_exception__c, Enrollment_of_ineligeligibleible_patient__c, Medication_non_complicance__c, On_study_procedure_required_by_protocol__c, Patient_became_pregnant_prior_to_surgery__c, Screening_and_on_study_test_lab_done__c, Screening_procedure_required__c, Visit_non_complicance__c from ProtocolViolationDetail__c where '+condition) ;
          
      }
      else {
          protocolv = [Select id, Incorrect_therapy_given_to_patient__c, Patient_withdrawn__c, Patient_Remains_on_Study__c, Other_Action_Checkbox__c, Other_Violation_Checkbox__c, Eligibility_criteria_exception__c, Enrollment_of_ineligeligibleible_patient__c, Medication_non_complicance__c, On_study_procedure_required_by_protocol__c, Patient_became_pregnant_prior_to_surgery__c, Screening_and_on_study_test_lab_done__c, Screening_procedure_required__c, Visit_non_complicance__c from ProtocolViolationDetail__c ];    
      }
      
       for (ProtocolViolationDetail__c pvd : protocolv ) {
            if (pvd.Incorrect_therapy_given_to_patient__c) {
                loadMap(pvd,'Incorrect therapy given to patient');         
            }
             if (pvd.Eligibility_criteria_exception__c) {
                loadMap(pvd,'Eligibility criteria exception');         
            }
           
             if (pvd.Enrollment_of_ineligeligibleible_patient__c) {
                loadMap(pvd,'Enrollment of ineligeligibleible patient');         
            }
             if (pvd.Medication_non_complicance__c) {
                loadMap(pvd,'Medication non-compliance');         
            }
             if (pvd.On_study_procedure_required_by_protocol__c) {
                loadMap(pvd,'On-study procedure required by protocol');         
            }
             if (pvd.Other_Violation_Checkbox__c) {
                loadMap(pvd,'Other Type of Violation');         
            }
             if (pvd.Patient_became_pregnant_prior_to_surgery__c) {
                loadMap(pvd,'Patient became pregnant prior to surgery');         
            }
             if (pvd.Screening_procedure_required__c) {
                loadMap(pvd,'Screening procedure required');         
            }
             if (pvd.Visit_non_complicance__c) {
                loadMap(pvd,'Visit non-complicance');         
            }
             if (pvd.Screening_and_on_study_test_lab_done__c) {
                loadMap(pvd,'Screening and on-study test/lab done');         
            }
            
        }
        
      } 
     void loadMap(ProtocolViolationDetail__c pvd, String key) {
        if (!mapActionWrapper.containskey(key)) {
             mapActionWrapper.put(key, new ActionWrapper());
             aw = new ActionWrapper(); 
         }
         else {
             aw = mapActionWrapper.get(key); 
         }
         if (pvd.Other_Action_Checkbox__c == true) {
             aw.otherAction = aw.otherAction + 1; 
         }
         if (pvd.Patient_Remains_on_Study__c== true) {
             aw.patientRemainOnStudy= aw.patientRemainOnStudy + 1;
         }
         if (pvd.Patient_withdrawn__c == true) {
             aw.patientWithDrawn = aw.patientWithDrawn + 1;
         }
         mapActionWrapper.put(key,aw);          
    }  
    public class ActionWrapper {
        
        public integer otherAction{get;set;}
        public integer patientRemainOnStudy{get;set;}
        public integer patientWithDrawn{get;set;}
        
        public ActionWrapper() {
            otherAction = 0;
            patientRemainOnStudy = 0;
            patientWithDrawn = 0;
        }
    }      
}