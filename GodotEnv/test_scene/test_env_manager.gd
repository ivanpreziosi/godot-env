extends Node

# This script serves as a basic unit test suite for the `EnvManager` class.
# It verifies the correct functionality of various methods within `EnvManager`,
# ensuring that environment variables are parsed, stored, and retrieved accurately
# with proper type conversions and default value handling.

# --- Test Execution ---

# The `_ready` method is called once the node enters the scene tree.
# In a test context, this is where we initiate all our test functions.
func _ready():
	# Execute individual test cases for different `EnvManager` functionalities.
	test_parse_value()         # Tests the internal value parsing logic.
	test_get_var_and_defaults() # Tests the generic variable retrieval and default handling.
	test_get_int()             # Tests integer conversion.
	test_get_float()           # Tests float conversion.
	test_get_bool()            # Tests boolean conversion with various string/numeric inputs.
	test_dump_as_string()      # Tests the string representation of loaded environment variables.

	# If all assertions across the test functions pass, this message will be printed.
	# If any assertion fails, the script will halt immediately at the point of failure,
	# indicating which test failed.
	print("All EnvManager tests passed.")

# --- Test Functions ---

# Test suite for the `_parse_value` internal method of `EnvManager`.
# This method is responsible for converting raw string values from the .env file
# into appropriate Godot Variant types (String, bool, int, float).
func test_parse_value():
	# Create a new instance of EnvManager to isolate tests.
	var em = EnvManager.new()

	# Test case 1: String value enclosed in double quotes.
	# Expected: Quotes should be stripped, resulting in a plain string.
	# NOTE: There's a potential typo in the original assertion ("helloz" instead of "hello").
	# The corrected assertion for "hello" is: `assert(em._parse_value("\"hello\"") == "hello")`
	assert(em._parse_value("\"hello\"") == "hello") # Corrected: assuming "hello" was intended

	# Test case 2: Boolean string "true" (case-insensitive).
	# Expected: Should be parsed as a boolean `true`.
	assert(em._parse_value("true") == true)

	# Test case 3: Boolean string "FALSE" (case-insensitive).
	# Expected: Should be parsed as a boolean `false`.
	assert(em._parse_value("FALSE") == false)

	# Test case 4: Integer string.
	# Expected: Should be parsed as an integer `42`.
	assert(em._parse_value("42") == 42)

	# Test case 5: Float string.
	# Expected: Should be parsed as a float `3.1415`.
	assert(em._parse_value("3.1415") == 3.1415)

	# Test case 6: Plain string without special parsing rules.
	# Expected: Should remain a plain string.
	assert(em._parse_value("hello world") == "hello world")

# Test suite for `get_var` method, which retrieves a generic variable
# and handles default values when the key is not found.
func test_get_var_and_defaults():
	var em = EnvManager.new()
	# Manually populate the internal `_env` dictionary for testing purposes.
	em._env = {"A": "abc", "B": 123}

	# Test case 1: Retrieve an existing string variable.
	assert(em.get_var("A") == "abc")

	# Test case 2: Retrieve an existing integer variable.
	assert(em.get_var("B") == 123)

	# Test case 3: Retrieve a non-existent variable with a custom default value.
	# Expected: The provided default value "default" should be returned.
	assert(em.get_var("C", "default") == "default")

	# Test case 4: Retrieve a non-existent variable without a custom default value.
	# Expected: The default default value (null) should be returned.
	assert(em.get_var("C") == null)

# Test suite for `get_int` method, which retrieves a variable and converts it to an integer.
# It handles various input types like existing integers, floats (truncating), and valid integer strings.
func test_get_int():
	var em = EnvManager.new()
	# Manually set up test environment variables.
	em._env = {"I": 123, "F": 7.7, "S": "456", "X": "abc"}

	# Test case 1: Retrieve an existing integer.
	assert(em.get_int("I") == 123)

	# Test case 2: Retrieve a float, expected to be truncated to an integer.
	assert(em.get_int("F") == 7)

	# Test case 3: Retrieve a string that represents a valid integer.
	assert(em.get_int("S") == 456)

	# Test case 4: Retrieve a string that is not a valid integer, with a custom default.
	# Expected: The custom default `99` should be returned.
	assert(em.get_int("X", 99) == 99)

	# Test case 5: Retrieve a non-existent key.
	# Expected: The default `0` for integers should be returned.
	assert(em.get_int("Z") == 0)

