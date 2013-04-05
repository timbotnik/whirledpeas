
var pWidth = Ti.Platform.displayCaps.platformWidth;
var pHeight = Ti.Platform.displayCaps.platformHeight;
Ti.App.SCREEN_WIDTH = (pWidth > pHeight) ? pHeight : pWidth;
Ti.App.SCREEN_HEIGHT = (pWidth > pHeight) ? pWidth : pHeight;

if (OS_IOS) {
	// Set the global navgroup if we are on iOS
	Alloy.Globals.navgroup = $.navgroup;
	$.index.open();	
}
else if (OS_ANDROID) {
	var win = $.index.getView();
	win.setExitOnClose(true);
	win.open();
}