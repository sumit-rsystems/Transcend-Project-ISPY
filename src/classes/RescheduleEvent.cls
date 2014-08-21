public with sharing class RescheduleEvent {

	public List<Proposed_Rescheduling__c> propList{get;set;}
	public List<Proposed_Rescheduling__c> propListResch{get;set;}
	public Proposed_Rescheduling__c propObj{get;set;}
	public string propReschId{get;set;}
	public string refId{get;set;}
	public Boolean isStartDate{get;set;}
	public Boolean isRescheuDate{get;set;}
	public Boolean isButton{get;set;}
	public Boolean isReschudEvent {get;set;}
	public Boolean isEventCreation {get;set;}
	
	public RescheduleEvent(){
		isReschudEvent = false;
		isEventCreation = false;
		String result = userinfo.getUSerId();
		isStartDate = false;
		isRescheuDate = true;
		propList = new List<Proposed_Rescheduling__c>();
		propListResch = new List<Proposed_Rescheduling__c>();
		propReschId = ApexPages.currentPage().getParameters().get('propRecordId');
		refId = ApexPages.currentPage().getParameters().get('refId');
		system.debug('---------refId---------------'+refId);
		if(refId != null){ 
			propList = [Select p.subject__c,p.studyStaff__c, p.refId__c, p.WhatId__c, p.Type__c, p.Trial__c, p.SystemModstamp, p.StartDateTime__c, p.Reschedule_reason__c, p.Proposed_New_Date__c, p.PatientId__c, p.Owner.Email, p.OwnerId, p.Name, p.Minutes__c, p.LastModifiedDate, p.LastModifiedById, p.IsDeleted, p.Id, p.Hours__c, p.Eventid__c, p.EndDate__c, p.DurationInMinutes__c, p.Description__c, p.CreatedDate, p.CreatedById From Proposed_Rescheduling__c p where refId__c =: refId and OwnerId = :result];
			system.debug('---------propList-------------'+propList.size());
			if(propList.size() > 0){
				propObj = propList[0];
				isButton = true;
				isReschudEvent = true;
				isEventCreation = false;	
			}else{ 
	        	isStartDate = false;
				isRescheuDate = false;
				isButton = false;
			}	
		}else if(propReschId !=  null){
			propList = [Select p.subject__c,p.studyStaff__c, p.refId__c, p.WhatId__c, p.Type__c, p.Trial__c, p.SystemModstamp, p.StartDateTime__c, p.Reschedule_reason__c, p.Proposed_New_Date__c, p.PatientId__c, p.Owner.Email, p.OwnerId, p.Name, p.Minutes__c, p.LastModifiedDate, p.LastModifiedById, p.IsDeleted, p.Id, p.Hours__c, p.Eventid__c, p.EndDate__c, p.DurationInMinutes__c, p.Description__c, p.CreatedDate, p.CreatedById From Proposed_Rescheduling__c p where id =: propReschId and OwnerId = :result];
			if(propList.size() > 0){
				propObj = propList[0];
				isButton = true;
				isReschudEvent = false;
				isEventCreation = true;	
			}else{ 
	        	isStartDate = false;
				isRescheuDate = false;
				isButton = false;
			}
		}
	}
	public Pagereference reschuldeEvent(){
		for(Proposed_Rescheduling__c pro : propList){
			pro.Proposed_New_Date__c = pro.Proposed_New_Date__c; 
		}
		update propList;
		isReschudEvent = false;
		isRescheuDate = false;
		ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Your visit rescheduled  is successfully'));
		return null;
	}
	public Pagereference rescheduleEventCreation(){
		List<Proposed_Rescheduling__c> propList = [Select p.studyStaff__c, p.subject__c, p.refId__c, p.WhatId__c, p.Type__c, p.Trial__c, p.SystemModstamp, p.StartDateTime__c, p.Reschedule_reason__c, p.Proposed_New_Date__c, p.PatientId__c, p.Owner.Email, p.OwnerId, p.Name, p.Minutes__c, p.LastModifiedDate, p.LastModifiedById, p.IsDeleted, p.Id, p.Hours__c, p.Eventid__c, p.EndDate__c, p.DurationInMinutes__c, p.Description__c, p.CreatedDate, p.CreatedById From Proposed_Rescheduling__c p where id =: propReschId];
		List<Event> evList = new List<Event>();
		if(propList.size() > 0){
			for(Proposed_Rescheduling__c pro : propList){
				Event ev = new Event();
				ev.OwnerId = pro.OwnerId;
				ev.StartDateTime = propObj.StartDateTime__c;
				ev.Type = pro.Type__c;
				ev.Trial__c = pro.Trial__c;
				ev.DurationInMinutes = Integer.valueOf(pro.DurationInMinutes__c);
				ev.Hours__c = pro.Hours__c;
				ev.Minutes__c = pro.Minutes__c; 
				ev.subject__c = pro.subject__c;
				ev.Description = pro.Description__c;
				ev.status__c ='Confirmed';

				evList.add(ev);
				
				Event ev1 = new Event();
				ev1.OwnerId = pro.studyStaff__c;
				ev1.StartDateTime = propObj.StartDateTime__c;
				ev1.Type = pro.Type__c;
				ev1.Trial__c = pro.Trial__c;
				ev1.Hours__c = pro.Hours__c;
				ev1.Minutes__c = pro.Minutes__c; 
				ev1.subject__c = pro.subject__c;
				ev1.Description = pro.Description__c;
				ev.status__c ='Confirmed';     
				ev1.DurationInMinutes = Integer.valueOf(pro.DurationInMinutes__c);
				
				evList.add(ev1);
			}
		}
		insert evList;
		if(propList.size() > 0){
			delete propList;
			ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Your visit rescheduled  is successfully'));
			isStartDate = true;
			isRescheuDate = false; 
		}
		return null;	
	}
}