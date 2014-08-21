public with sharing class OnStudyPathology extends PageControllerBase {
    
    public DCISController dcisController {set;
    get{
        //get the map, then the component controller using the appropriate key
        if(getComponentControllerMap()!=null){
          DCISController mcc;
          mcc = (DCISController )getComponentControllerMap().get('dcis');
          if(mcc!= null)
             return mcc;
        }
        //just in case something goes wrong return something...this can be handled better
        return new DCISController(); 
    }
  }
  public void callDcisControllerMethod(Id ospId) {
    dcisController.saveDCIS(ospId); 
  } 
  
  public LCISController lcisController {set;
    get{
        //get the map, then the component controller using the appropriate key
        if(getComponentControllerMap()!=null){
          LCISController mcc;
          mcc = (LCISController )getComponentControllerMap().get('lcis');
          if(mcc!= null)
             return mcc;
        }
        //just in case something goes wrong return something...this can be handled better
        return new LCISController(); 
    }
  }
  public void callLcisControllerMethod(Id ospId) {
    lcisController.saveLCIS(ospId); 
  }
  
  public InvasiveTumor ivtController {set;
    get{
        //get the map, then the component controller using the appropriate key
        if(getComponentControllerMap()!=null){
          InvasiveTumor mcc;
          mcc = (InvasiveTumor )getComponentControllerMap().get('ivt');
          if(mcc!= null)
             return mcc;
        }
        //just in case something goes wrong return something...this can be handled better
        return new InvasiveTumor(); 
    }
  }
  public void callIvtControllerMethod(Id ospId) {
    ivtController.saveInvasiveTumor(ospId); 
  }
  
  public Receptors receptorsController {set;
    get{
        //get the map, then the component controller using the appropriate key
        if(getComponentControllerMap()!=null){
          Receptors mcc;
          mcc = (Receptors )getComponentControllerMap().get('rcpt');
          if(mcc!= null)
             return mcc;
        }
        //just in case something goes wrong return something...this can be handled better
        return new Receptors(); 
    }
  }
  public void callReceptorsControllerMethod(Id ospId) {
    receptorsController.insertRec(ospId); 
  }
  
    public On_Study_Pathology_Form__c ospObj{get;set;}
    public String currentTab {get;set;}
    public String ProcedureIds{get;set;}
    public String lymphProcedureIds{get;set;}
    //public String tumor{get;set;}
    public Boolean toShow{get;set;}
    public Boolean isPro{get;set;}
    public String tabNext{get;set;}
    public String tabPrevious{get;set;}
    public String mainLcisId {get;set;}
    public String isDCIS {get;set;}
    public String isLCIS {get;set;}
    public String isInasive {get;set;}
    public Id trailPat{get;set;}
    public String errorMsg1 {get;set;}
    public String password {get;set;}
    public Id PathologyId;
    public List<Procedure__c> lstproLymph {get;set;}
    public List<Procedure__c> lstproPositive {get;set;}
    private List<On_Study_Pathology_Form__c> lstCloneOsp{get;set;}
    public Boolean isComplete{get;set;}
    public Boolean isDelete{get;set;}
    public Boolean isShowEditButton{get;set;}
    private Id clonedCRFId{get;set;}
    public String proScanCheckString{get;set;}
    public String proLymphScanCheckString{get;set;}
    public List<positiveProWrapper> lstPositiveProWrapper{get; set;}
    public List<LymphProWrapper> lstLymphProWrapper{get; set;}
    public boolean openInEditMode {get;set;}
    public String nextTabName{get;set;} 
    public TrialPatient__c trialPatientObj {get;set;}
    public String profileName{get;set;}
    public On_Study_Pathology_Form__c pathObj{get;set;}
    
    public OnStudyPathology(ApexPages.StandardController controller) {
        String currentUserId = UserInfo.getUserId();
        for(User u :[Select  Profile.Name , ProfileId, Id, Name From User where id =:currentUserId]){            
            profileName = u.Profile.Name; 
        } 
        system.debug('__ok__');
        openInEditMode = false;
        isShowEditButton = false;
        toShow = false;
        isComplete = true;
        isDelete = false;
        PathologyId = null;
        isDCIS = '';
        isLCIS = '';
        isInasive = '';
        currentTab = 'procedureTab';
        
        PathologyId = Apexpages.currentPage().getParameters().get('PathologyId');
        if(PathologyId == null) {
            PathologyId = controller.getId();
        }
        system.debug('PathologyId: '+PathologyId);
        Apexpages.currentPage().getParameters().put('PathologyId',PathologyId);
        
        On_Study_Pathology_Form__c onStdPathologyFrmObj;
        if(PathologyId != null)onStdPathologyFrmObj = [Select o.TrialPatient__c From On_Study_Pathology_Form__c o where id =: PathologyId];
        
        if(onStdPathologyFrmObj != null){
            trailPat = onStdPathologyFrmObj.TrialPatient__c;
            PathologyId = onStdPathologyFrmObj.id;      
        }else{
            trailPat = Apexpages.currentPage().getParameters().get('trialPat');
            PathologyId = Apexpages.currentPage().getParameters().get('PathologyId');
        }
        
        if(trailPat != null) {
            List<TrialPatient__c> lstTrialPatient = [select Name, Patient_Id__c, Trial_Id__r.Name  from TrialPatient__c where Id = :trailPat];
            if(!lstTrialPatient.IsEmpty()) {
                trialPatientObj = lstTrialPatient[0];
            }
        }
        if(PathologyId != null){
            ospObj = [select Id,Root_CRF_Id__c,CRF__c,CRF__r.Status__c,Status__c, TrialPatient__c,Does_the_patient_have_bilateral_breast_c__c,Comments__c,Tumor_laterality__c,Is_DCIS_Present__c,Is_invasive_tumor_present__c,Is_LCIS_Present__c from On_Study_Pathology_Form__c where id = :PathologyId];
            lstCloneOsp = [select Id, Status__c,Root_CRF_Id__c  from On_Study_Pathology_Form__c where OriginalCRF__c =:PathologyId and Status__c = 'Cloned'];
            if(!lstCloneOsp.isEmpty()) {
                isShowEditButton = true;
                clonedCRFId = lstCloneOsp[0].Id;
            } 
        } else {
            ospObj = new On_Study_Pathology_Form__c();
            ospObj.TrialPatient__c = trailPat;
        }
        isComplete = CRFUtilities.isReadOnlyUsr(); 
        if(ospObj != null){
            //String crfId = ospObj.CRF__c;
            System.debug('----ospObj.CRF__c----->'+ospObj.CRF__c);
            System.debug('----ospObj.CRF__r.Status__c----->'+ospObj.CRF__r.Status__c);
            //if(crfId != null && crfId != ''){
                //String status = CRFUtilities.CRFStatus(crfId);
                String status = ospObj.Status__c;
                System.debug('----ospObj.CRF__r.Status__c----->'+ospObj.CRF__r.Status__c);
                if(status == 'Approval Pending' || status == 'Accepted' || status == 'Rejected'){
                    currentTab = 'Complete';
                    isComplete = false;
                    if(PathologyId != null){
                        lstproLymph = [Select p.Ultrasound__c, p.TrialPatient__c, p.Total_Positive__c, p.Total_Examined_Nodes__c, p.Stereotactic__c, p.Procedure_Name__c, p.Palpation_guided__c, p.On_Study_Pathology_Form__c, p.Node_Type__c, p.Node_Result__c, p.Name, p.Mammography__c, p.MRI__c, p.Location__c, p.Laterality__c, p.Form_Name__c, p.Date_Of_Procedure__c From Procedure__c p where p.On_Study_Pathology_Form__c = : PathologyId and p.Form_Name__c = 'On-Study Pathology Form(Lymph Node Biopsies)'];
                        System.debug('--------lstproLymph---------->'+lstproLymph);
                        lstproPositive = [Select p.Ultrasound__c, p.TrialPatient__c, p.Total_Positive__c, p.Total_Examined_Nodes__c, p.Stereotactic__c, p.Procedure_Name__c, p.Palpation_guided__c, p.On_Study_Pathology_Form__c, p.Node_Type__c, p.Node_Result__c, p.Name, p.Mammography__c, p.MRI__c, p.Location__c, p.Laterality__c, p.Form_Name__c, p.Date_Of_Procedure__c From Procedure__c p where p.On_Study_Pathology_Form__c = : PathologyId and p.Form_Name__c = 'On-Study Pathology Form(Positive Breast Biopsies)'];
                        lstPositiveProWrapper = new List<positiveProWrapper>();
                        for(Procedure__c positivePro : lstproPositive){
                            positiveProWrapper ppw = new positiveProWrapper();
                            ppw.proPositive = positivePro;
                            if(positivePro.Procedure_Name__c == 'Core biopsy') {
                                //proScanCheckString = '';
                                if(positivePro.Ultrasound__c) {
                                    ppw.proScanCheckString+='Ultrasound, ';
                                }
                                
                                if(positivePro.Palpation_guided__c) {
                                    ppw.proScanCheckString+='Palpation guided, ';
                                }
                                
                                if(positivePro.Mammography__c) {
                                    ppw.proScanCheckString+='Mammography, ';
                                }
                                
                                if(positivePro.MRI__c) {
                                    ppw.proScanCheckString+='MRI, ';
                                }
                                
                                if(positivePro.Stereotactic__c) {
                                    ppw.proScanCheckString+='Stereotactic, ';
                                }
                                
                                system.debug('__proScanCheckString__'+proScanCheckString);
                                if(proScanCheckString != null && proScanCheckString != '' && proScanCheckString.length() >= 2) {
                                    ppw.proScanCheckString = '('+ppw.proScanCheckString.substring(0, ppw.proScanCheckString.length()-2)+')';
                                }
                            }
                            lstPositiveProWrapper.add(ppw);
                        }
                        lstLymphProWrapper = new List<LymphProWrapper>();
                        for(Procedure__c lymphPro : lstproLymph){
                            LymphProWrapper lpw = new LymphProWrapper();
                            lpw.proLymph = lymphPro;
                            if(lymphPro.Procedure_Name__c == 'Core biopsy (lymph node)') {
                                if(lymphPro.Ultrasound__c) {
                                    lpw.proLymphScanCheckString+='Ultrasound, ';
                                }
                                
                                if(lymphPro.Palpation_guided__c) {
                                    lpw.proLymphScanCheckString+='Palpation guided, ';
                                }
                                
                                if(lymphPro.Mammography__c) {
                                    lpw.proLymphScanCheckString+='Mammography, ';
                                }
                                
                                if(lymphPro.MRI__c) {
                                    lpw.proLymphScanCheckString+='MRI, ';
                                }
                                
                                if(lymphPro.Stereotactic__c) {
                                    lpw.proLymphScanCheckString+='Stereotactic, ';
                                }
                                
                                system.debug('__proLymphScanCheckString__'+proLymphScanCheckString);
                                system.debug('__lpw.proLymphScanCheckString__'+lpw.proLymphScanCheckString);
                                if((lpw.proLymphScanCheckString != null || lpw.proLymphScanCheckString != '') && lpw.proLymphScanCheckString.length() >= 2) {
                                    lpw.proLymphScanCheckString = '('+lpw.proLymphScanCheckString.substring(0, lpw.proLymphScanCheckString.length()-2)+')';
                                }
                            }
                            lstLymphProWrapper.add(lpw);
                        }
                    }
                } 
            //}
        }
        isDelete();
    }
    
     public pagereference redirect(){
    pagereference redirect = new pagereference('/apex/OnStudyPathologyPdf?PathologyId='+PathologyId+'&trialPat='+trailPat);
    redirect.setRedirect(true);
    return redirect;
}
    public void isDelete(){
        
        System.debug('======PathologyId=======' +PathologyId);
        if(PathologyId != null){
            pathObj = [select Id, Status__c from On_Study_Pathology_Form__c where id =:PathologyId];
            
            if(pathObj != null && pathObj.Status__c != 'Not Completed'){
                isDelete = true;    
            }
        }
            
        System.debug('======pathObj =======' +pathObj);
    }
    
    public Pagereference insertPathology(){
        Id trailPat = Apexpages.currentPage().getParameters().get('trialPat');
        if(PathologyId != null){
            /*List<On_Study_Pathology_Form__c> lstOspEdit = [select Status__c, TrialPatient__c,Comments__c,Does_the_patient_have_bilateral_breast_c__c,Tumor_laterality__c from On_Study_Pathology_Form__c where id = :PathologyId];
            Pagereference pr = new Pagereference('/apex/OnStudyPathology?trialPat='+lstOspEdit[0].TrialPatient__c+'&formName=OnStudy+Pathology&PathologyId='+PathologyId);
            pr.getParameters().put('nooverride', '1');
            pr.setRedirect(true);
            return pr;*/
            return null;
        } else {
            ospObj = new On_Study_Pathology_Form__c();
            ospObj.TrialPatient__c = trailPat;
            RequiredFieldHandler.fromDataLoader = true;
            insert ospObj;
            Pagereference pr = new Pagereference('/apex/OnStudyPathology?trialPat='+trailPat+'&formName=OnStudy+Pathology&PathologyId='+ospObj.Id);
            pr.getParameters().put('nooverride', '1');
            pr.setRedirect(true);
            return pr;
        }
    } 
    
    public Pagereference next(){
        //Id trailPat = Apexpages.currentPage().getParameters().get('trialPat');
        String tabNext = Apexpages.currentPage().getParameters().get('tabNext');
        if(tabNext != null) {
            nextTabName = tabNext;
        }
        System.debug('----tabNext---->'+tabNext);
        System.debug('__nextTabName__'+nextTabName);
        System.debug('__currentTab__'+currentTab);
        
        if(currentTab == 'procedureTab'){  
            system.debug('--Does_the_patient_have_bilateral_breast_c__c --'+ospobj.Does_the_patient_have_bilateral_breast_c__c );
            
            if(isDCIS != ''){
                ospObj.Is_DCIS_Present__c = isDCIS;
            }
            if(isLCIS != ''){ 
                ospObj.Is_LCIS_Present__c = isLCIS;
            }
            if(isInasive != ''){
                ospObj.Is_invasive_tumor_present__c = isInasive;
            }
            if(!Test.isRunningTest()) {
                // Added by Shruti (DE401)
            try {
                upsert ospObj;
            }catch (Exception e) {
                Apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.ERROR, e.getMessage());
                Apexpages.addMessage(msg);                 
            // Pagereference ref = new Pagereference('/apex/OnStudyPathology?PathologyId='+PathologyId+'&trialPat='+trailPat);
             Pagereference ref = new Pagereference('/'+PathologyId);
            ref.setRedirect(true);
             return ref;             
            } 
            // Added by Shruti (DE401)                
            }
        } else if(currentTab == 'DiseaseDescription'){
            System.debug('-----isDCIS-------:'+isDCIS+'--------'+isLCIS+'---------------'+isInasive);
            system.debug('__ospObj.Is_DCIS_Present__c__'+ospObj.Is_DCIS_Present__c);
            
            Boolean isValid = DiseaseDescriptionValidation();
            if(!isValid && !Test.isRunningTest()) {
                return null;
            }
            
            if(isDCIS != ''){  
                ospObj.Is_DCIS_Present__c = isDCIS;   
            } 
            if(isLCIS != ''){
                ospObj.Is_LCIS_Present__c = isLCIS;
            }
            if(isInasive != ''){
                ospObj.Is_invasive_tumor_present__c = isInasive;
            }  
            if(!Test.isRunningTest()) {
                 // Added by Shruti (DE401)
            try {
                update ospObj;
            }catch (Exception e) {
                Apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.ERROR, e.getMessage());
                Apexpages.addMessage(msg);                 
            // Pagereference ref = new Pagereference('/apex/OnStudyPathology?PathologyId='+PathologyId+'&trialPat='+trailPat);
             Pagereference ref = new Pagereference('/'+PathologyId);
            ref.setRedirect(true);
             return ref;             
            } 
            // Added by Shruti (DE401)
                        
            }
            system.debug('--Punctate_necrosis__c--'+DCISController.dcisObj.Punctate_necrosis__c );
              
            System.debug('-----isDCIS-------:'+ospObj.Is_DCIS_Present__c+'--------'+ospObj.Is_LCIS_Present__c+'---------------'+ospObj.Is_invasive_tumor_present__c);
            system.debug('__DCISController.dcisObj.Nuclear_Grade__c__'+DCISController.dcisObj.Nuclear_Grade__c);
            if(ospObj.Is_DCIS_Present__c == 'Yes' && !Test.isRunningTest()) {
                callDcisControllerMethod(ospObj.Id);
            }  
            if(ospObj.Is_LCIS_Present__c == 'Yes' && !Test.isRunningTest()) {
                callLcisControllerMethod(ospObj.Id);
            }
            if(ospObj.Is_invasive_tumor_present__c == 'Yes' && !Test.isRunningTest()) {
                callIvtControllerMethod(ospObj.Id);
            }
        } else if(currentTab == 'Receptors'){
            System.debug('-----Receptors----->');
            
            Boolean isValid = receptorTabValidation();
            if(!isValid && !Test.isRunningTest()) {
                return null;
            }                   
            
            if(!Test.isRunningTest()) {
                // Added by Shruti (DE401)
            try {
                update ospObj;
            }catch (Exception e) {
                Apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.ERROR, e.getMessage());
                Apexpages.addMessage(msg);                 
            // Pagereference ref = new Pagereference('/apex/OnStudyPathology?PathologyId='+PathologyId+'&trialPat='+trailPat);
             Pagereference ref = new Pagereference('/'+PathologyId);
             ref.setRedirect(true);
             return ref;             
            } 
            // Added by Shruti (DE401)                
                callReceptorsControllerMethod(ospObj.Id);
            }
            if(!Test.isRunningTest()) {
                ospObj = [select Id,Root_CRF_Id__c, Status__c, TrialPatient__c,Does_the_patient_have_bilateral_breast_c__c,Comments__c,Tumor_laterality__c,Is_DCIS_Present__c,Is_invasive_tumor_present__c,Is_LCIS_Present__c from On_Study_Pathology_Form__c where id = :PathologyId];
            }
            lstproLymph = [Select p.Ultrasound__c, p.TrialPatient__c, p.Total_Positive__c, p.Total_Examined_Nodes__c, p.Stereotactic__c, p.Procedure_Name__c, p.Palpation_guided__c, p.On_Study_Pathology_Form__c, p.Node_Type__c, p.Node_Result__c, p.Name, p.Mammography__c, p.MRI__c, p.Location__c, p.Laterality__c, p.Form_Name__c, p.Date_Of_Procedure__c From Procedure__c p where p.On_Study_Pathology_Form__c = : PathologyId and p.Form_Name__c = 'On-Study Pathology Form(Lymph Node Biopsies)'];
            System.debug('--------lstproLymph---------->'+lstproLymph);
            lstproPositive = [Select p.Ultrasound__c, p.TrialPatient__c, p.Total_Positive__c, p.Total_Examined_Nodes__c, p.Stereotactic__c, p.Procedure_Name__c, p.Palpation_guided__c, p.On_Study_Pathology_Form__c, p.Node_Type__c, p.Node_Result__c, p.Name, p.Mammography__c, p.MRI__c, p.Location__c, p.Laterality__c, p.Form_Name__c, p.Date_Of_Procedure__c From Procedure__c p where p.On_Study_Pathology_Form__c = : PathologyId and p.Form_Name__c = 'On-Study Pathology Form(Positive Breast Biopsies)'];
            lstPositiveProWrapper = new List<positiveProWrapper>();
            for(Procedure__c positivePro : lstproPositive){
                positiveProWrapper ppw = new positiveProWrapper();
                ppw.proPositive = positivePro;
                if(positivePro.Procedure_Name__c == 'Core biopsy') {
                    if(positivePro.Ultrasound__c) {
                        ppw.proScanCheckString+='Ultrasound, ';
                    }
                    
                    if(positivePro.Palpation_guided__c) {
                        ppw.proScanCheckString+='Palpation guided, ';
                    }
                    
                    if(positivePro.Mammography__c) {
                        ppw.proScanCheckString+='Mammography, ';
                    }
                    
                    if(positivePro.MRI__c) {
                        ppw.proScanCheckString+='MRI, ';
                    }
                    
                    if(positivePro.Stereotactic__c) {
                        ppw.proScanCheckString+='Stereotactic, ';
                    }
                    
                    system.debug('__proScanCheckString__'+proScanCheckString);
                    system.debug('__ppw.proScanCheckString__'+ppw.proScanCheckString);
                    if((ppw.proScanCheckString != null || ppw.proScanCheckString != '') && ppw.proScanCheckString.length() >= 2) {
                        ppw.proScanCheckString = '('+ppw.proScanCheckString.substring(0, ppw.proScanCheckString.length()-2)+')';
                    }
                }
                lstPositiveProWrapper.add(ppw);
            }
            lstLymphProWrapper = new List<LymphProWrapper>();
            for(Procedure__c lymphPro : lstproLymph){
                LymphProWrapper lpw = new LymphProWrapper();
                lpw.proLymph = lymphPro;
                if(lymphPro.Procedure_Name__c == 'Core biopsy (lymph node)') {
                    if(lymphPro.Ultrasound__c) {
                        lpw.proLymphScanCheckString+='Ultrasound, ';
                    }
                    
                    if(lymphPro.Palpation_guided__c) {
                        lpw.proLymphScanCheckString+='Palpation guided, ';
                    }
                    
                    if(lymphPro.Mammography__c) {
                        lpw.proLymphScanCheckString+='Mammography, ';
                    }
                    
                    if(lymphPro.MRI__c) {
                        lpw.proLymphScanCheckString+='MRI, ';
                    }
                    
                    if(lymphPro.Stereotactic__c) {
                        lpw.proLymphScanCheckString+='Stereotactic, ';
                    }
                    
                    system.debug('__proLymphScanCheckString__'+proLymphScanCheckString);
                    system.debug('__lpw.proLymphScanCheckString__'+lpw.proLymphScanCheckString);
                    if((lpw.proLymphScanCheckString != null || lpw.proLymphScanCheckString != '') && lpw.proLymphScanCheckString.length() >= 2) {
                        lpw.proLymphScanCheckString = '('+lpw.proLymphScanCheckString.substring(0, lpw.proLymphScanCheckString.length()-2)+')';
                    }
                }
                lstLymphProWrapper.add(lpw);
            }
        }
         
       if(nextTabName == 'Complete'){
            //ChangeAdhocToLiveController completeCrf = new ChangeAdhocToLiveController();
            //completeCrf.customAdhoc(ospObj.Id+'', 'submit', 'Site');
            
            //6/8/13
            lstproLymph = [Select p.Ultrasound__c, p.TrialPatient__c, p.Total_Positive__c, p.Total_Examined_Nodes__c, p.Stereotactic__c, p.Procedure_Name__c, p.Palpation_guided__c, p.On_Study_Pathology_Form__c, p.Node_Type__c, p.Node_Result__c, p.Name, p.Mammography__c, p.MRI__c, p.Location__c, p.Laterality__c, p.Form_Name__c, p.Date_Of_Procedure__c From Procedure__c p where p.On_Study_Pathology_Form__c = : PathologyId and p.Form_Name__c = 'On-Study Pathology Form(Lymph Node Biopsies)'];
            System.debug('--------lstproLymph---------->'+lstproLymph);
            lstproPositive = [Select p.Ultrasound__c, p.TrialPatient__c, p.Total_Positive__c, p.Total_Examined_Nodes__c, p.Stereotactic__c, p.Procedure_Name__c, p.Palpation_guided__c, p.On_Study_Pathology_Form__c, p.Node_Type__c, p.Node_Result__c, p.Name, p.Mammography__c, p.MRI__c, p.Location__c, p.Laterality__c, p.Form_Name__c, p.Date_Of_Procedure__c From Procedure__c p where p.On_Study_Pathology_Form__c = : PathologyId and p.Form_Name__c = 'On-Study Pathology Form(Positive Breast Biopsies)'];
            lstPositiveProWrapper = new List<positiveProWrapper>();
            for(Procedure__c positivePro : lstproPositive){
                positiveProWrapper ppw = new positiveProWrapper();
                ppw.proPositive = positivePro;
                if(positivePro.Procedure_Name__c == 'Core biopsy') {
                    if(positivePro.Ultrasound__c) {
                        ppw.proScanCheckString+='Ultrasound, ';
                    }
                    
                    if(positivePro.Palpation_guided__c) {
                        ppw.proScanCheckString+='Palpation guided, ';
                    }
                    
                    if(positivePro.Mammography__c) {
                        ppw.proScanCheckString+='Mammography, ';
                    }
                    
                    if(positivePro.MRI__c) {
                        ppw.proScanCheckString+='MRI, ';
                    }
                    
                    if(positivePro.Stereotactic__c) {
                        ppw.proScanCheckString+='Stereotactic, ';
                    }
                    
                    system.debug('__proScanCheckString__'+proScanCheckString);
                    system.debug('__ppw.proScanCheckString__'+ppw.proScanCheckString);
                    if((ppw.proScanCheckString != null || ppw.proScanCheckString != '') && ppw.proScanCheckString.length() >= 2) {
                        ppw.proScanCheckString = '('+ppw.proScanCheckString.substring(0, ppw.proScanCheckString.length()-2)+')';
                    }
                }
                lstPositiveProWrapper.add(ppw);
            }
            lstLymphProWrapper = new List<LymphProWrapper>();
            for(Procedure__c lymphPro : lstproLymph){
                LymphProWrapper lpw = new LymphProWrapper();
                lpw.proLymph = lymphPro;
                if(lymphPro.Procedure_Name__c == 'Core biopsy (lymph node)') {
                    if(lymphPro.Ultrasound__c) {
                        lpw.proLymphScanCheckString+='Ultrasound, ';
                    }
                    
                    if(lymphPro.Palpation_guided__c) {
                        lpw.proLymphScanCheckString+='Palpation guided, ';
                    }
                    
                    if(lymphPro.Mammography__c) {
                        lpw.proLymphScanCheckString+='Mammography, ';
                    }
                    
                    if(lymphPro.MRI__c) {
                        lpw.proLymphScanCheckString+='MRI, ';
                    }
                    
                    if(lymphPro.Stereotactic__c) {
                        lpw.proLymphScanCheckString+='Stereotactic, ';
                    }
                    
                    system.debug('__proLymphScanCheckString__'+proLymphScanCheckString);
                    system.debug('__lpw.proLymphScanCheckString__'+lpw.proLymphScanCheckString);
                    if((lpw.proLymphScanCheckString != null || lpw.proLymphScanCheckString != '') && lpw.proLymphScanCheckString.length() >= 2) {
                        lpw.proLymphScanCheckString = '('+lpw.proLymphScanCheckString.substring(0, lpw.proLymphScanCheckString.length()-2)+')';
                    }
                }
                lstLymphProWrapper.add(lpw);
            }
            //6/8/13
            }
        
        if(nextTabName == 'saveAndClose'){
 //===========================For Save & Close Functionality ===========================       
        ospObj.First_Save_and_Close__c = true;
           // Added by Shruti (DE401)
            try {
                update ospObj;
            }catch (Exception e) {
                Apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.ERROR, e.getMessage());
                Apexpages.addMessage(msg);                 
            Pagereference ref = new Pagereference('/apex/OnStudyPathology?PathologyId='+PathologyId+'&trialPat='+trailPat);
            //Pagereference ref = new Pagereference('/'+PathologyId);
            ref.setRedirect(true);
             return ref;             
            } 
            // Added by Shruti (DE401)
           
 //=====================================================================================          
            List<TrialPatient__c> trialPatList = [select Patient_Id__c, Trial_Id__c from TrialPatient__c where Id =:trailPat];
            if(!trialPatList.isEmpty()) {
                Pagereference pr = new Pagereference('/apex/TranscendPage?id='+trialPatList[0].Patient_Id__c+'&TrialId='+trialPatList[0].Trial_Id__c+'&sfdc.override=1');
                //Pagereference pr = new Pagereference('/apex/TranscendPage?id='+trialPatList[0].Patient_Id__c+'&sfdc.override=1');
                pr.setRedirect(true);
                return pr;
            }    
        }
        currentTab = nextTabName;
        return null; 
    }
    
    public Pagereference customCancel(){
        //PathologyId = Apexpages.currentPage().getParameters().get('PathologyId');
        System.debug('-----PathologyId---->'+PathologyId);
        if(PathologyId != null){
            List<On_Study_Pathology_Form__c> lstOsp = [select id,Root_CRF_Id__c, OriginalCRF__c, Status__c, TrialPatient__c,TrialPatient__r.Patient_Id__c, TrialPatient__r.Trial_Id__c from On_Study_Pathology_Form__c where id = : PathologyId];
            Id patId = lstOsp[0].TrialPatient__r.Patient_Id__c;
            if(!lstOsp.isEmpty() && !Test.isRunningTest()){
             /*   if(lstOsp[0].OriginalCRF__c == null)
                    delete lstOsp[0];*/
             // ---------------------- for delete -------------------//       
                  if( PathologyId != null) {
                    // Added by Shruti (DE401)
            try {
                delete new On_Study_Pathology_Form__c(id=PathologyId);
            }catch (Exception e) {
                Apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.ERROR, e.getMessage());
                Apexpages.addMessage(msg);                 
            // Pagereference ref = new Pagereference('/apex/OnStudyPathology?PathologyId='+PathologyId+'&trialPat='+trailPat);
             Pagereference ref = new Pagereference('/'+PathologyId);
            ref.setRedirect(true);
             return ref;             
            } 
            // Added by Shruti (DE401)                        
                } 
             // ---------------------- for delete -------------------//      
            }
            Pagereference pr = new Pagereference('/apex/TranscendPage?id='+patId+'&TrialId='+lstOsp[0].TrialPatient__r.Trial_Id__c+'&sfdc.override=1');
            //Pagereference pr = new Pagereference('/apex/TranscendPage?id='+patId+'&sfdc.override=1');
            pr.setRedirect(true);
            return pr;
        } else {
            return null;
        }
    }
    
    // public void previous(){
       public Pagereference previous(){ //Added by Shruti (DE401)
        String tabPrevious = Apexpages.currentPage().getParameters().get('tabPrevious');
        System.debug('-----isDCIS-------:'+isDCIS+'--------'+isLCIS+'---------------'+isInasive);
        System.debug('-----isDCIS-------:'+ospObj.Is_DCIS_Present__c+'--------'+ospObj.Is_LCIS_Present__c+'---------------'+ospObj.Is_invasive_tumor_present__c);
        currentTab = tabPrevious;
        // Added by Shruti (DE401)
            try {
                update ospObj;
            }catch (Exception e) {
                Apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.ERROR, e.getMessage());
                Apexpages.addMessage(msg);                 
            // Pagereference ref = new Pagereference('/apex/OnStudyPathology?PathologyId='+PathologyId+'&trialPat='+trailPat);
             Pagereference ref = new Pagereference('/'+PathologyId);
            ref.setRedirect(true);
             return ref;             
            }
             return null; 
            // Added by Shruti (DE401) 
    }
    
    public void onChangeVal(){
        System.debug('-------onChange------->');
        toShow = true;
    }
    
    public Pagereference submit() {
        if(!Test.isRunningTest()) {
            update ospObj;
            callReceptorsControllerMethod(ospObj.Id);
        }
        Pagereference pr = new Pagereference('/'+ospObj.Id);
        return pr;
    }
    
    public Pagereference signAndSubmit() {
        
        Boolean isValidDiseaseDescription = DiseaseDescriptionValidation();
        if(!isValidDiseaseDescription && !Test.isRunningTest()) {
            currentTab = 'DiseaseDescription';
             return null;
        }
        Boolean isValidReceptor = receptorTabValidation();
        if(!isValidReceptor && !Test.isRunningTest()) {
            currentTab = 'Receptors';
             return null;
        }
        
        //ChangeAdhocToLiveController completeCrf = new ChangeAdhocToLiveController();
        //completeCrf.customAdhoc(ospObj.Id+'', 'submit', 'Site');
            
        SignAndSubmitController signSubmit = new SignAndSubmitController();
        signSubmit.password = password;
        Pagereference ref;
        if(!Test.isRunningTest()) {
            ref = signSubmit.signAndSubmit('00054','',ospObj.Id+'', 'Site');
        }
        system.debug('errorMsg :  '+signSubmit.errorMsg);
        errorMsg1 = signSubmit.errorMsg;
        msgColor = 'Red';
        isDelete= true;
        return ref;
    }
    public String msgColor {get;set;}
    public void resendCode() {
        SignAndSubmitController ctr = new SignAndSubmitController();
        ctr.resendCode();
        errorMsg1 = 'Code Sent! Please check your Email.';
        msgColor = 'Green';
    }
    
    public class positiveProWrapper {
        public Procedure__c proPositive {get; set;}
        public String proScanCheckString {get;set;}
        public positiveProWrapper(){
            proScanCheckString = '';
        }
    }
    
    public class LymphProWrapper {
        public Procedure__c proLymph {get; set;}
        public String proLymphScanCheckString{get; set;}
        public LymphProWrapper(){
            proLymphScanCheckString = '';
        }
    }
    //=======================Edit main CRF After rejecting by DCC============================================================
    
    public Pagereference cloneCRF() {
        openInEditMode = false;
        //String clonedCRFId = CloneBuilder.cloneMe(ospObj.Id, '0', '');
        ospObj.Status__c = 'Not Completed';
        update ospObj;
        return null;
    }
    
    public Pagereference editCRF() {
        if(isShowEditButton) {
            lstCloneOsp[0].Status__c = 'Not Completed';
            // Added by Shruti (DE401)
            try {
                update lstCloneOsp[0];
            }catch (Exception e) {
                Apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.ERROR, e.getMessage());
                Apexpages.addMessage(msg);                 
           //  Pagereference ref = new Pagereference('/apex/OnStudyPathology?PathologyId='+PathologyId+'&trialPat='+trailPat);
             Pagereference ref = new Pagereference('/'+PathologyId);
             ref.setRedirect(true);
             return ref;             
            } 
            // Added by Shruti (DE401)            
        }
        openInEditMode = false;
        currentTab = 'procedureTab';
        isComplete = true;
        Pagereference ref = new Pagereference('/apex/OnStudyPathology?trialPat='+trailPat+'&formName=OnStudy+Pathology&PathologyId='+clonedCRFId);
        ref.setRedirect(true);
        return ref;
    }
    
    private Boolean DiseaseDescriptionValidation() {
        Boolean isValidFlag = true;
        if(ospObj.Is_DCIS_Present__c == null) {   
            ospObj.Is_DCIS_Present__c.addError('Please select Is DCIS Present');
            isValidFlag = false;
        }          

        if(ospObj.Is_LCIS_Present__c == null) {   
            ospObj.Is_LCIS_Present__c.addError('Please select Is LCIS Present');   
            isValidFlag = false;
        }     
        if(ospObj.Is_invasive_tumor_present__c == null) {   
            ospObj.Is_invasive_tumor_present__c.addError('Please select Is invasive tumor present');
            isValidFlag = false;
        }
        
        if(ospObj.Is_DCIS_Present__c == 'Yes') {        
            if(dcisController.dcisObj.Comedonecrosis__c != true && dcisController.dcisObj.Punctate_necrosis__c != true && dcisController.dcisObj.Papillary__c != true && dcisController.dcisObj.Micropapillary__c != true &&  dcisController.dcisObj.Necrosis__c != true  && dcisController.dcisObj.Cribiform__c != true &&  dcisController.dcisObj.Cruciform__c != true &&  dcisController.dcisObj.Clinging__c!= true &&  dcisController.dcisObj.Solid__c != true &&  dcisController.dcisObj.Apocrine__c != true && dcisController.dcisObj.Intra_cystic_encysted_papillary__c != true && dcisController.dcisObj.Other__c != true ){
                dcisController.dcisObj.addError('Please select DCIS Histology type');   
                isValidFlag = false;                        
            }
            
            if(dcisController.dcisObj.Calcifications__c == null){
                dcisController.dcisObj.Calcifications__c.addError('Please select DCIS Calcifications');
                isValidFlag = false;
            }
            if(dcisController.dcisObj.Nuclear_Grade__c == null){
                dcisController.dcisObj.Nuclear_Grade__c.addError('Please select DCIS Nuclear grade');
                isValidFlag = false;
            }
        }         
                 
        if(ospObj.Is_LCIS_Present__c == 'Yes') {
            if(LCISController.lcisObj.Histological_Type__c ==null ){
                LCISController.lcisObj.Histological_Type__c.addError('Please select LCIS type');
               isValidFlag = false;
            }               
        }   
             
        if(ospObj.Is_invasive_tumor_present__c == 'Yes') {
            if(ivtController.objITD.Invasive_ductal_carcinoma_nos__c != true && ivtController.objITD.Invasive_lobular_carcinoma_classic_type__c != true && ivtController.objITD.Invasive_lobular_carcinoma_alveolar_type__c != true && ivtController.objITD.Pleomorphic_lobular_carcinoma__c != true && ivtController.objITD.Tubulolobular_carcinoma__c != true && ivtController.objITD.Invasive_carcinoma_mixed_ductal_lobular__c != true && ivtController.objITD.Tubular_carcinoma__c != true && ivtController.objITD.Mucinous_carcinoma__c != true && ivtController.objITD.Medullary_carcinoma__c != true && ivtController.objITD.Invasive_papillary_carcinoma__c != true && ivtController.objITD.Invasive_cribiform_carcinoma__c != true && ivtController.objITD.Other__c != true  ){
                ivtController.objITD.addError('Please select Invasive histology');
                isValidFlag = false;
            }
            if(ivtController.objITD.Calcifications__c == null){
                ivtController.objITD.Calcifications__c.addError('Please select Invasive Calcifications');
                isValidFlag = false;
            }
            if(ivtController.objITD.Nuclear_Grade__c == null){
                ivtController.objITD.Nuclear_Grade__c.addError('Please select Invasive Nuclear Grade');
                isValidFlag = false;
            }
            if(ivtController.objITD.Mitotic_Count__c == null){
                ivtController.objITD.Mitotic_Count__c.addError('Please select  Mitotic Count');  
                isValidFlag = false;
            }
            if(ivtController.objITD.Tubule_Papilla_formation__c == null){  
                ivtController.objITD.Tubule_Papilla_formation__c.addError('Please select Tubule/Papilla formation');
                isValidFlag = false;
            }
            if(ivtController.objITD.Lympatic_vascular_Invasion__c == null){
                ivtController.objITD.Lympatic_vascular_Invasion__c.addError('Please select Lympatic-vascular Invasion');
                isValidFlag = false;
            }
            if(ivtController.objITD.Skin_Involvement__c == null){
                ivtController.objITD.Skin_Involvement__c.addError('Please select Skin Involvement');
                isValidFlag = false;
            }
        }
        return isValidFlag;
    }
    
    private Boolean receptorTabValidation() {
        Boolean isValidFlag = true;
        if(receptorsController.recObj.Estrogen_Receptor_Status__c ==null){
            receptorsController.recObj.Estrogen_Receptor_Status__c.addError('Please select Estrogen Receptor Status From Estrogen Receptor (ER) ');
            isValidFlag = false;
        }
        
        /*if(receptorsController.recObj.Estrogen_Receptor_Proportion_Score__c == null){
            receptorsController.recObj.addError('Please select Proportion Score From Estrogen Receptor (ER) ');
            return;
        }
        if(receptorsController.recObj.Estrogen_Intensity_Score__c == null){
            receptorsController.recObj.addError('Please select Intensity Score  From Estrogen Receptor (ER)');
            return;
        } */
          
        if(receptorsController.recObj.Progesterone_Receptor_Status__c ==null){
            receptorsController.recObj.Progesterone_Receptor_Status__c.addError('Please select Progesterone Receptor Status From Progesterone Receptor (PR) ');
            isValidFlag = false;
        }
                            
        /*if(receptorsController.recObj.Progesterone_Receptor_Proportion_Score__c == null){
            receptorsController.recObj.addError('Please select Proportion Score From Progesterone Receptor (PR)  ');
            return;
        }
        if(receptorsController.recObj.Progesterone_Intensity_Score__c == null){
            receptorsController.recObj.addError('Please select Intensity Score From Progesterone Receptor (PR)  ');
            return;  
        }*/ 
        
        if(receptorsController.recObj.IHC__c == null){
            receptorsController.recObj.IHC__c.addError('Please select HER2/neu Marker Status(IHC)');
            isValidFlag = false;
        }
        /*if(receptorsController.recObj.DAKO_Herceptest__c !=true && receptorsController.recObj.Other_IHC_Test__c !=true && receptorsController.recObj.Ventana_kit__c !=true && receptorsController.recObj.CB_11__c !=true && receptorsController.recObj.IHC_test_not_done__c !=true ){
            receptorsController.recObj.addError('Please select HER2/neu IHC values');
            return;
        } */
        
        if(receptorsController.recObj.Fish__c ==null){
            receptorsController.recObj.Fish__c.addError('Please select HER2/neu Fish Marker Status(FISH)'); 
            isValidFlag = false;
        }
        /*if(receptorsController.recObj.Ventana_Oncoprobe__c !=true && receptorsController.recObj.Other_FISH_Test__c !=true && receptorsController.recObj.Other_FISH_Test__c !=true && receptorsController.recObj.FISH_test_not_done__c !=true){
            receptorsController.recObj.addError('Please select HER2/neu FISH Values');
            return;
        }   */
        return isValidFlag;
    }
}