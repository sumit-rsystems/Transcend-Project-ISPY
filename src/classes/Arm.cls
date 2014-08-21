//This class is used to exchange arm related information between external service and Salesforce
public global class Arm {
    
    //Name of the Arm
    public webService string name;
    public webService string description;
    public webService string genericName;
    //Name of the trial which Arm belongs to
    public webService string trialName;
    
        @isTest public static void  test1(){ 
        Arm a = new Arm();
    } 
}