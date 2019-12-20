tool
extends EditorPlugin

const main_scene_path : String = "res://addons/prop_tool/scenes/main.tscn"
const temp_scene_path : String = "res://addons/prop_tool/scenes/main_temp.tscn"
const temp_path : String = "res://addons/prop_tool/scenes/temp/"

var buttons_added : bool = false
var light_button : ToolButton
var mesh_button : ToolButton
var prop_button : ToolButton
var scene_button : ToolButton
var entity_button : ToolButton

var edited_prop : PropData

func _enter_tree():
	var dir : Directory = Directory.new()
	dir.copy(main_scene_path, temp_scene_path)
	
	light_button = ToolButton.new()
	light_button.text = "Light"
	light_button.connect("pressed", self, "add_light")
	
	mesh_button = ToolButton.new()
	mesh_button.text = "Mesh"
	mesh_button.connect("pressed", self, "add_mesh")
	
	prop_button = ToolButton.new()
	prop_button.text = "Prop"
	prop_button.connect("pressed", self, "add_prop")
	
	scene_button = ToolButton.new()
	scene_button.text = "Scene"
	scene_button.connect("pressed", self, "add_scene")
	
	entity_button = ToolButton.new()
	entity_button.text = "Entity"
	entity_button.connect("pressed", self, "add_entity")
	
	add_control_to_container(EditorPlugin.CONTAINER_SPATIAL_EDITOR_MENU, light_button)
	add_control_to_container(EditorPlugin.CONTAINER_SPATIAL_EDITOR_MENU, mesh_button)
	add_control_to_container(EditorPlugin.CONTAINER_SPATIAL_EDITOR_MENU, prop_button)
	add_control_to_container(EditorPlugin.CONTAINER_SPATIAL_EDITOR_MENU, scene_button)
	add_control_to_container(EditorPlugin.CONTAINER_SPATIAL_EDITOR_MENU, entity_button)
	
	light_button.hide()
	mesh_button.hide()
	prop_button.hide()
	scene_button.hide()
	entity_button.hide()
	
	connect("scene_changed", self, "scene_changed")


func _exit_tree():
	var dir : Directory = Directory.new()
	dir.remove(temp_scene_path)
	
	if is_instance_valid(light_button):
		light_button.queue_free()
		
	if is_instance_valid(mesh_button):
		mesh_button.queue_free()
		
	if is_instance_valid(prop_button):
		prop_button.queue_free()
		
	if is_instance_valid(scene_button):
		scene_button.queue_free()
		
	if is_instance_valid(entity_button):
		entity_button.queue_free()
		
	light_button = null
	mesh_button = null
	prop_button = null
	scene_button = null
	entity_button = null
		
	edited_prop = null
	
	disconnect("scene_changed", self, "scene_changed")

func scene_changed(scene):
	if scene.has_method("set_target_prop"):
		scene.plugin = self
		
		if not buttons_added:
			light_button.show()
			mesh_button.show()
			prop_button.show()
			scene_button.show()
			entity_button.show()
#			add_control_to_container(EditorPlugin.CONTAINER_SPATIAL_EDITOR_MENU, light_button)
#			add_control_to_container(EditorPlugin.CONTAINER_SPATIAL_EDITOR_MENU, mesh_button)
#			add_control_to_container(EditorPlugin.CONTAINER_SPATIAL_EDITOR_MENU, prop_button)
#			add_control_to_container(EditorPlugin.CONTAINER_SPATIAL_EDITOR_MENU, scene_button)
#			add_control_to_container(EditorPlugin.CONTAINER_SPATIAL_EDITOR_MENU, entity_button)
			
			buttons_added = true
	else:
		if buttons_added:
			light_button.hide()
			mesh_button.hide()
			prop_button.hide()
			scene_button.hide()
			entity_button.hide()
#
#			remove_control_from_container(EditorPlugin.CONTAINER_SPATIAL_EDITOR_MENU, light_button)
#			remove_control_from_container(EditorPlugin.CONTAINER_SPATIAL_EDITOR_MENU, mesh_button)
#			remove_control_from_container(EditorPlugin.CONTAINER_SPATIAL_EDITOR_MENU, prop_button)
#			remove_control_from_container(EditorPlugin.CONTAINER_SPATIAL_EDITOR_MENU, scene_button)
#			remove_control_from_container(EditorPlugin.CONTAINER_SPATIAL_EDITOR_MENU, entity_button)
			
			buttons_added = false

func apply_changes() -> void:
	var scene : Node = get_editor_interface().get_edited_scene_root()
	
	if scene is PropTool:
#	if scene.has_method("set_target_prop") and scene.has_method("save"):
		scene.save()
	
