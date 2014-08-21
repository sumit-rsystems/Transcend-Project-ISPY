global class ReportSchedulerClass implements Schedulable {
	public Decimal nextReport;
	public ReportSchedulerClass(Decimal nextReport) {
		this.nextReport = nextReport;
	}
	global void execute(SchedulableContext sc) {
		ReportGeneratorClass.generateReport(sc.getTriggerId(), nextReport);
	}
}