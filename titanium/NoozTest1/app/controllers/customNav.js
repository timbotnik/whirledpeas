var navControl = require ('/navControl');

var gradientNormal = {
		type: "linear",
		startPoint: { x: "0%", y:"0%"},
		endPoint:   { x: "0%", y:"100%"},
		colors: [
			{ color: "#8d8d8d", offset: 0.0 },
			{ color: "#2d2d2d", offset: 1.0 }
		]};

var gradientPressed = {
		type: "linear",
		startPoint: { x: "0%", y:"100%"},
		endPoint:   { x: "0%", y:"0%"},
		colors: [
			{ color: "#8d8d8d", offset: 0.0 },
			{ color: "#2d2d2d", offset: 1.0 }
		]};

$.navLeftButton.addEventListener('click', function() {
	navControl.popView(); 
});

$.navRightButton.addEventListener('click', function() {
	navControl.popView();
});

$.navLeftButton.addEventListener('touchstart', function() {
	$.navLeftButton.backgroundGradient = gradientPressed; 
});

$.navLeftButton.addEventListener('touchend', function() {
	$.navLeftButton.backgroundGradient = gradientNormal;
});

$.navLeftButton.addEventListener('touchcancel', function() {
	$.navLeftButton.backgroundGradient = gradientNormal;
});



/*  // custom animation TBD
function slideTo(xPos) {
    var slide = Titanium.UI.createAnimation();
	slide.left = xPos;
	slide.duration = 300;
	Ti.API.info('Sliding to ' + xPos);
	return slide;	
}

function onItemClicked(e) {  
    setTimeout( function() {
    	var articleView = Alloy.createController('articleView', {feedUrl: e.rowData.link}).getView();
	    articleView.left = Ti.App.SCREEN_WIDTH;
	    articleView.addEventListener('onBackButton', function(e) {
	    	setTimeout( function() {
		    	articleView.animate(slideTo(Ti.App.SCREEN_WIDTH), function() {
		    		articleView.close();
		    		articleView.removeEventListener('onBackButton');
		    	});
		    	$.index.animate(slideTo(0));
	    	}, 50);
	    });
    
    	articleView.open(slideTo(0));
    	$.index.animate(slideTo(-Ti.App.SCREEN_WIDTH));
    }, 50);
}

*/