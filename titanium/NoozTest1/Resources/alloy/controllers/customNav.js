function Controller() {
    require("alloy/controllers/BaseController").apply(this, Array.prototype.slice.call(arguments));
    $model = arguments[0] ? arguments[0].$model : null;
    var $ = this, exports = {}, __defers = {};
    $.__views.discoveryNavBar = Ti.UI.createView({
        backgroundColor: "black",
        top: 0,
        width: Ti.UI.FILL,
        height: 40,
        backgroundGradient: {
            type: "linear",
            startPoint: {
                x: "0%",
                y: "0%"
            },
            endPoint: {
                x: "0%",
                y: "100%"
            },
            colors: [ {
                color: "#8d8d8d",
                offset: 0
            }, {
                color: "#2d2d2d",
                offset: 1
            } ]
        },
        id: "discoveryNavBar"
    });
    $.addTopLevelView($.__views.discoveryNavBar);
    $.__views.navLeftButton = Ti.UI.createButton({
        left: 10,
        width: 40,
        height: 36,
        backgroundGradient: {
            type: "linear",
            startPoint: {
                x: "0%",
                y: "0%"
            },
            endPoint: {
                x: "0%",
                y: "100%"
            },
            colors: [ {
                color: "#8d8d8d",
                offset: 0
            }, {
                color: "#2d2d2d",
                offset: 1
            } ]
        },
        backgroundImage: "none",
        backgroundSelectedColor: "black",
        color: "white",
        borderColor: "#4d4d4d",
        borderWidth: 2,
        borderRadius: 6,
        visible: !1,
        id: "navLeftButton"
    });
    $.__views.discoveryNavBar.add($.__views.navLeftButton);
    $.__views.discoveryNavLogo = Ti.UI.createImageView({
        width: 200,
        image: "/discovery-news-logo.png",
        id: "discoveryNavLogo"
    });
    $.__views.discoveryNavBar.add($.__views.discoveryNavLogo);
    $.__views.navRightButton = Ti.UI.createButton({
        right: 10,
        width: 40,
        height: 36,
        backgroundGradient: {
            type: "linear",
            startPoint: {
                x: "0%",
                y: "0%"
            },
            endPoint: {
                x: "0%",
                y: "100%"
            },
            colors: [ {
                color: "#8d8d8d",
                offset: 0
            }, {
                color: "#2d2d2d",
                offset: 1
            } ]
        },
        backgroundImage: "none",
        backgroundSelectedColor: "black",
        color: "white",
        borderColor: "#4d4d4d",
        borderWidth: 2,
        borderRadius: 6,
        visible: !1,
        id: "navRightButton"
    });
    $.__views.discoveryNavBar.add($.__views.navRightButton);
    exports.destroy = function() {};
    _.extend($, $.__views);
    var navControl = require("/navControl"), gradientNormal = {
        type: "linear",
        startPoint: {
            x: "0%",
            y: "0%"
        },
        endPoint: {
            x: "0%",
            y: "100%"
        },
        colors: [ {
            color: "#8d8d8d",
            offset: 0
        }, {
            color: "#2d2d2d",
            offset: 1
        } ]
    }, gradientPressed = {
        type: "linear",
        startPoint: {
            x: "0%",
            y: "100%"
        },
        endPoint: {
            x: "0%",
            y: "0%"
        },
        colors: [ {
            color: "#8d8d8d",
            offset: 0
        }, {
            color: "#2d2d2d",
            offset: 1
        } ]
    };
    $.navLeftButton.addEventListener("click", function() {
        navControl.popView();
    });
    $.navRightButton.addEventListener("click", function() {
        navControl.popView();
    });
    $.navLeftButton.addEventListener("touchstart", function() {
        $.navLeftButton.backgroundGradient = gradientPressed;
    });
    $.navLeftButton.addEventListener("touchend", function() {
        $.navLeftButton.backgroundGradient = gradientNormal;
    });
    $.navLeftButton.addEventListener("touchcancel", function() {
        $.navLeftButton.backgroundGradient = gradientNormal;
    });
    _.extend($, exports);
}

var Alloy = require("alloy"), Backbone = Alloy.Backbone, _ = Alloy._, $model;

module.exports = Controller;