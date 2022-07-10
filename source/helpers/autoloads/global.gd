extends Node2D

var rng = RandomNumberGenerator.new()
var scroll_speed : float = 500.0


onready var view_size = get_viewport_rect().size
var sprite_size : Vector2 = Vector2(256, 106)


func _ready() -> void:
	rng.randomize()
