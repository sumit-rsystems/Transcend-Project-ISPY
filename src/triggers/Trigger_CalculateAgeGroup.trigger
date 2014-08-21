trigger Trigger_CalculateAgeGroup on Patient_Custom__c (before insert, before update) {
    for (Patient_Custom__c patient: Trigger.New) {
         
         if (patient.Age__C != null) {
             //calculate age group.      
             if(patient.Age__C < 20){
                 patient.Age_Group__c = 'under 20';
             }else if(patient.Age__C >= 20 && patient.Age__C < 30){
                 patient.Age_Group__c = '20-30';
             }else if(patient.Age__C >= 30 && patient.Age__C < 40){
                 patient.Age_Group__c = '30-40';
             }else if(patient.Age__C >= 40 && patient.Age__C < 50){
                 patient.Age_Group__c = '40-50';
             }else if(patient.Age__C >= 50 && patient.Age__C < 60){
                 patient.Age_Group__c = '50-60';
             }else if(patient.Age__C >= 60 && patient.Age__C < 70){
                 patient.Age_Group__c = '60-70';
             }else if(patient.Age__C >= 70 && patient.Age__C < 80){
                 patient.Age_Group__c = '70-80';
             }else if(patient.Age__C >= 80 && patient.Age__C <= 90){
                 patient.Age_Group__c = '80-90';
             }else if(patient.Age__C > 90){
                patient.Age_Group__c = 'over 90';
             }
         }
    }
}