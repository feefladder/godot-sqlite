extends Node

const SQLite = preload("res://addons/godot-sqlite/bin/gdsqlite.gdns")
var db

const verbosity_level : int = 2

var db_name := "res://my_database.db"

var table_name := "company"

var ids := [1,2,3,4,5,6,7]
var names := ["Paul","Allen","Teddy","Mark","Robert","Julia","Amanda"]
var ages := [32,25,23,25,30,63,13]
var addresses := ["California","Texas","Baltimore","Richmond","Texas","Atlanta","New-York"]
var salaries := [20000.00,15000.00,20000.00,65000.00,65000.00,65000.00,65000.00]

signal output_received(text)
signal texture_received(texture)

func _ready():
	if OS.get_name() in ["Android", "iOS", "HTML5"]:
		db_name = "user://my_database.db"

	# Enable/disable examples here:
	example_of_database_persistency()
	example_of_database_persistency()

func cprint(text : String) -> void:
	print(text)
	emit_signal("output_received", text)

# Basic example that goes over all the basic features available in the addon, such
# as creating and dropping tables, inserting and deleting rows and doing more elementary
# PRAGMA queries.
func example_of_database_persistency():

	# Make a big table containing the variable types.
	var table_dict : Dictionary = Dictionary()
	table_dict["id"] = {"data_type":"int", "primary_key": true, "not_null": true}
	table_dict["count"] = {"data_type":"text", "not_null": true}

	db = SQLite.new()
	db.path = db_name
	db.verbosity_level = verbosity_level
	# Open the database using the db_name found in the path variable
	db.open_db()

	# Create a table with the structure found in table_dict and add it to the database
	db.create_table(table_name, table_dict)

	db.select_rows(table_name, "id = 1", ["count"])
	var query_result : Array = db.query_result
	var count : int = 0
	if query_result.empty():
		# It doesn't exist yet! Add it!
		db.insert_row(table_name, {"id": 1, "count": 0})
	else:
		var result : Dictionary = query_result[0]
		count = int(result.get("count", count))

	cprint("Count is: {0}".format([count]))

	# Increment the value for the next time!
	db.update_rows(table_name, "id = 1", {"count": count + 1 })

	# Close the current database
	db.close_db()
