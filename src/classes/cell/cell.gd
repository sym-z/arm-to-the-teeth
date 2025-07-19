class_name Cell extends Node

var position : Vector2i

## Wall Configuration
# TODO: Convert these into single bitwise integer
var n_wall : bool = true
var s_wall : bool = true
var e_wall : bool = true
var w_wall : bool = true

## Maze Status
var in_maze : bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
