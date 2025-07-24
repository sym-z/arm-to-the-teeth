extends Node2D

@export var player : Node
@export var map_node : Node

# Alias for the map's world map
var world_map : Dictionary[Vector2i,Cell]
var icons : Dictionary[Vector2i, Sprite2D]
var vis_sprite_frames : SpriteFrames = preload("uid://cbjh88qmpok43")
var player_db_sprite_frames : SpriteFrames = preload("uid://b7xoyoeypo5ys")
var exit_icon : Texture2D = preload("uid://dya7m2106hkvd")
var spawn_icon : Texture2D = preload("uid://c1luniab6md7i")
var arm_icon : Texture2D = preload("uid://ya10rgihl35a")
var tooth_icon : Texture2D = preload("uid://m1kguw4tngc6")
var player_db_sprite : Sprite2D
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

func _on_map_map_filled():
	create_visualization()

func create_visualization():
	world_map = map_node.world_map
	for key in world_map.keys():
		var curr_texture : Texture2D = int_to_sprite(world_map[key].walls_to_int())
		var curr_sprite : Sprite2D = Sprite2D.new()
		curr_sprite.texture = curr_texture
		curr_sprite.position = Vector2(world_map[key].position.x*FRAME_SIZE,world_map[key].position.y*FRAME_SIZE)
		if world_map[key].contents != Cell.TYPE.EMPTY:
			# Overlay proper mini icon on map
			var icon_sprite : Sprite2D = Sprite2D.new()
			match world_map[key].contents:
				Cell.TYPE.EXIT:
					icon_sprite.texture = exit_icon
					# Assign this sprite to be owned at the position of the cell it is meant to represent
					icons[world_map[key].position] = icon_sprite
				Cell.TYPE.SPAWN:
					icon_sprite.texture = spawn_icon
					icons[world_map[key].position] = icon_sprite
				Cell.TYPE.ARM:
					icon_sprite.texture = arm_icon
					icons[world_map[key].position] = icon_sprite
				Cell.TYPE.TOOTH:
					icon_sprite.texture = tooth_icon
					icons[world_map[key].position] = icon_sprite
			#icon_sprite.position = curr_sprite.position
			curr_sprite.add_child(icon_sprite)
		add_child(curr_sprite)
	place_player()

func place_player():
	player_db_sprite = Sprite2D.new()
	player_position_refresh()
	player_direction_refresh()
	add_child(player_db_sprite)


func _on_player_item_picked_up():
	icons[player.position].visible = false
	pass # Replace with function body.

func _on_player_change_facing():
	player_direction_refresh()

func _on_player_change_position():
	player_position_refresh()
	
func player_position_refresh():
	player_db_sprite.position = Vector2i(player.position.x*FRAME_SIZE,player.position.y*FRAME_SIZE)
	
func player_direction_refresh():
	match player.facing:
		Globals.NORTH:
			player_db_sprite.texture = player_db_sprite_frames.get_frame_texture("default", 0)
		Globals.SOUTH:
			player_db_sprite.texture = player_db_sprite_frames.get_frame_texture("default", 1)
		Globals.WEST:
			player_db_sprite.texture = player_db_sprite_frames.get_frame_texture("default", 2)
		Globals.EAST:
			player_db_sprite.texture = player_db_sprite_frames.get_frame_texture("default", 3)
	
