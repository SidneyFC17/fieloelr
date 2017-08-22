({
    doInit : function(component, event, helper) {
        console.log('Falta definir y procesar configuracion');
        var fieldset = [{apiName: "Name", type: "subcomponent", subcomponent: "ShowCourse", label: "Name", showLabel: true}, {apiName: "FieloELR__Description__c", type: "output", label: "Description", showLabel: true}, {apiName: "JoinCourse", type: "subcomponent", subcomponent: "JoinCourse", label: "Join Course", showLabel: false}]
        var modulesFieldset = [{apiName: "Name", type: "output", label: "Name", showLabel: true}, {apiName: "FieloELR__Description__c", type: "output", label: "Description", showLabel: true}, {apiName: "FieloELR__ApprovalGrade__c", type: "output", label: "Approval Grade", showLabel: true}, {apiName: "TakeModule", type: "subcomponent", subcomponent: "TakeModule", label: "", showLabel: false}];
        component.set('v.fieldset', fieldset);
        component.set('v.modulesFieldset', modulesFieldset);
        component.set('v.title', 'Courses');
    },
    updateMember: function(component, event, helper){
        var member = event.getParam('member');        
        component.set('v.member', member);        
        helper.loadCourses(component, event, helper);        
    },
    showCourse: function(component, event, helper){
        var modulesRecord = event.getParam('record');        
        var modulesList = [];
        var modules = modulesRecord.modules;        
        for(var i = 0; i < modules.length; i++){
            var newModule = modules[i].module;
            newModule.moduleResponses = modules[i].moduleResponses;
            newModule.numberOfAttempts = modules[i].numberOfAttempts;
            newModule.isApproved = modules[i].isApproved;
            modulesList.push(newModule);
        }                
        var courseName = event.getParam('courseName');
        component.set('v.courseTitle', courseName);
        component.set('v.showCoursesList', false);        
        component.set('v.modules', modulesList);        
        component.set('v.showCourse', true);        
    },
    showCoursesList: function(component, event, helper){
        component.set('v.showCoursesList', true);        
        component.set('v.showCourse', false); 
    }
})