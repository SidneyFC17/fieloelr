({
	doInit : function(component, event, helper) {
        try{
            var config = component.get('v.config');
            var url = component.get('v.url');
            var fileExtension = component.get('v.fileExtension');
            var disableControls = component.get('v.disableControls');
            var type = component.get('v.mediaType').toLowerCase();
            component.set('v.type', type);
            
            var urls = url.split(',');
            console.log('url: ' + url);
            if (urls) {
                var newUrls = [];
                urls.forEach(function(urlToTest) {
                    if (urlToTest.indexOf('https://') == -1) {
						newUrls.push( config.communityURL + urlToTest.replace(new RegExp('^\/'),'') );
                    }
                });
                console.log('new urs: ' + newUrls);
                if (newUrls.length > 0) {
                	component.set('v.url', newUrls.join(','));    
                }
            }
            
            if (type == 'youtube video') {
                var videoUrl = component.get('v.url');
                var firstParam = videoUrl.toLowerCase().indexOf('?') == -1 ?
                    '?' :
                	'&';
                var params = [];
                if (videoUrl.toLowerCase().indexOf('rel=') == -1) {
                    params.push('rel=0');
                }
                if (videoUrl.toLowerCase().indexOf('showinfo=') == -1) {
                    params.push('showinfo=0');
                }
                if (disableControls) {
                    if (videoUrl.toLowerCase().indexOf('controls=') == -1) {
                        params.push('controls=0');
                    }
                    if (videoUrl.toLowerCase().indexOf('disablekb=') == -1) {
                        params.push('disablekb=1');
                    }
                }
                if (params.length > 0) {
                    videoUrl += firstParam + params.join('&');
                }
                component.set('v.url', videoUrl);
            }
            component.set('v.type', component.get('v.mediaType').toLowerCase());
        } catch(e) {
            console.log(e);
        }
	}
})