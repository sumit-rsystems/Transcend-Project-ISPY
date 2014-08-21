/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the 
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are 
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest(SeeAllData=true)
private class TestSnomedCTCode {

    @isTest static void myUnitTest() {
        // TO DO: implement unit test
        
        SnomedCTCode sno = new SnomedCTCode();
        
        SnomedCTCode.SnomedCode('test inst','Her2TargetPrint_OS');
        
        SnomedCTCode.SnomedCode('test','Her2TargetPrint_OS');
        
        SnomedCTCode.SnomedCode('test','Her2TargetPrint_OS');
        
        SnomedCTCode.SnomedCode('test','Her2TargetPrint_OS');
        
        SnomedCTCode.SnomedCode('test','Her2TargetPrint_OS');
        
        SnomedCTCode.SnomedCode('test','Her2TargetPrint_OS');
        
        SnomedCTCode.SnomedCode('test','Her2TargetPrint_OS');
        
        SnomedCTCode.SnomedCode('1','Her2TargetPrint_OS');
        
        SnomedCTCode.SnomedCode('1','Her2TargetPrint_OS');
        
        SnomedCTCode.SnomedCode('1','Her2TargetPrint_OS');
        
        SnomedCTCode.SnomedCode('White','Her2TargetPrint_OS'); 
        SnomedCTCode.SnomedCode('Black or African American','Her2TargetPrint_OS');
        SnomedCTCode.SnomedCode('Asian','Her2TargetPrint_OS');
        SnomedCTCode.SnomedCode('American Indian or Alaska Native','Her2TargetPrint_OS'); 
        SnomedCTCode.SnomedCode('','Her2TargetPrint_OS'); 
        
        SnomedCTCode.SnomedCode('White, Black or African American, Asian, Native Hawaiian or Pacific Islander, American Indian or Alaska Native','Her2TargetPrint_OS'); 
        
        SnomedCTCode.SnomedCode('Hispanic or Latino','Her2TargetPrint_OS');
        SnomedCTCode.SnomedCode('Not Hispanic or Latino','Her2TargetPrint_OS');
        
        SnomedCTCode.SnomedCode('1','Her2TargetPrint_OS');
        
        SnomedCTCode.SnomedCode('Alive','Her2TargetPrint_OS');
        SnomedCTCode.SnomedCode('Dead','Her2TargetPrint_OS');
        SnomedCTCode.SnomedCode('Lost to Follow-up','Her2TargetPrint_OS');
        SnomedCTCode.SnomedCode('Consent for follow-up withdrawn','Her2TargetPrint_OS');
        
        SnomedCTCode.SnomedCode('Alive','Her2TargetPrint_OS');
        SnomedCTCode.SnomedCode('Dead','Her2TargetPrint_OS');
        SnomedCTCode.SnomedCode('Lost to Follow-up','Her2TargetPrint_OS');
        SnomedCTCode.SnomedCode('Consent for follow-up withdrawn','Her2TargetPrint_OS');
        
        SnomedCTCode.SnomedCode('','Her2TargetPrint_OS');
        SnomedCTCode.SnomedCode('','Her2TargetPrint_OS'); 
        
        SnomedCTCode.SnomedCode('Premenopausal(<6 months since LMP AND no prior bilateral ovariectomy AND not on estrogen replacement)','Her2TargetPrint_OS');
        SnomedCTCode.SnomedCode('Postmenopausal (prior bilateral ovariectomy OR > 12 months since LMP with no prior hysterectomy)','Her2TargetPrint_OS');
        SnomedCTCode.SnomedCode('Premenopausal(6-12 months since LMP AND no prior bilateral ovariectomy AND not on estrogen replacement)','Her2TargetPrint_OS');
        SnomedCTCode.SnomedCode('','Her2TargetPrint_OS');
        
        SnomedCTCode.SnomedCode('Self exam','Her2TargetPrint_OS');
        SnomedCTCode.SnomedCode('Clinical exam','Her2TargetPrint_OS');
        SnomedCTCode.SnomedCode('Screening mammogram','Her2TargetPrint_OS');
        SnomedCTCode.SnomedCode('Unknown','Her2TargetPrint_OS');
        SnomedCTCode.SnomedCode('Screening MRI','Her2TargetPrint_OS');
        SnomedCTCode.SnomedCode('Other','Her2TargetPrint_OS');
        
        SnomedCTCode.SnomedCode('','Her2TargetPrint_OS');
        SnomedCTCode.SnomedCode('800','Her2TargetPrint_OS');
        SnomedCTCode.SnomedCode('700','Her2TargetPrint_OS');
        
        SnomedCTCode.SnomedCode('No','Her2TargetPrint_OS');
        SnomedCTCode.SnomedCode('Yes','Her2TargetPrint_OS');
        SnomedCTCode.SnomedCode('Negative','Her2TargetPrint_OS');
        SnomedCTCode.SnomedCode('Positive','Her2TargetPrint_OS');
        
        SnomedCTCode.SnomedCode('Necrosis','Her2TargetPrint_OS');
        SnomedCTCode.SnomedCode('Ductal','Her2TargetPrint_OS');
        SnomedCTCode.SnomedCode('Lobular classic','Her2TargetPrint_OS');
        SnomedCTCode.SnomedCode('Lobular alveolar','Her2TargetPrint_OS');
        SnomedCTCode.SnomedCode('pleomorphic lobular','Her2TargetPrint_OS');
        SnomedCTCode.SnomedCode('tubulolobular','Her2TargetPrint_OS');
        SnomedCTCode.SnomedCode('Mixed Ductal and Lobular','Her2TargetPrint_OS');
        SnomedCTCode.SnomedCode('Tubular','Her2TargetPrint_OS');
        SnomedCTCode.SnomedCode('Mucinous','Her2TargetPrint_OS');
        SnomedCTCode.SnomedCode('Medullary','Her2TargetPrint_OS');
        SnomedCTCode.SnomedCode('papillary','Her2TargetPrint_OS');
        SnomedCTCode.SnomedCode('cribiform','Her2TargetPrint_OS');
        SnomedCTCode.SnomedCode('Other','Her2TargetPrint_OS');
        
        SnomedCTCode.SnomedCode('Necrosis,Ductal,Lobular classic,Lobular alveolar,pleomorphic lobular,tubulolobular,Mixed Ductal and Lobular,Tubular,Mucinous,Medullary,papillary,cribiform,Other','Her2TargetPrint_OS');
        
        SnomedCTCode.SnomedCode('Grade I (low)','Her2TargetPrint_OS');
        SnomedCTCode.SnomedCode('Grade II (intermediate)','Her2TargetPrint_OS');
        SnomedCTCode.SnomedCode('Grade III (high)','Her2TargetPrint_OS');
        SnomedCTCode.SnomedCode('Indeterminate','Her2TargetPrint_OS');  
        
        SnomedCTCode.SnomedCode('Negative','Her2TargetPrint_OS');
        SnomedCTCode.SnomedCode('Positive','Her2TargetPrint_OS');
        SnomedCTCode.SnomedCode('Indeterminate','Her2TargetPrint_OS');
        
        SnomedCTCode.SnomedCode('Negative','Her2TargetPrint_OS');
        SnomedCTCode.SnomedCode('Positive','Her2TargetPrint_OS');
        SnomedCTCode.SnomedCode('Indeterminate','Her2TargetPrint_OS');
        
        SnomedCTCode.SnomedCode('Negative','Her2TargetPrint_OS');
        SnomedCTCode.SnomedCode('Positive','Her2TargetPrint_OS');
        SnomedCTCode.SnomedCode('Indeterminate','Her2TargetPrint_OS');
        SnomedCTCode.SnomedCode('Not Reported','Her2TargetPrint_OS');
        
        SnomedCTCode.SnomedCode('Negative','Her2TargetPrint_OS');
        SnomedCTCode.SnomedCode('Positive','Her2TargetPrint_OS');
        SnomedCTCode.SnomedCode('Undetermined status','Her2TargetPrint_OS');
        SnomedCTCode.SnomedCode('Not Done','Her2TargetPrint_OS');
        
        SnomedCTCode.SnomedCode('Low risk','Her2TargetPrint_OS');
        SnomedCTCode.SnomedCode('High Risk','Her2TargetPrint_OS');
        SnomedCTCode.SnomedCode('Quantity not sufficient','Her2TargetPrint_OS');
        SnomedCTCode.SnomedCode('Quality not sufficient','Her2TargetPrint_OS');
        
        SnomedCTCode.SnomedCode('Yes','Her2TargetPrint_OS');
        
        SnomedCTCode.SnomedCode('Surgery','Her2TargetPrint_OS');
        SnomedCTCode.SnomedCode('Chemotherapy','Her2TargetPrint_OS');
        SnomedCTCode.SnomedCode('Radiation','Her2TargetPrint_OS');
        SnomedCTCode.SnomedCode('Hormone','Her2TargetPrint_OS');  
        
        SnomedCTCode.SnomedCode('Early Treatment','Her2TargetPrint_OS');
        SnomedCTCode.SnomedCode('Inter-Regimen','Her2TargetPrint_OS');
        SnomedCTCode.SnomedCode('Pre-Surgery','Her2TargetPrint_OS');
        
        SnomedCTCode.SnomedCode('Early Treatment','Her2TargetPrint_OS');
        SnomedCTCode.SnomedCode('Inter-Regimen','Her2TargetPrint_OS');
        SnomedCTCode.SnomedCode('Pre-Surgery','Her2TargetPrint_OS');
        
        SnomedCTCode.SnomedCode('Pre-Surgery','Her2TargetPrint_OS');
        
        SnomedCTCode.SnomedCode('Pre-Surgery','Her2TargetPrint_OS');
        
        SnomedCTCode.SnomedCode('Pre-Surgery','Her2TargetPrint_OS');
        
        SnomedCTCode.SnomedCode('Stage 0','Her2TargetPrint_OS');
        SnomedCTCode.SnomedCode('Stage I','Her2TargetPrint_OS');
        SnomedCTCode.SnomedCode('Stage IIA','Her2TargetPrint_OS');
        SnomedCTCode.SnomedCode('Stage IIB','Her2TargetPrint_OS');
        SnomedCTCode.SnomedCode('Stage IIIA','Her2TargetPrint_OS');
        SnomedCTCode.SnomedCode('Stage IIIB','Her2TargetPrint_OS');
        SnomedCTCode.SnomedCode('Stage IIIC','Her2TargetPrint_OS');
        SnomedCTCode.SnomedCode('Stage IV','Her2TargetPrint_OS');
        SnomedCTCode.SnomedCode('Inflammatory','Her2TargetPrint_OS');
        
        SnomedCTCode.SnomedCode('Not Reported','Her2TargetPrint_OS');
        
        SnomedCTCode.SnomedCode('Complete Response (CR)','Her2TargetPrint_OS');
        SnomedCTCode.SnomedCode('Partial Response (PR)','Her2TargetPrint_OS');
        SnomedCTCode.SnomedCode('Stable Disease (SD)','Her2TargetPrint_OS');
        SnomedCTCode.SnomedCode('Progressive Disease (PD)','Her2TargetPrint_OS');
        
        SnomedCTCode.SnomedCode('Skin only','Her2TargetPrint_OS');
        SnomedCTCode.SnomedCode('Chest wall','Her2TargetPrint_OS');
        SnomedCTCode.SnomedCode('Skin and chest wall','Her2TargetPrint_OS');
        SnomedCTCode.SnomedCode('Inflammatory','Her2TargetPrint_OS');
        SnomedCTCode.SnomedCode('No Skin involvement','Her2TargetPrint_OS');
        
        SnomedCTCode.SnomedCode('Skin only','Her2TargetPrint_OS');
        SnomedCTCode.SnomedCode('Chest Wall Only','Her2TargetPrint_OS');
        SnomedCTCode.SnomedCode('Skin and chest wall','Her2TargetPrint_OS');
        SnomedCTCode.SnomedCode('Inflammatory','Her2TargetPrint_OS');
        SnomedCTCode.SnomedCode('No Skin involvement','Her2TargetPrint_OS');
        
        SnomedCTCode.SnomedCode('Skin only','Her2TargetPrint_OS');
        SnomedCTCode.SnomedCode('Chest Wall Only','Her2TargetPrint_OS');
        SnomedCTCode.SnomedCode('Skin and chest wall','Her2TargetPrint_OS');
        SnomedCTCode.SnomedCode('Inflammatory','Her2TargetPrint_OS');
        SnomedCTCode.SnomedCode('No Skin involvement','Her2TargetPrint_OS');
        
        SnomedCTCode.SnomedCode('Skin only','Her2TargetPrint_OS');
        SnomedCTCode.SnomedCode('Chest Wall Only','Her2TargetPrint_OS');
        SnomedCTCode.SnomedCode('Skin and chest wall','Her2TargetPrint_OS');
        SnomedCTCode.SnomedCode('Inflammatory','Her2TargetPrint_OS');
        SnomedCTCode.SnomedCode('No Skin involvement','Her2TargetPrint_OS');
        
        SnomedCTCode.SnomedCode('No','Her2TargetPrint_OS');
        SnomedCTCode.SnomedCode('Yes, completed protocol','Her2TargetPrint_OS');
        SnomedCTCode.SnomedCode('Yes, did not want to complete MRI','Her2TargetPrint_OS');
        SnomedCTCode.SnomedCode('Yes, did not want to complete study core biopsy','Her2TargetPrint_OS');
        SnomedCTCode.SnomedCode('Yes, did not continue treatment','Her2TargetPrint_OS');
        SnomedCTCode.SnomedCode('Yes, due to (S)AE','Her2TargetPrint_OS');
        SnomedCTCode.SnomedCode('Yes, due to Personal preference','Her2TargetPrint_OS');
        SnomedCTCode.SnomedCode('Yes, due to Other reason','Her2TargetPrint_OS');
        SnomedCTCode.SnomedCode('Yes, patient did not have surgery','Her2TargetPrint_OS');
        SnomedCTCode.SnomedCode('Yes, patient died','Her2TargetPrint_OS');
        
        SnomedCTCode.SnomedCode('No','Her2TargetPrint_OS');
        SnomedCTCode.SnomedCode('Yes','Her2TargetPrint_OS');
        
        SnomedCTCode.SnomedCode('Stage 0','Her2TargetPrint_OS');
        SnomedCTCode.SnomedCode('Stage IIA','Her2TargetPrint_OS');
        SnomedCTCode.SnomedCode('Stage IIB','Her2TargetPrint_OS');
        SnomedCTCode.SnomedCode('Stage IIIA','Her2TargetPrint_OS');
        SnomedCTCode.SnomedCode('Stage IIIB','Her2TargetPrint_OS');
        SnomedCTCode.SnomedCode('Stage IIIC','Her2TargetPrint_OS');
        SnomedCTCode.SnomedCode('Stage IV','Her2TargetPrint_OS');   
        
        SnomedCTCode.SnomedCode('H1','Her2TargetPrint_OS'); 
        SnomedCTCode.SnomedCode('H2','Her2TargetPrint_OS');
        SnomedCTCode.SnomedCode('Undetermined','Her2TargetPrint_OS');
        
        SnomedCTCode.SnomedCode('No','Her2TargetPrint_OS'); 
        SnomedCTCode.SnomedCode('Yes','Her2TargetPrint_OS');  
        
        SnomedCTCode.SnomedCode('No','Her2TargetPrint_OS'); 
        SnomedCTCode.SnomedCode('Yes','Her2TargetPrint_OS');
        
        SnomedCTCode.SnomedCode('Ultrasound','Her2FISHstatus_OS');  
        SnomedCTCode.SnomedCode('MRI','Her2FISHstatus_OS');
        SnomedCTCode.SnomedCode('Stereotactic','Her2FISHstatus_OS'); 
        SnomedCTCode.SnomedCode('Mammography','Her2FISHstatus_OS');
        SnomedCTCode.SnomedCode('Palpation','Her2FISHstatus_OS');
        
        SnomedCTCode.SnomedCode('No','Her2FISHstatus_OS'); 
        SnomedCTCode.SnomedCode('Yes','Her2FISHstatus_OS'); 
        
        SnomedCTCode.SnomedCode('No','Her2FISHstatus_OS');
        SnomedCTCode.SnomedCode('Yes','Her2FISHstatus_OS'); 
        
        SnomedCTCode.SnomedCode('No','Her2FISHstatus_OS');
        SnomedCTCode.SnomedCode('Yes','Her2FISHstatus_OS');
        
        SnomedCTCode.SnomedCode('Not given','Her2FISHstatus_OS'); 
        SnomedCTCode.SnomedCode('Pegfilgrastim (Neulasta)','Her2FISHstatus_OS'); 
        SnomedCTCode.SnomedCode('Filgrastin (Neupogen)','Her2FISHstatus_OS');
        
        SnomedCTCode.SnomedCode('No','Her2FISHstatus_OS');
        SnomedCTCode.SnomedCode('Yes','Her2FISHstatus_OS');
        
        SnomedCTCode.SnomedCode('No','Her2FISHstatus_OS');
        SnomedCTCode.SnomedCode('yes','Her2FISHstatus_OS');  
        
        SnomedCTCode.SnomedCode('Not done','Her2FISHstatus_OS'); 
        SnomedCTCode.SnomedCode('Negative','Her2FISHstatus_OS'); 
        SnomedCTCode.SnomedCode('Positive','Her2FISHstatus_OS'); 
        
        SnomedCTCode.SnomedCode('Not done','Her2FISHstatus_OS'); 
        SnomedCTCode.SnomedCode('Negative','Her2FISHstatus_OS'); 
        SnomedCTCode.SnomedCode('Positive','Her2FISHstatus_OS');  
        
        SnomedCTCode.SnomedCode('Not done','Her2FISHstatus_OS'); 
        SnomedCTCode.SnomedCode('Negative','Her2FISHstatus_OS'); 
        SnomedCTCode.SnomedCode('Positive','Her2FISHstatus_OS');
        
        SnomedCTCode.SnomedCode('Not done','Her2FISHstatus_OS');   
        SnomedCTCode.SnomedCode('Negative','Her2FISHstatus_OS'); 
        SnomedCTCode.SnomedCode('Positive','Her2FISHstatus_OS');
        
        SnomedCTCode.SnomedCode('No','Her2FISHstatus_OS'); 
        SnomedCTCode.SnomedCode('Yes','Her2FISHstatus_OS'); 
        
        SnomedCTCode.SnomedCode('Left','Her2FISHstatus_OS'); 
        SnomedCTCode.SnomedCode('Right','Her2FISHstatus_OS');  
        
        SnomedCTCode.SnomedCode('Yes','Her2FISHstatus_OS'); 
        SnomedCTCode.SnomedCode('No,  multicentric disease','Her2FISHstatus_OS'); 
        SnomedCTCode.SnomedCode('No, inflammatory disease','Her2FISHstatus_OS'); 
        SnomedCTCode.SnomedCode('No, difuse microcalcifications','Her2FISHstatus_OS');
        SnomedCTCode.SnomedCode('institutional norm','Her2FISHstatus_OS');
        SnomedCTCode.SnomedCode('No, specific anatomy of primary','Her2FISHstatus_OS');
        SnomedCTCode.SnomedCode('No, other','Her2FISHstatus_OS'); 
        
        SnomedCTCode.SnomedCode('Yes','Her2FISHstatus_OS');
        SnomedCTCode.SnomedCode('Yes, did not consent to Tx','Her2FISHstatus_OS');
        SnomedCTCode.SnomedCode('Patient found to be ineligible because they are MammaPrint Low, ER Positive, HER2 Negative','Her2FISHstatus_OS');
        SnomedCTCode.SnomedCode('No, ineligible due to other criteria','Her2FISHstatus_OS');
        SnomedCTCode.SnomedCode('Patient found to be ineligible because patient could not complete MRI','Her2FISHstatus_OS');
        SnomedCTCode.SnomedCode('Patient found to be ineligible because patient could not complete core biopsy','Her2FISHstatus_OS');
        SnomedCTCode.SnomedCode('Decided not to have neoadjuvant chemotherapy','Her2FISHstatus_OS');
        SnomedCTCode.SnomedCode('No, decided NOT to sign','Her2FISHstatus_OS');
        SnomedCTCode.SnomedCode('Other','Her2FISHstatus_OS');
        
        SnomedCTCode.SnomedCode('Paclitaxel + Anthracycline/Cytoxan','Her2FISHstatus_OS');
        SnomedCTCode.SnomedCode('Paclitaxel/Herceptin + Anthracycline/Cytoxan','Her2FISHstatus_OS');
        SnomedCTCode.SnomedCode('Paclitaxel/Investigational Agent + Anthracycline/Cytoxan','Her2FISHstatus_OS');
        SnomedCTCode.SnomedCode('Paclitaxel/Herceptin/Investigational Agent + Anthracycline/Cytoxan','Her2FISHstatus_OS');
        
        SnomedCTCode.SnomedCode('Not given','Her2FISHstatus_OS');
        SnomedCTCode.SnomedCode('Pegfilgrastim (Neulasta)','Her2FISHstatus_OS');
        SnomedCTCode.SnomedCode('Filgrastin (Neupogen)','Her2FISHstatus_OS');
        
        SnomedCTCode.SnomedCode('No','Her2FISHstatus_OS');
        SnomedCTCode.SnomedCode('Yes','Her2FISHstatus_OS');
        
        SnomedCTCode.SnomedCode('No','Her2FISHstatus_OS'); 
        SnomedCTCode.SnomedCode('Yes','Her2FISHstatus_OS');
         
        SnomedCTCode.SnomedCode('No','Her2FISHstatus_OS'); 
        SnomedCTCode.SnomedCode('Yes','Her2FISHstatus_OS'); 
        
        SnomedCTCode.SnomedCode('Yes','Her2FISHstatus_OS'); 
        SnomedCTCode.SnomedCode('Delayed surgery (>8 weeks)','Her2FISHstatus_OS');
        SnomedCTCode.SnomedCode('No, Disease Progression','Her2FISHstatus_OS'); 
        SnomedCTCode.SnomedCode('No, Adverse Event','Her2FISHstatus_OS');
        SnomedCTCode.SnomedCode('No, Patient Refusal','Her2FISHstatus_OS'); 
        SnomedCTCode.SnomedCode('No, Other Reason','Her2FISHstatus_OS'); 
        
        SnomedCTCode.SnomedCode('Necrosis','Her2FISHstatus_OS'); 
        SnomedCTCode.SnomedCode('Ductal Carcinoma','Her2FISHstatus_OS');
        SnomedCTCode.SnomedCode('Lobular','Her2FISHstatus_OS'); 
        SnomedCTCode.SnomedCode('Mixed Ductal/Lobular carcinoma','Her2FISHstatus_OS'); 
        SnomedCTCode.SnomedCode('Other','Her2FISHstatus_OS'); 
        SnomedCTCode.SnomedCode('No residual invasive breast cancer','Her2FISHstatus_OS');  
        
        SnomedCTCode.SnomedCode('Grade I (low)','Her2FISHstatus_OS'); 
        SnomedCTCode.SnomedCode('Grade II (intermediate)','Her2FISHstatus_OS'); 
        SnomedCTCode.SnomedCode('Grade III (high)','Her2FISHstatus_OS'); 
        SnomedCTCode.SnomedCode('Indeterminate','Her2FISHstatus_OS'); 
        SnomedCTCode.SnomedCode('No residual invasive breast cancer','Her2FISHstatus_OS'); 
        
        SnomedCTCode.SnomedCode('Negative','Her2FISHstatus_OS');  
        SnomedCTCode.SnomedCode('Positive','Her2FISHstatus_OS'); 
        SnomedCTCode.SnomedCode('Indeterminate','Her2FISHstatus_OS'); 
        
        SnomedCTCode.SnomedCode('Negative','Her2FISHstatus_OS');  
        SnomedCTCode.SnomedCode('Positive','Her2FISHstatus_OS'); 
        SnomedCTCode.SnomedCode('Indeterminate','Her2FISHstatus_OS'); 
        
        SnomedCTCode.SnomedCode('Negative','Her2FISHstatus_OS');  
        SnomedCTCode.SnomedCode('Positive','Her2FISHstatus_OS'); 
        SnomedCTCode.SnomedCode('Indeterminate','Her2FISHstatus_OS'); 
        
        SnomedCTCode.SnomedCode('Negative','Her2FISHstatus_OS');   
        SnomedCTCode.SnomedCode('Positive','Her2FISHstatus_OS'); 
        SnomedCTCode.SnomedCode('Not Done','Her2FISHstatus_OS'); 
        
        SnomedCTCode.SnomedCode('No axillary','Her2FISHstatus_OS');  
        SnomedCTCode.SnomedCode('','Her2FISHstatus_OS');
        
        SnomedCTCode.SnomedCode('','Her2FISHstatus_OS');  
        SnomedCTCode.SnomedCode('','Her2FISHstatus_OS');
        SnomedCTCode.SnomedCode('Stage IIA','Her2FISHstatus_OS');  
        SnomedCTCode.SnomedCode('Stage IIB','Her2FISHstatus_OS');
        SnomedCTCode.SnomedCode('Stage IIIA','Her2FISHstatus_OS');  
        SnomedCTCode.SnomedCode('Stage IIIB','Her2FISHstatus_OS');
        SnomedCTCode.SnomedCode('Stage IIIC','Her2FISHstatus_OS');  
        SnomedCTCode.SnomedCode('Stage IV','Her2FISHstatus_OS');
        
        SnomedCTCode.SnomedCode('Multi-centric disease','Her2FISHstatus_OS'); 
        SnomedCTCode.SnomedCode('Inflammatory disease','Her2FISHstatus_OS');
        SnomedCTCode.SnomedCode('Diffuse micro calcifications','Her2FISHstatus_OS'); 
        SnomedCTCode.SnomedCode('Patient choice/family history','Her2FISHstatus_OS');
        SnomedCTCode.SnomedCode('Institutional norm','Her2FISHstatus_OS'); 
        SnomedCTCode.SnomedCode('Specific anatomy of primary','Her2FISHstatus_OS');
        SnomedCTCode.SnomedCode('Other','Her2FISHstatus_OS'); 
        SnomedCTCode.SnomedCode('Multiple reasons','Her2FISHstatus_OS');
        
        SnomedCTCode.SnomedCode('Yes','Her2FISHstatus_OS'); 
        SnomedCTCode.SnomedCode('No','Her2FISHstatus_OS');
        SnomedCTCode.SnomedCode('No Surgery','Her2FISHstatus_OS'); 
        SnomedCTCode.SnomedCode('Not reported','Her2FISHstatus_OS');
        
        SnomedCTCode.SnomedCode('DCIS','Her2FISHstatus_OS'); 
        SnomedCTCode.SnomedCode('LCIS','Her2FISHstatus_OS');
        SnomedCTCode.SnomedCode('No Surgery','Her2FISHstatus_OS'); 

        SnomedCTCode.SnomedCode('Punctuate Necrosis','Her2FISHstatus_OS'); 
        SnomedCTCode.SnomedCode('Comedo Necrosis','Her2FISHstatus_OS');
        SnomedCTCode.SnomedCode('Papillary','Her2FISHstatus_OS'); 
        SnomedCTCode.SnomedCode('Micropapillary','Her2FISHstatus_OS');
        SnomedCTCode.SnomedCode('Necrosis','Her2FISHstatus_OS'); 
        SnomedCTCode.SnomedCode('Cribiform','Her2FISHstatus_OS');
        SnomedCTCode.SnomedCode('Cruciform','Her2FISHstatus_OS'); 
        SnomedCTCode.SnomedCode('Clinging','Her2FISHstatus_OS');
        SnomedCTCode.SnomedCode('Solid','Her2FISHstatus_OS');
        SnomedCTCode.SnomedCode('Apocrine','Her2FISHstatus_OS'); 
        SnomedCTCode.SnomedCode('Intracystic (encysted papillary)','Her2FISHstatus_OS'); 
        SnomedCTCode.SnomedCode('Other','Her2FISHstatus_OS');

        SnomedCTCode.SnomedCode('N/A','Her2FISHstatus_OS'); 
        SnomedCTCode.SnomedCode('classic','Her2FISHstatus_OS');
        SnomedCTCode.SnomedCode('small cell','Her2FISHstatus_OS'); 
        SnomedCTCode.SnomedCode('large cell','Her2FISHstatus_OS');
        SnomedCTCode.SnomedCode('pleomorphic','Her2FISHstatus_OS'); 
        SnomedCTCode.SnomedCode('unknown','Her2FISHstatus_OS');
        
        SnomedCTCode.SnomedCode('Negative for invasive and in situ disease (DCIS and LCIS)','Her2FISHstatus_OS');
        SnomedCTCode.SnomedCode('Positive for invasive disease, completion of mastectomy was performed, additional invasive disease was found','Her2FISHstatus_OS');
        SnomedCTCode.SnomedCode('Positive for invasive disease, re-excision was performed, additional invasive disease was found','Her2FISHstatus_OS');
        SnomedCTCode.SnomedCode('Positive for invasive disease, re-excision was performed, no additional invasive or in situ disease was found','Her2FISHstatus_OS');
        SnomedCTCode.SnomedCode('Positive for invasive disease, re-excision was not performed, patient had radiation instead','Her2FISHstatus_OS');
        SnomedCTCode.SnomedCode('Positive for in situ disease, re-excision was performed, no additional in situ or invasive disease was found','Her2FISHstatus_OS');
        SnomedCTCode.SnomedCode('No Surgery','Her2FISHstatus_OS');
        
        SnomedCTCode.SnomedCode('TX','Her2FISHstatus_OS');
        SnomedCTCode.SnomedCode('T0','Her2FISHstatus_OS');
        SnomedCTCode.SnomedCode('Tis','Her2FISHstatus_OS');
        SnomedCTCode.SnomedCode('T1','Her2FISHstatus_OS');
        SnomedCTCode.SnomedCode('T2','Her2FISHstatus_OS');
        SnomedCTCode.SnomedCode('T3','Her2FISHstatus_OS');
        SnomedCTCode.SnomedCode('T4','Her2FISHstatus_OS');
        SnomedCTCode.SnomedCode('T4-Inflammatory','Her2FISHstatus_OS');
        SnomedCTCode.SnomedCode('T4-Skin','Her2FISHstatus_OS');
        SnomedCTCode.SnomedCode('T4-Inflammatory, skin, chest wall','Her2FISHstatus_OS');
        SnomedCTCode.SnomedCode('No Surgery','Her2FISHstatus_OS');
        
        SnomedCTCode.SnomedCode( 'NX','Her2FISHstatus_OS');
        SnomedCTCode.SnomedCode( 'N0','Her2FISHstatus_OS');
        SnomedCTCode.SnomedCode( 'N1','Her2FISHstatus_OS');
        SnomedCTCode.SnomedCode( 'N2','Her2FISHstatus_OS');
        SnomedCTCode.SnomedCode( 'No Surgery','Her2FISHstatus_OS');
        
        SnomedCTCode.SnomedCode('MX','Her2FISHstatus_OS');
        SnomedCTCode.SnomedCode('M0','Her2FISHstatus_OS');
        SnomedCTCode.SnomedCode('M1','Her2FISHstatus_OS');
        SnomedCTCode.SnomedCode('No Surgery','Her2FISHstatus_OS');
        
        SnomedCTCode.SnomedCode('','Her2FISHstatus_OS');
        SnomedCTCode.SnomedCode('','Her2FISHstatus_OS');
        
        SnomedCTCode.SnomedCode('0','Her2FISHstatus_OS');
        SnomedCTCode.SnomedCode('II','Her2FISHstatus_OS');
        SnomedCTCode.SnomedCode('III','Her2FISHstatus_OS');
        
        SnomedCTCode.SnomedCode('No Surgery','Her2FISHstatus_OS');
        
        SnomedCTCode.SnomedCode('N/A','Her2FISHstatus_OS');
        SnomedCTCode.SnomedCode('','Her2FISHstatus_OS'); 
        
        SnomedCTCode.SnomedCode('N/A','Her2FISHstatus_OS'); 
        SnomedCTCode.SnomedCode('Indeterminate','Her2FISHstatus_OS');
        
        SnomedCTCode.SnomedCode('No','Her2FISHstatus_OS');
        SnomedCTCode.SnomedCode('Yes','Her2FISHstatus_OS');
        
        SnomedCTCode.SnomedCode('No','Her2FISHstatus_OS');
        SnomedCTCode.SnomedCode('Yes','Her2FISHstatus_OS');
        
        SnomedCTCode.SnomedCode('No','Her2FISHstatus_OS');
        SnomedCTCode.SnomedCode('Yes','Her2FISHstatus_OS');
        
        SnomedCTCode.SnomedCode('No','Her2FISHstatus_OS');
        SnomedCTCode.SnomedCode('Yes','Her2FISHstatus_OS');
        
        SnomedCTCode.SnomedCode('No','Her2FISHstatus_OS');
        SnomedCTCode.SnomedCode('Yes','Her2FISHstatus_OS');
        
        SnomedCTCode.SnomedCode('No','Her2FISHstatus_OS');
        
        SnomedCTCode.SnomedCode('No','Her2FISHstatus_OS');
        
        SnomedCTCode.SnomedCode('No','Her2FISHstatus_OS');
        SnomedCTCode.SnomedCode('Yes','Her2FISHstatus_OS');
        
        SnomedCTCode.SnomedCode('No','Her2FISHstatus_OS');
        SnomedCTCode.SnomedCode('Yes','Her2FISHstatus_OS');
        
        SnomedCTCode.SnomedCode('No','Her2FISHstatus_OS');
        SnomedCTCode.SnomedCode('Yes','Her2FISHstatus_OS');
        
        SnomedCTCode.SnomedCode('No','Her2FISHstatus_OS');
        SnomedCTCode.SnomedCode('Yes','Her2FISHstatus_OS');
        
        SnomedCTCode.SnomedCode('No','Her2FISHstatus_OS');
        SnomedCTCode.SnomedCode('Yes','Her2FISHstatus_OS');
        
        SnomedCTCode.SnomedCode('No','Her2FISHstatus_OS');
        SnomedCTCode.SnomedCode('Yes','Her2FISHstatus_OS');
        
        SnomedCTCode.SnomedCode('Contralateral breast','Her2FISHstatus_OS');
        SnomedCTCode.SnomedCode('Distant lymph nodes','Her2FISHstatus_OS');
        SnomedCTCode.SnomedCode('Pleura','Her2FISHstatus_OS');
        SnomedCTCode.SnomedCode('Liver','Her2FISHstatus_OS');
        SnomedCTCode.SnomedCode('Distant skin and subcutaneous tissue','Her2FISHstatus_OS');
        SnomedCTCode.SnomedCode('Bone','Her2FISHstatus_OS');
        SnomedCTCode.SnomedCode('Bone Marrow','Her2FISHstatus_OS');
        SnomedCTCode.SnomedCode('Brain/CNS','Her2FISHstatus_OS');
        SnomedCTCode.SnomedCode('Other','Her2FISHstatus_OS');
        
        SnomedCTCode.SnomedCode('No','Her2FISHstatus_OS');
        SnomedCTCode.SnomedCode('Yes','Her2FISHstatus_OS');
        
        SnomedCTCode.SnomedCode('Low','Her2FISHstatus_OS'); 
        SnomedCTCode.SnomedCode('Intermediate','Her2FISHstatus_OS');
        SnomedCTCode.SnomedCode('High','Her2FISHstatus_OS'); 
        SnomedCTCode.SnomedCode('N/A','Her2FISHstatus_OS');
        SnomedCTCode.SnomedCode('Indeterminate','Her2FISHstatus_OS');
        
        SnomedCTCode.SnomedCode('Present','Her2FISHstatus_OS'); 
        SnomedCTCode.SnomedCode('Absent','Her2FISHstatus_OS');
        
        SnomedCTCode.SnomedCode('Ductal','Her2FISHstatus_OS');
        SnomedCTCode.SnomedCode('Lobular','Her2FISHstatus_OS');
        SnomedCTCode.SnomedCode('Mixed','Her2FISHstatus_OS');
        SnomedCTCode.SnomedCode('Mucinous','Her2FISHstatus_OS');
        SnomedCTCode.SnomedCode('N/A','Her2FISHstatus_OS');
        SnomedCTCode.SnomedCode('No Surgery','Her2FISHstatus_OS');
        
        SnomedCTCode.SnomedCode('Present','Her2FISHstatus_OS');
        SnomedCTCode.SnomedCode('None','Her2FISHstatus_OS');
        SnomedCTCode.SnomedCode('Not reported','Her2FISHstatus_OS');
        SnomedCTCode.SnomedCode('Unavailable','Her2FISHstatus_OS');
        
        SnomedCTCode.SnomedCode('Yes','Her2FISHstatus_OS');
        SnomedCTCode.SnomedCode('No','Her2FISHstatus_OS');
        SnomedCTCode.SnomedCode('N/A','Her2FISHstatus_OS');
        SnomedCTCode.SnomedCode('Unavailable','Her2FISHstatus_OS');
        
        SnomedCTCode.SnomedCode('N/A','Her2FISHstatus_OS');
        SnomedCTCode.SnomedCode('Indeterminate','Her2FISHstatus_OS'); 
        SnomedCTCode.SnomedCode('Numerical value','Her2FISHstatus_OS');

        
    }
    @isTest static void myUnitTest1() { // method "insertSnomedCodesForResponseEvaluation"
        // TO DO: implement unit test
        
        Code_Master__c snomedObject = new Code_Master__c();
        snomedObject.Variable_Description__c = 'test';
        snomedObject.IsReportColumn__c = true;
        snomedObject.Display_Order__c = 3.0;
        snomedObject.Name = 'Breast Conserv';
        insert snomedObject;
        
        Codes__c codeObj = new Codes__c();
        codeObj.Code_Master__c = snomedObject.Id;
        codeObj.Code_System_Version__c = '123';
        codeObj.Code_Type__c = 'SNOMED CT';
        codeObj.Code__c = '27113001 | body weight | ';
        codeObj.Value__c = 'white';
        insert codeObj;
        
        Code_Master__c snomedObject1 = new Code_Master__c();
        snomedObject1.Variable_Description__c = 'test';
        snomedObject1.IsReportColumn__c = true;
        snomedObject1.Display_Order__c = 3.0;
        snomedObject1.Name = 'InflamCa_OS';
        insert snomedObject1;
        
        Codes__c codeObj1 = new Codes__c();
        codeObj1.Code_Master__c = snomedObject1.Id;
        codeObj1.Code_System_Version__c = '123';
        codeObj1.Code_Type__c = 'SNOMED CT';
        codeObj1.Code__c = '27113001 | body weight | ';
        codeObj1.Value__c = 'white';
        insert codeObj1;
        
        Code_Master__c snomedObject2 = new Code_Master__c();
        snomedObject2.Variable_Description__c = 'test';
        snomedObject2.IsReportColumn__c = true;
        snomedObject2.Display_Order__c = 3.0;
        snomedObject2.Name = 'cTstage_OS';
        insert snomedObject2;
        
        Codes__c codeObj2 = new Codes__c();
        codeObj2.Code_Master__c = snomedObject2.Id;
        codeObj2.Code_System_Version__c = '123';
        codeObj2.Code_Type__c = 'SNOMED CT';
        codeObj2.Code__c = '27113001 | body weight | ';
        codeObj2.Value__c = 'white';
        insert codeObj2;
        
        Code_Master__c snomedObject3 = new Code_Master__c();
        snomedObject3.Variable_Description__c = 'test';
        snomedObject3.IsReportColumn__c = true;
        snomedObject3.Display_Order__c = 3.0;
        snomedObject3.Name = 'cNstage_OS';
        insert snomedObject3;
        
        Codes__c codeObj3 = new Codes__c();
        codeObj3.Code_Master__c = snomedObject3.Id;
        codeObj3.Code_System_Version__c = '123';
        codeObj3.Code_Type__c = 'SNOMED CT';
        codeObj3.Code__c = '27113001 | body weight | ';
        codeObj3.Value__c = 'white';
        insert codeObj3;
        
        Code_Master__c snomedObject4 = new Code_Master__c();
        snomedObject4.Variable_Description__c = 'test';
        snomedObject4.IsReportColumn__c = true;
        snomedObject4.Display_Order__c = 3.0;
        snomedObject4.Name = 'cStaging_OS';
        insert snomedObject4;
        
        Codes__c codeObj4 = new Codes__c();
        codeObj4.Code_Master__c = snomedObject4.Id;
        codeObj4.Code_System_Version__c = '123';
        codeObj4.Code_Type__c = 'SNOMED CT';
        codeObj4.Code__c = '27113001 | body weight | ';
        codeObj4.Value__c = 'white';
        insert codeObj4;
        
        Code_Master__c snomedObject5 = new Code_Master__c();
        snomedObject5.Variable_Description__c = 'test';
        snomedObject5.IsReportColumn__c = true;
        snomedObject5.Display_Order__c = 3.0;
        snomedObject5.Name = 'BaseDiseaseExt';
        insert snomedObject5;
        
        snomedObject5 = new Code_Master__c();
        snomedObject5.Variable_Description__c = 'test';
        snomedObject5.IsReportColumn__c = true;
        snomedObject5.Display_Order__c = 3.0;
        snomedObject5.Name = 'Incisional_LN_Pretx';
        insert snomedObject5;
        
        snomedObject5 = new Code_Master__c();
        snomedObject5.Variable_Description__c = 'test';
        snomedObject5.IsReportColumn__c = true;
        snomedObject5.Display_Order__c = 3.0;
        snomedObject5.Name = 'InvPathSize1_PS';
        insert snomedObject5;
        
        snomedObject5 = new Code_Master__c();
        snomedObject5.Variable_Description__c = 'test';
        snomedObject5.IsReportColumn__c = true;
        snomedObject5.Display_Order__c = 3.0;
        snomedObject5.Name = 'InvPathSize2_PS';
        insert snomedObject5;
        
        snomedObject5 = new Code_Master__c();
        snomedObject5.Variable_Description__c = 'test';
        snomedObject5.IsReportColumn__c = true;
        snomedObject5.Display_Order__c = 3.0;
        snomedObject5.Name = 'GrossPathSize1_PS';
        insert snomedObject5;
        
        snomedObject5 = new Code_Master__c();
        snomedObject5.Variable_Description__c = 'test';
        snomedObject5.IsReportColumn__c = true;
        snomedObject5.Display_Order__c = 3.0;
        snomedObject5.Name = 'GrossPathSize1_PS';
        insert snomedObject5;
        
        Codes__c codeObj5 = new Codes__c();
        codeObj5.Code_Master__c = snomedObject5.Id;
        codeObj5.Code_System_Version__c = '123';
        codeObj5.Code_Type__c = 'SNOMED CT';
        codeObj5.Code__c = '27113001 | body weight | ';
        codeObj5.Value__c = 'white';
        insert codeObj5;
        
        Code_Master__c snomedObject6 = new Code_Master__c();
        snomedObject6.Variable_Description__c = 'test';
        snomedObject6.IsReportColumn__c = true;
        snomedObject6.Display_Order__c = 3.0;
        snomedObject6.Name = 'BaseNodeExt';
        insert snomedObject6;
        
        Codes__c codeObj6 = new Codes__c();
        codeObj6.Code_Master__c = snomedObject6.Id;
        codeObj6.Code_System_Version__c = '123';
        codeObj6.Code_Type__c = 'SNOMED CT';
        codeObj6.Code__c = '27113001 | body weight | ';
        codeObj6.Value__c = 'white';
        insert codeObj6;
        
        Code_Master__c snomedObject7 = new Code_Master__c();
        snomedObject7.Variable_Description__c = 'test';
        snomedObject7.IsReportColumn__c = true;
        snomedObject7.Display_Order__c = 3.0;
        snomedObject7.Name = 'TSizeClinical';
        insert snomedObject7;
        Codes__c codeObj7 = new Codes__c();
        codeObj7.Code_Master__c = snomedObject7.Id;
        codeObj7.Code_System_Version__c = '123';
        codeObj7.Code_Type__c = 'SNOMED CT';
        codeObj7.Code__c = '27113001 | body weight | ';
        codeObj7.Value__c = '';
        insert codeObj7;
        
        Code_Master__c snomedObject8 = new Code_Master__c();
        snomedObject8.Variable_Description__c = 'test';
        snomedObject8.IsReportColumn__c = true;
        snomedObject8.Display_Order__c = 3.0;
        snomedObject8.Name = 'ReasonNoSurg_PTx';
        insert snomedObject8;
        Codes__c codeObj8 = new Codes__c();
        codeObj8.Code_Master__c = snomedObject8.Id;
        codeObj8.Code_System_Version__c = '123';
        codeObj8.Code_Type__c = 'SNOMED CT';
        codeObj8.Code__c = '27113001 | body weight | ';
        codeObj8.Value__c = 'Multi-centric disease';
        insert codeObj8;
        
        Code_Master__c snomedObject9 = new Code_Master__c();
        snomedObject9.Variable_Description__c = 'test';
        snomedObject9.IsReportColumn__c = true;
        snomedObject9.Display_Order__c = 3.0;
        snomedObject9.Name = 'T4Early';
        insert snomedObject9;
        Codes__c codeObj9 = new Codes__c();
        codeObj9.Code_Master__c = snomedObject8.Id;
        codeObj9.Code_System_Version__c = '123';
        codeObj9.Code_Type__c = 'SNOMED CT';
        codeObj9.Code__c = '27113001 | body weight | ';
        codeObj9.Value__c = 'Inflammatory';
        insert codeObj9;
        
        Code_Master__c snomedObject10 = new Code_Master__c();
        snomedObject10.Variable_Description__c = 'test';
        snomedObject10.IsReportColumn__c = true;
        snomedObject10.Display_Order__c = 3.0;
        snomedObject10.Name = 'ClinRespT1_T3';
        insert snomedObject10;
        
        Response_Evaluation_Form__c refObject = new Response_Evaluation_Form__c();
        refObject.ReasonNotConservationSurgeryCandidate__c = 'Multi-centric disease';
        refObject.Current_status_of_T4_tumor__c  = 'Inflammatory';
        refObject.ReasonNotConservationSurgeryCandidate__c = 'Multi-centric disease';
        refObject.Best_overall_Response_to_date__c = 'Complete Response (CR)';
        refObject.Reporting__c = 'Pre-surgery';
        refObject.Status__c = 'Accepted';
        insert refObject;
        
        Response_Evaluation_Form__c refObject11 = new Response_Evaluation_Form__c();
        refObject11.ReasonNotConservationSurgeryCandidate__c = 'Multi-centric disease';
        refObject11.Current_status_of_T4_tumor__c  = 'Inflammatory';
        refObject11.ReasonNotConservationSurgeryCandidate__c = 'Multi-centric disease';
        refObject11.Best_overall_Response_to_date__c = 'Complete Response (CR)';
        refObject11.Reporting__c = 'Inter-regimen';
        refObject11.Status__c = 'Accepted';
        insert refObject11;
        
        Response_Evaluation_Form__c refObject1 = new Response_Evaluation_Form__c();
        refObject1.ReasonNotConservationSurgeryCandidate__c = 'Inflammatory disease';
        refObject1.Reporting__c = 'Baseline';
        refObject1.Status__c = 'Accepted';
        insert refObject1;
        
        Response_Evaluation_Form__c refObject2 = new Response_Evaluation_Form__c();
        refObject2.ReasonNotConservationSurgeryCandidate__c = 'Diffuse micro calcifications';
        refObject2.Reporting__c = 'Baseline';
        refObject2.Status__c = 'Accepted';
        insert refObject2;
        
        Response_Evaluation_Form__c refObject3 = new Response_Evaluation_Form__c();
        refObject3.ReasonNotConservationSurgeryCandidate__c = 'Institutional norm';
        refObject3.Reporting__c = 'Baseline';
        refObject3.Status__c = 'Accepted';
        insert refObject3;
        
        Response_Evaluation_Form__c refObject4 = new Response_Evaluation_Form__c();
        refObject4.ReasonNotConservationSurgeryCandidate__c = 'Specific anatomy of primary';
        refObject4.Reporting__c = 'Baseline';
        refObject4.Status__c = 'Accepted';
        insert refObject4;
        
        Response_Evaluation_Form__c refObject5 = new Response_Evaluation_Form__c();
        refObject5.ReasonNotConservationSurgeryCandidate__c = 'Other';
        refObject5.Reporting__c = 'Baseline';
        refObject5.Status__c = 'Accepted';
        insert refObject5;
        
        Response_Evaluation_Form__c refObject6 = new Response_Evaluation_Form__c();
        refObject6.IsCandidateForConservationSurgery__c = 'Yes';
        refObject6.ReasonNotConservationSurgeryCandidate__c = 'Multi-centric disease';
        refObject6.Reporting__c = 'Baseline';
        refObject6.Status__c = 'Accepted';
        insert refObject6;
        
        Disease_Assessment__c da = new Disease_Assessment__c();
        da.Clip_placed__c = 'No';
        da.O_Clock_Position_To__c = '3';
        da.O_Clock_Position_From__c = '1';
        da.Longest_Diameter__c = 23.0;
        da.Distance_from_nipple__c = 23.0;
        da.Response_Evaluation_Form__c = refObject.Id;
        insert da;
        
        Disease_Assessment__c da1 = new Disease_Assessment__c();
        da1.Clip_placed__c = 'Yes';
        da1.O_Clock_Position_To__c = '3';
        da1.O_Clock_Position_From__c = '1';
        da1.Longest_Diameter__c = 23.0;
        da1.Distance_from_nipple__c = 23.0;
        da1.Response_Evaluation_Form__c = refObject.Id;
        insert da1;
        
        Set<Id> refIds = new Set<Id>();
        refIds.add(refObject.Id);
        refIds.add(refObject1.Id);
        refIds.add(refObject2.Id);
        refIds.add(refObject3.Id);
        refIds.add(refObject4.Id);
        refIds.add(refObject5.Id);
        refIds.add(refObject6.Id);
        
        SnomedCTCode sno = new SnomedCTCode();
        SnomedCTCode.insertSnomedCodesForResponseEvaluation(refIds);
        SnomedCTCode.SnomedCode('test', 'Breast Conserv');
    }
    
