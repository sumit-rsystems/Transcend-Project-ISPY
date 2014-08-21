global class RunCalcXMLUpdateScheduler implements Schedulable {
    global void execute(SchedulableContext SC) {
        RandomizationXMLBuilder.updateRunCalculationXML();
    }
    
    @isTest public static void unitTest() {
        Test.StartTest();
        RunCalcXMLUpdateScheduler m = new RunCalcXMLUpdateScheduler();
        String sch = '0 0 0 * * ?';
        system.schedule('Update Run Calculation XML for "-1 Values"', sch, m);
        Test.stopTest();
    }
}