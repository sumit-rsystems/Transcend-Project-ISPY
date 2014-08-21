public with sharing class PostSurgerySummaryController extends PageControllerBase {
     
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
  public void callDcisControllerMethod(Id postId) {
    dcisController.savePostDCIS(postId);
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
  public void callLcisControllerMethod(Id postId) {
    lcisController.savePostLCIS(postId); 
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
  public void callIvtControllerMethod(Id postId) {
    ivtController.savePostInvasiveTumor(postId); 
  }
  
  public Receptors leftReceptorsCont {set;
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
  
  public void callReceptorsControllerMethodLeft(Id postId) {
    leftReceptorsCont.insertRecPostLeft(postId); 
  }
  
  public Receptors rightReceptorsCont {set;
    get{
        //get the map, then the component controller using the appropriate key
        if(getComponentControllerMap()!=null){
          Receptors mcc;
          mcc = (Receptors )getComponentControllerMap().get('rcptRight');
          if(mcc!= null)
             return mcc;
        }
        //just in case something goes wrong return something...this can be handled better
        return new Receptors(); 
    }
  }
  
  public void callReceptorsControllerMethodRight(Id postId) {
    rightReceptorsCont.insertRecPostRight(postId); 
  }
  
  public StagingComponentController StagingLeft {set;
    get{
        //get the map, then the component controller using the appropriate key
        if(getComponentControllerMap()!=null){
          StagingComponentController mcc;
          mcc = (StagingComponentController )getComponentControllerMap().get('stag');
          if(mcc!= null)
             return mcc;
        }
        //just in case something goes wrong return something...this can be handled better
        return new StagingComponentController();
    }
  }
  public void callStagingControllerMethodLeft(Id postId) {
    system.debug('__StagingLeft.stagObjLeft__'+StagingLeft.stagObjLeft);
    system.debug('__StagingLeft.stagObjLeft.Adjudicated_Stage__c__'+StagingLeft.stagObjLeft.Adjudicated_Stage__c);
    StagingLeft.insertStageLeft(postId); 
  }
  
  public StagingComponentController StagingRight {set;
    get{
        //get the map, then the component controller using the appropriate key
        if(getComponentControllerMap()!=null){
          StagingComponentController mccRight;
          mccRight = (StagingComponentController )getComponentControllerMap().get('stagRight');
          if(mccRight!= null)
             return mccRight;
        }
        //just in case something goes wrong return something...this can be handled better
        return new StagingComponentController(); 
    }
  }
  
  public void callStagingControllerMethodRight(Id postId) {
    system.debug('__StagingController.stagObjRight__'+StagingRight.stagObjRight);
    system.debug('__StagingController.stagObjRight.Adjudicated_Stage__c__'+StagingRight.stagObjRight.Adjudicated_Stage__c);
    StagingRight.insertStageRight(postId);
  }
  
    public String currentTab {get;set;}
    public Post_Surgaory_Summary__c postSurObj{get;set;}
    public List<Contact> surgeon{get;set;}
    public List<SelectOption> surgeonOption{get;set;}
    public String selectedSurgeon{get;set;}
    public String ProcedureIds{get;set;}
    public Boolean isShowDateError{get;set;}
    public Boolean isShowGrossMass{get;set;}
    public Boolean isShowLargestGross{get;set;}
    public Boolean isShowGrossChanges{get;set;}
    
    public boolean showLeftLymphNodes {get;set;}
    public List<Lymph_Nodes__c> leftLymphNodes {get;set;}
    public boolean showRightLymphNodes {get;set;}
    public List<Lymph_Nodes__c> rightLymphNodes {get;set;}
    public integer totalLeftPositive {get;set;}
    public integer totalRightPositive {get;set;}
    public integer totalLeftExmined {get;set;}
    public integer totalRightExmined {get;set;}
    
    public String procedureSectionTitle{get;set;}
    public List<Procedure__c> specimenProcedureList{get;set;}
    public Procedure_Specimen_Detail__c proSpecimenObj{get;set;}
    public Boolean isShowMainSecimen{get;set;}
    public Boolean isShowSingleSecimen{get;set;}
    static integer serialNumber = 1;
    public List<wrapProcedure> wrapProcedureList{get;set;}
    public Boolean isUserNotAssocite{get;set;}
    public Id rId{get;set;}
    public String histologySectionTitle{get;set;}
    public String isDCIS{get;set;}
    public String isLCIS{get;set;}
    public String isInasive{get;set;}
    public String isCalciPickList{get;set;}
    public String isCalci{get;set;}
    public Boolean isLymphNodeProcedureAdded{get;set;}
    public Boolean isShowProcedure{get;set;}
    public List<Procedure__c> procedureList{get;set;}
    public String TrialPatientId{get;set;}
    public Boolean isReceptorLeftLaterlity{get;set;}
    public Boolean isReceptorRightLaterlity{get;set;}
    public String rcbAllDateProcedure{get;set;}
    private String rcbProcedureNameStr{get;set;}
    public String areaBedTumorStr{get;set;}
    public String LargestMetSizeStr{get;set;}
    public String TotalPositiveNodesStr{get;set;}
    public String password {get;set;}
    public String errorMsg {get;set;}
    private List<Post_Surgaory_Summary__c> lstClonePSS{get;set;}
    public Boolean isComplete{get;set;}
    public Boolean isShowEditButton{get;set;}
    private Id clonedCRFId{get;set;}
    public TrialPatient__c trialPatientObj {get;set;}
    public Staging_Detail__c stagObjLeft{set;}
    public Staging_Detail__c getStagObjLeft() {
        return StagingLeft.stagObjLeft;
    }
    public Staging_Detail__c stagObjRight{set;}
    public Staging_Detail__c getStagObjRight() {
        return StagingRight.stagObjRight;
    }
    
    public boolean openInEditMode {get;set;}
    public String nextTabName{get;set;}
    public String profileName{get;set;}
    public Boolean isDelete{get;set;}
    public Post_Surgaory_Summary__c pathObj{get;set;}
    
    public PostSurgerySummaryController(ApexPages.StandardController controller) {
        String currentUserId = UserInfo.getUserId();
        for(User u :[Select  Profile.Name , ProfileId, Id, Name From User where id =:currentUserId]){            
            profileName = u.Profile.Name; 
        } 
        isDelete = false;
        openInEditMode = false;
        
        rId = controller.getId();
        Post_Surgaory_Summary__c PostSurgerySummaryObj;
        if(rId != null)PostSurgerySummaryObj = [Select p.TrialPatient__c From Post_Surgaory_Summary__c p where id =: rId];
        
        if(PostSurgerySummaryObj != null){
            TrialPatientId = PostSurgerySummaryObj.TrialPatient__c;
            rId = PostSurgerySummaryObj.id;
        }else{
            TrialPatientId = Apexpages.currentPage().getParameters().get('trialPat');
            rId = Apexpages.currentPage().getParameters().get('postid');
        }
        
        if(TrialPatientId != null) {
            List<TrialPatient__c> lstTrialPatient = [select Name, Patient_Id__c, Trial_Id__r.Name  from TrialPatient__c where Id = :TrialPatientId];
            if(!lstTrialPatient.IsEmpty()) {
                trialPatientObj = lstTrialPatient[0];
            }
        }
        rId = Apexpages.currentPage().getParameters().get('postid');
        isShowGrossMass = false;
        isShowLargestGross = false;
        isShowGrossChanges = false;
        isShowMainSecimen = false;
        isShowSingleSecimen = false;
        isUserNotAssocite = false;
        showLeftLymphNodes = false;
        showRightLymphNodes = false;
        totalLeftPositive = 0;
        totalRightPositive = 0 ;
        totalLeftExmined = 0;
        totalRightExmined = 0;
    
        isLymphNodeProcedureAdded = false;
        isShowProcedure = false;
        isComplete = true;
        procedureSectionTitle = '';
        histologySectionTitle = '';
        isDCIS = '';
        isLCIS = '';
        isInasive ='';
        isCalci = '';
        isCalciPickList = '';
        rcbProcedureNameStr = '';
        isReceptorRightLaterlity = false;
        isReceptorLeftLaterlity = false;
        isShowEditButton = false;
        surgeonOption = new List<SelectOption>();
        procedureList = new List<Procedure__c>();
        //currentTab = 'procedureTab';
        //currentTab = 'CompleteTab';
        system.debug('__rId__'+rId);
        if(rId!=null) {
            system.debug('__rId__'+rId);
            postSurObj = [select Root_CRF_Id__c,Total_Positive_Nodes__c, Total_Examined_Nodes__c, p.separately_submitted_margins__c, p.percentage_of_CA_in_Situ_Disease__c, p.pcr__c, p.Type_Of_Tumor__c, p.Tumor_Present__c, p.TrialPatient__c, p.Total_span_multifocal_gross_mass_width__c, p.Total_span_multifocal_gross_mass_height__c, p.Total_Span_Measurement_Unit__c, p.SystemModstamp, p.Surgeon__c, p.Surgeon_Other__c, p.Status__c, p.Span_of_gross_changes_width__c, p.Span_of_gross_changes_height__c, p.Size_of_Largest_Gross_Mass_Width__c, p.Size_of_Largest_Gross_Mass_Height__c, p.Size_of_Gross_Mass_Width__c, p.Size_of_Gross_Mass_Height__c, p.RecordTypeId, p.RCB_index__c, p.RCB_Overall_Center_Cellularity__c, p.RCB_Class__c, p.Primary_Tumor_Bed_Area__c, p.OwnerId, p.Other_Changes__c, p.Other_Changes_Present__c, p.Other_Change__c, p.Number_of_lymph_nodes_positive__c, p.Name, p.Lymph_node_dissection_done__c, p.LastModifiedDate, p.LastModifiedById, p.LastActivityDate, p.Largest_Gross_Mass_Measurement_Unit__c, p.Is_invasive_tumor_present__c, p.Is_LCIS_Present__c, p.Is_DCIS_Present__c, p.IsDeleted, p.Invasive_CA_present__c, p.Invasive_CA_at_true_margin__c, p.In_Situ_Disease_Present__c, p.In_Situ_Disease_At_True_Margin__c, p.Id, p.Gross_Mass_Measurement_Unit__c, p.Gross_Changes_Measurement_Unit__c, p.Diameter_of_largest_met__c, p.Date_Of_Procedure__c, p.CreatedDate, p.CreatedById, p.CompletedDate__c, p.Comments__c, p.Calcification_Details__c, p.CRF__c, p.Are_Calcifications_Present__c, Surgeon__r.Name, OriginalCRF__c From Post_Surgaory_Summary__c p where Id =:rId];
            lstClonePSS = [select Id, Status__c,Root_CRF_Id__c from Post_Surgaory_Summary__c where OriginalCRF__c =:rId and Status__c = 'Cloned'];
            if(!lstClonePSS.isEmpty()) {
                isShowEditButton = true;
                clonedCRFId = lstClonePSS[0].Id;
            }
            system.debug('__postSurObj__'+postSurObj);
            if(postSurObj.Surgeon__c != null || postSurObj.Surgeon__c != '') {
                selectedSurgeon = postSurObj.Surgeon__c; 
            }
            if(postsurObj.Date_Of_Procedure__c != null) {
                procedureList = [select p.Ultrasound__c, p.TrialPatient__c, p.Total_Positive__c, p.Total_Examined_Nodes__c, p.SystemModstamp, p.Stereotactic__c, p.Procedure_Name__c, p.Post_Surgery_Summary__c, p.Palpation_guided__c, p.OwnerId, p.On_Study_Pathology_Form__c, p.Node_Type__c, p.Node_Result__c, p.Name, p.Mammography__c, p.MRI__c, p.Location__c, p.Laterality__c, p.LastModifiedDate, p.LastModifiedById, p.IsDeleted, p.Id, p.Form_Name__c, p.Date_Of_Procedure__c, p.CreatedDate, p.CreatedById from Procedure__c p where Date_Of_Procedure__c =:postsurObj.Date_Of_Procedure__c and TrialPatient__c =:TrialPatientId and Post_Surgery_Summary__c !=:rId];
                
                if(!procedureList.isEmpty()) {
                    isShowProcedure = true;
                }
                system.debug('__procedureList__'+procedureList);
            } 
        } else {
            postSurObj = new Post_Surgaory_Summary__c();
            postSurObj.TrialPatient__c = TrialPatientId;
        }
        isShowDateError = false;
        wrapProcedureList = new List<wrapProcedure>();
        List<InstitutionUser__c> instUser = [select Id, Site__c from InstitutionUser__c where User__c = :Userinfo.getUserId()];
        if(instUser.isEmpty()) {
            isUserNotAssocite = true;
        } else {
            
            surgeon = [select Id, Site__c, Name from Contact where Site__c =:instUser[0].Site__c and Type__c = 'Surgeon'];
            system.debug('__instUser__'+instUser[0]);
            system.debug('__surgeon__'+surgeon);
            SelectOption option = new SelectOption('','--None--');
            surgeonOption.add(option);
            for(Contact cont : surgeon) {
                if(cont.Name!=null) {
                    option = new SelectOption(cont.Id,cont.Name);
                    surgeonOption.add(option);
                }
            }
            option = new SelectOption('other','Other');
            surgeonOption.add(option);
        }
        isComplete = CRFUtilities.isReadOnlyUsr(); 
        if(postSurObj != null){
            String crfId = postSurObj.CRF__c; 
            if(crfId != null && crfId != ''){
                String status = CRFUtilities.CRFStatus(crfId);
                if(status == 'Approval Pending' || status == 'Accepted'  || status == 'Rejected'){
                    List<Procedure__c> tmpProcedureList = [select p.Ultrasound__c, p.TrialPatient__c, p.Total_Positive__c, p.Total_Examined_Nodes__c, p.SystemModstamp, p.Stereotactic__c, p.Procedure_Name__c, p.Post_Surgery_Summary__c, p.Palpation_guided__c, p.OwnerId, p.On_Study_Pathology_Form__c, p.Node_Type__c, p.Node_Result__c, p.Name, p.Mammography__c, p.MRI__c, p.Location__c, p.Laterality__c, p.LastModifiedDate, p.LastModifiedById, p.IsDeleted, p.Id, p.Form_Name__c, p.Date_Of_Procedure__c, p.CreatedDate, p.CreatedById,(select Total_Slices__c, SystemModstamp, Superor_inferior_size_unit__c, Superor_inferior_Gross_specimen_size__c, Specimen__c, Slicing_Method__c, Slice_Plane2__c, Slice_Plane1__c, Slice2__c, Slice1__c, Single_Speciment_submitted_for_histology__c, Procedure__c, OwnerId, Name, Medial_lateral_size_unit__c, Medial_lateral_Gross_specimen_size__c, Main_Specimen_submitted_for_histology__c, Lymph_node_tissue_present_in_sample__c, LastModifiedDate, LastModifiedById, Lab__c, IsDeleted, Id, Effective_Time__c, CreatedById, Block2__c, Block1__c, Anterior_deep_size_unit__c, Anterior_deep_Gross_specimen_size__c, Lab__r.Name from Procedure_Specimen_Details__r order by Effective_Time__c) from Procedure__c p where Post_Surgery_Summary__c =:rId];
                    Set<Id> tmpProcedureIdSet = new Set<Id>();
                    for(Procedure__c tmpObj : tmpProcedureList) {
                        tmpProcedureIdSet.add(tmpObj.Id);
                    }
                    
                    //List<Procedure_Specimen_Detail__c> specimenList = [select p.Total_Slices__c, p.SystemModstamp, p.Superor_inferior_size_unit__c, p.Superor_inferior_Gross_specimen_size__c, p.Specimen__c, p.Slicing_Method__c, p.Slice_Plane2__c, p.Slice_Plane1__c, p.Slice2__c, p.Slice1__c, p.Single_Speciment_submitted_for_histology__c, p.Procedure__c, p.OwnerId, p.Name, p.Medial_lateral_size_unit__c, p.Medial_lateral_Gross_specimen_size__c, p.Main_Specimen_submitted_for_histology__c, p.Lymph_node_tissue_present_in_sample__c, p.LastModifiedDate, p.LastModifiedById, p.Lab__c, p.IsDeleted, p.Id, p.Effective_Time__c, p.CreatedById, p.Block2__c, p.Block1__c, p.Anterior_deep_size_unit__c, p.Anterior_deep_Gross_specimen_size__c, p.Lab__r.Name from Procedure_Specimen_Detail__c p where Procedure__c IN :tmpProcedureIdSet order by Effective_Time__c];
                    
                    for(Procedure__c tmpObj : tmpProcedureList) {
                        if(!showLeftLymphNodes && tmpObj.Procedure_Name__c == 'Sentinel lymph node dissection' && tmpObj.Laterality__c == 'Left') {
                            showLeftLymphNodes = true;
                            isLymphNodeProcedureAdded = true;
                        }
                        if(!showRightLymphNodes && tmpObj.Procedure_Name__c == 'Sentinel lymph node dissection' && tmpObj.Laterality__c == 'Right') {
                            showRightLymphNodes = true;
                            isLymphNodeProcedureAdded = true;
                        }
                        if(tmpObj.Laterality__c == 'Left') {
                            isReceptorLeftLaterlity = true;
                        } else if(tmpObj.Laterality__c == 'Right') {
                            isReceptorRightLaterlity = true;
                        }
                        
                        wrapProcedure wrapProObj = new wrapProcedure();
                        wrapProObj.procedure = tmpObj;
                        Integer flag = 0;
                        for(Procedure_Specimen_Detail__c specimenObj : tmpObj.Procedure_Specimen_Details__r) {
                            if(specimenObj.Procedure__c == tmpObj.Id) {
                                flag = 1;
                                wrapSpecimen wrapSpecimenObj = new wrapSpecimen();
                                wrapSpecimenObj.proSpecimen = specimenObj;
                                if(wrapProObj.proSpecimen.size() == 0) {
                                    wrapSpecimenObj.srno = serialNumber;
                                } else {
                                    wrapSpecimenObj.srno = wrapProObj.proSpecimen.size() + 1;
                                }
                                
                                if(specimenObj.Specimen__c == 'Main specimen with separately submitted margins') {
                                    wrapSpecimenObj.isShowMainSecimen = true;
                                    wrapSpecimenObj.isShowSingleSecimen = false;
                                }
                                else if(specimenObj.Specimen__c == 'Single Specimen') {
                                    wrapSpecimenObj.isShowMainSecimen = false;
                                    wrapSpecimenObj.isShowSingleSecimen = true;
                                }
                                else {
                                    wrapSpecimenObj.isShowMainSecimen = false;
                                    wrapSpecimenObj.isShowSingleSecimen = false;
                                }
                                
                                wrapProObj.proSpecimen.add(wrapSpecimenObj);
                            }
                        }
                        
                        for(wrapSpecimen wrapSpeciObj: wrapProObj.proSpecimen) {
                            if(wrapProObj.proSpecimen.size() == wrapSpeciObj.srno) {
                                wrapSpeciObj.isShowAddLink = true;
                            }
                            else {
                                wrapSpeciObj.isShowAddLink = false;
                            }
                        }
                        
                        if(flag == 0) {
                            proSpecimenObj = new Procedure_Specimen_Detail__c();
                            wrapSpecimen wrapSpecimenObj = new wrapSpecimen();
                            proSpecimenObj.Procedure__c = tmpObj.Id; 
                            wrapSpecimenObj.proSpecimen = proSpecimenObj;
                            if(wrapProObj.proSpecimen.size() == 0) {
                                wrapSpecimenObj.srno = serialNumber;
                            } else {
                                wrapSpecimenObj.srno = wrapProObj.proSpecimen.size() + 1;
                            }
                            wrapSpecimenObj.isShowAddLink = true;
                            wrapProObj.proSpecimen.add(wrapSpecimenObj);
                        }
                        wrapProcedureList.add(wrapProObj);
                    }
                    
                    //List<Lymph_Nodes__c> lymphList = [select l.Tumor_Size_Measurement_Unit__c, l.SystemModstamp, l.Specific_Size_of_Largest_Tumor__c, l.Size_of_Largest_Tumor__c, l.Single_Detection_Result__c, l.Sentinel_Nodes__c, l.Procedure__c, l.Positive__c, l.OwnerId, l.Not_reported_Detection_Result__c, l.Node_Checkbox_Value__c, l.Name, l.Method_of_Detection__c, l.Location__c, l.LastModifiedDate, l.LastModifiedById, l.IsDeleted, l.Id, l.Focus_Detection_Result__c, l.Extramodal_Extension__c, l.Examined__c, l.Detection_Result__c, l.CreatedDate, l.CreatedById, l.Cluster_Detection_Result__c, l.Axillary_Nodes__c, l.Additional_Nodes__c From Lymph_Nodes__c l where Procedure__c IN :tmpProcedureIdSet];
                    Integer Num = 0;
                    for(wrapProcedure wrapProcedureObj : wrapProcedureList) {
                        //wrapProcedureObj.lymphNodeList.clear();
                        //if(wrapProcedureObj.procedure.Procedure_Name__c == 'Sentinel lymph node dissection' && (wrapProcedureObj.procedure.Laterality__c == 'Left' || wrapProcedureObj.procedure.Laterality__c == 'Right')) {
                            
                            //lymphProcedureIdSet.add(wrapProcedureObj.procedure.Id);
                        //    List<String> nodeCheckboxValue = new List<String>{'Sentinel Nodes', 'Axillary Nodes', 'Additional Nodes'}; 
                        //    system.debug('__nodeCheckboxValue__'+nodeCheckboxValue);
                        //    for(String tmpCheckboxVal : nodeCheckboxValue) {
                        //        Integer lymphFlag = 0;
                        //        for(Lymph_Nodes__c lymphListObj : lymphList) {
                        //            system.debug('__lymphList__'+lymphList);
                        //            system.debug('__condition__'+((wrapProcedureObj.procedure.Id == lymphListObj.Procedure__c) && (tmpCheckboxVal == lymphListObj.Node_Checkbox_Value__c)));
                        //            if((wrapProcedureObj.procedure.Id == lymphListObj.Procedure__c) && (tmpCheckboxVal == lymphListObj.Node_Checkbox_Value__c)) {
                        //                wrapProcedureObj.lymphNodeList.add(lymphListObj);
                        //                lymphFlag = 1;
                        //            }
                        //        }
                        //    }
                        //}
                        //wrapProcedureObj.hiddenPositiveValue = Integer.valueOf(wrapProcedureObj.procedure.Total_Positive__c);
                        //wrapProcedureObj.hiddenExaminedValue = Integer.valueOf(wrapProcedureObj.procedure.Total_Examined_Nodes__c);
                        wrapProcedureObj.srNo = Num;
                        Num++;
                        system.debug('__wrapProcedureObj.srNo__'+wrapProcedureObj.srNo);
                    }
                    initializeLymphNodes();
                    currentTab = 'CompleteTab';
                    isComplete = false; 
                } else {
                    currentTab = 'procedureTab';
                }
            }
        }
        isDelete();
    }
    public void isDelete(){
        
        System.debug('======rId=======' +rId);
        if(rId!= null){
            pathObj = [select Id, Status__c,Root_CRF_Id__c from Post_Surgaory_Summary__c where id =:rId];
            
            if(pathObj != null && pathObj.Status__c != 'Not Completed'){
                isDelete = true;    
            }
        }
            
        System.debug('======rId=======' +rId); 
    }
    public pagereference redirect(){
            pagereference redirect = new pagereference('/apex/PostSurgerySummaryPdf?postid='+rId +'&trialPat='+Apexpages.currentPage().getparameters().get('trialPat'));
            redirect.setRedirect(true);
            return redirect;
     }  
    
    public Pagereference saveCrf() {
            String TrialPatientId = Apexpages.currentPage().getParameters().get('trialPat');
            String postIdValue = Apexpages.currentPage().getParameters().get('postid');
            
            if(postIdValue == null) {
                postIdValue = Apexpages.currentPage().getParameters().get('id');
                if(postIdValue != null) {
                    List<Post_Surgaory_Summary__c> postList = [select TrialPatient__c from Post_Surgaory_Summary__c where Id =:postIdValue];
                    Pagereference pr = new Pagereference('/apex/PostSurgerySummary?trialPat='+postList[0].TrialPatient__c+'&formName=Post Surgery Summary Form&postid='+postIdValue);
                    pr.getParameters().put('nooverride', '1');
                    pr.setRedirect(true);
                    return pr;
                } else {
                    postSurObj = new Post_Surgaory_Summary__c();
                    postSurObj.TrialPatient__c = TrialPatientId;
                    try {
                        insert postSurObj;
                    }catch (Exception e) {
                        Apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.ERROR, e.getMessage());
                        Apexpages.addMessage(msg);
                        return null;
                    }
                    
                    Pagereference pr = new Pagereference('/apex/PostSurgerySummary?trialPat='+TrialPatientId+'&formName=Post Surgery Summary Form&postid='+postSurObj.Id);
                    pr.getParameters().put('nooverride', '1');
                    pr.setRedirect(true);
                    return pr;
                }
            } else {
                return null;
            }
            
    }   
    
    public Pagereference next(){
        system.debug('__currentTab__'+currentTab);
        system.debug('__postSurObj__'+postSurObj);
        system.debug('__ProcedureIds__'+ProcedureIds);
        system.debug('__selectedSurgeon__'+selectedSurgeon);
        String nextTabValue = Apexpages.currentPage().getParameters().get('nextTab');
        if(nextTabValue != null) {
            nextTabName = nextTabValue;
        }
        system.debug('__nextTabValue__'+nextTabValue);
        String surgeonName = '';
        
        if(currentTab == 'procedureTab') {
            procedureSectionTitle = '';
            histologySectionTitle = '';
            wrapProcedureList.clear();
            //procData.proSpecimen
            if(selectedSurgeon == 'Other') {
                List<InstitutionUser__c> lstInstUserSite = [select id,Institution__c,Site__c from InstitutionUser__c where User__c =:Userinfo.getUserId()];
                system.debug('----lstInstUserSite[0].Site__c------'+lstInstUserSite[0].Site__c);
                Contact con = new Contact();
                con.LastName = postsurObj.Surgeon_Other__c;
                con.AccountId = lstInstUserSite[0].Institution__c;
                con.Site__c = lstInstUserSite[0].Site__c;
                con.Type__c = 'Surgeon';
                insert con;
                
                postsurObj.Surgeon__c = con.Id;
            } else {
                postsurObj.Surgeon__c = selectedSurgeon;
            }
            
            if(postSurObj.Date_Of_Procedure__c>system.today()) {
                isShowDateError = true;
                return null;
            }
            else {
                //currentTab = 'specimensTab';
                //currentTab = nextTabValue;
                if(postsurObj.Surgeon__c!=null) {
                    for(Contact cont : surgeon) {
                        if(cont.Id == postsurObj.Surgeon__c) {
                            surgeonName = cont.Name; 
                        }
                    }
                }
                
                system.debug('__postSurObj__'+postSurObj);
                system.debug('__rId__'+rId);
                /*if(rId==null || rId == '') {
                    upsert postSurObj;
                } 
                else {
                }*/
                
                try {
                    update postSurObj;
                }catch (Exception e) {
                    Apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.ERROR, e.getMessage());
                    Apexpages.addMessage(msg);
                    // Added by Shruti (DE401)
                    // Pagereference ref = new Pagereference('/apex/PostSurgerySummary?postid='+rId +'&trialPat='+Apexpages.currentPage().getparameters().get('trialPat'));
                     Pagereference ref = new Pagereference('/'+rId);
                     ref.setRedirect(true);
                     return ref;
             // Added by Shruti (DE401)
                }
                
                system.debug('__postSurObjId__'+postSurObj.Id);
                if(postsurObj.Date_Of_Procedure__c != null){
                    procedureSectionTitle+= 'Specimens entry for procedures performed on '+postsurObj.Date_Of_Procedure__c.format();
                    histologySectionTitle+= postsurObj.Date_Of_Procedure__c.format();   
                }
                
                if(surgeonName!=null && surgeonName!='') {
                    procedureSectionTitle+=' by '+surgeonName;
                    histologySectionTitle+=' /'+surgeonName;
                }
            }
            showTumorOption();
            //if(ProcedureIds!=null && ProcedureIds!='') {
            //    List<String> ProcedureIdList = ProcedureIds.split('\\,');
            //    Set<Id> ProcedureIdSet = new Set<Id>();
            //    for(String tmpList : ProcedureIdList) {
            //        ProcedureIdSet.add(tmpList);
            //    }
                
                specimenProcedureList = [select Id,Procedure_Name__c, Laterality__c, Location__c,(select p.Total_Slices__c, p.SystemModstamp, p.Superor_inferior_size_unit__c, p.Superor_inferior_Gross_specimen_size__c, p.Specimen__c, p.Slicing_Method__c, p.Slice_Plane2__c, p.Slice_Plane1__c, p.Slice2__c, p.Slice1__c, p.Single_Speciment_submitted_for_histology__c, p.Procedure__c, p.OwnerId, p.Name, p.Medial_lateral_size_unit__c, p.Medial_lateral_Gross_specimen_size__c, p.Main_Specimen_submitted_for_histology__c, p.Lymph_node_tissue_present_in_sample__c, p.LastModifiedDate, p.LastModifiedById, p.Lab__c, p.IsDeleted, p.Id, p.Effective_Time__c, p.CreatedById, p.Block2__c, p.Block1__c, p.Anterior_deep_size_unit__c, p.Anterior_deep_Gross_specimen_size__c,p.Lab__r.Name from Procedure_Specimen_Details__r p order by Effective_Time__c) from Procedure__c where Post_Surgery_Summary__c = :rid];
                //List<Procedure_Specimen_Detail__c> specimenList = [select p.Total_Slices__c, p.SystemModstamp, p.Superor_inferior_size_unit__c, p.Superor_inferior_Gross_specimen_size__c, p.Specimen__c, p.Slicing_Method__c, p.Slice_Plane2__c, p.Slice_Plane1__c, p.Slice2__c, p.Slice1__c, p.Single_Speciment_submitted_for_histology__c, p.Procedure__c, p.OwnerId, p.Name, p.Medial_lateral_size_unit__c, p.Medial_lateral_Gross_specimen_size__c, p.Main_Specimen_submitted_for_histology__c, p.Lymph_node_tissue_present_in_sample__c, p.LastModifiedDate, p.LastModifiedById, p.Lab__c, p.IsDeleted, p.Id, p.Effective_Time__c, p.CreatedById, p.Block2__c, p.Block1__c, p.Anterior_deep_size_unit__c, p.Anterior_deep_Gross_specimen_size__c,p.Lab__r.Name from Procedure_Specimen_Detail__c p where Procedure__c IN :ProcedureIdSet order by Effective_Time__c];
                List<Procedure__c> updateProcedure = new List<Procedure__c>();
                for(Procedure__c tmpObj : specimenProcedureList) {
                    if(postSurObj.Id!=null || postSurObj.Id!='') {
                        
                        //tmpObj.Post_Surgery_Summary__c = postSurObj.Id;
                        tmpObj.Date_Of_Procedure__c = postSurObj.Date_Of_Procedure__c;
                        updateProcedure.add(tmpObj);
                        rcbProcedureNameStr+= tmpObj.Procedure_Name__c+' '+tmpObj.Laterality__c+' '+tmpObj.Location__c+', ';
                    }
                    wrapProcedure wrapProObj = new wrapProcedure();
                    wrapProObj.procedure = tmpObj;
                    Integer flag = 0;
                    for(Procedure_Specimen_Detail__c specimenObj : tmpObj.Procedure_Specimen_Details__r) {
                        if(specimenObj.Procedure__c == tmpObj.Id) {
                            flag = 1;
                            wrapSpecimen wrapSpecimenObj = new wrapSpecimen();
                            wrapSpecimenObj.proSpecimen = specimenObj;
                            if(wrapProObj.proSpecimen.size() == 0) {
                                wrapSpecimenObj.srno = serialNumber;
                            } else {
                                wrapSpecimenObj.srno = wrapProObj.proSpecimen.size() + 1;
                            }
                            
                            if(specimenObj.Specimen__c == 'Main specimen with separately submitted margins') {
                                wrapSpecimenObj.isShowMainSecimen = true;
                                wrapSpecimenObj.isShowSingleSecimen = false;
                            }
                            else if(specimenObj.Specimen__c == 'Single Specimen') {
                                wrapSpecimenObj.isShowMainSecimen = false;
                                wrapSpecimenObj.isShowSingleSecimen = true;
                            }
                            else {
                                wrapSpecimenObj.isShowMainSecimen = false;
                                wrapSpecimenObj.isShowSingleSecimen = false;
                            }
                            
                            wrapProObj.proSpecimen.add(wrapSpecimenObj);
                        }
                    }
                    
                    for(wrapSpecimen wrapSpeciObj: wrapProObj.proSpecimen) {
                        if(wrapProObj.proSpecimen.size() == wrapSpeciObj.srno) {
                            wrapSpeciObj.isShowAddLink = true;
                        }
                        else {
                            wrapSpeciObj.isShowAddLink = false;
                        }
                    }
                    
                    if(flag == 0) {
                        proSpecimenObj = new Procedure_Specimen_Detail__c();
                        wrapSpecimen wrapSpecimenObj = new wrapSpecimen();
                        proSpecimenObj.Procedure__c = tmpObj.Id; 
                        wrapSpecimenObj.proSpecimen = proSpecimenObj;
                        if(wrapProObj.proSpecimen.size() == 0) {
                            wrapSpecimenObj.srno = serialNumber;
                        } else {
                            wrapSpecimenObj.srno = wrapProObj.proSpecimen.size() + 1;
                        }
                        wrapSpecimenObj.isShowAddLink = true;
                        wrapProObj.proSpecimen.add(wrapSpecimenObj);
                    }
                    wrapProcedureList.add(wrapProObj);
                }
    //=====================start build wrapper class for lymph nodes====================================================
                Set<Id> lymphProcedureIdSet = new Set<Id>(); 
                for(wrapProcedure wrapProcedureObj : wrapProcedureList) {
                    lymphProcedureIdSet.add(wrapProcedureObj.procedure.Id);
                }
                
                for(wrapProcedure wrapProcedureObj : wrapProcedureList) {
                    //wrapProcedureObj.lymphNodeList.clear();
                    if(wrapProcedureObj.procedure.Procedure_Name__c == 'Sentinel lymph node dissection') {
                        isLymphNodeProcedureAdded = true;
                        if(wrapProcedureObj.procedure.Laterality__c == 'Left') {
                            showLeftLymphNodes = true;
                        } else if(wrapProcedureObj.procedure.Laterality__c == 'Right') {
                            showRightLymphNodes = true;
                        }
                        //lymphProcedureIdSet.add(wrapProcedureObj.procedure.Id);
                        //List<String> nodeCheckboxValue = new List<String>{'Sentinel Nodes', 'Axillary Nodes', 'Additional Nodes'}; 
                        //system.debug('__nodeCheckboxValue__'+nodeCheckboxValue);
                        //for(String tmpCheckboxVal : nodeCheckboxValue) {
                            //Integer lymphFlag = 0;
                            //for(Lymph_Nodes__c lymphListObj : lymphList) {
                            //    system.debug('__lymphList__'+lymphList);
                            //    system.debug('__condition__'+((wrapProcedureObj.procedure.Id == lymphListObj.Procedure__c) && (tmpCheckboxVal == lymphListObj.Node_Checkbox_Value__c)));
                            //    if((wrapProcedureObj.procedure.Id == lymphListObj.Procedure__c) && (tmpCheckboxVal == lymphListObj.Node_Checkbox_Value__c)) {
                            //        wrapProcedureObj.lymphNodeList.add(lymphListObj);
                            //        lymphFlag = 1;
                            //    }
                            //}
                            
                            //if(lymphFlag == 0) {
                            //    Lymph_Nodes__c lymphObj = new Lymph_Nodes__c();
                            //    lymphObj.Node_Checkbox_Value__c = tmpCheckboxVal;
                            //    lymphObj.Procedure__c = wrapProcedureObj.procedure.Id;
                            //    wrapProcedureObj.lymphNodeList.add(lymphObj);
                            //}
                        //}
                    }
                    if(wrapProcedureObj.procedure.Laterality__c == 'Left') {
                        isReceptorLeftLaterlity = true;
                    } else if(wrapProcedureObj.procedure.Laterality__c == 'Right') {
                        isReceptorRightLaterlity = true;
                    }
                }
    //=====================end build wrapper class for lymph nodes====================================================
                if(rcbProcedureNameStr != '') {
                    rcbProcedureNameStr = rcbProcedureNameStr.substring(0, rcbProcedureNameStr.length()-2);
                }
                system.debug('__updateProcedure__'+updateProcedure);
                if(!updateProcedure.isEmpty()) {
                    update updateProcedure;
                }
                leftLymphNodes = null;
                rightLymphNodes = null;
                initializeLymphNodes();
            //}
        }
        else if(currentTab == 'specimensTab') {
            Integer flag = 0;
            try {
                update postSurObj;
            }catch (Exception e) {
                Apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.ERROR, e.getMessage());
                Apexpages.addMessage(msg);
                // Added by Shruti (DE401)
                    // Pagereference ref = new Pagereference('/apex/PostSurgerySummary?postid='+rId +'&trialPat='+Apexpages.currentPage().getparameters().get('trialPat'));
                    
                    Pagereference ref = new Pagereference('/'+rId);
                     ref.setRedirect(true);
                     return ref;
             // Added by Shruti (DE401)
            }
            system.debug('__ProcedureIds__'+ProcedureIds);
            
            Set<Id> lymphProcedureIdSet = new Set<Id>(); 
            for(wrapProcedure wrapProcedureObj : wrapProcedureList) {
                lymphProcedureIdSet.add(wrapProcedureObj.procedure.Id);
            }
            
            //List<Lymph_Nodes__c> lymphList = [select l.Tumor_Size_Measurement_Unit__c, l.SystemModstamp, l.Specific_Size_of_Largest_Tumor__c, l.Size_of_Largest_Tumor__c, l.Single_Detection_Result__c, l.Sentinel_Nodes__c, l.Procedure__c, l.Positive__c, l.OwnerId, l.Not_reported_Detection_Result__c, l.Node_Checkbox_Value__c, l.Name, l.Method_of_Detection__c, l.Location__c, l.LastModifiedDate, l.LastModifiedById, l.IsDeleted, l.Id, l.Focus_Detection_Result__c, l.Extramodal_Extension__c, l.Examined__c, l.Detection_Result__c, l.CreatedDate, l.CreatedById, l.Cluster_Detection_Result__c, l.Axillary_Nodes__c, l.Additional_Nodes__c From Lymph_Nodes__c l where Procedure__c IN :lymphProcedureIdSet];
            
            List<Procedure_Specimen_Detail__c> specimenInsertList = new List<Procedure_Specimen_Detail__c>();
            Integer Num = 0;
            for(wrapProcedure wrapProcedureObj : wrapProcedureList) {
                system.debug('__wrapProcedureObj.proSpecimen__'+wrapProcedureObj.proSpecimen);
                if(wrapProcedureObj.proSpecimen!=null && !wrapProcedureObj.proSpecimen.isEmpty()) {
                    for(wrapSpecimen tmpSeciObj : wrapProcedureObj.proSpecimen) {
                        //Procedure_Specimen_Detail__c specimenObj = new Procedure_Specimen_Detail__c();
                         //specimenObj.Procedure__c = wrapProcedureObj.procedure.Id;
                        specimenInsertList.add(tmpSeciObj.proSpecimen);
                        /*if(tmpSeciObj.proSpecimen.Specimen__c!=null && tmpSeciObj.proSpecimen.Specimen__c!='') {
                            
                        }*/
                        
                    }
                }
                /*wrapProcedureObj.lymphNodeList.clear();
                if(wrapProcedureObj.procedure.Procedure_Name__c == 'Sentinel lymph node dissection' && (wrapProcedureObj.procedure.Laterality__c == 'Left' || wrapProcedureObj.procedure.Laterality__c == 'Right')) {
                    isLymphNodeProcedureAdded = true;
                    //lymphProcedureIdSet.add(wrapProcedureObj.procedure.Id);
                    List<String> nodeCheckboxValue = new List<String>{'Sentinel Nodes', 'Axillary Nodes', 'Additional Nodes'}; 
                    system.debug('__nodeCheckboxValue__'+nodeCheckboxValue);
                    for(String tmpCheckboxVal : nodeCheckboxValue) {
                        Integer lymphFlag = 0;
                        for(Lymph_Nodes__c lymphListObj : lymphList) {
                            system.debug('__lymphList__'+lymphList);
                            system.debug('__condition__'+((wrapProcedureObj.procedure.Id == lymphListObj.Procedure__c) && (tmpCheckboxVal == lymphListObj.Node_Checkbox_Value__c)));
                            if((wrapProcedureObj.procedure.Id == lymphListObj.Procedure__c) && (tmpCheckboxVal == lymphListObj.Node_Checkbox_Value__c)) {
                                wrapProcedureObj.lymphNodeList.add(lymphListObj);
                                lymphFlag = 1;
                            }
                        }
                        
                        if(lymphFlag == 0) {
                            Lymph_Nodes__c lymphObj = new Lymph_Nodes__c();
                            lymphObj.Node_Checkbox_Value__c = tmpCheckboxVal;
                            lymphObj.Procedure__c = wrapProcedureObj.procedure.Id;
                            wrapProcedureObj.lymphNodeList.add(lymphObj);
                        }
                    }
                }*/
                wrapProcedureObj.srNo = Num;
                Num++;
                system.debug('__wrapProcedureObj.srNo__'+wrapProcedureObj.srNo);
            }
            
            //initializeLymphNodes();
            
            /*List<Lymph_Nodes__c> lymphList = [select l.Tumor_Size_Measurement_Unit__c, l.SystemModstamp, l.Specific_Size_of_Largest_Tumor__c, l.Size_of_Largest_Tumor__c, l.Single_Detection_Result__c, l.Sentinel_Nodes__c, l.Procedure__c, l.Positive__c, l.OwnerId, l.Not_reported_Detection_Result__c, l.Node_Checkbox_Value__c, l.Name, l.Method_of_Detection__c, l.Location__c, l.LastModifiedDate, l.LastModifiedById, l.IsDeleted, l.Id, l.Focus_Detection_Result__c, l.Extramodal_Extension__c, l.Examined__c, l.Detection_Result__c, l.CreatedDate, l.CreatedById, l.Cluster_Detection_Result__c, l.Axillary_Nodes__c, l.Additional_Nodes__c From Lymph_Nodes__c l where Procedure__c IN :lymphProcedureIdSet];
            system.debug('__lymphList__'+lymphList);
            for(wrapProcedure wrapProcedureObj : wrapProcedureList) {
                system.debug('__wrapProcedureObj.procedure.Id__'+wrapProcedureObj.procedure.Id);
                if(wrapProcedureObj.procedure.Procedure_Name__c == 'Sentinel lymph node dissection' && (wrapProcedureObj.procedure.Laterality__c == 'Left' || wrapProcedureObj.procedure.Laterality__c == 'Right')) {
                    for(Lymph_Nodes__c lymphObj : lymphList) {
                        for(Lymph_Nodes__c lymphWrapObj : wrapProcedureObj.lymphNodeList) {
                            //system.debug('__lymphWrapObj.Procedure__c: '+lymphWrapObj.Procedure__c+', lymphWrapObj.Node_Checkbox_Value__c: '+lymphWrapObj.Node_Checkbox_Value__c);
                            //system.debug('__lymphObj.Procedure__c: '+lymphObj.Procedure__c+', lymphObj.Node_Checkbox_Value__c: '+lymphObj.Node_Checkbox_Value__c);
                            system.debug('condition : '+((lymphWrapObj.Procedure__c == lymphObj.Procedure__c) && (lymphWrapObj.Node_Checkbox_Value__c == lymphObj.Node_Checkbox_Value__c)));
                            if((lymphWrapObj.Procedure__c == lymphObj.Procedure__c) && (lymphWrapObj.Node_Checkbox_Value__c == lymphObj.Node_Checkbox_Value__c)) {
                                lymphWrapObj = lymphObj;
                                system.debug('__lymphWrapObj__'+lymphWrapObj);
                                system.debug('__lymphWrapObj.Id__'+lymphWrapObj.Id);
                                system.debug('__wrapProcedureObj.lymphNodeList[0].Id__'+wrapProcedureObj.lymphNodeList[0].Id);
                                system.debug('__wrapProcedureObj.lymphNodeList[1].Id__'+wrapProcedureObj.lymphNodeList[1].Id);
                                system.debug('__wrapProcedureObj.lymphNodeList[2].Id__'+wrapProcedureObj.lymphNodeList[2].Id);
                            } 
                        }
                    }
                }
                system.debug('__wrapProcedureObj.lymphNodeList__'+wrapProcedureObj.lymphNodeList);
            }*/
            
            system.debug('__specimenInsertList__'+specimenInsertList);
            if(!specimenInsertList.isEmpty()) {
                upsert specimenInsertList;
            }
            //currentTab = nextTabValue;
        } else if(currentTab == 'lymphTab') {
            
            //currentTab = nextTabValue;
            //if(postSurObj.Lymph_node_dissection_done__c == 'Yes') {
            //    List<Procedure__c> updateLymphProcedureList = new List<Procedure__c>();
            //    List<Lymph_Nodes__c> insertLymphNodes = new List<Lymph_Nodes__c>(); 
            //    for(wrapProcedure wrapProcedureObj : wrapProcedureList) {
            //        if(wrapProcedureObj.procedure.Procedure_Name__c == 'Sentinel lymph node dissection' && (wrapProcedureObj.procedure.Laterality__c == 'Left' || wrapProcedureObj.procedure.Laterality__c == 'Right')) {
                        //isLymphNodeProcedureAdded = true;
                        //List<String> nodeCheckboxValue = new List<String>{'Sentinel Nodes', 'Axillary Nodes', 'Additional Nodes'}; 
                        //system.debug('__nodeCheckboxValue__'+nodeCheckboxValue);
            //            for(Lymph_Nodes__c tmpLymphNode : wrapProcedureObj.lymphNodeList) {
            //                if(tmpLymphNode.Node_Checkbox_Value__c == 'Sentinel Nodes' && tmpLymphNode.Sentinel_Nodes__c != true) continue;
            //                if(tmpLymphNode.Node_Checkbox_Value__c == 'Axillary Nodes' && tmpLymphNode.Axillary_Nodes__c != true) continue;
            //                if(tmpLymphNode.Node_Checkbox_Value__c == 'Additional Nodes' && tmpLymphNode.Additional_Nodes__c != true) continue;
                            //tmpLymphNode.Procedure__c = wrapProcedureObj.procedure.Id; 
                            //tmpLymphNode.Examined__c = wrapPro.hiddenPositiveValue
            //                insertLymphNodes.add(tmpLymphNode);
            //            }
            //            wrapProcedureObj.procedure.Total_Positive__c = wrapProcedureObj.hiddenPositiveValue;
            //            wrapProcedureObj.procedure.Total_Examined_Nodes__c = wrapProcedureObj.hiddenExaminedValue;
            //            updateLymphProcedureList.add(wrapProcedureObj.procedure);
            //        }
            //    }
            if(postSurObj.Lymph_node_dissection_done__c == 'Yes') {
                List<Lymph_Nodes__c> insertLymphNodes = new List<Lymph_Nodes__c>();
            	Decimal totalPositiveNodes = 0;
            	Decimal totalExaminedNodes = 0;
                if(leftLymphNodes != null) {
                    for(Lymph_Nodes__c ln : leftLymphNodes) {
                        if(ln.Sentinel_Nodes__c || ln.Additional_Nodes__c || ln.Axillary_Nodes__c) {
                            totalPositiveNodes+= ln.Positive__c;
                            totalExaminedNodes+= ln.Examined__c;
                            ln.Post_Surgery_Summary__c = rId;
                            insertLymphNodes.add(ln);
                        }
                    }
                }
                if(rightLymphNodes != null) {
                    for(Lymph_Nodes__c ln : rightLymphNodes) {
                        if(ln.Sentinel_Nodes__c || ln.Additional_Nodes__c || ln.Axillary_Nodes__c) {
                        	totalPositiveNodes+= ln.Positive__c;
                            totalExaminedNodes+= ln.Examined__c;
                            ln.Post_Surgery_Summary__c = rId;
                            insertLymphNodes.add(ln);
                        }
                    }
                }
                system.debug('__insertLymphNodes__'+insertLymphNodes);
                if(!insertLymphNodes.isEmpty()) {
                	postSurObj.Total_Examined_Nodes__c = totalPositiveNodes;
                	postSurObj.Total_Positive_Nodes__c = totalExaminedNodes;
                  // Added by Shruti (DE401)  
                    try {
			            upsert insertLymphNodes;
			        }catch (Exception e) {
			            Apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.ERROR, e.getMessage());
			            Apexpages.addMessage(msg);             
			            // Pagereference ref = new Pagereference('/apex/PostSurgerySummary?postid='+rId +'&trialPat='+Apexpages.currentPage().getparameters().get('trialPat'));
			            Pagereference ref = new Pagereference('/'+rId);
			            ref.setRedirect(true);
			             return ref;             
			        } 
                // Added by Shruti (DE401)
                }
            } else {
                postSurObj.Total_Examined_Nodes__c = 0;
                postSurObj.Total_Positive_Nodes__c = 0;
                delete [select Id from Lymph_Nodes__c where Post_Surgery_Summary__c=:rId];
                leftLymphNodes = null;
                rightLymphNodes = null;
                initializeLymphNodes();
            }
            //    system.debug('__updateLymphProcedureList__'+updateLymphProcedureList);
            //    if(!updateLymphProcedureList.isEmpty()) {
            //        update updateLymphProcedureList;
            //    }
            //}
            try {
                update postSurObj;
            }catch (Exception e) {
                Apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.ERROR, e.getMessage());
                Apexpages.addMessage(msg);
                // Added by Shruti (DE401)
                    // Pagereference ref = new Pagereference('/apex/PostSurgerySummary?postid='+rId +'&trialPat='+Apexpages.currentPage().getparameters().get('trialPat'));
                    Pagereference ref = new Pagereference('/'+rId); 
                     ref.setRedirect(true);
                     return ref;
             // Added by Shruti (DE401)
            }
        } else if(currentTab == 'histologyTab') {
            //currentTab = nextTabValue;
            /*public String isDCIS{get;set;}
            public String isLCIS{get;set;}
            public String isInasive{get;set;}
            public String isCalciPickList{get;set;}
            public String isCalci{get;set;}*/
            system.debug('__isDCIS__'+isDCIS);
            system.debug('__isInasive__'+isInasive);
            system.debug('__isLCIS__'+isLCIS);
            system.debug('__isCalci__'+isCalci);
            system.debug('__isCalciPickList__'+isCalciPickList);
            
            postsurObj.Is_DCIS_Present__c = isDCIS;
            postsurObj.Is_invasive_tumor_present__c = isInasive;
            postsurObj.Is_LCIS_Present__c = isLCIS;
            postsurObj.Are_Calcifications_Present__c = isCalci;
            if(isCalci == 'Yes') {
                postsurObj.Calcification_Details__c = isCalciPickList;
            } else {
                postsurObj.Calcification_Details__c = null;
            }
            
            if(postsurObj.Is_LCIS_Present__c == 'Yes' && lcisController.lcisObj.Histological_Type__c == 'Pleomorphic' && lcisController.lcisObj.Closest_Margin__c == 'Specifiy') {
            	if(lcisController.lcisObj.Specify_No__c != null) {
	            	Pattern isnumbers = Pattern.Compile('^[0-9]+$');
					Matcher postalMatch = isnumbers.matcher(lcisController.lcisObj.Specify_No__c);
					if(!postalMatch.Matches()) {
						lcisController.lcisObj.Specify_No__c.addError('Please enter numeric value.');
						return null;
					}
            		
            	}
            }
            try {
                update postSurObj;
            }catch (Exception e) {
                Apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.ERROR, e.getMessage());
                Apexpages.addMessage(msg);
                // Added by Shruti (DE401)
                     // Pagereference ref = new Pagereference('/apex/PostSurgerySummary?postid='+rId +'&trialPat='+Apexpages.currentPage().getparameters().get('trialPat'));
                     Pagereference ref = new Pagereference('/'+rId);
                     ref.setRedirect(true);
                     return ref;
             // Added by Shruti (DE401)
            } 
            System.debug('-----isDCIS-------:'+postsurObj.Is_DCIS_Present__c+'----isInasive----'+postsurObj.Is_invasive_tumor_present__c+'------isLCIS---------'+postsurObj.Is_LCIS_Present__c);
            
            if(postsurObj.Is_DCIS_Present__c == 'Yes') {
                callDcisControllerMethod(postsurObj.Id);
            }
            if(postsurObj.Is_invasive_tumor_present__c == 'Yes') {
                callIvtControllerMethod(postsurObj.Id);
            }
            if(postsurObj.Is_LCIS_Present__c == 'Yes') {
                callLcisControllerMethod(postsurObj.Id);
            }
        } else if(currentTab == 'marginTab') {
            try {
                update postSurObj;
            }catch (Exception e) {
                Apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.ERROR, e.getMessage());
                Apexpages.addMessage(msg);
                // Added by Shruti (DE401)
                    // Pagereference ref = new Pagereference('/apex/PostSurgerySummary?postid='+rId +'&trialPat='+Apexpages.currentPage().getparameters().get('trialPat'));
                     Pagereference ref = new Pagereference('/'+rId);
                     ref.setRedirect(true);
                     return ref;
             // Added by Shruti (DE401)
            }
            //currentTab = nextTabValue;
            /*for(wrapProcedure wrapProcedureObj : wrapProcedureList) {
                if(wrapProcedureObj.procedure.Laterality__c == 'Left') {
                    isReceptorLeftLaterlity = true;
                } else if(wrapProcedureObj.procedure.Laterality__c == 'Right') {
                    isReceptorRightLaterlity = true;
                }
            }*/
        } else if(currentTab == 'receptorTab') {
            //currentTab = nextTabValue;
            if(isReceptorLeftLaterlity) {
                callReceptorsControllerMethodLeft(postsurObj.Id);
            }
            
            if(isReceptorRightLaterlity) {
                callReceptorsControllerMethodRight(postsurObj.Id);
            }
        } else if(currentTab == 'stagingTab') {
            if(isReceptorLeftLaterlity) {
                callStagingControllerMethodLeft(postsurObj.Id);
            }
            
            if(isReceptorRightLaterlity) {
                callStagingControllerMethodRight(postsurObj.Id);
            }
            //stagObjLeft = StagingLeft.stagObjLeft;
            //stagObjRight = StagingLeft.stagObjRight;
            //currentTab = nextTabValue;
        } /*else if(nextTabValue == 'submit') {
            update postsurObj;
            Pagereference pr = new Pagereference('/'+postSurObj.Id);
            pr.setRedirect(true);
            return pr;
        }*/ else if(currentTab == 'rcbTab') {
            try {
                update postSurObj;
            }catch (Exception e) {
                Apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.ERROR, e.getMessage());
                Apexpages.addMessage(msg);
                // Added by Shruti (DE401)
                    // Pagereference ref = new Pagereference('/apex/PostSurgerySummary?postid='+rId +'&trialPat='+Apexpages.currentPage().getparameters().get('trialPat'));
                     Pagereference ref = new Pagereference('/'+rId);
                     ref.setRedirect(true);
                     return ref;
             // Added by Shruti (DE401)
            }
        }
        
        if(nextTabName == 'rcbTab') {
            Decimal areaBedTumor = 0;
            Decimal percentageInSituCellularity = 0;
            Decimal percentageInDCISCellularity = 0;
            Decimal percentageInLCISCellularity = 0;
            Decimal percentageInvasiveCellularity = 0;
            Decimal LargestMetSize = 0;
            Decimal TotalPositiveNodes = 0;
            Decimal RCBIndex = 0;
            areaBedTumorStr = '0';
            LargestMetSizeStr = '0'; 
            TotalPositiveNodesStr = '0';
            rcbAllDateProcedure = '';
            postSurObj = [select Total_Examined_Nodes__c, Total_Positive_Nodes__c,p.Root_CRF_Id__c ,p.separately_submitted_margins__c, p.percentage_of_CA_in_Situ_Disease__c, p.pcr__c, p.Type_Of_Tumor__c, p.Tumor_Present__c, p.TrialPatient__c, p.Total_span_multifocal_gross_mass_width__c, p.Total_span_multifocal_gross_mass_height__c, p.Total_Span_Measurement_Unit__c, p.SystemModstamp, p.Surgeon__c, p.Surgeon_Other__c, p.Status__c, p.Span_of_gross_changes_width__c, p.Span_of_gross_changes_height__c, p.Size_of_Largest_Gross_Mass_Width__c, p.Size_of_Largest_Gross_Mass_Height__c, p.Size_of_Gross_Mass_Width__c, p.Size_of_Gross_Mass_Height__c, p.RecordTypeId, p.RCB_index__c, p.RCB_Overall_Center_Cellularity__c, p.RCB_Class__c, p.Primary_Tumor_Bed_Area__c, p.OwnerId, p.Other_Changes__c, p.Other_Changes_Present__c, p.Other_Change__c, p.Number_of_lymph_nodes_positive__c, p.Name, p.Lymph_node_dissection_done__c, p.LastModifiedDate, p.LastModifiedById, p.LastActivityDate, p.Largest_Gross_Mass_Measurement_Unit__c, p.Is_invasive_tumor_present__c, p.Is_LCIS_Present__c, p.Is_DCIS_Present__c, p.IsDeleted, p.Invasive_CA_present__c, p.Invasive_CA_at_true_margin__c, p.In_Situ_Disease_Present__c, p.In_Situ_Disease_At_True_Margin__c, p.Id, p.Gross_Mass_Measurement_Unit__c, p.Gross_Changes_Measurement_Unit__c, p.Diameter_of_largest_met__c, p.Date_Of_Procedure__c, p.CreatedDate, p.CreatedById, p.CompletedDate__c, p.Comments__c, p.Calcification_Details__c, p.CRF__c, p.Are_Calcifications_Present__c,Surgeon__r.Name, OriginalCRF__c From Post_Surgaory_Summary__c p where Id =:rId];
              
            if(postsurObj.Date_Of_Procedure__c != null ) {
                rcbAllDateProcedure+= postsurObj.Date_Of_Procedure__c.format();
            }      
            if(rcbProcedureNameStr != '') {
                rcbAllDateProcedure+= ' - '+rcbProcedureNameStr;
            }
    //==============calculating tumor bed area=========================================================
            Integer areaBedTumorFlag = 0;
            system.debug('__postsurObj.Is_invasive_tumor_present__c__'+postsurObj.Is_invasive_tumor_present__c);
            if(postsurObj.Is_invasive_tumor_present__c == 'Yes') {
                //system.debug('__postsurObj.Invasive_Tumor_Detail__c__'+postsurObj.Invasive_Tumor_Detail__c);
                List<Invasive_Tumor_Detail__c> invasiveList = [select Tumor_Size_Height__c, Tumor_Size_Width__c, Tumor_Measurement_Unit__c, Overall_cancer_cellularity__c from Invasive_Tumor_Detail__c where Post_Surgery_Summary__c =:postsurObj.Id ];
                system.debug('__invasiveList__'+invasiveList);
                system.debug('__invasiveList[0].Tumor_Measurement_Unit__c__'+invasiveList[0].Tumor_Measurement_Unit__c);
                if(!invasiveList.isEmpty() && invasiveList[0].Tumor_Measurement_Unit__c == 'MM') {
                    system.debug('__invasiveList[0].Tumor_Size_Width__c__'+invasiveList[0].Tumor_Size_Width__c);
                    system.debug('__invasiveList[0].Tumor_Size_Height__c__'+invasiveList[0].Tumor_Size_Height__c);
                    areaBedTumor = invasiveList[0].Tumor_Size_Width__c * invasiveList[0].Tumor_Size_Width__c;
                    areaBedTumorStr = invasiveList[0].Tumor_Size_Width__c+' X '+invasiveList[0].Tumor_Size_Width__c+' MM';
                    areaBedTumorFlag = 1;
                }
                //===============calculating percentageInvasiveCellularity %=============================================
                system.debug('__invasiveList[0].Overall_cancer_cellularity__c__'+invasiveList[0].Overall_cancer_cellularity__c);
                if(invasiveList[0].Overall_cancer_cellularity__c != null) {
                    percentageInvasiveCellularity = invasiveList[0].Overall_cancer_cellularity__c; 
                }
            }
            
            system.debug('__percentageInvasiveCellularity__'+percentageInvasiveCellularity);
            system.debug('__areaBedTumorFlag__'+areaBedTumorFlag);
            
            if(areaBedTumorFlag == 0) {
                system.debug('__postsurObj.Type_Of_Tumor__c__'+postsurObj.Type_Of_Tumor__c);
                system.debug('__postSurObj.Gross_Mass_Measurement_Unit__c__'+postSurObj.Gross_Mass_Measurement_Unit__c);
                system.debug('__postSurObj.Total_Span_Measurement_Unit__c__'+postSurObj.Total_Span_Measurement_Unit__c);
                system.debug('__postSurObj.Gross_Changes_Measurement_Unit__c__'+postSurObj.Gross_Changes_Measurement_Unit__c);
                
                if(postsurObj.Type_Of_Tumor__c == 'Single Discrete Mass' && postSurObj.Gross_Mass_Measurement_Unit__c == 'MM') {
                    areaBedTumor = postSurObj.Size_of_Gross_Mass_Width__c * postSurObj.Size_of_Gross_Mass_Height__c;
                    areaBedTumorStr = postSurObj.Size_of_Gross_Mass_Width__c+' X '+postSurObj.Size_of_Gross_Mass_Height__c+' MM';
                } else if(postsurObj.Type_Of_Tumor__c == 'Multifocal Discrete Masses' && postSurObj.Total_Span_Measurement_Unit__c == 'MM'){
                    areaBedTumor = postSurObj.Total_span_multifocal_gross_mass_width__c * postSurObj.Total_span_multifocal_gross_mass_height__c;
                    areaBedTumorStr = postSurObj.Total_span_multifocal_gross_mass_width__c+' X '+postSurObj.Total_span_multifocal_gross_mass_height__c+' MM';
                } else if(postsurObj.Type_Of_Tumor__c == 'Gross Stromal Alterations/Fibrosis' && postSurObj.Gross_Changes_Measurement_Unit__c == 'MM'){
                    areaBedTumor = postSurObj.Span_of_gross_changes_width__c * postSurObj.Span_of_gross_changes_height__c;
                    areaBedTumorStr = postSurObj.Span_of_gross_changes_width__c+' X '+postSurObj.Span_of_gross_changes_height__c+' MM';
                }
            }
            system.debug('__areaBedTumor__'+areaBedTumor);
    //================calculating DCIS %========================================================
            system.debug('__postsurObj.Is_DCIS_Present__c__'+postsurObj.Is_DCIS_Present__c);
            //system.debug('__postsurObj.DCIS__c__'+postsurObj.DCIS__c);        
            if(postsurObj.Is_DCIS_Present__c == 'Yes') {
                List<DCIS__c> DCISList = [select DCIS__c from DCIS__c where Post_Surgery_Summary__c =:postsurObj.Id];
                system.debug('__DCISList__'+DCISList);
                if(!DCISList.isEmpty() && DCISList[0].DCIS__c != null) {
                    percentageInDCISCellularity = DCISList[0].DCIS__c;
                }
            }
            system.debug('__percentageInDCISCellularity__'+percentageInDCISCellularity);
    //================calculating LCIS %========================================================    
            system.debug('__postsurObj.Is_LCIS_Present__c__'+postsurObj.Is_LCIS_Present__c);
            //system.debug('__postsurObj.LCIS__c__'+postsurObj.LCIS__c);    
            
            if(postsurObj.Is_LCIS_Present__c == 'Yes') {
                List<LCIS__c> LCISList = [select LCIS__c from LCIS__c where Post_Surgery_Summary__c =:postsurObj.Id];
                system.debug('__LCISList__'+LCISList);
                if(!LCISList.isEmpty() && LCISList[0].LCIS__c != null) {
                    percentageInLCISCellularity = LCISList[0].LCIS__c;
                }
            }
            system.debug('__percentageInLCISCellularity__'+percentageInLCISCellularity);
    //================calculating InSituCellularity %========================================================       
            if(percentageInDCISCellularity != 0 || percentageInLCISCellularity != 0) {
                percentageInSituCellularity = percentageInLCISCellularity;
                if(percentageInDCISCellularity > percentageInLCISCellularity) {
                    percentageInSituCellularity = percentageInDCISCellularity;
                }
                //percentageInSituCellularity = MAX(percentageInDCISCellularity, percentageInLCISCellularity);
            }
            system.debug('__percentageInSituCellularity__'+percentageInSituCellularity);
            
    //================calculating size of largest metastasis and total positive nodes ================================================
            system.debug('__postsurObj.Lymph_node_dissection_done__c__'+postsurObj.Lymph_node_dissection_done__c);
            /*if(postsurObj.Lymph_node_dissection_done__c == 'Yes') {
                Decimal SentinelLargestSize = 0;
                Decimal AxillaryLargestSize = 0;
                Decimal AdditionalLargestSize = 0;
                for(wrapProcedure wrapProcedureObj : wrapProcedureList) {
                    system.debug('__wrapProcedureObj.procedure'+wrapProcedureObj.procedure);
                    if(wrapProcedureObj.procedure.Procedure_Name__c == 'Sentinel lymph node dissection' && (wrapProcedureObj.procedure.Laterality__c == 'Left' || wrapProcedureObj.procedure.Laterality__c == 'Right')) {
                        for(Lymph_Nodes__c tmpLymphNode : wrapProcedureObj.lymphNodeList) {
                            system.debug('__tmpLymphNode.Node_Checkbox_Value__c__'+tmpLymphNode.Node_Checkbox_Value__c);
                            system.debug('__tmpLymphNode.Tumor_Size_Measurement_Unit__c__'+tmpLymphNode.Tumor_Size_Measurement_Unit__c);
                            system.debug('__tmpLymphNode.Specific_Size_of_Largest_Tumor__c__'+tmpLymphNode.Specific_Size_of_Largest_Tumor__c);
                            if(tmpLymphNode.Node_Checkbox_Value__c == 'Sentinel Nodes') {
                                if(tmpLymphNode.Sentinel_Nodes__c != true) {
                                    continue;
                                } else if(tmpLymphNode.Tumor_Size_Measurement_Unit__c == 'MM') {
                                    SentinelLargestSize = tmpLymphNode.Specific_Size_of_Largest_Tumor__c;
                                }
                            }
                            
                            if(tmpLymphNode.Node_Checkbox_Value__c == 'Axillary Nodes') {
                                if(tmpLymphNode.Axillary_Nodes__c != true) {
                                     continue;
                                } else if(tmpLymphNode.Tumor_Size_Measurement_Unit__c == 'MM') {
                                    AxillaryLargestSize = tmpLymphNode.Specific_Size_of_Largest_Tumor__c;
                                }
                            }
                            
                            if(tmpLymphNode.Node_Checkbox_Value__c == 'Additional Nodes') {
                                if(tmpLymphNode.Additional_Nodes__c != true) {
                                    continue;
                                } else if(tmpLymphNode.Tumor_Size_Measurement_Unit__c == 'MM') {
                                    AdditionalLargestSize = tmpLymphNode.Specific_Size_of_Largest_Tumor__c;
                                }
                            }
                            
                            if(AdditionalLargestSize != 0 || AxillaryLargestSize != 0 || SentinelLargestSize != 0) {
                                LargestMetSize+= AdditionalLargestSize+AxillaryLargestSize+SentinelLargestSize;
                            }
                            //insertLymphNodes.add(tmpLymphNode);
                        }
                        
                        system.debug('__LargestMetSize__'+LargestMetSize);
                        system.debug('__wrapProcedureObj.procedure.Total_Positive__c__'+wrapProcedureObj.procedure.Total_Positive__c);
                        if(wrapProcedureObj.procedure.Total_Positive__c != null) {
                            TotalPositiveNodes+= wrapProcedureObj.procedure.Total_Positive__c;
                            TotalPositiveNodesStr = TotalPositiveNodes+' (SLN+ALN)';
                        }
                        system.debug('__TotalPositiveNodes__'+TotalPositiveNodes);
                    }
                }
            }*/
            LargestMetSize = 0;
            system.debug('leftLymphNodes: '+leftLymphNodes);
            if(leftLymphNodes != null) { 
                for(Lymph_Nodes__c ln : leftLymphNodes) {
                	system.debug('ln: '+ln);
                	system.debug('ln.Positive__c: '+ln.Positive__c);
                    TotalPositiveNodes += ln.Positive__c;
                    if(ln.Size_of_Largest_Tumor__c == 'Specify') {
                        if(ln.Specific_Size_of_Largest_Tumor__c > LargestMetSize) {
                            LargestMetSize = ln.Specific_Size_of_Largest_Tumor__c;
                        }
                    }
                }
            }
            if(rightLymphNodes != null) {
                for(Lymph_Nodes__c ln : rightLymphNodes) {
                    TotalPositiveNodes += ln.Positive__c;
                    if(ln.Size_of_Largest_Tumor__c == 'Specify') {
                        if(ln.Specific_Size_of_Largest_Tumor__c > LargestMetSize) {
                            LargestMetSize = ln.Specific_Size_of_Largest_Tumor__c;
                        }
                    }
                }
            }
            TotalPositiveNodesStr = TotalPositiveNodes+' (SLN+ALN)';
            
            if(LargestMetSize > 0) {
                LargestMetSizeStr = LargestMetSize+' MM';
            } else {
                LargestMetSizeStr = '';
            }
            postsurObj.Primary_Tumor_Bed_Area__c = String.valueOf(areaBedTumor);
            postsurObj.RCB_Overall_Center_Cellularity__c = percentageInvasiveCellularity;
            postsurObj.percentage_of_CA_in_Situ_Disease__c = percentageInSituCellularity;
            postsurObj.Number_of_lymph_nodes_positive__c = String.valueOf(TotalPositiveNodes);
            postsurObj.Diameter_of_largest_met__c = String.valueOf(LargestMetSize);
            
            system.debug('__postsurObj.Primary_Tumor_Bed_Area__c__'+postsurObj.Primary_Tumor_Bed_Area__c);
            system.debug('__postsurObj.RCB_Overall_Center_Cellularity__c__'+postsurObj.RCB_Overall_Center_Cellularity__c);
            system.debug('__postsurObj.percentage_of_CA_in_Situ_Disease__c__'+postsurObj.percentage_of_CA_in_Situ_Disease__c);
            system.debug('__postsurObj.Number_of_lymph_nodes_positive__c__'+postsurObj.Number_of_lymph_nodes_positive__c);
            system.debug('__postsurObj.Diameter_of_largest_met__c__'+postsurObj.Diameter_of_largest_met__c);
            
            Decimal finv = (1-(percentageInSituCellularity/100)) * (percentageInvasiveCellularity/100);
            Decimal lymphNodesBase = 0.75;
            
            postSurObj.RCB_index__c = RCBIndex = 1.4 *(areaBedTumor * finv)*0.17+(4*(LargestMetSize * (1-lymphNodesBase.pow(Integer.valueOf(TotalPositiveNodes)))))*0.17;
            if(RCBIndex == 0) {
                postSurObj.RCB_Class__c = '0';
            } else if(RCBIndex <= 1.36) {
                postSurObj.RCB_Class__c = 'I';
            } else if(RCBIndex > 1.36 && RCBIndex <= 3.28) {
                postSurObj.RCB_Class__c = 'II';
            } else if(RCBIndex > 3.28) {
                postSurObj.RCB_Class__c = 'III';
            }
        } else if(nextTabName == 'CompleteTab') {
            //ChangeAdhocToLiveController completeCrf = new ChangeAdhocToLiveController();
            //completeCrf.customAdhoc(postsurObj.Id+'', 'submit', 'Site'); 
            postSurObj = [select Total_Positive_Nodes__c, Total_Examined_Nodes__c,p.Root_CRF_Id__c, p.separately_submitted_margins__c, p.percentage_of_CA_in_Situ_Disease__c, p.pcr__c, p.Type_Of_Tumor__c, p.Tumor_Present__c, p.TrialPatient__c, p.Total_span_multifocal_gross_mass_width__c, p.Total_span_multifocal_gross_mass_height__c, p.Total_Span_Measurement_Unit__c, p.SystemModstamp, p.Surgeon__c, p.Surgeon_Other__c, p.Status__c, p.Span_of_gross_changes_width__c, p.Span_of_gross_changes_height__c, p.Size_of_Largest_Gross_Mass_Width__c, p.Size_of_Largest_Gross_Mass_Height__c, p.Size_of_Gross_Mass_Width__c, p.Size_of_Gross_Mass_Height__c, p.RecordTypeId, p.RCB_index__c, p.RCB_Overall_Center_Cellularity__c, p.RCB_Class__c, p.Primary_Tumor_Bed_Area__c, p.OwnerId, p.Other_Changes__c, p.Other_Changes_Present__c, p.Other_Change__c, p.Number_of_lymph_nodes_positive__c, p.Name, p.Lymph_node_dissection_done__c, p.LastModifiedDate, p.LastModifiedById, p.LastActivityDate, p.Largest_Gross_Mass_Measurement_Unit__c, p.Is_invasive_tumor_present__c, p.Is_LCIS_Present__c, p.Is_DCIS_Present__c, p.IsDeleted, p.Invasive_CA_present__c, p.Invasive_CA_at_true_margin__c, p.In_Situ_Disease_Present__c, p.In_Situ_Disease_At_True_Margin__c, p.Id, p.Gross_Mass_Measurement_Unit__c, p.Gross_Changes_Measurement_Unit__c, p.Diameter_of_largest_met__c, p.Date_Of_Procedure__c, p.CreatedDate, p.CreatedById, p.CompletedDate__c, p.Comments__c, p.Calcification_Details__c, p.CRF__c, p.Are_Calcifications_Present__c,Surgeon__r.Name, OriginalCRF__c From Post_Surgaory_Summary__c p where Id =:rId];
            List<Staging_Detail__c> listforlaterty= new List<Staging_Detail__c>();
            listforlaterty=[select s.Tumor_Type__c, s.T4_Tumor_final_status__c, s.SystemModstamp, s.Staging_Modifier_Type__c, s.Post_Surgery_Summary__c, s.OwnerId, s.Node_Type__c, s.Name, s.Modifier_multiple_primary__c, s.Modifier_indicates_recurrent__c, s.Modifier_designates__c, s.Modifier_classification_done__c, s.Metastasis__c, s.Letarality__c, s.LastModifiedDate, s.LastModifiedById, s.IsDeleted, s.Id, s.CreatedDate, s.CreatedById, s.Calculated_Stage__c, s.Calculated_Stage_Value__c, s.Adjudicated_Stage__c, s.Adjudicated_By__c, Adjudicated_By__r.Name From Staging_Detail__c s where Post_Surgery_Summary__c =: postSurObj.id ];
            for(Staging_Detail__c itr :listforlaterty){
            	if(itr.Letarality__c=='Left'){
            		 StagingLeft.stagObjLeft=itr;
            	}
            	else {
            		StagingRight.stagObjRight=itr;	
            	}
            }
            
            /*if(leftLymphNodes != null) {
                for(Lymph_Nodes__c ln : leftLymphNodes) {
                    totalLeftExmined += Integer.valueOf(ln.Examined__c);
                    totalLeftPositive += Integer.valueOf(ln.Positive__c);
                }
            }
            if(rightLymphNodes != null) {
                for(Lymph_Nodes__c ln : rightLymphNodes) {
                    totalRightExmined += Integer.valueOf(ln.Examined__c);
                    totalRightPositive += Integer.valueOf(ln.Positive__c);  
                }
            }*/
            System.debug('rId: '+rId);
            //lstFeeds = [Select f.Type, f.Title, f.SystemModstamp, f.ParentId, f.LinkUrl, f.LikeCount, f.LastModifiedDate, f.IsDeleted, f.InsertedById, f.Id, f.CreatedDate, f.CreatedById, f.ContentType, f.ContentSize, f.ContentFileName, f.ContentDescription, f.ContentData, f.CommentCount, f.Body From FeedItem f where ParentId =:rId order by CreatedDate DESC];
        }else if(nextTabName == 'saveAndClose') {
//================================= For Save & Close===================================        
        postSurObj.First_Save_and_Close__c = true;
            try {
                update postSurObj;
            }catch (Exception e) {
                Apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.ERROR, e.getMessage());
                Apexpages.addMessage(msg);
                // Added by Shruti (DE401)
                     Pagereference ref = new Pagereference('/apex/PostSurgerySummary?postid='+rId +'&trialPat='+Apexpages.currentPage().getparameters().get('trialPat'));
                    //Pagereference ref = new Pagereference('/'+rId);
                     ref.setRedirect(true);
                     return ref;
             // Added by Shruti (DE401)
            }     
