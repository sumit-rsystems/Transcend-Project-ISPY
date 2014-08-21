public with sharing class patientsViewTab {
	public List<Patient_Custom__c> patientList{get;set;}
	public String strSearch{get;set;}
	public string ascDesc{get;set;}
	public string orderBy{get;set;}
	
	public Set<Id> setPatientId{get;set;}
	public Map<Integer,Set<Id>> mapPageNumberSetId {get;set;}
	
	public Integer lastInsertPageNumber{get;set;}
	public Integer currentPageNumber{get;set;}
	public List<SelectOption> lstPageNumber{get;set;}
	public Boolean isPreviousDisable{get;set;}
	public Boolean isNextDisable{get;set;}
	public Integer fromRecord{get;set;}
	public Integer toRecord{get;set;}
	public Integer totalRecord{get;set;}
	public Boolean hasRecords{get;set;}
	public String strSearchName{get;set;}

	public patientsViewTab(){			
		ascDesc = 'asc';
		orderBy = 'Name';
		ReviewSearch();	
	}
	
	public void ReviewSearch(){						 			
		String strQuery = 'Select p.Status__c, p.Name, p.Institution__r.Name, p.Institution__c From Patient_Custom__c p';
		system.debug('MitulQuery-----------------'+strQuery);
		List<Patient_Custom__c> lstProperty = Database.query(strQuery);		
		if(lstProperty.size() > 0){
			BuildPagination(lstProperty);
			hasRecords = true;
		}
		else{
			patientList = new List<Patient_Custom__c>();
			hasRecords = false;
			isPreviousDisable = false;
			isNextDisable = false;
		}						
	}
	
	public void BuildPagination(List<Patient_Custom__c> lstPatient){
		setPatientId = new Set<Id>();
		mapPageNumberSetId = new Map<Integer,Set<Id>>();
		lstPageNumber = new List<SelectOption>();
		
		lastInsertPageNumber = 1;
		currentPageNumber = 1;
		isNextDisable = false;
		isPreviousDisable = false;	
		
		fromRecord = 0;
		toRecord = 0;
		totalRecord = lstPatient.size();	
		
		for(Patient_Custom__c property : lstPatient){
			if(setPatientId.size() < 19){
				setPatientId.add(property.Id);	
			}
			else{
				setPatientId.add(property.Id);
				mapPageNumberSetId.put(lastInsertPageNumber,setPatientId);
				lastInsertPageNumber++;
				setPatientId = new Set<Id>();
			}						
		}
		if(setPatientId.size() != 0 && setPatientId.size() < 25){
			mapPageNumberSetId.put(lastInsertPageNumber,setPatientId);
		}		
		PreparePageNumberList();
		GetCurrentPatientList();
	}
	
	public void GetCurrentPatientList(){		
		Set<Id> setCurrentPatientId = mapPageNumberSetId.get(currentPageNumber);
		String strpatId = '(';
		for(Id id : setCurrentPatientId){
			if(strpatId == '('){
				strpatId += '\''+id+'\'';
			}
			else{
				strpatId += ','+'\''+id+'\'';
			}
		}
		strpatId += ')';
		String query = 'Select p.Status__c, p.Name, p.Institution__r.Name, p.Institution__c From Patient_Custom__c p where Id In '+strpatId;
		query += ' order by '+orderBy+' '+ascDesc;
		system.debug('-------------------Mitul query print----------- : '+query);
		patientList = Database.query(query);
		checkPreviousDisable();
		checkNextDisable();	
		PrintPageRecordDetail();	
	}
	public void PreparePageNumberList(){
		for(Integer i=1;i<=mapPageNumberSetId.size();i++){
			lstPageNumber.add(new SelectOption(string.valueof(i),string.valueof(i)));	
		}		
	}
	public void GoToPageNumber(){ 
		GetCurrentPatientList();
	}
	public void GoToFirstPage(){
		currentPageNumber = 1;
		GetCurrentPatientList();	
	} 
	public void GoToNextPage(){
		currentPageNumber++;
		GetCurrentPatientList();
	}
	public void GoToPreviousPage(){
		currentPageNumber--;
		GetCurrentPatientList();	
	}
	public void GoToLastPage(){
		currentPageNumber = mapPageNumberSetId.size();
		GetCurrentPatientList();
	}	
	public void checkPreviousDisable(){
		if(currentPageNumber == 1){
			isPreviousDisable = false;	
		}			
		else{
			isPreviousDisable = true;
		}
	}
	
	public void checkNextDisable(){
		if(currentPageNumber == mapPageNumberSetId.size()){
			isNextDisable = false;
		}
		else{
			isNextDisable = true;
		}
	}
	
	public void PrintPageRecordDetail(){
		system.debug('---------currentPageNumber----------'+currentPageNumber);	
		if(currentPageNumber == mapPageNumberSetId.size() && currentPageNumber != 1){
			toRecord = totalRecord;
			fromRecord = ((mapPageNumberSetId.size() -1)*20) + 1; 			
		}
		else if(currentPageNumber == mapPageNumberSetId.size() && currentPageNumber == 1){
			fromRecord = 1;
			toRecord = ((mapPageNumberSetId.size() -1)*20) + mapPageNumberSetId.get(mapPageNumberSetId.size()).size();			
		}	
		else{
			fromRecord = (currentPageNumber * mapPageNumberSetId.get(currentPageNumber).size()) - 19;
			toRecord = (currentPageNumber * mapPageNumberSetId.get(currentPageNumber).size());			
		}		
	}
		
}