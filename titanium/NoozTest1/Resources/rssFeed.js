function rssFeed() {
    var _MONTH_MAP = {
        JAN: 1,
        FEB: 2,
        MAR: 3,
        APR: 4,
        MAY: 5,
        JUN: 6,
        JUL: 7,
        AUG: 8,
        SEP: 9,
        OCT: 10,
        NOV: 11,
        DEC: 12
    }, _getRssText = function(item, key) {
        return item.getElementsByTagName(key).item(0).text;
    }, _padZero = function(n, p, c) {
        var padChar = typeof c != "undefined" ? c : "0", pad = (new Array(1 + p)).join(padChar);
        return (pad + n).slice(-pad.length);
    }, _parseDate = function(dateString) {
        var dateParts = dateString.split(" ");
        return dateParts[3] + "-" + _padZero(_MONTH_MAP[dateParts[2].toUpperCase()], 2) + "-" + dateParts[1] + " " + dateParts[4];
    };
    this.getFeed = function(rssUrl, next, tries) {
        var xhr = Titanium.Network.createHTTPClient();
        tries = tries || 0;
        xhr.open("GET", rssUrl);
        xhr.onload = function(e) {
            var xml = this.responseXML;
            if (xml === null || xml.documentElement === null) {
                if (tries < 3) {
                    tries++;
                    this.getFeed(rssUrl, next, tries);
                    return;
                }
                next({
                    message: "Error reading RSS feed. Make sure you have a network connection and try refreshing."
                });
                return;
            }
            var items = xml.documentElement.getElementsByTagName("item"), articles = Alloy.Collections.article;
            articles.fetch();
            for (var i = 0; i < items.length; i++) {
                var item = items.item(i), imageUrl = "/dnews-square.png";
                try {
                    var thumbnail = item.getElementsByTagNameNS("http://search.yahoo.com/mrss/", "thumbnail").item(0);
                    thumbnail && (imageUrl = thumbnail.getAttribute("url"));
                } catch (e) {}
                Ti.API.info(imageUrl);
                var article = Alloy.createModel("article", {
                    title: _getRssText(item, "title").toUpperCase(),
                    description: _getRssText(item, "description"),
                    link: _getRssText(item, "link"),
                    pubDate: _parseDate(_getRssText(item, "pubDate")),
                    thumbnail: imageUrl
                });
                articles.add(article);
            }
            next(null, articles);
        };
        xhr.onerror = function(e) {
            next({
                message: e.error
            });
        };
        xhr.send();
    };
}

module.exports = rssFeed;