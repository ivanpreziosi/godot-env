extends Node



func _ready():
	test_parse_value()
	test_get_var_and_defaults()
	test_get_int()
	test_get_float()
	test_get_bool()
	test_dump_as_string()
	print("All EnvManager tests passed.")

func test_parse_value():
	var em = EnvManager.new()
	# String with quotes
	assert(em._parse_value("\"hello\"") == "helloz")
	# Boolean
	assert(em._parse_value("true") == true)
	assert(em._parse_value("FALSE") == false)
	# Integer
	assert(em._parse_value("42") == 42)
	# Float
	assert(em._parse_value("3.1415") == 3.1415)
	# Plain string
	assert(em._parse_value("hello world") == "hello world")

func test_get_var_and_defaults():
	var em = EnvManager.new()
	em._env = {"A": "abc", "B": 123}
	assert(em.get_var("A") == "abc")
	assert(em.get_var("B") == 123)
	assert(em.get_var("C", "default") == "default")
	assert(em.get_var("C") == null)

func test_get_int():
	var em = EnvManager.new()
	em._env = {"I": 123, "F": 7.7, "S": "456", "X": "abc"}
	assert(em.get_int("I") == 123)
	assert(em.get_int("F") == 7)
	assert(em.get_int("S") == 456)
	assert(em.get_int("X", 99) == 99)
	assert(em.get_int("Z") == 0)

func test_get_float():
	var em = EnvManager.new()
	em._env = {"F": 3.5, "I": 2, "S": "6.28", "X": "abc"}
	assert(em.get_float("F") == 3.5)
	assert(em.get_float("I") == 2.0)
	assert(em.get_float("S") == 6.28)
	assert(em.get_float("X", 1.23) == 1.23)
	assert(em.get_float("Z") == 0.0)

func test_get_bool():
	var em = EnvManager.new()
	em._env = {
		"T": true, "F": false,
		"S1": "true", "S2": "yes", "S3": "on", "S4": "1",
		"S5": "y", "S6": "t", "S7": "enabled",
		"S8": "false", "S9": "no", "S10": "off", "S11": "0", "S12": "n", "S13": "f", "S14": "disabled",
		"N1": 1, "N0": 0, "N2": 20, "NF": -1
	}
	assert(em.get_bool("T") == true)
	assert(em.get_bool("F") == false)
	# True-like strings
	for k in ["S1", "S2", "S3", "S4", "S5", "S6", "S7"]:
		assert(em.get_bool(k) == true)
	# False-like strings
	for k in ["S8", "S9", "S10", "S11", "S12", "S13", "S14"]:
		assert(em.get_bool(k) == false)
	# Numbers
	assert(em.get_bool("N1") == true)
	assert(em.get_bool("N0") == false)
	assert(em.get_bool("NF") == true)
	# Missing key
	assert(em.get_bool("Z") == false)
	# Custom default
	assert(em.get_bool("Z", true) == true)

func test_dump_as_string():
	var em = EnvManager.new()
	em._env = {"A": "foo", "B": 2}
	var dump = em.dump_as_string()
	assert(dump.find("A = foo") != -1)
	assert(dump.find("B = 2") != -1)
