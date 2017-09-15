// TODO: Ver que pasa cuando hay registros para un program y registros sin program
public with sharing abstract class PageSettingsController {
    public String objectName { get; set; }
    public Boolean showHeader { get{
            if (showHeader == null){
                showHeader = ApexPages.currentPage().getParameters().containsKey('embed') ? false : true;
            } return showHeader;
        } set; }    

/* Para los page settings de un view */
    private SObject record { get; set; }
    private List<FieloPLT__PageSettings__c> relatedPS {get;set;}
    private List<FieloPLT__PageSettings__c> relatedFormsPS {get;set;}
    private FieloPLT__PageSettings__c editPS {get;set;}
    private FieloPLT__PageSettings__c viewPS {get;set;}
    private FieloPLT__PageSettings__c detailPS {get;set;}
    private Set<String> standardRelated {get;set;} 

    private Boolean hasEditForm {get;set;} 
    private Boolean hasDetail {get;set;} 

    public Boolean getHasEditForm () {
        return hasEditForm;
    }
    public Boolean getHasDetail () {
        return hasDetail;
    }


/* 
    Constructor para los Views
*/
    public void setRecord( SObject r ) { 
        this.record = r;        
    }

    public Set<String> fieldList { get {
        if ( fieldList == null ) {
            fieldList = new Set<String>();
            if ( !String.isBlank(viewPS.FieloPLT__Fieldset__c) ) {
                for ( BackendHeaderRecordController.HeaderColumn c:  (List<BackendHeaderRecordController.HeaderColumn>)JSON.deserialize( '[' + viewPS.FieloPLT__Fieldset__c + ']', List<BackendHeaderRecordController.HeaderColumn>.class ) ) {
                    fieldList.add(c.Name.toLowerCase() );
                }
            }
            if ( !String.isBlank(detailPS.FieloPLT__Sections__c) ) {
                for ( FormController.Section s:  (List<FormController.Section>) JSON.deserialize( '[' + detailPS.FieloPLT__Sections__c + ']', List<FormController.Section>.class ) ) {
                  for ( List<FormController.FormField> r :s.rows ) {
                    for ( FormController.FormField f :r ) {
                      if ( !String.isBlank(f.Name) ) {
                        fieldList.add(f.Name.toLowerCase() );
                      }
                    }
                  }
                }
            }
        }
        return fieldList;
    } set ;}

    public Set<String> relatedStandard { get {
        if (relatedStandard == null){
            relatedStandard = standardRelated;
        }
        return relatedStandard;
    } set; }

    private class FilterWrapper{
        public String field;
        public String value;
        public String operator;
        public String andOrOperator;
    }

    private String getVisibility(String jsonCondition, SObject record){
        List<FilterWrapper> filterWrappers;
        try{
            system.debug(jsonCondition);
            filterWrappers = (List<FilterWrapper>)JSON.deserialize(jsonCondition, List<FilterWrapper>.class);
        }catch(Exception e){
            throw new FieloPLT.FieloException('JSON wrong format');
        }
        
        String condition = '';
        for(FilterWrapper filter : filterWrappers){
            condition += String.valueOf(filterResult(record.get(filter.field), filter.operator, filter.value)) + ' ' + filter.andOrOperator + ' ';
        }

        return validateConditional(condition);
    }

    private Boolean filterResult(Object recordValue, String operator, Object compareValue){
        if(operator == 'eq'){
            return recordValue == compareValue;
        }/*else if(operator == 'gt'){
            return recordValue > compareValue;
        }else if(operator == 'lt'){
            return recordValue < compareValue;
        }*/else if(operator == 'neq'){
            return recordValue != compareValue;
        }
        return false;
    }

    private static String validateConditional(String conditional){

        if(conditional.trim() == 'true' || conditional.trim() == 'false'){
            return conditional.trim();
        }

        //first check for wrong simple format
        Pattern mySingleFormatPattern = Pattern.compile('^(true|false) (AND|OR) (true|false)$');
        Matcher mySingleFormatMatcher = mySingleFormatPattern.matcher(conditional);
        boolean singleFormatResult = mySingleFormatMatcher.find();
        if(!conditional.contains('(') && !singleFormatResult){
            return 'false';
        }

        while(conditional.contains('(')){
            Pattern myPattern = Pattern.compile('\\([^\\(]*?\\)');
            Matcher myMatcher = myPattern.matcher(conditional);
            myMatcher.find();
            conditional = conditional.replaceFirst('\\([^\\(]*?\\)', dynamicConditionals(myMatcher.group()));
        }
        String resultadoFinalString = dynamicConditionals(conditional);
        return resultadoFinalString;
    }

    private static String dynamicConditionals(String operation){

        //take out parenthesis
        operation = operation.replace('(', '').replace(')', '');

        //if the expression has only one operator
        if(operation.trim() == 'true' || operation.trim() == 'false'){
            return operation.trim();
        }

        //wrong format
        Pattern mySingleFormatPattern = Pattern.compile('^(true|false) (AND|OR) (true|false)$');
        Matcher mySingleFormatMatcher = mySingleFormatPattern.matcher(operation);
        boolean singleFormatResult = mySingleFormatMatcher.find();
        if(!singleFormatResult){
            return 'false';
        }

        List<string> operators = operation.split (' ');
        if(operators[1] == 'AND'){
            if(operators[0] == 'true' && operators[2] == 'true'){
                return 'true';
            }
        }else if(operators[1] == 'OR'){
            if (operators[0] == 'true' || operators[2] == 'true'){
                return 'true';
            }
        }
        return 'false';
    }

    public List<FieloPLT__PageSettings__c> relatedSettings { get {
        if (relatedSettings == null){
            if(relatedPS != null && !relatedPS.isEmpty()){
                for(FieloPLT__PageSettings__c relPS: relatedPS){
                    if(!String.isBlank(relPS.FieloPLT__Buttons__c)){
                        relPS.FieloPLT__Buttons__c = PageSettingsController.replaceFormula(relPS.FieloPLT__Buttons__c, null);
                    }
                    if(!String.isBlank(relPS.FieloPLT__Tools__c)){
                        relPS.FieloPLT__Tools__c = PageSettingsController.replaceFormula(relPS.FieloPLT__Tools__c, null);
                    }
                    if(!String.isBlank(relPS.FieloPLT__Actions__c)){
                        relPS.FieloPLT__Actions__c = PageSettingsController.replaceFormula(relPS.FieloPLT__Actions__c, null);
                    }
                    system.debug(relPS.FieloPLT__DataFilters__c);
                    if(!String.isBlank(relPS.FieloPLT__DataFilters__c)){
                        relPS.FieloPLT__DataFilters__c = PageSettingsController.replaceFormula(relPS.FieloPLT__DataFilters__c, record);
                        system.debug(relPS.FieloPLT__DataFilters__c);
                    } else {                        
                        relPS.FieloPLT__DataFilters__c = '{\'' + relPS.FieloPLT__TargetField__c + '\':\'' +  record.Id + '\'}';
                    }
                    if(!String.isBlank(relPS.FieloPLT__Visibility__c)){
                        relPS.FieloPLT__Visibility__c = getVisibility(relPS.FieloPLT__Visibility__c, record);
                    } else {                        
                        relPS.FieloPLT__Visibility__c = 'true';
                    }
                }
            }
            relatedSettings = relatedPS;
        }
        return relatedSettings;
    } set; }
    public List<FieloPLT__PageSettings__c> relatedFormsSettings { get {
        if (relatedFormsSettings == null){
            if(relatedFormsPS != null && !relatedFormsPS.isEmpty()){
                for(FieloPLT__PageSettings__c relatedFormPS: relatedFormsPS){
                    if(!String.isBlank(relatedFormPS.FieloPLT__Sections__c)){
                        relatedFormPS.FieloPLT__Sections__c = PageSettingsController.replaceFormula(relatedFormPS.FieloPLT__Sections__c, null);
                    }
                }
            }
            relatedFormsSettings = relatedFormsPS;
        }
        return relatedFormsSettings;

    } set; }
    public FieloPLT__PageSettings__c editSettings { get {
        if (editSettings == null){
            // Quita la primer , que concatena los settings
            if(!String.isBlank(editPS.FieloPLT__Sections__c)){
                editPS.FieloPLT__Sections__c = '[' + PageSettingsController.replaceFormula(editPS.FieloPLT__Sections__c, record) + ']';
            }
            
            editSettings = editPS;
        }
        return editSettings;

    } set; }
    public FieloPLT__PageSettings__c viewSettings { get {
        if (viewSettings == null){
            if(!String.isBlank(viewPS.FieloPLT__Fieldset__c)){
                viewPS.FieloPLT__Fieldset__c = '[' + PageSettingsController.replaceFormula(viewPS.FieloPLT__Fieldset__c, record ) + ']';
            }
            if(!String.isBlank(viewPS.FieloPLT__Buttons__c)){
                viewPS.FieloPLT__Buttons__c =  '[' + PageSettingsController.replaceFormula(viewPS.FieloPLT__Buttons__c, record) + ']';
            }
            if(!String.isBlank(viewPS.FieloPLT__Tools__c)){
                viewPS.FieloPLT__Tools__c =  '[' + PageSettingsController.replaceFormula(viewPS.FieloPLT__Tools__c, record) + ']';
            }
            viewSettings = viewPS;
        }
        return viewSettings;

    } set; }

    public FieloPLT__PageSettings__c detailSettings{ get {
        if (detailSettings == null){
            if (!String.isBlank(detailPS.FieloPLT__Sections__c)){
                detailPS.FieloPLT__Sections__c = '[' + PageSettingsController.replaceFormula(detailPS.FieloPLT__Sections__c, record) + ']';
            }
            detailSettings = detailPS;
        }
        return detailSettings;

    } set; }

    public void initPageSettings( String objectName, SObject record, String standardButtons, String standardTools, String defaultIcon  ) {
        this.objectName = objectName;
        hasEditForm = hasDetail = false;
        this.record = record;
        if ( defaultIcon == null ) {
            defaultIcon = 'action-sprite/svg/symbols.svg#record';
        }
        // 
        List<String> recordTypeNames = new List<String>();
        String recordTypeName;
        try {           
            recordTypeName = (String) record.getSObject('RecordType').get('DeveloperName');
        } catch ( Exception e) {}
        if ( recordTypeName != null ) {
            recordTypeNames.add( recordTypeName);
        }           
        List<FieloPLT__PageSettings__c> settings =  PageSettingsController.getPageSettings( new List<String>{ 'Edit', 'Related', 'View', 'Detail' }, recordTypeNames, objectName );

        if(standardButtons == null){
            standardButtons = '';
        }
        if(standardTools == null){
            standardTools = '';
        }
        relatedPS = new List<FieloPLT__PageSettings__c>();
        editPS = new FieloPLT__PageSettings__c( FieloPLT__Sections__c = '', FieloPLT__Buttons__c = '', FieloPLT__Tools__c = '');
        detailPS = new FieloPLT__PageSettings__c( FieloPLT__Sections__c = '', FieloPLT__Buttons__c = '', FieloPLT__Tools__c = '');
        viewPS = new FieloPLT__PageSettings__c( FieloPLT__Icon__c = defaultIcon,  FieloPLT__Fieldset__c = '', FieloPLT__Buttons__c = standardButtons, FieloPLT__Tools__c = standardTools);

        Set<String> relatedObjects = new Set<String>();
        standardRelated = new Set<String>();
        String viewActions = '';
        // Por Performance dividimos la logica entre los que tienen Recordtype y los que no
        if ( recordTypeName != null ) {
            Map<String, Boolean> skipDefault = new Map<String, Boolean>();

            for ( FieloPLT__PageSettings__c p : settings ) {
                if ( !skipDefault.containsKey( p.FieloPLT__Type__c) ) {
                    skipDefault.put(p.FieloPLT__Type__c, !String.isBlank(p.FieloPLT__RecordType__c) );
                }
                if ( !String.isBlank(p.FieloPLT__RecordType__c) || !skipDefault.get(p.FieloPLT__Type__c) ) {
                    if ( p.FieloPLT__Type__c == 'Related' && String.isNotBlank(p.FieloPLT__TargetObject__c) ) {
                        if ( ! String.isBlank( p.FieloPLT__StandardActions__c )  ) {
                            relatedObjects.add(p.FieloPLT__TargetObject__c);
                        }
                        // Icono por default de las related
                        if ( String.isBlank( p.FieloPLT__Icon__c )  ) {
                            p.FieloPLT__Icon__c = 'action-sprite/svg/symbols.svg#goal';
                        }                       
                        relatedPS.add(p);
                    } else if ( p.FieloPLT__Type__c == 'Edit'  ) {
                        hasEditForm = true;
                        if ( p.FieloPLT__Sections__c != null ) {
                            editPS.FieloPLT__Sections__c += (editPS.FieloPLT__Sections__c == '') ? p.FieloPLT__Sections__c : ',' + p.FieloPLT__Sections__c;
                        }               
                    } else if ( p.FieloPLT__Type__c == 'Detail'  ) {
                        hasDetail = true;
                        if ( ! String.isBlank(p.FieloPLT__Sections__c )  ) {
                            detailPS.FieloPLT__Sections__c += (detailPS.FieloPLT__Sections__c == '') ? p.FieloPLT__Sections__c : ',' + p.FieloPLT__Sections__c;
                        }           
                    } else { // View
                        if ( ! String.isBlank( p.FieloPLT__Icon__c )  ) {
                            viewPS.FieloPLT__Icon__c = p.FieloPLT__Icon__c;
                        }
                        if ( ! String.isBlank( p.FieloPLT__StandardActions__c )  ) {
                            viewActions = p.FieloPLT__StandardActions__c;
                        }                                               
                        if ( ! String.isBlank(p.FieloPLT__Fieldset__c ) ) {
                            viewPS.FieloPLT__Fieldset__c += (viewPS.FieloPLT__Fieldset__c == '') ? p.FieloPLT__Fieldset__c : ',' + p.FieloPLT__Fieldset__c;
                        }
                        if ( ! String.isBlank(p.FieloPLT__Buttons__c) ) {
                            viewPS.FieloPLT__Buttons__c += (viewPS.FieloPLT__Buttons__c == '' ) ? p.FieloPLT__Buttons__c : ',' + p.FieloPLT__Buttons__c;
                        }
                        if ( ! String.isBlank(p.FieloPLT__Tools__c)  ) {
                            viewPS.FieloPLT__Tools__c += (viewPS.FieloPLT__Tools__c == '') ? p.FieloPLT__Tools__c : ',' + p.FieloPLT__Tools__c;
                        }
                        if ( ! String.isBlank( p.FieloPLT__StandardRelated__c )  ) {
                            standardRelated.addAll( p.FieloPLT__StandardRelated__c.split(';') );
                        }                       
                    }
                }
            }

        } else {
            for ( FieloPLT__PageSettings__c p : settings ) {
                if ( p.FieloPLT__Type__c == 'Related' && String.isNotBlank(p.FieloPLT__TargetObject__c)  ) {
                    if ( ! String.isBlank( p.FieloPLT__StandardActions__c )  ) {
                        relatedObjects.add(p.FieloPLT__TargetObject__c);
                    }
                    // Icono por default de las related
                    if ( String.isBlank( p.FieloPLT__Icon__c )  ) {
                        p.FieloPLT__Icon__c = 'action-sprite/svg/symbols.svg#goal';
                    }
                    relatedPS.add(p);
                } else if ( p.FieloPLT__Type__c == 'Edit'  ) {
                    hasEditForm = true;                 
                    if ( ! String.isBlank(p.FieloPLT__Sections__c) ) {
                        editPS.FieloPLT__Sections__c += (editPS.FieloPLT__Sections__c == '') ? p.FieloPLT__Sections__c : ',' + p.FieloPLT__Sections__c;
                    }           
                } else if ( p.FieloPLT__Type__c == 'Detail'  ) {
                    hasDetail = true;
                    if ( ! String.isBlank(p.FieloPLT__Sections__c) ) {
                        detailPS.FieloPLT__Sections__c += (detailPS.FieloPLT__Sections__c == '') ? p.FieloPLT__Sections__c : ',' + p.FieloPLT__Sections__c; 
                    }               
                } else {
                    if ( ! String.isBlank( p.FieloPLT__Icon__c )  ) {
                        viewPS.FieloPLT__Icon__c = p.FieloPLT__Icon__c;
                    }                   
                    if ( ! String.isBlank( p.FieloPLT__StandardActions__c )  ) {
                        viewActions = p.FieloPLT__StandardActions__c;
                    }
                    if ( ! String.isBlank(p.FieloPLT__Fieldset__c) ) {
                        viewPS.FieloPLT__Fieldset__c += (viewPS.FieloPLT__Fieldset__c == '') ? p.FieloPLT__Fieldset__c : ',' + p.FieloPLT__Fieldset__c;
                    }
                    if ( ! String.isBlank(p.FieloPLT__Buttons__c)  ) {
                        viewPS.FieloPLT__Buttons__c += (viewPS.FieloPLT__Buttons__c == '') ? p.FieloPLT__Buttons__c : ',' + p.FieloPLT__Buttons__c;
                    }
                    if ( ! String.isBlank(p.FieloPLT__Tools__c) ) {
                        viewPS.FieloPLT__Tools__c += (viewPS.FieloPLT__Tools__c == '') ? p.FieloPLT__Tools__c : ',' + p.FieloPLT__Tools__c;
                    }
                    if ( ! String.isBlank( p.FieloPLT__StandardRelated__c )  ) {
                        standardRelated.addAll( p.FieloPLT__StandardRelated__c.split(';') );
                    }                                           
                }
            }
        }
        // Reemplaza las formulas y agrega las standard actions en las related
        if ( relatedPS.size() > 0 ) {           
            // Busca si Hay PageSettings Edit de los objetos en caso positivo mete el form
            Map<String, FieloPLT__PageSettings__c> mapForms = new Map<String, FieloPLT__PageSettings__c>();
            Map<String, Schema.DescribeSObjectResult> mapDescribes = new Map<String, Schema.DescribeSObjectResult>();

            if ( relatedObjects.size() > 0 ) {
                for(String relatedObject: relatedObjects){
                    Schema.DescribeSObjectResult describeObjectResult = ((sObject)Type.forName(relatedObject).newInstance()).getSObjectType().getDescribe();
                    mapDescribes.put(relatedObject, describeObjectResult);
                }
                /*Schema.DescribeSObjectResult[] describes = FieloPLT.SObjectDescribe.describeSObjects(  new List<String>(relatedObjects) );
                for ( Schema.DescribeSObjectResult d: describes) {
                    mapDescribes.put(d.getName(), d);
                }*/

                List<FieloPLT__PageSettings__c> forms = getRelatedForms( relatedObjects );
                if ( forms.size() > 0 ) {
                    for ( FieloPLT__PageSettings__c p : forms ) {
                        String key = p.FieloPLT__Object__c;
                        if ( p.FieloPLT__Type__c == 'New' ) {
                            key += 'New';
                        }
                        if ( String.isNotBlank(p.FieloPLT__RecordType__c) ) {
                            key += p.FieloPLT__RecordType__c;
                        }
                        if ( mapForms.containsKey(key) ) {
                            FieloPLT__PageSettings__c m = mapForms.get(key);
                            m.FieloPLT__Sections__c += ',' + p.FieloPLT__Sections__c;
                        } else {
                            mapForms.put(key, p );
                        }
                    }
                    this.relatedFormsPS = mapForms.values();                    
                }
            }
            // Buscar si hay formularios de los relatedObjects
            for ( FieloPLT__PageSettings__c r : relatedPS ) {
                if ( !String.isBlank(r.FieloPLT__Buttons__c) ) {
                    r.FieloPLT__Buttons__c = PageSettingsController.replaceFormula( r.FieloPLT__Buttons__c , record); 
                }
                if ( !String.isBlank(r.FieloPLT__Tools__c) ) {
                    r.FieloPLT__Tools__c =  PageSettingsController.replaceFormula( r.FieloPLT__Tools__c , record); 
                }
                if ( !String.isBlank(r.FieloPLT__Actions__c) ) {
                    r.FieloPLT__Actions__c =  PageSettingsController.replaceFormula( r.FieloPLT__Actions__c , record); 
                }
                if ( !String.isBlank(r.FieloPLT__StandardActions__c) ) {
                    Set<String> opciones = new Set<String>();
                    opciones.addAll( r.FieloPLT__StandardActions__c.split(';') );
             
                    if ( opciones.contains('New') &&  mapDescribes.get(r.FieloPLT__TargetObject__c).isCreateable() ){
                        if ( mapForms.containsKey(r.FieloPLT__TargetObject__c + 'New')  ) {
                            r.FieloPLT__Buttons__c = '{"Label": "' + Label.New + '", "Type": "Modal", "Action": "' + r.FieloPLT__TargetObject__c + 'FormNew" }' + (String.isBlank(r.FieloPLT__Buttons__c)?'':','+ r.FieloPLT__Buttons__c);
                        } else if ( mapForms.containsKey(r.FieloPLT__TargetObject__c)  ) {
                            r.FieloPLT__Buttons__c = '{"Label": "' + Label.New + '", "Type": "Modal", "Action": "' + r.FieloPLT__TargetObject__c + 'Form" }' + (String.isBlank(r.FieloPLT__Buttons__c)?'':','+ r.FieloPLT__Buttons__c);
                        } else {                            
                            r.FieloPLT__Buttons__c = '{"Label": "' + Label.New + '", "Type": "Action", "Action": "New", "ObjectName" : "' + r.FieloPLT__TargetObject__c + '" }' + (String.isBlank(r.FieloPLT__Buttons__c)?'':',' + r.FieloPLT__Buttons__c) ;
                        }
                    }

                    if ( opciones.contains('Delete') &&  mapDescribes.get(r.FieloPLT__TargetObject__c).isDeletable()){
                        r.FieloPLT__Actions__c = '{"Label": "' + Label.Delete + '", "Type": "Remote", "Action": "FieloPLT.RelatedListController.deleteRecord", "CssClass": "slds-button--destructive", "Confirm":true }' + (String.isBlank(r.FieloPLT__Actions__c)?'':',' + r.FieloPLT__Actions__c) ;
                        //r.Actions__c = '{"Label": "' + Label.Delete + '", "Type": "Action", "Action": "Delete", "ObjectName" : "' + r.TargetObject__c + '" }' + (String.isBlank(r.Actions__c)?'':',') + r.Actions__c;
                    }                                   

                    if ( opciones.contains('Edit') &&  mapDescribes.get(r.FieloPLT__TargetObject__c).isUpdateable() ){
                        if ( mapForms.containsKey(r.FieloPLT__TargetObject__c) ) {
                            r.FieloPLT__Actions__c = '{"Label": "' + Label.Edit + '", "Type": "Modal", "Action": "' + r.FieloPLT__TargetObject__c + 'Form" }' + (String.isBlank(r.FieloPLT__Actions__c)?'':',' + r.FieloPLT__Actions__c) ;
                        } else {
                            r.FieloPLT__Actions__c = '{"Label": "' + Label.Edit + '", "Type": "Action", "Action": "Edit", "ObjectName" : "' + r.FieloPLT__TargetObject__c + '" }' + (String.isBlank(r.FieloPLT__Actions__c)?'':',' + r.FieloPLT__Actions__c);
                        }
                    }
                }
                // TODO: Ver si los fieldset de related necesitan
                //if ( !String.isBlank(r.Fieldset__c) ) {
                //  r.Fieldset__c = PageSettingsController.replaceFormula( r.Fieldset__c, record );
                //}
            }           
        }

        if ( !String.isBlank(viewActions) ) {
            Set<String> opciones = new Set<String>();
            opciones.addAll( viewActions.split(';') );

            /*Schema.DescribeSObjectResult[] describes = FieloPLT.SObjectDescribe.describeSObjects(  new List<String>{objectName} );          
            Schema.DescribeSObjectResult describeObject = describes.get(0);*/
            
            Schema.DescribeSObjectResult describeObjectResult = ((sObject)Type.forName(objectName).newInstance()).getSObjectType().getDescribe();

            //if ( opciones.contains('Clone') && describeObject.isCreateable() ){
            if ( opciones.contains('Clone') && describeObjectResult.isCreateable() ){
                // TODO: Ver Bugfix del Clone
                //if ( hasEditForm ) {
                //  viewPS.Buttons__c = '{"Label": "' + Label.Clone + '", "Type": "Modal", "Parameters": "{ \'cloneId\': \'' + record.Id + '\' }", "Action": "' + objectName + 'Form" }' + (String.isBlank(viewPS.Buttons__c)?'':',') + viewPS.Buttons__c;
                //} else {
                    viewPS.FieloPLT__Buttons__c = '{"Label": "' + Label.Clone + '", "Type": "Action", "Action": "Clone", "ObjectName" : "' + objectName + '" }' + (String.isBlank(viewPS.FieloPLT__Buttons__c)?'':',' + viewPS.FieloPLT__Buttons__c);
                //} 
            }

            if ( opciones.contains('Settings') ){
                viewPS.FieloPLT__Tools__c = '{"Label": "' + 'Settings' + '", "Type": "Link", "Action": "/apex/FieloPLT__PageSettingsView?objectName=' + objectName + '" }' + (String.isBlank(viewPS.FieloPLT__Tools__c)?'':',') + viewPS.FieloPLT__Tools__c;

            }

            //if ( opciones.contains('Edit') && describeObject.isUpdateable()){
            if ( opciones.contains('Edit') && describeObjectResult.isUpdateable()){
                if ( hasEditForm ) {
                    viewPS.FieloPLT__Buttons__c = '{"Label": "' + Label.Edit + '", "Type": "Modal", "Action": "' + objectName + 'Form" }' + (String.isBlank(viewPS.FieloPLT__Buttons__c)?'':',') + viewPS.FieloPLT__Buttons__c;
                } else {
                    viewPS.FieloPLT__Buttons__c = '{"Label": "' + Label.Edit + '", "Type": "Action", "Action": "Edit", "ObjectName" : "' + objectName + '" }' + (String.isBlank(viewPS.FieloPLT__Buttons__c)?'':',') + viewPS.FieloPLT__Buttons__c;
                }               
            }

            //if ( opciones.contains('Delete') && describeObject.isDeletable()){
            if ( opciones.contains('Delete') && describeObjectResult.isDeletable()){
//              viewPS.Tools__c = '{"Label": "' + Label.Delete + '", "CssClass": "slds-button--destructive fielosf-button__delete", "Confirm": true, "Type": "Remote", "Action": "FieloPLT.BackendHeaderRecordController.deleteRecord" }' + (String.isBlank(viewPS.Tools__c)?'':',') + viewPS.Tools__c;
                viewPS.FieloPLT__Tools__c = '{"Label": "' + Label.Delete + '", "CssClass": "slds-button--destructive fielosf-button__delete", "Confirm": true, "Type": "Action", "Action": "Delete", "ObjectName" : "' + objectName + '" }' + (String.isBlank(viewPS.FieloPLT__Tools__c)?'':',') + viewPS.FieloPLT__Tools__c;
            }

            if ( opciones.contains('View') ){
                viewPS.FieloPLT__Tools__c = '{"Label": "' + Label.View + '", "Type": "Link", "Action": "/' + record.Id + '?nooverride=1" }' + (String.isBlank(viewPS.FieloPLT__Tools__c)?'':',' + viewPS.FieloPLT__Tools__c);
            }                                   

        }
    }


/***** METODOS DE SOPORTE *****/
    private List<FieloPLT__PageSettings__c> getRelatedForms( Set<String> objects ) {
        List<String> settingType = new List<String> { 'Edit', 'New' };
        String query = 'SELECT FieloPLT__StandardActions__c, FieloPLT__Type__c, FieloPLT__Object__c, FieloPLT__Sections__c, FieloPLT__RecordType__c FROM FieloPLT__PageSettings__c ';
        // WHERE CONDITION 
        query += ' WHERE FieloPLT__isActive__c = true AND FieloPLT__Type__c IN :settingType AND FieloPLT__Object__c IN :objects ';

        FieloPLT__Program__c activeProgram = ProgramService.getActiveProgram();
        Id programId;
        if ( activeProgram != null  ) {
            programId = activeProgram.Id;
            query += ' AND ( FieloPLT__Program__c = :programId OR FieloPLT__Program__c = null )';
        }

        // ORDER BY & LIMIT 
        query += ' ORDER BY FieloPLT__Object__c, FieloPLT__Order__c LIMIT 100 ';            
        return Database.query(query);        
    }   

/***** METODOS STATICOS DE SOPORTE *****/
    private static Map<String, String> mapLabels { get; set; }

    private static String translateLabel(String labelName ){ 
        String labelValue;

        if ( PageSettingsController.mapLabels == null ) {
            PageSettingsController.mapLabels = new Map<String, String> { 'Edit' => Label.Edit, 'Delete' => Label.Delete, 'New' => Label.New };          
        }

        if ( PageSettingsController.mapLabels.containsKey(labelName) ) {
            labelValue =  PageSettingsController.mapLabels.get(labelName);
        } else {
            try {
                Component.Apex.OutputText output;
                output = new Component.Apex.OutputText();
                output.expressions.value = '{!$Label.' + labelName + '}';
                labelValue = string.valueOf(output.value);
            } catch (Exception e) {}
            PageSettingsController.mapLabels.put( labelName, labelValue );              
        }
        return labelValue;
    }
    
    public static String replaceFormula(String json , SObject record) { 
        Pattern formulaRegEx = Pattern.compile('\\{\\!record.([a-z|A-Z|0-9].*?)\\}');
        Pattern labelRegEx = Pattern.compile('\\{\\!\\$[Ll]abel.([a-z|A-Z|0-9].*?)\\}');
        if (  !String.isBlank(json) ) {
            if ( record != null ) {
                Matcher m = formulaRegEx.matcher(json);

                // Usa un set en caso que se repita
                Set<String> apiNames = new Set<String>();
                while (m.find()) {
                    String formula = m.group();
                    String apiName = formula.substring(9,formula.length()-1);
                    if ( !apiNames.contains(apiName) ) {
                        if(record.get(apiName) != null){
                            json = json.replace(formula, String.valueOf(record.get(apiName)));
                        } else {
                            json = json.replace(formula, '');
                        }
                        apiNames.add(apiName);
                    }
                }
            }
            Matcher ml = labelRegEx.matcher(json);
            // Usa un set en caso que se repita
            Set<String> labelNames = new Set<String>();
            while (ml.find()) {
                String formula = ml.group();
                String labelName = formula.substring(9,formula.length()-1);
                if ( !labelNames.contains(labelName) ) {
                    json = json.replace(formula, translateLabel( labelName ) );
                    labelNames.add(labelName);
                }
            }

        }
        return json;
    }

    public static FieloPLT__PageSettings__c getLookupSetting( String objectNames, String targetObject, String targetField ) {        
        String query = 'SELECT FieloPLT__Filters__c, FieloPLT__Fieldset__c FROM FieloPLT__PageSettings__c ';
        // WHERE CONDITION 
        query += ' WHERE FieloPLT__isActive__c = true AND FieloPLT__Type__c = \'Lookup\'  AND FieloPLT__Object__c = :objectNames  ';

        FieloPLT__Program__c activeProgram = ProgramService.getActiveProgram();
        Id programId;
        if ( activeProgram != null  ) {
            programId = activeProgram.Id;
            query += ' AND ( FieloPLT__Program__c = :programId OR FieloPLT__Program__c = null )';
        }

        if ( String.isNotBlank(targetObject ) ) {
            query += ' AND FieloPLT__TargetObject__c = :targetObject';
        } 
        if ( String.isNotBlank(targetField ) ) {
            query += ' AND FieloPLT__TargetField__c = :targetField';
        }
        // ORDER BY & LIMIT 
        query += ' ORDER BY FieloPLT__Object__c, FieloPLT__Order__c LIMIT 1 ';

        List<FieloPLT__PageSettings__c> pageSetting = Database.query(query);

        return pageSetting.isEmpty() ? null : pageSetting.get(0);       
    }

    public static List<FieloPLT__PageSettings__c> getPageSettings( List<String> settingType, List<String> recordTypes, String objectName ) {
        
        String query = 'SELECT FieloPLT__DataFilters__c, FieloPLT__Visibility__c, Name, FieloPLT__IsActive__c, FieloPLT__Library__r.Name, FieloPLT__Icon__c, FieloPLT__OrderBy__c, FieloPLT__StandardRelated__c, FieloPLT__StandardActions__c, FieloPLT__Type__c, FieloPLT__RecordType__c, FieloPLT__Sections__c, FieloPLT__Fieldset__c, FieloPLT__TargetObject__c, FieloPLT__TargetField__c, FieloPLT__Tools__c, FieloPLT__Buttons__c, FieloPLT__Actions__c FROM FieloPLT__PageSettings__c ';
        // WHERE CONDITION 
        query += ' WHERE FieloPLT__isActive__c = true AND FieloPLT__Type__c IN :settingType  AND FieloPLT__Object__c = :objectName  ';

        FieloPLT__Program__c activeProgram = ProgramService.getActiveProgram();
        Id programId;
        if ( activeProgram != null  ) {
            programId = activeProgram.Id;
            query += ' AND ( FieloPLT__Program__c = :programId OR FieloPLT__Program__c = null )';
        }

        if ( recordTypes.isEmpty() ) {
            // ORDER BY & LIMIT 
            query += ' AND FieloPLT__RecordType__c = null ORDER BY FieloPLT__Type__c, FieloPLT__Order__c LIMIT 100 ';             
        } else {
            query += 'AND ( FieloPLT__RecordType__c IN :recordTypes  OR FieloPLT__RecordType__c = null )';
            // ORDER BY & LIMIT 
            query += ' ORDER BY FieloPLT__Type__c, FieloPLT__RecordType__c, FieloPLT__Order__c LIMIT 100 ';           
        }
        return Database.query(query);        
    }

}