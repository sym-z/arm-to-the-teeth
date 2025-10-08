extends ColorRect
var base_noise : FastNoiseLite
var timer : Timer
@export var seed_tick = 0.1
# Called when the node enters the scene tree for the first time.
func _ready():
	var mat = material as ShaderMaterial
	var n_tex = mat.get_shader_parameter("image") as NoiseTexture2D
	base_noise = n_tex.noise as FastNoiseLite
	timer = Timer.new()
	timer.autostart = true
	timer.one_shot = false
	timer.wait_time = seed_tick
	timer.connect("timeout", bump_seed)
	add_child(timer)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func bump_seed():
	base_noise.seed += 1
	base_noise.seed %= 10
	pass
	
