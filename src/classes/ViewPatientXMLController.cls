public with sharing class ViewPatientXMLController {

    

    public static Integer pageSize=20;
    
    public  List<SelectOption> lstTrial { get; set; }

    public String trial { get; set; }

    public List<SelectOption> lstSite { get; set; }

    public String site { get; set; }

    public List<SelectOption> lstInstitution { get; set; }

    public String institution { get; set; }
    
    public String trialPatientIdSelected { get; set; }
    
    public List<TrialPatientWrapper> recLst {get{
            
           
               
            String query = 'Select Id,FirstName__c, LastName__c,Patient_Id__c from TrialPatient__c where Patient_Id__c in (Select Patient__c from PreEligibility_Checklist__c where Patient_signed_up_for_I_SPY2_screening__c=True)';
            if(trial!=null){
                 //query = query + ' where Trial_Id__c = \''+trial+'\'';
                 query = query + ' and Trial_Id__c = \''+trial+'\'';
            }
            if(institution !=null){
                 query = query + ' and Patient_Id__r.Institution__c = \''+institution+'\'';
            }
             if(site!=null){
                 query = query + ' and Site__c = \''+site+'\'';
            }
            query = query + ' order by '+ sortExpression  + ' ' + sortDirection;
            System.debug('Amit========'+query);
            con = new ApexPages.StandardSetController(Database.getQueryLocator(query));

            // sets the number of records in each page set
            con.setPageSize(pageSize);
           
            
            List<TrialPatient__c> records = con.getRecords();
    
            recLst = new List<TrialPatientWrapper>();
            for(TrialPatient__c fr : records ){
    
                recLst.add(new TrialPatientWrapper(fr) );
    
            }
            return recLst;
    }
     set;}
    
    private String sortDirection = 'DESC';
    private String sortExp = 'CreatedDate';

    public String sortExpression{
        get {
            return sortExp;
        } 
        set{
            if (value == sortExp){
                sortDirection = (sortDirection == 'ASC')? 'DESC' : 'ASC';
            }
            else{
                sortDirection = 'DESC';
            }
            sortExp = value;
        }
    }
    
    
    public String getSortDirection(){
        //if not column is selected 
        if (sortExpression == null || sortExpression == ''){
            return 'ASC';
        }
        else{
            return sortDirection;
        }
    }

    public void setSortDirection(String value){  
        sortDirection = value;
    }
    
    public ViewPatientXMLController(){
        lstInstitution = new List<SelectOption>();
        lstSite = new List<SelectOption>();
        lstTrial = new List<SelectOption>();
        loadTrial();
    } 
    public PageReference loadInstitute() {
        return null;
    }

    public void loadInstitution() {
        lstInstitution.clear();
        lstSite.clear();
        lstSite.add(new SelectOption('','------None------'));
        lstInstitution.add(new SelectOption('','------None------'));
        List<InstitutionTrial__c> lstInst = [select Institution_Id__c,Institution_Id__r.Name from InstitutionTrial__c where Trial_Id__c=:trial order by Institution_Id__r.Name desc];
        for(InstitutionTrial__c inst : lstInst) {
            lstInstitution.add(new SelectOption(inst.Institution_Id__c,inst.Institution_Id__r.Name));
        }
    }
    public PageReference loadTrial() {
        lstTrial.clear();
        lstTrial.add(new SelectOption('','------None------'));
        List<Trial__c> lstTrial2 = [select Id, Name from Trial__c order by Name asc];
        for(Trial__c trial : lstTrial2 ) {
            if(trial.Name != null) {
                lstTrial.add(new SelectOption(trial.Id,trial.Name));
            }
        }
        
        return null;
    }
    public PageReference loadSite() {
        lstSite.clear();
        //lstTrial.clear();
     
        lstSite.add(new SelectOption('','------None------'));
        //lstTrial.add(new SelectOption('','------None------'));
        List<Site__c> lstOfSite = [select Name from Site__c where Institute__c = :institution order by Name asc];
        for(Site__c site : lstOfSite) {
            lstSite.add(new SelectOption(site.Id,site.Name));
        }
        //doSort();
        return null;
    }
    
     
    public ApexPages.StandardSetController con {
        get {
            if(con == null) {
               
                String query = 'Select Id,FirstName__c, LastName__c,Patient_Id__c from TrialPatient__c where Patient_Id__c in (Select Patient__c from PreEligibility_Checklist__c where Patient_signed_up_for_I_SPY2_screening__c=True)';
                if(trial!=null){
                     //query = query + ' where Trial_Id__c = \''+trial+'\'';
                     query = query + ' and Trial_Id__c = \''+trial+'\'';
                }
                if(institution !=null){
                     query = query + ' and Patient_Id__r.Institution__c = \''+institution+'\'';
                }
                 if(site!=null){
                     query = query + ' and Site__c = \''+site+'\'';
                }
                query = query + ' order by '+ sortExpression  + ' ' + sortDirection;
                System.debug('Amit========'+query);
                con = new ApexPages.StandardSetController(Database.getQueryLocator(query));

                // sets the number of records in each page set
                con.setPageSize(pageSize);
            }
            return con;
        }
        set;
    }
     // indicates whether there are more records after the current page set.
    public Boolean hasNext {
        get {
            return con.getHasNext();
        }
        set;
    }

    // indicates whether there are more records before the current page set.
    public Boolean hasPrevious {
        get {
            return con.getHasPrevious();
        }
        set;
    }

    // returns the page number of the current page set
    public Integer pageNumber {
        get {
            return con.getPageNumber();
        }
        set;
    }

    // returns the first page of records
    public void first() {
        con.first();
        
        List<TrialPatient__c> records = con.getRecords();

        recLst.clear();
        for(TrialPatient__c li : records ){

            recLst.add(new TrialPatientWrapper(li) );

        }
    }

    // returns the last page of records
    public void last() {
        con.last();
        List<TrialPatient__c> records = con.getRecords();

        recLst.clear();
        for(TrialPatient__c li : records ){

            recLst.add(new TrialPatientWrapper(li) );

        }
    }

    // returns the previous page of records
    public void previous() {
        con.previous();
        List<TrialPatient__c> records = con.getRecords();

        recLst.clear();
        for(TrialPatient__c li : records ){

            recLst.add(new TrialPatientWrapper(li) );

        }
    }

    // returns the next page of records
    public void next() {
        con.next();
        List<TrialPatient__c> records = con.getRecords();

        recLst.clear();
        for(TrialPatient__c li : records ){

            recLst.add(new TrialPatientWrapper(li) );

        }
    }
    public void doSort(){
       
        String query = 'Select Id,FirstName__c, LastName__c,Patient_Id__c from TrialPatient__c where Patient_Id__c in (Select Patient__c from PreEligibility_Checklist__c where Patient_signed_up_for_I_SPY2_screening__c=True)';
        if(trial!=null){
             //query = query + ' where Trial_Id__c = \''+trial+'\'';
             query = query + ' and Trial_Id__c = \''+trial+'\'';
        }
        if(institution !=null){
             query = query + ' and Patient_Id__r.Institution__c = \''+institution+'\'';
        }
         if(site!=null){
             query = query + ' and Site__c = \''+site+'\'';
        }
                
        query += ' order by '+ sortExpression  + ' ' + sortDirection;
        System.debug('Amit query==================='+query );
        con = new ApexPages.StandardSetController(Database.getQueryLocator(query));
        // sets the number of records in each page set
        con.setPageSize(pageSize);
   
        List<TrialPatient__c> recs = con.getRecords();
        recLst.clear();
        for(TrialPatient__c li : recs ){

            recLst.add(new TrialPatientWrapper(li) );

        }
    
   }
   public Pagereference submitTrialSummaryNote(){
          
        //CRFMaster__c crfmst = [Select c.Id From CRFMaster__c c where c.Object_Name__c ='AE_Detail__c']; 
        CRFMaster__c crfmst = [Select c.Id From CRFMaster__c c where c.Object_Name__c ='Registration__c' limit 1]; 
        
        //To fetch admin xml configuration
        List<XML_Configuration__c> xmlPatientList = [Select id, Field_API_Name__c from XML_Configuration__c where CRF_Type__c = :crfmst.Id and Object_API_Name__c = 'Patient_Custom__c'];
        //List<XML_Configuration__c> aeList = [Select id, Field_API_Name__c from XML_Configuration__c where CRF_Type__c = :crfmst.Id and Object_API_Name__c = 'AE_Detail__c'];
        Set<String> patientSet = new Set<String>();
        for(XML_Configuration__c x: xmlPatientList){
            patientSet.add(x.Field_API_Name__c);
        }
        //Set<String> aeSet = new Set<String>();
        //for(XML_Configuration__c x: aeList ){
        //    aeSet.add(x.Field_API_Name__c);
        //} 
       
        
        cdapackage.CDAGeneratorPort ihub = new cdapackage.CDAGeneratorPort();
        External_Connection_Settings__c iHubEndpoint = External_Connection_Settings__c.getInstance('iHub');
        if (iHubEndpoint !=null){
            ihub.endpoint_x=iHubEndpoint.URL__c;
            ihub.timeout_x=iHubEndpoint.Timeout__c.intValue();
        }
        
        if(Test.isRunningTest()){
            ihub.endpoint_x = 'http://ec2-23-20-103-202.compute-1.amazonaws.com:12020/services/CDAGenerator';
            ihub.timeout_x = 120000;
        }
        cdapackage.clinicalDocument clinicalDoc = new cdapackage.clinicalDocument();
        cdapackage.author author = new cdapackage.author();
        cdapackage.patient patient = new cdapackage.patient();
        cdapackage.procedure procedure = new cdapackage.procedure();
        cdapackage.guidanceMethod[] guidanceArray;// = new cdapackage.guidanceMethod[]{};
        String xmlType = 'CDA';
        author.idExtension = UserInfo.getUserName();
        
        List<AE_Detail__c> adverseEventObjList = [select a.caAERS_report_filed__c, a.Visit_Date__c, a.CompletedDate__c, a.CRF__c, a.TrialPatient__c, a.SystemModstamp, a.Status__c, 
                    a.Patient_Hospitalized__c, a.OwnerId, a.Name, a.LastModifiedDate, a.LastModifiedById, a.IsDeleted, a.Id, 
                    a.Effective_Time__c, a.CreatedById, OriginalCRF__c, (Select Id, Name, AE_Detail__c, AE_End_Date__c, Attribution__c, 
                    Did_event_required_hospitalization__c, Did_event_result_in_death__c, Did_the_investigator_find_event_unusual__c, 
                    Grade__c, Onset_Date__c, Patient_Complaint__c, Resolved__c, Result_conginental_abnormality_defect__c, 
                    Result_persistent_significant_disability__c, SAE__c, Was_event_life_threatning__c, Symptom_Status__c, Symptom_Masters__c, Toxicity_Master__c,  Toxicity_Status__c   From Toxicities__r)
                    From AE_Detail__c a where TrialPatient__c=:trialPatientIdSelected  order by CreatedDate desc];
       
       
       
        TrialPatient__c trialPatientObj = null;
        String patientId;
        List<TrialPatient__c> lstTrialPatient = [select Id,Name,Subject_Id__c,Site__c, Patient_Id__c, Trial_Id__c,Trial_Id__r.Name,Site__r.Name  from TrialPatient__c where Id = :trialPatientIdSelected ];
        if(!lstTrialPatient.IsEmpty()) {
            trialPatientObj = lstTrialPatient[0];
            patientId = lstTrialPatient[0].Patient_Id__c;
        }
                    
        clinicalDoc.id=trialPatientObj.id;
        clinicalDoc.title = 'Trial Summary Note';
        //if(adverseEventObj.Effective_Time__c!=null){
            clinicalDoc.effectiveTime=String.valueOf(System.today()).replaceAll('-','').replaceAll(':','').replaceAll(' ','');
        //}
        
        String siteCode = trialPatientObj.Site__r.Name;
        if(trialPatientObj.Site__r.Name!=null){
        	Integer index1 = trialPatientObj.Site__r.Name.indexOf('(');
        	Integer index2 = trialPatientObj.Site__r.Name.indexOf(')');
        	if(index1>-1 && index2>-1 && index2>index1 ){
        		siteCode = trialPatientObj.Site__r.Name.substring(index1+1,index2).trim();
        	}
        }
        clinicalDoc.siteIdentifier= siteCode;
		        
        //clinicalDoc.siteIdentifier= trialPatientObj.Site__r.Name;
        clinicalDoc.siteIdRoot='2.16.840.1.113883.3.26.1.7';      
        clinicalDoc.studyId=trialPatientObj.Trial_Id__r.Name ;
        clinicalDoc.studyIdRoot='2.16.840.1.113883.3.26.1.7' ;

        String siteId,studyId,mrn;
        String firstName,lastName;
        
        List<Patient_Custom__c> patientObjList = [Select  p.Name,p.mrn__c,p.Birthdate__c, p.Zip__c, p.SSN__c, p.Race__c, p.Middle_Name__c, p.Medical_Record_Number__c, p.Last_Name__c, p.Institution__c, p.Institute_Text__c, p.Initials__c, p.Gender__c, p.First_Name__c, p.Ethnicity__c, p.Country_of_Birth__c From Patient_Custom__c p where Id =:patientId limit 1];
        if(!patientObjList.isEmpty()) {
            Patient_Custom__c patientObj = patientObjList.get(0);
            firstName = patientObj.First_Name__c;
            lastName = patientObj.Last_Name__c;
            patient.MRN = patientObj.Medical_Record_Number__c; 
            if(patientSet.contains('First_Name__c')) {
                patient.givenName=patientObj.First_Name__c;
            }
            if(patientSet.contains('Last_Name__c')) {
                patient.familyName=patientObj.Last_Name__c;
            }
            patient.gender=patientObj.Gender__c;
            if(patientObj.Gender__c=='Female'){
                patient.gendercode='F';
            }else if(patientObj.Gender__c=='Male'){
                patient.gendercode='M';
            }else{
                patient.gendercode='N/A';
            }
            if(patientObj.Birthdate__c!=null){
                patient.doB=String.valueOf(patientObj.Birthdate__c).replaceAll('-','').replaceAll(' ','');
            }

            patient.maritalStatus='UNKNOWN';
            patient.maritalStatuscode='N/A';
            if(patientSet.contains('Race__c')) {
                List<String> stringList = patientObj.Race__c.split('\\;');  
                if(stringList.size()>0 ){
                     patientObj.Race__c = stringList[0];
                }
                
                Map<String,String> raceMap = new Map<String,String>();
                raceMap.put('White','2106-3');
                raceMap.put('Black or African American','2054-5');
                raceMap.put('American Indian or Alaska Native','1002-5');
                raceMap.put('Asian','2028-9');
                raceMap.put('Native Hawaiian or Pacific Islander','2076-8');
                
                patient.race=patientObj.Race__c;
                /*
                if(patientObj.Race__c=='White'){
                    patient.raceCode='2106-3';
                }else if(patientObj.Race__c=='Black or African American'){
                    patient.raceCode='2054-5';
                }else if(patientObj.Race__c=='American Indian or Alaska Native'){
                    patient.raceCode='1002-5';
                }else if(patientObj.Race__c=='Asian'){
                    patient.raceCode='2028-9';
                }else if(patientObj.Race__c=='Native Hawaiian or Other Pacific Islander'){
                    patient.raceCode='2076-8';
                }else{
                    patient.raceCode='N/A';
                }
                */
                patient.raceCode=(raceMap.get(patientObj.Race__c)==null?'N/A':raceMap.get(patientObj.Race__c));
                
                if(stringList.size()>1){
                        cdapackage.race[] additionalrace = new cdapackage.race[stringList.size()-1];
                        for(Integer i=1; i<stringList.size();i++){
                                cdapackage.race r = new cdapackage.race();
                                r.raceValue = stringList[i];
                                /*
                                if(r.raceValue=='White'){
                                    r.raceCode='2106-3';
                                }else if(r.raceValue=='Black or African American'){
                                    r.raceCode='2054-5';
                                }else if(r.raceValue=='American Indian or Alaska Native'){
                                    r.raceCode='1002-5';
                                }else if(r.raceValue=='Asian'){
                                    r.raceCode='2028-9';
                                }else if(r.raceValue=='Native Hawaiian or Other Pacific Islander'){
                                    r.raceCode='2076-8';
                                }else{
                                    r.raceCode='N/A';
                                }*/
                                r.raceCode=(raceMap.get(r.raceValue)==null?'N/A':raceMap.get(r.raceValue));
                                additionalrace[i-1] = r;
                        }
                        patient.additionalrace = additionalrace;
                }
            }
            
            Map<String,String> ethinicityMap = new Map<String,String>();
            ethinicityMap.put('Not Hispanic or Latino','2186-5');
            ethinicityMap.put('Hispanic or Latino','2135-2');
                
            if(patientSet.contains('Ethnicity__c')) {
                patient.ethinicity=patientObj.Ethnicity__c;
                /*
                if(patientObj.Ethnicity__c=='Not Hispanic or Latino'){
                    patient.ethinicityCode='2186-5';
                }else if(patientObj.Ethnicity__c=='Hispanic or Latino'){
                    patient.ethinicityCode='2135-2';
                }else{
                    patient.ethinicityCode='N/A';
                }*/
                patient.ethinicityCode=(ethinicityMap.get(patientObj.Ethnicity__c)==null?'N/A':ethinicityMap.get(patientObj.Ethnicity__c));
            }
            
            clinicalDoc.studySubjectIdentifier=trialPatientObj.Subject_Id__c;
            mrn=patientObj.Medical_Record_Number__c;
            
        }
        siteId = trialPatientObj.Site__c;
        studyId = trialPatientObj.Trial_Id__c;
        
        
        //if(adverseEventObjList.isEmpty()){
	    //   	ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Adverse Event records not found for the patient '+firstName+' '+lastName+'('+patientId+').');
	    //    ApexPages.addMessage(myMsg);
	    //    return null;
        //}
        
        String treatmentArmName;
        List<ArmPatient__c> armPatientList = [Select a.assignedToPatient__c, a.TrialPatient__r.Patient_Id__c, a.TrialPatient__r.Name, a.TrialPatient__c, a.Name, a.Arm_Id__r.Name, a.Arm_Id__c From ArmPatient__c a where TrialPatient__c =:trialPatientIdSelected and assignedToPatient__c = true];
        
        if(!armPatientList.isEmpty()) {
            //treatmentArmId = armPatientObj.Arm_Id__c;
            ArmPatient__c armPatientObj = armPatientList[0];
            treatmentArmName = armPatientObj.Arm_Id__r.Name;
        }else{
        	treatmentArmName='';
        }
        
        //if(armPatientList.isEmpty()){
	    //   	ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Treatment Arm not found for the patient '+firstName+' '+lastName+'('+patientId+').');
	    //    ApexPages.addMessage(myMsg);
	     //   return null;
        //}
        
        Map<String,String> toxicityCodeMap = new Map<String,String>();
        List<CTCAECodeMaster__c> codeMasterList = [Select Toxicity_Master__r.Toxicity_Name__c, Code__c From CTCAECodeMaster__c where Toxicity_Master__r.Toxicity_Name__c !=null];
        for(CTCAECodeMaster__c codeMaster : codeMasterList){
        	toxicityCodeMap.put(codeMaster.Toxicity_Master__r.Toxicity_Name__c,codeMaster.Code__c);
        }
        
        //if(codeMasterList.isEmpty()){
	    //   	ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Code Master List is empty. Cannot proceed..');
	    //    ApexPages.addMessage(myMsg);
	    //    return null;
        //}
        
        Integer size =0;
        for(AE_Detail__c adverseEventObj : adverseEventObjList){
        	size += adverseEventObj.Toxicities__r.size();
        }
        cdapackage.adverseEvent[] adverseEventArray = new cdapackage.adverseEvent[size];
        Integer iCount =0;
        
        Map<String,String> gradeMap = new Map<String,String>();
        gradeMap.put('1','CTCAE Grade 1');
        gradeMap.put('2','CTCAE Grade 2');
        gradeMap.put('3','CTCAE Grade 3');
        gradeMap.put('4','CTCAE Grade 4');
        gradeMap.put('5','CTCAE Grade 5');
        
        Map<String,String> attributionMap = new Map<String,String>();
        attributionMap.put('1 - Unrelated','N/A');
        attributionMap.put('2 - Unlikely','N/A');
        attributionMap.put('3 - Possible','371930009');
        attributionMap.put('4 - Probable','N/A');
        attributionMap.put('5 - Definite','255545003');
       
            
        for(AE_Detail__c adverseEventObj : adverseEventObjList){
	        for(Integer i=0;i< adverseEventObj.Toxicities__r.size();i++){
	            Toxicity__c tox=adverseEventObj.Toxicities__r[i];
	            cdapackage.adverseEvent ae = new cdapackage.adverseEvent();
	            
	            ae.id= tox.Id;
	            
	            //if(tox.AE_End_Date__c!=null){
	            //    ae.reportingPeriodEndDate=String.valueOf(tox.AE_End_Date__c).replaceAll('-','').replaceAll(' ','');
	            //}
	            //ae.grade = tox.Grade__c;
	            if(tox.Grade__c!=null){
	                String s = tox.Grade__c.split('-')[0].trim();
	                System.debug('Amit Grade ===='+s );
	                /*
	                if(S=='1'){
	                        ae.grade='CTCAE Grade 1';
	                }else if(S=='2'){
	                        ae.grade='CTCAE Grade 2';
	                }else if(S=='3'){
	                        ae.grade='CTCAE Grade 3';
	                }else if(S=='4'){
	                        ae.grade='CTCAE Grade 4';
	                }else if(S=='5'){
	                        ae.grade='CTCAE Grade 5';
	                }*/
	                ae.grade=gradeMap.get(s);
	            }
	            
	            if(tox.Attribution__c!=null){
	              ae.attribution=tox.Attribution__c.split('-')[1].trim();
	            }
	            //ae.attribution=tox.Attribution__c;//rollback
	            /*
	            if(tox.Attribution__c=='1 - Unrelated'){
	                ae.attributionCode='N/A';
	            }else if(tox.Attribution__c=='2 - Unlikely'){
	                ae.attributionCode='N/A';
	            }else if(tox.Attribution__c=='3 - Possible'){
	                ae.attributionCode='371930009';
	            }else if(tox.Attribution__c=='4 - Probable'){
	                ae.attributionCode='N/A';
	            }else if(tox.Attribution__c=='5 - Definite'){
	                ae.attributionCode='255545003';
	            }else{
	                ae.attributionCode='';
	            }
	            */
	            ae.attributionCode=(attributionMap.get(tox.Attribution__c)==null?'':attributionMap.get(tox.Attribution__c));
	
	            if(tox.Onset_Date__c!=null){
	                ae.onsetDate=String.valueOf(tox.Onset_Date__c).replaceAll('-','').replaceAll(' ','');
	            }
	             
	           
	            ae.groupid = '36e3e930-7b14-11db-9fe1-0800200c9a66';
	            ae.reportingPeriodStartDate = '';
	            ae.reportingPeriodEndDate='';
	            if(tox.AE_End_Date__c!=null){
	                ae.resolutionDate=String.valueOf(tox.AE_End_Date__c).replaceAll('-','').replaceAll(' ','');
	            }else{
	                ae.resolutionDate='';
	            }
	            
	            ae.adversereaction=tox.Name;
	            //ae.adversereactionCode='405532008';
	            ae.adversereactionCode=toxicityCodeMap.get(tox.Name);
	            
	            ae.verbatim=tox.Patient_Complaint__c;
	            
	            if(tox.Was_event_life_threatning__c){
	                ae.seriousReason='Is life threatening';
	                ae.seriousReasonCode='440181000';
	            }
	             if(tox.Did_event_result_in_death__c){
	                ae.seriousReason='Results in death';
	                ae.seriousReasonCode='405535005';
	            }
	             if(tox.Did_event_required_hospitalization__c){
	                ae.seriousReason='Requires inpatient hospitalization or prolongation of existing hospitalization';
	                ae.seriousReasonCode='308540004';
	            }
	             if(tox.Did_the_investigator_find_event_unusual__c){
	                ae.seriousReason='Unusual event';
	                ae.seriousReasonCode='N/A';
	            }
	             if(tox.Result_conginental_abnormality_defect__c){
	                ae.seriousReason='Is a congenital abnormality/birth defect';
	                ae.seriousReasonCode='66091009';
	            }
	             if(tox.Result_persistent_significant_disability__c){
	                ae.seriousReason='Results in persistent or significant incapacity or substantial disruption of the ability to conduct normal life functions';
	                ae.seriousReasonCode='405532008';
	            }
	            
	            //ae.assignedTreatment='TAC1';
	            //ae.assignedTreatment='Paclitaxel';
	            ae.assignedTreatment=treatmentArmName;
	            
	           
	            
	            adverseEventArray[iCount] = ae;
	            iCount++;
	        }
        }//outer for
        
        
        String trialId = trialPatientObj.Trial_Id__c;
        
        cdapackage.osPathology osPathology = new cdapackage.osPathology();
        
        List<On_Study_Pathology_Form__c> pathologyFormList = [Select id,Tumor_laterality__c,Is_DCIS_Present__c,Is_LCIS_Present__c,Is_invasive_tumor_present__c,(select Estrogen_Receptor_Status__c,Progesterone_Receptor_Status__c,HER2_neu_Marker__c from Receptors__r) from On_Study_Pathology_Form__c where TrialPatient__c=:trialPatientIdSelected ];
        if(!pathologyFormList.isEmpty() ){
            On_Study_Pathology_Form__c pf = pathologyFormList[0]; 
            
            osPathology.DCIS_Present=pf.Is_DCIS_Present__c;
            
           
            osPathology.invasive_tumor_present=pf.Is_invasive_tumor_present__c;
            osPathology.laterality=pf.Tumor_laterality__c;
            if(osPathology.laterality=='Left'){
            	osPathology.lateralitycode ='7771000';
            }else{
            	osPathology.lateralitycode ='24028007';
            }
            osPathology.LCIS_Present=pf.Is_LCIS_Present__c;
            osPathology.LymphNodeStatus='';
             
            
            if(!pf.Receptors__r.isEmpty()){
            	osPathology.ERStatus=pf.Receptors__r[0].Estrogen_Receptor_Status__c;
            	osPathology.PRStatus=pf.Receptors__r[0].Progesterone_Receptor_Status__c;
            	osPathology.HERStatus=pf.Receptors__r[0].HER2_neu_Marker__c;
            }else{
		       	//ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'On Study Pathology Receptors not found for the patient '+firstName+' '+lastName+'('+patientId+').');
		        //ApexPages.addMessage(myMsg);
		        //return null;
		        osPathology.ERStatus='';
            	osPathology.PRStatus='';
            	osPathology.HERStatus='';
	        }
            
        }else{
        	osPathology.DCIS_Present='';
            osPathology.invasive_tumor_present='';
            osPathology.laterality='';
            osPathology.lateralitycode ='';
            osPathology.LCIS_Present='';
            osPathology.LymphNodeStatus='';
            osPathology.ERStatus='';
        	osPathology.PRStatus='';
        	osPathology.HERStatus='';
        }
        
        //if(pathologyFormList.isEmpty()){
	     //  	ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'On Study Pathology not found for the patient '+firstName+' '+lastName+'('+patientId+').');
	    //    ApexPages.addMessage(myMsg);
	    //    return null;
        //}
        
        //List<Staging_Detail__c> stagingList = [Select Id,Adjudicated_Stage__c from Staging_Detail__c where Patient__c=:patientId];
        //if(!stagingList.isEmpty()){
        //	Staging_Detail__c stage = stagingList[0];
        //	osPathology.ClinicalStaging=stage.Adjudicated_Stage__c;
        //}
        
        //if(stagingList.isEmpty()){
	    //   	ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Clinical Staging not found for the patient '+firstName+' '+lastName+'('+patientId+').');
	    //    ApexPages.addMessage(myMsg);
	    //    return null;
        //}
       
        
        cdapackage.chemoProcedure chemoProcedure  = new cdapackage.chemoProcedure();
        List<Post_Surgaory_Summary__c> postSurgaorySumList = [Select id,pcr__c,Date_Of_Procedure__c,Is_DCIS_Present__c, Is_invasive_tumor_present__c, Is_LCIS_Present__c,Lymph_node_dissection_done__c,(select Estrogen_Receptor_Status__c,Progesterone_Receptor_Status__c,HER2_neu_Marker__c from Receptors__r),(Select Id,Adjudicated_Stage__c from Staging_Details__r) from Post_Surgaory_Summary__c where TrialPatient__c =:trialPatientIdSelected];
        
        if(!postSurgaorySumList.isEmpty()){
        	Post_Surgaory_Summary__c pss = postSurgaorySumList[0];
	        chemoProcedure.DCIS_Present = pss.Is_DCIS_Present__c;
	        
	        chemoProcedure.invasive_tumor_present = pss.Is_invasive_tumor_present__c;
	        chemoProcedure.LCIS_Present=pss.Is_LCIS_Present__c;
	        chemoProcedure.LymphNodedissection=pss.Lymph_node_dissection_done__c;
	        chemoProcedure.Lymphnodestatus='';
	        chemoProcedure.PCR=String.valueOf(pss.pcr__c);
	        
	        chemoProcedure.RCB='';

	        if(pss.Date_Of_Procedure__c!=null){
            	chemoProcedure.surgerydate=String.valueOf(pss.Date_Of_Procedure__c).replaceAll('-','').replaceAll(':','').replaceAll(' ','');
            }else{
            	chemoProcedure.surgerydate='';
            }
	        chemoProcedure.surgerytype='';
	        if(!pss.Receptors__r.isEmpty()){
            	chemoProcedure.ERStatus=pss.Receptors__r[0].Estrogen_Receptor_Status__c;
            	chemoProcedure.PRStatus=pss.Receptors__r[0].Progesterone_Receptor_Status__c;
            	chemoProcedure.HERStatus=pss.Receptors__r[0].HER2_neu_Marker__c;
            }else{
            	//ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Receptors not found for the patient '+firstName+' '+lastName+'('+patientId+').');
		        //ApexPages.addMessage(myMsg);
		        //return null;
		        chemoProcedure.ERStatus='';
            	chemoProcedure.PRStatus='';
            	chemoProcedure.HERStatus='';
            }
            
            if(!pss.Staging_Details__r.isEmpty()){
            	osPathology.ClinicalStaging=pss.Staging_Details__r[0].Adjudicated_Stage__c;
            	osPathology.Adjudicatedstage=pss.Staging_Details__r[0].Adjudicated_Stage__c;
                osPathology.Adjudicatedstagecode='';
            	
            }else{
            	//ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Clinical Staging not found for the patient '+firstName+' '+lastName+'('+patientId+').');
		        //ApexPages.addMessage(myMsg);
		        //return null;
		        osPathology.ClinicalStaging='';
            	osPathology.Adjudicatedstage='';
                osPathology.Adjudicatedstagecode='';
		        
            }
        }else{
        	chemoProcedure.DCIS_Present = '';
	        
	        chemoProcedure.invasive_tumor_present = '';
	        chemoProcedure.LCIS_Present='';
	        chemoProcedure.LymphNodedissection='';
	        chemoProcedure.Lymphnodestatus='';
	        chemoProcedure.PCR='';
	        
	        chemoProcedure.RCB='';
	        chemoProcedure.surgerydate='';
	        chemoProcedure.surgerytype='';
	        chemoProcedure.ERStatus='';
        	chemoProcedure.PRStatus='';
        	chemoProcedure.HERStatus='';
        	osPathology.ClinicalStaging='';
        	osPathology.Adjudicatedstage='';
            osPathology.Adjudicatedstagecode='';
        }
        //if(postSurgaorySumList.isEmpty()){
	    //   	ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Chemo Procedure detail (Post Surgaory Summary) not found for the patient '+firstName+' '+lastName+'('+patientId+').');
	    //    ApexPages.addMessage(myMsg);
	    //    return null;
        //}
        cdapackage.chemoRegimen chemoRegimen = new cdapackage.chemoRegimen();
        List<Chemo_Therapy_Regimen__c> chemoRegimenList = [Select Id, Agent__r.Name, Prescribed_Dose__c, Day__c, Dose_Mod__c from Chemo_Therapy_Regimen__c where Chemo_Treatment__r.TrialPatient__c=:trialPatientIdSelected];
        if(!chemoRegimenList.isEmpty()){
        	Chemo_Therapy_Regimen__c cr = chemoRegimenList[0];
	        
	        chemoRegimen.dose=String.valueOf(cr.Prescribed_Dose__c);
	        chemoRegimen.dosemodifications=String.valueOf(cr.Dose_Mod__c);
	        chemoRegimen.drugname=cr.Agent__r.Name;
	        
	        chemoRegimen.priordose='';
	        chemoRegimen.priordrugagent='';
	        chemoRegimen.schedule=String.valueOf(cr.Day__c);
	        chemoRegimen.treatmentplanname ='';
	        
	        
        }else{
        	chemoRegimen.dose='';
	        chemoRegimen.dosemodifications='';
	        chemoRegimen.drugname='';
	        
	        chemoRegimen.priordose='';
	        chemoRegimen.priordrugagent='';
	        chemoRegimen.schedule='';
	        chemoRegimen.treatmentplanname ='';
        }
        //if(chemoRegimenList.isEmpty()){
	    //   	ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Chemo Regimen detail  not found for the patient '+firstName+' '+lastName+'('+patientId+').');
	    //    ApexPages.addMessage(myMsg);
	    //    return null;
        //}
        
        List<Chemo_Treatment__c> chemoList = [Select id, Cycle_number__c from Chemo_Treatment__c where TrialPatient__c = :trialPatientIdSelected];
        if(!chemoList.isEmpty()){
        	Chemo_Treatment__c chemo = chemoList[0];
        	chemoRegimen.cycles=String.valueOf(chemo.Cycle_number__c);
        }else{
        	chemoRegimen.cycles='';
        }
        
        //if(chemoList.isEmpty()){
	    //   	ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Chemo Regimen Cycle  not found for the patient '+firstName+' '+lastName+'('+patientId+').');
	    //    ApexPages.addMessage(myMsg);
	    //    return null;
        //}
       
        List<Chemo_Summary_Form__c> chemoSummaryList = [Select id,First_Date_of_Taxane_Therapy__c, First_Date_of_Investigational_Therapy__c, First_Date_of_Anthracycline_Therapy__c,Last_Date_of_Anthracycline_Therapy__c, Last_Date_of_Investigational_Therapy__c, Last_Date_of_Taxane_Therapy__c,InvestigationalRegimenTreatmentEndReason__c,Other_Reason__c from Chemo_Summary_Form__c where TrialPatient__c= :trialPatientIdSelected];
        if(!chemoSummaryList.isEmpty()) {
        	Chemo_Summary_Form__c cs = chemoSummaryList[0];
        	//chemoRegimen.startdate=cs.First_Date_of_Taxane_Therapy__c;
        	if(cs.First_Date_of_Taxane_Therapy__c!=null){
            	chemoRegimen.startdate=String.valueOf(cs.First_Date_of_Taxane_Therapy__c).replaceAll('-','').replaceAll(':','').replaceAll(' ','');
            }else{
            	chemoRegimen.startdate='';
            }
        	
        	//chemoRegimen.enddate = cs.Last_Date_of_Taxane_Therapy__c;
        	if(cs.Last_Date_of_Taxane_Therapy__c!=null){
            	chemoRegimen.enddate=String.valueOf(cs.Last_Date_of_Taxane_Therapy__c).replaceAll('-','').replaceAll(':','').replaceAll(' ','');
            }else{
            	chemoRegimen.enddate='';
            }
        	
        	if(cs.InvestigationalRegimenTreatmentEndReason__c =='Treatment completed per protocol criteria'){
        		chemoRegimen.treatmentcomepleted = 'Yes';
        	}else{
        		chemoRegimen.treatmentcomepleted = 'No';
        	}
        	//if(cs.InvestigationalRegimenTreatmentEndReason__c !='Treatment completed per protocol criteria'){
	        //	chemoRegimen.treatmentendreason =cs.InvestigationalRegimenTreatmentEndReason__c;
        	//}else {
        	//	chemoRegimen.treatmentendreason =cs.Other_Reason__c;
        	//}
        	chemoRegimen.treatmentendreason =cs.InvestigationalRegimenTreatmentEndReason__c;
        	if(chemoRegimen.treatmentendreason==null && cs.Other_Reason__c!=null){
        		chemoRegimen.treatmentendreason =cs.Other_Reason__c;
        	}
        	if(chemoRegimen.treatmentendreason ==null){
        		chemoRegimen.treatmentendreason ='';
        	}
        } else{
        	chemoRegimen.startdate='';
        	chemoRegimen.enddate='';
        	chemoRegimen.treatmentcomepleted ='';
        	chemoRegimen.treatmentendreason ='';
        	
        }
        //if(chemoSummaryList.isEmpty()){
	    //   	ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Chemo Summary  not found for the patient '+firstName+' '+lastName+'('+patientId+').');
	    //    ApexPages.addMessage(myMsg);
	    //    return null;
        //}
             
        try{
            cdapackage.response res = new cdapackage.response();
            if(Test.isRunningTest()) {
                res.status = 'SUCCESS';
                res.description='success message';
                res.code = 'SUCCESS';
            }else{
            	
               System.debug('Amit====clinicalDoc='+clinicalDoc);
               System.debug('Amit====author='+author);
               System.debug('Amit====patient='+patient);
               System.debug('Amit====adverseEventArray='+adverseEventArray);
               System.debug('Amit====osPathology='+osPathology);
               System.debug('Amit====chemoProcedure='+chemoProcedure);
               System.debug('Amit====chemoRegimen='+chemoRegimen);
               System.debug('Amit====xmlType='+xmlType);
               	
               res = ihub.submitClinicalTrialCDA(clinicalDoc ,author,patient,adverseEventArray,osPathology,chemoProcedure,chemoRegimen,xmlType );
               // submitClinicalTrialCDA(cdapackage.clinicalDocument arg0,cdapackage.author arg1,cdapackage.patient arg2,cdapackage.adverseEvent[] arg3,cdapackage.osPathology arg4,cdapackage.chemoProcedure arg5,cdapackage.chemoRegimen arg6,String arg7) 
            }
            
            if(res.status=='FAILURE'){
                                
                populateFailedRegistration(trialPatientObj.Id,patientId,trialId,siteId,studyId,res.code,res.description,'Failure','caAERS',mrn,res.caXchangeId,res.id);
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, res.code+':'+res.description+' for the patient '+firstName+' '+lastName+'('+patientId+').');
        		ApexPages.addMessage(myMsg);
            }else{
            	ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Trial Summary Note has been submitted for the patient '+firstName+' '+lastName+'('+patientId+').');
        		ApexPages.addMessage(myMsg);
            }
            
        }catch(System.CalloutException e){
        	String errorCode = '5001';
        	populateFailedRegistration(trialPatientObj.Id,patientId,trialId,siteId,studyId,errorCode,'Connection timeout when accessing CDA Service','Failure','caAERS',mrn,null,null);
        	ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, '5001:Connection timeout when accessing CDA Service'+' for the patient '+firstName+' '+lastName+'('+patientId+').');
        	ApexPages.addMessage(myMsg);
        }catch(Exception e){
            System.debug(e);
            String errorCode = '5000';
            
            populateFailedRegistration(trialPatientObj.Id,patientId,trialId,siteId,studyId,errorCode,'Unexpected error','Failure','caAERS',mrn,null,null);
        	ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, '5000:Unexpected error'+' for the patient '+firstName+' '+lastName+'('+patientId+').');
        	ApexPages.addMessage(myMsg);
        }
        
        
        return null;
   }
   
   public void populateFailedRegistration(String crfId,String patientId, String trialId, String siteId,String studyId, String errorCode, String errorMessage, String status,String systemName, String mrn,String caXchangeId, String returnId){
        String CRFName='Trial Summary Note';
        /*
        List<CRFMaster__c> crfList = [Select c.CRFType__c From CRFMaster__c c where c.Object_Name__c='AE_Detail__c'];
        if(crfList.size()>0){
            CRFName = crfList[0].CRFType__c;
        }
        */
        Boolean autoRetry = false;
        List<Auto_Retry_Error_Codes__c> codeList = Auto_Retry_Error_Codes__c.getAll().values();
        for(Auto_Retry_Error_Codes__c code : codeList){
            if(code.Error_Code__c==errorCode){
                autoRetry = true;
                break;
            }
        }
        
        
        Failed_Registration__c fr = new Failed_Registration__c(CRF_Id__c=crfId,Patient__c=patientId,Trial__c=trialId,Last_Error_Message__c=errorMessage,Last_Status__c=status,Retry__c=autoRetry,Site__c=siteId,Study_Id__c=studyId,Error_Code__c=errorCode,System_Name__c=systemName,MRN__c=mrn,CRF_Name__c=CRFName,CaXchangeId__c=caXchangeId,ReturnId__c=returnId);
        insert fr;
    }
   
    public class TrialPatientWrapper
    {
        public TrialPatient__c trialPatient{get; set;}
        
        public String url{get; set;}
        
        public TrialPatientWrapper(TrialPatient__c tp)
        {
            trialPatient= tp;
            url='www.yahoo.com';
        }
    }
    
}