/**
* @brief Class Used to upload a photo as attach to a specific record
*/
public with sharing class PhotoUploadController {


/* Manejo del Folder */
    public String folderUniqueName {get; set;}
    public Id folderId {get {
        if ( folderId == null ) {
            Folder folder;
            List<String> folderNames = folderUniqueName.split( '__' );
            if ( folderNames.size() == 1 ) {
                folder = [SELECT Id FROM Folder WHERE DeveloperName =: folderUniqueName];
            } else {
                folder = [SELECT Id FROM Folder WHERE DeveloperName =: folderNames.get(1) AND NamespacePrefix = :folderNames.get(0)];
            }
            folderId = folder.Id;
        }
        return folderId;
    } set;}

    public List<PicklistController.Entry>  existingDocuments { get {
        if ( existingDocuments == null ) {
            existingDocuments = new List<PicklistController.Entry>();
            for ( Document d : [SELECT Id, Name FROM Document WHERE folderId = :folderId ORDER BY LastModifiedDate DESC LIMIT 255] ) {
               existingDocuments.add( new PicklistController.Entry(d.Id, d.Name));
            }
        }
        return existingDocuments;
    } set;}
    
    //component attributes  
    public SObject recordObject {get; set; }   
    public String fieldNameObject {get; set;}
    public String externalURLNameObject {get; set;}
    public String getEncImage(){
        String base64 = '';
        List<Document> doc = [select body, ContentType from Document where id =: ((Id)recordObject.get(fieldNameObject)) limit 1];
        if( !doc.isEmpty() ){
            base64 = EncodingUtil.Base64Encode(doc.get(0).Body);
            String contentType = doc.get(0).ContentType;
            return ( base64 == '' ) ? '': 'data:' + contentType +  ';base64,' + base64;
        }
        return null;
    }

    public Boolean hasImage {get{
        if(hasImage == null){
            String encImage = getEncImage();
            if( encImage == null && recordObject.get(fieldNameObject) == null && recordObject.get(externalURLNameObject) == null ){
                return false;
            } else if( encImage == null && recordObject.get(fieldNameObject) == null && recordObject.get(externalURLNameObject) != null ){
                return true;
            } else if( encImage == null && recordObject.get(fieldNameObject) != null && recordObject.get(externalURLNameObject) != null ){
                return false;
            } else if( encImage != null && recordObject.get(fieldNameObject) != null && recordObject.get(externalURLNameObject) != null ){
                return true;
            }
        }
        return false;
    } set;}


/*
    Metodo Save
    status: internal, external, existing
*/
    @RemoteAction
    public static RemoteActionResult save( sObject record, String folderId, String objectName, String fieldName, String externalURLField, String status, String photoBase64, String instance){
    
    Savepoint sp;
    RemoteActionResult result = new RemoteActionResult();
    try{
        sp = Database.setSavepoint();
        String documentId = null;

        if ( status == 'external' || status == 'existing' ) {

          SObjectType convertType = record.sObjectType;

          SecurityUtils.checkObjectIsInsertable(convertType);
          SecurityUtils.checkObjectIsUpdateable(convertType);

            upsert record;


        } else {
            Id recordId = record.Id;
            Document currentDocument = new Document();
            if ( status == 'internal' ) {
                // Vuelve a hacer el query por si sube varias veces en la misma page
                 SObjectType convertType = Schema.getGlobalDescribe().get(objectName);

                SecurityUtils.checkObjectIsReadable(convertType);
                sObject existingRecord = Database.query('SELECT ' + fieldName + ' FROM ' + objectName + ' WHERE Id =: recordId');
                
                documentId = (String) existingRecord.get(fieldName);
                // Si No es un Documento Nuevo y esta siendo usado => Lo clona para no cropear el original
                if( !String.isBlank(documentId) ){
                    List<Document> documents =  [SELECT Id, Body, ContentType, LastModifiedDate FROM Document WHERE Id =: documentId  LIMIT 1];
                    if ( documents.size() != 0 ) {
                        currentDocument = documents.get(0);
                    } else { // En caso que hayan borrado el documento
                        documentId = null;
                    }
                    
                     convertType = Schema.getGlobalDescribe().get(objectName);

                    SecurityUtils.checkObjectIsReadable(convertType);
                    List<SObject> whereIsUsed = Database.query('SELECT Id FROM ' + objectName + ' WHERE ' + fieldName + ' = :documentId  AND Id != :recordId ');
                    Boolean isUsed = !whereIsUsed.isEmpty();

                    if(isUsed && currentDocument != null ) {
                        currentDocument = currentDocument.clone(false, false, false, false);
                    }
                }
            }
            
            // Si uso Croppper reemplazo el Body
            if(!String.isBlank(photoBase64)) {
                Integer firstComma = photoBase64.indexOf(',');
                photoBase64 = photoBase64.substring(firstComma + 1, photoBase64.length() - 1);
                currentDocument.put('Body', EncodingUtil.Base64Decode(photoBase64));
            }

            if(currentDocument.Id != null){

                 SObjectType convertType = currentDocument.sObjectType;

                    SecurityUtils.checkObjectIsInsertable(convertType);
                    SecurityUtils.checkObjectIsUpdateable(convertType);

                update currentDocument;
            } else {
                currentDocument.put('Name', (String)record.get('Name') );
                // TODO: Ver Description, Keywords, Unique Name (DeveloperName), File Extension (Type + ContentType)
                // TODO: Ver width y height
                currentDocument.put('FolderId', folderId);
                currentDocument.put('IsPublic', true);

              SObjectType convertType = currentDocument.sObjectType;

                    SecurityUtils.checkObjectIsInsertable(convertType);
                    SecurityUtils.checkObjectIsUpdateable(convertType);

                upsert currentDocument;

                record.put( fieldName, currentDocument.Id );
            }

            documentId = currentDocument.Id;

            result.redirectURL = createURL(currentDocument, instance);
            record.put( externalURLField, result.redirectURL);


           SObjectType convertType = record.sObjectType;

          SecurityUtils.checkObjectIsInsertable(convertType);
          SecurityUtils.checkObjectIsUpdateable(convertType);

            upsert record;
        }

        result.addMessage(new RemoteActionResult.RemoteActionMessage( ApexPages.Severity.Confirm, label.DataSavedSuccessfully) );

        result.recordsId.add(documentId);
        

    }catch(DmlException e){
    // Agrega las Validation Rules asociadas al Campo
        Database.rollback(sp);
        if(ApexPages.hasMessages()){
            result.redirectURL = '';
            for(ApexPages.Message m : ApexPages.getMessages()){
                result.addMessage(new RemoteActionResult.RemoteActionMessage(m, record.getSobjectType().getDescribe().getName() ));
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
    public static RemoteActionResult remove( sObject record, String fieldName, String externalURLField){
    Savepoint sp;
    RemoteActionResult result = new RemoteActionResult();

    try{

        sp = Database.setSavepoint();
        record.put(fieldName ,null);
        record.put(externalURLField ,null);

        SObjectType convertType = record.sObjectType;

          SecurityUtils.checkObjectIsInsertable(convertType);
          SecurityUtils.checkObjectIsUpdateable(convertType);

            upsert record;

        //TODO REVISAR SI BORRA DOCUMENTOS HUERFANOS
        result.addMessage(new RemoteActionResult.RemoteActionMessage( ApexPages.Severity.Confirm, label.DataRemovedSuccessfully) );

    }catch(DmlException e){
    // Agrega las Validation Rules asociadas al Campo
        Database.rollback(sp);
        if(ApexPages.hasMessages()){
            result.redirectURL = '';
            for(ApexPages.Message m : ApexPages.getMessages()){
                result.addMessage(new RemoteActionResult.RemoteActionMessage(m, record.getSobjectType().getDescribe().getName() ));
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

    public static String createURL(Document imageRecord, String instance){
        String url;

        if(instance != null && instance != ''){
            url = 'https://c.' + instance + '.content.force.com/servlet/servlet.ImageServer?id=' + (String)imageRecord.Id + '&oid=' + UserInfo.getOrganizationId();
        }else{
            url = '/servlet/servlet.ImageServer?id=' + (String)imageRecord.Id + '&oid=' + UserInfo.getOrganizationId();
        }
        if(imageRecord.get('LastModifiedDate') != null) {
            url += '&LastModifiedDate=' + String.valueOf(imageRecord.get('LastModifiedDate')).deleteWhitespace();
        }
        return url;
    }

}