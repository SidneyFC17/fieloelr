({
    getLastModuleResponse : function(component) {
        try{
            var moduleResponses = component.get('v.moduleResponses');
            var moduleWrapper = component.get('v.moduleWrapper');
            var passed = moduleWrapper.isApproved;
            if (moduleResponses) {
                if (passed) {
                    moduleResponses = moduleResponses.filter(function(mr) {
                        return mr.FieloELR__Module__c == moduleWrapper.module.Id &&
                            mr.FieloELR__IsApproved__c &&
                            mr.FieloELR__NumberofApprove__c == 1;
                    });
                } else {
                    moduleResponses = moduleResponses.filter(function(mr) {
                        return mr.FieloELR__Module__c == moduleWrapper.module.Id &&
                            mr.FieloELR__NumberOfAttempt__c == moduleWrapper.numberOfAttempts;
                    });
                }
            }
            if (moduleResponses) {
                if (moduleResponses.length == 1) {
                    component.set('v.moduleResponse', moduleResponses[0]);
                }
            }
        } catch(e) {
            console.log(e);
        }
    }
})