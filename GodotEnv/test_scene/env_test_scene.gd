extends Node

func _ready() -> void:
	DotEnv.load_env("res://addons/GodotEnv/env_example.env")
	
	print(DotEnv.dump_as_string())
	
	var data = {
		"SERVER_NAME" : DotEnv.get_string("SERVER_NAME", "bogus: SERVER_NAME"),
		"IS_PROTECTED" : DotEnv.get_bool("IS_PROTECTED", false),
		"PORT" : DotEnv.get_int("PORT", -1),
		"MODIFIER" : DotEnv.get_float("MODIFIER", 5.5),
		"STRING_NUMBER" : DotEnv.get_var("STRING_NUMBER", "nullus"),
		"SALT" : DotEnv.get_string("SALT", "nullus salis est"),
		"DATA_PATH" : DotEnv.get_string("DATA_PATH", "nulla via est"),
		"DATA FILE" : DotEnv.get_string("DATA FILE", "nullum documentum est"),
	}
	
	print (DotEnv.has_var("PORT"))
	print (DotEnv.has_var("ZUMURRUDDU"))
	
	var print_string  = '''
	"SERVER_NAME" : {SERVER_NAME},
	"IS_PROTECTED" : {IS_PROTECTED},
	"PORT" : {PORT},
	"MODIFIER" : {MODIFIER},
	"STRING_NUMBER" : {STRING_NUMBER},
	"SALT" : {SALT},
	"DATA_PATH" : {DATA_PATH},
	"DATA FILE" : {DATA FILE},
	'''
	print(print_string.format(data))
