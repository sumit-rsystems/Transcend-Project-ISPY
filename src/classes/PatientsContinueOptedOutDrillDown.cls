Public with sharing class PatientsContinueOptedOutDrillDown{
    public String data{get;set;}
    public PatientsContinueOptedOutDrillDown(){
            data  =   '[\'ARM\',\' Created Date\',\' Subject IDs\'],';
            String drilldownfiled = ApexPages.CurrentPage().getParameters().get('drilldown');
            
            List<Randomization_Form__c> randomizationpatientlist = database.query('SELECT TrialPatient__r.Patient_Id__c,Randomization_Result__c FROM Randomization_Form__c where Randomization_Result__c != \'Not Randomized\' and Status__c = \'Approval Not Required\' and Did_Patient_Sign_Treatment_Consent_Form__c = true and TrialPatient__c not in (SELECT TrialPatient__c FROM Off_Study_Detail__c where  status__c = \'Accepted\') ');
             List<Randomization_Form__c> randomizationpatientlist1 = database.query('SELECT TrialPatient__r.Patient_Id__c,Randomization_Result__c FROM Randomization_Form__c where Randomization_Result__c != \'Not Randomized\' and Status__c = \'Approval Not Required\' and Did_Patient_Sign_Treatment_Consent_Form__c = true and TrialPatient__c in (SELECT TrialPatient__c FROM Off_Study_Detail__c where  status__c = \'Accepted\') ');
            
            List<Id> continueIds = new List<Id>();
            List<Id> optedoutIds= new List<Id>();
            
            for(Randomization_Form__c rr :randomizationpatientlist )
                continueIds.add(rr.TrialPatient__r.Patient_Id__c);
            
            for(Randomization_Form__c rr :randomizationpatientlist1)
                optedoutIds.add(rr.TrialPatient__r.Patient_Id__c);
                
            List<ArmPatient__c > armp = new List<ArmPatient__c >();
            if(drilldownfiled  == 'Opted Out Patient'){
                armp = [select Arm_Id__r.Name,Subject_Id__c,CreatedDate,TrialPatient__r.Patient_Id__r.CreatedDate FROM ArmPatient__c where TrialPatient__r.Patient_Id__r.CreatedDate != null and TrialPatient__r.Patient_Id__c in :optedoutIds Order By Name];
                integer count=1;
                for(ArmPatient__c  c: armp ){
                    if(count == armp.size())
                        data += '[\''+c.Arm_Id__r.Name+'\',\''+c.TrialPatient__r.Patient_Id__r.CreatedDate+'\',\''+c.Subject_Id__c+'\']';
                    else    
                        data += '[\''+c.Arm_Id__r.Name+'\',\''+c.TrialPatient__r.Patient_Id__r.CreatedDate+'\',\''+c.Subject_Id__c+'\'],';   
                    count++;    
                }
            }
            else if(drilldownfiled == 'Continued Patient'){
                armp = [select Arm_Id__r.Name,Subject_Id__c,CreatedDate,TrialPatient__r.Patient_Id__r.CreatedDate FROM ArmPatient__c where TrialPatient__r.Patient_Id__r.CreatedDate != null and  TrialPatient__r.Patient_Id__c in :continueIds Order By Arm_Id__r.Name];
                integer count=1;
                for(ArmPatient__c  c: armp ){
                    if(count == armp.size())
                        data += '[\''+c.Arm_Id__r.Name+'\',\''+c.TrialPatient__r.Patient_Id__r.CreatedDate+'\',\''+c.Subject_Id__c+'\']';
                    else    
                        data += '[\''+c.Arm_Id__r.Name+'\',\''+c.TrialPatient__r.Patient_Id__r.CreatedDate+'\',\''+c.Subject_Id__c+'\'],';   
                    count++;  
                }
            }
            else{
                armp = [select Arm_Id__r.Name,Subject_Id__c,CreatedDate,TrialPatient__r.Patient_Id__r.CreatedDate FROM ArmPatient__c where TrialPatient__r.Patient_Id__r.CreatedDate != null and TrialPatient__r.Patient_Id__c in :optedoutIds Order By Name];
                for(ArmPatient__c  c: armp ){
                    data += '[\''+c.Arm_Id__r.Name+'\',\''+c.TrialPatient__r.Patient_Id__r.CreatedDate+'\',\''+c.Subject_Id__c+'\'],';   
               }
                armp = [select Arm_Id__r.Name,Subject_Id__c,CreatedDate,TrialPatient__r.Patient_Id__r.CreatedDate FROM ArmPatient__c where TrialPatient__r.Patient_Id__r.CreatedDate != null and TrialPatient__r.Patient_Id__c in :continueIds Order By Arm_Id__r.Name];
                for(ArmPatient__c  c: armp ){
                    data += '[\''+c.Arm_Id__r.Name+'\',\''+c.TrialPatient__r.Patient_Id__r.CreatedDate+'\',\''+c.Subject_Id__c+'\'],';   
                }
            
            }
           
   
    }
}