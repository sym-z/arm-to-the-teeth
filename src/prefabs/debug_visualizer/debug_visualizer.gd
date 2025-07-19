extends Node2D


@export var map_node : Node

var world_map : Dictionary[Vector2i,Cell]

var vis_sprite_frames : SpriteFrames = preload("uid://cbjh88qmpok43")
const FRAME_SIZE = 8
## Converts bitwise representation of walls to a frame in the SpriteFrames object
func int_to_sprite(walls : int) -> Texture2D:
	return vis_sprite_frames.get_frame_texture("default", walls)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func create_visualization():
	world_map = map_node.world_map
	for key in world_map.keys():
		var curr_texture : Texture2D = int_to_sprite(world_map[key].walls_to_int())
		var curr_sprite : Sprite2D = Sprite2D.new()
		curr_sprite.texture = curr_texture
		curr_sprite.position = Vector2(world_map[key].position.x*FRAME_SIZE,world_map[key].position.y*FRAME_SIZE)
		add_child(curr_sprite)
