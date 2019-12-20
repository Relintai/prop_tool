tool
extends Spatial
class_name PropToolScene

export(PackedScene) var scene_data : PackedScene
export(bool) var snap_to_mesh : bool = false
export(Vector3) var snap_axis : Vector3 = Vector3(0, -1, 0)

var _prop_scene : PropDataScene

func get_data() -> PropDataScene:
	if not visible or scene_data == null:
		return null
	
	if _prop_scene == null:
		_prop_scene = PropDataScene.new()
		
	_prop_scene.scene = scene_data
	_prop_scene.snap_to_mesh = snap_to_mesh
	_prop_scene.snap_axis = snap_axis
	
	return _prop_scene

func set_data(scene: PropDataScene) -> void:
	_prop_scene = scene
	
	scene_data = _prop_scene.scene
	snap_to_mesh = _prop_scene.snap_to_mesh
	snap_axis = _prop_scene.snap_axis
	
