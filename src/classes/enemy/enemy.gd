class_name Enemy extends Resource


var total_health : int = 5
var curr_health : int = 5

var damage : int = 1

var anim : SpriteFrames

#TODO: Possibly item drop?

func debug_print():
	print("ENEMY")
	print("TOTAL HEALTH: ", total_health)
	print("CURRENT HEALTH: ", curr_health)
	print("DAMAGE : ", damage)
	print("ANIMATION : ", anim)
