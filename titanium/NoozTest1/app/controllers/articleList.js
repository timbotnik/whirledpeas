var dwsClient = require ('/dwsClient');
var dwsUtils = require ('/dwsUtils');
var navControl = require ('/navControl');

	
function onApiResponse(error, feeds) {
	if (error) 
		alert(error.message);
}

function onItemClicked(e) {  
    var articleView = Alloy.createController('articleView', {feedUrl: e.rowData.link}).getView();
    navControl.pushView(articleView);
}

function formatListItem(article) {
	var pubDate = article.get('pubDate');
	var transform = article.toJSON();
    transform.title = transform.title.toUpperCase();
	transform.pubDate = dwsUtils.formatDate(pubDate); 
	return transform;
}

var api = new dwsClient();
api.getNewsArticles(onApiResponse);

// Free model-view data binding resources when this view-controller closes
$.articleList.addEventListener('close', function() {
    $.destroy();
});
