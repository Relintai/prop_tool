tool
extends Spatial
class_name PropTool

export(bool) var refresh : bool setget refresh_set
export(PropData) var target_prop : PropData setget target_prop_set
export(bool) var snap_to_mesh : bool = false
export(Vector3) var snap_axis : Vector3 = Vector3(0, -1, 0)
var plugin : EditorPlugin

func save() -> void:
	if target_prop == null:
		return
		
	print("save " + target_prop.resource_path)
	
	while target_prop.get_prop_count() > 0:
		target_prop.remove_prop(0)
		
	for child in get_children():
		save_node(child, transform)
		
	target_prop.snap_to_mesh = snap_to_mesh
	target_prop.snap_axis = snap_axis
	
	ResourceSaver.save(target_prop.resource_path, target_prop)
		
func save_node(node : Node, parent_transform: Transform) -> void:
	if node is Spatial and node.has_method("get_data"):
		var prop : PropDataEntry = node.get_data()

		if prop:
			prop.transform = parent_transform * (node as Spatial).transform
		
			target_prop.add_prop(prop)
			
		if node.has_method("evaluate_children") and not node.evaluate_children():
			return
		
		for child in node.get_children():
			save_node(child, parent_transform * node.transform)
	else:
		if node.has_method("set_target_prop"):
			if node.target_prop:
				var prop : PropDataProp = PropDataProp.new()
			
				prop.prop = node.target_prop

				prop.transform = parent_transform * (node as Spatial).transform
		
				target_prop.add_prop(prop)
		else:
			for child in node.get_children():
				save_node(child, parent_transform)

func rebuild_hierarchy() -> void:
	for ch in get_children():
		ch.queue_free()
	
	if target_prop == null:
		return
		
	snap_to_mesh = target_prop.snap_to_mesh
	snap_axis = target_prop.snap_axis
		
	for i in range(target_prop.get_prop_count()):
		print(i)
		var prop : PropDataEntry = target_prop.get_prop(i)
		
		if prop is PropDataLight:
			var l : PropToolLight = PropToolLight.new()
			
			add_child(l)
			l.owner = self
			l.transform = prop.transform
			
			l.set_data(prop as PropDataLight)
		elif prop is PropDataMesh:
			var m : PropToolMesh = PropToolMesh.new()
			
			add_child(m)
			m.owner = self
			m.transform = prop.transform
			
			m.set_data(prop as PropDataMesh)
		elif prop is PropDataScene:
			var s : PropToolScene = PropToolScene.new()
			
			add_child(s)
			s.owner = self
			s.transform = prop.transform
			
			s.set_data(prop as PropDataScene)
		elif prop is PropDataProp:
			var s : Node = plugin.create_or_get_scene(prop.prop)
			
			add_child(s)
			s.owner = self
			s.transform = prop.transform
#			s.set_target_prop(prop.prop)
		elif prop is PropDataEntity:
			var s : PropToolEntity = PropToolEntity.new()
			
			add_child(s)
			s.owner = self
			s.transform = prop.transform
			
			s.set_data(prop as PropDataEntity)

func refresh_set(value):
	if value:
		rebuild_hierarchy()

func set_target_prop(prop: PropData) -> void:
#	if prop == null:
#		return
	
	target_prop = prop

	rebuild_hierarchy()

func get_plugin():
	return plugin

func target_prop_set(prop: PropData) -> void:
	target_prop = prop
	
	if prop == null:
		return
	
	var last_prop_tool : PropTool = self
	var root : Node = self
	while root.get_parent() != null:
		root = root.get_parent()
		
		if root and root.has_method("target_prop_set"):
			last_prop_tool = root as PropTool

	if last_prop_tool == self:
		return
		
	last_prop_tool.load_scene_for(self, prop)

func load_scene_for(t: PropTool, prop: PropData):
	if not plugin:
		return
	
	t.queue_free()
	var s : Node = plugin.create_or_get_scene(prop)
			
	add_child(s)
	s.owner = self
