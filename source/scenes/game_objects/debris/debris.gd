class_name Debris extends KinematicBody2D

export (NodePath) onready var sprite = get_node(sprite) as Sprite

func _ready(reflected: bool = false) -> void:
	sprite.flip_v = reflected
		

func _on_hit_detector_body_entered(body:Node) -> void:
	if body.has_method("handle_damage"):
		if body._state == Boat.State.COASTING:
			body.handle_damage()
		
