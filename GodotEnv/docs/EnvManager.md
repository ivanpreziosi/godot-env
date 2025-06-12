# Class: EnvManager

Extends: `Node` Class Name: `EnvManager`

The `EnvManager` class provides robust management of environment variables, allowing them to be loaded from a `.env` file and accessed with specific types. It supports loading in both the Godot editor and exported builds, handles comments, and various data types (strings, booleans, integers, floats).

----------

## Properties

### `var _env := {}`

A private `Dictionary` to store the loaded environment variables.

### `var path := "res://.env"`

The default path for the `.env` file. This path is used if no custom path is provided when calling `load_env()`. By default, it points to the project root in the editor.

----------

## Public Methods

### `load_env(custom_path: String = "") -> void`

Loads environment variables from a `.env` file into the `_env` dictionary. This function dynamically determines the `.env` file path based on whether the application is running in the Godot Editor or as an exported build. It also includes error handling for non-existent files and robust line parsing. Env files should never be packed in your export, but used for installation configurations.

**Parameters:**

-   `custom_path: String = ""`: An optional custom path to the `.env` file. If provided, this path takes precedence over the default path. Example: `"res://data/.env"`.

### `get_var(key: String, default: Variant = null) -> Variant`

Retrieves a variable from the loaded environment. This is the generic getter.

**Parameters:**

-   `key: String`: The key (name) of the environment variable to retrieve.
-   `default: Variant = null`: The default value to return if the key is not found. Defaults to `null`.

**Returns:**

-   `Variant`: The value associated with the key, or the default value if the key is not found.

### `get_string(key: String, default: String = "") -> String`

Retrieves an environment variable and ensures it is returned as a `String`.

**Parameters:**

-   `key: String`: The key (name) of the environment variable.
-   `default: String = ""`: The default `String` value to return if the key is not found. Defaults to an empty string.

**Returns:**

-   `String`: The variable's value converted to a `String`, or the default `String`.

### `get_int(key: String, default: int = 0) -> int`

Retrieves an environment variable and attempts to convert it to an `Integer`. This method handles values that are already integers or floats, or strings that can be parsed as valid integers.

**Parameters:**

-   `key: String`: The key (name) of the environment variable.
-   `default: int = 0`: The default `Integer` value to return if the key is not found or conversion fails. Defaults to `0`.

**Returns:**

-   `int`: The variable's value as an `Integer`, or the default `Integer`.

### `get_float(key: String, default: float = 0.0) -> float`

Retrieves an environment variable and attempts to convert it to a `Float`. This method handles values that are already floats or integers, or strings that can be parsed as valid floats.

**Parameters:**

-   `key: String`: The key (name) of the environment variable.
-   `default: float = 0.0`: The default `Float` value to return if the key is not found or conversion fails. Defaults to `0.0`.

**Returns:**

-   `float`: The variable's value as a `Float`, or the default `Float`.

### `get_bool(key: String, default: bool = false) -> bool`

Retrieves an environment variable and attempts to convert it to a `Boolean`. This method offers robust parsing, handling explicit booleans, various string representations (`"true"`, `"false"`, `"1"`, `"0"`, `"yes"`, `"no"`, `"on"`, `"off"`), and numeric values (`0` as `false`, any non-zero as `true`).

**Parameters:**

-   `key: String`: The key (name) of the environment variable.
-   `default: bool = false`: The default `Boolean` value to return if the key is not found or conversion fails. Defaults to `false`.

**Returns:**

-   `bool`: The variable's value as a `Boolean`, or the default `Boolean`.

### `has_var(key: String) -> bool`

Checks if a specific environment variable exists (i.e., has been loaded) in the internal environment dictionary.

**Parameters:**

-   `key: String`: The key (name) of the environment variable to check for.

**Returns:**

-   `bool`: `true` if the key exists, `false` otherwise.

### `dump_as_string() -> String`

Dumps all loaded environment variables as a multi-line string. This function is primarily useful for debugging and logging purposes, providing a clear overview of the current environment configuration.

**Returns:**

-   `String`: A string containing all key-value pairs in the format `"KEY = VALUE"`, each on a new line.