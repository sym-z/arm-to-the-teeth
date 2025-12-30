extends Node2D

@export var top : AnimatedSprite2D
@export var right : AnimatedSprite2D
@export var bottom : AnimatedSprite2D
@export var left : AnimatedSprite2D

enum STATE {MISS, WHIFF, HIT}

func set_top(new : STATE):
	top.frame = new

func set_right(new : STATE):
	right.frame = new
	
func set_bottom(new : STATE):
	bottom.frame = new

func set_left(new : STATE):
	left.frame = new
	
func reset_tongue_awareness():
	right.frame = STATE.MISS
	bottom.frame = STATE.MISS
	left.frame = STATE.MISS
