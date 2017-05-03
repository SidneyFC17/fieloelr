public with sharing class RelatedListController {
/***** Badges ******/  
  public String cBadges{get;set;}
  public List<String> cBadgesList{get{
    if(cBadgesList==null ){
      cBadgesList = cBadges.split(',');
    }
    return cBadgesList;
  }set;}


  private Map<String, Schema.SObjectField> objectFieldMap { get {
    if ( objectFieldMap == null && !String.isBlank(csObjectName) ) {
      Schema.DescribeSObjectResult[] describeObjects = Schema.describeSObjects(  new List<String>{csObjectName} );
      if ( describeObjects.size() > 0 ) {
        objectFieldMap = describeObjects.get(0).fields.getMap();
      }
    }
    return objectFieldMap;
  } set;}

/***** Columnas ******/
  public String cNameField{get;set;}
  public String cFieldset{get;set;}

  public class RelatedColumn  {
    public String Type{get;set;}
    public String Name{get;set;}
    public String Label{get;set;}
    //public Boolean Sortable {get;set;}
  }

  public List<RelatedColumn> columns { get {
      if ( columns == null ) {
        if ( !String.isBlank(cFieldset)  ) {
          // Si empieza con [ es un valor seteado en una visual force => lo tiene que modificar para que sea json
          if ( !cFieldset.startsWith('[') ) {
            cFieldset = '[' + cFieldset.replace('\'', '"') + ']';
          }
          try {
            columns = (List<RelatedListController.RelatedColumn>) JSON.deserialize( cFieldset , List<RelatedListController.RelatedColumn>.class );

            // Rellenar los Labels y Types Nulos
            if ( objectFieldMap != null ) {
              for ( RelatedColumn c: columns ) {
                  //si tiene campo por relacion tomo lo anterior al punto nomas
                  String apiName = c.Name.indexOf('.') > 0 ? c.Name.substring(0,c.Name.indexOf('.')) : c.Name;
                  //si es un campo custom con __r lo cambio por __c
                  if(apiName.indexOf('__r') > 0){
                    apiName = apiName.substring(0, apiName.indexOf('__r') ) + '__c';
                  //si es un campo standard y no tien el id al
                  }else if(!apiName.contains('__c') && c.Name.contains('.') ){
                      apiName += 'id';
                  }           
                if ( objectFieldMap.containsKey(apiName) && ( c.Label == null || c.Type == null) ) {
                  Schema.DescribeFieldResult fieldDescribe = objectFieldMap.get(apiName).getDescribe();              
                if(apiName.toLowerCase() == 'recordtypeid' || apiName.toLowerCase().contains('recordtype.id')){
                  c.Type = 'string';
                }
                  if ( c.Label == null ) {
                    c.Label = fieldDescribe.getLabel();
                  }
                  if ( c.Type == null ) {
                    c.Type = fieldDescribe.getType().name();
                  }              
                }
              }
            }
          } catch( JSONException e ) {
            system.debug(LoggingLevel.ERROR, 'INVALID JSON ' + cFieldset );        
          }          
        } else {
          columns = new List<RelatedListController.RelatedColumn>();
        }
      }
      return columns;
    } set;
  }
  public String fieldsetString { get {
      if ( fieldsetString == null) {
        fieldsetString = cNameField;
        for ( RelatedColumn r :columns ){
          if ( r.Name != cNameField ) {
            fieldsetString += ', '  + r.Name;            
          }
        }
      }
      return fieldsetString;
    } set;
  }


/*****  Metodos Remote Delete Record  y Refresh Data *****/
  @RemoteAction
  public static RemoteActionResult deleteRecord( Id recordId ){
    RemoteActionResult result = new RemoteActionResult();

    try{
        if ( recordId == null ) {          
          result.addMessage(new RemoteActionResult.RemoteActionMessage( ApexPages.Severity.ERROR, String.format(Label.RequiredArgument, new String[]{'recordId'} ) ) );        
        } else {
          SObject record = recordId.getSobjectType().newSObject();
          record.id = recordId;
          delete record;
          // TODO cambiar label
          result.addMessage(new RemoteActionResult.RemoteActionMessage( ApexPages.Severity.Confirm, 'The record was deleted successfully') );        
        }
    }catch(Exception e){
        result.addMessage(new RemoteActionResult.RemoteActionMessage(e));
    }
    return result;
  }
/***** Query Datos ******/  
  public Integer cRecordsPerPage{get;set;}
  public String orderBy {get; set;}    
  public String csObjectName{get;set;}
  public Boolean noRecords{get { return cRecords.size() == 0; } } 
  public Boolean viewAll {get { return cRecords.size() == cRecordsPerPage; } } 
  public String cDataFilters {get; set;}  

  public List<sObject> cRecords { get {
    if ( cRecords == null ) {
      if ( !String.isBlank(cDataFilters) ) {
        cDataFilters = cDataFilters.replace('\'', '"'); 
      }

      cRecords = getRecords(  csObjectName,  fieldsetString, 0,  orderBy,  cDataFilters,  cRecordsPerPage );
    }
    return cRecords;
  } set; }    

  @RemoteAction
  public static List<SObject> getRecords( String objectName, String fields, Integer offset, String orderBy, String dataFilters, Integer recordsPerPage ) {
      String query = 'SELECT Id, ' + fields;
      query += ' FROM ' + objectName;
      query += getWhereCondition( dataFilters ); 
      // ORDER BY       
      if ( orderBy == null ) {
          orderBy = 'LastModifiedDate DESC';
      }
      query += ' ORDER BY '+ orderBy; //DESC
      // LIMIT & OFFSET
      if ( recordsPerPage == null ) {
          recordsPerPage = 10;
      }
      query += ' LIMIT '+ String.valueOf(recordsPerPage);
      if ( offset != null ){
        query += ' OFFSET '+ String.valueOf(offset);
      }        
      return Database.query(query);
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


}