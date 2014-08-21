global class PatientWebservices{
    
    /*
      @Author:Amit Mondal
      PatientWebservices: class exposed as web service.
      Date : 07 Mar 13
    */ 
  
    global class Response{
        webservice String Status;
        webservice String Error;
        webservice String CreatedId;
    }
    
    webservice static String getCurrentPatientsList(String study, String institution){
        String  runCalcXML = RandomizePatient.getRunCalculationXML(study, institution);
        System.debug('runCalcXML:'+runCalcXML);
        return runCalcXML;
    }
    
    webservice static Response updateProbabilities(String xml){
        Response res = new Response();
        if(xml != null &&!xml.trim().equals('')) {
            try{
                //String currentPatientXML = rp.getPatientXMLForRunCalculation();
                RandomizePatient.saveRunCalculationResponse(xml);
                res.Status='Success';
            }catch(Exception e){
                res.Status='Failure';
                res.Error=e.getMessage(); 
            }
        }else{
            res.Status='Failure';
            res.Error='Input xml is empty!';
        }
        return res;
    }
    
    @isTest public static void myTest1(){
        
        PatientWebservices.getCurrentPatientsList('123','345');
    }
    @isTest public static void myTest2(){
        PatientWebservices.updateProbabilities('xml_data');
    }
    @isTest public static void myTest3(){
        PatientWebservices.updateProbabilities(null);
    }
    
}