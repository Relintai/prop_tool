tool
extends MeshInstance
class_name PropToolMesh

export(MeshDataResource) var mesh_data : MeshDataResource setget set_prop_mesh
export(Texture) var texture : Texture setget set_texture
export(bool) var snap_to_mesh : bool = false
export(Vector3) var snap_axis : Vector3 = Vector3(0, -1, 0)

export(bool) var generate : bool setget set_generate

var _prop_mesh : PropDataMesh
var _material : SpatialMaterial

func get_data() -> PropDataMesh:
	if not visible or mesh_data == null:
		return null
	
	if _prop_mesh == null:
		_prop_mesh = PropDataMesh.new()
		
	_prop_mesh.mesh = mesh_data
	_prop_mesh.texture = texture
	_prop_mesh.snap_to_mesh = snap_to_mesh
	_prop_mesh.snap_axis = snap_axis

	return _prop_mesh

func set_data(data : PropDataMesh) -> void:
	_prop_mesh = data
	
	set_texture(_prop_mesh.texture)
	set_prop_mesh(_prop_mesh.mesh)
	
	snap_to_mesh = _prop_mesh.snap_to_mesh
	snap_axis = _prop_mesh.snap_axis

func set_prop_mesh(md : MeshDataResource) -> void:
	mesh_data = md
	
	set_generate(true)
	
func set_texture(tex : Texture) -> void:
	texture = tex
	
func set_generate(val : bool) -> void:
	if val:
		if !mesh_data:
			mesh = null
			return
			
		var m : ArrayMesh = ArrayMesh.new()
		
		var arr = []
		arr.resize(ArrayMesh.ARRAY_MAX)
		
		var v : PoolVector3Array = PoolVector3Array()
		v.append_array(mesh_data.array[Mesh.ARRAY_VERTEX])
		arr[Mesh.ARRAY_VERTEX] = v
		
		var norm : PoolVector3Array = PoolVector3Array()
		norm.append_array(mesh_data.array[Mesh.ARRAY_NORMAL])
		arr[Mesh.ARRAY_NORMAL] = norm
		
		var uv : PoolVector2Array = PoolVector2Array()
		uv.append_array(mesh_data.array[Mesh.ARRAY_TEX_UV])
		arr[Mesh.ARRAY_TEX_UV] = uv

		var ind : PoolIntArray = PoolIntArray()
		ind.append_array(mesh_data.array[Mesh.ARRAY_INDEX])
		arr[Mesh.ARRAY_INDEX] = ind
		
		m.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arr)

		mesh = m
		
		if texture != null:
			if _material == null:
				_material = SpatialMaterial.new()
			
			_material.albedo_texture = texture
			
			material_override = _material
		