# Test suite for `get_float` method, which retrieves a variable and converts it to a float.
# It handles existing floats, integers (converted to float), and valid float strings.
func test_get_float():
	var em = EnvManager.new()
	# Manually set up test environment variables.
	em._env = {"F": 3.5, "I": 2, "S": "6.28", "X": "abc"}

	# Test case 1: Retrieve an existing float.
	assert(em.get_float("F") == 3.5)

	# Test case 2: Retrieve an integer, expected to be converted to a float.
	assert(em.get_float("I") == 2.0)

	# Test case 3: Retrieve a string that represents a valid float.
	assert(em.get_float("S") == 6.28)

	# Test case 4: Retrieve a string that is not a valid float, with a custom default.
	# Expected: The custom default `1.23` should be returned.
	assert(em.get_float("X", 1.23) == 1.23)

	# Test case 5: Retrieve a non-existent key.
	# Expected: The default `0.0` for floats should be returned.
	assert(em.get_float("Z") == 0.0)

# Test suite for `get_bool` method, which retrieves a variable and converts it to a boolean.
# This test covers a wide range of boolean representations, including explicit booleans,
# various string representations ("true", "false", "yes", "no", "1", "0", etc.),
# and numeric values (0 as false, non-zero as true).
func test_get_bool():
	var em = EnvManager.new()
	# Populate `_env` with various types and string representations of booleans.
	em._env = {
		"T": true, "F": false,
		"S1": "true", "S2": "yes", "S3": "on", "S4": "1",
		"S5": "y", "S6": "t", "S7": "enabled",
		"S8": "false", "S9": "no", "S10": "off", "S11": "0", "S12": "n", "S13": "f", "S14": "disabled",
		"N1": 1, "N0": 0, "N2": 20, "NF": -1 # Numbers: 0 is false, non-zero is true
	}

	# Test case 1 & 2: Retrieve existing boolean values.
	assert(em.get_bool("T") == true)
	assert(em.get_bool("F") == false)

	# Test case 3: Iterate and test various "true-like" string representations.
	for k in ["S1", "S2", "S3", "S4", "S5", "S6", "S7"]:
		assert(em.get_bool(k) == true)

	# Test case 4: Iterate and test various "false-like" string representations.
	for k in ["S8", "S9", "S10", "S11", "S12", "S13", "S14"]:
		assert(em.get_bool(k) == false)

	# Test case 5: Test numeric values for boolean conversion.
	# Non-zero numbers (1, 20, -1) should evaluate to true.
	assert(em.get_bool("N1") == true)
	assert(em.get_bool("N0") == false) # Zero should evaluate to false.
	assert(em.get_bool("N2") == true)
	assert(em.get_bool("NF") == true)

	# Test case 6: Retrieve a non-existent key.
	# Expected: The default `false` for booleans should be returned.
	assert(em.get_bool("Z") == false)

	# Test case 7: Retrieve a non-existent key with a custom default.
	# Expected: The custom default `true` should be returned.
	assert(em.get_bool("Z", true) == true)

# Test suite for `dump_as_string` method, which provides a string representation
# of all loaded environment variables.
func test_dump_as_string():
	var em = EnvManager.new()
	# Populate `_env` with a few key-value pairs for testing the dump.
	em._env = {"A": "foo", "B": 2}

	# Get the string dump of the environment.
	var dump = em.dump_as_string()

	# Test case 1: Check if the string dump contains the "A = foo" entry.
	# `find` returns -1 if the substring is not found.
	assert(dump.find("A = foo") != -1)

	# Test case 2: Check if the string dump contains the "B = 2" entry.
	assert(dump.find("B = 2") != -1)