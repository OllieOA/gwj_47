class_name CharacterBoat extends KinematicBody2D

# Export vars
export (NodePath) onready var stun_timer = get_node(stun_timer) as Timer

# These are blockers for the state machine transision
# TODO: Implement this logic somehow
var _can_move_up := true
var _can_move_down := true

# Target lane index (will be clamped)
var _target_lane := 3
var _current_lane := 3
var _target_position := Vector2.ZERO setget _set_target_position

# Logic for "close enough"
const CLOSE_ENOUGH_PIXELS = 20
var _target_reached := false
var _position_close_enough_x := false
var _position_close_enough_y := false

# TODO: Refactor this to only affect y values
var _lane_to_position := {  # TODO: Parameterise these to the resolution?
	1: Vector2(90, Global.sprite_size.y*5),
	2: Vector2(90, Global.sprite_size.y*4),
	3: Vector2(90, Global.sprite_size.y*3),
	4: Vector2(90, Global.sprite_size.y*2),
	5: Vector2(90, Global.sprite_size.y),
	6: Vector2(90, 0),
}
var _num_lanes := 0

enum State {
	COASTING,
	MOVING,
	FORCING,
	STUNNED,  # Forced -> Stunned -> Coasting
}

var _state = State.COASTING

# ENGINE CALLBACKS

func _ready() -> void:
	# Initialise position
	_num_lanes = _lane_to_position.size() # better to use the dictionary-specific method
	position = _lane_to_position[_current_lane]

	stun_timer.connect("timeout", self, "_handle_stun_timeout")


func _process(delta: float) -> void:
	# Explicitly handle input so that you can hold the button down to move
	_handle_input()
	
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
				stun_timer.start()

		State.STUNNED:
			pass  # Locked in this state for a beat - handled by _handle_stun_timeout()


func _move_boat(normal_direction: int) -> void:
	# Instead of clamping, I think we should do check operations, so that the "move accepted" signal
	# is only called if the move is valid
	
	if _target_lane + normal_direction >= 1 and _target_lane + normal_direction <= _num_lanes:
		_target_lane = clamp(_target_lane + normal_direction, 1, _num_lanes) # Clamp anyway because ¯\_(ツ)_/¯
		Event.emit_signal("character_boat_move_accepted", normal_direction)
		print("SET _TARGET_LANE TO ", _target_lane)


# SIGNAL CALLBACKS
func _handle_stun_timeout() -> void:
	_state = State.COASTING


# CUSTOM METHODS
func _set_target_position(target_pos: Vector2) -> void:
	_target_position = target_pos


func _force_move(normal_direction: int) -> void:
	_target_lane += normal_direction
	_set_target_position(_lane_to_position[_target_lane])
	_state = State.MOVING

func _handle_input() -> void:
	var _moveable = _current_lane == _target_lane and _state == State.COASTING
	if Input.is_action_pressed("move_up") and _moveable:
		_move_boat(1)
	
	if Input.is_action_pressed("move_down") and _moveable:
		_move_boat(-1)
