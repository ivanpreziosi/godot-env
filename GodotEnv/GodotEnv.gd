@tool
extends EditorPlugin

# Name of the Singleton in the project
const SINGLETON_NAME = "DotEnv"
# Path to main class script
const SINGLETON_PATH = "./EnvManager.gd"


func _enable_plugin() -> void:
	# Add autoload singleton
	add_autoload_singleton(SINGLETON_NAME, SINGLETON_PATH)
	print("Plugin goDotEnv activated: singleton '%s' added." % SINGLETON_NAME)


func _disable_plugin() -> void:
	# Remove autoload singleton
	remove_autoload_singleton(SINGLETON_NAME)
	print("Plugin goDotEnv deactivated: singleton '%s' removed." % SINGLETON_NAME)
