public with sharing class FormModelController  {
  /*****  Retrieve  *****/

	@RemoteAction
	public static FieloPLT__Model__c retrieve( String objectName, Id recordId, String fields ){
    	FieloPLT__Model__c recordObject;
    	objectName = recordId.getSObjectType().getDescribe().getName();
    	if ( objectName == 'FieloPLT__Model__c' ) {
				SObjectType convertType = Schema.getGlobalDescribe().get('FieloPLT__Model__c');
        	    SecurityUtils.checkObjectIsReadable(convertType);
          	recordObject = [SELECT ID, FieloPLT__JSON__c, FieloPLT__Icon__c, FieloPLT__Type__c, FieloPLT__Category__c, Name FROM FieloPLT__Model__c WHERE Id = : recordId ];
    	} else if( objectName == 'FieloELR__Course__c') {
    		recordObject = new FieloPLT__Model__c( Name = 'New Model', FieloPLT__Category__c = 'Miscelaneas', FieloPLT__Type__c = 'Course' ) ;
    		recordObject.FieloPLT__JSON__c = ExportService.exportCourses(new List<Id>{recordId});
    		recordObject.FieloPLT__Icon__c = 'fielosf-icon-content';
    	}
    	return recordObject;
	}
}