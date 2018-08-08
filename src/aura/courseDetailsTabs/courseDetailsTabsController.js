({
    handleTabClick : function(component, event, helper) {
        try{
            var viewName = event.target.id;
            component.set('v.selectedView', viewName);
            helper.selectView(component);
            var registerFieldEvent = component.getEvent("courseViewSelected");
            registerFieldEvent.setParams({
                'viewName': viewName
            });
            registerFieldEvent.fire();
        } catch(e) {
            console.log(e);
        }
    },
    selectView : function(component, event, helper) {
        try{
            var params = event.getParam('arguments');
            if (params.viewName) {
                component.set('v.selectedView', params.viewName);
                helper.selectView(component);
            }
        } catch(e) {
            console.log(e);
        }
    }
});