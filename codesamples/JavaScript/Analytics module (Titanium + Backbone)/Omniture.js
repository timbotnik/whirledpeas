/**
 * @author Tim Hingston
 */

var Analytics = require('/analytics/Analytics');
var dwsUtils = require('/dws/dwsUtils');

var Omniture = Analytics.extend({
	
	//Constants
	_USER_AGENT: 'Mozilla/5.0 ('+ Titanium.Platform.model +'; U; CPU '+ Titanium.Platform.name + ' ' + Titanium.Platform.version + ' like Mac OS X; ' + Ti.Platform.locale + ';) '
		+ 'DiscoveryNews/' + Ti.App.version,

	//Private properties
	_userId: Ti.App.installId || Ti.App.sessionId,
	_storedEvents:0,
	_dispatcherIsBusy:false,
	_reportSuiteId: Alloy.CFG.analytics.OMNITURE_REPORTSUITE_ID,
	_trackingDomain: Alloy.CFG.analytics.OMNITURE_DOMAIN,
	_appName: Alloy.CFG.platform.analytics.OMNITURE_APP_NAME,
	_channelBase: Alloy.CFG.platform.analytics.OMNITURE_CHANNEL_BASE,
	_screenSize: Ti.Platform.displayCaps.platformWidth + 'x' + Ti.Platform.displayCaps.platformHeight + '@' + Ti.Platform.displayCaps.dpi + "DPI",
	_dispatchInterval: undefined,
	_dispatchPeriod: Alloy.CFG.analytics.DISPATCH_PERIOD, 
	
	constructor: function() {},

	//Main public methods
	startSession: function(dispatchPeriod, isAsync){
        DNewsApp.log.debug('STARTING ANALYTICS SESSION ' + Ti.App.sessionId);
		this._isAsync = (isAsync != undefined ? isAsync : true);
		this._initialize();
		this.enabled = true;
		this._sessionId = Ti.App.sessionId;
		var context = this;
		if (!this._dispatchInterval) {
			this._dispatchEvents();
			this._dispatchInterval = setInterval(function() {
				context._dispatchEvents();
			}, dispatchPeriod * 1000);
		}
	},

	stopSession: function(){
		DNewsApp.log.debug('STOPPING ANALYTICS SESSION ' + Ti.App.sessionId);
		this.enabled = false;
		if (this._dispatchInterval) {
			clearInterval(this._dispatchInterval);
			this._dispatchInterval = null;
		}
	},
	
	trackEvent: function(channel, pageName, data) {
		if (this.enabled) {
			this._createEvent(channel, pageName, data);
		}
	},

	// Private methods
	_initialize: function(){
		var events = Alloy.createCollection('TrackingEvent');
		events.fetch();
		this._storedEvents = events.length;
	},

	_createEvent : function(channel, pageName, data) {
		if(this._storedEvents >= 1000) {
			Titanium.API.warn('Analytics: Store full, not storing last event');
			return;
		}
		var evt = Alloy.createModel('TrackingEvent', {
				userId: this._userId,
				channel: this._channelBase + "/" + channel,
				pageName: pageName,
				vars: JSON.stringify(data),
				timestamp: dwsUtils.getCurrentTimestamp()
			});
		evt.save();
		this._storedEvents++;
	},

	_dispatchEvents : function() {
		if(!this._dispatcherIsBusy && Titanium.Network.online){
			this._dispatcherIsBusy = true;

			var events = Alloy.createCollection('TrackingEvent');
			events.fetch();
			var eventsToDelete = [];
			var context = this;
			events.each(function (evt) {
				var host = 'http://' + context._trackingDomain + '/b/ss//6';  // ??
				DNewsApp.log.debug("POST " + host);
				DNewsApp.log.debug("User-Agent: " + context._USER_AGENT);
				var params = context._makeEventParams(_.clone(evt.attributes));
				var httpClient = Titanium.Network.createHTTPClient({
					onload : function(e) {
						//DNewsApp.log.info('OM response: ' + this.responseText);
					},
					onerror : function(e) {
						DNewsApp.log.error('OM error: ' + e.error);
					},
					timeout : 5000  
				});
				
				httpClient.open('POST', host, context._isAsync);
				httpClient.setRequestHeader('User-Agent', context._USER_AGENT);
				httpClient.send(params);
			});

			events.deleteAll();			
			this._dispatcherIsBusy = false;
			events.fetch();
			this._storedEvents = events.length;
		}
	},

	_makeEventParams : function(evt) {
		var time = new Date(evt.timestamp * 1000);
		var params = {
			'reportSuiteID': this._reportSuiteId,
			'ndh': 1,
			'transactionId': this._sessionId,
			'visitorId': evt.userId,
			't': time.toISOString(),
			'ce': 'UTF-8',
			'cc': 'USD', // currency
			'c': 24, // screen color bit depth
			's': this._screenSize, // screen size
			'userAgent': this._USER_AGENT,
			'prop7': Titanium.Platform.name + ' ' + Ti.Platform.version,
			'eVar7': Titanium.Platform.name + ' ' + Ti.Platform.version,
			'prop8': this._appName + ' ' + Ti.App.version,
			'prop49': this._appName,
			'eVar2': this._appName
		};
		
		switch (evt.pageName) {
			default:
		    	//just app view
			    params['channel'] = evt.channel;
			    params['eVar11'] = evt.channel;
			    params['pageName'] = evt.pageName;
			    params['eVar33'] = evt.pageName;
			break;
		}
		
		var extParams = JSON.parse(evt.vars);
		_.extend(params, extParams);
		
		/* create opening XML elements */
		var xml = '<?xml version=\'1.0\' encoding=\'UTF-8\'' + '?>\n';
		xml += '<request>\n';
		xml += ' <scXmlVer>1.0</scXmlVer>\n';
				
		/* add elements for all of the hit properties */
		for (var name in params) {
			xml += ' <' + name + '>';
			xml += params[name]; //Ti.Network.encodeURIComponent(params[name]);
			xml += '</' + name + '>\n';
		}
		
		/* close the XML request */
		xml += '</request>\n';
		DNewsApp.log.debug(xml);
		return xml;
	}
});

module.exports = Omniture;