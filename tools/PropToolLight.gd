tool
extends OmniLight
class_name PropToolLight

var _prop_light : PropDataLight

#func _ready():
#	set_notify_transform(true)

func get_data() -> PropDataLight:
	if not visible:
		return null
	
	if _prop_light == null:
		_prop_light = PropDataLight.new()
	
	_prop_light.light_color = light_color
	_prop_light.light_size = omni_range 
	
	return _prop_light

func set_data(light : PropDataLight) -> void:
	_prop_light = light
	
	light_color = _prop_light.light_color
	omni_range = _prop_light.light_size
	light_energy = _prop_light.light_size

#func save():
#	if get_node("..").has_method("save"):
#		get_node("..").save()
#
#func _notification(what):
#	if what == NOTIFICATION_TRANSFORM_CHANGED:
#		save()

