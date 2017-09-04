({
	doInit : function(component, event, helper) {
        console.log('nico');
        var question = component.get('v.question');
        console.log(question);
        component.set('v.title', question.FieloELR__QuestionText__c);
        component.set('v.options', question.FieloELR__AnswerOptions__r.records);        
        component.set('v.renderQuestion', true);
        console.log('nico');
	},
    setAnswer: function(component, event, helper){
        
    }
})