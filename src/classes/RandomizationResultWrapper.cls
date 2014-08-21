public with sharing class RandomizationResultWrapper {
    public String patientName {get;set;}
    public String ER {get;set;}
    public String PR {get;set;}
    public String HER2IHC {get;set;}
    public String HER2FISH {get;set;}
    public String HER2TP {get;set;}
    public String MP {get;set;}
    public boolean isRandomized {get;set;}
    public String treatmentArm {get;set;}
    public String randomizationDate {get;set;}
    
    @isTest static void myUnitTest() {
        new RandomizationResultWrapper();
    }
}