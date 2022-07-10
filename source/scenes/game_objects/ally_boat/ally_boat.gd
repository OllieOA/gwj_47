class_name AllyBoat extends KinematicBody2D
# This class is simpler, and generally reponds to the character only.
# All logic about whether it can move up or down is handled in CharacterBoat

# Target lane index
var _target_lane := 4
var _target_position := Vector2.ZERO setget _set_target_position

# Logic for "close enough"
const CLOSE_ENOUGH_PIXELS = 20
var _target_reached := false
var _position_close_enough_x := false
var _position_close_enough_y := false

# TODO: Refactor this to only affect y values
# MAYBE WE CAN REFACTOR INTO A "BOAT" CLASS, SO WE DON'T NEED TO COPY STATES, POSITIONS, ETC MULTIPLE
# TIMES? - DAVE
var _lane_to_position := {
	1: Vector2(600, Global.sprite_size.y*5),
	2: Vector2(600, Global.sprite_size.y*4),
	3: Vector2(600, Global.sprite_size.y*3),
	4: Vector2(600, Global.sprite_size.y*2),
	5: Vector2(600, Global.sprite_size.y),
	6: Vector2(600, 0),
}
var _num_lanes := 0

enum State{
	WAITING,
	FORCING,
	MOVING,
}

var _state = State.WAITING

func _ready() -> void:
	Event.connect("character_boat_move_accepted", self, "_handle_character_boat_move_accepted")
	position = _lane_to_position[_target_lane]


func _process(delta: float) -> void:
	_position_close_enough_x = abs(position.x - _target_position.x) < CLOSE_ENOUGH_PIXELS
	_position_close_enough_y = abs(position.y - _target_position.y) < CLOSE_ENOUGH_PIXELS
	_target_reached = _position_close_enough_x and _position_close_enough_y

	match _state:
		State.WAITING:
		# Wait for input
			pass
		
		State.MOVING:
			if not _target_reached:
				position = lerp(position, _target_position, 0.1)
				# TWEENS ARE LIFE - DAVE
			else:
				# Target reached!
				_state = State.WAITING

# SIGNAL CALLBACKS
func _handle_character_boat_move_accepted(normal_direction: int) -> void:
	# TODO: clamp this 
	#-> DOESN'T NEED CLAMPING SINCE ONLY CALLED WHEN CHARACTER MOVE IS ACCEPTED.
	# CLAMPING SHOULD OCCUR THERE - DAVE
	_target_lane -= normal_direction  # -= as it is opposite
	_set_target_position(_lane_to_position[_target_lane])
	_state = State.MOVING


# CUSTOM METHODS
func _set_target_position(target_pos: Vector2) -> void:
	_target_position = target_pos


func _force_move(normal_direction: int) -> void:
	_target_lane += normal_direction
	_set_target_position(_lane_to_position[_target_lane])
	_state = State.MOVING
