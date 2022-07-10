class_name Boat extends KinematicBody2D

export (float, 0, 1024) onready var _x_pos : float = 250

# These are blockers for the state machine transision
# TODO: Implement this logic somehow
var _can_move_up := true
var _can_move_down := true

# Target lane index (will be clamped)
var _target_lane: int
var _current_lane: int
var _target_position := Vector2.ZERO

# Logic for "close enough"
const CLOSE_ENOUGH_PIXELS = 20
var _target_reached := false
var _position_close_enough_x := false
var _position_close_enough_y := false

var _num_lanes := 0

var _max_lane := 0
var _min_lane := 0

enum State {
	COASTING,
	MOVING,
	FORCING,
	STUNNED,  # Forced -> Stunned -> Coasting
}

var _state = State.COASTING

var hits = 0  # Placeholder for game win/loss

# ONREADY
const Y_OFFSET = 5
onready var _lane_to_y_position := {
	1: Y_OFFSET + Global.sprite_size.y*6,
	2: Y_OFFSET + Global.sprite_size.y*5,
	3: Y_OFFSET + Global.sprite_size.y*4,
	4: Y_OFFSET + Global.sprite_size.y*3,
	5: Y_OFFSET + Global.sprite_size.y*2,
	6: Y_OFFSET + Global.sprite_size.y,
}

# ENGINE CALLBACKS

func _ready() -> void:
	# Initialise position
	_num_lanes = _lane_to_y_position.size()


func _process(delta: float) -> void:	
	# Set a target (if none set)
	if _current_lane != _target_lane:
		_set_target_y_position(_lane_to_y_position[_target_lane])

	# Check if we are close to the target
	_position_close_enough_x = abs(position.x - _target_position.x) < CLOSE_ENOUGH_PIXELS
	_position_close_enough_y = abs(position.y - _target_position.y) < CLOSE_ENOUGH_PIXELS
	_target_reached = _position_close_enough_x and _position_close_enough_y
	
	# Moved this to common spot to always move towards target
	position = lerp(position, _target_position, 0.1)

	match _state:
		State.COASTING:
			if _current_lane != _target_lane:
				# If we have a valid target set, set state to moving
				_state = State.MOVING
		
		State.MOVING:
			if _target_reached:
				# Target reached!
				_current_lane = _target_lane
				_state = State.COASTING

		State.FORCING:
			# This state is executed through a signal, which wipes the queue
			# and sets the target. Enters into STUNNED state on exit
			
			if _target_reached:
				# Target reached!
				_current_lane = _target_lane
				_state = State.STUNNED

		State.STUNNED:
			pass  # Locked in this state for a beat - handled by _handle_stun_timeout()


# CUSTOM METHODS
func _check_if_move_valid(normal_direction: int) -> bool:
	if not _target_lane + normal_direction <= _max_lane:
		return false
	if not _target_lane + normal_direction >= _min_lane:
		return false
	
	# TODO: Check if lane is blocked

	return true


func _attempt_move_boat(normal_direction: int, _move_reflection: bool = true) -> void:
	var _move_valid = _check_if_move_valid(normal_direction)
	if _move_valid:
		_target_lane = _target_lane + normal_direction

		if _move_reflection:
			Event.emit_signal("character_boat_move_accepted", normal_direction)

	# Broadcast if successful. Needed for reflection logic and also for UI probably
	Event.emit_signal("move_attempted", self, normal_direction, _move_valid)  



func _set_target_y_position(target_y_pos: int) -> void:
	_target_position = Vector2(_x_pos, target_y_pos)


func force_move(normal_direction: int) -> void:
	_attempt_move_boat(normal_direction, false)
	_target_lane += normal_direction
	_set_target_y_position(_lane_to_y_position[_target_lane])
	_state = State.MOVING


func handle_damage() -> void:
	hits += 1
	print("HITS NOW AT ", hits)
	_state = State.STUNNED
