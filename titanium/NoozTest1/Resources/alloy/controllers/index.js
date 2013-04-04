function Controller() {
    require("alloy/controllers/BaseController").apply(this, Array.prototype.slice.call(arguments));
    $model = arguments[0] ? arguments[0].$model : null;
    var $ = this, exports = {}, __defers = {};
    $.__views.index = Alloy.createController("articleList", {
        id: "index"
    });
    $.addTopLevelView($.__views.index);
    exports.destroy = function() {};
    _.extend($, $.__views);
    var pWidth = Ti.Platform.displayCaps.platformWidth, pHeight = Ti.Platform.displayCaps.platformHeight;
    Ti.App.SCREEN_WIDTH = pWidth > pHeight ? pHeight : pWidth;
    Ti.App.SCREEN_HEIGHT = pWidth > pHeight ? pWidth : pHeight;
    $.index.getView().open();
    _.extend($, exports);
}

var Alloy = require("alloy"), Backbone = Alloy.Backbone, _ = Alloy._, $model;

module.exports = Controller;