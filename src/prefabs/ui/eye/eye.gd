extends AnimatedSprite2D

@export var root_ui : CanvasLayer
@export var mouse_field : ColorRect
@export var mini_map : Node2D
# Sets up the loopers to transitions
var mouse_hovering : bool = false

@export var shadow : AnimatedSprite2D
@export var shadow_highlight_color : Color
@export var default_shadow_color : Color

# Called when the node enters the scene tree for the first time.
func _ready():
	root_ui.player.connect("move_key_pressed", hide_map)
	connect("animation_finished", check_animation)
	connect("animation_looped", check_loops)
	mouse_field.connect("gui_input", _on_field_clicked)
	shadow.modulate = default_shadow_color
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_field_entered():
	mouse_hovering = true
	shadow.modulate = shadow_highlight_color
	if animation == "default":
		animation = "open"
		play()
	pass # Replace with function body.


func _on_field_exited():
	mouse_hovering = false
	shadow.modulate = default_shadow_color
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

func hide_map():
	mini_map.visible = false