    @isTest static void myUnitTest2() { // method "insertSnomedCodeForFollowup"
        // TO DO: implement unit test
        
        
        Account acc = new Account();
        
        List<Account> lstAccount = [Select a.Id From Account a limit 1]; 
        
        if(!lstAccount.isEmpty()){
                
        Code_Master__c snomedObject = new Code_Master__c();
        snomedObject.Variable_Description__c = 'test';
        snomedObject.IsReportColumn__c = true;
        snomedObject.Display_Order__c = 3.0;
        snomedObject.Name = 'SurvStat';
        insert snomedObject;
        
        Code_Master__c snomedObject1 = new Code_Master__c();
        snomedObject1.Variable_Description__c = 'test';
        snomedObject1.IsReportColumn__c = true;
        snomedObject1.Display_Order__c = 3.0;
        snomedObject1.Name = 'LocalProgSite';
        insert snomedObject1;
        
        Code_Master__c snomedObject2 = new Code_Master__c();
        snomedObject2.Variable_Description__c = 'test';
        snomedObject2.IsReportColumn__c = true;
        snomedObject2.Display_Order__c = 3.0;
        snomedObject2.Name = 'Adj_ChemoReg';
        insert snomedObject2;
        
        Code_Master__c snomedObject3 = new Code_Master__c();
        snomedObject3.Variable_Description__c = 'test';
        snomedObject3.IsReportColumn__c = true;
        snomedObject3.Display_Order__c = 3.0;
        snomedObject3.Name = 'NewPrimeTx';
        insert snomedObject3;
        
        Code_Master__c snomedObject4 = new Code_Master__c();
        snomedObject4.Variable_Description__c = 'test';
        snomedObject4.IsReportColumn__c = true;
        snomedObject4.Display_Order__c = 3.0;
        snomedObject4.Name = 'SurvDateD';
        insert snomedObject4;
        
        Code_Master__c snomedObject5 = new Code_Master__c();
        snomedObject5.Variable_Description__c = 'test';
        snomedObject5.IsReportColumn__c = true;
        snomedObject5.Display_Order__c = 3.0;
        snomedObject5.Name = 'RFS';
        insert snomedObject5;
        
        Code_Master__c snomedObject6 = new Code_Master__c();
        snomedObject6.Variable_Description__c = 'test';
        snomedObject6.IsReportColumn__c = true;
        snomedObject6.Display_Order__c = 3.0;
        snomedObject6.Name = 'RFS_ind';
        insert snomedObject6;
        
        Code_Master__c snomedObject7 = new Code_Master__c();
        snomedObject7.Variable_Description__c = 'test';
        snomedObject7.IsReportColumn__c = true;
        snomedObject7.Display_Order__c = 3.0;
        snomedObject7.Name = 'LocalProgress';
        insert snomedObject7;
        
        Code_Master__c snomedObject8 = new Code_Master__c();
        snomedObject8.Variable_Description__c = 'test';
        snomedObject8.IsReportColumn__c = true;
        snomedObject8.Display_Order__c = 3.0;
        snomedObject8.Name = 'DistProgress';
        insert snomedObject8;
        
        Code_Master__c snomedObject9 = new Code_Master__c();
        snomedObject9.Variable_Description__c = 'test';
        snomedObject9.IsReportColumn__c = true;
        snomedObject9.Display_Order__c = 3.0;
        snomedObject9.Name = 'LocalProgTimeD';
        insert snomedObject9;
        
        Code_Master__c snomedObject10 = new Code_Master__c();
        snomedObject10.Variable_Description__c = 'test';
        snomedObject10.IsReportColumn__c = true;
        snomedObject10.Display_Order__c = 3.0;
        snomedObject10.Name = 'DistProgTimeD';
        insert snomedObject10;
        
        Code_Master__c snomedObject11 = new Code_Master__c();
        snomedObject11.Variable_Description__c = 'test';
        snomedObject11.IsReportColumn__c = true;
        snomedObject11.Display_Order__c = 3.0;
        snomedObject11.Name = 'NewPrimeCa';
        insert snomedObject11;
        
        Code_Master__c snomedObject12 = new Code_Master__c();
        snomedObject12.Variable_Description__c = 'test';
        snomedObject12.IsReportColumn__c = true;
        snomedObject12.Display_Order__c = 3.0;
        snomedObject12.Name = 'NewPrimeTimeD';
        insert snomedObject12;
        
        Code_Master__c snomedObject13 = new Code_Master__c();
        snomedObject13.Variable_Description__c = 'test';
        snomedObject13.IsReportColumn__c = true;
        snomedObject13.Display_Order__c = 3.0;
        snomedObject13.Name = 'DistProgSite';
        insert snomedObject13;
        
        Code_Master__c snomedObject14 = new Code_Master__c();
        snomedObject14.Variable_Description__c = 'test';
        snomedObject14.IsReportColumn__c = true;
        snomedObject14.Display_Order__c = 3.0;
        snomedObject14.Name = 'LocalProgSite';
        insert snomedObject14;
        
        acc = lstAccount[0];           
        
        Patient_Custom__c pc = new Patient_Custom__c();
        pc.Last_Name__c = 'test1';
        pc.Gender__c = 'Male';
        pc.Birthdate__c = date.newInstance(1986, 8, 9);
        pc.Race__c = 'White';
        pc.Ethnicity__c = 'Not Hispanic or Latino';
        pc.Institution__c = acc.Id;
        insert pc;
        
        TrialPatient__c tpObject = new TrialPatient__c();
        tpObject.Patient_Id__c = pc.Id;
        insert tpObject;
        
        Post_Surgaory_Summary__c postObject = new Post_Surgaory_Summary__c();
        postObject.Type_Of_Tumor__c = 'Single Discrete Mass';
        postObject.TrialPatient__c = tpObject.Id;
        postObject.Date_Of_Procedure__c = date.newInstance(2009, 8, 7);
        insert postObject; 
        
        Followup_Form__c followObject = new Followup_Form__c(); //patient_diagnosed_local_progression__c
        followObject.patient_diagnosed_local_progression__c = true;
        followObject.patient_diagnosed_distant_progression__c = true;
        followObject.TrialPatient__c = tpObject.Id;
        followObject.Distant__c = 'Lung';
        followObject.Local__c = 'Axillary Nodes';
        followObject.Local_progression_Date__c = date.newInstance(2009, 8, 7);
        followObject.Distant_progression_Date__c = date.newInstance(2009, 7, 7);
        insert followObject;
        
        Followup_Form__c followObject1 = new Followup_Form__c(); //patient_diagnosed_local_progression__c
        followObject1.patient_diagnosed_local_progression__c = false;
        followObject1.patient_diagnosed_distant_progression__c = true;
        followObject1.TrialPatient__c = tpObject.Id;
        followObject1.Distant__c = 'Lung';
        followObject1.Local__c = 'Axillary Nodes';
        followObject1.Local_progression_Date__c = date.newInstance(2009, 8, 7);
        followObject1.Distant_progression_Date__c = date.newInstance(2009, 7, 7);
        insert followObject1;
        
        Followup_Form__c followObject2 = new Followup_Form__c(); //patient_diagnosed_local_progression__c
        followObject2.patient_diagnosed_local_progression__c = true;
        followObject2.patient_diagnosed_distant_progression__c = false;
        followObject2.TrialPatient__c = tpObject.Id;
        followObject2.Distant__c = 'Lung';
        followObject2.Local__c = 'Axillary Nodes';
        followObject2.Local_progression_Date__c = date.newInstance(2009, 8, 7);
        followObject2.Distant_progression_Date__c = date.newInstance(2009, 7, 7);
        insert followObject2;
        
        Irradiated_Site__c ir = new Irradiated_Site__c();
        ir.Followup_Form__c  = followObject.Id;
        ir.Total_dose_cGy_AP__c = 1.0;
        ir.Site__c = 'Breast';
        insert ir;
        
        Irradiated_Site__c ir1 = new Irradiated_Site__c();
        ir1.Followup_Form__c  = followObject.Id;
        ir1.Total_dose_cGy_AP__c = 1.0;
        ir1.Site__c = 'Boost';
        insert ir1;
        
        Therapy_Received__c tr = new Therapy_Received__c();
        tr.Followup_Form__c = followObject2.Id;
        tr.Therapy__c = 'Aromatase inhibitor';
        insert tr;
        
        tr = new Therapy_Received__c();
        tr.Followup_Form__c = followObject2.Id;
        tr.Therapy__c = 'Ovarian ablation';
        insert tr;
        
        tr = new Therapy_Received__c();
        tr.Followup_Form__c = followObject2.Id;
        tr.Therapy__c = 'Tamoxifen';
        insert tr;
        
        tr = new Therapy_Received__c();
        tr.Followup_Form__c = followObject2.Id;
        tr.Therapy__c = 'Aromatase inhibitor';
        insert tr;
        
        tr = new Therapy_Received__c();
        tr.Followup_Form__c = followObject2.Id;
        tr.Therapy__c = 'Ovarian suppression';
        insert tr;
        
        Set<Id> foIds = new Set<Id>();
        foIds.add(followObject.Id);
        
        SnomedCTCode sno = new SnomedCTCode();
        SnomedCTCode.insertSnomedCodeForFollowup(foIds);
        }
    }
    @isTest static void myUnitTest3() { // method "insertSnomedCodesForMRI"
        // TO DO: implement unit test
        User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
        System.runAs ( thisUser ){
        
        Account inst = new Account();
        List<Account> lstAccount = [select Id from Account limit 1];
        if(!lstAccount.isEmpty()) {
        inst = lstAccount[0];
                
        Patient_Custom__c p = new Patient_Custom__c();
        p.Birthdate__c = date.newInstance(1960, 8, 7);
        p.Ethnicity__c = 'Hispanic or latino';
        p.Gender__c = 'female';
        p.Race__c = 'asian';
        p.Last_Name__c = 'kumar';
        p.Institution__c = inst.Id;
        insert p;
        
        Trial__c t = new Trial__c();
        t.Start_Date__c = system.today();
        insert t;

        TrialPatient__c tp = new TrialPatient__c();
        tp.Trial_Id__c = t.Id;
        tp.Patient_Id__c = p.Id;
        insert tp;
        
        Code_Master__c snomedObject = new Code_Master__c();
        snomedObject.Variable_Description__c = 'test';
        snomedObject.IsReportColumn__c = true;
        snomedObject.Display_Order__c = 3.0;
        snomedObject.Name = 'MRIvol_T0';
        insert snomedObject;
        
        Code_Master__c snomedObject1 = new Code_Master__c();
        snomedObject1.Variable_Description__c = 'test';
        snomedObject1.IsReportColumn__c = true;
        snomedObject1.Display_Order__c = 3.0;
        snomedObject1.Name = 'MRIvol_T1';
        insert snomedObject1;
        
        Code_Master__c snomedObject2 = new Code_Master__c();
        snomedObject2.Variable_Description__c = 'test';
        snomedObject2.IsReportColumn__c = true;
        snomedObject2.Display_Order__c = 3.0;
        snomedObject2.Name = 'MRIvol_T2';
        insert snomedObject2;
        
        Code_Master__c snomedObject3 = new Code_Master__c();
        snomedObject3.Variable_Description__c = 'test';
        snomedObject3.IsReportColumn__c = true;
        snomedObject3.Display_Order__c = 3.0;
        snomedObject3.Name = 'MRIvol_T3';
        insert snomedObject3;
        
        Code_Master__c snomedObject4 = new Code_Master__c();
        snomedObject4.Variable_Description__c = 'test';
        snomedObject4.IsReportColumn__c = true;
        snomedObject4.Display_Order__c = 3.0;
        snomedObject4.Name = 'MRILD_T0';
        insert snomedObject4;
        
        Code_Master__c snomedObject5 = new Code_Master__c();
        snomedObject5.Variable_Description__c = 'test';
        snomedObject5.IsReportColumn__c = true;
        snomedObject5.Display_Order__c = 3.0;
        snomedObject5.Name = 'MRILD_T1';
        insert snomedObject5;
        
        Code_Master__c snomedObject6 = new Code_Master__c();
        snomedObject6.Variable_Description__c = 'test';
        snomedObject6.IsReportColumn__c = true;
        snomedObject6.Display_Order__c = 3.0;
        snomedObject6.Name = 'MRILD_T2';
        insert snomedObject6;
        
        Code_Master__c snomedObject7 = new Code_Master__c();
        snomedObject7.Variable_Description__c = 'test';
        snomedObject7.IsReportColumn__c = true;
        snomedObject7.Display_Order__c = 3.0;
        snomedObject7.Name = 'MRILD_T3';
        insert snomedObject7;
        
        snomedObject7 = new Code_Master__c();
        snomedObject7.Variable_Description__c = 'test';
        snomedObject7.IsReportColumn__c = true;
        snomedObject7.Display_Order__c = 3.0;
        snomedObject7.Name = 'MRIvol_T0-T1';
        insert snomedObject7;
        
        snomedObject7 = new Code_Master__c();
        snomedObject7.Variable_Description__c = 'test';
        snomedObject7.IsReportColumn__c = true;
        snomedObject7.Display_Order__c = 3.0;
        snomedObject7.Name = 'MRIvol_T0-T2';
        insert snomedObject7;
        
        snomedObject7 = new Code_Master__c();
        snomedObject7.Variable_Description__c = 'test';
        snomedObject7.IsReportColumn__c = true;
        snomedObject7.Display_Order__c = 3.0;
        snomedObject7.Name = 'MRIvol_T1-T2';
        insert snomedObject7;
        
        snomedObject7 = new Code_Master__c();
        snomedObject7.Variable_Description__c = 'test';
        snomedObject7.IsReportColumn__c = true;
        snomedObject7.Display_Order__c = 3.0;
        snomedObject7.Name = 'MRIvol_T0-T3';
        insert snomedObject7;
        
        snomedObject7 = new Code_Master__c();
        snomedObject7.Variable_Description__c = 'test';
        snomedObject7.IsReportColumn__c = true;
        snomedObject7.Display_Order__c = 3.0;
        snomedObject7.Name = 'MRIvol_T1-T3';
        insert snomedObject7;
        
        snomedObject7 = new Code_Master__c();
        snomedObject7.Variable_Description__c = 'test';
        snomedObject7.IsReportColumn__c = true;
        snomedObject7.Display_Order__c = 3.0;
        snomedObject7.Name = 'MRIvol_T2-T3';
        insert snomedObject7;
        
        MRI_Volume__c mri = new MRI_Volume__c();
        mri.Time_Point__c = 'Pre-Treatment';
        mri.MRI_Scan_Date__c = date.newInstance(2012, 7, 7);
        mri.MRI_Volume_in_cm3__c = 2.0;
        mri.Longest_Diameter_Of_Index_Lesion_in_cm__c = 3.0;
        mri.Status__c = 'Accepted';
        mri.TrialPatient__c = tp.Id;
        insert mri; 
        
        MRI_Volume__c mri1 = new MRI_Volume__c();
        mri1.Time_Point__c = 'Early Treatment';
        mri1.MRI_Scan_Date__c = date.newInstance(2012, 7, 7);
        mri1.MRI_Volume_in_cm3__c = 2.0;
        mri1.Longest_Diameter_Of_Index_Lesion_in_cm__c = 3.0;
        mri1.Status__c = 'Accepted';
        mri1.TrialPatient__c = tp.Id;
        insert mri1; 
        
        MRI_Volume__c mri2 = new MRI_Volume__c();
        mri2.Time_Point__c = 'Inter-Regimen';
        mri2.MRI_Scan_Date__c = date.newInstance(2012, 7, 7);
        mri2.MRI_Volume_in_cm3__c = 2.0;
        mri2.Longest_Diameter_Of_Index_Lesion_in_cm__c = 3.0;
        mri2.Status__c = 'Accepted';
        mri2.TrialPatient__c = tp.Id;
        insert mri2;
        
        MRI_Volume__c mri3 = new MRI_Volume__c();
        mri3.Time_Point__c = 'Pre-Surgery';
        mri3.MRI_Scan_Date__c = date.newInstance(2012, 7, 7);
        mri3.MRI_Volume_in_cm3__c = 2.0;
        mri3.Longest_Diameter_Of_Index_Lesion_in_cm__c = 3.0;
        mri3.Status__c = 'Accepted';
        mri3.TrialPatient__c = tp.Id;
        insert mri3; 
        
        Set<Id> mriIds = new Set<Id>();
        mriIds.add(mri.Id);
        mriIds.add(mri1.Id);
        mriIds.add(mri2.Id);
        mriIds.add(mri3.Id);
        
        SnomedCTCode sno = new SnomedCTCode();
        SnomedCTCode.insertSnomedCodesForMRI(mriIds);
                
     }
   }
 }
    
