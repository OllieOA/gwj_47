class_name CharacterBoat extends Boat

# Export vars
export (NodePath) onready var stun_timer = get_node(stun_timer) as Timer

const MAX_LANE = 6
const MIN_LANE = 4

func _ready() -> void:
	_target_lane = 4
	_current_lane = 4
	stun_timer.connect("timeout", self, "_handle_stun_timeout")
	position = Vector2(_x_pos, _lane_to_y_position[_current_lane])
	_target_position = position

	_max_lane = 6
	_min_lane = 4

func _process(delta: float) -> void:
	# Explicitly handle input so that you can hold the button down to move
	_handle_input()
	
	if _state == State.STUNNED and stun_timer.is_stopped():
		stun_timer.start()


# SIGNAL CALLBACKS
func _handle_stun_timeout() -> void:
	_state = State.COASTING


func _handle_input() -> void:
	var _moveable = _current_lane == _target_lane and _state == State.COASTING
	if Input.is_action_pressed("move_up") and _moveable:
		_attempt_move_boat(1, true)
	
	if Input.is_action_pressed("move_down") and _moveable:
		_attempt_move_boat(-1, true)


# CUSTOM METHODS