//=====================================================================================            
            List<TrialPatient__c> trialPatList = [select Patient_Id__c, Trial_Id__c from TrialPatient__c where Id =:TrialPatientId];
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
    
    private void initializeLymphNodes() {
        //Get lymph nodes from db
        Lymph_Nodes__c leftSentinel = null;
        Lymph_Nodes__c rightSentinel = null;
        Lymph_Nodes__c leftAxillary = null;
        Lymph_Nodes__c rightAxillary = null;
        Lymph_Nodes__c leftAdditional = null;
        Lymph_Nodes__c rightAdditional = null;
        
        List<Lymph_Nodes__c> lymphList = [select l.Post_Surgery_Summary__c, l.Letarality__c,l.Tumor_Size_Measurement_Unit__c, l.SystemModstamp, l.Specific_Size_of_Largest_Tumor__c, l.Size_of_Largest_Tumor__c, l.Single_Detection_Result__c, l.Sentinel_Nodes__c, l.Procedure__c, l.Positive__c, l.OwnerId, l.Not_reported_Detection_Result__c, l.Node_Checkbox_Value__c, l.Name, l.Method_of_Detection__c, l.Location__c, l.LastModifiedDate, l.LastModifiedById, l.IsDeleted, l.Id, l.Focus_Detection_Result__c, l.Extramodal_Extension__c, l.Examined__c, l.Detection_Result__c, l.CreatedDate, l.CreatedById, l.Cluster_Detection_Result__c, l.Axillary_Nodes__c, l.Additional_Nodes__c From Lymph_Nodes__c l where Post_Surgery_Summary__c = :rId];
        system.debug('lymphList: '+lymphList);
        for(Lymph_Nodes__c lymphListObj : lymphList) {
        	system.debug('lymphListObj.Letarality__c: '+lymphListObj.Letarality__c);
            if(lymphListObj.Letarality__c == 'Left') {
                showLeftLymphNodes = true;
                if(lymphListObj.Sentinel_Nodes__c)leftSentinel = lymphListObj;
                if(lymphListObj.Axillary_Nodes__c)leftAxillary = lymphListObj;
                if(lymphListObj.Additional_Nodes__c)leftAdditional = lymphListObj;
                if(leftLymphNodes == null) leftLymphNodes = new List<Lymph_Nodes__c>();
            } else if(lymphListObj.Letarality__c == 'Right') {
                showRightLymphNodes = true;
                if(lymphListObj.Sentinel_Nodes__c)rightSentinel = lymphListObj;
                if(lymphListObj.Axillary_Nodes__c)rightAxillary = lymphListObj;
                if(lymphListObj.Additional_Nodes__c)rightAdditional = lymphListObj;
                if(rightLymphNodes == null) rightLymphNodes = new List<Lymph_Nodes__c>();
            }
        }
        
        system.debug('showLeftLymphNodes: '+showLeftLymphNodes);
        if(leftLymphNodes != null) {
            if(leftSentinel != null)leftLymphNodes.add(leftSentinel);
            if(leftAxillary != null)leftLymphNodes.add(leftAxillary);
            if(leftAdditional != null)leftLymphNodes.add(leftAdditional);
            
            for(Lymph_Nodes__c ln : leftLymphNodes) {
                totalLeftExmined += Integer.valueOf(ln.Examined__c);
                totalLeftPositive += Integer.valueOf(ln.Positive__c);
            }
        }
        system.debug('leftLymphNodes: '+leftLymphNodes);
        system.debug('totalLeftPositive: '+totalLeftPositive);
        if(rightLymphNodes != null) {
            if(rightSentinel != null)rightLymphNodes.add(rightSentinel);
            if(rightAxillary != null)rightLymphNodes.add(rightAxillary);
            if(rightAdditional != null)rightLymphNodes.add(rightAdditional);
            
            for(Lymph_Nodes__c ln : rightLymphNodes) {
                totalRightExmined += Integer.valueOf(ln.Examined__c);
                totalRightPositive += Integer.valueOf(ln.Positive__c);  
            }
        }
        
        //Add to lymph nodes based on procedures
        if(leftLymphNodes == null || rightLymphNodes == null) {
            for(wrapProcedure wrapProcedureObj : wrapProcedureList) {
                if(wrapProcedureObj.procedure.Procedure_Name__c != 'Sentinel lymph node dissection')continue;
                if(wrapProcedureObj.procedure.Laterality__c == 'Left') {
                    showLeftLymphNodes = true;
                } else if(wrapProcedureObj.procedure.Laterality__c == 'Right') {
                    showRightLymphNodes = true;
                }   
            }
            system.debug('showLeftLymphNodes: '+showLeftLymphNodes);    
            if(showLeftLymphNodes){
                if(leftLymphNodes == null) leftLymphNodes = new List<Lymph_Nodes__c>();
                if(leftSentinel == null) {
                    Lymph_Nodes__c lnSentinel = new Lymph_Nodes__c();
                    lnSentinel.Node_Checkbox_Value__c = 'Sentinel Nodes';
                    lnSentinel.Letarality__c = 'Left';
                    leftLymphNodes.add(lnSentinel);
                }
                if(leftAxillary == null) {
                    Lymph_Nodes__c lnAxillary = new Lymph_Nodes__c();
                    lnAxillary.Node_Checkbox_Value__c = 'Axillary Nodes';
                    lnAxillary.Letarality__c = 'Left';
                    leftLymphNodes.add(lnAxillary);
                }
                if(leftAdditional == null) {
                    Lymph_Nodes__c lnAdditional = new Lymph_Nodes__c();
                    lnAdditional.Node_Checkbox_Value__c = 'Additional Nodes';
                    lnAdditional.Letarality__c = 'Left';
                    leftLymphNodes.add(lnAdditional);
                }
            }
            if(showRightLymphNodes) {
                if(rightLymphNodes == null) rightLymphNodes = new List<Lymph_Nodes__c>();
                if(rightSentinel == null) {
                    Lymph_Nodes__c lnSentinel = new Lymph_Nodes__c();
                    lnSentinel.Node_Checkbox_Value__c = 'Sentinel Nodes';
                    lnSentinel.Letarality__c = 'Right';
                    rightLymphNodes.add(lnSentinel);
                }
                if(rightAxillary == null) {
                    Lymph_Nodes__c lnAxillary = new Lymph_Nodes__c();
                    lnAxillary.Node_Checkbox_Value__c = 'Axillary Nodes';
                    lnAxillary.Letarality__c = 'Right';
                    rightLymphNodes.add(lnAxillary);
                }
                if(rightAdditional == null) {
                    Lymph_Nodes__c lnAdditional = new Lymph_Nodes__c();
                    lnAdditional.Node_Checkbox_Value__c = 'Additional Nodes';
                    lnAdditional.Letarality__c = 'Right';
                    rightLymphNodes.add(lnAdditional);
                }
            }
        }
    }
    
    // public void previous(){
       public Pagereference previous(){  //Added By Shruti (DE401)
        system.debug('__currentTab__'+currentTab);
        system.debug('__postSurObj__'+postSurObj);
        String prevTabValue = Apexpages.currentPage().getParameters().get('prevTab');
        system.debug('__prevTabValue__'+prevTabValue);
        currentTab = prevTabValue;
        // Added by Shruti (DE401)  
          try {
            update postSurObj;
        }catch (Exception e) {
            Apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.ERROR, e.getMessage());
            Apexpages.addMessage(msg);             
            // Pagereference ref = new Pagereference('/apex/PostSurgerySummary?postid='+rId +'&trialPat='+Apexpages.currentPage().getparameters().get('trialPat'));
             Pagereference ref = new Pagereference('/'+rId);
            ref.setRedirect(true);
             return ref;             
              } 
              return null;
                // Added by Shruti (DE401)
    }
    