    @isTest static void myUnitTest5() { // method "insertOnStudyEligibilityCode"
        
        //===========================method "insertOnStudyEligibilityCode"=========================
        User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
        System.runAs ( thisUser ){
        
        Account inst = new Account();
        List<Account> lstAccount = [select Id from Account limit 1];
        if(!lstAccount.isEmpty()) {
        inst = lstAccount[0];
                
        Patient_Custom__c p = new Patient_Custom__c();
        p.Birthdate__c = date.newInstance(1960, 8, 7);
        p.Ethnicity__c = 'Hispanic or latino';
        p.Gender__c = 'female';
        p.Race__c = 'asian';
        p.Last_Name__c = 'kumar';
        p.Institution__c = inst.Id;
        insert p;
        
        Trial__c t = new Trial__c();
        t.Start_Date__c = system.today();
        insert t;

        TrialPatient__c tp = new TrialPatient__c();
        tp.Trial_Id__c = t.Id;
        tp.Patient_Id__c = p.Id;
        insert tp;
        
        Code_Master__c snomedObject1 = new Code_Master__c();
        snomedObject1.Variable_Description__c = 'test';
        snomedObject1.IsReportColumn__c = true;
        snomedObject1.Display_Order__c = 3.0;
        snomedObject1.Name = 'Interval_Cancer';
        insert snomedObject1;
        
        Code_Master__c snomedObject = new Code_Master__c();
        snomedObject.Variable_Description__c = 'test';
        snomedObject.IsReportColumn__c = true;
        snomedObject.Display_Order__c = 3.0;
        snomedObject.Name = 'Method_Detect';
        insert snomedObject;
        
        On_Study_Eligibility_Form__c oseObject = new On_Study_Eligibility_Form__c();
        oseObject.Status__c = 'Accepted';
        oseObject.Most_Recent_Date__c = date.newInstance(2012, 8, 8);
        oseObject.Mass_Identification_Date__c = date.newInstance(2012, 8, 9);
        oseObject.TrialPatient__c = tp.Id;
        oseObject.How_was_the_cancer_first_detected__c = 'Self exam';
        insert oseObject;
        
        Set<Id> oseIds = new Set<Id>();
        oseIds.add(oseObject.Id);
        
        SnomedCTCode.insertOnStudyEligibilityCode(oseIds);
        
        //=============================FINISHED ====================================================
        
        //============================method "insertPrelEligibilityCodes"===========================
        
        Code_Master__c snomedObject2 = new Code_Master__c();
        snomedObject2.Variable_Description__c = 'test';
        snomedObject2.IsReportColumn__c = true;
        snomedObject2.Display_Order__c = 3.0;
        snomedObject2.Name = 'ECOG';
        insert snomedObject2;
        
        PreEligibility_Checklist__c preObject = new PreEligibility_Checklist__c();
        preObject.Status__c = 'Approval Not Required';
        preObject.ECOG_Score__c = '1-Symplomatic but ambulatory';
        insert preObject;
        
        Set<Id> preElIds = new Set<Id>();
        preElIds.add(preObject.Id);
        
        SnomedCTCode.insertPrelEligibilityCodes(preElIds);
    }
   }
 }
    @isTest static void myUnitTest6() { // method "insertSnomedCodesForChemoTreatment"
        // TO DO: implement unit test
        
        //====================== method "insertSnomedCodesForChemoTreatment"================================
        
        Code_Master__c snomedObject = new Code_Master__c();
        snomedObject.Variable_Description__c = 'test';
        snomedObject.IsReportColumn__c = true;
        snomedObject.Display_Order__c = 3.0;
        snomedObject.Name = 'Height';
        insert snomedObject;
        
        Code_Master__c snomedObject1 = new Code_Master__c();
        snomedObject1.Variable_Description__c = 'test';
        snomedObject1.IsReportColumn__c = true;
        snomedObject1.Display_Order__c = 3.0;
        snomedObject1.Name = 'Weight';
        insert snomedObject1;
        
        snomedObject1 = new Code_Master__c();
        snomedObject1.Variable_Description__c = 'test';
        snomedObject1.IsReportColumn__c = true;
        snomedObject1.Display_Order__c = 3.0;
        snomedObject1.Name = 'ChemoGrowthMeds';
        insert snomedObject1;
        
        snomedObject1 = new Code_Master__c();
        snomedObject1.Variable_Description__c = 'test';
        snomedObject1.IsReportColumn__c = true;
        snomedObject1.Display_Order__c = 3.0;
        snomedObject1.Name = 'ChemoCat';
        insert snomedObject1;
        
        Chemo_Treatment__c chemObject = new Chemo_Treatment__c();
        chemObject.Patient_height__c = 168.0;
        chemObject.Cycle_number__c = 2.0;
        insert chemObject;
        
        Set<Id> chemoIds = new Set<Id>();
        chemoIds.add(chemObject.Id);
        
        SnomedCTCode sno = new SnomedCTCode();
        SnomedCTCode.insertSnomedCodesForChemoTreatment(chemoIds);
        
        //===============================FINISHED=============================================================
    }
       @isTest static void myUnitTest7() { // method "insertSnomedCodesForPostSurgery"
        // TO DO: implement unit test
        
        //====================== method "insertSnomedCodesForPostSurgery"================================
        
        Code_Master__c snomedObject = new Code_Master__c();
        snomedObject.Variable_Description__c = 'test';
        snomedObject.IsReportColumn__c = true;
        snomedObject.Display_Order__c = 3.0;
        snomedObject.Name = 'RCB_class';
        insert snomedObject;
        
        snomedObject = new Code_Master__c();
        snomedObject.Variable_Description__c = 'test';
        snomedObject.IsReportColumn__c = true;
        snomedObject.Display_Order__c = 3.0;
        snomedObject.Name = 'RCB_index';
        insert snomedObject;
        
        Code_Master__c snomedObject1 = new Code_Master__c();
        snomedObject1.Variable_Description__c = 'test';
        snomedObject1.IsReportColumn__c = true;
        snomedObject1.Display_Order__c = 3.0;
        snomedObject1.Name = 'FNA_Br_pretx';
        insert snomedObject1;
        
        Code_Master__c snomedObject2 = new Code_Master__c();
        snomedObject2.Variable_Description__c = 'test';
        snomedObject2.IsReportColumn__c = true;
        snomedObject2.Display_Order__c = 3.0;
        snomedObject2.Name = 'CoreNeedle_Br__pretx';
        insert snomedObject2;
        
        Code_Master__c snomedObject3 = new Code_Master__c();
        snomedObject3.Variable_Description__c = 'test';
        snomedObject3.IsReportColumn__c = true;
        snomedObject3.Display_Order__c = 3.0;
        snomedObject3.Name = 'Excisional_Br_pretx';
        insert snomedObject3;
        
        Code_Master__c snomedObject4 = new Code_Master__c();
        snomedObject4.Variable_Description__c = 'test';
        snomedObject4.IsReportColumn__c = true;
        snomedObject4.Display_Order__c = 3.0;
        snomedObject4.Name = 'Surgery_Br';
        insert snomedObject4;
        
        Code_Master__c snomedObject5 = new Code_Master__c();
        snomedObject5.Variable_Description__c = 'test';
        snomedObject5.IsReportColumn__c = true;
        snomedObject5.Display_Order__c = 3.0;
        snomedObject5.Name = 'Excisional_Br_pretx';
        insert snomedObject5;
        
        Code_Master__c snomedObject6 = new Code_Master__c();
        snomedObject6.Variable_Description__c = 'test';
        snomedObject6.IsReportColumn__c = true;
        snomedObject6.Display_Order__c = 3.0;
        snomedObject6.Name = 'CoreNeedle_LN_Pretx';
        insert snomedObject6;
        
        Code_Master__c snomedObject7 = new Code_Master__c();
        snomedObject7.Variable_Description__c = 'test';
        snomedObject7.IsReportColumn__c = true;
        snomedObject7.Display_Order__c = 3.0;
        snomedObject7.Name = 'Bx_SN_Pretx';
        insert snomedObject7;
        
        Code_Master__c snomedObject8 = new Code_Master__c();
        snomedObject8.Variable_Description__c = 'test';
        snomedObject8.IsReportColumn__c = true;
        snomedObject8.Display_Order__c = 3.0;
        snomedObject8.Name = 'NumExLN_PS';
        insert snomedObject8;
        
        Code_Master__c snomedObject9 = new Code_Master__c();
        snomedObject9.Variable_Description__c = 'test';
        snomedObject9.IsReportColumn__c = true;
        snomedObject9.Display_Order__c = 3.0;
        snomedObject9.Name = 'NumPosLN_PS';
        insert snomedObject9;
        
        Code_Master__c snomedObject10 = new Code_Master__c();
        snomedObject10.Variable_Description__c = 'test';
        snomedObject10.IsReportColumn__c = true;
        snomedObject10.Display_Order__c = 3.0;
        snomedObject10.Name = 'DCISGrade_PS';
        insert snomedObject10;
        
        Code_Master__c snomedObject11 = new Code_Master__c();
        snomedObject11.Variable_Description__c = 'test';
        snomedObject11.IsReportColumn__c = true;
        snomedObject11.Display_Order__c = 3.0;
        snomedObject11.Name = 'InvMargin_PS';
        insert snomedObject11;
        
        Code_Master__c snomedObject12 = new Code_Master__c();
        snomedObject12.Variable_Description__c = 'test';
        snomedObject12.IsReportColumn__c = true;
        snomedObject12.Display_Order__c = 3.0;
        snomedObject12.Name = 'InvHistology_PS';
        insert snomedObject12;
        
        Code_Master__c snomedObject13 = new Code_Master__c();
        snomedObject13.Variable_Description__c = 'test';
        snomedObject13.IsReportColumn__c = true;
        snomedObject13.Display_Order__c = 3.0;
        snomedObject13.Name = 'DCISHistology_PS';
        insert snomedObject13;
        
        Code_Master__c snomedObject14 = new Code_Master__c();
        snomedObject14.Variable_Description__c = 'test';
        snomedObject14.IsReportColumn__c = true;
        snomedObject14.Display_Order__c = 3.0;
        snomedObject14.Name = 'DCISspan_PS';
        insert snomedObject14;
        
        snomedObject14 = new Code_Master__c();
        snomedObject14.Variable_Description__c = 'test';
        snomedObject14.IsReportColumn__c = true;
        snomedObject14.Display_Order__c = 3.0;
        snomedObject14.Name = 'LCISHistology_PS';
        insert snomedObject14;
        
        Code_Master__c snomedObject15 = new Code_Master__c();
        snomedObject15.Variable_Description__c = 'test';
        snomedObject15.IsReportColumn__c = true;
        snomedObject15.Display_Order__c = 3.0;
        snomedObject15.Name = 'SizeMetLN_PS';
        insert snomedObject15;
        
        Code_Master__c snomedObject16 = new Code_Master__c();
        snomedObject16.Variable_Description__c = 'test';
        snomedObject16.IsReportColumn__c = true;
        snomedObject16.Display_Order__c = 3.0;
        snomedObject16.Name = 'LVI_PS';
        insert snomedObject16;
        
        Code_Master__c snomedObject17 = new Code_Master__c();
        snomedObject17.Variable_Description__c = 'test';
        snomedObject17.IsReportColumn__c = true;
        snomedObject17.Display_Order__c = 3.0;
        snomedObject17.Name = 'InvMultifocal_PS';
        insert snomedObject17;
        
        Code_Master__c snomedObject18 = new Code_Master__c();
        snomedObject18.Variable_Description__c = 'test';
        snomedObject18.IsReportColumn__c = true;
        snomedObject18.Display_Order__c = 3.0;
        snomedObject18.Name = 'InvMargin_PS';
        insert snomedObject18;
        
        Code_Master__c snomedObject19 = new Code_Master__c();
        snomedObject19.Variable_Description__c = 'test';
        snomedObject19.IsReportColumn__c = true;
        snomedObject19.Display_Order__c = 3.0;
        snomedObject19.Name = 'InvHistology_PS';
        insert snomedObject19;
        
        Code_Master__c snomedObject20 = new Code_Master__c();
        snomedObject20.Variable_Description__c = 'test';
        snomedObject20.IsReportColumn__c = true;
        snomedObject20.Display_Order__c = 3.0;
        snomedObject20.Name = 'PathologyStage_PS';
        insert snomedObject20;
        
        Code_Master__c snomedObject21 = new Code_Master__c();
        snomedObject21.Variable_Description__c = 'test';
        snomedObject21.IsReportColumn__c = true;
        snomedObject21.Display_Order__c = 3.0;
        snomedObject21.Name = 'ypT';
        insert snomedObject21;
        
        Code_Master__c snomedObject22 = new Code_Master__c();
        snomedObject22.Variable_Description__c = 'test';
        snomedObject22.IsReportColumn__c = true;
        snomedObject22.Display_Order__c = 3.0;
        snomedObject22.Name = 'ypN';
        insert snomedObject22;
        
        Code_Master__c snomedObject23 = new Code_Master__c();
        snomedObject23.Variable_Description__c = 'test';
        snomedObject23.IsReportColumn__c = true;
        snomedObject23.Display_Order__c = 3.0;
        snomedObject23.Name = 'ypM';
        insert snomedObject23;
        
        Code_Master__c snomedObject24 = new Code_Master__c();
        snomedObject24.Variable_Description__c = 'test';
        snomedObject24.IsReportColumn__c = true;
        snomedObject24.Display_Order__c = 3.0;
        snomedObject24.Name = 'InSitu_PS';
        insert snomedObject24;
        
        Code_Master__c snomedObject25 = new Code_Master__c();
        snomedObject25.Variable_Description__c = 'test';
        snomedObject25.IsReportColumn__c = true;
        snomedObject25.Display_Order__c = 3.0;
        snomedObject25.Name = 'InvDz';
        insert snomedObject25;
        
        Code_Master__c snomedObject26 = new Code_Master__c();
        snomedObject26.Variable_Description__c = 'test';
        snomedObject26.IsReportColumn__c = true;
        snomedObject26.Display_Order__c = 3.0;
        snomedObject26.Name = 'InSituHisto_PS';
        insert snomedObject26;
        
        snomedObject26 = new Code_Master__c();
        snomedObject26.Variable_Description__c = 'test';
        snomedObject26.IsReportColumn__c = true;
        snomedObject26.Display_Order__c = 3.0;
        snomedObject26.Name = 'pCR';
        insert snomedObject26;
        
        Account inst1 = new Account();
        
        List<Account> lstAccount = [select Id from Account where RecordType.Name = 'Institution'];
        if(!lstAccount.isEmpty()) {
        inst1 = lstAccount[0];
            
        Patient_Custom__c pc = new Patient_Custom__c();
        pc.First_Name__c = 'test';
        pc.Last_Name__c = 'test1';
        pc.Gender__c = 'Male';
        pc.Birthdate__c = date.newInstance(2000, 7, 7);
        pc.Race__c = 'White';
        pc.Ethnicity__c = 'Not Hispanic or Latino';
        pc.Medical_Record_Number__c = '3434';
        pc.Institution__c = inst1.Id;
        insert pc;
        
        Trial__c t = new Trial__c();
        insert t;
        
        TrialPatient__c triPat = new TrialPatient__c();
        triPat.Patient_Id__c = pc.Id;
        triPat.Trial_Id__c = t.Id;
        insert triPat;
        
        /*Snomed_Code__c snomed = new Snomed_Code__c();
        snomed.Code_Master__c = snomedObject.Id;
        snomed.TrialPatient__c = triPat.Id;
        snomed.snomed_Code_Name__c = 'IHTSDO_4683';
        snomed.Value__c = '1';
        insert snomed;*/
        
       /* Snomed_Code__c snomed1 = new Snomed_Code__c();
        snomed1.Code_Master__c = snomedObject.Id;
        snomed1.TrialPatient__c = triPat.Id;
        snomed1.snomed_Code_Name__c = '48635004 | fine needle biopsy | ';
        snomed1.Value__c = '1';
        insert snomed1;
        
        Snomed_Code__c snomed2 = new Snomed_Code__c();
        snomed2.Code_Master__c = snomedObject.Id;
        snomed2.TrialPatient__c = triPat.Id;
        snomed2.snomed_Code_Name__c = '392021009 | lumpectomy of breast | ';
        snomed2.Value__c = '1';
        insert snomed2; */
        
        Set<Id> postIds = new Set<Id>();
        
        Post_Surgaory_Summary__c postObject = new Post_Surgaory_Summary__c();
        postObject.Type_Of_Tumor__c = 'Single Discrete Mass';
        postObject.RCB_Class__c = 'I';
        postObject.Is_DCIS_Present__c = 'Yes';
        postObject.Is_LCIS_Present__c = 'Yes';
        postObject.Is_invasive_tumor_present__c = 'No';
        postObject.TrialPatient__c = triPat.Id;
        postObject.status__c = 'Accepted';
        insert postObject;
        postIds.add(postObject.Id);
        
        postObject = new Post_Surgaory_Summary__c();
        postObject.Type_Of_Tumor__c = 'Single Discrete Mass';
        postObject.RCB_Class__c = 'I';
        postObject.Is_DCIS_Present__c = 'Not Reported';
        postObject.Is_LCIS_Present__c = 'No';
        postObject.Is_invasive_tumor_present__c = 'No';
        postObject.TrialPatient__c = triPat.Id;
        postObject.status__c = 'Accepted';
        insert postObject;
        postIds.add(postObject.Id);
        
        Post_Surgaory_Summary__c postObject1 = new Post_Surgaory_Summary__c();
        postObject1.Type_Of_Tumor__c = 'Single Discrete Mass';
        postObject1.RCB_Class__c = 'I';
        postObject1.Is_DCIS_Present__c = 'No';
        postObject1.TrialPatient__c = triPat.Id;
        postObject.Is_invasive_tumor_present__c = 'Yes';
        postObject1.status__c = 'Accepted';
        insert postObject1;
        postIds.add(postObject1.Id);
        
       /* Procedure__c pro = new Procedure__c();
        pro.Post_Surgery_Summary__c = postObject.Id;
        pro.Procedure_Name__c = 'FNA';
        insert pro;
        
        pro = new Procedure__c();
        pro.Post_Surgery_Summary__c = postObject.Id;
        pro.Procedure_Name__c = 'Partial mastectomy';
        insert pro;
        
        pro = new Procedure__c();
        pro.Post_Surgery_Summary__c = postObject.Id;
        pro.Procedure_Name__c = 'FNA (lymph node)';
        insert pro;
        
        pro = new Procedure__c();
        pro.Post_Surgery_Summary__c = postObject.Id;
        pro.Procedure_Name__c = 'Core biopsy';
        insert pro;
        
        pro = new Procedure__c();
        pro.Post_Surgery_Summary__c = postObject.Id;
        pro.Procedure_Name__c = 'Core biopsy (lymph node)';
        insert pro;
        
        pro = new Procedure__c();
        pro.Post_Surgery_Summary__c = postObject.Id;
        pro.Procedure_Name__c = 'Excisional biopsy (lymph node)';
        insert pro;
        
        pro = new Procedure__c();
        pro.Post_Surgery_Summary__c = postObject.Id;
        pro.Procedure_Name__c = 'Incisional biopsy';
        insert pro;
        
        pro = new Procedure__c();
        pro.Post_Surgery_Summary__c = postObject.Id;
        pro.Procedure_Name__c = 'Sentinel lymph node dissection';
        insert pro;
        
        pro = new Procedure__c();
        pro.Post_Surgery_Summary__c = postObject.Id;
        pro.Procedure_Name__c = 'Therapeutic Mastectomy';
        insert pro;
        
        pro = new Procedure__c();
        pro.Post_Surgery_Summary__c = postObject.Id;
        pro.Procedure_Name__c = 'Skin Sparing Mastectomy';
        insert pro;
        
        pro = new Procedure__c();
        pro.Post_Surgery_Summary__c = postObject.Id;
        pro.Procedure_Name__c = 'Total skin sparing mastectomy';
        insert pro;
        
        pro = new Procedure__c();
        pro.Post_Surgery_Summary__c = postObject.Id;
        pro.Procedure_Name__c = 'Modified radical mastectomy';
        insert pro;
        
        pro = new Procedure__c();
        pro.Post_Surgery_Summary__c = postObject.Id;
        pro.Procedure_Name__c = 'Core biopsy (lymph node)';
        pro.Mammography__c = true;
        pro.MRI__c = true;
        pro.Ultrasound__c = true;
        pro.Stereotactic__c = true;
        pro.Palpation_guided__c = true;
        insert pro;*/
        
        /*Procedure__c pro1 = new Procedure__c();
        pro1.Post_Surgery_Summary__c = postObject.Id;
        pro1.Procedure_Name__c = 'Sentinel lymph node dissection';
        insert pro1; */
        
        Lymph_Nodes__c ln = new Lymph_Nodes__c();
        ln.Post_Surgery_Summary__c = postObject.Id;
        ln.Axillary_Nodes__c = true;
        ln.Positive__c = 1.0;
        ln.Examined__c = 1.0;
        insert ln;
        
        Lymph_Nodes__c ln1 = new Lymph_Nodes__c();
        ln.Post_Surgery_Summary__c = postObject1.Id;
        ln1.Sentinel_Nodes__c = true;
        ln1.Positive__c = 1.0;
        ln1.Examined__c = 1.0;
        insert ln1;
        
        Invasive_Tumor_Detail__c inv = new Invasive_Tumor_Detail__c();
        inv.Post_Surgery_Summary__c  = postObject1.id;
        inv.Invasive_ductal_carcinoma_nos__c = true;
        inv.Invasive_lobular_carcinoma_classic_type__c = true;
        inv.Invasive_lobular_carcinoma_alveolar_type__c = true;
        inv.Pleomorphic_lobular_carcinoma__c = true;
        inv.Tubulolobular_carcinoma__c = true;
        inv.Invasive_carcinoma_mixed_ductal_lobular__c = true;
        inv.Tubular_carcinoma__c = true;
        inv.Mucinous_carcinoma__c = true;
        inv.Medullary_carcinoma__c = true;
        inv.Invasive_papillary_carcinoma__c = true;
        inv.Invasive_cribiform_carcinoma__c = true;
        inv.Multi_focal_Tumor__c = 'Yes'; 
        insert inv;
        
        DCIS__c dcis = new DCIS__c();
        dcis.Post_Surgery_Summary__c = postObject.Id;
        dcis.Punctate_necrosis__c = true;
        dcis.Comedonecrosis__c = true;
        dcis.Papillary__c = true;
        dcis.Micropapillary__c = true;
        dcis.Necrosis__c = true;
        dcis.Cribiform__c = true;
        dcis.Cruciform__c = true;
        dcis.Clinging__c = true;
        dcis.Solid__c = true;
        dcis.Apocrine__c = true;
        dcis.Intra_cystic_encysted_papillary__c = true;
        dcis.Other__c = true;
        insert dcis;
        
        LCIS__c lcis = new LCIS__c();
        lcis.Post_Surgery_Summary__c = postObject.Id;
        insert lcis;
        
        Staging_Detail__c s = new Staging_Detail__c();
        s.Post_Surgery_Summary__c= postObject1.id;
        insert s;
        
        //SnomedCTCode sno = new SnomedCTCode();
        SnomedCTCode.insertSnomedCodesForPostSurgery(postIds);
        }
        //===================FINISHED=================================================
    }
    
