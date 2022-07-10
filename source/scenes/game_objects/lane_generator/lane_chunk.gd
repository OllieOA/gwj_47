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

var _lane_type: int = Type.EMPTY
var connectable := false
var _effect_direction := 0

# ENGINE CALLBACKS
# OH MY GOD THANK YOU - I DID NOT KNOW YOU COULD PASS VARIABLES TO _READY!!!
func _ready(type : int = 999) -> void:
	# Randomly choose type, assign sprite texture, set influence direction
	# TODO: not uniform random
	match type:
		999:
			# Random type generation
			_choose_random()
		_:
			# Specific type generation
			pass


func _on_effect_area_body_entered(body:Node) -> void:
	if body.has_method("force_move") and _effect_direction != 0:
		body.force_move(_effect_direction)


func _choose_random() -> void:
	# TODO: REMOVE THIS TEMPORARY RANDOM AND REPLACE WITH WAVE FUNCTION COLLAPSE
	# NEEDS PROPER LOGIC BETWEEN EMPTY AND UP/DOWN
	var _type_choice = randf()

	if _type_choice < 0.9:
		_lane_type = Type.PASSTHROUGH
	elif _type_choice >= 0.9 and _type_choice < 0.96:
		_lane_type = Type.EMPTY
	else:
		_lane_type = rand_range(2, 4)  # Random of up/down

	
	sprite.texture = TextureLookup[_lane_type]
	connectable = RearConnectable[_lane_type]
	_effect_direction = ForceDirection[_lane_type]
	
