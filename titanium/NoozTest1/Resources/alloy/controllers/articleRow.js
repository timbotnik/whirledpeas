function Controller() {
    require("alloy/controllers/BaseController").apply(this, Array.prototype.slice.call(arguments));
    $model = arguments[0] ? arguments[0].$model : null;
    var $ = this, exports = {}, __defers = {};
    $.__views.articleRow = Ti.UI.createTableViewRow({
        backgroundColor: "black",
        height: 120,
        className: "articleRow",
        link: typeof $model.__transform.link != "undefined" ? $model.__transform.link : $model.get("link"),
        hasDetail: "true",
        id: "articleRow"
    });
    $.addTopLevelView($.__views.articleRow);
    $.__views.__alloyId7 = Ti.UI.createLabel({
        top: 2,
        left: 6,
        color: "#ffffff",
        font: {
            fontSize: 10
        },
        text: typeof $model.__transform.pubDate != "undefined" ? $model.__transform.pubDate : $model.get("pubDate"),
        id: "__alloyId7"
    });
    $.__views.articleRow.add($.__views.__alloyId7);
    $.__views.__alloyId8 = Ti.UI.createImageView({
        width: 96,
        height: 96,
        left: 6,
        top: 18,
        image: typeof $model.__transform.thumbnail != "undefined" ? $model.__transform.thumbnail : $model.get("thumbnail"),
        defaultImage: "/dnews-square.png",
        id: "__alloyId8"
    });
    $.__views.articleRow.add($.__views.__alloyId8);
    $.__views.__alloyId9 = Ti.UI.createLabel(function() {
        var o = {};
        _.extend(o, {});
        Alloy.isHandheld && _.extend(o, {
            top: 16,
            left: 108,
            color: "#80b4d6",
            width: Ti.UI.FILL,
            font: {
                fontWeight: "bold",
                fontSize: 10
            }
        });
        _.extend(o, {});
        Alloy.isTablet && _.extend(o, {
            top: 16,
            left: 108,
            color: "#80b4d6",
            width: Ti.UI.FILL,
            font: {
                fontWeight: "bold",
                fontSize: 14
            }
        });
        _.extend(o, {
            text: typeof $model.__transform.title != "undefined" ? $model.__transform.title : $model.get("title"),
            id: "__alloyId9"
        });
        return o;
    }());
    $.__views.articleRow.add($.__views.__alloyId9);
    $.__views.__alloyId10 = Ti.UI.createLabel(function() {
        var o = {};
        _.extend(o, {});
        Alloy.isHandheld && _.extend(o, {
            left: 108,
            color: "#ffffff",
            top: 48,
            width: Ti.UI.FILL,
            height: 64,
            backgroundColor: "black",
            font: {
                fontSize: 10
            }
        });
        _.extend(o, {});
        Alloy.isTablet && _.extend(o, {
            left: 108,
            color: "#ffffff",
            top: 48,
            width: Ti.UI.FILL,
            height: 64,
            backgroundColor: "black"
        });
        _.extend(o, {
            text: typeof $model.__transform.description != "undefined" ? $model.__transform.description : $model.get("description"),
            id: "__alloyId10"
        });
        return o;
    }());
    $.__views.articleRow.add($.__views.__alloyId10);
    exports.destroy = function() {};
    _.extend($, $.__views);
    _.extend($, exports);
}

var Alloy = require("alloy"), Backbone = Alloy.Backbone, _ = Alloy._, $model;

module.exports = Controller;