extends Node2D
var scroll_speed : float = 300.0


onready var view_size = get_viewport_rect().size
var sprite_size : Vector2 = Vector2(256, 80)


func _ready() -> void:
	randomize()
