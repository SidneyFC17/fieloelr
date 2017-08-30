({
    doInit: function(component, event, helper){
        var module = component.get('v.module');
  		component.set('v.questions', module.questions);
        component.set('v.showQuestions', true);
    },
    showModule : function(component, event, helper) {
        console.log(component.get('v.module'));
    }
})