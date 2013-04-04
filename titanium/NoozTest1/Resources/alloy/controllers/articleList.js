function Controller() {
    function rssFeedResponse(error, feeds) {
        error && alert(error.message);
    }
    function onItemClicked(e) {
        var articleView = Alloy.createController("articleView", {
            feedUrl: e.rowData.link
        }).getView();
        navControl.pushView(articleView);
    }
    require("alloy/controllers/BaseController").apply(this, Array.prototype.slice.call(arguments));
    $model = arguments[0] ? arguments[0].$model : null;
    var $ = this, exports = {}, __defers = {};
    Alloy.Collections.instance("article");
    $.__views.articleList = Ti.UI.createWindow({
        navBarHidden: !0,
        id: "articleList"
    });
    $.addTopLevelView($.__views.articleList);
    $.__views.customNav = Alloy.createController("customNav", {
        id: "customNav"
    });
    $.__views.customNav.setParent($.__views.articleList);
    $.__views.articleTable = Ti.UI.createTableView({
        top: 40,
        width: Ti.UI.FILL,
        backgroundColor: "black",
        separatorStyle: Ti.UI.iPhone.TableViewSeparatorStyle.NONE,
        id: "articleTable"
    });
    $.__views.articleList.add($.__views.articleTable);
    var __alloyId6 = function(e) {
        var models = Alloy.Collections.article.models, len = models.length, rows = [];
        for (var i = 0; i < len; i++) {
            var __alloyId4 = models[i];
            __alloyId4.__transform = {};
            var __alloyId5 = Alloy.createController("articleRow", {
                id: "__alloyId2",
                $model: __alloyId4
            });
            rows.push(__alloyId5.getViewEx({
                recurse: !0
            }));
        }
        $.__views.articleTable.setData(rows);
    };
    Alloy.Collections.article.on("fetch destroy change add remove reset", __alloyId6);
    onItemClicked ? $.__views.articleTable.addEventListener("click", onItemClicked) : __defers["$.__views.articleTable!click!onItemClicked"] = !0;
    exports.destroy = function() {
        Alloy.Collections.article.off("fetch destroy change add remove reset", __alloyId6);
    };
    _.extend($, $.__views);
    var rssFeed = require("/rssFeed"), navControl = require("/navControl"), rss = new rssFeed;
    rss.getFeed("http://feeds.feedburner.com/DiscoveryNews-Top-Stories?format=xml", rssFeedResponse, 0);
    $.articleList.addEventListener("close", function() {
        $.destroy();
    });
    __defers["$.__views.articleTable!click!onItemClicked"] && $.__views.articleTable.addEventListener("click", onItemClicked);
    _.extend($, exports);
}

var Alloy = require("alloy"), Backbone = Alloy.Backbone, _ = Alloy._, $model;

module.exports = Controller;