extends Node3D

# Island Size TODO create a size map for small, medium, large islands.
const SIZE = 256 * 2
const HEIGHT_AMPLITUDE = 60

func _ready():
	generate_island()
	

func generate_island():
	#randomize() #generates the islands seed TODO Change this to be generated on world creation
	
	var surface_tool = SurfaceTool.new()
	var data_tool = MeshDataTool.new()
	
	var noise = FastNoiseLite.new()
	#noise.noise_type = FastNoiseLite.TYPE_SIMPLEX
	noise.noise_type = FastNoiseLite.TYPE_SIMPLEX_SMOOTH
	noise.seed = 1337 #randi()
	noise.fractal_octaves = 2
	noise.fractal_lacunarity = 2
	noise.fractal_gain = 0.7
	noise.frequency = 0.008
	
	var plane_mesh = PlaneMesh.new()
	plane_mesh.size = Vector2(SIZE, SIZE)
	plane_mesh.subdivide_depth = SIZE * 0.5
	plane_mesh.subdivide_width = SIZE * 0.5
	
	surface_tool.create_from(plane_mesh, 0)
	var array_mesh = surface_tool.commit()
	data_tool.create_from_surface(array_mesh, 0)
	
	var custom_gradient = ResourceLoader.load("res://assets/island_generation/RadialGradient2.tres") as Image
	#custom_gradient.width = SIZE+1
	#custom_gradient.height = SIZE+1
	#ResourceSaver.save(custom_gradient.get_image(), "res://assets/island_generation/RadialGradient3.tres")
	#custom_gradient.get_image().save_png("res://assets/island_generation/RadialGradient3.png")
	
	for i in range(data_tool.get_vertex_count()):
		var vertex = data_tool.get_vertex(i)
		
		var data = custom_gradient#.get_image()
		#data.lock()
		var r_value = data.get_pixel(vertex.x + SIZE * 0.5, vertex.z + SIZE * 0.5).r
		# White = 1
		# Black = 0
		var gradient_value = r_value #* 1.5
		
		var noise_value = (noise.get_noise_2d(vertex.x, vertex.z) + 1)/2
		
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
	
	$Island.add_child(mesh_instance)