    @isTest static void myUnitTest7a() {
        Account inst1 = new Account();
        
        List<Account> lstAccount = [select Id from Account where RecordType.Name = 'Institution'];
        if(!lstAccount.isEmpty()) {
            inst1 = lstAccount[0];
                
            Patient_Custom__c pc = new Patient_Custom__c();
            pc.First_Name__c = 'test';
            pc.Last_Name__c = 'test1';
            pc.Gender__c = 'Male';
            pc.Birthdate__c = date.newInstance(2000, 7, 7);
            pc.Race__c = 'White';
            pc.Ethnicity__c = 'Not Hispanic or Latino';
            pc.Medical_Record_Number__c = '3434';
            pc.Institution__c = inst1.Id;
            insert pc;
            
            Trial__c t = new Trial__c();
            insert t;
            
            TrialPatient__c triPat = new TrialPatient__c();
            triPat.Patient_Id__c = pc.Id;
            triPat.Trial_Id__c = t.Id;
            insert triPat;
            
            Set<Id> postIds = new Set<Id>();
            Post_Surgaory_Summary__c postObject2 = new Post_Surgaory_Summary__c();
            postObject2.Type_Of_Tumor__c = 'Single Discrete Mass';
            postObject2.RCB_Class__c = 'I';
            postObject2.Is_DCIS_Present__c = 'Not Reported';
            postObject2.Is_LCIS_Present__c = 'Yes';
            postObject2.TrialPatient__c = triPat.Id;
            postObject2.Status__c = 'Accepted';
            insert postObject2;
            postIds.add(postObject2.Id);
            
            Post_Surgaory_Summary__c postObject = new Post_Surgaory_Summary__c();
            postObject.Type_Of_Tumor__c = 'Single Discrete Mass';
            postObject.RCB_Class__c = 'I';
            postObject.Is_DCIS_Present__c = 'No';
            postObject.Is_LCIS_Present__c = 'Yes';
            postObject.Is_invasive_tumor_present__c = 'No';
            postObject.TrialPatient__c = triPat.Id;
            postObject.status__c = 'Accepted';
            insert postObject;
            postIds.add(postObject.Id);
            
            postObject = new Post_Surgaory_Summary__c();
            postObject.Type_Of_Tumor__c = 'Single Discrete Mass';
            postObject.RCB_Class__c = 'I';
            postObject.Is_DCIS_Present__c = 'No';
            postObject.Is_LCIS_Present__c = 'No';
            postObject.Is_invasive_tumor_present__c = 'No';
            postObject.TrialPatient__c = triPat.Id;
            postObject.status__c = 'Accepted';
            insert postObject;
            postIds.add(postObject.Id);
            
            Post_Surgaory_Summary__c postObject3 = new Post_Surgaory_Summary__c();
            postObject3.Type_Of_Tumor__c = 'Single Discrete Mass';
            postObject3.RCB_Class__c = 'I';
            postObject3.Is_DCIS_Present__c = '';
            postObject3.Is_LCIS_Present__c = '';
            postObject3.TrialPatient__c = triPat.Id;
            postObject3.Status__c = 'Accepted';
            insert postObject3;
            postIds.add(postObject3.Id);
            
            SnomedCTCode.insertSnomedCodesForPostSurgery(postIds);
        }
    }
    
