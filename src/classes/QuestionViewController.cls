public with sharing class QuestionViewController extends PageSettingsController {
	public Question__c record {get;set;}
	public String buttonString {get;set;}
	public String toolsString {get;set;}
	public static String secondaryParameters {get;set;}
	public List<Map<String,Object>> buttonList {get;set;}
	private ApexPages.StandardController controller;

	/**
    * @brief constructor
    */
	public QuestionViewController(ApexPages.StandardController controller) {
		String objectName = 'FieloELR__Question__c';
		this.controller = controller;
		Id recordId = controller.getId();
		Set<String> fields = new Set<String>();

		fields.addAll(Schema.describeSObjects(
			new String[]{objectName})[0].fields.getMap().keySet());

		if(!Test.isRunningTest()){
            this.controller.addFields(new List<String>(fields));
        }
        // Cast all fieldNames to lowercase
        for(String fieldName: fields){
			fields.remove(fieldName);
			fields.add(fieldName.toLowerCase());
		}

        record = (FieloELR__Question__c)controller.getRecord();

		initPageSettings(objectName, record, '', '', '');

		if ( fieldList.size() > 0  ) {
			for(String fieldName:fieldList) {
				fields.add(fieldName);
			}
			String query = String.format(
				'SELECT {0} FROM {1} WHERE Id = :recordId',
				new String[]{
					String.join(new List<String>(fields), ','),
					objectName
				}
			);
			record = Database.query(query);
			setRecord(record);
		}
	}

	private static String getWhereCondition( String filterJson ) {
		String whereCondition = '';
		if (filterJson != null ) { 
			try {
				Map<String,Object> filter = (Map<String, Object>) JSON.deserializeUntyped( filterJson);
		  		for ( String k :filter.keySet() ) {
			    	String value = (String) filter.get(k);
		    		if ( value.startsWith('!') ) {
			      		whereCondition += ' AND ' + k + ' <> \'' +  value.substring(1) + '\'';            
		    		} else {
			      		whereCondition += ' AND ' + k + ' = \'' +  value + '\'';
		    		}
		  		}
				if ( whereCondition != '') {          
				    whereCondition = ' WHERE ' + whereCondition.substring(4);
		  		}
			} catch( JSONException e ) {
				system.debug(LoggingLevel.ERROR, 'INVALID JSON ' + filterJson );        
			}
		}
		return whereCondition;
	}

	public class Section {
        public String Name{get;set;}
        public List<List<FormField>> Rows{get;set;}
        public String CssClass{get;set;}
    }

    public class FormField {
        public String Type{get;set;}
        public String MetaField{get;set;}
        public String Name{get;set;}
        public String onchange{get;set;}
        public String Label{get;set;}
        public String Value{get;set;}
        public String WhereCondition{get;set;}
        public Boolean Required{get;set;}

        public String getRequiredValue () {
            if ( Required != null ) {
                return Required ? 'true' : 'false';
            }
            return '';
        }
    }
}