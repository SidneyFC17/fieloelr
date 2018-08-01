({
	doInit : function(component, event, helper) {
        try{
            console.log('doInit');
            console.log('courseId: ' + component.get('v.recordId'));
        } catch(e) {
            console.log(e);
        }
	},
    updateMember: function(component, event, helper){
        try{
            console.log('updateMember');
            var member = event.getParam('member');
            component.set('v.member', member);
            window.localStorage.setItem('member', JSON.stringify(member));
            helper.getConfig(component);
        } catch(e) {
            console.log(e);
        }
    }
})