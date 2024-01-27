extends Control

@onready var noise = generate_noise(0, 0.01, 5, 2, 0.5, 0)
@onready var texture: TextureRect = $TextureRect

# Called when the node enters the scene tree for the first time.
func _ready():
	var noiseTexture = texture.texture as NoiseTexture2D
	noiseTexture.noise = noise

func change_seed(seed):
	noise.seed = seed

func change_frequency(freq):
	noise.frequency = freq

func change_octaves(oct):
	noise.fractal_octaves = oct

func change_lacunarity(lac):
	noise.fractal_lacunarity = lac

func change_gain(gain):
	noise.fractal_gain = gain

func generate_noise(seed, freq, oct, lac, gain, amp):
	var _noise = FastNoiseLite.new()
	_noise.noise_type = FastNoiseLite.TYPE_PERLIN
	_noise.seed = seed
	_noise.frequency = freq
	_noise.fractal_octaves = oct
	_noise.fractal_lacunarity = lac
	_noise.fractal_gain = gain
	_noise.domain_warp_amplitude = amp
	return _noise
