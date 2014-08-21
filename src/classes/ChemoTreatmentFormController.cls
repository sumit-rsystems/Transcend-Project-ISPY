public with sharing class ChemoTreatmentFormController {
  
  public String userName {get;set;}
  public String password {get;set;}
  public String errorMsg {get;set;}
  
  public ChemoTreatmentWrapper chemoTreatmentWrapper {get;set;}
  public Id chemoTreatmentId {get;set;}
  public String trialPatientId = null;
  public String trialPatient {get;set;}
  public String treatmentArm {get;set;}
  public String currentTab {get;set;}
  public List<SelectOption> studyTreatmentOptions {get;set;}
  public List<ChemoTherapyWrapper> lstCTWrapper {get;set;}
  public List<Growth_Factor__c> lstGrowthFactor {get;set;}
  private List<Chemo_Treatment__c> lstCloneChemo {get;set;}
  public Boolean isComplete{get; set;}
  public Boolean isShowEditButton{get;set;}
  private Id clonedCRFId{get;set;}
  public String lastFeed {get;set;}
  public integer cycleNumber = 0;
  public boolean openInEditMode {get;set;}
  public integer medicationSNO = 0;
  public String nextTabName{get;set;}
  public TrialPatient__c trialPatientObj {get;set;}
  public String profileName{get;set;}
  public Boolean isDelete{get;set;}
  public Chemo_Treatment__c pathObj{get;set;}
  public integer getMedicationSNO() {
    return medicationSNO;
  }
      public Integer counterchecker=0;
  
  
  public ChemoTreatmentFormController(Apexpages.StandardController std) {
    System.debug('ChemoTreatmentForm-------'+std.getId());
    chemoTreatmentId = std.getId();
    Chemo_Treatment__c ChemoTreatmentObj;
    if(chemoTreatmentId != null)ChemoTreatmentObj = [Select c.TrialPatient__c From Chemo_Treatment__c c where id =: chemoTreatmentId];
        
    String currentUserId = UserInfo.getUserId();
    for(User u :[Select  Profile.Name , ProfileId, Id, Name From User where id =:currentUserId]){            
                 profileName = u.Profile.Name; 
    } 
    openInEditMode = false;
    isShowEditButton = false;
    chemoTreatmentWrapper = new ChemoTreatmentWrapper();
    system.debug('constructor called!');
    lstCTWrapper = new List<ChemoTherapyWrapper>();
    
    lstGrowthFactor = new List<Growth_Factor__c>();
    isComplete = true;
    isDelete = false; 
    studyTreatmentOptions = new List<Selectoption>();
    studyTreatmentOptions.add(new Selectoption('false','No'));
    studyTreatmentOptions.add(new Selectoption('true','Yes'));
    
    if(ChemoTreatmentObj != null){
        trialPatientId = ChemoTreatmentObj.TrialPatient__c;
        chemoTreatmentId = ChemoTreatmentObj.id;
    }else{
        trialPatientId = Apexpages.currentPage().getParameters().get('trialPat');
        chemoTreatmentId = Apexpages.currentPage().getParameters().get('formId');
    }
    
    if(trialPatientId != null) {
      List<TrialPatient__c> lstTrialPatient = [select Name, Patient_Id__c, Trial_Id__r.Name  from TrialPatient__c where Id = :trialPatientId];
      if(!lstTrialPatient.IsEmpty()) {
        trialPatientObj = lstTrialPatient[0];
      }
    } 
    
    List<ArmPatient__c> lstArmPatient = [Select a.Arm_Id__r.Name, a.Arm_Id__c From ArmPatient__c a where TrialPatient__c = :trialPatientId];
    if(!lstArmPatient.isEmpty()) { 
      treatmentArm = lstArmPatient[0].Arm_Id__r.Name;
    } else {
      treatmentArm = 'Patient not randomized.';
    }
    
    system.debug('trialPatientId : '+trialPatientId);
    system.debug('getNextAdministrationDay() : '+getNextAdministrationDay(trialPatientId, 'Dose'));
    
    if(chemoTreatmentWrapper.lstChemoTherapyWrapper == null || chemoTreatmentWrapper.lstChemoTherapyWrapper.isEmpty()) {
      Map<String, integer> mapNextAdminDay = getNextAdministrationDay(trialPatientId, 'Frequency');
      Map<String, integer> mapLastAdminDose = getNextAdministrationDay(trialPatientId, 'Dose');
      chemoTreatmentWrapper.lstChemoTherapyWrapper = buildlstChemoTherapyWrapper(mapNextAdminDay, mapLastAdminDose);
    }
    
    List<Chemo_Therapy_Regimen__c> lstChemoTherapy_old = null;
    List<Growth_Factor__c> lstGrowthFact = null;
    List<Chemo_Treatment__c> lstChemoTreatment_Stored = [Select c.Root_CRF_Id__c,c.OriginalCRF__c, c.CreatedBy.FirstName, c.CRF__c, c.TrialPatient__c, c.Status__c, 
          c.RecordTypeId, c.Patient_weight__c, c.Patient_height__c, c.Name, c.Id, c.Did_patient_go_off_study_treatment__c, c.Date_of_therapy__c, 
          c.Cycle_number__c, c.Effective_Time__c, (Select Id, isReceived__c , Name, Dose__c, TotalDose__c, Route__c, Notes__c, Chemo_Treatment__c 
          From Growth_Factor__r),  (Select Id, Name, Prescribed_Dose__c, Total_Dose__c, Day__c, Dose_Delay__c, Did_patient_stop_receiving__c, 
          Reason_why_patient_stopped_receiving__c, Chemo_Treatment__c, Agent__c, Dose_modification__c, Dose_Mod__c, Other_Dose_Mod_Reason__c, 
          Dose_Mod_Reason_Number__c From Chemo_Therapy_Regimens__r), (Select Id, Medication__c, Other_Madication__c, Start_Year__c, 
          Start_Month__c, Start_Day__c, End_Year__c, End_Day__c, End_Month__c, Frequency__c, Dose__c, DoseValue__c, Route__c, Type__c, 
          Chemo_Treatment__c From Concomitant_Medications__r) From Chemo_Treatment__c c where TrialPatient__c = :trialPatientId order by Effective_Time__c ASC];
    system.debug('lstChemoTreatment_Stored : '+lstChemoTreatment_Stored);
    if(lstChemoTreatment_Stored.size() >= 2) {
      lstGrowthFact = lstChemoTreatment_Stored[1].Growth_Factor__r;
      //lstChemoTherapy_old = lstChemoTreatment_Stored[1].Chemo_Therapy_Regimens__r;
      //system.debug('lstChemoTherapy_old : '+lstChemoTherapy_old);
    }
    
    cycleNumber = lstChemoTreatment_Stored.size() + 1; 
    
    if(chemoTreatmentWrapper == null) {
      chemoTreatmentWrapper = new ChemoTreatmentWrapper();
    }
    
    chemoTreatmentWrapper.chemoTreatment = new Chemo_Treatment__c();
    chemoTreatmentWrapper.chemoTreatment.Did_patient_go_off_study_treatment__c = false;
    chemoTreatmentWrapper.lstGrowthFactor = new List<Growth_Factor__c>();
    
    Growth_Factor__c growthFactor1 = new Growth_Factor__c();
    growthFactor1.Name = 'Neulasta';
    if(lstGrowthFact != null) {
      for(Growth_Factor__c gf : lstGrowthFact) {
        if(gf.Name == 'Neulasta') {
          growthFactor1.Dose__c = gf.Dose__c;
        }
      }
    }
    chemoTreatmentWrapper.lstGrowthFactor.add(growthFactor1);
    
    Growth_Factor__c growthFactor2 = new Growth_Factor__c();
    growthFactor2.Name = 'Neupogen';
    if(lstGrowthFact != null) {
      for(Growth_Factor__c gf : lstGrowthFact) {
        if(gf.Name == 'Neupogen') {
          growthFactor2.Dose__c = gf.Dose__c;
        }
      }
    }
    chemoTreatmentWrapper.lstGrowthFactor.add(growthFactor2);
    
    chemoTreatmentWrapper.lstMedicationWrapper = new List<MedicationWrapper>();
    /*List<Concomitant_Medication__c> lstConMed = new List<Concomitant_Medication__c>();
    if(lstChemoTreatment_Stored.size() > 2)  {
      List<Concomitant_Medication__c> lstConMedication1 = lstChemoTreatment_Stored[lstChemoTreatment_Stored.size() - 2].Concomitant_Medications__r;
      medicationSNO = 0;
      System.debug('lstConMedication1 : '+lstConMedication1);
      if(lstConMedication1 != null && !lstConMedication1.isEmpty()) {
        for(Concomitant_Medication__c conMed : lstConMedication1) {
      */    /*MedicationWrapper medWrapper = new MedicationWrapper();
          medWrapper.concomitantMedication = new Concomitant_Medication__c();
          medWrapper.concomitantMedication.Chemo_Treatment__c = conMed.Chemo_Treatment__c;
          medWrapper.concomitantMedication.Dose__c = conMed.Dose__c;
          medWrapper.concomitantMedication.DoseValue__c = conMed.DoseValue__c;
          medWrapper.concomitantMedication.End_Day__c = conMed.End_Day__c;
          medWrapper.concomitantMedication.End_Month__c = conMed.End_Month__c;
          medWrapper.concomitantMedication.End_Year__c = conMed.End_Year__c;
          medWrapper.concomitantMedication.Frequency__c = conMed.Frequency__c;
          medWrapper.concomitantMedication.Medication__c = conMed.Medication__c;
          medWrapper.concomitantMedication.Other_Madication__c = conMed.Other_Madication__c;
          medWrapper.concomitantMedication.Route__c = conMed.Route__c;
          medWrapper.concomitantMedication.Start_Day__c = conMed.Start_Day__c;
          medWrapper.concomitantMedication.Start_Month__c = conMed.Start_Month__c;
          medWrapper.concomitantMedication.Start_Year__c = conMed.Start_Year__c;
          medWrapper.concomitantMedication.Type__c = conMed.Type__c;
          
          medWrapper.isReadOnly = true;
          medWrapper.isUpdateVisible = false;
          medWrapper.sno = String.valueOf(++medicationSNO);
          if(conMed.Other_Madication__c != null && conMed.Other_Madication__c != '') {
            medWrapper.isOtherMedication = true;
          }
          chemoTreatmentWrapper.lstMedicationWrapper.add(medWrapper);*/
          
      /*    MedicationWrapper mWrapper = new MedicationWrapper();
          mWrapper.concomitantMedication = new Concomitant_Medication__c();
          mWrapper.concomitantMedication.Dose__c = conMed.Dose__c;
          mWrapper.concomitantMedication.DoseValue__c = conMed.DoseValue__c;
          mWrapper.concomitantMedication.End_Day__c = conMed.End_Day__c;
          mWrapper.concomitantMedication.End_Month__c = conMed.End_Month__c;
          mWrapper.concomitantMedication.End_Year__c = conMed.End_Year__c;
          mWrapper.concomitantMedication.Frequency__c = conMed.Frequency__c;
          mWrapper.concomitantMedication.Medication__c = conMed.Medication__c;
          mWrapper.concomitantMedication.Other_Madication__c = conMed.Other_Madication__c;
          mWrapper.concomitantMedication.Route__c = conMed.Route__c;
          mWrapper.concomitantMedication.Start_Day__c = conMed.Start_Day__c;
          mWrapper.concomitantMedication.Start_Month__c = conMed.Start_Month__c;
          mWrapper.concomitantMedication.Start_Year__c = conMed.Start_Year__c;
          mWrapper.concomitantMedication.Type__c = conMed.Type__c;
          mWrapper.isReadOnly = false;
          mWrapper.isUpdateVisible = false;
          mWrapper.isOtherMedication = false;
          mWrapper.sno = String.valueOf(++medicationSNO);
          chemoTreatmentWrapper.lstMedicationWrapper.add(mWrapper);
      */    
          /*Concomitant_Medication__c cmCopy = new Concomitant_Medication__c();
          cmCopy.Chemo_Treatment__c = conMed.Chemo_Treatment__c;
          cmCopy.Dose__c = conMed.Dose__c;
          cmCopy.DoseValue__c = conMed.DoseValue__c;
          cmCopy.End_Day__c = conMed.End_Day__c;
          cmCopy.End_Month__c = conMed.End_Month__c;
          cmCopy.End_Year__c = conMed.End_Year__c;
          cmCopy.Frequency__c = conMed.Frequency__c;
          cmCopy.Medication__c = conMed.Medication__c;
          cmCopy.Other_Madication__c = conMed.Other_Madication__c;
          cmCopy.Route__c = conMed.Route__c;
          cmCopy.Start_Day__c = conMed.Start_Day__c;
          cmCopy.Start_Month__c = conMed.Start_Month__c;
          cmCopy.Start_Year__c = conMed.Start_Year__c;
          cmCopy.Type__c = conMed.Type__c;
          
          lstConMed.add(conMed);*/
    /*    }
      }
    }*/
      //insert lstConMed;
    System.debug('chemoTreatmentWrapper.lstMedicationWrapper : '+chemoTreatmentWrapper.lstMedicationWrapper);
    system.debug('chemoTreatmentId : '+chemoTreatmentId);
    if(chemoTreatmentId != null) {
      
      List<Chemo_Treatment__c> lstChemoTreatment = [Select c.Root_CRF_Id__c,c.OriginalCRF__c, c.CreatedBy.FirstName, c.Effective_Time__c, c.TrialPatient__c, c.Status__c, c.RecordTypeId, c.Patient_weight__c, c.Patient_height__c, c.Name, c.Id, c.Did_patient_go_off_study_treatment__c, c.Date_of_therapy__c, c.Cycle_number__c, c.CRF__c,
                  (Select Id, isReceived__c , Name, Dose__c, TotalDose__c, Route__c, Notes__c, Chemo_Treatment__c From Growth_Factor__r), 
                  (Select Id, Medication__r.Name, Medication__c, Other_Madication__c, Start_Year__c, Start_Month__c, Start_Day__c, End_Year__c, End_Day__c, End_Month__c, Frequency__c, Dose__c, DoseValue__c, Route__c, Type__c, Chemo_Treatment__c From Concomitant_Medications__r), 
                  (Select Id, Name, Prescribed_Dose__c, Total_Dose__c, Day__c, Dose_Delay__c, Did_patient_stop_receiving__c, Reason_why_patient_stopped_receiving__c, Chemo_Treatment__c, Agent__c, Dose_modification__c, Dose_Mod__c, Other_Dose_Mod_Reason__c, Dose_Mod_Reason_Number__c, Other_Agent__c, Prescribed_dose_Units__c, Administered_dose_Units__c From Chemo_Therapy_Regimens__r) From Chemo_Treatment__c c where Id = :chemoTreatmentId];
      system.debug('lstChemoTreatment : '+lstChemoTreatment);
      if(!lstChemoTreatment.isEmpty()) {
        lstCloneChemo = [select Id, Status__c,Root_CRF_Id__c from Chemo_Treatment__c where OriginalCRF__c =:lstChemoTreatment[0].Id and Status__c = 'Cloned'];
        if(!lstCloneChemo.isEmpty()) {
          isShowEditButton = true;
          clonedCRFId = lstCloneChemo[0].Id;
        }
        chemoTreatmentWrapper.chemoTreatment = lstChemoTreatment[0];
        List<Growth_Factor__c> lstGrowFect = lstChemoTreatment[0].Growth_Factor__r;
        if(lstGrowFect != null && !lstGrowFect.isEmpty()) {
          chemoTreatmentWrapper.lstGrowthFactor = lstGrowFect;
        }
        medicationSNO = 0;
        List<Concomitant_Medication__c> lstConMedication = lstChemoTreatment[0].Concomitant_Medications__r;
        if(lstConMedication != null && !lstConMedication.isEmpty()) {
          for(Concomitant_Medication__c conMed : lstConMedication) {
            MedicationWrapper medWrapper = new MedicationWrapper();
            medWrapper.concomitantMedication = conMed;
            medWrapper.isReadOnly = true;
            medWrapper.isUpdateVisible = false;
            medWrapper.sno = String.valueOf(++medicationSNO);
            if(conMed.Other_Madication__c != null && conMed.Other_Madication__c != '') {
              medWrapper.isOtherMedication = true;
            }
            chemoTreatmentWrapper.lstMedicationWrapper.add(medWrapper);
          }
        }
        String agent = '';
        List<ChemoTherapyWrapper> savedChemoTherapy = new List<ChemoTherapyWrapper>();
        List<Chemo_Therapy_Regimen__c> lstChemoTherapy = lstChemoTreatment[0].Chemo_Therapy_Regimens__r;
        system.debug('lstChemoTherapy : '+lstChemoTherapy);
        if(lstChemoTherapy != null && !lstChemoTherapy.isEmpty()) {
          system.debug('lstChemoTherapy_old : '+lstChemoTherapy_old);
          for(Chemo_Therapy_Regimen__c chemoTherapy : lstChemoTherapy) {
            for(ChemoTherapyWrapper chTherapyWrapper : chemoTreatmentWrapper.lstChemoTherapyWrapper) {
              //system.debug('chTherapyWrapper.chemoTherapy : '+chTherapyWrapper.chemoTherapy);
              //system.debug('chemoTherapy : '+chemoTherapy);
              if(chTherapyWrapper.chemoTherapy.Id != null) continue;
              if(chTherapyWrapper.chemoTherapy.Agent__c == chemoTherapy.Agent__c) {
                chTherapyWrapper.isAgentChecked = true;
                chTherapyWrapper.isDisabled = false;
                chTherapyWrapper.chemoTherapy = chemoTherapy;
                if(chTherapyWrapper.chemoTherapy.Day__c == null) {
                  chTherapyWrapper.chemoTherapy.Day__c = 1;
                }
                break;
              }
            }
            if(chemoTherapy.Other_Agent__c != null && chemoTherapy.Other_Agent__c != '') {
              ChemoTherapyWrapper chemoTherapyWrapper = new ChemoTherapyWrapper();
              chemoTherapyWrapper.chemoTherapy = chemoTherapy;
              if(chemoTherapyWrapper.chemoTherapy.Day__c == null) {
                chemoTherapyWrapper.chemoTherapy.Day__c = 1;
              }
              chemoTherapyWrapper.agentName = chemoTherapy.Other_Agent__c;
              chemoTherapyWrapper.isAgentChecked = true;
              chemoTherapyWrapper.isOtherAgent = true;
              chemoTreatmentWrapper.chemoTreatment.Did_patient_go_off_study_treatment__c = true;
              savedChemoTherapy.add(chemoTherapyWrapper);
            } else {
              if(chemoTherapy.Agent__c != null && agent == '') {
                agent = chemoTherapy.Agent__c;
              }
            }
          }
          List<Agent__c> lstAgent = [select Id, Name from Agent__c where Id = :agent];
          if(!lstAgent.isEmpty()) {
            Apexpages.currentPage().getParameters().put('agentName', lstAgent[0].Name);
            executeChemoTherapyRule();
          }
          
          chemoTreatmentWrapper.lstChemoTherapyWrapper.addAll(savedChemoTherapy);
          system.debug('chemoTreatmentWrapper.lstChemoTherapyWrapper : '+chemoTreatmentWrapper.lstChemoTherapyWrapper);
          
        }
      }
      
      /*lstFeeds = [Select b.ParentId, b.ContentFileName, b.ContentDescription, b.Body, b.LinkUrl, b.CreatedDate From Chemo_Treatment__Feed b where ParentId = :chemoTreatmentWrapper.chemoTreatment.Id order by CreatedDate DESC];
      if(!lstFeeds.isEmpty()) {
        lastFeed = lstFeeds[lstFeeds.size() - 1].Body;
      }*/
      
      for(Growth_Factor__c gf : ChemoTreatmentWrapper.lstGrowthFactor) {
        gf.Chemo_Treatment__c = chemoTreatmentWrapper.chemoTreatment.Id;
        if(gf.isReceived__c) {
          lstGrowthFactor.add(gf);
        }
      }
        
      lstCTWrapper = new List<ChemoTherapyWrapper>();
      List<Chemo_Therapy_Regimen__c> lstChemoTherapyRegimen = new List<Chemo_Therapy_Regimen__c>();
      for(ChemoTherapyWrapper chemoTherapyWrapper : chemoTreatmentWrapper.lstChemoTherapyWrapper) {
        if(chemoTherapyWrapper.isAgentChecked) {
          chemoTherapyWrapper.chemoTherapy.Chemo_Treatment__c = chemoTreatmentWrapper.chemoTreatment.Id;
          lstChemoTherapyRegimen.add(chemoTherapyWrapper.chemoTherapy);
          lstCTWrapper.add(chemoTherapyWrapper);
        }
      }
      
    }
    
    currentTab = 'chemoAdminTab';
    isComplete = CRFUtilities.isReadOnlyUsr(); 
    if(chemoTreatmentWrapper.chemoTreatment != null){
      //String crfId = chemoTreatmentWrapper.chemoTreatment.CRF__c;
      //System.debug('-----chemoTreatmentWrapper.chemoTreatment.CRF__c------->'+chemoTreatmentWrapper.chemoTreatment.CRF__c);
      //if(crfId != null && crfId != ''){
        //System.debug('-----chemoTreatmentWrapper.chemoTreatment.CRF__c------->'+chemoTreatmentWrapper.chemoTreatment.CRF__c);
        //String status = CRFUtilities.CRFStatus(crfId);
        String status = chemoTreatmentWrapper.chemoTreatment.Status__c;
        System.debug('-----status------->'+status);
        if(status == 'Approval Pending' || status == 'Accepted' || status == 'Approval Not Required' || status == 'Rejected'){
          currentTab = 'completeTab';
          isComplete = false; 
        } else {
          currentTab = 'chemoAdminTab';
        }
      //}
    }
     isDelete();
  }
    public void isDelete(){
        
        System.debug('======chemoTreatmentId=======' +chemoTreatmentId);
        if(chemoTreatmentId != null){
            pathObj = [select Id, Status__c from Chemo_Treatment__c where id =:chemoTreatmentId];
            
            if(pathObj != null && pathObj.Status__c != 'Not Completed'){
                isDelete = true;    
            }
        }
            
        System.debug('======chemoTreatmentId=======' +chemoTreatmentId); 
    }
    public pagereference redirect(){
            pagereference redirect = new pagereference('/apex/ChemoTreatmentPdf?id='+chemoTreatmentId);
            redirect.setRedirect(true);
            return redirect;
     }  
  
  public Map<String, integer> getNextAdministrationDay(Id trialPatient, String requiredData) {
    Map<String, integer> mapAdminCount = new Map<String, integer>();
    List<Chemo_Therapy_Regimen__c> lstChemoTherapyRegimen = [Select c.Prescribed_Dose__c, c.Day__c, c.Chemo_Treatment__r.TrialPatient__c, c.Chemo_Treatment__c, c.Agent__c From Chemo_Therapy_Regimen__c c where Chemo_Treatment__r.TrialPatient__c = :trialPatient order by Effective_Time__c DESC];
    
    if(requiredData == 'Dose') {
      Map<String, integer> mapAdminDose = new Map<String, integer>();
      for(Chemo_Therapy_Regimen__c ctr : lstChemoTherapyRegimen) {
        if(mapAdminDose.containsKey(ctr.Agent__c)) {
          continue;
        } else {
          mapAdminDose.put(ctr.Agent__c, Integer.valueOf(ctr.Prescribed_Dose__c));
        }
      }
      return mapAdminDose;
    }
    
    for(Chemo_Therapy_Regimen__c ctr : lstChemoTherapyRegimen) {
      if(mapAdminCount.containsKey(ctr.Agent__c)) {
        mapAdminCount.put(ctr.Agent__c, mapAdminCount.get(ctr.Agent__c) + 1);
      } else {
        mapAdminCount.put(ctr.Agent__c, 1);
      }
    }
    
    system.debug('mapAdminCount : '+mapAdminCount);
    List<Agent__c> lstAgent = [Select a.Name, a.Id, a.Frequency__c, a.Dose_Unit__c, a.Display_Order__c, a.Total_Dose_Unit__c  From Agent__c a];
    Map<Id, String> agentMap = new Map<Id, String>();
    for(Agent__c ag : lstAgent) {
      if(agentMap.containsKey(ag.Id)) {
        agentMap.put(ag.Id, ag.Frequency__c);
      } else {
        agentMap.put(ag.Id, ag.Frequency__c);
      }
    }
    system.debug('agentMap : '+agentMap);
    Map<String, integer> lstNextAdminDay = new Map<String, integer>();
    for(String key : mapAdminCount.keySet()) {
      if(agentMap.get(key) == 'Weekly') {
        lstNextAdminDay.put(key, (mapAdminCount.get(key)*7)+1);
      } else if(agentMap.get(key) == 'Daily') {
        lstNextAdminDay.put(key, (mapAdminCount.get(key)));
      } else if(agentMap.get(key) == '3 weeks') {
        lstNextAdminDay.put(key, (mapAdminCount.get(key)*21)+1);
      }
    }
    return lstNextAdminDay;  
  }
  
  public Pagereference saveMainCRF() {
    system.debug('chemoTreatmentId : '+chemoTreatmentId);
    system.debug('trialPatientId : '+trialPatientId);
    if(chemoTreatmentId == null) {
      
      chemoTreatmentWrapper.chemoTreatment.TrialPatient__c = trialPatientId;
      chemoTreatmentWrapper.chemoTreatment.Date_of_therapy__c = system.today();
      chemoTreatmentWrapper.chemoTreatment.Cycle_number__c = cycleNumber;
      
      try {
            insert chemoTreatmentWrapper.chemoTreatment;
        }catch (Exception e) {
            Apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.ERROR, e.getMessage());
            Apexpages.addMessage(msg);
            return null;
        }
      
      chemoTreatmentId = chemoTreatmentWrapper.chemoTreatment.Id;
      
      //Pagereference ref = new Pagereference('/apex/ChemoTreatmentForm?trialPat='+trialPatientId+'&formId='+chemoTreatmentId);
      Pagereference ref = new Pagereference('/'+chemoTreatmentId);
      ref.setRedirect(true);
      return ref;
      
    } else {
      List<Chemo_Treatment__c> lstChemoTreatment = [Select c.Root_CRF_Id__c,c.OriginalCRF__c, c.TrialPatient__c,c.CRF__c, c.Status__c, c.RecordTypeId, c.Patient_weight__c, c.Patient_height__c, c.Name, c.Id, c.Did_patient_go_off_study_treatment__c, c.Date_of_therapy__c, c.Cycle_number__c, (Select Id, isReceived__c , Name, Dose__c, TotalDose__c, Route__c, Notes__c, Chemo_Treatment__c From Growth_Factor__r) From Chemo_Treatment__c c where Id = :chemoTreatmentId];
      if(lstChemoTreatment.isEmpty()) {
        return new Pagereference('/'+chemoTreatmentId);
      }
    }
    return null;
  }
  
  public Pagereference addOtherAgent() {
    if(chemoTreatmentWrapper.chemoTreatment.Did_patient_go_off_study_treatment__c == false) {
      //chemoTreatmentWrapper.chemoTreatment.addError('"Did patient go off study treatment?" should be \"Yes\". ');
      //return null;
    }
    ChemoTherapyWrapper chemoTherapyWrapper = new ChemoTherapyWrapper();
    chemoTherapyWrapper.chemoTherapy = new Chemo_Therapy_Regimen__c();
    chemoTherapyWrapper.isAgentChecked = true;
    chemoTherapyWrapper.isOtherAgent = true;
    chemoTreatmentWrapper.chemoTreatment.Did_patient_go_off_study_treatment__c = true;
    system.debug('chemoTreatmentWrapper.lstChemoTherapyWrapper : '+chemoTreatmentWrapper.lstChemoTherapyWrapper);
    chemoTreatmentWrapper.lstChemoTherapyWrapper.add(chemoTherapyWrapper);
    
    return null;
  }
  
  public List<ChemoTherapyWrapper> buildlstChemoTherapyWrapper(Map<String, integer> mapNextAdminDay, Map<String, integer> mapLastAdminDose) {
    List<ChemoTherapyWrapper> lstChemoTherapyWrapper = new List<ChemoTherapyWrapper>();
    List<Agent__c> lstAgent = [Select a.Name, a.Id, a.Frequency__c, a.Dose_Unit__c, a.Display_Order__c, a.Total_Dose_Unit__c  From Agent__c a];
    sortList(lstAgent, 'Display_Order__c', 'asc');
    
    for(Agent__c agent : lstAgent) {
      if(agent.Frequency__c == 'Daily') {
        for(integer i=1;i<=7;i++) {
          ChemoTherapyWrapper chemoTherapyWrapper = new ChemoTherapyWrapper();
          chemoTherapyWrapper.chemoTherapy = new Chemo_Therapy_Regimen__c();
          if(mapNextAdminDay.get(agent.Id) != null) {
            chemoTherapyWrapper.chemoTherapy.Day__c = mapNextAdminDay.get(agent.Id)+i;
          } else {
            chemoTherapyWrapper.chemoTherapy.Day__c = i;
          }
          
          chemoTherapyWrapper.chemoTherapy.Agent__c = agent.Id;
          chemoTherapyWrapper.chemoTherapy.Prescribed_Dose__c = mapLastAdminDose.get(agent.Id);
          chemoTherapyWrapper.agentName = agent.Name;
          chemoTherapyWrapper.isAgentChecked = false;
          chemoTherapyWrapper.doseUnit = agent.Dose_Unit__c;
          chemoTherapyWrapper.index=counterchecker++;
          chemoTherapyWrapper.totalDoseUnit = agent.Total_Dose_Unit__c;
          lstChemoTherapyWrapper.add(chemoTherapyWrapper);
        }
      } else {
          ChemoTherapyWrapper chemoTherapyWrapper = new ChemoTherapyWrapper();
          chemoTherapyWrapper.chemoTherapy = new Chemo_Therapy_Regimen__c();
          
          if(mapNextAdminDay.get(agent.Id) != null) {
            chemoTherapyWrapper.chemoTherapy.Day__c = mapNextAdminDay.get(agent.Id);
          } else {
            chemoTherapyWrapper.chemoTherapy.Day__c = 1;
          }
          
          chemoTherapyWrapper.chemoTherapy.Agent__c = agent.Id;
          chemoTherapyWrapper.chemoTherapy.Prescribed_Dose__c = mapLastAdminDose.get(agent.Id);
          chemoTherapyWrapper.agentName = agent.Name;
          chemoTherapyWrapper.isAgentChecked = false;
          chemoTherapyWrapper.doseUnit = agent.Dose_Unit__c;
          chemoTherapyWrapper.index=counterchecker++;
          chemoTherapyWrapper.totalDoseUnit = agent.Total_Dose_Unit__c;
          lstChemoTherapyWrapper.add(chemoTherapyWrapper);
      }
    }
    
    return lstChemoTherapyWrapper;
  }
  
  public void sortList(List<Sobject> items, String sortField, String order){


       List<Sobject> resultList = new List<Sobject>();
   
        //Create a map that can be used for sorting 
       Map<object, List<Sobject>> objectMap = new Map<object, List<Sobject>>();
           
       for(Sobject ob : items){
                if(objectMap.get(ob.get(sortField)) == null){  // For non Sobject use obj.ProperyName
                    objectMap.put(ob.get(sortField), new List<Sobject>()); 
                }
                objectMap.get(ob.get(sortField)).add(ob);
        }       
        //Sort the keys
        List<object> keys = new List<object>(objectMap.keySet());
        keys.sort();
       
        for(object key : keys){ 
            resultList.addAll(objectMap.get(key)); 
        }
       
        //Apply the sorted values to the source list
        items.clear();
        if(order.toLowerCase() == 'asc'){
            for(Sobject ob : resultList){
                items.add(ob); 
            }
        }else if(order.toLowerCase() == 'desc'){
            for(integer i = resultList.size()-1; i >= 0; i--){
                items.add(resultList[i]);  
            }
        } 
    }
  
  public Pagereference next() {
    String nextTabValue = Apexpages.currentPage().getParameters().get('nextTab');
    if(nextTabValue != null){
      nextTabName = nextTabValue;
    }
    
    if(chemoTreatmentWrapper.chemoTreatment.Date_of_therapy__c > System.today()) {
      chemoTreatmentWrapper.chemoTreatment.Date_of_therapy__c.addError('Future dates are not allowed.');
      return null;
    }
    try {
        update chemoTreatmentWrapper.chemoTreatment;
    }catch (Exception e) {
        Apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.ERROR, e.getMessage());
        Apexpages.addMessage(msg);
         // Added by Shruti (DE401)
             //Pagereference ref = new Pagereference('/apex/ChemoTreatmentForm?id='+chemoTreatmentId);
             Pagereference ref = new Pagereference('/'+chemoTreatmentId);
            ref.setRedirect(true);
             return ref;
             // Added by Shruti (DE401)
    }
  
    /*lstFeeds = [Select b.ParentId, b.ContentFileName, b.ContentDescription, b.Body, b.LinkUrl, b.CreatedDate From Chemo_Treatment__Feed b where ParentId = :chemoTreatmentWrapper.chemoTreatment.Id order by CreatedDate DESC];
    if(!lstFeeds.isEmpty()) {
      lastFeed = lstFeeds[lstFeeds.size() - 1].Body;
    }*/
    
    
    if(currentTab == 'growthFactorsTab') {
      lstGrowthFactor = new List<Growth_Factor__c>();
      for(Growth_Factor__c gf : ChemoTreatmentWrapper.lstGrowthFactor) {
        gf.Chemo_Treatment__c = chemoTreatmentWrapper.chemoTreatment.Id;
        if(gf.isReceived__c) {
          lstGrowthFactor.add(gf);
        }
      }
      // Added by Shruti (DE401)
      try {
        upsert ChemoTreatmentWrapper.lstGrowthFactor;
    }catch (Exception e) {
        Apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.ERROR, e.getMessage());
        Apexpages.addMessage(msg);         
            // Pagereference ref = new Pagereference('/apex/ChemoTreatmentForm?id='+chemoTreatmentId);
            Pagereference ref = new Pagereference('/'+chemoTreatmentId);
            ref.setRedirect(true);
             return ref;             
        }
        // Added by Shruti (DE401)      
      currentTab = 'conMedTab'; 
    } 
    else if(currentTab == 'conMedTab') {
      //currentTab = 'attachmentTab';
    }else if(currentTab == 'attachmentTab') {
      //currentTab = 'completeTab';
    }
    lstCTWrapper = new List<ChemoTherapyWrapper>();
    List<Chemo_Therapy_Regimen__c> lstChemoTherapyRegimen = new List<Chemo_Therapy_Regimen__c>();
    List<Chemo_Therapy_Regimen__c> lstDeleteChemoTherapyRegimen = new List<Chemo_Therapy_Regimen__c>();
    for(ChemoTherapyWrapper chemoTherapyWrapper : chemoTreatmentWrapper.lstChemoTherapyWrapper) {
    	system.debug('chemoTherapyWrapper.isAgentChecked: '+chemoTherapyWrapper.isAgentChecked+', chemoTherapyWrapper.chemoTherapy.Id: '+chemoTherapyWrapper.chemoTherapy.Id);
      if(chemoTherapyWrapper.isAgentChecked) {
        system.debug('chemoTherapyWrapper : '+chemoTherapyWrapper);
        system.debug('chemoTherapyWrapper.chemoTherapy : '+chemoTherapyWrapper.chemoTherapy);
        chemoTherapyWrapper.chemoTherapy.Chemo_Treatment__c = chemoTreatmentWrapper.chemoTreatment.Id;
                
        lstChemoTherapyRegimen.add(chemoTherapyWrapper.chemoTherapy);
        lstCTWrapper.add(chemoTherapyWrapper);
      } else if(chemoTherapyWrapper.chemoTherapy.Id != null) {
      	lstDeleteChemoTherapyRegimen.add(chemoTherapyWrapper.chemoTherapy);
      }
    }
    //List<Chemo_Therapy_Regimen__c> lstCTR = new List<Chemo_Therapy_Regimen__c>();
    Map<ID, Chemo_Therapy_Regimen__c> chemoTherapyRegimenMap = new Map<ID, Chemo_Therapy_Regimen__c>();
    for(Chemo_Therapy_Regimen__c ctr : lstChemoTherapyRegimen) {
      if(!chemoTherapyRegimenMap.containsKey(ctr.Id)) {
        chemoTherapyRegimenMap.put(ctr.Id, ctr);
        //lstCTR.add(ctr);
      }
    }
    system.debug('lstChemoTherapyRegimen : '+lstChemoTherapyRegimen); 
    if(!lstDeleteChemoTherapyRegimen.isEmpty()) {
    	DeleteSharedRecordUtility.deleteChemoTherapyRegimen(lstDeleteChemoTherapyRegimen);
    	//delete lstDeleteChemoTherapyRegimen;
    }
     // Added by Shruti (DE401)
      try {
        upsert lstChemoTherapyRegimen;
    }catch (Exception e) {
        Apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.ERROR, e.getMessage());
        Apexpages.addMessage(msg);         
             // Pagereference ref = new Pagereference('/apex/ChemoTreatmentForm?id='+chemoTreatmentId);
             Pagereference ref = new Pagereference('/'+chemoTreatmentId);
            ref.setRedirect(true);
             return ref;             
        }
        // Added by Shruti (DE401)    
    if(nextTabName == 'saveAndClose') 
    {
//============================For Save & Close Functionality ====================  
      chemoTreatmentWrapper.chemoTreatment.First_Save_and_Close__c = true;
           try {
                update chemoTreatmentWrapper.chemoTreatment;
            }catch (Exception e) {
                Apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.ERROR, e.getMessage());
                Apexpages.addMessage(msg);
                //Added by Shruti (DE401)
                //Pagereference ref = new Pagereference('/apex/ChemoTreatmentForm?id='+chemoTreatmentId);
                Pagereference ref = new Pagereference('/'+chemoTreatmentId);
            ref.setRedirect(true);
             return ref; 
             //Added by Shruti (DE401)
            } 
