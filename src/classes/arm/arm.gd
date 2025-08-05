class_name Arm extends Resource



# How much damage does this arm deal?
var strength : int
# How much health does this arm have?
var condition : int
# Is the player using this arm or not?
var equipped : bool
# What is the maximum condition that this arm can be in?
var max_condition : int


func debug_print():
	print("STR: ", strength)
	print("COND: ", condition)
	print("EQ?: ", equipped)
