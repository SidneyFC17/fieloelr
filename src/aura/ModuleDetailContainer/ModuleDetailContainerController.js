({
    doInit: function(component, event, helper) {
        try{
            var moduleResponseWrapper = JSON.parse(window.localStorage.getItem('currentModuleReponse'));
            if (moduleResponseWrapper) {
                component.set('v.moduleInProgress', true);
            }
            helper.getConfig(component);
            helper.getModuleFieldsData(component);
            helper.getModuleResponseFieldsData(component);
        } catch(e) {
            console.log(e);
        }
    },
    updateMember: function(component, event, helper){
        try{
            var member = event.getParam('member');
            component.set('v.member', member);       
            window.localStorage.setItem('member', JSON.stringify(member));
            helper.getModuleData(component);
        } catch(e) {
            console.log(e);
        }
    },
    backToCourses: function(component, event, helper) {
        try{
            $A
            .get("e.force:navigateToObjectHome")
            .setParams({"scope": "FieloELR__Course__c"})
            .fire();
        } catch(e) {
            console.log(e);
        }
    },
    backToParentCourse: function(component, event, helper) {
        try{
            $A
            .get("e.force:navigateToSObject")
            .setParams({"recordId": component.get('v.course').Id})
            .fire();
        } catch(e) {
            console.log(e);
        }
    },
    toggleContent: function(component, event, helper){
        try{
            component.set('v.isCollapsed', !component.get('v.isCollapsed'));
        } catch(e) {
            console.log(e);
        }
    }
})