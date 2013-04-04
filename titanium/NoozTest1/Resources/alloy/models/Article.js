exports.definition = {
    config: {
        columns: {
            title: "text",
            description: "text",
            pubDate: "text",
            thumbnail: "text",
            link: "text"
        },
        adapter: {
            type: "sql",
            collection_name: "articles"
        }
    },
    extendModel: function(Model) {
        _.extend(Model.prototype, {});
        return Model;
    },
    extendCollection: function(Collection) {
        _.extend(Collection.prototype, {
            sort: function(data) {
                data.sort(dateDesc);
            },
            dateDesc: function(thisObject, thatObject) {
                return thisObject.get("pubDate") > thatObject.get("pubDate") ? 1 : thisObject.get("pubDate") < thatObject.get("pubDate") ? -1 : 0;
            }
        });
        return Collection;
    }
};

var Alloy = require("alloy"), _ = require("alloy/underscore")._, model, collection;

model = Alloy.M("article", exports.definition, []);

collection = Alloy.C("article", exports.definition, model);

exports.Model = model;

exports.Collection = collection;