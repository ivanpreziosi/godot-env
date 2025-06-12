extends Node

# This script serves as an example of how to use the `DotEnv` singleton
# (provided by the GodotEnv plugin) within a Godot project.
# It demonstrates loading environment variables from a `.env` file,
# accessing them with specific type conversions, handling default values,
# and checking for variable existence.

func _ready() -> void:
	# --- Load Environment Variables ---

	# Load environment variables from a specified `.env` file.
	# We're explicitly pointing to `res://addons/GodotEnv/env_example.env` for this example.
	# In a real project, you might load from `res://.env` (the default) or
	# `user://.env` for exported builds, depending on your setup and needs.
	DotEnv.load_env("res://addons/GodotEnv/env_example.env")

	# --- Debugging and Inspection ---

	# Print a formatted string representation of all loaded environment variables.
	# This is highly useful for debugging to quickly see what variables have been loaded.
	print(DotEnv.dump_as_string())

	# --- Accessing Environment Variables with Type Conversions and Defaults ---

	# Create a dictionary to hold the retrieved and typed environment data.
	# This demonstrates how to fetch variables using the `DotEnv` singleton's
	# type-specific getter methods, along with providing sensible default values.
	var data = {
		# Get "SERVER_NAME" as a String. If not found, default to "bogus: SERVER_NAME".
		"SERVER_NAME" : DotEnv.get_string("SERVER_NAME", "bogus: SERVER_NAME"),

		# Get "IS_PROTECTED" as a Boolean. If not found, default to `false`.
		"IS_PROTECTED" : DotEnv.get_bool("IS_PROTECTED", false),

		# Get "PORT" as an Integer. If not found, default to `-1`.
		"PORT" : DotEnv.get_int("PORT", -1),

		# Get "MODIFIER" as a Float. If not found, default to `5.5`.
		"MODIFIER" : DotEnv.get_float("MODIFIER", 5.5),

		# Get "STRING_NUMBER" using the generic `get_var` method.
		# This will preserve its original type (e.g., string if not parsable as int/float/bool).
		# If not found, default to "nullus".
		"STRING_NUMBER" : DotEnv.get_var("STRING_NUMBER", "nullus"),

		# Get "SALT" as a String. Demonstrates a key with a common variable name.
		"SALT" : DotEnv.get_string("SALT", "nullus salis est"),

		# Get "DATA_PATH" as a String. Example of a path variable.
		"DATA_PATH" : DotEnv.get_string("DATA_PATH", "nulla via est"),

		# Get "DATA FILE" as a String. Example of a key with a space (though generally discouraged in .env keys).
		"DATA FILE" : DotEnv.get_string("DATA FILE", "nullum documentum est"),
	}

	# --- Checking Variable Existence ---

	# Check if the "PORT" variable exists in the loaded environment.
	# Expected: `true` if "PORT" was in `env_example.env`.
	print(DotEnv.has_var("PORT"))

	# Check if a non-existent variable "ZUMURRUDDU" exists.
	# Expected: `false`.
	print(DotEnv.has_var("ZUMURRUDDU"))

	# --- Displaying Retrieved Data ---

	# Define a multi-line format string using GDScript's triple-quoted string literal.
	# This template will be filled with the values retrieved into the `data` dictionary.
	var print_string = '''
	"SERVER_NAME" : {SERVER_NAME},
	"IS_PROTECTED" : {IS_PROTECTED},
	"PORT" : {PORT},
	"MODIFIER" : {MODIFIER},
	"STRING_NUMBER" : {STRING_NUMBER},
	"SALT" : {SALT},
	"DATA_PATH" : {DATA_PATH},
	"DATA FILE" : {DATA FILE},
	'''
	# Use the `format()` method to substitute placeholders in `print_string`
	# with the corresponding values from the `data` dictionary.
	print(print_string.format(data))