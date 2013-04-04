exports.definition = {
	config: {
		columns: {
		    "title": "text",
		    "description": "text",
		    "pubDate": "text",
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
			
			sort : function(data) {
				data.sort(dateDesc);
			},
			// Implement the comparator method.
    	    dateDesc : function(thisObject, thatObject) {
			  if (thisObject.get('pubDate') > thatObject.get('pubDate')) {
			    return 1;
			  } else if (thisObject.get('pubDate') < thatObject.get('pubDate')) {
			    return -1;
			  }
			  return 0;
			}
		});
		
		return Collection;
	}
}

