class_name Arm extends Resource



# How much damage does this arm deal?
var strength : int
# How much health does this arm have?
var condition : int
# Is the player using this arm or not?
var equipped : bool

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func debug_print():
	print("STR: ", strength)
	print("COND: ", condition)
	print("EQ?: ", equipped)
