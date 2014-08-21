trigger MammaPrintFormBeforeInsertUpdate on MammaPrintDetail__c (before insert, before update) {
	
	/*for(MammaPrintDetail__c mpd : Trigger.new){
		mpd.TargetPrint_Her2_OS_Snomed__c = SnomedCTCode.SnomedCode('MammaPrintDetail__c','TargetPrint_Her_2_Status__c','');
		mpd.TargetPrint_Her2_Val_Snomed__c = SnomedCTCode.SnomedCode('MammaPrintDetail__c','TargetPrint_Her_2_Status__c',mpd.TargetPrint_Her_2_Status__c);
		mpd.MammaPrint_Risk_Snomed__c = SnomedCTCode.SnomedCode('MammaPrintDetail__c','MammaPrint_Risk__c','');
		mpd.MammaPrint_Risk_val_Snomed__c = SnomedCTCode.SnomedCode('MammaPrintDetail__c','MammaPrint_Risk__c', mpd.MammaPrint_Risk__c);
		mpd.MammaPrint_Index_Snomed__c = SnomedCTCode.SnomedCode('MammaPrintDetail__c','MammaPrint_Index__c', '');
		mpd.H1_H2_status_Snomed__c = SnomedCTCode.SnomedCode('MammaPrintDetail__c','H1_H2_status__c', '');
		mpd.H1_H2_status_Val_Snomed__c = SnomedCTCode.SnomedCode('MammaPrintDetail__c','H1_H2_status__c', mpd.H1_H2_status__c);
	}*/
}