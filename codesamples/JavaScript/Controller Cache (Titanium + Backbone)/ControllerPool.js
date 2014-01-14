var dwsUtils = require('/dws/dwsUtils');

var ControllerPool = function() {
	
	var _pool = [];
	var _wasOffline = false;
	
	var _CACHE_SIZE = Alloy.CFG.cache.CONTROLLER_POOL_SIZE;
	
	var _getCacheId = function(controllerName, args) {
		var url = "controller://" + controllerName + "?" + dwsUtils.toQueryString(args);
		DNewsApp.log.debug("CACHE URL: " + url);
		var cacheId = Ti.Utils.md5HexDigest(url);
		return cacheId; 
	};
	
	var _isFresh = function(expiration) {
		var now = new Date(); 
		return expiration > now.getTime(); 
	};	
	
	this.isCacheable = function(controller) {
		return controller.isCacheable();
	};
	
	this.forceRefresh = function() {
		for (var i in _pool) {
			var obj = _pool[i];
			var now = new Date();
			obj.expiration = now.getTime();
		}
	};
	
	this.markAsStale = function(cacheId) {
		var objs = _.where(_pool, { cacheId: cacheId });
		if (objs.length > 0) {
			var obj = objs[0];
			var now = new Date();
			obj.expiration = now.getTime();
		}
	};
	
	this.remove = function(cacheId, onDestroy) {
		var objs = _.where(_pool, { cacheId: cacheId });
		if (objs.length > 0) {
			var obj = objs[0];
			if (onDestroy) {
				onDestroy(obj.controller);
			}
			var idx = _pool.indexOf(obj);
			_pool.splice(idx, 1);
		}
	};
	
	this.fetch = function(controllerName, args, onDestroy) {
		var cacheId = _getCacheId(controllerName, args);
		var objs = _.where(_pool, { cacheId: cacheId });
		var controller = null;
		if (objs.length > 0) {
			var obj = objs[0];
			if (_isFresh(obj.expiration) && (obj.wasOnline || !Ti.Network.online)) {
				controller = obj.controller;
			}
			else {
				onDestroy(obj.controller);
				var idx = _pool.indexOf(obj);
				_pool.splice(idx, 1);
			}
		}
		return controller;
	};
	
	this.store = function(controllerName, args, controller, onDestroy) {
		var cacheId = _getCacheId(controllerName, args);
		controller.__cacheId = cacheId;
		if (!this.isCacheable(controller)) {
			return;
		}
		if (_pool.length + 1 > _CACHE_SIZE) {
			var obj = _pool.shift();
			onDestroy(obj.controller);
		}
		var now = new Date();
		var expirationDate = new Date(now.getTime() + Alloy.CFG.cache.MAX_RESYNC_TIMEOUT_SEC * 1000);
		var obj = {
			cacheId: cacheId,
			expiration: expirationDate.getTime(),
			wasOnline: Ti.Network.online,
			controllerName: controllerName,
			args: args,
			controller: controller
		};
		_pool.push(obj);
	};
};

module.exports = ControllerPool;