    @isTest static void myUnitTest8() { // method "insertPatientRelatedCode"
        // TO DO: implement unit test
        
        //====================== method "insertPatientRelatedCode"================================
        
        Code_Master__c snomedObject = new Code_Master__c();
        snomedObject.Variable_Description__c = 'test';
        snomedObject.IsReportColumn__c = true;
        snomedObject.Display_Order__c = 3.0;
        snomedObject.Name = 'Age';
        insert snomedObject;
        
        Snomed_Code__c snomed = new Snomed_Code__c();
        snomed.Code_Master__c = snomedObject.Id;
        insert snomed;
        
        Code_Master__c snomedObject1 = new Code_Master__c();
        snomedObject1.Variable_Description__c = 'test';
        snomedObject1.IsReportColumn__c = true;
        snomedObject1.Display_Order__c = 3.0;
        snomedObject1.Name = 'Race';
        insert snomedObject1;
        
        Code_Master__c snomedObject2 = new Code_Master__c();
        snomedObject2.Variable_Description__c = 'test';
        snomedObject2.IsReportColumn__c = true;
        snomedObject2.Display_Order__c = 3.0;
        snomedObject2.Name = 'Ethn';
        insert snomedObject2;
        
        Account acc = new Account();
        
        List<Account> lstAccount = [Select a.Id From Account a limit 1]; 
        
        if(!lstAccount.isEmpty()){
                
        acc = lstAccount[0];           
        
        Patient_Custom__c pc = new Patient_Custom__c();
        pc.Last_Name__c = 'test1';
        pc.Gender__c = 'Male';
        pc.Birthdate__c = date.newInstance(1986, 8, 9);
        pc.Race__c = 'White';
        pc.Ethnicity__c = 'Not Hispanic or Latino';
        pc.Institution__c = acc.Id;
        insert pc;
        
        Set<id> patientIds = new Set<id>();
        patientIds.add(pc.Id);
        
        SnomedCTCode sno = new SnomedCTCode();
        SnomedCTCode.insertPatientRelatedCode(patientIds);
        
        //===================================FINISHED========================================================
        
        //==============================METHOD "insertRegistrationRelatedCode" ==============================
        
        Code_Master__c snomedObject3 = new Code_Master__c();
        snomedObject3.Variable_Description__c = 'test';
        snomedObject3.IsReportColumn__c = true;
        snomedObject3.Display_Order__c = 3.0;
        snomedObject3.Name = 'Institution';
        insert snomedObject3;
        
        Trial__c tr = new Trial__c();
        tr.Name = 'test';
        insert tr;
        
        Registration__c reg = new Registration__c(); 
        reg.Patient__c = pc.Id;
        reg.Registration_Date__c = system.today();
        reg.Institution__c = acc.Id;
        reg.IRB_Approval_Date__c = system.today();
        reg.HIPPA_Consent_Date__c = system.today();
        reg.Screening_Informed_Consent_Date__c = system.today();
        reg.Trial__c = tr.Id;
        insert reg; 
        
        Set<id> regIds = new Set<id>();
        regIds.add(reg.Id);
        
        SnomedCTCode.insertRegistrationRelatedCode(regIds);
        //=============================FINISHED===============================================================
        
        }
    }
    @isTest static void myUnitTest9() { // method "insertMenopasualRelatedCode"
        
        //====================== method "insertMenopasualRelatedCode"================================
        User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
        System.runAs ( thisUser ){
        
        Account inst = new Account();
        List<Account> lstAccount = [select Id from Account limit 1];
        if(!lstAccount.isEmpty()) {
        inst = lstAccount[0];
                
        Patient_Custom__c p = new Patient_Custom__c();
        p.Birthdate__c = date.newInstance(1960, 8, 7);
        p.Ethnicity__c = 'Hispanic or latino';
        p.Gender__c = 'female';
        p.Race__c = 'asian';
        p.Last_Name__c = 'kumar';
        p.Institution__c = inst.Id;
        insert p;
        
        Trial__c t = new Trial__c();
        t.Start_Date__c = system.today();
        insert t;

        TrialPatient__c tp = new TrialPatient__c();
        tp.Trial_Id__c = t.Id;
        tp.Patient_Id__c = p.Id;
        insert tp;
        
        Code_Master__c snomedObject = new Code_Master__c();
        snomedObject.Variable_Description__c = 'test';
        snomedObject.IsReportColumn__c = true;
        snomedObject.Display_Order__c = 3.0;
        snomedObject.Name = 'Menopausal_OS';
        insert snomedObject;
        
        Snomed_Code__c snomed = new Snomed_Code__c();
        snomed.Code_Master__c = snomedObject.Id;
        insert snomed;
        
        Menopausal_Status_Detail__c msdObject = new Menopausal_Status_Detail__c(); // else part line 29
        msdObject.Menopausal_Status__c = 'Above categories not applicable AND Age < 50';
        msdObject.TrialPatient__c = tp.Id;
        insert msdObject;  
        
        Set<id> menopasualIds = new Set<id>();
        menopasualIds.add(msdObject.Id);
        
        SnomedCTCode sno = new SnomedCTCode();
        SnomedCTCode.insertMenopasualRelatedCode(menopasualIds);
        
        //==================================FINISHED==================================================
        
        //========================method "insertMammaPrintCode"=======================================
        
        Code_Master__c snomedObject1 = new Code_Master__c();
        snomedObject1.Variable_Description__c = 'test';
        snomedObject1.IsReportColumn__c = true;
        snomedObject1.Display_Order__c = 3.0;
        snomedObject1.Name = 'Her2TargetPrint_OS';
        insert snomedObject1;
        
        Snomed_Code__c snomed1 = new Snomed_Code__c();
        snomed1.Code_Master__c = snomedObject1.Id;
        insert snomed1;
        
        Code_Master__c snomedObject2 = new Code_Master__c();
        snomedObject2.Variable_Description__c = 'test';
        snomedObject2.IsReportColumn__c = true;
        snomedObject2.Display_Order__c = 3.0;
        snomedObject2.Name = 'MP_Risk';
        insert snomedObject2;
        
        Snomed_Code__c snomed2 = new Snomed_Code__c();
        snomed2.Code_Master__c = snomedObject2.Id;
        insert snomed2;
        
        Code_Master__c snomedObject3 = new Code_Master__c();
        snomedObject3.Variable_Description__c = 'test';
        snomedObject3.IsReportColumn__c = true;
        snomedObject3.Display_Order__c = 3.0;
        snomedObject3.Name = 'MP_Index';
        insert snomedObject3;
        
        Snomed_Code__c snomed3 = new Snomed_Code__c();
        snomed3.Code_Master__c = snomedObject3.Id;
        insert snomed3;
        
        Code_Master__c snomedObject4 = new Code_Master__c();
        snomedObject4.Variable_Description__c = 'test';
        snomedObject4.IsReportColumn__c = true;
        snomedObject4.Display_Order__c = 3.0;
        snomedObject4.Name = 'MP_Cat';
        insert snomedObject4;
        
        Snomed_Code__c snomed4 = new Snomed_Code__c();
        snomed4.Code_Master__c = snomedObject4.Id;
        insert snomed4;
        
        MammaPrintDetail__c mpd = new MammaPrintDetail__c();
        mpd.Report_Date__c = date.newInstance(2011, 7, 7);
        mpd.MammaPrint_Index__c = 2.0;
        mpd.MammaPrint_Risk__c = 'Low risk';
        mpd.TrialPatient__c = tp.Id;
        insert mpd; 
        
        Set<id> mpIds = new Set<id>();
        mpIds.add(mpd.Id);
        
        SnomedCTCode.insertMammaPrintCode(mpIds);
     }
   }
 }
 
