/**
 * @author Tim Hingston
 */
var dwsUtils = require('/dwsUtils');

function rssFeed () {

	var _MONTH_MAP = { JAN: 1, FEB: 2, MAR: 3, APR: 4, MAY: 5, JUN: 6, JUL: 7, AUG: 8, SEP: 9, OCT: 10, NOV: 11, DEC: 12 };
	var _getRssText = function(item, key) {
		return item.getElementsByTagName(key).item(0).text;
	};
	
	var _parseDate = function(dateString) {
		var dateParts = dateString.split(' ');
		return dateParts[3] + '-' + dwsUtils.padZero(_MONTH_MAP[dateParts[2].toUpperCase()], 2) + '-' + dateParts[1] 
			+ ' ' + dateParts[4];
	};
	
	this.getFeed = function(rssUrl, next, tries) {
		var xhr = Titanium.Network.createHTTPClient();	
		tries = tries || 0;
		xhr.open('GET', rssUrl);
		xhr.onload = function(e) {
			var xml = this.responseXML;
	
			if (xml === null || xml.documentElement === null) { 
				if (tries < 3) {
					tries++
					this.getFeed(rssUrl, next, tries);
					return;
				} else {
					next({ 
						message: 'Error reading RSS feed. Make sure you have a network connection and try refreshing.' 
					});
					return;	
				}	
			}
	
			var items = xml.documentElement.getElementsByTagName("item");
			var articles = Alloy.Collections.article;
			articles.fetch();
			for (var i = 0; i < items.length; i++) {
				var item = items.item(i);
				var imageUrl = '/dnews-square.png';
				try {
					var thumbnail = item.getElementsByTagNameNS('http://search.yahoo.com/mrss/', 'thumbnail').item(0);
					if (thumbnail) { 
						imageUrl = thumbnail.getAttribute('url');
					}
				} catch (e) {}
				Ti.API.info(imageUrl);
				var article = Alloy.createModel('article', {
					title: _getRssText(item, 'title').toUpperCase(),
					//description: '<html><body style="margin: 0; height: 64px; color: #ffffff; font-family: \'Helvetica\'; font-size: 8pt">' 
					//	+ _getRssText(item, 'description') + '</body></html>',
					description: _getRssText(item, 'description'),
					link: _getRssText(item, 'link'),
					pubDate: _parseDate(_getRssText(item, 'pubDate')),
					thumbnail: imageUrl
				});
				articles.add(article);
			}
			next(null, articles);
		};
		xhr.onerror = function(e) {
			next({message: e.error});
		};
	
		xhr.send();	
	};
}

module.exports = rssFeed;

