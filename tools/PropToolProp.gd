tool
extends Spatial
class_name PropToolProp

export(PropData) var prop_data : PropData
export(bool) var snap_to_mesh : bool = false
export(Vector3) var snap_axis : Vector3 = Vector3(0, -1, 0)

var _prop_prop : PropDataProp

func get_data() -> PropDataProp:
	if not visible or prop_data == null:
		return null
	
	if _prop_prop == null:
		_prop_prop = PropDataProp.new()
		
	_prop_prop.prop = prop_data
	_prop_prop.snap_to_mesh = snap_to_mesh
	_prop_prop.snap_axis = snap_axis

	return _prop_prop

func set_data(prop: PropDataProp) -> void:
	_prop_prop = prop
	
	prop_data = _prop_prop.prop
	snap_to_mesh = prop_data.snap_to_mesh
	snap_axis = prop_data.snap_axis

func refresh() -> void:
	return
