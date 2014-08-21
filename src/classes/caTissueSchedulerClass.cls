global class caTissueSchedulerClass implements Schedulable {
	public String operationType;
	public caTissueSchedulerClass(String operationType) {
		this.operationType = operationType;
	}
	global void execute(SchedulableContext sc) {
		caTissueIntegration.callCaTissue(sc.getTriggerId(), operationType);
	}
}