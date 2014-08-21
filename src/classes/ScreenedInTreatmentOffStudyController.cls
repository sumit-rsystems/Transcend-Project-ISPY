Public with sharing class ScreenedInTreatmentOffStudyController{
    public String data{get;set;}
    public ScreenedInTreatmentOffStudyController(){
        try{
            data  =   '[\'Name\',\' Number Of Patients\'],';
            List<TrialPatient__c  > screened = new List<TrialPatient__c  >();
            List<TrialPatient__c  >  inTreatment  = new List<TrialPatient__c  >();
            List<TrialPatient__c  >  offstudy = new List<TrialPatient__c  >();
            
            List<patient_Custom__c> screened1 = new  List<patient_Custom__c>() ;
            List<patient_Custom__c>  inTreatment1 = new  List<patient_Custom__c>() ;
            List<patient_Custom__c>  offstudy1 = new  List<patient_Custom__c>() ;
            
            String instituteId = ApexPages.CurrentPage().getParameters().get('institute');
            String siteId = ApexPages.CurrentPage().getParameters().get('site');
            String trialId = ApexPages.CurrentPage().getParameters().get('trial');
            
            List<Randomization_Form__c> randomizeformpatientId = [select CRF__r.patient__c,CRF__c FROM Randomization_Form__c where Randomization_Result__c != 'Not Randomized'  and CRF__c not in (SELECT CRF__c FROM Off_Study_Detail__c where Status__c = 'Accepted')];
            List<Id> patientlist = new List<Id>();
            for(Randomization_Form__c id :randomizeformpatientId ){
                patientlist.add(id.CRF__r.patient__c);
            }
            List<Id> offstudypatientlist = new List<Id>();
            List<Off_Study_Detail__c> offstudypatient = [SELECT CRF__r.Patient__c  FROM Off_Study_Detail__c where Status__c ='Accepted'];
            for(Off_Study_Detail__c id :offstudypatient){
                    offstudypatientlist.add(id.CRF__r.patient__c);
            } 
            
            if((siteId != '' && siteId != null) || (instituteId != '' && instituteId != null) || (trialId != '' && trialId != null)){    
                String condition ='';
               
                if(siteId != '' && siteId != null){
                     condition +='and Site__c IN ('+siteId+')';
                }
                screened= database.query('select Patient_Id__c   from TrialPatient__c  where Patient_Id__c in (select Patient__c from CRF__c where type__c =\'PreEligibility_Checklist__c\') and Patient_Id__c not in (SELECT Patient_Id__c FROM ArmPatient__c) '+condition);
                inTreatment = database.query('select Patient_Id__c   from TrialPatient__c  where Patient_Id__c in :patientlist '+condition);
                offstudy = database.query('select Patient_Id__c   from TrialPatient__c  where Patient_Id__c in :offstudypatientlist '+condition);
            }    
            else{  
                screened1 = [select Id   from patient_Custom__c  where id in (select Patient__c from CRF__c where type__c ='PreEligibility_Checklist__c') and id not in (SELECT Patient_Id__c FROM ArmPatient__c)];
                inTreatment1 = [select Id   from patient_Custom__c  where id in :patientlist];
                offstudy1 = [select Id   from patient_Custom__c  where id in :offstudypatientlist];
            }
            Integer intreatmentvar = 0, screenedvar = 0, offstudyvar = 0;    
            if(inTreatment.size()>0){
                intreatmentvar =  inTreatment.size();
            }
            if(inTreatment1.size()>0 && inTreatment.size() == 0)
                intreatmentvar =  inTreatment1.size();
                
            if(screened.size()>0){
                screenedvar = screened.size();
            }
            if(screened1.size()>0 && screened.size() == 0)
                screenedvar = screened1.size();    
                
            if(offstudy.size()>0){
                offstudyvar  = offstudy.size();
            }
            if(offstudy1.size()>0 && offstudy.size() == 0)
                offstudyvar  = offstudy1.size();
            
            data  += '[\'Screened\','+screenedvar +'],[\'In Treatment\','+intreatmentvar +'],[\'Off Study\','+offstudyvar+']';
               
        }
        catch(exception e){
            System.assert(false,e.getstacktracestring());
        }
            
    }
}