public with sharing class PreEligibilityChecklistPdf{
   
    public PreEligibility_Checklist__c preObj {get; set;}
    string preEligibilityId;
   
    public PreEligibilityChecklistPdf(Apexpages.StandardController std) {
        preEligibilityId = Apexpages.currentPage().getParameters().get('id');
        if(preEligibilityId != null && preEligibilityId != '')
            preObj = [Select p.X30_Days_Investigational_Agents__c, p.Status__c, p.RecordTypeId, p.Reason_for_not_signing_screening_consent__c, p.Phase__c, p.Patient_signed_up_for_I_SPY2_screening__c, p.Patient_is_willing_to_have_core_biospy__c, p.Patient_is_willin_to_have_study_MRI__c, p.Patient_is_eligible_to_be_screened_for_t__c, p.Patient_is_18_years_or_older__c, p.Patient__c, p.Other_investigational_agents__c, p.Not_had_prior_RT__c, p.Non_Pregnant_Not_Lactating__c, p.Name, p.Histologically_confirmed_invasive_cancer__c, p.Had_prior_cytotoxic_regimens_anticancer__c, p.Ferromegnatic_Prostheses__c, p.ECOG_Score__c, p.Cytotoxic_Regiments__c, p.CreatedDate, p.CreatedById, p.CompletedDate__c, p.Clinically_radiologically_measurable__c, p.CRF_Id__c From PreEligibility_Checklist__c p where id = : preEligibilityId];
            
    }
     
}