/**
* @description Class to Control the Incentives Landing Page.
*/
public with sharing class ELearningLandingController extends PageSettingsSetController {

	public String currentView {get;set;}
    public FieloPLT__PageSettings__c newCourse {get;set;}
    public FieloPLT__PageSettings__c newModule {get;set;}
    public FieloPLT__PageSettings__c landingCourse {get;set;}
    public FieloPLT__PageSettings__c landingModule {get;set;}

    public FieloPLT__Program__c currentProgram { get {
        if ( currentProgram == null) {
            currentProgram = ProgramService.getActiveProgram();
        }
        return currentProgram;
    }set;}

	public ELearningLandingController() {
		if( currentProgram != null ){
            String standardTools  = '';
            String standardButtons = '';

            standardButtons = '{"Label": "' + Label.New + '", "Type": "Modal", "Action": "FieloELR__Course__cForm", "CssClass": "fielosf-create-course" }';
            standardButtons += ',{"Label": "' + Label.New + '", "Type": "Modal", "Action": "FieloELR__Module__cForm", "CssClass": "fielosf-create-module slds-hide" }';

            PageReference exportPage = Page.FieloPLT__XMLExport;
            exportPage.getParameters().put( 'retURL', System.currentPageReference().getUrl() );
            exportPage.getParameters().put( 'type', 'elearning' );
            PageReference importPage = Page.FieloPLT__XMLImport;
            importPage.getParameters().put( 'retURL', System.currentPageReference().getUrl() );
            importPage.getParameters().put( 'type', 'elearning' );

            standardTools = '{"Label": "Export", "Type": "Link", "Action": "' + exportPage.getUrl() + '" }';
            standardTools += ',{"Label": "Import", "Type": "Link", "Action": "' + importPage.getUrl() + '" }';

            initPageSettings( 'FieloELR__Module__c', null, null, 'utility-sprite/svg/symbols.svg#people' );
            newModule = newSettings.clone();
            landingModule = landingSettings.clone();

            initPageSettings( 'FieloELR__Course__c', standardButtons, standardTools, 'utility-sprite/svg/symbols.svg#people' );
            newCourse = newSettings;
            landingCourse = landingSettings;

            if ( Apexpages.currentPage().getParameters().containsKey('view') ) {
                currentView = Apexpages.currentPage().getParameters().get('view');
            } else {
                currentView = 'Draft';
            }
        }
	}
}