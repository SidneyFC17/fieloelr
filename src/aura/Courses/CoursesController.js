({
    doInit : function(component, event, helper) {
        try{
            helper.getFields(component);
            helper.getFilterFieldSet(component);
            helper.getCourseFieldSet(component);
            helper.getConfiguration(component);
            var title, fields, fieldset;
        } catch(e) {
            console.log(e);
            component.set('v.error', e);
            component.set('v.showError', true);
        }
    },
    getFieldSet: function(component, event, helper) {
        try{
            helper.getFieldSet(component);
        } catch(e) {
            console.log(e);
        }
    },
    updateMember: function(component, event, helper){
        try{
            var member = event.getParam('member');
            component.set('v.member', member);       
            window.localStorage.setItem('member', JSON.stringify(member));
            helper.updateButtons(component);
            helper.loadCourses(component, event, helper, 0);
        } catch(e) {
            console.log(e);
        }
    },
    handleFilterRecords: function(component, event, helper) {
        try{
            var dynamicFilterString = event.getParam('dynamicFilter');
            var sortByClause = event.getParam('sortByClause');
            console.log(JSON.stringify(event.getParams(), null, 2));
            component.set('v.dynamicFilterString', dynamicFilterString);
            component.set('v.sortByClause', sortByClause);
            helper.loadCourses(component, event, helper, 0);   
        } catch(e) {
            console.log(e);
        }
    },
    handleCourseViewSelected: function(component, event, helper){
        try{
            event.stopPropagation();
            var viewName = event.getParam('viewName');
            console.log(viewName);
            component.set('v.activeViewName', viewName);
            helper.updateButtons(component);
            $A.enqueueAction(component.get('c.getFieldSet'));
            $A.enqueueAction(component.get('c.loadCourses'));
        } catch(e) {
            console.log(e);
        }
    },
    loadCourses: function(component, event, helper) {
        try{
            helper.loadCourses(component, event, helper, 0);
        } catch(e) {
            console.log(e);
        }
    },
    reloadCourses: function(component, event, helper){
        helper.loadCourses(component, event, helper, 0);        
    },
    paginator: function(component, event, helper){
        var offset = event.getParam("offset");        
        helper.loadCourses(component, event, helper, offset);
    }
})