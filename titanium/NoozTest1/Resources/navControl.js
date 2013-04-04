exports.windowStack = [];

exports.pushView = function(win) {
    exports.windowStack.push(win);
    var that = exports;
    win.addEventListener("close", function() {
        that.windowStack.pop();
    });
    win.navBarHidden = win.navBarHidden || !1;
    win.open();
};

exports.popView = function() {
    if (exports.windowStack.length == 0) return;
    var win = _.last(exports.windowStack);
    win.close();
};