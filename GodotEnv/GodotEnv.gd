@tool
extends EditorPlugin

# --- Plugin Configuration Constants ---

# Define the name under which the EnvManager will be registered as an autoload singleton.
# This name is used to access the singleton globally (e.g., `DotEnv.get_var("MY_VAR")`).
const SINGLETON_NAME = "DotEnv"

# Specify the relative path to the main `EnvManager` class script.
const SINGLETON_PATH = "./EnvManager.gd"


# --- Plugin Lifecycle Methods ---

# Called when the plugin is enabled in the Godot editor.
func _enable_plugin() -> void:
	# Add the `EnvManager` script as an autoload singleton to the project.
	add_autoload_singleton(SINGLETON_NAME, SINGLETON_PATH)

	# Print a confirmation message to the Godot output console
	print("Plugin goDotEnv activated: singleton '%s' added." % SINGLETON_NAME)


# Called when the plugin is disabled or removed from the Godot editor.
func _disable_plugin() -> void:
	# Remove the previously added autoload singleton.
	remove_autoload_singleton(SINGLETON_NAME)

	# Print a confirmation message to the Godot output console
	print("Plugin goDotEnv deactivated: singleton '%s' removed." % SINGLETON_NAME)