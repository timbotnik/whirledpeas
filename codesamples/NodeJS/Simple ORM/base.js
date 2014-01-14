var mysql = require('mysql')
  , config = require('../dbconfig');

//
//  Model_Message
//
//  Created by Tim Hingston on 1/12/13.
//  Copyright (c) 2013 Tim Hingston. All rights reserved.
//


/** 
 * A very thin ORM that simplifies some CRUD operations for MySQL.
 * Assumes a unique primary key column called 'id'.
 */


/** 
	* Constructs a base DAO / model object.
	* @param tableName The backing table to use with queries.
	* @param dbConfig A database configuration.
	*/
var Model = function (tableName, dbConfig) {
  this.tableName = tableName;
  this.dbConfig = dbConfig ? dbConfig : 'default';
  this.db = null;
  this.id = null;
  this.createdAt = null;
  this.updatedAt = null;
};

/** 
	* Reads a single object into memory from the database.
	* @param id The ID of the object.
	* @param columns An array of columns to select.
	* @param fn The callback to execute when finished.
	*/
Model.prototype.load = function (id, columns, fn) {
  this.id = id;
  this.refresh(columns, fn);
};

/** 
	* Returns the count of some set of conditions for this table.
	* @param fields An array of column => value conditions (currently only '=' supported)
	* @param fn The callback to execute when finished.
	*/
Model.prototype.count = function (fields, fn) {
  var sql = "SELECT ";
  if (!fields) {
    fn(new Error('no fields supplied')); 
    return;
  } 
  sql += " COUNT(*) AS total";
  sql += " FROM " + this.tableName;
  var first = true;
	var params = [];
  for (f in fields) {
    if (first) {
      first = false;
      sql += " WHERE ";
    }
    else 
      sql += " AND ";

    sql += f + " = ?";
		params.push(fields[f]);
  } 
  sql += ";";
	//console.log(sql);
  this.dbStart().query(sql, params, function (e, rows, cols) {
    this.dbEnd();
    fn(e, e || rows[0].total);
  }.bind(this));  
};

/** 
	* Returns a single object based on some set of conditions for this table.
	* @param fields An array of column => value conditions (currently only '=' supported)
	* @param fn The callback to execute when finished.
	*/
Model.prototype.find = function (fields, fn) {
  var sql = "SELECT ";
  if (!fields) {
    fn(new Error('no fields supplied')); 
    return;
  }
  sql += " * ";
  sql += " FROM " + this.tableName;
  var first = true;
	var params = [];
  for (f in fields) {
    if (first) {
      first = false;
      sql += " WHERE ";
    }
    else 
      sql += " AND ";

    sql += f + " = ?";
		params.push(fields[f]);
  }
  sql += " LIMIT 1;";
	//console.log(sql);
  this.dbStart().query(sql, params, function (e, rows, cols) {
    this.dbEnd();
 		if (!e) {
	    if (rows.length != 1)
	      e = new Error("no records found");
			else
				this.values(rows[0]);
		}
    if (fn)
			fn(e, this);
  }.bind(this));  
};

/** 
	* Synchronizes an object by bringing it up-to-date with the database.
	* @param columns An array of columns to select for.
	* @param fn The callback to execute when finished.
	*/
Model.prototype.refresh = function (columns, fn) {
  var sql = "SELECT ";
  if (columns)
    sql += columns + " ";
  else 
    sql += "* ";
  
  sql += "FROM " + this.tableName + " WHERE id = ? LIMIT 1";
  sql += ";";

  this.dbStart().query(sql, [this.id], function (e, rows, cols) {
    this.dbEnd();
		if (!e) {
	    if (rows.length != 1)
	      e = new Error("no records found");
			else
				this.values(rows[0]);
		}
    if (fn)
			fn(e, this);
  }.bind(this));  
};

/** 
	* Updates the database record for this object.
	* @param fields An array of column => value conditions.
	* @param fn The callback to execute when finished.
	*/
Model.prototype.update = function (fields, fn) {
  var sql = "UPDATE ";
  if (!fields) {
    fn(new Error('no fields supplied')); 
    return;
  }
  sql += this.tableName + " ";
	var params = [];
	var i = Object.keys(fields).length;
  for (f in fields) {
		sql += "SET " + f + " = ?";
		if (--i != 0)
			sql += ",";
		params.push(fields[f]);
  }
  sql += " WHERE id = ?;";
	params.push(this.id);
	
  this.dbStart().query(sql, params, function (e, rows, cols) {
    this.dbEnd();
		if (!e) {
    	this.values(fields);
		}	
		if (fn) {
			//console.log('updated ' + JSON.stringify(this));
    	fn(e, this);
		}
  }.bind(this));  
};


/** PRIVATE **/

Model.prototype.dbStart =  function () {
  if (this.db) {
    this.db.end();
    this.db = null;
  }

  this.db = mysql.createConnection(config.db(this.dbConfig));
  this.db.connect();
  return this.db;
};

Model.prototype.dbEnd =  function() {
  if (this.db) 
    this.db.end()
  this.db = null;
};

Model.prototype.values = function (props) {
  for (key in props) {
		this[key] = props[key];
  }
  return this;
}; 


module.exports = Model;
