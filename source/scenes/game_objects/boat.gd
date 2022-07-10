class_name Boat extends KinematicBody2D

export (float, 0, 1024) onready var _x_pos : float

# These are blockers for the state machine transision
# TODO: Implement this logic somehow
var _can_move_up := true
var _can_move_down := true

# Target lane index (will be clamped)
var _target_lane
var _current_lane := 3
var _target_position := Vector2.ZERO setget _set_target_position

# Logic for "close enough"
const CLOSE_ENOUGH_PIXELS = 1
var _target_reached := false
var _position_close_enough_x := false
var _position_close_enough_y := false

var _num_lanes := 0

enum State {
	COASTING,
	MOVING,
	FORCING,
	STUNNED,  # Forced -> Stunned -> Coasting
}

var _state = State.COASTING

# ONREADY
onready var _lane_to_position := {  # TODO: Parameterise these to the resolution?
	1: Vector2(_x_pos, 53 + Global.sprite_size.y*5),
	2: Vector2(_x_pos, 53 + Global.sprite_size.y*4),
	3: Vector2(_x_pos, 53 + Global.sprite_size.y*3),
	4: Vector2(_x_pos, 53 + Global.sprite_size.y*2),
	5: Vector2(_x_pos, 53 + Global.sprite_size.y),
	6: Vector2(_x_pos, 53),
}

# ENGINE CALLBACKS

func _ready() -> void:
	# Initialise position
	_num_lanes = _lane_to_position.size() # better to use the dictionary-specific method
	position = _lane_to_position[_current_lane]



func _process(delta: float) -> void:	
	# Set a target (if none set)
	if _current_lane != _target_lane:
		_set_target_position(_lane_to_position[_target_lane])

	# Check if we are close to the target
	_position_close_enough_x = abs(position.x - _target_position.x) < CLOSE_ENOUGH_PIXELS
	_position_close_enough_y = abs(position.y - _target_position.y) < CLOSE_ENOUGH_PIXELS
	_target_reached = _position_close_enough_x and _position_close_enough_y

	match _state:
		State.COASTING:
			if _current_lane != _target_lane:
				# If we have a valid target set, set state to moving
				_state = State.MOVING
		
		State.MOVING:
			if not _target_reached:
				position = lerp(position, _target_position, 0.1)
			else:
				# Target reached!
				_current_lane = _target_lane
				_state = State.COASTING

		State.FORCING:
			# This state is executed through a signal, which wipes the queue
			# and sets the target. Enters into STUNNED state on exit
			if not _target_reached:
				position = lerp(position, _target_position, 0.1)
			else:
				# Target reached!
				_current_lane = _target_lane
				_state = State.STUNNED

		State.STUNNED:
			pass  # Locked in this state for a beat - handled by _handle_stun_timeout()


# CUSTOM METHODS
func _set_target_position(target_pos: Vector2) -> void:
	_target_position = target_pos


func _force_move(normal_direction: int) -> void:
	_target_lane += normal_direction
	_set_target_position(_lane_to_position[_target_lane])
	_state = State.MOVING