    @isTest static void myUnitTest10() { // method "insertOnStudyPathologyCode" 
        
        //====================== method "insertOnStudyPathologyCode"================================
        
       
        Code_Master__c snomedObject = new Code_Master__c();
        snomedObject.Variable_Description__c = 'test';
        snomedObject.IsReportColumn__c = true;
        snomedObject.Display_Order__c = 3.0;
        snomedObject.Name = 'BilateralCa';
        
        insert snomedObject;
        
        snomedObject = new Code_Master__c();
        snomedObject.Variable_Description__c = 'test';
        snomedObject.IsReportColumn__c = true;
        snomedObject.Display_Order__c = 3.0;
        snomedObject.Name = 'Bx_SN_Pretx';
        
       insert snomedObject;
        
       snomedObject = new Code_Master__c();
        snomedObject.Variable_Description__c = 'test';
        snomedObject.IsReportColumn__c = true;
        snomedObject.Display_Order__c = 3.0;
        snomedObject.Name = 'Incisional_LN_Pretx';
      
       insert snomedObject;
        
        snomedObject = new Code_Master__c();
        snomedObject.Variable_Description__c = 'test';
        snomedObject.IsReportColumn__c = true;
        snomedObject.Display_Order__c = 3.0;
        snomedObject.Name = 'CoreNeedle Guidance_pretx';
        
        insert snomedObject;
        
        Code_Master__c snomedObject1 = new Code_Master__c();
        snomedObject1.Variable_Description__c = 'test';
        snomedObject1.IsReportColumn__c = true;
        snomedObject1.Display_Order__c = 3.0;
        snomedObject1.Name = 'Excisional_Br_pretx';
        
        insert snomedObject1;
        
        snomedObject1 = new Code_Master__c();
        snomedObject1.Variable_Description__c = 'test';
        snomedObject1.IsReportColumn__c = true;
        snomedObject1.Display_Order__c = 3.0;
        snomedObject1.Name = 'FNA_Br_pretx';
       
       insert snomedObject1;
        
        snomedObject1 = new Code_Master__c();
        snomedObject1.Variable_Description__c = 'test';
        snomedObject1.IsReportColumn__c = true;
        snomedObject1.Display_Order__c = 3.0;
        snomedObject1.Name = 'FNA_LN_Pretx';
       
      insert snomedObject1;
        
        snomedObject1 = new Code_Master__c();
        snomedObject1.Variable_Description__c = 'test';
        snomedObject1.IsReportColumn__c = true;
        snomedObject1.Display_Order__c = 3.0;
        snomedObject1.Name = 'CoreNeedle_Br__pretx';
       
       insert snomedObject1;
        
        snomedObject1 = new Code_Master__c();
        snomedObject1.Variable_Description__c = 'test';
        snomedObject1.IsReportColumn__c = true;
        snomedObject1.Display_Order__c = 3.0;
        snomedObject1.Name = 'CoreNeedle_LN_Pretx';
      
        insert snomedObject1;
        
        Code_Master__c snomedObject2 = new Code_Master__c();
        snomedObject2.Variable_Description__c = 'test';
        snomedObject2.IsReportColumn__c = true;
        snomedObject2.Display_Order__c = 3.0;
        snomedObject2.Name = 'PRstatus_OS';
       
        insert snomedObject2;
        
        Code_Master__c snomedObject3 = new Code_Master__c();
        snomedObject3.Variable_Description__c = 'test';
        snomedObject3.IsReportColumn__c = true;
        snomedObject3.Display_Order__c = 3.0;
        snomedObject3.Name = 'ERstatus_OS';
      
        insert snomedObject3;
        
        Code_Master__c snomedObject4 = new Code_Master__c();
        snomedObject4.Variable_Description__c = 'test';
        snomedObject4.IsReportColumn__c = true;
        snomedObject4.Display_Order__c = 3.0;
        snomedObject4.Name = 'ER_TS_OS';
      
        insert snomedObject4;
        
        Code_Master__c snomedObject5 = new Code_Master__c();
        snomedObject5.Variable_Description__c = 'test';
        snomedObject5.IsReportColumn__c = true;
        snomedObject5.Display_Order__c = 3.0;
        snomedObject5.Name = 'PgR_TS_OS';
      
        insert snomedObject5;
        
        Code_Master__c snomedObject6 = new Code_Master__c();
        snomedObject6.Variable_Description__c = 'test';
        snomedObject6.IsReportColumn__c = true;
        snomedObject6.Display_Order__c = 3.0;
        snomedObject6.Name = 'Her2IHCstatus_OS';
       
       insert snomedObject6;
        
        Code_Master__c snomedObject7 = new Code_Master__c();
        snomedObject7.Variable_Description__c = 'test';
        snomedObject7.IsReportColumn__c = true;
        snomedObject7.Display_Order__c = 3.0;
        snomedObject7.Name = 'Her2FISHstatus_OS';
      
        insert snomedObject7;
        
        Code_Master__c snomedObject8 = new Code_Master__c();
        snomedObject8.Variable_Description__c = 'test';
        snomedObject8.IsReportColumn__c = true;
        snomedObject8.Display_Order__c = 3.0;
        snomedObject8.Name = 'NumExLN_PS';
      
        insert snomedObject8;
        
        Code_Master__c snomedObject9 = new Code_Master__c();
        snomedObject9.Variable_Description__c = 'test';
        snomedObject9.IsReportColumn__c = true;
        snomedObject9.Display_Order__c = 3.0;
        snomedObject9.Name = 'NumPosLN_PS';
       
        insert snomedObject9;
        
        Code_Master__c snomedObject10 = new Code_Master__c();
        snomedObject10.Variable_Description__c = 'test';
        snomedObject10.IsReportColumn__c = true;
        snomedObject10.Display_Order__c = 3.0;
        snomedObject10.Name = 'DCISGrade_PS';
      
        insert snomedObject10;
        
        Code_Master__c snomedObject11 = new Code_Master__c();
        snomedObject11.Variable_Description__c = 'test';
        snomedObject11.IsReportColumn__c = true;
        snomedObject11.Display_Order__c = 3.0;
        snomedObject11.Name = 'InvMargin_PS';
        
        insert snomedObject11;
        
        Code_Master__c snomedObject12 = new Code_Master__c();
        snomedObject12.Variable_Description__c = 'test';
        snomedObject12.IsReportColumn__c = true;
        snomedObject12.Display_Order__c = 3.0;
        snomedObject12.Name = 'InvHistology_PS';
        
        insert snomedObject12;
        
        Code_Master__c snomedObject13 = new Code_Master__c();
        snomedObject13.Variable_Description__c = 'test';
        snomedObject13.IsReportColumn__c = true;
        snomedObject13.Display_Order__c = 3.0;
        snomedObject13.Name = 'DCISHistology_PS';
        insert snomedObject13;
     
        
        
        
        Code_Master__c snomedObject14 = new Code_Master__c();
        snomedObject14.Variable_Description__c = 'test';
        snomedObject14.IsReportColumn__c = true;
        snomedObject14.Display_Order__c = 3.0;
        snomedObject14.Name = 'DCISspan_PS';
        insert snomedObject14;
        
        snomedObject14 = new Code_Master__c();
        snomedObject14.Variable_Description__c = 'test';
        snomedObject14.IsReportColumn__c = true;
        snomedObject14.Display_Order__c = 3.0;
        snomedObject14.Name = 'LCISHistology_PS';
        insert snomedObject14;
        
        Code_Master__c snomedObject15 = new Code_Master__c();
        snomedObject15.Variable_Description__c = 'test';
        snomedObject15.IsReportColumn__c = true;
        snomedObject15.Display_Order__c = 3.0;
        snomedObject15.Name = 'SizeMetLN_PS';
        insert snomedObject15;
        
        Code_Master__c snomedObject16 = new Code_Master__c();
        snomedObject16.Variable_Description__c = 'test';
        snomedObject16.IsReportColumn__c = true;
        snomedObject16.Display_Order__c = 3.0;
        snomedObject16.Name = 'LVI_PS';
        insert snomedObject16;
        
        Code_Master__c snomedObject17 = new Code_Master__c();
        snomedObject17.Variable_Description__c = 'test';
        snomedObject17.IsReportColumn__c = true;
        snomedObject17.Display_Order__c = 3.0;
        snomedObject17.Name = 'InvMultifocal_PS';
        insert snomedObject17;
        
        Code_Master__c snomedObject18 = new Code_Master__c();
        snomedObject18.Variable_Description__c = 'test';
        snomedObject18.IsReportColumn__c = true;
        snomedObject18.Display_Order__c = 3.0;
        snomedObject18.Name = 'InvMargin_PS';
        insert snomedObject18;
        
        Code_Master__c snomedObject19 = new Code_Master__c();
        snomedObject19.Variable_Description__c = 'test';
        snomedObject19.IsReportColumn__c = true;
        snomedObject19.Display_Order__c = 3.0;
        snomedObject19.Name = 'InvHistology_PS';
        insert snomedObject19;
        
        Code_Master__c snomedObject20 = new Code_Master__c();
        snomedObject20.Variable_Description__c = 'test';
        snomedObject20.IsReportColumn__c = true;
        snomedObject20.Display_Order__c = 3.0;
        snomedObject20.Name = 'PathologyStage_PS';
        insert snomedObject20;
        
        Code_Master__c snomedObject21 = new Code_Master__c();
        snomedObject21.Variable_Description__c = 'test';
        snomedObject21.IsReportColumn__c = true;
        snomedObject21.Display_Order__c = 3.0;
        snomedObject21.Name = 'ypT';
        insert snomedObject21;
        
        Code_Master__c snomedObject22 = new Code_Master__c();
        snomedObject22.Variable_Description__c = 'test';
        snomedObject22.IsReportColumn__c = true;
        snomedObject22.Display_Order__c = 3.0;
        snomedObject22.Name = 'ypN';
        insert snomedObject22;
        
        Code_Master__c snomedObject23 = new Code_Master__c();
        snomedObject23.Variable_Description__c = 'test';
        snomedObject23.IsReportColumn__c = true;
        snomedObject23.Display_Order__c = 3.0;
        snomedObject23.Name = 'ypM';
        insert snomedObject23;
        
        Code_Master__c snomedObject24 = new Code_Master__c();
        snomedObject24.Variable_Description__c = 'test';
        snomedObject24.IsReportColumn__c = true;
        snomedObject24.Display_Order__c = 3.0;
        snomedObject24.Name = 'InSitu_PS';
        insert snomedObject24;
        
        Code_Master__c snomedObject25 = new Code_Master__c();
        snomedObject25.Variable_Description__c = 'test';
        snomedObject25.IsReportColumn__c = true;
        snomedObject25.Display_Order__c = 3.0;
        snomedObject25.Name = 'InvDz';
        insert snomedObject25;
        
        Code_Master__c snomedObject26 = new Code_Master__c();
        snomedObject26.Variable_Description__c = 'test';
        snomedObject26.IsReportColumn__c = true;
        snomedObject26.Display_Order__c = 3.0;
        snomedObject26.Name = 'InSituHisto_PS';
        insert snomedObject26;
        
        snomedObject26 = new Code_Master__c();
        snomedObject26.Variable_Description__c = 'test';
        snomedObject26.IsReportColumn__c = true;
        snomedObject26.Display_Order__c = 3.0;
        snomedObject26.Name = 'pCR';
        insert snomedObject26; 
        
        Snomed_Code__c snomed = new Snomed_Code__c();
        snomed.Code_Master__c = snomedObject.Id;
        insert snomed;
        
       /* On_Study_Pathology_Form__c ospobject = new On_Study_Pathology_Form__c();
        ospobject.status__c = 'Accepted';
        insert ospobject; */
        
        On_Study_Pathology_Form__c ospobject=[Select id from On_Study_Pathology_Form__c where status__c = 'Accepted' limit 1];
        
        Post_Surgaory_Summary__c postObject = new Post_Surgaory_Summary__c();
        postObject.Type_Of_Tumor__c = 'Single Discrete Mass';
        insert postObject;
        
        Procedure__c pro = new Procedure__c();
        pro.On_Study_Pathology_Form__c = ospobject.Id;
        pro.Procedure_Name__c = 'FNA';
        insert pro;
        
        pro = new Procedure__c();
        pro.On_Study_Pathology_Form__c = ospobject.Id;
        pro.Procedure_Name__c = 'Partial mastectomy';
        insert pro;
        
        pro = new Procedure__c();
        pro.On_Study_Pathology_Form__c = ospobject.Id;
        pro.Procedure_Name__c = 'FNA (lymph node)';
        insert pro;
        
        pro = new Procedure__c();
        pro.On_Study_Pathology_Form__c = ospobject.Id;
        pro.Procedure_Name__c = 'Core biopsy';
        insert pro;
        
        pro = new Procedure__c();
        pro.On_Study_Pathology_Form__c = ospobject.Id;
        pro.Procedure_Name__c = 'Core biopsy (lymph node)';
        insert pro;
        
        pro = new Procedure__c();
        pro.On_Study_Pathology_Form__c = ospobject.Id;
        pro.Procedure_Name__c = 'Excisional biopsy (lymph node)';
        insert pro;
        
        pro = new Procedure__c();
        pro.On_Study_Pathology_Form__c = ospobject.Id;
        pro.Procedure_Name__c = 'Incisional biopsy';
        insert pro;
        
        pro = new Procedure__c();
        pro.On_Study_Pathology_Form__c = ospobject.Id;
        pro.Procedure_Name__c = 'Sentinel lymph node dissection';
        insert pro;
        
        pro = new Procedure__c();
        pro.On_Study_Pathology_Form__c = ospobject.Id;
        pro.Procedure_Name__c = 'Therapeutic Mastectomy';
        insert pro;
        
        pro = new Procedure__c();
        pro.On_Study_Pathology_Form__c = ospobject.Id;
        pro.Procedure_Name__c = 'Skin Sparing Mastectomy';
        insert pro;
        
        pro = new Procedure__c();
        pro.On_Study_Pathology_Form__c = ospobject.Id;
        pro.Procedure_Name__c = 'Total skin sparing mastectomy';
        insert pro;
        
        pro = new Procedure__c();
        pro.On_Study_Pathology_Form__c = ospobject.Id;
        pro.Procedure_Name__c = 'Modified radical mastectomy';
        insert pro;
        
        pro = new Procedure__c();
        pro.On_Study_Pathology_Form__c = ospobject.Id;
        pro.Procedure_Name__c = 'Core biopsy (lymph node)';
        pro.Mammography__c = true;
        pro.MRI__c = true;
        pro.Ultrasound__c = true;
        pro.Stereotactic__c = true;
        pro.Palpation_guided__c = true;
        insert pro;
        
        Procedure__c pro1 = new Procedure__c();
        pro1.On_Study_Pathology_Form__c = ospobject.Id;
        pro1.Procedure_Name__c = 'Sentinel lymph node dissection';
        insert pro1;
        
        Procedure__c proObject = new Procedure__c();
        proObject.Procedure_Name__c = 'Lung';
        proObject.On_Study_Pathology_Form__c = ospobject.Id;
        proObject.Post_Surgery_Summary__c = postObject.Id;
        proObject.Form_Name__c = 'On-Study Pathology Form(Lymph Node Biopsies)';
        insert proObject;
        
        Receptors__c  rec = new Receptors__c ();
        rec.On_Study_Pathology_Form__c  = ospobject.id;
        rec.Progesterone_Receptor_Status__c = 'Negative';
        rec.Estrogen_Receptor_Status__c = 'Positive';
        rec.Total_Score_ER__c = 0.5;
        rec.Total_Score_PR__c = 1;
        rec.IHC__c = 'Positive';
        rec.Fish__c = 'Negative';
        insert rec;
        
        Set<id> ospIds = new Set<id>();
        ospIds.add(ospobject.Id);
        
        SnomedCTCode sno = new SnomedCTCode();
        SnomedCTCode.insertOnStudyPathologyCode(ospIds);
        
        ospIds.clear();
        ospobject = new On_Study_Pathology_Form__c();
        ospobject.status__c = 'Accepted';
        insert ospobject;
        ospIds.add(ospobject.Id);
       SnomedCTCode.insertOnStudyPathologyCode(ospIds);
        //==============================FINISHED==================================================
        
    }
    
    
    
