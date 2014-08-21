public with sharing class AdditionalQuestionController extends ComponentControllerBase {
	
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
	
	
	public String CRFType {get;set;}
	public String TrialPatientId {get;set;}
	public String armId {get;set;}
	public String Questiontype {get;set;}
	public String ansType {get;set;}
	public String question {get;set;}
	public String ans {get;set;}
	public String CRFId {get;set;}
	public Boolean isReadOnly {get;set;}
	public List<QuestionAnswerWrapper> lstQuesAnsWrapper;
	List<AnswerOption__c> lstAnsOption = new List<AnswerOption__c>();
	List<CRFAdditionalQuestion__c> lstCRFQues = new List<CRFAdditionalQuestion__c>();
	public boolean datafromPreviousCRF {get;set;}
	public AdditionalQuestionController() {
		
		system.debug('CRFType : '+CRFType);
	}
	public void setlstQuesAnsWrapper(List<QuestionAnswerWrapper> lstQuesAnsWrapper) {
		system.debug('From Component Setter lstQuesAnsWrapper : '+lstQuesAnsWrapper);
		this.lstQuesAnsWrapper = lstQuesAnsWrapper;
	}
	
	public List<QuestionAnswerWrapper> getlstQuesAnsWrapper() {
		lstQuesAnsWrapper = new List<QuestionAnswerWrapper>();
		system.debug('isReadOnly : '+isReadOnly);
		system.debug('lstQuesAnsWrapper inside get method() : '+lstQuesAnsWrapper);
		system.debug('CRFType : '+CRFType);
		system.debug('CRFId : '+CRFId);
		system.debug('armId : '+armId);
		system.debug('Questiontype : '+Questiontype);
		datafromPreviousCRF = false;
		
		List<CRFAdditionalQuestion__c> lstCRFAddQues = [Select c.QuestionAnswer__c, c.Id, c.CRFId__c, c.Answer__c, (Select QuestionId__c, Contextdata__c, ContextDataUnit__c, CRFAdditionalQuestion__c From AnswerOptions__r order by SNo__c ASC) From CRFAdditionalQuestion__c c where CRFId__c = :CRFId];
		System.debug('lstCRFAddQues------------------'+lstCRFAddQues);
		List<QuestionAnswer__c> lstQuestionAnswer = new List<QuestionAnswer__c>();
		List<Arm__c> lstArm = new List<Arm__c>();
		List<On_Study_Eligibility_Form__c> lstOSE = new List<On_Study_Eligibility_Form__c>();
		List<Lab_and_Test__c> lstLabAndTest = new List<Lab_and_Test__c>();
		if(armId != null && armId != '') {
			lstArm = [select id,Name from Arm__c where id = : armId];
			lstLabAndTest = [select CreatedDate from Lab_and_Test__c where Id =:CRFId];
		} else {
			lstOSE = [select CreatedDate from On_Study_Eligibility_Form__c where Id =:CRFId];
		}
		System.debug('-----lstArm----->'+lstArm);
		String[] agentName;
		if(!lstArm.isEmpty()){	
			agentName = lstArm[0].Name.split(' \\+ ');
		}
		System.debug('-----agentName----->'+agentName);
		set<Id> setIds = new set<Id>();
		List<Agent__c> lstAgent = new List<Agent__c>(); 
		if(agentName!= null && !agentName.isEmpty()){	
			lstAgent = [select id,Name from Agent__c where Name IN : agentName];
		}
		System.debug('-----lstAgent----->'+lstAgent);
		for(Agent__c agent : lstAgent){
			setIds.add(agent.Id);
		}
		System.debug('-----setIds----->'+setIds); 
		if(setIds != null && !setIds.isEmpty() && !lstLabAndTest.isEmpty()) {
			lstQuestionAnswer = [Select q.Question__c, q.AnswerType__c, q.Parent_Question_Answer__c, q.Name, q.Id,q.Agent__c, q.Arm__c, q.Alignment__c, q.PickList_Values__c, q.Date__c, (Select QuestionId__c, Contextdata__c, ContextDataUnit__c, CRFAdditionalQuestion__c From AnswerOptions__r where ((CreatedDate < :lstLabAndTest[0].CreatedDate and Is_Deleted__c = false) or (Is_Deleted__c = true and CreatedDate < :lstLabAndTest[0].CreatedDate and DeletedDateTime__c > :lstLabAndTest[0].CreatedDate)) order by CreatedDate ASC),  (Select Id, AnswerType__c, Question__c, Alignment__c, Parent_Question_Answer__c, PickList_Values__c, Date__c From QuestionAnswers__r order by CreatedDate ASC), (Select isDeleted__c,Answer__c, QuestionAnswer__c, CRFId__c From CRFAdditionalQuestion__r where CRFId__c = :CRFId and isDeleted__c = false) From QuestionAnswer__c q where Agent__c IN: setIds and Parent_Question_Answer__c = null and Type__c = :Questiontype and ((CreatedDate < :lstLabAndTest[0].CreatedDate and Is_Deleted__c = false) or (Is_Deleted__c = true and CreatedDate < :lstLabAndTest[0].CreatedDate and DeletedDateTime__c > :lstLabAndTest[0].CreatedDate)) order by CreatedDate ASC];
			if(Test.isRunningTest()) {
				lstQuestionAnswer = [Select q.Question__c, q.AnswerType__c, q.Parent_Question_Answer__c, q.Name, q.Id,q.Agent__c, 
					q.Arm__c, q.Alignment__c, q.PickList_Values__c, q.Date__c, (Select QuestionId__c, Contextdata__c, 
					ContextDataUnit__c, CRFAdditionalQuestion__c From AnswerOptions__r),  (Select Id, AnswerType__c, Question__c, 
					Alignment__c, Parent_Question_Answer__c, PickList_Values__c, Date__c From QuestionAnswers__r order by CreatedDate ASC), 
					(Select Answer__c, QuestionAnswer__c, CRFId__c From CRFAdditionalQuestion__r where CRFId__c = :CRFId) 
					From QuestionAnswer__c q where Agent__c IN: setIds and Parent_Question_Answer__c = null and Type__c = :Questiontype order by CreatedDate ASC];
			}
		} else if(!lstOSE.isEmpty()){
			system.debug('lstOSE[0].CreatedDate: '+lstOSE[0].CreatedDate);
			lstQuestionAnswer = [Select q.Question__c, q.AnswerType__c, q.Parent_Question_Answer__c, q.Name, q.Id,q.Agent__c, q.Arm__c, q.Alignment__c, q.PickList_Values__c, q.Date__c, (Select QuestionId__c, Contextdata__c, ContextDataUnit__c, CRFAdditionalQuestion__c From AnswerOptions__r where ((CreatedDate < :lstOSE[0].CreatedDate and Is_Deleted__c = false) or (Is_Deleted__c = true and CreatedDate < :lstOSE[0].CreatedDate and DeletedDateTime__c > :lstOSE[0].CreatedDate)) order by CreatedDate ASC),  (Select Id, AnswerType__c, Question__c, Alignment__c, Parent_Question_Answer__c, PickList_Values__c, Date__c From QuestionAnswers__r order by CreatedDate ASC), (Select Answer__c, QuestionAnswer__c, CRFId__c From CRFAdditionalQuestion__r where CRFId__c = :CRFId and isDeleted__c=false) From QuestionAnswer__c q where Parent_Question_Answer__c = null and Type__c = :Questiontype and ((CreatedDate < :lstOSE[0].CreatedDate and Is_Deleted__c = false) or (Is_Deleted__c = true and CreatedDate < :lstOSE[0].CreatedDate and DeletedDateTime__c > :lstOSE[0].CreatedDate)) order by CreatedDate ASC];
			system.debug('lstQuestionAnswer------ '+lstQuestionAnswer.size());
		} /*else {
			lstQuestionAnswer = [Select q.Question__c, q.AnswerType__c, q.Parent_Question_Answer__c, q.Name, q.Id,q.Agent__c, q.Arm__c, q.Alignment__c, q.PickList_Values__c, q.Date__c, (Select QuestionId__c, Contextdata__c, ContextDataUnit__c, CRFAdditionalQuestion__c From AnswerOptions__r order by CreatedDate ASC),  (Select Id, AnswerType__c, Question__c, Alignment__c, Parent_Question_Answer__c, PickList_Values__c, Date__c From QuestionAnswers__r order by CreatedDate ASC), (Select Answer__c, QuestionAnswer__c, CRFId__c From CRFAdditionalQuestion__r where CRFId__c = :CRFId) From QuestionAnswer__c q where Parent_Question_Answer__c = null and Type__c = :Questiontype order by CreatedDate ASC];
		}*/
		
		Map<Id,List<AnswerOption__c>> mapAnsOpt = new Map<Id,List<AnswerOption__c>>();
		Map<Id,List<CRFAdditionalQuestion__c>> mapCRFAddQues = new Map<Id,List<CRFAdditionalQuestion__c>>();
		List<QuestionAnswer__c> lstQuestionAnswer_Child = [Select q.Question__c, q.AnswerType__c, q.Parent_Question_Answer__c, q.Name, q.Id, q.Arm__c, q.Alignment__c, q.PickList_Values__c, q.Date__c, (Select QuestionId__c, Contextdata__c, ContextDataUnit__c, CRFAdditionalQuestion__c, SNo__c From AnswerOptions__r  order by CreatedDate ASC),  (Select Id, AnswerType__c, Question__c, Alignment__c, Parent_Question_Answer__c, PickList_Values__c, Date__c From QuestionAnswers__r order by CreatedDate ASC ), (Select Answer__c, QuestionAnswer__c, CRFId__c From CRFAdditionalQuestion__r where isDeleted__c=false and CRFId__c =:CRFId) From QuestionAnswer__c q where Parent_Question_Answer__c != null and Type__c = :Questiontype  order by CreatedDate ASC];
		
		for(QuestionAnswer__c quesAns : lstQuestionAnswer_Child) {
			mapAnsOpt.put(quesAns.Id, quesAns.AnswerOptions__r);
			List<CRFAdditionalQuestion__c> lstCRFAQ = quesAns.CRFAdditionalQuestion__r;
			if(lstCRFAQ != null) {
				for(CRFAdditionalQuestion__c crfAQ : lstCRFAQ) {
					if(crfAQ.CRFId__c == CRFId) {
						mapCRFAddQues.put(quesAns.Id, quesAns.CRFAdditionalQuestion__r);
					}		
				}
			}
			
		}
		
		for(QuestionAnswer__c quesAns : lstQuestionAnswer) {
			System.debug('quesAns---------------'+quesAns);
			QuestionAnswerWrapper quesAnsWrapper = new QuestionAnswerWrapper();
			quesAnsWrapper.QuestionAnswer = new QuestionAnswer__c();
			quesAnsWrapper.QuestionAnswer = quesAns;
			if(quesAns.AnswerType__c == 'Picklist') {
				if(quesAns.PickList_Values__c != null && quesAns.PickList_Values__c.length() > 0) {
					List<String> options = quesAns.PickList_Values__c.split('\\,');
					quesAnsWrapper.lstPicklistAns = new List<Selectoption>();
					quesAnsWrapper.lstPicklistAns.add(new Selectoption('None','------None------'));
					for(String opt : options) {
						if(opt != null) {
							quesAnsWrapper.lstPicklistAns.add(new Selectoption(opt,opt));
						}
					}
				}
			} else if(quesAns.AnswerType__c == 'Picklist (Multi-Select)') {
				if(quesAns.PickList_Values__c != null && quesAns.PickList_Values__c.length() > 0) {
					List<String> options = quesAns.PickList_Values__c.split('\\,');
					quesAnsWrapper.lstMultiPicklistAns = new List<Selectoption>();
					quesAnsWrapper.lstMultiPicklistAns.add(new Selectoption('None','------None------'));
					for(String opt : options) {
						if(opt != null) {
							quesAnsWrapper.lstMultiPicklistAns.add(new Selectoption(opt,opt));
						}
					}
				}
			} else if(quesAns.AnswerType__c == 'Boolean') {
				system.debug('quesAns.CRFAdditionalQuestion__r : '+quesAns.CRFAdditionalQuestion__r);
				if(quesAns.CRFAdditionalQuestion__r != null && quesAns.CRFAdditionalQuestion__r.size() > 0) {
					system.debug('quesAns.CRFAdditionalQuestion__r[0].CRFId__c: '+quesAns.CRFAdditionalQuestion__r[0].CRFId__c);
					system.debug('CRFId : '+CRFId);
					system.debug('quesAns.CRFAdditionalQuestion__r[0].CRFId__c == CRFId : '+(quesAns.CRFAdditionalQuestion__r[0].CRFId__c == CRFId));
					for(CRFAdditionalQuestion__c crfAq : quesAns.CRFAdditionalQuestion__r) {
						if(crfAq.CRFId__c == CRFId) {
							if(crfAq.Answer__c != null && !datafromPreviousCRF) {
								quesAnsWrapper.booleanAns = Boolean.valueOf(crfAq.Answer__c);
							}
						}
					}
				}
			} else if(quesAns.AnswerType__c == 'Date') {
				system.debug('quesAns.CRFAdditionalQuestion__r : '+quesAns.CRFAdditionalQuestion__r);
				if(quesAns.CRFAdditionalQuestion__r != null && quesAns.CRFAdditionalQuestion__r.size() > 0) {
					for(CRFAdditionalQuestion__c crfAq : quesAns.CRFAdditionalQuestion__r) {
						if(crfAq.CRFId__c == CRFId) {
							if(crfAq.Answer__c != null) {
								quesAnsWrapper.QuestionAnswer.Date__c = Date.valueOf(crfAq.Answer__c);
							}
						}
					}
				}
			} else if(quesAns.AnswerType__c == 'Text') {
				system.debug('quesAns.CRFAdditionalQuestion__r : '+quesAns.CRFAdditionalQuestion__r);
				if(quesAns.CRFAdditionalQuestion__r != null && quesAns.CRFAdditionalQuestion__r.size() > 0) {
					system.debug('quesAns.CRFAdditionalQuestion__r[0].CRFId__c: '+quesAns.CRFAdditionalQuestion__r[0].CRFId__c);
					system.debug('CRFId : '+CRFId);
					system.debug('quesAns.CRFAdditionalQuestion__r[0].CRFId__c == CRFId : '+(quesAns.CRFAdditionalQuestion__r[0].CRFId__c == CRFId));
					for(CRFAdditionalQuestion__c crfAq : quesAns.CRFAdditionalQuestion__r) {
						if(crfAq.CRFId__c == CRFId) {
							if(crfAq.Answer__c != null)
								quesAnsWrapper.textAns = crfAq.Answer__c;
						}
					}
				}
			} else if(quesAns.AnswerType__c == 'TextArea') {
				system.debug('quesAns.CRFAdditionalQuestion__r : '+quesAns.CRFAdditionalQuestion__r);
				if(quesAns.CRFAdditionalQuestion__r != null && quesAns.CRFAdditionalQuestion__r.size() > 0) {
					system.debug('quesAns.CRFAdditionalQuestion__r[0].CRFId__c: '+quesAns.CRFAdditionalQuestion__r[0].CRFId__c);
					system.debug('CRFId : '+CRFId);
					system.debug('quesAns.CRFAdditionalQuestion__r[0].CRFId__c == CRFId : '+(quesAns.CRFAdditionalQuestion__r[0].CRFId__c == CRFId));
					for(CRFAdditionalQuestion__c crfAq : quesAns.CRFAdditionalQuestion__r) {
						if(crfAq.CRFId__c == CRFId) {
							if(crfAq.Answer__c != null)
								quesAnsWrapper.textAreaAns = crfAq.Answer__c;
						}
					}
				}
			}
			
			if(lstCRFAddQues.isEmpty()) {
				quesAnsWrapper.lstAnsOption = quesAns.AnswerOptions__r;
			}
			
			for(CRFAdditionalQuestion__c crfAddQ : lstCRFAddQues) {
				if(crfAddQ.QuestionAnswer__c == quesAns.Id) {
					if(crfAddQ.AnswerOptions__r != null && crfAddQ.AnswerOptions__r.size() > 0) {
						quesAnsWrapper.lstAnsOption = crfAddQ.AnswerOptions__r;
					} else {
						quesAnsWrapper.lstAnsOption = quesAns.AnswerOptions__r;
					}
				}
			}
			//quesAnsWrapper.lstAnsOption = quesAns.AnswerOptions__r;
			
			if(quesAns.QuestionAnswers__r != null) {
				quesAnsWrapper.lstQuesAnsWrapper = new List<QuestionAnswerWrapper>();
				for(QuestionAnswer__c childQuesAns : quesAns.QuestionAnswers__r) {
					system.debug('childQuesAns.Date__c : '+childQuesAns.Date__c);
					QuestionAnswerWrapper childQuesAnsWrapper = new QuestionAnswerWrapper();
					childQuesAnsWrapper.QuestionAnswer = new QuestionAnswer__c();
					childQuesAnsWrapper.QuestionAnswer = childQuesAns;
					if(childQuesAns.AnswerType__c == 'Picklist') {
						if(childQuesAns.PickList_Values__c != null && childQuesAns.PickList_Values__c.length() > 0) {
							List<String> options = childQuesAns.PickList_Values__c.split('\\,');
							childQuesAnsWrapper.lstPicklistAns = new List<Selectoption>();
							childQuesAnsWrapper.lstPicklistAns.add(new Selectoption('None','------None------'));
							for(String opt : options) {
								if(opt != null) {
									childQuesAnsWrapper.lstPicklistAns.add(new Selectoption(opt,opt));
								}
							}
							
						}
					} else if(childQuesAns.AnswerType__c == 'Picklist (Multi-Select)') {
						if(childQuesAns.PickList_Values__c != null && childQuesAns.PickList_Values__c.length() > 0) {
							List<String> options = childQuesAns.PickList_Values__c.split('\\,');
							childQuesAnsWrapper.lstMultiPicklistAns = new List<Selectoption>();
							childQuesAnsWrapper.lstMultiPicklistAns.add(new Selectoption('None','------None------'));
							for(String opt : options) {
								if(opt != null) {
									childQuesAnsWrapper.lstMultiPicklistAns.add(new Selectoption(opt,opt));
								}
							}
						}
					} else if(childQuesAns.AnswerType__c == 'Boolean') {
						if(mapCRFAddQues.get(childQuesAns.Id) != null && mapCRFAddQues.get(childQuesAns.Id).size() > 0) {
							for(CRFAdditionalQuestion__c crfAq : mapCRFAddQues.get(childQuesAns.Id)) {
								if(crfAq.CRFId__c == CRFId) {
									if(crfAq.Answer__c != null) {
										childQuesAnsWrapper.booleanAns = Boolean.valueOf(crfAq.Answer__c);
									}
								}
							}
						}
					} else if(childQuesAns.AnswerType__c == 'Date') {
						if(mapCRFAddQues.get(childQuesAns.Id) != null && mapCRFAddQues.get(childQuesAns.Id).size() > 0) {
							for(CRFAdditionalQuestion__c crfAq : mapCRFAddQues.get(childQuesAns.Id)) {
								if(crfAq.CRFId__c == CRFId) {
									system.debug('crfAq.Answer__c : '+crfAq.Answer__c);
									if(crfAq.Answer__c != null) {
										childQuesAnsWrapper.QuestionAnswer.Date__c = Date.valueOf(crfAq.Answer__c);
									}
									system.debug('childQuesAnsWrapper.QuestionAnswer.Date__c : '+childQuesAnsWrapper.QuestionAnswer.Date__c);
								}
							}
						}
					} else if(childQuesAns.AnswerType__c == 'Text') {
						if(mapCRFAddQues.get(childQuesAns.Id) != null && mapCRFAddQues.get(childQuesAns.Id).size() > 0) {
							for(CRFAdditionalQuestion__c crfAq : mapCRFAddQues.get(childQuesAns.Id)) {
								if(crfAq.CRFId__c == CRFId) {
									system.debug('crfAq.Answer__c : '+crfAq.Answer__c);
									childQuesAnsWrapper.textAns = crfAq.Answer__c;
									system.debug('childQuesAnsWrapper.QuestionAnswer.Date__c : '+childQuesAnsWrapper.QuestionAnswer.Date__c);
								}
							}
						}
					} else if(childQuesAns.AnswerType__c == 'TextArea') {
						if(mapCRFAddQues.get(childQuesAns.Id) != null && mapCRFAddQues.get(childQuesAns.Id).size() > 0) {
							for(CRFAdditionalQuestion__c crfAq : mapCRFAddQues.get(childQuesAns.Id)) {
								if(crfAq.CRFId__c == CRFId) {
									system.debug('crfAq.Answer__c : '+crfAq.Answer__c);
									childQuesAnsWrapper.textAreaAns = crfAq.Answer__c;
									system.debug('childQuesAnsWrapper.QuestionAnswer.Date__c : '+childQuesAnsWrapper.QuestionAnswer.Date__c);
								}
							}
						}
					}
					
					if(lstCRFAddQues.isEmpty()) {
						childQuesAnsWrapper.lstAnsOption = mapAnsOpt.get(childQuesAns.Id);
					}
					for(CRFAdditionalQuestion__c crfAddQ : lstCRFAddQues) {
						if(crfAddQ.QuestionAnswer__c == childQuesAns.Id) {
							if(crfAddQ.AnswerOptions__r != null && crfAddQ.AnswerOptions__r.size() > 0) {
								childQuesAnsWrapper.lstAnsOption = crfAddQ.AnswerOptions__r;
							} else {
								childQuesAnsWrapper.lstAnsOption = mapAnsOpt.get(childQuesAns.Id);
							}
						}
					}
					
					//childQuesAnsWrapper.lstAnsOption = mapAnsOpt.get(childQuesAns.Id);
					quesAnsWrapper.lstQuesAnsWrapper.add(childQuesAnsWrapper);

				}
			}
			
			quesAnsWrapper.lstQuesAnsWrapperList = new List<List<QuestionAnswerWrapper>>();
			List<List<QuestionAnswerWrapper>> lstOfList = new List<List<QuestionAnswerWrapper>>();
			List<QuestionAnswerWrapper> lstQuesAns = new List<QuestionAnswerWrapper>();
			for(QuestionAnswerWrapper qaw : quesAnsWrapper.lstQuesAnsWrapper) {
				
				lstQuesAns.add(qaw);
				if(lstQuesAns.size() == 2) {
					lstOfList.add(lstQuesAns);
					lstQuesAns = new List<QuestionAnswerWrapper>();
				}
			}
			if(lstQuesAns.size() < 2) {
				lstOfList.add(lstQuesAns);
			}
			quesAnsWrapper.lstQuesAnsWrapperList = lstOfList;
			lstQuesAnsWrapper.add(quesAnsWrapper);
			system.debug('lstQuesAnsWrapper.size() : '+lstQuesAnsWrapper.size());
		}
		system.debug('lstQuesAnsWrapper : '+lstQuesAnsWrapper);
		system.debug('lstQuesAnsWrapper :size--- '+lstQuesAnsWrapper.size());
		
		/*
		if(isReadOnly != null && Boolean.valueOf(isReadOnly)) {
			//editComponent();
		}
		*/
		system.debug('lstQuesAnsWrapper : '+lstQuesAnsWrapper.size());
		return lstQuesAnsWrapper;
	}
	
	//public void saveComponent(Id latId) {
	//	saveComponent(latId);
	//}
	
	public void saveComponent(Id latId) {
		system.debug('latId : '+latId);
		List<CRFAdditionalQuestion__c> lstCRFAddQues = new List<CRFAdditionalQuestion__c>();
		List<AnswerOption__c> ansOptToDel = new List<AnswerOption__c>();
		List<AnswerOption__c> ansOptToInsert = new List<AnswerOption__c>();
		if(latId != null) {
			lstCRFAddQues = [Select c.QuestionAnswer__c, c.Id, c.CRFId__c, c.Answer__c, c.isDeleted__c From CRFAdditionalQuestion__c c where CRFId__c = :latId AND isDeleted__c = false];
			if(!lstCRFAddQues.isEmpty()) {
				for(CRFAdditionalQuestion__c crfAddQues : lstCRFAddQues) {
					crfAddQues.isDeleted__c = true;
					if(lstQuesAnsWrapper != null) {
						for(QuestionAnswerWrapper queAnsWrapper : lstQuesAnsWrapper) {
							if(crfAddQues.QuestionAnswer__c == queAnsWrapper.QuestionAnswer.Id) {
								if(crfAddQues.AnswerOptions__r != null && !crfAddQues.AnswerOptions__r.isEmpty()) {
									ansOptToDel.addAll(crfAddQues.AnswerOptions__r);
								}
							}
							for(QuestionAnswerWrapper queAnsWrapper_Child : queAnsWrapper.lstQuesAnsWrapper) {
								if(crfAddQues.QuestionAnswer__c == queAnsWrapper_Child.QuestionAnswer.Id) {
									if(crfAddQues.AnswerOptions__r != null && !crfAddQues.AnswerOptions__r.isEmpty()) {
										ansOptToDel.addAll(crfAddQues.AnswerOptions__r);
									}
								}	
							}
						}
					}
				}
				system.debug('lstCRFAddQues : '+lstCRFAddQues);
				//delete lstCRFAddQues;
				update lstCRFAddQues;
				
				lstCRFAddQues = new List<CRFAdditionalQuestion__c>();
			}
		}
		if(lstQuesAnsWrapper != null) {
		for(QuestionAnswerWrapper queAnsWrapper : lstQuesAnsWrapper) {
			CRFAdditionalQuestion__c crfAddQues = new CRFAdditionalQuestion__c();
			crfAddQues.QuestionAnswer__c = queAnsWrapper.QuestionAnswer.Id;
			System.debug('crfAddQues.QuestionAnswer__c--------------'+crfAddQues.QuestionAnswer__c);
			if(queAnsWrapper.QuestionAnswer.AnswerType__c == 'Picklist') {
				crfAddQues.Answer__c = queAnsWrapper.picklistAns;
			} else if(queAnsWrapper.QuestionAnswer.AnswerType__c == 'Picklist (Multi-Select)') {
				crfAddQues.Answer__c = queAnsWrapper.multiPicklistAns;
			} else if(queAnsWrapper.QuestionAnswer.AnswerType__c == 'Boolean') {
				System.debug('queAnsWrapper.booleanAns-----------------'+queAnsWrapper.booleanAns);
				crfAddQues.Answer__c = String.valueOf(queAnsWrapper.booleanAns);
			} else if(queAnsWrapper.QuestionAnswer.AnswerType__c == 'Text') {
				crfAddQues.Answer__c = queAnsWrapper.textAns;
			} else if(queAnsWrapper.QuestionAnswer.AnswerType__c == 'TextArea') {
				crfAddQues.Answer__c = queAnsWrapper.textAreaAns;
			} else if(queAnsWrapper.QuestionAnswer.AnswerType__c == 'Date') {
				if(queAnsWrapper.QuestionAnswer.Date__c != null) {
					crfAddQues.Answer__c = String.valueOf(queAnsWrapper.QuestionAnswer.Date__c);
				}
			}
			crfAddQues.CRFId__c = latId;
			crfAddQues.CRFType__c = CRFType;
			lstCRFAddQues.add(crfAddQues);
			system.debug('lstCRFAddQues : '+lstCRFAddQues);
			List<QuestionAnswerWrapper> lstQuesAnsWrapper_Child = queAnsWrapper.lstQuesAnsWrapper;
			for(QuestionAnswerWrapper queAnsWrapper_Child : lstQuesAnsWrapper_Child) {
				CRFAdditionalQuestion__c crfAddQues_Child = new CRFAdditionalQuestion__c();
				crfAddQues_Child.QuestionAnswer__c = queAnsWrapper_Child.QuestionAnswer.Id;
				if(queAnsWrapper_Child.QuestionAnswer.AnswerType__c == 'Picklist') {
					crfAddQues_Child.Answer__c = queAnsWrapper_Child.picklistAns;
				} else if(queAnsWrapper_Child.QuestionAnswer.AnswerType__c == 'Picklist (Multi-Select)') {
					crfAddQues_Child.Answer__c = queAnsWrapper_Child.multiPicklistAns;
				} else if(queAnsWrapper_Child.QuestionAnswer.AnswerType__c == 'Boolean') {
					crfAddQues_Child.Answer__c = String.valueOf(queAnsWrapper_Child.booleanAns);
				} else if(queAnsWrapper_Child.QuestionAnswer.AnswerType__c == 'Text') {
					crfAddQues_Child.Answer__c = queAnsWrapper_Child.textAns;
				} else if(queAnsWrapper_Child.QuestionAnswer.AnswerType__c == 'TextArea') {
					crfAddQues_Child.Answer__c = queAnsWrapper_Child.textAreaAns;
				} else if(queAnsWrapper_Child.QuestionAnswer.AnswerType__c == 'Date') {
					if(queAnsWrapper_Child.QuestionAnswer.Date__c != null) {
						crfAddQues_Child.Answer__c = String.valueOf(queAnsWrapper_Child.QuestionAnswer.Date__c);
					}
				}
				
				crfAddQues_Child.CRFId__c = latId;
				crfAddQues_Child.CRFType__c = CRFType;
				lstCRFAddQues.add(crfAddQues_Child);
			}
		}
		}
		system.debug('lstCRFAddQues : '+lstCRFAddQues);
		
		insert lstCRFAddQues;
		
		integer ansOptSNo = 0;
		system.debug('lstQuesAnsWrapper : '+lstQuesAnsWrapper);
		for(CRFAdditionalQuestion__c crfAddQues : lstCRFAddQues) {
			for(QuestionAnswerWrapper queAnsWrapper : lstQuesAnsWrapper) {
				if(crfAddQues.QuestionAnswer__c == queAnsWrapper.QuestionAnswer.Id) {
					if(crfAddQues.AnswerOptions__r != null && !crfAddQues.AnswerOptions__r.isEmpty()) {
						ansOptToDel.addAll(crfAddQues.AnswerOptions__r);
					}
					system.debug('queAnsWrapper.QuestionAnswer.AnswerOptions__r : '+queAnsWrapper.QuestionAnswer.AnswerOptions__r);
					if(queAnsWrapper.lstAnsOption != null) {
						for(AnswerOption__c ansOption : queAnsWrapper.lstAnsOption) {
							AnswerOption__c ansOptionNew = new AnswerOption__c();
							ansOptionNew.Contextdata__c = ansOption.Contextdata__c;
							ansOptionNew.ContextDataUnit__c = ansOption.ContextDataUnit__c;
							ansOptionNew.CRFAdditionalQuestion__c = crfAddQues.Id;
							ansOptionNew.SNo__c = (++ansOptSNo);
							ansOptToInsert.add(ansOptionNew);
						}
					}
				}
				for(QuestionAnswerWrapper queAnsWrapper_Child : queAnsWrapper.lstQuesAnsWrapper) {
					if(queAnsWrapper_Child == null) continue;
					if(crfAddQues.QuestionAnswer__c == queAnsWrapper_Child.QuestionAnswer.Id) {
						if(crfAddQues.AnswerOptions__r != null && !crfAddQues.AnswerOptions__r.isEmpty()) {
							ansOptToDel.addAll(crfAddQues.AnswerOptions__r);
						}
						system.debug('queAnsWrapper_Child.QuestionAnswer.AnswerOptions__r : '+queAnsWrapper_Child.QuestionAnswer.AnswerOptions__r);
						if(queAnsWrapper_Child.lstAnsOption == null) continue;
						for(AnswerOption__c ansOption : queAnsWrapper_Child.lstAnsOption) {
							AnswerOption__c ansOptionNew_cd = new AnswerOption__c();
							ansOptionNew_cd.Contextdata__c = ansOption.Contextdata__c;
							ansOptionNew_cd.ContextDataUnit__c = ansOption.ContextDataUnit__c;
							ansOptionNew_cd.CRFAdditionalQuestion__c = crfAddQues.Id;
							ansOptionNew_cd.SNo__c = (++ansOptSNo);
							ansOptToInsert.add(ansOptionNew_cd);
						}
					}	
				}
			}
		}
		delete ansOptToDel;
		insert ansOptToInsert;
	}
	
	public void editComponent() {
		
		/*system.debug('isReadOnly : '+isReadOnly);
		system.debug('lstQuesAnsWrapper : '+lstQuesAnsWrapper);
		system.debug('TrialPatientId : '+TrialPatientId);
		system.debug('CRFType : '+CRFType);
		List<CRFAdditionalQuestion__c> lstCRFAdditonalQuestion = [select Name, Question__c, Answer__c, CRFType__c, QuestionAnswer__c, QuestionAnswer__r.Question__c ,QuestionAnswer__r.Parent_Question_Answer__c, QuestionAnswer__r.AnswerType__c, QuestionAnswer__r.Alignment__c, (Select Id, Contextdata__c, ContextDataUnit__c, AnsOptionType__c, CRFAdditionalQuestion__c From AnswerOptions__r) from CRFAdditionalQuestion__c where CRFId__c = :CRFId];
		Map<Id,List<QuestionAnswerWrapper>> mapQuesAns = new Map<Id,List<QuestionAnswerWrapper>>();
		//List<CRFAdditionalQuestion__c> lstcrfAddQ = [Select c.QuestionAnswer__r.Parent_Question_Answer__c, c.QuestionAnswer__r.Alignment__c, c.QuestionAnswer__r.ContextDataUnit__c, c.QuestionAnswer__r.Contextdata__c, c.QuestionAnswer__r.Question__c, c.QuestionAnswer__r.AnswerType__c, c.QuestionAnswer__r.Name, c.QuestionAnswer__c, c.Name From CRFAdditionalQuestion__c c where TrialPatient__c = :TrialPatientId];
		List<QuestionAnswer__c> lstQuestionAnswer1 = [Select q.Name, q.Question__c, q.AnswerType__c, q.Alignment__c, Parent_Question_Answer__c, (Select AnswerOptionText__c, ContextDataUnit__c, Contextdata__c, AnsOptionType__c  From AnswerOptions__r), (Select AnswerType__c, Question__c, Alignment__c From QuestionAnswers__r) From QuestionAnswer__c q order by CreatedDate ASC];
		for(QuestionAnswerWrapper queAns : lstQuesAnsWrapper) {
			for(CRFAdditionalQuestion__c crfQues : lstCRFAdditonalQuestion) {
				System.debug('----1st for-->');
				if(queAns.QuestionAnswer.Id == crfQues.QuestionAnswer__c) {
					//queAns.lstAnsOption = crfQues.AnswerOptions__r;
					System.debug('-----queAns.ansType--->'+queAns.ansType);
					if(queAns.ansType == 'Picklist') {
						queAns.picklistAns = crfQues.Answer__c;
					} else if(queAns.ansType == 'Picklist (Multi-Select)') {
						queAns.multiPicklistAns = crfQues.Answer__c;
						system.debug('crfQues.Answer__c : ' + crfQues.Answer__c);
						String option = queAns.multiPicklistAns.substring(1,queAns.multiPicklistAns.length() - 1);
						lstAns = new List<Selectoption>();
						List<String> options = option.split('\\,'); 
						system.debug('options : '+options);
						
					} else if(queAns.ansType == 'Boolean') {
						if(crfQues.Answer__c != null) {
							queAns.booleanAns = Boolean.valueOf(crfQues.Answer__c);
						}
					} else if(queAns.ansType == 'Text') {
						queAns.textAns = crfQues.Answer__c;
					} else if(queAns.ansType == 'TextArea') {
						queAns.textAreaAns = crfQues.Answer__c;
					} else if(queAns.ansType == 'Date') {
						if(crfQues.Answer__c != null) {
							queAns.dateTypeAnswer = Date.valueOf(crfQues.Answer__c);
						}
					} 
					System.debug('-----crfQues.Answer__c--->'+crfQues.Answer__c);
				}
				if(queAns.lstQAWList != null && !queAns.lstQAWList.isEmpty()) {
					for(List<QuestionAnswerWrapper> lstChildQuesAns : queAns.lstQAWList) {
						for(QuestionAnswerWrapper childQuesAns : lstChildQuesAns) {
							for(CRFAdditionalQuestion__c crfQues1 : lstCRFAdditonalQuestion) {
								
								if(childQuesAns.QuestionAnswer.Id == crfQues1.QuestionAnswer__c) {
									childQuesAns.lstAnsOption = crfQues1.AnswerOptions__r;
									System.debug('-----childQuesAns.ansType--->'+childQuesAns.ansType);
									if(childQuesAns.ansType == 'Picklist') {
										childQuesAns.picklistAns = crfQues1.Answer__c;
									} else if(childQuesAns.ansType == 'Picklist (Multi-Select)') {
										childQuesAns.multiPicklistAns = crfQues1.Answer__c;
										system.debug('crfQues.Answer__c : ' + crfQues1.Answer__c);
										String option = childQuesAns.multiPicklistAns.substring(1,childQuesAns.multiPicklistAns.length() - 1);
										lstAns = new List<Selectoption>();
										List<String> options = option.split('\\,'); 
										system.debug('options : '+options);
										
									} else if(childQuesAns.ansType == 'Boolean') {
										if(crfQues1.Answer__c != null) {
											childQuesAns.booleanAns = Boolean.valueOf(crfQues1.Answer__c);
										}
									} else if(childQuesAns.ansType == 'Text') {
										childQuesAns.textAns = crfQues1.Answer__c;
									} else if(childQuesAns.ansType == 'TextArea') {
										childQuesAns.textAreaAns = crfQues1.Answer__c;
									} else if(childQuesAns.ansType == 'Date') {
										if(crfQues.Answer__c != null) {
											childQuesAns.dateTypeAnswer = Date.valueOf(crfQues1.Answer__c);
										}
									} 
									System.debug('-----crfQues.Answer__c--->'+crfQues1.Answer__c);
								}
							}
						}	
					}
				}	
			}
		}
		system.debug('mapQuesAns : '+mapQuesAns);
		system.debug('after lstQuesAnsWrapper : '+lstQuesAnsWrapper);
		*/
	}
	
	public class QuestionAnswerWrapper {
		
		public List<Selectoption> lstPicklistAns {get;set;}
		public String picklistAns {get;set;}
		public List<Selectoption> lstMultiPicklistAns {get;set;}
		public String multiPicklistAns {get;set;}
		public String textAns {get;set;}
		public String textAreaAns {get;set;}
		public boolean booleanAns {get;set;}
		public Date dateTypeAnswer {get;set;} 
		
		public String ansType {get;set;}
		
		public QuestionAnswer__c QuestionAnswer {get;set;}
		public List<AnswerOption__c> lstAnsOption {get;set;}
		public String Answer {get;set;}
		
		
		public String CRFAddQuesNumber {get;set;}
		
		public List<QuestionAnswerWrapper> lstQuesAnsWrapper {get;set;}
		
		//bik
		public List<List<QuestionAnswerWrapper>> lstQuesAnsWrapperList {get;set;}
		
		public boolean hasAnsOpt {get;set;}
		
		
	}
	
}