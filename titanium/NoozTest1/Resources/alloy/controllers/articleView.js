function Controller() {
    require("alloy/controllers/BaseController").apply(this, Array.prototype.slice.call(arguments));
    $model = arguments[0] ? arguments[0].$model : null;
    var $ = this, exports = {}, __defers = {};
    $.__views.articleView = Ti.UI.createWindow({
        backgroundColor: "white",
        id: "articleView"
    });
    $.addTopLevelView($.__views.articleView);
    $.__views.customNav = Alloy.createController("customNav", {
        id: "customNav"
    });
    $.__views.customNav.setParent($.__views.articleView);
    $.__views.articleWebView = Ti.UI.createWebView({
        top: 40,
        height: "auto",
        id: "articleWebView"
    });
    $.__views.articleView.add($.__views.articleWebView);
    exports.destroy = function() {};
    _.extend($, $.__views);
    var args = arguments[0] || {};
    $.articleWebView.url = args.feedUrl || "";
    $.customNav.getView("navLeftButton").title = " < ";
    $.customNav.getView("navLeftButton").visible = !0;
    _.extend($, exports);
}

var Alloy = require("alloy"), Backbone = Alloy.Backbone, _ = Alloy._, $model;

module.exports = Controller;