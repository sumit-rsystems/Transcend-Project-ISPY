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
@isTest
private class TestCdapackage {

    @isTest static void myUnitTest1() {
        cdapackage cda = new cdapackage();
        cdapackage.generateConsentCDAResponse a = new cdapackage.generateConsentCDAResponse();
        a.return_x='';
        cdapackage.generatePatientCDAResponse b = new cdapackage.generatePatientCDAResponse();
        b.return_x='';
        
        cdapackage.lymphnode c = new cdapackage.lymphnode();
        c.Laterality='';
        c.Proceduredate='';
        c.ProcedureName='';
        c.Targetsite='';
        c.Targetsitecode='';
        
        cdapackage.submitAECDAResponse d = new cdapackage.submitAECDAResponse();
        d.return_x=new cdapackage.response();
        
        cdapackage.submitBioCDAResponse e = new cdapackage.submitBioCDAResponse();
        e.return_x = new cdapackage.response();
        
        cdapackage.submitPatientCDA f = new cdapackage.submitPatientCDA(); 
        f.arg0 = new cdapackage.clinicalDocument();
        f.arg1 = new cdapackage.author();
        f.arg2 = new cdapackage.patient();
        f.arg3='';
        
        cdapackage.submitBioCDA g = new cdapackage.submitBioCDA();
        g.arg0 = new cdapackage.clinicalDocument();
        g.arg1 = new cdapackage.author();
        g.arg2 = new cdapackage.patient();
        g.arg3= new  cdapackage.procedure();
        g.arg4 = null;
        g.arg5 = null;
        g.arg6='';
        
        cdapackage.guidanceMethod h = new cdapackage.guidanceMethod();
        h.valueCode='';
        h.valueDisplayName='';
        h.valueOriginalText='';
        
        cdapackage.generateConsentCDA i = new cdapackage.generateConsentCDA();
        i.arg0=new cdapackage.clinicalDocument();
        i.arg1=new cdapackage.author();
        i.arg2=new cdapackage.patient();
        i.arg3=null;
        i.arg4='';
        
        cdapackage.specimen j = new cdapackage.specimen();
        
        cdapackage.submitAECDA k = new cdapackage.submitAECDA();
        cdapackage.generateClinicalTrialCDA l = new cdapackage.generateClinicalTrialCDA(); 
        cdapackage.getRequest m = new cdapackage.getRequest();
        
        cdapackage.getRequestResponse n = new cdapackage.getRequestResponse();
        cdapackage.generatePatientCDA o = new cdapackage.generatePatientCDA();
        cdapackage.submitClinicalTrialCDA  p= new cdapackage.submitClinicalTrialCDA();
        cdapackage.generateBioCDA q= new cdapackage.generateBioCDA();
        cdapackage.consent r= new cdapackage.consent();
        cdapackage.submitConsentCDAResponse s= new cdapackage.submitConsentCDAResponse();
        cdapackage.generateClinicalTrialCDAResponse t= new cdapackage.generateClinicalTrialCDAResponse();
        cdapackage.submitPatientCDAResponse u= new cdapackage.submitPatientCDAResponse();
        cdapackage.generateBioCDAResponse v= new cdapackage.generateBioCDAResponse();
        cdapackage.generateAECDAResponse w= new cdapackage.generateAECDAResponse();
        cdapackage.submitClinicalTrialCDAResponse x= new cdapackage.submitClinicalTrialCDAResponse();
        cdapackage.getResponse y= new cdapackage.getResponse();
        cdapackage.generateAECDA z= new cdapackage.generateAECDA();
        cdapackage.getResponseResponse z2= new cdapackage.getResponseResponse();
        cdapackage.submitConsentCDA z3= new cdapackage.submitConsentCDA();
        
    }
       
        
}