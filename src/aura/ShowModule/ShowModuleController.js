({
    showModule: function(component, event, helper){
        var modulesEvent = $A.get('e.FieloELR:ShowCourseEvent');
        var record = component.get('v.record');        
        var name = component.get('v.name');         
        if(modulesEvent){
            modulesEvent.setParam('record', record);
            modulesEvent.setParam('courseName', name);
            modulesEvent.fire();
        }                
    }
})