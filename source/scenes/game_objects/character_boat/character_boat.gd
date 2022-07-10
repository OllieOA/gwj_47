class_name CharacterBoat extends Boat

# Export vars
export (NodePath) onready var stun_timer = get_node(stun_timer) as Timer


func _ready() -> void:
	_target_lane = 3
	stun_timer.connect("timeout", self, "_handle_stun_timeout")

func _process(delta: float) -> void:
	# Explicitly handle input so that you can hold the button down to move
	_handle_input()
	
	if _state == State.STUNNED:
		stun_timer.start()


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


func _handle_input() -> void:
	var _moveable = _current_lane == _target_lane and _state == State.COASTING
	if Input.is_action_pressed("move_up") and _moveable:
		_move_boat(1)
	
	if Input.is_action_pressed("move_down") and _moveable:
		_move_boat(-1)
