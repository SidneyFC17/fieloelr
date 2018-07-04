({
    gotoDetail : function(component, event, helper) {
        try{
            var navEvt = $A.get("e.force:navigateToSObject");
            navEvt.setParams({
                "recordId": component.get('v.record').Id,
                "slideDevName": "detail"
            });
            navEvt.fire();   
        } catch(e) {
            console.log(e);
        }
    }
})