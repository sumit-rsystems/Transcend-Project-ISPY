public with sharing class ScheduleManager {
	public static void generateSchedule(ARM__c armObj, TrialPatient__c trailPatObj) {
		if(trailPatObj != null) {
			//List<Randomization_Form__c> lstRandomization = [select Id from Randomization_Form__c where TrialPatient__c =:trailPatObj.Id];
			List<TrialPatient__c> lstTrialPatient = [Select (select Id From Randomization_Forms__r), (select Id From Off_Study_Details__r) From TrialPatient__c t where Id =:trailPatObj.Id];
			if(!lstTrialPatient.isEmpty() && !lstTrialPatient[0].Randomization_Forms__r.isEmpty() && lstTrialPatient[0].Off_Study_Details__r.isEmpty()) {
				/*commented to get characters for other coding
				TaskManager.createTaskAfterRandomzation(new Set<Id>{trailPatObj.Id});
				*/
			}
		}
	}
}