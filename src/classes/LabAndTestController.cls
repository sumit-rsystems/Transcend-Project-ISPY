public with sharing class LabAndTestController extends PageControllerBase {    
    public Lab_and_Test__c latObj{get;set;}
    public String currentTab {get;set;}
    public Boolean isCollectionDate {get;set;}
    public Boolean isCollectionDate1 {get;set;}
    public Boolean dateofProcedure {get;set;}
    public Boolean leukocytes {get;set;}    
    public Boolean anc {get;set;}  
    public Boolean platelets {get;set;}   
    public Boolean totalBilirubin {get;set;}
    public Boolean ast {get;set;}
    public Boolean alt {get;set;} 
    public Boolean creatinine {get;set;} 
    public Boolean mugaScan {get;set;}
    public Boolean cardiacEcho {get;set;}
    public Boolean patientNotRandomized {get;set;}
    public Boolean neratinib {get;set;}
    public Boolean amg386 {get;set;}
    public Boolean ganitumab {get;set;}
    public Boolean figitumumab {get;set;}
    public Boolean abt888 {get;set;}
    public Boolean trastuzumab {get;set;}
    public Boolean paclitaxel {get;set;}
    public Boolean paclitaxelTrastuzumab {get;set;}
    public Boolean paclitaxelABT888Carboplatin {get;set;}
    public Boolean paclitaxelAMG386 {get;set;}
    public Boolean paclitaxelGanitumab {get;set;}
    public Boolean paclitaxelMK2206 {get;set;}
    public Boolean paclitaxelMK2206Trastuzumab {get;set;}
    public Boolean paclitaxelNeratinib {get;set;}
    public Boolean abt888withCarboplatin {get;set;}
    public Boolean randomizationResult {get;set;}
    public String trialPat {get;set;}
    public String errorMsg {get;set;}
    public Id labAndTestId;
    public String password {get;set;}
    public String armIdSelected {get; set;}
    public string armName {get; set;}
    public Boolean isComplete {get; set;}
    public boolean openInEditMode {get;set;}
    public boolean isShowEditButton{get;set;}
    public String nextTabName{get;set;}
    private Id clonedCRFId{get;set;} 
    public TrialPatient__c trialPatientObj {get;set;}
    private List<Lab_and_Test__c> lstCloneLabAndTest{get;set;}
    public String profileName{get;set;}
    public Boolean isDelete{get;set;}
    public Lab_and_Test__c pathObj{get;set;}
        
    public AdditionalQuestionController addQuesController {set;
    get{
        //get the map, then the component controller using the appropriate key
        if(getComponentControllerMap()!=null){
          AdditionalQuestionController addQues;
          addQues = (AdditionalQuestionController )getComponentControllerMap().get('addQues');
          if(addQues!= null)
             return addQues;
        }               
        
        //just in case something goes wrong return something...this can be handled better
        return new AdditionalQuestionController(); 
    }
  } 
  public void callAddQuesControllerMethod(Id labAndTestId) {
    system.debug('addQuesController : '+addQuesController);
    addQuesController.saveComponent(labAndTestId);  
  }
  
    public LabAndTestController(ApexPages.StandardController controller){
        System.debug('LabAndTest-------'+controller.getId());
        labAndTestId = controller.getId();
        Lab_and_Test__c LabAndTestObj;
        if(labAndTestId != null)LabAndTestObj = [Select l.TrialPatient__c From Lab_and_Test__c l where id =: labAndTestId];
        System.debug('LabAndTestObj-------'+LabAndTestObj);
        
        String currentUserId = UserInfo.getUserId();
        for(User u :[Select  Profile.Name , ProfileId, Id, Name From User where id =:currentUserId]){            
            profileName = u.Profile.Name; 
        }
        openInEditMode = false;
        isDelete = false;
        isCollectionDate = false;
        isCollectionDate1 = false;
        dateofProcedure = false;
        neratinib = false;
        amg386 = false;  
        ganitumab = false;
        figitumumab = false;
        abt888 = false;
        trastuzumab = false;
        leukocytes = true;
        anc = true;
        platelets = true;
        totalBilirubin = true;      
        ast = true;     
        alt = true;
        creatinine = true;
        mugaScan = true;
        cardiacEcho = true;
        patientNotRandomized = true;
        isComplete = true;
        randomizationResult = false;
        isShowEditButton = false;
        
        if(LabAndTestObj != null){
            trialPat = LabAndTestObj.TrialPatient__c;
            labAndTestId = LabAndTestObj.id;
        }else{
            trialPat = Apexpages.currentPage().getParameters().get('trialPat');
            labAndTestId = Apexpages.currentPage().getParameters().get('labAndTestId');
        }
        
        System.debug('trialPat-------'+trialPat);
        
        if(trialPat != null) {
            List<TrialPatient__c> lstTrialPatient = [select Name, Patient_Id__c, Trial_Id__r.Name  from TrialPatient__c where Id = :trialPat];
            if(!lstTrialPatient.IsEmpty()) {
                trialPatientObj = lstTrialPatient[0];
            }
        }
        System.debug('trialPatientObj-------'+trialPatientObj);
        if(labAndTestId != null){
            latObj = [Select l.Status__c, l.TrialPatient__c,l.CRF__c, l.Total_Bilirubin__c,l.Collection_Date_for_Investigative_Agent__c,l.MUGA_Scan__c,l.Cardiac_Echo__c,l.Cardiac_Echo_Date__c,l.Cardiac_Echo_LVEF__c,l.Cardiac_Echo_Institutional_Lower_Limit__c,l.MUGA_Scan_Date__c,l.MUGA_Scan_LVEF__c,l.MUGA_Institutional_Lower_Limit_of_Normal__c,l.Total_Bilirubin_Result__c, l.Total_Bilirubin_Institutional_Reference__c, l.SystemModstamp, l.Platelets__c, l.Platelets_Result__c, l.Platelets_Institutional_Reference_Range__c, l.OwnerId, l.Name, l.Leukocytes__c, l.Leukocytes_Result__c, l.Leukocytes_Institutional_Reference_Range__c, l.LastModifiedDate, l.LastModifiedById, l.IsDeleted, l.Id, l.Creatinine__c, l.Creatinine_Result__c, l.Creatinine_Institutional_Reference_Range__c, l.CreatedDate, l.CreatedById, l.CompletedDate__c, l.Collection_Date__c, l.Absolute_Neutrophil_Count_ANC__c, l.Absolute_Neutrophil_Count_ANC_Result__c, l.AST__c, l.AST_Result__c, l.AST_Institutional_Reference_Range__c, l.ANC_Industrial_Reference_Range__c, l.ALT__c, l.ALT_Result__c, l.ALT_Institutional_Reference_Range__c, l.Root_CRF_Id__c From Lab_and_Test__c l where l.Id = : labAndTestId];
            lstCloneLabAndTest = [select Id, Status__c,Root_CRF_Id__c  from Lab_and_Test__c where OriginalCRF__c =:labAndTestId and Status__c = 'Cloned'];
            if(!lstCloneLabAndTest.isEmpty()) {
                isShowEditButton = true;
                clonedCRFId = lstCloneLabAndTest[0].Id;
            }
            if(latObj.Leukocytes__c){
                leukocytes = false;
            } else {
                leukocytes = true; 
            }
            if(latObj.Absolute_Neutrophil_Count_ANC__c){
                anc = false;
            } else {
                anc = true;
            }
            if(latObj.Platelets__c){
                platelets = false;
            } else {
                platelets = true;
            }
            if(latObj.Total_Bilirubin__c){
                totalBilirubin = false;
            } else {
                totalBilirubin = true;
            }
            if(latObj.AST__c){
                ast = false;
            } else {
                ast = true;
            }
            if(latObj.ALT__c){
                alt = false;
            } else {
                alt = true;
            }
            if(latObj.Creatinine__c){
                creatinine = false;
            } else {
                creatinine = true;
            }
            if(latObj.MUGA_Scan__c){
                mugaScan = false;
            } else {
                mugaScan = true;
            }
            if(latObj.Cardiac_Echo__c){
                cardiacEcho = false;
            } else {
                cardiacEcho = true;
            }
        } else if(labAndTestId == null || labAndTestId == '') {
            latObj = new Lab_and_Test__c();
            latObj.Collection_Date__c = null;
        }
        isComplete = CRFUtilities.isReadOnlyUsr();
        if(latObj != null){
            //String crfId = latObj.CRF__c;
            //if(crfId != null && crfId != ''){
                //String status = CRFUtilities.CRFStatus(crfId);
                String status = latObj.Status__c;
                if(status == 'Approval Pending' || status == 'Accepted' || status == 'Approval Not Required' || status == 'Rejected'){
                    currentTab = 'Complete';
                    isComplete = false;
                    List<ArmPatient__c> lstArmPat = [select id,Arm_Id__c,Arm_Id__r.Name,assignedToPatient__c,TrialPatient__c from ArmPatient__c where TrialPatient__c = : trialPat and assignedToPatient__c = true];
                    System.debug('-----lstArmPat------>'+lstArmPat);
                    if(!lstArmPat.isEmpty()){
                        System.debug('-----lstArmPat------>'+lstArmPat[0].Arm_Id__r.Name);
                        armIdSelected = lstArmPat[0].Arm_Id__c;
                        armName = lstArmPat[0].Arm_Id__r.Name;
                        patientNotRandomized = false;
                        randomizationResult = true;
                    } else {
                        patientNotRandomized = true;
                        randomizationResult = false;
                    }
                } else {
                        currentTab = 'LabTests';
                }
            //}
        }
          isDelete();
    }
     public void isDelete(){
        
        System.debug('======labAndTestId=======' +labAndTestId);
        if(labAndTestId != null){
            pathObj = [select Id, Status__c from Lab_and_Test__c where id =:labAndTestId];
            
            if(pathObj != null && pathObj.Status__c != 'Not Completed'){
                isDelete = true;    
            }
        }
            
        System.debug('======labAndTestId=======' +labAndTestId); 
    }
    public pagereference redirect(){
            pagereference redirect = new pagereference('/apex/LabAndTestPdf?id='+labAndTestId);
            redirect.setRedirect(true);
            return redirect;
     }  
    
    public Pagereference insertCRF(){
        //String trialPat = Apexpages.currentPage().getParameters().get('trialPat');
        System.debug('--labAndTestId--------->'+labAndTestId);
        if(labAndTestId == null){
            
                latObj = new Lab_and_Test__c();
                List<Lab_and_Test__c> previousListObj = [Select l.Status__c, l.TrialPatient__c,l.CRF__c, l.Total_Bilirubin__c,l.Collection_Date_for_Investigative_Agent__c,l.MUGA_Scan__c,l.Cardiac_Echo__c,l.Cardiac_Echo_Date__c,l.Cardiac_Echo_LVEF__c,l.Cardiac_Echo_Institutional_Lower_Limit__c,l.MUGA_Scan_Date__c,l.MUGA_Scan_LVEF__c,l.MUGA_Institutional_Lower_Limit_of_Normal__c,l.Total_Bilirubin_Result__c, l.Total_Bilirubin_Institutional_Reference__c, l.SystemModstamp, l.Platelets__c, l.Platelets_Result__c, l.Platelets_Institutional_Reference_Range__c, l.OwnerId, l.Name, l.Leukocytes__c, l.Leukocytes_Result__c, l.Leukocytes_Institutional_Reference_Range__c, l.LastModifiedDate, l.LastModifiedById, l.IsDeleted, l.Id, l.Creatinine__c, l.Creatinine_Result__c, l.Creatinine_Institutional_Reference_Range__c, l.CreatedDate, l.CreatedById, l.CompletedDate__c, l.Collection_Date__c, l.Absolute_Neutrophil_Count_ANC__c, l.Absolute_Neutrophil_Count_ANC_Result__c, l.AST__c, l.AST_Result__c, l.AST_Institutional_Reference_Range__c, l.ANC_Industrial_Reference_Range__c, l.ALT__c, l.ALT_Result__c, l.ALT_Institutional_Reference_Range__c,l.Root_CRF_Id__c  From Lab_and_Test__c l where TrialPatient__c = :trialPat order by Effective_Time__c desc limit 1];
                if(previousListObj.size() > 0) {
                    latObj.Leukocytes_Institutional_Reference_Range__c = previousListObj[0].Leukocytes_Institutional_Reference_Range__c;
                    latObj.ANC_Industrial_Reference_Range__c = previousListObj[0].ANC_Industrial_Reference_Range__c;
                    latObj.Platelets_Institutional_Reference_Range__c = previousListObj[0].Platelets_Institutional_Reference_Range__c;
                    latObj.Total_Bilirubin_Institutional_Reference__c = previousListObj[0].Total_Bilirubin_Institutional_Reference__c;
                    latObj.AST_Institutional_Reference_Range__c = previousListObj[0].AST_Institutional_Reference_Range__c;
                    latObj.ALT_Institutional_Reference_Range__c = previousListObj[0].ALT_Institutional_Reference_Range__c;
                    latObj.Creatinine_Institutional_Reference_Range__c = previousListObj[0].Creatinine_Institutional_Reference_Range__c;
                    latObj.MUGA_Institutional_Lower_Limit_of_Normal__c = previousListObj[0].MUGA_Institutional_Lower_Limit_of_Normal__c;
                    latObj.Cardiac_Echo_Institutional_Lower_Limit__c = previousListObj[0].Cardiac_Echo_Institutional_Lower_Limit__c;
                    
                }
                system.debug('trialPat : '+trialPat);
                latObj.TrialPatient__c = trialPat;
                latObj.Collection_Date__c = null;
                try {
                    insert latObj;
                }catch (Exception e) {
                    Apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.ERROR, e.getMessage());
                    Apexpages.addMessage(msg);
                    return null;
                }
                
                /*if(previousListObj.size() > 0) {
                    List<CRFAdditionalQuestion__c> lstCRFAddQues = [Select c.QuestionAnswer__c, c.Id, c.CRFId__c, c.Answer__c, (Select QuestionId__c, Contextdata__c, ContextDataUnit__c, CRFAdditionalQuestion__c From AnswerOptions__r order by SNo__c ASC) From CRFAdditionalQuestion__c c where CRFId__c = :previousListObj[0].Id];
                    if(!lstCRFAddQues.isEmpty()) {
                        List<Sobject> lstCloneAddQues = CloneBuilder.cloneObjects(lstCRFAddQues);
                        for(Sobject sObj : lstCloneAddQues) {
                            sObj.put('CRFId__c', latObj.Id+'');
                        }
                        insert lstCloneAddQues;
                    }
                }*/
                
                
                System.debug('------latObj.Id--------->'+latObj.Id);
                System.debug('------trialPat--------->'+trialPat);
                //Pagereference pr = new Pagereference('/apex/LabAndTestDetails?trialPat='+trialPat+'&labAndTestId='+latObj.Id);
                Pagereference pr = new Pagereference('/'+latObj.Id);
                //pr.getParameters().put('nooverride', '1');
                pr.setRedirect(true);
                return pr;
             
        } 
        return null;
    }
    
    public Pagereference next(){
        system.debug('__currentTab__'+currentTab);
        String nextTabValue = Apexpages.currentPage().getParameters().get('tabNext');
        if(nextTabValue != null){
            nextTabName = nextTabValue;
        }
        system.debug('__nextTabValue__'+nextTabValue);
        system.debug('__nextTabName__'+nextTabName);
        //Id trialPat = Apexpages.currentPage().getParameters().get('trialPat');
        //labAndTestId = Apexpages.currentPage().getParameters().get('labAndTestId');
                        
        if(currentTab == 'LabTests'){
            isCollectionDate = false;
            if(latObj.Collection_Date__c > System.today()){
                latObj.Collection_Date__c.addError('Collection Date should not be greater than current date. ');
                isCollectionDate = true;
                return null;
            }
            
            if(latObj.Leukocytes_Institutional_Reference_Range__c != null) {
                if(latObj.Leukocytes_Institutional_Reference_Range__c == '-') {
                    latObj.Leukocytes_Institutional_Reference_Range__c.addError('Invalid range format. (Ex: 12.0-34)');
                    return null;
                }
                String[] sptRefRange = latObj.Leukocytes_Institutional_Reference_Range__c.split('-');
                for(String str : sptRefRange) {
                    if(str == null) continue;
                    try {
                      Decimal x = Decimal.valueOf(str);
                    } catch (exception e) {
                        latObj.Leukocytes_Institutional_Reference_Range__c.addError('Invalid range format. (Ex: 12.0-34)');
                        return null;
                    }
                }
            }
            
            if(latObj.ANC_Industrial_Reference_Range__c != null) {
                if(latObj.ANC_Industrial_Reference_Range__c == '-') {
                    latObj.ANC_Industrial_Reference_Range__c.addError('Invalid range format. (Ex: 12.0-34)');
                    return null;
                }
                String[] sptRefRange = latObj.ANC_Industrial_Reference_Range__c.split('-');
                for(String str : sptRefRange) {
                    if(str == null) continue;
                    try {
                      Decimal x = Decimal.valueOf(str);
                    } catch (exception e) {
                        latObj.ANC_Industrial_Reference_Range__c.addError('Invalid range format. (Ex: 12.0-34)');
                        return null;
                    }
                }
            }
            
             if(latObj.Platelets_Institutional_Reference_Range__c != null) {
                if(latObj.Platelets_Institutional_Reference_Range__c == '-') {
                    latObj.Platelets_Institutional_Reference_Range__c.addError('Invalid range format. (Ex: 12.0-34)');
                    return null;
                }
                String[] sptRefRange = latObj.Platelets_Institutional_Reference_Range__c.split('-');
                for(String str : sptRefRange) {
                    if(str == null) continue;
                    try {
                      Decimal x = Decimal.valueOf(str);
                    } catch (exception e) {
                        latObj.Platelets_Institutional_Reference_Range__c.addError('Invalid range format. (Ex: 12.0-34)');
                        return null;
                    }
                }
            }
            
            if(latObj.Total_Bilirubin_Institutional_Reference__c != null) {
                if(latObj.Total_Bilirubin_Institutional_Reference__c == '-') {
                    latObj.Total_Bilirubin_Institutional_Reference__c.addError('Invalid range format. (Ex: 12.0-34)');
                    return null;
                }
                String[] sptRefRange = latObj.Total_Bilirubin_Institutional_Reference__c.split('-');
                for(String str : sptRefRange) {
                    if(str == null) continue;
                    try {
                      Decimal x = Decimal.valueOf(str);
                    } catch (exception e) {
                        latObj.Total_Bilirubin_Institutional_Reference__c.addError('Invalid range format. (Ex: 12.0-34)');
                        return null;
                    }
                }
            }
            
            if(latObj.AST_Institutional_Reference_Range__c != null) {
                if(latObj.AST_Institutional_Reference_Range__c == '-') {
                    latObj.AST_Institutional_Reference_Range__c.addError('Invalid range format. (Ex: 12.0-34)');
                    return null;
                }
                String[] sptRefRange = latObj.AST_Institutional_Reference_Range__c.split('-');
                for(String str : sptRefRange) {
                    if(str == null) continue;
                    try {
                      Decimal x = Decimal.valueOf(str);
                    } catch (exception e) {
                        latObj.AST_Institutional_Reference_Range__c.addError('Invalid range format. (Ex: 12.0-34)');
                        return null;
                    }
                }
            }
            
            if(latObj.ALT_Institutional_Reference_Range__c != null) {
                if(latObj.ALT_Institutional_Reference_Range__c == '-') {
                    latObj.ALT_Institutional_Reference_Range__c.addError('Invalid range format. (Ex: 12.0-34)');
                    return null;
                }
                String[] sptRefRange = latObj.ALT_Institutional_Reference_Range__c.split('-');
                for(String str : sptRefRange) {
                    if(str == null) continue;
                    try {
                      Decimal x = Decimal.valueOf(str);
                    } catch (exception e) {
                        latObj.ALT_Institutional_Reference_Range__c.addError('Invalid range format. (Ex: 12.0-34)');
                        return null;
                    }
                }
            }
            
            if(latObj.Creatinine_Institutional_Reference_Range__c != null) {
                if(latObj.Creatinine_Institutional_Reference_Range__c == '-') {
                    latObj.Creatinine_Institutional_Reference_Range__c.addError('Invalid range format. (Ex: 12.0-34)');
                    return null;
                }
                String[] sptRefRange = latObj.Creatinine_Institutional_Reference_Range__c.split('-');
                for(String str : sptRefRange) {
                    if(str == null) continue;
                    try {
                      Decimal x = Decimal.valueOf(str);
                    } catch (exception e) {
                        latObj.Creatinine_Institutional_Reference_Range__c.addError('Invalid range format. (Ex: 12.0-34)');
                        return null;
                    }
                }
            }
            
            latObj.CompletedDate__c = System.today();
            //latObj.TrialPatient__c = trialPat;
            //System.debug('----trialPat----->'+trialPat);
            // Added by Shruti (DE401)
            try {
                upsert latObj;
            }catch (Exception e) {
                Apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.ERROR, e.getMessage());
                Apexpages.addMessage(msg);                 
            // Pagereference ref = new Pagereference('/apex/LabAndTestDetails?id='+labAndTestId);
            Pagereference ref = new Pagereference('/'+labAndTestId);
            ref.setRedirect(true);
             return ref;             
            } 
            // Added by Shruti (DE401)            
            System.debug('------latObj.Id--------->'+latObj.Leukocytes_Institutional_Reference_Range__c);
            System.debug('------latObj.Id--------->'+latObj.Leukocytes__c);
            System.debug('------latObj.Id--------->'+latObj.Leukocytes_Result__c); 
                
            if(latObj.Leukocytes__c){
                leukocytes = false;
            } else {
                leukocytes = true; 
            }
            if(latObj.Absolute_Neutrophil_Count_ANC__c){
                anc = false; 
                  
            } else {
                anc = true;     
            }
            if(latObj.Platelets__c){
                platelets = false;
            } else {
                platelets = true;
            }
            if(latObj.Total_Bilirubin__c){
                totalBilirubin = false;
            } else {
                totalBilirubin = true;
            }
            if(latObj.AST__c){
                ast = false;
            } else {
                ast = true;
            }
            if(latObj.ALT__c){
                alt = false;
            } else {
                alt = true;
            }
            if(latObj.Creatinine__c){
                creatinine = false;
            } else {
                creatinine = true;  
            } 
        } else if(currentTab == 'CardiacFunctionTest'){
            dateofProcedure = false;
            if(latObj.MUGA_Scan_Date__c > System.today()){          
                latObj.MUGA_Scan_Date__c.addError('Date of Procedure should not be greater than current date.');
                mugaScan = false;
                dateofProcedure = true;
                return null; 
            } 
            if(latObj.Cardiac_Echo_Date__c > System.today()){
                latObj.Cardiac_Echo_Date__c.addError('Date of Procedure should not be greater than current date.');
                cardiacEcho = false;
                dateofProcedure = true;
                return null;
            }
            
                try {
                    update latObj;
                }catch (Exception e) {
                    Apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.ERROR, e.getMessage());
                    Apexpages.addMessage(msg);
                    // Added by Shruti (DE401)
            // Pagereference ref = new Pagereference('/apex/LabAndTestDetails?id='+labAndTestId);
             Pagereference ref = new Pagereference('/'+labAndTestId);
            ref.setRedirect(true);
             return ref;
             // Added by Shruti (DE401)
                }
                System.debug('------latObj.Id--------->'+latObj.Leukocytes_Institutional_Reference_Range__c);
                /*List<Randomization_Form__c> lstRandomizationForm = [select id,Randomization_Result__c,TrialPatient__c from Randomization_Form__c where TrialPatient__c = :trialPat];
                if(lstRandomizationForm.size() > 0){
                    randomizationResult = lstRandomizationForm[0].Randomization_Result__c;
                    String[] randomResult = lstRandomizationForm[0].Randomization_Result__c.split(' + ');
                    for(String randRes : randomResult){
                        if(randRes.contains('Neratinib')){
                            neratinib = true;
                        }
                        if(randRes.contains('AMG 386')){
                            amg386 = true;
                        }
                        if(randRes.contains('Ganitumab')){
                            ganitumab = true;
                        }
                        if(randRes.contains('Figitumumab')){
                            figitumumab = true;
                        }
                        if(randRes.contains('ABT 888')){
                            abt888 = true;
                        }
                        if(randRes.contains('Trastuzumab')){
                            trastuzumab = true;
                        }
                    }
                } else {
                    patientNotRandomized = true;
                }*/
                /*List<ArmPatient__c> lstArmPat = [select id,Arm_Id__c,Arm_Id__r.Name,assignedToPatient__c,TrialPatient__c from ArmPatient__c where TrialPatient__c = : trialPat and assignedToPatient__c = true];
                System.debug('-----lstArmPat------>'+lstArmPat);
                if(!lstArmPat.isEmpty()){
                    System.debug('-----lstArmPat------>'+lstArmPat[0].Arm_Id__r.Name);
                    armIdSelected = lstArmPat[0].Arm_Id__c;
                    armName = lstArmPat[0].Arm_Id__r.Name;
                    patientNotRandomized = false;
                    randomizationResult = true;
                } else {
                    patientNotRandomized = true;
                    randomizationResult = false;
                }*/
            if(latObj.MUGA_Scan__c){
                mugaScan = false;
            } else {
                mugaScan = true;
            }
            if(latObj.Cardiac_Echo__c){
                cardiacEcho = false;
            } else {
                cardiacEcho = true;
            } 
        } else if(currentTab == 'InvestigativeAgentSpecificTests'){
            isCollectionDate1 = false;
            if(latObj.Collection_Date_for_Investigative_Agent__c > System.today()){         
                latObj.Collection_Date_for_Investigative_Agent__c.addError('Collection Date should not be greater than current date.');
                isCollectionDate1 = true;
                return null;
            } 
            
            if(randomizationResult){
                System.debug('-----randomizationResult------>'+randomizationResult);    
                if(!Test.isRunningTest()){
                    callAddQuesControllerMethod(latObj.Id);
                } 
            }
            try {
                update latObj;
            }catch (Exception e) {
                Apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.ERROR, e.getMessage());
                Apexpages.addMessage(msg);
                 // Added by Shruti (DE401)
            // Pagereference ref = new Pagereference('/apex/LabAndTestDetails?id='+labAndTestId);
            Pagereference ref = new Pagereference('/'+labAndTestId);
            ref.setRedirect(true);
             return ref;
             // Added by Shruti (DE401)
            } 
        } else if(currentTab == 'CommentsandAttachments'){
            System.debug('-----latObj.Id------>'+latObj.Id);
            System.debug('-----randomizationResult------>'+randomizationResult);
            
            try {
                update latObj;
            }catch (Exception e) {
                Apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.ERROR, e.getMessage());
                Apexpages.addMessage(msg);
                // Added by Shruti (DE401)
            // Pagereference ref = new Pagereference('/apex/LabAndTestDetails?id='+labAndTestId);
             Pagereference ref = new Pagereference('/'+labAndTestId);
            ref.setRedirect(true);
             return ref;
             // Added by Shruti (DE401)
            }
        } 
        if(nextTabName =='InvestigativeAgentSpecificTests' || nextTabName =='Complete' ){
            System.debug('trialPat : '+trialPat);
            List<ArmPatient__c> lstArmPat = [select id,Arm_Id__c,Arm_Id__r.Name,assignedToPatient__c,TrialPatient__c from ArmPatient__c where TrialPatient__c = : trialPat and assignedToPatient__c = true];
                System.debug('-----lstArmPat------>'+lstArmPat);
                if(!lstArmPat.isEmpty()){
                    System.debug('-----lstArmPat------>'+lstArmPat[0].Arm_Id__r.Name);
                    armIdSelected = lstArmPat[0].Arm_Id__c;
                    armName = lstArmPat[0].Arm_Id__r.Name;
                    patientNotRandomized = false; 
                    randomizationResult = true;
                } else {
                    patientNotRandomized = true; 
                    randomizationResult = false;
                } 
        } 
        else if(nextTabName == 'saveAndClose') {
//==================================For Save & Close Functionality ======================        
            latObj.First_Save_and_Close__c = true;
            try {
                update latObj;
            }catch (Exception e) {
                Apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.ERROR, e.getMessage());
                Apexpages.addMessage(msg);
                //Added by Shruti (DE401)
               // Pagereference ref = new Pagereference('/apex/LabAndTestDetails?id='+labAndTestId);
                Pagereference ref = new Pagereference('/'+labAndTestId);
                ref.setRedirect(true);
                return ref;
                //Added by Shruti (DE401)
            } 
