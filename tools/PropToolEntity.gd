tool
extends Spatial
class_name PropToolEntity

export(EntityData) var entity_data : EntityData setget set_entity_data
export(int) var entity_data_id : int
export(int) var level : int = 1

var _prop_entity : PropDataEntity
var _entity : Entity

func get_data() -> PropDataEntity:
	if not visible or entity_data == null:
		return null
	
	if _prop_entity == null:
		_prop_entity = PropDataEntity.new()
		
	_prop_entity.entity_data_id = entity_data.id
	_prop_entity.level = level

	return _prop_entity

func set_data(scene: PropDataEntity) -> void:
	_prop_entity = scene
	
	entity_data_id = _prop_entity.entity_data_id
	level = _prop_entity.level
	
	var dir = Directory.new()
	if dir.open("res://data/entities/") == OK:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		
		while (file_name != ""):
			if not dir.current_is_dir():
				var ed : EntityData = ResourceLoader.load("res://data/entities/" + file_name, "EntityData")
				
				if ed != null and ed.id == entity_data_id:
					set_entity_data(ed)
					return
				
			file_name = dir.get_next()
			
		print("PropToolEntity: Entity not found!")

func set_entity_data(ed: EntityData) -> void:
	entity_data = ed
	
	if entity_data == null:
		return
	
	if _entity == null:
		var scene : PackedScene = load("res://addons/prop_tool/player/PropToolDisplayPlayer.tscn")

		_entity = scene.instance() as Entity

		add_child(_entity)
#		_entity.owner = owner

#		_entity.get_node(_entity.character_skeleton_path).owner = owner
		_entity.get_node(_entity.character_skeleton_path).refresh_in_editor = true
	#	_entity.get_character_skeleton().refresh_in_editor = true
	
	_entity.sentity_data = entity_data
	
	name = entity_data.text_name

	
func evaluate_children() -> bool:
	return false
