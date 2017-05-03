public with sharing class BackendFooterController {
	public String cExternalJS {get;set;}

    public  List<String> getJSUrls(){
        return cExternalJS != null ? cExternalJS.split(',') : null;
    }
}