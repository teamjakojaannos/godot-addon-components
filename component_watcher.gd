extends Node

var _script_lookup: Dictionary[String, Array] = {}

func _enter_tree() -> void:
	get_tree().node_added.connect(_on_node_added)


func _on_node_added(node: Node) -> void:
	var key = _get_script_key(node)
	if not key:
		return

	var initializers = _get_component_initializers(key, node)
	if not initializers.is_empty():
		node.ready.connect(
			_run_initializers.bind(initializers),
			CONNECT_ONE_SHOT
		)


func _run_initializers(initializers: Array[Callable]) -> void:
	for initializer in initializers:
		initializer.call()


func _get_script_key(node: Node) -> String:
	var s = node.get_script()
	if s is Script:
		return ResourceUID.path_to_uid(s.resource_path)

	return ""


func _get_component_initializers(key: String, node: Node) -> Array[Callable]:
	if not _script_lookup.has(key):
		var initializer_names = []
		for method in node.get_method_list():
			if not _is_accessor_ready_method(method):
				continue

			initializer_names.push_back(method["name"])
		
		_script_lookup.set(key, initializer_names)

	var initializer_names = _script_lookup[key]
	var initializers: Array[Callable] = []
	for method_name in initializer_names:
		var initializer = Callable.create(node, method_name)
		initializers.push_back(initializer)

	return initializers


func _is_accessor_ready_method(method: Dictionary) -> bool:
	var method_name: String = method["name"]
	if not method_name.begins_with("__"):
		return false

	if not method_name.ends_with("_accessor_ready"):
		return false

	var args: Array = method["args"]
	if not args.is_empty():
		return false

	return true
