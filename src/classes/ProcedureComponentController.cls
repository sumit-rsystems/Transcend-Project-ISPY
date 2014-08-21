public with sharing class ProcedureComponentController {

	public List<Procedure__c> addProcedureList {get;set;}
	public Procedure__c proObj {get;set;}
	public List<Procedure__c> showProcedureList {get;set;}
	public List<Procedure__c> newProcedureList {get;set;}
	public List<WrapForSrno> wrapList {get;set;}
	public Integer countProcedure {get;set;}
	public Boolean isShowSaveButton {get;set;}
	public String insertedIds {get;set;}
	private Set<Id> procedureIds {get;set;}
	public Integer currentCountValue {get;set;}
	public String formNameValue{get;set;}
	static integer serialNumber = 1;
	public String trialPatientId{get;set;}
	public String postId{get;set;}
	public String pathologyId{get;set;}
	public Procedure__c editProcedure {get;set;}
	public Boolean isShowDateError{get;set;}
	private String patientId{get;set;}
	public Date dateOfProcedure{get;set;}
	public String surgeonId{get;set;}
	public String surgeonOtherValue{get;set;}
	public String subFormValueOF{get;set;}
	//public String proScanCheckString{get;set;} //==============this should be a comma seperated string of Scan done===============
	//public String proLymphScanCheckString{get;set;} //==============this should be a comma seperated string of lymph Scan done===============
	
	public ProcedureComponentController() {
		formNameValue = Apexpages.currentPage().getParameters().get('formName');
		trialPatientId = Apexpages.currentPage().getParameters().get('trialPat');
		postId = Apexpages.currentPage().getParameters().get('postid');
		pathologyId = Apexpages.currentPage().getParameters().get('PathologyId');
		patientId = Apexpages.currentPage().getParameters().get('patientId');
		system.debug('__postIdComponent__'+postId);
		System.debug('__formName__'+formNameValue);
		insertedIds = '';
		//proScanCheckString = '';
		//proLymphScanCheckString = '';
		isShowSaveButton = false;
		isShowDateError = false;
		procedureIds = new Set<Id>();
		//showProcedureList = new List<Procedure__c>();
		newProcedureList = new List<Procedure__c>();
		wrapList = new List<WrapForSrno>();
		List<Procedure__c> tmpProcedureList = new List<Procedure__c>();
		if(postId!=null && postId!='') {
			//showProcedureList = [select Ultrasound__c, TrialPatient__c, Stereotactic__c, Procedure_Name__c, Post_Surgery_Summary__c, Palpation_guided__c, On_Study_Pathology_Form__c, Node_Type__c, Node_Result__c, Name, Mammography__c, MRI__c, Location__c, Laterality__c, Id, Form_Name__c, Date_Of_Procedure__c  from Procedure__c where TrialPatient__c =:trialPatientId and (Post_Surgery_Summary__c =:postId or On_Study_Pathology_Form__c!=null)];
			//tmpProcedureList = [select Ultrasound__c, TrialPatient__c, Stereotactic__c, Procedure_Name__c, Post_Surgery_Summary__c, Palpation_guided__c, On_Study_Pathology_Form__c, Node_Type__c, Node_Result__c, Name, Mammography__c, MRI__c, Location__c, Laterality__c, Id, Form_Name__c, Date_Of_Procedure__c  from Procedure__c where (Post_Surgery_Summary__c =:postId or TrialPatient__c =:trialPatientId) order by CreatedDate];
			tmpProcedureList = [select Ultrasound__c, TrialPatient__c, Stereotactic__c, Procedure_Name__c, Post_Surgery_Summary__c, Palpation_guided__c, On_Study_Pathology_Form__c, Node_Type__c, Node_Result__c, Name, Mammography__c, MRI__c, Location__c, Laterality__c, Id, Form_Name__c, Date_Of_Procedure__c  from Procedure__c where Post_Surgery_Summary__c =:postId  order by Effective_Time__c];
			system.debug('__PostId__: '+postId+'__tmpProcedureList__:'+tmpProcedureList);
		} else if(pathologyId != null && pathologyId != '') {
			tmpProcedureList = [select Ultrasound__c, TrialPatient__c, Stereotactic__c, Procedure_Name__c, Post_Surgery_Summary__c, Palpation_guided__c, On_Study_Pathology_Form__c, Node_Type__c, Node_Result__c, Name, Mammography__c, MRI__c, Location__c, Laterality__c, Id, Form_Name__c, Date_Of_Procedure__c  from Procedure__c where (On_Study_Pathology_Form__c =: pathologyId) order by Effective_Time__c];
			system.debug('__pathologyId__: '+pathologyId+'__tmpProcedureList__:'+tmpProcedureList);
		}
		else {
			//showProcedureList = [select Ultrasound__c, TrialPatient__c, Stereotactic__c, Procedure_Name__c, Post_Surgery_Summary__c, Palpation_guided__c, On_Study_Pathology_Form__c, Node_Type__c, Node_Result__c, Name, Mammography__c, MRI__c, Location__c, Laterality__c, Id, Form_Name__c, Date_Of_Procedure__c from Procedure__c where TrialPatient__c =:trialPatientId and On_Study_Pathology_Form__c!=null];
			System.debug('__Query__select Ultrasound__c, TrialPatient__c, Stereotactic__c, Procedure_Name__c, Post_Surgery_Summary__c, Palpation_guided__c, On_Study_Pathology_Form__c, Node_Type__c, Node_Result__c, Name, Mammography__c, MRI__c, Location__c, Laterality__c, Id, Form_Name__c, Date_Of_Procedure__c from Procedure__c where TrialPatient__c ='+trialPatientId+' and On_Study_Pathology_Form__c!=null order by Effective_Time__c');
			tmpProcedureList = [select Ultrasound__c, TrialPatient__c, Stereotactic__c, Procedure_Name__c, Post_Surgery_Summary__c, Palpation_guided__c, On_Study_Pathology_Form__c, Node_Type__c, Node_Result__c, Name, Mammography__c, MRI__c, Location__c, Laterality__c, Id, Form_Name__c, Date_Of_Procedure__c from Procedure__c where TrialPatient__c =:trialPatientId and On_Study_Pathology_Form__c!=null order by Effective_Time__c];
			//tmpProcedureList = [select Ultrasound__c, TrialPatient__c, Stereotactic__c, Procedure_Name__c, Post_Surgery_Summary__c, Palpation_guided__c, On_Study_Pathology_Form__c, Node_Type__c, Node_Result__c, Name, Mammography__c, MRI__c, Location__c, Laterality__c, Id, Form_Name__c, Date_Of_Procedure__c from Procedure__c where Patient__c =:patientId and is_breast_surgical_procedure__c = true order by CreatedDate];
		}
		
		for(Procedure__c tmpObj : tmpProcedureList) {
			WrapForSrno tmpWrapObj = new WrapForSrno();
			tmpWrapObj.pro = tmpObj;
			system.debug('__tmpObj__'+tmpObj);
			if(tmpObj.Procedure_Name__c == 'Core biopsy') {
				if(tmpObj.Ultrasound__c) {
					tmpWrapObj.proScanCheckString+='Ultrasound, ';
				}
				
				if(tmpObj.Palpation_guided__c) {
					tmpWrapObj.proScanCheckString+='Palpation guided, ';
				}
				
				if(tmpObj.Mammography__c) {
					tmpWrapObj.proScanCheckString+='Mammography, ';
				}
				
				if(tmpObj.MRI__c) {
					tmpWrapObj.proScanCheckString+='MRI, ';
				}
				
				if(tmpObj.Stereotactic__c) {
					tmpWrapObj.proScanCheckString+='Stereotactic, ';
				}
				
				system.debug('__tmpWrapObj.proScanCheckString__'+tmpWrapObj.proScanCheckString);
				if(tmpWrapObj.proScanCheckString != '') {
					tmpWrapObj.proScanCheckString = '('+tmpWrapObj.proScanCheckString.substring(0, tmpWrapObj.proScanCheckString.length()-2)+')';
				}
			}
			
			if(tmpObj.Procedure_Name__c == 'Core biopsy (lymph node)') {
				if(tmpObj.Ultrasound__c) {
					tmpWrapObj.proLymphScanCheckString+='Ultrasound, ';
				}
				
				if(tmpObj.Palpation_guided__c) {
					tmpWrapObj.proLymphScanCheckString+='Palpation guided, ';
				}
				
				if(tmpObj.Mammography__c) {
					tmpWrapObj.proLymphScanCheckString+='Mammography, ';
				}
				
				if(tmpObj.MRI__c) {
					tmpWrapObj.proLymphScanCheckString+='MRI, ';
				}
				
				if(tmpObj.Stereotactic__c) {
					tmpWrapObj.proLymphScanCheckString+='Stereotactic, ';
				}
				
				system.debug('__tmpWrapObj.proLymphScanCheckString__'+tmpWrapObj.proLymphScanCheckString);
				if(tmpWrapObj.proLymphScanCheckString != '') {
					tmpWrapObj.proLymphScanCheckString = '('+tmpWrapObj.proLymphScanCheckString.substring(0, tmpWrapObj.proLymphScanCheckString.length()-2)+')';
				}
			}
			tmpWrapObj.isEditMode = false;
			
			if(wrapList.size() == 0) {
				tmpWrapObj.srno = serialNumber;
			} else {
				tmpWrapObj.srno = wrapList.size() + 1;
			}
			if(tmpObj.Id != null || tmpObj.Id != '') {
				procedureIds.add(tmpObj.Id);
				tmpWrapObj.isShowEditButton = true;
				insertedIds+= tmpObj.Id+',';
				/*if(postId!=null && postId!='' && tmpObj.Post_Surgery_Summary__c == postId) {
				}
				else if(pathologyId != null && pathologyId != '' && tmpObj.On_Study_Pathology_Form__c == pathologyId){
					tmpWrapObj.isShowEditButton = true;
					insertedIds+= tmpObj.Id+',';
				}*/
			}
			wrapList.add(tmpWrapObj);  
		}
		
		system.debug('__insertedIds__'+insertedIds);
		if(insertedIds!=null && insertedIds!='') {
			
			insertedIds = insertedIds.substring(0, insertedIds.length()-1);
		}
		
		system.debug('__tmpProcedureList__'+tmpProcedureList);
		system.debug('__showProcedureList__'+showProcedureList);
		addProcedureList = new List<Procedure__c>();
		
		/*proObj = new Procedure__c();
		proObj.Form_Name__c = 'Post Surgery Summary Form';*/
		countProcedure = 0;
		
	}
	
	public void addNewProcedure() {
		
		Id patholgyid=ApexPages.currentPage().getParameters().get('id') ;
		
		if(patholgyid==null){
			patholgyid=ApexPages.currentPage().getParameters().get('PathologyId') ;
		}
		List<On_Study_Pathology_Form__c > objpatholist=[Select o.TrialPatient__c, o.Id, o.CRF__r.Type__c, o.CRF__c From On_Study_Pathology_Form__c o where id =:patholgyid];
		
		if(objpatholist.size()>0){
			trialPatientId=objpatholist[0].TrialPatient__c;
			formNameValue='On_Study_Pathology_Form__c';
			if(formNameValue=='On_Study_Pathology_Form__c'){
				formNameValue = 'OnStudy Pathology';
			}
		}
		else{
			Id pss=ApexPages.currentPage().getParameters().get('id') ;
			if(pss==null){
				pss=ApexPages.currentPage().getParameters().get('postid') ;
			}
			List<Post_Surgaory_Summary__c > objpsslist =[Select p.TrialPatient__c, p.Id From Post_Surgaory_Summary__c p where  id =: pss];
			if(objpsslist.size()>0){
				trialPatientId=objpsslist[0].TrialPatient__c;
				formNameValue='Post Surgery Summary Form';
			}
		}
		
		//subFormValueOF = Apexpages.currentPage().getParameters().get('subForm');
		String procedureIdValue = Apexpages.currentPage().getParameters().get('procedureId');
		system.debug('__subFormValue__'+subFormValueOF);
		//system.debug('__procedureIdValue__'+procedureIdValue);
		
		WrapForSrno wrapObj = new WrapForSrno(); 
		proObj = new Procedure__c();
		proObj.TrialPatient__c = trialPatientId;
		if(formNameValue!='OnStudy Pathology') {
			proObj.Form_Name__c = formNameValue;
		}
		else {
			if(subFormValueOF!=null && subFormValueOF!='') {
				proObj.Form_Name__c = subFormValueOF;
			}
		}
		system.debug('__proObj__'+proObj);
		/*newProcedureList.add(proObj);
		system.debug('__newProcedureList__'+newProcedureList);
		system.debug('__newProcedureList.Size__'+newProcedureList.Size());*/
		
		wrapObj.pro = proObj;
		wrapObj.isEditMode = true;
		wrapObj.isShowEditButton = true;
		if(wrapList.size() == 0) {
			wrapObj.srno = serialNumber;
		} else {
			wrapObj.srno = wrapList.size() + 1;
		}
		
		wrapList.add(wrapObj);
		isShowSaveButton = true;
		system.debug('__wrapObj__'+wrapObj);
		system.debug('__srno__'+wrapObj.srno);
	}
	
	public void saveNewProcedure() {
		//String postIdValue = Apexpages.currentPage().getParameters().get('postid');
		List<Procedure__c> insertProcedureList = new List<Procedure__c>();
		system.debug('__wrapList[0].pro__'+wrapList[0].pro);
		system.debug('__wrapList[0].pro.Procedure_Name__c__'+wrapList[0].pro.Procedure_Name__c);
		for(WrapForSrno tmpProcObj : wrapList) {
			if(tmpProcObj.pro.Procedure_Name__c!=null && tmpProcObj.pro.Procedure_Name__c!='' && tmpProcObj.pro.Id == null) {
				if(postId != null && postId != '') {
					tmpProcObj.pro.Post_Surgery_Summary__c = postId;
				}
				else if(pathologyId != null && pathologyId != '') {
					if(tmpProcObj.pro.Date_Of_Procedure__c != null && tmpProcObj.pro.Date_Of_Procedure__c > system.today()) {
						isShowDateError = true;
						return;
					} else {
						isShowDateError = false;
					}
					tmpProcObj.pro.On_Study_Pathology_Form__c = pathologyId;
				} /*else if(patientId != null) {
					tmpProcObj.pro.Patient__c = patientId; 
					tmpProcObj.pro.is_breast_surgical_procedure__c = true;
					if(dateOfProcedure>system.today()) {
						isShowDateError = true;
						return;
					} else if(dateOfProcedure != null) {
						tmpProcObj.pro.Date_Of_Procedure__c = dateOfProcedure;
						isShowDateError = false;
					}
					
					if(surgeonId == 'Other') {
						if(surgeonOtherValue != null && surgeonOtherValue != '') {
							List<InstitutionUser__c> lstInstUserSite = [select id,Institution__c,Site__c from InstitutionUser__c where User__c =:Userinfo.getUserId()];
							system.debug('----lstInstUserSite[0].Site__c------'+lstInstUserSite[0].Site__c);
							Contact con = new Contact();
							con.LastName = surgeonOtherValue;
							con.AccountId = lstInstUserSite[0].Institution__c;
							con.Site__c = lstInstUserSite[0].Site__c;
							con.Type__c = 'Surgeon';
							insert con;
							tmpProcObj.pro.Surgeon__c = con.Id;
						}
					} else if(surgeonId != null && surgeonId != '') {
						tmpProcObj.pro.Surgeon__c = surgeonId;
					}
				}*/
				
				if((tmpProcObj.pro.Laterality__c == 'Left' || tmpProcObj.pro.Laterality__c == 'Right') && tmpProcObj.pro.Location__c == null) {
					if(tmpProcObj.pro.Procedure_Name__c == 'Sentinel Lymph Node Dissection' || tmpProcObj.pro.Procedure_Name__c == 'Partial Mastectomy') {
						tmpProcObj.pro.Location__c.addError('Please enter location.');
						return;
					}
				}
				insertProcedureList.add(tmpProcObj.pro);
			}
		}
		
		if(!insertProcedureList.isEmpty()) {
			insert insertProcedureList;
		}
		
		if(insertedIds!='') {
			insertedIds = insertedIds+',';
		}
		
		system.debug('__insertProcedureList__'+insertProcedureList);
		for(Procedure__c tmpProcObj : insertProcedureList) {
			procedureIds.add(tmpProcObj.Id);
			insertedIds+= tmpProcObj.Id+',';
		}
		
		system.debug('__insertedIds__'+insertedIds);
		if(insertedIds!=null && insertedIds!='') {
			
			insertedIds = insertedIds.substring(0, insertedIds.length()-1);
		}
		system.debug('__insertedIdsAfter__'+insertedIds);
		List<Procedure__c> tmpProcedureList = [select Ultrasound__c, TrialPatient__c, Stereotactic__c, Procedure_Name__c, Post_Surgery_Summary__c, Palpation_guided__c, On_Study_Pathology_Form__c, Node_Type__c, Node_Result__c, Name, Mammography__c, MRI__c, Location__c, Laterality__c, Id, Form_Name__c, Date_Of_Procedure__c from Procedure__c where Id IN :procedureIds order by Effective_Time__c];
		wrapList.clear();
		
		for(Procedure__c tmpObj : tmpProcedureList) {
			WrapForSrno tmpWrapObj = new WrapForSrno();
			tmpWrapObj.pro = tmpObj;
			tmpWrapObj.isEditMode = false;
			
			if(tmpWrapObj.pro.Procedure_Name__c == 'Core biopsy') {
				if(tmpWrapObj.pro.Ultrasound__c) {
					tmpWrapObj.proScanCheckString+='Ultrasound, ';
				}
				
				if(tmpWrapObj.pro.Palpation_guided__c) {
					tmpWrapObj.proScanCheckString+='Palpation guided, ';
				}
				
				if(tmpWrapObj.pro.Mammography__c) {
					tmpWrapObj.proScanCheckString+='Mammography, ';
				}
				
				if(tmpWrapObj.pro.MRI__c) {
					tmpWrapObj.proScanCheckString+='MRI, ';
				}
				
				if(tmpWrapObj.pro.Stereotactic__c) {
					tmpWrapObj.proScanCheckString+='Stereotactic, ';
				}
				
				system.debug('__tmpWrapObj.proScanCheckString__'+tmpWrapObj.proScanCheckString);
				if(tmpWrapObj.proScanCheckString != '') {
					tmpWrapObj.proScanCheckString = '('+tmpWrapObj.proScanCheckString.substring(0, tmpWrapObj.proScanCheckString.length()-2)+')';
				}
			}
			
			if(tmpWrapObj.pro.Procedure_Name__c == 'Core biopsy (lymph node)') {
				if(tmpWrapObj.pro.Ultrasound__c) {
					tmpWrapObj.proLymphScanCheckString+='Ultrasound, ';
				}
				
				if(tmpWrapObj.pro.Palpation_guided__c) {
					tmpWrapObj.proLymphScanCheckString+='Palpation guided, ';
				}
				
				if(tmpWrapObj.pro.Mammography__c) {
					tmpWrapObj.proLymphScanCheckString+='Mammography, ';
				}
				
				if(tmpWrapObj.pro.MRI__c) {
					tmpWrapObj.proLymphScanCheckString+='MRI, ';
				}
				
				if(tmpWrapObj.pro.Stereotactic__c) {
					tmpWrapObj.proLymphScanCheckString+='Stereotactic, ';
				}
				
				system.debug('__tmpWrapObj.proLymphScanCheckString__'+tmpWrapObj.proLymphScanCheckString);
				if(tmpWrapObj.proLymphScanCheckString != '') {
					tmpWrapObj.proLymphScanCheckString = '('+tmpWrapObj.proLymphScanCheckString.substring(0, tmpWrapObj.proLymphScanCheckString.length()-2)+')';
				}
			}
			
			if(wrapList.size() == 0) {
				tmpWrapObj.srno = serialNumber;
			} else {
				tmpWrapObj.srno = wrapList.size() + 1;
			}
			
			if(postId!=null && postId!='' && tmpObj.Post_Surgery_Summary__c == postId) {
				tmpWrapObj.isShowEditButton = true;
			}
			else if(pathologyId != null && pathologyId != '' && tmpObj.On_Study_Pathology_Form__c == pathologyId){
				tmpWrapObj.isShowEditButton = true;
			}
			
			wrapList.add(tmpWrapObj);  
		}
		system.debug('__wrapList__'+wrapList);
		isShowSaveButton = false;
	}
	
	public void cancelNewProcedure() {
		Integer currentCountValue = Integer.valueOf(Apexpages.currentPage().getParameters().get('serial'));
		String procedureIdValue = Apexpages.currentPage().getParameters().get('procedureId');
		system.debug('__currentCountValue__'+currentCountValue);
		system.debug('__procedureIdValue__'+procedureIdValue);
		system.debug('__insertedIds__'+insertedIds);
		if(!wrapList.isEmpty()) {
			wrapList.remove(currentCountValue-1);
		}
		
		if(procedureIdValue != null && procedureIdValue != '') {
			//delete [select Id from Procedure__c where Id =:procedureIdValue];
			list<Procedure__c> proceduretoDelete = [select Id from Procedure__c where Id =:procedureIdValue];
			DeleteSharedRecordUtility.deleteProcedurePss(proceduretoDelete);
			if(insertedIds.contains(procedureIdValue)) {
				insertedIds.replaceAll(procedureIdValue, '');
			}
		}
		system.debug('__insertedIds__'+insertedIds);
		
		Integer counter = 1;
		Integer flag = 0;
		for(WrapForSrno tmpWrap : wrapList) {
			tmpWrap.srno = counter;
			if(tmpWrap.isEditMode) {
				flag = 1;
			}
			counter++;
		}
		system.debug('__wrapList__'+wrapList.Size());
		if(wrapList.isEmpty() || flag == 0) {
			isShowSaveButton = false;
		}
		//wrapList = updatedWrapList;
	}
	
	public void editProcedure() {
		String procedureIdValue = Apexpages.currentPage().getParameters().get('procedureId');
		Integer currentCountValue = Integer.valueOf(Apexpages.currentPage().getParameters().get('serial'));
		system.debug('__procedureIdValue__'+procedureIdValue);
		system.debug('__currentCountValue__'+currentCountValue);
		//List<Procedure__c> editProcedureList = [select Ultrasound__c, TrialPatient__c, Stereotactic__c, Procedure_Name__c, Post_Surgery_Summary__c, Palpation_guided__c, On_Study_Pathology_Form__c, Node_Type__c, Node_Result__c, Name, Mammography__c, MRI__c, Location__c, Laterality__c, Id, Form_Name__c, Date_Of_Procedure__c from Procedure__c where Id =:procedureIdValue];
		//system.debug('__editProcedureList__'+editProcedureList);
		/*if(!editProcedureList.isEmpty()) {
			editProcedure = editProcedureList[0];
			editProcedure.Form_Name__c = editProcedureList[0].Form_Name__c;
		}*/
		for(WrapForSrno tmpWrap : wrapList) {
			if(tmpWrap.srno == currentCountValue) {
				tmpWrap.isEditMode = true;
				tmpWrap.isUpdateMode = true;
			}
		}
		system.debug('__wrapList__'+wrapList);
	}
	
	public void updateProcedure() {
		String procedureIdValue = Apexpages.currentPage().getParameters().get('procedureId');
		List<Procedure__c> updateProcedureList = new List<Procedure__c>();
		for(WrapForSrno tmpWrap : wrapList) {
			if(tmpWrap.pro.Id == procedureIdValue) {
				tmpWrap.isEditMode = false;
				tmpWrap.isUpdateMode = false;
				if(tmpWrap.pro.Procedure_Name__c == 'Core biopsy') {
					tmpWrap.proScanCheckString = '';
						if(tmpWrap.pro.Ultrasound__c) {
							tmpWrap.proScanCheckString+='Ultrasound, ';
						}
						
						if(tmpWrap.pro.Palpation_guided__c) {
							tmpWrap.proScanCheckString+='Palpation guided, ';
						}
						
						if(tmpWrap.pro.Mammography__c) {
							tmpWrap.proScanCheckString+='Mammography, ';
						}
						
						if(tmpWrap.pro.MRI__c) {
							tmpWrap.proScanCheckString+='MRI, ';
						}
						
						if(tmpWrap.pro.Stereotactic__c) {
							tmpWrap.proScanCheckString+='Stereotactic, ';
						}
						
						system.debug('__tmpWrap.proScanCheckString__'+tmpWrap.proScanCheckString);
						if(tmpWrap.proScanCheckString != '') {
							tmpWrap.proScanCheckString = '('+tmpWrap.proScanCheckString.substring(0, tmpWrap.proScanCheckString.length()-2)+')';
						}
					}
					
					if(tmpWrap.pro.Procedure_Name__c == 'Core biopsy (lymph node)') {
						tmpWrap.proLymphScanCheckString = '';
						if(tmpWrap.pro.Ultrasound__c) {
							tmpWrap.proLymphScanCheckString+='Ultrasound, ';
						}
						
						if(tmpWrap.pro.Palpation_guided__c) {
							tmpWrap.proLymphScanCheckString+='Palpation guided, ';
						}
						
						if(tmpWrap.pro.Mammography__c) {
							tmpWrap.proLymphScanCheckString+='Mammography, ';
						}
						
						if(tmpWrap.pro.MRI__c) {
							tmpWrap.proLymphScanCheckString+='MRI, ';
						}
						
						if(tmpWrap.pro.Stereotactic__c) {
							tmpWrap.proLymphScanCheckString+='Stereotactic, ';
						}
						
						system.debug('__tmpWrap.proLymphScanCheckString__'+tmpWrap.proLymphScanCheckString);
						if(tmpWrap.proLymphScanCheckString != '') {
							tmpWrap.proLymphScanCheckString = '('+tmpWrap.proLymphScanCheckString.substring(0, tmpWrap.proLymphScanCheckString.length()-2)+')';
						}
					}
				updateProcedureList.add(tmpWrap.pro);
			}
		}
		system.debug('__wrapListUpdate__'+wrapList);
		system.debug('__updateProcedureList__'+updateProcedureList);
		if(!updateProcedureList.isEmpty()) {
			update updateProcedureList;
		}
		/*
		system.debug('__editProcedure__'+editProcedure);
		update editProcedure;
		
		List<String> ProcedureIdList = insertedIds.split('\\,');
		Set<Id> ProcedureIdSet = new Set<Id>();
		for(String tmpList : ProcedureIdList) {
			ProcedureIdSet.add(tmpList);
		}
		system.debug('__ProcedureIdSet__'+ProcedureIdSet);
		
		List<Procedure__c> tmpProcedureList = [select Ultrasound__c, TrialPatient__c, Stereotactic__c, Procedure_Name__c, Post_Surgery_Summary__c, Palpation_guided__c, On_Study_Pathology_Form__c, Node_Type__c, Node_Result__c, Name, Mammography__c, MRI__c, Location__c, Laterality__c, Id, Form_Name__c, Date_Of_Procedure__c from Procedure__c where Id IN :ProcedureIdSet];
		wrapList.clear();
		system.debug('__tmpProcedureList__'+tmpProcedureList);
		
		for(Procedure__c tmpObj : tmpProcedureList) {
			WrapForSrno tmpWrapObj = new WrapForSrno();
			tmpWrapObj.pro = tmpObj;
			tmpWrapObj.isEditMode = false;
			
			if(wrapList.size() == 0) {
				tmpWrapObj.srno = serialNumber;
			} else {
				tmpWrapObj.srno = wrapList.size() + 1;
			}
			wrapList.add(tmpWrapObj);  
		}
		system.debug('__wrapList__'+wrapList);
		isShowSaveButton = false;*/
	}
	
	public void updateCancelProcedure() {
		Integer currentCountValue = Integer.valueOf(Apexpages.currentPage().getParameters().get('serial'));
		String procedureIdValue = Apexpages.currentPage().getParameters().get('procedureId');
		
		List<Procedure__c> tmpProList = [select Procedure_Name__c, Laterality__c, Location__c, Node_Result__c, Mammography__c, MRI__c, Palpation_guided__c, Stereotactic__c, Ultrasound__c from Procedure__c where Id =:procedureIdValue];
		
		for(WrapForSrno tmpWrap : wrapList) {
			if(tmpWrap.srno == currentCountValue) {
				if(!tmpProList.isEmpty()) {
					tmpWrap.pro.Procedure_Name__c = tmpProList[0].Procedure_Name__c;
					tmpWrap.pro.Laterality__c = tmpProList[0].Laterality__c;
					tmpWrap.pro.Location__c = tmpProList[0].Location__c;
					tmpWrap.pro.Node_Result__c = tmpProList[0].Node_Result__c;
					tmpWrap.pro.Mammography__c = tmpProList[0].Mammography__c;
					tmpWrap.pro.MRI__c = tmpProList[0].MRI__c;
					tmpWrap.pro.Palpation_guided__c = tmpProList[0].Palpation_guided__c;
					tmpWrap.pro.Stereotactic__c = tmpProList[0].Stereotactic__c;
					tmpWrap.pro.Ultrasound__c = tmpProList[0].Ultrasound__c;
				}
				tmpWrap.isEditMode = false;
				tmpWrap.isUpdateMode = false;
			}
		}
		system.debug('__wrapList__'+wrapList);
	}
	/*
	public void saveProcedure() {
		List<Procedure__c> insertProcedureList = new List<Procedure__c>();
		system.debug('__wrapList__'+wrapList);
		for(WrapForSrno tmpProcObj : wrapList) {
			if(tmpProcObj.pro.Procedure_Name__c!=null && tmpProcObj.pro.Procedure_Name__c!='') {
				insertProcedureList.add(tmpProcObj.pro);
			}
		}
		
		if(!insertProcedureList.isEmpty()) {
			insert insertProcedureList;
		}
		
		if(insertedIds!='') {
			insertedIds = insertedIds+',';
		}
		
		system.debug('__insertProcedureList__'+insertProcedureList);
		for(Procedure__c tmpProcObj : insertProcedureList) {
			procedureIds.add(tmpProcObj.Id);
			insertedIds+= tmpProcObj.Id+',';
		}
		
		system.debug('__insertedIds__'+insertedIds);
		if(insertedIds!=null && insertedIds!='') {
			
			insertedIds = insertedIds.substring(0, insertedIds.length()-1);
		}
		showProcedureList = [select Ultrasound__c, TrialPatient__c, Stereotactic__c, Procedure_Name__c, Post_Surgery_Summary__c, Palpation_guided__c, On_Study_Pathology_Form__c, Node_Type__c, Node_Result__c, Name, Mammography__c, MRI__c, Location__c, Laterality__c, Id, Form_Name__c, Date_Of_Procedure__c from Procedure__c where Id IN :procedureIds];
		wrapList.clear();
		isShowSaveButton = false;
	}
	
	public void addProcedureRow() {
		//Integer currentCountValue = Integer.valueOf(Apexpages.currentPage().getParameters().get('count'));
		//system.debug('__currentCountValue__'+currentCountValue);
		String subFormValue = Apexpages.currentPage().getParameters().get('subForm');
		String procedureIdValue = Apexpages.currentPage().getParameters().get('procedureId');
		system.debug('__subFormValue__'+subFormValue);
		system.debug('__procedureIdValue__'+procedureIdValue);
		
		WrapForSrno wrapObj = new WrapForSrno(); 
		isShowSaveButton = true;
		if(procedureIdValue != null && procedureIdValue != '') {
			for(Procedure__c tmpProcObj : showProcedureList) {
				if(tmpProcObj.Id == procedureIdValue) {
					proObj = tmpProcObj;
					break;
				}
			}
		}
		else {
			proObj = new Procedure__c();
			proObj.TrialPatient__c = trialPatientId;
			if(formNameValue!='OnStudy Pathology') {
				proObj.Form_Name__c = formNameValue;
			}
			else {
				if(subFormValue!=null && subFormValue!='') {
					proObj.Form_Name__c = subFormValue;
				}
			}
		}
		system.debug('__proObj__'+proObj);
		//addProcedureList.add(proObj);
		
		wrapObj.pro = proObj;
		if(wrapList.size() == 0) {
			wrapObj.srno = serialNumber;
		} else {
			wrapObj.srno = wrapList.size() + 1;
		}
		wrapList.add(wrapObj);
		system.debug('__srno__'+wrapObj.srno);
		
		//countProcedure = currentCountValue++;
	}
	
	public void cancelProcedure() {
		Integer currentCountValue = Integer.valueOf(Apexpages.currentPage().getParameters().get('serial'));
		system.debug('__currentCountValue__'+currentCountValue);
		wrapList.remove(currentCountValue-1);
		
		Integer counter = 1;
		//List<WrapForSrno> updatedWrapList = new List<WrapForSrno>();
		for(WrapForSrno tmpWrap : wrapList) {
			//WrapForSrno wrapObj = new WrapForSrno();
			//tmpWrap.pro = tmpWrap.pro;
			tmpWrap.srno = counter;
			//updatedWrapList.add(wrapObj);
			counter++;
		}
		system.debug('__wrapList__'+wrapList.Size());
		if(wrapList.isEmpty()) {
			isShowSaveButton = false;
		}
		//wrapList = updatedWrapList;
	}
	*/
	
	
	public class WrapForSrno {
		public Procedure__c pro {get; set;}
        public integer srno {get; set;}
        public Boolean isEditMode {get;set;}
        public Boolean isUpdateMode {get;set;}
        public Boolean isShowEditButton{get;set;}
        public String proScanCheckString{get;set;} //==============this should be a comma seperated string of Scan done===============
		public String proLymphScanCheckString{get;set;} //==============this should be a comma seperated string of lymph Scan done===============
        
        public WrapForSrno() {
        	isEditMode = false;
        	isUpdateMode = false;
        	isShowEditButton = false;
        	proScanCheckString = '';
        	proLymphScanCheckString = '';
        }
	}
}