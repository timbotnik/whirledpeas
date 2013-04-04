
exports.windowStack = [];

exports.pushView = function (win) {
	exports.windowStack.push(win);
	var that = exports;
	win.addEventListener('close', function() {
		that.windowStack.pop();
	});
	 
	if (OS_IOS) {
		Alloy.Globals.navgroup.open(win, {navBarHidden: true});	
	} else if (OS_ANDROID) {
		// Android wants this...
		win.navBarHidden = win.navBarHidden || false;
		win.open();
	}
};

exports.popView = function () {
	if (exports.windowStack.length == 0) {
		return;
	}
	var win = _.last(exports.windowStack);
	if (OS_IOS) {
		Alloy.Globals.navgroup.close(win);
	} else if (OS_ANDROID) {
		win.close();
	}
};
