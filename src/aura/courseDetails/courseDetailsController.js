({
    doInit: function (component, event, helper) {
        try{
            helper.getDetailFields(component);
            if (component.get('v.courseDetailFields')) {
            	helper.getFieldsMeta(component, 'FieloELR__Course__c', helper.addCourseRequiredFields(component.get("v.courseDetailFields")));
            }
            if (component.get('v.courseStatusDetailFields')) {
            	helper.getFieldsMeta(component, 'FieloELR__CourseStatus__c', component.get('v.courseStatusDetailFields'));
            }
        } catch(e) {
            console.log(e);
        }
    },
    updateMember: function (component, event, helper) {
        try {
            var member = event.getParam('member');
            component.set('v.member', member);
            window.localStorage.setItem('member', JSON.stringify(member));
            
            /* Call order
             * - helper.getConfig
             * - helper.retrieveCourse
             * - helper.loadCourseStatus
             * - helper.setFieldSet
             * - helper.setButtons
             **/
            helper.getConfig(component);
        } catch (e) {
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
    refreshContent: function(component, event, helper) {
        try{
            console.log('refreshContent');
            $A.get("e.force:refreshView").fire();
        } catch(e) {
            console.log(e);
        }
    }
})