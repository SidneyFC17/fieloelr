({
    doInit : function(component, event, helper){
        var course = component.get('v.record');
        var courseId = course.FieloELR__Course__c;
        var joinedCourses = window.localStorage.getItem('joinedCourses') || '{}';
        joinedCourses = JSON.parse(joinedCourses);
        if(joinedCourses[courseId]){
            component.set('v.takeModule', true);
        }
    },
    takeModule: function(component, event, helper){

    }
})