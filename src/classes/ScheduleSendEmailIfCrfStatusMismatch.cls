global class ScheduleSendEmailIfCrfStatusMismatch implements Schedulable{
	global void execute(SchedulableContext sc) {
		CheckStatusOfMasterCRFWithAllCRFs cs = new CheckStatusOfMasterCRFWithAllCRFs();
		cs.compareStatusAndSendEmail();
	}
}