    @isTest static void myUnitTest11() { // method "insertRandomizationCode" and "insertChemoTherapyRegimenCode"
        
        //====================== method "insertRandomizationCode"================================
        
        Code_Master__c snomedObject = new Code_Master__c();
        snomedObject.Variable_Description__c = 'test';
        snomedObject.IsReportColumn__c = true;
        snomedObject.Display_Order__c = 3.0;
        snomedObject.Name = 'Randomized';
        insert snomedObject;
        
        snomedObject = new Code_Master__c();
        snomedObject.Variable_Description__c = 'test';
        snomedObject.IsReportColumn__c = true;
        snomedObject.Display_Order__c = 3.0;
        snomedObject.Name = 'ChemoCat';
        insert snomedObject;
        
        /*Snomed_Code__c snomed = new Snomed_Code__c();
        snomed.Code_Master__c = snomedObject.Id;
        insert snomed;
        
        Code_Master__c snomedObject1 = new Code_Master__c();
        snomedObject1.Variable_Description__c = 'test';
        snomedObject1.IsReportColumn__c = true;
        snomedObject1.Display_Order__c = 3.0;
        snomedObject1.Name = 'Her2status_PS';
        insert snomedObject1;
        
        Snomed_Code__c snomed1 = new Snomed_Code__c();
        snomed1.Code_Master__c = snomedObject1.Id;
        insert snomed1;*/
        
        Randomization_Form__c rfcObject = new Randomization_Form__c();
        rfcObject.Randomization_Result__c = 'Paclitaxel';
        rfcObject.Did_Patient_Sign_Treatment_Consent_Form__c = true;
        rfcObject.Status__c = 'Approval Not Required';
        insert rfcObject;
        
        rfcObject = new Randomization_Form__c();
        rfcObject.Why_Patient_Not_Signed_Consent_Form__c = 'Patient found to be ineligible for the study';
        rfcObject.Did_Patient_Sign_Treatment_Consent_Form__c = true;
        rfcObject.Status__c = 'Approval Not Required';
        insert rfcObject;
        
        Set<id> randIds = new Set<id>();
        randIds.add(rfcObject.Id);
        
       SnomedCTCode.insertRandomizationCode(randIds);
    }
    
    @isTest static void myUnitTest111() { // method "insertRandomizationCode" and "insertChemoTherapyRegimenCode"
        
        //====================== method "insertRandomizationCode"================================
        
        Code_Master__c snomedObject = new Code_Master__c();
        snomedObject.Variable_Description__c = 'test';
        snomedObject.IsReportColumn__c = true;
        snomedObject.Display_Order__c = 3.0;
        snomedObject.Name = 'Randomized';
        insert snomedObject;
        
        snomedObject = new Code_Master__c();
        snomedObject.Variable_Description__c = 'test';
        snomedObject.IsReportColumn__c = true;
        snomedObject.Display_Order__c = 3.0;
        snomedObject.Name = 'ChemoCat';
        insert snomedObject;
        
        Randomization_Form__c rfcObject = new Randomization_Form__c();
        rfcObject.Randomization_Result__c = 'Paclitaxel';
        rfcObject.Did_Patient_Sign_Treatment_Consent_Form__c = true;
        rfcObject.Status__c = 'Approval Not Required';
        insert rfcObject;
        
        rfcObject = new Randomization_Form__c();
        rfcObject.Randomization_Result__c = 'Paclitaxel + Trastuzumab';
        rfcObject.Did_Patient_Sign_Treatment_Consent_Form__c = true;
        rfcObject.Status__c = 'Approval Not Required';
        insert rfcObject;
        
        rfcObject = new Randomization_Form__c();
        rfcObject.Randomization_Result__c = 'Paclitaxel + Neratinib';
        rfcObject.Did_Patient_Sign_Treatment_Consent_Form__c = true;
        rfcObject.Status__c = 'Approval Not Required';
        insert rfcObject;
        
        rfcObject = new Randomization_Form__c();
        rfcObject.Randomization_Result__c = 'Paclitaxel + ABT-888 + Carboplatin';
        rfcObject.Did_Patient_Sign_Treatment_Consent_Form__c = true;
        rfcObject.Status__c = 'Approval Not Required';
        insert rfcObject;
        
        rfcObject = new Randomization_Form__c();
        rfcObject.Why_Patient_Not_Signed_Consent_Form__c = 'Patient found to be ineligible for the study';
        rfcObject.Did_Patient_Sign_Treatment_Consent_Form__c = true;
        rfcObject.Status__c = 'Approval Not Required';
        insert rfcObject;
        
        Set<id> randIds = new Set<id>();
        randIds.add(rfcObject.Id);
        
        SnomedCTCode.insertRandomizationCode(randIds);
    }
    
    @isTest static void myUnitTest11a() {
        
        Code_Master__c snomedObject = new Code_Master__c();
        snomedObject.Variable_Description__c = 'test';
        snomedObject.IsReportColumn__c = true;
        snomedObject.Display_Order__c = 3.0;
        snomedObject.Name = 'Randomized';
        insert snomedObject;
        
        snomedObject = new Code_Master__c();
        snomedObject.Variable_Description__c = 'test';
        snomedObject.IsReportColumn__c = true;
        snomedObject.Display_Order__c = 3.0;
        snomedObject.Name = 'ChemoCat';
        insert snomedObject;
        
        Set<id> randIds = new Set<id>();
 
        List<Account> lstAccount = [Select a.Id From Account a limit 1]; 
        Account acc = lstAccount[0];
        
        Patient_Custom__c pc = new Patient_Custom__c();
        pc.Last_Name__c = 'test1';
        pc.Gender__c = 'Male';
        pc.Birthdate__c = date.newInstance(1986, 8, 9);
        pc.Race__c = 'White';
        pc.Ethnicity__c = 'Not Hispanic or Latino';
        pc.Institution__c = acc.Id;
        insert pc;
        
        TrialPatient__c tpObject = new TrialPatient__c();
        tpObject.Patient_Id__c = pc.Id;
        insert tpObject;
        
        Randomization_Form__c rfcObject1 = new Randomization_Form__c();
        rfcObject1.Did_Patient_Sign_Treatment_Consent_Form__c = true;
        rfcObject1.Status__c = 'Approval Not Required';
        rfcObject1.Randomization_Result__c = 'Paclitaxel + AMG386';
        rfcObject1.TrialPatient__c = tpObject.Id;
        insert rfcObject1;
        
        rfcObject1 = new Randomization_Form__c();
        rfcObject1.Did_Patient_Sign_Treatment_Consent_Form__c = true;
        rfcObject1.Status__c = 'Approval Not Required';
        rfcObject1.Randomization_Result__c = 'Paclitaxel + Ganitumab';
        rfcObject1.TrialPatient__c = tpObject.Id;
        insert rfcObject1;
        
        rfcObject1 = new Randomization_Form__c();
        rfcObject1.Why_Patient_Not_Signed_Consent_Form__c = 'Decided not to have neoadjuvant chemotherapy';
        rfcObject1.Did_Patient_Sign_Treatment_Consent_Form__c = false;
        rfcObject1.Status__c = 'Approval Not Required';
        rfcObject1.Randomization_Result__c = 'dsd';
        rfcObject1.TrialPatient__c = tpObject.Id;
        insert rfcObject1;
        randIds.add(rfcObject1.Id);
        SnomedCTCode.insertRandomizationCode(randIds);
    }
    @isTest static void myUnitTest11a1() {
        
        Code_Master__c snomedObject = new Code_Master__c();
        snomedObject.Variable_Description__c = 'test';
        snomedObject.IsReportColumn__c = true;
        snomedObject.Display_Order__c = 3.0;
        snomedObject.Name = 'Randomized';
        insert snomedObject;
        
        snomedObject = new Code_Master__c();
        snomedObject.Variable_Description__c = 'test';
        snomedObject.IsReportColumn__c = true;
        snomedObject.Display_Order__c = 3.0;
        snomedObject.Name = 'ChemoCat';
        insert snomedObject;
        
        Set<id> randIds = new Set<id>();
 
        List<Account> lstAccount = [Select a.Id From Account a limit 1]; 
        Account acc = lstAccount[0];
        
        Patient_Custom__c pc = new Patient_Custom__c();
        pc.Last_Name__c = 'test1';
        pc.Gender__c = 'Male';
        pc.Birthdate__c = date.newInstance(1986, 8, 9);
        pc.Race__c = 'White';
        pc.Ethnicity__c = 'Not Hispanic or Latino';
        pc.Institution__c = acc.Id;
        insert pc;
        
        TrialPatient__c tpObject = new TrialPatient__c();
        tpObject.Patient_Id__c = pc.Id;
        insert tpObject;
        
        Randomization_Form__c rfcObject1 = new Randomization_Form__c();
        rfcObject1.Did_Patient_Sign_Treatment_Consent_Form__c = true;
        rfcObject1.Status__c = 'Approval Not Required';
        rfcObject1.Randomization_Result__c = 'Paclitaxel + MK-2206';
        rfcObject1.TrialPatient__c = tpObject.Id;
        insert rfcObject1;
        
        rfcObject1 = new Randomization_Form__c();
        rfcObject1.Did_Patient_Sign_Treatment_Consent_Form__c = true;
        rfcObject1.Status__c = 'Approval Not Required';
        rfcObject1.Randomization_Result__c = 'Paclitaxel + MK-2206 + Trastuzumab';
        rfcObject1.TrialPatient__c = tpObject.Id;
        insert rfcObject1;
        
        rfcObject1 = new Randomization_Form__c();
        rfcObject1.Why_Patient_Not_Signed_Consent_Form__c = 'Decided not to have neoadjuvant chemotherapy';
        rfcObject1.Did_Patient_Sign_Treatment_Consent_Form__c = false;
        rfcObject1.Status__c = 'Approval Not Required';
        rfcObject1.Randomization_Result__c = 'dsd';
        rfcObject1.TrialPatient__c = tpObject.Id;
        insert rfcObject1;
        randIds.add(rfcObject1.Id);
        SnomedCTCode.insertRandomizationCode(randIds);
    }
    
    @isTest static void myUnitTest11b() {
        Code_Master__c snomedObject = new Code_Master__c();
        snomedObject.Variable_Description__c = 'test';
        snomedObject.IsReportColumn__c = true;
        snomedObject.Display_Order__c = 3.0;
        snomedObject.Name = 'Randomized';
        insert snomedObject;
        
        List<Account> lstAccount = [Select a.Id From Account a limit 1]; 
        Account acc = lstAccount[0];
        
        Set<id> randIds = new Set<id>();
        Patient_Custom__c pc = new Patient_Custom__c();
        pc.Last_Name__c = 'test1';
        pc.Gender__c = 'Male';
        pc.Birthdate__c = date.newInstance(1986, 8, 9);
        pc.Race__c = 'White';
        pc.Ethnicity__c = 'Not Hispanic or Latino';
        pc.Institution__c = acc.Id;
        insert pc;
        
        TrialPatient__c tpObject = new TrialPatient__c();
        tpObject.Patient_Id__c = pc.Id;
        insert tpObject;
        
        Randomization_Form__c rfcObject2 = new Randomization_Form__c();
        rfcObject2.Why_Patient_Not_Signed_Consent_Form__c = 'Decided not to be treated with a novel agent';
        rfcObject2.Did_Patient_Sign_Treatment_Consent_Form__c = false;
        rfcObject2.Status__c = 'Approval Not Required';
        rfcObject2.TrialPatient__c = tpObject.id;
        rfcObject2.Randomization_Result__c = 'Not Randomized';
        insert rfcObject2;
        randIds.add(rfcObject2.Id);
        SnomedCTCode.insertRandomizationCode(randIds);
    }
    
    @isTest static void myUnitTest11c() {
        
        Code_Master__c snomedObject = new Code_Master__c();
        snomedObject.Variable_Description__c = 'test';
        snomedObject.IsReportColumn__c = true;
        snomedObject.Display_Order__c = 3.0;
        snomedObject.Name = 'Randomized';
        insert snomedObject;
        
        List<Account> lstAccount = [Select a.Id From Account a limit 1]; 
        Account acc = lstAccount[0];
        
        Set<id> randIds = new Set<id>();
        Patient_Custom__c pc = new Patient_Custom__c();
        pc.Last_Name__c = 'test1';
        pc.Gender__c = 'Male';
        pc.Birthdate__c = date.newInstance(1986, 8, 9);
        pc.Race__c = 'White';
        pc.Ethnicity__c = 'Not Hispanic or Latino';
        pc.Institution__c = acc.Id;
        insert pc;
        
        TrialPatient__c tpObject = new TrialPatient__c();
        tpObject.Patient_Id__c = pc.Id;
        insert tpObject;
        
        Randomization_Form__c rfcObject3 = new Randomization_Form__c();
        rfcObject3.Why_Patient_Not_Signed_Consent_Form__c = 'Patient found to be ineligible for the study';
        rfcObject3.Did_Patient_Sign_Treatment_Consent_Form__c = false;
        rfcObject3.Status__c = 'Approval Not Required';
        rfcObject3.TrialPatient__c = tpObject.id;
        rfcObject3.Randomization_Result__c = 'Not Randomized';
        insert rfcObject3;

        randIds.add(rfcObject3.Id);
        SnomedCTCode.insertRandomizationCode(randIds);
    }
    
    @isTest static void myUnitTest11d() {
        
        Code_Master__c snomedObject = new Code_Master__c();
        snomedObject.Variable_Description__c = 'test';
        snomedObject.IsReportColumn__c = true;
        snomedObject.Display_Order__c = 3.0;
        snomedObject.Name = 'Randomized';
        insert snomedObject;
        
        List<Account> lstAccount = [Select a.Id From Account a limit 1]; 
        Account acc = lstAccount[0];
        
        Set<id> randIds = new Set<id>();
        Patient_Custom__c pc = new Patient_Custom__c();
        pc.Last_Name__c = 'test1';
        pc.Gender__c = 'Male';
        pc.Birthdate__c = date.newInstance(1986, 8, 9);
        pc.Race__c = 'White';
        pc.Ethnicity__c = 'Not Hispanic or Latino';
        pc.Institution__c = acc.Id;
        insert pc;
        
        TrialPatient__c tpObject = new TrialPatient__c();
        tpObject.Patient_Id__c = pc.Id;
        insert tpObject;
        
        Randomization_Form__c rfcObject4 = new Randomization_Form__c();
        rfcObject4.Why_Patient_Not_Signed_Consent_Form__c = 'Patient found to be ineligible because they are MammaPrint Low, ER Positive, HER2 Negative';
        rfcObject4.Did_Patient_Sign_Treatment_Consent_Form__c = false;
        rfcObject4.Status__c = 'Approval Not Required';
        rfcObject4.TrialPatient__c = tpObject.id;
        rfcObject4.Randomization_Result__c = 'Not Randomized';
        insert rfcObject4;
        
        randIds.add(rfcObject4.Id);
        SnomedCTCode.insertRandomizationCode(randIds);
    }
    
    @isTest static void myUnitTest11e() {
        
        Code_Master__c snomedObject = new Code_Master__c();
        snomedObject.Variable_Description__c = 'test';
        snomedObject.IsReportColumn__c = true;
        snomedObject.Display_Order__c = 3.0;
        snomedObject.Name = 'Randomized';
        insert snomedObject;
        
        List<Account> lstAccount = [Select a.Id From Account a limit 1]; 
        Account acc = lstAccount[0];
        
        Set<id> randIds = new Set<id>();
        Patient_Custom__c pc = new Patient_Custom__c();
        pc.Last_Name__c = 'test1';
        pc.Gender__c = 'Male';
        pc.Birthdate__c = date.newInstance(1986, 8, 9);
        pc.Race__c = 'White';
        pc.Ethnicity__c = 'Not Hispanic or Latino';
        pc.Institution__c = acc.Id;
        insert pc;
        
        TrialPatient__c tpObject = new TrialPatient__c();
        tpObject.Patient_Id__c = pc.Id;
        insert tpObject;
        
        Randomization_Form__c rfcObject5 = new Randomization_Form__c();
        rfcObject5.Why_Patient_Not_Signed_Consent_Form__c = 'Patient found to be ineligible because inability to complete MammaPrint Test';
        rfcObject5.Did_Patient_Sign_Treatment_Consent_Form__c = false;
        rfcObject5.Status__c = 'Approval Not Required';
        rfcObject5.TrialPatient__c = tpObject.id;
        rfcObject5.Randomization_Result__c = 'Not Randomized';
        insert rfcObject5;
        
        randIds.add(rfcObject5.Id);
        SnomedCTCode.insertRandomizationCode(randIds);
    }
    
    @isTest static void myUnitTest11f() {
        
        Code_Master__c snomedObject = new Code_Master__c();
        snomedObject.Variable_Description__c = 'test';
        snomedObject.IsReportColumn__c = true;
        snomedObject.Display_Order__c = 3.0;
        snomedObject.Name = 'Randomized';
        insert snomedObject;
        
        List<Account> lstAccount = [Select a.Id From Account a limit 1]; 
        Account acc = lstAccount[0];
        
        Set<id> randIds = new Set<id>();
        Patient_Custom__c pc = new Patient_Custom__c();
        pc.Last_Name__c = 'test1';
        pc.Gender__c = 'Male';
        pc.Birthdate__c = date.newInstance(1986, 8, 9);
        pc.Race__c = 'White';
        pc.Ethnicity__c = 'Not Hispanic or Latino';
        pc.Institution__c = acc.Id;
        insert pc;
        
        TrialPatient__c tpObject = new TrialPatient__c();
        tpObject.Patient_Id__c = pc.Id;
        insert tpObject;
        
        Randomization_Form__c rfcObject6 = new Randomization_Form__c();
        rfcObject6.Why_Patient_Not_Signed_Consent_Form__c = 'Patient found to be ineligible because they did not meet other eligibility criteria';
        rfcObject6.Did_Patient_Sign_Treatment_Consent_Form__c = false;
        rfcObject6.Status__c = 'Approval Not Required';
        rfcObject6.TrialPatient__c = tpObject.id;
        rfcObject6.Randomization_Result__c = 'Not Randomized';
        insert rfcObject6;
        
        randIds.add(rfcObject6.Id);
        SnomedCTCode.insertRandomizationCode(randIds);
    }
    
