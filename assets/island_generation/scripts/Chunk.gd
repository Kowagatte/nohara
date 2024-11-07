extends Node3D
class_name Chunk

const HEIGHT_AMPLITUDE = 60

var mesh_instance: MeshInstance3D
var noise: FastNoiseLite
var x
var z
var chunk_size
var shouldUnload: bool = true
var island

func _init(noise, x, z, chunk_size, island):
	self.noise = noise
	self.x = x
	self.z = z
	self.chunk_size = chunk_size
	self.island = island

static func getChunkKey(_x, _z):
	return str(_x)+","+str(_z)

# Called when the node enters the scene tree for the first time.
func _ready():
	generateWater()
	generate()

func generateWater():
	var plane_mesh = PlaneMesh.new()
	plane_mesh.size = Vector2(chunk_size, chunk_size)
	plane_mesh.material = preload("res://assets/island_generation/WaterMaterial.tres") as StandardMaterial3D

	var mesh_instance = MeshInstance3D.new()
	mesh_instance.mesh = plane_mesh
	mesh_instance.translate(Vector3(0, 1, 0))
	
	add_child(mesh_instance)

#island info
var offset = null
var gradient = null

func generate():
	var surface_tool = SurfaceTool.new()
	var data_tool = MeshDataTool.new()
	
	var plane_mesh = PlaneMesh.new()
	plane_mesh.size = Vector2(chunk_size, chunk_size)
	plane_mesh.subdivide_depth = chunk_size * 0.5
	plane_mesh.subdivide_width = chunk_size * 0.5
	
	surface_tool.create_from(plane_mesh, 0)
	var array_mesh = surface_tool.commit()
	data_tool.create_from_surface(array_mesh, 0)
	
	#var custom_gradient = ResourceLoader.load("res://assets/island_generation/RadialGradient2.tres") as Image
	#custom_gradient.width = SIZE+1
	#custom_gradient.height = SIZE+1
	#ResourceSaver.save(custom_gradient.get_image(), "res://assets/island_generation/RadialGradient3.tres")
	#custom_gradient.get_image().save_png("res://assets/island_generation/RadialGradient3.png")
	
	if island != null:
		gradient = island["data"]# as Image
		var island_origin = Vector3(island["position"]["x"], 0, island["position"]["z"])
		var pos = Vector3(x, 0, z)
		#print("pos: " + str(pos))
		offset = pos - island_origin
		#print("offset: " + str(offset))
		#print(island)
	
	for i in range(data_tool.get_vertex_count()):
		var vertex = data_tool.get_vertex(i)
		
		#var data = custom_gradient#.get_image()
		#data.lock()
		
		var gradient_value: float = 1.0
		if island != null:
			gradient_value = gradient[(vertex.x + chunk_size * 0.5) + offset.x][(vertex.z + chunk_size * 0.5) + offset.z]
			#gradient_value = gradient.get_pixel((vertex.x + chunk_size * 0.5) + offset.x, (vertex.z + chunk_size * 0.5) + offset.z).r
		
		#var r_value = data.get_pixel(vertex.x + chunk_size * 0.5, vertex.z + chunk_size * 0.5).r
		# White = 1
		# Black = 0
		#var gradient_value = 1.0 #* 1.5
		
		var noise_value = (noise.get_noise_2d(vertex.x + x, vertex.z + z) + 1) /2
		
		#var new_height = clamp(noise_value - gradient_value, -0.3, 1)
		var new_height = noise_value - gradient_value
		
		# Makes y values below water tamer
		if new_height < 0:
			new_height = new_height ** 5
		
		vertex.y = new_height * HEIGHT_AMPLITUDE
		# Generates underwater crevices
		if new_height < 0:
			vertex.y -= 1.5 * -vertex.y
		
		data_tool.set_vertex(i, vertex)


	array_mesh.clear_surfaces()
	
	data_tool.commit_to_surface(array_mesh)
	surface_tool.begin(Mesh.PRIMITIVE_TRIANGLES)
	surface_tool.create_from(array_mesh, 0)
	surface_tool.generate_normals()
	
	var mesh_instance = MeshInstance3D.new()
	mesh_instance.mesh = surface_tool.commit()
	
	var material = StandardMaterial3D.new()
	material.albedo_color = Color(0.0, 0.8, 0.4)
	
	mesh_instance.material_override = material
	
	mesh_instance.create_trimesh_collision()
	
	add_child(mesh_instance)
	
