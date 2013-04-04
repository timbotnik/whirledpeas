var rssFeed = require ('/rssFeed');
var navControl = require ('/navControl');

function rssFeedResponse(error, feeds) {
	if (error) 
		alert(error.message);
}

function onItemClicked(e) {  
    var articleView = Alloy.createController('articleView', {feedUrl: e.rowData.link}).getView();
    navControl.pushView(articleView);
}

var rss = new rssFeed();
rss.getFeed('http://feeds.feedburner.com/DiscoveryNews-Top-Stories?format=xml', rssFeedResponse, 0);

// Free model-view data binding resources when this view-controller closes
$.articleList.addEventListener('close', function() {
    $.destroy();
});
