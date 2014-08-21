public with sharing class CRFsPendingForDCCApproval {
	public String selectedTab{get;set;}
	public List<CRFWrapper> crfScreeningWapList {get;set;}
	public List<CRFWrapper> crfTreatmentWapList {get;set;}
	public List<CRFWrapper> crfFollowUpWapList {get;set;}
	public Map<string,string> CRFFormsMap;
	public Map<string,string> CRFFormTypeMap;
	public String selectedCRFViewOption{get;set;}
	public boolean showTabPanel {get;set;}
	public string crfFormName {get;set;}
	public string crfFormApiName {get;set;}
	public List<AggregateResult> taskList {get;set;}
	public Set<string> CRFObjectNameSet;
	public List<Selectoption> CRFOptionsList {get;set;}
	public List<CRFMaster__c> CRFMasterList;
	public Integer noOfSelectdCRFs {get;set;}
	public List<CRFWrapper2> CRFWrapper2List {get;set;}
	public List<List<CRFWrapper2>> CRFWrapper2ListOfList {get;set;}
	public Integer noOfRecs {get;set;}
	
	public List<CRFRandomizationWrapper> CRFRandomizationWrapperList {get;set;}
	public List<List<CRFRandomizationWrapper>> CRFRandomizationWrapperListOfList {get;set;}
	public integer CRFRandomizationRecNos {get;set;}
	
	public Set<Id> trialIdSet;
	public Set<Id> patientIdSet;
	public Set<Id> trialPatientIdSet;
	
	
	public Trial__c MoISpy2Trial;
	public CRFsPendingForDCCApproval(){
		List<Trial__c>trialList = [Select t.id, t.Start_Date__c, t.Name From Trial__c t where name = 'MO-I-SPY 2 TRIAL'];
		if(!trialList.isEmpty()){
			MoISpy2Trial = trialList[0]; 
			//List<Task> taskList = [Select t.WhoId, t.WhatId, t.Type, t.Subject, t.Status, t.Original_Due_Date__c, count(Id) From Task t where Status != 'Completed'];
			//List<AggregateResult> taskList = [Select count(id) total, Object_Name__c  From Task t where t.Status != 'Completed' AND OwnerId= :UserInfo.getUserId() group by t.Object_Name__c ];
			//taskList = [Select count(id) total, Object_Name__c  From Task t where (t.Status = 'In Progress' OR t.Status = 'Not Started') AND t.Trial_Id__c != null AND t.WhatId != null AND OwnerId= :UserInfo.getUserId() group by t.Object_Name__c ];
			taskList = [Select count(id) total, Object_Name__c  From Task t where (t.Status = 'In Progress' OR t.Status = 'Not Started') AND t.Trial_Id__c = :MoISpy2Trial.id AND t.WhatId != null AND OwnerId= :UserInfo.getUserId() group by t.Object_Name__c ];
			System.debug('taskList-----------'+taskList);
		} 
		noOfRecs = 0;
		
		CRFFormsMap = new Map<string,string>();
		CRFFormTypeMap = new Map<string,string>();
		CRFObjectNameSet = new Set<string>();
		CRFOptionsList = new List<Selectoption>();
		CRFMasterList = [Select c.Object_Name__c, c.Name, c.CRFType__c From CRFMaster__c c];
		
        CRFOptionsList.add(new Selectoption('pending submission','CRF pending submission (not signed & submitted)'));
        CRFOptionsList.add(new Selectoption('pending re-submission','CRF pending re-submission (rejected but not submitted)'));
        CRFOptionsList.add(new Selectoption('Patients pending registration','Patients pending registration (Registration CRF not submitted)'));
        CRFOptionsList.add(new Selectoption('Patients pending Randomization','Patients pending Randomization (Randomization CRF - not signed & submitted)'));
        CRFOptionsList.add(new Selectoption('Delayed CRFs','Delayed CRFs'));
        
		for(CRFMaster__c crfMaster : CRFMasterList){
			if(crfMaster.Object_Name__c == null || crfMaster.CRFType__c == null)continue;
			CRFFormsMap.put(crfMaster.Object_Name__c,crfMaster.CRFType__c);
			CRFFormTypeMap.put(crfMaster.CRFType__c,crfMaster.Object_Name__c);
			CRFObjectNameSet.add(crfMaster.Object_Name__c);
			//CRFOptionsList.add(new Selectoption(crfMaster.Object_Name__c,crfMaster.CRFType__c));
		}
		
		CRFPendingRandomization();
		
		if(!taskList.isEmpty()){
			buildCRFWrapperList(taskList);
		}
		showTabPanel = true;
	}
	
	public void buildCRFWrapperList(List<AggregateResult> taskList){
		crfScreeningWapList = new List<CRFWrapper>();
		crfTreatmentWapList = new List<CRFWrapper>();
		crfFollowUpWapList = new List<CRFWrapper>();
		
		List<Phase_CRFs__c> phaseCRFsList = [Select p.Phase_Cycle__r.Phase__c, p.Phase_Cycle__r.Phase__r.Name, p.Phase_Cycle__c, p.CRF__r.CRFType__c, 
											p.CRF__r.Object_Name__c, p.CRF__r.Id, p.CRF__c, Next_Due_on__c From Phase_CRFs__c p 
											order by Order__c];

		List<Phase_Master__c> phaseMasterList = [Select p.Name, p.Id From Phase_Master__c p];
		
		for(Phase_CRFs__c phaseCrfObj : phaseCRFsList) {
			CRFWrapper crfWap;
			for(Phase_Master__c phaseMasterObj : phaseMasterList) {
				if(phaseMasterObj.Name == 'Screening' && phaseMasterObj.Id == phaseCrfObj.Phase_Cycle__r.Phase__c) {
					for(AggregateResult ar : taskList){
						if(String.valueOf(ar.get('Object_Name__c')) == phaseCrfObj.CRF__r.Object_Name__c){
							System.debug('obj---Name--------Screening---'+ar.get('Object_Name__c'));
							System.debug('obj---total-------Screening---'+ar.get('total'));
							
							if(Integer.valueOf(ar.get('total')) > 0){
								crfWap = new CRFWrapper();
								string objName = String.valueOf(ar.get('Object_Name__c'));
								
								crfWap.objName = objName;
								crfWap.formName = CRFFormsMap.get(objName);
								crfWap.noOfForms = Integer.valueOf(ar.get('total'));
								crfScreeningWapList.add(crfWap);
							}
						}
					}
				} else if(phaseMasterObj.Name == 'Treatment' && phaseMasterObj.Id == phaseCrfObj.Phase_Cycle__r.Phase__c) {
					for(AggregateResult ar : taskList){
						System.debug('obj---Name----'+ar.get('Object_Name__c')+'       '+phaseCrfObj.CRF__r.Object_Name__c);
						if(String.valueOf(ar.get('Object_Name__c')) == phaseCrfObj.CRF__r.Object_Name__c){
							System.debug('obj---Name--------Treatment---'+ar.get('Object_Name__c'));
							System.debug('obj---total-------Treatment---'+ar.get('total'));
							
							if(Integer.valueOf(ar.get('total')) > 0){
								crfWap = new CRFWrapper();
								string objName = String.valueOf(ar.get('Object_Name__c'));
								
								crfWap.objName = objName;
								crfWap.formName = CRFFormsMap.get(objName);
								crfWap.noOfForms = Integer.valueOf(ar.get('total'));
								crfTreatmentWapList.add(crfWap);
							}
						}
					}
				} else if(phaseMasterObj.Name == 'Follow Up' && phaseMasterObj.Id == phaseCrfObj.Phase_Cycle__r.Phase__c) {
					for(AggregateResult ar : taskList){
						if(String.valueOf(ar.get('Object_Name__c')) == phaseCrfObj.CRF__r.Object_Name__c){
							System.debug('obj---Name--------FollowUp---'+ar.get('Object_Name__c'));
							System.debug('obj---total-------FollowUp---'+ar.get('total'));
							
							if(Integer.valueOf(ar.get('total')) > 0){
								crfWap = new CRFWrapper();
								string objName = String.valueOf(ar.get('Object_Name__c'));
								
								crfWap.objName = objName;
								crfWap.formName = CRFFormsMap.get(objName);
								crfWap.noOfForms = Integer.valueOf(ar.get('total'));
								crfFollowUpWapList.add(crfWap);
							}
						}
					}
				}
			}
			System.debug('crfWap---'+crfWap);
			if(crfWap == null){
				crfWap = new CRFWrapper();
				string objName = phaseCrfObj.CRF__r.Object_Name__c;
				crfWap.objName = objName;
				crfWap.formName = CRFFormsMap.get(objName);
				crfWap.noOfForms = 0;
				crfWap.barWidth = 0;
				string phaseName = phaseCrfObj.Phase_Cycle__r.Phase__r.Name;
				if(phaseName == 'Screening')crfScreeningWapList.add(crfWap);
				if(phaseName == 'Treatment')crfTreatmentWapList.add(crfWap);
				if(phaseName == 'Follow Up')crfFollowUpWapList.add(crfWap);
			}
		}
		System.debug('crfScreeningWapList---------'+crfScreeningWapList);
		System.debug('crfTreatmentWapList---------'+crfTreatmentWapList);
		System.debug('crfFollowUpWapList---------'+crfFollowUpWapList);
		
		if(!crfScreeningWapList.isEmpty())createBarChartOfCrfPhase(crfScreeningWapList);
		if(!crfTreatmentWapList.isEmpty())createBarChartOfCrfPhase(crfTreatmentWapList);
		if(!crfFollowUpWapList.isEmpty())createBarChartOfCrfPhase(crfFollowUpWapList);
		
		/*
		if(!CRFRandomizationWrapperList.isEmpty()){
			CRFWrapper crfRandomizationWap = new CRFWrapper();
			string objName = CRFFormsMap.get('Randomization_Form__c');
			System.debug('objName----hhh-----------------------'+objName);
			crfRandomizationWap.objName = CRFFormTypeMap.get(objName);
			crfRandomizationWap.formName = objName;
			crfRandomizationWap.noOfForms = (CRFRandomizationWrapperList.size() > 0)? CRFRandomizationWrapperList.size():0;
			crfScreeningWapList.add(crfRandomizationWap);
		}
		*/
		
	}
	
	public void createBarChartOfCrfPhase(List<CRFWrapper> crfWapList){
		//check no Of forms and make calculation for graph bar and set barwidth
		if(!crfWapList.isEmpty()){
			//1st find the most no of Crf
			Integer mostNoOfCrfs = 0;
			for(CRFWrapper crfWap : crfWapList){
				if(crfWap.noOfForms > mostNoOfCrfs){
					mostNoOfCrfs = crfWap.noOfForms;
				}
			}
			//set barwidth
			System.debug('mostNoOfCrfs------------'+mostNoOfCrfs);
			for(CRFWrapper crfWap : crfWapList){
				if(crfWap.noOfForms != 0){
					decimal noOfForms = crfWap.noOfForms;
					decimal crfWapBarWidth = (noOfForms*100).Divide(mostNoOfCrfs,5);
					crfWap.barWidth = crfWapBarWidth;
					System.debug('crfWap.barWidth-------------------'+crfWap.formName+'    '+crfWap.noOfForms+'   '+crfWap.barWidth); 
				}
			}
		}
	}
	
	public void createNewCRFsList(){
		System.debug('selectedCRFViewOption---------'+selectedCRFViewOption);
		if(selectedCRFViewOption == 'Patients pending Randomization'){
			showTabPanel = false;
			crfFormName = CRFFormsMap.get('Randomization_Form__c');
			crfFormApiName = CRFFormTypeMap.get(crfFormName);
			noOfSelectdCRFs = (CRFRandomizationWrapperList.size() > 0)? CRFRandomizationWrapperList.size():0;
			Apexpages.currentPage().getParameters().put('CRFName','Randomization_Form__c');
			return;
		}
		string queryStrValue = 'Select count(id) total, Object_Name__c From Task t ';
		if(selectedCRFViewOption == 'pending submission'){
			//queryStrValue = queryStrValue + 'where (t.Status = \'In Progress\' OR t.Status = \'Not Started\') AND t.Trial_Id__c != null AND t.WhatId != null AND t.OwnerId = \''+UserInfo.getUserId()+'\' group by t.Object_Name__c ';
			queryStrValue = queryStrValue + 'where (t.Status = \'In Progress\' OR t.Status = \'Not Started\') AND t.Trial_Id__c = \''+MoISpy2Trial.id+'\' AND t.WhatId != null AND t.OwnerId = \''+UserInfo.getUserId()+'\' group by t.Object_Name__c ';
			showTabPanel = true;
		}else if(selectedCRFViewOption == 'pending re-submission'){
			//queryStrValue = queryStrValue + 'where (t.Status = \'In Progress\' OR t.Status = \'Not Started\') AND Subject = \'Resubmit Rejected CRF\' AND CRF__c != null AND Trial_Id__c != null AND WhatId != null AND OwnerId = \''+UserInfo.getUserId()+'\' group by t.Object_Name__c ';
			queryStrValue = queryStrValue + 'where (t.Status = \'In Progress\' OR t.Status = \'Not Started\') AND Subject = \'Resubmit Rejected CRF\' AND CRF__c != null AND Trial_Id__c =\''+MoISpy2Trial.id+'\' AND OwnerId = \''+UserInfo.getUserId()+'\' group by t.Object_Name__c ';
			showTabPanel = true;
		}else if(selectedCRFViewOption == 'Patients pending registration'){
			//queryStrValue = queryStrValue + 'where Object_Name__c = \'Registration__c\' AND (Status = \'In Progress\' OR Status = \'Not Started\') AND Trial_Id__c != null AND WhatId != null AND OwnerId = \''+UserInfo.getUserId()+'\' group by t.Object_Name__c ';
			queryStrValue = queryStrValue + 'where Object_Name__c = \'Registration__c\' AND (Status = \'In Progress\' OR Status = \'Not Started\') AND Trial_Id__c =\''+MoISpy2Trial.id+'\' AND WhatId != null AND OwnerId = \''+UserInfo.getUserId()+'\' group by t.Object_Name__c ';
			showTabPanel = false;
			crfFormName = CRFFormsMap.get('Registration__c');
			crfFormApiName = CRFFormTypeMap.get(crfFormName);
			Apexpages.currentPage().getParameters().put('CRFName','Registration__c');
			CRFPendingListsView();
			
		}else if (selectedCRFViewOption == 'Delayed CRFs'){
			queryStrValue = queryStrValue + 'where (t.Status = \'In Progress\' OR t.Status = \'Not Started\') AND t.Trial_Id__c != null AND t.WhatId != null AND t.OwnerId = \''+UserInfo.getUserId()+'\' AND t.Original_Due_Date__c < TODAY group by t.Object_Name__c ';
			showTabPanel = true;	
		}else{
			System.debug('selectedCRFViewOption--------else----'+selectedCRFViewOption);
			queryStrValue = queryStrValue + 'where (Status = \'In Progress\' OR Status = \'Not Started\') AND Object_Name__c = \''+selectedCRFViewOption+'\' AND Trial_Id__c != null AND WhatId != null AND OwnerId = \''+UserInfo.getUserId()+'\' group by t.Object_Name__c ';
			showTabPanel = false;
			crfFormName = CRFFormsMap.get(selectedCRFViewOption);
			crfFormApiName = CRFFormTypeMap.get(crfFormName);
		}
		
		System.debug('queryStrValue--------------'+queryStrValue);
		taskList = Database.query(queryStrValue);
		System.debug('taskList--------------'+taskList);
		
		if(!taskList.isEmpty() && showTabPanel == true){
			buildCRFWrapperList(taskList);
		}else if(!taskList.isEmpty() && !showTabPanel){
			noOfSelectdCRFs = Integer.valueOf(taskList[0].get('total'));
		}else if(taskList.isEmpty()){
			System.debug('noOfSelectdCRFs--------------'+showTabPanel);
			if(crfScreeningWapList != null && !crfScreeningWapList.isEmpty())crfScreeningWapList.clear();
			if(crfTreatmentWapList != null && !crfTreatmentWapList.isEmpty())crfTreatmentWapList.clear();
			if(crfFollowUpWapList != null && !crfFollowUpWapList.isEmpty())crfFollowUpWapList.clear();
			noOfSelectdCRFs = 0;
		}
		selectedTab = 'Screening';
	}
	
	public class CRFWrapper {
		public string formName {get;set;}
		public string objName {get;set;}
		public string formViewLink {get;set;}
		public integer noOfForms {get;set;}
		public decimal barWidth {get;set;}
	}
	
	public class CRFWrapper2 {
		public string institute {get;set;}
		public string site {get;set;}
		public string trial {get;set;}
		public Date dueDate {get;set;}
		public string subjectId {get;set;}
		public Datetime preEICompletionDate {get;set;}
	}
	
	public void CRFPendingListsView(){
		string formName = Apexpages.currentPage().getParameters().get('CRFName');
		System.debug('formName-------------'+formName);
		if(formName == 'Randomization_Form__c'){
			crfFormName = CRFFormsMap.get(formName);
			//return;
		}else{
			crfFormName = CRFFormsMap.get(formName);
			System.debug('crfFormName-------------'+crfFormName);
			System.debug('selectedCRFViewOption-------------'+selectedCRFViewOption);
			
			string taskQuery = 'Select t.CRF_Form_Id__c, t.CreatedDate, t.Trial_Id__c, t.WhoId, t.WhatId, t.Type, t.Subject, t.Status, t.Original_Due_Date__c From Task t ';
			
			if(selectedCRFViewOption == 'pending re-submission'){
				//taskQuery = taskQuery + 'where (t.Status = \'In Progress\' OR t.Status = \'Not Started\') AND t.Trial_Id__c != null AND t.WhatId != null AND OwnerId= \''+UserInfo.getUserId()+'\' AND Object_Name__c = \''+formName+'\' AND Subject = \'Resubmit Rejected CRF\' AND CRF__c != null order by CreatedDate asc';
				taskQuery = taskQuery + 'where (t.Status = \'In Progress\' OR t.Status = \'Not Started\') AND t.Trial_Id__c = \''+MoISpy2Trial.id+'\' AND t.WhatId != null AND OwnerId= \''+UserInfo.getUserId()+'\' AND Object_Name__c = \''+formName+'\' AND Subject = \'Resubmit Rejected CRF\' AND CRF__c != null order by CreatedDate asc';
			}else{
				//taskQuery = taskQuery + 'where (t.Status = \'In Progress\' OR t.Status = \'Not Started\') AND t.Trial_Id__c != null AND t.WhatId != null AND OwnerId= \''+UserInfo.getUserId()+'\' AND Object_Name__c = \''+formName+'\' order by CreatedDate asc';
				taskQuery = taskQuery + 'where (t.Status = \'In Progress\' OR t.Status = \'Not Started\') AND t.Trial_Id__c = \''+MoISpy2Trial.id+'\' AND t.WhatId != null AND OwnerId= \''+UserInfo.getUserId()+'\' AND Object_Name__c = \''+formName+'\' order by CreatedDate asc';
			}
			//List<Task> taskList = [ where (t.Status = 'In Progress' OR t.Status = 'Not Started') AND t.Trial_Id__c != null AND t.WhatId != null AND OwnerId= :UserInfo.getUserId() AND Object_Name__c = :formName order by CreatedDate asc];
			System.debug('taskQuery-------------'+taskQuery);
			List<Task> taskList = Database.Query(taskQuery);
			System.debug('taskList-------------'+taskList.size());
			List<TrialPatient__c> trialPatList;
			trialIdSet = new Set<Id>();
			patientIdSet = new Set<Id>();
			Map<string,Task> trialPatientTaskMap = new Map<string,Task>();
			Map<string,TrialPatient__c> trialPatMap;
			
			Set<id> patientIdSet = new Set<id>();
			Map<id,Patient_Custom__c> patientMap; 
			 
			if(!taskList.isEmpty()){
				for(Task t : taskList){
					System.debug('t.Trial_Id__c-----------------'+t.Trial_Id__c);
					System.debug('t.WhatId-----------------'+t.WhatId);
					if(t.WhatId != null){
						patientIdSet.add(t.WhatId);
					}
					if(t.Trial_Id__c != null && t.WhatId != null){
						trialIdSet.add(t.Trial_Id__c);
						patientIdSet.add(t.WhatId);
						trialPatientTaskMap.put(t.Trial_Id__c+'-'+t.WhatId,t);
					}
				}
				trialPatList = [Select t.Subject_Id__c, t.Trial_Id__r.Name, t.Trial_Id__c, t.Site__r.Name, t.Site__c, t.Institution__c, t.Patient_Id__c From TrialPatient__c t where Trial_Id__c IN :trialIdSet OR Patient_Id__c IN :patientIdSet];
				System.debug('trialPatList----------------'+trialPatList.size());
				trialPatMap = new Map<string,TrialPatient__c>();
				if(!trialPatList.isEmpty()){
					for(TrialPatient__c tp : trialPatList){
						trialPatMap.put(tp.Trial_Id__c+'-'+tp.Patient_Id__c,tp);			
					}
				}
			}
			
			if(!patientIdSet.isEmpty()){
				patientMap = new Map<id,Patient_Custom__c>([Select (Select Name, LastModifiedDate, Status__c From PreEligibility_Checklists__r where Status__c = 'Approval Not Required') From Patient_Custom__c p where id IN :patientIdSet]);
				System.debug('patientMap---------'+patientMap.size());
			}
			
			CRFWrapper2ListOfList = new List<List<CRFWrapper2>>();
			if(!taskList.isEmpty()){
				CRFWrapper2List = new List<CRFWrapper2>();
				System.debug('taskList----size----'+taskList.size());
				noOfRecs = 0;
					for(Task t : taskList){
						if(t.Trial_Id__c == null || t.WhatId == null)continue;
						CRFWrapper2 cwp = new CRFWrapper2();
						cwp.dueDate = t.Original_Due_Date__c;
						TrialPatient__c tp = trialPatMap.get(t.Trial_Id__c+'-'+t.WhatId);
						System.debug('tPatient-------'+tp);
						if(tp != null){
							cwp.institute = tp.Institution__c;
							cwp.trial = tp.Trial_Id__r.Name;
							cwp.site = tp.Site__r.Name;
							cwp.subjectId = tp.Subject_Id__c;
						}
						// bring preEligibility completion date
						if(patientMap != null && !patientMap.isEmpty()){
							Patient_Custom__c pc = patientMap.get(t.WhatId);
							if(pc != null){
								List<PreEligibility_Checklist__c> preEligibilityList = pc.PreEligibility_Checklists__r;
								if(preEligibilityList != null && !preEligibilityList.isEmpty()){
									cwp.preEICompletionDate = preEligibilityList[0].LastModifiedDate;
								}
							}
						}
						CRFWrapper2List.add(cwp);
						noOfRecs++ ;
						if(CRFWrapper2List.size() == 999){
							CRFWrapper2ListOfList.add(CRFWrapper2List);
							CRFWrapper2List = new List<CRFWrapper2>();
						}
					}
				if(!CRFWrapper2List.isEmpty())CRFWrapper2ListOfList.add(CRFWrapper2List);
				System.debug('CRFWrapper2List-------'+CRFWrapper2List.size());
				System.debug('CRFWrapper2ListOfList-------'+CRFWrapper2ListOfList.size());
			}
			System.debug('CRFWrapper2ListOfList-------'+CRFWrapper2ListOfList.size());
		}
	}
	
	public class CRFRandomizationWrapper {
		public string subjectId {get;set;}
		public string institute {get;set;}
		public string site {get;set;}
		public string trial {get;set;}
		public Date preEICompletionDate {get;set;}
		public Date registrationCompletionDate {get;set;}
		public Date tissueSpecimenCompletionDate {get;set;}
		public Date MRICompletionDate {get;set;}
		public Date onStudyEligibilityCompletionDate {get;set;}
		public Date onStudyPathologyCompletionDate {get;set;}
		public Date mammaPrintCompletionDate {get;set;}
	}
	
	
	public void CRFPendingRandomization(){
		Map<id,PreEligibility_Checklist__c> preEligibilityMap;
		Set<id> patientIdSet; 
		
		List<TrialPatient__c> trialPatientRandomizationList = [Select t.Subject_Id__c, t.Trial_Id__r.Name, t.Trial_Id__c, t.Site__r.Name, t.Site__c, t.Institution__c, t.Patient_Id__c, (Select Status__c, CompletedDate__c From Randomization_Forms__r), (Select Status__c, CompletedDate__c From Registrations__r order by LastModifiedDate desc limit 1), (Select Status__c, CompletedDate__c From TissueSpecimenDetail__r), (Select Status__c, CompletedDate__c From On_Study_Pathology_Forms__r where status__c = 'Accepted'), (Select Status__c, CompletedDate__c From On_Study_Eligibility_Forms__r where status__c = 'Accepted'), (Select Status__c, CompletedDate__c From MammaPrint_Details__r where status__c = 'Approval Not Required'), (Select Status__c, CompletedDate__c From MRI_Volumes__r where status__c = 'Accepted' and Time_Point__c = 'Pre-Treatment') From TrialPatient__c t];
		System.debug('trialPatientRandomizationList---size---'+trialPatientRandomizationList.size());
		if(!trialPatientRandomizationList.isEmpty()){
			patientIdSet = new Set<id>();
			for(TrialPatient__c tp : trialPatientRandomizationList){
				patientIdSet.add(tp.Patient_Id__c);	
			}
			if(!patientIdSet.isEmpty()){
				List<PreEligibility_Checklist__c> preEligibilityFrmList = [Select p.Patient__c, p.CompletedDate__c From PreEligibility_Checklist__c p where Patient__c IN :patientIdSet];
				preEligibilityMap = new Map<id,PreEligibility_Checklist__c>();
				for(PreEligibility_Checklist__c pEligibility : preEligibilityFrmList){
					preEligibilityMap.put(pEligibility.Patient__c,pEligibility);
				}				
			}
			
			CRFRandomizationWrapperList = new List<CRFRandomizationWrapper>();
			CRFRandomizationWrapperListOfList = new List<List<CRFRandomizationWrapper>>();
			CRFRandomizationRecNos = 0;
			for(TrialPatient__c tp : trialPatientRandomizationList){
				List<Randomization_Form__c> randomizationFrmList =  tp.Randomization_Forms__r;
				List<Registration__c> registrationFrmList =  tp.Registrations__r;
				List<TissueSpecimenDetail__c> tissueSpecimenFrmList =  tp.TissueSpecimenDetail__r;
				List<On_Study_Pathology_Form__c> onStdPathologyFrmList =  tp.On_Study_Pathology_Forms__r;
				List<On_Study_Eligibility_Form__c> onStdEligibilityList =  tp.On_Study_Eligibility_Forms__r;
				List<MammaPrintDetail__c> mammaPrintFrmList =  tp.MammaPrint_Details__r;
				List<MRI_Volume__c> MRIFrmList =  tp.MRI_Volumes__r;
				if(randomizationFrmList.isEmpty() && !onStdPathologyFrmList.isEmpty() && !onStdEligibilityList.isEmpty() && !mammaPrintFrmList.isEmpty() && !MRIFrmList.isEmpty()){
					CRFRandomizationWrapper cwp = new CRFRandomizationWrapper();
					cwp.subjectId = tp.Subject_Id__c;
					cwp.institute = tp.Institution__c;
					cwp.site = tp.Site__r.Name;
					cwp.trial = tp.Trial_Id__r.Name;
					if(preEligibilityMap.get(tp.Patient_Id__c) != null) cwp.preEICompletionDate = preEligibilityMap.get(tp.Patient_Id__c).CompletedDate__c;
					cwp.registrationCompletionDate = registrationFrmList[0].CompletedDate__c;
					cwp.tissueSpecimenCompletionDate = tissueSpecimenFrmList[0].CompletedDate__c;
					cwp.onStudyPathologyCompletionDate = onStdPathologyFrmList[0].CompletedDate__c;
					cwp.onStudyEligibilityCompletionDate = onStdEligibilityList[0].CompletedDate__c;
					cwp.mammaPrintCompletionDate = mammaPrintFrmList[0].CompletedDate__c;
					cwp.MRICompletionDate = MRIFrmList[0].CompletedDate__c;
					
					CRFRandomizationWrapperList.add(cwp);
					CRFRandomizationRecNos++;
				}
				if(CRFRandomizationWrapperList.size() == 999){
					CRFRandomizationWrapperListOfList.add(CRFRandomizationWrapperList);
					CRFRandomizationWrapperList = new List<CRFRandomizationWrapper>();
				}
			}
			if(!CRFRandomizationWrapperList.isEmpty()){
				CRFRandomizationWrapperListOfList.add(CRFRandomizationWrapperList);
			}
		}			
	}
	
}