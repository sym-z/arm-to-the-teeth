extends Node2D

@export_category("Sprites")
@export var left : AnimatedSprite2D
@export var down : AnimatedSprite2D
@export var right : AnimatedSprite2D

var tongue_sprites : Array[AnimatedSprite2D] = []

@export_category("Locations")
@export var left_start : Marker2D
@export var down_start : Marker2D
@export var right_start : Marker2D
@export var flicker_position : Marker2D

signal start_cooldown
signal start_attack
# Called when the node enters the scene tree for the first time.
func _ready():
	tongue_sprites = [left,down, right]
	left.start_location = left_start
	down.start_location = down_start
	right.start_location = right_start
	for tongue in tongue_sprites:
		tongue.global_position = tongue.start_location.global_position
		tongue.flicker_location = flicker_position
		tongue.connect("attack_done", start_cooldown.emit)
		tongue.connect("creep_done", start_attack.emit)
		tongue.connect("block_done", start_cooldown.emit)
	pass # Replace with function body.


func get_random_tongue() -> AnimatedSprite2D:
	print("getter")
	tongue_sprites.shuffle()
	for tongue in tongue_sprites:
		if tongue.is_ready == true:
			return tongue
	return null
	#attacking_tongue = tongue_sprites[randi_range(0,tongue_sprites.size())]
	#return attacking_tongue

		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
