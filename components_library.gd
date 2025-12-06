@tool
extends EditorPlugin

const AUTOLOAD_NAME: String = "_jakojaannos_component_library__component_watcher"

func _enter_tree() -> void:
	var component_watcher_path = ResourceUID.uid_to_path("uid://c5bdt2qvjcxvl")
	add_autoload_singleton(AUTOLOAD_NAME, component_watcher_path)

func _exit_tree() -> void:
	remove_autoload_singleton(AUTOLOAD_NAME)
