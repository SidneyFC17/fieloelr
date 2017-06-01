public with sharing class FormQuestionController {
	/*****  Datos  *****/
  	public String csObjectName{get;set;}
    public String cFilter{get;set;}
  	public String cLayout{get;set;}
  	public static Boolean cRecordRedirect{get;set;}
    public SObject cRecord {get;set;}  
  	private Boolean queryRecordNotDone = true;

  	public String fields {get{
    	if ( fields == null ) {
			fields = 'Id';
        	for ( Section s :sections ) {
          		for ( List<FormField> r :s.rows ) {
            		for ( FormField f :r ) {
              			if ( !String.isBlank(f.Name) ) {
                			fields += ', '  + f.Name;
              			}
            		}
          		}
        	}
      	}
		return fields;
    }set;}
	
	public SObject recordObject{get{
		if (queryRecordNotDone ) {
			queryRecordNotDone = false;
        	if ( cRecord !=null && cRecord.Id != null ) {
          		Id recordId = cRecord.Id;
          		String query = 'SELECT  ' + fields;
          		query += ' FROM ' + csObjectName;
          		query += ' WHERE Id = : recordId ';
          		
          		recordObject = Database.query(query)[0];
        	} else {
          		recordObject = Schema.getGlobalDescribe().get(csObjectName).newSObject() ;
        	}
      	}
      	return recordObject;
    }set;}

	/*****  Secciones Y Fields  *****/
  	public String cFieldset{get;set;}

  	public class Section {
	    public String Name{get;set;}
	    public List<List<FormField>> Rows{get;set;}
  	}
  	public class FormField {
	    public String Type{get;set;}
	    public String MetaField{get;set;}
	    public String Name{get;set;}
	    public String onchange{get;set;}
	    public String Label{get;set;}
	    public String Value{get;set;}
    	public String WhereCondition{get;set;}
  	}

  	public List<Section> sections { get {
        if ( sections == null ) {
            if ( !String.isBlank(cFieldset)  ) {
                // Si empieza con [ es un valor seteado en una visual force => lo tiene que modificar para que sea json
                if ( !cFieldset.startsWith('[') ) {
                    cFieldset = '[' + cFieldset.replace('\'', '"') + ']';
                }
                try {
                    if ( cLayout == 'inline'  ) {
                        Section s = new Section();
                        s.Name = '';
                        s.Rows =  new List<List<FormField>>();
                        s.Rows.add( (List<FormField>) JSON.deserialize( cFieldset, List<FormField>.class ));
                        sections = new List<Section>();
                        sections.add(s);
                    } else {
                        sections = (List<Section>) JSON.deserialize( cFieldset, List<Section>.class );
                    }
                } catch( JSONException e ) {
                    system.debug(LoggingLevel.ERROR, 'INVALID JSON ' + cFieldset );        
                }
            } else {
                sections = new List<Section>();
            }
        }
        return sections;
        } set;
    }

	/*****  Piclklist Values *****/
  	private Map<String, Schema.SObjectField> fieldMap { get {
	    if ( fieldMap == null && csObjectName != null ) {
      		Schema.DescribeSObjectResult[] describes = Schema.describeSObjects(new String[]{ csObjectName });
      		fieldMap = describes.get(0).fields.getMap();
    	}
    	return fieldMap;
  	} set; }

  	public Map<String, String> mapOptionsString { get {
    	if ( mapOptionsString == null && mapPicklistOptions != null ) {
      		mapOptionsString = new Map<String, String>();
      		for ( String key : mapPicklistOptions.keySet() ) {
        		String options = '';
        		for ( PicklistController.Entry p : mapPicklistOptions.get(key) ) {
          			options += ',{ "id": "' + p.Id + '", "label": "' + p.Label + '" }';
        		}
        		if ( options != '') {
          			mapOptionsString.put(key,'[' + options.substring(1) + ']');
        		} else {
          			mapOptionsString.put(key,'[]');
        		}
      		}
    	}
    	return mapOptionsString;
  	} set;}

  	public Map<String, List<PicklistController.Entry>> mapPicklistOptions { get {
	    if ( mapPicklistOptions == null && !String.isBlank(csObjectName) ) {
      		mapPicklistOptions = new Map<String, List<PicklistController.Entry>>();
      		for ( Section s :sections ) {
        		for ( List<FormField> ff :s.Rows ) {
          			for ( FormField f :ff ) {
            			if ( (f.Type == 'picklist' ||  f.Type == 'radio'|| f.Type == 'multiselect'|| f.Type == 'checkboxes') && fieldMap.containsKey(f.Name) ) {
              				List<PicklistController.Entry> options = new List<PicklistController.Entry>();
              				Schema.DescribeFieldResult describe = fieldMap.get(f.Name).getDescribe();
              				if ( describe.getType().name() == 'PICKLIST' || describe.getType().name() == 'MULTIPICKLIST' ) {
                				List<Schema.PicklistEntry> pickListValues = describe.getPickListValues();
                				for (Schema.PicklistEntry a : pickListValues) {
                   					options.add( new PicklistController.Entry(a.getValue(), a.getLabel() ));
                				}
              				} else if ( describe.getType().name() == 'REFERENCE' ) {
                				String query = 'SELECT ID, Name FROM ' + describe.getReferenceTo().get(0);
                				if ( ! String.isBlank( f.WhereCondition )  ){
                  					query += ' WHERE ' + f.WhereCondition.replace('/', '\'') ;
                				}
                				query += ' LIMIT 500';
                				for ( SObject o : Database.query(query) ) {
                  					// Substring para que matche con el multipicklist (para multisegment)
                   					options.add( new PicklistController.Entry( ((String)o.id).substring(0, 15),  (String)o.get('Name') ));
                				}
              				}
              				mapPicklistOptions.put( f.Name , options);
            			}
          			}
        		}
      		}
    	}
    	return mapPicklistOptions;
  	} set;}

	/*****  Metodos Remote para Save y Retrieve *****/
    @RemoteAction
    public static RemoteActionResult save( FieloELR__Question__c question, List<String> questionNullFields, List<FieloELR__AnswerOption__c> answerOptions, Map<Id,List<String>> answerOptionsNullFields){
	    Savepoint sp;
	    RemoteActionResult result = new RemoteActionResult();
        SObjectUnitOfWork uow = new SObjectUnitOfWork(new List<Schema.SobjectType>{FieloELR__Question__c.SObjectType, FieloELR__AnswerOption__c.SObjectType});

	    try{
            sp = Database.setSavepoint();
            for( String f :questionNullFields ) {
                question.put(f, null );
            }

            if (question.Id == null) {
                uow.registerNew(question);
            }

            for( FieloELR__AnswerOption__c answerOption: answerOptions) {
                if(answerOptionsNullFields.containsKey(answerOption.Id)){
                    for(String f: answerOptionsNullFields.get(answerOption.Id)){
                        answerOption.put(f, null);
                    }
                }
                if(answerOption.Id == null){
                    uow.registerNew(answerOption, AnswerOption__c.Question__c, question);
                }else{
                    uow.registerDirty(answerOption);
                }
            }

            uow.commitWork();

	        //TODO Crear Label DataSavedSuccessfully
	        result.addMessage(new RemoteActionResult.RemoteActionMessage( ApexPages.Severity.Confirm, 'Data was saved successfully') );

	    } catch(DmlException e) {
	    // Agrega las Validation Rules asociadas al Campo
	        Database.rollback(sp);
	        if(ApexPages.hasMessages()){
	            result.redirectURL = '';
	            for(ApexPages.Message m : ApexPages.getMessages()){
	                result.addMessage(new RemoteActionResult.RemoteActionMessage(m, '' ));
	            }
	        } else {
	          result.addMessage(new RemoteActionResult.RemoteActionMessage(e));  
	        }
	    }catch(Exception e){
	        if(sp != null){
	            Database.rollback(sp);
	        }
	        result.addMessage(new RemoteActionResult.RemoteActionMessage(e));
	    }
	    return result;
   }

    @RemoteAction
    public static sObject retrieve( String objectName, String recordId, String fields ){
	    String query = 'SELECT ' + fields;
      if (objectName == 'FieloELR__Question__c') {
        query += ' ,(Select Id, FieloELR__IsCorrect__c, FieloELR__AnswerOptionText__c, FieloELR__Order__c From AnswerOptions__r ORDER BY FieloELR__Order__c, LastModifiedDate)';
      }
	    query += ' FROM ' + objectName;
	    query += ' WHERE ID = :recordId' ;
	    query += ' LIMIT 1';
	    List<sObject> result = Database.query(query);
	    if ( result.size() > 0 ) {
      		return result.get(0);
    	}
    	return null;
  	}
}