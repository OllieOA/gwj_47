class_name LaneGenerator extends YSort
"""
I would have called this a lane _manager_ ¬‿¬ - DAVE
"""


export var max_cols : int = 3

var _first_child_column
var _columns := []


onready var _lane_column : PackedScene = preload("res://source/scenes/game_objects/lane_generator/lane_column.tscn")
onready var _num_columns = ceil(Global.view_size.x / Global.sprite_size.x) + 1
onready var LEFT_CUTOFF := -ceil(Global.sprite_size.x * 1)  # x coord to queue free

func _ready() -> void:
	_initialize_columns()


func _physics_process(delta: float) -> void:
	# Check for the first column in the children
	if _columns[0].position.x < LEFT_CUTOFF:
		_columns[0].queue_free()
		_columns.pop_front()
		_create_new_column()
	
	for column in _columns:
		column.position.x -= Global.scroll_speed


func _initialize_columns() -> void:
	# Create the initial run of columns
	for i in range(_num_columns):
		_create_new_column(LaneChunk.Type.EMPTY)
		_columns[i].position.x = Global.sprite_size.x * i
	pass


func _create_new_column(type : int = 999) -> void:
	# Generate a new column
	var new_column = _lane_column.instance()
	new_column.position.x = Global.sprite_size.x * (_num_columns - 1)
	_columns.push_back(new_column)
	add_child(new_column)
#	new_column.generate_column(get_child(-1).read_column_connections()) # Not sure here?
	new_column.generate_column(type)
