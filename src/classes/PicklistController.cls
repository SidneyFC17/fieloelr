public with sharing class PicklistController {

	public class Entry {
		public String Id{get;set;}
		public String Label{get;set;}
		public String MetaLabel{get;set;}

		public Entry ( String Id, String Label ) {
			  this.Id = Id;
			  this.Label = Label;
			}
	}

	public String cOptions {get;set;}
	public String cValue {get;set;}

	public String optionsString {get {
		if ( optionsString == null && !String.isBlank(cOptions) ) {
			optionsString = cOptions;
			if ( cOptions.substring(1) != '['  ) {
				optionsString = cOptions.replace('\'', '"');
			} else {
				optionsString = cOptions;
			}
		}
		return optionsString;
	} set;}


	public List<Entry> optionsList { get {
		  if ( optionsList == null ) {
		    if ( !String.isBlank(cOptions)  ) {
		      cOptions = cOptions.replace('\\\'', '&&&');
		      cOptions = cOptions.replace('\"', '$$$');
		      cOptions = cOptions.replace('\'', '"');
		      cOptions = cOptions.replace('&&&', '\'');
		      cOptions = cOptions.replace('$$$', '"');
		      try {
		    	optionsList = (List<Entry>) JSON.deserialize( cOptions, List<Entry>.class );
	          } catch( JSONException e ) {
	              system.debug(LoggingLevel.ERROR, 'INVALID JSON ' + cOptions );        
	          }
		    } else {
		    	optionsList = new List<Entry>();
		    }
		  }
		  return optionsList;
	} set; }

	public String fixedName { get{
		if (fixedName == null && cValue != null) {
			fixedName = ((String) getName(cValue).get('Name')) ;
		} 
		return fixedName;
	} set;}

	@RemoteAction
	public static List<sObject> getRecordsSOSL( String sObjectName, String idField, String idLabel, String metaField, String whereCondition, String searchTerm  ){
		if ( searchTerm.length() > 1 ) {
			String q = 'FIND {' + String.escapeSingleQuotes(searchTerm)+ '*} IN NAME FIELDS RETURNING ' + sObjectName + '( ' + idField + ',' + idLabel + ')';
			if ( !String.isBlank(whereCondition) ) {
				q += ' WHERE ' +  whereCondition.replace('/', '\'') + ' AND ';
			}

			List<List<SObject>> records  = search.query( q );

			return records.get(0);	
		}
		return null;
	}

	@RemoteAction
	public static List<sObject> getRecords( String sObjectName, String idField, String idLabel, String metaField, String whereCondition, String searchTerm  ){
		String q = 'SELECT ' + idField + ',' + idLabel;
		if ( !String.isBlank(metaField) ) {
			q += ', ' + metaField;
		}
		q += ' FROM ' + sObjectName + ' WHERE ';
		if ( !String.isBlank(whereCondition) ) {
			q += whereCondition.replace('/', '\'') + ' AND ';
		}
		q += idLabel + ' LIKE \'%'  + String.escapeSingleQuotes(searchTerm) + '%\' LIMIT 100';

		SObjectType convertType = Schema.getGlobalDescribe().get(sObjectName);

        SecurityUtils.checkObjectIsReadable(convertType);
		List<sObject> records  = Database.query( q );

		return records;
	}

	@RemoteAction
	public static sObject getName( ID lookupId ) {
		String sObjectName = lookupId.getSObjectType().getDescribe().getName();
		String q = 'SELECT Name FROM ' + sObjectName +
		 ' WHERE id = \'' + lookupId + '\'';

		SObjectType convertType = Schema.getGlobalDescribe().get(sObjectName);

        SecurityUtils.checkObjectIsReadable(convertType);
		sObject record = Database.query( q );

		return record;
	}
}