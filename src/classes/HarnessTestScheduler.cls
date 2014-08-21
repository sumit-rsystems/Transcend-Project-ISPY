global class HarnessTestScheduler implements Schedulable {
	public String testHarnessType;
	public HarnessTestScheduler(String testHarnessType) {
		this.testHarnessType = testHarnessType;
	}
	global void execute(SchedulableContext sc) {
		HarnessTestForRandomization.doRandomize(sc.getTriggerId(), testHarnessType);
	}
}