({
	doInit : function(component, event, helper) {
        var moduleId = component.get('v.module').Id;
        var answer = {};
        answer[moduleId] = {};
        window.localStorage.setItem('moduleAnswer', JSON.stringify(answer));
	},
    showAnswer : function(component, event, helper) {
        console.log(JSON.parse(window.localStorage.getItem('moduleAnswer')));
    }
})