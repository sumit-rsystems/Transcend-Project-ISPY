public class CRFHeaderController {
    
    public String patientId{get;set;}
    public String patientInitials{get;set;}
    public String patientInstitute{get;set;}
    public String shortName{get;set;}
    public CRFHeaderController() {
        
       
    }
    
    public string getPatientSubjectId() {
       String subjectId ='';
       if (patientId  != null) {
         List<Patient_Custom__c> lstPatient = [Select Initials__c, p.Institute_Text__c From Patient_Custom__c p 
         where Id = :patientId];
          if (lstPatient.size() > 0) {
           patientInitials = lstPatient[0].Initials__c;
           patientInstitute = lstPatient[0].Institute_Text__c;
           if(patientInstitute.contains( '(' )  && patientInstitute.contains( ')' ) ){
                 Integer i = patientInstitute.IndexOf( '(' );
                 Integer J = patientInstitute.IndexOf( ')' );
                 shortName = patientInstitute.subString(i+1,j);
           }      
          
          } 
            List<TrialPatient__c> trialPatList = [select Patient_Id__c, Subject_Id__c from TrialPatient__c where Patient_Id__c =:patientId];
            if(!trialPatList.isEmpty()) {
                 subjectId = trialPatList[0].Subject_Id__c;
            }
        }
        return subjectId ;
    }
}