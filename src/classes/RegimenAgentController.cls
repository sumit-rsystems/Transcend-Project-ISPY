public with sharing class RegimenAgentController extends ComponentControllerBase {
	
	public String regimenName {get;set;}
	public String trialPatientId {get;set;}
	public String chemoSummaryId {get;set;}
	
	public Date firstDate {get;set;}
	public Date lastDate {get;set;}
	public ChemoSummaryRegimenDetail__c chemoSummaryRegimenDetail {get;set;}
	public RegimenDetailWrapper regimenDetailWrapper;
	public List<List<AgentCollectionWrapper>> lstAgentCollectionWrapperForPage {get;set;}
	public List<SelectOption> treatmentEndReasonList{get;set;}
	
	private static Map<String, Agent__c> agentMap = new Map<String, Agent__c>();
	static {
		List<Agent__c> lstAgent = [select Name, Frequency__c, Total_Dose_Unit__c from Agent__c];
		for(Agent__c agent : lstAgent) {
			agentMap.put(agent.Id, agent);
		}
	}
	
	public String getKey() {
		return key;
	}
	
	public void setKey(String value) {
		if(value!= null){
         Key  = value;
         if(pageController!= null)
            pageController.setComponentControllerMap(Key, this);
      	}
	}
	
	public void setPageController(PageControllerBase value) {
		if (value!= null) {
			pageController = value;
			pageController.setAddQuesComponentController(this);
	    }
	}
	
	public PageControllerBase getPageController() {
		system.debug('pageController : '+pageController);
		return pageController;
	}
	
	public RegimenDetailWrapper getRegimenDetailWrapper() {
		
		List<AgentCollectionWrapper> lstACW = new List<AgentCollectionWrapper>();
		lstAgentCollectionWrapperForPage = new List<List<AgentCollectionWrapper>>();
		
		String cloneCalled = Apexpages.currentPage().getParameters().get('cloneCalled');
		system.debug('cloneCalled : '+cloneCalled);
		system.debug('regimenName : '+regimenName);
		system.debug('trialPatientId : '+trialPatientId);
		system.debug('chemoSummaryId : '+chemoSummaryId+'_');
		
		if(cloneCalled == 'true') {
			return new RegimenDetailWrapper();
		}
		
		treatmentEndReasonList = new List<SelectOption>();
		treatmentEndReasonList.add(new Selectoption('Treatment completed per protocol criteria','Treatment completed per protocol criteria'));
		treatmentEndReasonList.add(new Selectoption('Disease progression, relapse during active treatment','Disease progression, relapse during active treatment'));
		treatmentEndReasonList.add(new Selectoption('Toxicity/side effects/complications','Toxicity/side effects/complications'));
		treatmentEndReasonList.add(new Selectoption('Patient withdrawal or refusal after beginning protocol therapy','Patient withdrawal or refusal after beginning protocol therapy'));
		treatmentEndReasonList.add(new Selectoption('Patient withdrawal or refusal prior to beginning protocol therapy','Patient withdrawal or refusal prior to beginning protocol therapy'));
		treatmentEndReasonList.add(new Selectoption('Other complicating disease','Other complicating disease'));
		treatmentEndReasonList.add(new Selectoption('Death during treatment','Death during treatment'));
		treatmentEndReasonList.add(new Selectoption('Alternative therapy','Alternative therapy'));
		treatmentEndReasonList.add(new Selectoption('Patient declared ineligible','Patient declared ineligible'));
		treatmentEndReasonList.add(new Selectoption('Other','Other'));
		
		List<ChemoSummaryRegimenDetail__c> lstChemoSummaryRegDetail = [Select c.Treatment_End_Reasons__c, c.Other_Reason__c, c.Last_Date_of_Therapy__c, c.Id, c.First_Date_of_Therapy__c, c.Chemo_Summary_Form__c, c.Chemo_Regimen__r.Name, c.Chemo_Regimen__c From ChemoSummaryRegimenDetail__c c where Chemo_Summary_Form__c = :chemoSummaryId];
		//system.debug('Select c.Treatment_End_Reasons__c, c.Other_Reason__c, c.Last_Date_of_Therapy__c, c.Id, c.First_Date_of_Therapy__c, c.Chemo_Summary_Form__c, c.Chemo_Regimen__r.Name, c.Chemo_Regimen__c From ChemoSummaryRegimenDetail__c c where Chemo_Summary_Form__c = \''+chemoSummaryId+'\'');
		//List<ChemoSummaryRegimenDetail__c> lstChemoSummaryRegDetail1 = database.query('Select c.Treatment_End_Reasons__c, c.Other_Reason__c, c.Last_Date_of_Therapy__c, c.Id, c.First_Date_of_Therapy__c, c.Chemo_Summary_Form__c, c.Chemo_Regimen__r.Name, c.Chemo_Regimen__c From ChemoSummaryRegimenDetail__c c where Chemo_Summary_Form__c = \''+chemoSummaryId+'\'');
		
		system.debug('lstChemoSummaryRegDetail : '+lstChemoSummaryRegDetail);
		for(ChemoSummaryRegimenDetail__c csrd : lstChemoSummaryRegDetail) {
			system.debug('regimenName : '+regimenName+'  and csrd.Chemo_Regimen__r.Name : '+csrd.Chemo_Regimen__r.Name);
			if(csrd.Chemo_Regimen__r.Name == regimenName || csrd.Chemo_Regimen__r.Name == null) {
				chemoSummaryRegimenDetail = csrd;
				break;
			}
		}
		system.debug('chemoSummaryRegimenDetail : '+chemoSummaryRegimenDetail);
		regimenDetailWrapper = new RegimenDetailWrapper();
		
		system.debug('chemoSummaryId :'+chemoSummaryId);
		system.debug('chemoSummaryRegimenDetail :'+chemoSummaryRegimenDetail);
		
		
		Set<Id> agentIds = new Set<Id>();
		if(regimenName != null) {
			
			List<Chemo_Regimen_Agent__c> lstChemoRegimenAgent = [Select c.Chemo_Regimen__r.Name, c.Chemo_Regimen__c, c.Agent__c From Chemo_Regimen_Agent__c c where Chemo_Regimen__r.Name = :regimenName];
			for(Chemo_Regimen_Agent__c cra : lstChemoRegimenAgent) {
				agentIds.add(cra.Agent__c);
			}
		}
		
		Map<Id, AgentCollectionWrapper> mapAgentCollectionWrapper = new Map<Id, AgentCollectionWrapper>(); 
		Map<String, AgentCollectionWrapper> mapOtherAgentCollectionWrapper = new Map<String, AgentCollectionWrapper>();
		List<Chemo_Treatment__c> lstChemoTreatment = [Select c.TrialPatient__c, c.Status__c, c.Date_of_therapy__c, c.Cycle_number__c, (Select Prescribed_Dose__c, Total_Dose__c, Day__c, Dose_Delay__c, Agent__c, Dose_Mod__c, Other_Agent__c, Dose_modification__c, Administered_dose_Units__c, Other_Dose_Mod_Reason__c From Chemo_Therapy_Regimens__r) From Chemo_Treatment__c c where TrialPatient__c =:trialPatientId order by Date_of_therapy__c ASC]; 
		if(trialPatientId != null && regimenName != 'Other') { //IF regimen name is other then we have to show all other regimen in other tab
			
			integer countForm = 0;
			List<AgentCollectionWrapper> lstAgentCollectionWrapper = new List<AgentCollectionWrapper>();
			for(Chemo_Treatment__c chemoTreatment : lstChemoTreatment) {
				
				List<Chemo_Therapy_Regimen__c> lstChemoTherapyRegimen = chemoTreatment.Chemo_Therapy_Regimens__r;
				for(Chemo_Therapy_Regimen__c chemoTherapy : lstChemoTherapyRegimen) {
					if(chemoTherapy.Agent__c == null) continue;
					if(!agentIds.contains(chemoTherapy.Agent__c)) continue;
					if(countForm == 0) {
						regimenDetailWrapper.firstDate = chemoTreatment.Date_of_therapy__c;
						system.debug('regimenDetailWrapper.firstDate : '+regimenDetailWrapper.firstDate);
						++countForm;
					}
					regimenDetailWrapper.lastDate = chemoTreatment.Date_of_therapy__c;
					system.debug('regimenDetailWrapper.lastDate : '+regimenDetailWrapper.lastDate);
					
					if(mapAgentCollectionWrapper.containsKey(chemoTherapy.Agent__c)) {
						AgentCollectionWrapper existWrapper = mapAgentCollectionWrapper.get(chemoTherapy.Agent__c);
						system.debug('existWrapper.totalDose : '+existWrapper.totalDose);
						if(chemoTherapy.Total_Dose__c == null) {
							chemoTherapy.Total_Dose__c = 0.0;
						}
						if(existWrapper.totalDose != null) {
							existWrapper.totalDose = String.valueOf((Decimal.valueOf(existWrapper.totalDose) + chemoTherapy.Total_Dose__c));
						}
						if(chemoTherapy.Agent__c != null) {
							existWrapper.totalDoseUnit = agentMap.get(chemoTherapy.Agent__c).Total_Dose_Unit__c;
						}
						existWrapper.completedCycle = String.valueOf(Decimal.valueOf(existWrapper.completedCycle) + 1);
						if(chemoTherapy.Dose_Delay__c == 'Yes') {
							existWrapper.doseDelay = 'Yes';
						}
						
						if(chemoTherapy.Dose_modification__c != existWrapper.doseMod && chemoTherapy.Dose_modification__c != 'No dose modification') {
							existWrapper.doseMod = chemoTherapy.Dose_modification__c==null||chemoTherapy.Dose_modification__c=='null'?'No dose modification':chemoTherapy.Dose_modification__c;
							existWrapper.doseMod = existWrapper.doseMod=='Other'?'Other-'+chemoTherapy.Other_Dose_Mod_Reason__c:existWrapper.doseMod;
						}
						system.debug('Dose Modification : '+chemoTherapy.Dose_modification__c);
					} else {
						
						AgentCollectionWrapper agCollWrapper = new AgentCollectionWrapper();
						agCollWrapper.agentName = agentMap.get(chemoTherapy.Agent__c).Name;
						agCollWrapper.treatmentSchedule = agentMap.get(chemoTherapy.Agent__c).Frequency__c;
						agCollWrapper.completedCycle = '1';
						//regimenDetailWrapper.doseMod = ;
						if(chemoTherapy.Total_Dose__c != null) {
							agCollWrapper.totalDose = String.valueOf(chemoTherapy.Total_Dose__c);
							agCollWrapper.totalDoseUnit = agentMap.get(chemoTherapy.Agent__c).Total_Dose_Unit__c;
						}
						
						if(chemoTreatment.Cycle_number__c == 1) {
							agCollWrapper.cycle1Dose = String.valueOf(chemoTherapy.Prescribed_Dose__c);
							agCollWrapper.doseMod = String.valueOf(chemoTherapy.Dose_Mod__c);
						}
						
						if(agCollWrapper.doseMod == null || agCollWrapper.doseMod == '') {
							agCollWrapper.doseMod = 'No dose modification';
						} else {
							agCollWrapper.doseMod = String.valueOf(chemoTherapy.Dose_modification__c); 
							agCollWrapper.doseMod = agCollWrapper.doseMod=='Other'?'Other-'+chemoTherapy.Other_Dose_Mod_Reason__c:agCollWrapper.doseMod;
						}
						
						if(agCollWrapper.cycle1Dose == null) {
							agCollWrapper.cycle1Dose = 'N/A';
						}
						
						if(chemoTherapy.Dose_Delay__c == 'Yes') {
							agCollWrapper.doseDelay = 'Yes';
						}
						
						mapAgentCollectionWrapper.put(chemoTherapy.Agent__c, agCollWrapper);
					}
				}				
			}
			
			Set<Id> agentIdSet = mapAgentCollectionWrapper.keySet();
			for(Id id : agentIdSet) {
				lstAgentCollectionWrapper.add(mapAgentCollectionWrapper.get(id));
				lstACW.add(mapAgentCollectionWrapper.get(id));
				if(lstACW.size() == 2) {
					regimenDetailWrapper.lstAgentCollectionWrapperForPage.add(lstACW);
					lstACW = new List<AgentCollectionWrapper>();
				}
			}
			if(!lstACW.isEmpty()) {
				regimenDetailWrapper.lstAgentCollectionWrapperForPage.add(lstACW);
			}
			regimenDetailWrapper.lstAgentCollectionWrapper = lstAgentCollectionWrapper;
			
		} else if(regimenName == 'Other'){
			//List<Chemo_Treatment__c> lstChemoTreatment = [Select c.TrialPatient__c, c.Status__c, c.Date_of_therapy__c, c.Cycle_number__c, (Select Prescribed_Dose__c, Total_Dose__c, Day__c, Dose_Delay__c, Agent__c, Dose_Mod__c, Other_Agent__c, Administered_dose_Units__c, Dose_modification__c  From Chemo_Therapy_Regimens__r where Agent__c = null or Agent__c ='') From Chemo_Treatment__c c where TrialPatient__c =:trialPatientId order by Date_of_therapy__c ASC];
			integer countForm = 0;
			List<AgentCollectionWrapper> lstAgentCollectionWrapper = new List<AgentCollectionWrapper>();
			for(Chemo_Treatment__c chemoTreatment : lstChemoTreatment) {
				
				List<Chemo_Therapy_Regimen__c> lstChemoTherapyRegimen = chemoTreatment.Chemo_Therapy_Regimens__r;
				for(Chemo_Therapy_Regimen__c chemoTherapy : lstChemoTherapyRegimen) {
					if(chemoTherapy.Agent__c != null) continue;	
					if(countForm == 0) {
						regimenDetailWrapper.firstDate = chemoTreatment.Date_of_therapy__c;
						++countForm;
					}
					regimenDetailWrapper.lastDate = chemoTreatment.Date_of_therapy__c;
					
					if(mapOtherAgentCollectionWrapper.containsKey(chemoTherapy.Other_agent__c)) {
						AgentCollectionWrapper existWrapper = mapOtherAgentCollectionWrapper.get(chemoTherapy.Other_agent__c);
						if(existWrapper.totalDose != null) {
							existWrapper.totalDose = String.valueOf((Decimal.valueOf(existWrapper.totalDose) + chemoTherapy.Total_Dose__c));
						}
						if(agentMap.get(chemoTherapy.Other_agent__c) != null) {
							existWrapper.totalDoseUnit = agentMap.get(chemoTherapy.Other_agent__c).Total_Dose_Unit__c;
						}
						existWrapper.completedCycle = String.valueOf(Decimal.valueOf(existWrapper.completedCycle) + 1);
						if(chemoTherapy.Dose_Delay__c == 'Yes') {
							existWrapper.doseDelay = 'Yes';
						}
						
						if(chemoTherapy.Dose_modification__c != existWrapper.doseMod && chemoTherapy.Dose_modification__c != 'No dose modification') {
							existWrapper.doseMod = chemoTherapy.Dose_modification__c;
							existWrapper.doseMod = chemoTherapy.Dose_modification__c==null||chemoTherapy.Dose_modification__c=='null'?'No dose modification':chemoTherapy.Dose_modification__c;
							existWrapper.doseMod = existWrapper.doseMod=='Other'?'Other-'+chemoTherapy.Other_Dose_Mod_Reason__c:existWrapper.doseMod;
						}
						
						system.debug('Dose Modification : '+chemoTherapy.Dose_modification__c);
					} else {
						
						AgentCollectionWrapper agCollWrapper = new AgentCollectionWrapper();
						agCollWrapper.agentName = chemoTherapy.Other_agent__c;
						agCollWrapper.treatmentSchedule = '';
						agCollWrapper.completedCycle = '1';
						//regimenDetailWrapper.doseMod = ;
						if(chemoTherapy.Total_Dose__c != null) {
							agCollWrapper.totalDose = String.valueOf(chemoTherapy.Total_Dose__c);
							agCollWrapper.totalDoseUnit = chemoTherapy.Administered_dose_Units__c;
						}
						
						if(chemoTreatment.Cycle_number__c == 1) {
							agCollWrapper.cycle1Dose = String.valueOf(chemoTherapy.Prescribed_Dose__c);
						}
						
						if(agCollWrapper.doseMod == null || agCollWrapper.doseMod == '') {
							agCollWrapper.doseMod = 'No dose modification';
						} else {
							agCollWrapper.doseMod = String.valueOf(chemoTherapy.Dose_modification__c);
							agCollWrapper.doseMod = agCollWrapper.doseMod=='Other'?'Other-'+chemoTherapy.Other_Dose_Mod_Reason__c:agCollWrapper.doseMod; 
						}
						
						system.debug('Dose Modification : '+chemoTherapy.Dose_modification__c);
						
						if(agCollWrapper.cycle1Dose == null) {
							agCollWrapper.cycle1Dose = 'N/A';
						}
						
						if(chemoTherapy.Dose_Delay__c == 'Yes') {
							agCollWrapper.doseDelay = 'Yes';
						}
						
						mapOtherAgentCollectionWrapper.put(chemoTherapy.Other_agent__c, agCollWrapper);
					}
				}				
			}
			
			Set<String> agentIdSet = mapOtherAgentCollectionWrapper.keySet();
			for(String id : agentIdSet) {
				lstAgentCollectionWrapper.add(mapOtherAgentCollectionWrapper.get(id));
				lstACW.add(mapOtherAgentCollectionWrapper.get(id));
				if(lstACW.size() == 2) {
					regimenDetailWrapper.lstAgentCollectionWrapperForPage.add(lstACW);
					lstACW = new List<AgentCollectionWrapper>();
				}
			}
			if(!lstACW.isEmpty()) {
				regimenDetailWrapper.lstAgentCollectionWrapperForPage.add(lstACW);
			}
			regimenDetailWrapper.lstAgentCollectionWrapper = lstAgentCollectionWrapper;
		}
		if(chemoSummaryRegimenDetail == null) {
			chemoSummaryRegimenDetail = new ChemoSummaryRegimenDetail__c();
			 
		} else {
			system.debug('chemoSummaryRegimenDetail.Treatment_End_Reasons__c : '+chemoSummaryRegimenDetail.Treatment_End_Reasons__c);
			//regimenDetailWrapper.firstDate = chemoSummaryRegimenDetail.First_Date_of_Therapy__c;
			//regimenDetailWrapper.lastDate = chemoSummaryRegimenDetail.Last_Date_of_Therapy__c;
			regimenDetailWrapper.reason = chemoSummaryRegimenDetail.Treatment_End_Reasons__c;
			regimenDetailWrapper.otherReason = chemoSummaryRegimenDetail.Other_Reason__c;
			//regimenDetailWrapper. = chemoSummaryRegimenDetail.First_Date_of_Therapy__c;
		}
		return regimenDetailWrapper;
	}
	
	public void setRegimenDetailWrapper(RegimenDetailWrapper regimenDetailWrapper) {
		
		this.regimenDetailWrapper = regimenDetailWrapper;
	}
	
	public void saveComponent(Id id, String regimen) {
		
		system.debug('saveComponent : regimen : '+regimen);
		system.debug('saveComponent : id : '+id);
		system.debug('saveComponent : regimenName : '+regimenName);
		system.debug('regimenDetailWrapper.reason : '+regimenDetailWrapper.reason);
		system.debug('regimenDetailWrapper.firstDate : '+regimenDetailWrapper.firstDate);
		system.debug('regimenDetailWrapper.lastDate : '+regimenDetailWrapper.lastDate);
		List<ChemoSummaryRegimenDetail__c> lstChemoSummaryRegDetail = [Select c.Treatment_End_Reasons__c, c.Other_Reason__c, c.Last_Date_of_Therapy__c, c.Id, c.First_Date_of_Therapy__c, c.Chemo_Summary_Form__c, c.Chemo_Regimen__r.Name, c.Chemo_Regimen__c From ChemoSummaryRegimenDetail__c c where Chemo_Summary_Form__c = :id and Chemo_Regimen__r.Name = :regimenName];
		if(!lstChemoSummaryRegDetail.isEmpty()) {
			system.debug('Getting Regimen From Query : ');
			chemoSummaryRegimenDetail = lstChemoSummaryRegDetail[0];
		} else {
			system.debug('Creating new instance of agent : ');
			chemoSummaryRegimenDetail = new ChemoSummaryRegimenDetail__c();
		}
		if(regimen == regimenName) {
			List<Chemo_Regimen__c> lstChemoRegimen = [select Id from Chemo_Regimen__c where Name = :regimenName];
			if(!lstChemoRegimen.isEmpty()) {
				chemoSummaryRegimenDetail.Chemo_Regimen__c = lstChemoRegimen[0].Id;
			}
			chemoSummaryRegimenDetail.First_Date_of_Therapy__c = regimenDetailWrapper.firstDate;
			chemoSummaryRegimenDetail.Last_Date_of_Therapy__c = regimenDetailWrapper.lastDate;
			chemoSummaryRegimenDetail.Treatment_End_Reasons__c = regimenDetailWrapper.reason;
			chemoSummaryRegimenDetail.Other_Reason__c = regimenDetailWrapper.otherReason;
			chemoSummaryRegimenDetail.Chemo_Summary_Form__c = id;
			system.debug('chemoSummaryRegimenDetail : '+chemoSummaryRegimenDetail);
			upsert chemoSummaryRegimenDetail;
		}
		/*List<ChemoSummaryAgentDetail__c> lstChemoSummaryAgentDetails = [Select c.treatmentSchedule__c, c.totalDose__c, c.totalDoseUnit__c, c.doseMod__c, c.doseDelay__c, c.cycle1Dose__c, c.completedCycle__c, c.Name, c.Id, c.ChemoSummaryRegimenDetail__c, c.Agent__c From ChemoSummaryAgentDetail__c c where ChemoSummaryRegimenDetail__c =:chemoSummaryRegimenDetail.Id];
		if(lstChemoSummaryAgentDetails.isEmpty()) {
			for(AgentCollectionWrapper acw : regimenDetailWrapper.lstAgentCollectionWrapper) {
				ChemoSummaryAgentDetail__c chemoSummaryAgentDetial = new ChemoSummaryAgentDetail__c();
				chemoSummaryAgentDetial.Agent__c = acw.agentName;
				chemoSummaryAgentDetial.cycle1Dose__c = acw.cycle1Dose;
				chemoSummaryAgentDetial.completedCycle__c = acw.completedCycle;
				chemoSummaryAgentDetial.totalDose__c = acw.totalDose;
				chemoSummaryAgentDetial.totalDoseUnit__c = acw.totalDoseUnit;
				chemoSummaryAgentDetial.treatmentSchedule__c = acw.treatmentSchedule;
				chemoSummaryAgentDetial.doseDelay__c = acw.doseDelay;
				chemoSummaryAgentDetial.doseMod__c = acw.doseMod;
				chemoSummaryAgentDetial.ChemoSummaryRegimenDetail__c = chemoSummaryRegimenDetail.Id;
				lstChemoSummaryAgentDetails.add(chemoSummaryAgentDetial);
			}
		}
		system.debug('lstChemoSummaryAgentDetails---'+lstChemoSummaryAgentDetails);
		//upsert lstChemoSummaryAgentDetails;*/
		chemoSummaryId = id;
	}
	
	public class RegimenDetailWrapper {
		
		public String regimenName {get;set;}
		public Date firstDate {get;set;}
		public Date lastDate {get;set;}
		public String reason {get;set;}
		public String otherReason {get;set;}
		public List<AgentCollectionWrapper> lstAgentCollectionWrapper {get;set;}
		public List<List<AgentCollectionWrapper>> lstAgentCollectionWrapperForPage {get;set;}
		public RegimenDetailWrapper() {
			lstAgentCollectionWrapper = new List<AgentCollectionWrapper>();
			lstAgentCollectionWrapperForPage = new List<List<AgentCollectionWrapper>>();
		}
	}
	
	public class AgentCollectionWrapper {
	
		public String agentName {get;set;}
		public String cycle1Dose {get;set;}
		public String completedCycle {get;set;}
		public String totalDose {get;set;}
		public String totalDoseUnit {get;set;}
		public String treatmentSchedule {get;set;}
		public String doseDelay {get;set;}
		public String doseMod {get;set;}
		
		public AgentCollectionWrapper() {
			doseDelay = 'No';
		}
	}
	
}