({
    doInit: function(component, event, helper){                
        var fieldset = [{apiName: "Name", type: "subcomponent", subcomponent: "ShowCourse", label: "Name", showLabel: true}, {apiName: "FieloELR__Progress__c", type: "subcomponent", subcomponent: "ProgressBar", label: "Progress", showLabel: true}]
        var modulesFieldset = [{apiName: "Name", type: "output", label: "Name", showLabel: true}, {apiName: "FieloELR__Description__c", type: "output", label: "Description", showLabel: true}, {apiName: "FieloELR__ApprovalGrade__c", type: "output", label: "Approval Grade", showLabel: true}];
        component.set('v.title', 'My Courses');
        component.set('v.modulesFieldset', modulesFieldset);
        component.set('v.fieldset', fieldset);
    },
    updateMember: function(component, event, helper){
        var member = event.getParam('member');        
        component.set('v.member', member);        
        helper.loadCourses(component, event, helper);        
    },
    showCourse: function(component, event, helper){         
        var course = event.getParam('record');        
        var modulesList = [];
        var modules = course.modules;        
        for(var i = 0; i < modules.length; i++){
            var newModule = modules[i].module;
            newModule.moduleResponses = modules[i].moduleResponses;
            newModule.numberOfAttempts = modules[i].numberOfAttempts;
            newModule.isApproved = modules[i].isApproved;
            modulesList.push(newModule);
        }                
        component.set('v.modules', modulesList);
        component.set('v.courseTitle', course.Name);
        component.set('v.showMyCourses', false);
        component.set('v.showCourse', true);            
    },
    showCoursesList: function(component, event, helper){
        component.set('v.showMyCourses', true);        
        component.set('v.showCourse', false); 
    }
})