//===========================Sign And Submit for Site User in AE CRF===========================================         
    public Pagereference signAndSubmit() {
        SignAndSubmitController signSubmit = new SignAndSubmitController();
        signSubmit.password = password;
        Pagereference ref = signSubmit.signAndSubmit('00062','',postsurObj.Id+'', 'Site');
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
    
    public void showTumorOption() {
        if(postSurObj.Type_Of_Tumor__c == 'Single Discrete Mass') {
            isShowGrossMass = true;
            isShowLargestGross = false;
            isShowGrossChanges = false;
        }
        else if(postSurObj.Type_Of_Tumor__c == 'Multifocal Discrete Masses') {
            isShowLargestGross = true;
            isShowGrossMass = false;
            isShowGrossChanges = false;
        }
        else if(postSurObj.Type_Of_Tumor__c == 'Gross Stromal Alterations/Fibrosis') {
            isShowGrossChanges = true;
            isShowGrossMass = false;
            isShowLargestGross = false;
        }
        else {
            isShowGrossChanges = false;
            isShowGrossMass = false;
            isShowLargestGross = false;
        } 
    }
    
    public void showSpecimenOption() {
        Integer currentCountValue = Integer.valueOf(Apexpages.currentPage().getParameters().get('specimenNum'));
        String procedureIdValue = Apexpages.currentPage().getParameters().get('procedureId');
        system.debug('__currentCountValue__'+currentCountValue);
        system.debug('__procedureIdValue__'+procedureIdValue);
        for(wrapProcedure wrapProcedureObj : wrapProcedureList) {
            if(procedureIdValue == wrapProcedureObj.procedure.Id) {
                for(wrapSpecimen tmpSeciObj : wrapProcedureObj.proSpecimen) {
                    if(tmpSeciObj.srno == currentCountValue) {
                        system.debug('__tmpSeciObj.proSpecimen.Specimen__c__'+tmpSeciObj.proSpecimen.Specimen__c);
                        if(tmpSeciObj.proSpecimen.Specimen__c == 'Main specimen with separately submitted margins') {
                            tmpSeciObj.isShowMainSecimen = true;
                            tmpSeciObj.isShowSingleSecimen = false;
                        }
                        else if(tmpSeciObj.proSpecimen.Specimen__c == 'Single Specimen') {
                            tmpSeciObj.isShowMainSecimen = false;
                            tmpSeciObj.isShowSingleSecimen = true;
                        }
                        else {
                            tmpSeciObj.isShowMainSecimen = false;
                            tmpSeciObj.isShowSingleSecimen = false;
                        }
                    }
                }
            }
            
        }
    }
    
    public void addSpecimen() {
        String procedureIdValue = Apexpages.currentPage().getParameters().get('procedureId');
        for(wrapProcedure wrapProcedureObj : wrapProcedureList) {
            if(wrapProcedureObj.procedure.Id == procedureIdValue) {
                
                proSpecimenObj = new Procedure_Specimen_Detail__c();
                wrapSpecimen wrapSpecimenObj = new wrapSpecimen();
                proSpecimenObj.Procedure__c = wrapProcedureObj.procedure.Id; 
                wrapSpecimenObj.proSpecimen = proSpecimenObj;
                if(wrapProcedureObj.proSpecimen.size() == 0) {
                    wrapSpecimenObj.srno = serialNumber;
                } else {
                    wrapSpecimenObj.srno = wrapProcedureObj.proSpecimen.size() + 1;
                }
                wrapProcedureObj.proSpecimen.add(wrapSpecimenObj);
                for(wrapSpecimen tmpSeciObj : wrapProcedureObj.proSpecimen) {
                    system.debug('size :'+wrapProcedureObj.proSpecimen.size()+'---srno :'+tmpSeciObj.srno);
                    if(wrapProcedureObj.proSpecimen.size() == tmpSeciObj.srno) {
                        tmpSeciObj.isShowAddLink = true;
                    }
                    else {
                        tmpSeciObj.isShowAddLink = false;
                    }
                }
            }
        }
        /*wrapSpecimen wrapSpecimenObj = new wrapSpecimen();
        proSpecimenObj = new Procedure_Specimen_Detail__c();
        wrapSpecimenObj.proSpecimen = proSpecimenObj;
        
        if(wrapSpecimenList.size() == 0) {
            wrapSpecimenObj.srno = serialNumber;
        } else {
            wrapSpecimenObj.srno = wrapSpecimenList.size() + 1;
        }
        wrapSpecimenList.add(wrapSpecimenObj);
        system.debug('__wrapSpecimenObj__'+wrapSpecimenObj);*/
    }
    
    public void removeSpecimen() {
        Integer currentCountValue = Integer.valueOf(Apexpages.currentPage().getParameters().get('serial'));
        String procedureIdValue = Apexpages.currentPage().getParameters().get('procedureId');
        system.debug('__currentCountValueremove__'+currentCountValue);
        List<Procedure_Specimen_Detail__c> deleteSpecimenList = new List<Procedure_Specimen_Detail__c>(); 
        for(wrapProcedure wrapProcedureObj : wrapProcedureList) {
            if(wrapProcedureObj.procedure.Id == procedureIdValue) {
                system.debug('__wrapProcedureObj.proSpecimenremove__'+wrapProcedureObj.proSpecimen);
                for(wrapSpecimen wrapSpecimenObj : wrapProcedureObj.proSpecimen) {
                    if(wrapSpecimenObj.proSpecimen.Id != null && wrapSpecimenObj.srno == currentCountValue) {
                        system.debug('__currentCountValueremove__'+currentCountValue);
                        deleteSpecimenList.add(wrapSpecimenObj.proSpecimen);
                    }
                }
                wrapProcedureObj.proSpecimen.remove(currentCountValue-1);
            }
        }
        
        if(!deleteSpecimenList.isEmpty()) {
            delete deleteSpecimenList;
        }
        
        Integer counter = 1;
        //List<WrapForSrno> updatedWrapList = new List<WrapForSrno>();
        for(wrapProcedure wrapProcedureObj : wrapProcedureList) {
            if(wrapProcedureObj.procedure.Id == procedureIdValue) {
                for(wrapSpecimen tmpSpeciObj : wrapProcedureObj.proSpecimen) {
                    
                    tmpSpeciObj.srno = counter;
                    counter++;
                    if(wrapProcedureObj.proSpecimen.size() == tmpSpeciObj.srno) {
                        tmpSpeciObj.isShowAddLink = true;
                    }
                    else {
                        tmpSpeciObj.isShowAddLink = false;
                    }
                }
            }
        }
        /*system.debug('__currentCountValue__'+currentCountValue);
        wrapSpecimenList.remove(currentCountValue-1);
        
        Integer counter = 1;
        for(wrapSpecimen tmpWrap : wrapSpecimenList) {
            tmpWrap.srno = counter;
            counter++;
        }
        system.debug('__wrapSpecimenListSize__'+wrapSpecimenList.Size());
        system.debug('__wrapSpecimenList__'+wrapSpecimenList);*/
    }
    
    public void showProcedure() {
        if(postsurObj.Date_Of_Procedure__c != null) {
            procedureList = [select p.Ultrasound__c, p.TrialPatient__c, p.Total_Positive__c, p.Total_Examined_Nodes__c, p.SystemModstamp, p.Stereotactic__c, p.Procedure_Name__c, p.Post_Surgery_Summary__c, p.Palpation_guided__c, p.OwnerId, p.On_Study_Pathology_Form__c, p.Node_Type__c, p.Node_Result__c, p.Name, p.Mammography__c, p.MRI__c, p.Location__c, p.Laterality__c, p.LastModifiedDate, p.LastModifiedById, p.IsDeleted, p.Id, p.Form_Name__c, p.Date_Of_Procedure__c, p.CreatedDate, p.CreatedById from Procedure__c p where Date_Of_Procedure__c =:postsurObj.Date_Of_Procedure__c and TrialPatient__c =:TrialPatientId and Post_Surgery_Summary__c !=:rId];
            
            if(!procedureList.isEmpty()) {
                isShowProcedure = true;
            } else {
                isShowProcedure = false;
            }
            system.debug('__procedureList__'+procedureList);
        }
    }
    
    public Pagereference customCancel(){
        system.debug('__TrialPatientId__'+TrialPatientId);
        List<TrialPatient__c> trialPatList = [select Patient_Id__c, Trial_Id__c from TrialPatient__c where Id =:TrialPatientId];
       /* if(postSurObj.OriginalCRF__c == null)
            delete postSurObj;*/
            if( rId != null) {
               // Added by Shruti (DE401)  
                    try {
            delete new Post_Surgaory_Summary__c(id=rId );
        }catch (Exception e) {
            Apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.ERROR, e.getMessage());
            Apexpages.addMessage(msg);             
            // Pagereference ref = new Pagereference('/apex/PostSurgerySummary?postid='+rId +'&trialPat='+Apexpages.currentPage().getparameters().get('trialPat'));
             Pagereference ref = new Pagereference('/'+rId);
             ref.setRedirect(true);
             return ref;             
              } 
                // Added by Shruti (DE401)               
            }
        
        System.debug('-----Deleted---->');
        Pagereference pr = new Pagereference('/apex/TranscendPage?id='+trialPatList[0].Patient_Id__c+'&TrialId='+trialPatList[0].Trial_Id__c+'&sfdc.override=1');
       //Pagereference pr = new Pagereference('/apex/TranscendPage?id='+trialPatList[0].Patient_Id__c+'&sfdc.override=1');
        return pr;
    }
    
    public class wrapProcedure {
        public Procedure__c procedure{get;set;}
        public List<wrapSpecimen> proSpecimen{get;set;}
        public List<Lymph_Nodes__c> lymphNodeList{get;set;}
        public Integer hiddenPositiveValue{get;set;}
        public Integer hiddenExaminedValue{get;set;}
        public Integer srNo{get;set;}
        
        public wrapProcedure() {
            proSpecimen = new List<wrapSpecimen>();
            //lymphNodeList = new List<Lymph_Nodes__c>(); 
            srNo = 0;
        }
    }
    
    public class wrapSpecimen {
        public Procedure_Specimen_Detail__c proSpecimen{get;set;}
        public integer srno{get;set;}
        public Boolean isShowAddLink{get;set;}
        public Boolean isShowMainSecimen{get;set;}
        public Boolean isShowSingleSecimen{get;set;}
        
        public wrapSpecimen() {
            isShowAddLink = false;
            isShowMainSecimen = false;
            isShowSingleSecimen = false;
        }
    }
    
    /*public class wrapLymphProcedure {
        public Procedure__c procedure{get;set;}
        public List<wrapLymphNode> proLymphNode{get;set;}
        
        public wrapLymphProcedure() {
            proLymphNode = new List<wrapLymphNode>(); 
        }
    }
    
    public class wrapLymphNode {
        public Lymph_Nodes__c lymphNode{get;set;}
    }*/
    //=======================Edit main CRF After rejecting by DCC============================================================
         
    public Pagereference cloneCRF() {
        openInEditMode = true;
        //String clonedCRFId = CloneBuilder.cloneMe(postSurObj.Id, '0', '');
        postSurObj.Status__c = 'Not Completed';
        try {
            update postSurObj;
        }catch (Exception e) {
            Apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.ERROR, e.getMessage());
            Apexpages.addMessage(msg);
            return null;
        }
        return null;
    }
    
    public Pagereference editCRF() {
        if(isShowEditButton) {
            lstClonePSS[0].Status__c = 'Not Completed';
            try {
                update lstClonePSS[0];
            }catch (Exception e) {
                Apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.ERROR, e.getMessage());
                Apexpages.addMessage(msg);
                // Added by Shruti (DE401)
                    // Pagereference ref = new Pagereference('/apex/PostSurgerySummary?postid='+rId +'&trialPat='+Apexpages.currentPage().getparameters().get('trialPat'));
                     Pagereference ref = new Pagereference('/'+rId);
                     ref.setRedirect(true);
                     return ref;
             // Added by Shruti (DE401)
            }
        }
        openInEditMode = false;
        currentTab = 'Calcification';
        isComplete = true;
        Pagereference ref = new Pagereference('/apex/PostSurgerySummary?trialPat='+TrialPatientId+'&formName=Post Surgery Summary Form&postid='+clonedCRFId);
        ref.setRedirect(true);
        return ref;
    }
}