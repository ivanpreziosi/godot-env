

# Godot-Env
Godot-Env provides a minimal and robust implementation of the .env pattern for Godot Engine. It is designed to be extremely lightweight and dependency-free, offering a clean way to manage your application's configuration by separating it from the source code.

## Installation
The package is a plugin for Godot 4.4 and can be installed by downloading the plugin and putting it in your addons folder:

    res://addons/

The installed folder structure should be like this:

    📁 res:// 
    ├── 🗂️ addons/ 
    │   └── 🗂️ GodotEnv/ 
    │   	├── 📄 EnvManager.gd 
    │   	├── 📄 env_example.env 
    │   	├── 📄 GodotEnv.gd 
     │   	├── 📄 plugin.cfg
    │   	└── 🗂️ test_scene/ *(this is not required for production)*
    │ 	    	├──── 📄 EnvTestScene.tscn 
    │       	└──── 📄 env_test_scene.gd
    │       	└──── 📄 test_env_manager.gd (a minimal unit test file)

 ## Enable the plugin in godot
After importing the scripts (test_scene is not needed for plugin functioning), you will need to activate it in your Godot project:
![Godot Plugins Panel](plugins.png)

You will find the plugins panel under the menu: Project -> Project Settings -> Plugins

## The Env file
The env file is quite auto explanatory.

    ## Example env file #####################
    SERVER_NAME=My Server Name # value can contain spaces and a trailing comment
    IS_PROTECTED=true # bool values are supported
    PORT=60666 # integer are supported
    MODIFIER=1.5 # floats are supported
    STRING_NUMBER="2.5" # quotation marks convert all values to string
    
    # you can use the "=" char in your values. NAMES THOUGH CAN NEVER USE THE "=" CHAR! 
    SALT=aaabbbccc=cccbbbaaa 
    
    DATA_PATH="res://data" # this will return as a string
    DATA FILE=pathfile # names support also spaces, i don't like it toh
    #########################################

 - Your key names must never ever contain the "equal" char "=" or everything will break.
 - Key Names can contain spaces and other chars, but using only **CONSTANT_CASE** is strongly suggested!
 - String, Int, Float and Bool values are accepted and managed
 - Line comments and trailing comments are supported
 - Quotation marks enclosed values are supported and converted to String by default

## Usage
Once the plugin is active DotEnv should be autoloaded as a global singleton in godot.
Usage requires an actual .env file to be loaded. This is usually done at bootstrap time of your app, as one of the earliest subsystems to be loaded.
This only requires a line of code:

    extends Node
    
    func _ready() -> void:
    	DotEnv.load_env("res://addons/GodotEnv/env_example.env")
You can pass a custom path for your env file or just use the default value with the env sitting in the same folder as the root or executable.

After loading you should have the following line in your console:

    Env file loaded: res://addons/GodotEnv/env_example.env

### Values retrieval
Once the env file is loaded it will be available globally in your project. It will expose several retrieval functions to get values and infos from your env.

    extends Node
    
    func _ready() -> void:
	    # load the env file
    	DotEnv.load_env("res://addons/GodotEnv/env_example.env")
    	
    	# print an env dump to console
    	print(DotEnv.dump_as_string())
    	
    	# example of getters usage to retrieve values
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
    	
    	# example of has_var() usage
    	print (DotEnv.has_var("PORT"))
    	print (DotEnv.has_var("NON_EXISTENT_KEY"))
    	
    	# print the value retrieved before
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