    @isTest static void myUnitTest11g() {
        
        Code_Master__c snomedObject = new Code_Master__c();
        snomedObject.Variable_Description__c = 'test';
        snomedObject.IsReportColumn__c = true;
        snomedObject.Display_Order__c = 3.0;
        snomedObject.Name = 'Randomized';
        insert snomedObject;
        
        List<Account> lstAccount = [Select a.Id From Account a limit 1]; 
        Account acc = lstAccount[0];
        
        Set<id> randIds = new Set<id>();
        Patient_Custom__c pc = new Patient_Custom__c();
        pc.Last_Name__c = 'test1';
        pc.Gender__c = 'Male';
        pc.Birthdate__c = date.newInstance(1986, 8, 9);
        pc.Race__c = 'White';
        pc.Ethnicity__c = 'Not Hispanic or Latino';
        pc.Institution__c = acc.Id;
        insert pc;
        
        TrialPatient__c tpObject = new TrialPatient__c();
        tpObject.Patient_Id__c = pc.Id;
        insert tpObject;
        
        Randomization_Form__c rfcObject7 = new Randomization_Form__c();
        rfcObject7.Why_Patient_Not_Signed_Consent_Form__c = 'Patient found to be ineligible because patient could not complete MRI';
        rfcObject7.Did_Patient_Sign_Treatment_Consent_Form__c = false;
        rfcObject7.Status__c = 'Approval Not Required';
        rfcObject7.TrialPatient__c = tpObject.id;
        rfcObject7.Randomization_Result__c = 'Not Randomized';
        insert rfcObject7;
        
        randIds.add(rfcObject7.Id);
        SnomedCTCode.insertRandomizationCode(randIds);
    }
    
    @isTest static void myUnitTest11h() {
        
        Code_Master__c snomedObject = new Code_Master__c();
        snomedObject.Variable_Description__c = 'test';
        snomedObject.IsReportColumn__c = true;
        snomedObject.Display_Order__c = 3.0;
        snomedObject.Name = 'Randomized';
        insert snomedObject;
        
        List<Account> lstAccount = [Select a.Id From Account a limit 1]; 
        Account acc = lstAccount[0];
        
        Set<id> randIds = new Set<id>();
        Patient_Custom__c pc = new Patient_Custom__c();
        pc.Last_Name__c = 'test1';
        pc.Gender__c = 'Male';
        pc.Birthdate__c = date.newInstance(1986, 8, 9);
        pc.Race__c = 'White';
        pc.Ethnicity__c = 'Not Hispanic or Latino';
        pc.Institution__c = acc.Id;
        insert pc;
        
        TrialPatient__c tpObject = new TrialPatient__c();
        tpObject.Patient_Id__c = pc.Id;
        insert tpObject;
        
        Randomization_Form__c rfcObject8 = new Randomization_Form__c();
        rfcObject8.Why_Patient_Not_Signed_Consent_Form__c = 'Patient found to be ineligible because patient could not complete core biopsy';
        rfcObject8.Did_Patient_Sign_Treatment_Consent_Form__c = false;
        rfcObject8.Status__c = 'Approval Not Required';
        rfcObject8.TrialPatient__c = tpObject.id;
        rfcObject8.Randomization_Result__c = 'Not Randomized';
        insert rfcObject8;
        
        randIds.add(rfcObject8.Id);
        SnomedCTCode.insertRandomizationCode(randIds);
    }
    
    @isTest static void myUnitTest11i() {
        
        Code_Master__c snomedObject = new Code_Master__c();
        snomedObject.Variable_Description__c = 'test';
        snomedObject.IsReportColumn__c = true;
        snomedObject.Display_Order__c = 3.0;
        snomedObject.Name = 'Randomized';
        insert snomedObject;
        
        List<Account> lstAccount = [Select a.Id From Account a limit 1]; 
        Account acc = lstAccount[0];
        
        Set<id> randIds = new Set<id>();
        Patient_Custom__c pc = new Patient_Custom__c();
        pc.Last_Name__c = 'test1';
        pc.Gender__c = 'Male';
        pc.Birthdate__c = date.newInstance(1986, 8, 9);
        pc.Race__c = 'White';
        pc.Ethnicity__c = 'Not Hispanic or Latino';
        pc.Institution__c = acc.Id;
        insert pc;
        
        TrialPatient__c tpObject = new TrialPatient__c();
        tpObject.Patient_Id__c = pc.Id;
        insert tpObject;
        
        Randomization_Form__c rfcObject9 = new Randomization_Form__c();
        rfcObject9.Why_Patient_Not_Signed_Consent_Form__c = 'Other';
        rfcObject9.Did_Patient_Sign_Treatment_Consent_Form__c = false;
        rfcObject9.Status__c = 'Approval Not Required';
        rfcObject9.TrialPatient__c = tpObject.id;
        rfcObject9.Randomization_Result__c = 'Not Randomized';
        insert rfcObject9;
        
        randIds.add(rfcObject9.Id);
        SnomedCTCode.insertRandomizationCode(randIds);
    }
    
    @isTest static void myUnitTest12() { // method "SnomedCodeNew" 
        
        Code_Master__c snomedObject = new Code_Master__c();
        snomedObject.Variable_Description__c = 'test';
        snomedObject.IsReportColumn__c = true;
        snomedObject.Display_Order__c = 3.0;
        snomedObject.Name = 'SurvStat';
        insert snomedObject;
        
        snomedObject = new Code_Master__c();
        snomedObject.Variable_Description__c = 'test';
        snomedObject.IsReportColumn__c = true;
        snomedObject.Display_Order__c = 3.0;
        snomedObject.Name = 'SurvStatD';
        insert snomedObject;
        
        snomedObject = new Code_Master__c();
        snomedObject.Variable_Description__c = 'test';
        snomedObject.IsReportColumn__c = true;
        snomedObject.Display_Order__c = 3.0;
        snomedObject.Name = 'RFS_ind';
        insert snomedObject;
        
        snomedObject = new Code_Master__c();
        snomedObject.Variable_Description__c = 'test';
        snomedObject.IsReportColumn__c = true;
        snomedObject.Display_Order__c = 3.0;
        snomedObject.Name = 'LocalProgress';
        insert snomedObject;
        
        snomedObject = new Code_Master__c();
        snomedObject.Variable_Description__c = 'test';
        snomedObject.IsReportColumn__c = true;
        snomedObject.Display_Order__c = 3.0;
        snomedObject.Name = 'LocalProgSite';
        insert snomedObject;
        
        snomedObject = new Code_Master__c();
        snomedObject.Variable_Description__c = 'test';
        snomedObject.IsReportColumn__c = true;
        snomedObject.Display_Order__c = 3.0;
        snomedObject.Name = 'DistProgSite';
        insert snomedObject;
        
        snomedObject = new Code_Master__c();
        snomedObject.Variable_Description__c = 'test';
        snomedObject.IsReportColumn__c = true;
        snomedObject.Display_Order__c = 3.0;
        snomedObject.Name = 'LocalProgSite';
        insert snomedObject;
        
        Snomed_Code__c snomed = new Snomed_Code__c();
        snomed.Code_Master__c = snomedObject.Id;
        insert snomed;
        
        Account acc = new Account();
        
        List<Account> lstAccount = [Select a.Id From Account a limit 1]; 
        
        if(!lstAccount.isEmpty()){
                
        acc = lstAccount[0];           
        
        Patient_Custom__c pc = new Patient_Custom__c();
        pc.Last_Name__c = 'test1';
        pc.Gender__c = 'Male';
        pc.Birthdate__c = date.newInstance(1986, 8, 9);
        pc.Race__c = 'White';
        pc.Ethnicity__c = 'Not Hispanic or Latino';
        pc.Institution__c = acc.Id;
        insert pc;
        
        TrialPatient__c tpObject = new TrialPatient__c();
        tpObject.Patient_Id__c = pc.Id;
        insert tpObject;
        
        Post_Surgaory_Summary__c postObject = new Post_Surgaory_Summary__c();
        postObject.Type_Of_Tumor__c = 'Single Discrete Mass';
        postObject.TrialPatient__c = tpObject.Id;
        postObject.Date_Of_Procedure__c = date.newInstance(2009, 8, 7);
        insert postObject;
        
        Set<Id> foIds = new Set<Id>();
        Followup_Form__c followObject = new Followup_Form__c(); //patient_diagnosed_local_progression__c
        followObject.patient_diagnosed_local_progression__c = true;
        followObject.patient_diagnosed_distant_progression__c = true;
        followObject.TrialPatient__c = tpObject.Id;
        followObject.Distant__c = 'Lung';
        followObject.Local__c = 'Axillary Nodes';
        followObject.Local_progression_Date__c = date.newInstance(2009, 8, 7);
        followObject.Distant_progression_Date__c = date.newInstance(2009, 7, 7);
        followObject.Status__c = 'Accepted';
        insert followObject;
        foIds.add(followObject.Id);
        
        followObject = new Followup_Form__c(); //patient_diagnosed_local_progression__c
        followObject.patient_diagnosed_local_progression__c = true;
        followObject.patient_diagnosed_distant_progression__c = true;
        followObject.TrialPatient__c = tpObject.Id;
        followObject.Distant__c = 'Lung';
        followObject.Local__c = 'Axillary Nodes';
        followObject.Local_progression_Date__c = date.newInstance(2009, 8, 7);
        followObject.Distant_progression_Date__c = date.newInstance(2009, 7, 7);
        followObject.Status__c = 'Accepted';
        followObject.Patient_received_adjuvant_therapy__c=true;
        insert followObject;
        foIds.add(followObject.Id);
        
        followObject = new Followup_Form__c(); //patient_diagnosed_local_progression__c
        followObject.patient_diagnosed_local_progression__c = true;
        followObject.patient_diagnosed_distant_progression__c = true;
        followObject.TrialPatient__c = tpObject.Id;
        followObject.Distant__c = 'Lung';
        followObject.Local__c = 'Axillary Nodes';
        followObject.Local_progression_Date__c = date.newInstance(2009, 8, 7);
        followObject.Distant_progression_Date__c = date.newInstance(2009, 7, 7);
        followObject.Status__c = 'Accepted';
        followObject.Patient_received_adjuvant_therapy__c=true;
        followObject.Survival_Status__c = 'Alive';
        followObject.End_Date__c = Date.newInstance(2011,1,1);
        insert followObject;
        foIds.add(followObject.Id);
        
        //SnomedCTCode sno = new SnomedCTCode();
        //SnomedCTCode.SnomedCodeNew('IHTSDO_4598', '', followObject);
        //SnomedCTCode.SnomedCodeNew('IHTSDO_4600', '', followObject);
        //SnomedCTCode.SnomedCodeNew('IHTSDO_4597', '', followObject);
        SnomedCTCode.insertSnomedCodeForFollowup(foIds);
    }
  }
  
  @isTest static void myUnitTest13() { 
        
        Code_Master__c snomedObject = new Code_Master__c();
        snomedObject.Variable_Description__c = 'test';
        snomedObject.IsReportColumn__c = true;
        snomedObject.Display_Order__c = 3.0;
        snomedObject.Name = 'SurvDateD';
        insert snomedObject;
        
        snomedObject = new Code_Master__c();
        snomedObject.Variable_Description__c = 'test';
        snomedObject.IsReportColumn__c = true;
        snomedObject.Display_Order__c = 3.0;
        snomedObject.Name = 'OffStudy';
        insert snomedObject;
        
        Account acc = new Account();
        acc.Name = 'test';
        insert acc;
        
        Patient_Custom__c pc = new Patient_Custom__c();
        pc.Last_Name__c = 'test1';
        pc.Gender__c = 'Male';
        pc.Birthdate__c = date.newInstance(1986, 8, 9);
        pc.Race__c = 'White';
        pc.Ethnicity__c = 'Not Hispanic or Latino';
        pc.Institution__c = acc.Id;
        insert pc;
        
        TrialPatient__c tpObject = new TrialPatient__c();
        tpObject.Patient_Id__c = pc.Id;
        insert tpObject;
        
        Snomed_Code__c snomed = new Snomed_Code__c();
        snomed.Code_Master__c = snomedObject.Id;
        snomed.TrialPatient__c = tpObject.Id;
        insert snomed;
        
        Set<id> offStudyIds = new Set<id>();
        Off_Study_Detail__c offStudyObj = new Off_Study_Detail__c();
        offStudyObj.TrialPatient__c = tpObject.Id;
        offStudyObj.Patient_completed_study_per_protocol__c = true;
        insert offStudyObj;
        offStudyIds.add(offStudyObj.Id);
        
        
        Off_Study_Detail__c offStudyObj1 = new Off_Study_Detail__c();
        offStudyObj1.TrialPatient__c = tpObject.Id;
        offStudyObj1.Patient_completed_study_per_protocol__c = false;
        offStudyObj1.Patient_did_not_want_to_complete_MRI__c = true;
        offStudyObj1.Why_patient_didnt_continue_treatment_arm__c = 'Other';
        insert offStudyObj1;
        offStudyIds.add(offStudyObj1.Id);
        
        Off_Study_Detail__c offStudyObj2 = new Off_Study_Detail__c();
        offStudyObj2.TrialPatient__c = tpObject.Id;
        offStudyObj2.Patient_completed_study_per_protocol__c = false;
        offStudyObj2.Patient_did_not_want_to_complete_MRI__c = false;
        offStudyObj2.Patient_did_nt_want_to_complete_core_bio__c = true;
        offStudyObj2.Why_patient_didnt_continue_treatment_arm__c = 'Personal Preference';
        insert offStudyObj2;
        offStudyIds.add(offStudyObj2.Id);
        
        Off_Study_Detail__c offStudyObj3 = new Off_Study_Detail__c();
        offStudyObj3.TrialPatient__c = tpObject.Id;
        offStudyObj3.Patient_completed_study_per_protocol__c = false;
        offStudyObj3.Patient_did_not_want_to_complete_MRI__c = false;
        offStudyObj3.Patient_did_nt_want_to_complete_core_bio__c = false;
        offStudyObj3.Patient_did_nt_continue_on_treatment_arm__c = true;
        offStudyObj3.Why_patient_didnt_continue_treatment_arm__c = 'Due to (S)AE';
        offStudyObj3.Patient_Died__c = true;
        offStudyObj3.Patient_did_not_have_surgery__c = true;
        insert offStudyObj3;
        offStudyIds.add(offStudyObj3.Id);
        
        offStudyObj3 = new Off_Study_Detail__c();
        offStudyObj3.TrialPatient__c = tpObject.Id;
        offStudyObj3.Patient_completed_study_per_protocol__c = false;
        offStudyObj3.Patient_did_not_want_to_complete_MRI__c = false;
        offStudyObj3.Patient_did_nt_want_to_complete_core_bio__c = false;
        offStudyObj3.Patient_did_nt_continue_on_treatment_arm__c = true;
        offStudyObj3.Why_patient_didnt_continue_treatment_arm__c = 'Personal Preference';
        offStudyObj3.Patient_Died__c = true;
        offStudyObj3.Patient_did_not_have_surgery__c = true;
        insert offStudyObj3;
        offStudyIds.add(offStudyObj3.Id);
        
        
        
        SnomedCTCode sno = new SnomedCTCode();
        SnomedCTCode.insertOffstudyRelatedCode(offStudyIds);
        
    }
    
    @isTest static void testDummyMethod() {
        SnomedCTCode.dummyMethod();
        SnomedCTCode.dummyMethod1();
        SnomedCTCode.dummyMethod2();
        SnomedCTCode.dummyMethod3();
        SnomedCTCode.dummyMethod4();
    }
    
    
    
    @isTest static void myUnitTest16() { 
        Account acc = new Account();
        acc.Name = 'test';
        insert acc;
        
        
         Code_Master__c snomedObject = new Code_Master__c();
        snomedObject.Variable_Description__c = 'test';
        snomedObject.IsReportColumn__c = true;
        snomedObject.Display_Order__c = 3.0;
        snomedObject.Name = 'SurvDateD';
        insert snomedObject;
        
          Patient_Custom__c pc = new Patient_Custom__c();
        pc.Last_Name__c = 'test1';
        pc.Gender__c = 'Male';
        pc.Birthdate__c = date.newInstance(1986, 8, 9);
        pc.Race__c = 'White';
        pc.Ethnicity__c = 'Not Hispanic or Latino';
        pc.Institution__c = acc.Id;
        insert pc;
        
        TrialPatient__c tpObject = new TrialPatient__c();
        tpObject.Patient_Id__c = pc.Id;
        insert tpObject;
        
        Snomed_Code__c snomed = new Snomed_Code__c();
        snomed.Code_Master__c = snomedObject.Id;
        snomed.TrialPatient__c = tpObject.Id;
        insert snomed;
        
        Post_Surgaory_Summary__c postObject1 = new Post_Surgaory_Summary__c();
        postObject1.Type_Of_Tumor__c = 'Single Discrete Mass';
        postObject1.RCB_Class__c = 'I';
        postObject1.Is_DCIS_Present__c = 'No';
        postObject1.TrialPatient__c = tpObject.Id;
        postObject1.Is_invasive_tumor_present__c = 'Yes';
        postObject1.status__c = 'Accepted';
        insert postObject1;
        
        Invasive_Tumor_Detail__c inv = new Invasive_Tumor_Detail__c();
        inv.Post_Surgery_Summary__c  = postObject1.id;
        inv.Invasive_ductal_carcinoma_nos__c = true;
        inv.Invasive_lobular_carcinoma_classic_type__c = true;
        inv.Invasive_lobular_carcinoma_alveolar_type__c = true;
        inv.Pleomorphic_lobular_carcinoma__c = true;
        inv.Tubulolobular_carcinoma__c = true;
        inv.Invasive_carcinoma_mixed_ductal_lobular__c = true;
        inv.Tubular_carcinoma__c = true;
        inv.Mucinous_carcinoma__c = true;
        inv.Medullary_carcinoma__c = true;
        inv.Invasive_papillary_carcinoma__c = true;
        inv.Invasive_cribiform_carcinoma__c = true;
        inv.Multi_focal_Tumor__c = 'Yes'; 
        insert inv;
        
         DCIS__c dcis = new DCIS__c();
        dcis.Post_Surgery_Summary__c = postObject1.Id;
        dcis.Punctate_necrosis__c = true;
        dcis.Comedonecrosis__c = true;
        dcis.Papillary__c = true;
        dcis.Micropapillary__c = true;
        dcis.Necrosis__c = true;
        dcis.Cribiform__c = true;
        dcis.Cruciform__c = true;
        dcis.Clinging__c = true;
        dcis.Solid__c = true;
        dcis.Apocrine__c = true;
        dcis.Intra_cystic_encysted_papillary__c = true;
        dcis.Other__c = true;
        insert dcis;
        
        
        
        On_Study_Pathology_Form__c ospobject=[Select id from On_Study_Pathology_Form__c where status__c = 'Accepted' limit 1];
        
        Procedure__c pro1 = new Procedure__c();
        pro1.On_Study_Pathology_Form__c = ospobject.Id;
        pro1.Procedure_Name__c = 'Sentinel lymph node dissection';
        insert pro1;
      
        //SnomedCTCode.histologySnomed(dcis,inv,pro1,postObject1,snomed);
        
    }
    
    
    
    
    
    
    
}