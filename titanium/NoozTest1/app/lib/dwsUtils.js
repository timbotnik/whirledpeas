
exports.MONTH_MAP = [ "Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec" ];

exports.padZero = function(n, p, c) {
    var padChar = typeof c !== 'undefined' ? c : '0';
    var pad = new Array(1 + p).join(padChar);
    return (pad + n).slice(-pad.length);
};
	
exports.formatDate = function(dateObj) {
	var currDay = dateObj.getDate();
    var currMonth = dateObj.getMonth();
    var currYear = dateObj.getFullYear();
    var hours = dateObj.getHours();
    var minutes = dateObj.getMinutes();
    var ampm = 'AM';
    if (hours > 12) {
    	ampm = 'PM';
    	hours -= 12;
    }
    return exports.MONTH_MAP[currMonth] + ' ' + exports.padZero(currDay, 2) 
    	+ ' ' + exports.padZero(hours, 2) + ':' + exports.padZero(minutes, 2) + ampm;
};
