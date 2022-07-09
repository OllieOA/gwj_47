class_name LaneChunk extends Node2D
"""This is the fundamental component of a lane, and will have different
actions on the boats, i.e. moving up or down
"""

export (NodePath) onready var sprite = get_node(sprite) as Sprite

enum Type {
	EMPTY,
	PASSTHROUGH,
	UP,
	DOWN,
}

var TextureLookup := {
	Type.EMPTY: load("res://source/scenes/game_objects/lane_generator/prototype_chunk_empty.png"),
	Type.PASSTHROUGH: load("res://source/scenes/game_objects/lane_generator/prototype_chunk_pass.png"),
	Type.UP: load("res://source/scenes/game_objects/lane_generator/prototype_chunk_up.png"),
	Type.DOWN: load("res://source/scenes/game_objects/lane_generator/prototype_chunk_down.png"),
}

var RearConnectable = {
	Type.EMPTY: true,
	Type.PASSTHROUGH: true,
	Type.UP: false,
	Type.DOWN: false,
} # This will determine if another piece can follow

var ForceDirection = {
	Type.EMPTY: 0,
	Type.PASSTHROUGH: 0,
	Type.UP: 1,
	Type.DOWN: -1,
} # This will determine if another piece can follow

var _lane_type: int= Type.EMPTY
var connectable := false
var _effect_direction := 0

# ENGINE CALLBACKS
func _ready() -> void:
	# Randomly choose type, assign sprite texture, set influence direction
	# TODO: not uniform random
	pass



func _on_effect_area_body_entered(body:Node) -> void:
	if body.has_method("force_move") and _effect_direction != 0:
		body.force_move(_effect_direction)