//===============================================================================           
      List<TrialPatient__c> trialPatList = [select Patient_Id__c, Trial_Id__c from TrialPatient__c where Id =:trialPatientId];
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
  
  //public void previous() {
  public Pagereference previous() { //Added by Shruti (DE401)
    if(currentTab == 'growthFactorsTab') {
      currentTab = 'chemoAdminTab';
    } else if(currentTab == 'conMedTab') {
      currentTab = 'growthFactorsTab';
    } else if(currentTab == 'attachmentTab') {
      currentTab = 'conMedTab';
    } else if(currentTab == 'completeTab') {
      currentTab = 'attachmentTab';
    }
    // Added by Shruti (DE401)
    try {
        update chemoTreatmentWrapper.chemoTreatment;
    }catch (Exception e) {
        Apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.ERROR, e.getMessage());
        Apexpages.addMessage(msg);         
            // Pagereference ref = new Pagereference('/apex/ChemoTreatmentForm?id='+chemoTreatmentId);
             Pagereference ref = new Pagereference('/'+chemoTreatmentId);
            ref.setRedirect(true);
             return ref;             
         }
             return null;
             // Added by Shruti (DE401)
  }
  
  public Pagereference cancelCRF() {
    
    //Delete Chemo Treatment CRF permanently and Redirect page to patient Page
    
    List<TrialPatient__c> lstTP = [select Patient_Id__c, Trial_Id__c from TrialPatient__c where Id = :trialPatientId];
    if(!lstTP.isEmpty()) {
      if(trialPatientId != null) {
       /* if(chemoTreatmentWrapper.chemoTreatment.OriginalCRF__c == null) {
          delete chemoTreatmentWrapper.chemoTreatment;
        }*/
         if( chemoTreatmentId != null) {
                   // Added by Shruti (DE401)
      try {
        delete new  Chemo_Treatment__c(id=chemoTreatmentId);
    }catch (Exception e) {
        Apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.ERROR, e.getMessage());
        Apexpages.addMessage(msg);         
            // Pagereference ref = new Pagereference('/apex/ChemoTreatmentForm?id='+chemoTreatmentId);
            Pagereference ref = new Pagereference('/'+chemoTreatmentId);
            ref.setRedirect(true);
             return ref;             
        }
        // Added by Shruti (DE401)
                        
                }  
        return new Pagereference('/apex/TranscendPage?id='+lstTP[0].Patient_Id__c+'&TrialId='+lstTP[0].Trial_Id__c);
       // return new Pagereference('/apex/TranscendPage?id='+lstTP[0].Patient_Id__c);
      } else {
        return null;
      }
    } else {
      return null;
    }
    
  }
  
  public void addMedication() {
    
    MedicationWrapper mWrapper = new MedicationWrapper();
    mWrapper.concomitantMedication = new Concomitant_Medication__c();
    mWrapper.isReadOnly = false;
    mWrapper.isUpdateVisible = false;
    mWrapper.isOtherMedication = false;
    mWrapper.sno = String.valueOf(++medicationSNO);
    chemoTreatmentWrapper.lstMedicationWrapper.add(mWrapper);
    system.debug('chemoTreatmentWrapper.lstMedicationWrapper : '+chemoTreatmentWrapper.lstMedicationWrapper);
  }
  
  public void updateMedication() {
    List<Concomitant_Medication__c> lstConMedication = new List<Concomitant_Medication__c>();
    for(MedicationWrapper mWrapper : chemoTreatmentWrapper.lstMedicationWrapper) {
      if(mWrapper.concomitantMedication.Id == Apexpages.currentPage().getParameters().get('recordId')) {
        mWrapper.isReadOnly = true;
        mWrapper.isUpdateVisible = false;
        lstConMedication.add(mWrapper.concomitantMedication);
      }
    }
    upsert lstConMedication;
  }
  
  public void cancelMedication() {
    String recordId = Apexpages.currentPage().getParameters().get('recordId');
    system.debug('recordId : '+recordId);
    if(recordId != null && recordId != '') {
      for(MedicationWrapper mWrapper : chemoTreatmentWrapper.lstMedicationWrapper) {
        if(mWrapper.concomitantMedication.Id == recordId) {
          mWrapper.isReadOnly = true;
          mWrapper.isUpdateVisible = false;
        }
      }
      
    } else {
      medicationSNO = 0;
      List<MedicationWrapper> lstTempAlWrapper = new List<MedicationWrapper>();
      String cancelIndex = Apexpages.currentPage().getParameters().get('cancelIndex');
      for(MedicationWrapper mWrapper : chemoTreatmentWrapper.lstMedicationWrapper) {
        if(mWrapper.sno != cancelIndex) {
          MedicationWrapper newMWrapper = new MedicationWrapper();
          newMWrapper.concomitantMedication = mWrapper.concomitantMedication;
          newMWrapper.isReadOnly = mWrapper.isReadOnly;
          newMWrapper.isUpdateVisible = mWrapper.isUpdateVisible;
          newMWrapper.sno = String.valueOf(++medicationSNO);
          lstTempAlWrapper.add(newMWrapper);
        }
      }
      chemoTreatmentWrapper.lstMedicationWrapper = new List<MedicationWrapper>();
      chemoTreatmentWrapper.lstMedicationWrapper = lstTempAlWrapper;
    }
  }
  
  public void saveMedication() {
    List<Medication__c> lstMedication = [select Name from Medication__c];
    Map<Id,String> medicationMap = new Map<Id,String>();
    for(Medication__c med : lstMedication) {
      medicationMap.put(med.Id, med.Name);
    }
    List<Concomitant_Medication__c> lstConMedication = new List<Concomitant_Medication__c>();
    for(MedicationWrapper mWrapper : chemoTreatmentWrapper.lstMedicationWrapper) {
      if(mWrapper.concomitantMedication.Type__c != null && mWrapper.concomitantMedication.Type__c != '') {
        if(mWrapper.concomitantMedication.Type__c == 'Medication') {
          if(mWrapper.concomitantMedication.Medication__c == null) {
            mWrapper.concomitantMedication.Medication__c.addError('You must enter a value');
            return;
          }
        } else if(mWrapper.concomitantMedication.Type__c == 'Other') {
          if(mWrapper.concomitantMedication.Other_Madication__c == null || mWrapper.concomitantMedication.Other_Madication__c == '') {
            mWrapper.concomitantMedication.Other_Madication__c.addError('You must enter a value');
            return;
          }
        } 
        
      } else {
        mWrapper.concomitantMedication.Type__c.addError('Please select type of Medication');
        return;
      }
      
      mWrapper.isReadOnly = true;
      mWrapper.concomitantMedication.Chemo_Treatment__c = chemoTreatmentWrapper.chemoTreatment.Id;
      if(mWrapper.concomitantMedication.Type__c == 'Other') {
        mWrapper.medicationName = mWrapper.concomitantMedication.Other_Madication__c;
        mWrapper.isOtherMedication = true;
      } else {
        mWrapper.medicationName = medicationMap.get(mWrapper.concomitantMedication.Medication__c);
      }
      mWrapper.isReadOnly = true;
      mWrapper.isUpdateVisible = false;
      lstConMedication.add(mWrapper.concomitantMedication);
    }
    upsert lstConMedication;
  }
  
  public void editMedication() {
    String recordId = Apexpages.currentPage().getParameters().get('recordId'); 
    for(MedicationWrapper mWrapper : chemoTreatmentWrapper.lstMedicationWrapper) {
      if(mWrapper.concomitantMedication.Id == recordId) {
        mWrapper.isReadOnly = false;
        mWrapper.isUpdateVisible = true;
      }
    }
  }
  
  public void removeMedication() {
    String recordId = Apexpages.currentPage().getParameters().get('recordId');
    delete [select Id from Concomitant_Medication__c where Id =:recordId];
    medicationSNO = 0;
    List<MedicationWrapper> lstTempAlWrapper = new List<MedicationWrapper>();
    String cancelIndex = Apexpages.currentPage().getParameters().get('cancelIndex');
    for(MedicationWrapper mWrapper : chemoTreatmentWrapper.lstMedicationWrapper) {
      if(mWrapper.sno != cancelIndex) {
        MedicationWrapper newMWrapper = new MedicationWrapper();
        newMWrapper.concomitantMedication = mWrapper.concomitantMedication;
        newMWrapper.isReadOnly = mWrapper.isReadOnly;
        newMWrapper.isUpdateVisible = mWrapper.isUpdateVisible;
        newMWrapper.sno = String.valueOf(++medicationSNO);
        lstTempAlWrapper.add(newMWrapper);
      }
    }
    chemoTreatmentWrapper.lstMedicationWrapper = new List<MedicationWrapper>();
    chemoTreatmentWrapper.lstMedicationWrapper = lstTempAlWrapper;
  }
  
  public Pagereference signAndSubmit() {
    
    //ChangeAdhocToLiveController completeCrf = new ChangeAdhocToLiveController();
    //completeCrf.customAdhoc(chemoTreatmentWrapper.chemoTreatment.Id+'', 'submit', 'Site'); 
    
    SignAndSubmitController signSubmit = new SignAndSubmitController();
    signSubmit.password = password;
    Pagereference ref = signSubmit.signAndSubmit('00061','',chemoTreatmentWrapper.chemoTreatment.Id+'','Site');
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
  //lstChemoTherapyWrapper
  
  public void executeChemoTherapyRule() {
    system.debug('chemoTreatmentWrapper.lstChemoTherapyWrapper : '+chemoTreatmentWrapper.lstChemoTherapyWrapper);
    Set<String> disableList = new Set<String>();
    Set<String> enableList = new Set<String>();
    String index = Apexpages.currentPage().getParameters().get('index');
    if(test.isRunningTest()){
    	index='1';
    }
    String agentName = Apexpages.currentPage().getParameters().get('agentName');
    system.debug('agentName : '+agentName);
    String isAgentChecked = Apexpages.currentPage().getParameters().get('isAgentChecked');
    if(agentName == 'Paclitaxel (Taxol)' && isAgentChecked == 'true') {
      disableList.add('Doxorubicin (Adriamycin)');
      disableList.add('Cyclophosphamide (Cytoxan)');
    } else if(agentName == 'Paclitaxel (Taxol)' && isAgentChecked == 'false') {
      enableList.add('Doxorubicin (Adriamycin)');
      enableList.add('Cyclophosphamide (Cytoxan)');
    } else if(agentName == 'Doxorubicin (Adriamycin)' && isAgentChecked == 'true') {
      disableList.add('Paclitaxel (Taxol)');
      disableList.add('Trastuzumab (Herceptin)');
      disableList.add('Cyclophosphamide (Cytoxan)');
      disableList.add('AMG 386');
      disableList.add('Neratinib');
      disableList.add('ABT-888');
      disableList.add('Carboplatin');
      disableList.add('Ganitumab');
      disableList.add('MK-2206'); 
    } else if(agentName == 'Doxorubicin (Adriamycin)' && isAgentChecked == 'false') {
      enableList.add('Paclitaxel (Taxol)');
      enableList.add('Trastuzumab (Herceptin)');
      enableList.add('Cyclophosphamide (Cytoxan) ');
      enableList.add('AMG 386');
      enableList.add('Neratinib');
      enableList.add('ABT-888');
      enableList.add('Carboplatin');
      enableList.add('Ganitumab');
      enableList.add('MK-2206'); 
    } else if(agentName == 'Neratinib' && isAgentChecked == 'true') {
      disableList.add('Doxorubicin (Adriamycin)');
      disableList.add('ABT-888');
      disableList.add('Carboplatin');
      enableList.add('Neratinib');
    } else if(agentName == 'Neratinib' && isAgentChecked == 'false') {
      enableList.add('Doxorubicin (Adriamycin)');
      enableList.add('ABT-888');
      enableList.add('Carboplatin');
      disableList.add('Neratinib');
    } else if(agentName == 'ABT-888' && isAgentChecked == 'true') {
      disableList.add('Doxorubicin (Adriamycin)');
      disableList.add('Neratinib');
      enableList.add('ABT-888');
    } else if(agentName == 'ABT-888' && isAgentChecked == 'false') {
      enableList.add('Doxorubicin (Adriamycin)');
      enableList.add('Neratinib');
      disableList.add('ABT-888');
    } 
    
    for(ChemoTherapyWrapper ctw : chemoTreatmentWrapper.lstChemoTherapyWrapper) {
      if(disableList.contains(ctw.agentName))
      {
        if(isAgentChecked == 'true'  && ctw.index==Integer.valueof(index )) {
          ctw.isDisabled = false;
        }
        if(isAgentChecked == 'false'  && ctw.index==Integer.valueof(index )) {
          ctw.isAgentChecked = true;
        }
      }
    }
    for(ChemoTherapyWrapper ctw : chemoTreatmentWrapper.lstChemoTherapyWrapper) {
      if(enableList.contains(ctw.agentName))
      {
        if(isAgentChecked == 'false'  && ctw.index==Integer.valueof(index )) {
          ctw.isDisabled = true;
        }
        if(isAgentChecked == 'true'  && ctw.index==Integer.valueof(index )) {
          ctw.isAgentChecked = false;
        }
        //ctw.isAgentChecked = false;
      }
      system.debug('ctw : '+ctw);
    }
    /*for(ChemoTherapyWrapper ctw : chemoTreatmentWrapper.lstChemoTherapyWrapper) {
      
    }*/
    //chemoTreatmentWrapper.chemoTreatment.Did_patient_go_off_study_treatment__c = true;
    system.debug('enableList : '+enableList);
    system.debug('disableList : '+disableList);
  }
  //=======================Edit main CRF After rejecting by DCC============================================================
  
  public Pagereference cloneCRF() {
    openInEditMode = true;
    //String clonedCRFId = CloneBuilder.cloneMe(chemoTreatmentWrapper.chemoTreatment.Id, '0', '');
    chemoTreatmentWrapper.chemoTreatment.Status__c = 'Not Completed';
    try {
        update chemoTreatmentWrapper.chemoTreatment;
    }catch (Exception e) {
        Apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.ERROR, e.getMessage());
        Apexpages.addMessage(msg);
        return null;
    }
    return null;
  }
  
  public Pagereference editCRF() {
    if(isShowEditButton) {
      lstCloneChemo[0].Status__c = 'Not Completed';
      try {
        update lstCloneChemo[0];
        }catch (Exception e) {
            Apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.ERROR, e.getMessage());
            Apexpages.addMessage(msg);
            // Added by Shruti (DE401)
             // Pagereference ref = new Pagereference('/apex/ChemoTreatmentForm?id='+chemoTreatmentId);
                Pagereference ref = new Pagereference('/'+chemoTreatmentId);
            ref.setRedirect(true);
             return ref;
             // Added by Shruti (DE401)
        }
    }
    openInEditMode = false;
    currentTab = 'chemoAdminTab';
    isComplete = true;
    Pagereference ref = new Pagereference('/apex/ChemoTreatmentForm?trialPat='+trialPatientId+'&formId='+clonedCRFId);
    ref.setRedirect(true);
    return ref;
  }
  
  public class ChemoTreatmentWrapper {
    public Chemo_Treatment__c chemoTreatment {get;set;}
    public List<Growth_Factor__c> lstGrowthFactor {get;set;}
    public List<ChemoTherapyWrapper> lstChemoTherapyWrapper {get;set;}
    public List<MedicationWrapper> lstMedicationWrapper {get;set;}
  }
  
  public class ChemoTherapyWrapper {
    
    public Chemo_Therapy_Regimen__c chemoTherapy {get;set;}
    public boolean isAgentChecked {get;set;}
    public String agentName {get;set;}
    public String doseUnit {get;set;}
    public String totalDoseUnit {get;set;}
    public boolean isDisabled {get;set;}
    public boolean isOtherAgent {get;set;}
    public integer index {get;set;}
    public ChemoTherapyWrapper() {
      isOtherAgent = false;
    }
    
  }
  
  public class MedicationWrapper {
    
    public Concomitant_Medication__c concomitantMedication {get;set;}
    public String medicationName {get;set;}
    public String sno {get;set;}
    public boolean isUpdateVisible {get;set;}
    public boolean isReadOnly {get;set;}
    public boolean isOtherMedication {get;set;}
    public MedicationWrapper() {
      concomitantMedication = new Concomitant_Medication__c();
    }
    
  }
  
}