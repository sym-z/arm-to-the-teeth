extends CanvasLayer

@export var player : Node 
@export var map : Node

@export_category("Context Menu Buttons")
@export var pickup_button : Button

var item_to_pick : Cell.TYPE = Cell.TYPE.EMPTY
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Because this is a global script, work should start only when the map is done filling.
func _on_map_map_filled():
	pickup_button.disabled = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_player_item_detected(item, loc):
	match item:
		Cell.TYPE.EMPTY:
			pickup_button.disabled = true
			item_to_pick = Cell.TYPE.EMPTY
		Cell.TYPE.SPAWN:
			pickup_button.disabled = true
			item_to_pick = Cell.TYPE.SPAWN
		Cell.TYPE.EXIT:
			pickup_button.disabled = true
			item_to_pick = Cell.TYPE.EXIT
		Cell.TYPE.ARM:
			pickup_button.disabled = false
			item_to_pick = Cell.TYPE.ARM
		Cell.TYPE.TOOTH:
			pickup_button.disabled = false
			item_to_pick = Cell.TYPE.TOOTH
		Cell.TYPE.ENEMY:
			pickup_button.disabled = true
			item_to_pick = Cell.TYPE.ENEMY
			
func _on_player_item_picked_up():
	pickup_button.disabled = true
	item_to_pick = Cell.TYPE.EMPTY
	
#region Context Menu Button Presses
func _on_pick_up_pressed():
	player.pick_up(item_to_pick)
#endregion
