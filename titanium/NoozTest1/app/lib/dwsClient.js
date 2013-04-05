/**
 * @author Tim Hingston
 */

function dwsClient () {
	
	var _API_BASE_URL = "http://api.media.dp.discovery.com";
	var _API_QUERY = "?format=application/json";
	
	this.getApiUrl = function(resource, site, schema) {
		return _API_BASE_URL + '/' + resource + '/' + site + '/contents' + _API_QUERY + '&schema=' + schema;
	};
	
	var _parseDate = function parseDate(dateString) {
	    // [y, m, d, hr, min, sec]
	    var parts = dateString.match(/\d+/g);
	
	    // Months are 0-indexed
	    parts[1] -= 1;
		var timestamp = Date.UTC.apply(Date, parts);
		var localDate = new Date(timestamp);
	    return localDate;
	};
	
	this.getNewsArticles = function(next, tries) {
		tries = tries || 0;
		var apiUrl = this.getApiUrl('taxonomy', 'discovery+news', 'taxonomy/content/1');
		Ti.API.info('API: ' + apiUrl);
		var api = this;
		var xhr = Titanium.Network.createHTTPClient();
		xhr.setTimeout(15000);
		xhr.setAutoEncodeUrl(false);
		xhr.open('GET', apiUrl);
		xhr.onload =  function(e) {
				var articles = Alloy.Collections.article;
				articles.fetch();
				data = JSON.parse(this.responseText);
				_.each(data.elements, function(item) {
					var imageUrl = '';
					if (item.thumbnail_image) { 
						imageUrl = item.thumbnail_image;
					}
					else if (item.slideshow_thumbnail_image) { 
						imageUrl = item.slideshow_thumbnail_image;
					}
					var pubDate = _parseDate(item.date);
					var article = Alloy.createModel('article', {
						title: item.title,
						description: item.description,
						link: item.href,
						pubDate: pubDate,
						timestamp: pubDate.getTime(),
						thumbnail: imageUrl
					});
					articles.add(article);
				}); // _.each
				next(null, articles);
			};
		xhr.onerror = function(e) {
			if (tries < 3) {
				tries++;
				api.getNewsArticles(next, tries);
			}
			else {
				next({message: e.error});
			}
		};
		xhr.send();	
	};
}


module.exports = dwsClient;