//=======================================================================================            
            List<TrialPatient__c> trialPatList = [select Patient_Id__c, Trial_Id__c from TrialPatient__c where Id =:trialPat];
            if(!trialPatList.isEmpty()) {
                Pagereference pr = new Pagereference('/apex/TranscendPage?id='+trialPatList[0].Patient_Id__c+'&TrialId='+trialPatList[0].Trial_Id__c+'&sfdc.override=1');
                //Pagereference pr = new Pagereference('/'+trialPatList[0].Patient_Id__c);
                pr.setRedirect(true);
                return pr;
            }    
        }
        currentTab = nextTabName;
        return null;
    }
    
    public Pagereference customCancel(){
        //Id trialPat = Apexpages.currentPage().getParameters().get('trialPat');
        //labAndTestId = Apexpages.currentPage().getParameters().get('labAndTestId');
        if(labAndTestId != null){
            List<Lab_and_Test__c> latObj1 = [select id, Status__c, TrialPatient__c,TrialPatient__r.Patient_Id__c, TrialPatient__r.Trial_Id__c, OriginalCRF__c,Root_CRF_Id__c  from Lab_and_Test__c where id = : labAndTestId];
            if(!latObj1.isEmpty()){
              /*  if(latObj1[0].OriginalCRF__c == null)
                    delete latObj1[0];*/
                     if( labAndTestId != null) {
                     // Added by Shruti (DE401)
                try {
                delete new Lab_and_Test__c(id=labAndTestId);
            }catch (Exception e) {
                Apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.ERROR, e.getMessage());
                Apexpages.addMessage(msg);                 
             //Pagereference ref = new Pagereference('/apex/LabAndTestDetails?id='+labAndTestId);
             Pagereference ref = new Pagereference('/'+labAndTestId);
            ref.setRedirect(true);
             return ref;             
            } 
            // Added by Shruti (DE401)                        
                }  
            }
            if(!latObj1.isEmpty()){ 
                //Pagereference pr = new Pagereference('/'+latObj1[0].TrialPatient__r.Patient_Id__c);
                Pagereference pr = new Pagereference('/apex/TranscendPage?id='+latObj1[0].TrialPatient__r.Patient_Id__c+'&TrialId='+latObj1[0].TrialPatient__r.Trial_Id__c+'&sfdc.override=1');
               
               
               
                return pr;
            } else {
                return null;
            }
        } else if(trialPat != null){
            List<TrialPatient__c> lstTriPat = [select id,Patient_Id__c, Trial_Id__c from TrialPatient__c where id = : trialPat];
            List<Lab_and_Test__c> latObj1 = [select id, Status__c, TrialPatient__c,TrialPatient__r.Patient_Id__c, OriginalCRF__c, Root_CRF_Id__c from Lab_and_Test__c where id = : labAndTestId];
            Id patId = lstTriPat[0].Patient_Id__c;
            if(!latObj1.isEmpty()){
              /*  if(latObj1[0].OriginalCRF__c == null)
                    delete latObj1[0];*/
                     if( labAndTestId != null) {
                    // Added by Shruti (DE401)
                try {
                delete new Lab_and_Test__c(id=labAndTestId);
            }catch (Exception e) {
                Apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.ERROR, e.getMessage());
                Apexpages.addMessage(msg);                 
            // Pagereference ref = new Pagereference('/apex/LabAndTestDetails?id='+labAndTestId);
             Pagereference ref = new Pagereference('/'+labAndTestId);
            ref.setRedirect(true);
             return ref;             
            } 
            // Added by Shruti (DE401)                        
                }  
            }
            //Pagereference pr = new Pagereference('/'+patId);
            Pagereference pr = new Pagereference('/apex/TranscendPage?id='+patId+'&TrialId='+trialPat+'&sfdc.override=1');
              
            
            return pr;
        } else {
            return null;
        }
    }
    
    // public void previous(){
       public Pagereference previous(){ //Added by Shruti (DE401)
        String tabPrevious = Apexpages.currentPage().getParameters().get('tabPrevious');
        //Id trialPat = Apexpages.currentPage().getParameters().get('trialPat');
        
        if(tabPrevious == 'LabTests'){
            isCollectionDate = false;
        }
        if(tabPrevious == 'InvestigativeAgentSpecificTests'){
            List<ArmPatient__c> lstArmPat = [select id,Arm_Id__c,Arm_Id__r.Name,assignedToPatient__c,TrialPatient__c from ArmPatient__c where TrialPatient__c = : trialPat and assignedToPatient__c = true];
            System.debug('-----lstArmPat------>'+lstArmPat);
            if(!lstArmPat.isEmpty()){
                System.debug('-----lstArmPat------>'+lstArmPat[0].Arm_Id__r.Name);
                armIdSelected = lstArmPat[0].Arm_Id__c;
                armName = lstArmPat[0].Arm_Id__r.Name;
                patientNotRandomized = false;
                randomizationResult = true;
                if(randomizationResult){    
                    callAddQuesControllerMethod(latObj.Id);
                }
            } else {
                patientNotRandomized = true;
                randomizationResult = false;
            }
        }
        currentTab = tabPrevious;
        // Added by Shruti (DE401)
            try {
                    update latObj;
                }catch (Exception e) {
                    Apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.ERROR, e.getMessage());
                    Apexpages.addMessage(msg);
                    
            // Pagereference ref = new Pagereference('/apex/LabAndTestDetails?id='+labAndTestId);
             Pagereference ref = new Pagereference('/'+labAndTestId);
            ref.setRedirect(true);
             return ref;             
                }
             return null;
                // Added by Shruti (DE401)
    }
    
    /*public Pagereference submit(){
        update latObj;
        //callAddQuesControllerMethod(latObj.Id);
        Pagereference pr = new Pagereference('/'+latObj.Id);
        return pr;
    }*/
    
    public Pagereference signAndSubmit() {
        //ChangeAdhocToLiveController completeCrf = new ChangeAdhocToLiveController();
        //completeCrf.customAdhoc(latObj.Id+'', 'submit', 'Site');
        SignAndSubmitController signSubmit = new SignAndSubmitController();
        signSubmit.password = password;
        Pagereference ref = signSubmit.signAndSubmit('00055','',latObj.Id+'','Site'); 
        system.debug('errorMsg :  '+signSubmit.errorMsg);
        errorMsg = signSubmit.errorMsg;
        msgColor = 'Red';
        isDelete= true;
        return ref;
    }
    public String msgColor {get;set;}
    public void resendCode() {
        SignAndSubmitController ctr = new SignAndSubmitController();
        ctr.resendCode();
        errorMsg = 'Code Sent! Please check your Email.';
        msgColor = 'Green';
    }
    //=======================Edit main CRF After rejecting by DCC============================================================
    
   /* public Pagereference cloneCRF() {
        openInEditMode = true;
        //String clonedCRFId = CloneBuilder.cloneMe(latObj.Id, '0', '');
        latObj.Status__c = 'Not Completed';
        update latObj;
        return null;
    }*/
    
    public Pagereference editCRF() {
        if(isShowEditButton) {
            lstCloneLabAndTest[0].Status__c = 'Not Completed';
            try {
                update lstCloneLabAndTest[0];
            }catch (Exception e) {
                Apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.ERROR, e.getMessage());
                Apexpages.addMessage(msg);
                // Added by Shruti (DE401)
            // Pagereference ref = new Pagereference('/apex/LabAndTestDetails?id='+labAndTestId);
            Pagereference ref = new Pagereference('/'+labAndTestId);
            ref.setRedirect(true);
             return ref;
                // Added by Shruti (DE401)
            }
        }
        openInEditMode = false; 
        currentTab = 'LabTests';
        isComplete = true;
        Pagereference ref = new Pagereference('/apex/LabAndTestDetails?trialPat='+trialPat+'&labAndTestId='+clonedCRFId);
        ref.setRedirect(true);
        return ref;
    }
    
}