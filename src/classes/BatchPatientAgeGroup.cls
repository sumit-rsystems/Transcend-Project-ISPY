global class BatchPatientAgeGroup implements Database.Batchable<sObject>{

  String query = 'SELECT Id, Age__c, Birthdate__c, Age_Group__c From Patient_Custom__c where age__c != null';

  /************************************************************
  *  constructor
  ************************************************************/
  global BatchPatientAgeGroup () {
  }
  
  /****************************************************************
  *  start(Database.BatchableContext BC)
  *****************************************************************/
  global Database.QueryLocator start(Database.BatchableContext BC) {
    return Database.getQueryLocator(this.query);
  }
  
  /*********************************************************************
  *  execute(Database.BatchableContext BC, List scope)
  **********************************************************************/
  global void execute(Database.BatchableContext BC, List<sObject> scope) {
    
    String ageGroup = '';
    
    // loop through query results...
    
      Patient_Custom__c patient = (Patient_Custom__c) scope[0];
      
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
  
     update patient;
  }
  
  /****************************************************
  *  finish(Database.BatchableContext BC)
  *****************************************************/
  global void finish(Database.BatchableContext BC) {
  //TODO: add a record to custom log object
  }  

 
  
}