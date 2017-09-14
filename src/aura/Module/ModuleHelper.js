({
    loadContent : function(component, event, helper) {
        var contentField = component.get('v.moduleContent');
        var moduleId = component.get('v.module').module.Id;        
        if(contentField){
            contentField = contentField.Field;
            component.set('v.contentFieldName', contentField);
            var getContent = component.get('c.getContent');            
            getContent.setParams({
                'contentField': contentField,
                'moduleId': moduleId
            })
            // Add callback behavior for when response is received
            getContent.setCallback(this, function(response) {
                var state = response.getState();                
                if (component.isValid() && state === 'SUCCESS') {                                        
                    var moduleResponse = response.getReturnValue();
                    component.set('v.content', moduleResponse);                    
                    if(moduleResponse[contentField]){
                        component.set('v.showContent', true);                                            
                    }                                        
                }else {
                    console.log('Failed with state: ' + state);
                }
            });      
            
            $A.enqueueAction(getContent);
        }
    }
    
})