func edit(object : Object) -> void:
	var pedited_prop = object as PropData
	
	var p : String = create_or_get_scene_path(pedited_prop)
	
	get_editor_interface().open_scene_from_path(p)

func handles(object : Object) -> bool:
	return object is PropData

func add_light():
	var selection : Array = get_editor_interface().get_selection().get_selected_nodes()
	var selected : Node
	
	if selection.size() != 1:
		selected = get_editor_interface().get_edited_scene_root()
	else:
		selected = selection[0]
	
	var s : Node = selected
	var n = PropToolLight.new()
	
	var u : UndoRedo = get_undo_redo()
	u.create_action("Add Light")
	u.add_do_method(s, "add_child", n)
	u.add_do_property(n, "owner", get_editor_interface().get_edited_scene_root())
	u.add_undo_method(s, "remove_child", n)
	u.commit_action()
	
	get_editor_interface().get_selection().clear()
	get_editor_interface().get_selection().add_node(n)
	
	
func add_mesh():
	var selected : Array = get_editor_interface().get_selection().get_selected_nodes()
	
	if selected.size() != 1:
		return

	var s : Node = selected[0]
	var n = PropToolMesh.new()
	
	var u : UndoRedo = get_undo_redo()
	u.create_action("Add Mesh")
	u.add_do_method(s, "add_child", n)
	u.add_do_property(n, "owner", get_editor_interface().get_edited_scene_root())
	u.add_undo_method(s, "remove_child", n)
	u.commit_action()
	
	get_editor_interface().get_selection().clear()
	get_editor_interface().get_selection().add_node(n)

	
func add_prop():
	var selected : Array = get_editor_interface().get_selection().get_selected_nodes()
	
	if selected.size() != 1:
		return
	
	var s : Node = selected[0]
	var n = PropTool.new()
	
	var u : UndoRedo = get_undo_redo()
	u.create_action("Add Prop")
	u.add_do_method(s, "add_child", n)
	u.add_do_property(n, "owner", get_editor_interface().get_edited_scene_root())
	u.add_undo_method(s, "remove_child", n)
	u.commit_action()
	
	get_editor_interface().get_selection().clear()
	get_editor_interface().get_selection().add_node(n)
	
func add_scene():
	var selected : Array = get_editor_interface().get_selection().get_selected_nodes()
	
	if selected.size() != 1:
		return
	
	var s : Node = selected[0]
	var n = PropToolScene.new()
	
	var u : UndoRedo = get_undo_redo()
	u.create_action("Add Scene")
	u.add_do_method(s, "add_child", n)
	u.add_do_property(n, "owner", get_editor_interface().get_edited_scene_root())
	u.add_undo_method(s, "remove_child", n)
	u.commit_action()
	
	get_editor_interface().get_selection().clear()
	get_editor_interface().get_selection().add_node(n)
	
func add_entity():
	var selected : Array = get_editor_interface().get_selection().get_selected_nodes()
	
	if selected.size() != 1:
		return
	
	var s : Node = selected[0]
	var n = PropToolEntity.new()
	
	var u : UndoRedo = get_undo_redo()
	u.create_action("Add Entity")
	u.add_do_method(s, "add_child", n)
	u.add_do_property(n, "owner", get_editor_interface().get_edited_scene_root())
	u.add_undo_method(s, "remove_child", n)
	u.commit_action()
	
	get_editor_interface().get_selection().clear()
	get_editor_interface().get_selection().add_node(n)

func create_or_get_scene_path(data: PropData) -> String:
	var path : String = temp_path + data.resource_path.get_file().get_basename() + ".tscn"
	
	var dir : Directory = Directory.new()
	
	if not dir.file_exists(path):
		create_scene(data)
	
	return path
	
func create_or_get_scene(data: PropData) -> PropTool:
	if data == null:
		print("PropTool plugin.gd: Data is null!")
		return null
	
	var path : String = temp_path + data.resource_path.get_file().get_basename() + ".tscn"
	
	var dir : Directory = Directory.new()
	
	var ps : PackedScene
	
	if not dir.file_exists(path):
		ps = create_scene(data)
	else:
		ps = ResourceLoader.load(path, "PackedScene")
	
	if ps == null:
		return null
		
	var pt : PropTool = ps.instance() as PropTool
	pt.plugin = self
	return pt
	
func create_scene(data: PropData) -> PackedScene:
	var pt : PropTool = PropTool.new()
	
	pt.plugin = self
	pt.set_target_prop(data)
	
	var ps : PackedScene = PackedScene.new()
	ps.pack(pt)
	
	var err = ResourceSaver.save(temp_path + data.resource_path.get_file().get_basename() + ".tscn", ps)

	pt.queue_free()
	return ps
