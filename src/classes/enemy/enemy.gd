class_name Enemy extends Resource


var total_health : int = 5
var curr_health : int = 5

var damage : int = 1

var anim : SpriteFrames

## Minimum roll to hit
var difficulty_class : int = 5

## Enemy will hit about every 1 in hit_chance attempts.
var hit_chance : float = 4.0

func debug_print():
	print("ENEMY")
	print("TOTAL HEALTH: ", total_health)
	print("CURRENT HEALTH: ", curr_health)
	print("DAMAGE : ", damage)
	print("ANIMATION : ", anim)
