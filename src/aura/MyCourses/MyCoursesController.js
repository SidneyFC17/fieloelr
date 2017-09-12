({
    doInit: function(component, event, helper){
        var config = component.get('v.config');      
        if(config){
            config = JSON.parse(config);
            var fieldset = config.Fieldset;
            var courseFieldset = config.Course.Fieldset;
            component.set('v.fieldset', fieldset);
            component.set('v.courseFieldset', courseFieldset);
            component.set('v.title', config.Title);        
            component.set('v.layout', config.Layout.toLowerCase());        
            component.set('v.columns', config.Columns);            
            component.set('v.courseLayout', config.Course.Layout.toLowerCase());                    
            component.set('v.courseColumns', config.Course.Columns);                      
            window.localStorage.setItem('coursesStatus', '{}');            
        }        
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