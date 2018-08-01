({
    doInit: function(component, event, helper) {
        try{
            if (!component.get('v.doneAdjust')) {
                var el = component.getElement();
                var wordArray = el.innerHTML.split(' ');
                while(el.scrollHeight > el.offsetHeight) {
                    wordArray.pop();
                    el.innerHTML = wordArray.join(' ') + '...';
                }
            }
            component.set('v.doneAdjust', true)    
        } catch(e) {
            console.log(e);
        }
    }
})