exports.definition = {
	config: {
		columns: {
		    "title": "text",
		    "description": "text",
		    "pubDate": "text",
		    "timestamp": "integer",
		    "thumbnail": "text",
		    "link": "text"
		},
		adapter: {
			type: "sql",
			collection_name: "articles"
		}
	},		
	extendModel: function(Model) {		
		_.extend(Model.prototype, {
			// extended functions and properties go here
		});
		
		return Model;
	},
	extendCollection: function(Collection) {		
		_.extend(Collection.prototype, {
			// extended functions and properties go here
			comparator: function(Model) {
				var ts = Model.get('timestamp');
				return -ts;
			}
		});
		
		return Collection;
	}
}

