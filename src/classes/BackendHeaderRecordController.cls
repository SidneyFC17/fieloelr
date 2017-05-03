public with sharing class BackendHeaderRecordController {

/*****  Datos  *****/
  public String csObjectName{get;set;}
  private Boolean queryRecordNotDone = true;
  public SObject cRecord{get{
      if (queryRecordNotDone && cRecord !=null && cRecord.Id != null ) {
        Id recordId = cRecord.Id;
        String query = 'SELECT Id, Name ';
        for ( HeaderColumn c :columns ){
          if ( c.Name != 'Name' && c.Name != 'Id'  ){
            query += ', '  + c.Name;
            if(c.Name.contains('__r')){
              query += ', ' + c.Name.substring(0, c.Name.indexOf('__r') ) + '__c';
            }
          }
        }
        query += ' FROM ' + csObjectName;
        query += ' WHERE Id = : recordId ';
        cRecord = Database.query(query)[0];
        queryRecordNotDone = false;
      }
      return cRecord;
    }set;}

/*****  Fieldset  *****/
  public class HeaderColumn {
    public String Type{get;set;}
    public String Name{get;set;}
    public String Label{get;set;}
    public String Href{get;set;}
  }
  public String cFieldset{get;set;}

  private Map<String, Schema.SObjectField> objectFieldMap { get {
    if ( objectFieldMap == null && !String.isBlank(csObjectName) ) {
      Schema.DescribeSObjectResult[] describeObjects = Schema.describeSObjects(  new List<String>{csObjectName} );
      if ( describeObjects.size() > 0 ) {
        objectFieldMap = describeObjects.get(0).fields.getMap();
      }
    }
    return objectFieldMap;
  } set;}

  public List<HeaderColumn> columns { get {
      if ( columns == null ) {
        if ( !String.isBlank(cFieldset)  ) {
          if ( !cFieldset.startsWith('[') ) {
            cFieldset = '[' + cFieldset.replace('\'', '"') + ']';
          }

          try {
            columns = (List<BackendHeaderRecordController.HeaderColumn>) JSON.deserialize( cFieldset, List<BackendHeaderRecordController.HeaderColumn>.class );
          } catch( JSONException e ) {
              system.debug(LoggingLevel.ERROR, 'INVALID JSON ' + cFieldset );        
          }
          // Rellenar los Labels y Types Nulos
          if ( objectFieldMap != null ) {
            for ( HeaderColumn c: columns ) {
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


        }
      }
      return columns;
    } set;
  }

  @RemoteAction
  public static RemoteActionResult deleteRecord( Id recordId ){
    RemoteActionResult result = new RemoteActionResult();

    try{
        if ( recordId == null ) {          
          result.addMessage(new RemoteActionResult.RemoteActionMessage( ApexPages.Severity.ERROR, String.format(Label.RequiredArgument, new String[]{'recordId'} ) ) );        
        } else {
          sobjectType sobjectType = recordId.getSobjectType();
          SObject record = sobjectType.newSObject();
          record.id = recordId;
          delete record;
          // TODO cambiar label
          result.addMessage(new RemoteActionResult.RemoteActionMessage( ApexPages.Severity.Confirm, 'The record was deleted successfully') );
          //if ( String.isBlank(retUrl)  ) {
            result.redirectURL = '/' + sobjectType.getDescribe().getKeyPrefix();
          //} else {
          //  result.redirectURL = retUrl;
          //}
        }
    }catch(Exception e){
        result.addMessage(new RemoteActionResult.RemoteActionMessage(e));
    }
    return result;
  }

}