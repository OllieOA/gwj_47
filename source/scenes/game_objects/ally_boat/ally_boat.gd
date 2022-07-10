class_name AllyBoat extends Boat
# This class is simpler, and generally reponds to the character only.
# All logic about whether it can move up or down is handled in CharacterBoat

func _ready() -> void:
	Event.connect("character_boat_move_accepted", self, "_handle_character_boat_move_accepted")
	Event.connect("move_attempted", self, "_handle_move_attempted")
	_current_lane = 3
	_target_lane = 3
	position = Vector2(_x_pos, _lane_to_y_position[_current_lane])
	_target_position = position

	_max_lane = 3
	_min_lane = 1


# SIGNAL CALLBACKS
func _handle_character_boat_move_accepted(normal_direction: int) -> void:
	_target_lane -= normal_direction  # -= as it is opposite
	_set_target_y_position(_lane_to_y_position[_target_lane])
	_state = State.MOVING

	# TODO: Handle wrapping


func _handle_move_attempted(boat: Boat, normal_direction: int, attempt_successful: bool) -> void:
	# Signal to handle wrapping around, unique to reflection
	# TODO: This will require some VFX to mask the move
	var _attempted_lane = _current_lane + normal_direction
	if _attempted_lane == _max_lane + 1 and not attempt_successful:
		# Wrap down
		_target_lane = _min_lane
	elif _attempted_lane == _min_lane - 1 and not attempt_successful:
		# Wrap up
		_target_lane = _max_lane
