class_name LaneGenerator extends YSort

const LEFT_CUTOFF := -100  # x coord to queue free

var _first_child_column

var lane_column : PackedScene = preload("res://source/scenes/game_objects/lane_generator/lane_column.tscn")

func _ready() -> void:
	_initialize_columns()
	_first_child_column = get_child(0)


func _process(delta: float) -> void:
	# Check for the first column in the children

	if _first_child_column.position.x < LEFT_CUTOFF:
		_first_child_column.queue_free()
		call_deferred("_get_first_child")

	_create_new_column()


func _initialize_columns() -> void:
	# Create the initial run of columns
	pass


func _create_new_column() -> void:
	# Generate a new column
	var new_column = lane_column.instance()
	add_child(new_column)
#	new_column.generate_column(get_child(-1).read_column_connections())


func _get_first_child() -> void:
	_first_child_column = get_child(0)
