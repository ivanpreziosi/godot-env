extends Node
class_name EnvManager

# A dictionary to store the loaded environment variables.
var _env := {}

# The default path for the .env file.
# This path is used if no custom path is provided when calling load_env().
# By default, it points to the project root in the editor.
var path := "res://.env"

### FUNCTION: load_env(custom_path: String = "") -> void
#
# Loads environment variables from a .env file into the '_env' dictionary.
#
# @param custom_path: An optional custom path to the .env file. If provided,
#                      this path takes precedence over the default path.
#                      Example: "res://data/.env"
#
# This function dynamically determines the .env file path based on whether
# the application is running in the Godot Editor or as an exported build.
# It also includes error handling for non-existent files and robust line parsing.
# Env files should never be packed in your export, but used for installation configurations.
func load_env(custom_path: String = "") -> void:
	var target_path = ""

	# Determine the target path for the .env file.
	if custom_path:
		# If a custom path is provided, use it directly.
		target_path = custom_path
	else:
		# If no custom path, determine the default path based on the execution environment.
		if Engine.is_editor_hint():
			# When running in the Godot editor, default to the project root (res://).
			target_path = "res://.env"
		else:
			# When running as an exported build, default to the same directory
			# as the executable. This is a common practice for runtime configurations.
			target_path = OS.get_executable_path().get_base_dir().path_join(".env")

	# Check if the determined .env file exists.
	if not FileAccess.file_exists(target_path):
		# If the file does not exist, log a warning and exit the function gracefully.
		push_warning("goDotEnv: .env file not found at %s" % target_path)
		return

	# Open the .env file in read mode.
	var file := FileAccess.open(target_path, FileAccess.READ)
	
	# Iterate through each line of the file until the end is reached.
	while not file.eof_reached():
		# Read a line and remove leading/trailing whitespace.
		var line := file.get_line().strip_edges()
		
		# Skip empty lines or lines that start with '#', treating them as comments.
		if line.begins_with("#") or line.is_empty():
			continue
		
		# Remove trailing comments from the line.
		var decommented_line = line.split("#", false, 1) #only split first occurrance
		
		# Split the de-commented part of the line into a key and a value.
		var parts := decommented_line[0].split("=", false, 1) #only split first occurrance
		
		# Ensure that the line was successfully parsed into exactly two parts (key and value).
		if parts.size() == 2:
			# Extract the key and remove any surrounding whitespace.
			var key := parts[0].strip_edges()
			# Extract the raw value, strip whitespace, and parse it into an appropriate Variant type.
			var value: Variant = _parse_value(parts[1].strip_edges())
			# Store the parsed key-value pair in the internal environment dictionary.
			_env[key] = value
	
	# Close the file handle to release resources.
	file.close()
	print("Env file loaded: "+target_path)

### FUNCTION: _parse_value(raw: String) -> Variant
#
# Parses a raw string value from the .env file and attempts to convert it
# into a more specific Godot Variant type (e.g., boolean, integer, float).
# If no specific type can be inferred, it defaults to a String.
#
# @param raw: The raw string value read from the .env file.
# @return: The parsed value as a Godot Variant type (String, bool, int, or float).
func _parse_value(raw: String) -> Variant:
	# If the value is enclosed in double quotes, remove the quotes and return it as a string.
	if raw.begins_with("\"") and raw.ends_with("\""):
		return raw.substr(1, raw.length() - 2)
	# If the value is "true" (case-insensitive), return boolean true.
	elif raw.to_lower() == "true":
		return true
	# If the value is "false" (case-insensitive), return boolean false.
	elif raw.to_lower() == "false":
		return false
	# If the value is a valid integer string, convert and return it as an integer.
	elif raw.is_valid_int():
		return raw.to_int()
	# If the value is a valid float string, convert and return it as a float.
	elif raw.is_valid_float():
		return raw.to_float()
	# If none of the above types match, return the raw string as is.
	else:
		return raw

### ACCESS METHODS

# FUNCTION: get_var(key: String, default: Variant = null) -> Variant
#
# Retrieves a variable from the loaded environment. This is the generic getter.
#
# @param key: The key (name) of the environment variable to retrieve.
# @param default: The default value to return if the key is not found. Defaults to null.
# @return: The value associated with the key, or the default value if the key is not found.
func get_var(key: String, default: Variant = null) -> Variant:
	return _env.get(key, default)

