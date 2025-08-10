extends Node2D

@export var root_ui : Node
var player : Node
var map : Node

const MINI_MAP_TILE_SIZE = 8

var tiles : Dictionary[Vector2i, Sprite2D]
var icons : Dictionary[Vector2i, Sprite2D]

var mini_map_tiles : SpriteFrames = preload("uid://58ywf8owqlkj")
var player_sprite_frames : SpriteFrames = preload("uid://bilyg2c07firc")
var exit_icon : Texture2D = preload("uid://dk6w2sox6788m")
var spawn_icon : Texture2D = preload("uid://cxgyk5cp3ygtf")
var arm_icon : Texture2D = preload("uid://b660jj2kjsd3u")
var tooth_icon : Texture2D = preload("uid://bwjsth4iug6ls")
var enemy_icon : Texture2D = preload("uid://dk6w2sox6788m")
var player_sprite : Sprite2D

signal mini_map_ready
# Called when the node enters the scene tree for the first time.
func _ready():
	player = root_ui.player
	map = root_ui.map
	player.connect("change_facing", player_direction_refresh)
	player.connect("change_position", player_position_refresh)
	player.connect("item_picked_up", item_picked_up)
	map.connect("map_filled", create_visualization)
	map.connect("level_clear", clear_visualization)
	mini_map_ready.emit()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
## Converts bitwise representation of walls to a frame in the SpriteFrames object
func int_to_sprite(walls : int) -> Texture2D:
	return mini_map_tiles.get_frame_texture("default", walls)
	
func create_visualization():
	var world_map : Dictionary[Vector2i,Cell] = map.world_map
	for key in world_map.keys():
		var curr_texture : Texture2D = int_to_sprite(world_map[key].walls_to_int())
		var curr_sprite : Sprite2D = Sprite2D.new()
		curr_sprite.texture = curr_texture
		curr_sprite.position = Vector2(world_map[key].position.x*MINI_MAP_TILE_SIZE,world_map[key].position.y*MINI_MAP_TILE_SIZE)
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
				Cell.TYPE.ENEMY:
					icon_sprite.texture = enemy_icon
					icons[world_map[key].position] = icon_sprite
			curr_sprite.add_child(icon_sprite)
		# Hide this sprite until it is walked on!
		curr_sprite.visible = false
		tiles[key] = curr_sprite
		add_child(curr_sprite)
	place_player()

func set_icon(type: Cell.TYPE, loc: Vector2i):
	var icon_sprite = icons[loc]
	match type:
		Cell.TYPE.EXIT:
			icon_sprite.texture = exit_icon
		Cell.TYPE.SPAWN:
			icon_sprite.texture = spawn_icon
		Cell.TYPE.ARM:
			icon_sprite.texture = arm_icon
		Cell.TYPE.TOOTH:
			icon_sprite.texture = tooth_icon
		Cell.TYPE.ENEMY:
			icon_sprite.texture = enemy_icon

func clear_visualization():
	tiles.clear()
	icons.clear()
	for child in get_children():
		child.call_deferred("queue_free")
		

func place_player():
	player_sprite = Sprite2D.new()
	player_position_refresh()
	player_direction_refresh()
	add_child(player_sprite)


func item_picked_up():
	# Free the sprite from memory
	icons[player.position].call_deferred("queue_free")
	# Erase its reference in the icons Dictionary
	icons.erase(player.position)

func reveal_tile(loc : Vector2i):
	tiles[loc].visible = true
	if icons.has(loc):
		icons[loc].visible = true

func player_position_refresh():
	player_sprite.position = Vector2i(player.position.x*MINI_MAP_TILE_SIZE,player.position.y*MINI_MAP_TILE_SIZE)
	# Reveal part of map here
	reveal_tile(player.position)
	
func player_direction_refresh():
	match player.facing:
		Globals.NORTH:
			player_sprite.texture = player_sprite_frames.get_frame_texture("default", 0)
		Globals.SOUTH:
			player_sprite.texture = player_sprite_frames.get_frame_texture("default", 1)
		Globals.WEST:
			player_sprite.texture = player_sprite_frames.get_frame_texture("default", 2)
		Globals.EAST:
			player_sprite.texture = player_sprite_frames.get_frame_texture("default", 3)
	
