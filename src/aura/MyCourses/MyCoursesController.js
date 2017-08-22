({
    doInit: function(component, event, helper){        
        var fieldset = [{apiName: "FieloELR__Course__r.Name", type: "output", label: "Name", showLabel: true}, {apiName: "FieloELR__Progress__c", type: "output", label: "Progress", showLabel: true}]
        component.set('v.title', 'My Courses');
        component.set('v.fieldset', fieldset);
    },
     updateMember: function(component, event, helper){
        var member = event.getParam('member');        
        component.set('v.member', member);        
        helper.loadCourses(component, event, helper);        
    }
})