# FUNCTION: get_string(key: String, default: String = "") -> String
#
# Retrieves an environment variable and ensures it is returned as a String.
#
# @param key: The key (name) of the environment variable.
# @param default: The default String value to return if the key is not found. Defaults to an empty string.
# @return: The variable's value converted to a String, or the default String.
func get_string(key: String, default: String = "") -> String:
	var value = get_var(key, default)
	# Safely converts the retrieved value to a string.
	return str(value)

# FUNCTION: get_int(key: String, default: int = 0) -> int
#
# Retrieves an environment variable and attempts to convert it to an Integer.
# This method handles values that are already integers or floats, or strings
# that can be parsed as valid integers.
#
# @param key: The key (name) of the environment variable.
# @param default: The default Integer value to return if the key is not found or conversion fails. Defaults to 0.
# @return: The variable's value as an Integer, or the default Integer.
func get_int(key: String, default: int = 0) -> int:
	var value = get_var(key, default)
	# If the value is already an integer or float, directly cast to integer.
	if typeof(value) == TYPE_INT or typeof(value) == TYPE_FLOAT:
		return int(value)
	# If the value is a string and can be parsed as a valid integer, convert it.
	if typeof(value) == TYPE_STRING and String(value).is_valid_int():
		return value.to_int()
	# If conversion is not possible, return the default value.
	return default

# FUNCTION: get_float(key: String, default: float = 0.0) -> float
#
# Retrieves an environment variable and attempts to convert it to a Float.
# This method handles values that are already floats or integers, or strings
# that can be parsed as valid floats.
#
# @param key: The key (name) of the environment variable.
# @param default: The default Float value to return if the key is not found or conversion fails. Defaults to 0.0.
# @return: The variable's value as a Float, or the default Float.
func get_float(key: String, default: float = 0.0) -> float:
	var value = get_var(key, default)
	# If the value is already a float or integer, directly cast to float.
	if typeof(value) == TYPE_FLOAT or typeof(value) == TYPE_INT:
		return float(value)
	# If the value is a string and can be parsed as a valid float, convert it.
	if typeof(value) == TYPE_STRING and String(value).is_valid_float():
		return value.to_float()
	# If conversion is not possible, return the default value.
	return default

# FUNCTION: get_bool(key: String, default: bool = false) -> bool
#
# Retrieves an environment variable and attempts to convert it to a Boolean.
# This method offers robust parsing, handling explicit booleans, various string
# representations ("true", "false", "1", "0", "yes", "no", "on", "off"),
# and numeric values (0 as false, any non-zero as true).
#
# @param key: The key (name) of the environment variable.
# @param default: The default Boolean value to return if the key is not found or conversion fails. Defaults to false.
# @return: The variable's value as a Boolean, or the default Boolean.
func get_bool(key: String, default: bool = false) -> bool:
	var value = get_var(key, default)
	# If the value is already a boolean, return it directly.
	if typeof(value) == TYPE_BOOL:
		return value
	# If the value is a string, attempt conversion based on common boolean representations.
	if typeof(value) == TYPE_STRING:
		var s = String(value).to_lower().strip_edges()
		var true_values = ["true", "1", "yes", "on", "y", "t", "enabled"]
		var false_values = ["false", "0", "no", "off", "n", "f", "disabled"]
		if s in true_values:
			return true
		elif s in false_values:
			return false
	# If the value is a number (integer or float), convert based on zero/non-zero.
	# 0 (or 0.0) evaluates to false while and any non-zero number evaluates to true.
	if typeof(value) == TYPE_INT or typeof(value) == TYPE_FLOAT:
		return value != 0
	# If conversion is not possible, return the default value.
	return default

### FUNCTION: has_var(key: String) -> bool
#
# Checks if a specific environment variable exists (i.e., has been loaded)
# in the internal environment dictionary.
#
# @param key: The key (name) of the environment variable to check for.
# @return: True if the key exists, false otherwise.
func has_var(key: String) -> bool:
	return _env.has(key)

### FUNCTION: dump_as_string() -> String
#
# Dumps all loaded environment variables as a multi-line string.
# This function is primarily useful for debugging and logging purposes,
# providing a clear overview of the current environment configuration.
#
# @return: A string containing all key-value pairs in the format "KEY = VALUE",
#          each on a new line.
func dump_as_string() -> String:
	var env_dump := ""
	# Iterate over all keys in the environment dictionary.
	for k in _env.keys():
		# Append each key-value pair to the dump string, formatted as "KEY = VALUE\n".
		# The value is converted to a string representation.
		env_dump += "%s = %s\n" % [k, str(_env[k])]
	# Return the complete formatted string.
	return env_dump
