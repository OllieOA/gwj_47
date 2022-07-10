class_name AllyBoat extends Boat
# This class is simpler, and generally reponds to the character only.
# All logic about whether it can move up or down is handled in CharacterBoat

func _ready() -> void:
	Event.connect("character_boat_move_accepted", self, "_handle_character_boat_move_accepted")
	_target_lane = 4


# SIGNAL CALLBACKS
func _handle_character_boat_move_accepted(normal_direction: int) -> void:
	# TODO: clamp this 
	#-> DOESN'T NEED CLAMPING SINCE ONLY CALLED WHEN CHARACTER MOVE IS ACCEPTED.
	# CLAMPING SHOULD OCCUR THERE - DAVE
	_target_lane -= normal_direction  # -= as it is opposite
	_set_target_position(_lane_to_position[_target_lane])
	_state = State.MOVING
