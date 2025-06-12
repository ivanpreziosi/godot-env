

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
    │   	└── 🗂️ test_scene/ 
    │ 	    	├──── 📄 EnvTestScene.tscn 
    │       	└──── 📄 env_test_scene.gd

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
