extends AnimatedSprite2D

@export var mouse_field : ColorRect
@export var mini_map : Node2D
# Sets up the loopers to transitions
var mouse_hovering : bool = false
# Called when the node enters the scene tree for the first time.
func _ready():
	connect("animation_finished", check_animation)
	connect("animation_looped", check_loops)
	mouse_field.connect("gui_input", _on_field_clicked)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_field_entered():
	mouse_hovering = true
	if animation == "default":
		animation = "open"
		play()
	pass # Replace with function body.


func _on_field_exited():
	mouse_hovering = false
	if animation == "hover":
		animation = "close"
		play()
	pass # Replace with function body.

func check_animation():
	if animation == "close":
		animation = "default"
		play()
	if animation == "open":
		animation = "hover"
		play()
	pass

func check_loops():
	if animation == "hover":
		if mouse_hovering == false:
			animation = "close"
			play()
	elif animation == "default":
		if mouse_hovering == true:
			animation = "open"
			play()
	pass

func _on_field_clicked(event):
	if event is InputEventMouseButton and event.button_index == 1 and event.pressed == true:
		mini_map.visible = !mini_map.visible
	pass
