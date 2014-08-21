Public with sharing class ScreenedInTreatmentOffStudyDrillDown{
    public String data{get;set;}
    public ScreenedInTreatmentOffStudyDrillDown(){
            //data  =   '[\'ARM\',\' Created Date\',\' Active/Inactive\',\' Subject IDs\'],';
            data  =   '[\'ARM\',\' Created Date\',\' Subject IDs\'],';
            List<TrialPatient__c  > screened = new List<TrialPatient__c  >();
            List<TrialPatient__c  >  inTreatment  = new List<TrialPatient__c  >();
            List<TrialPatient__c  >  offstudy = new List<TrialPatient__c  >();
            List<patient_Custom__c> screened1 = new  List<patient_Custom__c>() ;
            List<patient_Custom__c>  inTreatment1 = new  List<patient_Custom__c>() ;
            List<patient_Custom__c>  offstudy1 = new  List<patient_Custom__c>() ;
            
            String drilldownfiled = ApexPages.CurrentPage().getParameters().get('drilldown');
            
            List<Randomization_Form__c> randomizeformpatientId = [select CRF__r.patient__c,CRF__c FROM Randomization_Form__c where Randomization_Result__c != 'Not Randomized'  and CRF__c not in (SELECT CRF__c FROM Off_Study_Detail__c where Status__c = 'Accepted')];
            set<Id> patientlist = new set<Id>();
            for(Randomization_Form__c id :randomizeformpatientId ){
                patientlist.add(id.CRF__r.patient__c);
            }
            set<Id> offstudypatientlist = new set<Id>();
            List<Off_Study_Detail__c> offstudypatient = [SELECT TrialPatient__r.Patient_Id__c  FROM Off_Study_Detail__c where Status__c ='Accepted'];
            for(Off_Study_Detail__c id :offstudypatient){
                    offstudypatientlist.add(id.TrialPatient__r.Patient_Id__c);
            } 
            screened1 = [select Id   from patient_Custom__c  where id in (select Patient__c from CRF__c where type__c ='PreEligibility_Checklist__c') and id not in (SELECT Patient_Id__c FROM ArmPatient__c)];
            inTreatment1 = [select Id   from patient_Custom__c  where id in :patientlist];
            offstudy1 = [select Id   from patient_Custom__c  where id in :offstudypatientlist];
            List<ArmPatient__c> armp = new List<ArmPatient__c>();
            if(drilldownfiled  == 'Off Study'){
                armp = [select Arm_Id__r.Name,Subject_Id__c,CreatedDate,TrialPatient__r.Patient_Id__r.CreatedDate FROM ArmPatient__c where TrialPatient__r.Patient_Id__c in :offstudypatientlist Order By Name];
                integer count=1;
                for(ArmPatient__c  c: armp ){
                    if(count == armp.size())
                        data += '[\''+c.Arm_Id__r.Name+'\',\''+c.TrialPatient__r.Patient_Id__r.CreatedDate+'\',\''+c.Subject_Id__c+'\']';
                    else    
                        data += '[\''+c.Arm_Id__r.Name+'\',\''+c.TrialPatient__r.Patient_Id__r.CreatedDate+'\',\''+c.Subject_Id__c+'\'],';   
                    count++;    
                }
            }
            else if(drilldownfiled == 'In Treatment'){
                integer count=1;
                for(ArmPatient__c  c: armp ){
                    if(count == armp.size())
                        data += '[\''+c.Arm_Id__r.Name+'\',\''+c.TrialPatient__r.Patient_Id__r.CreatedDate+'\',\''+c.Subject_Id__c+'\']';
                    else    
                        data += '[\''+c.Arm_Id__r.Name+'\',\''+c.TrialPatient__r.Patient_Id__r.CreatedDate+'\',\''+c.Subject_Id__c+'\'],';   
                    count++;  
                }
            }
            else if(drilldownfiled == 'Screened'){
                List<CRF__c> screeneds= [select Patient__r.CreatedDate,Patient__r.Name,TrialPatient__c from CRF__c where type__c ='PreEligibility_Checklist__c' and Patient__c  not in (SELECT Patient_Id__c FROM ArmPatient__c) ];
                integer count=1;
                for(CRF__c c: screeneds){
                    if(count == screeneds.size())
                        data += '[\' \',\''+c.Patient__r.CreatedDate+'\',\''+c.Patient__r.Name+'\']';
                    else    
                        data += '[\'  \',\''+c.Patient__r.CreatedDate+'\',\''+c.Patient__r.Name+'\'],';   
                    count++;  
                }
            }
            else{
                 armp = [select Arm_Id__r.Name,Subject_Id__c,CreatedDate,TrialPatient__r.Patient_Id__r.CreatedDate FROM ArmPatient__c where TrialPatient__r.Patient_Id__c in :offstudypatientlist Order By Name];
                for(ArmPatient__c  c: armp ){
                        data += '[\''+c.Arm_Id__r.Name+'\',\''+c.TrialPatient__r.Patient_Id__r.CreatedDate+'\',\''+c.Subject_Id__c+'\'],';   
                      
                }
                 List<CRF__c> screeneds= [select Patient__r.CreatedDate,Patient__r.Name,TrialPatient__c from CRF__c where type__c ='PreEligibility_Checklist__c' and Patient__c  not in (SELECT Patient_Id__c FROM ArmPatient__c) ];
                for(CRF__c c: screeneds){
                        
                        data += '[\'  \',\''+c.Patient__r.CreatedDate+'\',\''+c.Patient__r.Name+'\'],';   
                  
                }
                 armp = [select Arm_Id__r.Name,Subject_Id__c,CreatedDate,TrialPatient__r.Patient_Id__r.CreatedDate FROM ArmPatient__c where TrialPatient__r.Patient_Id__c in :patientlist Order By Arm_Id__r.Name];
                for(ArmPatient__c  c: armp ){
                      data += '[\''+c.Arm_Id__r.Name+'\',\''+c.TrialPatient__r.Patient_Id__r.CreatedDate+'\',\''+c.Subject_Id__c+'\'],';   
                    
                }
            }
            
    System.debug('*****************'+offstudypatientlist.size()+armp.size()+data);
    }
}