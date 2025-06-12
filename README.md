
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

 

